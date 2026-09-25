Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7413E4D9F81
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361167; cv=none; b=C0Btwcjmkq2GamBWWtML8c/QTZ5ppTan3YA7MP3IB6/Q7MZK9iAJkrNV2GjgVuZvmP6qsNKkp0gkrHNVYEvtf4qI5PFegfmwR5elY6sVTGF88T/JdGJewpSbt+NqcS6HnkGBZv2tSrsn4C451P1FS8geFDLG7pvybi+xbeFBF5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361167; c=relaxed/simple;
	bh=UNzhTLW1WQLvs3TRpjxXjAob4ZLc1jmpvpbN6RuXSZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhNJEAyoLjzVditDna6YphmSV86919HclHa7yDr9TDq3hVk8m3TVlaFzdBJ8r7yiIhaOnsFVEya2i8gzh6T3AqrA0pguMEaILFMqIOMI57NY78t6NT0iHayoildjR7JgWcALeA9ADzOxxv6/iSnisAnc8ivbjh2uk811HtXvrSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pLMUB2nx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pLMUB2nx"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpP04p8z1XM30g;
	Fri, 25 Sep 2026 18:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361161; x=1792953162; bh=nIIrR
	FwCYPMeohLByQLonOkqM9q4SYEsm4v6bpjd8gM=; b=pLMUB2nxOqgldIX+Y+w6h
	xfyfo8JOsLxez4/WqXSbXtvvEh6BGReaGMQh3W1bCwLNuuWm7mNgxyu6iMz/E71n
	2tz188raBQWQtF2rL9YT1x+BWnqFnV1+IxgMTVEYulN4DSBnHzXxNFmKpeMAuPAV
	5UpnHoqMHBgVJfHF6hFz5e7c4tRRa8887QLt5ioPI0qtB36yU8xiswq5YKZ62f/6
	beo0s7pc41o4kkCBn0OCQQOk2pJw07NXX/oOn1PGryaGbvD/+kX58t+f1sgN/+44
	uY3HAiYMoiFurWuUXGfG+8ZDvYvDbhhEUietblV5SOPr8U8WaNaS3ULaFoMiHxtS
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sK7VMqSmtuTV; Fri, 25 Sep 2026 18:32:41 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpH1TBJz1XM5kW;
	Fri, 25 Sep 2026 18:32:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 43/54] scsi: pm8001: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:21 -0700
Message-ID: <e51355852d4a14478545bc9bb5fd9af9fd947bf4.1790360262.git.bvanassche@acm.org>
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

Document locking requirements with __must_hold().

Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
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
index 659dbd603a03..d2572dd66071 100644
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
@@ -3856,6 +3857,7 @@ static int ssp_coalesced_comp_resp(struct pm8001_hb=
a_info *pm8001_ha,
  */
 static void process_one_iomb(struct pm8001_hba_info *pm8001_ha,
 		struct outbound_queue_table *circularQ, void *piomb)
+	__must_hold(&circularQ->oq_lock)
 {
 	__le32 pHeader =3D *(__le32 *)piomb;
 	u32 opc =3D (u32)((le32_to_cpu(pHeader)) & 0xFFF);
