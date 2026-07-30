Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F6F3E49DF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451630; cv=none; b=LduhyA0TpETOts2g2/QFFzV3wk3at2JKMbmRuu1EGkj/D86Mybczz8QHeIIGF9r9TX4SOnrpAO/mVDAqCFGriIrFfqwj4181jmmdDvUPBoOPFnBeN3j0H4eNC/j0UtA/UMbpf2wyzN/8GlYVA/hiRqcmrhcEIBrLyN3kQX0Ns3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451630; c=relaxed/simple;
	bh=RPSqlyVcrDjD3TyHDhbtTp+CYlig+PugFITVpvIhexE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSr1/Qe4OrssIMZjTXK1G8fEhDkQGlgUcb2KH+qPUpKPJr3vdPrAwaaf5luIHeRxVtq4/iPl9bMHaI629LmtfPZQ/+B0F002l+OeAT3QcTqVxgXpGvHTu4fES6RiDIgvaCp0lr+boL1c+Dj7Cd1c69+swueNqQbVgXFWts5YQEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hwv/4ZKE; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hwv/4ZKE"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48D3PKdz1XM6Jn;
	Thu, 30 Jul 2026 22:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451625; x=1788043626; bh=H3cBp
	wEs3DjpsYI96fr8/RXLpTdX3J+hBmOfzTi+6t8=; b=hwv/4ZKEjfHzBkj8RwDpx
	BiBfeKS80ObTFsTL+4h39VJpFDgkS2dVOISfbwxtluR2km017W/A3tvgX95w0Sxi
	57XmOPRGC8MfagIOjOmy+jX2o1O7GjtAti49/rgB87Wcgfax/kh6cQYA+OD11sxJ
	G0GXBEjyoGBMIiW/bEoRqqaV/w7c5lwqtyCQn+OSekT8xUtjWpkF5bvbg7gkJ70j
	r3W04HQpQNJVp383Gu+5ONXYm0W59h7+Mqge6Z7ftdV6LIqtVc0m5eLHEPMOMryj
	BIBeGErHOti05dSXb1BCKdgVLD54cqj4/EqO4uJcSd72c7CRKji5W2ECF4uyL+a7
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iECnvs3jcs0M; Thu, 30 Jul 2026 22:47:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48817nYz1XM4TB;
	Thu, 30 Jul 2026 22:47:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 04/57] scsi: st: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:44:47 -0700
Message-ID: <d9f861b2abd75ddafee3d0bc778621bb7e83037d.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document what mutex is released by st_common_ioctl().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/st.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c4946637..234482e1b70b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3535,6 +3535,7 @@ static int partition_tape(struct scsi_tape *STp, in=
t size)
 static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef *ST=
m,
 			    struct file *file, unsigned int cmd_in,
 			    unsigned long arg)
+	__releases(&STp->lock)
 {
 	int i, retval =3D 0;
=20
