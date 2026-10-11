Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D7328506C
	for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 19:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791746366; cv=none; b=S4NA+PbbhXo+Yk5kyNjkmmSNmSlD0Y4OyOkKjuW/xmhMmJOY09O+ZZJiGIjc6MUwL5kc9TyQ496lJ9BCYdcQIMVtpg2flgpMQpYt8R+zhlYK7t+pSMUk+S52+96j5FkaN6YmV5mdZAaU3vm1w1u7E+WDJC3bTp5z8ZZYFEguOOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791746366; c=relaxed/simple;
	bh=VqxDzcKZMb5h334yyHNngEjkgtJNHdQqm5vg6Sp8+/s=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=fUSkOuEpJtI0+qB2rTgdDgvG2M8qzaba+H9wCWzN1RPq7l3+CLdrdiMmz0mzAl8GsVX+2oxNGiXNP7QSCNeG9ZSv5jaS+ohDaG9+NoXOUkR+9eXnPGIuV08Yj+tzG14AyuYcjtykWe9gg8P9i7p3vp+S0J3ncZInp1K/4S3/mPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eI9UCYpI; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eI9UCYpI"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5338c1197easo10097121cf.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 12:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791746364; x=1792351164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VgfbC/HOVtS6a+9bSQWui2w97m/YLrLLlAJbhXILz50=;
        b=eI9UCYpIMUhrBkea7bFT2uDydZMLO/qeSgltHQMJDr+Xtwszxjh5/EDDWSfV3f0ne7
         /Hjqb8yr7O/xRFmmPVcZIoM+SnZFO1oSHuPTVfAr9K15fsi9grU2yFUh3rqDJcQNUZuf
         1RGL5l6A4SzmCTqLdam0qPQTBl7B/whJOGstZBDm8uVwOarUpUH4OQkPveeLfJZSu+ZZ
         hN2/I2Nt+QAPCRu1MEzSyaOlcj7+DS3q24gMyXHnnfYHsdIo+zF23CEyEKPNOiVHGML4
         kz17sOMU1uktTd47UQOnbt3UQ2MFLJgjsBZlDsejg9A+CwVg7A9HM6f5bE8po3Ym2Ak5
         zpKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791746364; x=1792351164;
        h=content-transfer-encoding:mime-version:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VgfbC/HOVtS6a+9bSQWui2w97m/YLrLLlAJbhXILz50=;
        b=cwTAdadCY8T0xyriMUPvALuJ2Krf4Bv5SxLL3ktGya0qLaoyDYl0LNxgnQams5PTV6
         KX6gLuyj3gyoeTIUb6QSTA374kjZElhJdQuTecstXk/RYm1qqp7fVgoyEyRR5Bz38IJD
         8+JjZNT+6WDfbbvf6cM0ccysNs30M9dqw5BU+ff8RT3hSpT/bCfb1BNSGGQkA0tUiLT4
         rutQPbogqCv9/49oYjlfr/tBZN44u5lxsyt9hcQykQkHD5kvkki3fIByQMFJt/LSKdGw
         lVIb41NtK0nI/TB1PTqNcwjO/BZBt+vTfU8fX0l5+rDvjBGMppaqfr+MWrjpLWAJbVe5
         hAdQ==
X-Gm-Message-State: AFq9FYLE8/deQ3Dn/aVoaMxkWol8bRK2G8YsaF2z/QjRW15EHRg28r70
	2wVx0YcZpc7F3Kuhseuvr6IDjDwt54rY6TV9BitoTPrdJCqLhb/RnHM=
X-Gm-Gg: AYBFou2nL9oNsPMnd1TB6TR5l6bjxJLg0Z/4b91nsW6U05j2Bf/AWsUJF9zDzGqR8mW
	P2tbZtmMi3rSBGi0Pt+MKPKR9i+LTp593Ne9EQ7vIb49KHdhuoDllbCveF2JkZ8yFxMF6CM5ek4
	CJCulWmEUYrOMBRIeQcGKh8pHoij0Z0Zn9u2tSGunXAVxW004Gxd9+jXiH1pxa2+InHpaVkmJ3U
	3bauTDYJClZkSXPZK9BmEUEle/Yl+VVbBGB2mvi98hI9aS0eHWtPvKRZtVl71zNcaJqZxeOCFKp
	6KsqV/Yf/9uqqHIZmnvFXFTqxa3gvYq6NjEs0AxeNYQzw0iWtSyxhWW2sAiIkMN9+8dHT5bvE3p
	tBjfM+MwVHHWl1KU8itJtoLDmFA6QgAkvSGET0hm69SWq7hc9qVYsBojUFYljhRMrfWvKoOwk0O
	PThuklbPjxTY13i2XMyHysutAhWe5491nfvRqdCKMnEEDRrmEY5m9DCIrTaOQyaXE1kOI8i39iY
	QH1s9Lnwc4yrMQqYIKzWQlltA9sV/ZD65G1bq20haW+iCGNF0UDcjWuZEOqRIUKMlsWtnYybN5n
	FmGn7A==
X-Received: by 2002:a05:622a:5599:b0:535:a5fa:ee03 with SMTP id d75a77b69052e-535d8719261mr6459461cf.67.1791746363958;
        Sun, 11 Oct 2026 12:19:23 -0700 (PDT)
Received: from gmail.com ([130.203.156.90])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b54e832edsm77213176d6.4.2026.10.11.12.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 12:19:22 -0700 (PDT)
From: Myeonghun Pak <mhun512@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ae878000@gmail.com,
	moonafterrain@outlook.com
Subject: [PATCH] scsi: aic94xx: Free the IRQ before killing the completion tasklet
Date: Sun, 11 Oct 2026 15:19:18 -0400
Message-ID: <20261011151621.b9b17c998453-1-mhun512@gmail.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Masking the adapter interrupt does not wait for an interrupt handler
that is already running. Such a handler can schedule dl_tasklet after
tasklet_kill() returns in asd_pci_remove(), leaving the tasklet pending
when the adapter state and done list are freed.

Move free_irq() ahead of tasklet_kill() so the last possible producer is
joined first. Apply the same ordering to probe failures after interrupts
have been enabled; those paths currently never drain dl_tasklet.

This completes the removal ordering added by commit f6ab594672d4 ("scsi:
aic94xx: fix use-after-free in device removal path").

This issue was found by static analysis.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
Compile-tested with GCC, W=1 (arm). No runtime testing.

 drivers/scsi/aic94xx/aic94xx_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 4400a36..89e584c 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -810,6 +810,7 @@ static int asd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 Err_escbs:
 	asd_disable_ints(asd_ha);
 	free_irq(dev->irq, asd_ha);
+	tasklet_kill(&asd_ha->seq.dl_tasklet);
 Err_irq:
 	if (use_msi)
 		pci_disable_msi(dev);
@@ -881,6 +882,7 @@ static void asd_pci_remove(struct pci_dev *dev)
 	asd_unregister_sas_ha(asd_ha);
 
 	asd_disable_ints(asd_ha);
+	free_irq(dev->irq, asd_ha);
 
 	/* Ensure all scheduled tasklets complete before freeing resources */
 	tasklet_kill(&asd_ha->seq.dl_tasklet);
@@ -889,7 +891,6 @@ static void asd_pci_remove(struct pci_dev *dev)
 
 	/* XXX more here as needed */
 
-	free_irq(dev->irq, asd_ha);
 	if (use_msi)
 		pci_disable_msi(asd_ha->pcidev);
 	asd_turn_off_leds(asd_ha);
