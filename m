Received: from mail-pj2-f26.google.com (mail-pj2-f26.google.com [74.125.227.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAC24156C9
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 17:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754325; cv=none; b=LhvV3gZYJYXW27yySom/VTDQUZL8inpBzfx2u2+Sn7op5SQvfZf4+xalOy/GYnfNqbHqRvh0JcHlk9ahT2+IqbYRjZb4zAXdcSqWg03N+8fB/Erg4zJE/Nh75EnDCKyRiklJnl8FwzeIoo0zudSaRXBPcOtKxiZecdy9xgFUEeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754325; c=relaxed/simple;
	bh=+Mg8EFKwkdqT02bF8v5cO7MWrzRs8xUgBeDxWVc0CRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HohIn4Cv7U4hvVhR2vNR6kJBgwTrhCo7Yf/Zvyl29oMWROOpnJq/Gx5emeLp4K/4t1VUIiwtmLL/GJ2cW/z5SsESL4rPfaCw+1RWUoj5jaLFhpftQCgxT49BXVcZWaD2uWoqSO1L0OXjsGy5h+uDT+R6Ly2ot/Hyg8wId9+Vqe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fE1F9aJm; arc=none smtp.client-ip=74.125.227.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fE1F9aJm"
Received: by mail-pj2-f26.google.com with SMTP id d9443c01a7336-2d8fb334e72so10007185ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 10:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754324; x=1790359124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=O/ALC021jyvVUyJohqb4fsm6d/IW7/IWPNFCS11cgBw=;
        b=fE1F9aJmB8BeDwV5Pn8zC+aM1dgaj6b5bMxVYpPhB0FEHMdWHtCbffU748nNFm46nC
         k8p66fUD3uXbQxfBw0N2LEYn9LLVohpTGcdjy137d8r1F+c0dv4UBZBQW/mK2DhwEJyv
         e7EJ8OYZStYQ/a4A+0yQ8i85izNH7t57aWcUPyb99Cv8pszFXkJ6NSMkF4/uMot80sq0
         cQHC0oDa2k8B4pEiaEV9oNQBzqZpQzc+cJ7SfqydecfxNFslaLL2UzjO/10QBKR28ePH
         udYrllwNAt46HSd5PWm/E+OFlpOm1VCNROeQSZ/WCgy1nq5K3mGnXp+64fSoUi3ha5yd
         DnVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754324; x=1790359124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O/ALC021jyvVUyJohqb4fsm6d/IW7/IWPNFCS11cgBw=;
        b=KLbfFupeGptMxxO2w1nuL1nSI4wyoxvdB6cpxK2gyLTNUC1pf8dh5Ad9HUJYBQx3YX
         MbLbP/4tT7OdJ/Li9sEWvrzQaYC8tDo1t0Kcm6xg1VbNv8ilJPC4hS0QE2Fg40a49PM9
         qMBUFmULHe0ZV+SHf7NPF05c37v8EEbFgQgcErJs+ukV5mkmUTwEGZbyU1vxA1z0jQo6
         tmgdJt3F709sWVh6al63iRujakZO9bIeTh8UQnsCUTFtOEKvxlj79QEnKW52czBdvbNr
         2Pa1Q96eO5yiWCbHiKXvuF0B0iEeIuYwdxvf2Lbjnqx5xac5+cFlIoR8hIGcD796fAYL
         3saQ==
X-Forwarded-Encrypted: i=1; AKwUvBzuvjdcgVilH+D5BcTkjbJ5wg7UNOdoAVarFVZtxt75bE/ZacGR1lvEcqqP2BQW4u3hr1pUwO0yXRHV@vger.kernel.org
X-Gm-Message-State: AFuF++l3OySiyqijoWDAjZQ3dsO3VvO9O4EW/rAD9n1Ey4X1tiHa86Ha
	XDCtMECBZsNc2AytWpUPS2KQinovVEPLRQBdE7bbCpi+bBsBRb0sMPAb
X-Gm-Gg: AYBFou0DhZurQDSfQ6bbjK6kRxdAqap7cv/zDpy3ykBw6KURGMrwCCwn/PFhcmELhsX
	JXTV86skaWS6WfXtbeeb/elcM9jzyhM1MOsibvYLJWUH5V63ab5+fi/iKlWGwkmdv9PEXuf+EWt
	+2Xwt9nEFZ15R1a6wiLzAN0kal+ip50GfoBG6tNGP5I8VXPAKTgEF4ZjVzQrECTYZ16mVPbflbk
	QbSJq0wfUdcx2cc88a3n+F5/QvOg6u8F7o/otQ03wsssh+e9ypm92yJOWz6xyvxHem5cKV5pAlQ
	JuxlkN0mTRZXKjVuTFKQqOSl/H2udkroIRH6huCyaHfhLNwQW7Eenhs5jy4AqGCP4hK35RWg6jN
	h3leC8Lg23lWhKrbg/15x+c2kFxDMtkqAdBPNmi06lacWgTg13vraxpdZpjXE6kXlpbPPa7wqbi
	zYjZHaustS0d+nEIFgXOn4sjVe6dW/Y0O+H4OHW6YrQkhsufOnZQDfEg==
X-Received: by 2002:a17:902:d592:b0:2dd:c100:7cb6 with SMTP id d9443c01a7336-2ddc1007d6amr4356465ad.50.1789754323643;
        Fri, 18 Sep 2026 10:58:43 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc16b471fsm682465ad.3.2026.09.18.10.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 10:58:43 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: sun3x_esp: unmap registers on remove
Date: Sat, 19 Sep 2026 01:58:35 +0800
Message-ID: <20260918175835.3622269-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

esp_sun3x_probe() maps both the ESP registers and DMA registers with
ioremap(). The probe failure path unmaps both regions, but the normal
remove path does not perform the corresponding cleanup.

As a result, both MMIO mappings remain allocated after the driver is
removed.

Unmap the DMA and ESP register regions before releasing the SCSI host,
matching the probe error path.

This issue was found by manual code inspection.

Fixes: 0bb67f181834 ("[SCSI] sun3x_esp: convert to esp_scsi")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/sun3x_esp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 365406885b8e..101d3b0f8f2f 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -259,7 +259,8 @@ static void esp_sun3x_remove(struct platform_device *dev)
 	dma_free_coherent(esp->dev, 16,
 			  esp->command_block,
 			  esp->command_block_dma);
-
+	iounmap(esp->dma_regs);
+	iounmap(esp->regs);
 	scsi_host_put(esp->host);
 }
 
-- 
2.43.0

