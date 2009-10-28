From: Michael Reed <mdr@sgi.com>
Subject: 2.6.31 - scsi scanning / target deletion deadlock
Date: Wed, 28 Oct 2009 15:18:22 -0500
Message-ID: <4AE8A70E.9070504@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:43305 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755060AbZJ1USS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Oct 2009 16:18:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Smart <James.Smart@Emulex.Com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jeremy Higdon <jeremy@sgi.com>

Hi All,

I encountered the following deadlock on the Scsi_Host's scan_lock.
Target device glitches have caused the qla2xxx driver to delete and
later attempt to re-add a scsi device.  (Sorry, I cannot present the
exact sequence of events.)

scsi_wq_3 is executing a scan on host 3, holds host's scan_lock.
   i/o has been queued to target3:0:0, on rport 0xe00000b0f02d6c20.

qla2xxx_3_dpc is changing rport roles on rport 0xe00000b0f02d6c20.  Until
  this completes, the work on scsi_wq_3 cannot progress.  The change in
  rport roles results in a call to flush target delete work on fc_wq_3.

fc_wq_3 is trying to remove scsi target 0xe0000030f5e86488 on rport 0xe0000030f1f432d0
  and needs to acquire the scan_lock held by scsi_wq_3.  

Perhaps the granularity of scan_lock is too great?

Would anyone have any thoughts on how best to eliminate this deadlock?

Thanks,
 Mike



[0]kdb> btp 3790
Stack traceback for pid 3790
0xe0000034f5d30000     3790        2  0    1   D  0xe0000034f5d30570  fc_wq_3
0xa0000001007280a0 schedule+0x14e0
        args (0x4000, 0x0, 0x0, 0xa000000100729720, 0x813, 0xe0000034f5d3fdb0, 0x1111111111111111, 0x0, 0x1010095a6000)
0xa000000100729840 __mutex_lock_slowpath+0x320
        args (0xe0000034f4f24cf0, 0xe0000034f5d30000, 0x10095a6010, 0xe0000034f4f24cf4, 0xe0000034f4f24cf8, 0xa0000001011c2600, 0xa0000001011c1cb0, 0x7ffff00)
0xa000000100729ad0 mutex_lock+0x30
        args (0xe0000034f4f24d08, 0xa000000100471d30, 0x286, 0x10095a6010)
0xa000000100471d30 scsi_remove_device+0x30
        args (0xe0000030f5ea57a8, 0xe0000034f4f24cf0, 0xa000000100471f40, 0x48b, 0xe0000034f4f24c90)
0xa000000100471f40 __scsi_remove_target+0x180
        args (0xe0000030f5e86488, 0xe0000030f5ea57a8, 0xe0000034f4f24c90, 0xe0000034f4f24ce8, 0xe0000030f5e865f0, 0xe0000030f5e865ec, 0xa000000100472120, 0x205, 0xa00000010096c950)
0xa000000100472120 __remove_child+0x40
        args (0xe0000030f5e864b0, 0xa0000001004152c0, 0x389, 0x0)
0xa0000001004152c0 device_for_each_child+0x80
        args (0xe0000030f1f43338, 0x0, 0xa00000010096c200, 0x0, 0xa0000001004720b0, 0x288, 0xa0000001013a6540)
0xa0000001004720b0 scsi_remove_target+0x90
        args (0xe0000030f1f43330, 0xe0000030f1f43330, 0xa000000100485630, 0x205, 0xa0000001013a6540)
0xa000000100485630 fc_starget_delete+0x30
        args (0xe0000030f1f43528, 0xa0000001000cbd00, 0x50e, 0xa0000001000cbb80)
0xa0000001000cbd00 worker_thread+0x2a0
        args (0xe0000034f7f1b098, 0xa00000010096cec0, 0xe0000034f7f1b0a0, 0xe0000034f7f1b0c8, 0xe0000034f7f1b0a0, 0xe0000034f7f1b0b0, 0xffffffffbfffffff, 0xa0000001000d5bb0, 0x389)
0xa0000001000d5bb0 kthread+0x110
        args (0xe00000b073a1fcf8, 0xe0000034f5d3fe18, 0xe0000034f7f1b098, 0xa00000010096f650, 0xa000000100014a30, 0x286, 0xa0000001013a6540)
0xa000000100014a30 kernel_thread_helper+0xd0
        args (0xa00000010096ffd0, 0xe00000b073a1fcf8, 0xa00000010000a4c0, 0x2, 0xa0000001013a6540)
0xa00000010000a4c0 start_kernel_thread+0x20
        args (0xa00000010096ffd0, 0xe00000b073a1fcf8)




[0]kdb> btp 3789
Stack traceback for pid 3789
0xe0000034f5b50000     3789        2  0    1   D  0xe0000034f5b50570  scsi_wq_3
0xa0000001007280a0 schedule+0x14e0
        args (0xe0000034f4ec7008, 0xe0000034f4f24d70, 0xe0000034f4ec6fe8, 0xe0000034f3669508, 0xe0000034f3669500, 0xe0000034f3669508, 0xe0000034f36694f8, 0xa0000001011c2cd0, 0x1010095a6000)
0xa000000100728640 schedule_timeout+0x40
        args (0x7fffffffffffffff, 0x0, 0x0, 0xe0000034f64a6928, 0xa000000100726840, 0x50d, 0xe0000034f4ec7000)
0xa000000100726840 wait_for_common+0x1a0
        args (0xe0000034f5b5fce0, 0x7fffffffffffffff, 0x2, 0xe0000034f5b5fce8, 0xe0000034f5b50000, 0xe0000034f5b5fce8, 0xa000000100726ba0, 0x207, 0xa0000001013a6540)
0xa000000100726ba0 wait_for_completion+0x40
        args (0xe0000034f5b5fce0, 0xa0000001002b8460, 0x48e, 0x1)
0xa0000001002b8460 blk_execute_rq+0x140
        args (0xe0000034f36692d0, 0x0, 0xe000003441024250, 0x1, 0xa0000001002b7b60, 0xe000003441024360, 0xa0000001002b8510, 0x38b, 0xe000003441024300)
0xa0000001002b8510 scsi_execute_rq+0x30
        args (0xe0000034f36692d0, 0xe0000034f4ec6fb8, 0xe000003441024250, 0x1, 0xa000000100469050, 0x713, 0x713)
0xa000000100469050 scsi_execute+0x190
        args (0xe0000034f4ec6fb8, 0xe000003441024250, 0xe0000034f03ec500, 0x1000, 0xe000003440f3e278, 0x5dc, 0x3, 0x4000000)
0xa000000100469200 scsi_execute_req+0xe0
        args (0xe0000034f4ec6fb8, 0xe0000034f5b5fd8c, 0x2, 0xe0000034f03ec500, 0x1000, 0xe0000034f5b5fd84, 0x5dc, 0x3, 0xe000003440f3e278)
0xa00000010046da70 __scsi_scan_target+0x530
        args (0x0, 0x0, 0x1000, 0xe0000034f03ec500, 0x1, 0xe0000034f4ec6fb8, 0xe0000030f14b55e0, 0xa0000001011c2cd0, 0xe0000034f5b5fd70)
0xa00000010046f000 scsi_scan_target+0x120
        args (0xe00000b0f02d6c80, 0x0, 0x0, 0xffffffffffffffff, 0x1, 0xe0000034f4f24c90, 0xe0000034f4f24cf0, 0xa000000100485c20, 0x28a)
0xa000000100485c20 fc_scsi_scan_rport+0x140
        args (0xe00000b0f02d6c20, 0xe0000034f4f24ce8, 0xa0000001000cbd00, 0x50e, 0x50e)
0xa0000001000cbd00 worker_thread+0x2a0
        args (0xe0000034f7f1ada0, 0xa00000010096ceb0, 0xe0000034f7f1ada8, 0xe0000034f7f1add0, 0xe0000034f7f1ada8, 0xe0000034f7f1adb8, 0xffffffffbfffffff, 0xa0000001000d5bb0, 0x389)
0xa0000001000d5bb0 kthread+0x110
        args (0xe00000b073a1fd18, 0xe0000034f5b5fe18, 0xe0000034f7f1ada0, 0xa00000010096f650, 0xa000000100014a30, 0x286, 0xa0000001013a6540)
0xa000000100014a30 kernel_thread_helper+0xd0
        args (0xa00000010096ffd0, 0xe00000b073a1fd18, 0xa00000010000a4c0, 0x2, 0xa0000001013a6540)
0xa00000010000a4c0 start_kernel_thread+0x20
        args (0xa00000010096ffd0, 0xe00000b073a1fd18)




[0]kdb> btp 3788
Stack traceback for pid 3788
0xe0000034f3e40000     3788        2  0    0   D  0xe0000034f3e40570  qla2xxx_3_dpc
0xa0000001007280a0 schedule+0x14e0
        args (0x0, 0x1, 0xf, 0x43, 0xa000000100f6d300, 0x0, 0x0, 0xa0000001011e5c80, 0x1010095a6000)
0xa000000100728640 schedule_timeout+0x40
        args (0x7fffffffffffffff, 0x0, 0x0, 0xa0000001000cc150, 0xa000000100726840, 0x50d, 0xe0000034f7f1b0b0)
0xa000000100726840 wait_for_common+0x1a0
        args (0xe0000034f3e4fd00, 0x7fffffffffffffff, 0x2, 0xe0000034f3e4fd08, 0xe0000034f3e40000, 0xe0000034f3e4fd08, 0xa000000100726ba0, 0x207, 0xe0000034f7f1b0b0)
0xa000000100726ba0 wait_for_completion+0x40
        args (0xe0000034f3e4fd00, 0xa0000001000cc390, 0x288, 0xa0000001000cc350)
0xa0000001000cc390 flush_cpu_workqueue+0x110
        args (0xe0000034f7f1b098, 0x1, 0xa0000001000cc750, 0x38a, 0xe0000034f7f1b458)
0xa0000001000cc750 flush_workqueue+0x90
        args (0xe0000034f5c68140, 0x0, 0xa0000001007c13a8, 0xa000000100bd0200, 0xa000000100483850, 0x206, 0x4000)
0xa000000100483850 fc_flush_work+0xb0
        args (0xe0000034f4f24c90, 0xa000000100483b70, 0x48b, 0xe0000034f4f24ce0)
0xa000000100483b70 fc_remote_port_rolechg+0x2f0
        args (0xe00000b0f02d6c20, 0x1, 0xe00000b0f02d6c68, 0xe0000034f4f24ce8, 0xe0000030f442a608, 0xe0000034f4f24c90, 0xa000000206fdfa20, 0x38f, 0xe0000034f7d4d0c8)
0xa000000206fdfa20 [qla2xxx]qla2x00_update_fcport+0x880
        args (0xe00000b0f02d6c20, 0xe0000030f442a5b0, 0xe0000034f62131c8, 0xe0000030f442a5c0, 0xa000000206fdfc00, 0x38c, 0xa00000020700d058)
0xa000000206fdfc00 [qla2xxx]qla2x00_fabric_dev_login+0x160
        args (0xe0000034f4f250a8, 0xe0000030f442a5b0, 0x0, 0xe0000034f62131c8, 0xa000000206fe2900, 0x1634, 0xa00000020700d058)
0xa000000206fe2900 [qla2xxx]qla2x00_configure_loop+0x2cc0
        args (0xe0000034f4f250a8, 0xe0000030f442a5b0, 0xe0000034f4f251a4, 0xe0000034f3e4fd88, 0x300000000, 0x0, 0x1000, 0xe0000034f4f25108, 0xe000003440efdda2)
0xa000000206fe32b0 [qla2xxx]qla2x00_loop_resync+0x1b0
        args (0xe0000034f4f250a8, 0xe0000034f4f25108, 0x0, 0xfe, 0xe0000034f56dc000, 0xe0000034f4f251a4, 0xe0000034f4f2511c, 0xe0000034f4f25104, 0xe0000034f7f1bab0)
0xa000000206fd6d40 [qla2xxx]qla2x00_do_dpc+0x9a0
        args (0xe0000034f62131c8, 0x1, 0xe0000034f3e4fe00, 0xe0000034f4f25108, 0xe0000034f4f250a8, 0xe0000034f3e4fe00, 0xe0000034f4f250e8, 0xa000000207048958, 0xe0000034f4f250c8)
0xa0000001000d5bb0 kthread+0x110
        args (0xe00000b073a1fd28, 0xe0000034f3e4fe18, 0xe0000034f62131c8, 0xa00000020703cfd8, 0xa000000100014a30, 0x286, 0xa0000001013a6540)
0xa000000100014a30 kernel_thread_helper+0xd0
        args (0xa00000010096ffd0, 0xe00000b073a1fd28, 0xa00000010000a4c0, 0x2, 0xa0000001013a6540)
0xa00000010000a4c0 start_kernel_thread+0x20
        args (0xa00000010096ffd0, 0xe00000b073a1fd28)
