From: Ying Chu <jasonchu@marvell.com>
Subject: [PATCH 3/4] mvsas: Set Hardware Bit for TMF
Date: Fri, 8 May 2009 14:17:04 +0800
Message-ID: <20090508061704.GA1888@jason.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:51595 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753256AbZEHGRS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2009 02:17:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeff@garzik.org, james.bottomley@hansenpartnership.com

>From a939392afc59960b4a9bd8244e2e8fe43b7016f6 Mon Sep 17 00:00:00 2001
From: Andy Yan <ayan@marvell.com>
Date: Mon, 4 May 2009 23:33:58 +0800
Subject: [PATCH 3/4] bug fix: task frame type setting

Set SSP Task Frame for TMF task.

Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_sas.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index cb002ef..83d5465 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -761,9 +761,9 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 		flags |= MCH_FBURST;
 		fburst = (1 << 7);
 	}
-	hdr->flags = cpu_to_le32(flags |
-				 (tei->n_elem << MCH_PRD_LEN_SHIFT) |
-				 (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT));
+	if (is_tmf)
+		flags |= (MCH_SSP_FR_TASK << MCH_SSP_FR_TYPE_SHIFT);
+	hdr->flags = cpu_to_le32(flags | (tei->n_elem << MCH_PRD_LEN_SHIFT));
 	hdr->tags = cpu_to_le32(tag);
 	hdr->data_len = cpu_to_le32(task->total_xfer_len);
 
-- 
1.6.0.3

-- 
Regards,
Ying Chu
