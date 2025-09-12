Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AD332ED3C
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701682; cv=none; b=mVBqqK8hjdvYYVBy6ckCwS4vYg2a4+TSLYQScUp/TP5KKz6gXOFOxqiY6DybTz2w23VZZkTzBbSL+2LrCgvuh/jD7/JT1q6+cNzDuwEL9uLmoPolkSfjucPutPY/1eaUSZ38Ty1rMzonmY1FDIuiDHUDWF2ahtUldxUlJ7xxX+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701682; c=relaxed/simple;
	bh=xRKgPSPerkn6iWarLE/0OrDTtal/hcbfzGjHYHW2puU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTaXTDnnFYnXMLvKkQxgUrKv4o58kYebOZwMjHttCFqzRo7A1DPDNSAhYC0r+ILqLpfN4VsU2yPv/MawCtXPh1c/TAY7uJVpLrCKXVzfdRo2sh7X8jXeEszqyLhPZNBaj+WcKFuOEsxdLc1JpiEQ6vm63lOBFXaLa78pXCcKqyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1z7UHN+P; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1z7UHN+P"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjbM4qtMzlgqTs;
	Fri, 12 Sep 2025 18:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701678; x=1760293679; bh=1cH8V
	0bM4gHz5qCWDYzzZHMPYTtKQzFFSq8ZOuH6pHM=; b=1z7UHN+PF0FW+ZncxUBFp
	BDL5qwLyZgsPD/b7R33go+FrpgPudt5qYBDfmSJSYrahkWWA9I+M4RD++OATXjYg
	t+9sF88G7c9jhR/jrP5KPWDEiqv9xXD7RYaOuZPKpBRJlASDiqQes5RkiGakA0PU
	xoILnPL0Y7dasJZbQYeUTHJhec+mX6gbecXXIjTE5DTg7JlrF4B9lJ09DNPJeR2d
	MzUK7V/KXDZ7mCZVYm76q3nSkltBb3YRJj/Sg7sU4yXz0cDrvpXRBqNIhR1tmdmb
	KutZBU/YHVoVj3rDoUkiM5x7KHPa7S+mXBBB2u8esVfkEBH1RvwNzNz8gRjZqtec
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2pT6AZcvK90L; Fri, 12 Sep 2025 18:27:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjbG2T3YzlsxFY;
	Fri, 12 Sep 2025 18:27:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 22/29] ufs: core: Do not clear driver-private command data
Date: Fri, 12 Sep 2025 11:21:43 -0700
Message-ID: <20250912182340.3487688-23-bvanassche@acm.org>
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

Tell the SCSI core to skip the memset() call that clears driver-private
data because __ufshcd_setup_cmd() performs all necessary initialization.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ce766295d4ca..f25671ae1b30 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2992,6 +2992,15 @@ static void ufshcd_map_queues(struct Scsi_Host *sh=
ost)
 	}
 }
=20
+/*
+ * The only purpose of this function is to make the SCSI core skip the m=
emset()
+ * call for the private command data.
+ */
+static int ufshcd_init_cmd_priv(struct Scsi_Host *host, struct scsi_cmnd=
 *cmd)
+{
+	return 0;
+}
+
 /**
  * ufshcd_queuecommand - main entry point for SCSI requests
  * @host: SCSI host pointer
@@ -9155,6 +9164,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.name			=3D UFSHCD,
 	.proc_name		=3D UFSHCD,
 	.map_queues		=3D ufshcd_map_queues,
+	.init_cmd_priv		=3D ufshcd_init_cmd_priv,
 	.queuecommand		=3D ufshcd_queuecommand,
 	.mq_poll		=3D ufshcd_poll,
 	.sdev_init		=3D ufshcd_sdev_init,
