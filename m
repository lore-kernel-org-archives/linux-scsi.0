From: Keith Owens <kaos@sgi.com>
Subject: devlabel/scsi_unique_id hang in 2.6.8
Date: Fri, 20 Aug 2004 17:23:00 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <12108.1092986580@kao2.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:31720 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S262406AbUHTHXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 03:23:14 -0400
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by omx3.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with SMTP id i7K6ZdNB024950
	for <@external-mail-relay.sgi.com:linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 23:35:40 -0700
Received: from kao2.melbourne.sgi.com (kao2.melbourne.sgi.com [134.14.55.180]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA04042 for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2004 17:23:09 +1000
Received: from kao2.melbourne.sgi.com (localhost [127.0.0.1])
	by kao2.melbourne.sgi.com (Postfix) with ESMTP id 3C37C140115
	for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2004 17:23:01 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

cc: me please, I am not on this list.

scsi_unique_id is hanging in 2.6.8 on fibre channel, running on both
ia64 and i386.  It works fine with devices on a qla1280, it hangs with
devices on qla2300.  2.6.8 dmesg extract.

scsi1 : qla2xxx
qla2300 0000:03:01.0: 
 QLogic Fibre Channel HBA Driver: 8.00.00b14-k
  QLogic QLA2310 - 
  ISP2300: PCI-X (66 MHz) @ 0000:03:01.0 hdma+, host#=1, fw=3.02.30 IPX
  Vendor: SGI       Model: TP9500            Rev: 0530
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:03:01.0: scsi(1:0:0:0): Enabled tagged queuing, queue depth 32.
  Vendor: SGI       Model: TP9500            Rev: 0530
  Type:   Direct-Access                      ANSI SCSI revision: 03

....

SCSI device sdc: 570425344 512-byte hdwr sectors (292058 MB)
SCSI device sdc: drive cache: write back
 sdc: sdc1 sdc2
Attached scsi disk sdc at scsi1, channel 0, id 0, lun 0

2.6.8 .config extract

CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA2XXX=y
# CONFIG_SCSI_QLA21XX is not set
CONFIG_SCSI_QLA22XX=y
CONFIG_SCSI_QLA2300=y
CONFIG_SCSI_QLA2322=y
CONFIG_SCSI_QLA6312=y
CONFIG_SCSI_QLA6322=y

devlabel calls scsi_unique_id, scsi_unique_id issues ioctl(FIBMAP)
which hangs in the kernel in D state.  kdb backtrace on ia64 shows

Stack traceback for pid 4082
0xe000013013c00000     4082        1  0    3   D  0xe000013013c004d0  scsi_unique_id
0xa00000010075a6f0 schedule+0xcd0
        args (0xa0000001008327c8, 0x9a5, 0xa00000010075acd0, 0x389, 0xe00001300778d2a0)
0xa00000010075ae90 wait_for_completion+0x1f0
        args (0xe000013013c07c50, 0x0, 0x2, 0xe000013013c07c08, 0xe000013013c07c10)
0xa0000001004b8840 blk_execute_rq+0x1a0
        args (0xe00001b07bb9d1b8, 0xe000013007729dc0, 0xe00001307bace920, 0xe00001307bace9d8, 0xa0000001004c27d0)
0xa0000001004c27d0 sg_scsi_ioctl+0x5f0
        args (0xe00001307bace930, 0x400, 0x0, 0x9fffffffffffffff, 0xe00001307bacea08)
0xa0000001004c2b20 scsi_cmd_ioctl+0x160
        args (0xe00001301047ab28, 0xe000013007729dc0, 0xffffffffffffffea, 0x6000000000004010, 0xe00001b07bb9d1b8)
0xa0000001005bc520 sd_ioctl+0xe0
        args (0xe00001307bf0fd00, 0x6000000000004010, 0x1, 0x6000000000004010, 0xe00001300778d270)
0xa0000001004bdb00 blkdev_ioctl+0x140
        args (0xa000000100d31520, 0xe00001301047ab28, 0x1, 0x6000000000004010, 0x6000000000004000)
0xa00000010017c5a0 block_ioctl+0x40
        args (0xe00001b005b6a428, 0xe00001301047ab28, 0x1, 0x6000000000004010, 0xa000000100195eb0)
0xa000000100195eb0 sys_ioctl+0x2b0
        args (0x3, 0x1, 0x6000000000004010, 0x0, 0x0)
0xa0000001000120e0 ia64_ret_from_syscall
        args (0x3, 0x1, 0x6000000000004010)

The exact same hardware works fine on 2.4 kernels, because 2.4 does not
support ioctl(0x5386) (SCSI_IOCTL_GET_BUS_NUMBER) on qla2300.

strace of scsi_unique_id /dev/sdc on 2.4 kernel.  Does nothing useful.

1905  open("/dev/sdc", O_RDWR)          = 3
1905  fstat(3, {st_mode=S_IFBLK|0640, st_rdev=makedev(4, 32), ...}) = 0
1905  ioctl(3, 0x5386, 0x60000fffffff9ec0) = -1 EINVAL (Invalid argument)
1905  write(2, "/usr/bin/scsi_unique_id: Unknown"..., 53) = 53

strace of scsi_unique_id /dev/sdc on 2.6.8 kernel.

4190  open("/dev/sdc", O_RDWR)          = 3
4190  fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 32), ...}) = 0
4190  ioctl(3, 0x5386, 0x60000fffffffb500) = 0
4190  brk(0)                            = 0x6000000000004000
4190  mmap(NULL, 1048576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x20000000002c8000
4190  ioctl(3, FIBMAP

ioctl(FIBMAP) never returns from the kernel.

