Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65C0311C16
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933912; cv=none; b=aqmF0yqKuxxWQ5r0dYR/d44P1a2yaSBXxRg5Xlp+Ky6ss58tAYrwg4iZFVkzrRuDYPGZ1bryml9J7i1KLimHHboQDhV4MhjOTQcLPxDLjvWhe9j62O+5POe2HphWAMfDkjcMs8NuyD5MTCZVJ7L0IeRZ94MUCTAnYkVNqhvAlaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933912; c=relaxed/simple;
	bh=vK3k5gHyrYYM0FkNn79tHn+eQ+ExH7+SAk68228lPT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmGJCLqFMwfH5NXhPji1W0J88Ip5UX2ZuJ1wrln2SQ2fZXuAbCeIQFcijov2S3QM2JJWKjRpZ5ZMNraExht/pkicfcLNVkoH3hvCROdq7eOgFIYnftjXf3r478BoNGNBqDU0tagJ/R1NPjffpQTCUc0wm5SadhdPPtsg23GRaso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W8ydk21r; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W8ydk21r"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c12115vRHzlsxFl;
	Mon, 11 Aug 2025 17:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933907; x=1757525908; bh=VIy+z
	1H9OGzgQQ+B9dpSrx9ZHfffUsWlJeW6W2sV9Ac=; b=W8ydk21rAelRyUSaY7ZoD
	9l7gwIZH7lUuDolqvlXDw6m3OBMSDzKsMSU9zQixpI6Kt/R3xnyDzMx06xssVfQH
	cXq1eGkFGWyFC/588z1WBK14t99IbXTTfVknLZKFkEJhpfHuE62GdE+yhhy4rn2l
	TozTR8/GCB1y19R0WlPXC7YA7WfTyewK2w/PaVAD6tyJlOmzMEg8/H+b7VyrqOQo
	Z+a+aVy+tdKrLzF+/El3ZK2by/qdF1ADSYYH1miiiPWh73LOHq0uTWOg+DRs2JJB
	qfhHx4CzwOKRcFsGxfZTtFeNVJYGe3rvk/vWaZZS8GBrsdhGxxuyIC+p/NqkaMkd
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Q_QN2nwvU9JD; Mon, 11 Aug 2025 17:38:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c120t2LcczlgqVH;
	Mon, 11 Aug 2025 17:38:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 09/30] ufs: core: Only call ufshcd_add_command_trace() for SCSI commands
Date: Mon, 11 Aug 2025 10:34:21 -0700
Message-ID: <20250811173634.514041-10-bvanassche@acm.org>
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

Instead of checking inside ufshcd_add_command_trace() whether 'cmd' point=
s
at a SCSI command, let the caller perform that check. This patch prepares
for removing the lrbp->cmd pointer.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fee144f36c4a..2ee735872e4d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -488,9 +488,6 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 	struct request *rq =3D scsi_cmd_to_rq(cmd);
 	int transfer_len =3D -1;
=20
-	if (!cmd)
-		return;
-
 	/* trace UPIU also */
 	ufshcd_add_cmd_upiu_trace(hba, lrbp, str_t);
 	if (!trace_ufshcd_command_enabled())
@@ -2359,9 +2356,10 @@ void ufshcd_send_command(struct ufs_hba *hba, unsi=
gned int task_tag,
 	lrbp->issue_time_stamp_local_clock =3D local_clock();
 	lrbp->compl_time_stamp =3D ktime_set(0, 0);
 	lrbp->compl_time_stamp_local_clock =3D 0;
-	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
-	if (lrbp->cmd)
+	if (lrbp->cmd) {
+		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
+	}
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
=20
