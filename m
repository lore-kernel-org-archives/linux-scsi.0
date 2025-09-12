Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8F53009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701744; cv=none; b=PXpIMYAFoeHGyXPlMhMuze18t6ABkVHw3Xdo43WUBgPScHs5JE1ZpjjzVWXUyLjXI6VmzRh8vtTG49W4ZrInjWLrgkICcmOW3OA+NwtcqPGMGNej8w8nz7pBUG04o5IZpv8MyToLsL68yE75IDyozTNCvOVMxbiIXL+WWWuR5BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701744; c=relaxed/simple;
	bh=xxijY8YoQhLtWKiZuRnkusT9iR/wfPk4JOLTXutYUyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnIG1E0pNhmvXhZdpvl8WEktbRGyENh73MWHQXySmf++8CVAyML89jSLtEY+V5lbUWLvdc4+EU9+b/M0K01eER2piXpJ6DpBhdZeqsV2FTD/kYT52JitQfmxfQWMg3xNzqDXnQEjOUqSA//MciurIu3pxNmcTzVZkje1dlRfqZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=z+MRt0j9; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="z+MRt0j9"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjcZ0R3CzlgqVx;
	Fri, 12 Sep 2025 18:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701740; x=1760293741; bh=ooq6w
	uXhD/jEEcyQmsNqaqNKxcweitTsGKfZsqKTnME=; b=z+MRt0j9cLPG61LHlOAvJ
	jBqVDk4dtF4F4rbm5ULqvXlh98M7iUz5NvIuB5wkdinUm02NKKqgVnHILVfv8Hog
	ilyAd1KA8qRkizGoy/9TtiAKA9W29byOeJfgQGEGny2zuz2dopEFNojRpiOOgWKa
	0l2UZNsQi6hCV2bKvJNePv+BUFlPHef0w7b/hDxX0u5cRe3PC0BPMl45x4W/DH9W
	D7+zKMD4gM79nTM8a0spVLY5qFfBfCLZPXclBPMloXjyb9UddzWWmp1iag2Fvop7
	w3+zWAXXbm6G4VKH0yM8FATwQb2HgksoGFRIQ19BxojmuDVPfBn96pqV7MtLUbus
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CfdG_ALDuVOa; Fri, 12 Sep 2025 18:29:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjcR6MlKzlgqTs;
	Fri, 12 Sep 2025 18:28:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 26/29] ufs: core: Make blk_mq_tagset_busy_iter() skip reserved requests
Date: Fri, 12 Sep 2025 11:21:47 -0700
Message-ID: <20250912182340.3487688-27-bvanassche@acm.org>
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

A later patch will convert hba->reserved_slot into a reserved tag. Make
blk_mq_tagset_busy_iter() skip reserved requests such that device
management commands are skipped.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0961432e9ee0..2f815f74aa66 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -646,7 +646,8 @@ static bool ufshcd_print_tr_iter(struct request *req,=
 void *priv)
 	struct Scsi_Host *shost =3D sdev->host;
 	struct ufs_hba *hba =3D shost_priv(shost);
=20
-	ufshcd_print_tr(hba, blk_mq_rq_to_pdu(req), *(bool *)priv);
+	if (!blk_mq_is_reserved_rq(req))
+		ufshcd_print_tr(hba, blk_mq_rq_to_pdu(req), *(bool *)priv);
=20
 	return true;
 }
@@ -5741,7 +5742,7 @@ static bool ufshcd_mcq_force_compl_one(struct reque=
st *rq, void *priv)
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (!hwq)
+	if (blk_mq_is_reserved_rq(rq) || !hwq)
 		return true;
=20
 	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
@@ -5768,7 +5769,7 @@ static bool ufshcd_mcq_compl_one(struct request *rq=
, void *priv)
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (hwq)
+	if (!blk_mq_is_reserved_rq(rq) && hwq)
 		ufshcd_mcq_poll_cqe_lock(hba, hwq);
=20
 	return true;
@@ -6630,6 +6631,9 @@ static bool ufshcd_abort_one(struct request *rq, vo=
id *priv)
 	struct Scsi_Host *shost =3D sdev->host;
 	struct ufs_hba *hba =3D shost_priv(shost);
=20
+	if (blk_mq_is_reserved_rq(rq))
+		return true;
+
 	*ret =3D ufshcd_try_to_abort_task(hba, tag);
 	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
 		ufshcd_is_scsi_cmd(cmd) ? cmd->cmnd[0] : -1,
@@ -7565,7 +7569,7 @@ static bool ufshcd_clear_lu_cmds(struct request *re=
q, void *priv)
 	const u64 lun =3D *(u64 *)priv;
 	const u32 tag =3D req->tag;
=20
-	if (sdev->lun !=3D lun)
+	if (blk_mq_is_reserved_rq(req) || sdev->lun !=3D lun)
 		return true;
=20
 	if (ufshcd_clear_cmd(hba, tag) < 0) {
