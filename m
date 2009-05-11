From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 1/5] mvsas: bug fix with setting task management frame type
Date: Tue, 12 May 2009 01:19:44 +0800
Message-ID: <20090511171944.GA9698@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:19010 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755240AbZEKI25 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 04:28:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

>From 5cd41873370e1e7df7404dad798ed8ad745c304b Mon Sep 17 00:00:00 2001
From: Andy Yan <ayan@marvell.com>
Date: Mon, 11 May 2009 20:01:55 +0800
Subject: [PATCH 1/5] mvsas: bug fix with setting task management frame type

Correct frame type setting according to parameter.

Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_sas.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index d79ac17..f709319 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -761,9 +761,11 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 		flags |= MCH_FBURST;
 		fburst = (1 << 7);
 	}
-	hdr->flags = cpu_to_le32(flags |
-				 (tei->n_elem << MCH_PRD_LEN_SHIFT) |
-				 (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT));
+	if (is_tmf)
+		flags |= (MCH_SSP_FR_TASK << MCH_SSP_FR_TYPE_SHIFT);
+	else
+		flags |= (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT);
+	hdr->flags = cpu_to_le32(flags | (tei->n_elem << MCH_PRD_LEN_SHIFT));
 	hdr->tags = cpu_to_le32(tag);
 	hdr->data_len = cpu_to_le32(task->total_xfer_len);
 
-- 
1.6.2.1

