Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6520A4078D1
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361109; cv=none; b=naYY6s1vcqmBw7AWbQ2wp3NjJfzDZnwvvE3wU95cJ20upZVHUw8HKLABnlMjdmyUN4UA3tsaYQFvFY+Yfw7NQ/P8+GwUWE0+xUh76X55azZy/o/cRIsAsCd8S2uDf29/kjGoJwKHjZkgMMy6CXCJG+vaBGH0gFRAXGDggz7MxDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361109; c=relaxed/simple;
	bh=U1xFaitJVx2FXBPFah9fQlsh/JjqKQUIsg2Q+sk0JZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbmFNvG/NGWgzCxdU6tHZKyesKbU6ZOMTeiMkKx2g9Dnmn83wSeYi0EmYf8b7KpT7XmecmdRAmlcoECw+NcnbwvdG28nFrFWMdH8f9XnQPvunkBjdGVA62pDawisEWRQ5CbgZ11eFSeC9E7j8kmnkXF1S695p0nSSxecvYAiz+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FXWV3JLg; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FXWV3JLg"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrznH6cYNz1XM30h;
	Fri, 25 Sep 2026 18:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361104; x=1792953105; bh=Y5tc4
	DhEh+KpQaxRySS6r+qFMV5Rylv/FoAUleS9BNQ=; b=FXWV3JLgM81ApCAjF/R4H
	rg9O1QPD/F+Qy0J1txepTj99PE7A92BuyZW4t4AaKfjIZqE2bMUppgFOxwUs/4Zs
	Apq3OzH9Hv92rVHfJopGyOZ476XvB/uT0IvxORJgWlY9W3TjnM3zm9y95LXuGhDv
	UIAQy0+mV4RESnhJQcKKZCavl+Sbj1ll0v3XDft3tl4oH0vxiWdM9s6eObyAFqwy
	hhtSO11Pevqo3bLX5MZwYbzot1NuSmFmJ5sw4Dtdu8vmkWGuYWdcJr2/sB0hCLDL
	i7Da8KFBTSK2OBeh2OG1f9rkm7TvfHhEpu6Dx+vzfHhAznrbIdBx+1rYlmn5uqSo
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id W0SYh1ekCpFg; Fri, 25 Sep 2026 18:31:44 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrznB1mwVz1XM5kW;
	Fri, 25 Sep 2026 18:31:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 31/54] scsi: ipr: Simplify ipr_eh_abort()
Date: Fri, 25 Sep 2026 11:26:09 -0700
Message-ID: <8427eb7fc8e7c97cf115b9bfff27ed84c35c8bf4.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Derive the SCSI host pointer once instead of three times. This was detect=
ed
by Sashiko. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ipr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 1c74eec3a0c0..d221689d28c6 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5299,17 +5299,17 @@ static int ipr_scan_finished(struct Scsi_Host *sh=
ost, unsigned long elapsed_time
  **/
 static int ipr_eh_abort(struct scsi_cmnd *scsi_cmd)
 {
+	struct Scsi_Host *host =3D scsi_cmd->device->host;
+	struct ipr_ioa_cfg *ioa_cfg =3D (void *)host->hostdata;
 	unsigned long flags;
 	int rc;
-	struct ipr_ioa_cfg *ioa_cfg;
=20
 	ENTER;
=20
-	ioa_cfg =3D (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
=20
-	spin_lock_irqsave(&scsi_cmd->device->host->host_lock, flags);
+	spin_lock_irqsave(&host->host_lock, flags);
 	rc =3D ipr_cancel_op(scsi_cmd);
-	spin_unlock_irqrestore(&scsi_cmd->device->host->host_lock, flags);
+	spin_unlock_irqrestore(&host->host_lock, flags);
=20
 	if (rc =3D=3D SUCCESS)
 		rc =3D ipr_wait_for_ops(ioa_cfg, scsi_cmd->device, ipr_match_lun);
