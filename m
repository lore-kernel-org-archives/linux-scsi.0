Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CDE23AE87
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 12:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780144248; cv=none; b=qYvLUdnhWvV139p7DlGr7hb8v9OqC/Jypob/xDwXH7bW3sJy55Hi5MF2JF+JdCN3kKP8lGU+zsSzN2+To9PpLojYIFgYFYx95/ExJo1Q43YmsLYUIEynbT4s2AAW3b3BD8NmhDwwmdQ9l1m+ODsO4Vmi3FvFmqTDJMaO/Bxrk8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780144248; c=relaxed/simple;
	bh=JOkh0VtUTMNM8R2U5kHd24sbbewIR96ibV2lt7jrRmc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=jjFXBarKslyaAsdwRs83w6VCIxYHvlPpDCAKgt/AiMzmBOwGFzEgaeR71N/8qfvSPvaMSn8e8Tdf3F6OYzzxdIdDuEkWg2G31OpvqHG97Pz4XihiqOc3E41LuuwLAWw8D98nBcHTzuGqahyxjaiBw5VTTOGz5cSYAyVAMm/9qZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CROhc5P9; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CROhc5P9"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490388fd0dbso90732255e9.0
        for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 05:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780144245; x=1780749045; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3IrPF7Yf2T/CTW8tuqL+BCfM7WayAgdlVua5IFI5JOo=;
        b=CROhc5P9gSarVcjI0y7/5wwK8cDGEb4HJaEHXWxFlJMsU47xBBcFsFOwrqGJSPUBc4
         qcz46E8BAcyKvHn/L/EwIe34f/xY/PW/F6d5ktW86ATKoAKdBWGYeGv3wOqvFjPZzEv5
         V+Pv90wPLcexY2hnKCNpGbAn1kQwEbMAM+VK7rFHVXiO6oP3dMpM/xXMDc/htVOt40mc
         L9uUMJdoR1bTv1gSsHji3SoqbKLiq88VZXjGzzi+lSMcn+yP3dCwypZFePwJIQF71EgG
         zEo42OGCqxWTFhPBzy0l7S5RyEZx14R/ZhxY5spcX+NgUDaf4saJKXRT9cyOc4UzDFp3
         SJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780144245; x=1780749045;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3IrPF7Yf2T/CTW8tuqL+BCfM7WayAgdlVua5IFI5JOo=;
        b=EInuJ9PHGrXpSsm1Bjer/qGLO5DPQIE/BUfi9n1aviSusl13pLPn69w9hiRp55enX5
         rNHBaAYReD6oZttivtxfH0zCEPmgaCH/eR5Hsn82kkDABAw90sqhwXozke2X6QrO/cLX
         YUigO2vl0f1ZLxBk/0haqTwrO9TRzE7m8bkI0n5vrSMqhrbIgZjF4W9HQbkAjq2jCgIN
         +EKtrdORmt849A8Cu6tw7Sl/bnnTxIVZ/n0qWjZPF9S0b81vQYtPLQECh9RqjwqIAr2u
         HLjMVU/fuN8vSzoCpqtf7y0HoJr1w3k2Xwj6Q+i4V3Gf3kRujgIzwPn3yf5RVgXrlsl/
         WlIw==
X-Forwarded-Encrypted: i=1; AFNElJ9d8BLtktULptpixyIFsnBqaNydzaGz25grL9W1ypfKOrKVeH56pH+YvsCYI9u7aaWwKNkONawHcOxg@vger.kernel.org
X-Gm-Message-State: AOJu0YyixYaROFo4l/efSjwk6hs9Z+Qp5tGATAJvHKhaJMYTYSv7WqKA
	eIkBc1bQSTPZyNLTyoZarzM9d5dRFR95QvqziEhBXlGj/JZ8U0+aZSKL
X-Gm-Gg: Acq92OG4IoIFQ7ANuR3uifOBsd1gxio1627i9v1u294oTdR7gIIQU1HYvfp770DO3Y8
	EBbNOjVMpsN6xGQ7cdYxVbcuPg7xGumJpmrK+cx9EOnaZGa4KQTttWrNFxx8luNYFeF+fMq6hrx
	Xxwms8gV1QTPHyfmsZw3BoMrH1xV1vowH9V9zZNlwIv/g8bqOW8AKBRXti9/DpnTyFyN5YBjtQ3
	Tvk27EpPYW8GEXw5vMXhdtRMqK8YrBvW0M2HTMmEwDMIDkB8v6+LHuu9OhJ6VWaPrKEvHp5N7Uc
	fsUhQ9cxwMVL6bSd9gZixhaQVijE8kc+50ZrS5/5Nk+NJ4mUC7hihr0Wkp2SUiSAlchG0nzbmJt
	WBCTZzW5rE5D17nkZ7w9x3foUfiPEryhI5SH1IKp8gW+bavj3urIeV1NNvlCEvFjKgHMqhVyjRo
	ybRSKupcG07lUveXrr31AEDc4yXcx4qNwl+PdutHzlE64=
X-Received: by 2002:a05:600d:6413:20b0:490:890a:da46 with SMTP id 5b1f17b1804b1-490a292a4b7mr46598725e9.2.1780144244852;
        Sat, 30 May 2026 05:30:44 -0700 (PDT)
Received: from localhost ([94.53.77.213])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c0c39b0sm55179475e9.2.2026.05.30.05.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 05:30:44 -0700 (PDT)
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Sat, 30 May 2026 15:31:22 +0300
Subject: [PATCH] scsi: core: Remove dead code export of
 scsi_device_from_queue
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260530-remove-pktcdvd-references-v1-1-aa56941d4315@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMUQrCMBCE4auUfTYQUxLQq4gPNTvqKqYl2wah9
 O6u+vgxzL+SogqUjt1KFU1UxmLY7zrK96Hc4ITNFHxIPvbeVbzGBjc958yNjVdUlAx1B4459Sk
 MkUH2n2yT9699Ov+ty+WBPH+DtG0fGfyzFH0AAAA=
X-Change-ID: 20260530-remove-pktcdvd-references-9d5c6362a5de
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Jens Axboe <axboe@kernel.dk>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, 
 Catalin Iacob <iacobcatalin@gmail.com>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7848;
 i=iacobcatalin@gmail.com; h=from:subject:message-id;
 bh=JOkh0VtUTMNM8R2U5kHd24sbbewIR96ibV2lt7jrRmc=;
 b=owGbwMvMwCX261qtXAKXKjvjabUkhiypG6sLntvMDjCYxBM9Lyi3xOfHzogig8LdgutDb9Vf0
 nRRlLnQUcrCIMbFICumyPLi3PW2DXvOBNxLsmuBmcPKBDKEgYtTACbC8Ybhr9zTN/w1LhaSHd1W
 e+UXcJ5zF266PE9izuRDc7y1I/YvnsnIcOoo/36rKsWFmo9C9/zP2M3LESaWvmyasflW7+qD6iy
 bWQA=
X-Developer-Key: i=iacobcatalin@gmail.com; a=openpgp;
 fpr=F609BFABD84EB5C9DDDC37EDE89C6A3571CD0E33

Commit 1cea5180f2f8 ("block: remove pktcdvd driver") left behind some
CONFIG_CONFIG_CDROM_PKTCDVD* references in defconfigs and around an
export. Remove them.

Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
---
Found this incidentally while looking at kernel sources to understand
what pktcdvd is
---
 arch/mips/configs/fuloong2e_defconfig    | 1 -
 arch/mips/configs/ip22_defconfig         | 1 -
 arch/mips/configs/ip27_defconfig         | 1 -
 arch/mips/configs/ip30_defconfig         | 1 -
 arch/mips/configs/jazz_defconfig         | 1 -
 arch/mips/configs/malta_defconfig        | 1 -
 arch/mips/configs/malta_kvm_defconfig    | 1 -
 arch/mips/configs/maltaup_xpa_defconfig  | 1 -
 arch/mips/configs/rm200_defconfig        | 1 -
 arch/mips/configs/sb1250_swarm_defconfig | 1 -
 arch/powerpc/configs/g5_defconfig        | 1 -
 arch/powerpc/configs/ppc6xx_defconfig    | 1 -
 arch/sh/configs/sh2007_defconfig         | 1 -
 arch/sparc/configs/sparc64_defconfig     | 2 --
 drivers/scsi/scsi_lib.c                  | 8 --------
 15 files changed, 23 deletions(-)

diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index b6fe3c962464..840130a73992 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -89,7 +89,6 @@ CONFIG_MTD_CFI_STAA=m
 CONFIG_MTD_PHYSMAP=m
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=m
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
index e123848f94ab..61f09cc9ac12 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -177,7 +177,6 @@ CONFIG_NET_ACT_SIMP=m
 CONFIG_NET_ACT_SKBEDIT=m
 CONFIG_RFKILL=m
 CONFIG_CONNECTOR=m
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index fea0ccee6948..60da9cf71b72 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -83,7 +83,6 @@ CONFIG_CFG80211=m
 CONFIG_MAC80211=m
 CONFIG_RFKILL=m
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/mips/configs/ip30_defconfig b/arch/mips/configs/ip30_defconfig
index 718f3060d9fa..5c2911ff9a87 100644
--- a/arch/mips/configs/ip30_defconfig
+++ b/arch/mips/configs/ip30_defconfig
@@ -77,7 +77,6 @@ CONFIG_NET_ACT_PEDIT=m
 CONFIG_NET_ACT_SKBEDIT=m
 # CONFIG_VGA_ARB is not set
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index a790c2610fd3..dd3486b8d1fc 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -33,7 +33,6 @@ CONFIG_BLK_DEV_FD=m
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 81704ec67f09..b10dac71f400 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -224,7 +224,6 @@ CONFIG_BLK_DEV_FD=m
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/mips/configs/malta_kvm_defconfig b/arch/mips/configs/malta_kvm_defconfig
index 82a97f58bce1..bdd5d99884e3 100644
--- a/arch/mips/configs/malta_kvm_defconfig
+++ b/arch/mips/configs/malta_kvm_defconfig
@@ -228,7 +228,6 @@ CONFIG_BLK_DEV_FD=m
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/mips/configs/maltaup_xpa_defconfig b/arch/mips/configs/maltaup_xpa_defconfig
index 0f9ef20744f9..523c0ff329ac 100644
--- a/arch/mips/configs/maltaup_xpa_defconfig
+++ b/arch/mips/configs/maltaup_xpa_defconfig
@@ -226,7 +226,6 @@ CONFIG_BLK_DEV_FD=m
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index ad9fbd0cbb38..60054e54bc5a 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -177,7 +177,6 @@ CONFIG_PARIDE_ON26=m
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
diff --git a/arch/mips/configs/sb1250_swarm_defconfig b/arch/mips/configs/sb1250_swarm_defconfig
index 4a25b8d3e507..a50a7c097542 100644
--- a/arch/mips/configs/sb1250_swarm_defconfig
+++ b/arch/mips/configs/sb1250_swarm_defconfig
@@ -43,7 +43,6 @@ CONFIG_FW_LOADER=m
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=9220
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index 5ca1676e6058..647775f6d174 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -57,7 +57,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=65536
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index eda1fec7ffd9..5c3e25fd8edd 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -306,7 +306,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
-CONFIG_CDROM_PKTCDVD=m
 CONFIG_VIRTIO_BLK=m
 CONFIG_ENCLOSURE_SERVICES=m
 CONFIG_SENSORS_TSL2550=m
diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index 5d9080499485..f287a41cd38c 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -45,7 +45,6 @@ CONFIG_NETWORK_SECMARK=y
 CONFIG_NET_PKTGEN=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
-CONFIG_CDROM_PKTCDVD=y
 CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 632081a262ba..4abea39281cd 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -60,8 +60,6 @@ CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
-CONFIG_CDROM_PKTCDVD=m
-CONFIG_CDROM_PKTCDVD_WCACHE=y
 CONFIG_ATA_OVER_ETH=m
 CONFIG_SUNVDC=m
 CONFIG_ATA=y
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6e8c7a42603e..f836212c2acf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2201,14 +2201,6 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)
 
 	return sdev;
 }
-/*
- * pktcdvd should have been integrated into the SCSI layers, but for historical
- * reasons like the old IDE driver it isn't.  This export allows it to safely
- * probe if a given device is a SCSI one and only attach to that.
- */
-#ifdef CONFIG_CDROM_PKTCDVD_MODULE
-EXPORT_SYMBOL_GPL(scsi_device_from_queue);
-#endif
 
 /**
  * scsi_block_requests - Utility function used by low-level drivers to prevent

---
base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
change-id: 20260530-remove-pktcdvd-references-9d5c6362a5de

Best regards,
--  
Catalin Iacob <iacobcatalin@gmail.com>

