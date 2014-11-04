From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/11] scsi: don't force tagged_supported in drivers
Date: Tue,  4 Nov 2014 08:54:15 +0100
Message-ID: <1415087656-9491-11-git-send-email-hch@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaKDHyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 02:54:25 -0500
In-Reply-To: <1415087656-9491-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

Now that we also get proper values in cmd->request->tag for untagged
commands, there is no need to force tagged_supported to on in drivers
that need host-wide tags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/fnic/fnic_main.c       |  2 --
 drivers/scsi/libsas/sas_scsi_host.c |  1 -
 drivers/scsi/qla4xxx/ql4_os.c       |  9 ---------
 drivers/scsi/scsi_debug.c           |  1 -
 drivers/scsi/stex.c                 | 11 -----------
 drivers/scsi/ufs/ufshcd.c           |  6 +-----
 6 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 0f29e3f..cf1560c 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -95,8 +95,6 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 
-	sdev->tagged_supported = 1;
-
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 56d698a..89e8b68 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -945,7 +945,6 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
 		SAS_DPRINTK("device %llx, LUN %llx doesn't support "
 			    "TCQ\n", SAS_ADDR(dev->sas_addr),
 			    scsi_dev->lun);
-		scsi_dev->tagged_supported = 0;
 		scsi_adjust_queue_depth(scsi_dev, 1);
 	}
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 784f59e..f8724f2 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -162,7 +162,6 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
-static int qla4xxx_slave_configure(struct scsi_device *device);
 static umode_t qla4_attr_is_visible(int param_type, int param);
 static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
 static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int qdepth,
@@ -203,7 +202,6 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.eh_host_reset_handler	= qla4xxx_eh_host_reset,
 	.eh_timed_out		= qla4xxx_eh_cmd_timed_out,
 
-	.slave_configure	= qla4xxx_slave_configure,
 	.slave_alloc		= qla4xxx_slave_alloc,
 	.change_queue_depth	= qla4xxx_change_queue_depth,
 
@@ -9059,7 +9057,6 @@ static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 	ddb = sess->dd_data;
 
 	sdev->hostdata = ddb;
-	sdev->tagged_supported = 1;
 
 	if (ql4xmaxqdepth != 0 && ql4xmaxqdepth <= 0xffffU)
 		queue_depth = ql4xmaxqdepth;
@@ -9068,12 +9065,6 @@ static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-static int qla4xxx_slave_configure(struct scsi_device *sdev)
-{
-	sdev->tagged_supported = 1;
-	return 0;
-}
-
 static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int qdepth,
 				      int reason)
 {
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b44d9ca..fce393f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2700,7 +2700,6 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 	devip = devInfoReg(sdp);
 	if (NULL == devip)
 		return 1;	/* no resources, will be marked offline */
-	sdp->tagged_supported = 1;
 	sdp->hostdata = devip;
 	blk_queue_max_segment_size(sdp->request_queue, -1U);
 	if (scsi_debug_no_uld)
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 2bb8a9e..98a62bc 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -544,21 +544,11 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
 }
 
 static int
-stex_slave_alloc(struct scsi_device *sdev)
-{
-	/* Cheat: usually extracted from Inquiry data */
-	sdev->tagged_supported = 1;
-
-	return 0;
-}
-
-static int
 stex_slave_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
 	sdev->use_10_for_ms = 1;
 	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
-	sdev->tagged_supported = 1;
 
 	return 0;
 }
@@ -1380,7 +1370,6 @@ static struct scsi_host_template driver_template = {
 	.proc_name			= DRV_NAME,
 	.bios_param			= stex_biosparam,
 	.queuecommand			= stex_queuecommand,
-	.slave_alloc			= stex_slave_alloc,
 	.slave_configure		= stex_slave_config,
 	.eh_abort_handler		= stex_abort,
 	.eh_host_reset_handler		= stex_reset,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5eb4931..67e2280 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2695,8 +2695,7 @@ static void ufshcd_set_queue_depth(struct scsi_device *sdev)
 
 	dev_dbg(hba->dev, "%s: activate tcq with queue depth %d\n",
 			__func__, lun_qdepth);
-	if (sdev->tagged_supported)
-		scsi_adjust_queue_depth(sdev, lun_qdepth);
+	scsi_adjust_queue_depth(sdev, lun_qdepth);
 }
 
 /*
@@ -2766,7 +2765,6 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	struct ufs_hba *hba;
 
 	hba = shost_priv(sdev->host);
-	sdev->tagged_supported = 1;
 
 	/* Mode sense(6) is not supported by UFS, so use Mode sense(10) */
 	sdev->use_10_for_ms = 1;
@@ -2806,8 +2804,6 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev,
 	switch (reason) {
 	case SCSI_QDEPTH_DEFAULT:
 	case SCSI_QDEPTH_RAMP_UP:
-		if (!sdev->tagged_supported)
-			depth = 1;
 		scsi_adjust_queue_depth(sdev, depth);
 		break;
 	case SCSI_QDEPTH_QFULL:
-- 
1.9.1

