From: Paul Smith <paul@mad-scientist.net>
Subject: Re: [2.6.27.25] Hang in SCSI sync cache when a disk is removed--?
Date: Mon, 06 Jul 2009 14:04:13 -0400
Message-ID: <1246903453.9022.7246.camel@psmith-ubeta.netezza.com>
References: <1246551772.9022.7192.camel@psmith-ubeta.netezza.com>
	 <20090702174151.GA17414@linux.vnet.ibm.com>
Reply-To: paul@mad-scientist.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta.netezza.com ([12.148.248.132]:58751 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753313AbZGFSEQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2009 14:04:16 -0400
In-Reply-To: <20090702174151.GA17414@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2009-07-02 at 10:41 -0700, Mike Anderson wrote:
> Paul Smith <paul@mad-scientist.net> wrote:
> > Hi all; we are seeing a problem where, when we pull a disk out of our
> > disk array (even one that's not actively being used), the entire IO
> > subsystem in Linux hangs.  Here are some details:
> > 
> > I have an IBM Bladecenter with an LSI EXP3000 SAS expander with 12 1TB
> > Seagate SAS disks.  Relevant lspci output for the SAS controllers:
> > 
> >         # lspci | grep LSI
> >         02:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS (rev 02)
> >         08:01.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064 PCI-X Fusion-MPT SAS (rev 03)
> >         14:01.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064 PCI-X Fusion-MPT SAS (rev 03)
> 
> Have you tried a minimum level of logging like the following without the
> error going away?
> "sysctl -w dev.scsi.logging_level=4100"

We enabled this and were able to reproduce the hang.  Please see the log
output below.

> Can you run "cat /sys/class/scsi_host/*/state" when you are in the hung
> state?
> 
> If the host is in recovery no IOs will move forward. I assume if you can
> get a run with the 4100 level of logging it will show a host reset sent,
> but no waking up host to restart (unless the reset is being generated for
> other reasons outside of the scsi error handler).

This seems to be the case, yes.  The output of the above-requested cat
is:

# cat /sys/class/scsi_host/host*/state
running
running
running
recovery
running

# cat /sys/class/scsi_host/host3/state
recovery

# ls -l /sys/class/scsi_host/host3/device
lrwxrwxrwx    1 root     root            0 Jul  6 13:27 /sys/class/scsi_host/host3/device -> ../../../devices/pci0000:00/0000:00:04.0/0000:11:00.0/0000:13:08.0/0000:14:01.0/host3

Note that host3 is ioc1.

Thanks for looking at this; it's really killing us.


kernel log output:
------------------
Jul  6 13:31:18  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:31:18  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:31:27  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:31:27  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:31:35  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:31:35  user.info kernel: sd 3:0:1:0: [sdn] Result: hostbyte=0x02 driverbyte=0x00
Jul  6 13:31:35  user.warn kernel: device-mapper: multipath: Failing path 8:208.
Jul  6 13:31:35  daemon.notice multipathd: 8:208: mark as failed
Jul  6 13:31:35  daemon.notice multipathd: encl1Slot2: remaining active paths: 1
Jul  6 13:31:43  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:31:43  user.info kernel: sd 2:0:1:0: [sdb] <6>mptscsih: ioc0: attempting task abort! (sc=ffff8804623e4b40)
Jul  6 13:31:43  user.info kernel: sd 2:0:1:0: [sdb] CDB: cdb[0]=0x12: 12 01 80 00 fe 00
Jul  6 13:31:43  user.info kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff8804623e4b40)
Jul  6 13:31:43  user.warn kernel: Result: hostbyte=0x02 driverbyte=0x00
Jul  6 13:31:43  user.warn kernel: device-mapper: multipath: Failing path 8:16.
Jul  6 13:31:43  daemon.notice multipathd: 8:16: mark as failed
Jul  6 13:31:43  daemon.notice multipathd: encl1Slot2: remaining active paths: 0
Jul  6 13:31:51  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:31:51  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:31:51  user.info kernel: mptscsih: ioc0: attempting task abort! (sc=ffff880463a6b680)
Jul  6 13:31:51  user.info kernel: sd 2:0:1:0: [sdb] CDB: 
Jul  6 13:31:51  user.info kernel: cdb[0]=0x12
Jul  6 13:31:51  user.info kernel: : 12
Jul  6 13:31:51  user.info kernel:  01
Jul  6 13:31:51  user.info kernel:  80 00
Jul  6 13:31:51  user.info kernel:  fe 00
Jul  6 13:31:51  user.info kernel: 
Jul  6 13:31:51  user.info kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff880463a6b680)
Jul  6 13:31:59  daemon.notice multipathd: sdn: readsector0 checker reports path is down
Jul  6 13:31:59  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:31:59  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:31:59  user.info kernel: mptscsih: ioc0: attempting target reset! (sc=ffff8804623e4b40)
Jul  6 13:31:59  user.info kernel: sd 2:0:1:0: [sdb] CDB: cdb[0]=0x12
Jul  6 13:31:59  user.info kernel: : 12
Jul  6 13:31:59  user.info kernel:  01 80
Jul  6 13:31:59  user.info kernel:  00 fe
Jul  6 13:31:59  user.info kernel:  00
Jul  6 13:31:59  user.info kernel: 
Jul  6 13:31:59  user.info kernel: mptscsih: ioc0: target reset: SUCCESS (sc=ffff8804623e4b40)
Jul  6 13:32:07  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:32:07  user.info kernel: mptscsih: ioc0: attempting bus reset! (sc=ffff8804623e4b40)
Jul  6 13:32:07  user.info kernel: sd 2:0:1:0: [sdb] CDB: 
Jul  6 13:32:07  user.info kernel: cdb[0]=0x12
Jul  6 13:32:07  user.info kernel: : 12
Jul  6 13:32:07  user.info kernel:  01
Jul  6 13:32:07  user.info kernel:  80 00
Jul  6 13:32:07  user.info kernel:  fe
Jul  6 13:32:07  user.info kernel:  00
Jul  6 13:32:11  user.info kernel: mptscsih: ioc0: bus reset: SUCCESS (sc=ffff8804623e4b40)
Jul  6 13:32:23  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:32:31  user.info kernel: mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:32:31  user.info kernel: mptscsih: ioc0: attempting host reset! (sc=ffff8804623e4b40)
Jul  6 13:32:42  user.info kernel: mptscsih: ioc0: host reset: SUCCESS (sc=ffff8804623e4b40)
Jul  6 13:32:43  user.info kernel: mptbase: ioc0: LogInfo(0x30030501): Originator={IOP}, Code={Invalid Page}, SubCode(0x0501)
Jul  6 13:32:43  user.info kernel: mptsas: ioc0: removing ssp device: fw_channel 0, fw_id 27, phy 1, sas_addr 0x5000c5000d298821
Jul  6 13:32:43  user.debug kernel:  phy-2:2:79: mptsas: ioc0: delete phy 1, phy-obj (0xffff88046a5e6800)
Jul  6 13:32:43  user.debug kernel:  port-2:2:1: mptsas: ioc0: delete port 1, sas_addr (0x5000c5000d298821)
Jul  6 13:32:43  user.notice kernel: sd 2:0:1:0: [sdb] Synchronizing SCSI cache
Jul  6 13:32:52  user.info kernel: sd 2:0:1:0: Device offlined - not ready after error recovery
Jul  6 13:32:53  user.info kernel: sd 2:0:1:0: [sdb] md: super_written gets error=-5, uptodate=0
Jul  6 13:32:53  user.alert kernel: raid1: Disk failure on dm-13, disabling device.
Jul  6 13:32:53  user.alert kernel: raid1: Operation continuing on 1 devices.
Jul  6 13:32:53  daemon.notice multipathd: sdb: readsector0 checker reports path is down
Jul  6 13:32:53  user.warn kernel: Result: hostbyte=0x01 driverbyte=0x00
Jul  6 13:32:53  user.info kernel: mptbase: ioc0: LogInfo(0x30030501): Originator={IOP}, Code={Invalid Page}, SubCode(0x0501)
Jul  6 13:32:53  user.warn kernel: RAID1 conf printout:
Jul  6 13:32:53  user.warn kernel:  --- wd:1 rd:2
Jul  6 13:32:53  user.warn kernel:  disk 0, wo:0, o:1, dev:dm-6
Jul  6 13:32:53  user.warn kernel:  disk 1, wo:1, o:0, dev:dm-13
Jul  6 13:32:53  user.warn kernel: RAID1 conf printout:
Jul  6 13:32:53  user.warn kernel:  --- wd:1 rd:2
Jul  6 13:32:53  user.warn kernel:  disk 0, wo:0, o:1, dev:dm-6
Jul  6 13:32:55  daemon.notice multipathd: sdn: readsector0 checker reports path is down
Jul  6 13:32:55  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:33:02  user.info kernel: mptscsih: ioc1: attempting task abort! (sc=ffff880461f6a280)
Jul  6 13:33:02  user.info kernel: sd 3:0:1:0: CDB: 
Jul  6 13:33:02  user.info kernel: cdb[0]=0x12
Jul  6 13:33:02  user.info kernel: :
Jul  6 13:33:02  user.info kernel:  12
Jul  6 13:33:02  user.info kernel:  00 00
Jul  6 13:33:02  user.info kernel:  00 24
Jul  6 13:33:02  user.info kernel:  00
Jul  6 13:33:02  user.info kernel: 
Jul  6 13:33:02  user.info kernel: mptbase: ioc1: LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
Jul  6 13:33:02  user.info kernel: mptscsih: ioc1: task abort: SUCCESS (sc=ffff880461f6a280)
Jul  6 13:33:03  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:33:03  user.info kernel: mptscsih: ioc1: attempting task abort! (sc=ffff88046c04a000)
Jul  6 13:33:03  user.info kernel: sd 3:0:1:0: [sdn] CDB: 
Jul  6 13:33:03  user.info kernel: cdb[0]=0x12
Jul  6 13:33:03  user.info kernel: : 12
Jul  6 13:33:03  user.info kernel:  01
Jul  6 13:33:03  user.info kernel:  80 00
Jul  6 13:33:03  user.info kernel:  fe
Jul  6 13:33:03  user.info kernel:  00
Jul  6 13:33:03  user.info kernel: 
Jul  6 13:33:03  user.info kernel: mptscsih: ioc1: task abort: SUCCESS (sc=ffff88046c04a000)
Jul  6 13:33:04  user.err kernel: scsi 2:0:1:0: rejecting I/O to dead device
Jul  6 13:33:04  daemon.notice multipathd: sdb: readsector0 checker reports path is down
Jul  6 13:33:11  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:33:11  user.info kernel: mptscsih: ioc1: attempting task abort! (sc=ffff880463a6adc0)
Jul  6 13:33:11  user.info kernel: sd 3:0:1:0: [sdn] CDB: 
Jul  6 13:33:11  user.info kernel: cdb[0]=0x12
Jul  6 13:33:11  user.info kernel: : 12
Jul  6 13:33:11  user.info kernel:  01
Jul  6 13:33:11  user.info kernel:  80 00
Jul  6 13:33:11  user.info kernel:  fe
Jul  6 13:33:11  user.info kernel:  00
Jul  6 13:33:11  user.info kernel: mptscsih: ioc1: task abort: SUCCESS (sc=ffff880463a6adc0)
Jul  6 13:33:19  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:33:19  user.info kernel: mptscsih: ioc1: attempting target reset! (sc=ffff880461f6a280)
Jul  6 13:33:19  user.info kernel: sd 3:0:1:0: CDB: 
Jul  6 13:33:19  user.info kernel: cdb[0]=0x12
Jul  6 13:33:19  user.info kernel: : 12
Jul  6 13:33:19  user.info kernel:  00 00
Jul  6 13:33:19  user.info kernel:  00 24
Jul  6 13:33:19  user.info kernel:  00
Jul  6 13:33:19  user.info kernel: 
Jul  6 13:33:19  user.info kernel: mptscsih: ioc1: target reset: SUCCESS (sc=ffff880461f6a280)
Jul  6 13:33:27  user.info kernel: mptbase: ioc1: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Jul  6 13:33:27  user.info kernel: mptscsih: ioc1: attempting bus reset! (sc=ffff880461f6a280)
Jul  6 13:33:27  user.info kernel: sd 3:0:1:0: CDB: 
Jul  6 13:33:27  user.info kernel: cdb[0]=0x12
Jul  6 13:33:27  user.info kernel: :
Jul  6 13:33:27  user.info kernel:  12
Jul  6 13:33:27  user.info kernel:  00
Jul  6 13:33:27  user.info kernel:  24
Jul  6 13:33:27  user.info kernel:  00
Jul  6 13:33:27  user.info kernel: 
Jul  6 13:33:31  user.info kernel: mptscsih: ioc1: bus reset: SUCCESS (sc=ffff880461f6a280)
Jul  6 13:33:42  user.info kernel: mptbase: ioc1: LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
Jul  6 13:33:42  user.info kernel: mptscsih: ioc1: attempting host reset! (sc=ffff880461f6a280)
Jul  6 13:33:42  user.info kernel: mptsas: ioc1: removing ssp device: fw_channel 0, fw_id 62, phy 1, sas_addr 0x5000c5000d298822
Jul  6 13:33:42  user.debug kernel:  phy-3:2:79: mptsas: ioc1: delete phy 1, phy-obj (0xffff88046de9dc00)
Jul  6 13:33:42  user.debug kernel:  port-3:2:1: mptsas: ioc1: delete port 1, sas_addr (0x5000c5000d298822)
Jul  6 13:33:42  user.notice kernel: sd 3:0:1:0: [sdn] Synchronizing SCSI cache



