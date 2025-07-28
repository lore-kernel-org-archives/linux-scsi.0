Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6722274B4D;
	Mon, 28 Jul 2025 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753720699; cv=none; b=QRR7gxkk77eo/1dtrBFzhS32hgaZtFPyeEsINl2RTg6bgv23As7jqAISe/2ZFshGObkqo0hqgqC+HTHMNaBr08PkxOaTiMv417iwuTQ5xSrtMAUenu8NgoTKw+MLnYzfyz3ceTgVNM3KeUiYz/HvLYVYl2m+5Gy6Axol3XQlltU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753720699; c=relaxed/simple;
	bh=T+uNw3YjqQP1aZ7uAwedFetGiajOGf3ieBu7TZnNZcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg3xAQmNjMib7aZNmo79kaZIGtJ7BEV2JhriSiH6aqsjK5FcJ8PmBhq0MDWxVt5mbW9qQs46Y624G4/+ONLb/V2VtHX7t/3yMODBxqnFxPrWJ8UqVAtjNJNLRlAetiaYWycbXgz6aujtyrhZUDrhx67crZ4JCQfxOG5VaSLl9YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SwgL1Ig9; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SwgL1Ig9"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-553b5165cf5so5777604e87.0;
        Mon, 28 Jul 2025 09:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753720696; x=1754325496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HGHqFSiWlLrs//85f4NngCIHhLHkbHaBrCLuZ3xYBdA=;
        b=SwgL1Ig9MUKwZ+7fsgQONGsbvewGE9nideY5ju8sVtyjqXTacFfdFMAMRnMPdD3hXv
         dmuqrYdbKHwjm+++wUY4HVG+fJXxk+Xlge4V/PKbG28bUJ3HVTVJFQcTyjPOEV58Bjxl
         iXofw/Pz0elPxfhyLEK36bK/aUOEciaHZxvqn0NkAKxTWZwBcJzsDJDaFbLx2bMfqnI/
         VeeosaNf8c8Ua4QIolxej26ZRr7Y1lieGoePJlD5/lCwWgCNOhZUOH4f2DUHQhy/QEu4
         bSmMt7M9JXq+sTF203GO2Dxi70YeH9sua86Ez2X1a33Up/A+sgdlL8le6bDmyYEC0qNV
         76eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753720696; x=1754325496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HGHqFSiWlLrs//85f4NngCIHhLHkbHaBrCLuZ3xYBdA=;
        b=FI/GOQ41ZciqKf3mPTyjcobSIuBXf73XqImiZj775c/4Xp7i1q42XUGXLnW44NyQIW
         z8S2+VsIQb8oHJ7ssl7kaOxVj4uZniNWWL7sfzfI6XbhU3EaWxOYKcjKS+DrrX8/mSkW
         kU5oWlAfGcunRAVVkvYDZuCvqJh5vWcQuo79c8LX84ZVbhxf3SWssyshItn4+NCdav9Z
         tbf1/fRk/ItB14Yz/ND1nNIHNsExq49bGwPzg7Xrlya9oYSlAgzli75sF9bxd0/vty33
         Y5Lm6GagdV317sl58Sm4KpVI+jtqVAqdpiXzAsvYOlwWqvrYxdp8ooKsHeCezWw8Y+wp
         evOA==
X-Forwarded-Encrypted: i=1; AJvYcCWfbhndbOT61xNui/fDrv0gKOQvzm3RjRIemNcTZ2HqCUp+t8p9upyDM2nBg6q4tCaWROjTcpfo+oOW7g==@vger.kernel.org, AJvYcCXFHzu5CDaCJZCfRec6noMyksFlwSCz5O+b3p+yIEPZMqTN5a5PBwnzDJ68uA0fbbzmCp+cjIgjM3wVFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIi69v33LPRbHhD5AhBmCP7c9pPThI1CvaN8RbY6Xyn+va2+TP
	pS+2G6tiDDzLJ2Beqy6GP3JEI/sXwiSwf3IxCfAPfPuFn8SLjHA7GvT/m3mZd1tA
X-Gm-Gg: ASbGncvnRdf4IotF6PnFE6BZUUsxvUXxczuMb0gfmEAiIh0pQgVIdStRcAUWGZfTltb
	Eb5dmVjjyVS7K8wX2eWP9jo5suAgk7WnsmCItwUBvAWfehrg3qHGDBIP7/i1Xp6PB1l7bKX1YzO
	9Vvu6lt83GZkHbrg6wCSFuNG/VUzQLTNl++cPqaJrOz/af7rYrVjuxLaWhuizHr/KySB/execLt
	SA2zZdtfBSSytHUCOGhaezVgtythGy6VY7zESGLf0r0bWVGJPJAbGHqXUY/A/QiAcIc/aOtEnv+
	KGunLPsAZOJFe4H6RM2k2NMk2dW52Yb87b0ZJ+wWlqIE7aOkZ3eE49PZsbZjRNlQB/UrcrTuMlp
	+AfUPodjKmgfq3+4XF6qsU2L1Q5m0k3zE6DtRmOHPBum7g7FneO8FxLbL5hJ6wVHcySvVy9JlA/
	A=
X-Google-Smtp-Source: AGHT+IEXlxipIwdge6QrEiG4bECiFkRcWxPM3hRgk/i7lPVnmkRHg1SehpM8Z/j7eB2ZIDDi04Snew==
X-Received: by 2002:a05:6512:ea4:b0:550:e608:410b with SMTP id 2adb3069b0e04-55b5f4ab38amr2990555e87.33.1753720695172;
        Mon, 28 Jul 2025 09:38:15 -0700 (PDT)
Received: from buildhost.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b633631e9sm1322659e87.90.2025.07.28.09.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 09:38:14 -0700 (PDT)
From: Magnus Lindholm <linmag7@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	hch@infradead.org,
	macro@orcam.me.uk
Cc: linmag7@gmail.com
Subject: [PATCH 1/1] scsi: qla1280: Make 64-bit DMA addressing a Kconfig option
Date: Mon, 28 Jul 2025 18:34:14 +0200
Message-ID: <20250728163752.9778-2-linmag7@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250728163752.9778-1-linmag7@gmail.com>
References: <20250728163752.9778-1-linmag7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make 64-bit DMA addressing a Kconfig option.

While defaulting to 64-bit addressing, this gives the user the option
to revert to 32-bits when necessary without messing with the kernel
source. The Kconfig help text also points out the issues with tsunami
based alphas with more than 2GB RAM and 32-bit PCI Qlogic SCSI
controllers.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
---
 drivers/scsi/Kconfig   | 17 +++++++++++++++++
 drivers/scsi/qla1280.c |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5522310bab8d..27cf94f374f4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1126,6 +1126,23 @@ config SCSI_QLOGIC_1280
 	  To compile this driver as a module, choose M here: the
 	  module will be called qla1280.
 
+config SCSI_QLOGIC_1280_DMA_64BIT_ADDRESSING
+        bool "Enable 64-bit DMA addressing mode"
+        depends on SCSI_QLOGIC_1280
+        default y
+        help
+	  This options enables full 64-bit addressing for Qlogic ISP
+	  chips. 64-bit addressing works on most platforms and is hence
+	  the default. Some platforms like for example the SGI Octace2,
+	  require full 64-bit addressing in order to work and must have
+	  this option enabled.
+
+	  On some systems, like tsunami based Alpha systems, 32-bit
+	  PCI Qlogic SCSI controllers will not work propberly on systems
+	  with more than 2GB RAM installed. If you are on a tsunami
+	  based alpha (like the ES40, DS20) and want to use cards with
+	  the ISP1040/1020 chip, you should say no here.
+
 config SCSI_QLOGICPTI
 	tristate "PTI Qlogic, ISP Driver"
 	depends on SBUS && SCSI
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 6af018f1ca22..d02141157abe 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -371,8 +371,10 @@
 #include "qla1280.h"
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+#ifdef CONFIG_SCSI_QLOGIC_1280_DMA_64BIT_ADDRESSING
 #define QLA_64BIT_PTR	1
 #endif
+#endif
 
 #define NVRAM_DELAY()			udelay(500)	/* 2 microseconds */
 
-- 
2.49.0

