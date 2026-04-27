Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353CF39A802
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 08:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278317; cv=none; b=IU0U4Wrv0SfimQ9z/2CBfCvenojCgW7LhKnGatPl+o726Oi7VCL6YY2Ps8KmEwAey2+zEPt2cbJhjv3XbqS9WZRr4IdozDWmrONq+kbswjwTFWoBMR2p0QKAc4OtaWQJoVs0j3NuDbNLXq7DTQRuarMJXV+UFWWliRP3nrWCffg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278317; c=relaxed/simple;
	bh=+BrxlxfOQEye4Vs5yOHMMdR6wuvIizqlVvEMpg8Bk6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sIRKNG40ftsZxnK0XCHutAq9pShTCyGhtF2QYoNHpyAGudseKAoYZA/7dl1/QSa06V6Zp5xpwW6CWQQz+jiJmQcwWeoqyQ6RPffk5IY4fOuqdNZLChmmoKq7MGrSK3IEwrYssZcgrIAmWCGI99Dn5WkO+ovHNAKY6whpEyAwDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oO6+L7C1; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oO6+L7C1"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c76c067bc51so3808898a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777278315; x=1777883115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h/eapNxKO0qx5JN/Z8Jc8SYx7RZsmKzmHix+3vMH/gk=;
        b=oO6+L7C1awxsA8pvfcBGfDtHOwXk1XqGHqFwx/Qza/Qp06gqzJw0AwVfPpDaw/d9PO
         OO1ZTLI/O5Il3v0o9RP9/CIm0kcMiDB8x6wrEOIEnlO7esTC7nyUpetFlryB1PiglVkz
         DKS6bC4H0N2P2i5hAcQrpydu4+6cW2HIeC+FjndTxPPPN7i4RRRKZ6+5JVckkdKhivzG
         uQM3cP/tbX/yxemAQLLyQ+YfYbnFTX3A9TFQd2yZLytpCFglXGHP35ldKUCAshqpqX1E
         Hs2V02N1NI/F81cPYI/2xvlzSt0yV/xNeErqjfKrTPsBHql3JlEtTtpHYzbp2aLSTRqS
         3umQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777278315; x=1777883115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/eapNxKO0qx5JN/Z8Jc8SYx7RZsmKzmHix+3vMH/gk=;
        b=HfLBGHajyiAqrYF0hayo2OjbdnM2/0grway1cnSfFjNiw3mZGPmI71855/8U536Vxg
         pGDC6qXCQlll4S/j0c8qAI1G/TZCRRuQ2GaG8VKdlPzMwkX1IYHa1YZTGgMbol4r9XAF
         wI0lIWfNbOGwNUIjruKaDFGNLC79gaYJ95HrJdoxVm63NpIHdtaVoxnXJNzvXzVv76Gl
         d1YFA7Hcmj+0LmhOiWlk/QnXytu3yph81YZAjyOklC5Wt2vpTVRo6SHiaMPNPwDstZh1
         Ok6arqZ22EcQKxQyOHx4r11964WykUMdWj5qXEhdqsWTloOKcbiwXharlTk4BWDoLYAe
         YnxQ==
X-Gm-Message-State: AOJu0Yy/Zt7pEHSzC5t7tihgsPcJLub9kb6K22XteL+PoA24lJET8CUu
	uV6oObCqqW1K6VgKNJmkMaydNQxpxeVX3kXpFoxa2QY5RvJKxQdezAo=
X-Gm-Gg: AeBDietYqoKs0Mib/kvBmPInqxe2vO743Cm7ZUWiHAm8Aeeg0Wm3iwc8o5akAfTmVfK
	eh9LLqhBacF9idvmoDkLGjOOm6ntDsFVVEb24ntNDbwJXRJ8OrjB63yuY99XXn6RZ5Djl1Tu7b5
	FGIdx2OqiICo0CNbePJ4F8KeOGLUAl98jRkPGcdyrbfL8bbL1gJ/oxFHkeI/0XzTp2WRyc6Kb/I
	8eZW5zENLK6bcW9Dy/ExXkh+RVR66BHcVzFZlV1HjsDPPxjTGkUD7gndRyi7ZpXtXqYQsjpnHBB
	L/27T9iKguJ3ixV1UuJxa/YJWJ87jELFqfTemZUUTi5KUaOwEm/ndQmX05eKqr2Q2EsWwAbc32k
	J5rXxDAykEwqEreZjSllZBmJj9y7DVwWvI/ZbbfPY3620qW1ez32WvmJ4zCWGrcc0GNQUtxV8xd
	EJ22fXTynlgzg0JvKIuUx5mCBvwVqGp0YLMWKMf50/mWSNg8A96yUJHZDDfRPNU0HOo5jtPCPGc
	Cxo9bX/l5aPvB7s+HxYlrMetKppNDeShb3H/u83WQg+cYo=
X-Received: by 2002:a05:6a20:72a3:b0:39b:d6e0:2d4 with SMTP id adf61e73a8af0-3a08d8fec06mr50644047637.48.1777278315508;
        Mon, 27 Apr 2026 01:25:15 -0700 (PDT)
Received: from localhost.localdomain ([1.226.165.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797702fbfcsm24036858a12.22.2026.04.27.01.25.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Apr 2026 01:25:15 -0700 (PDT)
From: "=?UTF-8?q?=EB=B0=95=EB=AA=85=ED=9B=88?=" <mhun512@gmail.com>
X-Google-Original-From: =?UTF-8?q?=EB=B0=95=EB=AA=85=ED=9B=88?= <pakmyeonghun@bagmyeonghun-ui-MacBookPro.local>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ijae Kim <ae878000@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH] scsi: pcmcia: sym53c500: Fix probe error cleanup
Date: Mon, 27 Apr 2026 17:24:52 +0900
Message-ID: <20260427082505.57719-1-pakmyeonghun@bagmyeonghun-ui-MacBookPro.local>
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
 drivers/scsi/pcmcia/sym53c500_cs.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 1530c1ad5d..95a001c16a 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -800,12 +800,12 @@ SYM53C500_config(struct pcmcia_device *link)
 err_free_scsi:
 	scsi_host_put(host);
 err_release:
-	release_region(port_base, 0x10);
+	pcmcia_disable_device(link);
 	printk(KERN_INFO "sym53c500_cs: no SCSI devices found\n");
 	return -ENODEV;
 
 failed:
-	SYM53C500_release(link);
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
