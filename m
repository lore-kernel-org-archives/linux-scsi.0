Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404372E62D3
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715348; cv=none; b=Qkypi7gL572FL8Bej/AWIQPeD4sWvuX6DgdRlwMsdhRQK/MW7a7TQofkt3dogZiUVMryF23Fr+cs8a/YF4EDRsUb3hgnK/80fZTMpgcFAbVhMQRZ5B2IgJmPazqumGEmi50MUsH6QocTyvy+wsYirihgwY4RmCRXK/jYMEFTySA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715348; c=relaxed/simple;
	bh=wRZToAgNJr1RJEIcBlg+PO6CMws4fb54TniPtfMB9+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z01kAoFIy6lzgcZdNOkpn4DpgNGpsBKhQDXwaQO50uFyhRDZ/cMPVHpdBiHkHCNYy7/dGjAf6N3iW/gZV+2+VxNMEQvmC1zo+dVg/CQ1h6PGBD1/vt1OCrn9CPzL+ZaRFU+6+yA/jgQ4jo/2jMDLi2Km9+ASnQaWPRXLoU218a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=t3ADBS8f; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="t3ADBS8f"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF7Q166fzm0yR0;
	Thu,  3 Apr 2025 21:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715343; x=1746307344; bh=kK9jx
	zYXZUiIjKjFJNPAFPff98b2IRRVksUMPd9xqbk=; b=t3ADBS8fXyZ+rh68llMyj
	iyG6i4Q5DfkDpd5FkqrcIjBs0bwqbBh1kgKYje255O/9b85RamHMK4X/ZhDTtOz2
	TEJKow9OoAFoyDBTJ2LBoKrdnvpp1ybJyHHru4eGIHZP/EHTuCQq+OLwtEmGRc65
	Fu8+8FERvVclqF650GQPeYVQw8Bb+ohQi5HTFBQtACztPkjrQy8BZlNdSNhYI9cF
	isJ4P2hgbON3Cc4+1xUIZPQkmPGYbsCDopyslHSpMuKUlDVHnS2GJ/Io3RiWDvae
	4F9Upqxhwqj/IW/jNl2N7VYlVnvzxtmRGma7xjdEVuDLhYLItr1Io/nM8yoNbsUy
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FLRkbLS9xNgo; Thu,  3 Apr 2025 21:22:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF774c5kzmWSLL;
	Thu,  3 Apr 2025 21:22:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <quic_cang@quicinc.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 15/24] scsi: ufs: core: Add an argument to ufshcd_mcq_decide_queue_depth()
Date: Thu,  3 Apr 2025 14:17:59 -0700
Message-ID: <20250403211937.2225615-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for allocating SCSI commands in two steps by making the UFS devic=
e
queue depth an argument of ufshcd_mcq_decide_queue_depth().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c     | 14 ++++++++------
 drivers/ufs/core/ufshcd-priv.h |  2 +-
 drivers/ufs/core/ufshcd.c      |  2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 240ce135bbfb..cec21bb50cec 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -132,6 +132,7 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
 /**
  * ufshcd_mcq_decide_queue_depth - decide the queue depth
  * @hba: per adapter instance
+ * @ufs_dev_qd: maximum queue depth supported by the UFS device
  *
  * Return: queue-depth on success, non-zero on error
  *
@@ -140,7 +141,7 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
  * Calculates and adjusts the queue depth based on the depth
  * supported by the HC and ufs device.
  */
-int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
+int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba, u32 ufs_dev_qd)
 {
 	int mac;
=20
@@ -160,13 +161,14 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba *h=
ba)
 	if (mac < 0)
 		goto err;
=20
-	WARN_ON_ONCE(!hba->dev_info.bqueuedepth);
 	/*
-	 * max. value of bqueuedepth =3D 256, mac is host dependent.
-	 * It is mandatory for UFS device to define bQueueDepth if
-	 * shared queuing architecture is enabled.
+	 * According to the UFS standard, the UFS device queue depth
+	 * (bQueueDepth) must be in the range 1..255 if the shared queueing
+	 * architecture is supported. bQueueDepth is zero if the shared queuein=
g
+	 * architecture is not supported.
 	 */
-	return min_t(int, mac, hba->dev_info.bqueuedepth);
+	WARN_ON_ONCE(!ufs_dev_qd);
+	return min(mac, ufs_dev_qd);
=20
 err:
 	dev_err(hba->dev, "Failed to get mac, err=3D%d\n", mac);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index d0a2c963a27d..3cf06fc708b4 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -65,7 +65,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task=
_tag,
 			  struct cq_entry *cqe);
 int ufshcd_mcq_init(struct ufs_hba *hba);
 void ufshcd_mcq_disable(struct ufs_hba *hba);
-int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba);
+int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba, u32 ufs_dev_qd);
 int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
 struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 					   struct request *req);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 26aa07712507..99cc7c49619f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8728,7 +8728,7 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 	int ret;
 	int old_nutrs =3D hba->nutrs;
=20
-	ret =3D ufshcd_mcq_decide_queue_depth(hba);
+	ret =3D ufshcd_mcq_decide_queue_depth(hba, hba->dev_info.bqueuedepth);
 	if (ret < 0)
 		return ret;
=20
