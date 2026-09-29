Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F114F4C4F62
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724222; cv=none; b=QVExg4UU213EkJ/i1L6r5a9JxIsw3EtVP8eJ5XcBcoLFuBCQKqEqAKMHOOBw6uiPRdSPET17HR1y9Z4XzpFCTzw/Pcz/PqIw7SDYy4DNf9PFaRCJ14EA0cy3H/5UEtUH3xhnlt30LOo4bkCq3xO2ox+YurMwIBzB4PNFmYBuKuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724222; c=relaxed/simple;
	bh=dM4sRFEqNCR9x1u7fWc02bYsKonZD3wyAUnia+USyyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ny30kmBARiy5XzvHl3C3jxr+3NQ0rEWjRRvcgTt1qFV69DgvgrrFoKGH6IJrBVjTLVTQOwiiD+Xy+1eWVe57vL/tN8uREH/3lOO9Zk9bVBnD0ZNNnYM87lznHSxZz8u9xlOxvwL4fe7dfiXLSOSxlI8xTjRM6jWUzLaJaekZbAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aAvJHDMo; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aAvJHDMo"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hvZ4D5CJCz1XM5kD;
	Tue, 29 Sep 2026 23:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790724216; x=1793316217; bh=dM4sR
	FEqNCR9x1u7fWc02bYsKonZD3wyAUnia+USyyI=; b=aAvJHDMon6QZyo76hyw08
	qK4HaaHbkKU5YpxLuM8WmBf3bRMKQhiIx4OmDsyxNeuL8BCbqOJBAkltWSkz/Niu
	Ho9WzQnKRJ+I4s0RTz2BFB88FfU2qqAVoo+Dnp1agOpThjYCGct3XjXQMeh2EbYC
	p4sJokgDfiMCKehHgWh/o7p+OCbzsC0CRbeKTL79WHFY4n0DrPiIWGIiLQtY4fTJ
	6CVQXeCPUhFz+VZhmpmYSNyvlDX1GV3Lw3WojobcmRPL684bmsx+R2cb229Z4Ax6
	CpjrVZPe4OLYC7FkRKQx851DXhklVVlutzOAl+w8b1CtAFXtUCEte6vWaL6HP/z1
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bUWUsXfYGnfW; Tue, 29 Sep 2026 23:23:36 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hvZ464CvTz1XM5kY;
	Tue, 29 Sep 2026 23:23:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.garry@linux.dev>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v3 7/7] scsi: core: Enable lock context analysis for the scsi_debug driver
Date: Tue, 29 Sep 2026 16:23:03 -0700
Message-ID: <281107608e74cedc0a6132e334fd7677f86c1744.1790723966.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790723966.git.bvanassche@acm.org>
References: <cover.1790723966.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable lock context analysis now that all lock context analysis warnings
have been fixed.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 533623382eca..32d816e942d6 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -18,6 +18,7 @@ CONTEXT_ANALYSIS_constants.o :=3D y
 CONTEXT_ANALYSIS_hosts.o :=3D y
 CONTEXT_ANALYSIS_scsi.o :=3D y
 CONTEXT_ANALYSIS_scsi_common.o :=3D y
+CONTEXT_ANALYSIS_scsi_debug.o :=3D y
 CONTEXT_ANALYSIS_scsi_devinfo.o :=3D y
 CONTEXT_ANALYSIS_scsi_dh.o :=3D y
 CONTEXT_ANALYSIS_scsi_error.o :=3D y
