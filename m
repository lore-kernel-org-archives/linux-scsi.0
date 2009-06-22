From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] remove redundant BUG_ON
Date: Mon, 22 Jun 2009 19:54:38 +0200
Message-ID: <4A3FC55E.80108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:37625 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZFVPyD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2009 11:54:03 -0400
Received: by ewy6 with SMTP id 6so4809222ewy.37
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2009 08:54:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: abjoglek@cisco.com
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

sg_count is unsigned. If negative, a wrap causes the second BUG_ON to trigger.

scsi_dma_map may return -ENOMEM, sg_count should be int to catch that.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Please use this one instead.

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index eabf365..22a7cd5 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -260,7 +260,6 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 	char msg[2];
 
 	if (sg_count) {
-		BUG_ON(sg_count < 0);
 		BUG_ON(sg_count > FNIC_MAX_SG_DESC_CNT);
 
 		/* For each SGE, create a device desc entry */
@@ -344,7 +343,7 @@ int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	struct fnic *fnic;
 	struct vnic_wq_copy *wq;
 	int ret;
-	u32 sg_count;
+	int sg_count;
 	unsigned long flags;
 	unsigned long ptr;
 
