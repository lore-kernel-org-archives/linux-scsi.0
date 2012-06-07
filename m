From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4 v8] Fixes for SCSI device removal
Date: Thu, 07 Jun 2012 18:39:20 +0000
Message-ID: <4FD0F558.6090801@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:47868 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2FGSjZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jun 2012 14:39:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tejun Heo <tj@kernel.org>

This is version eight of the SCSI device removal patch series. This
version of this patch series has been tested by triggering a large
number of removals of a SCSI device controlled by the ib_srp LLD and at
the same time running an I/O integrity test with fio on a dm device on
top of the SRP SCSI device.

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
