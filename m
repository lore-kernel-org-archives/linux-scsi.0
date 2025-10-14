Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86F53054DE
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473213; cv=none; b=Mn9t31l2tA9Q5yWSy7U+xdRUzXI+9md0f04R/XyBbEt8ma4cDc9XN5p24NiKV6WWUJOvqJkxx9Ek7+QNH1TDVe3i2ZeFvEEk5s9Kn9dAu5Ky/tN1/Ev7frx4DuAckeo3u1bxD1i1wniNjDads38nGhSQBgQoJQwwLl6giOXQ0KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473213; c=relaxed/simple;
	bh=lM/mm93+OGC+XcWaX6Uun7r4tkYPkIbYXa5EZDEsKuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2/Gs31EzCgN9Dfr2gji3N9C8hzUylQlJLdJCzKKPjnFIpex75Vd1+Bp/w1VxyigaZPZirSH21PhdrsOqGPiPu9Yw61vspb3xXIaK8qfEL6akQQu9+xpL5EfdB/ZHyZz/BpK6Tk04gnksikDAcCXOnm64828KwAxwEIZ9B40+oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tGEkaRm3; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tGEkaRm3"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQZ30ljpzm0yVW;
	Tue, 14 Oct 2025 20:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473208; x=1763065209; bh=H/M6y
	n3kPyrDpphfQTAiV//r96urjDMuiypradLkdsE=; b=tGEkaRm34AdjX6K7+x53m
	mke7y2/XZ/ByNR6uZJstpKHYYGX9AidKf7sFISUYgYg/5s6oXP0mIJzTu0qkEbBD
	IRJnlrVDFuupmtQpHx6w/fqtk+x9+RVx9k+QsDRMfmyWTm9gwMrnJXjIbBazxPu3
	w25nZg03ZdNInrhA3dfi3EUPzQc8bMeH56jCabRqfP2XRVQYBaml41yh0nMOAMfa
	RSiqKm2KLvdqacUNdDWD/Fm9PzPM1bsHbQQHqyLj64vCcRrd7aOWKPJv0HOlNmkT
	wkWGIEaQtaEGEdAO7PVd2jrWlrrQvqWol/gGve2zJMQs4MoRDeb7YQX1WPfoLfKB
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PSnt7hhjjNjC; Tue, 14 Oct 2025 20:20:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQYp3n3Zzm0yTq;
	Tue, 14 Oct 2025 20:19:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v6 17/28] ufs: core: Rework the SCSI host queue depth calculation code
Date: Tue, 14 Oct 2025 13:15:59 -0700
Message-ID: <20251014201707.3396650-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
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
index 8780be79a0f8..36b755f6d7d0 100644
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
index 7042880c4e60..696837b031b9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8463,10 +8463,11 @@ static void ufs_init_rtc(struct ufs_hba *hba, u8 =
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
@@ -8494,6 +8495,18 @@ static int ufs_get_device_desc(struct ufs_hba *hba=
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
@@ -8902,7 +8915,7 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 	int ret;
 	int old_nutrs =3D hba->nutrs;
=20
-	ret =3D ufshcd_mcq_decide_queue_depth(hba);
+	ret =3D ufshcd_get_hba_mac(hba);
 	if (ret < 0)
 		return ret;
=20
