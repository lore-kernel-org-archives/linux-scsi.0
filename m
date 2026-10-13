Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B9A3E5EF8
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898032; cv=none; b=aQYOR8UeWfiIvSiAm0hOyq3f0ObhAJXcD6Bi4BfpsY0qSTlUHH0vkBrTFeemvjPjdhBNZfdHiRWhpFPTZmQ3t69fGtejUnop2p8zoT7VKhdWnpAXzJM7mVoRG3qtbIeI/3nj6MAGfJIWnjztqDBcfb3nVfddvqJO81+2TTaU0W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898032; c=relaxed/simple;
	bh=NWurmtMdk1iCQy/jvDuOguTbKlkAdVuo1eJca4ASPNw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=o4FG3H+kgYCf9ku46vo46xN7ZnXkKw9oQg5Qz/ERWPzx/bmXFMsc8kxPJ5FHEeeszBC5BcOTOCnkQ1J0yodITSwu6DA5pncNp71pvlmjmMpSfwbk9kiBkwlxR5rsNOPKKCE2FS+ehicpy7Oic3xQn0a5Qe58UMoNYC7aLR8q1zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jmOJo0Of; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jmOJo0Of"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfa4e4684bso47575255ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 06:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791898030; x=1792502830; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tz3XQeMDsa80BNjtP5zSjVPIr7ggAOeydAFlJIaMfm8=;
        b=jmOJo0OftGkdbVMB3g6vPDk0m4TxC++Wsw+hQSAC9FYLT5Q92oL2+9ac4pWD/Rzb8r
         2EIjYvnyKAP24gBE9MSD7a8zrOdJrQmx/eLuTpVmAREN/Tf6/RsVD2quOlabdx7vJ2x0
         qBp53qJ627FXtFkdVTHmV44JrifmbMIY0Fiiq41Kg24Zr3b5nkIhn3E8yFkNpgGko2k0
         tIdzFiCSU64zCPcJR70SmAuoj8VG5ZGs6WigWGsquClO+nl0QVSKw9w6XeaQJT9bSYg4
         oK3qfsoanh0oS5uRvLxDJ349NEnMwXy8FAAd7HABJHXbY0blcEW0/yY8IlgKOFywcXTW
         6qcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791898030; x=1792502830;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tz3XQeMDsa80BNjtP5zSjVPIr7ggAOeydAFlJIaMfm8=;
        b=vF/cR4kULY9h7zfxLzHFGW7muu+F+KeOrgLXLKykQsWOBlv4MVSJJrsB/1tOsdt6Gi
         iYWKSq2Tla5kgwUseuvU6l+0S2eMVBPm0myzVNyasVTCaMT+z5Gw/0rqzEsCb5f13Lvk
         MYrCd0uywtXg0aj41YiQU2HDAwZFRghEg9QrqDvcEDNmohGNKu0c1rsu/hco0yjE9/4F
         BdxjyA2sNOZgv+WfNeSj915RVXp69oy5qkd1t+yFYHzYmIbbdB7W/5SquFOzqMRIseqZ
         Yoih7BmOeV5Jb61vzSrUPsnQjUsL/SpcT+N8d2E1M1HGsVTTTiDepz+k0+Mi5hE1E86d
         FqbQ==
X-Forwarded-Encrypted: i=1; AKwUvBy4DLdAXeOi6khgYQ9Ir/CyMc97QV+083hnGpSsmZOoKR+cGcY4bHajeGPFiupZW3vZshmckqQQbkwJ@vger.kernel.org
X-Gm-Message-State: AFq9FYLFQLKwshC5VRbEANOYnNq3BFE5NJSgSW9G1t7uj5VV6wI2jjOi
	T4ZyJL6iRH8vKmaJFPzaQiydTrW5Gx697a1QoSlDPq8JIVQyUY2lRsf5QnXvUYqsf8boM6MiGzr
	X7TDRSWXRfFAzaMrbUCcO8g==
X-Received: from plbjx17.prod.google.com ([2002:a17:903:1391:b0:2e9:64c:38da])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f60e:b0:2e7:ff92:25f5 with SMTP id d9443c01a7336-2e8431428b2mr100542525ad.61.1791898030303;
 Tue, 13 Oct 2026 06:27:10 -0700 (PDT)
Date: Tue, 13 Oct 2026 21:27:08 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013132708.1669415-1-stanleyjhu@google.com>
Subject: [PATCH] scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS
 ARPMB replies
From: Stanley Jhu <stanleyjhu@google.com>
To: Jens Axboe <axboe@kernel.dk>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, 
	Mike Christie <michael.christie@oracle.com>, Bean Huo <beanhuo@micron.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	mpi3mr-linuxdrv.pdl@broadcom.com, open-iscsi@googlegroups.com, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

bsg-lib allocates a 96-byte (SCSI_SENSE_BUFFERSIZE) reply buffer per
job, but struct ufs_rpmb_reply is 104 bytes: a 40-byte struct
ufs_bsg_reply followed by a 64-byte EHS. When an Advanced RPMB command
returns an EHS, ufshcd_advanced_rpmb_req_handler() copies it right
after the 40-byte header and writes 8 bytes past the end of the buffer.

Let each BSG transport pass its reply buffer size to bsg_setup_queue()
and have ufs_bsg request sizeof(struct ufs_rpmb_reply), so the full
reply reaches user space. Other transports keep SCSI_SENSE_BUFFERSIZE.

Fixes: 6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support in ufs_bsg")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
Tested on QEMU arm64 with KASAN: the reproducer no longer triggers.

 block/bsg-lib.c                     | 13 ++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_app.c    |  2 +-
 drivers/scsi/scsi_transport_fc.c    |  6 ++++--
 drivers/scsi/scsi_transport_iscsi.c |  2 +-
 drivers/scsi/scsi_transport_sas.c   |  6 ++++--
 drivers/ufs/core/ufs_bsg.c          |  2 +-
 include/linux/bsg-lib.h             |  3 ++-
 7 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 895db30a7033..536cee4430a7 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -23,11 +23,14 @@ struct bsg_set {
 	struct bsg_device	*bd;
 	bsg_job_fn		*job_fn;
 	bsg_timeout_fn		*timeout_fn;
+	unsigned int		reply_len;
 };
 
 static int bsg_transport_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 		bool open_for_write, unsigned int timeout)
 {
+	struct bsg_set *bset =
+		container_of(q->tag_set, struct bsg_set, tag_set);
 	struct bsg_job *job;
 	struct request *rq;
 	struct bio *bio;
@@ -50,7 +53,7 @@ static int bsg_transport_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	reply = job->reply;
 	memset(job, 0, sizeof(*job));
 	job->reply = reply;
-	job->reply_len = SCSI_SENSE_BUFFERSIZE;
+	job->reply_len = bset->reply_len;
 	job->dd_data = job + 1;
 
 	job->request_len = hdr->request_len;
@@ -301,9 +304,10 @@ static blk_status_t bsg_queue_rq(struct blk_mq_hw_ctx *hctx,
 static int bsg_init_rq(struct blk_mq_tag_set *set, struct request *req,
 		       unsigned int hctx_idx, int numa_node)
 {
+	struct bsg_set *bset = container_of(set, struct bsg_set, tag_set);
 	struct bsg_job *job = blk_mq_rq_to_pdu(req);
 
-	job->reply = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+	job->reply = kzalloc(bset->reply_len, GFP_KERNEL);
 	if (!job->reply)
 		return -ENOMEM;
 	return 0;
@@ -358,10 +362,12 @@ static const struct blk_mq_ops bsg_mq_ops = {
  * @job_fn: bsg job handler
  * @timeout: timeout handler function pointer
  * @dd_job_size: size of LLD data needed for each job
+ * @reply_len: size of the reply buffer needed for each job
  */
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 		struct queue_limits *lim, bsg_job_fn *job_fn,
-		bsg_timeout_fn *timeout, int dd_job_size)
+		bsg_timeout_fn *timeout, int dd_job_size,
+		unsigned int reply_len)
 {
 	struct bsg_set *bset;
 	struct blk_mq_tag_set *set;
@@ -374,6 +380,7 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 
 	bset->job_fn = job_fn;
 	bset->timeout_fn = timeout;
+	bset->reply_len = reply_len;
 
 	set = &bset->tag_set;
 	set->ops = &bsg_mq_ops;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 1353a8ff9c85..094490713d69 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -3053,7 +3053,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 	}
 
 	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
-			mpi3mr_bsg_request, NULL, 0);
+			mpi3mr_bsg_request, NULL, 0, SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
 		    dev_name(bsg_dev));
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 173ed6373f04..b66365a382c7 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -4345,7 +4345,8 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	scsi_init_limits(shost, &lim);
 	lim.max_segments = min_not_zero(lim.max_segments, i->f->max_bsg_segments);
 	q = bsg_setup_queue(dev, bsg_name, &lim, fc_bsg_dispatch,
-			fc_bsg_job_timeout, i->f->dd_bsg_size);
+			fc_bsg_job_timeout, i->f->dd_bsg_size,
+			SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		dev_err(dev,
 			"fc_host%d: bsg interface failed to initialize - setup queue\n",
@@ -4378,7 +4379,8 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 	scsi_init_limits(shost, &lim);
 	lim.max_segments = min_not_zero(lim.max_segments, i->f->max_bsg_segments);
 	q = bsg_setup_queue(dev, dev_name(dev), &lim, fc_bsg_dispatch_prep,
-				fc_bsg_job_timeout, i->f->dd_bsg_size);
+				fc_bsg_job_timeout, i->f->dd_bsg_size,
+				SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		dev_err(dev, "failed to setup bsg queue\n");
 		return PTR_ERR(q);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 8aa76f813bcd..b50ff8a1d0a9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1545,7 +1545,7 @@ iscsi_bsg_host_add(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)
 	snprintf(bsg_name, sizeof(bsg_name), "iscsi_host%d", shost->host_no);
 	scsi_init_limits(shost, &lim);
 	q = bsg_setup_queue(dev, bsg_name, &lim, iscsi_bsg_host_dispatch, NULL,
-			0);
+			0, SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		shost_printk(KERN_ERR, shost, "bsg interface failed to "
 			     "initialize - no request queue\n");
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index d689b9ed08a6..a825966f60e5 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -199,7 +199,8 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 
 	if (rphy) {
 		q = bsg_setup_queue(&rphy->dev, dev_name(&rphy->dev), NULL,
-				sas_smp_dispatch, NULL, 0);
+				sas_smp_dispatch, NULL, 0,
+				SCSI_SENSE_BUFFERSIZE);
 		if (IS_ERR(q))
 			return PTR_ERR(q);
 		rphy->q = q;
@@ -208,7 +209,8 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 
 		snprintf(name, sizeof(name), "sas_host%d", shost->host_no);
 		q = bsg_setup_queue(&shost->shost_gendev, name, NULL,
-				sas_smp_dispatch, NULL, 0);
+				sas_smp_dispatch, NULL, 0,
+				SCSI_SENSE_BUFFERSIZE);
 		if (IS_ERR(q))
 			return PTR_ERR(q);
 		to_sas_host_attrs(shost)->q = q;
diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 7a66917b3fc0..156637dd76c8 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -258,7 +258,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 		goto out;
 
 	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), NULL, ufs_bsg_request,
-			NULL, 0);
+			NULL, 0, sizeof(struct ufs_rpmb_reply));
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
 		device_del(bsg_dev);
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 14fa93268630..a697246feeac 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -66,7 +66,8 @@ void bsg_job_done(struct bsg_job *job, int result,
 		  unsigned int reply_payload_rcv_len);
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 		struct queue_limits *lim, bsg_job_fn *job_fn,
-		bsg_timeout_fn *timeout, int dd_job_size);
+		bsg_timeout_fn *timeout, int dd_job_size,
+		unsigned int reply_len);
 void bsg_remove_queue(struct request_queue *q);
 void bsg_job_put(struct bsg_job *job);
 int __must_check bsg_job_get(struct bsg_job *job);
-- 
2.56.0.385.gd3acb90ef8-goog

