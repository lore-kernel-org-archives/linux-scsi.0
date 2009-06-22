From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] remove redundant BUG_ON
Date: Mon, 22 Jun 2009 19:43:51 +0200
Message-ID: <4A3FC2D7.60400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:55114 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119AbZFVPnT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2009 11:43:19 -0400
Received: by ewy6 with SMTP id 6so4800815ewy.37
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2009 08:43:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: abjoglek@cisco.com
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

sg_count is unsigned so if negative a wrap occurs and the second BUG_ON
catches it.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index eabf365..c57cff4 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -260,7 +260,6 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 	char msg[2];
 
 	if (sg_count) {
-		BUG_ON(sg_count < 0);
 		BUG_ON(sg_count > FNIC_MAX_SG_DESC_CNT);
 
 		/* For each SGE, create a device desc entry */
