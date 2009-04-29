From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] block: add rq->resid_len
Date: Wed, 29 Apr 2009 18:13:41 +0900
Message-ID: <1240996428-10159-4-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
Cc: Tejun Heo <tj@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

rq->data_len served two purposes - the length of data buffer on issue
and the residual count on completion.  This duality creates some
headaches.

First of all, block layer and low level drivers can't really determine
what rq->data_len contains while a request is executing.  It could be
the total request length or it coulde be anything else one of the
lower layers is using to keep track of residual count.  This
complicates things because blk_rq_bytes() and thus
[__]blk_end_request_all() relies on rq->data_len for PC commands.
Drivers which want to report residual count should first cache the
total request length, update rq->data_len and then complete the
request with the cached data length.

Secondly, it makes requests default to reporting full residual count,
ie. reporting that no data transfer occurred.  The residual count is
an exception not the norm; however, the driver should clear
rq->data_len to zero to signify the normal cases while leaving it
alone means no data transfer occurred at all.  This reverse default
behavior complicates code unnecessarily and renders block PC on some
drivers (ide-tape/floppy) unuseable.

This patch adds rq->resid_len which is used only for residual count.

While at it, remove now unnecessasry blk_rq_bytes() caching in
ide_pc_intr() as rq->data_len is not changed anymore.

[ Impact: cleanup residual count handling, report 0 resid by default ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
---
 block/bsg.c                              |    8 +++---
 block/scsi_ioctl.c                       |    2 +-
 drivers/block/cciss.c                    |   13 +++-------
 drivers/block/ub.c                       |    6 +---
 drivers/ide/ide-atapi.c                  |    9 +------
 drivers/ide/ide-cd.c                     |   13 ++++------
 drivers/ide/ide-tape.c                   |    4 +-
 drivers/message/fusion/mptsas.c          |    3 +-
 drivers/scsi/libsas/sas_expander.c       |    6 +----
 drivers/scsi/libsas/sas_host_smp.c       |   38 +++++++++++++++--------------
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    4 +--
 drivers/scsi/scsi_lib.c                  |   24 +++++++++---------
 drivers/scsi/sg.c                        |    2 +-
 drivers/scsi/st.c                        |    2 +-
 include/linux/blkdev.h                   |    1 +
 15 files changed, 57 insertions(+), 78 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 206060e..2d746e3 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -445,14 +445,14 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	}
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->data_len;
-		hdr->din_resid = rq->next_rq->data_len;
+		hdr->dout_resid = rq->resid_len;
+		hdr->din_resid = rq->next_rq->resid_len;
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->data_len;
+		hdr->din_resid = rq->resid_len;
 	else
-		hdr->dout_resid = rq->data_len;
+		hdr->dout_resid = rq->resid_len;
 
 	/*
 	 * If the request generated a negative error number, return it
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 58cf456..a9670dd 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -230,7 +230,7 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->data_len;
+	hdr->resid = rq->resid_len;
 	hdr->sb_len_wr = 0;
 
 	if (rq->sense_len && hdr->sbp) {
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 4d4d5e0..f22d493 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1299,7 +1299,6 @@ static void cciss_softirq_done(struct request *rq)
 {
 	CommandList_struct *cmd = rq->completion_data;
 	ctlr_info_t *h = hba[cmd->ctlr];
-	unsigned int nr_bytes;
 	unsigned long flags;
 	u64bit temp64;
 	int i, ddir;
@@ -1321,15 +1320,11 @@ static void cciss_softirq_done(struct request *rq)
 	printk("Done with %p\n", rq);
 #endif				/* CCISS_DEBUG */
 
-	/*
-	 * Store the full size and set the residual count for pc requests
-	 */
-	nr_bytes = blk_rq_bytes(rq);
+	/* set the residual count for pc requests */
 	if (blk_pc_request(rq))
-		rq->data_len = cmd->err_info->ResidualCnt;
+		rq->resid_len = cmd->err_info->ResidualCnt;
 
-	if (blk_end_request(rq, (rq->errors == 0) ? 0 : -EIO, nr_bytes))
-		BUG();
+	blk_end_request_all(rq, (rq->errors == 0) ? 0 : -EIO);
 
 	spin_lock_irqsave(&h->lock, flags);
 	cmd_free(h, cmd, 1);
@@ -2691,7 +2686,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 			printk(KERN_WARNING "cciss: cmd %p has"
 			       " completed with data underrun "
 			       "reported\n", cmd);
-			cmd->rq->data_len = cmd->err_info->ResidualCnt;
+			cmd->rq->resid_len = cmd->err_info->ResidualCnt;
 		}
 		break;
 	case CMD_DATA_OVERRUN:
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 689cd27..8c2cc71 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -783,10 +783,8 @@ static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 
 	if (cmd->error == 0) {
 		if (blk_pc_request(rq)) {
-			if (cmd->act_len >= rq->data_len)
-				rq->data_len = 0;
-			else
-				rq->data_len -= cmd->act_len;
+			if (cmd->act_len < rq->data_len)
+				rq->resid_len = rq->data_len - cmd->act_len;
 			scsi_status = 0;
 		} else {
 			if (cmd->act_len != cmd->len) {
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index afe5a43..e4a02a0 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -367,7 +367,6 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	/* No more interrupts */
 	if ((stat & ATA_DRQ) == 0) {
 		int uptodate, error;
-		unsigned int done;
 
 		debug_log("Packet command completed, %d bytes transferred\n",
 			  pc->xferred);
@@ -406,12 +405,6 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) && (stat & ATA_DSC) == 0)
 			dsc = 1;
 
-		/*
-		 * ->pc_callback() might change rq->data_len for
-		 * residual count, cache total length.
-		 */
-		done = blk_rq_bytes(rq);
-
 		/* Command finished - Call the callback function */
 		uptodate = drive->pc_callback(drive, dsc);
 
@@ -431,7 +424,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			error = uptodate ? 0 : -EIO;
 		}
 
-		ide_complete_rq(drive, error, done);
+		ide_complete_rq(drive, error, blk_rq_bytes(rq));
 		return ide_stopped;
 	}
 
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 6736287..8bbe222 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -519,7 +519,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 		error = blk_execute_rq(drive->queue, info->disk, rq, 0);
 
 		if (buffer)
-			*bufflen = rq->data_len;
+			*bufflen = rq->resid_len;
 
 		flags = rq->cmd_flags;
 		blk_put_request(rq);
@@ -707,11 +707,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 out_end:
 	if (blk_pc_request(rq) && rc == 0) {
-		unsigned int dlen = rq->data_len;
-
-		rq->data_len = 0;
-
-		if (blk_end_request(rq, 0, dlen))
+		if (blk_end_request(rq, 0, rq->data_len))
 			BUG();
 
 		hwif->rq = NULL;
@@ -740,9 +736,10 @@ out_end:
 			nsectors = 1;
 
 		if (blk_fs_request(rq) == 0) {
-			rq->data_len -= (cmd->nbytes - cmd->nleft);
+			rq->resid_len = rq->data_len -
+				(cmd->nbytes - cmd->nleft);
 			if (uptodate == 0 && (cmd->tf_flags & IDE_TFLAG_WRITE))
-				rq->data_len += cmd->last_xfer_len;
+				rq->resid_len += cmd->last_xfer_len;
 		}
 
 		ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 7149224..3813a0e 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -380,7 +380,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 		}
 
 		tape->first_frame += blocks;
-		rq->data_len -= blocks * tape->blk_size;
+		rq->resid_len = blk_rq_bytes(rq) - blocks * tape->blk_size;
 
 		if (pc->error) {
 			uptodate = 0;
@@ -903,7 +903,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 	blk_execute_rq(drive->queue, tape->disk, rq, 0);
 
 	/* calculate the number of transferred bytes and update buffer state */
-	size -= rq->data_len;
+	size -= rq->resid_len;
 	tape->cur = tape->buf;
 	if (cmd == REQ_IDETAPE_READ)
 		tape->valid = size;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index a9019f0..5d5f347 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1357,8 +1357,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
 		memcpy(req->sense, smprep, sizeof(*smprep));
 		req->sense_len = sizeof(*smprep);
-		req->data_len = 0;
-		rsp->data_len -= smprep->ResponseDataLength;
+		rsp->resid_len = rsp->data_len - smprep->ResponseDataLength;
 	} else {
 		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
 		    ioc->name, __func__);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 3da02e4..6605ec9 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1936,12 +1936,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			       bio_data(rsp->bio), rsp->data_len);
 	if (ret > 0) {
 		/* positive number is the untransferred residual */
-		rsp->data_len = ret;
-		req->data_len = 0;
+		rsp->resid_len = ret;
 		ret = 0;
-	} else if (ret == 0) {
-		rsp->data_len = 0;
-		req->data_len = 0;
 	}
 
 	return ret;
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index d110a36..89952ed 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -134,7 +134,7 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 {
 	u8 *req_data = NULL, *resp_data = NULL, *buf;
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
-	int error = -EINVAL, resp_data_len = rsp->data_len;
+	int error = -EINVAL;
 
 	/* eight is the minimum size for request and response frames */
 	if (req->data_len < 8 || rsp->data_len < 8)
@@ -176,17 +176,20 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 	resp_data[1] = req_data[1];
 	resp_data[2] = SMP_RESP_FUNC_UNK;
 
+	req->resid_len = req->data_len;
+	rsp->resid_len = rsp->data_len;
+
 	switch (req_data[1]) {
 	case SMP_REPORT_GENERAL:
-		req->data_len -= 8;
-		resp_data_len -= 32;
+		req->resid_len -= 8;
+		rsp->resid_len -= 32;
 		resp_data[2] = SMP_RESP_FUNC_ACC;
 		resp_data[9] = sas_ha->num_phys;
 		break;
 
 	case SMP_REPORT_MANUF_INFO:
-		req->data_len -= 8;
-		resp_data_len -= 64;
+		req->resid_len -= 8;
+		rsp->resid_len -= 64;
 		resp_data[2] = SMP_RESP_FUNC_ACC;
 		memcpy(resp_data + 12, shost->hostt->name,
 		       SAS_EXPANDER_VENDOR_ID_LEN);
@@ -199,13 +202,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_DISCOVER:
-		req->data_len -= 16;
-		if ((int)req->data_len < 0) {
-			req->data_len = 0;
+		req->resid_len -= 16;
+		if ((int)req->resid_len < 0) {
+			req->resid_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
-		resp_data_len -= 56;
+		rsp->resid_len -= 56;
 		sas_host_smp_discover(sas_ha, resp_data, req_data[9]);
 		break;
 
@@ -215,13 +218,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_REPORT_PHY_SATA:
-		req->data_len -= 16;
-		if ((int)req->data_len < 0) {
-			req->data_len = 0;
+		req->resid_len -= 16;
+		if ((int)req->resid_len < 0) {
+			req->resid_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
-		resp_data_len -= 60;
+		rsp->resid_len -= 60;
 		sas_report_phy_sata(sas_ha, resp_data, req_data[9]);
 		break;
 
@@ -238,13 +241,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_PHY_CONTROL:
-		req->data_len -= 44;
-		if ((int)req->data_len < 0) {
-			req->data_len = 0;
+		req->resid_len -= 44;
+		if ((int)req->resid_len < 0) {
+			req->resid_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
-		resp_data_len -= 8;
+		rsp->resid_len -= 8;
 		sas_phy_control(sas_ha, req_data[9], req_data[10],
 				req_data[32] >> 4, req_data[33] >> 4,
 				resp_data);
@@ -265,7 +268,6 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 	flush_kernel_dcache_page(bio_page(rsp->bio));
 	kunmap_atomic(buf - bio_offset(rsp->bio), KM_USER0);
 	local_irq_enable();
-	rsp->data_len = resp_data_len;
 
  out:
 	kfree(req_data);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index e03dc0b..53759c5 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1170,9 +1170,7 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 		memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
 		req->sense_len = sizeof(*mpi_reply);
-		req->data_len = 0;
-		rsp->data_len -= mpi_reply->ResponseDataLength;
-
+		rsp->resid_len = rsp->data_len - mpi_reply->ResponseDataLength;
 	} else {
 		dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT
 		    "%s - no reply\n", ioc->name, __func__));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index aa9fc57..7d49ef5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -240,11 +240,11 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	 * is invalid.  Prevent the garbage from being misinterpreted
 	 * and prevent security leaks by zeroing out the excess data.
 	 */
-	if (unlikely(req->data_len > 0 && req->data_len <= bufflen))
-		memset(buffer + (bufflen - req->data_len), 0, req->data_len);
+	if (unlikely(req->resid_len > 0 && req->resid_len <= bufflen))
+		memset(buffer + (bufflen - req->resid_len), 0, req->resid_len);
 
 	if (resid)
-		*resid = req->data_len;
+		*resid = req->resid_len;
 	ret = req->errors;
  out:
 	blk_put_request(req);
@@ -549,7 +549,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 		int leftover = (req->hard_nr_sectors << 9);
 
 		if (blk_pc_request(req))
-			leftover = req->data_len;
+			leftover = req->resid_len;
 
 		/* kill remainder if no retrys */
 		if (error && scsi_noretry_cmd(cmd))
@@ -673,11 +673,11 @@ void scsi_release_buffers(struct scsi_cmnd *cmd)
 EXPORT_SYMBOL(scsi_release_buffers);
 
 /*
- * Bidi commands Must be complete as a whole, both sides at once.
- * If part of the bytes were written and lld returned
- * scsi_in()->resid and/or scsi_out()->resid this information will be left
- * in req->data_len and req->next_rq->data_len. The upper-layer driver can
- * decide what to do with this information.
+ * Bidi commands Must be complete as a whole, both sides at once.  If
+ * part of the bytes were written and lld returned scsi_in()->resid
+ * and/or scsi_out()->resid this information will be left in
+ * req->resid_len and req->next_rq->resid_len. The upper-layer driver
+ * can decide what to do with this information.
  */
 static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
 {
@@ -685,8 +685,8 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
 	unsigned int dlen = req->data_len;
 	unsigned int next_dlen = req->next_rq->data_len;
 
-	req->data_len = scsi_out(cmd)->resid;
-	req->next_rq->data_len = scsi_in(cmd)->resid;
+	req->resid_len = scsi_out(cmd)->resid;
+	req->next_rq->resid_len = scsi_in(cmd)->resid;
 
 	/* The req and req->next_rq have not been completed */
 	BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));
@@ -778,7 +778,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_end_bidi_request(cmd);
 			return;
 		}
-		req->data_len = scsi_get_resid(cmd);
+		req->resid_len = scsi_get_resid(cmd);
 	}
 
 	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 82312df..dec4c70 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1260,7 +1260,7 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 
 	sense = rq->sense;
 	result = rq->errors;
-	resid = rq->data_len;
+	resid = rq->resid_len;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
 		sdp->disk->disk_name, srp->header.pack_id, result));
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index eb24efe..8681b70 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -463,7 +463,7 @@ static void st_scsi_execute_end(struct request *req, int uptodate)
 	struct scsi_tape *STp = SRpnt->stp;
 
 	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
-	STp->buffer->cmdstat.residual = req->data_len;
+	STp->buffer->cmdstat.residual = req->resid_len;
 
 	if (SRpnt->waiting)
 		complete(SRpnt->waiting);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3a5b1bd..6a967ca 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -229,6 +229,7 @@ struct request {
 	unsigned int data_len;
 	unsigned int extra_len;	/* length of alignment and padding */
 	unsigned int sense_len;
+	unsigned int resid_len;	/* residual count */
 	void *sense;
 
 	unsigned long deadline;
-- 
1.6.0.2

