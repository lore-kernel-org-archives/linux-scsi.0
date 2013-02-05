From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v8 0/10] More device removal fixes
Date: Tue, 05 Feb 2013 13:44:08 +0100
Message-ID: <5110FE98.8030209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:41521 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3BEMoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2013 07:44:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

Fix a few race conditions that can be triggered by removing a device:
- Fix a race between starved list processing and device removal.
- Avoid that a SCSI LLD callback can get invoked after
   scsi_remove_host() finished.
- Speed up device removal by stopping error handling as soon as
   the SHOST_DEL or SHOST_DEL_RECOVERY state has been reached.
- Save and restore the host_scribble field during error handling

These patches have been tested on top of kernel v3.8-rc6 and are also 
available here: 
http://github.com/bvanassche/linux/tree/device-removal-fixes.

Sorry for the delay between v7 and v8 - the past few weeks were really 
hectic.

Changes compared to v7:
- Addressed the review comments posted by Hannes Reinecke and Rolf Eike
   Beer.
- Modified patch "Make scsi_remove_host() wait until error handling
   finished" such that it is also safe for SCSI timeout values below
   the maximum LLD response time by modifying scsi_send_eh_cmnd() such
   that it does not invoke any LLD code after scsi_remove_host() started.
- Added a patch to save and restore the host_scribble field.
- Refined / clarified several patch descriptions.
- Rebased and retested on top of kernel v3.8-rc6.

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
