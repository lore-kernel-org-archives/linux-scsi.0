Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDC7133981;
	Tue,  2 Apr 2024 13:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063280; cv=none; b=TsccmIEPIctR+ZFfw+2cXc1BsHyft/salFizviSSsuMoZsQJBGUmA56hBmgO+nYkH683yAzekcNTeY+LMRq9yE66tJzRCdi2rKndhfHbmf/dHOwr021GNGU0r5ifOaD3NbAal8jIdo6x7A8i26Kw8egaBvPCju+CjMTsSW51zKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063280; c=relaxed/simple;
	bh=i47mjYOmH4SGbaHg5BGF4xEWF98ne90KD9OsCjAAexk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XJ+n3k4TjHdCCjXKXw33ZwNKgRVC84o33y6FlQNcHXqnpFUx86gAQrJXelJYnfhveAjRTcT779M7F9saI7WDnfhua+Yovb/T61zI6r17JHhmFuETchx2aK1cG75zs63k4KBRzqdEt3x20K/KggBbKtSyudUSqBoXyIqgE+hE5y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BxyOgfML; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BxyOgfML"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RNf9b509Vynq+6R7KqFWYU/yEB76QcinhbS804cdyao=; b=BxyOgfMLMbW8c/5xWh8BYAbvmp
	J9HF3hJLoUMaHNGthlYls8KDYbAKJoqR4rrl+7ZEPwgLfFpf77ITwj20Fy5TUpTKqeE8jaUGhFeek
	geccKXzVSbg4N1zXXt+6GW6qJAEJflYsdj7CUn7HM3tR6sxf7Vw1nI9xlbpI8chA02d0LT14Vyd/L
	sWwfRFfhJP6MUnR5Lu6isq+KO0mHRHir6TPKF97jIz6bm/bo6ckAf/sxoIB+uU5bN2Njxl6IQQFtx
	OtDrfP0mbC/HRVlmTcNp4LQGHNubxsrIIRBx6hIM9/h1uCPwvodCcpEhDK1u3qZ1Tk9jIWYc1ezlh
	C0glbHaA==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdre-0000000BFmL-3hPB;
	Tue, 02 Apr 2024 13:07:48 +0000
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
Subject: [PATCH 21/23] mpi3mr: switch to using ->device_configure
Date: Tue,  2 Apr 2024 15:06:43 +0200
Message-Id: <20240402130645.653507-22-hch@lst.de>
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

Switch to the ->device_configure method instead of ->slave_configure
and update the block limits on the passed in queue_limits instead
of using the per-limit accessors.

Note that mpi3mr also updates the limits from an event handler that
iterates all SCSI devices.  This is also updated to use the
queue_limits, but the complete locking of this path probably means
it already is completely broken and needs a proper audit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  1 -
 drivers/scsi/mpi3mr/mpi3mr_os.c | 76 ++++++++++++++-------------------
 2 files changed, 31 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 3de1ee05c44e4c..565d6047f68cb8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1348,7 +1348,6 @@ void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout);
 void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_host_io(struct mpi3mr_ioc *mrioc);
 void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc);
-void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_delayed_cmd_lists(struct mpi3mr_ioc *mrioc);
 void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
 void mpi3mr_print_fault_info(struct mpi3mr_ioc *mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 73c831a97d276a..de3e02446c6814 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -986,6 +986,25 @@ static int mpi3mr_change_queue_depth(struct scsi_device *sdev,
 	return retval;
 }
 
+static void mpi3mr_configure_nvme_dev(struct mpi3mr_tgt_dev *tgt_dev,
+		struct queue_limits *lim)
+{
+	u8 pgsz = tgt_dev->dev_spec.pcie_inf.pgsz ? : MPI3MR_DEFAULT_PGSZEXP;
+
+	lim->max_hw_sectors = tgt_dev->dev_spec.pcie_inf.mdts / 512;
+	lim->virt_boundary_mask = (1 << pgsz) - 1;
+}
+
+static void mpi3mr_configure_tgt_dev(struct mpi3mr_tgt_dev *tgt_dev,
+		struct queue_limits *lim)
+{
+	if (tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_PCIE &&
+	    (tgt_dev->dev_spec.pcie_inf.dev_info &
+	     MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) ==
+			MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE)
+		mpi3mr_configure_nvme_dev(tgt_dev, lim);
+}
+
 /**
  * mpi3mr_update_sdev - Update SCSI device information
  * @sdev: SCSI device reference
@@ -1001,31 +1020,17 @@ static void
 mpi3mr_update_sdev(struct scsi_device *sdev, void *data)
 {
 	struct mpi3mr_tgt_dev *tgtdev;
+	struct queue_limits lim;
 
 	tgtdev = (struct mpi3mr_tgt_dev *)data;
 	if (!tgtdev)
 		return;
 
 	mpi3mr_change_queue_depth(sdev, tgtdev->q_depth);
-	switch (tgtdev->dev_type) {
-	case MPI3_DEVICE_DEVFORM_PCIE:
-		/*The block layer hw sector size = 512*/
-		if ((tgtdev->dev_spec.pcie_inf.dev_info &
-		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) ==
-		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE) {
-			blk_queue_max_hw_sectors(sdev->request_queue,
-			    tgtdev->dev_spec.pcie_inf.mdts / 512);
-			if (tgtdev->dev_spec.pcie_inf.pgsz == 0)
-				blk_queue_virt_boundary(sdev->request_queue,
-				    ((1 << MPI3MR_DEFAULT_PGSZEXP) - 1));
-			else
-				blk_queue_virt_boundary(sdev->request_queue,
-				    ((1 << tgtdev->dev_spec.pcie_inf.pgsz) - 1));
-		}
-		break;
-	default:
-		break;
-	}
+
+	lim = queue_limits_start_update(sdev->request_queue);
+	mpi3mr_configure_tgt_dev(tgtdev, &lim);
+	WARN_ON_ONCE(queue_limits_commit_update(sdev->request_queue, &lim));
 }
 
 /**
@@ -1038,8 +1043,7 @@ mpi3mr_update_sdev(struct scsi_device *sdev, void *data)
  *
  * Return: Nothing.
  */
-
-void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
+static void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 {
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
 	struct mpi3mr_stgt_priv_data *tgt_priv;
@@ -4393,15 +4397,17 @@ static void mpi3mr_target_destroy(struct scsi_target *starget)
 }
 
 /**
- * mpi3mr_slave_configure - Slave configure callback handler
+ * mpi3mr_device_configure - Slave configure callback handler
  * @sdev: SCSI device reference
+ * @lim: queue limits
  *
  * Configure queue depth, max hardware sectors and virt boundary
  * as required
  *
  * Return: 0 always.
  */
-static int mpi3mr_slave_configure(struct scsi_device *sdev)
+static int mpi3mr_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim)
 {
 	struct scsi_target *starget;
 	struct Scsi_Host *shost;
@@ -4432,28 +4438,8 @@ static int mpi3mr_slave_configure(struct scsi_device *sdev)
 	sdev->eh_timeout = MPI3MR_EH_SCMD_TIMEOUT;
 	blk_queue_rq_timeout(sdev->request_queue, MPI3MR_SCMD_TIMEOUT);
 
-	switch (tgt_dev->dev_type) {
-	case MPI3_DEVICE_DEVFORM_PCIE:
-		/*The block layer hw sector size = 512*/
-		if ((tgt_dev->dev_spec.pcie_inf.dev_info &
-		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) ==
-		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE) {
-			blk_queue_max_hw_sectors(sdev->request_queue,
-			    tgt_dev->dev_spec.pcie_inf.mdts / 512);
-			if (tgt_dev->dev_spec.pcie_inf.pgsz == 0)
-				blk_queue_virt_boundary(sdev->request_queue,
-				    ((1 << MPI3MR_DEFAULT_PGSZEXP) - 1));
-			else
-				blk_queue_virt_boundary(sdev->request_queue,
-				    ((1 << tgt_dev->dev_spec.pcie_inf.pgsz) - 1));
-		}
-		break;
-	default:
-		break;
-	}
-
+	mpi3mr_configure_tgt_dev(tgt_dev, lim);
 	mpi3mr_tgtdev_put(tgt_dev);
-
 	return retval;
 }
 
@@ -4921,7 +4907,7 @@ static const struct scsi_host_template mpi3mr_driver_template = {
 	.queuecommand			= mpi3mr_qcmd,
 	.target_alloc			= mpi3mr_target_alloc,
 	.slave_alloc			= mpi3mr_slave_alloc,
-	.slave_configure		= mpi3mr_slave_configure,
+	.device_configure		= mpi3mr_device_configure,
 	.target_destroy			= mpi3mr_target_destroy,
 	.slave_destroy			= mpi3mr_slave_destroy,
 	.scan_finished			= mpi3mr_scan_finished,
-- 
2.39.2

