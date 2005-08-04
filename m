From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: calling scsi_adjust_queue_depth() during I/O...
Date: Thu, 4 Aug 2005 16:41:55 -0700
Message-ID: <20050804234155.GJ13374@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:42575 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262730AbVHDXl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2005 19:41:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

All,

While adding support for the new change_queue_depth/type() callbacks,

	static int
	qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth)
	{
		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
		return sdev->queue_depth;
	}

and updating the queue-depth:

	# echo 16 > /sys/class/scsi_device/3:0:0:0/device/queue_depth

while I/O is running, I'm hitting a reproducible WARN_ON() triggering
within as_completed_request():

	static void as_completed_request(request_queue_t *q, struct request *rq)
	{
		struct as_data *ad = q->elevator->elevator_data;
		struct as_rq *arq = RQ_DATA(rq);

		WARN_ON(!list_empty(&rq->queuelist));
		...

and a subsequent panic:

	Badness in as_completed_request at drivers/block/as-iosched.c:951

	Call Trace: <IRQ> ffff8024883a>{as_completed_request+63} <ffffffff8024098d>{elv_completed_request+44}
	       <ffffffff8024272a>{__blk_put_request+73} <ffffffff80280781>{scsi_end_request+164}
	       <ffffffff802809eb>{scsi_io_completion+584} <ffffffff80297059>{sd_rw_intr+709}
	       <ffffffff8027aa08>{scsi_finish_command+182} <ffffffff8027b2dc>{scsi_softirq+255}
	       <ffffffff801291ea>{__do_softirq+110} <ffffffff8010eb13>{call_softirq+31}
	       <ffffffff801101be>{do_softirq+54} <ffffffff80110211>{do_IRQ+74}
	       <ffffffff8010deba>{ret_from_intr+0}  <EOI> <ffffffff8010c2fd>{mwait_idle+86}
	       <ffffffff8021aef0>{acpi_processor_idle+310} <ffffffff8010cacb>{cpu_idle+79}
	       <ffffffff804cecbf>{start_secondary+1017}
	----------- [cut here ] --------- [please bite here ] ---------
	Kernel BUG at "drivers/block/ll_rw_blk.c":2361
	invalid operand: 0000 [1] SMP
	CPU 2
	Modules linked in: qla2xxx
	Pid: 0, comm: swapper Not tainted 2.6.13-rc5
	RIP: 0010:[<ffffffff80242734>] <ffffffff80242734>{__blk_put_request+83}
	RSP: 0018:ffff8100021bbde8  EFLAGS: 00010087
	RAX: 0000000000000000 RBX: ffff81002dc738b0 RCX: 0000000000008000
	RDX: 0000000000004e6b RSI: 0000000000000004 RDI: ffff81003e091778
	RBP: ffff81003f8fa600 R08: 0000000000000000 R09: 0000000000000003
	R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
	R13: 0000000000000001 R14: ffff81003f8fa600 R15: ffff81003f8fa600
	FS:  0000000000000000(0000) GS:ffffffff804b6900(0000) knlGS:0000000000000000
	CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
	CR2: 00002aaaaaac1000 CR3: 0000000037f05000 CR4: 00000000000006e0
	Process swapper (pid: 0, threadinfo ffff8100021b6000, task ffff8100021b54f0)
	Stack: ffff81002dc738b0 ffff81002c1cd7c0 0000000000000286 ffffffff80280781
	       0000000000000001 ffff81002c1cd7c0 ffff81002dc738b0 0000000000000000
	       0000000000080000 ffffffff802809eb
	Call Trace: <IRQ> <ffffffff80280781>{scsi_end_request+164} <ffffffff802809eb>{scsi_io_completion+584}
	       <ffffffff80297059>{sd_rw_intr+709} <ffffffff8027aa08>{scsi_finish_command+182}
	       <ffffffff8027b2dc>{scsi_softirq+255} <ffffffff801291ea>{__do_softirq+110}
	       <ffffffff8010eb13>{call_softirq+31} <ffffffff801101be>{do_softirq+54}
	       <ffffffff80110211>{do_IRQ+74} <ffffffff8010deba>{ret_from_intr+0}
		<EOI> <ffffffff8010c2fd>{mwait_idle+86} <ffffffff8021aef0>{acpi_processor_idle+310}
	       <ffffffff8010cacb>{cpu_idle+79} <ffffffff804cecbf>{start_secondary+1017}

	Code: 0f 0b a3 0b f2 32 80 ff ff ff ff c2 39 09 48 89 de 48 89 ef
	RIP <ffffffff80242734>{__blk_put_request+83} RSP <ffff8100021bbde8>
	 <3>Debug: sleeping function called from invalid context at include/linux/rwsem.h:43
	in_atomic():1, irqs_disabled():1

	Call Trace: <IRQ> <ffffffff8011e2d7>{__might_sleep+199} <ffffffff80125316>{profile_task_exit+34}
	       <ffffffff80126fe2>{do_exit+34} <ffffffff801fc7d0>{vgacon_cursor+231}
	       <ffffffff8010f653>{kernel_math_error+0} <ffffffff8010fa09>{do_trap+264}
	       <ffffffff8010feb9>{do_invalid_op+145} <ffffffff80242734>{__blk_put_request+83}
	       <ffffffff801245d7>{printk+141} <ffffffff8010e415>{error_exit+0}
	       <ffffffff80242734>{__blk_put_request+83} <ffffffff8024272a>{__blk_put_request+73}
	       <ffffffff80280781>{scsi_end_request+164} <ffffffff802809eb>{scsi_io_completion+584}
	       <ffffffff80297059>{sd_rw_intr+709} <ffffffff8027aa08>{scsi_finish_command+182}
	       <ffffffff8027b2dc>{scsi_softirq+255} <ffffffff801291ea>{__do_softirq+110}
	       <ffffffff8010eb13>{call_softirq+31} <ffffffff801101be>{do_softirq+54}
	       <ffffffff80110211>{do_IRQ+74} <ffffffff8010deba>{ret_from_intr+0}
		<EOI> <ffffffff8010c2fd>{mwait_idle+86} <ffffffff8021aef0>{acpi_processor_idle+310}
	       <ffffffff8010cacb>{cpu_idle+79} <ffffffff804cecbf>{start_secondary+1017}

	Kernel panic - not syncing: Aiee, killing interrupt handler!

Adding scsi_target_quiesce() and scsi_target_resume() barriers around
the scsi_adjust_target_queue_depth() call appears to help (i.e.
dropping from 32 -> 24):

	# echo 24 > /sys/class/scsi_device/3\:0\:0\:0/device/queue_depth

and dropping down again to 16:

	# echo 16 > /sys/class/scsi_device/3\:0\:0\:0/device/queue_depth

but occasionally, while trying another depth drop:

	# echo 10 > /sys/class/scsi_device/3\:0\:0\:0/device/queue_depth

I'll either get a panic (haven't captured a good one yet (only a
couple of line within the trace):

	eip: ffffffff80248a62
	----------- [cut here ] --------- [please bite here ] ---------
	Kernel BUG at "include/asm/spinlock.h":121

or I get the following slab-error:

	slab error in cache_free_debugcheck(): cache `size-128': double free, or memory outside object was overwritten

	Call Trace:<ffffffff8014930c>{cache_free_debugcheck+290} <ffffffff8014975c>{kfree+136}
	       <ffffffff80244e65>{blk_queue_resize_tags+119} <ffffffff8027a826>{scsi_adjust_queue_depth+68}
	       <ffffffff88000133>{:qla2xxx:qla2x00_change_queue_depth+71}
	       <ffffffff80283666>{sdev_store_queue_depth_rw+82} <ffffffff8023a9a2>{dev_attr_store+31}
	       <ffffffff80191e95>{sysfs_write_file+200} <ffffffff80160dba>{vfs_write+172}
	       <ffffffff80160ed8>{sys_write+69} <ffffffff8010d8f6>{system_call+126}

	ffff8100389baba8: redzone 1: 0x170fc2a5, redzone 2: 0x0.

I'm using a fairly recent snapshot of Linus' GIT tree (sync done
earlier today).

Two questions:

 - must the target be quiesced before adjusting the queue-depth?

 - any ideas on where why successive lowering of the depth borks the
   machine?

Thanks,
Andrew Vasquez
