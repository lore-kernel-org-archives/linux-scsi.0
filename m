Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736AC335BA
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 20:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313147; cv=none; b=oGLxATQc4liekGWwYWEP4tdTEHuGhPl4CfnqSCpEqSQBVA7tOadErYb9htgg4SXCGT/aRzIjDKW0UcCy5bmePgaoiU6YQiwFCQBD9cUpcxw2tA1ivYnL09BdAjTH4D1OdOiGjRBfqmwU0lvXAvXsGsKONQvW+HxWCoGQA12ysh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313147; c=relaxed/simple;
	bh=+m/p8ILRn3KZkKgVYlIOUGw6OTbgmET3AzjXnjjqAzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g3TSS8JL8evIVZl0F0plzYzak5FRTDRORS3zpWP19xOB1Iu5UTmecw+QrVfOTkoCVy6iZS4MF9GSBaI7Ux+on7iKC7wez+k/uP4dDpybyDQHRiBSKYpQ9vuDcEsCUWtossJy13YTpLfb/Vk6VsO1uQBNhT/i4Jgqz+FcHcdp2Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=VU4TFjCN; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="VU4TFjCN"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7bd8b170e0so74580766b.3
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 12:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765313144; x=1765917944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwDU5Tm0VargWcs82kVDChhs9JS2RAbH7stEMtu120M=;
        b=VU4TFjCNVdtJm1486ss+ViRAfnmIXOro+/osHooCmeeiAcLOPGWOipB69wdEfxDPHz
         cHmHIdM4DZUinl+RLPcUAg2vJleEKWpa+7Rq9MqoJLfbFvczyGnUt40gPcmBNJslHBGZ
         VJVUGVSaCyLd3uKzjL+jGN51LpOQlPFu4OFRicZiDLjDb96A4Qo3AkH7BRo3aE1tQrMp
         9JGN5TXlY1jwP2N9xCWQZCyuOat8k8Klc3Ezx7IHf5/k7FfH9MwVnRqo5+lTeHsB9QY8
         UeiQchdm+0jQwc6H0HvIXetajr9OZe9p2M3N+6yjabPLPhmWcaAk+b+M1hIjf0UiHfKY
         UG+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313144; x=1765917944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DwDU5Tm0VargWcs82kVDChhs9JS2RAbH7stEMtu120M=;
        b=BFpONOhix3XHqC2LnEXfN3ibpQ8gtpxIQjbjm9ErnrKswwQTNlsEkekOHUNDmuTHG4
         BaRTyetRaO2YoYocYn1uJMO87dr5SFZX8J4mdqc30ElqtkG4vRUChct3iJmLoFQPsDfM
         Ku1Uhtw60jxQvXfWgguZgrGqAAQGfVTABnII8Ouh+oSEswvTaNq5ZJ6TDMZZqM/6VkVH
         L7pNIVD+7YHE+8ugm4uYmNzOGjKWzd1wAFtZxBIcY30AXYlYD57ffQw8UhCL5bFBIuSn
         DPzZTgrk5ba3pv1IK6ExCWmFCESuqZOJZ4cAIj9LAaHd+7cYFhSMkN9rPwnhJwTjqs27
         hlpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhrihw4emAhxjaOthMYujXawt5cyIJiosH+tC5imbHUPIm3rRMEYtxf8JXJYYAyIIzMVXxRk5P/akF@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0c+beE1PginQB5HS5XkAOyV13eUFs94DR4N2inFaH6TNp0V8f
	VPTLWrwEhXnNJX1AFbR6Ey8em9J6PBVWSbFXlKgqsDr8eaxG6b/l3AGU18KfxIfgvsA=
X-Gm-Gg: ASbGnct5lUUFSrtFv7agWlDK/33aUmxfQqBF5vF3JDzZQGzO9kufceXLWlS3SgSsCJs
	vqcBAL7DRiho5LsffsuP/ziCQGXp/OBgj5MlOZ316WKbu3EjzCqzQCl2qz5jvr2+LNBG9YD6ITq
	K27Sr6VvFChR/nuHPyXc42Sfat61gs3faEHe1N6tzqukWFenS1/KpFd+75vngfAVrXfKhykXX3C
	0eUGUYoNj9GIs3LOd97VSGBZx6mv9swkje3KGynY1Q4qQ/4C+2JcT1uWSzMtRBRWDgPDrsYgUs2
	MQxwDVMu1tT+j55kbFxGDccRx7cIZ1Mm6y3+cGRMPCSs96VTX4Q1j4ke76A6yrLVacYjr4p/mA2
	6liJhYt27Zt2ObFGkjEML/0lEz6leCHl4tiUIzYcVGWs72Y7bNNeMXIH0w4Rv4ie14Zj8EUKLNG
	EXe+lPrC7inR8yDXZP
X-Google-Smtp-Source: AGHT+IGLIlKskKWNtlPJyB37/V5hDWS5f5zW8X6WY+p1B1vQxVgvz9dMFV8PI0B43bjba6YeRnpD4A==
X-Received: by 2002:a17:907:96a6:b0:b6d:573d:bbc5 with SMTP id a640c23a62f3a-b7a244e435cmr1299237866b.37.1765313143614;
        Tue, 09 Dec 2025 12:45:43 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b7a01a33379sm1320985966b.62.2025.12.09.12.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:45:43 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: =?utf-8?q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 7/8] scsi: st: Convert to scsi bus methods
Date: Tue,  9 Dec 2025 21:45:08 +0100
Message-ID:  <1a41343533a7f4d8a2c3517c786e443401cdd61f.1765312062.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2097; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=+m/p8ILRn3KZkKgVYlIOUGw6OTbgmET3AzjXnjjqAzw=; b=owGbwMvMwMXY3/A7olbonx/jabUkhkyLroTsZTY6AvtslgVmRa5+xvIiKvWUlNeXDVpNnJs63 l+/qWLZyWjMwsDIxSArpshi37gm06pKLrJz7b/LMINYmUCmMHBxCsBE3K+z//d4++yhYJh4zqwJ De5vvzxtuLlpy7vfv54+bP2ScexdsNENoQnP9SItKvlWrxNS7xANSso2SYjrf5oZ+oZxmcKpgIW 82vMvnNPqiHi+f9+98LgWXzeuLMZHPNXrupIvnk5J9GS7UvXgknSoW8/Nt0vn+7tInl5+Z+Eu3T RWwxVz1SoeNkZYNhnvnj7ZueKaiLgrQ9tN1qW/rrXc38J097V8YUVMlkyY2NI4rdYU/8/Hkub9/ +/fmml70/GO+pyU+gTDJqVfrSEV/EdcbKb850zONVa5ajLR8nIh+5m86VuzrJYsDDe4Gt3c/GCh gIxVYF7WGVF2w0a/Z5N1In3YqgUWXazbq/Hf7rj/zoPOAA==
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi bus got dedicated callbacks for probe, remove and shutdown.
Make use of that. This fixes a runtime warning about the driver needing
to be converted to the bus probe method.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/st.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 83140b60f3fb..06f03fde9637 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -202,14 +202,14 @@ static int sgl_map_user_pages(struct st_buffer *, const unsigned int,
 			      unsigned long, size_t, int);
 static int sgl_unmap_user_pages(struct st_buffer *, const unsigned int, int);
 
-static int st_probe(struct device *);
-static int st_remove(struct device *);
+static int st_probe(struct scsi_device *);
+static void st_remove(struct scsi_device *);
 
 static struct scsi_driver st_template = {
+	.probe = st_probe,
+	.remove = st_remove,
 	.gendrv = {
 		.name		= "st",
-		.probe		= st_probe,
-		.remove		= st_remove,
 		.groups		= st_drv_groups,
 	},
 };
@@ -4299,9 +4299,9 @@ static void remove_cdevs(struct scsi_tape *tape)
 	}
 }
 
-static int st_probe(struct device *dev)
+static int st_probe(struct scsi_device *SDp)
 {
-	struct scsi_device *SDp = to_scsi_device(dev);
+	struct device *dev = &SDp->sdev_gendev;
 	struct scsi_tape *tpnt = NULL;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -4456,12 +4456,13 @@ static int st_probe(struct device *dev)
 };
 
 
-static int st_remove(struct device *dev)
+static void st_remove(struct scsi_device *SDp)
 {
+	struct device *dev = &SDp->sdev_gendev;
 	struct scsi_tape *tpnt = dev_get_drvdata(dev);
 	int index = tpnt->index;
 
-	scsi_autopm_get_device(to_scsi_device(dev));
+	scsi_autopm_get_device(SDp);
 	remove_cdevs(tpnt);
 
 	mutex_lock(&st_ref_mutex);
@@ -4470,7 +4471,6 @@ static int st_remove(struct device *dev)
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, index);
 	spin_unlock(&st_index_lock);
-	return 0;
 }
 
 /**
-- 
2.47.3

