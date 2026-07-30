Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022AC3DA5C3
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451644; cv=none; b=ZCjwLvkzWSxr1+IsB+Rcwx0G1QoyjAraqWfxkdArxVcLKKjaYtB6Bv9Bn2v+G7cPCz0WZyZOf+7zIXxtTNI2lz12y/XaqYk1wlJ1Yiv7MrKQK2Qnm3CzBS/hVwLSCwgm3DoX6t+OfoMseyN3TEp8zTJA6Yc0xw8qsQS4KmUl1Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451644; c=relaxed/simple;
	bh=N+gr+hqGOB5Q54sI/oUwLcBcZAewEvXR2LeWogI9g3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9djFqjbS7JgUtl3flcjJJgAzvhRoIBwLJw1BXYINzZbIE19KrhqGQeU6Cej2NGoaMC+FH0+4tZuAUU070pK2HXqiRBLU/UuHKX2loZ6SKm/CW7bu6Tt3ntCh1pJCzkXU6r+Gx1QQE0708P4E5n6Wq31MPdRc8RRlEsCxT2TSw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ndJ5bAWD; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ndJ5bAWD"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48V45nCz1XM30r;
	Thu, 30 Jul 2026 22:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451639; x=1788043640; bh=o1Tld
	l7ZiAgdLI3MPfWFzUQAcKs61rgRkDsylVWtMtU=; b=ndJ5bAWDmZvSmyPAlBW9w
	hrA33bdZ/GY3DEztwqyylNoq5diivZOdw479HSSHDDz/Sj6PI6TIa6xweQQv7+76
	LISqaCLEv9sxYLSqnm93Kn8zR6Z7Zx0jLlAoLqUGAPTxyJ/HECVqegeegodBNqah
	9PEP9Z9IcZpsBMm4EyKMJoO4luhhPLfiz4GRhBnmR69U3alPsSZgrVhMk644EkJ4
	AFVNZCeUD+WoQu86qSdD5jTu+WuusWFq1mLu7e5z4qbQJK4mHozOBJcencdZHQ7h
	Lj0EKh0V0vC9g2jBtlC61xbRWeCxGLOdKReAbhfmIGiPCoanue8HsxwbHRvX01pq
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vYX5jUV6BjNf; Thu, 30 Jul 2026 22:47:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48P4LKmz1XM6Jm;
	Thu, 30 Jul 2026 22:47:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 11/57] scsi: aic7xxx: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:44:54 -0700
Message-ID: <ed194427a2143eebd670035696db4d9fd6369327.1785451174.git.bvanassche@acm.org>
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

Document locking requirements with __acquires() and __releases().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aic7xxx/aic79xx_osm.h | 2 ++
 drivers/scsi/aic7xxx/aic7xxx_osm.h | 2 ++
 2 files changed, 4 insertions(+)

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
