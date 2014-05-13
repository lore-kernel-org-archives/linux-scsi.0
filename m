From: Nicolas Sylvain <nsylvain@gmail.com>
Subject: Re: Hot Swap Problems with LSI HBA and LSI Backplane -- reproducable
 and very frustrating
Date: Tue, 13 May 2014 10:50:27 -0700
Message-ID: <CA+kKMHTQWpEqE5yNTxACZVVzupH0ghvV-1uXdvTUdQvRf7MhLg@mail.gmail.com>
References: <523A23D3.6030608@nathanshearer.ca> <CAC9+an+YaZ3hn+eTyk0mApgj7m30yTYEKeif=aEUrF49dinh7w@mail.gmail.com>
 <523BE569.4020706@nathanshearer.ca> <537244D8.7020008@nathanshearer.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:65240 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaEMRur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2014 13:50:47 -0400
Received: by mail-ve0-f172.google.com with SMTP id oz11so905841veb.17
        for <linux-scsi@vger.kernel.org>; Tue, 13 May 2014 10:50:47 -0700 (PDT)
In-Reply-To: <537244D8.7020008@nathanshearer.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Thanks for all the info! It's definitely very helpful.

I'm using the LSI SAS9207-8i as well.   I've tested 3 drives, and only
1 causes the problem:

Intel SSD 520 Series 480GB SSDSC2CW480A3 -> works
Hitachi 2TB HUA722020ALA331 -> works
Crucial M200 SSD 960GB CT960M500SSD1 -> failed

The server is a Dell R720XD with 12 3.5inch hotswap bays.  I'm unsure
what exact backplane it's using, but I'll be talking to Dell about
this.

The behavior I'm seeing is very similar to yours:

I can hotswap the Intel or Hitachi drives without problem.  However,
when I insert and remove the Crucial disk, there is about a 50% chance
that the bay is going to be wedged.   When it happens, This bay is no
longer able to recognize Crucial disks.  Soft-rebooting does not seem
to fix the problem.   Hotswap events for any of the other bays/drives
are also not working until I actually remove the Crucial drive from
the wedged bay.  The mtp2sas driver seems to be hung.

When inserting a drive in a bay that is wedged, I sometimes see:

mpt2sas0: device is not present handle(0x000b), no sas_device!!!


When removing a drive that was inserted in a wedged bay, I see
messages like those:

May 10 00:11:14 localhost kernel: [ 8211.861607] mpt2sas0:
handle(0x000c), ioc_status(0x0022)
May 10 00:11:14 localhost kernel: [ 8211.861610] failure at
/build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_transport.c:162/_transport_set_identify()!
May 10 00:11:14 localhost kernel: [ 8211.867179] mpt2sas0:
handle(0x0011), ioc_status(0x0022)
May 10 00:11:14 localhost kernel: [ 8211.867182] failure at
/build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_transport.c:162/_transport_set_identify()!
May 10 00:11:14 localhost kernel: [ 8211.867805] mpt2sas0: failure at
/build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_scsih.c:5157/_scsih_add_device()!
May 10 00:11:14 localhost kernel: [ 8211.876189] mpt2sas0:
handle(0x0011), ioc_status(0x0022)
May 10 00:11:14 localhost kernel: [ 8211.876190] failure at
/build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_transport.c:162/_transport_set_identify()!
May 10 00:11:14 localhost kernel: [ 8211.876797] mpt2sas0: failure at
/build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_scsih.c:5157/_scsih_add_device()!
May 10 00:11:14 localhost kernel: [ 8211.881823] mpt2sas0:
handle(0x0012), ioc_status(0x0022)
May 10 00:11:14 localhost kernel: [ 8211.881825] failure at
/build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_transport.c:162/_transport_set_identify()!
May 10 00:11:14 localhost kernel: [ 8211.882288] mpt2sas0: failure at
/build/buildd/linux-3.2.0/drivers/scsi/mpt2sas/mpt2sas_scsih.c:5157/_scsih_add_device()!

One thing that might be different from your problem, is that I
actually have a workaround to fix the wedged bays : Insert a Intel or
Hitachi drive.   Those get detected correctly, no matter if the bay is
wedged for Crucial disks or not.

I only have done limited testing, but I'll be following up with Dell
on this and let you know if I get to try your backplane solution.

Thanks

Nicolas

On Tue, May 13, 2014 at 9:14 AM, Nathan Shearer <mail@nathanshearer.ca> wrote:
>
> Hi Nicolas,
>
> I just wanted to be sure that you are experiencing the same problem. In my final setup I wanted to use a Supermicro SuperChassis 826E2-R800LPB with a LSI SAS9207-8i and a mixture of hard drives.
>
> I included the linux-scsi mailing list for future reference, but I'm afraid I have bad news. I contacted Supermicro and LSI regarding this issue and after a lot of back-and-forth and testing on my part this is what I determined:
>
> Supermicro Case Number: SM1309158401
> LSI Case Number: P00078977
> Seagate Case Number: 03671535
> The LSI SAS9207-8i uses the LSI SAS2308 controller, is SAS 2.1 compliant, and has the same problem
> The Supermicro AOC-USAS2-L8i uses the LSI SAS2008 controller, is SAS 2.0 compliant, and has the same problem
> The Supermicro AOC-USAS-L8i uses the LSI SAS1068E controller, is SAS 1.0 compliant, and works perfectly
>
> Note that this card does not support hard drives with >2TB of space
> All drives work (including the ones affected on the newer controller), but they have exactly 2^32 bytes of usable space
>
> Supermicro SuperChassis 826E2-R800LPB uses the BPN-SAS-826EL2 backplane (SAS 1.0)
> The BPN-SAS-826EL2 uses the LSI SASx28 expander chipset (SAS 1.0)
> LSI has discontinued support for the LSI SASx28 over 2 years ago!
> Supermicro refused to provide support or a new firmware for the backplane or LSI SASx28 expander. They told me to contact Supermicro for a new backplane firmware or a new backplane.
> I forwarded my entire e-mail chain from LSI to Supermicro and Supermicro said that LSI discontinued support over 2 years ago and that there is no newer firmware.
> To solve the issue, You need to replace the SAS1 backplane (BPN-SAS-826EL2) with a SAS2 packplane: BPN-SAS2-826EL2
>
> I did not try this -- I can't guarantee that it will work
>
> I believe it is a problem with the SAS1 backplane and SAS2 controller card. Why only certain drives are affected, I'm not sure. My guess is it's a power-saving feature that is causing them to not spin up properly, then the controller/backplane disables the drive bay permanently for some reason. It is something related to mixing the SAS2 controller with the SAS1 backplane. A SAS2 backplane might fix the issue.
>
> I am still using the Supermicro SuperChassis 826E2-R800LPB with the BPN-SAS-826EL2 backplane with the LSI SASx28 expander chipset, all with a LSI SAS9207-8i controller. In my particular situation we decided to just go with drives that work from the compatibility list -- which is very expensive, but I needed the guarantee that they would work.
>
> With that configuration, I did some testing with various drives and this is what I found:
>
> Western Digital WD2003FYYS-02W0B0 works
> Western Digital WD20EARS-00S8B1 works
> Western Digital WD3000BLFS-01YBU4 works
> Western Digital WD3000HLFS-01G6U1 works
> Western Digital WD30EFRX-68AX9N0 works (but had some odd "task abort" kernel messages)
> Western Digital WD740ADFD-00NLR5 works
> Seagate ST3000DM001 failed
> Seagate ST3500641AS works
> Seagate ST4000DM000-1F2168 failed
> Seagate ST91000640NS works
>
> I also tried these drives on my HighPoint RocketRaid 2740 (direct attached SAS 2.0) without the backplane and all the drives worked perfectly.
