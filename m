Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C0D1482F2
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853207; cv=none; b=nFgbgaUqc38xIZIy9Fmhgd7+SvWQh1+1bLttCDfMu1B/J55DQXWYE80IdiFGaCaAdVfqIXe1W8mTCjapzgb931YpyvUtj9hizaZ10aCCqBKu+7Bxvf25zKSZTwmE6cOLJ9c5V+Ll+9/LcmaH5NwDEcDn85IP67Vw3p5ZYuEw5xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853207; c=relaxed/simple;
	bh=A5Sc7+RzelLdv8ZzV3cwauny5K9ya8JmvziGh7RgqJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvygDo1vOCnlPq6bbViWRr9XNq5LNLHmlat2QDigaObUjw3EJvnic/4N1or73UwETulSH1yghJrKSLwonB6QB49UaNxoD+q1ulUpzY1ZD3Mqe0DMc4GJvsrHSMCbA54ucdN1TQm7PWH1OpBeNiNGOChim22w7PDOJ460aZQ1Q0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pXQNiVym; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pXQNiVym"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDwP0fgjzlmm7l;
	Thu, 30 Oct 2025 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853202; x=1764445203; bh=OKK6U
	X71Y6/L5h116EBXDTPeYxfpiXHIwhn9BT5sUZQ=; b=pXQNiVymwLFITpBg9Kky/
	MAZmZAsTM5SsRNtMAB5Nn6YVmXqyetOC/lfTaKGd+EnlMyQB3n1Byi6A2Dv+M3Bz
	S3NpEbRqk6tF3pG85sQpQtZU1RjFzbaO+uK8j8GwVOmusgcboHgwSUii6/VDB8bV
	jxKJygY2CcTsrkuwRLnXYEuh68aRqy8BR5zmnpptR4lEQgIbtp+RCVov3QeNg5QX
	qRAv8q83/kzEHQZqHK3Cbb1Mt42Vm32irMlnZs8kBSVQbr9Hjt3Faj/83OL6F6k8
	z8sQ0eWW6oD4yd55RT+b6YCBaZNcydmLo4GYfCpV/YIhww4SAIJqKa8EUfSC4UP1
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rN0qttuDAQTG; Thu, 30 Oct 2025 19:40:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDw75b2DzltNPs;
	Thu, 30 Oct 2025 19:39:50 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v7 17/28] ufs: core: Rework the SCSI host queue depth calculation code
Date: Thu, 30 Oct 2025 12:36:16 -0700
Message-ID: <20251030193720.871635-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251030193720.871635-1-bvanassche@acm.org>
References: <20251030193720.871635-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufs-mcq.c     | 25 ++++++-------------------
 drivers/ufs/core/ufshcd-priv.h |  2 +-
 drivers/ufs/core/ufshcd.c      | 17 +++++++++++++++--
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index bae35d0f99c5..00b043b54419 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -134,17 +134,15 @@ unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_h=
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
@@ -162,18 +160,7 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hb=
a)
 		mac =3D hba->vops->get_hba_mac(hba);
 	}
 	if (mac < 0)
-		goto err;
-
-	WARN_ON_ONCE(!hba->dev_info.bqueuedepth);
-	/*
-	 * max. value of bqueuedepth =3D 256, mac is host dependent.
-	 * It is mandatory for UFS device to define bQueueDepth if
-	 * shared queuing architecture is enabled.
-	 */
-	return min_t(int, mac, hba->dev_info.bqueuedepth);
-
-err:
-	dev_err(hba->dev, "Failed to get mac, err=3D%d\n", mac);
+		dev_err(hba->dev, "Failed to get mac, err=3D%d\n", mac);
 	return mac;
 }
=20
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index 1f0d38aa37f9..749c0ab2a4ca 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -67,7 +67,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task=
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
index f64192c672e2..93f2853ff5df 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8466,10 +8466,11 @@ static void ufs_init_rtc(struct ufs_hba *hba, u8 =
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
@@ -8497,6 +8498,18 @@ static int ufs_get_device_desc(struct ufs_hba *hba=
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
@@ -8905,7 +8918,7 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 	int ret;
 	int old_nutrs =3D hba->nutrs;
=20
-	ret =3D ufshcd_mcq_decide_queue_depth(hba);
+	ret =3D ufshcd_get_hba_mac(hba);
 	if (ret < 0)
 		return ret;
=20
