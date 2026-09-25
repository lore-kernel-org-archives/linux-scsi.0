Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8652D63E5
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361133; cv=none; b=hjNDK/i7juGFOy9TPkVHPQJNYVof2kLEajXYaW7qxoBX6tkcEitz4LlD1vS4d2ItJ7iUBDSagmG5X+ezaZ4AXp2X1eKecTI73mtA3cgjgYgyG0OQnH2YR4O+HYgY4hO7vazYf+aJd+MaYHtJZStC5EATZb+DBFu69qtos4OIvNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361133; c=relaxed/simple;
	bh=342vbo+jSWIuvus37ymB6JWKPsI1lGe4DPDO3gcGr4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjydD2jNHXrzNkxFlzcqn4S2QfjBoofFEAV0VX3yWzv/E8ddCqcMKJE8gRoleP+o+BPzsDnA3IVmLLZ2wJykSNB5blL0T4wP/Wi70uPyr4NopjzxmBiu5Lct7xQJz9715ch2DxHgoMcHzMjiIm04w4l5lqRXU9B56LzxC03MVZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RV5tg+wR; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RV5tg+wR"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrznl3w92z1XM4Sx;
	Fri, 25 Sep 2026 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361127; x=1792953128; bh=03fq5
	As8Qpku8FY12z+wW/QDg5KsqYGNC+LpLlFZhEE=; b=RV5tg+wRaVOHM4KYPvfU6
	7aqoUca5QGRnvXU0qO9EH2tqIlOrfMWxz/DmwBEC8UsoPio+FXPCwZbjwI2P17bP
	wqaNOo671z3P0AmOElQrJYYCcX4UY4YJjybDc/xiQLNdubacx2+0rdgG85wtIKQ5
	HRz1SNSgTziUt1S3aSRduZeO3As3qGr504cOrNA/3ZT5Y9eIJXlre7dlIXmRWdgO
	EEautyyH1oOLi3mTuj6dWHhUqve5t3Z+K/jS2FmK/PzPb/FG+s7hhneyqs3AF+C1
	zLV8+/Nv6RZfNBeLCP2V65m2HOrqLxWmxmSmY7pRcQ/bLLFiVShgd+EiBUVIqzll
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0gUpIGjXpw-v; Fri, 25 Sep 2026 18:32:07 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrznd5Jt8z1XM5kW;
	Fri, 25 Sep 2026 18:32:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH v4 37/54] scsi: libsas: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:26:15 -0700
Message-ID: <15aea1d6d04eed87a84c23a6f3eaa487378f0bda.1790360262.git.bvanassche@acm.org>
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

Since Clang requires that lock context annotations only refer to
variables that are visible, modify a __must_hold() annotation.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
index 61368e55bf86..2340790c9f6b 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -153,7 +153,7 @@ static void sas_ata_task_done(struct sas_task *task)
 }
=20
 static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
-	__must_hold(ap->lock)
+	__must_hold(qc->ap->lock)
 {
 	struct sas_task *task;
 	struct scatterlist *sg;
