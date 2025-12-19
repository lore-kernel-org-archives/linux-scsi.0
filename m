Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0942F39B1
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 09:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136374; cv=none; b=SU80s7pXfTgHN1qmw8dN4RB9D2KUFPGGLXeff68B/X7IbUWVx7O6nGnup4a3iYF+y8y/SF1c9h2dYEu28nnXFs85/lPkwYVJErhjBLN0/L+v0jzjSSNIgxeuEYwNtOCV+lsq+7I6Syq5WnhEQFxBocRCsn3qUhn3M7x5ckDjo0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136374; c=relaxed/simple;
	bh=JFJvLGnyaHaCV/eJzejgi5pSvHr6D8xakNdWbDoTCoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hn7+OmGmQ7awMGDwxflEkBTWSiDCg6Nxrn6Pq2hII7VQxSzRcAd2aSvOvOvv4zvBnLsLKwi59Pz1rLFX8PsOzoZA5QrgDKenhgnfIacr5rMJIHW4Scbxbw9pAUf8viI/8wUzHRjfly7RSmyp08rBV1GYp+G8tvvxOnwLCt44Ed8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=lZvmeuMn; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="lZvmeuMn"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47d1d8a49f5so1532045e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 01:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1766136370; x=1766741170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/mp1cXdFClVmFyKeKpkTnCOC7fFOUEAMCCmxVP0ZFE=;
        b=lZvmeuMnQYaczecn/DjuKTQGEBWJnqeMBQtggIt5smDGJnAJ7rEzMLZz5jrvp3W3hk
         OuYHzWsW9MidH1f6CvHPQaM6RV0J+GrE5wGK/FYu86L+uSnZ3Q6Hh0IOo4LMxnlFwLgK
         0AnbbJcD361ZnFLFMikpANRi2BF9UOivDqAaU29fPJ2npcnxaVgT1wDyWAL+c3FbwDBQ
         dt3PxPbBiGPdvDvbhjIAPN4WVIQMLSwM9k4jdKclaCeyP5j8BoHkFikHtu7LAPhZyjVF
         LKvlHHoGg5g9lGTimSdI6DeisCk+c3ihlS70DS9tBMP86TbPrBnQ8iFFXfUL1L/Fk9Rx
         8BzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766136370; x=1766741170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e/mp1cXdFClVmFyKeKpkTnCOC7fFOUEAMCCmxVP0ZFE=;
        b=dMa3zI3NaiMIK8kEjVDFKV8fzfnb1PbJS5IH+5OV2SkCjYg8W7I/pYupNH83UM8LTr
         vFMfsZ69HFtjD0x132Oj0fyjacR/RrNsoyoajUAEPJY/h9iR2SQInbebEz8e41PBLVuV
         iQZoxE7hFl6d2jNLokKBpPKfzAcY+d4eYo7gMNRkqFyEw3uG2av7U8l6FBeltjLGhQHx
         L/RYRAWUJ5Bdpcsl5hKxq9Vu+yffUjUjMWxIGrS9JdWsMdiXNZHN6PAuRAVyslmmElIP
         R4jqyfjZSHqr0BBWBtXgRZnsGM8vDFVRu9gxzcm1iV/3T/hgSwtDDHRLNhaDWu1knUKG
         Lx8w==
X-Forwarded-Encrypted: i=1; AJvYcCX9JOJUma3ipyCQT3XQAOpHU2DJn9C0ju8EoTKzztdObTMdffjiH4pfTO7nf1+BxeyaKArUcfr2OJz0@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzk144i8uzb1eo8Q8A8+57AY9dhtNcj+zdValIV/iNXGofc24t
	TO1AcSUjWBmNjgoaSk0fHVXDXTV0VJRe3ahsFcnxKry6yweSMgp9y2GizxPdV6uz4Pg=
X-Gm-Gg: AY/fxX6tE8+t9UFRkMRZ6BR/B1ESmWTGnfqI9FxvmJAFcEK2JHwaGEja7BhoonqOghI
	5FYnFhYeszOZueGm53q76DVzyA/ztH09wswvWL918fazlpFL0WHWboG7afkqqcEE5wi+r00PFa4
	S2vxQCR5PRXqRaYzqvn6VFnBx8sWfy3YRyhVZ2geQ4ssqMSTf0HKkIqn49DWqsVkLeh7CJKaMz+
	1i7x23vNs541ZT4qlEFevAG3v/xuPWmqxe2BZFPS7P1K/TDIvrS1Ay5a4kgLKMvC4tUJiRDuC5f
	CeYj4+uQUzSdAWbzUAgeobTOxl05PoOEmEbtE8uF6oZFXOrzy5Gk9WbcQviMwvHF348uYpWvwnW
	S8DG22t0iZfQvI5AD7ruebJ0/nFJTPC9mg3azwPP/2+Hzlibb0kjQ1JJYhSVc18TVASBDpmViAa
	7SYFVnSHndGH3DTlFLQJPeP46bsW1CVI9HxBgeHTARYdnb+r5y8xVQrjiPz8QvC8xaKRbD67TWZ
	z0=
X-Google-Smtp-Source: AGHT+IFEGjvrlWAs0NpG2elZsaHgNsCZyVGl9rExLbOyNOaoYdDfMM8vBeF0ffSfqRLAATFuQzu3Vg==
X-Received: by 2002:a05:600c:1d0b:b0:479:2a0b:180d with SMTP id 5b1f17b1804b1-47d1954a5f7mr18629415e9.11.1766136369925;
        Fri, 19 Dec 2025 01:26:09 -0800 (PST)
Received: from localhost (p200300f65f0066087cf387e078e1a5dc.dip0.t-ipconnect.de. [2003:f6:5f00:6608:7cf3:87e0:78e1:a5dc])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47be3a2b419sm32705035e9.1.2025.12.19.01.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 01:26:09 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v2 8/8] scsi: ufs: Convert to scsi bus methods
Date: Fri, 19 Dec 2025 10:25:37 +0100
Message-ID:  <69f17c7d4f8f587e2a56e3ea268d441d98a6a895.1766133330.git.u.kleine-koenig@baylibre.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2170; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=JFJvLGnyaHaCV/eJzejgi5pSvHr6D8xakNdWbDoTCoQ=; b=kA0DAAoBj4D7WH0S/k4ByyZiAGlFGiGjjk6qc0RvRyJZG5ixc8Wz+NTnF0Cizh6nRvjrn03iE 4kBMwQAAQoAHRYhBD+BrGk6eh5Zia3+04+A+1h9Ev5OBQJpRRohAAoJEI+A+1h9Ev5Ov6MH/jlY GNzBxxjQ/8nlY7aC9rclIr1Lin6LyW5AQ18LOuo0fVz3sG8R3ZFEKxjSgJeIMXKXO8nP9NCVvQr TUPIpYMAUlkYaMsrnD61k+Xqver+dgeMYDw4FC64WIuD2/DQjl/gg5d8OB/KKKCN1Qr1sNhNb/R nKRnwHJkzdfscRfMOPZviEplerBOt/hwrbVwnpSDdokMqZfZDI2OR1gP1+HsVT3JDJrj71gFBLl /LnuX6EB0ADIkKNSzywAiVQqiHSjGZVjCYl7zi+RNSdS/QZ4IHFnMT8nvWK+2GcTo5KX9i8eIxj TopuKY6AKRdIz1k5qDtUXiNO97+TxTahd1eMKyk=
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi subsystem has implemented dedicated callbacks for probe, remove
and shutdown. Make use of them. This fixes a runtime warning about the
driver needing to be converted to the bus probe method.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/ufs/core/ufshcd.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index da1e89e95d07..78669c205568 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10525,9 +10525,8 @@ int ufshcd_runtime_resume(struct device *dev)
 EXPORT_SYMBOL(ufshcd_runtime_resume);
 #endif /* CONFIG_PM */
 
-static void ufshcd_wl_shutdown(struct device *dev)
+static void ufshcd_wl_shutdown(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
 	struct ufs_hba *hba = shost_priv(sdev->host);
 
 	down(&hba->host_sem);
@@ -11133,9 +11132,9 @@ static int ufshcd_wl_poweroff(struct device *dev)
 }
 #endif
 
-static int ufshcd_wl_probe(struct device *dev)
+static int ufshcd_wl_probe(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct device *dev = &sdev->sdev_gendev;
 
 	if (!is_device_wlun(sdev))
 		return -ENODEV;
@@ -11147,10 +11146,11 @@ static int ufshcd_wl_probe(struct device *dev)
 	return  0;
 }
 
-static int ufshcd_wl_remove(struct device *dev)
+static void ufshcd_wl_remove(struct scsi_device *sdev)
 {
+	struct device *dev = &sdev->sdev_gendev;
+
 	pm_runtime_forbid(dev);
-	return 0;
 }
 
 static const struct dev_pm_ops ufshcd_wl_pm_ops = {
@@ -11223,12 +11223,12 @@ static void ufshcd_check_header_layout(void)
  * Hence register a scsi driver for ufs wluns only.
  */
 static struct scsi_driver ufs_dev_wlun_template = {
+	.probe = ufshcd_wl_probe,
+	.remove = ufshcd_wl_remove,
+	.shutdown = ufshcd_wl_shutdown,
 	.gendrv = {
 		.name = "ufs_device_wlun",
-		.probe = ufshcd_wl_probe,
-		.remove = ufshcd_wl_remove,
 		.pm = &ufshcd_wl_pm_ops,
-		.shutdown = ufshcd_wl_shutdown,
 	},
 };
 
-- 
2.47.3

