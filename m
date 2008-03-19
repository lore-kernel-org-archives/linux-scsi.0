From: Denis Cheng <crquan@gmail.com>
Subject: [PATCH] scsi: removed one unneeded shost->active_mode assignment
Date: Thu, 20 Mar 2008 03:10:20 +0800
Message-ID: <1205953820-8501-1-git-send-email-crquan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:34320 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbYCSTiU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 15:38:20 -0400
Received: by wf-out-1314.google.com with SMTP id 28so582893wff.4
        for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2008 12:38:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

In the following if/else statement, shost->active_mode will always be set,
so this assignment is unneeded.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/scsi/hosts.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 880c78b..553d443 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -341,7 +341,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
-	shost->active_mode = sht->supported_mode;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
-- 
1.5.4.4

