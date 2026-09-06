Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1201A3AB47E
	for <linux-scsi@vger.kernel.org>; Sun,  6 Sep 2026 03:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788666050; cv=none; b=EklmszIhGFZsR2JKsw32kARVSTct/n+3rcl7L8Voi48JXXNRGLNdhT2cNU6M6hnXmChgSqVkEdr/W+NCgUhmhgq34DrbiZY+Ow56SfAgYn4SafU0eBBpvqFoRS8bG0djii9RuPsfxYbH7VBLFJhxs6MLalY84gQiyjG7xI395Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788666050; c=relaxed/simple;
	bh=/8M0tegxRt4HmKQN/LPB34a28YCNaa39wlzYTA1fjKc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fUMoZMI9x18gcFKAdGj6MVOKrLlWxedockoRtHL2+hrZEopM/QT2LzYwSHCw2/od+q9jTQdijd9cC6wR4VIRkY7RiuKrVufOWWNIThNhbAb4lRGtwFVjQREgenEO85Ubq6vZTT9MqrvvuSI8T9mCjQPBQAay1bstuK1pZx4FNOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iya4Hw0w; arc=none smtp.client-ip=74.125.227.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iya4Hw0w"
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-398b9f722abso720738a91.0
        for <linux-scsi@vger.kernel.org>; Sat, 05 Sep 2026 20:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788666048; x=1789270848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IKdp+HR5KTqwNHJfV8ToQcuLLzhKcZ0RoFebWPsbOCw=;
        b=Iya4Hw0weJMIL7mEWc2ZjRd2aSU6vPCBCf61lbWazsbzuXC57PAS/GEFgCD/CznI9E
         m58rcbrw22KlrSTuDRXxxj5fXy95dHy3YPL986L4vh2SngmHvc3f3vo7Cmhe+ojHoY9v
         ssfIPx/TB6+qDSZ2UHb/oMgm2ZBSog9EQLqmk04JoNPEIBbuyx7eWjKRNnL+G/HQRZJw
         8V6nR3+J3ZHiTkRUKUUzNdpfZHZmm/eWazqhFu14hvrDQ3xDpF86lBfHXwmgo/UHOdSS
         ot83Vfe3jPpQJ25DUz8QjF8dQRXR2ktiFfWK25pSSaSW+YxJhN3ehLYo0qXfz2dTPgHk
         wRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788666048; x=1789270848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IKdp+HR5KTqwNHJfV8ToQcuLLzhKcZ0RoFebWPsbOCw=;
        b=nuSbHElKIHyhBcoY5jqrnLN8HxddwxNeD5m1XowTHWE4r7ekFYhAVSICFKmNp0/52I
         OTl0EpO8Phq9P+FugBGUqtU/get9bmp2wlqtrTMaEf1tMEWyKIDBP4D+y6laavjD7DMr
         QrG9Z3MNdCQST41W31MtTTCZrAjvffQFfrhATs3nayajVfMHrp3asI5esD8EmKaad3qh
         Oz+B9e+7Q4FT9oBEBJQpSct08hpRPwy+jHFGYRr8R/2Bl8Qs6mjmR4NKlU/Vy3hooBUX
         VwMM6msxedIt7pLG2+WhnVhHI67Eqzx3zOUixyj2H49jZEloSVZS7pZgfvALAwXMFabf
         a7Xg==
X-Forwarded-Encrypted: i=1; AKwUvByRKnk0WETg3ArArBy9ZApCtKWDwVrr379MzsAVcNGdOBLYBrFggpG+CZvv3glX14YrHCWfZf6lly+4@vger.kernel.org
X-Gm-Message-State: AFuF++mu8s6YlxJ9iywy2tjxjyWcHJTwjP08Zl7NNpz2CaK9Q/yKFG1y
	ZzpOhB87WUjJIjYxc4iO4hCoTgnJSMBAa9RMOYpZX8gWeoiaekfkCssf
X-Gm-Gg: AYBFou2a02YV3Bz07PQScQ1UcgFxe0VwkzbpalZQsVV/zNDrU5DbcsHpVo+RpIDumcV
	/tT1PAhbe1nDY6+p8hzTf5wxDnqTDH9mTuM1Xerdw+bS1+BJKl8ThWJHLkKwQ7aVCDrYjWqBCik
	/N1Tf9YZ+TSQIL1GojPfX+F4Omm77T7MmD1rP2xMy8328wxbZ5JTXxYJPAf2M23WZyMsFNfxZ1z
	iqpHf7A0pD6Wspa3RRfI0VD3Q5noEQTsAL77bLaOJwW5t2oE5eBz4EQnPl64rb7lno8rI167Hf7
	bQLRuoCNXO8y/6QRvpQcf2Z3rP4h9wm6944ISrLD+wd3gOZ5So1oqrY2QFHU1nY4mmWwGraA96x
	hFuYmlILypk2NdroZSCxbtkM6vxsGGS45HZuAzyQLIXXKY/kE3bhEZ/fswp5D4K2Ae+qp9FaUZy
	ie4nfMzG1nT0Kinbvs3nON3jjyKxuwq/2l456KOpcDrS7tshjY/n5Bu8Wvcz7aNgWCPUR8YrJFQ
	g8ngyI/uyXWKN+2LgsNSJ39zZpeXMBQL0INfO7dle3WgwSRjNk/qx8Dvsp1SVq+8099o/mzLWDy
	twZmbvuAh7/Ot1mPefnxn3+KqY5boJywnlO3AmyagbPSe2rvIdD54BA=
X-Received: by 2002:a17:90b:1dc3:b0:398:d6f4:c61a with SMTP id 98e67ed59e1d1-39b26207ee4mr24439031a91.17.1788666048184;
        Sat, 05 Sep 2026 20:40:48 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243a9388sm16121651c88.10.2026.09.05.20.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 20:40:47 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH] zorro: use module_driver() to avoid repeated boilerplate code
Date: Sat,  5 Sep 2026 20:40:19 -0700
Message-ID: <20260906034037.81379-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Many Zorro drivers have module_init and module_exit functions that only
call zorro_register_driver() and zorro_unregister_driver(). The
module_driver() macro automatically generates these functions given the
register and unregister functions. Switch to it to simplify the code.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/net/ethernet/8390/hydra.c     | 13 +------------
 drivers/net/ethernet/8390/zorro8390.c | 13 +------------
 drivers/net/ethernet/amd/a2065.c      | 13 +------------
 drivers/net/ethernet/amd/ariadne.c    | 13 +------------
 drivers/scsi/a2091.c                  | 12 +-----------
 drivers/scsi/gvp11.c                  | 12 +-----------
 drivers/scsi/zorro7xx.c               | 13 +------------
 drivers/scsi/zorro_esp.c              | 13 +------------
 8 files changed, 8 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/8390/hydra.c b/drivers/net/ethernet/8390/hydra.c
index 9a59915436d2..2edf97e500df 100644
--- a/drivers/net/ethernet/8390/hydra.c
+++ b/drivers/net/ethernet/8390/hydra.c
@@ -257,18 +257,7 @@ static void hydra_remove_one(struct zorro_dev *z)
     free_netdev(dev);
 }
 
-static int __init hydra_init_module(void)
-{
-    return zorro_register_driver(&hydra_driver);
-}
-
-static void __exit hydra_cleanup_module(void)
-{
-    zorro_unregister_driver(&hydra_driver);
-}
-
-module_init(hydra_init_module);
-module_exit(hydra_cleanup_module);
+module_driver(hydra_driver, zorro_register_driver, zorro_unregister_driver);
 
 MODULE_DESCRIPTION("Zorro-II Hydra 8390 ethernet driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/8390/zorro8390.c b/drivers/net/ethernet/8390/zorro8390.c
index cb1d5ed20874..0f66f28e50b4 100644
--- a/drivers/net/ethernet/8390/zorro8390.c
+++ b/drivers/net/ethernet/8390/zorro8390.c
@@ -430,18 +430,7 @@ static struct zorro_driver zorro8390_driver = {
 	.remove		= zorro8390_remove_one,
 };
 
-static int __init zorro8390_init_module(void)
-{
-	return zorro_register_driver(&zorro8390_driver);
-}
-
-static void __exit zorro8390_cleanup_module(void)
-{
-	zorro_unregister_driver(&zorro8390_driver);
-}
-
-module_init(zorro8390_init_module);
-module_exit(zorro8390_cleanup_module);
+module_driver(zorro8390_driver, zorro_register_driver, zorro_unregister_driver);
 
 MODULE_DESCRIPTION("Zorro NS8390-based ethernet driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/a2065.c
index 672c4996b30e..93f2261f4bfe 100644
--- a/drivers/net/ethernet/amd/a2065.c
+++ b/drivers/net/ethernet/amd/a2065.c
@@ -768,18 +768,7 @@ static void a2065_remove_one(struct zorro_dev *z)
 	free_netdev(dev);
 }
 
-static int __init a2065_init_module(void)
-{
-	return zorro_register_driver(&a2065_driver);
-}
-
-static void __exit a2065_cleanup_module(void)
-{
-	zorro_unregister_driver(&a2065_driver);
-}
-
-module_init(a2065_init_module);
-module_exit(a2065_cleanup_module);
+module_driver(a2065_driver, zorro_register_driver, zorro_unregister_driver);
 
 MODULE_DESCRIPTION("Commodore A2065 Ethernet driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/amd/ariadne.c b/drivers/net/ethernet/amd/ariadne.c
index ec6e7e8c14fe..662eba9e8ffd 100644
--- a/drivers/net/ethernet/amd/ariadne.c
+++ b/drivers/net/ethernet/amd/ariadne.c
@@ -777,18 +777,7 @@ static struct zorro_driver ariadne_driver = {
 	.remove		= ariadne_remove_one,
 };
 
-static int __init ariadne_init_module(void)
-{
-	return zorro_register_driver(&ariadne_driver);
-}
-
-static void __exit ariadne_cleanup_module(void)
-{
-	zorro_unregister_driver(&ariadne_driver);
-}
-
-module_init(ariadne_init_module);
-module_exit(ariadne_cleanup_module);
+module_driver(ariadne_driver, zorro_register_driver, zorro_unregister_driver);
 
 MODULE_DESCRIPTION("Ariadne Ethernet Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index f81e53b53e20..421330a7b6a7 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -288,17 +288,7 @@ static struct zorro_driver a2091_driver = {
 	.remove		= a2091_remove,
 };
 
-static int __init a2091_init(void)
-{
-	return zorro_register_driver(&a2091_driver);
-}
-module_init(a2091_init);
-
-static void __exit a2091_exit(void)
-{
-	zorro_unregister_driver(&a2091_driver);
-}
-module_exit(a2091_exit);
+module_driver(a2091_driver, zorro_register_driver, zorro_unregister_driver);
 
 MODULE_DESCRIPTION("Commodore A2091/A590 SCSI");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 79bd64e12adc..eba868ac355d 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -461,17 +461,7 @@ static struct zorro_driver gvp11_driver = {
 	.remove		= gvp11_remove,
 };
 
-static int __init gvp11_init(void)
-{
-	return zorro_register_driver(&gvp11_driver);
-}
-module_init(gvp11_init);
-
-static void __exit gvp11_exit(void)
-{
-	zorro_unregister_driver(&gvp11_driver);
-}
-module_exit(gvp11_exit);
+module_driver(gvp11_driver, zorro_register_driver, zorro_unregister_driver);
 
 MODULE_DESCRIPTION("GVP Series II SCSI");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 21c769dc1ecb..80e156b04b99 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -173,15 +173,4 @@ static struct zorro_driver zorro7xx_driver = {
 	.remove	  = zorro7xx_remove_one,
 };
 
-static int __init zorro7xx_scsi_init(void)
-{
-	return zorro_register_driver(&zorro7xx_driver);
-}
-
-static void __exit zorro7xx_scsi_exit(void)
-{
-	zorro_unregister_driver(&zorro7xx_driver);
-}
-
-module_init(zorro7xx_scsi_init);
-module_exit(zorro7xx_scsi_exit);
+module_driver(zorro7xx_driver, zorro_register_driver, zorro_unregister_driver);
diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index 178d46140674..121bcbbce52d 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -946,15 +946,4 @@ static struct zorro_driver zorro_esp_driver = {
 	.remove	  = zorro_esp_remove,
 };
 
-static int __init zorro_esp_scsi_init(void)
-{
-	return zorro_register_driver(&zorro_esp_driver);
-}
-
-static void __exit zorro_esp_scsi_exit(void)
-{
-	zorro_unregister_driver(&zorro_esp_driver);
-}
-
-module_init(zorro_esp_scsi_init);
-module_exit(zorro_esp_scsi_exit);
+module_driver(zorro_esp_driver, zorro_register_driver, zorro_unregister_driver);
-- 
2.43.0

