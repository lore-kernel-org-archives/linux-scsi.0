Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D2426A1A7
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 01:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782782472; cv=none; b=AXfN6K20DerM2ojnz+2kyrYYQoBvpiXzm1SSYjguBToyBqYBp/6Ptdn8HE1vdRuybuZpMr86O9TMxeTJn8tOzXPX3U5uyEpdvNGfMxcYnFzGk3JHKSx1fHKSWN8LTPw4RjTBG3dFLmqA9JMytL4QFUsKj4u/bxPRo/H5rkaJ9vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782782472; c=relaxed/simple;
	bh=NcHqpszERXjT6L6QRCE5wtLwJT4Wa3f3AWZ6iw/lRs8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LQK+bpPfdj6zMqeKF+mJea5rOAPlxUf5JYl5Pkq5splOX8n8zL1kBQmXCUWy+6Hcv1BuO6JUy7Qt+/ajqXSGtXzAxymIzWJewGdW3Y47ZJBtqTJF5gyqDB7Ve6NSy1eV1GV2Thg/m6cWH/eWVWAWshgb8qMRUvoRhGKT8FTL3RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=knBvwv6t; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knBvwv6t"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c85d4b4245aso2321203a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 18:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782782463; x=1783387263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WLMD0egzUCNwTlRP4H9rot2jquTKrKUwDtaYpTqbx2Q=;
        b=knBvwv6t6gpDSIkRVagkBaMb4sL127quTTaNfXA9w/KDSYq1Sy3vSDVn9ah8lD+d7G
         hwuk+DEaokclsExt3veXJEBNxfxxXhXzg7QqN8qr4S3esXWHRjwO8QKDtwl6/7ML6Lbu
         9YGupVnnTU0dUnM7ZxSszPDCvNh3yDV60AYDZcQlOv1xHJzFcj33CoKvH7fMNMLYCbkF
         9GV4co6il5n+8ZZ+8tFprnOUCxFRH6O5MTTXZdECLVewiTec2MtPdlETiWB05dtyOaZf
         bpW3YHAw3T871Qw9EyPaHovXwP9ZCZZ7gIofcUktvobpbRPPV40myf/HiVj5S7vAOHu4
         QRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782782463; x=1783387263;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLMD0egzUCNwTlRP4H9rot2jquTKrKUwDtaYpTqbx2Q=;
        b=sp576LxMtQtGNQz/DViAQBuKjCMuUKv6aNP4Tso6PQnZVjt+vy0PJyClnV5Qa/k6Zc
         rrMm82+4Jq13knkWcdztg+rxAMutzYu39OZX6x0NziRn+JrdO9xfwoTSukgW6yQKNc4O
         fJCqNQAKuEPxHwJ1tb+CXEfmNOo0smi9t+cdfZbFRjM6sC1TTQmYD+daNKB98oBw6WiN
         T6HCyrMF11gueQnvU4OSRwMECAgFwAE7OhBygMdWap9LHj/EYQErgoCwdIs3vgvZraNJ
         XWyGZmSv+35m4Zm+/ZFaGMcKZJuRVide+jz7J58SxD9SMXOcyU8vaIJmvOQNyqXi7z+f
         MDnQ==
X-Gm-Message-State: AOJu0YxY37DgOOIEiVrI5tRwNT+BkWJBgNEezovXdP32/TplXru4MCZ8
	SdXpwMgL6+c7p0M6XNCRNfu3ncbEIDwVdQJ5SZcLoMmVnCF/+1j25YVKFQOW9NXk
X-Gm-Gg: AfdE7cnu/YQ3x83txooZ309kLnozUP3KKGMFnNig9x/pvhuK4A6wjIxSNW57xezDPXz
	r3ze0HxNJtNpbdzNk0g9bBJYg7085eR+qu6ucY2LJKor2DKyAPjRX0acfRaz57WDWxC1OQ9+VAb
	mqL51qwzju27bOCgGh/EIFUug3gHSPwLOYedsi7eACiiOBIRMpKmnbBSEfLpKRVKioRftba6Ew8
	Zg1yeGemqm5V+VnPgrs7TvP+IyKDMAn1eM+wsIjSM/XDJDv/UqHWBZOLeSWBk5YIezhGcRm1UJ3
	QOS8vUrwOehY1e7XEgLugcnWHNRpoX2SUXqegtvf3Gv2ouzcPwSjo5ibzAMcokazQMPoq+6lgvN
	rgetArLk5Tdc5HunMewQxup1rGjdQp69s2jPwMRgNzQiGvS5zbstjevoZ7lrUORSgbdGmZehlre
	/HQN8zAwLvGohQrYNWNgYGZ6hK+oUsA0H4wDaZuBBcrtM9MalkNr5zHe6nh6ctmsk44emgdbkmk
	SnUP1rbjA==
X-Received: by 2002:a05:6a00:ad89:b0:847:9aa8:d3bb with SMTP id d2e1a72fcca58-8479eed1d30mr1294340b3a.12.1782782463469;
        Mon, 29 Jun 2026 18:21:03 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8479ff8c7b5sm689184b3a.11.2026.06.29.18.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 18:21:02 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be|_ptr)?\b)
Subject: [PATCH] scsi: st: use kzalloc_array
Date: Mon, 29 Jun 2026 18:21:01 -0700
Message-ID: <20260630012101.1461335-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/st.c | 12 +++---------
 drivers/scsi/st.h |  3 ++-
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c4946637..31ae189b18e7 100644
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
2.54.0

