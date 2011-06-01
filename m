From: Jonathan Isom <jeisom@gmail.com>
Subject: Re: 2.6.39 and Powerfile c200
Date: Wed, 1 Jun 2011 09:58:25 -0500
Message-ID: <BANLkTimnRS64VFy5TSpOvSpUUEF1fMP+Cg@mail.gmail.com>
References: <BANLkTikkCOML4aNv_wSrk9VRSofjVwtVAw@mail.gmail.com>
 <20110528202646.02280a95@stein> <BANLkTi=JUTZ+7DNNZJR5wpODes78tYPVjA@mail.gmail.com>
 <BANLkTin=kaUtYMi7QeEAJmSLvLm7rmADkQ@mail.gmail.com> <20110530232429.3ef05054@stein>
 <BANLkTin4A-RCNtogW6LiVpumNcea+rmCAg@mail.gmail.com> <20110530233841.4e652322@stein>
 <BANLkTinSPtcr-btv7v5ZUkdPObguYDSSag@mail.gmail.com> <20110531212643.174c2739@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54753 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab1FAO6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2011 10:58:46 -0400
Received: by qwk3 with SMTP id 3so2623512qwk.19
        for <linux-scsi@vger.kernel.org>; Wed, 01 Jun 2011 07:58:45 -0700 (PDT)
In-Reply-To: <20110531212643.174c2739@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Tue, May 31, 2011 at 2:26 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On May 31 Jonathan Isom wrote:
>> Well I did some further testing. =A0If I boot with /bin/sh as init a=
nd
>> manually load the firewire modules the C200 works. =A0I moved out al=
l
>> kernel modules but firewire and loaded init and it start giving the
>> offline messages. =A0So it appears to be a userspace problem.
>
> (Or a firmware problem actually, provoked by Linux userspace that doe=
s not
> behave like a Windows system.)
>
>> Just =A0not sure where to start. I already did some digging in udev =
but
>> no luck so far. I'm running gentoo which probably make tracking it
>> down just a little harder as there are few identical installs in the
>> world. =A0Below is a listing of init scripts loaded at boot.
>>
>> Any Ideas?
> [...]
>
> Nothing obvious as far as I can tell. =A0The mythbackend perhaps? =A0=
Or a GUI
> desktop component that is started after login into xdm?

Neither those are it. Was logging in via console and disabled mythbacke=
nd.
tried the code,  However they only tell about the dvd drives themselves=
 and
I suspect it has more to do with the changer side of the device.  I
get 3 /dev/sg?
a /dev/sch0, a couple nodes in  /dev/bsg/, a /dev/fw1 , and the 2 dvd
drive nodes.
I'm kinda sure it is udev but am not sure where to patch to do similar
to the below
patch for the others.  In other testing, when I tried booting with
init as /bin/sh and
loaded the modules manually the device loads fine and no errors. Howeve=
r once
I start init and get a login it has disabled errors on parts.

> I don't know if there is a logging facility in the kernel's SCSI laye=
r
> that could expose the process name of SCSI ioctl issuers, but you can=
 add
> one:
>
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -479,6 +479,9 @@ static int sr_block_open(struct block_de
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D cdrom_open(&cd->cdi, bdev, mod=
e);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0scsi_cd_put(cd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "*****=
 %s opened by %s *****\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cd->cdi.=
name, current->comm);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0mutex_unlock(&sr_mutex);
> =A0 =A0 =A0 =A0return ret;
>
> --
> Stefan Richter
> -=3D=3D=3D=3D=3D-=3D=3D-=3D=3D -=3D-=3D =3D=3D=3D=3D=3D
> http://arcgraph.de/sr/
>

dmesg log after C200 poweron

[48028.951220] firewire_core: phy config: card 0, new root=3Dffc1, gap_=
count=3D5
[48029.549845] firewire_core: created device fw1: GUID 003060f200002759=
, S400
[48029.609450] scsi8 : SBP-2 IEEE-1394
[48029.810579] firewire_sbp2: fw1.0: logged in to LUN 0000 (0 retries)
[48029.812794] scsi 8:0:0:0: CD-ROM            TOSHIBA  DVD-ROM
SD-M1212 1032 PQ: 0 ANSI: 0 CCS
[48029.817707] sr1: scsi3-mmc drive: 32x/32x cd/rw xa/form2 cdda tray
[48029.817962] sr 8:0:0:0: Attached scsi CD-ROM sr1
[48029.818159] sr 8:0:0:0: Attached scsi generic sg5 type 5
[48029.820363] firewire_sbp2: fw1.0: logged in to LUN 0001 (0 retries)
[48029.822509] scsi 8:0:0:1: CD-ROM            TOSHIBA  DVD-ROM
SD-M1212 1032 PQ: 0 ANSI: 0 CCS
[48029.827662] sr2: scsi3-mmc drive: 32x/32x cd/rw xa/form2 cdda tray
[48029.827907] sr 8:0:0:1: Attached scsi CD-ROM sr2
[48029.828073] sr 8:0:0:1: Attached scsi generic sg6 type 5
[48029.830277] firewire_sbp2: fw1.0: logged in to LUN 0002 (0 retries)
[48029.835850] scsi 8:0:0:2: Medium Changer    Escient  Powerfile C200
  04A  PQ: 0 ANSI: 3
[48060.704057] firewire_sbp2: fw1.0: sbp2_scsi_abort
[48070.704061] firewire_sbp2: fw1.0: sbp2_scsi_abort
[48070.704292] sr 8:0:0:1: Device offlined - not ready after error reco=
very
[48070.704387] sr 8:0:0:1: rejecting I/O to offline device
[48071.031118] ch0: type #1 (mt): 0x0+1 [medium transport]
[48071.031126] ch0: type #2 (st): 0x4+200 [storage]
[48071.031132] ch0: type #3 (ie): 0x1+1 [import/export]
[48071.031136] ch0: type #4 (dt): 0x2+2 [data transfer]
[48071.364376] ch0: dt 0x2: READ ELEMENT STATUS failed
[48101.728068] firewire_sbp2: fw1.0: sbp2_scsi_abort
[48111.728057] firewire_sbp2: fw1.0: sbp2_scsi_abort
[48111.728268] sr 8:0:0:0: Device offlined - not ready after error reco=
very
[48111.728394] sr 8:0:0:0: rejecting I/O to offline device
[48111.730902] ***** sr0 opened by udisks-daemon *****
[48111.730980] sr 8:0:0:1: rejecting I/O to offline device
[48111.731035] sr 8:0:0:1: rejecting I/O to offline device
[48111.731157] sr 8:0:0:1: rejecting I/O to offline device
[48111.731167] sr 8:0:0:1: rejecting I/O to offline device
[48111.731625] sr 8:0:0:0: rejecting I/O to offline device
[48111.731652] sr 8:0:0:0: rejecting I/O to offline device
[48111.732300] sr 8:0:0:0: rejecting I/O to offline device
[48111.732326] sr 8:0:0:0: rejecting I/O to offline device
[48111.734325] ***** sr0 opened by udisks-daemon *****
[48111.757569] sr 8:0:0:1: rejecting I/O to offline device
[48111.757590] sr 8:0:0:1: rejecting I/O to offline device
[48111.757729] sr 8:0:0:0: rejecting I/O to offline device
[48111.757753] sr 8:0:0:0: rejecting I/O to offline device
[48111.762602] sr 8:0:0:1: rejecting I/O to offline device
[48111.762626] sr 8:0:0:1: rejecting I/O to offline device
[48111.762684] sr 8:0:0:1: rejecting I/O to offline device
[48111.762694] sr 8:0:0:1: rejecting I/O to offline device
[48111.765711] sr 8:0:0:0: rejecting I/O to offline device
[48111.765736] sr 8:0:0:0: rejecting I/O to offline device
[48111.765796] sr 8:0:0:0: rejecting I/O to offline device
[48111.765806] sr 8:0:0:0: rejecting I/O to offline device
[48112.062578] ch0: dt 0x3: READ ELEMENT STATUS failed
[48112.062586] ch0: INITIALIZE ELEMENT STATUS, may take some time ...
[48112.105512] ch0: ... finished
[48112.105522] ch 8:0:0:2: Attached scsi changer ch0
[48112.105690] ch 8:0:0:2: Attached scsi generic sg7 type 8
[48114.003984] ***** sr0 opened by udisks-daemon *****
[48114.004952] sr 8:0:0:0: rejecting I/O to offline device
[48114.004970] sr 8:0:0:0: rejecting I/O to offline device
[48114.005145] sr 8:0:0:1: rejecting I/O to offline device
[48114.005168] sr 8:0:0:1: rejecting I/O to offline device
[48116.003804] ***** sr0 opened by udisks-daemon *****
[48116.004466] sr 8:0:0:0: rejecting I/O to offline device
[48116.004483] sr 8:0:0:0: rejecting I/O to offline device
[48116.004616] sr 8:0:0:1: rejecting I/O to offline device
[48116.004638] sr 8:0:0:1: rejecting I/O to offline device
[48118.004164] ***** sr0 opened by udisks-daemon *****
[48118.004855] sr 8:0:0:0: rejecting I/O to offline device
[48118.004880] sr 8:0:0:0: rejecting I/O to offline device
[48118.005057] sr 8:0:0:1: rejecting I/O to offline device
[48118.005079] sr 8:0:0:1: rejecting I/O to offline device

Last 5 lines repeated until C200 shutdown.


Thanks

Jonathan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
