Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123E9319617
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 19:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782329495; cv=none; b=EoSTZK7hmeJblmJPvDsHEthjodvi4qy6KznqApG2bBTXDUQOH8M4dNU5zkyf8TwMaPpMFc6wK/maHQ2TZ0o5RzPr6JnMK+9+D4sWzapDgx9fOBtt456z61i2u65eDXmCJPhQs/1k3I1TRRiA80Qv6T7eKHYNXZbdpq7DQo/QB54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782329495; c=relaxed/simple;
	bh=ob09ATNmS0jCTssGQEIKkb1JS2ZAXCYLh/fWfUDCvFY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=alrkE0njqUM1nPaJLVzzXfgWU8Aq6QHFXJnAE5+ujNVdX4pZaVk7KDBBSNVE1IP1elapwbl1fLFQC7ykZx3F4e3a62FwWqOt9n3a5DvFNbvQ7FfxizTuzokesMmuQdZJpKJRyQoAJSfVW6tBl/Sssw6GMEQ26s1HSPtP//JpYdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PBdkb8vU; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PBdkb8vU"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4926046fbc5so2631525e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 12:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782329491; x=1782934291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zM0Rsyc81+omKNrgWAtmEWugLcKMCzyY/I4DvgqfYRc=;
        b=PBdkb8vUaOD1ltPufmzRzX3jRJzlI7DyBvjhDeYHKJDGI38hpMzV2IDqJRUUJ4zv3e
         zIgo8e4bn+8+PCni/94MKa1tBJjLJr7N/+CJshWFL3/OuC2gzwgJjpzsMOJWeb7ma6aj
         S/VabluV0GnlqYNMJX9ptvs3RQjmBJtwLxYbCUeN8Jb1s6VvITOgQDN11oonFBMfZ17o
         qcP3MHMDlUM+fMdGJQYxpZDROffvK3IqH7SVE5HCk7FhL8GaLQoplWX45nUJkimfvYTr
         KZZSsenvpO6n5zUVSBMAhl+CBvseRIeLqoaGswnLO17+jsqfcjw/RhpVhgr4Y1XF5OtI
         4jJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782329491; x=1782934291;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zM0Rsyc81+omKNrgWAtmEWugLcKMCzyY/I4DvgqfYRc=;
        b=ohGQw9B3pE9c5M+2r+cO2hz+c9VYnfD8PjwXLA6dfUY/+IepgkBmHisDO+TONNXYK0
         W4Wj69A10fwGTRtIrZEqouNRHRZCafS1WcXlI0FcmpbahgVQyrH55EwwP3mBjy/By2mc
         6Mm7fhlRNi2lO/MAGf7z3KDCeZBwwsmM3J0+VyM/uo3QfEJ8UXianH29YKr2GoHI3l5t
         KJDCFCxfZmGYYXFf7yd0BqW4BlqmgTX7i/hlFBUUbP8jOIR/BOIpN2d2f4yJQUMj6w40
         t36gz/PI78Y9man9ufFLhcexuwFYZ4MxFYHnKcdudhSNHDa59/6dV6Llszk2xonMIcN2
         RjUA==
X-Gm-Message-State: AOJu0YwarhsMlquQcoMgav5LJyWk1M5+2Pldc9e28fivfon9aG0RovxD
	PLCaiATYvMwrM/20R2yOOWBN2LVqLdUp0U56lfqWvMyVAka78thAy5pI
X-Gm-Gg: AfdE7ck8NFcp8FYTovA7zFhzeLcaP9uGrcP+mQnBB3ekUmeD9jACmQAYOB/n0FNpumv
	yPWV7e1OQ13yzkELwgfolSPSlge/KQjtw6d1YRxcwmbjMluyjJiWZDpt2eDlRtUvb7WDPspyyIw
	tqKFBD3Cx17JFPn9SF3GeFDAB05RPc66g5rpRwiCXBJfrzj3z/X42U/3oFHK/DGwtVaYNmMpxjY
	8OyF5U7vfhPCTEcbY8Q4jY1lK56cK8N7VWhZrlA6aMnuWwoVhoZAB/x3dYTidzO3NVUWP+Oi3vy
	0VmV1fkt/gedN3bh2/zitErtje3BCAtxf347CHqNKub4RZ7hc60lpr1LTLoud6+3tBGhHk1PBUJ
	VU0Pd3wgJZgxlEk6Ma5JqOTHWBmQwfH4vJnWQrKyUv6ncw0JGEvRFcJivCsmQBYXeJQW3sBVGE7
	mjwZTNAGj9vgYXRsHrgDZo9KbsKw==
X-Received: by 2002:a05:600c:5843:b0:490:af63:2cb1 with SMTP id 5b1f17b1804b1-492632a3556mr18392175e9.7.1782329491450;
        Wed, 24 Jun 2026 12:31:31 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4926497c890sm2967355e9.0.2026.06.24.12.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 12:31:31 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Adam Radford <aradford@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH] scsi: 3w-xxxx: validate AEN ioctl buffer length
Date: Wed, 24 Jun 2026 21:31:21 +0200
Message-ID: <20260624193121.5895-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TW_OP_AEN_LISTEN copies a fixed AEN code into the ioctl data buffer, but
the coherent ioctl allocation is sized from the user supplied buffer
length. A zero-length or otherwise short buffer lets the handler write
past the allocated ioctl buffer.

Reject AEN listen requests whose data buffer is too small for the code
returned by the driver.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 drivers/scsi/3w-xxxx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index c68678fa7..147a47e6b 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -908,6 +908,12 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 		goto out;
 	}
 
+	if (cmd == TW_OP_AEN_LISTEN &&
+	    data_buffer_length < sizeof(tw_aen_code)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
 	/* Hardware can only do multiple of 512 byte transfers */
 	data_buffer_length_adjusted = (data_buffer_length + 511) & ~511;
 
@@ -2427,4 +2433,3 @@ static void __exit tw_exit(void)
 
 module_init(tw_init);
 module_exit(tw_exit);
-
-- 
2.54.0

