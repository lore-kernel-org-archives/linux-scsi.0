Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BD94F93D2
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755218; cv=none; b=pY7SEjWuFzs10qOjTJbpT+EJTeOolklIDlRwF1fOTgl0LY92iw+9XTBhgA0ns9NWDzN/cXmBTAIhykppLLoSgPO7kt7p2ffeOrTnT88W+j5yhw1C7t3S63JnLtt3LR+CNC19aPbDHtrhNmTwb6QhGMO0gLA/b5H8+5fXmJdX2WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755218; c=relaxed/simple;
	bh=jxB51OTaF8ZQDmHlLnMOrVw7Z/Ws4WNrUhbIMMa/FPY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BwwZ0CUlT1rSknCibYfoSzGUMyuPtOMALiUOXIvz5WSl918h3N+aDenFA1iCE5RCduAVZUUXLtuY2BT5nMAjg2DdLKlDn7tB75F+oYrEyuk2JGiNGovw3wSM84ZpDxz4MkKLszfF7VJopcwYpPSfAuKd6Q7BcL042ZU/UWBy2WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M44kfKPW; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M44kfKPW"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747f05ffcso8829115ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 11:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789755216; x=1790360016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=shS485b8tZfkhk79R4MyxZiHCFajwa7fKOgCDdDkLAw=;
        b=M44kfKPWKda/HQ54Lt3AI06EuzRL5MzqGj+Ht2X1/cHXTPkh30UTbI6D7FpYB1tsiO
         244NTerQ1oOA2MYCE8fqDDQ0LPQOCjIxo6a+qEmAsD9HqJSvuY/K1AGPxhOJnFkb9PJk
         mCmWAe6tARA8Js0hFMIelim+afhECSapODYiiZitQF7XqbebCqvF0uBtpCscJ4rLm/EB
         J14zTg6cAJqkmhixjA78k7BHWMiguDofXXh7Xzsmhw5I6jLhjmu3CLf8F78b5J6aOXfl
         feb6JEsF3ZWS7skzm4tpoZTpXqbjr0h/Q5HkeqM2DoqbInHjdPzOI2PjCIsbvTm/sUAT
         94dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789755216; x=1790360016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=shS485b8tZfkhk79R4MyxZiHCFajwa7fKOgCDdDkLAw=;
        b=krQ5Dx+430xzvOw0qDc6JB4t3+BG6inxqTqRqsVvOYdfMJ+ZquPl5VQwwpBDW3iaad
         sXc5B9aQDRSjidHmaIBis4xVprS2JfM0ZAdw+0h2AbJQO9OgDK6WfsKsMUnbhwti++9G
         UMBi7ilV1N4Y9tFxKzE29dRDixTybAEtrzas94fpe/RX+nG3cdr3fcbPIHl7eosrKUeh
         kNqXkYzeZjg48VwRYSgt235m/1ISW7CpuSHjOtGR+diUnahGRXA5x6skbW3NVyosQ2+w
         wWzR37gIFSv3lNACYaz5YxO8Tx9tr5xSTDv4X/yyiJrqdOm5DwwG/H01ghq+ZM4Ry6Po
         sq5Q==
X-Forwarded-Encrypted: i=1; AKwUvBx/IIkCKGLnBQ+HUWuc4ZsPQkcfetzEWDXypcFHipzOjSqi/KPWDRQU3Yi3LJFiNgokL29z6kIU2QPp@vger.kernel.org
X-Gm-Message-State: AFuF++kfTU70OVsew2WMjPJYO4Oc93TNEheyRE8g98ovem+AXbyXtfm7
	phzby4A8zoxLMmRikdq0AniJ9ex+FYqWuZAmsD94yAM6SSdP/i+GDBXF
X-Gm-Gg: AYBFou2PWIvCWRalehCNy7jgc1P33FIUH+RPL8Y6NN07ThR2nnOud7jeOSXoaItGoDD
	F7VQrc4+Dj4bJaH674CY3abs4Ns/RzY4btcCCQr+PnkIf8bAh8eNrbmeBMxrlL9k9SgCz6mQsHI
	wBtAfFE9/xpXAGoGi7G+/CZwgRMZ+dMB+mpNntzZtGzl5qLb2DVoyFRMyvB24G4na0vV7QA7KDy
	ZTyV91aEpAOIkstPLdqGlBWDvi/lRBUL5mxWh4XKPLOBal+YpRDq3wpaNw/6r52Lb1+PVNLWk92
	EzIhPSgB/+KrA/RDzbg/3o3xddca5qVBOSHj3NKJBUcf5kOXSPKj3R0rzSrJq4B35hqLgvzyNPK
	9NG2ipyQM72Qspi/m74oF/mBIrJrLVn/3pQ6pJAyLfy5hLLey2mS3Q9HIL0Nr0z8JnDDLcU/Awr
	XNIRI59/H7iaU/Yl+qB5vWvTAcV+IOA2eD56Pf0UZQWRIfx7md1qKJmPEefXeRoP2r
X-Received: by 2002:a17:902:e751:b0:2c8:2808:3ec9 with SMTP id d9443c01a7336-2ddb1ae69b7mr68800035ad.12.1789755215937;
        Fri, 18 Sep 2026 11:13:35 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc1788bcasm662465ad.21.2026.09.18.11.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:13:35 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Daniel Wagner <dwagner@suse.de>,
	Hannes Reinecke <hare@suse.de>,
	James Smart <jsmart2021@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] scsi: efct: clear MWI on remove
Date: Sat, 19 Sep 2026 02:13:26 +0800
Message-ID: <20260918181326.3633765-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

efct_pci_probe() enables PCI Memory-Write-Invalidate with pci_set_mwi().
The probe failure path clears this state with pci_clear_mwi(), but the
normal remove path does not perform the corresponding cleanup.

pci_disable_device() only disables PCI bus mastering and does not clear
the PCI_COMMAND_INVALIDATE bit. As a result, the MWI configuration can
remain enabled after the driver is removed.

Call pci_clear_mwi() in efct_pci_remove(), matching the probe error
path.

This issue was found by manual code inspection.

Fixes: 4df84e8466242 ("scsi: elx: efct: Driver initialization routines")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/elx/efct/efct_driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 07c2f453459e..720bad7b3517 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -613,6 +613,7 @@ efct_pci_remove(struct pci_dev *pdev)
 
 	pci_release_regions(pdev);
 
+	pci_clear_mwi(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.43.0

