Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8010C391513
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 22:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789856790; cv=none; b=H2dq+1Vc3kX6SFk1QSujb2aItSOBQxy+tEK4tRhsRfKzhhN4y7HqJ8idLcTZMUdWTz/NcFWfXi4ZmLV/DyKTqNRFthb3qy8grI9ugFiUDnRZwcGhOW+KDpVxePqI5hzOXTIK7Wx1BW0CFcO22H7u5w1b+xON+VR/0E36MX1gZbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789856790; c=relaxed/simple;
	bh=gU93zAzsOoQ1roR6T6OlNqwkUWFuikccQakX9808gFA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kj6miZqvrld1StKcDKmP3U1DGfxYw/GXciT5WQxnfUPx8cosUtArm/B1Tiub/UD4Hn+vC+/fOp36oRQcTkQTuvWgKSuQ9zGJ/FABos6aiKAl0V2NOsrpfH12UTsZtYce/6gGcpsEqq55IuIhHDNSuEoG2V9EN2X3GlfSFFgmlns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ldAToeH7; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ldAToeH7"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396cccbba92so1716256a91.0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 15:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789856788; x=1790461588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AHexZoASrrLFUeP2m4HCenY6Z1qSfaQk6YYJHltbZIA=;
        b=ldAToeH7rvrAqYS/pCUkXqOI0Qmyk8GeEgaYYUkixo3QFHN7Sx2MhcE0CbXnpPBhkI
         Ypif5eZYRPt+rfG3P9wztKZPAd4c8Rqc1ITZN68JXlVjMBxDkOTBXieD23SvwXep0ZC7
         qrd6MUQhcnXAZk9QI1uZX+/VdGhdg39lVAXnthtJo2eRmdGFqz+/btK3OqBRaT1q9PkF
         XqOKo00/XRLYItFKvR4wGx2JwuT7SAYJDNUkk+n3sdkUJTZsnDeR60LOQ6p8bZ9aInMS
         7rwcW/OQ8Sw0fF/OvWE/baYGv8Q3wso3U/0WHYNBHwKW1cw2Pozcha73UeExAhgunQPc
         Zzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789856788; x=1790461588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AHexZoASrrLFUeP2m4HCenY6Z1qSfaQk6YYJHltbZIA=;
        b=D8IW5Zqc7ximoKpa/gt73lJyirJgIuGjOk2PlVIqHeewsFI5Y38PQ54txVwgs1Cdcu
         UEqoNjIwnmKzYtWIjQXjsGxBpQCk4w0PCaU4uBDx5gU5Bj2EGJerK1UGXhh2FoAOSzKN
         RgLd2/fJxX3osiyiwScRNmHtMcPHp2v71vkn+/wpJHlpHxO/u8qeaMdDHEcVzpdehlMd
         tl6UNOinzWzr3CFeszuK2SH/QfZGHwbiu8H1ejrlsDovRpYi+OkCTM/bXvFYkS/bdgCJ
         IVTYTxGj1KkIjNmtFc71UsSfMHxaG1zu30l+CzdghBYwoZXbRMBNScgzJkgcNOYjiRec
         5lxg==
X-Gm-Message-State: AFuF++mANwOTSEfm2CBX1c98BTfhfqhjPEGGsy8NSmDONeXEMjBrU4ot
	+1jCQgvVUskuIeEU4ZmDv3K2PhHeBpyOT0eS09aNd/xEIyujQsn3Ujr9Fy3Nm60Q
X-Gm-Gg: AYBFou3nekk/xK7P+9e93Fmrgw9h6+zCCeKF3UTRUzpKs592qKqJ9whG3X6OrM/n2rN
	U9wIYq9ilEz84dgzI8tq3dWnvPlBUOVj4BwYsuqVr9Qq2Yhf9UQYKB/+sNqb6Up5FZmcaczM3bQ
	mZPFMOuheBZYqC8pWxhllbGZkwaOw5jJ3xmXUQ0qjg9aVlevWgohVM9+sSzHcxTzHFTpCwVOJNA
	BmT0Y6PI8FXqprYOXcCQow16M8+X7JOmirXxcKqjH1HjDrWPdsZSdVQRFemmh0P5dGzWzr3fasJ
	fnD51kRPdPhVe30NL0xOK8d4xFftsoNVyanr+biJ0doXAkJRcSzhvhVkqjZLvmcBaLskaJwcpof
	3lrGvLetbhYJsxATgrWahCWY4LOsGcrLKNeJn/4iImv3uSlus957ZLAn0OpvX/EYP648SAkiI1s
	EGRe6YOAfHkGNngbNLDygDHyTH/oU5lRAUiTe2LJ1YlBVjHV9t+hE4igvij8z2/3cMB42C2nQDN
	1h6ZyHafie4DK+S6uPO51Obpb9a0vu8WVyPxb2tpC35483Q8vvXSP8+mbap3FIGR70fcutGMq2q
	4EB1tEeIgw==
X-Received: by 2002:a17:90b:2d03:b0:39e:1c03:14c2 with SMTP id 98e67ed59e1d1-39e54baa3f1mr10887430a91.11.1789856787653;
        Sat, 19 Sep 2026 15:26:27 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (78.123.83.34.bc.googleusercontent.com. [34.83.123.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c3145e5sm6614629a91.5.2026.09.19.15.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 15:26:27 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: sg, sr: fix stale scatter_elem_sz in sg_build_indirect() and OOB read in sr_is_xa()
Date: Sat, 19 Sep 2026 22:26:26 +0000
Message-ID: <20260919222626.3797788-1-benquike@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix two issues in drivers/scsi/sg.c and drivers/scsi/sr_ioctl.c:

1. In sg_build_indirect() (drivers/scsi/sg.c), snapshot scatter_elem_sz
   into a local variable and clamp it to [PAGE_SIZE, SG_SCATTER_SZ] so a
   concurrent SG_SET_RESERVED_SIZE ioctl cannot cause inconsistent page
   order calculations or unbounded order-10 allocations.
2. In sr_is_xa() (drivers/scsi/sr_ioctl.c), allocate at least 2048 bytes
   (or CD_FRAMESIZE_RAW) before calling sr_read_sector() so reading
   sector data at offset + 14 does not read or write past the kmalloc
   buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
---
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e6c0..5d635349e06e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -480,8 +480,10 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 
 	hp = &srp->header;
 	old_hdr = kzalloc(SZ_SG_HEADER, GFP_KERNEL);
-	if (!old_hdr)
-		return -ENOMEM;
+	if (!old_hdr) {
+		retval = -ENOMEM;
+		goto free_old_hdr;
+	}
 
 	old_hdr->reply_len = (int) hp->timeout;
 	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
@@ -543,10 +545,10 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 		}
 	} else
 		count = (old_hdr->result == 0) ? 0 : -EIO;
-	sg_finish_rem_req(srp);
-	sg_remove_request(sfp, srp);
 	retval = count;
 free_old_hdr:
+	sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
 	kfree(old_hdr);
 	return retval;
 }
@@ -1667,9 +1669,12 @@ init_sg(void)
 {
 	int rc;
 
-	if (scatter_elem_sz < PAGE_SIZE) {
+	if (scatter_elem_sz < (int)PAGE_SIZE) {
 		scatter_elem_sz = PAGE_SIZE;
 		scatter_elem_sz_prev = scatter_elem_sz;
+	} else if (scatter_elem_sz > (int)(PAGE_SIZE << MAX_PAGE_ORDER)) {
+		scatter_elem_sz = PAGE_SIZE << MAX_PAGE_ORDER;
+		scatter_elem_sz_prev = scatter_elem_sz;
 	}
 
 	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), 
@@ -1875,9 +1880,14 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 
 	num = scatter_elem_sz;
 	if (unlikely(num != scatter_elem_sz_prev)) {
-		if (num < PAGE_SIZE) {
+		if (num < (int)PAGE_SIZE) {
+			num = PAGE_SIZE;
 			scatter_elem_sz = PAGE_SIZE;
 			scatter_elem_sz_prev = PAGE_SIZE;
+		} else if (num > (int)(PAGE_SIZE << MAX_PAGE_ORDER)) {
+			num = PAGE_SIZE << MAX_PAGE_ORDER;
+			scatter_elem_sz = PAGE_SIZE << MAX_PAGE_ORDER;
+			scatter_elem_sz_prev = PAGE_SIZE << MAX_PAGE_ORDER;
 		} else
 			scatter_elem_sz_prev = num;
 	}
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 089653018d32..2a3ce6a460ed 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -582,7 +582,7 @@ int sr_is_xa(Scsi_CD *cd)
 	if (!xa_test)
 		return 0;
 
-	raw_sector = kmalloc(2048, GFP_KERNEL);
+	raw_sector = kmalloc(CD_FRAMESIZE_RAW1, GFP_KERNEL);
 	if (!raw_sector)
 		return -ENOMEM;
 	if (0 == sr_read_sector(cd, cd->ms_offset + 16,
