Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F169B3612E6
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2026 18:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772216442; cv=none; b=iY/wuygj+sNyZeVEHcHKm7ZL8IXLPCefJgCgOBNBRJpDFEODNrLHJrs7wIsby2G0n0NEDH9POiVC2/J0goNWPQssaEqz1eOkJH4q4ajcetH3rZsmax0+D6xVe2fY2CSicVtMKFM7XLlMdkA3W2bTd3Amj/Dh4DqoC5Q4QRq/aSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772216442; c=relaxed/simple;
	bh=jTmJNz3JOVdyba92WBCm0BzI8m25eUf0xEN3z2CYgZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kz6+Fh0Zy00Bu/c9RoV5W44e/1aiv239ahtWsJ5d2LjIsbMj3loLimJ2JgRdGNokXbgPxt/hCKUwAkca8Lalp13mrO7t8fESLDkrqAV82uqiacsI0m6Ts8xou4oCY8vgFQUxT1ebY8ikq2te4jVGdkNUl32ALWFAekcICVVfYSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WvJRImBg; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WvJRImBg"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43767807cf3so1586960f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2026 10:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772216439; x=1772821239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7lkvvORJcUpRwcgHDhrU7VhBdAXzpHVrJB8Pl7/ogIQ=;
        b=WvJRImBgWnQzT1MV6UQNzYAnLIBZhpI50VLw1aLYvlNymNJjxy4sY/KUU8RR2nCK6V
         10yAdbY7abYIZnKUBwgDMbVS/hGA9vOH5613lLcqCaCKrV8wEa2MmSeaKa/bdSk38gnz
         I/4e1RIeTS6YjCjlJWE3w8NawzshmrUPjVeZ+j8m7ja2EcoBgsTwq9d8I9EKgmyFdCiU
         p771xz85fA6kPOIGRKXdTBsm3ZjrFeHue1EeNkReDGdXookC8Nu3Nb3lX7MR/oyN9kUt
         t0Wem4Bg1avIn1REL16tBFDD+7Y/wmGLUTjnE14RMk2S1/LuLHgjR2vqcMxNwLcbcA5R
         KT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772216439; x=1772821239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lkvvORJcUpRwcgHDhrU7VhBdAXzpHVrJB8Pl7/ogIQ=;
        b=KCtyou9SCUcovT2onHCsmBJGMBbPlsJLBLcl/nQS4prqnkvhgHIXyzSLUp7rTToneq
         Pdc9Hw7Gd0h+T05NBaCso5Wbk//ggG06oj+vLUd5uAdqrtd3u6tnsyKAzkpYk2bZPdpZ
         h/AmRBnK1svGJSE6d3NcmGd0Uh1Sdlx+pDvjCWAuxOGNa8aZ+6FiO/dGWgT0taFkZUs5
         tMPXO2B7DCXxeQAXivLTF+JZItdNuhWLLpGSJHaDruu3sYEJ3n3imdURk4ZPVwXPsEjy
         7Md913GCrJvDad0lqmX85Feo3SA85lTfBaPBw19eiktMS0Vn2Wp6SDZ435ry2ATMVMOL
         j+hA==
X-Gm-Message-State: AOJu0YyHPVnvJt4MI8NBt6sxe8s8alzNlqCychhFTYE5n7GIFkzIbqi2
	6WUDO1of/T5R9q9nWdH0093yq/NLAU3WbLpHMKghyM13H7M6kAXsJt0=
X-Gm-Gg: ATEYQzxlnUwRqe+DqntAWOh0XoY3rznT2otpar/VOHLcBZVyXEBmY01scfdzhng16xS
	LX+4jy9QZm7hHCP5L1rQWgts6qu3dNNegAQpjPDQEAPNCHj3d6asNlDzDqp05Cf8M35b8UQLcCN
	impd2lrsoOm08JvYXtdcP5K6t7txIjMH9vZSZTZR9ZaQZlqkVoqYRm7ZbPq1USUXDBk1QZeUZJR
	6yt0bYgTbboOdPWF29o+mleCXrWJAUKFf7lVHGQngSl3BS5vZlV9/kR3l9t/L6EXg1wGmAQFYI5
	CFI5Jc7RAr8ZvYHJ5E4raqyKsqSvISaZhFa5xZztyH86AoAJCgBG+R3Zh9yEgvmdWMuGnqqCPHX
	83yGmxSWz3tbq9pJT5Gg5VjNBJSgOo3OgxMMCY5CPCi2pxHFsEFjeLIFKsLgSb7p4a58LuvE+eh
	FFyJAsBsh+1jkU407HTPvP2svElBI/0e6qcNW+PKpiAr6kUBIjGv8EDdl0j/CcbAlgq55PT0EW7
	dl+nwQGpSzWXyLcWWY=
X-Received: by 2002:a05:6000:2301:b0:439:938a:3de1 with SMTP id ffacd0b85a97d-4399ddf1edcmr6329774f8f.16.1772216439061;
        Fri, 27 Feb 2026 10:20:39 -0800 (PST)
Received: from localhost ([2a02:810d:4a94:b300:dfb0:2728:8964:e209])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4399c70e8dasm7819525f8f.9.2026.02.27.10.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 10:20:38 -0800 (PST)
From: Florian Fuchs <fuchsfl@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fuchsfl@gmail.com
Subject: [PATCH] scsi: devinfo: Add BLIST_SKIP_IO_HINTS for Iomega ZIP
Date: Fri, 27 Feb 2026 19:18:23 +0100
Message-ID: <20260227181823.892932-1-fuchsfl@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Iomega ZIP 100 (Z100P2) can't process IO Advice Hints Grouping mode
page query. It immediately switches to the status phase 0xb8 after
receiving the subpage code 0x05 of MODE_SENSE_10 command, which fails
imm_out() and turns into DID_ERROR of this command, which leads to
unusable device. This was tested with an Iomega ZIP 100 (Z100P2)
connected with a StarTech PEX1P2 AX99100 PCIe parallel port card.

Prior to this fix, Test Unit Ready fails and the drive can't be used:
        IMM: returned SCSI status b8
        sd 7:0:6:0: [sdh] Test Unit Ready failed: Result: hostbyte=0x01 driverbyte=DRIVER_OK

Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
---
The processed CDB, where 0xb8 was set after subpage code 0x05:
	5a 08 0a 05 00 00 00 02 00 00

Prior error message, no partitions found and Test Unit Ready failed:

	imm: Found device at ID 6, Attempting to use EPP 8 bit
	imm: Communication established at 0xd010 with ID 6 using EPP 8 bit
	scsi host7: Iomega VPI2 (imm) interface
	scsi 7:0:6:0: Direct-Access     IOMEGA   ZIP 100          P.04 PQ: 0 ANSI: 2
	sd 7:0:6:0: Power-on or device reset occurred
	sd 7:0:6:0: Power-on or device reset occurred
	sd 7:0:6:0: [sdh] 196608 512-byte logical blocks: (101 MB/96.0 MiB)
	sd 7:0:6:0: [sdh] Write Protect is off
	sd 7:0:6:0: [sdh] Mode Sense: 25 00 00 08
	sd 7:0:6:0: [sdh] Cache data unavailable
	sd 7:0:6:0: [sdh] Assuming drive cache: write through
	IMM: returned SCSI status b8
	sd 7:0:6:0: [sdh] Test Unit Ready failed: Result: hostbyte=0x01 driverbyte=DRIVER_OK
	sdh: detected capacity change from 196608 to 0
	sd 7:0:6:0: [sdh] Attached SCSI removable disk

Ater this fix, the partition is detected and the drive works like we deserve:

	imm: Found device at ID 6, Attempting to use EPP 8 bit
	imm: Communication established at 0xd010 with ID 6 using EPP 8 bit
	scsi host7: Iomega VPI2 (imm) interface
	scsi 7:0:6:0: Direct-Access     IOMEGA   ZIP 100          P.04 PQ: 0 ANSI: 2
	sd 7:0:6:0: Power-on or device reset occurred
	sd 7:0:6:0: Power-on or device reset occurred
	sd 7:0:6:0: [sdh] 196608 512-byte logical blocks: (101 MB/96.0 MiB)
	sd 7:0:6:0: [sdh] Write Protect is off
	sd 7:0:6:0: [sdh] Mode Sense: 25 00 00 08
	sd 7:0:6:0: [sdh] Cache data unavailable
	sd 7:0:6:0: [sdh] Assuming drive cache: write through
	 sdh: sdh4
	sd 7:0:6:0: [sdh] Attached SCSI removable disk
---
 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 0dada89d8d99..68a992494b12 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -190,7 +190,7 @@ static struct {
 	{"IBM", "2076", NULL, BLIST_NO_VPD_SIZE},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
-	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN},
+	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN | BLIST_SKIP_IO_HINTS},
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
 	{"INSITE", "I325VM", NULL, BLIST_KEY},

base-commit: 2f38fd99c0004676d835ae96ac4f3b54edc02c82
-- 
2.43.0

