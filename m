From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: i2o and scsi problem on 64-bit platform
Date: Thu, 01 Apr 2004 23:05:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406C840B.1040809@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.133.118.2] ([213.133.118.2]:63211 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S263168AbUDAVFp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 16:05:45 -0500
Received: from pd95238b5.dip.t-dialin.net ([217.82.56.181] helo=shadowconnect.com)
	by mail.shadowconnect.com with asmtp (TLSv1:AES256-SHA:256)
	(Exim 4.21)
	id 1B99NK-0000kM-RV
	for linux-scsi@vger.kernel.org; Thu, 01 Apr 2004 23:05:25 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

i've got some problems with the i2o subsystem for 2.6 kernel. The 
i2o_scsi driver, which let access to the single disk's via the scsi 
subsystems, works fine on 32-bit systems, but on 64-bit (AMD64), the 
kernel panic...

Here is some logging output, which come from the i2o_scsi driver. On 
32-bit, the following command

dd if=/dev/sda of=/tmp/foo bs=1 count=1

will result in one Scsi_Cmnd. Here is some logging output:

Apr  1 21:27:54 s0001 i2o_scsi_queuecommand()
Apr  1 21:27:54 s0001 queue: id: 1, lun: 0
Apr  1 21:27:54 s0001 qcmd: Tid = 516
Apr  1 21:27:54 s0001 Real scsi messages.
Apr  1 21:27:54 s0001 Scsi_Cmnd add *: id: 0, Ptr:ce1cb080
Apr  1 21:27:54 s0001 use sg for cc378700, 4096 SCpnt->use_sg: 1
Apr  1 21:27:54 s0001 sg_count: 1
Apr  1 21:27:54 s0001 sg_dma_address: 05dc3000
Apr  1 21:27:54 s0001 sg_dma_len(sg): 4096
Apr  1 21:27:54 s0001 READ
Apr  1 21:27:54 s0001 Issued 469
Apr  1 21:27:54 s0001 i2o got a scsi reply 0006C001: <6>m[2]=00000003: 
<6>m[4]=00000000
Apr  1 21:27:54 s0001 Scsi_Cmnd *: id: 0, Ptr: ce1cb080
Apr  1 21:27:54 s0001 Completed 469



but if i run the same command on an 64-bit system, the output looks like:

Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 0, Ptr:000001007bb2b008
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271a60, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b86a000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 89
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 1, Ptr:000001007bb2b208
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271948, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b82e000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Queue depth now 2.
Apr  2 10:49:02 test64 kernel: Issued 90
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 2, Ptr:000001007bb2b408
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271830, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b8c7000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Queue depth now 3.
Apr  2 10:49:02 test64 kernel: Issued 91
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b608
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271718, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b86d000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Queue depth now 4.
Apr  2 10:49:02 test64 kernel: Issued 92
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b608
Apr  2 10:49:02 test64 kernel: Completed 92
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b808
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271600, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b842000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 93
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b808
Apr  2 10:49:02 test64 kernel: Completed 93
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b608
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271718, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b421000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 94
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b608
Apr  2 10:49:02 test64 kernel: Completed 94
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b808
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271600, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b420000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 95
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b808
Apr  2 10:49:02 test64 kernel: Completed 95
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b608
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271718, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b41f000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 96
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b608
Apr  2 10:49:02 test64 kernel: Completed 96
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b808
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271600, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b41e000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 97
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b808
Apr  2 10:49:02 test64 kernel: Completed 97
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b608
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271718, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b41d000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 98
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b608
Apr  2 10:49:02 test64 kernel: Completed 98
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b808
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271600, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b41c000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 99
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b808
Apr  2 10:49:02 test64 kernel: Completed 99
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b608
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271718, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b41b000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 100
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b608
Apr  2 10:49:02 test64 kernel: Completed 100
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b808
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271600, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b41a000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 101
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b808
Apr  2 10:49:02 test64 kernel: Completed 101
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b608
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271718, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b419000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 102
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b608
Apr  2 10:49:02 test64 kernel: Completed 102
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b808
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271600, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b418000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 103
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b808
Apr  2 10:49:02 test64 kernel: Completed 103
Apr  2 10:49:02 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:02 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:02 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:02 test64 kernel: Real scsi messages.
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b608
Apr  2 10:49:02 test64 kernel: use sg for 000001007d271718, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:02 test64 kernel: sg_count: 1
Apr  2 10:49:02 test64 kernel: sg_dma_address: 000000007b417000
Apr  2 10:49:02 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:02 test64 kernel: READ
Apr  2 10:49:02 test64 kernel: Issued 104
Apr  2 10:49:02 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:02 test64 kernel: Scsi_Cmnd *: id: 3, Ptr: 000001007bb2b608
Apr  2 10:49:02 test64 kernel: Completed 104
Apr  2 10:49:32 test64 kernel: i2o_scsi: Aborting command block.
Apr  2 10:49:32 test64 kernel: Scsi_Cmnd add *: id: 3, Ptr:000001007bb2b008
Apr  2 10:49:32 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:32 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:32 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:32 test64 kernel: Real scsi messages.
Apr  2 10:49:32 test64 kernel: Scsi_Cmnd add *: id: 4, Ptr:000001007bb2b008
Apr  2 10:49:32 test64 kernel: non sg for 0000000000000000, 0
Apr  2 10:49:32 test64 kernel: TEST_UNIT_READY
Apr  2 10:49:32 test64 kernel: Issued 89
Apr  2 10:49:32 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=0B00000A
Apr  2 10:49:32 test64 kernel: Scsi_Cmnd *: id: 0, Ptr: 000001007bb2b008
Apr  2 10:49:32 test64 kernel: Completed 89
Apr  2 10:49:32 test64 kernel: SCSI error 0B00000A<4>i2o_scsi: Aborting 
command block.
Apr  2 10:49:32 test64 kernel: Scsi_Cmnd add *: id: 0, Ptr:000001007bb2b208
Apr  2 10:49:32 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:32 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:32 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:32 test64 kernel: Real scsi messages.
Apr  2 10:49:32 test64 kernel: Scsi_Cmnd add *: id: 5, Ptr:000001007bb2b208
Apr  2 10:49:32 test64 kernel: non sg for 0000000000000000, 0
Apr  2 10:49:32 test64 kernel: TEST_UNIT_READY
Apr  2 10:49:32 test64 kernel: Issued 90
Apr  2 10:49:32 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=0B00000A
Apr  2 10:49:32 test64 kernel: Scsi_Cmnd *: id: 0, Ptr: 000001007bb2b208
Apr  2 10:49:32 test64 kernel: Completed 90
Apr  2 10:49:32 test64 kernel: SCSI error 0B00000A<4>i2o_scsi: Aborting 
command block.
Apr  2 10:49:32 test64 kernel: Scsi_Cmnd add *: id: 0, Ptr:000001007bb2b408
Apr  2 10:49:32 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:32 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:32 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:32 test64 kernel: Real scsi messages.
Apr  2 10:49:32 test64 kernel: Scsi_Cmnd add *: id: 6, Ptr:000001007bb2b408
Apr  2 10:49:32 test64 kernel: non sg for 0000000000000000, 0
Apr  2 10:49:32 test64 kernel: TEST_UNIT_READY
Apr  2 10:49:32 test64 kernel: Issued 91
Apr  2 10:49:32 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=0B00000A
Apr  2 10:49:32 test64 kernel: Scsi_Cmnd *: id: 0, Ptr: 000001007bb2b408
Apr  2 10:49:32 test64 kernel: Completed 91
Apr  2 10:49:32 test64 kernel: SCSI error 0B00000A<4>i2o_scsi: 
Attempting to reset the bus.
Apr  2 10:49:32 test64 kernel: i2o got a scsi reply 0005C001: 
<6>m[2]=80000001: <6>m[4]=0B00000A
Apr  2 10:49:32 test64 kernel: i2o_scsi: bus reset completed.
Apr  2 10:49:40 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:40 test64 kernel: Scsi_Cmnd *: id: 5, Ptr: 000001007bb2b208
Apr  2 10:49:40 test64 kernel: Completed 90
Apr  2 10:49:40 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:40 test64 kernel: Scsi_Cmnd *: id: 6, Ptr: 000001007bb2b408
Apr  2 10:49:40 test64 kernel: Completed 91
Apr  2 10:49:42 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:42 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:42 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:42 test64 kernel: Real scsi messages.
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd add *: id: 0, Ptr:000001007bb2b008
Apr  2 10:49:42 test64 kernel: non sg for 0000000000000000, 0
Apr  2 10:49:42 test64 kernel: TEST_UNIT_READY
Apr  2 10:49:42 test64 kernel: Issued 89
Apr  2 10:49:42 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd *: id: 0, Ptr: 000001007bb2b008
Apr  2 10:49:42 test64 kernel: Completed 89
Apr  2 10:49:42 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:42 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:42 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:42 test64 kernel: Real scsi messages.
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd add *: id: 0, Ptr:000001007bb2b208
Apr  2 10:49:42 test64 kernel: non sg for 0000000000000000, 0
Apr  2 10:49:42 test64 kernel: TEST_UNIT_READY
Apr  2 10:49:42 test64 kernel: Issued 90
Apr  2 10:49:42 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd *: id: 0, Ptr: 000001007bb2b208
Apr  2 10:49:42 test64 kernel: Completed 90
Apr  2 10:49:42 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:42 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:42 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:42 test64 kernel: Real scsi messages.
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd add *: id: 0, Ptr:000001007bb2b408
Apr  2 10:49:42 test64 kernel: non sg for 0000000000000000, 0
Apr  2 10:49:42 test64 kernel: TEST_UNIT_READY
Apr  2 10:49:42 test64 kernel: Issued 91
Apr  2 10:49:42 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd *: id: 0, Ptr: 000001007bb2b408
Apr  2 10:49:42 test64 kernel: Completed 91
Apr  2 10:49:42 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:42 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:42 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:42 test64 kernel: Real scsi messages.
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd add *: id: 0, Ptr:000001007bb2b408
Apr  2 10:49:42 test64 kernel: use sg for 000001007d271830, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:42 test64 kernel: sg_count: 1
Apr  2 10:49:42 test64 kernel: sg_dma_address: 000000007b8c7000
Apr  2 10:49:42 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:42 test64 kernel: READ
Apr  2 10:49:42 test64 kernel: Issued 105
Apr  2 10:49:42 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:42 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:42 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:42 test64 kernel: Real scsi messages.
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd add *: id: 5, Ptr:000001007bb2b208
Apr  2 10:49:42 test64 kernel: use sg for 000001007d271948, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:42 test64 kernel: sg_count: 1
Apr  2 10:49:42 test64 kernel: sg_dma_address: 000000007b82e000
Apr  2 10:49:42 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:42 test64 kernel: READ
Apr  2 10:49:42 test64 kernel: Issued 106
Apr  2 10:49:42 test64 kernel: i2o_scsi_queuecommand()
Apr  2 10:49:42 test64 kernel: queue: id: 0, lun: 0
Apr  2 10:49:42 test64 kernel: qcmd: Tid = 515
Apr  2 10:49:42 test64 kernel: Real scsi messages.
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd add *: id: 6, Ptr:000001007bb2b008
Apr  2 10:49:42 test64 kernel: use sg for 000001007d271a60, 4096 
SCpnt->use_sg: 1
Apr  2 10:49:42 test64 kernel: sg_count: 1
Apr  2 10:49:42 test64 kernel: sg_dma_address: 000000007b86a000
Apr  2 10:49:42 test64 kernel: sg_dma_len(sg): 4096
Apr  2 10:49:42 test64 kernel: READ
Apr  2 10:49:42 test64 kernel: Issued 107
Apr  2 10:49:42 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd *: id: 0, Ptr: 000001007bb2b408
Apr  2 10:49:42 test64 kernel: Completed 105
Apr  2 10:49:42 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd *: id: 5, Ptr: 000001007bb2b208
Apr  2 10:49:42 test64 kernel: Completed 106
Apr  2 10:49:42 test64 kernel: i2o got a scsi reply 0006C001: 
<6>m[2]=00000001: <6>m[4]=00000000
Apr  2 10:49:42 test64 kernel: Scsi_Cmnd *: id: 6, Ptr: 000001007bb2b008
Apr  2 10:49:42 test64 kernel: Completed 107


i've hardcoded the sg_tablesize to 1 (because i thought it was the 
source of the problem). But also with sg_tablesize = 4, the first three 
messages disappear some how, and the fourth will be executed... I know 
that the source of the problem is in the i2o_scsi driver, but maybe you 
could help me, why there are so many more Scsi_Cmnd's? Any help, what 
would be very appreciated.


Best regards,



Markus Lidel
