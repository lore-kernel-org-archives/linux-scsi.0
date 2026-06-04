Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F78747D928
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780579203; cv=none; b=DBn2ID+auc2yLNo7PO2Xr9WN+dEllXlS3Szkcq2VvTK1zYW+bkCbXb71PDVBGQr410wcGWuDcCXKbEjosNN7krRnVG0+1tCtOxalsgnZPuFefrRZhmwTP6lPsWPJdAFnHpG1EfzooXWZrXbLdZIF0RXuurtQpYfaI+tndjO8qzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780579203; c=relaxed/simple;
	bh=PHSBDn+EOV9cRPD4tjMDFF7NZh/wndEKOUGnhx8+7jI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PEybaOA+Ipi5xq+V1ezdNlqqnqYaU6aorSEto2QZhtRtKB0egmROQQ2rWce8xunQD8WNM/Hq27Ddx2ooD/VWWWXSSQQlu5yvthdOLSruasXRp0ZDrqPJmqLF0QqvxWpBU8RPP4JC5RkE0VCkekRmeKRNOnJwMch8auDzfYLEuCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pm2OGKHR; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pm2OGKHR"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490b09e4cccso5986945e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 06:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780579195; x=1781183995; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JErWg4zEtTpgl+LBk0hgPrc4Api/7+6zFB/swmBFkD8=;
        b=pm2OGKHRbbhfhdSTB/ugmp0VhlPbw/VtEbcHGLNSaUzLgy0vMFyrcrZTZdpU+C1wOC
         2qnYbHSF8I5PpIDow7RPBvqtxIWFhie0ZybuBuk3i173nBb5EOOWzNN7cLvic1uk4ooi
         K4B6bAqMhm6UvXOQQu87//MvA1CWfh8xVg/EueyRaY+IoeB0efGIb6+1Zlvvi0cLMjec
         s2ySj8frw6cJ1X6E9TNmXwTewzGkGlPDCXWA/5lzI4kn+B/dg4S79YFSnfqoisKh9FCa
         urlefM5mvg9dr2lOCD3U8T/dGhf9dBUtlCPsw9hQcise6I81ljUEjkzoOFw70DZ8mzCC
         aJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780579195; x=1781183995;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JErWg4zEtTpgl+LBk0hgPrc4Api/7+6zFB/swmBFkD8=;
        b=dJ/H2PD2f/zNmoV/Cc4FJmAsBVVOhfHFMeBpIry+QOAh6w0uP4JRkfXuvlNGq3OsmG
         vCCurRzyqshqGQnU7ifaK39ztg7/zmcmZ8lIJhbsMAliN+0rJcliwnVDo29YTcIsyq3h
         hKvqgyelbkhNy4+Qy44WPFiVJbB1arzCWABF1ddtMMWQJlfU9XEe/wOtK8ZGbeZez0YP
         aRDozGxsopllfdXijTQiCw6VPETCxmhIqNnlDTuwSu2qpXwC0TB0kAD4ilNW32K0P5J1
         3BrEhhqomIU1jULBe/y0a8C4VSvn1Zrl332p1YN9xoHX0FDGdVACVQ0kVKhIkywUL9L9
         IwoQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ovzOLObulSZwum3FVlYh4JfxSufbE70qVAQaw6IV+OeK47JWMJlYGPVkrw92/eQTpWW2lmd3JMXbU@vger.kernel.org
X-Gm-Message-State: AOJu0YyQVM1zWj6VVerjwAPKeIZSvtJ7OeqDlfOj2vATPoDcSQRcqcNH
	G/7RQ9gXZsX5Fz7Izwy2ldbD7KEH/VbcbxGeW+YirVdXIRW5DdP+cVCB
X-Gm-Gg: Acq92OGXom/BShzgUEv0agCF3O2aRrboKKSmbuSUNBenVZBjzHIZz1C3sx5o/3CuIYA
	1ihE14/Chp1GaehI3S3DoyOp2q0DT0aLKRuI4k4o0sa0PEM7FZ75atqZbOVj3dP4OLNU+fCUa6F
	7FbYQnOMZ2vhWBFUpf2rjcDWbeVBbOqM8B7yU26BboUOPmP36GZX8FqoQtVdyVL8oIjpMhVjlQ0
	HZSvfKFgpZZPncFjs0zaxuFvDka1J+Yofi2BMvbJBzBJE79aJCK3LN8Lx4TB8dnEfsmI2abvlMT
	PWzh0NDb3vj7e3WgSK2L3g/BDOUOvoMlrFe7K9j7ZcrBZCqyXjpNFpUo9p49jLVC9CrY/1hhKM/
	+Hbe//17JrMwhYLxMNqQWzIi53OQlahX5MafhIxMtyFnHv7i6/1ibeiea7QTUbHSL8qpNgBPHkf
	xSV30yTtqti7f+AGN5ugvJ3okIT9Anl82+
X-Received: by 2002:a05:600c:1551:b0:490:5466:8576 with SMTP id 5b1f17b1804b1-490b5e9fca9mr130752605e9.1.1780579195429;
        Thu, 04 Jun 2026 06:19:55 -0700 (PDT)
Received: from localhost ([94.53.77.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f368e9fsm15750607f8f.37.2026.06.04.06.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 06:19:54 -0700 (PDT)
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Thu, 04 Jun 2026 16:20:26 +0300
Subject: [PATCH v3 3/6] mips: Remove remaining defconfig references to the
 pktcdvd driver
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-remove-pktcdvd-references-v3-3-e2f06fb4eef4@gmail.com>
References: <20260604-remove-pktcdvd-references-v3-0-e2f06fb4eef4@gmail.com>
In-Reply-To: <20260604-remove-pktcdvd-references-v3-0-e2f06fb4eef4@gmail.com>
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
 Jens Axboe <axboe@kernel.dk>, Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, 
 Catalin Iacob <iacobcatalin@gmail.com>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4891;
 i=iacobcatalin@gmail.com; h=from:subject:message-id;
 bh=PHSBDn+EOV9cRPD4tjMDFF7NZh/wndEKOUGnhx8+7jI=;
 b=owGbwMvMwCX261qtXAKXKjvjabUkhizF6vVTc+KTYw73r5fOi9NlmJC+WWdX4szitUmdB0627
 omxYxPoKGVhEONikBVTZHlx7nrbhj1nAu4l2bXAzGFlAhnCwMUpABPpr2D4n+pW9+X+bI+0NSUc
 vy5x7l5o9GPanunid7TdhNqEmf4aRDD8jwiVUi4Nzc1l2Foqk3fBr21nj6Hhn09/0p/+W8ddte8
 cDwA=
X-Developer-Key: i=iacobcatalin@gmail.com; a=openpgp;
 fpr=F609BFABD84EB5C9DDDC37EDE89C6A3571CD0E33

Commit 1cea5180f2f8 ("block: remove pktcdvd driver") left behind some
CONFIG_CONFIG_CDROM_PKTCDVD references in defconfigs. Remove them.

Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
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
 10 files changed, 10 deletions(-)

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

-- 
2.54.0

