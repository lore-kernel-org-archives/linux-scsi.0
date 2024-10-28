Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BCB18C90A
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 08:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730102891; cv=none; b=HppL2Z0YjX+abeUc4opklBQsvv54A3Ms2JnjHdnRh9p67HYYBYIiMEPdi2ykOKPHYBUqWr+YqCVBaniRhpmpHXeuYASQtmHzr/EJULK11LGS/CfFhllB9tO6XPZPBMQPulYvKNHZr+q85HJj0qm7Vd9Q60/SEOSrqhf5v/LLMV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730102891; c=relaxed/simple;
	bh=G2e8gI3c9FG/MB+RYZX0Vo/4XfyPnuRvWxblgkT3i3o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PCIrevn0U3IM7+3mSdyA5/vTOCnGPZ6MsJoOSKsWuzAc+ic3NEBWaNi6jJI3MibU92JLZxo4lXR4lecc/Zw4PlR4CCGUEooXzu/LbYviVy4E6/a+Ahv5q7Zraj/xpAQq4j8IjKs/dc+hVH5VdEbeNOmy3Zuh/3PrZP8zYypBp1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=dBQJLiz7; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="dBQJLiz7"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4319399a411so27119275e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 01:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1730102886; x=1730707686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N4qDjbHqYjW+XCnQ6s6Y0wz7hBrex6eMmdS2icXTx78=;
        b=dBQJLiz7tB5xWkewvwTtTcSGJLMDsJeXzbxnLZec0wFVaZMNqvx7tmBPV+QUgwWxdl
         aLn75IPKH1p3iWF6D+Y+B0CirGAfCP/yHs+3jpzK3LpUFyz96EnHTZsjnrpIHhQ+hXKE
         79EJuFoc9wwfLtWewLuGMZ885WFAgVJmZATky1MphK+NuRg99H0A8TsjPmyR4sFXwdj5
         GriO5gYTD4bH+aMw79zNv5EBModvFLsYuGLBqB6/DsCVnY5rBVeolGfQd9Y1ECZfvfNM
         D2/KyrM+HFuRnD5Tm3qlVzZHBPMtX3SxiCCTpiHBWSrX8Y269Zut1Zn5BMR/mEYF8vDt
         NBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730102886; x=1730707686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N4qDjbHqYjW+XCnQ6s6Y0wz7hBrex6eMmdS2icXTx78=;
        b=Anwx/JiIjERbtBo0SEBRa9s/w7w4Ma7hU/0u24tIWwQhwfSd5p33WOGlXtzQgKMhoH
         C6OpnrjBN9DIyruIVLe98UonflDhpXaezQY0/t6T/pchYcsitIA6a8p7/qH9RTPJbsvh
         BmuZE/KjCMiK8R0oIHiyItml0HZD6yCUeft00/pZ6JcZKJqk/Bk8wXnos0f65BYTt8gM
         c4Uu80bcDsOhHnNaTfL5oUg1xmlUxQVaTt9Y+B9urG7dBqJP3QimK0IQ44H9Etgs/LbU
         plk561XlBxhptSVtChPTn3dV/DCdhEmfOGFSbHcs7j/aw68f3ywC3j5ukzFsTsU+xmVr
         8OJQ==
X-Gm-Message-State: AOJu0YyLkE1vTBp6o769s3E5DXxj1+3W1UcVmt6QgE0mwEgCw7BuKUXQ
	ebKT619LI3Qz3lI7QBlkw5VQookX6NYEZ+MXPcEy4yoK0NSkf0hHb0CDK7VgLmM=
X-Google-Smtp-Source: AGHT+IFceWeINyt1owRL8mrmTojuSuOJ3CMJ87+38Uq5Dco34cpAzDNE2+RILL5iiXCPKptvh6shDA==
X-Received: by 2002:a5d:4c4f:0:b0:37d:446a:4142 with SMTP id ffacd0b85a97d-38061158e44mr5036197f8f.32.1730102885862;
        Mon, 28 Oct 2024 01:08:05 -0700 (PDT)
Received: from localhost (p50915d2d.dip0.t-ipconnect.de. [80.145.93.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b3c1f7sm8805067f8f.43.2024.10.28.01.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 01:08:05 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: Switch back to struct platform_driver::remove()
Date: Mon, 28 Oct 2024 09:07:55 +0100
Message-ID: <20241028080754.429191-2-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=9884; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=G2e8gI3c9FG/MB+RYZX0Vo/4XfyPnuRvWxblgkT3i3o=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBnH0Za4zwOzhe3Oo+0gmL6Cm0GIHozXCEZbAt1e oXPrl4/yPmJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZx9GWgAKCRCPgPtYfRL+ Tho1B/0XYzr3pna0XC+EOF0+AHdDN1IdoJRWaJdRr5rdl8vy125nmstrZxRT2uBspDGNXck8ZOR 1vyAE+MEsyqCyqJy6N2eT5ITesZ6jqwK4F3KHfNF/PNn3tnaL6NL37OktIOOuGH5SGdkW5smD1s hHhrjqWckhb/G+ppxf5/uP8gAE5Kwjq1FF4BdL1fEvhbHXpJZ3J0e0YczdyU+w3/imlfIk3I3ZY S/9Z/rhISx8LgCLiIs1Whdj1ong9fzhRIjPAs+7tRUe8hSXNmjEGQBa0Am7xl0aOfV6aSjwA3Mn xCCpuywW0Ey433HTBMUqmnYSZSdDCbWOItA9AsVsFEGzLEGm
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

After commit 0edb555a65d1 ("platform: Make platform_driver::remove()
return void") .remove() is (again) the right callback to implement for
platform drivers.

Convert all platform drivers below drivers/scsito use .remove(), with
the eventual goal to drop struct platform_driver::remove_new(). As
.remove() and .remove_new() have the same prototypes, conversion is done
by just changing the structure member name in the driver initializer.

On the way do a few whitespace changes to make indention consistent.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
Hello,

I did a single patch for all of drivers/scsi. While I usually prefer to
do one logical change per patch, this seems to be overengineering here
as the individual changes are really trivial and shouldn't be much in
the way for stable backports. But I'll happily split the patch if you
prefer it split.

Note I didn't Cc: the maintainers of each driver as this would hit
sending limits.

This is based on today's next, if conflicts arise when you apply it at
some later time and don't want to resolve them, feel free to just drop
the changes to the conflicting files. I'll notice and followup at a
later time then. Or ask me for a fixed resend.

Best regards
Uwe

 drivers/scsi/a3000.c                   | 6 +++---
 drivers/scsi/a4000t.c                  | 6 +++---
 drivers/scsi/atari_scsi.c              | 2 +-
 drivers/scsi/bvme6000_scsi.c           | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 +-
 drivers/scsi/jazz_esp.c                | 2 +-
 drivers/scsi/mac_esp.c                 | 2 +-
 drivers/scsi/mac_scsi.c                | 2 +-
 drivers/scsi/mvme16x_scsi.c            | 2 +-
 drivers/scsi/qlogicpti.c               | 2 +-
 drivers/scsi/sgiwd93.c                 | 2 +-
 drivers/scsi/sni_53c710.c              | 2 +-
 drivers/scsi/sun3_scsi.c               | 2 +-
 drivers/scsi/sun3x_esp.c               | 2 +-
 drivers/scsi/sun_esp.c                 | 2 +-
 16 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index ad39797890e5..bf054dd7682b 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -302,9 +302,9 @@ static void __exit amiga_a3000_scsi_remove(struct platform_device *pdev)
  * triggering a section mismatch warning.
  */
 static struct platform_driver amiga_a3000_scsi_driver __refdata = {
-	.remove_new = __exit_p(amiga_a3000_scsi_remove),
-	.driver   = {
-		.name	= "amiga-a3000-scsi",
+	.remove = __exit_p(amiga_a3000_scsi_remove),
+	.driver = {
+		.name = "amiga-a3000-scsi",
 	},
 };
 
diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index d9103adc87fe..75b43047a155 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -115,9 +115,9 @@ static void __exit amiga_a4000t_scsi_remove(struct platform_device *pdev)
  * triggering a section mismatch warning.
  */
 static struct platform_driver amiga_a4000t_scsi_driver __refdata = {
-	.remove_new = __exit_p(amiga_a4000t_scsi_remove),
-	.driver   = {
-		.name	= "amiga-a4000t-scsi",
+	.remove = __exit_p(amiga_a4000t_scsi_remove),
+	.driver = {
+		.name = "amiga-a4000t-scsi",
 	},
 };
 
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 98a1b966a0b0..85055677666c 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -885,7 +885,7 @@ static void __exit atari_scsi_remove(struct platform_device *pdev)
  * triggering a section mismatch warning.
  */
 static struct platform_driver atari_scsi_driver __refdata = {
-	.remove_new = __exit_p(atari_scsi_remove),
+	.remove = __exit_p(atari_scsi_remove),
 	.driver = {
 		.name	= DRV_MODULE_NAME,
 	},
diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
index f893e9779e9d..baf5f4e47937 100644
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -106,7 +106,7 @@ static struct platform_driver bvme6000_scsi_driver = {
 		.name		= "bvme6000-scsi",
 	},
 	.probe		= bvme6000_probe,
-	.remove_new	= bvme6000_device_remove,
+	.remove		= bvme6000_device_remove,
 };
 
 static int __init bvme6000_scsi_init(void)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 70bba55bc5d0..c3e571be2222 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1802,7 +1802,7 @@ MODULE_DEVICE_TABLE(acpi, sas_v1_acpi_match);
 
 static struct platform_driver hisi_sas_v1_driver = {
 	.probe = hisi_sas_v1_probe,
-	.remove_new = hisi_sas_remove,
+	.remove = hisi_sas_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.of_match_table = sas_v1_of_match,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index ab6668dc5b77..1a62b5d15eca 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3649,7 +3649,7 @@ MODULE_DEVICE_TABLE(acpi, sas_v2_acpi_match);
 
 static struct platform_driver hisi_sas_v2_driver = {
 	.probe = hisi_sas_v2_probe,
-	.remove_new = hisi_sas_remove,
+	.remove = hisi_sas_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.of_match_table = sas_v2_of_match,
diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index fb04b0b515ab..35137f5cfb3a 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -196,7 +196,7 @@ MODULE_ALIAS("platform:jazz_esp");
 
 static struct platform_driver esp_jazz_driver = {
 	.probe		= esp_jazz_probe,
-	.remove_new	= esp_jazz_remove,
+	.remove		= esp_jazz_remove,
 	.driver	= {
 		.name	= "jazz_esp",
 	},
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 187ae0a65d40..ff0253d47a0e 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -432,7 +432,7 @@ static void esp_mac_remove(struct platform_device *dev)
 
 static struct platform_driver esp_mac_driver = {
 	.probe    = esp_mac_probe,
-	.remove_new = esp_mac_remove,
+	.remove   = esp_mac_remove,
 	.driver   = {
 		.name	= DRV_MODULE_NAME,
 	},
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index f225bb20aa22..a86bd839d08e 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -547,7 +547,7 @@ static void __exit mac_scsi_remove(struct platform_device *pdev)
  * triggering a section mismatch warning.
  */
 static struct platform_driver mac_scsi_driver __refdata = {
-	.remove_new = __exit_p(mac_scsi_remove),
+	.remove = __exit_p(mac_scsi_remove),
 	.driver = {
 		.name	= DRV_MODULE_NAME,
 	},
diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index e08a38e2a442..9b19d5205e50 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -127,7 +127,7 @@ static struct platform_driver mvme16x_scsi_driver = {
 		.name           = "mvme16x-scsi",
 	},
 	.probe          = mvme16x_probe,
-	.remove_new     = mvme16x_device_remove,
+	.remove         = mvme16x_device_remove,
 };
 
 static int __init mvme16x_scsi_init(void)
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 6177f4798f3a..74866b9f2b14 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1463,7 +1463,7 @@ static struct platform_driver qpti_sbus_driver = {
 		.of_match_table = qpti_match,
 	},
 	.probe		= qpti_sbus_probe,
-	.remove_new	= qpti_sbus_remove,
+	.remove		= qpti_sbus_remove,
 };
 module_platform_driver(qpti_sbus_driver);
 
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index b0bef83db7b6..6594661db5f4 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -306,7 +306,7 @@ static void sgiwd93_remove(struct platform_device *pdev)
 
 static struct platform_driver sgiwd93_driver = {
 	.probe  = sgiwd93_probe,
-	.remove_new = sgiwd93_remove,
+	.remove = sgiwd93_remove,
 	.driver = {
 		.name   = "sgiwd93",
 	}
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 9df1c90a24c1..d1d2556c8fc4 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -119,7 +119,7 @@ static void snirm710_driver_remove(struct platform_device *dev)
 
 static struct platform_driver snirm710_driver = {
 	.probe	= snirm710_probe,
-	.remove_new = snirm710_driver_remove,
+	.remove	= snirm710_driver_remove,
 	.driver	= {
 		.name	= "snirm_53c710",
 	},
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index fffc0fa52594..bb47274d920d 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -657,7 +657,7 @@ static void __exit sun3_scsi_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver sun3_scsi_driver = {
-	.remove_new = __exit_p(sun3_scsi_remove),
+	.remove = __exit_p(sun3_scsi_remove),
 	.driver = {
 		.name	= DRV_MODULE_NAME,
 	},
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index e20f314cf3e7..365406885b8e 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -265,7 +265,7 @@ static void esp_sun3x_remove(struct platform_device *dev)
 
 static struct platform_driver esp_sun3x_driver = {
 	.probe          = esp_sun3x_probe,
-	.remove_new     = esp_sun3x_remove,
+	.remove         = esp_sun3x_remove,
 	.driver = {
 		.name   = "sun3x_esp",
 	},
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 5ce6c9d19d1e..aa430501f0c7 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -603,7 +603,7 @@ static struct platform_driver esp_sbus_driver = {
 		.of_match_table = esp_match,
 	},
 	.probe		= esp_sbus_probe,
-	.remove_new	= esp_sbus_remove,
+	.remove		= esp_sbus_remove,
 };
 module_platform_driver(esp_sbus_driver);
 

base-commit: a39230ecf6b3057f5897bc4744a790070cfbe7a8
-- 
2.45.2

