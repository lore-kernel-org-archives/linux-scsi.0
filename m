Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C7F53E0B
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 12:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774873311; cv=none; b=WLSWpvEAjGc21afxx6R9zN7SE0a/kEHpUdEPgN4Lt9WkafzyIxB3uQVzN4l0xjgYV9EBAeOTOLjOW17tXG0W4dOpdCMnhW0079dO2HbvGvSimf3oRBFkMSE13y9wCin42r9ZxpyMmDgWTqr+gCcnLk0k763erK8wfZF7crp+AwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774873311; c=relaxed/simple;
	bh=zBP8PO5fui9P8/Sb7HKAcwIrDDCoVoXn++3myaEcMQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y10DUkwxdw57EY42egcfCZ6UGWr2SG2W9kbVFp9AkF0jts383FEoHSi8K7w5+nLkwgs0Jw4YwZVOpsC/3IwQnG8DH6t2wG/Ik4cLz1G8TxfDXouzwE/hExPsOG5GHPemF9kj3zm+vOA9AUOF/ZM83boZP6K+xMlpFYVdhiBLXDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z+eb3WVF; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z+eb3WVF"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43ccda008cdso1317731f8f.0
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 05:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774873306; x=1775478106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AfVs7uJYqazPiIYHhRqhNoID8aAr9DmOFHGu1EF3k3U=;
        b=Z+eb3WVFFmwbo/dEZuiq8xfKQiK7ec8nisd/yZqvv/l4Ul6O84kTrcK70ybRemrIDd
         5KOdIDIAWI6qt1oxKDlprBuy7g7vcx4s8OWIjropR0KX9mTa8cHNTPKivzlUrSlXydyb
         u8eXoLawP76bIV5F+9x9mrDYs+87xJs+b6Qpnst5z7LrMFXpiWsmmOHH3Dcw/W1G5MFo
         l1ZqM75WCfgDw8m4z7q9FC/T7CxbV81guKAE6PPpnbX7FHMXzIEqcPH3ewIfl3Mhm5jr
         mAOMHa1EtY0MzcOgsH6Xmo7eNSK2bEu0kMCKCLwTxucFakVuIjnpsyf8re3ct2cHfdEO
         cuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774873306; x=1775478106;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfVs7uJYqazPiIYHhRqhNoID8aAr9DmOFHGu1EF3k3U=;
        b=MtzYs6lpB5i6vxuDVlBrqOdLv7VeJ/1OK5L5H54E2AJkk955+4XRl9e6c0CIfz+SQq
         s2fPjqSpvpVr8nru1C7+CE0E+hqyA2JWDGIvbw9adTJwujp34TmGx5gUYqyFTWzlh2jZ
         NSJfcq4dxCSUADHgIFIMIzPWZJQF6zNzcx8eMd7Xiqdop5L9NIVp2HJ4sDuX0sbVpAKi
         vgFgF4sf7TvVxERpXac6I4jiWkttEAxx/IW6MlM8unBujfxmbK9Wh1JeeB4GVd0nSv7z
         nIym4s30GsUH5thgDHNI/vXR4kATyQ/3YlgwH4eUoOPTjKkxeJ8T7f9T7iYiCjU6+0KK
         W0nw==
X-Gm-Message-State: AOJu0Yw9uhm05hjFQ492AtfVvTsUc4ex9Q/PvaWTq3kaXOULYnleux3C
	aD1dezVdGMp6qYq5XhOaMhmbcb4i2tmQV0u9yupS4VE6oIOYgi4GTR1Ld6EqirJm
X-Gm-Gg: ATEYQzzmuQ7UvlDGi4t5NWPkJObF6MHWNinYPk+g/nJt0DgwpGo9saC5CrhuV4+Q5ps
	5z55+3kXdEMaASVre9di35dltar+CrQnMseWhWetJxA/QQ5CmOWEQPE64q9/yK1CPwPRUFsj2Il
	Sudich76jBN8J819eZXpeX7XGfX5HlaHAPjfvgTavOOZsNTe6my7sWBI4R1vgOeb3Jz3HNm2gOJ
	En38/qYvMQ1+ipqpG1+TDrIxlLLEnHrawz/hqAs17GfzttuJpMJ6v1ZYwTOpbRxDBROuBOWB6Ny
	tMIsqHzSHl9sIuFfeTJtRmHf+ivehjAUcQCauIArsZjkuUGl44kZur+cyaCxN1nxV7uRKt0oaqf
	Cp5cg4ThFOpoNYFyreORIfZltGUODodgOuTys49vzvG9ALPFdFGiGJqCfbwB7ohvSi/pbflLJY1
	Uk6fQNjO617J3gwsu50Jiw5WxlmMX/SI+lcT8Z93l/0yDixSnXBBvwAYaw3uG/STH5kUxs1R7XK
	VsU6mCSelmT+SFJIjb4JiWad8KGH1Hay4pAAYoyFpudqCpOWntar/fUJm99uy28G9ekm3WpvVYB
	LMb6M3Jtw2Z9Cilk0YiN
X-Received: by 2002:a5d:5d8a:0:b0:43c:fac5:d382 with SMTP id ffacd0b85a97d-43cfac5d3cdmr8226181f8f.12.1774873306344;
        Mon, 30 Mar 2026 05:21:46 -0700 (PDT)
Received: from particle-0df3-d360 (2a02-1810-950a-eb00-f9cf-2393-cb7f-6fd9.ip6.access.telenet.be. [2a02:1810:950a:eb00:f9cf:2393:cb7f:6fd9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf2580194sm17243443f8f.37.2026.03.30.05.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 05:21:45 -0700 (PDT)
From: Daan De Meyer <daan.j.demeyer@gmail.com>
X-Google-Original-From: Daan De Meyer <daan@amutable.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Daan De Meyer <daan@amutable.com>,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: [PATCH] scsi: sr: propagate read-only status to block layer via set_disk_ro()
Date: Mon, 30 Mar 2026 12:21:24 +0000
Message-ID: <20260330122124.755083-1-daan@amutable.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sr driver tracks whether a CD-ROM drive supports writing via the
cd->writeable flag, which is determined from the drive's MODE SENSE
capabilities page (page 0x2A). When the drive does not report any write
capabilities (CD-RW, DVD-RAM, MRW-W, etc.), writeable remains 0 and
write requests are rejected in sr_init_command().

However, this information is never propagated to the block layer via
set_disk_ro(). As a result, BLKROGET on a CD-ROM device always returns
0 (writable), even when the drive has no write capabilities and writes
will inevitably fail. This causes problems for userspace that relies on
BLKROGET to determine whether a block device is read-only, for example:

 - systemd's loop device setup uses BLKROGET to decide whether to create
   a loop device with LO_FLAGS_READ_ONLY. Without the read-only flag,
   writes pass through the loop device to the CD-ROM and fail with I/O
   errors.

 - systemd-fsck checks BLKROGET to decide whether to run fsck in
   no-repair mode (-n). Without the read-only flag, fsck attempts writes
   that produce I/O errors.

This is in contrast to the sd driver (SCSI disks), which has called
set_disk_ro() based on the MODE SENSE Write Protect bit since before
the beginning of the git history.

Fix this by calling set_disk_ro(disk, !cd->writeable) in sr_probe()
after get_capabilities() has determined the drive's write support.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daan De Meyer <daan.j.demeyer@gmail.com>
---
 drivers/scsi/sr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7adb2573f50d..8ed002f82e36 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -684,6 +684,7 @@ static int sr_probe(struct scsi_device *sdev)
 	sr_vendor_init(cd);
 
 	set_capacity(disk, cd->capacity);
+	set_disk_ro(disk, !cd->writeable);
 	disk->private_data = cd;
 
 	if (register_cdrom(disk, &cd->cdi))
-- 
2.53.0

