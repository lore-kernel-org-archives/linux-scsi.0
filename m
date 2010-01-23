From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 6/8] be2iscsi: Ensure clean reuse of wrb
Date: Sat, 23 Jan 2010 05:38:18 +0530
Message-ID: <20100123000808.GA12658@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:40028 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754621Ab0AWAIO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2010 19:08:14 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patch ensures that wrb is cleanly resued for io path
and is memset to zero for non io path

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 6b700ad..85c0e80 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1663,11 +1663,7 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
 			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_len, pwrb,
 							sg_len);
 			sge_len = sg_len;
-			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb,
-							1);
 		} else {
-			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb,
-							0);
 			AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_r2t_offset,
 							pwrb, sge_len);
 			sg_len = sg_dma_len(sg);
@@ -1690,8 +1686,22 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
 	AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, psgl,
 			io_task->bhs_pa.u.a32.address_lo);
 
-	if (num_sg == 2)
-		AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_last, pwrb, 1);
+	if (num_sg == 1) {
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb,
+								1);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_last, pwrb,
+								0);
+	} else if (num_sg == 2) {
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb,
+								0);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_last, pwrb,
+								1);
+	} else {
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb,
+								0);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_last, pwrb,
+								0);
+	}
 	sg = l_sg;
 	psgl++;
 	psgl++;
@@ -3476,6 +3486,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 
 	cid = beiscsi_conn->beiscsi_conn_cid;
 	pwrb = io_task->pwrb_handle->pwrb;
+	memset(pwrb, 0, sizeof(*pwrb));
 	AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb,
 		      be32_to_cpu(task->cmdsn));
 	AMAP_SET_BITS(struct amap_iscsi_wrb, wrb_idx, pwrb,
-- 
1.6.4

