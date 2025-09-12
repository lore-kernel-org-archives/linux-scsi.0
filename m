Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468263009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701634; cv=none; b=C/bdLLY1aKm+vjdu7rFBz83JJ49qMdFKdnUpdFuQ58zef814DD/FckpCdLK3Kms7zuvv4QpblqFGq6LmshxyLxj4IyB0N7Cp+G3ECC8XxFpHkntAqIsAMVFyKwsj69Nu7tIZviZNLKnfMkAf9uCM6Qvxvde6iFSXsa8/YbzRK8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701634; c=relaxed/simple;
	bh=CVjf4/DISpfh6IIJQ+VT6XE73twLSR2a87fR1gJmUPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+LppV5b4XUSjFlkMTvlWpxnrHz9Sl8k9Il6y9Cjd4BdxZLq34eH/bQoycXDSlO6Pt/m28CYiBxm2h9HJTT1vdZRU5u+jbYSt9RkBEpnw0P6qSKpyIAwN4zHnex4ArdYAmTpCD0rZkJxuKA46fzclA1utZ+Zw86wQr/vqOK8cg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=caOf8yxh; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="caOf8yxh"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjZS3phkzlgqVx;
	Fri, 12 Sep 2025 18:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701629; x=1760293630; bh=3Gaas
	g3E+EFEl/Z/k7C3PrzgVhbUNlo6IR9NnBrQRSw=; b=caOf8yxh2KnOujdJXcxp0
	E+nNPtCqeyWr34ZmYCY2FGY37NRrfIGGYJb0yOXPl1Snm4bWaBlnNtFCardgoOok
	p10HxR2FFRCBGFx0nqDio4U6b6s86mN1urnps2TWUOnw9FAvjRD9K6QNfO1kcJPq
	cN/TrEryoHks5NbH+EBVyMtxDJISgyFZC8RwGqsVijd9/wDznBM9IzEm54d8ablV
	9pEfDsePPqz8yRvKmWfKLXPaOwtk5aX1s/FM+LV41m5YqPPByugKLykkJ7gGJW6s
	16j3Zn9Twa00XirFIL4u9YZJA5a/94w07hHSg43B1Dvjn5AmO5Vchtx37MfFQh+P
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qhzojB0L_flP; Fri, 12 Sep 2025 18:27:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjZB1dJQzllRp5;
	Fri, 12 Sep 2025 18:26:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"ping.gao" <ping.gao@samsung.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 17/29] ufs: core: Rework the SCSI host queue depth calculation code
Date: Fri, 12 Sep 2025 11:21:38 -0700
Message-ID: <20250912182340.3487688-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for allocating the SCSI host earlier by making the SCSI host
queue depth independent of the queue depth supported by the UFS device.
This patch may increase the queue depth of the UFS SCSI host.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c     | 20 +++++---------------
 drivers/ufs/core/ufshcd-priv.h |  2 +-
 drivers/ufs/core/ufshcd.c      | 17 +++++++++++++++--
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 4eb4f1af7800..b99e482ad8da 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -130,17 +130,15 @@ unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_h=
ba *hba)
 EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
=20
 /**
- * ufshcd_mcq_decide_queue_depth - decide the queue depth
+ * ufshcd_get_hba_mac - Maximum number of commands supported by the host
+ *	controller.
  * @hba: per adapter instance
  *
- * Return: queue-depth on success, non-zero on error
+ * Return: queue depth on success; negative upon error.
  *
- * MAC - Max. Active Command of the Host Controller (HC)
- * HC wouldn't send more than this commands to the device.
- * Calculates and adjusts the queue depth based on the depth
- * supported by the HC and ufs device.
+ * MAC =3D Maximum number of Active Commands supported by the Host Contr=
oller.
  */
-int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
+int ufshcd_get_hba_mac(struct ufs_hba *hba)
 {
 	int mac;
=20
@@ -160,14 +158,6 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hb=
a)
 	if (mac < 0)
 		goto err;
=20
-	WARN_ON_ONCE(!hba->dev_info.bqueuedepth);
-	/*
-	 * max. value of bqueuedepth =3D 256, mac is host dependent.
-	 * It is mandatory for UFS device to define bQueueDepth if
-	 * shared queuing architecture is enabled.
-	 */
-	return min_t(int, mac, hba->dev_info.bqueuedepth);
-
 err:
 	dev_err(hba->dev, "Failed to get mac, err=3D%d\n", mac);
 	return mac;
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index d0a2c963a27d..ec1bb818bc73 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -65,7 +65,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task=
_tag,
 			  struct cq_entry *cqe);
 int ufshcd_mcq_init(struct ufs_hba *hba);
 void ufshcd_mcq_disable(struct ufs_hba *hba);
-int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba);
+int ufshcd_get_hba_mac(struct ufs_hba *hba);
 int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
 struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 					   struct request *req);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bdc6476694f3..f54599490c86 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8435,10 +8435,11 @@ static void ufs_init_rtc(struct ufs_hba *hba, u8 =
*desc_buf)
=20
 static int ufs_get_device_desc(struct ufs_hba *hba)
 {
+	struct ufs_dev_info *dev_info =3D &hba->dev_info;
+	struct Scsi_Host *shost =3D hba->host;
 	int err;
 	u8 model_index;
 	u8 *desc_buf;
-	struct ufs_dev_info *dev_info =3D &hba->dev_info;
=20
 	desc_buf =3D kzalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
 	if (!desc_buf) {
@@ -8466,6 +8467,18 @@ static int ufs_get_device_desc(struct ufs_hba *hba=
)
 				      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
 	dev_info->bqueuedepth =3D desc_buf[DEVICE_DESC_PARAM_Q_DPTH];
=20
+	/*
+	 * According to the UFS standard, the UFS device queue depth
+	 * (bQueueDepth) must be in the range 1..255 if the shared queueing
+	 * architecture is supported. bQueueDepth is zero if the shared queuein=
g
+	 * architecture is not supported.
+	 */
+	if (dev_info->bqueuedepth)
+		shost->cmd_per_lun =3D min(hba->nutrs, dev_info->bqueuedepth) -
+				     UFSHCD_NUM_RESERVED;
+	else
+		shost->cmd_per_lun =3D shost->can_queue;
+
 	dev_info->rtt_cap =3D desc_buf[DEVICE_DESC_PARAM_RTT_CAP];
=20
 	dev_info->hid_sup =3D get_unaligned_be32(desc_buf +
@@ -8871,7 +8884,7 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 	int ret;
 	int old_nutrs =3D hba->nutrs;
=20
-	ret =3D ufshcd_mcq_decide_queue_depth(hba);
+	ret =3D ufshcd_get_hba_mac(hba);
 	if (ret < 0)
 		return ret;
=20
