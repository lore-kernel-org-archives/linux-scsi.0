Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2554346FAD
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 18:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588041; cv=none; b=tyb7C4ZUShPRsq6zXgd9FLuun4NZvs1GN+808X9cMaitKPGoceodmhClHK42+vYo8EyJnDe6ZFjcDbOUp7PpvnCTT1bIPqdm+CMsjcgblkeXpSV46umgpxfjMaMZMrH6exhwcWZoPbHyJwMkqp4S0Cm9p9hoKCp8DMXUfcQBMoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588041; c=relaxed/simple;
	bh=Dtg+h6YKeMYXPJjhZaQo8VUXSBAv3MZ+nXeA1Vzqnwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spFfLhtSBWIyW7832Xh/YNwMs3Y32juHnSVyMNoFwQ/5jUwwNXqaliDJ3UyVUnVdiGsvjkQ+iQHcuphEBOsWu02Ro235s9yKSF44KT4fgxJSTgHoNuRQVz38fQ57OErch8dVRnXI4cEKUKFBwk9M4DgyOeUtM409+c/FlP3MRp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0aCjYPM4; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0aCjYPM4"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dt7cR3yYyzlh1Vx;
	Fri, 16 Jan 2026 18:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768588037; x=1771180038; bh=nAU2/
	UuKcSxUaO353ELL9DNIz4cFK2MS6iJYWtqg1ss=; b=0aCjYPM4Zibty370PHwVH
	RniSX9hWfFU2n8BTd88iKYZ4ensUH16YVaw03ds2OQOmKovNYPFcfpSNHClH6xG/
	fDJX+nuC29GwAtQQiQNbQKEIcIEebakCkNZ+XzpXdlbdG9AZvjpek/SnnkEismE4
	DRdTGH1x4sNJMetyb0/vTJLXl3UGaOTrduphw4GiVWmz7pho88uJDLwz7wA+4Zu0
	PZuWtCpET9/4tWl0495jC+JwyA6te0bu2OFEt1bP0c43mNthyIkKD22/Orqlb4b5
	i5Gz0Uq9+I4vFwuLwAWIFz9ONi2CCc5Qmnn3vK0z89lRh0nykf+R/k6ziaTJ5Y4o
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 29YD5F9REYBY; Fri, 16 Jan 2026 18:27:17 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dt7cM6Fhqzlh1W1;
	Fri, 16 Jan 2026 18:27:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 7/7] ufs: core: Remove ufshcd_{hold,release}() calls from the I/O path
Date: Fri, 16 Jan 2026 10:26:09 -0800
Message-ID: <20260116182628.3255116-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260116182628.3255116-1-bvanassche@acm.org>
References: <20260116182628.3255116-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Patch "Switch from clock gating to RPM" makes it unnecessary to call
ufshcd_{hold,release}() from the I/O path. Hence, remove these calls.
Remove the code that sets host->queuecommand_may_block since this patch
removes all code that may block from the I/O path.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8c388275308f..3cefbd69ab46 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2892,16 +2892,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *=
host, struct scsi_cmnd *cmd)
=20
 	hba->req_abort_count =3D 0;
=20
-	ufshcd_hold(hba);
-
 	ufshcd_setup_scsi_cmd(hba, cmd,
 			      ufshcd_scsi_to_upiu_lun(cmd->device->lun), tag);
=20
 	err =3D ufshcd_map_sg(hba, cmd);
-	if (err) {
-		ufshcd_release(hba);
+	if (err)
 		goto out;
-	}
=20
 	if (hba->mcq_enabled)
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
@@ -5403,7 +5399,6 @@ void ufshcd_release_scsi_cmd(struct ufs_hba *hba, s=
truct scsi_cmnd *cmd)
 {
 	scsi_dma_unmap(cmd);
 	ufshcd_crypto_clear_prdt(hba, cmd);
-	ufshcd_release(hba);
 	ufshcd_clk_scaling_update_busy(hba);
 }
=20
@@ -10676,7 +10671,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	host->max_channel =3D UFSHCD_MAX_CHANNEL;
 	host->unique_id =3D host->host_no;
 	host->max_cmd_len =3D UFS_CDB_SIZE;
-	host->queuecommand_may_block =3D !!(hba->caps & UFSHCD_CAP_CLK_GATING);
=20
 	/* Use default RPM delay if host not set */
 	if (host->rpm_autosuspend_delay =3D=3D 0)
