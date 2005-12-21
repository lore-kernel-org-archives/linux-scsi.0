From: David Caldwell <david@porkrind.org>
Subject: [SCSI] Add support for braindead Cypress USB ATA passthrough CDBs
Date: Wed, 21 Dec 2005 04:24:46 -0800
Message-ID: <20051221122442.GA16571@porkrind.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpe-67-49-70-252.socal.res.rr.com ([67.49.70.252]:49396 "EHLO
	death.porkrind.org") by vger.kernel.org with ESMTP id S932385AbVLUMYx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2005 07:24:53 -0500
Received: from death.porkrind.org (localhost [127.0.0.1])
	by death.porkrind.org (8.13.5/8.13.5/Debian-3) with ESMTP id jBLCOktx016635
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2005 04:24:46 -0800
Received: (from david@localhost)
	by death.porkrind.org (8.13.5/8.13.5/Submit) id jBLCOkC4016634
	for linux-scsi@vger.kernel.org; Wed, 21 Dec 2005 04:24:46 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch does 2 things. It reimplements the SG_FLAG_LUN_INHIBIT flag
in the SG_IO ioctl which stops the scsi subsystem from overwriting the
2nd byte of the CDB with the LUN. It also doesn't guess the CDB length
when sending the SG_IO ioctl to the sg device (the main scsi_ioctl
already did this).

This is for the Cypress CY7C68310 USB to ATA bridge chip (and most
likely other USB to ATA chips from Cypress), which implements an ATA
passthrough command that is 16 bytes long and starts with the bytes
0x24 0x24. (Not vendor unique, weird length for opcode 0x24, and
misuse of the LUN area all at the same time--Lovely).

Signed-off-by: David Caldwell <david@porkrind.org>

---

 block/scsi_ioctl.c         |    3 +++
 drivers/scsi/scsi.c        |    3 ++-
 drivers/scsi/scsi_error.c  |    4 ++--
 drivers/scsi/scsi_lib.c    |    8 ++++----
 drivers/scsi/sg.c          |   15 ++++++++-------
 drivers/scsi/st.c          |    4 ++--
 include/linux/blkdev.h     |    2 ++
 include/scsi/scsi_device.h |    5 +++--
 include/scsi/sg.h          |    2 +-
 9 files changed, 27 insertions(+), 19 deletions(-)

ea88a92a77263617575d957316464c1e6e8162ca
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 4e390df..266b828 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -291,6 +291,9 @@ static int sg_io(struct file *file, requ
 	rq->flags |= REQ_BLOCK_PC;
 	bio = rq->bio;
 
+	if (hdr->flags & SG_FLAG_LUN_INHIBIT)
+	    rq->flags |= REQ_LUN_INHIBIT;
+
 	/*
 	 * bounce this after holding a reference to the original bio, it's
 	 * needed for proper unmapping
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 180676d..cdcf6a5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -567,7 +567,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	/* 
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
 	 */
-	if (cmd->device->scsi_level <= SCSI_2) {
+	if (cmd->device->scsi_level <= SCSI_2 &&
+	    !(cmd->request->flags & REQ_LUN_INHIBIT)) {
 		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
 			       (cmd->device->lun << 5 & 0xe0);
 	}
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a2333d2..fd2f28c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1350,8 +1350,8 @@ static void scsi_eh_lock_door(struct scs
 	cmnd[4] = SCSI_REMOVAL_PREVENT;
 	cmnd[5] = 0;
 
-	scsi_execute_async(sdev, cmnd, DMA_NONE, NULL, 0, 0, 10 * HZ,
-			   5, NULL, NULL, GFP_KERNEL);
+	scsi_execute_async(sdev, cmnd, 6, DMA_NONE, NULL, 0, 0, 10 * HZ,
+			   5, 0, NULL, NULL, GFP_KERNEL);
 }
 
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a7f3f0c..a7504ca 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -445,8 +445,8 @@ free_bios:
  * @flags:	or into request flags
  **/
 int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
-		       int data_direction, void *buffer, unsigned bufflen,
-		       int use_sg, int timeout, int retries, void *privdata,
+		       unsigned cmd_len, int data_direction, void *buffer, unsigned bufflen,
+		       int use_sg, int timeout, int retries, int flags, void *privdata,
 		       void (*done)(void *, char *, int, int), gfp_t gfp)
 {
 	struct request *req;
@@ -462,7 +462,7 @@ int scsi_execute_async(struct scsi_devic
 	req = blk_get_request(sdev->request_queue, write, gfp);
 	if (!req)
 		goto free_sense;
-	req->flags |= REQ_BLOCK_PC | REQ_QUIET;
+	req->flags |= flags | REQ_BLOCK_PC | REQ_QUIET;
 
 	if (use_sg)
 		err = scsi_req_map_sg(req, buffer, use_sg, bufflen, gfp);
@@ -472,7 +472,7 @@ int scsi_execute_async(struct scsi_devic
 	if (err)
 		goto free_req;
 
-	req->cmd_len = COMMAND_SIZE(cmd[0]);
+	req->cmd_len = cmd_len ? cmd_len : COMMAND_SIZE(cmd[0]);
 	memcpy(req->cmd, cmd, req->cmd_len);
 	req->sense = sioc->sense;
 	req->sense_len = 0;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 221e96e..7b3c57f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -183,7 +183,7 @@ static ssize_t sg_new_read(Sg_fd * sfp, 
 static ssize_t sg_new_write(Sg_fd * sfp, const char __user *buf, size_t count,
 			    int blocking, int read_only, Sg_request ** o_srp);
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
-			   unsigned char *cmnd, int timeout, int blocking);
+			   unsigned char *cmnd, int timeout, int blocking, int lun_inhibit);
 static int sg_u_iovec(sg_io_hdr_t * hp, int sg_num, int ind,
 		      int wr_xf, int *countp, unsigned char __user **up);
 static int sg_write_xfer(Sg_request * srp);
@@ -614,7 +614,7 @@ sg_write(struct file *filp, const char _
 			       old_hdr.reply_len - (int)SZ_SG_HEADER,
 			       input_size, (unsigned int) cmnd[0],
 			       current->comm);
-	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
+	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking, 0);
 	return (k < 0) ? k : count;
 }
 
@@ -681,7 +681,8 @@ sg_new_write(Sg_fd * sfp, const char __u
 		sg_remove_request(sfp, srp);
 		return -EPERM;
 	}
-	k = sg_common_write(sfp, srp, cmnd, timeout, blocking);
+	k = sg_common_write(sfp, srp, cmnd, timeout, blocking,
+			    hp->flags & SG_FLAG_LUN_INHIBIT);
 	if (k < 0)
 		return k;
 	if (o_srp)
@@ -691,7 +692,7 @@ sg_new_write(Sg_fd * sfp, const char __u
 
 static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
-		unsigned char *cmnd, int timeout, int blocking)
+		unsigned char *cmnd, int timeout, int blocking, int lun_inhibit)
 {
 	int k, data_dir;
 	Sg_device *sdp = sfp->parentdp;
@@ -741,10 +742,10 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 	hp->duration = jiffies_to_msecs(jiffies);
 /* Now send everything of to mid-level. The next time we hear about this
    packet is when sg_cmd_done() is called (i.e. a callback). */
-	if (scsi_execute_async(sdp->device, cmnd, data_dir, srp->data.buffer,
+	if (scsi_execute_async(sdp->device, cmnd, hp->cmd_len, data_dir, srp->data.buffer,
 				hp->dxfer_len, srp->data.k_use_sg, timeout,
-				SG_DEFAULT_RETRIES, srp, sg_cmd_done,
-				GFP_ATOMIC)) {
+				SG_DEFAULT_RETRIES, lun_inhibit ? REQ_LUN_INHIBIT : 0,
+				srp, sg_cmd_done, GFP_ATOMIC)) {
 		SCSI_LOG_TIMEOUT(1, printk("sg_write: scsi_execute_async failed\n"));
 		/*
 		 * most likely out of mem, but could also be a bad map
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c4aade8..d73cb24 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -509,9 +509,9 @@ st_do_scsi(struct st_request * SRpnt, st
 	STp->buffer->cmdstat.have_sense = 0;
 	STp->buffer->syscall_result = 0;
 
-	if (scsi_execute_async(STp->device, cmd, direction,
+	if (scsi_execute_async(STp->device, cmd, 0, direction,
 			&((STp->buffer)->sg[0]), bytes, (STp->buffer)->sg_segs,
-			       timeout, retries, SRpnt, st_sleep_done, GFP_KERNEL)) {
+			       timeout, retries, 0, SRpnt, st_sleep_done, GFP_KERNEL)) {
 		/* could not allocate the buffer or request was too large */
 		(STp->buffer)->syscall_result = (-EBUSY);
 		(STp->buffer)->last_SRpnt = NULL;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a18500d..0612a91 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -233,6 +233,7 @@ enum rq_flag_bits {
 	__REQ_BAR_PREFLUSH,	/* barrier pre-flush done */
 	__REQ_BAR_POSTFLUSH,	/* barrier post-flush */
 	__REQ_BAR_FLUSH,	/* rq is the flush request */
+	__REQ_LUN_INHIBIT,	/* leave cmd[1] unmolested */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -263,6 +264,7 @@ enum rq_flag_bits {
 #define REQ_BAR_PREFLUSH	(1 << __REQ_BAR_PREFLUSH)
 #define REQ_BAR_POSTFLUSH	(1 << __REQ_BAR_POSTFLUSH)
 #define REQ_BAR_FLUSH	(1 << __REQ_BAR_FLUSH)
+#define REQ_LUN_INHIBIT	(1 << __REQ_LUN_INHIBIT)
 
 /*
  * State information carried for REQ_PM_SUSPEND and REQ_PM_RESUME
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e94ca4d..4c53f8c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -275,9 +275,10 @@ extern int scsi_execute_req(struct scsi_
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries);
 extern int scsi_execute_async(struct scsi_device *sdev,
-			      const unsigned char *cmd, int data_direction,
+			      const unsigned char *cmd, unsigned cmd_len,
+			      int data_direction,
 			      void *buffer, unsigned bufflen, int use_sg,
-			      int timeout, int retries, void *privdata,
+			      int timeout, int retries, int flags, void *privdata,
 			      void (*done)(void *, char *, int, int),
 			      gfp_t gfp);
 
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 0a487fe..6151e9c 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -139,7 +139,7 @@ typedef struct sg_io_hdr
 
 /* following flag values can be "or"-ed together */
 #define SG_FLAG_DIRECT_IO 1     /* default is indirect IO */
-#define SG_FLAG_UNUSED_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
+#define SG_FLAG_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
 				/* command block (when <= SCSI_2) */
 #define SG_FLAG_MMAP_IO 4       /* request memory mapped IO */
 #define SG_FLAG_NO_DXFER 0x10000 /* no transfer of kernel buffers to/from */
-- 
0.99.9n
