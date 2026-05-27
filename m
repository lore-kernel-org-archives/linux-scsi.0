Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEF43BFACE
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 07:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779866562; cv=none; b=srU+NHqza9eAN6Qw4q2wYQ+8j0QnLprovXHRVq9HdKD7ErRTIGXa0/PoVOvshdCSHJO6hlo5RZL46N1cWr7serXTy7YocFF/hv7e1txxRU//GJMY6KxMn9XqZaweC/PnyjeyNTvdlF4DEkPUR51tRl48k+oYVvAuNIxT6r6ePqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779866562; c=relaxed/simple;
	bh=DW1k08rXTsFZIW2DKskLR0WlqMSnA83Mw2P+9Vmq7A0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=LIrRP+Ueelxn0tXRi87E/utlzJ6U/oXwldJXJ0beKQQ1kbrJQyn9YGCfj0ImrHSyW7ysDZTSWsJZu5sZH7aEo7vlunfJKmzJnwBAth1tTK/hTV3UQsImuAhSkYjEyp+XX0vNkkLHNCLabrsx7rta98JRO68U/temydPZgp0xETA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mqfAfx5O; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mqfAfx5O"
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260527072232epoutp02778a9015d3dd6d54fabfab9762c3843d~zWzMnG5QB1404314043epoutp02k
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 07:22:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260527072232epoutp02778a9015d3dd6d54fabfab9762c3843d~zWzMnG5QB1404314043epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1779866553;
	bh=wHKMTcKtGx/5tv8dh5v1S5wv2HCfPmN2uOlQVwpbV5o=;
	h=From:To:Cc:Subject:Date:References:From;
	b=mqfAfx5OKs59JyIXZXyAIqkKmcOi4x8WVh/whNMEsyWTN6Q7Jto9xWzGyoFKlByA0
	 2b+VfhY+adFLJyZy10iSCI/MHGkN8TwTpNyUn0rIvyYrGfj9c4D21Xjw2liyzUCURq
	 cARVCpQKJ43hNuZOZ6aY+iGlTMe2JqE8x89ZGe2s=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20260527072232epcas1p191f854302c2716b2c1292b1eb6735a3e~zWzMGy7lE2834528345epcas1p1S;
	Wed, 27 May 2026 07:22:32 +0000 (GMT)
Received: from epcas1p4.samsung.com (unknown [182.195.38.115]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gQLfw1XbRz6B9m6; Wed, 27 May
	2026 07:22:32 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20260527072231epcas1p308649370c22bbf30eb2381abf6058db6~zWzLcdkzn1789617896epcas1p3v;
	Wed, 27 May 2026 07:22:31 +0000 (GMT)
Received: from cw9316lee.. (unknown [10.253.101.98]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20260527072231epsmtip1c69667ab36882a5c853dc552f816f0f1~zWzLX1TWg2850128501epsmtip1F;
	Wed, 27 May 2026 07:22:31 +0000 (GMT)
From: Chanwoo Lee <cw9316.lee@samsung.com>
To: ulf.hansson@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
	bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com, peter.wang@mediatek.com,
	vamshigajjela@google.com, alok.a.tiwari@oracle.comm, beanhuo@micron.com,
	can.guo@oss.qualcomm.com, adrian.hunter@intel.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chanwoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH] scsi: ufs: core: Fix NULL pointer dereference in
 scsi_cmd_priv() calls
Date: Wed, 27 May 2026 16:22:28 +0900
Message-ID: <20260527072228.271542-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260527072231epcas1p308649370c22bbf30eb2381abf6058db6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260527072231epcas1p308649370c22bbf30eb2381abf6058db6
References: <CGME20260527072231epcas1p308649370c22bbf30eb2381abf6058db6@epcas1p3.samsung.com>

ufshcd_tag_to_cmd() may return NULL if no command is associated with
the given tag. However, several callers dereference the returned cmd
pointer via scsi_cmd_priv() without checking for NULL first, leading
to a potential NULL pointer dereference.

Fix this by adding NULL checks for cmd before calling scsi_cmd_priv()
and moving the lrbp initialization after the NULL check

Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 14 +++++++++++---
 drivers/ufs/core/ufshcd.c  | 17 ++++++++++++++---
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index c1b1d67a1ddc..798b2a910128 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -555,8 +555,8 @@ static int ufshcd_mcq_sq_start(struct ufs_hba *hba, struct ufs_hw_queue *hwq)
 int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 {
 	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
-	struct request *rq = scsi_cmd_to_rq(cmd);
+	struct ufshcd_lrb *lrbp;
+	struct request *rq;
 	struct ufs_hw_queue *hwq;
 	void __iomem *reg, *opr_sqd_base;
 	u32 nexus, id, val;
@@ -568,6 +568,9 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 	if (!cmd)
 		return -EINVAL;
 
+	lrbp = scsi_cmd_priv(cmd);
+	rq = scsi_cmd_to_rq(cmd);
+
 	hwq = ufshcd_mcq_req_to_hwq(hba, rq);
 	if (!hwq)
 		return 0;
@@ -637,7 +640,7 @@ static bool ufshcd_mcq_sqe_search(struct ufs_hba *hba,
 				  struct ufs_hw_queue *hwq, int task_tag)
 {
 	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+	struct ufshcd_lrb *lrbp;
 	struct utp_transfer_req_desc *utrd;
 	__le64  cmd_desc_base_addr;
 	bool ret = false;
@@ -647,6 +650,11 @@ static bool ufshcd_mcq_sqe_search(struct ufs_hba *hba,
 	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
 		return true;
 
+	if (!cmd)
+		return false;
+
+	lrbp = scsi_cmd_priv(cmd);
+
 	mutex_lock(&hwq->sq_mutex);
 
 	ufshcd_mcq_sq_stop(hba, hwq);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e0336098e26..0371dea44887 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5833,13 +5833,15 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 			  struct cq_entry *cqe)
 {
 	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+	struct ufshcd_lrb *lrbp;
 	enum utp_ocs ocs;
 
 	if (WARN_ONCE(!cmd, "cqe->command_desc_base_addr = %#llx\n",
 		      le64_to_cpu(cqe->command_desc_base_addr)))
 		return;
 
+	lrbp = scsi_cmd_priv(cmd);
+
 	if (hba->monitor.enabled) {
 		lrbp->compl_time_stamp = ktime_get();
 		lrbp->compl_time_stamp_local_clock = local_clock();
@@ -7893,8 +7895,12 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
 
 	for_each_set_bit(tag, &bitmap, hba->nutrs) {
 		struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, tag);
-		struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+		struct ufshcd_lrb *lrbp;
+
+		if (!cmd)
+			continue;
 
+		lrbp = scsi_cmd_priv(cmd);
 		lrbp->req_abort_skip = true;
 	}
 }
@@ -7915,11 +7921,16 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
 int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
 {
 	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, tag);
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+	struct ufshcd_lrb *lrbp;
 	int err;
 	int poll_cnt;
 	u8 resp = 0xF;
 
+	if (!cmd)
+		return -EINVAL;
+
+	lrbp = scsi_cmd_priv(cmd);
+
 	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
 		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, tag, UFS_QUERY_TASK,
 					  &resp);
-- 
2.43.0

