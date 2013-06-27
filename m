From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v12 0/6] SCSI device removal fixes
Date: Thu, 27 Jun 2013 16:51:34 +0200
Message-ID: <51CC5176.90609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:59085 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3F0Ovh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jun 2013 10:51:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>

Fix a few issues related to SCSI device removal:
- Fix a race between starved list processing and device removal that
   can trigger a kernel oops.
- Avoid that __scsi_remove_device() is called twice for the same SCSI
   device, which also can cause a kernel oops.
- Restrict the SCSI device state changes allowed via sysfs.
- Avoid that invoking scsi_device_set_state() triggers a race.
- Avoid re-enabling I/O after the transport layer became offline.

Changes compared to v11:
- Left out a patch that was not a device removal bug fix.
- Left out the patches about which there is not yet an agreement.

Changes compared to v10:
- Rebased and retested on top of Linux kernel v3.10-rc5.

Changes compared to v9:
- Changed one WARN_ON() statement into a WARN() statement.

Changes compared to v8:
- Addressed the feedback from Joe Lawrence - dropped the patch that
   makes scsi_remove_host() wait until the last sdev user is gone.
- Eliminated Scsi_Host.tmf_in_progress since it duplicates state
   information available in Scsi_Host.eh_active.
- Added a patch to avoid reenabling I/O after the transport layer
   became offline.

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

