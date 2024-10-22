Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66321CB313
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 19:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729625559; cv=none; b=jSbFuC6Gz+fNn8EWBqoydn0jy+CK+PvI95naEI9GPu0pVlsDbaMUkxt7NSAqhTZykEgCAbR4RjS5ase6+YimSj8scgjk1tyPoLlw3c0b73xmUHeM/XxIjtZndwxAEn9SKhZizyDkDDqbihVQES6tCBKCnEY65qcWt+JWccp5Ttg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729625559; c=relaxed/simple;
	bh=0vIe6xWSb1uN2BA5mvu1z7guMNkF+Ujgi+3cuq/Udt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8DzWuLrCH/XZgRlSaNN7vqbhCHfjxonWrvd+d4WbEtB2xBZ3UQmOZ0Cna8Snri28qc8I6zCyGRSA3omNxuZEfbwYuY3XoOwX1D8pbguCEQJ8Nb/hTd7xEbgrpH6vPr4Njlh6FOfAu1W7JoZetyJ1TsS/stZuL5cVP5bMuTHJSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aT8+pknA; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aT8+pknA"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XY2Px1y67zlgTWQ;
	Tue, 22 Oct 2024 19:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729625553; x=1732217554; bh=nB3QP
	eIa5Mj1kg9/4TSYwcyOx44JbRot9yLHLuC0ONI=; b=aT8+pknAmHQ3oroh0dQ7S
	JSxKy2zZ0HBpdMvDiHTusVrPpRLPcwilvt6N3Rm/CjsQU70opkn4nbS2xQQFWW/G
	ul++Kab9dJU0OTbdWvEEje/QewTRmfiF3ajO/6wn9ym4qHH4IdNRA3A7RkqUX7d3
	CdYdg8EzDB7aNR9vzuPiQ2oCeRBLsjN70Xwf28vhj0ewbNtQ+XAzFTvSQu6LI8ce
	88jxHXywR2mCisw+uFPNIDmZK8akXCWOGWiqzh9lb2d0KnUkNnvALYpyHBqbGHtn
	3RSyYRZBFs/K+cldDrWheziAumXE48enslbjbEGGpnDa9Y2sa3ba7xJGy3gvJcIl
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2DGf9deozXm6; Tue, 22 Oct 2024 19:32:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XY2Pm1LZ0zlgTWP;
	Tue, 22 Oct 2024 19:32:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v2 4/6] scsi: ufs: core: Simplify ufshcd_exception_event_handler()
Date: Tue, 22 Oct 2024 12:31:00 -0700
Message-ID: <20241022193130.2733293-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
In-Reply-To: <20241022193130.2733293-1-bvanassche@acm.org>
References: <20241022193130.2733293-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The ufshcd_scsi_block_requests() and ufshcd_scsi_unblock_requests()
calls were introduced in ufshcd_exception_event_handler() to prevent
that querying the exception event information would time out. Commit
10fe5888a40e ("scsi: ufs: increase the scsi query response timeout")
increased the timeout for querying exception information from 30 ms to
1.5 s and thereby eliminated the risk that a timeout would happen.
Hence, the calls to block and unblock SCSI requests are superfluous.
Remove these calls.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Tested-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 76884df580c3..2fde1b0a6086 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6195,12 +6195,11 @@ static void ufshcd_exception_event_handler(struct=
 work_struct *work)
 	u32 status =3D 0;
 	hba =3D container_of(work, struct ufs_hba, eeh_work);
=20
-	ufshcd_scsi_block_requests(hba);
 	err =3D ufshcd_get_ee_status(hba, &status);
 	if (err) {
 		dev_err(hba->dev, "%s: failed to get exception status %d\n",
 				__func__, err);
-		goto out;
+		return;
 	}
=20
 	trace_ufshcd_exception_event(dev_name(hba->dev), status);
@@ -6212,8 +6211,6 @@ static void ufshcd_exception_event_handler(struct w=
ork_struct *work)
 		ufshcd_temp_exception_event_handler(hba, status);
=20
 	ufs_debugfs_exception_event(hba, status);
-out:
-	ufshcd_scsi_unblock_requests(hba);
 }
=20
 /* Complete requests that have door-bell cleared */
