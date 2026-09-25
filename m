Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433343672A8
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361088; cv=none; b=qwbDhOyTI+OVeI9X5z6rA7zCIESs11oVFZJ/bDioxjezln8/URgUQ2si/1Pbrsq65vOfp6UJ9NBwjOV3JWRZoyKdl9sN0CSI5teaU/Ocf6JcmBteyRpDk2GVyjYuJja4XUrsK8lBVkdQ3gzMxPyq6ubI89QUltgPlAHMWUPVacI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361088; c=relaxed/simple;
	bh=k4tldGNR5CErhM5sxtZLS/GW+khBvOrodyLMisdkMLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4m2KIn/RByRgsfOUJgVyI3mc1jY9A2/dZ6e3VleWsf4nyCnzzNlwKk+wKYVY+sWZy+jKmD/x029Mo/nN15+0bijJET7ScQbOloCrw7QpySKIPPD96tlZQSfZl5h8YFuc6FcQdN0117/Rg/qY+iIBkur2BiTUhs4S1cEbB0TbnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3fUkWJFX; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3fUkWJFX"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzms6H6jz1XM5kt;
	Fri, 25 Sep 2026 18:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361082; x=1792953083; bh=8EX99
	Tg7aEDSo+xYJ5hBUWcZ/pki/1tzNSzfGgBln+8=; b=3fUkWJFXPUfcZyORxDa07
	+QRRXEmV5EU05tPgNU9m49Pqovfnl9WKTFAyqI7y2rslHU5wNtoqpgnuusYVNkM0
	4g8KywSAgA0x4LW3E7XQX+GgMkmqH9cGtRdTgz6kyn46P6HkxFl2qGzZZseoEaNG
	UDv4j5ARa8OECqdMipW2fdtsQCaKW4hhyq2D/lNrCZoWUG0BP+1qsGxSEypzI0yZ
	kc0eQxR6RtC9r+de4FzL+Uqr+PPZ6h5PLJ9tN+4stDExPgTXgNGKHoXKweoPni66
	pLBP7/KmOuenoyaMuDogGtaYl3S8QYj9pileQPZ9z434YjW3Sr/3y42QR9dE1V3K
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JvNGeQFFEeqs; Fri, 25 Sep 2026 18:31:22 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzmm2sG9z1XM5kW;
	Fri, 25 Sep 2026 18:31:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Xingui Yang <yangxingui@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 27/54] scsi: hisi_sas: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:05 -0700
Message-ID: <5582ac312fea8c9315e3e87541eb0ea77524f685.1790360262.git.bvanassche@acm.org>
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
 drivers/scsi/hisi_sas/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makef=
ile
index 742e732cd51d..8576c78d4afe 100644
--- a/drivers/scsi/hisi_sas/Makefile
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_HISI_SAS)		+=3D hisi_sas_main.o
 obj-$(CONFIG_SCSI_HISI_SAS)		+=3D hisi_sas_v1_hw.o hisi_sas_v2_hw.o
 obj-$(CONFIG_SCSI_HISI_SAS_PCI)		+=3D hisi_sas_v3_hw.o
