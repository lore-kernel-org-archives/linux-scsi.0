From: Joe Lawrence <jdl1291@gmail.com>
Subject: NULL ptr in =?utf-8?b?c2NzaV9wcmVwX3N0YXRlX2NoZWNr?=
Date: Thu, 3 May 2012 20:22:34 +0000 (UTC)
Message-ID: <loom.20120503T220528-617@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40385 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab2ECUuG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 May 2012 16:50:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1SQ2yR-0006yy-5M
	for linux-scsi@vger.kernel.org; Thu, 03 May 2012 22:50:03 +0200
Received: from rigel.stratus.com ([rigel.stratus.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 03 May 2012 22:50:03 +0200
Received: from jdl1291 by rigel.stratus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 03 May 2012 22:50:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been debugging a NULL pointer crash on USB device removal in 
scsi_prep_state_check() with the following call trace:

PID: 10274  TASK: ffff88024d97f540  CPU: 2   COMMAND: "udisks-daemon"
 #0 [ffff88024d9815b0] machine_kexec at ffffffff8103287b
 #1 [ffff88024d981610] crash_kexec at ffffffff810ba4f2
 #2 [ffff88024d9816e0] oops_end at ffffffff814fe310
 #3 [ffff88024d981710] no_context at ffffffff81043bbb
 #4 [ffff88024d981760] __bad_area_nosemaphore at ffffffff81043e45
 #5 [ffff88024d9817b0] bad_area at ffffffff81043f6e
 #6 [ffff88024d9817e0] __do_page_fault at ffffffff81044673
 #7 [ffff88024d981900] do_page_fault at ffffffff815002ee
 #8 [ffff88024d981930] page_fault at ffffffff814fd6a5
    [exception RIP: scsi_prep_state_check+0xd]
    RIP: ffffffff813686bd  RSP: ffff88024d9819e8  RFLAGS: 00010086
    RAX: ffffffff81369e20  RBX: ffff88027681aa00  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: ffff88027681aa00  RDI: 0000000000000000
    RBP: ffff88024d9819f8   R8: 00000000fffffffe   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000001  R12: ffff8802706c2f20
    R13: ffff8802706c2f20  R14: 0000000000000000  R15: ffffffff8125b430
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #9 [ffff88024d981a00] scsi_setup_blk_pc_cmnd at ffffffff81369ccb
#10 [ffff88024d981a30] scsi_prep_fn at ffffffff81369e6d
#11 [ffff88024d981a50] blk_peek_request at ffffffff812569f7
#12 [ffff88024d981a80] scsi_request_fn at ffffffff81369023
#13 [ffff88024d981ae0] __generic_unplug_device at ffffffff812543d2
#14 [ffff88024d981b00] blk_execute_rq_nowait at ffffffff8125b4fe
#15 [ffff88024d981b40] blk_execute_rq at ffffffff8125b614
#16 [ffff88024d981bf0] scsi_execute at ffffffff8136aa98
#17 [ffff88024d981c40] scsi_execute_req at ffffffff8136ad28
#18 [ffff88024d981cd0] ioctl_internal_command.clone.0 at ffffffff813637c8
#19 [ffff88024d981d40] scsi_set_medium_removal at ffffffff8136398e
#20 [ffff88024d981d80] sr_lock_door at ffffffffa01156c0 [sr_mod]
#21 [ffff88024d981d90] cdrom_release at ffffffffa027237c [cdrom]
#22 [ffff88024d981e10] sr_block_release at ffffffffa011450e [sr_mod]
#23 [ffff88024d981e30] __blkdev_put at ffffffff811b40a6
#24 [ffff88024d981e80] blkdev_put at ffffffff811b40c0
#25 [ffff88024d981e90] blkdev_close at ffffffff811b4103
#26 [ffff88024d981ec0] __fput at ffffffff8117c205
#27 [ffff88024d981f10] fput at ffffffff8117c345
#28 [ffff88024d981f20] filp_close at ffffffff81177d7d
#29 [ffff88024d981f50] sys_close at ffffffff81177e55
#30 [ffff88024d981f80] tracesys at ffffffff8100b308 (via system_call)
    RIP: 0000003cb180e590  RSP: 00007fff2fe82b98  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: ffffffff8100b308  RCX: ffffffffffffffff
    RDX: 0000000000000007  RSI: 0000000000000880  RDI: 0000000000000005
    RBP: 0000000000000000   R8: 0000000000434589   R9: 0000000000000000
    R10: 0000000000000001  R11: 0000000000000246  R12: 0000000001796230
    R13: 0000000000000001  R14: 00000000017976b0  R15: 00000000017957d0
    ORIG_RAX: 0000000000000003  CS: 0033  SS: 002b

It looks like sdev (RDI) is NULL on the call to scsi_prep_state_check():

int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
{
        struct scsi_cmnd *cmd;
        int ret = scsi_prep_state_check(sdev, req);
        ...

I've been able to trace a possible cause to another thread that is removing this 
device from its bus:

PID: 43     TASK: ffff88027a7b2ae0  CPU: 0   COMMAND: "khubd"
    [exception RIP: _spin_lock_irq+0x25]
    RIP: ffffffff814fd0c5  RSP: ffff88027a7b9ab0  RFLAGS: 00000097
    RAX: 0000000000000cac  RBX: ffff8802706c2f20  RCX: 0000000000000082
    RDX: 0000000000000cab  RSI: ffff880278973540  RDI: ffff8802706c3238
    RBP: ffff88027a7b9ab0   R8: ffff88027a7b8000   R9: 00000000ffffffff
    R10: 0000000000000000  R11: 0000000000000001  R12: ffff8802706c37d8
    R13: ffff8802706c3238  R14: ffffffffa0223f08  R15: 0000000000000000
    CS: 0010  SS: 0018
 #0 [ffff88027a7b9ab8] blk_cleanup_queue at ffffffff8125621b
 #1 [ffff88027a7b9ae8] scsi_free_queue at ffffffff81368caf
 #2 [ffff88027a7b9b08] __scsi_remove_device at ffffffff8136f32c
 #3 [ffff88027a7b9b28] scsi_forget_host at ffffffff8136b6d4
 #4 [ffff88027a7b9b48] scsi_remove_host at ffffffff81363227
 #5 [ffff88027a7b9b78] quiesce_and_remove_host at ffffffffa022037b [usb_storage]
 #6 [ffff88027a7b9ba8] usb_stor_disconnect at ffffffffa02204b2 [usb_storage]
 #7 [ffff88027a7b9bc8] usb_unbind_interface at ffffffff813abb0d
 #8 [ffff88027a7b9c18] __device_release_driver at ffffffff8134e25f
 #9 [ffff88027a7b9c38] device_release_driver at ffffffff8134e3cd
#10 [ffff88027a7b9c58] bus_remove_device at ffffffff8134d263
#11 [ffff88027a7b9c88] device_del at ffffffff8134aead
#12 [ffff88027a7b9cb8] usb_disable_device at ffffffff813a79f0
#13 [ffff88027a7b9d18] usb_disconnect at ffffffff8139ed78
#14 [ffff88027a7b9d68] hub_thread at ffffffff813a04ec
#15 [ffff88027a7b9ee8] kthread at ffffffff81091c26
#16 [ffff88027a7b9f48] kernel_thread at ffffffff8100c14a

Interestingly, PID 43 has asynchronously set the request_queue's QUEUE_FLAG_DEAD 
(and other possible consequences) outside the queue lock.  PID 10274 and all the 
callers of blk_queue_dead() do not guard against this scenario, even if they 
grab the lock.

This bug looks like the one(s) Bart Van Assche has been hunting down recently:

http://thread.gmane.org/gmane.linux.scsi/74525
http://thread.gmane.org/gmane.linux.scsi/71496

I have kdump vmcore files and a fairly reproducible test scenario that 
reproduces this on RHEL 6.3 Beta 1.  From looking at the crash, I can verify 
that the request queue in question has been marked QUEUE_FLAG_DEAD and that 
blk_cleanup_queue() is waiting on the queue lock to continue.

If patches have been committed (or still need testing), I can give them a spin 
on our config.  If any additional debug or info from the crash would help, I 
would be happy to provide.

Regards,

-- Joe Lawrence
   Stratus Technologies


