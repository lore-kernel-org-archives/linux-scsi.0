From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4 v10] SCSI device removal fixes
Date: Fri, 29 Jun 2012 15:30:46 +0000
Message-ID: <4FEDCA26.90804@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:38255 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2F2Pav (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jun 2012 11:30:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>, Muthukumar Ratty <muthur@gmail.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tejun Heo <tj@kernel.org>

This is version ten of the SCSI device removal patch series. This
patch series has been tested by triggering a large number of removals of
a SCSI device controlled by the ib_srp LLD and at the same time running
an I/O integrity test with fio on a dm device on top of the SRP SCSI device.

Changes compared to v9:
- Added a patch to the series (3/5).
- Updated patch description of patch 2/5, swapped a kfree() and
  blk_cleanup_queue() call to make the code easier to read and removed
  the BUG_ON(!sdev) statements from that patch.

Changes compared to v8:
- Replaced the block layer patch (1/4) by a more comprehensive patch
  from Muthukumar Ratty.
- Added "Reviewed-by: Mike Christie" in patches 2/4..4/4.

Changes compared to v7:
- Made sure that __scsi_queue_insert() processes the request that has
  been passed to that function. Added a comment in that function too.
- Fixed a typo in the description of the first patch in this series
  and removed "CC: stable".

Changes compared to v6:
- Added a fix for a race in the block layer.
- Moved a BUG_ON(!sdev) statement up since it's a precondition check.
- Changed return type of scsi_queue_insert() from int to void.
- Added a cancel_work_sync(&sdev->requeue_work) call in
  __scsi_remove_device().

Changes compared to v5:
- Removed the function scsi_free_queue() and inlined that function
  in its callers.
- Added two additional patches.
