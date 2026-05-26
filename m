Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17A33FE660
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805083; cv=none; b=Djp2K3dCtzEI4qbUYy5/K+RwRKWWGsTU8yM6FfjaRd+bZgJ8bLoi2ZXi+QxI/AAD8N6IENxmJGHt2MtZA3ejoB1wvzqIfQnsFLaNg1awQwoMwW1fgJ+mPh+i9vuwfZ6T9S4iHwKigNLx1B6VIS+0fbc7gjfeJjyO0Rp5Mz0uuDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805083; c=relaxed/simple;
	bh=DUPc4hq5A75iCE9n+8UJBx44jmx2lrSpFvIMVWPYPp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptZe8BiAkq3v6wEHUwT3gl58PWgtN4Xu7ZYpw0xSx8rT211JnCB2s0FxrlGW1apRC9OusWGKJ+cbCyz41XF84Pk5dQwDif+TQM31ookJYQKNOSmgbVoequ4WdpygHbqzsndjuADZHMXKzrPr8Zj6QeXUMwWwz6SCWax44F2GOdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=cErOLFiE; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="cErOLFiE"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490686877a1so14739585e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 07:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1779805080; x=1780409880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owUZ+ht0GkQnt8mYcn/fY6yfRIileFWWrUTIJce2Gaw=;
        b=cErOLFiEI+IqeOv27L4jIhN1kqCubiWv7Byjh8zc/W3umPb6+o2awySfVKqU+QqaX2
         BZ7i5M99osrxCuHxPivXJPlMBu/nEoAmZtIRwqv2lBd8ygWjc2cggH1s7v/Mb0ygcU+d
         +WbN3xZS/5bUDAI743DIuZV5EO7HT8EZdTLRa6/PywVSP8pT8flMiyvueR+N3QkU5PjS
         E2YDetqnh+vtGvsUGBoB+3HLbBTUMAJ4HXGGehQDOxfEkzpC8mzepVUXJE8EMQXsexQX
         znToGfbwc3zke24G6wrQmufpWss6GFQ7AkibsgVbwXTJieWTYKjitsa6wpsrMKwD2zQq
         legw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779805080; x=1780409880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=owUZ+ht0GkQnt8mYcn/fY6yfRIileFWWrUTIJce2Gaw=;
        b=KUf1KazEgzvypqqviAy7WmScavPmR8oo77ZXNzpuPZhz5PYmrFlIrB8OHvB1CuFy0M
         jJjqpAVUKKSIJiFwtH6VBKrFTFy6X8onrUo3y/Vd9RAs2FtN4RgM8LV6rbMawen1TZs6
         PpCSvxqvyQcJHujbZbhsA8w4hUEsoqon8cJdGP1BmD7RMiIMrzkMdLPR+8kLfZAUknF1
         MWa/sntnfDZNn5JlEoXzoLEWSPQ3wXJyMjN4hGwH6m5BVan/x8IJW1elOI9XvXOm3oIA
         kaFZCSiy4Egc8HOgqGNjflbuxle5+N8wKdAM9YUf0beXwgRjL/gyov4H3m1mnIWpo2Hr
         yr9A==
X-Gm-Message-State: AOJu0YzGvZBbUQ+etBW/Hltk8E0XZnklY9y/geDlCkMsfqfIZnhFQwbM
	tJsa3Z46yplmzDSSirHqsNryBRzBJ80thKYkMxHdp33OtGT5+Sp8PPVhe+sqEcPBRUE=
X-Gm-Gg: Acq92OGVZ5hNyCpAG11ycvwiRMGHye1/rWv2hbw0QauRH23lXGcuowvM4RSPoRb0xDl
	WvbbKnhMewbxQkGnuDRE1DNadVmdIZXLO9tDa2nc1OlN+XKz0uFYzS260KpbS6scOwEZ44BoznB
	vyKw9+RU8dhIWRCURID0xNIrkWcj7+/NWyRu7D2aHSLJlhmkIi+8/TG3KMG5VT+g3/pHbejRLJP
	4h+R6oYhsj1KVNDhYGmB+HzaBtZC3uUkcVqHf+zO/+uD2JK9Yrk4IJm2Xrflgfa9ujVhHfSUh0p
	GwjtKHbIzp89E1MfM1vRdmFLMBD3o/bydpgSPjNPr0WF2F90EIIBtAIwCmJMXz3FAPOtYIRQAR9
	KKJzrz/5lN47sFeeeJdbvmJ2xkkbyQdHcAT1gRlAk57V6zyU0zgMB56EIg6sSFoS/B5Ojgk5QFu
	3tD2vpdbAHOKHwADdZRK7xO3H+t/rDL+9B6vkkg5+0w3jv6IXtTD+kZtOWTqy9oK11XKA9YmdGf
	O7qBpmzR9dMick=
X-Received: by 2002:a05:600c:4506:b0:490:3838:1548 with SMTP id 5b1f17b1804b1-49038381676mr334172855e9.13.1779805079826;
        Tue, 26 May 2026 07:17:59 -0700 (PDT)
Received: from localhost (p200300f65f47db04a716d2bdeddb4813.dip0.t-ipconnect.de. [2003:f6:5f47:db04:a716:d2bd:eddb:4813])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45eb6d6ebf0sm37095798f8f.34.2026.05.26.07.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 07:17:59 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org,
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>
Subject: [PATCH v1 2/8] scsi: Use named initializer for zorro_device_id
Date: Tue, 26 May 2026 16:17:28 +0200
Message-ID:  <9602004a447b474b15ca1e110d6d3c277f669e20.1779803053.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3342; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=DUPc4hq5A75iCE9n+8UJBx44jmx2lrSpFvIMVWPYPp0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqFat7M8eMhLUAoLTKpnqFEP1P/GOBJ0Ys3EJgQ NyA/2H+k2aJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCahWrewAKCRCPgPtYfRL+ TmGFB/921JeU5PH45mB8W4KFda/+9nqqIIa+qMv4InKRyccfCdXMtumJ53Km2M897qBTcAkaO8w wxxYTWmi5At320VtoBhOZ8SnJDxZxBQxNPU/TxWV6JjV4ujOcclgaSkQWvuk3piHBCpZ8iv7cWx hA6iOKyjZwwOTt49eIDAqjdRWJfd4CiIwHt/90r42LK3agVvH//OcwP+Qwtt0s6UCa0sQbBz60a SKG4s1AZheRf/9wa53odPVxu4lAUoTnd7Xtpe5++21uDsQUzROHhCUmLnyp7efw4Xds80qmyZD7 LPkx+MmY2lOOVJqsceRrywPuuqhsTGadMsHBhYLTneJJLiOf
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Using named initializers is more explicit and thus easier to parse for a
human.

It's also more robust to changes in the struct definition. This robustness
is relevant for a planned change to struct zorro_device_id that replaces
.driver_data by an anonymous union.

While touching these arrays, drop explicit zeros from the list terminator.

This change doesn't introduce changes to the compiled zorro_device_id
arrays.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/a2091.c     |  6 +++---
 drivers/scsi/gvp11.c     | 17 +++++++++--------
 drivers/scsi/zorro7xx.c  |  2 +-
 drivers/scsi/zorro_esp.c |  2 +-
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 204448bfd04b..f81e53b53e20 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -275,9 +275,9 @@ static void a2091_remove(struct zorro_dev *z)
 }
 
 static struct zorro_device_id a2091_zorro_tbl[] = {
-	{ ZORRO_PROD_CBM_A590_A2091_1 },
-	{ ZORRO_PROD_CBM_A590_A2091_2 },
-	{ 0 }
+	{ .id = ZORRO_PROD_CBM_A590_A2091_1 },
+	{ .id = ZORRO_PROD_CBM_A590_A2091_2 },
+	{ }
 };
 MODULE_DEVICE_TABLE(zorro, a2091_zorro_tbl);
 
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 0420bfe9bd42..79bd64e12adc 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -442,14 +442,15 @@ static void gvp11_remove(struct zorro_dev *z)
 	 */
 
 static struct zorro_device_id gvp11_zorro_tbl[] = {
-	{ ZORRO_PROD_GVP_COMBO_030_R3_SCSI,	~0x00ffffff },
-	{ ZORRO_PROD_GVP_SERIES_II,		~0x00ffffff },
-	{ ZORRO_PROD_GVP_GFORCE_030_SCSI,	~0x01ffffff },
-	{ ZORRO_PROD_GVP_A530_SCSI,		~0x01ffffff },
-	{ ZORRO_PROD_GVP_COMBO_030_R4_SCSI,	~0x01ffffff },
-	{ ZORRO_PROD_GVP_A1291,			~0x07ffffff },
-	{ ZORRO_PROD_GVP_GFORCE_040_SCSI_1,	~0x07ffffff },
-	{ 0 }
+	/* .driver_data specifies the DMA mask */
+	{ .id = ZORRO_PROD_GVP_COMBO_030_R3_SCSI,	.driver_data = ~0x00ffffff },
+	{ .id = ZORRO_PROD_GVP_SERIES_II,		.driver_data = ~0x00ffffff },
+	{ .id = ZORRO_PROD_GVP_GFORCE_030_SCSI,		.driver_data = ~0x01ffffff },
+	{ .id = ZORRO_PROD_GVP_A530_SCSI,		.driver_data = ~0x01ffffff },
+	{ .id = ZORRO_PROD_GVP_COMBO_030_R4_SCSI,	.driver_data = ~0x01ffffff },
+	{ .id = ZORRO_PROD_GVP_A1291,			.driver_data = ~0x07ffffff },
+	{ .id = ZORRO_PROD_GVP_GFORCE_040_SCSI_1,	.driver_data = ~0x07ffffff },
+	{ }
 };
 MODULE_DEVICE_TABLE(zorro, gvp11_zorro_tbl);
 
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 6aca9897b231..1f74586f0428 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -68,7 +68,7 @@ static struct zorro_device_id zorro7xx_zorro_tbl[] = {
 		.id = ZORRO_PROD_GVP_GFORCE_040_060,
 		.driver_data = (unsigned long)&zorro7xx_driver_data[3],
 	},
-	{ 0 }
+	{ }
 };
 MODULE_DEVICE_TABLE(zorro, zorro7xx_zorro_tbl);
 
diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index 1622285c9aec..178d46140674 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -706,7 +706,7 @@ static const struct zorro_device_id zorro_esp_zorro_tbl[] = {
 		.id = ZORRO_ID(PHASE5, 0x19, 0),
 		.driver_data = ZORRO_CYBERII,
 	},
-	{ 0 }
+	{ }
 };
 MODULE_DEVICE_TABLE(zorro, zorro_esp_zorro_tbl);
 
-- 
2.47.3

