Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B275629BD87
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934005; cv=none; b=CwaHv5TBFCtyofLhyD5Skkf2dyVw4ANRfS/1G+Ft9oe2IkAY4Txv0xZcfksFRSyFthLxO5nO21riffEYKJX1LaQyAFPIHdxPYzuk5aL/0aL6y4KScu0ntT+e91A9BV8+rNGdqFwTNHg49ZhV2h7F5EyjnbCjteWZAnMnT3NpPEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934005; c=relaxed/simple;
	bh=F06icOCKLGQ+oyNxwnLCX7FuHDPlirmxifLW8IR84Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEFusXdVL5vV4vOCaSCRKqPtRfMndbl0Sizwq8PvPF3WGaMqYEus44jNwYb1dsdXnUUbKlWUT2O0kIx/2JMSdylAl/vmbitsT4JgPHUfqlaV75uPLsgIJwkSCa9EZ+K1gY0EhTLaphFASeDt8uGU8l72250HH+6dUI02NUKR+1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=42HGRoe1; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="42HGRoe1"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c122p4mqgzlgqTr;
	Mon, 11 Aug 2025 17:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934000; x=1757526001; bh=NkyGs
	Z/8KoDBKDodqzyvbUoRzi31tUhk1qubj538/wA=; b=42HGRoe1aYDg+P5W+S5aU
	Ubi14Hs10ECff5qf/7rYAkEDdeJ1yYKLZzEzy6cw0pn0m2vUux+24/Wc5xqc5NmM
	IbaU/GsujbjdzPldsry0hlwBbBqdHh+z5atXTjuI6lUhyww/QO/28i4k0jqqcTVs
	TAg2u/A+AL6GL3DaGSewqNyP9D+FJ8ycbS8YPDIwAEJytPg2QMGj4jZkTz5+hKeK
	qIETcimA77ZqYxuudOUxF2FElQSSuE/dp3anMSngSmb6mi5sz791lFJTHCKIceGR
	oZ3YKXhYVY6IVOfBZxFwFSzzRNI1kNW4RaxB0uGZ9tn0fSREYlkVew47+VC6ZYsG
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bnrDm_C8xbxS; Mon, 11 Aug 2025 17:40:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c122Z375mzlgqTq;
	Mon, 11 Aug 2025 17:39:49 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"ping.gao" <ping.gao@samsung.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 17/30] ufs: core: Add an argument to ufshcd_mcq_decide_queue_depth()
Date: Mon, 11 Aug 2025 10:34:29 -0700
Message-ID: <20250811173634.514041-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
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
index 4eb4f1af7800..a44ab6c010d8 100644
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
+int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba, int ufs_dev_qd)
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
index d0a2c963a27d..c02f9a6af137 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -65,7 +65,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task=
_tag,
 			  struct cq_entry *cqe);
 int ufshcd_mcq_init(struct ufs_hba *hba);
 void ufshcd_mcq_disable(struct ufs_hba *hba);
-int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba);
+int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba, int ufs_dev_qd);
 int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
 struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 					   struct request *req);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 09727a94595c..bed88caea319 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8875,7 +8875,7 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 	int ret;
 	int old_nutrs =3D hba->nutrs;
=20
-	ret =3D ufshcd_mcq_decide_queue_depth(hba);
+	ret =3D ufshcd_mcq_decide_queue_depth(hba, hba->dev_info.bqueuedepth);
 	if (ret < 0)
 		return ret;
=20
