From: Andy <genanr@emsphone.com>
Subject: qla2xxx UNDERRUNS and failed multipath paths
Date: Tue, 23 Feb 2010 16:39:38 -0600
Message-ID: <20100223223938.GA4612@allantgroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thumper2.emsphone.com ([199.67.51.102]:46872 "EHLO
	thumper2.allantgroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab0BWWw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 17:52:56 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I discovered I was easily able to trigger path failures in kernel 2.6.32.8. 
Since I had known I had not had this problem in the 2.6.27 series kernels, I
bisected between 2.6.27 and 2.6.28 and found that the following commit
causes UNDERRUNS to turn into a serious problem.

2d136938792ba04bf3b6bb2d3a2807dc05c396fc - Additional residual-count
corrections during UNDERRUN handling 

HBA: QLA2460 (ISP2432)
FW: 4.04.05 (486)

I have since tested 2.6.32.8 with and without the patch.

I do have a few systems running kernels that have the patch that run fine,
but most they seem to be using newer HBAs (most qla2560/2562, but one is running
a qla2462 fw:4.04.05 (486)). 

Before the patch I get a bunch of UNDERRUN, but nothing else happens:

Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:3) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:3) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:3) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:3) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x2000 cdb=0x2a os_underflow=0x2000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x40000 cdb=0x28 os_underflow=0x40000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x1000 cdb=0x2a os_underflow=0x1000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x20000 cdb=0x28 os_underflow=0x20000
Feb 23 15:20:03 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:04 linuxdev1 kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:04 linuxdev1 kernel: scsi(4:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:22 linuxdev1 kernel: scsi(3:1:3) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 23 15:20:22 linuxdev1 kernel: scsi(3:1:3) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000

After the patch I get the following:

Feb 22 13:33:06 linuxdev1 kernel: scsi(1:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(1:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: sd 1:0:1:0: [sdg] Unhandled error code
Feb 22 13:33:06 linuxdev1 kernel: sd 1:0:1:0: [sdg] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
Feb 22 13:33:06 linuxdev1 kernel: sd 1:0:1:0: [sdg] CDB: Write(10): 2a 00 00 fa 96 78 00 04 00 00
Feb 22 13:33:06 linuxdev1 kernel: device-mapper: multipath: Failing path 8:96.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:0:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: sd 2:0:1:0: [sdq] Unhandled error code
Feb 22 13:33:06 linuxdev1 kernel: sd 2:0:1:0: [sdq] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
Feb 22 13:33:06 linuxdev1 kernel: sd 2:0:1:0: [sdq] CDB: Write(10): 2a 00 00 fa 9a 78 00 04 00 00
Feb 22 13:33:06 linuxdev1 kernel: device-mapper: multipath: Failing path 65:0.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:06 linuxdev1 kernel: scsi(2:0:0:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:07 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022de74700 from RISC. pid=28547.
Feb 22 13:33:07 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:07 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 6f83 2002.

and eventually...

Feb 22 13:33:13 linuxdev1 kernel: scsi(2:0:1:0) Dropped frame(s) detected (8000 of 8000 bytes)...retrying command.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2:1:0) UNDERRUN status detected 0x15-0x8. resid=0x0 fw_resid=0x80000 cdb=0x2a os_underflow=0x80000
Feb 22 13:33:13 linuxdev1 kernel: scsi(2:0:1:0) Dropped frame(s) detected (80000 of 80000 bytes)...retrying command.
Feb 22 13:33:13 linuxdev1 kernel: sd 2:0:1:0: [sdq] Unhandled error code
Feb 22 13:33:13 linuxdev1 kernel: sd 2:0:1:0: [sdq] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
Feb 22 13:33:13 linuxdev1 kernel: sd 2:0:1:0: [sdq] CDB: Write(10): 2a 00 01 1d 2a a0 00 00 40 00
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff880226cb1d40 from RISC. pid=31189.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 79d5 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022dedc5c0 from RISC. pid=31199.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 79df 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff880226cb1c40 from RISC. pid=31200.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 79e0 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff880226cb1300 from RISC. pid=31202.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 79e2 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868240 from RISC. pid=31291.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a3b 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868b00 from RISC. pid=31292.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a3c 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e8682c0 from RISC. pid=31293.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a3d 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868880 from RISC. pid=31294.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a3e 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868cc0 from RISC. pid=31295.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a3f 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868e00 from RISC. pid=31297.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a41 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868ec0 from RISC. pid=31298.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a42 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868500 from RISC. pid=31299.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a43 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868d80 from RISC. pid=31301.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a45 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868180 from RISC. pid=31303.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a47 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868f80 from RISC. pid=31304.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a48 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868700 from RISC. pid=31305.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a49 2002.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx_eh_abort(2): aborting sp ffff88022e868600 from RISC. pid=31306.
Feb 22 13:33:13 linuxdev1 kernel: scsi(2): ABORT status detected 0x5-0x0.
Feb 22 13:33:13 linuxdev1 kernel: qla2xxx 0000:0e:00.0: scsi(2:1:0): Abort command issued -- 1 7a4a 2002.
Feb 22 13:33:14 linuxdev1 kernel: __ratelimit: 131618 callbacks suppressed
Feb 22 13:33:14 linuxdev1 kernel: lost page write due to I/O error on dm-5

Any ideas why the patch would cause such problems?  Any way to reduce my
underruns?

Thanks,

	Andy
