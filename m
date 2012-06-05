From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4 v7] Fixes for SCSI device removal
Date: Tue, 05 Jun 2012 17:08:48 +0000
Message-ID: <4FCE3D20.4000205@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:55467 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2FERIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jun 2012 13:08:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

This is version seven of the SCSI device removal patch series. This
version of this patch series has been tested in the same way as the
previous series: by triggering a large number of removals of a SCSI
device controlled by the ib_srp LLD and also by checking that dm devices
controlled by multipathd still work fine.

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

