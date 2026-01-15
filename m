Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18659318B91
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 21:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768511057; cv=none; b=n2+ggnJ0WlpC+rxJM+xD36oo3v1d10VBCo1wOUlRF6d0s77qh78m2vomFXqnzBFUs4HOvZaZBW65jauu1/gzy6+XvXoVuE7QTdlNI3ddVqvv+1LZLwAAQGz8oegxhD4eIjUiRjzBqFiwr0+godmpxAON7yAKvL6+ylQXdGXORns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768511057; c=relaxed/simple;
	bh=KzuNgbIbEixgcNhHzHFz/lYln+jnZ5L/63qyRFOipNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIDEOFEKHiMVaScO81lWXuByuneGQtX+WVmB2AwnZwGYW+7t1uh7LN/BdczIVNidNQh/NL4VBUyHaG2WFMkswvFOyaZ/NrX8ey9tDhh7HM8tDd5Mt9YL9ZEvX0aPzlo2ei4LM4mcfc+PZ2iE/xHUp5uYegLzsLAVWzGpWayEFjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=K4TIhyJU; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="K4TIhyJU"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dsb7z53yhz1XLwWq;
	Thu, 15 Jan 2026 21:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768511053; x=1771103054; bh=dGMFB
	TCiZrpqmf1Xq11BCZjkAeKzLFeAxAArhBM8WBM=; b=K4TIhyJUCZEs2x5eJHpyJ
	D22g/iifaMt5Bp3UeGSxSyyQdbonpxriFczbbfSZ7tjr4VKXWweT5SbKsK9vBWQ4
	Heod4IQ8GOV/CdZyPX8cQDZLbtwY6aoOcUPqAogUYB8h8BjzQpDIDSc4D48pFZ24
	sJi2MNe8BBll01xeaQZw1FqluQdZVJ2BRBIUwzrbQitzX/ef3r6w1ThS0RRbh8in
	KWADuzRihVL37hGDKupPnqe+ciYBCtzRvostyliGr/SCFAPvfSpEw58ZpXgw2x9s
	A5drrzphKfOpMeLITqiTH2xUomZ3t4cE9iF4gHw4XSE5LXg6wq8cHi8RRl4I1dw2
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AUS2WXMsFbSF; Thu, 15 Jan 2026 21:04:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dsb7w3Mrbz1XLwWt;
	Thu, 15 Jan 2026 21:04:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 1/5] scsi: aha152x: Return SCSI_MLQUEUE_HOST_BUSY instead of 0x2003
Date: Thu, 15 Jan 2026 13:03:37 -0800
Message-ID: <20260115210357.2501991-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260115210357.2501991-1-bvanassche@acm.org>
References: <20260115210357.2501991-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

.queuecommand() implementations are expected to return a SCSI_MLQUEUE_*
value. Return SCSI_MLQUEUE_HOST_BUSY from aha152x_internal_queue() instea=
d
of 0x2003. This patch doesn't change any functionality since
scsi_dispatch_cmd() converts all return values other than SCSI_MLQUEUE_*
into SCSI_MLQUEUE_HOST_BUSY.

Cc: Juergen E. Fischer <fischer@norbit.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha152x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 182aa80ec4c6..f7879c81d9cb 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -939,13 +939,13 @@ static int aha152x_internal_queue(struct scsi_cmnd =
*SCpnt,
 	if (acp->phase & (resetting | check_condition)) {
 		if (!SCpnt->host_scribble || SCSEM(SCpnt) || SCNEXT(SCpnt)) {
 			scmd_printk(KERN_ERR, SCpnt, "cannot reuse command\n");
-			return FAILED;
+			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 	} else {
 		SCpnt->host_scribble =3D kmalloc(sizeof(struct aha152x_scdata), GFP_AT=
OMIC);
 		if(!SCpnt->host_scribble) {
 			scmd_printk(KERN_ERR, SCpnt, "allocation failed\n");
-			return FAILED;
+			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 	}
=20
