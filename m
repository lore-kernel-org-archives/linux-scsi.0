Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8C25464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451646; cv=none; b=gsUCanlm/DzXPm9Mo9HbS/p0AiLmQQwqt2GcnqaairQjMdbTvGKj+uCVExSYf8MMEiwWladc0w3L1qdcKpXdUS9x+NdNto9kZcVeF50kOdneI1j30vzxVmTHhESTrY4nR5e8xDD7VCyRihuSs3vzJzGBHghnvVsqoMugqEg1z+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451646; c=relaxed/simple;
	bh=vVHxKg/CcHvIDsO2xzGwGN5dyt7ejLDBb/8mLOkUXrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBeZrPwPvReqrr2xlkmijOdjsfcs5pCt1aIu8kQen6V3BtsetiYtiifCjgI+yoXB0o7nifNDJ4r9jAVitPdkbCRi2wXgqExA0ho8xW8na4i+9er+6rKErIq6nvjmTx//tLW73qDZ1dpNXRaMtKphfPSAAUNx0Y3nGJ8t8gKlq0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=D+YGdzuQ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="D+YGdzuQ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48X5d3Hz1XM30k;
	Thu, 30 Jul 2026 22:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451642; x=1788043643; bh=vVHxK
	g/CcHvIDsO2xzGwGN5dyt7ejLDBb/8mLOkUXrs=; b=D+YGdzuQSwDYxFtvPMGRp
	ZuFsN+5yQCp6In+Nmh1N3U718jm4U1PKkiCSEQgpomF0WUh7DZ6ydjyQLNS0yLgE
	uR+o1Ne8/q6gbIOMNvI08lx3FqMT0g/AAFuzm1dLOGq9VNNkq+zXB28ydvxR6chN
	P5Nmht5MU3DBi2lKA83MvVbmsqpfVQdmJl6CdIrJviYPeV78CVbK4fz8j5NtPBd7
	X0CiDLEI3pYq5JkQMReBYW+ZRtx7NiXbgUZrp6K9tZ3+Cbr8PFUkdzuwnOLXKxqp
	D7UetZ6RiPBF9Jr/YjP6p1IJeaZoox3o8JP8nOMvZe6eo980u5vb4ysgajDZj0TU
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8NhXGpxZ06k0; Thu, 30 Jul 2026 22:47:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48T2Ftmz1XM4TB;
	Thu, 30 Jul 2026 22:47:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 12/57] scsi: aic94xx: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:44:55 -0700
Message-ID: <55d3bd00d40c771f73a4e01395beb172cdc8f826.1785451174.git.bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aic94xx/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aic94xx/Makefile b/drivers/scsi/aic94xx/Makefil=
e
index db9fbe3a8e4c..4ab04ce6edf2 100644
--- a/drivers/scsi/aic94xx/Makefile
+++ b/drivers/scsi/aic94xx/Makefile
@@ -6,6 +6,8 @@
 # Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
 #
=20
+CONTEXT_ANALYSIS :=3D y
+
 ccflags-$(CONFIG_AIC94XX_DEBUG) :=3D -DASD_DEBUG -DASD_ENTER_EXIT
=20
 obj-$(CONFIG_SCSI_AIC94XX) +=3D aic94xx.o
