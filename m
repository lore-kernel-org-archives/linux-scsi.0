Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BD22F12D9
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 09:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136372; cv=none; b=eB3k/Nkc0jwy093rrc5iyX1c4OZd2M0zAcqaDQBXlnIoPn8EdrzoOuxiifwPwYSAVkoIN4qhvElJSt9iSppoLZqoLoqxPtHiHu4HyipFimou3ftVr/zMEUa+4sHcmVBCgyV+h8fVX62zj5QiPk9m7qPQj7W/a0H4ifXrf9AJE3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136372; c=relaxed/simple;
	bh=TP0oW1I5zUxhvVtcuXsfKAmVjB4CQj4gr4a6HfcOwsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BfOEMidOpJxCg8pgD7kCyICZmj/8LBDBE0ksKOM68a/f3PkCDofzhy0f8qXz9Lb/qyrhWZkEMn0Xn4/DuPL55Jy9qISBBVKVR1sMhKj18ZAcTMTx8+hD89wmsAsQ/nkmuFpViqlXAxZQzKKGNPG4yjzwmdjBb/cvpBgSu3FRaJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=a0g5lPni; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="a0g5lPni"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47789cd2083so8868535e9.2
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 01:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1766136367; x=1766741167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpPNx9yGzrfJDiu8usHo4C0Dzi++sqjJ7Ds5blO/Uxs=;
        b=a0g5lPnijJhC8T1Mo4+7D1yLS1HzwI1vewuIHSmKKYVOL/Q5H9m903IpkV59ab57y2
         X9NCwKI1x4Wr6dMtS28PYTEIj3ng1PVUEu8xorZONqUrkGmxBCaUnbNrgyLqnQcJgZ8O
         u7GsMDGrfJ5w0P2Lkb3vn+5SAtBWNqHe6PBZBgrO2UCygpcV577kZKzn1l3NqayJFEa1
         SvGPTLahpD7j/RpXZm6qT4kMn2WwUruEzQEjwWJByxKA05etFnoa/iVXumdl5KeWLM1Y
         W1SnJJ8yrlGzERmoeXglLiWwKHfUz1qttKbao8guRnXAYHoemRucGdf6aHuPL6zj2QC/
         ABEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766136367; x=1766741167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zpPNx9yGzrfJDiu8usHo4C0Dzi++sqjJ7Ds5blO/Uxs=;
        b=BvCNkaJWGKwsCCe+SN/vGLib19ePmSZt7+ItJVpkF8TCVjuuFB1eCpqexEWboWt81j
         6CltoECs7eKmelvhKy0/BUxCiZIY/C0dcrjtldNThpwyeG/bBZzHJS2u44qDK34GA2mC
         m8hKajKsqBthjR2mPA48zsxTYDhJxK2IZu/pt98ucCnzg7uG9toy/m3nep3Riq17YE/g
         qG/udBRu0xElb9GoMQLSMTT4o0q3u/gGnBrmj//ojHGcSrb/1xWYkek7mtXqwaSw2lUz
         LGc9gQMxRcbwHbgsWvIj6IzEQN5ULo2xZ0Em6dqCFbHAeJeNj7w/ZCBVrLVvfl2ZTToX
         uhXQ==
X-Gm-Message-State: AOJu0YySlNK2e5h5rhWdaU2jiDR8ovNsbj2+p1KbcRARYCv5pj9iuFDY
	YNXmg125VIbeVmaXYSvYM0sfYs7yKXHogtYKUyo99E0CFGUsqqtT4ee1tIp8L8wxvTh079G4BRt
	dLe0A
X-Gm-Gg: AY/fxX78MlJO5U6w0qmmrNmx3TpAkU5ElUCUXNCdiO1YFjMnfD0e9Me8OXtpeE34M1I
	CwcAApmb4xgq9LK3Dyz1Qb2UXeSYFf++Otvsu4bEsGjnu/TB8rKUxMHNEUJ0hgEpDGVEW4XqKnT
	9myhIZMVHpY/B1eD8VJSlacc9XOUC6OMZGz5YB16g1by+MeM4ZjLE9jou5Z0DztlIFvPGBoBAVq
	k/zSotjmyviwkpHLPVJvovAt16PR48hJ6yagNv7Hd/Dn4j+skKBXAkn6FDdPS1QPc0rY5HiM403
	VK7Tl3zBx5fIL8AauZKUFuenzrV5qrM6Lm26EhQB123hlxQgmNoIpruFBplJsQ5/2LjZ+K3q6QT
	rqMxKeqzKlKwITt22u+klY+dnNrhlkOHGt1HIdh5NiiSRmA2Y+geOBGHXQU7Kwqdi8MOBtg9131
	kQJd8MT5TVQboL0lxxibkc5BSTvpIXea/n4zqN1PPFRr+4lVKpyPo5uSXUq+PSV1/eaE3ed1gNu
	9Q=
X-Google-Smtp-Source: AGHT+IGh4uIKhFX1TWeeG449hs57UWoJPUP9JNpqyCzHdzn+y4T4FZZYcqLPx0HVzDFQanplRH6Dxw==
X-Received: by 2002:a05:600d:108:20b0:477:214f:bd95 with SMTP id 5b1f17b1804b1-47d1c036d6cmr8380445e9.23.1766136367592;
        Fri, 19 Dec 2025 01:26:07 -0800 (PST)
Received: from localhost (p200300f65f0066087cf387e078e1a5dc.dip0.t-ipconnect.de. [2003:f6:5f00:6608:7cf3:87e0:78e1:a5dc])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47be3a4651bsm30962535e9.7.2025.12.19.01.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 01:26:07 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH v2 6/8] scsi: sr: Convert to scsi bus methods
Date: Fri, 19 Dec 2025 10:25:35 +0100
Message-ID:  <ff6e8421f9efa84be3c37a11637aa435899160bf.1766133330.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
References: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2144; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=TP0oW1I5zUxhvVtcuXsfKAmVjB4CQj4gr4a6HfcOwsc=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpRRoc/XSYbBayB/65xEyRvMEQMti1doTLzRIIs ciXkpDXlDCJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaUUaHAAKCRCPgPtYfRL+ Tq1BB/9c3yAuaeAI7uuZxljoAjSJG7uTZrO40qn3bxz2oGCSV6C+/A6AeW4/meQYOebf29jhFi9 HW7DX3rEf1Mh2dWnNyp0ErmS42moDALXmzV/OKalAdX2dhotF2+vjJAF653KiEpdAyN7wUjBnbA vv8uZgL7wjZYVAVx19praImyuuXLwlCc6DRqrmBK8DCAimB2PTQrklkxSfGX5ECGjzbAy9/BoHi H8wcPC6zFliVT/+I2C/1VMgX6cAFG7QfHTbhzAIfQs5V0BJACLphQr3IL41WEeGzjNsuRmdKOtr v0zvdop+IQtXCYa1jxPsVlKq6uwmrb/LE8DZIrl6t6QDpI+N
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi subsystem has implemented dedicated callbacks for probe, remove
and shutdown. Make use of them. This fixes a runtime warning about the
driver needing to be converted to the bus probe method.

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

