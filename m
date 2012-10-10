From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4 v4] More device removal fixes
Date: Wed, 10 Oct 2012 17:05:34 +0200
Message-ID: <50758EBE.7050202@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:54764 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab2JJPFi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2012 11:05:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

Fix a few race conditions that can be triggered by removing a device:
- Avoid that request_fn() can be invoked on a dead queue.
- Avoid that blk_cleanup_queue() can finish while request_fn is still
   running.
- Fix a race between starved list processing and device removal.

These patches have been tested on top of commit 2474542f - a commit 
between 3.6 and the upcoming 3.7-rc1.

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

-- 
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

