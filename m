Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B913BE178
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360971; cv=none; b=Jg7Xe/9UalzwDoR1INLhsqvWMth9zrkxYZf1SE2qiPhX5NiPWlgJ/qVn0jj00vfnqvwRvx1gX/yxtwtNx7DWHVKlSIDGarsR5/QA5ScunreQW93T/R2Cz2Zr5vW7IFaIL3KL96/vod4mQkQJas+tbqcTDQzaRmewemUpH5m5kEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360971; c=relaxed/simple;
	bh=vVHxKg/CcHvIDsO2xzGwGN5dyt7ejLDBb/8mLOkUXrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qm+iyiBVYaMcKmJS1dLmMwjS/w6ckBxXZaL2Wc84LiHOBj5felm70uEMPkTjhkJURckTtEAQheOTU8m8AmqREZ0D/v2VADRqZNRqe1M8Ry0J1yQ3X+BXkziDSGsAGSXNIINUYj+RcQg0As/UUuA9SG3YKQDXu+O3ahTPoQ1PVz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Gr3sD//b; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Gr3sD//b"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzkd6fs4z1XM4Tl;
	Fri, 25 Sep 2026 18:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360967; x=1792952968; bh=vVHxK
	g/CcHvIDsO2xzGwGN5dyt7ejLDBb/8mLOkUXrs=; b=Gr3sD//bBwImYwhXvv8y6
	68C7EYf92zt2vzem1URzOUEa6Y+G6ZpPOV1okvnDRC9XWRc1kiGCCng+vdYwMqEE
	DTm3fmKvAf6SSoGIEaW3rnEQit5yMd8dPR3Zn+hxuesLgl5SjKqyuFH/mD/Bcmqg
	ICbvwgsB4KiTrXUNrX9nddXC2wiMdYvD/JxgmDwaUx2fLB8s6/e9FjRLI9snieoH
	LyKVpXJTkuWBnFa0+//Jm9zCs3bP1k74xFUuyqa5dzq6hcGoAIQwOUnXc+mqpFt/
	RAtrortGmqA7jixPNYE7cZ5qDpy8qIaGuAD4uXHtUBk8/FWDh8N7GYLHtMa7xky6
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id p8dquUD5-aM8; Fri, 25 Sep 2026 18:29:27 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzkY0PgLz1XM5kW;
	Fri, 25 Sep 2026 18:29:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 10/54] scsi: aic94xx: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:25:48 -0700
Message-ID: <ad452cff7f934476d9bdadd22d2ff6c73eedb0f7.1790360262.git.bvanassche@acm.org>
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
