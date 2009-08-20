From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: RE: Performance issues with Areca 1680 SAS Controllers
Date: Thu, 20 Aug 2009 20:18:44 +0800
Message-ID: <SERVER-ARECA8s4KWiG00002668@areca.com.tw>
References: <20090820121602.GU19938@edu.joroinen.fi>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from areca.com.tw ([220.130.178.142]:46553 "EHLO areca.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZHTMSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 08:18:46 -0400
In-Reply-To: <20090820121602.GU19938@edu.joroinen.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?'Pasi_K=E4rkk=E4inen'?= <pasik@iki.fi>
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, 'Michael Fuckner' <michael@fuckner.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

It could improve the performance with F/W v1.47.

-----Original Message-----
=46rom: Pasi K=E4rkk=E4inen [mailto:pasik@iki.fi]=20
Sent: Thursday, August 20, 2009 8:16 PM
To: Nick Cheng
Cc: 'Andrew Morton'; 'Michael Fuckner'; linux-kernel@vger.kernel.org;
linux-scsi@vger.kernel.org
Subject: Re: Performance issues with Areca 1680 SAS Controllers

On Thu, Aug 20, 2009 at 12:56:04PM +0300, Pasi K=E4rkk=E4inen wrote:
> On Thu, Aug 20, 2009 at 09:54:27AM +0800, Nick Cheng wrote:
> > Hi Gentlemen,
> > We have worked it out with new firmware and driver.
> > You can download the latest F/W from
> > ftp://ftp.areca.com.tw/RaidCards/BIOS_Firmware/ARC1680/ and use the
attached
> > driver.
> > Please have a try.
> > Any comments are welcome.
>=20
> Thanks! I'll give it a try today and report back.
>=20

v1.47 firmware seems to fix this problem! The system behaves _much_ bet=
ter
now even when Areca is busy flushing it's cache!=20

I didn't update the driver, only Areca firmware.

Is there something imported fixed in the latest driver? I'm using the
default driver included in RHEL/CentOS 5.3.

# modinfo arcmsr.ko
filename:       arcmsr.ko
version:        Driver Version 1.20.00.15.RH1 2008/02/27

-- Pasi

>=20
> > Thank you,
> > -----Original Message-----
> > From: Pasi K=E4rkk=E4inen [mailto:pasik@iki.fi]=20
> > Sent: Wednesday, August 19, 2009 10:09 PM
> > To: Nick Cheng
> > Cc: 'Andrew Morton'; 'Michael Fuckner'; linux-kernel@vger.kernel.or=
g;
> > linux-scsi@vger.kernel.org; 'Erich Chen'
> > Subject: Re: Performance issues with Areca 1680 SAS Controllers
> >=20
> > On Thu, Nov 20, 2008 at 03:39:40PM +0800, Nick Cheng wrote:
> > > Hi Michael,
> > > I will get around handling your issue.
> > > Thanks for your kindly patience,
> > >=20
> >=20
> > Hello,
> >=20
> > Was this issue resolved? I'm seeing similar behaviour.. I think it'=
s
related
> > to flushing the controller cache?
> >=20
> > Waiting a while (after the disk leds stop blinking) performance is =
back
to
> > normal..=20
> >=20
> > -- Pasi
> >=20
> > > -----Original Message-----
> > > From: Andrew Morton [mailto:akpm@linux-foundation.org]=20
> > > Sent: Thursday, November 20, 2008 9:18 AM
> > > To: Michael Fuckner
> > > Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Nic=
k
Cheng;
> > > Erich Chen
> > > Subject: Re: Performance issues with Areca 1680 SAS Controllers
> > >=20
> > > (cc's added)
> > >=20
> > > On Wed, 19 Nov 2008 13:16:56 +0100
> > > Michael Fuckner <michael@fuckner.net> wrote:
> > >=20
> > > > Hi,
> > > >=20
> > > > I am using an Areca 1680-SAS-Controller with 16 SAS-HDD (Seagat=
e 1TB
> > > > ST31000640SS). I set up a Raid6 with all 16 disks and formatted=
 it
with
> > > > XFS. The Controller has 512MB RAM and a BBU. The OS is installe=
d to
> > > > another disk attached to the onboard AHCI controller.
> > > >=20
> > > > After doing some IO, the areca raidset is slower compared to th=
e
rate=20
> > > > directly
> > > > after boot.
> > > >=20
> > > >=20
> > > > [root@storage ~]# dd if=3D/dev/sdb1 of=3D/dev/null bs=3D1M coun=
t=3D50k
> > > iflag=3Ddirect
> > > > 51200+0 records in
> > > > 51200+0 records out
> > > > 53687091200 bytes (54 GB) copied, 59.6494 seconds, 900 MB/s
> > > > [root@storage ~]# mount /dev/sdb1 /data
> > > > [root@storage ~]# cd /data/
> > > > [root@storage data]# ./iozone -i 0 -i 1 -s 32g -r 16m -S 6144 -=
t 8
-+r
> > > > -o  >raid6_sync_t8.log
> > > > [root@storage data]# cd
> > > > [root@storage ~]# umount /data/
> > > > [root@storage ~]# dd if=3D/dev/sdb1 of=3D/dev/null bs=3D1M coun=
t=3D50k
> > > iflag=3Ddirect
> > > > 51200+0 records in
> > > > 51200+0 records out
> > > > 53687091200 bytes (54 GB) copied, 76.4036 seconds, 703 MB/s
> > > >=20
> > > > I tested different Versions of Linux (Centos 5.2, OpenSUSE 11,
Debian
> > > > Lenny) and Vanilla kernels 2.6.22-2.6.27, all show this behavio=
ur.
> > > >=20
> > > > Idea why the device slows down after IO- or better: how to keep=
 the
high
> > > > rate? Is this reproducible foer Areca SATA Controllers (Type 11=
XX
and
> > > 12XX)
> > > >=20
> > > > Regards,
> > > >    Michael!
> > >=20
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> > > Please read the FAQ at  http://www.tux.org/lkml/
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
