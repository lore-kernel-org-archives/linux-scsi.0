From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Megaraid lockup on 2.6.[7-8]
Date: Mon, 9 Aug 2004 10:11:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC937@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35519 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266603AbUHIOL5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2004 10:11:57 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Merillat' <harik.attar@gmail.com>, linux-scsi@vger.kernel.org

Dan,

I speculate your drives are good. BTW, what raid level they are in? Also,
have you considered your drives enclosure as a possible source of errors. I
would highly recommended trying another box and see if it changes anything.
I can suggest FW trace collection, but let's wait a bit for that.

The latest 2.20 series of drivers
(ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.2.0/) should
support your card. This driver does have more extensive error reporting
capabilities.

-Atul Mukker
LSI Logic Corporation

> -----Original Message-----
> From: Dan Merillat [mailto:harik.attar@gmail.com]
> Sent: Friday, August 06, 2004 9:56 PM
> To: linux-scsi@vger.kernel.org
> Subject: Megaraid lockup on 2.6.[7-8]
> 
> 
> This dump is from 2.6.7-rc3.  I'm using the in-kernel megaraid driver
> on this Express 500.
> 
> 0000:00:09.0 RAID bus controller: American Megatrends Inc. 
> MegaRAID (rev 02)
>         Subsystem: American Megatrends Inc. MegaRAID 475 Express
> 500/500LC RAID Controller
> 
> At this point, I'm really unsure what's going on.  It went from
> "working" to "not working"
> overnight, after a 2 month uptime with no problem.  Now it lasts
> between 5 minutes and 3 hours before it locks up.  Somtimes the
> lockups are 'soft', in that all disk IO hangs in wait.  Othertimes
> it's hard (kernel panic and reload)
> 
> Due to the sudden nature of the problem, I suspected hardware. 
> Starting with the SCSI cable,
> RAID card, RAM, PCI riser card, motherboard... it's all been replaced.
>  The megaraid itself
> dosn't complain about problems accessing the drives (and the state is
> always Optimal on reboot, no media or "other" errors on any drive)
> 
> Software wise, I've tried from 2.6.7-rc3, 2.6.7, 2.6.8-rc2 
> and 2.6.8-rc3.
> 
> I tried the 2.20 series, but they don't appear to recognize older
> cards?  Are they for
> U320 only or did I do something wrong?  (2.20 works fine on another
> box with a U320 controller)
> 
> I'm at a loss.  I guess I could replace all the drives, being as
> that's the last thing left to try,
> but A) it's a serious PITA and B) they "appear" fine, even when doing
> a full consistency check
> via the Ctrl-M BIOS.   
> 
> This is made even more fun due to the fact it's a LIVE server, or was,
> until two days ago.  It's
> also stored in a colo facility about an hour from my house.   I'm
> going to go back tomorrow
> and try updating the firmware on the megaraid, but that's about the
> only thing I can think
> left to try.   Perhaps some PCI setting I should try?
> 
> Any help would be greatly appreciated!
> 
> (Different PCI Bus/Slot due to being in a different MB when I captured
> this backtrace)
> 
> 
> megaraid: found 0x101e:0x1960:bus 1:slot 2:func 0
> scsi0:Found MegaRAID controller at 0xf8846000, IRQ:27
> megaraid: [C170:3.13] detected 1 logical drives.
> megaraid: supports extended CDBs.
> megaraid: channel[0] is raid.
> scsi0 : LSI Logic MegaRAID C170 254 commands 16 targs 4 chans 7 luns
> scsi0: scanning scsi channel 0 for logical drives.
>   Vendor: MegaRAID  Model: LD 0 RAID5  210G  Rev: C170
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> SCSI device sda: 430116864 512-byte hdwr sectors (220220 MB)
> sda: asking for cache data failed
> sda: assuming drive cache: write through
>  /dev/scsi/host0/bus0/target0/lun0: p1
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
> scsi0: scanning scsi channel 1 for logical drives.
> scsi0: scanning scsi channel 2 for logical drives.
> scsi0: scanning scsi channel 4 [P0] for physical devices.
> ...
> megaraid: ABORTING-12793 cmd=2a <c=0 t=0 l=0>
> megaraid: ABORTING-12796 cmd=2a <c=0 t=0 l=0>
> megaraid: ABORTING-12797 cmd=2a <c=0 t=0 l=0>
> megaraid: ABORTING-12798 cmd=2a <c=0 t=0 l=0>
> megaraid: reservation reset failed.
> megaraid: RESET-12793 cmd=2a <c=0 t=0 l=0>
> megaraid: reservation reset failed.
> megaraid: RESET-12793 cmd=2a <c=0 t=0 l=0>
> megaraid: reservation reset failed.
> megaraid: RESET-12793 cmd=2a <c=0 t=0 l=0>
> scsi: Device offlined - not ready after error recovery: host 0 channel
> 0 id 0 lun 0
> scsi: Device offlined - not ready after error recovery: host 0 channel
> 0 id 0 lun 0
> scsi: Device offlined - not ready after error recovery: host 0 channel
> 0 id 0 lun 0
> scsi: Device offlined - not ready after error recovery: host 0 channel
> 0 id 0 lun 0
> SCSI error : <0 0 0 0> return code = 0x6000000
> end_request: I/O error, dev sda, sector 197231
> Buffer I/O error on device dm-64, logical block 24598
> lost page write due to I/O error on dm-64
> scsi0 (0:0): rejecting I/O to offline device
> 
