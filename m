Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66065320CAD
	for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2026 08:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777363375; cv=none; b=fxmE5dCimw6k8u8v7E+Zsbb/ZdJTSmJ1oy4Rae56K5QI7dKyBlS+s2AhMKtyBb1lT7kouXIpxygN/lWZOTNFdvPucAbm4oehSk2ldWZqUmNvvRiJh3nZiQ9DiqUGOFPtjW588oE6cZpLB9PTLVp7Xefk/F6TVB6JD4D45Wu7slo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777363375; c=relaxed/simple;
	bh=JY4+az23NLVkJxSPmQ4N8VCU4QfbBXdSOtko8CBjPXg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u6jvHXTqX+Pc4Ezk8Vs/9ivlIu0x7LI94Zati06ag3LZ5v/aYLE4cI5DJ8ZlhWa/QxeYtw4wAJCFHabi1xAgpj4F+V6tGeeZvSsrgHDV305XJyTINM7XI3f9pAHYfgMvazHaYjWNDutI5ZkP9Nh6N7mRXfXQ+shrjoBwOJ7KeGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lfhclOQO; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lfhclOQO"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so7633750a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2026 01:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777363374; x=1777968174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wh7HcfQ2a4z6YZXbRcuBA6egqAfxDuTb+4ocYPWlJts=;
        b=lfhclOQOJ58Jn5ftxv0bgSqFzWI5kd7Pzf/v3SouN8ucxFnPIClL7uZnECrH9DmZCi
         kNBAoH4F2em7sizmKfj+ksZBOKWTo3FxV2XYXwDgHLN0KygU2hLdP4Q+q7Eon4X8+lmy
         1jSTcqa1PZ61113RZsJB6+lkmyUV6/PkCcDKpAay0eCUgpduodo+wyeJ+AuWuBqRZ9G0
         soEiM1lufEd6H17xK8a2mQDGk2z6jNg9Vvets28F3xveeobKpgzDtxFudDJOJbCkkIsl
         7mtS7Vu9TvQB1Ic7TDaCKqh1XnkDBUS4+dRUQvtE+IDVlv/3Uhtg7LXNM4+I3QT7V3MM
         rELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777363374; x=1777968174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wh7HcfQ2a4z6YZXbRcuBA6egqAfxDuTb+4ocYPWlJts=;
        b=C2pybXoAKwyfKzVnuz2OQe/HbYEicxAZ8muAwbXrICAEZUgxPWclM6TaAD+oRLO6s3
         HzIZDgc52bZ1kAHfIUTHBsG2vm/R+LYyEWZDaBNVfsVG9gD8sDF8b5WSnCt9upKvVXD4
         WE9hhWiQDPtvwd4MdL1QLtRB0PZb4CK3tCzt44202DpgrNHJjyfEAw1CRCEVXs1Qmq4D
         pZpi/hi1pLYTmcEw1Y/UEGvUxN8wjJvT5HAtLDzb58O6yu7fwnI7jVGxVpanHVdPjbAq
         VQq68fvcdw1EKdsyUz8IPVyA5hYSO3Q7Oe6fjeW8yNOaTU3pNQKCDde8TPL4luNNaq/e
         egnA==
X-Gm-Message-State: AOJu0YyGUvfpp/7k5Zp46AMnbAveWmRNn091xIcpS1Hax171FxW2s1TA
	5K7JlHYq5nE8UXRorv0PCsRQkKJVUXX1xa8I//Z0C6zXnWMbQ7MkxF5V0E6hmcf7pA==
X-Gm-Gg: AeBDiets5RQrfZE0t7Da/JckYmEFvth8Tt29edNKWUfXUXnjZQoU6Aa329HTfhMTy0N
	+0bhC7lD6KvrEw75AbdMrXH4zqGotQ9JwT55QqfEEVGTAu2L3+xpqGqWpDSptPb50ZnYkSXZb6r
	DMYzTuvoPjtZfs1cqzlSikKcUbOGgqnU21lW3pOwZerxtih20tmRYRuKmAjsnzhk08H85TEMEXN
	tHC2mcV2ngWkLCOLc3OVmhoqE3V5ZYfRJmHe7aBCpKroCxCRLL6ySAA8y/7KtIkWU7AzEsa/YnT
	/IFpEDZOegfGKuUcpV6+q2mRa3jaTBYJi2I+FLlbdJChX6loZldUTrytndTRgeUzSy0ohWHS2Zs
	v3SrLgWFNkQLJW6yYvUh77Cpxe/NztZLWsYF+iKSPP0PRL0vpDgMnxZ41FC49UGjm7KSbBrXXhm
	ivOnrIBqhz7/pQ1xV4hBlQYgQBGUNMP2V7zhAq3OECZ9kX7zCKJJQR9jwyDny/iCFuNS6JuuXQV
	Y+8+9AdpCwGw1P6nYJoc9Y4Oo1pT3zaHTIaLeqdqsxPXn4=
X-Received: by 2002:a17:90b:1802:b0:359:15c8:e8e1 with SMTP id 98e67ed59e1d1-36492078018mr2142216a91.25.1777363373488;
        Tue, 28 Apr 2026 01:02:53 -0700 (PDT)
Received: from localhost.localdomain ([1.226.165.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36490fd57dasm1876283a91.17.2026.04.28.01.02.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Apr 2026 01:02:52 -0700 (PDT)
From: "=?UTF-8?q?=EB=B0=95=EB=AA=85=ED=9B=88?=" <mhun512@gmail.com>
X-Google-Original-From: =?UTF-8?q?=EB=B0=95=EB=AA=85=ED=9B=88?= <pakmyeonghun@bagmyeonghun-ui-MacBookPro.local>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ijae Kim <ae878000@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH v2] scsi: pcmcia: sym53c500: Fix probe error cleanup
Date: Tue, 28 Apr 2026 17:02:45 +0900
Message-ID: <20260428080247.96624-1-pakmyeonghun@bagmyeonghun-ui-MacBookPro.local>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Myeonghun Pak <mhun512@gmail.com>

SYM53C500_config() calls SYM53C500_release() from its early failure
path even though those failures can happen before a SCSI host has been
allocated and stored in link->priv. SYM53C500_release() unconditionally
dereferences info->host and then tears down a fully registered host, so
the probe error path can dereference a NULL host instead of unwinding only
the resources acquired so far.

Use pcmcia_disable_device() on configuration failures and let
SYM53C500_probe() free the per-device allocation when configuration
fails, because the driver's remove callback is not called after a failed
probe.

Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
Changes in v2:
- Centralize SYM53C500_config() failure exits to avoid duplicate
  pcmcia_disable_device() cleanup.

 drivers/scsi/pcmcia/sym53c500_cs.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 1530c1ad5d..88e8b20c37 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -711,14 +711,14 @@ SYM53C500_config(struct pcmcia_device *link)
 
 	ret = pcmcia_loop_config(link, SYM53C500_config_check, NULL);
 	if (ret)
-		goto failed;
+		goto err_disable;
 
 	if (!link->irq)
-		goto failed;
+		goto err_disable;
 
 	ret = pcmcia_enable_device(link);
 	if (ret)
-		goto failed;
+		goto err_disable;
 
 	/*
 	*  That's the trouble with copying liberally from another driver.
@@ -763,7 +763,7 @@ SYM53C500_config(struct pcmcia_device *link)
 	host = scsi_host_alloc(tpnt, sizeof(struct sym53c500_data));
 	if (!host) {
 		printk("SYM53C500: Unable to register host, giving up.\n");
-		goto err_release;
+		goto err_no_devices;
 	}
 
 	data = (struct sym53c500_data *)host->hostdata;
@@ -800,12 +800,9 @@ SYM53C500_config(struct pcmcia_device *link)
 err_free_scsi:
 	scsi_host_put(host);
-err_release:
-	release_region(port_base, 0x10);
+err_no_devices:
 	printk(KERN_INFO "sym53c500_cs: no SCSI devices found\n");
-	return -ENODEV;
-
-failed:
-	SYM53C500_release(link);
+err_disable:
+	pcmcia_disable_device(link);
 	return -ENODEV;
 } /* SYM53C500_config */
 
@@ -845,6 +845,7 @@ static int
 SYM53C500_probe(struct pcmcia_device *link)
 {
 	struct scsi_info_t *info;
+	int ret;
 
 	dev_dbg(&link->dev, "SYM53C500_attach()\n");
 
@@ -856,7 +857,13 @@ SYM53C500_probe(struct pcmcia_device *link)
 	link->priv = info;
 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
 
-	return SYM53C500_config(link);
+	ret = SYM53C500_config(link);
+	if (ret) {
+		kfree(info);
+		link->priv = NULL;
+	}
+
+	return ret;
 } /* SYM53C500_attach */
 
 MODULE_AUTHOR("Bob Tracy <rct@frus.com>");
