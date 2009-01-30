From: michaelc@cs.wisc.edu
Subject: [PATCH 3/3] scsi dh alua: handle report luns data changed in check sense callout
Date: Fri, 30 Jan 2009 17:00:11 -0600
Message-ID: <12333564123194-git-send-email-michaelc@cs.wisc.edu>
References: <12333564114078-git-send-email-michaelc@cs.wisc.edu>
 <12333564124151-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53960 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbZA3XAQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2009 18:00:16 -0500
In-Reply-To: <12333564124151-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ilgu Hong <ilgu.hong@promise.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Ilgu Hong <ilgu.hong@promise.com>

When we switch controllers the Intel Multi-Flex reports
REPORTED_LUNS_DATA_HAS_CHANGED. This patch just has us
retry the command.

Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 31e1df5..dba154c 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -461,6 +461,15 @@ static int alua_check_sense(struct scsi_device *sdev,
 			 */
 			return ADD_TO_MLQUEUE;
 		}
+		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e) {
+			/*
+			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
+			 * when switching controllers on targets like
+			 * Intel Multi-Flex. We can just retry.
+			 */
+			return ADD_TO_MLQUEUE;
+		}
+
 		break;
 	}
 
-- 
1.6.0.6

