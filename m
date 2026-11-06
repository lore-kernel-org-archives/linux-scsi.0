Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793971178;
	b=sh3BP0E6+DzlOEmTUTMMZjnoI7kccBd9Ghsd3wQLYCaSKFFXaJKTIKqDz+aFIbJHZfSv
	 +NqCPkOMxFz0lc+nJNdiPGM5e5tDYvLEz+O7UR60lyTL3++gkKtPTKbIkLCCPf950GymW
	 LraxzfjDa5NJ9/uxGCTLcgh9iF9P6OR4bnkXLpSkIG5HEbCd6zOX/AH/add40w9cbJZ5P
	 i58nlvxg+UdFNTctGw/7T3u4tiPPWkLWI3LUfRqQDB7aU85wUBY3vzU9KcuxZ3iQRnQQ1
	 wHoC1tI9e+QBMSPycEJXDe1qe9CCr20wWDWT34xEPXbqe3KkoZRm+7RB1qZitzpg1Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793971178;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OjxbtrTpVECakggq3aaOcAKtXEWGwtyTzHqRGiNRk7Q=;
	b=LW5I+A9fsuPp2f+F9rvfzcRXdANIaaOzI6fhFCo/YJAnTFjuvuFzrUwsDEJpIfAFopUd
	 0WWB5HgUE93EWSwhW2kJdkLi2WjZXDZOsaqnp8oaExTkwVrLxu9wGR5F+VGKDqN6kXttK
	 mnvxX3Wz+WGHarph5TlVu2F9AI9WNb0e265XgavAuHTEUXb7FHdQhR6sroH4EnKm2Nr/1
	 Xl4Y7R4/w4+MvrfMR5SdYkxQHffhl/QHKOV1cUTPWJWSs3bk4icGKkFY8L88rjSFRabMk
	 /H8j6Q/qMv8Dq6bp4VqXg4vm1dfAhpP26sZGmasWaHTpC1ym4y8NPDFeqwIy1lFsZgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=95.215.58.62
Received: from mta1.migadu.com (out-62.mta1.migadu.com [95.215.58.62])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06623606A32E
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 13:19:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06623606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KO2+Pw/HQKx0a4JyoCFPhhmUGDsn7IBoIsdjd3UIB1k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971165; v=1; x=1794575965;
 b=jeFNHfv5f4zmg3psPVOfCRejiIcbH0mRSeUBXfYvbsOUUduFnoh4Xb/lFO75h7OZwr3xb52j
 hl5asAf3vpi1tP7ZCwkufcg0keAVYJ9DH3vunUx+P7OTGGe6hcvnkzOe8I6jXRUX5LbI2tCx1XU
 DqQcY5Z6CBplWlVJlLCwbnXY=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 99a7a9ba11e11fd9;
	Fri, 06 Nov 2026 13:19:24 +0000
X-Mizu-Trace-ID: 99a7a9ba11e11fd9
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
Subject: [PATCH 1/7] scsi: sg and st: account the command buffer memory to memcg
Date: Fri,  6 Nov 2026 21:18:23 +0800
Message-ID: <20261106131829.3228926-2-cui.tao@linux.dev>
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

The sg data buffers are unaccounted: the per-fd reserved buffer, the
scatter-gather page array, and the order-0..N pages behind it, plus the
per-device tape buffer in st.  All of it is user controllable.  The
reserved size is capped only by the device max_sectors, SG_MAX_QUEUE
(16) commands can be in flight per fd, and the fd count is bounded by
RLIMIT_NOFILE.  Nothing is charged to the memcg of the process driving
it.  The September 2026 fixes in sg_build_indirect reshaped the element
sizing and left the accounting alone.

Mark these allocations __GFP_ACCOUNT so the driving process pays for
the memory it induces.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 drivers/scsi/sg.c | 23 ++++++++++++++++++++---
 drivers/scsi/st.c |  7 ++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 6551f1284d44..9c1414479b21 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -911,6 +911,19 @@ static int put_compat_request_table(struct compat_sg_req_info __user *o,
 }
 #endif
 
+/*
+ * The sg passthrough of the blktrace ioctls has the same exposure as the
+ * block device path: holding the node is the only requirement today, and
+ * a created trace outlives the fd.  Must match the gate in
+ * blk_trace_ioctl().
+ */
+static bool sg_is_blktrace_cmd(unsigned int cmd)
+{
+	return cmd == BLKTRACESETUP || cmd == BLKTRACESETUP2 ||
+	       cmd == BLKTRACESTART || cmd == BLKTRACESTOP ||
+	       cmd == BLKTRACETEARDOWN;
+}
+
 static long
 sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 		unsigned int cmd_in, void __user *p)
@@ -920,6 +933,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 	Sg_request *srp;
 	unsigned long iflags;
 
+	if (sg_is_blktrace_cmd(cmd_in) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				   "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
 	read_only = (O_RDWR != (filp->f_flags & O_ACCMODE));
@@ -1829,7 +1845,7 @@ static int
 sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 {
 	int sg_bufflen = tablesize * sizeof(struct page *);
-	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
+	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT;
 
 	schp->pages = kzalloc(sg_bufflen, gfp_flags);
 	if (!schp->pages)
@@ -1844,7 +1860,8 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 	int ret_sz = 0, i, k, rem_sz, num, mx_sc_elems;
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
 	int blk_size = buff_size, order;
-	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
+	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN |
+			 __GFP_ACCOUNT | __GFP_ZERO;
 
 	if (blk_size < 0)
 		return -EFAULT;
@@ -2134,7 +2151,7 @@ sg_add_sfp(Sg_device * sdp)
 	unsigned long iflags;
 	int bufflen;
 
-	sfp = kzalloc_obj(*sfp, GFP_ATOMIC | __GFP_NOWARN);
+	sfp = kzalloc_obj(*sfp, GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!sfp)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e9d41e3cc2dd..b92633ab2757 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4074,7 +4074,7 @@ static struct st_buffer *new_tape_buffer(int max_sg)
 {
 	struct st_buffer *tb;
 
-	tb = kzalloc_obj(struct st_buffer);
+	tb = kzalloc_obj(struct st_buffer, GFP_KERNEL_ACCOUNT);
 	if (!tb) {
 		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
 		return NULL;
@@ -4083,7 +4083,8 @@ static struct st_buffer *new_tape_buffer(int max_sg)
 	tb->use_sg = max_sg;
 	tb->buffer_size = 0;
 
-	tb->reserved_pages = kzalloc_objs(struct page *, max_sg);
+	tb->reserved_pages = kzalloc_objs(struct page *, max_sg,
+					  GFP_KERNEL_ACCOUNT);
 	if (!tb->reserved_pages) {
 		kfree(tb);
 		return NULL;
@@ -4109,7 +4110,7 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size)
 
 	max_segs = STbuffer->use_sg;
 
-	priority = GFP_KERNEL | __GFP_NOWARN;
+	priority = GFP_KERNEL | __GFP_NOWARN | __GFP_ACCOUNT;
 
 	if (STbuffer->cleared)
 		priority |= __GFP_ZERO;
-- 
2.43.0

