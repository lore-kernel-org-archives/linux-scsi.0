Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D279C170826
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750792172; cv=none; b=cEmDEY4ILsKqkJmKuaLExzfTQEYzEI3oPnXA9Z/NL7MaanucQcRQvIpDhW5LhSff452L5FbZAGbtkiS31thz7fnBc+YxOrVYQpY1QFqy8viGeD4KjeSYuNov1SwN4vKLbh0C/L6w3KH9Pe2T8NELa2IQIwmcnqnFKXn0jjLIass=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750792172; c=relaxed/simple;
	bh=hBhJ9L2/0h1qj4fvkYPYVGp55waIKwB8Ncc4UioS0Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IlXhre2lkc9t8o+SyusookPRVbEJe5q9M90SmpBvkQT8iTlEROuFPXMuqbEmbagqxZoc8KWVdOF7PR3/7bXDsP/nou+7jrg6eP7vH4pTJBqcKA2jhIjskmmsfqzs5XBiPGhApINqEDqdOTWsk78dO2EqYJNnqiM8I0HYJqWeinE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CIgHLcF7; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIgHLcF7"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a52878d37aso862005f8f.2
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 12:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750792168; x=1751396968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FkvYPueiCOuf5txXi0BNyw1clF28awuB3uZflGQQ4EE=;
        b=CIgHLcF7cvQF0JR/5fzSvj/EIrcQkmiKBn9maON9/pSNDHUeCP5hY8l0x/3pD3jMTB
         EMou0iKqaz8c1rm0+3hPn/eCq0pmNEEIZYpW7mqRtV0r/TI69PNRoA2C65Rtn04BW8pA
         QBOPzw1X6v7ceK/k9PYdhkQdxlCi4uEUh9vaSCZkXXxpm6xZqL1Vo+mziLMPB5TyfaYD
         WdAfXk0ZLd8+0k7py0uwH4tvtzZhVrKrTVFpH/v1DhaouHaVfnAzM6SHN+clusdUFXH/
         UzvNw0fMKc1qBfVh5nyUjqgnFg4o5RUTQjt+PPK1TV5jC09NURk9cJYWkG6Ow8ch8JqS
         /Vkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750792168; x=1751396968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FkvYPueiCOuf5txXi0BNyw1clF28awuB3uZflGQQ4EE=;
        b=jAgEPmde9Sjl3VDZppS6kW5jxCOBfFT9t8aZJxI4RoT6AqhT/YhRj8SuWYQ9fuF/wi
         vNrh2D6XrUOk/Q4pgu3K8q1rbNuGRb1xSfyarpboJEW+32pnh1tZjCEH3cFG8NaRPkgx
         gGTAGe24+Iw3oI5rqkmUgrQt6HvXuvoWrGr1rcfiVUyde3nxyklhiVUFENARy8c2fLCl
         1nSR0QOP0CCDCYbxU6B5cWZUsdAlpSQqigXsKgy5Hv2gLHgengjBmk41/RyVOnWqvjV7
         3CEhAaIrfvxz8/dFGGrf69sFvGwaHUz2XuEnqPub1fm8+eUWLarvlE4RaCgXgbTnFhB6
         Br9g==
X-Forwarded-Encrypted: i=1; AJvYcCVNSajrdZ2qG6BJ7CYEFYK/15s6+TT0wS/EMVU6kzPXdg8TSJFiDDYmOLYiKBA1DTKkMACbbotaCy06@vger.kernel.org
X-Gm-Message-State: AOJu0YxqZsq1cgHUT5XjgVDHQxdgKnUPDOzZGPukyvvofeEmzMnRvxi8
	c6XnpcJt7U7Xc8Fy+RhWEqlwD0xZV5gODbDqi52WB13e48nSJFijKYo=
X-Gm-Gg: ASbGncuetGXbYX6c0Xjb0t9Rpbcf9Q5s9jUSH0Cku1PXDL261pxj9zH5SgKcnXyJhDb
	dNyJSkXbhhTXlNo+Amb7vGzdpTjQ3pB3upwfOFU841WlDZ4WHSxYRS2/QQyodmxZNCThHgd7Vr8
	dapu2GtN/J5f+uW8u6rdbBM1MlBvRKdoJ1zkSSC81SEh58SxGJHHxiS0bFe2MEhBKwD8Ap/xfDr
	+KG+W604rC0CcNKYuE8HDDE7Nt/LvQYeGSmu3ETqk3UKAMdxtoIhYyR7Q5+gbTZirq6yR9cPffX
	uLcUv0MqjS8U52izeCs58A/KgaOpXaIRJOzbgaDPyszpYLcy1YV+pA0wkNOMy/5++1IKZklvWlN
	7FxAeIUAn4oXetTPEcYkr
X-Google-Smtp-Source: AGHT+IEePkrOyGuXaIC29F2bg0H/92kD36TZ0jf8wCx1W59mVlvtwCyryVuuvo7od6B2GT9jQTfsZQ==
X-Received: by 2002:a05:6000:2211:b0:3a5:7875:576 with SMTP id ffacd0b85a97d-3a6d12d737bmr5213330f8f.1.1750792167693;
        Tue, 24 Jun 2025 12:09:27 -0700 (PDT)
Received: from localhost (8.red-80-39-33.staticip.rima-tde.net. [80.39.33.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f264esm2585524f8f.47.2025.06.24.12.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 12:09:27 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Nilesh Javali <njavali@marvell.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	QLOGIC ML <GR-QLogic-Storage-Upstream@marvell.com>,
	LINUX SCSI ML <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: qla2xxx: remove firmware URL
Date: Tue, 24 Jun 2025 21:09:25 +0200
Message-ID: <20250624190926.115009-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

redirects to a marvell URL, only with drivers.

Cc: Nilesh Javali <njavali@marvell.com> (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER)
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com> (maintainer:SCSI SUBSYSTEM)
Cc: Martin K. Petersen <martin.petersen@oracle.com> (maintainer:SCSI SUBSYSTEM)
Cc: QLOGIC ML <GR-QLogic-Storage-Upstream@marvell.com> (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER)
Cc: LINUX SCSI ML <linux-scsi@vger.kernel.org> (open list:QLOGIC QLA2XXX FC-SCSI DRIVER)
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/qla2xxx/Kconfig    | 6 +-----
 drivers/scsi/qla2xxx/qla_init.c | 4 ----
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index a8b4314bfd6e..6946d7155bc2 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -25,11 +25,7 @@ config SCSI_QLA_FC
 	  Upon request, the driver caches the firmware image until
 	  the driver is unloaded.
 
-	  Firmware images can be retrieved from:
-
-	        http://ldriver.qlogic.com/firmware/
-
-	  They are also included in the linux-firmware tree as well.
+	  Firmware images are included in the linux-firmware tree.
 
 config TCM_QLA2XXX
 	tristate "TCM_QLA2XXX fabric module for QLogic 24xx+ series target mode HBAs"
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 514934dd6f80..be211ff22acb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8603,8 +8603,6 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 	return QLA_SUCCESS;
 }
 
-#define QLA_FW_URL "http://ldriver.qlogic.com/firmware/"
-
 int
 qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
@@ -8622,8 +8620,6 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	if (!blob) {
 		ql_log(ql_log_info, vha, 0x0083,
 		    "Firmware image unavailable.\n");
-		ql_log(ql_log_info, vha, 0x0084,
-		    "Firmware images can be retrieved from: "QLA_FW_URL ".\n");
 		return QLA_FUNCTION_FAILED;
 	}
 
-- 
2.50.0

