Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ECD3FFAA4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360978; cv=none; b=hsQV8xy9EuMZPwX3z9lxjeYw1/3uel0z3l6RwlQr6MmWgezzCEVYRD5buJz/Ak+rUxhYGLBde5gDD76zfyGQWqTsItU1jW6D2mr4BFxcFIGhpFZSULVBkvMxImJMNIYvUwCSiW6dA97aw39LQR2MWrj1/V4p0lLbIbBSg6Bz4o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360978; c=relaxed/simple;
	bh=eR+lxdrj9h43hWxvPvQYuh4o4+yZXm2dLUA5q7qAUCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNbxwTXJgZ5ChEs2k+UwSSRSCl0pQrFObhGNPSCUOsntXNsKcaB8VhU3PhgaU5Sr6GGtvllZ5iyzs/3YbJJDMPYYHGq49Fya74WTA/nImDx+IvRbXm54tCma8TwJ6EpqacDkyHR8aZkXT0wJIHPSLlwlEF1Z7LiCRG/C1xGTwWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=H0U+MOUL; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="H0U+MOUL"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzkm6G7nz1XM4Tl;
	Fri, 25 Sep 2026 18:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360973; x=1792952974; bh=eR+lx
	drj9h43hWxvPvQYuh4o4+yZXm2dLUA5q7qAUCI=; b=H0U+MOULLqYnXrQjJgtwu
	ViE8SLbHYmiWtjbkUYBr5s41UGUvODel9/+JODCv92fk0hu5gKyDWgVJqb1d6JBQ
	IAPkYb4hXasx8rnSMgdAhjD2Hf8ohoAbPyXDeSVYZGhQO34ZCD6bd9htu66zo3/i
	PzS8kBeitAstDEoFiZPJ63hP5Q4yfTvBaFOXQWg8wXngjdroUPFMhJ7ImcvOfxyv
	plh+3jhoQimfyZBoZ0tYTH4F3Kn3SmimkAHyC1fO6Wx3zbkwWbss0ScPeCOkTnhv
	+tl+5s8sMrscGzVYoKkmcPaAlW8cl0N0ADpmRXYTglIkV6ptrOliorluHS1Pa1a0
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Yw6uWdWDLX7p; Fri, 25 Sep 2026 18:29:33 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzkh1f98z1XM4Sx;
	Fri, 25 Sep 2026 18:29:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 11/54] scsi: arcmsr: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:25:49 -0700
Message-ID: <98a213b9a65dab8bdd73eb1f9317844f35502498.1790360262.git.bvanassche@acm.org>
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
 drivers/scsi/arcmsr/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/arcmsr/Makefile b/drivers/scsi/arcmsr/Makefile
index 9051f66cae36..6c12d36994da 100644
--- a/drivers/scsi/arcmsr/Makefile
+++ b/drivers/scsi/arcmsr/Makefile
@@ -2,6 +2,8 @@
 # File: drivers/arcmsr/Makefile
 # Makefile for the ARECA PCI-X PCI-EXPRESS SATA RAID controllers SCSI dr=
iver.
=20
+CONTEXT_ANALYSIS :=3D y
+
 arcmsr-objs :=3D arcmsr_attr.o arcmsr_hba.o
=20
 obj-$(CONFIG_SCSI_ARCMSR) :=3D arcmsr.o
