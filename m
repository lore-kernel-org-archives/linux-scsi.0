From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3 v3] blk_cleanup_queue() versus request_fn order fix
Date: Thu, 27 Sep 2012 18:34:28 +0200
Message-ID: <50648014.7080308@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [178.239.52.149] ([178.239.52.149]:45932 "EHLO wimaserver10.be"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750793Ab2I0Qep (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2012 12:34:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

At device removal time request processing functions like
scsi_request_fn() that unlock the queue lock internally may cause
blk_cleanup_queue() to finish while request_fn is in progress.
This three-patch series makes sure that blk_cleanup_queue() can't
finish before all active request_fn calls have finished and also
that request_fn isn't invoked anymore after queue draining finished.

Changes compared to v2:
- Split second patch into two patches.
- Refined patch descriptions.

Changes compared to v1:
- Included a patch to rename QUEUE_FLAG_DEAD.
- Refined the descriptions of the __blk_run_queue_uncond() and
   blk_cleanup_queue() functions.

