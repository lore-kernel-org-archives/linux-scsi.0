Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40626433E99
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 21:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783115632; cv=none; b=YTyBKtpYeg6RaEZvFfOsg12i8Ti2lbBTGkkSYSPO2KedRn0LlzQ2UWy9zZmMIzFfO64evgr1vFsUp97QY9O2CjrxhiCSwX6XnTzyyPPS/8r3y9R8Ycn6+s8t7+EcgJjgoti3LEF8BD3heNzCUitTdfOCa6Wib/ZkEgyOMN0xq3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783115632; c=relaxed/simple;
	bh=72Sz3QddkifQrNxXKx0x9wIQF0n9ZEE7JMJkeBTc52k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gkpaEahMATkbOEhxK8kMpNv9gKunZOwzqEFJO3but2QG0Tx1dUcwO5Xq1TfU67U7EKr9vwx0WmFz66bX8BuKhl0l3tMAPDxg2D27D7ll8Iengli9a+L6n0ZcoxoNz3RfVVDuq27wBBpyUS/wc/RV461IkYs+A/rzx2tnV2R3LQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BxMTWVk6; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxMTWVk6"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-37e0fb87b75so1090323a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jul 2026 14:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783115629; x=1783720429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rRYClkwdsvHfRU5ObCiwGORJlzT5RqIkavkZCGUIPck=;
        b=BxMTWVk6s9GdIIGTlJOgdxIVZ+nzO1fuyyTxdYHJuA0eBrsSkbuV81J5EsZ+7aNnYz
         yQ1IIahf3wa+jOU+2otpLcX4qOyceLFU5tBOicLcMTbEVtUEaiomadZalHw11ltweez5
         BGgfOIYWANeO01Zkb4RGcvhPlVXlaENFyhcdfa/7sscvs68sbsl5jP8C8ux9vmv23Z17
         eb4vgwvxmhMZ9T5l2d//AMy6TWSvaZzW6EyZ45CtiUPObQKOexWMIYd6GFSXvkEUxN8K
         jIUySMpe4tB1kot1vT4KglCdkQJLkLcPoMnCR72igiA5lg4VN35lRi1Ts59MVBQ01TBB
         z7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783115629; x=1783720429;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rRYClkwdsvHfRU5ObCiwGORJlzT5RqIkavkZCGUIPck=;
        b=S8y+uhw+gcln9wvhazmnt/D+nHySbPOyXk69oyFCag9GweMJ6GhgwTZPHoUvdM4uOO
         uSxzvi2e1pFQfLElDurfrwqoTEW5SDwe5/meNNdYfi1JkLNkTmJ+HU6+iqxbQ+vCBIIq
         l+gn1qcFpMNIpTAuDmBi8nHaa0LIpcVkrOb9yqILooEa/VzWzrgp00hlYIyLTu67P12B
         Cc1i5rhdOQVFYWmliud6gwaY16HVBkNYzYc/xLUGNZaEv+wDSxQPbTCvGEKV9kM/WJKQ
         OWGcaNr6NYxQa0Ow+iFu9pjmWeYwAl/R6gtTPJa0xedNTBY9sRCWxQUGx66yoVSskSr1
         Zz/w==
X-Gm-Message-State: AOJu0YwPnqE/yZlF6UfZrQRWAHLzcluLOqu1xrRKbX8r8TqVXFPMR1yo
	RfxJaxDYMC0/YIF0I35eYxrAE28FB38XGDpHnbjWkHibMJV1vsXNk/okWhfh7w==
X-Gm-Gg: AfdE7cnThKjMsqm86pFX5cPVjOTvEamvAsWy+qxx03Ob5SvrF7VaBkcjpaoJO3/OSOC
	IyCpRBTd+TxA/r6w/qrnBZGAlvUD1CWFrcxD/91TDKw/H35czHzGccm28IC2WEo9qIovPVL6jTa
	ScVdnJ9FaG4M+J7HaxqMPJXjFDxSSborvv5iFD/TEqMBzkjM679BufwAenAZX4PmFmxGhRPyr30
	4Nj4lpfZEy8/OnHSxLGtfqXS1fgL0hfq90T1aPc9zyXV/8yR6hxLY91DWt72bTkBIrtzVVr1Hxk
	K3gFx/kCdk5Ke0qbKJZQFPF3jHFgt6069Uv+s/+5Mz2OL26eRc5axdav4ljL525FGXshlpGjp9C
	LRrQYgDIeCtD124CdJTZMNxPogywogCtH3pEhYoGSGPf+LkpsI5gwFF2QbCBYQ379Ir9hF7L9cM
	yEElWOIVDSIgV0ec66zv5gpxMXB0VKzvAOjhKOHuZz1hELhewTLeHyMRmT/aR5YYHqY2rEy53ZL
	eRUO0zwMg==
X-Received: by 2002:a17:903:2f81:b0:2c9:b8e5:5741 with SMTP id d9443c01a7336-2cbb9ee1c39mr7826865ad.35.1783115629443;
        Fri, 03 Jul 2026 14:53:49 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776577esm14738535ad.39.2026.07.03.14.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 14:53:47 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be|_ptr)?\b)
Subject: [PATCHv2] scsi: st: use kzalloc_array()
Date: Fri,  3 Jul 2026 14:53:45 -0700
Message-ID: <20260703215345.253901-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Merge allocations to simpily memory management with kzalloc_array(). No
need to kfree separately.

Add __counted_by for extra runtime analysis. Move counting variable
assignment after allocation as kzalloc_flex() does this with newer
compilers.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: remove the kfree and add a description.
 drivers/scsi/st.c | 13 +++----------
 drivers/scsi/st.h |  3 ++-
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c4946637..55238f23f743 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -149,7 +149,7 @@ static struct st_dev_parm {
    mode counts */
 static const char *st_formats[] = {
 	"",  "r", "k", "s", "l", "t", "o", "u",
-	"m", "v", "p", "x", "a", "y", "q", "z"};
+	"m", "v", "p", "x", "a", "y", "q", "z"};

 /* The default definitions have been moved to st_options.h */

@@ -3973,21 +3973,15 @@ static struct st_buffer *new_tape_buffer(int max_sg)
 {
 	struct st_buffer *tb;

-	tb = kzalloc_obj(struct st_buffer);
+	tb = kzalloc_flex(*tb, reserved_pages, max_sg);
 	if (!tb) {
 		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
 		return NULL;
 	}
-	tb->frp_segs = 0;
 	tb->use_sg = max_sg;
+	tb->frp_segs = 0;
 	tb->buffer_size = 0;

-	tb->reserved_pages = kzalloc_objs(struct page *, max_sg);
-	if (!tb->reserved_pages) {
-		kfree(tb);
-		return NULL;
-	}
-
 	return tb;
 }

@@ -4533,7 +4527,6 @@ static void scsi_tape_release(struct kref *kref)

 	if (tpnt->buffer) {
 		normalize_buffer(tpnt->buffer);
-		kfree(tpnt->buffer->reserved_pages);
 		kfree(tpnt->buffer);
 	}

diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 0d7c4b8c2c8a..759f4c43d563 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -45,7 +45,6 @@ struct st_buffer {
 	int syscall_result;
 	struct st_request *last_SRpnt;
 	struct st_cmdstatus cmdstat;
-	struct page **reserved_pages;
 	int reserved_page_order;
 	struct page **mapped_pages;
 	struct rq_map_data map_data;
@@ -53,6 +52,8 @@ struct st_buffer {
 	unsigned short use_sg;	/* zero or max number of s/g segments for this adapter */
 	unsigned short sg_segs;		/* number of segments in s/g list */
 	unsigned short frp_segs;	/* number of buffer segments */
+
+	struct page *reserved_pages[] __counted_by(use_sg);
 };

 /* The tape mode definition */
--
2.55.0

