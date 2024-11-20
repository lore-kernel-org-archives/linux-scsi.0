Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B751AA7AE;
	Wed, 20 Nov 2024 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107618; cv=none; b=enGll9zo7+7OwtNGaFjXmnRaN+VzZLJaA3vEq+Anx489tlb77p9IU8esKe00xzO85eoLUQqCHCoY2M55nfibhEdHas87KMhHW11rki4I2d0HLP1fxq55GN0S6cXGWVeVL9HOlY8k8ZEosli2Q8mxCSBIvxwTVOmrDE7vtUA2LcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107618; c=relaxed/simple;
	bh=lnSflGzBTEK00pG99f+FveddFOFgN8Bmzg0DOu60lYE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tKHw9ADN/LS8f2CisFfPnrAPvpuWGxl496+xOiGk82Ee61t/Lj6K3cIGImqWlHllXSiY0C/Scl485m/miGBkYsodMCGw+2/A1+IY5Lz/KY5cjGCW9zdYMdPz27qf/tTgOVMMECIa6Rk2LBVbe28fUhok3XEQRkGwNTi2hMHQWbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=adVLAoln; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="adVLAoln"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3e5f6e44727so2450725b6e.0;
        Wed, 20 Nov 2024 05:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732107615; x=1732712415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EDqOcDIpGKI5hYNE6Sj7mEbCMZ8HdAAjaXY3MTLtetI=;
        b=adVLAolnqT1jnvr6i+SPnZpkK2BxsF7O6Nmj7yuv/u9Z/eKlffQWoQr+DRWCC1pswl
         c//JCKg/VHtc/wVn0QMHRJb2DcyRXPGhSPfI7VT9addtW494b3q/VzuRD1hsWDj59XVq
         OfxdwudFtFrQnfUt/8ii5McSGSCWKfyQpZWcAHZaMg2l6cr3z0NH4oL9bZtWzGj/csNV
         av86TzKfcNqlOo+3NlEVSIttdANKJj5vSOKHkOeCg2DvuTT9CCFAcW5vnTyHDQo2AGCw
         1ao8z7DMXRJ51cuvF+njMftkgOjX1ofOc5EzckUATlL/iBNPp6iUYMYaoHXIfeHMtU4Q
         pz4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732107615; x=1732712415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EDqOcDIpGKI5hYNE6Sj7mEbCMZ8HdAAjaXY3MTLtetI=;
        b=aX8QooZRkfEq2tHzfLzMUHaF9ns5FJk9yRuG6oxj/3EvrxpkCYyAu1zGRLV89QDhIZ
         Koe29JgMfurjN4U4HTEpVBSkvPRAIpnuIeAcfgJfHrDg1M5c2cmjKS2v0jleqXh54QO7
         LSq8OJ9JOsePBS8lcFUN6CVpCRN5TrtnaNUR8l9ASnWJgb3VKtiYdI5bVlujtaTnBShg
         bBUxQz7M/01mTp11eHwHgKc0OeqclrobBHt90yuvpvHjlF+qCLgDWzJ8mFPqNifY8AgM
         Fa+DDnxXxyGLfoWW5w1YNdu7hJjus2+xHYCwrSFPoZXl6du5Vdg81gGPQCAb5ibuRKyj
         53vQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB1Odvk5fGFOh/shIqfMyME+ai0Y9VA9iAyNuo4vFCVNp1alFNKOQui6qIdvculufJvjPYkktlvCCN3g==@vger.kernel.org, AJvYcCWpJ70PFHG+a5uzJA2Zeue6MxnAQV11uVP765Z9tpUfR4WxFBlE2c0RvQ4NLx3sogurQqVYymMkWXOs9rY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI2YOp4OLmsDulqx1BCa7hFg0q6XvHQFh1p2Dt7R+XctEycmFe
	oBLXfEpTT16QxowSkEVWWI5ghTgbbhKxeFi9KUZYlctFFWVnCGnI
X-Google-Smtp-Source: AGHT+IEsDvUDsMBR/Ffo23Ig5BpqckyyMpAfyq8F6YFQdtbAldYWtYa1W2QjOrCPFXyXLI/6QZR1jA==
X-Received: by 2002:a05:6808:1394:b0:3e6:2889:585e with SMTP id 5614622812f47-3e7eb7d3fd6mr2383564b6e.38.1732107614916;
        Wed, 20 Nov 2024 05:00:14 -0800 (PST)
Received: from purva-IdeaPad-Gaming-3-15IHU6.lan ([2409:40c0:11a2:6510:cf5d:dd30:9fe4:5132])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f8c1dae969sm9454719a12.63.2024.11.20.05.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 05:00:14 -0800 (PST)
From: Suraj Sonawane <surajsonawane0215@gmail.com>
To: dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Suraj Sonawane <surajsonawane0215@gmail.com>,
	syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
Subject: [PATCH] scsi: sg: fix slab-use-after-free Read in sg_release
Date: Wed, 20 Nov 2024 18:29:44 +0530
Message-Id: <20241120125944.88095-1-surajsonawane0215@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a use-after-free bug in `sg_release`,
detected by syzbot with KASAN:

BUG: KASAN: slab-use-after-free in lock_release+0x151/0xa30
kernel/locking/lockdep.c:5838
__mutex_unlock_slowpath+0xe2/0x750 kernel/locking/mutex.c:912
sg_release+0x1f4/0x2e0 drivers/scsi/sg.c:407

Root Cause:
In `sg_release`, the function `kref_put(&sfp->f_ref, sg_remove_sfp)`
is called before releasing the `open_rel_lock` mutex. The `kref_put`
call may decrement the reference count of `sfp` to zero, triggering
its cleanup through `sg_remove_sfp`. This cleanup includes scheduling
deferred work via `sg_remove_sfp_usercontext`, which ultimately frees
`sfp`.

After `kref_put`, `sg_release` continues to unlock `open_rel_lock` and
may reference `sfp` or `sdp`. If `sfp` has already been freed, this
results in a slab-use-after-free error.

Fix:
The `kref_put(&sfp->f_ref, sg_remove_sfp)` call is moved after unlocking
the `open_rel_lock` mutex. This ensures:
- No references to `sfp` or `sdp` occur after the reference count is  
  decremented.  
- Cleanup functions such as sg_remove_sfp and sg_remove_sfp_usercontext  
  can safely execute without impacting the mutex handling in `sg_release`. 

The fix has been tested and validated by syzbot. This patch closes the bug
reported at the following syzkaller link and ensures proper sequencing of
resource cleanup and mutex operations, eliminating the risk of
use-after-free errors in `sg_release`.

Reported-by: syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com 
Closes: https://syzkaller.appspot.com/bug?extid=7efb5850a17ba6ce098b 
Tested-by: syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com 
Fixes: cc833acbee9d ("sg: O_EXCL and other lock handling ")
Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f86be197f..457d54171 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -393,7 +393,6 @@ sg_release(struct inode *inode, struct file *filp)
 
 	mutex_lock(&sdp->open_rel_lock);
 	scsi_autopm_put_device(sdp->device);
-	kref_put(&sfp->f_ref, sg_remove_sfp);
 	sdp->open_cnt--;
 
 	/* possibly many open()s waiting on exlude clearing, start many;
@@ -405,6 +404,7 @@ sg_release(struct inode *inode, struct file *filp)
 		wake_up_interruptible(&sdp->open_wait);
 	}
 	mutex_unlock(&sdp->open_rel_lock);
+	kref_put(&sfp->f_ref, sg_remove_sfp);
 	return 0;
 }
 
-- 
2.34.1

