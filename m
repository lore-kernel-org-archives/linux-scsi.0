Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8723AE704
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 23:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783380636; cv=none; b=TZphy/QY0izkCCOBu4BSAf+dx6tCOPVr4nAIx3n92Im1aMv6XsmvcrDCkbjFXLY4Xdn8iZ8tF/OHNVzJVcRjd4jgAUVACxRjOfN++pjFuUZ0NTPTY1l7VioRFdJGrcAKpvnoEu8iuB5rs9eR+0Zx3fjVHKYFf9zjvJWIY5v2aHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783380636; c=relaxed/simple;
	bh=SLW8WrLBlFCgWLBf7dnpDb/jTAtbAWktNj6RWs4dTvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RDViRlp7Vp0EKoZZB4GA/du1CZPEjQcFEyof8rJ/T2EeKpKeTlcLCkxceMdEjTJ4YahhxsLm6AJCtaAgCRMvUb/+3vCKGavntRn1B+syy6hn7NLUS2W52bsnDDtnF9CZ5MSH7OwhT/QI4mD00+0vA2haD7r7Dqb3UyQwcUfYYYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T989Z/6E; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T989Z/6E"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8eefd0c5f59so24105676d6.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2026 16:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783380633; x=1783985433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OBr+hnnFmHItjtpfNGkl7u5UUjWMDOi9fk/G15N4o2Y=;
        b=T989Z/6Ej/mppJX/sweFwrtgfsA5QzAUvGu+CIlzmRm3ycajwMsXC00I26pgbe4Ntf
         /9PJfzuLjspjbeiendXaIkgGv0RFBARgrmK8d94gKqMddVSzsU2WZeDQKT0BOGPXfdRi
         x4BG8TREtvv/7NUUtHqpD6BP3HLEsJX2FMhvntrdw77Bznx1XZvGeGGoQAgE8DSXNMiR
         LRdeWcbOOkYluHXqRTNDP5H+00FI+TVx0NIgQE+/efcfk+rid0aHL3WXvTirpdRZuUTA
         /qheak8owHgTAI6WSO7FOKyfvosKUgRGxJXam9CxrGFlnuUbrddJCbNV/mTF3sTdywzD
         +d/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783380633; x=1783985433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OBr+hnnFmHItjtpfNGkl7u5UUjWMDOi9fk/G15N4o2Y=;
        b=KczOjTeA2G53SugupaQMNhc8Y5PEmUY+P+pellkrnN7HrTQ1XDRcDIBh6OvpWJsGWi
         p86Gp0lwJ5i6BkKKlMx0f1L0iUutN14MBFRFkjt1qMwcL+VjRzqL3VtIfCGqFwSZL6hR
         RGgQyxbKTbjf5FCkvL/MebxQE+3HSxuaKwZ4wbvTRnxshkoxls6DxRf61mCuU/sT0XgY
         RkROuK5+yNrJqSTN4lZj4egoisWSSKBCe82fD21UqtpFZIt+RyNcG2ALSiIkRf4vYRtp
         h84TAG/SFOlo+rvD673wcODb3qpB6CbKPjsl1umqQwwLKDK0jExvc4Wkzj5KVqYH0vN8
         7iuQ==
X-Gm-Message-State: AOJu0YwmRVFdi2nnbVDuBUUg+ejk7HK474ZjLBSrp6A80akXpRuuf3vj
	JqByKDHgYk+AysfQUIkTGSJeBBTt7gi3zG4e27AYQyqKrYqiAFOlVafNR23kiA==
X-Gm-Gg: AfdE7cl/LWmOlWX3B6VWj9xZTucwBnVwZ8nxIjfaw34kCjrZQ880fXIy4j0gho6QR4M
	i8y1BDyygYe3OUMYxW1x8PlQqxdhCscmksjp5SZuBuXRUud76Bi33Nz+phwnlGpaHCXnWyZ38vm
	1FGMDYfgcw5nZ/slj5ndgogf8qKa4PlYvON1ygJ+nVvI0K0R9ekJssRrY0MQ/ZU0llD6sklxtuN
	+APpkrfkBe1HuBI4zjh8P+TbHsddTP8e7jzL7ThcBsGaQ3EUWATZxbnFHIbuea/ktygQORP6Imm
	XfqZv0dxVTBZVWTeIYww0mDdxwhXtzI0EDX0oPsqGyyZml9wvWayisy3h3htV59i/0jIlUOPLwX
	w5S04K9LxD4ixdpU9qmVXktsp6pZVpZlVBfFgPLgM5m4vyaFCeZn4yld0Pg9gr4hb/oqYM4FPM2
	0KAHzQF0oZjn7yLouvDCtTBnjQgCA7ol7FYdvvjU4BA8RE68nmiQF114JwjFX1yPwWtp5b01NS8
	HDjAklRviG9yzrIENEf
X-Received: by 2002:a05:6214:202b:b0:8f2:8fe9:752e with SMTP id 6a1803df08f44-8fcb4fe943dmr37631566d6.53.1783380632620;
        Mon, 06 Jul 2026 16:30:32 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f46e371bdfsm146137956d6.1.2026.07.06.16.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 16:30:31 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be|_ptr)?\b)
Subject: [PATCHv3] scsi: st: use kzalloc_array()
Date: Mon,  6 Jul 2026 16:30:29 -0700
Message-ID: <20260706233029.814601-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Merge allocations to simplify memory management with kzalloc_array(). No
need to kfree separately.

Add __counted_by for extra runtime analysis. Move counting variable
assignment after allocation as kzalloc_flex() does this with newer
compilers.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v3: typo fix
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

