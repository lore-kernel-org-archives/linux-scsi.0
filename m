Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFC1254849
	for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2025 12:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766060238; cv=none; b=IyhLb7vEEG8LYhhE61MrQZKf/RP5MXLFGsF53lL/LW9HccL5MIF0bQqJtIRx30tFoEI0GlaN9ydOtBOXsp0G2AXJeWnBfunPYta8Gr7Ws9osJRcZr+vBKb0Uz4QZkkoYBH/t2Do4ffxensHSsJGH24QaYJNOQdnISZwq/zteslQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766060238; c=relaxed/simple;
	bh=qiG7O6UF/J2Ly/EAeGl0MYRrP6DOKAxr33FjUc3WicQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BEZY7nuviWck/LVXmP86zGKtGzadWXV11M0jjERFUNiuaZ5p/GrmCMEMjokJda8deFPafml0U5YjzGH8MDx26/Rve6dtHzJEDoReBucHp40CfkeyDOPU7T4v9y8HD1CV9D3nGplujQi319C0/zXyTeuS5uOo6mobFxxkr7uRUDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E4kpIb4O; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4kpIb4O"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a09a3bd9c5so4969995ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2025 04:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766060236; x=1766665036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jyVYm0ues4iUBaQ2lxXrnR7rIJDuzkZszrw1dntaQII=;
        b=E4kpIb4OPF74+NwP5RzyXm5hv+6BVsDAxxyonh23oKu/zVY3RrTf0p834ONc2vfNv8
         1p07EPRO3W9Y+K/d20v79mkgrQ1BHkhZXFzaPXH91uKJ3gdVafPYiSOQSAmGjBHvxB+I
         Kn3Sznb1UpraKWneBPSnDysnGs9uuV/r56uXgie0paPlVffVCNaTiZHo7ijVaSC38nnr
         Ua3SihCDnhz5PxfsENy9qLYs1Alb/52VjdHe3LtsE5ofMTwk+MZfDYPbw8qB24kjM6EU
         KwC+DvYFLdZ0gHn4bYWlTiJCvC2xxXt+m6UvVWsN6VPOiyixZpc6/DJEs1/d3Sn1oeIW
         HcvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766060236; x=1766665036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyVYm0ues4iUBaQ2lxXrnR7rIJDuzkZszrw1dntaQII=;
        b=kA0o4AxlsnAiYEB+b5svTBTa9/zOmmCgh3pybi51HwPYMESVnfBlTd5nPkWUtjok26
         yoe4uqOUh1vsQp0cl9Y0McHLAztUKvy77f4yKdljpw5JyHmWsXPPD/kJg9Z58S6P2W5U
         jUOIdZv2nRUFmc/W8w/aKQEBvINMM0AGuuj+L5TkLx9mzHmLg6KsqGPn50BqVBhgJpAE
         WXLzyW9+zk1xxiSpEBzm+LaRyRElDYAWR1p9hDRQdB9gA6Escz/n2ADSv6uYNpIg5too
         ++ILRmn3NfaRgpwFtbkn26jNgD3HaXa90x0Gz4Y7LPHEHjdBIl93aSz6FnlwGNa017HS
         9mIw==
X-Gm-Message-State: AOJu0YzbQ9AzPjl6TeMpZEa90ch0ECGta4EfZmLueZTP0Rs53t1a9QU9
	7XD+D3UoGhXw6VqNTpWHpGiyFKwBJ3tlyC6K3CcXJKBO2iDw4zEyTYhE
X-Gm-Gg: AY/fxX4JO4irqvzIt/e0ssbs/L/c1AistwOlnJfcj7biGA8pOQPzBHU/9CEbVQU2A+O
	o0fKfAmW9Gg/ytUVfdPOJW5QayKvWaaN7QTNj6ym1DeFP9NZZ+qpvkusNpQNcMl6mUUmCoFf115
	4j+zaJDKH4yAaVfStdBNZocNcAH85XCMZfbbOhtTwkBiP59owblK8adndEBSVbQgi2SpDGbRvXj
	Aws4zL4nO8xQHmhf+hbxDek0gcsU/hpVQ5py0lBZrX/waSuX7yZY+TzwbaGuBucgF4ny25g0b8J
	/8ztwbTL6PqLIJpkuQUG/ThasKUdWNzCAvdM7gsDEfQkjkmb0ujX4Gj7002IVzmIymlZNSZi/OU
	0u2Jf/ND4pdfJJjF1ZIjz4ploFNA+qVq3NkyRCXWheQZcuicwni1b+bj7rMNYChRl5PaXkXGJWr
	tC328jq/Ablfu60zzh+ZQcTnXYbczN0EMV+ngYfimAkbo/Sq+0EgJCHfNNXLzM/xrpppGdPGIyo
	+yQHVWDbs0fzg==
X-Google-Smtp-Source: AGHT+IGbIWcKUdY11VJPO4+wnaa+X7Au3kPc/xDIiLaFc+Ni+fjNam+/tZZgcdZsJi3G1B1P5zkElg==
X-Received: by 2002:a17:903:458d:b0:29f:135c:5f25 with SMTP id d9443c01a7336-29f23de670cmr202072965ad.4.1766060236465;
        Thu, 18 Dec 2025 04:17:16 -0800 (PST)
Received: from oslab.mshome.net (n058152119183.netvigator.com. [58.152.119.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d1612a35sm24006355ad.46.2025.12.18.04.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 04:17:16 -0800 (PST)
From: Tuo Li <islituo@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tuo Li <islituo@gmail.com>
Subject: [PATCH] scsi: csiostor: Fix a possible null-pointer dereference in csio_eh_lun_reset_handler()
Date: Thu, 18 Dec 2025 20:17:00 +0800
Message-ID: <20251218121700.11316-1-islituo@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In this function, rn is checked by an if statement. If it is NULL,
execution transfers to the fail label. However, rn may still
be dereferenced later via the following macro:

  CSIO_INC_STATS(rn, n_lun_rst_fail);

To avoid a potential null-pointer dereference, return FAILED directly when
rn is NULL, rather than transferring control to the common fail label.

Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/scsi/csiostor/csio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 34bde6650fae..feb1a9a9390b 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2074,7 +2074,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	struct csio_scsi_level_data sld;
 
 	if (!rn)
-		goto fail;
+		return FAILED;
 
 	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
 		      cmnd->device->lun, rn->flowid, rn->scsi_id);
-- 
2.43.0

