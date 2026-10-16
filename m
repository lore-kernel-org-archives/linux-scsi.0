Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8E438A72C
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792162487; cv=none; b=PN8ZhygTyNJU8tXYhTDybEQ5JFQYQhH2IVJxqbIpS0gNzfqiQ1Q8VmhIWEA4CLXfhv/sWKi+z+Fsl8WWRTvBQb9BkOGAY9TDmc9EI0GkV+ZeXiwgBRd49p3EDF13Mz2SIvIqOP+4/QWvYJ7QF3vryhPnrDG3c4skbHuNzqdynHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792162487; c=relaxed/simple;
	bh=C24Y8pYzO/aPrLA9AMl8TvcQHVpbwYHJDkWQ8XX3CzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f3CgkHzuRuANHnRBnynBKdAUVZay3f4XwDVpVy0/IEPVw+xtdlL7Fr6xe+xRDQQGECEpPjBHMY7YlAAvJv4H1yILLTCmgazX/1Xe5nXy0my6tAxgVMnciUYaZeueqFoHDKHGy5fWNavpqBoeKCJHEH118nfnxekhx9xVi/qIzV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i2Ftfp5J; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i2Ftfp5J"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48af4ba4425so1017827f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 07:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792162484; x=1792767284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8hZGPnwDEfX+nqOzBQskZPmMNJTIRqNPt8gbd4kOL/U=;
        b=i2Ftfp5JcX3Ok7EEeo+AU5BbuhXJs/sdV5zRXlENELgCFXkWhMaFm1wY6GsuL3YDEX
         A006cAW1cY8diJj08KNFzY88NVhhFbMs9LEmLhv9GSqF8xudFxWovM29tV+KiNstx88e
         sck7UqVpq/6n8wCWm+3nsA7/ifiFXdX5HnimGXivO4sZIEqbjHx4CGje29iIH+7QDf9h
         6lD7m405LKGfp8rShNGBPblhz8nffET0KL6JbDV+SjL239VvEzVlpoVjPPIX7iZU41X+
         4Y459Gjq1iXqCqZkW7Q8XllGh5G8I5AQiFQUT2KXZ257Af3/uZb0BSoFGvBD/Qw7TPul
         aDOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792162484; x=1792767284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8hZGPnwDEfX+nqOzBQskZPmMNJTIRqNPt8gbd4kOL/U=;
        b=2ap7+meW8uPtnOWum9cfCor42mqGFZv9ZL4Zu50Td+3AZxCpN2j1fqzN+KIiX68onG
         021vZwgfLeeJrBEZ1SgOryZlCop/eAFXGPkyu689O90Ml5baNhLvWKWfPxK+ZQO5wK3H
         WnXIbrnuUrISIuXjuc3oMdY9t46cNaO4/pTFk60Z0cHNoEKjpwft6UQtRkL/WmXXLvo8
         uls24czwtCDxoWswR5Hk0zF5Eaq+3eD8HqvnmSN2LQz7UnRdQdqubmLQUnpiQtLrgHxa
         JIUryiC+bV6jcW7KQj+j9s6X7SskZGauxjrPGEx09grgq5EkBGcanO0gGlUw4gQgP8DR
         /yLw==
X-Forwarded-Encrypted: i=1; AKwUvByzdfiG/GIyhdNKLEhu8xb8/rwnArsQCFNfqn/klt2BkSXHA2iLp7oAjfoywwd1tXrGzLAAdhq9GUNr@vger.kernel.org
X-Gm-Message-State: AFq9FYL7n1RgWjMLHzZu1ez3xBq34CRhiaOiWD1HJmFtaqqFFNax4YyK
	nI7JPndTEgNUjqLBjFe9MlB05cph2D/1PsweSLDyLqyKOQu3cOm7YgVS
X-Gm-Gg: AYBFou3ZFdW2MYPYqgzfgU5xwy6CBpI0Q61EuTV1L3PFnlP1Pj598m9OKir3RNTcJMO
	zb9RR8V3+bk7zAzpF+FTFafbyKdFs7f+ABxp9dsTn1SitmEcdzy4D9rOsLYMS/dVeVFABabw/c9
	z/Bxh00W4x0tS6cjvRRGnJCoVU4l/WNXm3AA4zwrSz7Z7rKQT6bSkrP7nCSlR/VR28goCPvHpMd
	SN8KVpY9y4Om2P4c4RNSFUnKtxS7oXPsmqoMMx/6QLgEmWqA8eh8EY/6WK6xMKgObuhKso9097Y
	mxkyRj/9byYfOJI/0SwSVnrFYmQ6lyYJlI+XZS6VhWtUWAMiPaVeuIXwz6p8m/wxwVCaYksFJ9I
	2suAjaJO1JEuT+DR2MkT26s62BHZkSJLBNWX01tlH1IjElBNB26FHE2j26jxo1A+vZ/FE/oXPVP
	hS56lRxNt0Ac91duWUyPWhuQfjwG2GBj3Qc6AaffLPKEV6tPQny9XHa9+6b+1XveQAtQyWvh5+R
	mu1EKIWdyunLU8EAGTTf8woJa0xLIiEQnk/EbDOhiVPQ3vdVhXGbBBOkS483tLrPj0=
X-Received: by 2002:a05:600c:37cf:b0:4a1:7dcf:be1f with SMTP id 5b1f17b1804b1-4a1d75dd618mr1120995e9.1.1792162484113;
        Fri, 16 Oct 2026 07:54:44 -0700 (PDT)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-83-149.paris.inria.fr. [128.93.83.149])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4a1c8a9ea3bsm50046305e9.0.2026.10.16.07.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:54:43 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	David Carroll <David.Carroll@microsemi.com>,
	Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>,
	Johannes Thumshirn <jthumshirn@suse.de>,
	linux-scsi@vger.kernel.org (open list:AACRAID SCSI RAID DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: aacraid: fix dma_free_coherent() size
Date: Fri, 16 Oct 2026 16:54:12 +0200
Message-ID: <20261016145420.50870-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In fib_map_alloc(), dev->hw_fib_va is allocated with
dma_alloc_coherent() with size
    (dev->max_cmd_size + sizeof(struct aac_fib_xporthdr))
    * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + (ALIGN32 - 1)
but in aac_fib_map_free(), the same buffer is freed with size
    (dev->max_fib_size + sizeof(struct aac_fib_xporthdr))
    * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + (ALIGN32 - 1)

This could leave parts of the freed memory mapped to the device.

Change the dma_free_coherent() size to match the unmap.

This was found with static analysis and only compile tested.

Fixes: 1bff5abca65d ("scsi: aacraid: Fix memory leak in fib init path")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/aacraid/commsup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index c4485629f792..cf0ae251e43b 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -81,7 +81,7 @@ void aac_fib_map_free(struct aac_dev *dev)
 		return;
 
 	num_fibs = dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB;
-	fib_size = dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
+	fib_size = dev->max_cmd_size + sizeof(struct aac_fib_xporthdr);
 	alloc_size = fib_size * num_fibs + ALIGN32 - 1;
 
 	dma_free_coherent(&dev->pdev->dev, alloc_size, dev->hw_fib_va,
-- 
2.53.0

