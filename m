Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7D93D5221
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451740; cv=none; b=BphxHY0O7DNeU4eQnaXduF8QbGuK++6xFWxUcoQguA+7Xsh52+jgUm+CvhM3smPCKML0Wm2GXBrPWU5oLJMl9xLIj0cLYchXNIyVmcyf0JNi5XMHrkuY3gRYkiyXoB6tMz7vz4TjSQIcZv/hNGWKd2en6hgeX0+95+fa98TW5+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451740; c=relaxed/simple;
	bh=fM4fHKwqxJhupdRe86heCo1MOwIgHOhZzNGqe8nAlRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/fclsGbj0RlePA1WN2sd3d6epiicmzWBBygcsALiP3tTZSV+COIPSs74BN9Fy/oebjzP96xU+VGZkZDEKu4SkqZB+CxnpytwI+KrfVwJaZBH0a5bbR31T5EW6Xxwof36KAXKyAlCd1zmkZ1pOSEgoljfyezOGLo8apq1qnLf/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Z84Zx1zj; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Z84Zx1zj"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4BL62lLz1XM30r;
	Thu, 30 Jul 2026 22:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451735; x=1788043736; bh=bROog
	bwI4aqna1hD89FFMT3m7p2dBr65vrQAbgzA3Pg=; b=Z84Zx1zjxa3cj8VTYs220
	G+yc5jnGeESGA2vaZHi6kS1ZnttXZW251H3F5JjOcE1/OEOnV5REnYGlM+HygezN
	yDmpAinpFqyaViigOiT+wVlCCpjnzzdJ9scTiykFon+q4cn5dElZjuwEgLK4kGV2
	Q/GrFRmKTV5DKmfP05sWktW9/r2gwYQkrBNpoPnq1oAj5WX7jOX/uBTaCpAI4F6f
	LH2HKrNQNeOSR1yuRpa7xM6CWDCLuY5aNKhVhoYM4gLKrFDNxR1TeqVW8WeWSgqx
	+yoHlcZmqk06SubbXNLEsWmS+heLtT4ifF1EDaBX0NM1YzKdcTp30uSxRXEOQ0SD
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nRv2p-KGuLQR; Thu, 30 Jul 2026 22:48:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4BF2zV8z1XM6Jk;
	Thu, 30 Jul 2026 22:48:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 44/57] scsi: pm8001: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:27 -0700
Message-ID: <6371196646d5f6222a6d8e55de2a351aa9caf967.1785451174.git.bvanassche@acm.org>
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
index 7a348f0194bd..ff6fdb761a70 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2294,6 +2294,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *p=
m8001_ha, void *piomb)
 static void
 mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
 		struct outbound_queue_table *circularQ, void *piomb)
+	__must_hold(&circularQ->oq_lock)
 {
 	struct sas_task *t;
 	struct pm8001_ccb_info *ccb;
@@ -3858,6 +3859,7 @@ static int ssp_coalesced_comp_resp(struct pm8001_hb=
a_info *pm8001_ha,
  */
 static void process_one_iomb(struct pm8001_hba_info *pm8001_ha,
 		struct outbound_queue_table *circularQ, void *piomb)
+	__must_hold(&circularQ->oq_lock)
 {
 	__le32 pHeader =3D *(__le32 *)piomb;
 	u32 opc =3D (u32)((le32_to_cpu(pHeader)) & 0xFFF);
