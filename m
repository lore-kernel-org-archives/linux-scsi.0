From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/7 v5] More device removal fixes
Date: Fri, 26 Oct 2012 14:00:35 +0200
Message-ID: <508A7B63.60608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:37594 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2JZMAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2012 08:00:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

Fix a few race conditions that can be triggered by removing a device:
- Avoid that request_fn() can be invoked on a dead queue.
- Avoid that blk_cleanup_queue() can finish while request_fn is still
   running.
- Fix a race between starved list processing and device removal.

These patches have been tested on top of kernel v3.7-rc2.

Changes compared to v4:
- Moved queue_flag_set(QUEUE_FLAG_DEAD, q) from blk_drain_queue() into
   blk_cleanup_queue().
- Declared the new __blk_run_queue_uncond() function inline. Checked in
   the generated assembler code that this function is really inlined in
   __blk_run_queue().
- Elaborated several patch descriptions.
- Added sparse annotations to scsi_request_fn().
- Split several patches.

Changes compared to v3:
- Fixed a race condition by setting QUEUE_FLAG_DEAD earlier.
- Added a patch for fixing a race between starved list processing
   and device removal to this series.

Changes compared to v2:
- Split second patch into two patches.
- Refined patch descriptions.

Changes compared to v1:
- Included a patch to rename QUEUE_FLAG_DEAD.
- Refined the descriptions of the __blk_run_queue_uncond() and
   blk_cleanup_queue() functions.

