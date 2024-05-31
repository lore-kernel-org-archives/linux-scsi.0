Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E638646444;
	Fri, 31 May 2024 07:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141761; cv=none; b=YixSHqq9TI2WXpwSB7f36TzcUeRLve5YN1MGeqqMFbr355PkjBWjjl/uB/he88r/12ZGY6XIv5Zql85yBMZL7AEgU+gKmKCHDlb0JvnLe63a5SUUNO0puNaW1Z3bUsANBkWF6yzOQKtOzb26vwHaK0FhCaQJun7XaShirxL7gpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141761; c=relaxed/simple;
	bh=l1yydhBuBTPhSLIofBFkw+QEyAJdKJg2i+CvuSSs/F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgNpToEadFQ38JrqwlMZ3AxnlLxr0iuzHIsE8UdHip+jlmIPnZmW6HCMWPV+Ka7jj4felEW6teEal002efCbgFN3To8PPIYIa+zqcTWt2KsmqaWeheIgFrp01196Ny8jJsnlF2pPtW5nyrC3K7pgbHCD29gTwah5/HFyfDOWumI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WCl9PeXI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WCl9PeXI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iMhM+qb16rWeYhTsrEp/EIKofeiSWWDmAm8PBvcX+R4=; b=WCl9PeXI0Uir7+ImFplX/mJBQW
	PadlppOJVLv1H1hcpEXK7QPq3XeF2IRiVoWUgG06Bh9FnczQtyVExyMIqaOnNpTw7P9Qo5r7UQf7k
	x5VPZ3bxf0mISNX3yuCLpzW2M7W83yLsnfawyqzrxdNRxcGrvghcagqikIplPccHgDyHAPvaOPDsT
	DoqTeon8mAhFTfO+PnoCohD4y2G9mYvaOBqH16GvMM9OIcnCL2KYbiEGUYtjFOolTa87gmoiBMDX5
	/Rynbgk2G8Gy/kQrHMItE34V5vqmXOweozZLBXWJGVWctwcegjzZ3GIsVcGs9nKQcYFWw/jkzPHqw
	NCqH0Xxg==;
Received: from 2a02-8389-2341-5b80-5ba9-f4da-76fa-44a9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5ba9:f4da:76fa:44a9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCx0l-00000009XmW-2kNJ;
	Fri, 31 May 2024 07:49:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 12/14] sr: convert to the atomic queue limits API
Date: Fri, 31 May 2024 09:48:07 +0200
Message-ID: <20240531074837.1648501-13-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531074837.1648501-1-hch@lst.de>
References: <20240531074837.1648501-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Assign all queue limits through a local queue_limits variable and
queue_limits_commit_update so that we can't race updating them from
multiple places, and free the queue when updating them so that
in-progress I/O submissions don't see half-updated limits.

Also use the chance to clean up variable names to standard ones.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sr.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ab000942b97fc..3f491019103e0c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -111,7 +111,7 @@ static struct lock_class_key sr_bio_compl_lkclass;
 static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
 
-static void get_sectorsize(struct scsi_cd *);
+static int get_sectorsize(struct scsi_cd *);
 static int get_capabilities(struct scsi_cd *);
 
 static unsigned int sr_check_events(struct cdrom_device_info *cdi,
@@ -473,15 +473,15 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	return BLK_STS_IOERR;
 }
 
-static void sr_revalidate_disk(struct scsi_cd *cd)
+static int sr_revalidate_disk(struct scsi_cd *cd)
 {
 	struct scsi_sense_hdr sshdr;
 
 	/* if the unit is not ready, nothing more to do */
 	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
-		return;
+		return 0;
 	sr_cd_check(&cd->cdi);
-	get_sectorsize(cd);
+	return get_sectorsize(cd);
 }
 
 static int sr_block_open(struct gendisk *disk, blk_mode_t mode)
@@ -494,13 +494,16 @@ static int sr_block_open(struct gendisk *disk, blk_mode_t mode)
 		return -ENXIO;
 
 	scsi_autopm_get_device(sdev);
-	if (disk_check_media_change(disk))
-		sr_revalidate_disk(cd);
+	if (disk_check_media_change(disk)) {
+		ret = sr_revalidate_disk(cd);
+		if (ret)
+			goto out;
+	}
 
 	mutex_lock(&cd->lock);
 	ret = cdrom_open(&cd->cdi, mode);
 	mutex_unlock(&cd->lock);
-
+out:
 	scsi_autopm_put_device(sdev);
 	if (ret)
 		scsi_device_put(cd->device);
@@ -685,7 +688,9 @@ static int sr_probe(struct device *dev)
 	blk_pm_runtime_init(sdev->request_queue, dev);
 
 	dev_set_drvdata(dev, cd);
-	sr_revalidate_disk(cd);
+	error = sr_revalidate_disk(cd);
+	if (error)
+		goto unregister_cdrom;
 
 	error = device_add_disk(&sdev->sdev_gendev, disk, NULL);
 	if (error)
@@ -714,13 +719,14 @@ static int sr_probe(struct device *dev)
 }
 
 
-static void get_sectorsize(struct scsi_cd *cd)
+static int get_sectorsize(struct scsi_cd *cd)
 {
+	struct request_queue *q = cd->device->request_queue;
 	static const u8 cmd[10] = { READ_CAPACITY };
 	unsigned char buffer[8] = { };
-	int the_result;
+	struct queue_limits lim;
+	int err;
 	int sector_size;
-	struct request_queue *queue;
 	struct scsi_failure failure_defs[] = {
 		{
 			.result = SCMD_FAILURE_RESULT_ANY,
@@ -736,10 +742,10 @@ static void get_sectorsize(struct scsi_cd *cd)
 	};
 
 	/* Do the command and wait.. */
-	the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN, buffer,
+	err = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN, buffer,
 				      sizeof(buffer), SR_TIMEOUT, MAX_RETRIES,
 				      &exec_args);
-	if (the_result) {
+	if (err) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
 	} else {
@@ -789,10 +795,12 @@ static void get_sectorsize(struct scsi_cd *cd)
 		set_capacity(cd->disk, cd->capacity);
 	}
 
-	queue = cd->device->request_queue;
-	blk_queue_logical_block_size(queue, sector_size);
-
-	return;
+	lim = queue_limits_start_update(q);
+	lim.logical_block_size = sector_size;
+	blk_mq_freeze_queue(q);
+	err = queue_limits_commit_update(q, &lim);
+	blk_mq_unfreeze_queue(q);
+	return err;
 }
 
 static int get_capabilities(struct scsi_cd *cd)
-- 
2.43.0

