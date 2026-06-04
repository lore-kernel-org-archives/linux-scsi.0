Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7541447D93F
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 13:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780579204; cv=none; b=FaZTZ1CmwpRqrYlzFFqS1e8t1JovGatEY+ugaKiYPTfBmH1MvRzUON28/vNbwizd6Ug+W28N8rSKXOv8BAF/otR0oibmFUP1IO1M5M0iajsjE2NzgR7s8Y2sb+8js2/yMNkxxmehZyqNxHTKqxuohOMSb2PnbElkDk7N/0b7BZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780579204; c=relaxed/simple;
	bh=gzHc6gkZVQYvB/HNV+tpD+0yf/PTlunsXEIfWYwA01U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cpYbhkB1sHumVyImwbBD1oiLFfhVcGURTCO/TLXHzYBvQsWAJTtmmrR+YJFCdqt4B2MnovnZSGdqDWNApDy4J7VPRZYOA4R4SiiJX4O2eZdDAzBFrw//2VJLmPBy8b33oJjJT55JcEmJ6pLZ7vBh3zooae5bQcu+jtsQtY8WPoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xq62RZnD; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xq62RZnD"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b09e4cccso5987575e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 06:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780579199; x=1781183999; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qohYqz4B4PBn5o3+UkMj6t+aWtH9uwOMAfqBpeAnghs=;
        b=Xq62RZnD4vbaMsxGWiQ5piP3GG8HVD3wOIguMVkym3xwuigqCO1eeNG5ysmGUu6kyY
         c8MpKgiyfr0OIhMlKyWacocz/RW1J9UfikPsiIVyVGr4KwWmegWpKHfeXji+PDVTGF+z
         5Fm1gdhZbdA8GF6ryR/GiGIlqZbysr4WyVBzFDsSDbCWpJ40C7ijfZMM+RjyeT2sygAf
         t2PMuFaX6+/bJb0g9eFHVj1FU0nf5uDRgSy+OWNVkR5EXpyRbCxYeeeQI5HU6snwRHol
         N55uXXNnpbUXndFPyRsUFocascTIP9PtGpWHW3mfizSKbEDjvgEex1FCzqYKTN6D0C0c
         cBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780579199; x=1781183999;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qohYqz4B4PBn5o3+UkMj6t+aWtH9uwOMAfqBpeAnghs=;
        b=Dx41qnj+/UKqQTkmDFKqs+CwS+W6ov2iG1rEooZrhO0foRbUN8zIgx6slKDBRR1qTg
         VZyBoWjsCqNhYt2I1n1JZJiOPvGoKVTvfzdllM6ITaRnCPWZRArC0TzYIWeb4ZKrj9iL
         j7yQDuzm7SRny2pNH4P0UyEx6Hdz8fGCJC1oMIaesQ8j1QxT5aZPzM8p/PSUQoWngJbR
         SMpWcZCzB1qJye2uFAac3r9J+LssquDc8L1FoKVl7WVSyClTz1q0LF7L2WG9b2vqadHP
         hq+evYEYe7j1Vyia8pKz120bHj+Lyr3SejqkmTEM3YTLqbScDkbr4h3980TchXsutGVz
         eVBw==
X-Forwarded-Encrypted: i=1; AFNElJ+0LDJmufEv3OdGKv44jD70XJE3zIxkzD0eQtV1xi/IiP1DuoiztpRqmab5Ohplm/yy++ciu+jEQsBm@vger.kernel.org
X-Gm-Message-State: AOJu0YxKm8kSCHOPfQVTVgT0Nx/C71LBUvxPOtpnK4XgAOdwHRA3Dku9
	VdnubYx92eEbkosol+4GX81zRd08eufxBWDdQTav0yeHwphBEtFvqj6R
X-Gm-Gg: Acq92OENQxDKPugPMHvcvC8TtFAmSCmi5+D8tTZzsp1GtSbCrFGvEGdhycLGZuW/6bu
	caR1kH1q/YQlxx1vbiMqVQimM7ZMIkMrQxPgTupcGIwB9jz4hI8ZDppgOE3faHF95fLuSjPVA23
	OL4JlO1EM5M4Q3Pas9W3Gd9A7NOI4xV5u4vLtSyj928S38ftj+AbD2weYjQ0Yepciq5pLdIsYs8
	Qtc3Ks7YB7rqy94Uh4F9ukKCbGawGEie1dOzLVC6CmBJyvY7gXfBj23C5szG8KGpRRPuzb/zNkO
	vVy134DmP0ZnemzTMHBsuJDU+L0qHAKcdoAY9oaZ/enPZTqwIcPX9al3dbNK3ZWPZd1YpvU65WA
	5m4K0xLjvRj19VVUNdlsbwDZtDwbPa9y2p3QWurajPUX5nXZq0NvKpPvDDwAFfvd69bGh0qYga4
	huGTfmsyjRDo3PGSXEoVC98HToF/d2sRql
X-Received: by 2002:a05:600c:871b:b0:490:b9ce:a73c with SMTP id 5b1f17b1804b1-490b9ceabdfmr108163365e9.31.1780579198642;
        Thu, 04 Jun 2026 06:19:58 -0700 (PDT)
Received: from localhost ([94.53.77.213])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc413541sm72844695e9.14.2026.06.04.06.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 06:19:58 -0700 (PDT)
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Thu, 04 Jun 2026 16:20:27 +0300
Subject: [PATCH v3 4/6] powerpc: Remove remaining defconfig references to
 the pktcdvd driver
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-remove-pktcdvd-references-v3-4-e2f06fb4eef4@gmail.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1209;
 i=iacobcatalin@gmail.com; h=from:subject:message-id;
 bh=gzHc6gkZVQYvB/HNV+tpD+0yf/PTlunsXEIfWYwA01U=;
 b=owGbwMvMwCX261qtXAKXKjvjabUkhizF6vVWD6QfaCz/Yty56WrD98M+Qcwrrn9sqvltdV/gy
 rLrO/+96ChlYRDjYpAVU2R5ce5624Y9ZwLuJdm1wMxhZQIZwsDFKQATyWZn+GcaGSFV+FgzPX1J
 Pq8T0x35indl8xo7kg/vsHeqOp1Xm8nwzyLEgilvj/l6p2MrPYTONhpNKdtdUs7dZrS6KkNs9ok
 73AA=
X-Developer-Key: i=iacobcatalin@gmail.com; a=openpgp;
 fpr=F609BFABD84EB5C9DDDC37EDE89C6A3571CD0E33

Commit 1cea5180f2f8 ("block: remove pktcdvd driver") left behind some
CONFIG_CONFIG_CDROM_PKTCDVD references in defconfigs. Remove them.

Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
---
 arch/powerpc/configs/g5_defconfig     | 1 -
 arch/powerpc/configs/ppc6xx_defconfig | 1 -
 2 files changed, 2 deletions(-)

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

-- 
2.54.0

