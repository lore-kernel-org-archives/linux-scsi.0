From: James Bottomley <jbottomley@suse.de>
Subject: Re: Fusion MPT Ultra320 disks  detected as Ultra2
Date: Sun, 13 Dec 2009 10:29:25 +0100
Message-ID: <20091213102925.4i5z7z3tw08swocc@imap.suse.de>
References: <26761757.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54526 "HELO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751651AbZLMJ31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Dec 2009 04:29:27 -0500
In-Reply-To: <26761757.post@talk.nabble.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: uprooter <uprooter@gmail.com>
Cc: linux-scsi@vger.kernel.org

Am Sat 12 Dec 2009 23:38:00 CET schrieb uprooter <uprooter@gmail.com>:
> Hello. I'm struggling a IBM x336 machine with FustionMPT LSI53C1030.
> This controller can't do radi0 so I disabled raid in the BIOS.
> Problem is that disks are detected wrong and IO is very slow
> hdparm -t gives only 37MB/s
> dmesg shows that both disks are recognized as FAST-20 while it should be
> FAST-160. also cache is disabled.

Well, the cache is easy, it isn't disabled, it's set to read through  
(the correct setting for enterprise disks).  That's what write  
disabled, read enabled means.

> I've googled around for hours, saw many problems related to the MPT being
> slow when compiled into the kernel in old versions (I have tried module) but
> I'm using using 2.6.31.
> Here are some logs:
>
> 6 23:35:16 localhost kernel: Fusion MPT base driver 3.04.07
> 6 23:35:16 localhost kernel: Copyright (c) 1999-2008 LSI Corporation
> 6 23:35:16 localhost kernel: Fusion MPT SPI Host driver 3.04.07
> 6 23:35:16 localhost kernel: mptspi 0000:04:01.0: PCI INT A -> GSI 28
> (level, low) -> IRQ 28
> 6 23:35:16 localhost kernel: mptbase: ioc0: Initiating bringup
> 6 23:35:16 localhost kernel: ata1.00: ATAPI: DV-18E, 2.0D, max UDMA/33
> 6 23:35:16 localhost kernel: ata1.00: configured for UDMA/33
> 6 23:35:16 localhost kernel: scsi 0:0:0:0: CD-ROM            TEAC     DV-18E
> 2.0D PQ: 0 ANSI: 5
> 6 23:35:16 localhost kernel: sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2
> cdda tray
> 6 23:35:16 localhost kernel: Uniform CD-ROM driver Revision: 3.20
> 6 23:35:16 localhost kernel: sr 0:0:0:0: Attached scsi CD-ROM sr0
> 6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 3
> 6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 1
> 6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 2
> 6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 0
> 6 23:35:16 localhost kernel: ioc0: LSI53C1030 C0: Capabilities={Initiator}
> 6 23:35:16 localhost kernel: scsi2 : ioc0: LSI53C1030 C0, FwRev=01032821h,
> Ports=1, MaxQ=222, IRQ=28
> 6 23:35:16 localhost kernel: Fusion MPT FC Host driver 3.04.07
> 6 23:35:16 localhost kernel: Fusion MPT SAS Host driver 3.04.07
> 6 23:35:16 localhost kernel: Fusion MPT misc device (ioctl) driver 3.04.07
> 6 23:35:16 localhost kernel: mptctl: Registered with Fusion MPT base driver
> 6 23:35:16 localhost kernel: mptctl: /dev/mptctl @ (major,minor=10,220)
> 6 23:35:16 localhost kernel: Fusion MPT LAN driver 3.04.07
> 6 23:35:16 localhost kernel: mptlan: ioc0: PortNum=0, ProtocolFlags=08h
> (Itlb)
> 6 23:35:16 localhost kernel: mptlan: ioc0: Hmmm... LAN protocol seems to be
> disabled on this adapter port!
> ....
>
> scsi: waiting for bus probes to complete ...
> Nov 26 23:35:16 localhost kernel: scsi 2:0:0:0: Direct-Access     IBM
> IC35L146UCDY10-0 S27N PQ: 0 ANSI: 3
> Nov 26 23:35:16 localhost kernel: target2:0:0: Beginning Domain Validation
> Nov 26 23:35:16 localhost kernel: target2:0:0: Domain Validation skipping
> write tests
> Nov 26 23:35:16 localhost kernel: target2:0:0: Ending Domain Validation
> Nov 26 23:35:16 localhost kernel: target2:0:0: FAST-20 WIDE SCSI 40.0 MB/s
> ST (50 ns, offset 8)

This is more curious, it seems to indicate that the disk is reporting  
its max transfer period as 50ns. Try raising it by echoing 25 to  
min_period and then 1 to revalidate to force a renegotiation.

James
