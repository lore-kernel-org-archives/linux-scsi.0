Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6E72367BA
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 20:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313145; cv=none; b=RaLZv9LwNOi1ZvhaVXWdOwElLUpdPGz9q1qby2+iZ3XjCCTjMdy/L7zGIzmsCdnBbuqR6xODOBdKcbR6BAsvyhuCt0WfmsSXlpWVRzOuXGADv4AJoBxq8BKWGfseJXOO2P7QCVPf//GzOQ1i2ok2TZLSecNpWXDDHuveOe9Btp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313145; c=relaxed/simple;
	bh=HwOIQTSUz0KsRkikgSpLP2ZghU47SZy3T5oOM0BG6C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d01b4FuA5w1uFjq8BeIh5AEn6I+0naCu/sNMAktx/eUiN0bHz4lJ66tOquo82lLUywOcSz0rQ2MDykl2p5vZxCzabpLwuw7xFPCuaC5FIYicwVJ5bzVvaWZsp+X2H3JcOBqQTw1HlC3iVZUPDLC7W9M/TQtizFv4Jf/3sB5mvvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=ToI2+9XE; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="ToI2+9XE"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b79d0a0537bso789547466b.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 12:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765313142; x=1765917942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=om7eq4vT1FB4r+Y68EstTbprnhPQq6X6vfDxcJIRdb8=;
        b=ToI2+9XEhX834C5RSTawIimt0PAkGJkFBalc/Sz/msshC6E9sS2ulW1+pvlGlvX8JT
         v61kzNEkdIgbzHMfAfpG/C9SMORKk8oVQoTyk/2VwCxveE+6Gf2AMxmfOPw/Qec7a6Y5
         6HyN8Lm2rhD0y/DBbEohmFhJMx74gSRSr+4AwFi8qYoJyWCoGl4rr6s6YOy/cvgz7sbV
         rMXl5Xly8gpaJXy2G5040bQpUVuMu+GSOP/l0BzBBmSjgyoKOLUQpnY5VJ3/OFf46JzJ
         D2UPhjyNAvBN6BgCsuNvvGRg46toHdKFsPNty+BWoAeMaKhvRWEx/5JTalw3C3dOBW2A
         YoLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313142; x=1765917942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=om7eq4vT1FB4r+Y68EstTbprnhPQq6X6vfDxcJIRdb8=;
        b=fyTgaLo3H75/mv/J6LcPY0otJ2KcqtCMu3H73SvYuVndmthMRRQbdUeRW/BZqOQpMM
         NkK/epAPxsTpwm6o/hcqH/yxJZ+l4n/bAhWazYlY2/GqXCQtJ+LpLJcRdqlmuRn8QaFc
         t9HIclc8OzVa1+axHUFzXdM3gHBeffiyH0CLggs6ADFtDK7YfskOkKx5Z2RnDIdDpXx+
         vLA0/jfKTOab4QikgFXNEC4x7bWUEXe2+Il0qfwf5DoUsbbhLwIhmlXW5Iw8vsyejUvr
         lZ6iT1gbLHOQaRU6TjBVsSnrfuj1cJI11mP5h0wpCbEhcVAepl8sHClCRtJL7LWRnJBI
         hOwA==
X-Forwarded-Encrypted: i=1; AJvYcCV6X0OMmaSpPdP3gSBz7ZBHRE7fYUZ73JnXPshJxnzoEvJnBvOb/5ood2qHUH5p59OGnCJYvuGEIXan@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo0fO2TpuCCjFCG9Qi+Bve8OAWO19vyOFluc4Jka6h3Qpmx+s5
	sMck6spmQXFiDgMl8WbdzS2KbKR+UGPjURcmIPofnbP7JvaGaYGMgIn32VlyOPAFPpo=
X-Gm-Gg: ASbGncto1e6flo6SGyHR0M6gtN4g6L8Iyx+7c28WlWT+yl08MSrNA1zecuSIgTqOMBM
	ruzOEvgCW3jNKz0QlC3kCrnQZv5XVS4skKVkm/g2P9nbh6KvQ3mWKnSZSIDcYNYuob+SxdhSdto
	uCS6Y0mfkgWU1IRzdMA63habLMR6Fl3B5O97dM560GxyQhp6fbzNCxAefIL3ILyjHKPA+xcIKkQ
	FeP3BeNYBMSSMHLqKJrP6Rc8hKkjvApbeFHloxCR0aKrqOa1WcqMyPq+3zx+HJivbT/NS6clxLL
	fKKDxykAEDXTyh7hAyBvElmktIgegItpSAjHkGErag3ZHTjuPrV5RA44h7ytqQwqCXyqqZe7AQv
	LOnB7FIo9lWvcnWZlSpxVzIlBBma93681lGzhQksHiNIFTai+rLpJQP7h7WmzthxDO43Hb+cq5y
	fn+H88v7gSrkxjEwub
X-Google-Smtp-Source: AGHT+IHHuQyH+PxzSPn/7ccMAn0Cj+bexdZhX7K6bBUr5pMBPLgpJ+wGeh8GEd5wr2osq3zLAo8pcA==
X-Received: by 2002:a17:906:fe47:b0:b70:af93:b32d with SMTP id a640c23a62f3a-b7a2489b45cmr1437985766b.53.1765313142090;
        Tue, 09 Dec 2025 12:45:42 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-647b368de06sm15212087a12.22.2025.12.09.12.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:45:41 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 6/8] scsi: sr: Convert to scsi bus methods
Date: Tue,  9 Dec 2025 21:45:07 +0100
Message-ID:  <d6bc01f1af1f76132e59592ba285fc1e450853d2.1765312062.git.u.kleine-koenig@baylibre.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2126; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=HwOIQTSUz0KsRkikgSpLP2ZghU47SZy3T5oOM0BG6C4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpOIpcREWpPSpOIGf/2YGbOp5Fk0BC7O74TQvPk MrKdYER3jmJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaTiKXAAKCRCPgPtYfRL+ ThTXB/95CrOg6A3NGWWF0F69OmqYGsShhaLHsqKWYRd6ZtNiM4rHSptNesZenHyWHOnWUc+Eq86 rTZlRqcC9El7UT7w0agbJCWLQsDWSgSoGSzzKU9mqoCNZDV5OQH+R6h4byk258l1WtTMvoO2j4E 5z07YMLFfAsBzfwApx7tMJvMvDKFfeEjTPU4YjxtlQxdUu+QsOt9RzvxEiQuelnKqO/KWm82xLQ TzpDCks/B++m/7CoaZu4AAZQrvyjeKPVz8IGXS20hdgbXFm6zyoNMf03E2OKXLD9t17eLmfnLdW AOzFJjdnNQUKfZXYBmtVVw5vCSiP1xRSquyDuMT/CZQqxUbQ
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi bus got dedicated callbacks for probe, remove and shutdown.
Make use of that. This fixes a runtime warning about the driver needing
to be converted to the bus probe method.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/sr.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 2f6bb6355186..1fb85f548955 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -82,8 +82,8 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
 	 CDC_MRW|CDC_MRW_W|CDC_RAM)
 
-static int sr_probe(struct device *);
-static int sr_remove(struct device *);
+static int sr_probe(struct scsi_device *);
+static void sr_remove(struct scsi_device *);
 static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt);
 static int sr_done(struct scsi_cmnd *);
 static int sr_runtime_suspend(struct device *dev);
@@ -93,10 +93,10 @@ static const struct dev_pm_ops sr_pm_ops = {
 };
 
 static struct scsi_driver sr_template = {
+	.probe = sr_probe,
+	.remove = sr_remove,
 	.gendrv = {
 		.name   	= "sr",
-		.probe		= sr_probe,
-		.remove		= sr_remove,
 		.pm		= &sr_pm_ops,
 	},
 	.init_command		= sr_init_command,
@@ -616,9 +616,9 @@ static void sr_release(struct cdrom_device_info *cdi)
 {
 }
 
-static int sr_probe(struct device *dev)
+static int sr_probe(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct device *dev = &sdev->sdev_gendev;
 	struct gendisk *disk;
 	struct scsi_cd *cd;
 	int minor, error;
@@ -982,16 +982,15 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	return ret;
 }
 
-static int sr_remove(struct device *dev)
+static void sr_remove(struct scsi_device *sdev)
 {
+	struct device *dev = &sdev->sdev_gendev;
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
 	scsi_autopm_get_device(cd->device);
 
 	del_gendisk(cd->disk);
 	put_disk(cd->disk);
-
-	return 0;
 }
 
 static int __init init_sr(void)
-- 
2.47.3

