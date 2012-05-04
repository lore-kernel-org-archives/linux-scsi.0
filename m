From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/3] Make scsi_free_queue() abort pending requests
Date: Fri, 04 May 2012 15:07:29 +0000
Message-ID: <4FA3F0B1.9040207@acm.org>
References: <4FA3EF10.3040104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:47003 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607Ab2EDPHu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 11:07:50 -0400
In-Reply-To: <4FA3EF10.3040104@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

It is possible that a SCSI LLD invokes scsi_remove_host() after a
request has been queued via scsi_host_template.queuecommand() but
before scsi_done() has been invoked for that request. This may
cause the SCSI error handler to start processing a timeout long
after scsi_remove_host() finished. This may even cause LLD error
handler functions to be invoked after the LLD kernel module has
been removed. Change this behavior such that the SCSI error
handler no longer invokes timeout processing after
scsi_remove_host() finished.

Note: blk_abort_queue() indirectly invokes the SCSI LLD
eh_abort_handler. This patch may cause that abort handler to be
invoked before the SCSI timeout elapsed. Hence follow-up
patches may be necessary to fix race conditions in LLDs that
expect that the abort handler is only invoked after the SCSI
timeout elapsed. Maybe this is why a similar patch has been
reverted about a year ago (see also commit
09c9d4c9b6a2b5909ae3c6265e4cd3820b636863).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Tomas Henzl <thenzl@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/scsi_sysfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f8fc240..a61051d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -963,6 +963,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 * scsi_device_dev_release_usercontext().
 	 */
 	blk_cleanup_queue(q);
+	blk_abort_queue(q);
 
 	if (sdev->is_visible) {
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-- 
1.7.7

