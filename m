Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD61B39DBFD
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573489; cv=none; b=ncD5979SsA5svfWez4K8sU8x33GlUiSKr8ctGFdRY6l/GR1xoOhENHEJLMzReSU4ehFzOdLL/z8ONiIN4Anpd3tagrkX3QzWglZc1Lz/XSYWVh1g7BPKwlEAsY2jo84kqThT8hdGQc4ZcPh/zVkdOU3CyAvYBG7hXZYqC5tHLHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573489; c=relaxed/simple;
	bh=R86vKmHlc+x1Hg7pKaRrP1STWfqqDC/+yatLFrUdUfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRCn3ISqzKuWd7QNBFAasvUjx9OlbyXLtpvL2YuZoS2SpDc7QceJoveYk9EVouinr3ZA+1bSxRa0YwY12/5ytG8ruGUiHiukL//MLl3geSDgLPCWM5IyhNYM/s8U6SR0PCZlQYGvfIHnTRiFGVAu4GJPrLSKpDOvGZnuwNsFcAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4IK74aTq; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4IK74aTq"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62dX2NHSzlfdfc;
	Thu, 30 Apr 2026 18:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573485; x=1780165486; bh=auMcq
	Euh34HtO3V1X4cyLw7pRSzMC3hlYTEJEMK4YhE=; b=4IK74aTqpgVhFC4X0/kx8
	bMtc/Uf576fGZlfmmj55O//+l6h1HreBDqDva7R1sHPEjBZcDjTRg/UHoG01Wolb
	2O1kyyyYQ+viiWp6RAtVqBfbQmMh/1B3ouHak4Lj+7Dl+USS/4n2YRSeuNkQyL6H
	N8NTwPx1muCAPGpLRmZ2D2/Pjmzam7T9CLsvmTmZ9pAnMLLXoMDJuBod21lLnrVH
	E15gpXMlcXjb1TLN9QjE7cRiSWnOgQ7owZBOZV2hOepJPnfN4HGNMNpSeKOCjj9d
	EC6pDryrM6g1Yp8mKn2UI9+insag1SUtY1yxE3iCiVhytEpFYTk3eGon3JWKaX4k
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aX9n4V1MDjgd; Thu, 30 Apr 2026 18:24:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62dR4KZ5zlkMXn;
	Thu, 30 Apr 2026 18:24:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 44/56] scsi: pm8001: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:14 -0700
Message-ID: <20260430182130.1978347-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pm8001/Makefile     | 1 +
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/pm8001/Makefile b/drivers/scsi/pm8001/Makefile
index bbb51b7312f1..b236359810fe 100644
--- a/drivers/scsi/pm8001/Makefile
+++ b/drivers/scsi/pm8001/Makefile
@@ -4,6 +4,7 @@
 #
 # Copyright (C) 2008-2009  USI Co., Ltd.
=20
+CONTEXT_ANALYSIS :=3D y
=20
 obj-$(CONFIG_SCSI_PM8001) +=3D pm80xx.o
=20
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 954f307352e6..5f7501af482b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2287,6 +2287,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *p=
m8001_ha, void *piomb)
 static void
 mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
 		struct outbound_queue_table *circularQ, void *piomb)
+	__must_hold(&circularQ->oq_lock)
 {
 	struct sas_task *t;
 	struct pm8001_ccb_info *ccb;
@@ -3849,6 +3850,7 @@ static int ssp_coalesced_comp_resp(struct pm8001_hb=
a_info *pm8001_ha,
  */
 static void process_one_iomb(struct pm8001_hba_info *pm8001_ha,
 		struct outbound_queue_table *circularQ, void *piomb)
+	__must_hold(&circularQ->oq_lock)
 {
 	__le32 pHeader =3D *(__le32 *)piomb;
 	u32 opc =3D (u32)((le32_to_cpu(pHeader)) & 0xFFF);
