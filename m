Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39BF1DED5C
	for <linux-scsi@vger.kernel.org>; Sun,  6 Sep 2026 04:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788667331; cv=none; b=R6yXLaNJFQOYq8wzLLyaxRrr2+pfpPF44CwEqXstptiO8SZxnH0wZP6913m1b6cGTc4PtBC/t5JuzmBfGpowmzBV9m7G9ZL6JdHUyl4mFG/pIQ0lgR/Nu2263AbAJJ09eluDuVow0G17N4A9sY2pvMvrbTh19lfHpAV+6CaYRLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788667331; c=relaxed/simple;
	bh=e3kDwgTbjRMMWW/kMDqb+WZJtSvUWK03BPKsrvS7uos=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ine5W9yoThUl32wedsATFqKRPFsQKn+RFklJOAeM2Tx6gbwRSnCHuK4cpt3gOd/7yzJ138d7TUAS8eXth7gKL/rId72UZMomjJUP9mi+JEXeSUGJ/8kiuuDndRSPWwE8qRoZlSp1DJl9DkKUcB54Pt8YTg6DVEmqU61nJPeffxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ry1vF3i8; arc=none smtp.client-ip=74.125.227.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ry1vF3i8"
Received: by mail-pj2-f8.google.com with SMTP id d9443c01a7336-2db33361b2fso4453125ad.1
        for <linux-scsi@vger.kernel.org>; Sat, 05 Sep 2026 21:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788667329; x=1789272129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cQv+gwRX7Z+DTbRSq5jeq2W2+DL4A8UrN+ZaQRvPPtM=;
        b=Ry1vF3i85d3xZxYFMf9l1+18Y4eU3hfd7Mr3wvMLZ+v2cfzskYwgvDe5K1FXLsUbXQ
         gJgRPhCzj8HG3y8IzG0D30D59Qc2BFtJAKw4bH9RQIpBDxKlqar2oKvwRvifBGOIAO9z
         6S58mJW+dSKIhL4r9X54GXUcalHHZuXIsiEqo3TXUUHUwuqkesnkEFGLjV4KtFvDnqkz
         TLEGWzCJTisCfgk2gwXHKZbMfyGpB4laomXANHByyVbsGgQ61GA1FnBG/S4cpvjxvpHg
         TYbKK4dcPl0Lz76v2Zs6cZsLsoyqay2maCdKPZmuD9N8pHle13wcofUkm4V2gAmoxMCH
         YfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788667329; x=1789272129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cQv+gwRX7Z+DTbRSq5jeq2W2+DL4A8UrN+ZaQRvPPtM=;
        b=A1Bm4hICrcbjtQ3/46vLV/+Qgvvx8YGE221HuD1yFSxLtc7WjGEILSVmvOfqbY/+ou
         Ys4LOfEK+PniyVBxd+xSyaIsQngOWJoUHY/viog20RaKsoGycmF05IxyvpEOGth307Ry
         wJzxlxspXZNl+y97XLFHNqovzlg6m+BQy7oawlPXPiS1BsUsGrJBeqE9nmMgq9KQot05
         DR8lf7cPAgzg3q9Nph3jBB+oS5Rtq1p9hL9lp659yGTBEC8p5VN9joXiSSuBVCRZd5SN
         veGktqn6sb9IjP3NDa0MOTwRyj5zixIzE663CsJPBZhKjLOspss6itUMZfmEsDRpDczf
         owgw==
X-Forwarded-Encrypted: i=1; AKwUvBzt3A22VdRalGOVkCOi9Exc/AcwaFOnKPEGCRaawzKPiBUyZ2RZvgBCPi4dP29x+HEYJiyLIgk+snY4@vger.kernel.org
X-Gm-Message-State: AFuF++lkYcdVQ+64WyQDnMQQo+WJRIct1D5VNBE5oVbd6rzMg9xiNI79
	D9C0bGGB773hsSM7TRbBX8XjjhYMK3lNBO4c/gFZd+UkYEt26C0jQjWs
X-Gm-Gg: AYBFou254RSsHtl6mGqNef1DrQZVlRMiOX1BrE6HStPxoRLyATyblg+qaydxVqpNwh3
	1MgdEbk6c8l8XisC34OoGILY9RXRShgUdVZmRZoWumA6uGAP7anZLSOXqdj5ieB69zT38sqKglu
	lq0Hgi8vSu9r9GTZVWWJ3rIxdYJJHu61GkcCV4hQfrdSId5cqZDiCn3fB5tMyYrkD0hWiT8vsUS
	qa85E/VKsMECh45GvvoUCRUK8rps4VSQ7sD3+yg/P5JcxMjmP9iuJkAI3J1N/6b7tvX9xJdBrAf
	415/hiwO2zuOwOn6miTQmV33qhoMfSzzAlsyZumAnxBDZt0kr6sWcDxyhQwDJHI/7bJ4TzwTEfa
	EcB+Ean/0K9lpOaax/VyAGbu2fEYGI+evUENsvMJ8j9cmvzp2mXa4MXDm18RlKYi/xTbIID0Lwi
	hSj7npmLJ0xfwJpGaa/i47rkzl8fD5GjnUsC/IwfDBUyc7bLz3No1kpiqsrc55BG49i3EyWgzct
	HpDZZkE7ffznnwJMsuZYNmZHmoIGpyAzARL3Dit1pKUgiMUfqgcclc9jeGWu8nTR5HjalBMPhQQ
	UTIRvW6Tks4v360JU/E7kD7xMtTWtDYtDAhh+LQz7WTzdkmjOlOl81o=
X-Received: by 2002:a17:903:9cf:b0:2d8:d4d1:313a with SMTP id d9443c01a7336-2db12634535mr249979245ad.17.1788667329144;
        Sat, 05 Sep 2026 21:02:09 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534152sm17127334eec.10.2026.09.05.21.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 21:02:08 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: Kees Cook <kees@kernel.org>,
	linux-ide@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-serial@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH] ecard: use module_driver() to avoid repeated boilerplate code
Date: Sat,  5 Sep 2026 21:01:46 -0700
Message-ID: <20260906040153.105692-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Many Acorn expansion card drivers have module_init and module_exit
functions that only call ecard_register_driver() and
ecard_remove_driver(). The module_driver() macro automatically
generates these functions given the register and unregister functions.
Switch to it to simplify the code.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/ata/pata_icside.c            | 13 +------------
 drivers/net/ethernet/i825xx/ether1.c | 13 +------------
 drivers/net/ethernet/seeq/ether3.c   | 13 +------------
 drivers/scsi/arm/acornscsi.c         | 13 +------------
 drivers/scsi/arm/arxescsi.c          | 14 +-------------
 drivers/scsi/arm/cumana_1.c          | 13 +------------
 drivers/scsi/arm/cumana_2.c          | 13 +------------
 drivers/scsi/arm/eesox.c             | 13 +------------
 drivers/scsi/arm/oak.c               | 14 +-------------
 drivers/scsi/arm/powertec.c          | 13 +------------
 drivers/tty/serial/8250/8250_acorn.c | 13 +------------
 11 files changed, 11 insertions(+), 134 deletions(-)

diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 70f056e47e6b..df7203a74f45 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -613,19 +613,8 @@ static struct ecard_driver pata_icside_driver = {
 	},
 };
 
-static int __init pata_icside_init(void)
-{
-	return ecard_register_driver(&pata_icside_driver);
-}
-
-static void __exit pata_icside_exit(void)
-{
-	ecard_remove_driver(&pata_icside_driver);
-}
+module_driver(pata_icside_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_AUTHOR("Russell King <rmk@arm.linux.org.uk>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ICS PATA driver");
-
-module_init(pata_icside_init);
-module_exit(pata_icside_exit);
diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
index 3e7d7c4bafdc..d21aeb831531 100644
--- a/drivers/net/ethernet/i825xx/ether1.c
+++ b/drivers/net/ethernet/i825xx/ether1.c
@@ -1070,17 +1070,6 @@ static struct ecard_driver ether1_driver = {
 	},
 };
 
-static int __init ether1_init(void)
-{
-	return ecard_register_driver(&ether1_driver);
-}
-
-static void __exit ether1_exit(void)
-{
-	ecard_remove_driver(&ether1_driver);
-}
-
-module_init(ether1_init);
-module_exit(ether1_exit);
+module_driver(ether1_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
index 20dad39b5ab9..b0d2cbc35914 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -882,17 +882,6 @@ static struct ecard_driver ether3_driver = {
 	},
 };
 
-static int __init ether3_init(void)
-{
-	return ecard_register_driver(&ether3_driver);
-}
-
-static void __exit ether3_exit(void)
-{
-	ecard_remove_driver(&ether3_driver);
-}
-
-module_init(ether3_init);
-module_exit(ether3_exit);
+module_driver(ether3_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 79d7d7336b6a..8b899fbf092e 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2902,18 +2902,7 @@ static struct ecard_driver acornscsi_driver = {
 	},
 };
 
-static int __init acornscsi_init(void)
-{
-	return ecard_register_driver(&acornscsi_driver);
-}
-
-static void __exit acornscsi_exit(void)
-{
-	ecard_remove_driver(&acornscsi_driver);
-}
-
-module_init(acornscsi_init);
-module_exit(acornscsi_exit);
+module_driver(acornscsi_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("AcornSCSI driver");
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 925d0bd68aa5..2d3f5b0519d1 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -344,20 +344,8 @@ static struct ecard_driver arxescsi_driver = {
 	},
 };
 
-static int __init init_arxe_scsi_driver(void)
-{
-	return ecard_register_driver(&arxescsi_driver);
-}
-
-static void __exit exit_arxe_scsi_driver(void)
-{
-	ecard_remove_driver(&arxescsi_driver);
-}
-
-module_init(init_arxe_scsi_driver);
-module_exit(exit_arxe_scsi_driver);
+module_driver(arxescsi_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_AUTHOR("Stefan Hanske");
 MODULE_DESCRIPTION("ARXESCSI driver for Acorn machines");
 MODULE_LICENSE("GPL");
-
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index d1a2a22ffe8c..62c11168f321 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -324,18 +324,7 @@ static struct ecard_driver cumanascsi1_driver = {
 	},
 };
 
-static int __init cumanascsi_init(void)
-{
-	return ecard_register_driver(&cumanascsi1_driver);
-}
-
-static void __exit cumanascsi_exit(void)
-{
-	ecard_remove_driver(&cumanascsi1_driver);
-}
-
-module_init(cumanascsi_init);
-module_exit(cumanascsi_exit);
+module_driver(cumanascsi1_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_DESCRIPTION("Cumana SCSI-1 driver for Acorn machines");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index e460068f6834..24945e1765ae 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -504,18 +504,7 @@ static struct ecard_driver cumanascsi2_driver = {
 	},
 };
 
-static int __init cumanascsi2_init(void)
-{
-	return ecard_register_driver(&cumanascsi2_driver);
-}
-
-static void __exit cumanascsi2_exit(void)
-{
-	ecard_remove_driver(&cumanascsi2_driver);
-}
-
-module_init(cumanascsi2_init);
-module_exit(cumanascsi2_exit);
+module_driver(cumanascsi2_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("Cumana SCSI-2 driver for Acorn machines");
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 99be9da8757f..823ad179f24c 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -626,18 +626,7 @@ static struct ecard_driver eesoxscsi_driver = {
 	},
 };
 
-static int __init eesox_init(void)
-{
-	return ecard_register_driver(&eesoxscsi_driver);
-}
-
-static void __exit eesox_exit(void)
-{
-	ecard_remove_driver(&eesoxscsi_driver);
-}
-
-module_init(eesox_init);
-module_exit(eesox_exit);
+module_driver(eesoxscsi_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("EESOX 'Fast' SCSI driver for Acorn machines");
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index d69245007096..aea21bb13355 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -194,20 +194,8 @@ static struct ecard_driver oakscsi_driver = {
 	},
 };
 
-static int __init oakscsi_init(void)
-{
-	return ecard_register_driver(&oakscsi_driver);
-}
-
-static void __exit oakscsi_exit(void)
-{
-	ecard_remove_driver(&oakscsi_driver);
-}
-
-module_init(oakscsi_init);
-module_exit(oakscsi_exit);
+module_driver(oakscsi_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("Oak SCSI driver");
 MODULE_LICENSE("GPL");
-
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 823c65ff6c12..67f071a0543b 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -432,18 +432,7 @@ static struct ecard_driver powertecscsi_driver = {
 	},
 };
 
-static int __init powertecscsi_init(void)
-{
-	return ecard_register_driver(&powertecscsi_driver);
-}
-
-static void __exit powertecscsi_exit(void)
-{
-	ecard_remove_driver(&powertecscsi_driver);
-}
-
-module_init(powertecscsi_init);
-module_exit(powertecscsi_exit);
+module_driver(powertecscsi_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("Powertec SCSI driver");
diff --git a/drivers/tty/serial/8250/8250_acorn.c b/drivers/tty/serial/8250/8250_acorn.c
index fb596262b9c7..f634de6e159f 100644
--- a/drivers/tty/serial/8250/8250_acorn.c
+++ b/drivers/tty/serial/8250/8250_acorn.c
@@ -120,19 +120,8 @@ static struct ecard_driver serial_card_driver = {
 	},
 };
 
-static int __init serial_card_init(void)
-{
-	return ecard_register_driver(&serial_card_driver);
-}
-
-static void __exit serial_card_exit(void)
-{
-	ecard_remove_driver(&serial_card_driver);
-}
+module_driver(serial_card_driver, ecard_register_driver, ecard_remove_driver);
 
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("Acorn 8250-compatible serial port expansion card driver");
 MODULE_LICENSE("GPL");
-
-module_init(serial_card_init);
-module_exit(serial_card_exit);
-- 
2.43.0

