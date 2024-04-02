Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2FE8288A;
	Tue,  2 Apr 2024 13:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063226; cv=none; b=BWqKVYqzkmJa4AAsq+CuWQheupmsXcl5awj9G0pJ6zS+i82pRQ5WNKB3DeNjswDVEBX5nzEIO8RGymY2PYalQ8juDm7a8CXxQdiYOgGOq9MIrsXoQJVxXfhrRcrAtqZPw7RmDlYUmmIIfGNW1AmWYNNhBHulj+Kk5Ahx3aBFwGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063226; c=relaxed/simple;
	bh=cdA7xq9q4QKBVX4NhlZS97yZMdp+l/+frA4s/zSI0Pc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QDMaz/8p7gZ7d0nCb4yBsguesIxieC7XvjnIyt9kYJ7GiWC8nV6sos6RPxOyx+SNaLvkbua2Av/3ZoHelKiQnuiCUMfSyk7zmiuefa6Ik2rjIDvmHbYkja1TCx4I6dKTSPNsCPf7KFA1mmpxTpXcx1sVtdD49OuLPJg1ymfmfPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1LDi0Lo2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1LDi0Lo2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lyFay2MEWHGjyJkVgKdY3+4m9YXmReiC41jMUT85tAI=; b=1LDi0Lo2U+Q5RD0oIXU4tFxmok
	MpGqpVj8dmD2YT1fCyEhnwtlMTuJjPg2B/4My8V6TTEogzr9jlRtDWATw0lx8Lf5Nl7pZnbX69PXf
	78ooWufQ5fRAM99uOqtJCPUz5V2z7Fq5qrTR2SiIfvFdvjJVbufNZENyKVmJS4QczEIlIcvpZ7Zii
	M+N0uf83bSfupJDEI3vOg/DfIa5lNhswRKGAhb5zHjsaGbKwNokA59De6rhn6w6wk8XlaW4vyj+sy
	40bLItnfXcN0xLvB1L209s4SaGijuIKjrmsCWzUpX8qzoTXO+kq2kvge++J7MQu5+sDhwL1nxYWnK
	bk3OLpkA==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdqm-0000000BFJv-2anh;
	Tue, 02 Apr 2024 13:06:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 02/23] bsg: pass queue_limits to bsg_setup_queue
Date: Tue,  2 Apr 2024 15:06:24 +0200
Message-Id: <20240402130645.653507-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240402130645.653507-1-hch@lst.de>
References: <20240402130645.653507-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This allows bsg_setup_queue to pass them to blk_mq_alloc_queue and thus
set up the limits at queue allocation time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/bsg-lib.c                     | 6 ++++--
 drivers/scsi/mpi3mr/mpi3mr_app.c    | 2 +-
 drivers/scsi/scsi_transport_fc.c    | 6 +++---
 drivers/scsi/scsi_transport_iscsi.c | 3 ++-
 drivers/scsi/scsi_transport_sas.c   | 4 ++--
 drivers/ufs/core/ufs_bsg.c          | 3 ++-
 include/linux/bsg-lib.h             | 3 ++-
 7 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index bcc7dee6abced6..ee738d129a9f5e 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -354,12 +354,14 @@ static const struct blk_mq_ops bsg_mq_ops = {
  * bsg_setup_queue - Create and add the bsg hooks so we can receive requests
  * @dev: device to attach bsg device to
  * @name: device to give bsg device
+ * @lim: queue limits for the bsg queue
  * @job_fn: bsg job handler
  * @timeout: timeout handler function pointer
  * @dd_job_size: size of LLD data needed for each job
  */
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
-		bsg_job_fn *job_fn, bsg_timeout_fn *timeout, int dd_job_size)
+		struct queue_limits *lim, bsg_job_fn *job_fn,
+		bsg_timeout_fn *timeout, int dd_job_size)
 {
 	struct bsg_set *bset;
 	struct blk_mq_tag_set *set;
@@ -383,7 +385,7 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 	if (blk_mq_alloc_tag_set(set))
 		goto out_tag_set;
 
-	q = blk_mq_alloc_queue(set, NULL, NULL);
+	q = blk_mq_alloc_queue(set, lim, NULL);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
 		goto out_queue;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 55d590b919476e..ce5445eb9d0e4e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1853,7 +1853,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
-	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev),
+	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), NULL,
 			mpi3mr_bsg_request, NULL, 0);
 	if (IS_ERR(mrioc->bsg_queue)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index b04075f19445dc..87b2235b8ece45 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -4287,8 +4287,8 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	snprintf(bsg_name, sizeof(bsg_name),
 		 "fc_host%d", shost->host_no);
 
-	q = bsg_setup_queue(dev, bsg_name, fc_bsg_dispatch, fc_bsg_job_timeout,
-				i->f->dd_bsg_size);
+	q = bsg_setup_queue(dev, bsg_name, NULL, fc_bsg_dispatch,
+			fc_bsg_job_timeout, i->f->dd_bsg_size);
 	if (IS_ERR(q)) {
 		dev_err(dev,
 			"fc_host%d: bsg interface failed to initialize - setup queue\n",
@@ -4318,7 +4318,7 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 	if (!i->f->bsg_request)
 		return -ENOTSUPP;
 
-	q = bsg_setup_queue(dev, dev_name(dev), fc_bsg_dispatch_prep,
+	q = bsg_setup_queue(dev, dev_name(dev), NULL, fc_bsg_dispatch_prep,
 				fc_bsg_job_timeout, i->f->dd_bsg_size);
 	if (IS_ERR(q)) {
 		dev_err(dev, "failed to setup bsg queue\n");
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index af3ac6346796ba..c131746bf20777 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1542,7 +1542,8 @@ iscsi_bsg_host_add(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)
 		return -ENOTSUPP;
 
 	snprintf(bsg_name, sizeof(bsg_name), "iscsi_host%d", shost->host_no);
-	q = bsg_setup_queue(dev, bsg_name, iscsi_bsg_host_dispatch, NULL, 0);
+	q = bsg_setup_queue(dev, bsg_name, NULL, iscsi_bsg_host_dispatch, NULL,
+			0);
 	if (IS_ERR(q)) {
 		shost_printk(KERN_ERR, shost, "bsg interface failed to "
 			     "initialize - no request queue\n");
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index d704c484a251c5..424a89513814b4 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -197,7 +197,7 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 	}
 
 	if (rphy) {
-		q = bsg_setup_queue(&rphy->dev, dev_name(&rphy->dev),
+		q = bsg_setup_queue(&rphy->dev, dev_name(&rphy->dev), NULL,
 				sas_smp_dispatch, NULL, 0);
 		if (IS_ERR(q))
 			return PTR_ERR(q);
@@ -206,7 +206,7 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 		char name[20];
 
 		snprintf(name, sizeof(name), "sas_host%d", shost->host_no);
-		q = bsg_setup_queue(&shost->shost_gendev, name,
+		q = bsg_setup_queue(&shost->shost_gendev, name, NULL,
 				sas_smp_dispatch, NULL, 0);
 		if (IS_ERR(q))
 			return PTR_ERR(q);
diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 374e5aae4e7e86..433d0480391ea6 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -253,7 +253,8 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
-	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), ufs_bsg_request, NULL, 0);
+	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), NULL, ufs_bsg_request,
+			NULL, 0);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
 		goto out;
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 9e97ced2896df2..14fa93268630ed 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -65,7 +65,8 @@ struct bsg_job {
 void bsg_job_done(struct bsg_job *job, int result,
 		  unsigned int reply_payload_rcv_len);
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
-		bsg_job_fn *job_fn, bsg_timeout_fn *timeout, int dd_job_size);
+		struct queue_limits *lim, bsg_job_fn *job_fn,
+		bsg_timeout_fn *timeout, int dd_job_size);
 void bsg_remove_queue(struct request_queue *q);
 void bsg_job_put(struct bsg_job *job);
 int __must_check bsg_job_get(struct bsg_job *job);
-- 
2.39.2

