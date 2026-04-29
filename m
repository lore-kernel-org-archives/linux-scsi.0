Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146853806C2
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2026 07:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777449398; cv=none; b=UmHdbjt6viQjyPf7T+sJO5PfHyi8GA7bPSyBZROxjyZroQ37axy9oYQIKFKsppL7KZajiG0i0a/yym3WAZKhsUYl5UaJxu3yzO8m1vyLg5NWfvy4VxtYouSCXu2sNhjtU/SDFrP4jiTPIX15RHwXcO0TeG8f9VaaEJmY4p4hFcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777449398; c=relaxed/simple;
	bh=pIrUuL+96vJYF6yhVyvt5jtcIsO1C6frn/CdJhPSmHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H+TEl+TLAL/Cg+/OlWIqFggwkxsz83FfyBqy2nt10+IXIQBMu2ZW+tGom4/Pg+A+1p2pxV6bRV3h3n2SMY70QedqHMOgLbjwvOiCfdsXf74rJdargVsDk0HPB/8IlUP1FYToiIof9HUObn6OuNLzrCoSeHDsRUjCiKaR9qKW0cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r6+ApggW; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r6+ApggW"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8318293f02bso319779b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2026 00:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777449396; x=1778054196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=seQxEAimef50aZBkMmV2G/WoxYi0qRD0xuspz2Lt/Ks=;
        b=r6+ApggWjBwazWf5HbM8DgrR6i4RsOElye2hSfiaREn6spblFzzFjbnK9wq/U2Wu6X
         4HD86AHdPhJkIVf+8eBTWTk24ii7J/XxfaVjEphgvDhDKRrOz6HAMA6Ns7bxaIC1MHlb
         9/I+nnoJwh1OOu+yvIUKKYACuka+cbtSLagRTj8Xgvn5J/XQV3pXJpS70nxRSUa64JUl
         VZLEsCwasN8w7OWrRZwSpeN1OHzCZdWOwT7NHgfM0dhTK+eunSyICgbEjB7cmI2V8LjG
         EYuPQ8KRRLxk/Tmg+7baUkgnLhICQioZc99QJe0azZoT7gq4G/otCV3Kff+19JwpAnjr
         yTpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777449396; x=1778054196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=seQxEAimef50aZBkMmV2G/WoxYi0qRD0xuspz2Lt/Ks=;
        b=Cm+sKudb6yAXJX3qv7pua+8LVmBkAuRkdEVaj0n5PNzu0g2Tx1X9Mpuec5OIL0uLpG
         NJc9y/EP36HJWaVr/yKx2DyTH9pZ00LHL7WiFLaR130Bqitu/rF7LaPNVM6YjBwxM2x0
         7KVfzNkwDWmo2D5d8d6SEiRsxhdoIax3JADOzmKRrKdK8k7KqPPEXmVeoF1pfqUPty5i
         MzP9VENlNmKKp8J9603Q2wkJfyOsK4uVV6pTyYKVShNypVEoSxE1mS1ZFRaIVCC14idT
         NXCqVv7Ykv8tl4EeLigMUurou33pmWv7t8FFqoV3QUFuRX10DNjcdLFBdZURObo+Uo/y
         2dKQ==
X-Forwarded-Encrypted: i=1; AFNElJ9iTWcNaslQz1f8/R89WJQshNdcwBvzNry5N/6EYK/YNLNSfzj/K2QAPSXvijBIEuHKshbg6XqT5iP2@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq9ciP6rm8pd7Vj9S5cmDja3iH7p1bLf+N3ZLveb5Q3u5o0plY
	CRhg5Uk8c7WGoE7sv6qBe5f8e5cwIwQbEyBvArSpwWOkZVl18qeAjDI=
X-Gm-Gg: AeBDiesifN/KRXTnhzvp74FeTdBYCE3YR3iGYRtut0Oar0wztzA4CFP+zadudGRtSyr
	svvB9ef1lW5BV5sXQVdkybf+umsdoiVx7JZnWgd5oTsCohIQGXsNS1FbTvI6bT9XeJcGCTcDU1I
	XaZ3zhWHDNjM9HAYGOJb47ZLUunRqmAQzhvbFvbBhoHS1dg96R9DVlFO6gn3mEPpc8V7jhwKON5
	AHkjB4odv3E3IrkKNDjaSZeP4WNnvLb5v5XAk0tLenZ+ztvLW16Rnwph05exbQmtEexqRksW1bP
	VjuYGP1rdR4TL3I0dIU7sz37faqU3cEF73jImT7XWoknOlFszFV0xowzbwRH5IXJrxT5LRJv+tU
	/7DauijNTRr2aaTjJCmAcFFudbEpszrXE/GRWQ0dBvx4H7eAj35YG5vzIjIEgyATze7wxnuqDct
	Fz7WOJtpCpUXSiTYtDWrDW/uXIgTRp73clpSh82C1J+yJW9y9Ga6/S1vISbGraYeWk2pEz4NQAI
	BBXQ0280Y4//bc0Y5TeHwrvs6/FpFRwtbGoWM5+6sxmaGwY596+HhM=
X-Received: by 2002:a05:6a00:4fd4:b0:82f:6de5:90e1 with SMTP id d2e1a72fcca58-834ebcb5638mr1954108b3a.24.1777449396342;
        Wed, 29 Apr 2026 00:56:36 -0700 (PDT)
Received: from localhost.localdomain ([211.198.234.66])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed5a1ca9sm1195563b3a.6.2026.04.29.00.56.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Apr 2026 00:56:35 -0700 (PDT)
From: "=?UTF-8?q?=EB=B0=95=EB=AA=85=ED=9B=88?=" <mhun512@gmail.com>
X-Google-Original-From: =?UTF-8?q?=EB=B0=95=EB=AA=85=ED=9B=88?= <pakmyeonghun@bagmyeonghun-ui-MacBookPro.local>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc:  Markus Elfring <Markus.Elfring@web.de>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH v3] scsi: pcmcia: sym53c500: Fix probe error cleanup
Date: Wed, 29 Apr 2026 16:56:18 +0900
Message-ID: <20260429075626.92421-1-pakmyeonghun@bagmyeonghun-ui-MacBookPro.local>
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
Changes in v3:
- Add Markus Elfring to Cc.

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
