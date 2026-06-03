Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDE12BEC27
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 13:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780493184; cv=none; b=if2647Kx/yRJ82KwfYJZrzETQyVxKc35GgqffdOsNathnM4sYec2gRIpxcJOBgGQCkNupJonK3Yv6fqdPuIDNl/eBeFMLi1Ijc0JUawDlIL09hOMWqkC5r5LYd2R8GsdI8NR7jGFMBxMr3e05DT85tPJdBP2oM10fLJGYQnjaps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780493184; c=relaxed/simple;
	bh=JbV17MusThKsX/XfftOIwSTO4Uf9F1T1idPmFAgjMao=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:
	 In-Reply-To:References:To:Cc; b=uM6+gLruA2HYdwzJdMXT0F49hleuO5CmD5VmgA1qonFAuxhPdXiizjSxdxe3r3yJ5rIruYot4C01k2wN3Xcw+baGRXJ65SzyUrTK2aLcUrUrC9eILUXBhaauHy+CUp1S5s1VAzQS5H8vMGeS5lhnDg9S87/lhPwMuFURzXNTKJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1qUTdKQ; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1qUTdKQ"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45ef56d9b67so4166394f8f.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2026 06:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780493181; x=1781097981; darn=vger.kernel.org;
        h=cc:to:references:in-reply-to:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=utDwPV/p1t0/Jmc7E5OVVroM+Yd4IFrNq2llOGm4i1I=;
        b=N1qUTdKQr5zr//bKoOHZ8HnbuETgQ5422JuSCXaGdxj9n+/hWgRGKgEWMxdGlucdoD
         ATiTLmWU+mAqtLJIdoJMeKXiO5szARyX/URy1mrVFI8tsq/LO1ZZuPuxypM+mtBOEuQy
         HT4hEDAl6/IhCyH86rEb4Vfnmin/pXHrIU+w1MKm70r+S5eW+bIv0ZlWN02YXovEjER/
         Oy6UZobP1viaDXSZK1pma5smuRP2NS/XOVLosKbPTaOjuZXAMeQCX+VbRoi9ClQT6vJa
         i3QOnmPaPio6q0EGQdB4rDx+UtFV1AmDjxoZTqdkfuIdOy34AXdUOH4s+t5q3kSPCg8k
         1lQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780493181; x=1781097981;
        h=cc:to:references:in-reply-to:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=utDwPV/p1t0/Jmc7E5OVVroM+Yd4IFrNq2llOGm4i1I=;
        b=TYQ7bfEq4M1YX0sVx1HsLSUg9nP/uWsu9C8JWunpMoMvrNRE8tBlRlTsqCmlAUwNVL
         J6w/dFBTipKYe7vsi3D8PmIkR8hW84XjYus3GDImW2J5UbNtuEw5C3/y1DUy3MhLQ4Qm
         QOGMJwd0bi2aIcYdYTv5hfDOFXP1aXhumcj2L/tF3xXP8kZ+ju5Lxu0Z/JO8esFcv0RI
         UL0rJHHoLgAcvP2RFxp+TkJ2TZY4h+zFeEuPgB/IM/udDdQbqPijJMQ1ua69W73H0mMm
         MxxRa9PCZNeyie+ju40CCUg6R/qYzc+GVzfyj1TkDl3+udp8OB3P0n5ec62bagUmeXS9
         /8qw==
X-Forwarded-Encrypted: i=1; AFNElJ/TXMU25EL1t372FI/gscargSDpmRIdVS3ucK+QLPgnL8N2wviINyAuhSWPF/O0d444Wo/RdSlp9v0I@vger.kernel.org
X-Gm-Message-State: AOJu0YwyCmcsANTTHFwBtMLIixfWkzfz8MGYMjTk4hi5GqEqUJYIopT7
	6Mq5pRw72wJLHYH3x+dcG3F6+EJp4GL99rUQbAY+1U8/F8nq+7CwZLTb
X-Gm-Gg: Acq92OHBqosZrSQSlht23PabAterD9rXgHDvkHH3yQOVafdWhWMwxxD4cgcqbBS3evp
	ilSWvc3dY8KAqQbyK0T859YnxIX8Ak7sKnXWLtkc3VnYZvIdwv80aE0iSKjhzwq0DIlEmNCEPRw
	jhT2DgS8hspu/Rf1EZgv4sTgPiz46QY5gXbAQWVLL8VTPBFbPcr22hJfM+q54tzttDsXyvsghmB
	I2y8nL5yARUeOAJFlNsJgoa5FKoHnRsgoiv5Kk4NqKxByUNuETfcRDkycj2G5zktjZj5T9lisca
	3H6y9+RoSDY2pZ4WphRzKYdyhxZQHCz3gnYINKBRdtV34TdfCky67A5ALpYVhJ6HBu0JwNZTJLw
	thY8AhN6tWg6nY2VjlQslsKalETpnoor5VDGAPOBu1Av5tFs3tEiYayBkkqEZG/BWu4NqwKPaUX
	joGitTi3rA2xBJGanIbkL7EjfmZ/eqGMNE
X-Received: by 2002:a5d:63c8:0:b0:43d:69ff:6898 with SMTP id ffacd0b85a97d-460218c57f8mr3748207f8f.9.1780493180903;
        Wed, 03 Jun 2026 06:26:20 -0700 (PDT)
Received: from localhost ([94.53.77.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f35fd33sm8224614f8f.35.2026.06.03.06.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 06:26:20 -0700 (PDT)
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Wed, 03 Jun 2026 16:27:09 +0300
Subject: [PATCH v2] scsi: core: Remove remaining references to the pktcdvd
 driver
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260603-remove-pktcdvd-references-v2-1-c4402154d53a@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42NTQ7CIBBGr9LMWkyhhaSuvIfpAmFsR21poBJNw
 92FegGXL9/P2yCgJwxwqjbwGCmQmzOIQwVm1POAjGxmELVQtWxq5nFyEdnyWI2NNuMNPc4GA+u
 sNKpRQkuLkPdLzui9f1/6H4fX9Y5mLYelMVJYnf/s8shL7x9P5IwzraXqWm7bhsvzMGl6Ho2bo
 E8pfQGcBljc1AAAAA==
X-Change-ID: 20260530-remove-pktcdvd-references-9d5c6362a5de
In-Reply-To: <20260530-remove-pktcdvd-references-v1-1-aa56941d4315@gmail.com>
References: <20260530-remove-pktcdvd-references-v1-1-aa56941d4315@gmail.com>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Rich Felker <dalias@libc.org>, 
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8092;
 i=iacobcatalin@gmail.com; h=from:subject:message-id;
 bh=JbV17MusThKsX/XfftOIwSTO4Uf9F1T1idPmFAgjMao=;
 b=owGbwMvMwCX261qtXAKXKjvjabUkhiwF7Z0Rd7zbzT7PWVCVdOLs2+ecMmtY1H+fmOClXXHz/
 +VtSxMkOkpZGMS4GGTFFFlenLvetmHPmYB7SXYtMHNYmUCGMHBxCsBETnczMjx8vTAkU2vFIgUt
 wa99KhvEpBP/7NO6YmXjZW0g8kf+0CZGhpnHb/w+9dDUNKA7w6SpS32pg/clzj2bgnWfOzFdK70
 QyggA
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
Changes in v2:
- Reworded commit message on John Paul Adrian's suggestion to be about
  the removed references not the export symbol
- Link to v1: https://patch.msgid.link/20260530-remove-pktcdvd-references-v1-1-aa56941d4315@gmail.com
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
index 85eef401925a..b67f0dc79499 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2224,14 +2224,6 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)
 
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
base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
change-id: 20260530-remove-pktcdvd-references-9d5c6362a5de

Best regards,
--  
Catalin Iacob <iacobcatalin@gmail.com>

