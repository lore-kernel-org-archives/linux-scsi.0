Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.162
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793971246;
	b=yiD88g0Hft3TdrIV1DzFKRpWlgtpQING6A3VsPY0NpAdB14XDhz5pHuAflciMiRmQrus
	 5O9CAwMfI2r/TpicblHVqtBl/9mRztbij4+SI00cWErxWNMJJT0l02xc04Fgy0q7Xg7BG
	 UxMAQwL8XyHdwbkzivoShBU0/ZQf1q0U9oCx5tZfhngsUImDMgGiAMXkd5dh3O8XlL97+
	 +VzXEVwtI8/oyLUQwQcdgjBHH8gTJoBhZAty3fPtsE4iC7zv4hlmaDKMmW6+mp0bo3zoH
	 g0kcRWTnsh0VzbUXxhMZbzaihxgxkx1gy1LxnOhCyGEVW+gwjlsSjpyCNtMATdE2BNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793971246;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fUXCYLhn52D7jjqtCGZ+7rWovE/XUiCSennV1JjWXTc=;
	b=NOa3kwM2sXYvrkvE9KwxPvsgx6Tv/v3mx5l3CmOO/pv8rfjFD5DIoWmo+bOUofmS/fqf
	 9X4CRAsOOy9BRhy10FljhMVxMUgotefA87hhWFqFmOuQiZRH/657naYyfTeDq0kvs9Dey
	 JcvRTAGMpi2+QeSn2OSmGbFGcyPGtQRHEMRNOmt12w/99zLr64SqwtcMG0haZYQjxSn3M
	 VLCBMW7tP6nsIdRYL99TBIqQ6opxdYqC8RyRU1Y+VN6Sw94fp3hQo71aJbQmxeIZnwyIF
	 stbfdxPURWFMOiwDJK3LgyC1aiqrP9ggT+cg5eNGiHEYdIjRZqa0VZRB12gXzEaHBJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AWU+oP3u;
	arc=none smtp.remote-ip=91.218.175.162
Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC0D606A32C
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 13:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DC0D606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AWU+oP3u
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ojgBXCCljWWMx/by6O5nBZ1cYADUOJnAnHqRvmqKFno=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971243; v=1; x=1794576043;
 b=AWU+oP3uE+Bp9M4NHthTv7q7awqULRAk7AJ+yUdGd8HP3gv4OZ3L3y2iim+wbp8ZY+SmjP6f
 RQOZ8k1aHyjLLkndQT62PYK+Mb5tL6fxCe7tCZ6NDOnwdYBj1Z+KZlsMEmliGrhC5h4dkKcDQnt
 /zsj+KNoWYeiGHHuaHTmkkzg=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fd2f547758ebbf7f;
	Fri, 06 Nov 2026 13:20:43 +0000
X-Mizu-Trace-ID: fd2f547758ebbf7f
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: akpm@linux-foundation.org,
	dgilbert@interlog.com,
	mkp@kernel.org,
	loberman@redhat.com,
	jmeneghi@redhat.com,
	kraxel@redhat.com,
	vivek.kasireddy@intel.com,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	stefanha@redhat.com,
	sgarzare@redhat.com,
	rostedt@goodmis.org,
	vdonnefort@google.com,
	mhiramat@kernel.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	axboe@kernel.dk
Cc: linux-mm@kvack.org,
	James.Bottomley@HansenPartnership.com,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	phasta@kernel.org,
	joro@8bytes.org,
	will@kernel.org,
	linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com,
	robin.murphy@arm.com,
	mason@kernel.org,
	aesteve@redhat.com,
	tjmercier@google.com,
	harry@kernel.org,
	vbabka@suse.cz,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH 6/7] io_uring: account the ring context and SQPOLL thread data to memcg
Date: Fri,  6 Nov 2026 21:18:28 +0800
Message-ID: <20261106131829.3228926-7-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106131829.3228926-1-cui.tao@linux.dev>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

The io_ring_ctx and the SQPOLL io_sqd are the last per-ring allocations
made with plain GFP_KERNEL.  The larger surfaces around them are
already charged: io_mapped_ubuf and io_rsrc_node since commit
075d5837bafc ("io_uring/rsrc: charge buffer arrays and nodes to memcg"),
the tctx node and its XArrays since commit 0b34e7b20a48 ("io_uring:
charge tctx nodes and personalities").

Charge the context and the SQPOLL thread data the same way.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 io_uring/io_uring.c | 2 +-
 io_uring/rsrc.c     | 3 ++-
 io_uring/sqpoll.c   | 2 +-
 io_uring/tctx.c     | 4 ++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 03724419c4e1..d39cdde49a9f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -229,7 +229,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	int hash_bits;
 	bool ret;
 
-	ctx = kzalloc_obj(*ctx);
+	ctx = kzalloc_obj(*ctx, GFP_KERNEL_ACCOUNT);
 	if (!ctx)
 		return NULL;
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e0345c3e764e..9a971c983686 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -825,7 +825,8 @@ static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
 	unsigned i, j;
 
 	/* Store head pages only*/
-	new_array = kvmalloc_objs(struct page *, nr_folios);
+	new_array = kvmalloc_objs(struct page *, nr_folios,
+				  GFP_KERNEL_ACCOUNT);
 	if (!new_array)
 		return false;
 
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index d387488db2de..b82d3a285337 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -172,7 +172,7 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
 			return sqd;
 	}
 
-	sqd = kzalloc_obj(*sqd);
+	sqd = kzalloc_obj(*sqd, GFP_KERNEL_ACCOUNT);
 	if (!sqd)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index b4fecea3ea47..6673393100ec 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -23,7 +23,7 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 	mutex_lock(&ctx->uring_lock);
 	hash = ctx->hash_map;
 	if (!hash) {
-		hash = kzalloc_obj(*hash);
+		hash = kzalloc_obj(*hash, GFP_KERNEL_ACCOUNT);
 		if (!hash) {
 			mutex_unlock(&ctx->uring_lock);
 			return ERR_PTR(-ENOMEM);
@@ -85,7 +85,7 @@ __cold struct io_uring_task *io_uring_alloc_task_context(struct task_struct *tas
 	struct io_uring_task *tctx;
 	int ret;
 
-	tctx = kzalloc_obj(*tctx);
+	tctx = kzalloc_obj(*tctx, GFP_KERNEL_ACCOUNT);
 	if (unlikely(!tctx))
 		return ERR_PTR(-ENOMEM);
 
-- 
2.43.0

