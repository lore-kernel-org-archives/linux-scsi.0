From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v7 0/9] More device removal fixes
Date: Thu, 06 Dec 2012 16:51:10 +0100
Message-ID: <50C0BEEE.4040907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:38338 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422709Ab2LFPvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 10:51:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

Fix a few race conditions that can be triggered by removing a device:
- Fix a race between starved list processing and device removal.
- Avoid that a SCSI LLD callback can get invoked after
   scsi_remove_host() finished.
- Speed up device removal by stopping error handling as soon as
   the SHOST_DEL or SHOST_DEL_RECOVERY state has been reached.

These patches have been tested on top of kernel v3.7-rc7.

Changes compared to v6:
- Dropped the first six patches since Jens queued these for 3.8.
- Added patch to avoid that __scsi_remove_device() is invoked twice.
- Restore error recovery in the SHOST_CANCEL state.

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

