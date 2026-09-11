Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9315B46DFF4
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789117844; cv=none; b=eK7sKjdxNcfrMPgFomt4UPeqp66eam49H+GihjfCM0pKju5rtNxTL2u+IF50OzwOOIvEX/90N/vquoc4axxbOnultcNorr8es5AU3wAuaIi94sDTs0BTMZk1V4Wr8kj2E2Kcvg2JSsmz7QWCPyNR+ybjEFCRErwyicEAFwl7OHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789117844; c=relaxed/simple;
	bh=23ALfxsYvotg77qqOZPp6b9Xvdun1Lsq1RkK9+oYvgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rS0BkL2EZDzR2rybXv5VK5OhtTZCz/mXQnvIxms8wmcn7h/o2FccAEFvyXtYF0AZ+hB3KzsOCSGJ18VnV23O0wH6OJzq6HFbctju8e7uvPltTSMD58FpvheITZ/PMo5pmJmsb9LURoR9edngZXDLHY21DDxDtiZ1GYvCUaDWVV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sY69i9A7; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sY69i9A7"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-86a46577018so933391b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789117835; x=1789722635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R1YKnHoIEP05svull0RsrAl0UwUUE7iMbBjY+AzRpi0=;
        b=sY69i9A7+ZydRZG2a3HThFhSic/f3aX2sykYIiMbd1pC8/qdZuYT1Ubg7XotQ9bnCF
         kOW4PzFzJ9NVx9xW5GglYjA/iGoQguaVsH0n5MJ6BHaxZ5fSlH3zEcKgkV5GtRl6W1Ba
         XMHsJx2HEzwcK9utgzG/MFZspa167a966JXQgLosQ9UpbWUAn0ak4KNKdI+Vvi9cy4xn
         IXjKj23lb9auenJTEmn4Jw6jlOQ2sscWKc5ie9ktaEpJLcdK+djaQR2my4H3NqrtnrxU
         /8fs35k0740xKhCR/MF3GCKaZh+AMSig4TeXp+nfko9f4ngicXHhkoZAlFQ0k9aFGrFB
         /qAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789117835; x=1789722635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R1YKnHoIEP05svull0RsrAl0UwUUE7iMbBjY+AzRpi0=;
        b=KnYO2BpRgLajVsmjReddaBo1HYG3nBnrkXPgSOdn8ah+FvcB7Sd7fWi4xn0o14LfAl
         zSfpeEH1kcB4jg50cpbsbtPLeTBN6GjwTEgNGvprntGMGcD8L0zKE4sQI8PHrVgL8TnP
         5EXlBNV0na82LBQcjC25CFh5lU82AV20bW/Dhj2P8qayc28mxqeTyFKVSN8KwQt3i2WJ
         MuGPAzzagtfDmRs3owlrQ/OW5P8VwMMsmalufrlVKQ7KJxicOsYJuLiCidhn64vo2JfT
         JV+ne7qw3IoVmizX/YmTKFhMj28f1nO6CRyom1+TazRPmEAkOyqZBSbMIdXQao+RSjmv
         YD7Q==
X-Gm-Message-State: AFuF++lBRwDwT9B+c7ZtDX19YNh+fR+DmQgVr7+TTYLSQLDi3Q2INiup
	p+ncWA/hUJqgiXnl4X3D5G4vBTGPgRNtoBxhwsxwUKUU44Xt/id/Dv0u
X-Gm-Gg: AYBFou2PPlgHJoECbIJpLZPeEayl9xEC5lQ8qdq4zZ5VtfS7A2wdWvLi4hMyw9z6zs7
	RJtkDJrStqvCOjrnCP7wYHywUZmP9l0OYyskCESUi+Goxd6MznSEitUqrWWg/dxsdgXGAN3BrGq
	p1HLUD8YHUIGK0xi2CVBDOcMx2wP4IHmM0OW96TlJNG26wiiZ0GR5u9JS8DHEb5GFBa44XtvSnl
	GphrgoNpTHF0vNQhD46fxdWmpFQBIbTVamhWyEE2U0/rTbZtqiX6KPkxKV+6lU+HdqXW93hN/SQ
	0QgVVu3SCB4N+pTuHr+D+6sacpenq+p9Cgbg2jGM1McHDX+gdSaSvvbTVzn+t4YyglZc+EvG8IP
	xxzo9D0QaAtKTmuACTsd2wsGpiSCoXf1uZnQmy5CLkLTBzSFWPghLbc8yKkcfbRWODJFgHR/UYp
	y51x/JXYtO13W2WdgaFWYmDucGmIg4ogPZ5H0gR77afGQw6VI7LVOaRXIWamMJZhHqhBG919d2k
	byt4UMmVX1SGUjwgaOrDmp0cdLGEjpNID2ifl+UQw==
X-Received: by 2002:a05:6a20:9f8b:b0:3d1:9166:5c68 with SMTP id adf61e73a8af0-3daed592b5bmr6489013637.8.1789117835645;
        Fri, 11 Sep 2026 02:10:35 -0700 (PDT)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6572ecasm822522a12.22.2026.09.11.02.10.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 11 Sep 2026 02:10:35 -0700 (PDT)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: jinpu.wang@cloud.ionos.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 2/4] scsi: pm8001: clean up resources on probe failure
Date: Fri, 11 Sep 2026 17:10:09 +0800
Message-ID: <20260911091011.94676-3-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20260911091011.94676-1-flyingpeng@tencent.com>
References: <20260911091011.94676-1-flyingpeng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When pm8001_init_ccb_tag() fails, pm8001_pci_probe() jumps directly to
the final return label. This bypasses teardown of the IRQs, tasklets,
HBA, SCSI host, SAS host data, PCI regions and PCI device.

Route the failure through the normal cleanup chain and reset the chip
before tearing down an initialized controller, including when
scsi_add_host() fails. Also release the separately allocated sas_phy and
sas_port arrays on failures after SAS host preparation.

Keep the earlier preparation-failure path separate because
pm8001_prep_sas_ha_init() already frees those arrays on failure.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 8ede1f1da415..412079b5652c 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1154,7 +1154,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	pm8001_ha = pm8001_pci_alloc(pdev, ent, shost);
 	if (!pm8001_ha) {
 		rc = -ENOMEM;
-		goto err_out_free;
+		goto err_out_free_sas_ha;
 	}
 
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
@@ -1167,7 +1167,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 
 	rc = pm8001_init_ccb_tag(pm8001_ha);
 	if (rc)
-		goto err_out_enable;
+		goto err_out_chip;
 
 
 	PM8001_CHIP_DISP->chip_post_init(pm8001_ha);
@@ -1184,7 +1184,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
-		goto err_out_ha_free;
+		goto err_out_chip;
 
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
 	if (pm8001_ha->chip_id != chip_8001) {
@@ -1216,8 +1216,16 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 
 err_out_shost:
 	scsi_remove_host(pm8001_ha->shost);
+err_out_chip:
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 err_out_ha_free:
+	pm8001_free_irq(pm8001_ha);
+	pm8001_kill_tasklet(pm8001_ha);
 	pm8001_free(pm8001_ha);
+err_out_free_sas_ha:
+	kfree(sha->sas_phy);
+	kfree(sha->sas_port);
 err_out_free:
 	kfree(sha);
 err_out_free_host:
-- 
2.43.7

