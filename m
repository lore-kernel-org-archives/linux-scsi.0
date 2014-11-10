From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/11] scsi: remove ordered_tags scsi_device field
Date: Mon, 10 Nov 2014 16:56:22 +0100
Message-ID: <1415634990-3023-4-git-send-email-hch@lst.de>
References: <1415634990-3023-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaKJP4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 10:56:34 -0500
In-Reply-To: <1415634990-3023-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

Remove the ordered_tags field, we haven't been issuing ordered tags based
on it since the big barrier rework in 2010.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/message/fusion/mptscsih.c    |  5 ++---
 drivers/scsi/bfa/bfad_im.c           | 11 +++--------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 16 ++++------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 +++------------
 drivers/scsi/qla2xxx/qla_os.c        |  5 +----
 drivers/scsi/scsi.c                  | 13 ++-----------
 drivers/scsi/scsi_sysfs.c            | 13 +++++++------
 drivers/scsi/vmw_pvscsi.c            |  4 ++--
 drivers/target/loopback/tcm_loop.c   | 14 +-------------
 include/scsi/scsi_device.h           |  1 -
 include/scsi/scsi_tcq.h              |  9 ---------
 11 files changed, 25 insertions(+), 81 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index e7dcb25..00bd13d 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2400,9 +2400,8 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH,
 				    SCSI_QDEPTH_DEFAULT);
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-		"tagged %d, simple %d, ordered %d\n",
-		ioc->name,sdev->tagged_supported, sdev->simple_tags,
-		sdev->ordered_tags));
+		"tagged %d, simple %d\n",
+		ioc->name,sdev->tagged_supported, sdev->simple_tags));
 
 	blk_queue_dma_alignment (sdev->request_queue, 512 - 1);
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index f067332..99280e8 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -868,14 +868,9 @@ bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 			if (bfa_lun_queue_depth > tmp_sdev->queue_depth) {
 				if (tmp_sdev->id != sdev->id)
 					continue;
-				if (tmp_sdev->ordered_tags)
-					scsi_adjust_queue_depth(tmp_sdev,
-						MSG_ORDERED_TAG,
-						tmp_sdev->queue_depth + 1);
-				else
-					scsi_adjust_queue_depth(tmp_sdev,
-						MSG_SIMPLE_TAG,
-						tmp_sdev->queue_depth + 1);
+				scsi_adjust_queue_depth(tmp_sdev,
+					MSG_SIMPLE_TAG,
+					tmp_sdev->queue_depth + 1);
 
 				itnim->last_ramp_up_time = jiffies;
 			}
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index ec36b91..69dc166 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1246,9 +1246,9 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 
 	if (sdev->inquiry_len > 7)
 		sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), "
-		"simple(%d), ordered(%d), scsi_level(%d), cmd_que(%d)\n",
+		"simple(%d), scsi_level(%d), cmd_que(%d)\n",
 		sdev->queue_depth, sdev->tagged_supported, sdev->simple_tags,
-		sdev->ordered_tags, sdev->scsi_level,
+		sdev->scsi_level,
 		(sdev->inquiry[7] & 2) >> 1);
 
 	return sdev->queue_depth;
@@ -3944,16 +3944,8 @@ _scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		mpi_control = MPI2_SCSIIO_CONTROL_NODATATRANSFER;
 
 	/* set tags */
-	if (!(sas_device_priv_data->flags & MPT_DEVICE_FLAGS_INIT)) {
-		if (scmd->device->tagged_supported) {
-			if (scmd->device->ordered_tags)
-				mpi_control |= MPI2_SCSIIO_CONTROL_ORDEREDQ;
-			else
-				mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
-		} else
-			mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
-	} else
-		mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
+	mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
+
 	/* Make sure Device is not raid volume.
 	 * We do not expose raid functionality to upper layer for warpdrive.
 	 */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 52464ac..d3abf25 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1114,9 +1114,9 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 
 	if (sdev->inquiry_len > 7)
 		sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), " \
-		"simple(%d), ordered(%d), scsi_level(%d), cmd_que(%d)\n",
+		"simple(%d), scsi_level(%d), cmd_que(%d)\n",
 		sdev->queue_depth, sdev->tagged_supported, sdev->simple_tags,
-		sdev->ordered_tags, sdev->scsi_level,
+		sdev->scsi_level,
 		(sdev->inquiry[7] & 2) >> 1);
 
 	return sdev->queue_depth;
@@ -3563,16 +3563,7 @@ _scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		mpi_control = MPI2_SCSIIO_CONTROL_NODATATRANSFER;
 
 	/* set tags */
-	if (!(sas_device_priv_data->flags & MPT_DEVICE_FLAGS_INIT)) {
-		if (scmd->device->tagged_supported) {
-			if (scmd->device->ordered_tags)
-				mpi_control |= MPI2_SCSIIO_CONTROL_ORDEREDQ;
-			else
-				mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
-		} else
-			mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
-	} else
-		mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
+	mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 
 	if ((sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
 	    scmd->cmd_len != 32)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5e75574..1e34fcf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1442,10 +1442,7 @@ static void qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, int qdepth)
 	if (req->max_q_depth <= sdev->queue_depth || req->max_q_depth < qdepth)
 		return;
 
-	if (sdev->ordered_tags)
-		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, qdepth);
-	else
-		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, qdepth);
+	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, qdepth);
 
 	ql_dbg(ql_dbg_io, vha, 0x302a,
 	    "Queue depth adjusted-up to %d for nexus=%ld:%d:%llu.\n",
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9baeff0..22c449e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -789,19 +789,13 @@ void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
 	sdev->queue_depth = tags;
 	switch (tagged) {
 		case 0:
-			sdev->ordered_tags = 0;
 			sdev->simple_tags = 0;
 			break;
 		case MSG_ORDERED_TAG:
-			sdev->ordered_tags = 1;
-			sdev->simple_tags = 1;
-			break;
 		case MSG_SIMPLE_TAG:
-			sdev->ordered_tags = 0;
 			sdev->simple_tags = 1;
 			break;
 		default:
-			sdev->ordered_tags = 0;
 			sdev->simple_tags = 0;
 			sdev_printk(KERN_WARNING, sdev,
 				    "scsi_adjust_queue_depth, bad queue type, "
@@ -857,11 +851,8 @@ int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 		return -1;
 	}
-	
-	if (sdev->ordered_tags)
-		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
-	else
-		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
+
+	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
 	return depth;
 }
 EXPORT_SYMBOL(scsi_track_queue_full);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f4cb7b3..35d93b0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -727,9 +727,7 @@ show_queue_type_field(struct device *dev, struct device_attribute *attr,
 	struct scsi_device *sdev = to_scsi_device(dev);
 	const char *name = "none";
 
-	if (sdev->ordered_tags)
-		name = "ordered";
-	else if (sdev->simple_tags)
+	if (sdev->simple_tags)
 		name = "simple";
 
 	return snprintf(buf, 20, "%s\n", name);
@@ -747,9 +745,12 @@ store_queue_type_field(struct device *dev, struct device_attribute *attr,
 	if (!sdev->tagged_supported || !sht->change_queue_type)
 		return -EINVAL;
 
-	if (strncmp(buf, "ordered", 7) == 0)
-		tag_type = MSG_ORDERED_TAG;
-	else if (strncmp(buf, "simple", 6) == 0)
+	/*
+	 * We're never issueing order tags these days, but allow the value
+	 * for backwards compatibility.
+	 */
+	if (strncmp(buf, "ordered", 7) == 0 ||
+	    strncmp(buf, "simple", 6) == 0)
 		tag_type = MSG_SIMPLE_TAG;
 	else if (strncmp(buf, "none", 4) != 0)
 		return -EINVAL;
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 598f65e..53a3eb6 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -526,9 +526,9 @@ static int pvscsi_change_queue_depth(struct scsi_device *sdev,
 
 	if (sdev->inquiry_len > 7)
 		sdev_printk(KERN_INFO, sdev,
-			    "qdepth(%d), tagged(%d), simple(%d), ordered(%d), scsi_level(%d), cmd_que(%d)\n",
+			    "qdepth(%d), tagged(%d), simple(%d), scsi_level(%d), cmd_que(%d)\n",
 			    sdev->queue_depth, sdev->tagged_supported,
-			    sdev->simple_tags, sdev->ordered_tags,
+			    sdev->simple_tags,
 			    sdev->scsi_level, (sdev->inquiry[7] & 2) >> 1);
 	return sdev->queue_depth;
 }
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 3b9c768..e30932f 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -135,18 +135,6 @@ static int tcm_loop_change_queue_depth(
 	return sdev->queue_depth;
 }
 
-/*
- * Locate the SAM Task Attr from struct scsi_cmnd *
- */
-static int tcm_loop_sam_attr(struct scsi_cmnd *sc, int tag)
-{
-	if (sc->device->tagged_supported &&
-	    sc->device->ordered_tags && tag >= 0)
-		return MSG_ORDERED_TAG;
-
-	return MSG_SIMPLE_TAG;
-}
-
 static void tcm_loop_submission_work(struct work_struct *work)
 {
 	struct tcm_loop_cmd *tl_cmd =
@@ -205,7 +193,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 
 	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			transfer_length, tcm_loop_sam_attr(sc, tl_cmd->sc_cmd_tag),
+			transfer_length, MSG_SIMPLE_TAG,
 			sc->sc_data_direction, 0,
 			scsi_sglist(sc), scsi_sg_count(sc),
 			sgl_bidi, sgl_bidi_count,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 0b18a09..f56175d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -141,7 +141,6 @@ struct scsi_device {
 	unsigned ppr:1;		/* Device supports PPR messages */
 	unsigned tagged_supported:1;	/* Supports SCSI-II tagged queuing */
 	unsigned simple_tags:1;	/* simple queue tag messages are enabled */
-	unsigned ordered_tags:1;/* ordered queue tag messages are enabled */
 	unsigned was_reset:1;	/* There was a bus reset on the bus for 
 				 * this device */
 	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index 032df74..342f38c 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -21,17 +21,11 @@ int scsi_change_queue_type(struct scsi_device *sdev, int tag_type);
 /**
  * scsi_get_tag_type - get the type of tag the device supports
  * @sdev:	the scsi device
- *
- * Notes:
- *	If the drive only supports simple tags, returns MSG_SIMPLE_TAG
- *	if it supports all tag types, returns MSG_ORDERED_TAG.
  */
 static inline int scsi_get_tag_type(struct scsi_device *sdev)
 {
 	if (!sdev->tagged_supported)
 		return 0;
-	if (sdev->ordered_tags)
-		return MSG_ORDERED_TAG;
 	if (sdev->simple_tags)
 		return MSG_SIMPLE_TAG;
 	return 0;
@@ -41,15 +35,12 @@ static inline void scsi_set_tag_type(struct scsi_device *sdev, int tag)
 {
 	switch (tag) {
 	case MSG_ORDERED_TAG:
-		sdev->ordered_tags = 1;
-		/* fall through */
 	case MSG_SIMPLE_TAG:
 		sdev->simple_tags = 1;
 		break;
 	case 0:
 		/* fall through */
 	default:
-		sdev->ordered_tags = 0;
 		sdev->simple_tags = 0;
 		break;
 	}
-- 
1.9.1

