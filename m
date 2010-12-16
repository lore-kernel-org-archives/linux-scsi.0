From: michaelc@cs.wisc.edu
Subject: [PATCH] SCSI: fix the return value of scsi_target_queue_read()
Date: Thu, 16 Dec 2010 14:26:37 -0600
Message-ID: <1292531197-29689-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab0LPU1M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2010 15:27:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

It seems that zero should be returned if scsi_target_is_busy(starget) is
true, no matter if sdev is on the starved list.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5b6bbae..0ed7a66 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1278,11 +1278,10 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 	}
 
 	if (scsi_target_is_busy(starget)) {
-		if (list_empty(&sdev->starved_entry)) {
+		if (list_empty(&sdev->starved_entry))
 			list_add_tail(&sdev->starved_entry,
 				      &shost->starved_list);
-			return 0;
-		}
+		return 0;
 	}
 
 	/* We're OK to process the command, so we can't be starved */
-- 
1.7.2.3

