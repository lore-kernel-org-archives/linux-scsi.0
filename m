Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6E7409273
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360965; cv=none; b=dZ/yu3yDDlHuo9815lhNbBfON5wnygPZeJUFhFNd8EsHXUOAlwvfmylqyq48EbFJtBia1GEPM6OVyvKW5bFC18Td5HyWr98h8SCFgXfhPStLyokIkbApTd0vWVntHDej6NA1YrOgQ7ForgkJNcQt8GOnoX7vqgi9+ys+jbRxIi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360965; c=relaxed/simple;
	bh=PM0kJJIQNrIQ0cA5V8rDY6FhWjBtgQIzGBJJWREdkVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eA5Cm2yqVErazCPRu4TdU57cakpWT8yy0aNrfW+BklH+FtsZJKCnpupwWduNmybKqPg2SKb8p7JGNtSnenIGAraJVY/rBTMq/BLUcURT7WB/Nd+GiVIiMHkHzBF+6CIXnSDmXrp/gHfbwd0b0UvgCtADZ/zST1vy7wXaDslZphg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ENm3ohkQ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ENm3ohkQ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzkX3Ft9z1XM4Sx;
	Fri, 25 Sep 2026 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360960; x=1792952961; bh=kclo6
	XW/yF/NjpSIoz4HYsvzc74o+ejZoQyRfXGASY4=; b=ENm3ohkQcIuh47SRTBZ8w
	f9Cb8sJ11cWqOF66FoT5vyW7M0JChkyYNvGWpBgs1WHA/tiS3+fa/IX8kq4Nlt7f
	ETSzl/YSyQjG3o2h8i1QGLzWzj+rwjM+aSrcfAThyGuc+i9WrGCwzq3HFEcVpw8v
	VjPDLvEPCKX3uC7VXQ9PpagOSS9cJ+fgkIQD9cU2RVVFMGEfNSGBAIYb45zhrAJy
	GQyOCx9h3aPrxOdMppBmNEl/EWYKSIOUlNEkB6DuIfD6kE9R68Z6n6yuOqOqwOYm
	rGc9lnzeqm96XN8F3aJE1+dx7OFTI4xrvx4dKDWPZOpfnw3FOMfg+8CTkXlhslla
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xK9OciQrq725; Fri, 25 Sep 2026 18:29:20 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzkQ4hwNz1XM5kW;
	Fri, 25 Sep 2026 18:29:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 09/54] scsi: aic7xxx: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:25:47 -0700
Message-ID: <a4d826939ec5c251dc8fac03a824ed3ebd218eed.1790360262.git.bvanassche@acm.org>
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

Annotate ahd_lock() and ahc_lock() with __acquires() and ahd_unlock() and
ahc_unlock() with __releases(). Enable lock context analysis for the
aic7xxx driver by setting CONTEXT_ANALYSIS in the Makefile.

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aic7xxx/Makefile      | 2 ++
 drivers/scsi/aic7xxx/aic79xx_osm.h | 2 ++
 drivers/scsi/aic7xxx/aic7xxx_osm.h | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefil=
e
index 853c72a81ae0..2da370d3d904 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -5,6 +5,8 @@
 # $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#8 $
 #
=20
+CONTEXT_ANALYSIS :=3D y
+
 # Let kbuild descend into aicasm when cleaning
 subdir-				+=3D aicasm
=20
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/ai=
c79xx_osm.h
index 793fe19993a9..c6eb2b97e929 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -376,12 +376,14 @@ ahd_lockinit(struct ahd_softc *ahd)
=20
 static inline void
 ahd_lock(struct ahd_softc *ahd, unsigned long *flags)
+	__acquires(&ahd->platform_data->spin_lock)
 {
 	spin_lock_irqsave(&ahd->platform_data->spin_lock, *flags);
 }
=20
 static inline void
 ahd_unlock(struct ahd_softc *ahd, unsigned long *flags)
+	__releases(&ahd->platform_data->spin_lock)
 {
 	spin_unlock_irqrestore(&ahd->platform_data->spin_lock, *flags);
 }
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h b/drivers/scsi/aic7xxx/ai=
c7xxx_osm.h
index 51d9f4de0734..5e78fe7d3f32 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -389,12 +389,14 @@ ahc_lockinit(struct ahc_softc *ahc)
=20
 static inline void
 ahc_lock(struct ahc_softc *ahc, unsigned long *flags)
+	__acquires(&ahc->platform_data->spin_lock)
 {
 	spin_lock_irqsave(&ahc->platform_data->spin_lock, *flags);
 }
=20
 static inline void
 ahc_unlock(struct ahc_softc *ahc, unsigned long *flags)
+	__releases(&ahc->platform_data->spin_lock)
 {
 	spin_unlock_irqrestore(&ahc->platform_data->spin_lock, *flags);
 }
