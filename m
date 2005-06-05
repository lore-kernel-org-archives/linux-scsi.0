From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Sun, 05 Jun 2005 00:15:27 -0700
Message-ID: <1117955727.4961.8.camel@mina>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1117901234.5005.9.camel@mulgrave>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2005-06-04 at 09:07, James Bottomley wrote:
> On Fri, 2005-06-03 at 18:19 -0700, Mike Christie wrote:
> > The goal is next convert the scsi 'special' requests to use these
> > functions, so scsi will be able to use block layer functions for scatter
> > lists setup for all requests. And then hopefully one day we will not
> > need those stinking "if (sc->use_sg)" paths all over our scsi drivers.
> 
> Here's the proof of concept for this one.  It converts scsi_wait_req to
> do correct REQ_BLOCK_PC submission (and works nicely in my setup).
> 
> The final goal should be to eliminate struct scsi_request, but that
> can't be done until the character submission paths of sg and st are also
> modified.

inlined below is a patch built over yours + my patch set (I put all my
patches here http://www.cs.wisc.edu/~michaelc/block/use-sg/v3/) that
converts scsi_scan.c and removes its scsi_request usage. I cheated and
added a new function that is basically your scsi_wait_req but it uses
the block layer's blk_execute_rq function instead of blk_insert_request.
Also to send block pc commands at scan time without the special bit set
I had to modify the scsi_prep_fn. This is just a RFC/test-patch so oh
well. There is the larger problem of handling queue limits to handle.

> 
> There's some loss of functionality to this: retries are no longer
> controllable (except by setting REQ_FASTFAIL) and the wait_req API needs
> to be altered, but it looks very nice.


diff -aurp git/drivers/block/ll_rw_blk.c git.work/drivers/block/ll_rw_blk.c
--- git/drivers/block/ll_rw_blk.c	2005-06-04 20:25:10.000000000 -0700
+++ git.work/drivers/block/ll_rw_blk.c	2005-06-04 23:42:13.000000000 -0700
@@ -2236,14 +2236,16 @@ EXPORT_SYMBOL(blk_rq_map_kern);
  * @q:		queue to insert the request in
  * @bd_disk:	matching gendisk
  * @rq:		request to insert
+ * @at_head:    insert request at head or tail of queue
  *
  * Description:
  *    Insert a fully prepared request at the back of the io scheduler queue
  *    for execution.
  */
 int blk_execute_rq(request_queue_t *q, struct gendisk *bd_disk,
-		   struct request *rq)
+		   struct request *rq, int at_head)
 {
+	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 	DECLARE_COMPLETION(wait);
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	int err = 0;
@@ -2265,7 +2267,7 @@ int blk_execute_rq(request_queue_t *q, s
 	rq->flags |= REQ_NOMERGE;
 	rq->waiting = &wait;
 	rq->end_io = blk_end_sync_rq;
-	elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 1);
+	elv_add_request(q, rq, where, 1);
 	generic_unplug_device(q);
 	wait_for_completion(&wait);
 	rq->waiting = NULL;
@@ -2333,7 +2335,7 @@ int blkdev_scsi_issue_flush_fn(request_q
 	rq->data_len = 0;
 	rq->timeout = 60 * HZ;
 
-	ret = blk_execute_rq(q, disk, rq);
+	ret = blk_execute_rq(q, disk, rq, 0);
 
 	if (ret && error_sector)
 		*error_sector = rq->sector;
diff -aurp git/drivers/block/scsi_ioctl.c git.work/drivers/block/scsi_ioctl.c
--- git/drivers/block/scsi_ioctl.c	2005-06-04 20:25:10.000000000 -0700
+++ git.work/drivers/block/scsi_ioctl.c	2005-06-04 23:32:24.000000000 -0700
@@ -298,7 +298,7 @@ static int sg_io(struct file *file, requ
 	 * (if he doesn't check that is his problem).
 	 * N.B. a non-zero SCSI status is _not_ necessarily an error.
 	 */
-	blk_execute_rq(q, bd_disk, rq);
+	blk_execute_rq(q, bd_disk, rq, 0);
 
 	/* write to all output members */
 	hdr->status = 0xff & rq->errors;
@@ -415,7 +415,7 @@ static int sg_scsi_ioctl(struct file *fi
 	rq->data_len = bytes;
 	rq->flags |= REQ_BLOCK_PC;
 
-	blk_execute_rq(q, bd_disk, rq);
+	blk_execute_rq(q, bd_disk, rq, 0);
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
@@ -569,7 +569,7 @@ int scsi_cmd_ioctl(struct file *file, st
 			rq->cmd[0] = GPCMD_START_STOP_UNIT;
 			rq->cmd[4] = 0x02 + (close != 0);
 			rq->cmd_len = 6;
-			err = blk_execute_rq(q, bd_disk, rq);
+			err = blk_execute_rq(q, bd_disk, rq, 0);
 			blk_put_request(rq);
 			break;
 		default:
diff -aurp git/drivers/cdrom/cdrom.c git.work/drivers/cdrom/cdrom.c
--- git/drivers/cdrom/cdrom.c	2005-06-04 20:04:45.000000000 -0700
+++ git.work/drivers/cdrom/cdrom.c	2005-06-04 23:32:54.000000000 -0700
@@ -2132,7 +2132,7 @@ static int cdrom_read_cdda_bpc(struct cd
 		if (rq->bio)
 			blk_queue_bounce(q, &rq->bio);
 
-		if (blk_execute_rq(q, cdi->disk, rq)) {
+		if (blk_execute_rq(q, cdi->disk, rq, 0)) {
 			struct request_sense *s = rq->sense;
 			ret = -EIO;
 			cdi->last_sense = s->sense_key;
diff -aurp git/drivers/ide/ide-disk.c git.work/drivers/ide/ide-disk.c
--- git/drivers/ide/ide-disk.c	2005-06-04 20:04:57.000000000 -0700
+++ git.work/drivers/ide/ide-disk.c	2005-06-04 23:32:42.000000000 -0700
@@ -750,7 +750,7 @@ static int idedisk_issue_flush(request_q
 
 	idedisk_prepare_flush(q, rq);
 
-	ret = blk_execute_rq(q, disk, rq);
+	ret = blk_execute_rq(q, disk, rq, 0);
 
 	/*
 	 * if we failed and caller wants error offset, get it
diff -aurp git/drivers/scsi/scsi_lib.c git.work/drivers/scsi/scsi_lib.c
--- git/drivers/scsi/scsi_lib.c	2005-06-04 20:25:14.000000000 -0700
+++ git.work/drivers/scsi/scsi_lib.c	2005-06-04 23:57:59.000000000 -0700
@@ -284,6 +284,59 @@ void scsi_wait_req(struct scsi_request *
 
 EXPORT_SYMBOL(scsi_wait_req);
 
+/**
+ * scsi_execute_req - insert request and wait for the result
+ * @sdev:	scsi device
+ * @cmd:	scsi command
+ * @data_direction: data direction
+ * @buffer:	data buffer
+ * @bufflen:	len of buffer
+ * @sense:	optional sense buffer
+ * @timeout:	request timeout in seconds
+ * @retries:	number of times to retry request
+ *
+ * scsi_execute_req returns the req->errors value which is the
+ * the scsi_cmnd result field.
+ **/
+int scsi_execute_req(struct scsi_device *sdev, unsigned char *cmd,
+		     int data_direction, void *buffer, unsigned bufflen,
+		     unsigned char *sense, int timeout, int retries)
+{
+	struct request *req;
+
+	if (bufflen)
+		req = blk_rq_map_kern(sdev->request_queue,
+				      data_direction == DMA_TO_DEVICE,
+				      buffer, bufflen, __GFP_WAIT);
+	else
+		req = blk_get_request(sdev->request_queue, READ, __GFP_WAIT);
+	if (!req)
+		/*
+		 * if we could not map the buffer within the request queue's
+		 * limits we return DRIVER_ERROR.
+		 *
+		 * TODO: should caller check limits and send multiple
+		 * requests or should we handle it.
+		 */
+		return DRIVER_ERROR << 24;
+
+	req->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(req->cmd, cmd, req->cmd_len);
+	req->sense = sense;
+	req->sense_len = 0;
+	req->timeout = timeout;
+	req->flags |= REQ_BLOCK_PC;
+
+	/*
+	 * head injection *required* here otherwise quiesce won't work
+	 */
+	blk_execute_rq(req->q, NULL, req, 1);
+	blk_put_request(req);
+	return req->errors;
+}
+
+EXPORT_SYMBOL(scsi_execute_req);
+
 /*
  * Function:    scsi_init_cmd_errh()
  *
@@ -1049,7 +1102,8 @@ static int scsi_prep_fn(struct request_q
 		       sdev->host->host_no, sdev->id, sdev->lun);
 		return BLKPREP_KILL;
 	}
-	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
+	if (unlikely(sdev->sdev_state != SDEV_RUNNING) &&
+	    unlikely(sdev->sdev_state != SDEV_CREATED)) {
 		/* OK, we're not in a running state don't prep
 		 * user commands */
 		if (sdev->sdev_state == SDEV_DEL) {
diff -aurp git/drivers/scsi/scsi_scan.c git.work/drivers/scsi/scsi_scan.c
--- git/drivers/scsi/scsi_scan.c	2005-06-04 20:05:53.000000000 -0700
+++ git.work/drivers/scsi/scsi_scan.c	2005-06-04 23:15:59.000000000 -0700
@@ -111,15 +111,14 @@ MODULE_PARM_DESC(inq_timeout, 
 
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
- * @sreq:	used to send the command
+ * @sdev:	scsi device to send command to
  * @result:	area to store the result of the MODE SENSE
  *
  * Description:
- *     Send a vendor specific MODE SENSE (not a MODE SELECT) command using
- *     @sreq to unlock a device, storing the (unused) results into result.
+ *     Send a vendor specific MODE SENSE (not a MODE SELECT) command.
  *     Called for BLIST_KEY devices.
  **/
-static void scsi_unlock_floptical(struct scsi_request *sreq,
+static void scsi_unlock_floptical(struct scsi_device *sdev,
 				  unsigned char *result)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
@@ -129,11 +128,10 @@ static void scsi_unlock_floptical(struct
 	scsi_cmd[1] = 0;
 	scsi_cmd[2] = 0x2e;
 	scsi_cmd[3] = 0;
-	scsi_cmd[4] = 0x2a;	/* size */
+	scsi_cmd[4] = 0x2a;     /* size */
 	scsi_cmd[5] = 0;
-	sreq->sr_cmd_len = 0;
-	sreq->sr_data_direction = DMA_FROM_DEVICE;
-	scsi_wait_req(sreq, scsi_cmd, result, 0x2a /* size */, SCSI_TIMEOUT, 3);
+	scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, result, 0x2a, NULL,
+			 SCSI_TIMEOUT, 3);
 }
 
 /**
@@ -419,26 +417,26 @@ void scsi_target_reap(struct scsi_target
 
 /**
  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
- * @sreq:	used to send the INQUIRY
+ * @sdev:	scsi_device to probe
  * @inq_result:	area to store the INQUIRY result
+ * @result_len: len of inq_result
  * @bflags:	store any bflags found here
  *
  * Description:
- *     Probe the lun associated with @sreq using a standard SCSI INQUIRY;
+ *     Probe the lun associated with @req using a standard SCSI INQUIRY;
  *
- *     If the INQUIRY is successful, sreq->sr_result is zero and: the
+ *     If the INQUIRY is successful, zero is returned and the
  *     INQUIRY data is in @inq_result; the scsi_level and INQUIRY length
- *     are copied to the Scsi_Device at @sreq->sr_device (sdev);
- *     any flags value is stored in *@bflags.
+ *     are copied to the Scsi_Device any flags value is stored in *@bflags.
  **/
-static void scsi_probe_lun(struct scsi_request *sreq, char *inq_result,
-			   int *bflags)
+static int scsi_probe_lun(struct scsi_device *sdev, char *inq_result,
+			  int result_len, int *bflags)
 {
-	struct scsi_device *sdev = sreq->sr_device;	/* a bit ugly */
+	char sense[SCSI_SENSE_BUFFERSIZE];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
-	int pass, count;
+	int pass, count, result;
 	struct scsi_sense_hdr sshdr;
 
 	*bflags = 0;
@@ -461,28 +459,28 @@ static void scsi_probe_lun(struct scsi_r
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
 		scsi_cmd[4] = (unsigned char) try_inquiry_len;
-		sreq->sr_cmd_len = 0;
-		sreq->sr_data_direction = DMA_FROM_DEVICE;
 
+		memset(sense, 0, sizeof(sense));
 		memset(inq_result, 0, try_inquiry_len);
-		scsi_wait_req(sreq, (void *) scsi_cmd, (void *) inq_result,
-				try_inquiry_len,
-				HZ/2 + HZ*scsi_inq_timeout, 3);
+
+		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
+					  inq_result, try_inquiry_len, sense,
+					  HZ / 2 + HZ * scsi_inq_timeout, 3);
 
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY %s "
 				"with code 0x%x\n",
-				sreq->sr_result ? "failed" : "successful",
-				sreq->sr_result));
+				result ? "failed" : "successful", result));
 
-		if (sreq->sr_result) {
+		if (result) {
 			/*
 			 * not-ready to ready transition [asc/ascq=0x28/0x0]
 			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
 			 * INQUIRY should not yield UNIT_ATTENTION
 			 * but many buggy devices do so anyway. 
 			 */
-			if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
-			    scsi_request_normalize_sense(sreq, &sshdr)) {
+			if ((driver_byte(result) & DRIVER_SENSE) &&
+			    scsi_normalize_sense(sense, sizeof(sense),
+						 &sshdr)) {
 				if ((sshdr.sense_key == UNIT_ATTENTION) &&
 				    ((sshdr.asc == 0x28) ||
 				     (sshdr.asc == 0x29)) &&
@@ -493,7 +491,7 @@ static void scsi_probe_lun(struct scsi_r
 		break;
 	}
 
-	if (sreq->sr_result == 0) {
+	if (result == 0) {
 		response_len = (unsigned char) inq_result[4] + 5;
 		if (response_len > 255)
 			response_len = first_inquiry_len;	/* sanity */
@@ -542,8 +540,8 @@ static void scsi_probe_lun(struct scsi_r
 
 	/* If the last transfer attempt got an error, assume the
 	 * peripheral doesn't exist or is dead. */
-	if (sreq->sr_result)
-		return;
+	if (result)
+		return -EIO;
 
 	/* Don't report any more data than the device says is valid */
 	sdev->inquiry_len = min(try_inquiry_len, response_len);
@@ -579,7 +577,7 @@ static void scsi_probe_lun(struct scsi_r
 	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
 		sdev->scsi_level++;
 
-	return;
+	return 0;
 }
 
 /**
@@ -785,9 +783,8 @@ static int scsi_probe_and_add_lun(struct
 				  void *hostdata)
 {
 	struct scsi_device *sdev;
-	struct scsi_request *sreq;
 	unsigned char *result;
-	int bflags, res = SCSI_SCAN_NO_RESPONSE;
+	int bflags, res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	/*
@@ -816,16 +813,13 @@ static int scsi_probe_and_add_lun(struct
 	sdev = scsi_alloc_sdev(starget, lun, hostdata);
 	if (!sdev)
 		goto out;
-	sreq = scsi_allocate_request(sdev, GFP_ATOMIC);
-	if (!sreq)
-		goto out_free_sdev;
-	result = kmalloc(256, GFP_ATOMIC |
+
+	result = kmalloc(result_len, GFP_ATOMIC |
 			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
 	if (!result)
-		goto out_free_sreq;
+		goto out_free_sdev;
 
-	scsi_probe_lun(sreq, result, &bflags);
-	if (sreq->sr_result)
+	if (scsi_probe_lun(sdev, result, result_len, &bflags))
 		goto out_free_result;
 
 	/*
@@ -853,7 +847,7 @@ static int scsi_probe_and_add_lun(struct
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
-			scsi_unlock_floptical(sreq, result);
+			scsi_unlock_floptical(sdev, result);
 		}
 		if (bflagsp)
 			*bflagsp = bflags;
@@ -861,8 +855,6 @@ static int scsi_probe_and_add_lun(struct
 
  out_free_result:
 	kfree(result);
- out_free_sreq:
-	scsi_release_request(sreq);
  out_free_sdev:
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (sdevp) {
@@ -1018,13 +1010,14 @@ static int scsi_report_lun_scan(struct s
 				int rescan)
 {
 	char devname[64];
+	char sense[SCSI_SENSE_BUFFERSIZE];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
 	unsigned int lun;
 	unsigned int num_luns;
 	unsigned int retries;
+	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_request *sreq;
 	u8 *data;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_target *starget = scsi_target(sdev);
@@ -1042,10 +1035,6 @@ static int scsi_report_lun_scan(struct s
 	if (bflags & BLIST_NOLUN)
 		return 0;
 
-	sreq = scsi_allocate_request(sdev, GFP_ATOMIC);
-	if (!sreq)
-		goto out;
-
 	sprintf(devname, "host %d channel %d id %d",
 		sdev->host->host_no, sdev->channel, sdev->id);
 
@@ -1063,7 +1052,7 @@ static int scsi_report_lun_scan(struct s
 	lun_data = kmalloc(length, GFP_ATOMIC |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!lun_data)
-		goto out_release_request;
+		goto out;
 
 	scsi_cmd[0] = REPORT_LUNS;
 
@@ -1082,8 +1071,6 @@ static int scsi_report_lun_scan(struct s
 
 	scsi_cmd[10] = 0;	/* reserved */
 	scsi_cmd[11] = 0;	/* control */
-	sreq->sr_cmd_len = 0;
-	sreq->sr_data_direction = DMA_FROM_DEVICE;
 
 	/*
 	 * We can get a UNIT ATTENTION, for example a power on/reset, so
@@ -1099,29 +1086,30 @@ static int scsi_report_lun_scan(struct s
 		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: Sending"
 				" REPORT LUNS to %s (try %d)\n", devname,
 				retries));
-		scsi_wait_req(sreq, scsi_cmd, lun_data, length,
-				SCSI_TIMEOUT + 4*HZ, 3);
+
+		memset(sense, 0, sizeof(sense));
+		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
+					  lun_data, length, sense,
+					  SCSI_TIMEOUT + 4 * HZ, 3);
+
 		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n", sreq->sr_result
-				?  "failed" : "successful", retries,
-				sreq->sr_result));
-		if (sreq->sr_result == 0)
+				" %s (try %d) result 0x%x\n", result
+				?  "failed" : "successful", retries, result));
+		if (result == 0)
 			break;
-		else if (scsi_request_normalize_sense(sreq, &sshdr)) {
+		else if (scsi_normalize_sense(sense, sizeof(sense), &sshdr)) {
 			if (sshdr.sense_key != UNIT_ATTENTION)
 				break;
 		}
 	}
 
-	if (sreq->sr_result) {
+	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
 		 */
 		kfree(lun_data);
-		scsi_release_request(sreq);
 		return 1;
 	}
-	scsi_release_request(sreq);
 
 	/*
 	 * Get the length from the first four bytes of lun_data.
@@ -1195,8 +1183,6 @@ static int scsi_report_lun_scan(struct s
 	kfree(lun_data);
 	return 0;
 
- out_release_request:
-	scsi_release_request(sreq);
  out:
 	/*
 	 * We are out of memory, don't try scanning any further.
diff -aurp git/include/linux/blkdev.h git.work/include/linux/blkdev.h
--- git/include/linux/blkdev.h	2005-06-04 20:25:10.000000000 -0700
+++ git.work/include/linux/blkdev.h	2005-06-04 23:31:22.000000000 -0700
@@ -562,7 +562,8 @@ extern struct request *blk_rq_map_user(r
 extern int blk_rq_unmap_user(struct request *, struct bio *, unsigned int);
 extern struct request *blk_rq_map_kern(request_queue_t *, int, void *,
 					unsigned int, unsigned int);
-extern int blk_execute_rq(request_queue_t *, struct gendisk *, struct request *);
+extern int blk_execute_rq(request_queue_t *, struct gendisk *,
+			  struct request *, int);
 
 static inline request_queue_t *bdev_get_queue(struct block_device *bdev)
 {
diff -aurp git/include/scsi/scsi_request.h git.work/include/scsi/scsi_request.h
--- git/include/scsi/scsi_request.h	2005-06-04 20:07:53.000000000 -0700
+++ git.work/include/scsi/scsi_request.h	2005-06-04 23:16:31.000000000 -0700
@@ -54,6 +54,9 @@ extern void scsi_do_req(struct scsi_requ
 			void *buffer, unsigned bufflen,
 			void (*done) (struct scsi_cmnd *),
 			int timeout, int retries);
+extern int scsi_execute_req(struct scsi_device *sdev, unsigned char *cmd,
+			    int data_direction, void *buffer, unsigned bufflen,
+			    unsigned char *sense, int timeout, int retries);
 
 struct scsi_mode_data {
 	__u32	length;
