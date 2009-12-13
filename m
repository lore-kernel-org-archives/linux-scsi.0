From: Uprooter <uprooter@gmail.com>
Subject: Re: Fusion MPT Ultra320 disks  detected as Ultra2
Date: Sun, 13 Dec 2009 12:58:26 +0200
Message-ID: <200912131258.27052.uprooter@gmail.com>
References: <26761757.post@talk.nabble.com> <20091213102925.4i5z7z3tw08swocc@imap.suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:45048 "HELO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750779AbZLMK6F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Dec 2009 05:58:05 -0500
Received: by fxm5 with SMTP id 5so2546412fxm.28
        for <linux-scsi@vger.kernel.org>; Sun, 13 Dec 2009 02:58:04 -0800 (PST)
In-Reply-To: <20091213102925.4i5z7z3tw08swocc@imap.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

Hello James and thanks for trying to help.

Unfortunately changing min_period  didn't solve anything.
# pwd
/sys/class/spi_transport/target2:0:1

localhost target2:0:1 # echo 25 > min_period
localhost target2:0:1 # echo 1 > revalidate
I did it for both disks.
#dmesg | tail -10
target2:0:0: Beginning Domain Validation
 target2:0:0: Domain Validation skipping write tests
 target2:0:0: Ending Domain Validation
 target2:0:0: Beginning Domain Validation
 target2:0:0: Domain Validation skipping write tests
 target2:0:0: Ending Domain Validation
 target2:0:1: Beginning Domain Validation
 target2:0:1: Domain Validation skipping write tests
 target2:0:1: Ending Domain Validation
 target2:0:1: Beginning Domain Validation
 target2:0:1: Domain Validation skipping write tests
 target2:0:1: Ending Domain Validation

# cat min_period
25
# cat period
50

hdparm still shows the same results.

# hdparm -Tt /dev/sda

/dev/sda:
 Timing cached reads:   1734 MB in  2.00 seconds = 867.28 MB/sec
 Timing buffered disk reads:  114 MB in  3.04 seconds =  37.55 MB/sec

# hdparm -Tt /dev/sdb

/dev/sdb:
 Timing cached reads:   1732 MB in  2.00 seconds = 866.42 MB/sec
 Timing buffered disk reads:  114 MB in  3.04 seconds =  37.47 MB/sec


If it helps here is what  lsiutil target settings shows:
Target MB/sec | MT/sec Wide ScanID ScanLUNs Disconnect Timeout QueueTag Boot
   0     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
   1     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
   2     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
   3     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
   4     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
   5     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
   6     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
   7     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
   8     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
   9     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
  10     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
  11     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
  12     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
  13     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
  14     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes
  15     320  |   160  Yes   Yes     Yes       Yes        10     Yes    Yes



On Sunday 13 December 2009 11:29:25 you wrote:
> Am Sat 12 Dec 2009 23:38:00 CET schrieb uprooter <uprooter@gmail.com>:
> > Hello. I'm struggling a IBM x336 machine with FustionMPT LSI53C1030.
> > This controller can't do radi0 so I disabled raid in the BIOS.
> > Problem is that disks are detected wrong and IO is very slow
> > hdparm -t gives only 37MB/s
> > dmesg shows that both disks are recognized as FAST-20 while it should be
> > FAST-160. also cache is disabled.
> 
> Well, the cache is easy, it isn't disabled, it's set to read through
> (the correct setting for enterprise disks).  That's what write
> disabled, read enabled means.
> 
> > I've googled around for hours, saw many problems related to the MPT being
> > slow when compiled into the kernel in old versions (I have tried module)
> > but I'm using using 2.6.31.
> > Here are some logs:
> >
> > 6 23:35:16 localhost kernel: Fusion MPT base driver 3.04.07
> > 6 23:35:16 localhost kernel: Copyright (c) 1999-2008 LSI Corporation
> > 6 23:35:16 localhost kernel: Fusion MPT SPI Host driver 3.04.07
> > 6 23:35:16 localhost kernel: mptspi 0000:04:01.0: PCI INT A -> GSI 28
> > (level, low) -> IRQ 28
> > 6 23:35:16 localhost kernel: mptbase: ioc0: Initiating bringup
> > 6 23:35:16 localhost kernel: ata1.00: ATAPI: DV-18E, 2.0D, max UDMA/33
> > 6 23:35:16 localhost kernel: ata1.00: configured for UDMA/33
> > 6 23:35:16 localhost kernel: scsi 0:0:0:0: CD-ROM            TEAC    
> > DV-18E 2.0D PQ: 0 ANSI: 5
> > 6 23:35:16 localhost kernel: sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2
> > cdda tray
> > 6 23:35:16 localhost kernel: Uniform CD-ROM driver Revision: 3.20
> > 6 23:35:16 localhost kernel: sr 0:0:0:0: Attached scsi CD-ROM sr0
> > 6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 3
> > 6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 1
> > 6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 2
> > 6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 0
> > 6 23:35:16 localhost kernel: ioc0: LSI53C1030 C0:
> > Capabilities={Initiator} 6 23:35:16 localhost kernel: scsi2 : ioc0:
> > LSI53C1030 C0, FwRev=01032821h, Ports=1, MaxQ=222, IRQ=28
> > 6 23:35:16 localhost kernel: Fusion MPT FC Host driver 3.04.07
> > 6 23:35:16 localhost kernel: Fusion MPT SAS Host driver 3.04.07
> > 6 23:35:16 localhost kernel: Fusion MPT misc device (ioctl) driver
> > 3.04.07 6 23:35:16 localhost kernel: mptctl: Registered with Fusion MPT
> > base driver 6 23:35:16 localhost kernel: mptctl: /dev/mptctl @
> > (major,minor=10,220) 6 23:35:16 localhost kernel: Fusion MPT LAN driver
> > 3.04.07
> > 6 23:35:16 localhost kernel: mptlan: ioc0: PortNum=0, ProtocolFlags=08h
> > (Itlb)
> > 6 23:35:16 localhost kernel: mptlan: ioc0: Hmmm... LAN protocol seems to
> > be disabled on this adapter port!
> > ....
> >
> > scsi: waiting for bus probes to complete ...
> > Nov 26 23:35:16 localhost kernel: scsi 2:0:0:0: Direct-Access     IBM
> > IC35L146UCDY10-0 S27N PQ: 0 ANSI: 3
> > Nov 26 23:35:16 localhost kernel: target2:0:0: Beginning Domain
> > Validation Nov 26 23:35:16 localhost kernel: target2:0:0: Domain
> > Validation skipping write tests
> > Nov 26 23:35:16 localhost kernel: target2:0:0: Ending Domain Validation
> > Nov 26 23:35:16 localhost kernel: target2:0:0: FAST-20 WIDE SCSI 40.0
> > MB/s ST (50 ns, offset 8)
> 
> This is more curious, it seems to indicate that the disk is reporting
> its max transfer period as 50ns. Try raising it by echoing 25 to
> min_period and then 1 to revalidate to force a renegotiation.
> 
> James
> 
