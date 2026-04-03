Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AC03B8D6A
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775223075; cv=none; b=AO4U3BGR0GLuascdflztGxVq5eyYrFhVXBfKI40LQN2XzCQyi65mg8G41299E4idMqDOys5ol/tONprfxV9q6pskCpRA0i7E0b8OpqskKFvrV6/S8DSr9XL+UWPYxJHxzvQvckViK2Y2SrQRG5uL0s2tRTJmmTDVX2a924l+2a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775223075; c=relaxed/simple;
	bh=tJuMjaXtSH2+B3CUI/9NTtAwb1Puf/ZSFJ6qth9ByG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MEQysdh3aejgyEzDinVR5SmTS4AL81rczpTs0vSniQxGxyVSnfYF3VKpSunWu07+fyixt1N7akjndGxqVfD1ohWCUZf9yhXwGiz5Dsq7eSmcIwrRMJ9vXElRj5fkbY+VpU1nmsks1kmPMcwfo7mQ+mqJQz8Q4YniPYRrqa8+5Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=G4c45SjU; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="G4c45SjU"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43cf3ee0fc1so2136401f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 06:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1775223073; x=1775827873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=06EtJYGQ6LYfDafCpTEDml6o3YzqQAzc59XOjIa4iLc=;
        b=G4c45SjUkt5XNL+S4y9FisFunVEaAJ3nOzPJfmRFuun94cQJ0IXcrRKhgIOf4aaYlV
         dHuN7zm39V/qpfP7jPWCrydvoTn7cP8weWecBH/MtqNC8Kr+6SCYiLO1yhXxdHImsZlV
         mL9sUMM68DB8Hk9Rr+rtibFl6tMnQpyla916NQZFP8Ha1WiRsVvsVXRBAOsh3qzHQoCz
         pJzg4Ob3L0ZAUZQF7noXz35yrRF7+42ioOTBTK+icONPcsvvLdJMz7Av1ov8rTQ1Liqg
         CQMZQmQe0RqIMv26ArVlllg8+PEXv8eBqH2Ry7+LTSchSM5VUhmRLatMIWitMHHHiNWR
         WB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775223073; x=1775827873;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06EtJYGQ6LYfDafCpTEDml6o3YzqQAzc59XOjIa4iLc=;
        b=ACzaHRE3FLtf0JJUtjFnpyL+THSP8P6SCn6c/FpW0EnAxhKrLIDi5CppprOxUWNyGr
         BeBJPwe9xL81GAqAOuRyuN1PqMcYTePhF9ut07pIerohZVcf0fjifGaeNGZHzf4akZQS
         oUwPX14Fu4Wbx1JopwiVTguKhIjZrqo6mY6vO/GyCnKt7yLtnqpYm1Aw5AdQ5/tzyF9K
         dAEujuRxR84ZvosVII/HFAQos8kYne+hwB6jBKKu8uXjkQwmjAGGZCsCEmrYjF9qn/ht
         S5caCRhGsY09edT3WPQXopRIIkvGzCnONKqfKTuJGnJnGtJDfhoXwHCq8ZITkjfV38Bq
         qVig==
X-Forwarded-Encrypted: i=1; AJvYcCV8XDC20FrHPzjW751syR0Q9r/qoSfNM2S6l6qF1Iwn9nhabAhZFl5vyDTgyB9S4GXKQlGvyuYVRh3w@vger.kernel.org
X-Gm-Message-State: AOJu0YyIQHGfzC//Ab4FPKsJAeX5UxjdjVUWtxnUVv3YEnsXCuv5Z1/3
	QM/ZtD+X6FEDfWYJ2qtCsRO4wIV7m/vGuBejfLTKoiyRL6+LWyDPyh+zdmLoltTPNIg=
X-Gm-Gg: AeBDievAZHKBTd8q5Di9ueZAT//9QJUBKLYbWf4zwNkpH5mIFo+YEdsvxKRND7SQw0i
	H0VfW7WbnAhTJF8gV0iAJEgP2DdwTG+zbOxlbDjok6jjc7FJ3q3OM9BC0ZWn4vCpwk2Unuq8d0C
	LwkooA5qHJpOkL6TnRTWsJdi8SNGyZb7ZIklfdC6DKa9hSaFVtyHi9qwPWGshoVeKNCs24kvy5b
	D5IPKBf9am5psE/CvVHXVDCEvk8i0lnaZb9JdRjHktDFzfa+Fe3HoCe29qIasXpf8zU/lUP/W+K
	LUFaQVc9APjK/KN7wrQ7JSdnJw8Aid9eP2xbqidKKynYnhyDD+3RUfx5GexOuMYOAuCc66hudA5
	XrEwUo3fajz0nEt3kvous6rhkkSCjp4F8dTKlttGjXTSage91vImEhtFhmDZR2faKHaGb77Pshj
	64CKPE17KD/a9GXVq+QOn6mE7o36qKRAYQDBHaEAWLjRv5zzCyUw+L
X-Received: by 2002:a05:6000:1446:b0:43d:160:c226 with SMTP id ffacd0b85a97d-43d290f737bmr5210902f8f.24.1775223072608;
        Fri, 03 Apr 2026 06:31:12 -0700 (PDT)
Received: from claudiu-X670E-Pro-RS.. ([82.78.167.248])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4f1a99sm17897406f8f.32.2026.04.03.06.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 06:31:12 -0700 (PDT)
From: Claudiu <claudiu.beznea@tuxon.dev>
X-Google-Original-From: Claudiu <claudiu.beznea.uj@bp.renesas.com>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: claudiu.beznea@tuxon.dev,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH] scsi: mpi3mr: Fix typo
Date: Fri,  3 Apr 2026 16:31:09 +0300
Message-ID: <20260403133109.2744351-1-claudiu.beznea.uj@bp.renesas.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

Fix typo in "synchronize".

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index c744210cc901..fe7af82357f9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2699,7 +2699,7 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code)
  * mpi3mr_sync_timestamp - Issue time stamp sync request
  * @mrioc: Adapter reference
  *
- * Issue IO unit control MPI request to synchornize firmware
+ * Issue IO unit control MPI request to synchronize firmware
  * timestamp with host time.
  *
  * Return: 0 on success, non-zero on failure.
-- 
2.43.0

