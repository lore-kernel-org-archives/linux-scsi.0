From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [2.6.27.25] Hang in SCSI sync cache when a disk is removed--?
Date: Mon, 6 Jul 2009 23:25:44 -0700
Message-ID: <20090707062543.GA2459@linux.vnet.ibm.com>
References: <1246551772.9022.7192.camel@psmith-ubeta.netezza.com> <20090702174151.GA17414@linux.vnet.ibm.com> <1246903453.9022.7246.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:45276 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbZGGGZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2009 02:25:44 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n676NX2Y003085
	for <linux-scsi@vger.kernel.org>; Tue, 7 Jul 2009 00:23:33 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n676PjP6209032
	for <linux-scsi@vger.kernel.org>; Tue, 7 Jul 2009 00:25:45 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n676PiGc032281
	for <linux-scsi@vger.kernel.org>; Tue, 7 Jul 2009 00:25:45 -0600
Content-Disposition: inline
In-Reply-To: <1246903453.9022.7246.camel@psmith-ubeta.netezza.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Smith <paul@mad-scientist.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>

Paul Smith <paul@mad-scientist.net> wrote:
> 

I was expecting a little more output from the error handler thread, but
the log does show a few things.

It would be good if in the failing case you could provide a sysrq "t"
output so I could understand where the reset handler is waiting.

It appears there are a few things going on.
1.) The dm deactivate calling blk_abort_queue is leading to error handler
activation. Similar to a previously described issue.
http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/8543
	- This kernel does not have DID_TRANSPORT_DISRUPTED so that
	  avoidance method cannot be used.
2.) The task aborts are completing, but the tur is most likely being
failed with a response of DID_BUS_BUSY leading to continued recovery.
3.) We appear to be inside mpt_HardResetHandler, but need more info to
understand where in the call chain.

T
> kernel log output:
> ------------------
> Jul  6 13:31:18  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:31:18  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:31:27  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:31:27  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:31:35  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:31:35  user.info kernel: sd 3:0:1:0: [sdn] Result: hostbyte=0x02 driverbyte=0x00
> Jul  6 13:31:35  user.warn kernel: device-mapper: multipath: Failing path 8:208.
> Jul  6 13:31:35  daemon.notice multipathd: 8:208: mark as failed
> Jul  6 13:31:35  daemon.notice multipathd: encl1Slot2: remaining active paths: 1
> Jul  6 13:31:43  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:31:43  user.info kernel: sd 2:0:1:0: [sdb] <6>mptscsih: ioc0: attempting task abort! (sc=ffff8804623e4b40)
> Jul  6 13:31:43  user.info kernel: sd 2:0:1:0: [sdb] CDB: cdb[0]=0x12: 12 01 80 00 fe 00
> Jul  6 13:31:43  user.info kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff8804623e4b40)
> Jul  6 13:31:43  user.warn kernel: Result: hostbyte=0x02 driverbyte=0x00
> Jul  6 13:31:43  user.warn kernel: device-mapper: multipath: Failing path 8:16.
> Jul  6 13:31:43  daemon.notice multipathd: 8:16: mark as failed
> Jul  6 13:31:43  daemon.notice multipathd: encl1Slot2: remaining active paths: 0
> Jul  6 13:31:51  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:31:51  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:31:51  user.info kernel: mptscsih: ioc0: attempting task abort! (sc=ffff880463a6b680)
> Jul  6 13:31:51  user.info kernel: sd 2:0:1:0: [sdb] CDB: 
> Jul  6 13:31:51  user.info kernel: cdb[0]=0x12
> Jul  6 13:31:51  user.info kernel: : 12
> Jul  6 13:31:51  user.info kernel:  01
> Jul  6 13:31:51  user.info kernel:  80 00
> Jul  6 13:31:51  user.info kernel:  fe 00
> Jul  6 13:31:51  user.info kernel: 
> Jul  6 13:31:51  user.info kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff880463a6b680)
> Jul  6 13:31:59  daemon.notice multipathd: sdn: readsector0 checker reports path is down
> Jul  6 13:31:59  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:31:59  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:31:59  user.info kernel: mptscsih: ioc0: attempting target reset! (sc=ffff8804623e4b40)
> Jul  6 13:31:59  user.info kernel: sd 2:0:1:0: [sdb] CDB: cdb[0]=0x12
> Jul  6 13:31:59  user.info kernel: : 12
> Jul  6 13:31:59  user.info kernel:  01 80
> Jul  6 13:31:59  user.info kernel:  00 fe
> Jul  6 13:31:59  user.info kernel:  00
> Jul  6 13:31:59  user.info kernel: 
> Jul  6 13:31:59  user.info kernel: mptscsih: ioc0: target reset: SUCCESS (sc=ffff8804623e4b40)
> Jul  6 13:32:07  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:32:07  user.info kernel: mptscsih: ioc0: attempting bus reset! (sc=ffff8804623e4b40)
> Jul  6 13:32:07  user.info kernel: sd 2:0:1:0: [sdb] CDB: 
> Jul  6 13:32:07  user.info kernel: cdb[0]=0x12
> Jul  6 13:32:07  user.info kernel: : 12
> Jul  6 13:32:07  user.info kernel:  01
> Jul  6 13:32:07  user.info kernel:  80 00
> Jul  6 13:32:07  user.info kernel:  fe
> Jul  6 13:32:07  user.info kernel:  00
> Jul  6 13:32:11  user.info kernel: mptscsih: ioc0: bus reset: SUCCESS (sc=ffff8804623e4b40)
> Jul  6 13:32:23  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:32:31  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:32:31  user.info kernel: mptscsih: ioc0: attempting host reset! (sc=ffff8804623e4b40)
> Jul  6 13:32:42  user.info kernel: mptscsih: ioc0: host reset: SUCCESS (sc=ffff8804623e4b40)
> Jul  6 13:32:43  user.info kernel: mptbase: ioc0: LogInfo(0x30030501): Originator={IOP}, Code={Invalid Page}, SubCode(0x0501)
> Jul  6 13:32:43  user.info kernel: mptsas: ioc0: removing ssp device: fw_channel 0, fw_id 27, phy 1, sas_addr 0x5000c5000d298821
> Jul  6 13:32:43  user.debug kernel:  phy-2:2:79: mptsas: ioc0: delete phy 1, phy-obj (0xffff88046a5e6800)
> Jul  6 13:32:43  user.debug kernel:  port-2:2:1: mptsas: ioc0: delete port 1, sas_addr (0x5000c5000d298821)
> Jul  6 13:32:43  user.notice kernel: sd 2:0:1:0: [sdb] Synchronizing SCSI cache
> Jul  6 13:32:52  user.info kernel: sd 2:0:1:0: Device offlined - not ready after error recovery
> Jul  6 13:32:53  user.info kernel: sd 2:0:1:0: [sdb] md: super_written gets error=-5, uptodate=0
> Jul  6 13:32:53  user.alert kernel: raid1: Disk failure on dm-13, disabling device.
> Jul  6 13:32:53  user.alert kernel: raid1: Operation continuing on 1 devices.
> Jul  6 13:32:53  daemon.notice multipathd: sdb: readsector0 checker reports path is down
> Jul  6 13:32:53  user.warn kernel: Result: hostbyte=0x01 driverbyte=0x00
> Jul  6 13:32:53  user.info kernel: mptbase: ioc0: LogInfo(0x30030501): Originator={IOP}, Code={Invalid Page}, SubCode(0x0501)
> Jul  6 13:32:53  user.warn kernel: RAID1 conf printout:
> Jul  6 13:32:53  user.warn kernel:  --- wd:1 rd:2
> Jul  6 13:32:53  user.warn kernel:  disk 0, wo:0, o:1, dev:dm-6
> Jul  6 13:32:53  user.warn kernel:  disk 1, wo:1, o:0, dev:dm-13
> Jul  6 13:32:53  user.warn kernel: RAID1 conf printout:
> Jul  6 13:32:53  user.warn kernel:  --- wd:1 rd:2
> Jul  6 13:32:53  user.warn kernel:  disk 0, wo:0, o:1, dev:dm-6
> Jul  6 13:32:55  daemon.notice multipathd: sdn: readsector0 checker reports path is down
> Jul  6 13:32:55  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:33:02  user.info kernel: mptscsih: ioc1: attempting task abort! (sc=ffff880461f6a280)
> Jul  6 13:33:02  user.info kernel: sd 3:0:1:0: CDB: 
> Jul  6 13:33:02  user.info kernel: cdb[0]=0x12
> Jul  6 13:33:02  user.info kernel: :
> Jul  6 13:33:02  user.info kernel:  12
> Jul  6 13:33:02  user.info kernel:  00 00
> Jul  6 13:33:02  user.info kernel:  00 24
> Jul  6 13:33:02  user.info kernel:  00
> Jul  6 13:33:02  user.info kernel: 
> Jul  6 13:33:02  user.info kernel: mptbase: ioc1: LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
> Jul  6 13:33:02  user.info kernel: mptscsih: ioc1: task abort: SUCCESS (sc=ffff880461f6a280)
> Jul  6 13:33:03  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:33:03  user.info kernel: mptscsih: ioc1: attempting task abort! (sc=ffff88046c04a000)
> Jul  6 13:33:03  user.info kernel: sd 3:0:1:0: [sdn] CDB: 
> Jul  6 13:33:03  user.info kernel: cdb[0]=0x12
> Jul  6 13:33:03  user.info kernel: : 12
> Jul  6 13:33:03  user.info kernel:  01
> Jul  6 13:33:03  user.info kernel:  80 00
> Jul  6 13:33:03  user.info kernel:  fe
> Jul  6 13:33:03  user.info kernel:  00
> Jul  6 13:33:03  user.info kernel: 
> Jul  6 13:33:03  user.info kernel: mptscsih: ioc1: task abort: SUCCESS (sc=ffff88046c04a000)
> Jul  6 13:33:04  user.err kernel: scsi 2:0:1:0: rejecting I/O to dead device
> Jul  6 13:33:04  daemon.notice multipathd: sdb: readsector0 checker reports path is down
> Jul  6 13:33:11  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:33:11  user.info kernel: mptscsih: ioc1: attempting task abort! (sc=ffff880463a6adc0)
> Jul  6 13:33:11  user.info kernel: sd 3:0:1:0: [sdn] CDB: 
> Jul  6 13:33:11  user.info kernel: cdb[0]=0x12
> Jul  6 13:33:11  user.info kernel: : 12
> Jul  6 13:33:11  user.info kernel:  01
> Jul  6 13:33:11  user.info kernel:  80 00
> Jul  6 13:33:11  user.info kernel:  fe
> Jul  6 13:33:11  user.info kernel:  00
> Jul  6 13:33:11  user.info kernel: mptscsih: ioc1: task abort: SUCCESS (sc=ffff880463a6adc0)
> Jul  6 13:33:19  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:33:19  user.info kernel: mptscsih: ioc1: attempting target reset! (sc=ffff880461f6a280)
> Jul  6 13:33:19  user.info kernel: sd 3:0:1:0: CDB: 
> Jul  6 13:33:19  user.info kernel: cdb[0]=0x12
> Jul  6 13:33:19  user.info kernel: : 12
> Jul  6 13:33:19  user.info kernel:  00 00
> Jul  6 13:33:19  user.info kernel:  00 24
> Jul  6 13:33:19  user.info kernel:  00
> Jul  6 13:33:19  user.info kernel: 
> Jul  6 13:33:19  user.info kernel: mptscsih: ioc1: target reset: SUCCESS (sc=ffff880461f6a280)
> Jul  6 13:33:27  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
> Jul  6 13:33:27  user.info kernel: mptscsih: ioc1: attempting bus reset! (sc=ffff880461f6a280)
> Jul  6 13:33:27  user.info kernel: sd 3:0:1:0: CDB: 
> Jul  6 13:33:27  user.info kernel: cdb[0]=0x12
> Jul  6 13:33:27  user.info kernel: :
> Jul  6 13:33:27  user.info kernel:  12
> Jul  6 13:33:27  user.info kernel:  00
> Jul  6 13:33:27  user.info kernel:  24
> Jul  6 13:33:27  user.info kernel:  00
> Jul  6 13:33:27  user.info kernel: 
> Jul  6 13:33:31  user.info kernel: mptscsih: ioc1: bus reset: SUCCESS (sc=ffff880461f6a280)
> Jul  6 13:33:42  user.info kernel: mptbase: ioc1: LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
> Jul  6 13:33:42  user.info kernel: mptscsih: ioc1: attempting host reset! (sc=ffff880461f6a280)
> Jul  6 13:33:42  user.info kernel: mptsas: ioc1: removing ssp device: fw_channel 0, fw_id 62, phy 1, sas_addr 0x5000c5000d298822
> Jul  6 13:33:42  user.debug kernel:  phy-3:2:79: mptsas: ioc1: delete phy 1, phy-obj (0xffff88046de9dc00)
> Jul  6 13:33:42  user.debug kernel:  port-3:2:1: mptsas: ioc1: delete port 1, sas_addr (0x5000c5000d298822)
> Jul  6 13:33:42  user.notice kernel: sd 3:0:1:0: [sdn] Synchronizing SCSI cache
> 
> 
> 

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
