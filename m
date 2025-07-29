Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A3820ED;
	Tue, 29 Jul 2025 16:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753805040; cv=none; b=HokXS2cS4ewS+/5Q4qj6br/qjyfdUXK70HbTf0bJ4DTeaq3g12Lrzm46j+fQPLBQlkwj8nC9e7tOdfvdPzf7fe2U0MzjpaxDnYE1KHELNYUckr68QnDbLME4b7iImj/4EDQwYKxNockFyUMXrqHBPviOEYnDOOnWi+9iiOxPxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753805040; c=relaxed/simple;
	bh=HsIXvtWbidHvuyE9TiKJIVJMf2j46HhLSf4zlRs9mno=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=epMxud82gbPYUgNrltwk42rycJmXE8KqGFDV8Kka4+lP1dqJ74FIb4fC6zfzgYLeYOhAXasaUTg+W25m48hVRdyzaqaH5bsYTvK0aN9SPxnYEiYKMXuvdr8aV1B7mdHwAWyuv0dHFQaD23jD34mMb8fZVEYBEsO+gPQtw8lFbO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kZNFbdlS; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kZNFbdlS"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24049d1643aso14281135ad.3;
        Tue, 29 Jul 2025 09:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753805038; x=1754409838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ji8gqgnwKvApP60qqe4UQjw37JMxLmNrj4jvz+/nEPs=;
        b=kZNFbdlSuxR43TA7kQ6or1n3KnMO6yl+pNiRi/lSUGEH5j1QkejGNbvhnZZUp/CPBx
         b1sToR27U/Mkjkje8uyhvyik3IwgGRoFBu/ACmW5EXfWgn1ObtVoQ23jRi603c8+3QqE
         MRznqKjnoPJ9PUl5mRpoBDPZTFUayUPQpiH5XM6iTXIqM2CbVgPvP5qm4xXpLf41jQXk
         Z0irVvrHpTxYNAfHIHE8guIh2JxcDmuxtFXxdpUG+i6Iv1CuBy+qIiI/1/OlvKT/0IRY
         blGrj7/f0rkVOrbLq5TDYL+jU+/qaSBAOzS/pWOJvwqP7L8vaqp4u1953mK/He8iEJCS
         DpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753805038; x=1754409838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ji8gqgnwKvApP60qqe4UQjw37JMxLmNrj4jvz+/nEPs=;
        b=XHulpl1wqzNEvSLSPKjgFFGPRWzkybcwr/U/G5BJr7U9YWZcgZZZwPLZflWQ/EG6KS
         KqqH4/mDZV8nRl1vgrYpUU3pNmc4nDPlknIXZWDJ6b1ksYK+UsecA7AGwuL2GDIvjxzX
         eiYAJCq5CNxOwSoi9rrxg+j/BPNOYSwBl3wuHnbJFYypdgOzqFH3PeWrsVHl3Dc4TsSo
         GoZ3uUFJ7jMRLp8AqCgv78NZhdm/U/zUtOPZw/3L+T64eT/u/vtD+jXrLpOtO7wHU7s3
         9EY7lHwsX9vWgeGj7JR8HFdiKPFyZOTnb8HE7v24GJ4czDHrtunbZRk3QcY/OULbrfeM
         iIrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVE4z1BcllAbx2o4HUEu5WzuZ73EuGgqG3GLbXrz6bTNDvhzUUY2WhhYy9RXFDQHTukIlV1xt6rWI8cQv0=@vger.kernel.org, AJvYcCVHsRt4K5rBa0XMjzPNjxis2LFBf84c8SYYkggkl3Hd42rE4Ni0P74hvcUVtPL+1nRYgr0E2vup+x8icw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLNqTvVQL+peRBv0cHCThH7R3BqyYsC++XT16mj4CUM9CEQ512
	swEqhXSFFaPQgIZtClwjPkjkAZxcyFyxTgMoYjl6PXDxQVXDR0RIg2BF
X-Gm-Gg: ASbGncvzLKNH9AyzgQZM3Q/hWXZjbLz+2IDMAtKeP60+qUv85KLjPwYB7Z4yLhLBoPW
	HMaduJn7qaeua+mgQvyGtFJk2hRTim1mkkyAoLfdKJ3ju87yzKXO0syjcp7OlKOQbQtwMqhqdGZ
	8TMupxIraHe6fGFweFcsE4eFMtqa1GxFge+ipX/5XJfStSGx846d6vS3jG0onSDeyagFw+tasXl
	l14wl84eHzQ4LWqITq3zpIEnvqqx3teGJjzgcZ8HGUAmPEZ2EepPEp7YlDJseD4Y0or0s6j5Efr
	cUDU6N2dVQXHmGNzFluj1HS8uX7r62BRhu/NK6c7h29Ikpi6NHsD9u6rxFqlqFmU98Cs8Jml7+2
	CyWikk9tAbN1azU5dQUX5gBP5XyXPnDwwIbWvvui4TSUiU25B9LlniE5sNsrFEaGK
X-Google-Smtp-Source: AGHT+IF2YF2QDEglhuLMoAr96j5ir2UTPTBBPs1aaoRRyIFfSuC6c0BXof1vMXReChNuvBDBfeQLKg==
X-Received: by 2002:a17:903:2a8e:b0:23f:adc0:8cc2 with SMTP id d9443c01a7336-23fb30b2f8cmr228342725ad.27.1753805038042;
        Tue, 29 Jul 2025 09:03:58 -0700 (PDT)
Received: from bj-kjy-standalone-gaoxiang17.mioffice.cn ([43.224.245.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24025f5a3ecsm51173795ad.136.2025.07.29.09.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 09:03:57 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	jaegeuk@kernel.org,
	chao@kernel.org
Cc: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	mani@kernel.org,
	quic_nguyenb@quicinc.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: [PATCH] fs: export some tracepoints for iotrace
Date: Wed, 30 Jul 2025 00:03:45 +0800
Message-Id: <20250729160345.3420908-1-gxxa03070307@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: gaoxiang17 <gaoxiang17@xiaomi.com>

Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 fs/f2fs/checkpoint.c      | 2 ++
 fs/f2fs/file.c            | 3 +++
 fs/f2fs/gc.c              | 3 +++
 4 files changed, 10 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 50adfb8b335b..4035b958057e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -41,6 +41,8 @@
 #define CREATE_TRACE_POINTS
 #include "ufs_trace.h"
 
+EXPORT_TRACEPOINT_SYMBOL_GPL(ufshcd_command);
+
 #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
 				 UTP_TASK_REQ_COMPL |\
 				 UFSHCD_ERROR_MASK)
diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index f149ec28aefd..83982977e9ec 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -21,6 +21,8 @@
 #include "iostat.h"
 #include <trace/events/f2fs.h>
 
+EXPORT_TRACEPOINT_SYMBOL_GPL(f2fs_write_checkpoint);
+
 #define DEFAULT_CHECKPOINT_IOPRIO (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 3))
 
 static struct kmem_cache *ino_entry_slab;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c677230699fd..44e1294a3e69 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -35,6 +35,9 @@
 #include <trace/events/f2fs.h>
 #include <uapi/linux/f2fs.h>
 
+EXPORT_TRACEPOINT_SYMBOL_GPL(f2fs_sync_file_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(f2fs_sync_file_exit);
+
 static void f2fs_zero_post_eof_page(struct inode *inode, loff_t new_size)
 {
 	loff_t old_size = i_size_read(inode);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 3cb5242f4ddf..ae153b41058d 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -23,6 +23,9 @@
 #include "iostat.h"
 #include <trace/events/f2fs.h>
 
+EXPORT_TRACEPOINT_SYMBOL_GPL(f2fs_gc_begin);
+EXPORT_TRACEPOINT_SYMBOL_GPL(f2fs_gc_end);
+
 static struct kmem_cache *victim_entry_slab;
 
 static unsigned int count_bits(const unsigned long *addr,
-- 
2.34.1

