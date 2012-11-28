From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/13 v6] More device removal fixes
Date: Wed, 28 Nov 2012 13:39:53 +0100
Message-ID: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:53355 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab2K1Mj5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2012 07:39:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Fix a few race conditions that can be triggered by removing a device:
- Avoid that request_fn() can be invoked on a dead queue.
- Avoid that blk_cleanup_queue() can finish while request_fn is still
   running.
- Fix a race between starved list processing and device removal.
- Avoid that a SCSI LLD callback can be invoked after scsi_remove_host()
   finished.
- Speed up device removal by stopping error handling as soon as
   scsi_remove_host() started.

These patches have been tested on top of kernel v3.7-rc7.

Changes compared to v5:
- Avoid that block layer work can be scheduled on a dead queue.
- Do not invoke any SCSI LLD callback after scsi_remove_host() finished.
- Stop error handling as soon as scsi_remove_host() started.
- Remove the unused function bsg_goose_queue().
- Avoid that scsi_device_set_state() triggers a race condition.

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

