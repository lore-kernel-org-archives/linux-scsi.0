Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FB7311C16
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934126; cv=none; b=QPLZm1YhWmrfeEqD3RFy+u67z22kP8pOLQrogf0ZEr651XwCs/8aBosyRouzpr0uLq7qxf4qMaCKPcRsbtw8VBQF3mpdw91kxZEhtSYS7Z1ZL8u16PBR9YMKmwla2y7qTt3pGueBDddVh9VT2atuEBoGHLrqH8sK3uHbXGXiGSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934126; c=relaxed/simple;
	bh=3FbW8asltJncG1Swyv8UXAu6vGZBc4rXiWjkTgYprxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgPv50MT5XTPCfI9i3D6nOzdCh9XPVRjB6Ju+/KEa5WmNLrfqc07o/Xjv+S8Ext0v2n1j2hsSy7prqzOLaxFtlNbxi9KQ2sP/OKENog1+tInc1UUIQKraY9f4wQr+IcVUoEsSRPcleSjFNmWNC5nEQomaGLOydBoXyBXhb1WyHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jAtv8P3C; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jAtv8P3C"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c125863H3zlgqTr;
	Mon, 11 Aug 2025 17:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934123; x=1757526124; bh=I5TVa
	puIYMu2KqX57b/k6jAQ41LaPczPjCZwN8CPJQg=; b=jAtv8P3Cp/EDOYZN68iJt
	4KGequp1VsHBqtZKsFqNS78bMapP18Y4Qi3Cul73vIBxeFNo0gaZX3GXDXUoqgEs
	7GaGGHTgLjOXOtMCV/NBV1dc2xacDzgtHa62qGBQUuqr7z3mdjQwb2Gd2ZbYEMX3
	v0yCKymhZhkpDL+C1JZ3aXexFhwd+mLU4/HbsRLZ3lK6gX3M5AY4Rl9uoEaJPqB+
	9KsWIhMQAh/Vkvk9NWMDgE/cgK6JpDspPfiN72w1ysVoiC5DMBa7Hd2nd1iHviP2
	aWBBVL4sqtxviO/UKXSpxbR327RLzql0GdlF/n3zKAW463ZdNJfgwpl15La4FgoO
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Nes4-mj6Hs8s; Mon, 11 Aug 2025 17:42:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c125306J3zlgqTq;
	Mon, 11 Aug 2025 17:41:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 28/30] ufs: core: Initialize the 'hwq' variable earlier
Date: Mon, 11 Aug 2025 10:34:40 -0700
Message-ID: <20250811173634.514041-29-bvanassche@acm.org>
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

In ufshcd_queuecommand(), initialize the 'hwq' variable earlier. This pat=
ch
prepares for adding more code that uses this variable. No functionality h=
as
been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9b021567dbdb..56af37706155 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3025,10 +3025,12 @@ static int ufshcd_init_cmd_priv(struct Scsi_Host =
*host, struct scsi_cmnd *cmd)
  */
 static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd =
*cmd)
 {
+	struct request *rq =3D scsi_cmd_to_rq(cmd);
 	struct ufs_hba *hba =3D shost_priv(host);
-	int tag =3D scsi_cmd_to_rq(cmd)->tag;
+	struct ufs_hw_queue *hwq =3D
+		hba->mcq_enabled ? ufshcd_mcq_req_to_hwq(hba, rq) : NULL;
+	int tag =3D rq->tag;
 	int err =3D 0;
-	struct ufs_hw_queue *hwq =3D NULL;
=20
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
@@ -3086,9 +3088,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
 		goto out;
 	}
=20
-	if (hba->mcq_enabled)
-		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
-
 	ufshcd_send_command(hba, cmd, hwq);
=20
 out:
