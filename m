Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FA714A0BC
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755273565; cv=none; b=U25M4oP/jS3kECDPvZ522q9a+hNb0hRrDlIrgTYAiOzOaGJRVWxHIXoeXq+LVdjrRvGbOCOmQJ9qxowYdvWL2M3WgOXSBxhbhmJDwNTnn9XjRtNwuDJ4NAoO10ciVGPlywNTvilZeCppYmfYJFzqrZqz89vKde3n+bvzi5F9Sus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755273565; c=relaxed/simple;
	bh=H6QgnX8fEUpZSKXBZXGlJoPjP0gAxYPVxBppU2wMHdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5Dv1PPgXiD4KG//wXIqHAQpDpVt2swaB4HHkbHtR1hwKEW4MlO+/ktI08wV+KlfbZJRXAncT+yl0ZYSYvPQlNEi6zrJvI/Bw+SMEpM+cHCyS8ldvcNtn40MrBoCGwkzYmIjB+Bp5bj1cG3EAzE4G0u4Arnz8BLQY8soILJtxkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bGLhDTn4; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bGLhDTn4"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c3Rcq1VlQzlgqW2;
	Fri, 15 Aug 2025 15:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1755273561; x=1757865562; bh=gRQB+
	pZhWzq0W9nf3Cr4qJnZ/Gr1jdVwrAcYYCYFTXY=; b=bGLhDTn4Ew8zr+MJLIKu6
	XDWfQjTIifJE6FXJ8Sc2DtZrTd6IyIuK9JvI02eQayo+7nrfnOaAXE6GB1kpXUez
	olroOcJWHGsXhi2TaFRE5XABlik4MDVPdvjGusgJhk0liGzT9eSHAbnpwUAK5pkY
	fiPsNqPghhPPNrKzRgw31swvhNGwRWOrx/hJAUnIMqCJNNcNlKlhYe+lCjh+Ym8U
	KOVcq3f/hDjAuMab9jN60kEIynaRwHjzvZTAYGAqSHL6FjpcM4bV1IGLJz5gFhwU
	XaAhsE+1e0VBCve9L5RLg7eWjsSv6nGlIGp16nKP8R5+29Wt03Bl9rFjKTDFzv4j
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mN1pW-8EEB5q; Fri, 15 Aug 2025 15:59:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c3Rcd5Xl9zlgqVS;
	Fri, 15 Aug 2025 15:59:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v3 2/4] ufs: core: Remove WARN_ON_ONCE() call from ufshcd_uic_cmd_compl()
Date: Fri, 15 Aug 2025 08:58:24 -0700
Message-ID: <20250815155842.472867-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
In-Reply-To: <20250815155842.472867-1-bvanassche@acm.org>
References: <20250815155842.472867-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The UIC completion interrupt may be disabled while an UIC command is
being processed. When the UIC completion interrupt is reenabled, an
UIC interrupt is triggered and the WARN_ON_ONCE(!cmd) statement is hit.
Hence this patch that removes this kernel warning.

Fixes: fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier=
 to analyze")
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ec4e860f5c53..8ebacf5dd959 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5561,7 +5561,7 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_=
hba *hba, u32 intr_status)
=20
 	guard(spinlock_irqsave)(hba->host->host_lock);
 	cmd =3D hba->active_uic_cmd;
-	if (WARN_ON_ONCE(!cmd))
+	if (!cmd)
 		goto unlock;
=20
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
