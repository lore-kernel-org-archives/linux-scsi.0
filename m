Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE81B137743
	for <linux-scsi@vger.kernel.org>; Mon,  3 Jun 2024 17:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435427; cv=none; b=MThFlS6Kmgbj5h0NUmg1G5O5JerwChPoR/kxfgOUD3AUuureqbuX5LXYwBANCJBCEu6jY+TUSqqRrWv5V234qnbENPF6k81DFxEV6wuL79R0zCUSgq8jHD63TTfNsIclUPF897B8iuF6aoI8TBPdBZYfFLBofVNulPic2PJWLlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435427; c=relaxed/simple;
	bh=Y+WJXP2fX6/PN7mqVvMwD05H59nuDB504BFx05kTk6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iecVaAwQsK9kTMMAXsoPNGGOp5KBdelDEBtKDgjbyO5Dw+hoFixhhfc+x7q0Ru1HszZ9iBHEOMvw/i5O7JFKcabEqPyA+AiPt3D1/r8gKjtu+yksQ8PeIewfBC3pvritMw2ll8h6DJ7v6RBvp2wO8HJGaZA847/chs2JCVvGlbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hp00Rr4+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hp00Rr4+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VtLDJ4rtnzlgMVc;
	Mon,  3 Jun 2024 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1717435422; x=1720027423; bh=ohrV4
	IM//73hbdg9v1M/xlYjly9AW97YPEhnHqeG9SQ=; b=hp00Rr4+ae2a2V6NnTfPb
	1oop6fSgzXFrpGpZIcfuNqRO3dhxsY2pUfHFJAwHqSEp0Uc723dZgRS9nTPXvdQI
	6QA/y0cdzGGjXJURqx2Han96m/mfrWsUOrPsAWDWkT2qo8do/Iry7gy8rKSq7Tm4
	EHd/MgXFIzxfPQQQH2m7OQnpxLo3eMBrzRWsjPorYBjhUohHBIp9de8aaWfD6sGl
	V+mu+DFYaZW0d43GzZu6EEMbh2VHFsf9+GAXlEcvHn/OYJIPpIldK6SAyQ6i8SqJ
	qGX4yj5TMDhAfpS80g2022mmSthLTXkupoS8P4AISO3g78xIB/XsyYqpeimS05/k
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kemid1vhf7BG; Mon,  3 Jun 2024 17:23:42 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VtLDG3Kr6zlgMVY;
	Mon,  3 Jun 2024 17:23:42 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Russell King <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/4] scsi: eesox: Declare local functions static
Date: Mon,  3 Jun 2024 10:23:10 -0700
Message-ID: <20240603172311.1587589-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
In-Reply-To: <20240603172311.1587589-1-bvanassche@acm.org>
References: <20240603172311.1587589-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/eesox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index b3ec7635bc72..99be9da8757f 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -381,7 +381,7 @@ eesoxscsi_dma_stop(struct Scsi_Host *host, struct scs=
i_pointer *SCp)
  * Params   : host - driver host structure to return info for.
  * Returns  : pointer to a static buffer containing null terminated stri=
ng.
  */
-const char *eesoxscsi_info(struct Scsi_Host *host)
+static const char *eesoxscsi_info(struct Scsi_Host *host)
 {
 	struct eesoxscsi_info *info =3D (struct eesoxscsi_info *)host->hostdata=
;
 	static char string[150];
