From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: MPTSAS: ("activate status led" | "find disc") in external
 enclosure
Date: Mon, 21 Apr 2008 11:01:48 +0200
Message-ID: <20080421110148.1918485e.taeuber@bbaw.de>
References: <20080418124104.9ca87130.taeuber@bbaw.de>
	<1208528945.3063.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:48677 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbYDUJAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Apr 2008 05:00:42 -0400
In-Reply-To: <1208528945.3063.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Hi James,

James Bottomley <James.Bottomley@HansenPartnership.com> schrieb:
> On Fri, 2008-04-18 at 12:41 +0200, Lars T=C3=A4uber wrote:
> > Is there a standard way to lit the led in the enclosure with linux =
means or anything alike?
> > The enclosure does not tell the serial numbers of the included disc=
=2E
> > The HBA is an LSI SAS 3801X.
>=20
> It depends on whether you have the HBA configured in RAID mode or not=
=2E
> If you have, then it takes absolute control of the enclosure manageme=
nt
> at the moment and I don't think you can get to it.

our HBA has no RAID option.

> If you run the HBA as a pure SAS one, then the promise website says t=
his
> enclosure is ses2 compliant, so you should just be able to insert the
> ses module and have enclosure management (2.6.24+ kernels).  This rel=
ies
> on the HBA exposing the enclosure device, but I think mptsas only eat=
s
> it for RAID configurations.

I tried 2.6.24.5 but the ses seems to be introduced in 2.6.25.
=20
> to see what's in the enclosure, just do
>=20
> ls /sys/class/enclosure/*/

# ls /sys/class/enclosure/*/
/sys/class/enclosure/6:0:16:0/:
0  10  12  14  2  4  6  8  components  subsystem
1  11  13  15  3  5  7  9  device      uevent

/sys/class/enclosure/6:0:33:0/:
0  10  12  14  2  4  6  8  components  subsystem
1  11  13  15  3  5  7  9  device      uevent

This is two times the same enclosure.
=20
> each of the subdirectories has a slot label (name taken from SES) to
> locate the enclosure, just echo 1 to the locate file and it will flas=
h
> the lights.  If it has a disk, there should be a device link in the s=
lot
> directory (might not be, this depends on ses working correctly and VP=
D
> inquiries identifying the right disk).

monosan:/sys/class/enclosure/6:0:16:0/0 # ls -l
insgesamt 0
-rw-r--r-- 1 root root 4096 21. Apr 10:48 active
-rw-r--r-- 1 root root 4096 21. Apr 10:48 fault
-rw-r--r-- 1 root root 4096 21. Apr 10:48 locate
-rw-r--r-- 1 root root 4096 21. Apr 10:48 status
lrwxrwxrwx 1 root root    0 21. Apr 10:46 subsystem -> ../../../enclosu=
re_component
-r--r--r-- 1 root root 4096 21. Apr 10:48 type
--w------- 1 root root 4096 21. Apr 10:48 uevent

There seems to be no device link if I understood you correctly.
Is the subdirctory numbering somehow in relation to the SCSI ID?

Thanks
Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
