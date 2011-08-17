From: Fredrik Lindgren <fli@swip.net>
Subject: mpt2sas driver behaving strange with a failed SATA disk behind SAS
 expander.
Date: Wed, 17 Aug 2011 16:25:24 +0200
Message-ID: <4E4BCF54.8090408@swip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailfe08.swip.net ([212.247.154.225]:41778 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753930Ab1HQOa1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2011 10:30:27 -0400
Received: from [192.71.219.1] (account fli@swip.net HELO [10.156.17.120])
  by mailfe08.swip.net (CommuniGate Pro SMTP 5.2.19)
  with ESMTPSA id 167298817 for linux-scsi@vger.kernel.org; Wed, 17 Aug 2011 16:25:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello,

I'm seeing something strange on a Supermicro 847E16-R1400. It has SAS 
expanders
with SATA disks behind them (Seagate Barracuda XT). The SAS card is a 
LSI SAS9211-8i.

When doing disk IO on the disks (they are all configured in MD raids) 
suddenly IO will
stop and these messages are printed on the console about once every second:

mpt2sas0: log_info(0x31110610): originator(PL), code(0x11), sub_code(0x0610)

 From what I understand this means:

PL_LOGINFO_CODE_RESET (0x00110000)
PL_LOGINFO_SUB_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET (0x00000600)

So a disk is acting up, generating errors? What does the last "10" mean 
in the sub_code,
is that an identifier for which disk it is?

After some time, the message changed:

mpt2sas0: log info(0x31111000): originator(PL), code(0x11), sub code(0x1000)

Now the disk seems to have died completely?

PL_LOGINFO_CODE_RESET (0x00110000)
PL_LOGINFO_SUB_CODE_DSCVRY_SATA_INIT_TIMEOUT (0x00001000)

What bothers me is that the machine is just hanging there with IO 
blocking for the disk
in question (I guess, this was gong on for several hours) there was no 
SCSI-errors and the
drive in question was not ejected from the MD array. After rebooting it 
started to rebuild
the MD array, promptly got stuck again and just sat there until the disk 
was removed from
the array and it was restarted again.

This was with a stock Debian Squeeze kernel 
(linux-image-2.6.32-5-amd64). I got the exact same
thing with a vanilla 3.0.1 from kernel.org.

Regards,
   Fredrik Lindgren

----

dmesg from 3.0.1:

mpt2sas version 08.100.00.02 loaded
mpt2sas 0000:06:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
mpt2sas 0000:06:00.0: setting latency timer to 64
mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (49559612 kB)
mpt2sas 0000:06:00.0: irq 72 for MSI/MSI-X
mpt2sas0: PCI-MSI-X enabled: IRQ 72
mpt2sas0: iomem(0x00000000fbc3c000), mapped(0xffffc90006068000), size(16384)
mpt2sas0: ioport(0x000000000000d000), size(256)
mpt2sas0: sending diag reset !!
mpt2sas0: diag reset: SUCCESS
mpt2sas0: Allocated physical memory: size(3971 kB)
mpt2sas0: Current Controller Queue Depth(1739), Max Controller Queue 
Depth(2000)
mpt2sas0: Scatter Gather Elements per IO(128)
mpt2sas0: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x03), 
BiosVersion(07.17.00.00)
mpt2sas0: Protocol=(Initiator,Target), 
Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set 
Full,NCQ)
mpt2sas0: sending port enable !!
mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b0034da7c0), phys(8)
mpt2sas0: expander_add: handle(0x0009), parent(0x0001), 
sas_addr(0x5003048001016e7f), phys(38)
mpt2sas0: expander_add: handle(0x0023), parent(0x0002), 
sas_addr(0x5003048000f6b57f), phys(30)
mpt2sas0: port enable: SUCCESS

root@weathergirl:~# smp_rep_manufacturer /dev/bsg/expander-6\:0
Report manufacturer response:
   Expander change count: 85
   SAS-1.1 format: 1
   vendor identification: LSI CORP
   product identification: SAS2X36
   product revision level: 0717
   component vendor identification: LSI
   component id: 547
   component revision level: 5
root@weathergirl:~# smp_rep_manufacturer /dev/bsg/expander-6\:1
Report manufacturer response:
   Expander change count: 67
   SAS-1.1 format: 1
   vendor identification: LSI CORP
   product identification: SAS2X28
   product revision level: 0717
   component vendor identification: LSI
   component id: 545
   component revision level: 5

