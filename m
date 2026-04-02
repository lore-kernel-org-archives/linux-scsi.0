Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9993D7D67
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 17:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775150074; cv=none; b=jQlwqj9F0QnSID2LmoSRTbzct3klcBqdgYFAVELe91dQ2YTsFLSWiXqlrPfgbmJk9fmPTMnBghvKHOJ4sefCPm5mg8Scr1AgyqrR9OWqq5NTO5j1VtID4w08v0UJC3Jrr6QozJofOw2958lbOXGyO8LsCaAOGzb3dKomYGisF+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775150074; c=relaxed/simple;
	bh=aBg0kVG3+WCOuu+gX8HAdyE4pt30MMUuHlRDgHlBV0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emaKwYkS9mrxoslO6gmQeWoiTByUDEn8CHYLYsAM+Ng9wBhw5hiaGEMrbUFEO72ARFrKNDhX3sKv/fcFwSUvfrSvfctufjrmem2OXNZjB+miTxHIc3wwxNlsTEY+YRuOXOm/vG4lY3+Uwy1oXiJuDaCG9CPSEQF5i3Tt6aMcQes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tp/JeVbW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tp/JeVbW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fmpPH5d8Pz1XM6Jc;
	Thu,  2 Apr 2026 17:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1775150063; x=1777742064; bh=zSOQD
	9pRWNA1gh0mwO3uk3uOqFI0A7+9pUeJ0RRwuVI=; b=tp/JeVbWCHw4QE32MWc+A
	Iish3lPqbGYpu3BY9Eg8qu7/axf/kB1DvVSz94BlDPUjgagGlHGyYFIjm5O6ln4J
	pZwmbW0QrsUwPfLJzbM6ofN6ilRRImBYPc1VG9fB3BzWELppkRVJRxK3U6rNjX24
	yf0nzx3/xK3immOR2saOox0f/900BElLfbUUZgFOXsbka/w0Vh0PqsgUAUq+Qmpl
	dZBy2CNN2g1OgradHo4DrcQ4iJrKF3Ij27Q5FSP814niDRIzjQNksQPjlqbBrNlr
	u+bJsR//tG4c3dRoIkPgaOCt1RUmwfxIv2QydRZJjfr0kAq87diwMTFkLRTaa5Dh
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 90ezATQjw04P; Thu,  2 Apr 2026 17:14:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fmpPB1s2Rz1XM6Jb;
	Thu,  2 Apr 2026 17:14:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 2/2] ufs: qcom: Reduce interrupt latency
Date: Thu,  2 Apr 2026 10:14:02 -0700
Message-ID: <20260402171404.3008494-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260402171404.3008494-1-bvanassche@acm.org>
References: <20260402171404.3008494-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Defer completion processing to thread context on slower CPU cores to
prevent interrupt latency spikes. On the fastest CPU cores, keep
processing all completions in interrupt context.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-qcom.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 5a58ffef3d27..4aabbd14631e 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2370,6 +2370,16 @@ struct ufs_qcom_irq {
 	struct ufs_hba		*hba;
 };
=20
+static irqreturn_t ufs_qcom_mcq_threaded_esi_handler(int irq, void *data=
)
+{
+	struct ufs_qcom_irq *qi =3D data;
+	struct ufs_hba *hba =3D qi->hba;
+
+	ufshcd_mcq_poll_cqe_lock(hba, &hba->uhq[qi->idx]);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t ufs_qcom_mcq_esi_handler(int irq, void *data)
 {
 	struct ufs_qcom_irq *qi =3D data;
@@ -2377,9 +2387,22 @@ static irqreturn_t ufs_qcom_mcq_esi_handler(int ir=
q, void *data)
 	struct ufs_hw_queue *hwq =3D &hba->uhq[qi->idx];
=20
 	ufshcd_mcq_write_cqis(hba, 0x1, qi->idx);
-	ufshcd_mcq_poll_cqe_lock(hba, hwq);
=20
-	return IRQ_HANDLED;
+	if (arch_scale_cpu_capacity(raw_smp_processor_id()) =3D=3D
+	    SCHED_CAPACITY_SCALE) {
+		ufshcd_mcq_poll_cqe_lock(hba, hwq);
+		return IRQ_HANDLED;
+	}
+
+	if (ufshcd_mcq_poll_n_cqe_lock(hba, hwq, 4) < 4)
+		return IRQ_HANDLED;
+
+	/*
+	 * Defer further completion processing to thread context because
+	 * processing a large number of completions in interrupt context on
+	 * slower CPU cores can result in unacceptably high interrupt latencies=
.
+	 */
+	return IRQ_WAKE_THREAD;
 }
=20
 static int ufs_qcom_config_esi(struct ufs_hba *hba)
@@ -2415,8 +2438,10 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba=
)
 		qi[idx].idx =3D idx;
 		qi[idx].hba =3D hba;
=20
-		ret =3D devm_request_irq(hba->dev, qi[idx].irq, ufs_qcom_mcq_esi_handl=
er,
-				       IRQF_SHARED, "qcom-mcq-esi", qi + idx);
+		ret =3D devm_request_threaded_irq(hba->dev, qi[idx].irq,
+			ufs_qcom_mcq_esi_handler,
+			ufs_qcom_mcq_threaded_esi_handler,
+			IRQF_SHARED | IRQF_ONESHOT, "qcom-mcq-esi", qi + idx);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to request IRQ for %d, err =3D %d\n",
 				__func__, qi[idx].irq, ret);
