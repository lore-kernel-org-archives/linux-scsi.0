Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFDB1C5F1B
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 01:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780017390; cv=none; b=dzb4inR40G0Het6/mKDXeXv25qfUFbL0DlJK0y/KCqykRL72/uGuhCMFqtrxudvDkKVatRz5cTXuoMz0ZizBO8Xs5L0IFFOnD8w9YPoiEmQWF0oQLGZ7ixNNVbMJnjhtS+ihOrrYDTw2iiKVsQ5OJ+uG7VS4uXYzuHrJ8dK1Dv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780017390; c=relaxed/simple;
	bh=L77pmz1V3vnh4bA9TbLP5qAiczzAS690ZaZPsb4vMtI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=N7f1KzcxgcTnhlGu/+/+HJWdHt5b2MEMzb6s5JISIIBCurBx5YmKhumiydT5x9LJgIIcSp77KQ2JbysOO/Lj3Nqp4pxkD3oFdxO4WwJMnEGgwjvgdmD1KPOVr+DIeIBEWSaHyZ7gPx9rrPX5x4XK1UqTGBs6kcMrCO+p+x+GNGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RY8PK652; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RY8PK652"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260529010750epoutp027a381a9431373b46a178a07c32050b89~z4_m1FBcs0291802918epoutp02Z
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 01:07:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260529010750epoutp027a381a9431373b46a178a07c32050b89~z4_m1FBcs0291802918epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1780016870;
	bh=bmOyx7LCKnUdi3eeyYD25VmIw0e+LrVRhm1f7vD2kMg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=RY8PK652LxgdU9HbM2ydBSd4sG98n1XrsTmt/XVPUt6d+pGU8uDUF3q6mUzMCOZtM
	 bqDXvh6paubFh+XSFeDoFuijr487FXl+N1G6jHaBih7C4oj1MOpCf4jhUtHoyXMhOP
	 tJXnoYRRGJGJczNVH5Vtd4OxMLD5QT6GGqjIvKn4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20260529010750epcas1p13b07e1698d96cced0f9e29ba6b425a3a~z4_mYWJSs3009830098epcas1p1N;
	Fri, 29 May 2026 01:07:50 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.38.192]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4gRQFf0VxCz2SSKj; Fri, 29 May
	2026 01:07:50 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260529010749epcas1p2bf38209e55149f0681550c220e541e92~z4_l1uhbb1847218472epcas1p2n;
	Fri, 29 May 2026 01:07:49 +0000 (GMT)
Received: from cw9316lee.. (unknown [10.253.101.98]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20260529010749epsmtip2edba16e6f42d45f98c45931bf48c751f~z4_lyGJWk1235712357epsmtip2-;
	Fri, 29 May 2026 01:07:49 +0000 (GMT)
From: Chanwoo Lee <cw9316.lee@samsung.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	peter.wang@mediatek.com, vamshigajjela@google.com, alok.a.tiwari@oracle.com,
	beanhuo@micron.com, can.guo@oss.qualcomm.com, adrian.hunter@intel.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chanwoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH v2] scsi: ufs: core: Fix NULL pointer dereference in
 scsi_cmd_priv() calls
Date: Fri, 29 May 2026 10:07:39 +0900
Message-ID: <20260529010739.295391-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260529010749epcas1p2bf38209e55149f0681550c220e541e92
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260529010749epcas1p2bf38209e55149f0681550c220e541e92
References: <CGME20260529010749epcas1p2bf38209e55149f0681550c220e541e92@epcas1p2.samsung.com>

ufshcd_tag_to_cmd() may return NULL if no command is associated with
the given tag. However, several callers dereference the returned cmd
pointer via scsi_cmd_priv() without checking for NULL first, leading
to a potential NULL pointer dereference.

Fix this by adding NULL checks for cmd before calling scsi_cmd_priv()
and moving the lrbp initialization after the NULL check.

Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
---
Changes in v2:
- Dropped moving scsi_cmd_priv()/scsi_cmd_to_rq() calls after NULL
  checks in ufshcd_mcq_sq_cleanup() and ufshcd_compl_one_cqe() since
  the derived pointers are not dereferenced before the check
  (Bart Van Assche)

 drivers/ufs/core/ufs-mcq.c |  7 ++++++-
 drivers/ufs/core/ufshcd.c  | 13 +++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index c1b1d67a1ddc..13b60a2d06db 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -637,7 +637,7 @@ static bool ufshcd_mcq_sqe_search(struct ufs_hba *hba,
 				  struct ufs_hw_queue *hwq, int task_tag)
 {
 	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+	struct ufshcd_lrb *lrbp;
 	struct utp_transfer_req_desc *utrd;
 	__le64  cmd_desc_base_addr;
 	bool ret = false;
@@ -647,6 +647,11 @@ static bool ufshcd_mcq_sqe_search(struct ufs_hba *hba,
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
index 9e0336098e26..7481c71c71b8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7893,8 +7893,12 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
 
 	for_each_set_bit(tag, &bitmap, hba->nutrs) {
 		struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, tag);
-		struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+		struct ufshcd_lrb *lrbp;
 
+		if (!cmd)
+			continue;
+
+		lrbp = scsi_cmd_priv(cmd);
 		lrbp->req_abort_skip = true;
 	}
 }
@@ -7915,11 +7919,16 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
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

