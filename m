Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505B5361667
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 09:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378086; cv=none; b=OhJkyEv2ioFJk4abumO8EEvSIk/c4/xbwHCMYbe60v/ZX50jcvEaZ/z9/Z270bw0ajVrPQkLB4RBtktx1FHbC3CKyyxTIjuw2kSSeb5oBQRJjIl2+XjQPl3Ht+z2xJCFlQFJ4dnfB8TqWcka8bcawr2I0TlUmDk2OeRflXrCgdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378086; c=relaxed/simple;
	bh=Mmg6zdhbGqnpNJI4L3IJbcc5j7f2xO4edEqJ4faiAaU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u8hXaRuF9cHWrhPbHWiG2SJGCksrPNxPulhoMVQjhgMGkgqL2BtLdYXOpLVRAwk2KqLqqRdr5hgu2gB6G1zasPDO5s3DCQKzidkshBYv+TZ9jRuhNncUN4BARQZh8TBm+Hn89fVJ4Z0gcaDEsRvPstuA9w3YYMItozBjR4HRRzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGH6cfV3; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGH6cfV3"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-80af6f707b5so612287b3.3
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 02:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782378084; x=1782982884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X4qHbsksl/byiUosk8V03cizsmnlk3vI68gtijKHle4=;
        b=dGH6cfV3hWjG+Z88PxcsHOtCpUV1dDplAoQgIcZHb1SPemlTtSKu5Zjsu1xF7OAmVb
         EwEbMYQayAfoIbzG5cE2UsripLGgMgZ5y/cMOI1Sd7mctbET4ZktPxRQGm8oMMnnMsZo
         PX+cdX6M0xq/aVf1oUmXnkq1WjG+UlnLiKaJhs66mpYuwBDw4t8pOw+OwgLcfAZVa8eZ
         vVqTbYONGpsTQjGOE5yhnFZ3+VZpFsjK+uAqjTEyNtAz/YkGIEa+YyWW/8VuqJqfLL03
         IEKxOtXvu/NFrHuKl9bqXzFMLtB444lUM/VCHgb/9dpn14lGdEAnJqXTHAr7ympWDu1F
         QdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378084; x=1782982884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4qHbsksl/byiUosk8V03cizsmnlk3vI68gtijKHle4=;
        b=neo58y7hzE8zQ81tCtTnXS9bVnmVAoMlcFdbQmLHjbTUeO+w6LzyELE6BYrdAKOtNd
         ahlzDXryLqRdUrCqgSlxld5KV/xAfWuksr5Q2wYaoeQQtWCO4x6Ca0x3K6nDVlMSFB1s
         AvyH8e82HwuLjt2F/u/Sq9mk3Rx6gXdZCQKR86gorsVhfOMVY0C2qT2gmTRVv+5PRfKh
         ATbcRe1co7AxxfZbip2IiJjflz2ujPXJWJn6e327H3AuiEFvPxUm0HW2YosjGJq/jrfl
         b0Euo2JolZNpPZLiQ6QkHFsMsEL5eBAj4erUSjf11M6jTq6DJ9NtFSAYOvifBrqnW+Fe
         KwxA==
X-Forwarded-Encrypted: i=1; AHgh+RrV8nAy5hrtIdkK4bCLIbYLBRUbTjf7U+whdoXqCjtzUyBQiCbkkC16CwWza9UFx80cbFapcqr0Jkqp@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/Wlq9zRvTxvyolTWKWx9p4GDyLTRmjODhJuSYyYNRfR5DAlii
	yzmhgIbIGtoLlE3J0RM4a8q3dsb6Le3MIg9oGLOpTONW3FZFvEHRI3Up
X-Gm-Gg: AfdE7cnw33rPWgHrzNbLXqG5sf71vsHSEihr+ZvQMPlG01vHnjBlVV+uaW+hXDaOkI6
	JmF3CPOE7/zODneXDi4zTsYOZS9xkYYQRa/nS/by2bCdEDYTjP+46QJ4gf2bLj7EZB6f3gN81/C
	nYeA0S1ok6qKSAWC6d7z+KmQrSi9U6We4tNrT9roI8ChBc7WZAMkB0HR3T0vx5sk2WqvNcG0JfY
	+OpkcaUQfO2DpgI5FdNHX5TMSqxYs8bUBTSBs+P+p7v7rBlQ7gVNAELEHGIuj7pCn1ly4Sqd/eQ
	Wk9zJKlbHIbnx9b+nilMosCPNAdtCkjFAo49MqDrbuyKD7ZlAMU7ohvaNNqpOj7p+nanVkOGVf+
	OpnGnVOkjMTFHvMS4Hf5HefO3tDgcfEp9x4jNBvupEw0YBBoXGznUUZ0GQhy9XN060/8ukpGOqX
	tPsBa22XhOQpYSQCNKQbRKDD2fpg==
X-Received: by 2002:a05:690c:e1cb:10b0:80a:9f1a:d48f with SMTP id 00721157ae682-80a9f1ad706mr7237507b3.54.1782378084296;
        Thu, 25 Jun 2026 02:01:24 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-808ceb8ced7sm16937347b3.40.2026.06.25.02.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:01:23 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH] scsi: megaraid: clear ioctl DMA buffers before use
Date: Thu, 25 Jun 2026 11:01:01 +0200
Message-ID: <20260625090101.4761-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MIMD ioctl path reuses DMA buffers from per-adapter pools, or
allocates a fresh pool buffer when the shared buffers are busy. Read
commands copy the requested user-visible length back after firmware
completion, but firmware is not guaranteed to overwrite every byte in the
bounce buffer.

Clear the attached DMA buffer before issuing the command so short device
writes cannot return stale data from a previous ioctl or allocation. This
covers both regular DCMDs and passthrough commands after their requested
lengths have been validated.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 drivers/scsi/megaraid/megaraid_mm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 75f6b7198..1e011e4f7 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -544,6 +544,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t *kioc, int xferlen)
 			kioc->buf_paddr		= pool->paddr;
 
 			spin_unlock_irqrestore(&pool->lock, flags);
+			memset(kioc->buf_vaddr, 0, xferlen);
 			return 0;
 		}
 		else {
@@ -575,6 +576,8 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t *kioc, int xferlen)
 	if (!kioc->buf_vaddr)
 		return -ENOMEM;
 
+	memset(kioc->buf_vaddr, 0, xferlen);
+
 	return 0;
 }
 
-- 
2.54.0

