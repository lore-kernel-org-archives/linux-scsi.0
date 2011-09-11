From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: 3.1.0-rc4: oops at elv_put_request()
Date: Mon, 12 Sep 2011 00:36:35 +0300
Message-ID: <20110911213634.GA3065@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59910 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab1IKVgk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2011 17:36:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, jbottomley@parallels.com, torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Caught this one, there was no real load at the moment.
FWIW, setup is ext4 over RAID-6 across 4 disks.

	elv_put_request
	__blk_put_request
	blk_put_request
	scsi_execute
	scsi_execute_req
	scsi_test_unit_ready
	sd_check_events
	disk_events_workfn
	process_one_work
	worker_thread
	kthread
	kernel_thread_helper

$ addr2line -e vmlinux 0xffffffff811bcbbb
block/elevator.c:772

   768	void elv_put_request(struct request_queue *q, struct request *rq)
   769	{
   770		struct elevator_queue *e = q->elevator;
   771	
   772	===>	if (e->ops->elevator_put_req_fn)	<===
   773			e->ops->elevator_put_req_fn(rq);
   774	}
