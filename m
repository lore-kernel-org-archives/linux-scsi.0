From: michaelc@cs.wisc.edu
Subject: [PATCH 10/10] convert sg.c to blk/bio helpers
Date: Sat, 20 Oct 2007 00:44:44 -0500
Message-ID: <1192859090397-git-send-email-michaelc@cs.wisc.edu>
References: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
	<1192859085521-git-send-email-michaelc@cs.wisc.edu>
	<11928590862112-git-send-email-michaelc@cs.wisc.edu>
	<11928590861021-git-send-email-michaelc@cs.wisc.edu>
	<11928590871413-git-send-email-michaelc@cs.wisc.edu>
	<11928590871678-git-send-email-michaelc@cs.wisc.edu>
	<11928590884170-git-send-email-michaelc@cs.wisc.edu>
	<11928590894155-git-send-email-michaelc@cs.wisc.edu>
	<11928590892682-git-send-email-michaelc@cs.wisc.edu>
	<11928590903157-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11928590903157-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts sg to use the block/bio layer helpers
to map and copy data.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/sg.c | 1061 ++++++++++++++++-------------------------------------
 1 files changed, 310 insertions(+), 751 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7238b2d..8adf7ea 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -67,7 +67,6 @@ static void sg_proc_cleanup(void);
 #endif
 
 #define SG_ALLOW_DIO_DEF 0
-#define SG_ALLOW_DIO_CODE /* compile out by commenting this define */
 
 #define SG_MAX_DEVS 32768
 
@@ -94,9 +93,6 @@ int sg_big_buff = SG_DEF_RESERVED_SIZE;
 static int def_reserved_size = -1;	/* picks up init parameter */
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
-static int scatter_elem_sz = SG_SCATTER_SZ;
-static int scatter_elem_sz_prev = SG_SCATTER_SZ;
-
 #define SG_SECTOR_SZ 512
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
@@ -114,12 +110,10 @@ static struct class_interface sg_interface = {
 
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
 	unsigned short k_use_sg; /* Count of kernel scatter-gather pieces */
-	unsigned sglist_len; /* size of malloc'd scatter-gather list ++ */
 	unsigned bufflen;	/* Size of (aggregate) data buffer */
-	unsigned b_malloc_len;	/* actual len malloc'ed in buffer */
-	struct scatterlist *buffer;/* scatter list */
-	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
 	unsigned char cmd_opcode; /* first byte of command */
+	struct bio_map_data *bmd; /* reserve memory */
+	struct bio_set *bs;	  /* bio pool */
 } Sg_scatter_hold;
 
 struct sg_device;		/* forward declarations */
@@ -131,6 +125,8 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	Sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
 	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
 	unsigned char sense_b[SCSI_SENSE_BUFFERSIZE];
+	struct request *request;
+	struct bio *bio;	/* ptr to bio for later unmapping */
 	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
@@ -145,7 +141,6 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
-	unsigned save_scat_len;	/* original length of trunc. scat. element */
 	Sg_request *headrp;	/* head of request slist, NULL->empty */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
@@ -173,38 +168,24 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 
 static int sg_fasync(int fd, struct file *filp, int mode);
 /* tasklet or soft irq callback */
-static void sg_cmd_done(void *data, char *sense, int result, int resid);
-static int sg_start_req(Sg_request * srp);
+static void sg_cmd_done(struct request *rq, int uptodate);
+static int sg_setup_req(Sg_request * srp);
 static void sg_finish_rem_req(Sg_request * srp);
-static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
-static int sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp,
-			 int tablesize);
 static ssize_t sg_new_read(Sg_fd * sfp, char __user *buf, size_t count,
 			   Sg_request * srp);
 static ssize_t sg_new_write(Sg_fd * sfp, const char __user *buf, size_t count,
 			    int blocking, int read_only, Sg_request ** o_srp);
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			   unsigned char *cmnd, int timeout, int blocking);
-static int sg_u_iovec(sg_io_hdr_t * hp, int sg_num, int ind,
-		      int wr_xf, int *countp, unsigned char __user **up);
-static int sg_write_xfer(Sg_request * srp);
 static int sg_read_xfer(Sg_request * srp);
-static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
-static void sg_remove_scat(Sg_scatter_hold * schp);
-static void sg_build_reserve(Sg_fd * sfp, int req_size);
-static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
-static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
-static struct page *sg_page_malloc(int rqSz, int lowDma, int *retSzp);
-static void sg_page_free(struct page *page, int size);
+static int sg_build_reserve(Sg_fd * sfp, int req_size);
 static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
 static int sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
 static void __sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
-static int sg_res_in_use(Sg_fd * sfp);
 static int sg_allow_access(unsigned char opcode, char dev_type);
-static int sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len);
 static Sg_device *sg_get_dev(int dev);
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
@@ -301,6 +282,12 @@ sg_open(struct inode *inode, struct file *filp)
 	return retval;
 }
 
+static void sg_cleanup_transfer(struct sg_request *srp)
+{
+	srp->bio = NULL;
+	srp->res_used = 0;
+}
+
 /* Following function was formerly called 'sg_close' */
 static int
 sg_release(struct inode *inode, struct file *filp)
@@ -460,7 +447,9 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 		if (count > old_hdr->reply_len)
 			count = old_hdr->reply_len;
 		if (count > SZ_SG_HEADER) {
-			if (sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)) {
+			retval = blk_rq_complete_transfer(srp->bio, buf, count);
+			sg_cleanup_transfer(srp);
+			if (retval) {
 				retval = -EFAULT;
 				goto free_old_hdr;
 			}
@@ -646,18 +635,13 @@ sg_new_write(Sg_fd * sfp, const char __user *buf, size_t count,
 		return -ENOSYS;
 	}
 	if (hp->flags & SG_FLAG_MMAP_IO) {
-		if (hp->dxfer_len > sfp->reserve.bufflen) {
-			sg_remove_request(sfp, srp);
-			return -ENOMEM;	/* MMAP_IO size must fit in reserve buffer */
-		}
+		/*
+		 * the call to mmap will have claimed the reserve buffer
+		 */
 		if (hp->flags & SG_FLAG_DIRECT_IO) {
 			sg_remove_request(sfp, srp);
 			return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
 		}
-		if (sg_res_in_use(sfp)) {
-			sg_remove_request(sfp, srp);
-			return -EBUSY;	/* reserve buffer already being used */
-		}
 	}
 	ul_timeout = msecs_to_jiffies(srp->header.timeout);
 	timeout = (ul_timeout < INT_MAX) ? ul_timeout : INT_MAX;
@@ -690,9 +674,11 @@ static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		unsigned char *cmnd, int timeout, int blocking)
 {
-	int k, data_dir;
+	int k;
 	Sg_device *sdp = sfp->parentdp;
 	sg_io_hdr_t *hp = &srp->header;
+	struct request_queue *q = sdp->device->request_queue;
+	struct request *rq;
 
 	srp->data.cmd_opcode = cmnd[0];	/* hold opcode of command */
 	hp->status = 0;
@@ -702,54 +688,44 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	hp->host_status = 0;
 	hp->driver_status = 0;
 	hp->resid = 0;
+
 	SCSI_LOG_TIMEOUT(4, printk("sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			  (int) cmnd[0], (int) hp->cmd_len));
 
-	if ((k = sg_start_req(srp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=%d\n", k));
-		sg_finish_rem_req(srp);
-		return k;	/* probably out of space --> ENOMEM */
-	}
-	if ((k = sg_write_xfer(srp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: write_xfer, bad address\n"));
-		sg_finish_rem_req(srp);
-		return k;
+	rq = blk_get_request(q, hp->dxfer_direction == SG_DXFER_TO_DEV,
+			     GFP_NOIO);
+	if (!rq) {
+		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: Could "
+				"not allocate request\n"));
+		return -ENOMEM;
 	}
+	srp->request = rq;
+
+	memset(srp->sense_b, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense = srp->sense_b;
+	rq->sense_len = 0;
+	rq->cmd_len = hp->cmd_len;
+	memcpy(rq->cmd, cmnd, rq->cmd_len);
+	rq->timeout = timeout;
+	rq->retries = SG_DEFAULT_RETRIES;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_flags |= REQ_QUIET;
+	rq->end_io_data = srp;
+
 	if (sdp->detached) {
 		sg_finish_rem_req(srp);
 		return -ENODEV;
 	}
 
-	switch (hp->dxfer_direction) {
-	case SG_DXFER_TO_FROM_DEV:
-	case SG_DXFER_FROM_DEV:
-		data_dir = DMA_FROM_DEVICE;
-		break;
-	case SG_DXFER_TO_DEV:
-		data_dir = DMA_TO_DEVICE;
-		break;
-	case SG_DXFER_UNKNOWN:
-		data_dir = DMA_BIDIRECTIONAL;
-		break;
-	default:
-		data_dir = DMA_NONE;
-		break;
+	if ((k = sg_setup_req(srp))) {
+		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=%d\n", k));
+		sg_finish_rem_req(srp);
+		return k;	/* probably out of space --> ENOMEM */
 	}
+
 	hp->duration = jiffies_to_msecs(jiffies);
-/* Now send everything of to mid-level. The next time we hear about this
-   packet is when sg_cmd_done() is called (i.e. a callback). */
-	if (scsi_execute_async(sdp->device, cmnd, hp->cmd_len, data_dir, srp->data.buffer,
-				hp->dxfer_len, srp->data.k_use_sg, timeout,
-				SG_DEFAULT_RETRIES, srp, sg_cmd_done,
-				GFP_ATOMIC)) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: scsi_execute_async failed\n"));
-		/*
-		 * most likely out of mem, but could also be a bad map
-		 */
-		sg_finish_rem_req(srp);
-		return -ENOMEM;
-	} else
-		return 0;
+	blk_execute_rq_nowait(q, NULL, rq, 1, sg_cmd_done);
+	return 0;
 }
 
 static int
@@ -838,14 +814,13 @@ sg_ioctl(struct inode *inode, struct file *filp,
 		result = get_user(val, ip);
 		if (result)
 			return result;
-		if (val) {
+		if (val)
+			/*
+			 * We should always be allocated mem from the right
+			 * limit, so maybe this should always be zero?.
+			 */
 			sfp->low_dma = 1;
-			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
-				val = (int) sfp->reserve.bufflen;
-				sg_remove_scat(&sfp->reserve);
-				sg_build_reserve(sfp, val);
-			}
-		} else {
+		else {
 			if (sdp->detached)
 				return -ENODEV;
 			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
@@ -914,14 +889,8 @@ sg_ioctl(struct inode *inode, struct file *filp,
                 if (val < 0)
                         return -EINVAL;
 		val = min_t(int, val,
-				sdp->device->request_queue->max_sectors * 512);
-		if (val != sfp->reserve.bufflen) {
-			if (sg_res_in_use(sfp) || sfp->mmap_called)
-				return -EBUSY;
-			sg_remove_scat(&sfp->reserve);
-			sg_build_reserve(sfp, val);
-		}
-		return 0;
+			    sdp->device->request_queue->max_sectors * 512);
+		return sg_build_reserve(sfp, val);
 	case SG_GET_RESERVED_SIZE:
 		val = min_t(int, sfp->reserve.bufflen,
 				sdp->device->request_queue->max_sectors * 512);
@@ -1060,9 +1029,6 @@ sg_ioctl(struct inode *inode, struct file *filp,
 		if (sdp->detached)
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
-	case BLKSECTGET:
-		return put_user(sdp->device->request_queue->max_sectors * 512,
-				ip);
 	default:
 		if (read_only)
 			return -EPERM;	/* don't know so take safe approach */
@@ -1148,72 +1114,53 @@ static struct page *
 sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
 {
 	Sg_fd *sfp;
-	struct page *page = NOPAGE_SIGBUS;
-	unsigned long offset, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	struct scatterlist *sg;
-	int k;
 
 	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return page;
-	rsv_schp = &sfp->reserve;
-	offset = addr - vma->vm_start;
-	if (offset >= rsv_schp->bufflen)
-		return page;
-	SCSI_LOG_TIMEOUT(3, printk("sg_vma_nopage: offset=%lu, scatg=%d\n",
-				   offset, rsv_schp->k_use_sg));
-	sg = rsv_schp->buffer;
-	sa = vma->vm_start;
-	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-	     ++k, sg = sg_next(sg)) {
-		len = vma->vm_end - sa;
-		len = (len < sg->length) ? len : sg->length;
-		if (offset < len) {
-			page = virt_to_page(page_address(sg->page) + offset);
-			get_page(page);	/* increment page count */
-			break;
-		}
-		sa += len;
-		offset -= len;
-	}
+		return NOPAGE_SIGBUS;
 
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	return blk_rq_vma_nopage(sfp->reserve.bmd, vma, addr, type);
+}
+
+static void
+sg_vma_close(struct vm_area_struct *vma)
+{
+	Sg_fd *sfp = vma->vm_private_data;
+
+	if (!sfp || !sfp->reserve.bmd)
+		return;
+	blk_rq_mmap_close(sfp->reserve.bmd);
+	sfp->reserve.bmd = NULL;
 }
 
 static struct vm_operations_struct sg_mmap_vm_ops = {
 	.nopage = sg_vma_nopage,
+	.close = sg_vma_close,
 };
 
 static int
 sg_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	Sg_fd *sfp;
-	unsigned long req_sz, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k;
-	struct scatterlist *sg;
 
 	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
 		return -ENXIO;
-	req_sz = vma->vm_end - vma->vm_start;
-	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p, len=%d\n",
-				   (void *) vma->vm_start, (int) req_sz));
-	if (vma->vm_pgoff)
-		return -EINVAL;	/* want no offset */
-	rsv_schp = &sfp->reserve;
-	if (req_sz > rsv_schp->bufflen)
-		return -ENOMEM;	/* cannot map more than reserved buffer */
-
-	sa = vma->vm_start;
-	sg = rsv_schp->buffer;
-	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-	     ++k, sg = sg_next(sg)) {
-		len = vma->vm_end - sa;
-		len = (len < sg->length) ? len : sg->length;
-		sa += len;
-	}
+	if (sfp->reserve.bmd)
+		return -ENXIO;
+	if (!sfp->reserve.bs)
+		return -ENOMEM;
+
+	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p\n",
+				   (void *) vma->vm_start));
+
+	/*
+	 * This only allocates the buffer and checks we can execute the op.
+	 * We do not build the request until it is sent down through the write.
+	 */
+	sfp->reserve.bmd = blk_rq_mmap_open(sfp->reserve.bs,
+					    sfp->parentdp->device->request_queue,
+					    vma);
+	if (!sfp->reserve.bmd)
+		return -ENOMEM;
 
 	sfp->mmap_called = 1;
 	vma->vm_flags |= VM_RESERVED;
@@ -1223,18 +1170,18 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 }
 
 /* This function is a "bottom half" handler that is called by the
- * mid level when a command is completed (or has failed). */
+ * block level when a command is completed (or has failed). */
 static void
-sg_cmd_done(void *data, char *sense, int result, int resid)
+sg_cmd_done(struct request *rq, int uptodate)
 {
-	Sg_request *srp = data;
+	Sg_request *srp = rq->end_io_data;
 	Sg_device *sdp = NULL;
 	Sg_fd *sfp;
 	unsigned long iflags;
 	unsigned int ms;
 
 	if (NULL == srp) {
-		printk(KERN_ERR "sg_cmd_done: NULL request\n");
+		__blk_put_request(rq->q, rq);
 		return;
 	}
 	sfp = srp->parentfp;
@@ -1247,29 +1194,28 @@ sg_cmd_done(void *data, char *sense, int result, int resid)
 
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
-		sdp->disk->disk_name, srp->header.pack_id, result));
-	srp->header.resid = resid;
+			sdp->disk->disk_name, srp->header.pack_id, rq->errors));
+	srp->header.resid = rq->data_len;
 	ms = jiffies_to_msecs(jiffies);
 	srp->header.duration = (ms > srp->header.duration) ?
 				(ms - srp->header.duration) : 0;
-	if (0 != result) {
+	if (0 != rq->errors) {
 		struct scsi_sense_hdr sshdr;
 
-		memcpy(srp->sense_b, sense, sizeof (srp->sense_b));
-		srp->header.status = 0xff & result;
-		srp->header.masked_status = status_byte(result);
-		srp->header.msg_status = msg_byte(result);
-		srp->header.host_status = host_byte(result);
-		srp->header.driver_status = driver_byte(result);
+		srp->header.status = 0xff & rq->errors;
+		srp->header.masked_status = status_byte(rq->errors);
+		srp->header.msg_status = msg_byte(rq->errors);
+		srp->header.host_status = host_byte(rq->errors);
+		srp->header.driver_status = driver_byte(rq->errors);
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			__scsi_print_sense("sg_cmd_done", sense,
-					   SCSI_SENSE_BUFFERSIZE);
+			__scsi_print_sense("sg_cmd_done", rq->sense,
+					   rq->sense_len);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
-		if (driver_byte(result) != 0
-		    && scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)
+		if (driver_byte(rq->errors) != 0
+		    && scsi_normalize_sense(rq->sense, rq->sense_len, &sshdr)
 		    && !scsi_sense_is_deferred(&sshdr)
 		    && sshdr.sense_key == UNIT_ATTENTION
 		    && sdp->device->removable) {
@@ -1278,12 +1224,14 @@ sg_cmd_done(void *data, char *sense, int result, int resid)
 			sdp->device->changed = 1;
 		}
 	}
+
+	srp->request = NULL;
+	__blk_put_request(rq->q, rq);
 	/* Rely on write phase to clean out srp status values, so no "else" */
 
 	if (sfp->closed) {	/* whoops this fd already released, cleanup */
 		SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, freeing ...\n"));
 		sg_finish_rem_req(srp);
-		srp = NULL;
 		if (NULL == sfp->headrp) {
 			SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, final cleanup\n"));
 			if (0 == sg_remove_sfp(sdp, sfp)) {	/* device still present */
@@ -1294,10 +1242,8 @@ sg_cmd_done(void *data, char *sense, int result, int resid)
 	} else if (srp && srp->orphan) {
 		if (sfp->keep_orphan)
 			srp->sg_io_owned = 0;
-		else {
+		else
 			sg_finish_rem_req(srp);
-			srp = NULL;
-		}
 	}
 	if (sfp && srp) {
 		/* Now wake up any sg_read() that is waiting for this packet. */
@@ -1521,7 +1467,6 @@ sg_remove(struct class_device *cl_dev, struct class_interface *cl_intf)
 		msleep(10);	/* dirty detach so delay device destruction */
 }
 
-module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
 module_param_named(def_reserved_size, def_reserved_size, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
@@ -1532,8 +1477,6 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(SG_VERSION_STR);
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_GENERIC_MAJOR);
 
-MODULE_PARM_DESC(scatter_elem_sz, "scatter gather element "
-                "size (default: max(SG_SCATTER_SZ, PAGE_SIZE))");
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
 
@@ -1542,10 +1485,6 @@ init_sg(void)
 {
 	int rc;
 
-	if (scatter_elem_sz < PAGE_SIZE) {
-		scatter_elem_sz = PAGE_SIZE;
-		scatter_elem_sz_prev = scatter_elem_sz;
-	}
 	if (def_reserved_size >= 0)
 		sg_big_buff = def_reserved_size;
 	else
@@ -1589,602 +1528,279 @@ exit_sg(void)
 }
 
 static int
-sg_start_req(Sg_request * srp)
+sg_setup_req(Sg_request * srp)
 {
-	int res;
+	struct request *rq = srp->request;
 	Sg_fd *sfp = srp->parentfp;
 	sg_io_hdr_t *hp = &srp->header;
+	struct sg_iovec *u_iov;
 	int dxfer_len = (int) hp->dxfer_len;
 	int dxfer_dir = hp->dxfer_direction;
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
+	int res = 0, num_xfer = 0, size;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_start_req: dxfer_len=%d\n", dxfer_len));
-	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
+	SCSI_LOG_TIMEOUT(4, printk("sg_setup_req: dxfer_len=%d\n", dxfer_len));
+
+	/* no transfer */
+	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE) ||
+	  (new_interface && (SG_FLAG_NO_DXFER & hp->flags)))
 		return 0;
+
+	/* mmap */
+	if (new_interface && (SG_FLAG_MMAP_IO & hp->flags)) {
+		res = blk_rq_setup_mmap_buffer(rq, sfp->reserve.bmd,
+					       dxfer_len, GFP_NOIO);
+		if (res)
+			goto fail;
+		goto done;
+	}
+
+	/* dio */
 	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
 	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
 	    (!sfp->parentdp->device->host->unchecked_isa_dma)) {
-		res = sg_build_direct(srp, sfp, dxfer_len);
-		if (res <= 0)	/* -ve -> error, 0 -> done, 1 -> try indirect */
-			return res;
-	}
-	if ((!sg_res_in_use(sfp)) && (dxfer_len <= rsv_schp->bufflen))
-		sg_link_reserve(sfp, srp, dxfer_len);
-	else {
-		res = sg_build_indirect(req_schp, sfp, dxfer_len);
-		if (res) {
-			sg_remove_scat(req_schp);
-			return res;
+		res = blk_rq_setup_buffer(sfp->reserve.bs, rq, hp->dxferp,
+					  dxfer_len, GFP_NOIO);
+		if (!res) {
+			hp->info |= SG_INFO_DIRECT_IO;
+			goto done;
 		}
+		/* drop down to copy */
 	}
-	return 0;
-}
-
-static void
-sg_finish_rem_req(Sg_request * srp)
-{
-	Sg_fd *sfp = srp->parentfp;
-	Sg_scatter_hold *req_schp = &srp->data;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
-	if (srp->res_used)
-		sg_unlink_reserve(sfp, srp);
-	else
-		sg_remove_scat(req_schp);
-	sg_remove_request(sfp, srp);
-}
-
-static int
-sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
-{
-	int sg_bufflen = tablesize * sizeof(struct scatterlist);
-	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
-
-	/*
-	 * TODO: test without low_dma, we should not need it since
-	 * the block layer will bounce the buffer for us
-	 *
-	 * XXX(hch): we shouldn't need GFP_DMA for the actual S/G list.
-	 */
-	if (sfp->low_dma)
-		 gfp_flags |= GFP_DMA;
-	schp->buffer = kzalloc(sg_bufflen, gfp_flags);
-	if (!schp->buffer)
-		return -ENOMEM;
-	schp->sglist_len = sg_bufflen;
-	return tablesize;	/* number of scat_gath elements allocated */
-}
-
-#ifdef SG_ALLOW_DIO_CODE
-/* vvvvvvvv  following code borrowed from st driver's direct IO vvvvvvvvv */
-	/* TODO: hopefully we can use the generic block layer code */
-
-/* Pin down user pages and put them into a scatter gather list. Returns <= 0 if
-   - mapping of all pages not successful
-   (i.e., either completely successful or fails)
-*/
-static int 
-st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
-	          unsigned long uaddr, size_t count, int rw)
-{
-	unsigned long end = (uaddr + count + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = uaddr >> PAGE_SHIFT;
-	const int nr_pages = end - start;
-	int res, i, j;
-	struct page **pages;
-
-	/* User attempted Overflow! */
-	if ((uaddr + count) < uaddr)
-		return -EINVAL;
 
-	/* Too big */
-        if (nr_pages > max_pages)
-		return -ENOMEM;
+	/* copy */
+	/* old interface put SG_DXFER_TO_DEV/SG_DXFER_TO_FROM_DEV in flags */
+	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_TO_DEV == dxfer_dir) ||
+	    (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
+		num_xfer = (int) (new_interface ? hp->dxfer_len : hp->flags);
+		if (num_xfer > dxfer_len)
+			num_xfer = dxfer_len;
+	}
 
-	/* Hmm? */
-	if (count == 0)
-		return 0;
+	SCSI_LOG_TIMEOUT(4, printk("sg_setup_req: Try xfer num_xfer=%d, "
+			"iovec_count=%d\n", dxfer_len, hp->iovec_count));
 
-	if ((pages = kmalloc(max_pages * sizeof(*pages), GFP_ATOMIC)) == NULL)
-		return -ENOMEM;
+	if (!hp->iovec_count) {
+		struct sg_iovec iov;
 
-        /* Try to fault in all of the necessary pages */
-	down_read(&current->mm->mmap_sem);
-        /* rw==READ means read from drive, write into memory area */
-	res = get_user_pages(
-		current,
-		current->mm,
-		uaddr,
-		nr_pages,
-		rw == READ,
-		0, /* don't force */
-		pages,
-		NULL);
-	up_read(&current->mm->mmap_sem);
-
-	/* Errors and no page mapped should return here */
-	if (res < nr_pages)
-		goto out_unmap;
-
-        for (i=0; i < nr_pages; i++) {
-                /* FIXME: flush superflous for rw==READ,
-                 * probably wrong function for rw==WRITE
-                 */
-		flush_dcache_page(pages[i]);
-		/* ?? Is locking needed? I don't think so */
-		/* if (TestSetPageLocked(pages[i]))
-		   goto out_unlock; */
-        }
+		iov.iov_base = hp->dxferp;
+		iov.iov_len = num_xfer;
 
-	sgl[0].page = pages[0];
-	sgl[0].offset = uaddr & ~PAGE_MASK;
-	if (nr_pages > 1) {
-		sgl[0].length = PAGE_SIZE - sgl[0].offset;
-		count -= sgl[0].length;
-		for (i=1; i < nr_pages ; i++) {
-			sgl[i].page = pages[i]; 
-			sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
-			count -= PAGE_SIZE;
-		}
-	}
-	else {
-		sgl[0].length = count;
+		res = blk_rq_copy_user_iov(sfp->reserve.bs, rq, &iov, 1,
+					   dxfer_len, GFP_NOIO);
+		if (res)
+			goto fail;
+		goto done;
 	}
 
-	kfree(pages);
-	return nr_pages;
-
- out_unmap:
-	if (res > 0) {
-		for (j=0; j < res; j++)
-			page_cache_release(pages[j]);
-		res = 0;
+	if (!access_ok(VERIFY_READ, hp->dxferp,
+			SZ_SG_IOVEC * hp->iovec_count)) {
+		res = -EFAULT;
+		goto fail;
 	}
-	kfree(pages);
-	return res;
-}
-
-
-/* And unmap them... */
-static int 
-st_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_pages,
-		    int dirtied)
-{
-	int i;
-
-	for (i=0; i < nr_pages; i++) {
-		struct page *page = sgl[i].page;
 
-		if (dirtied)
-			SetPageDirty(page);
-		/* unlock_page(page); */
-		/* FIXME: cache flush missing for rw==READ
-		 * FIXME: call the correct reference counting function
-		 */
-		page_cache_release(page);
+	size = SZ_SG_IOVEC * hp->iovec_count;
+	u_iov = kmalloc(size, GFP_KERNEL);
+	if (!u_iov) {
+		res = -ENOMEM;
+		goto fail;
 	}
 
-	return 0;
-}
-
-/* ^^^^^^^^  above code borrowed from st driver's direct IO ^^^^^^^^^ */
-#endif
-
-
-/* Returns: -ve -> error, 0 -> done, 1 -> try indirect */
-static int
-sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len)
-{
-#ifdef SG_ALLOW_DIO_CODE
-	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
-	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	int mx_sc_elems, res;
-	struct scsi_device *sdev = sfp->parentdp->device;
+	if (copy_from_user(u_iov, hp->dxferp, size)) {
+		kfree(u_iov);
+		res = -EFAULT;
+		goto fail;
+	}
 
-	if (((unsigned long)hp->dxferp &
-			queue_dma_alignment(sdev->request_queue)) != 0)
-		return 1;
+	res = blk_rq_copy_user_iov(sfp->reserve.bs, rq, u_iov, hp->iovec_count,
+				   dxfer_len, GFP_NOIO);
+	kfree(u_iov);
+	if (res)
+		goto fail;
 
-	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
-        if (mx_sc_elems <= 0) {
-                return 1;
-        }
-	res = st_map_user_pages(schp->buffer, mx_sc_elems,
-				(unsigned long)hp->dxferp, dxfer_len, 
-				(SG_DXFER_TO_DEV == hp->dxfer_direction) ? 1 : 0);
-	if (res <= 0) {
-		sg_remove_scat(schp);
-		return 1;
-	}
-	schp->k_use_sg = res;
-	schp->dio_in_use = 1;
-	hp->info |= SG_INFO_DIRECT_IO;
+done:
+	/* the blk/bio layer handles mmap cleanup */
+	if (!(new_interface && (SG_FLAG_MMAP_IO & hp->flags)))
+		/* must save for later unmapping */
+		srp->bio = rq->bio;
+	srp->res_used = 1;
 	return 0;
-#else
-	return 1;
-#endif
+
+fail:
+	return res;
 }
 
-static int
-sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
+static void
+sg_finish_rem_req(Sg_request * srp)
 {
-	struct scatterlist *sg;
-	int ret_sz = 0, k, rem_sz, num, mx_sc_elems;
-	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	int blk_size = buff_size;
-	struct page *p = NULL;
-
-	if (blk_size < 0)
-		return -EFAULT;
-	if (0 == blk_size)
-		++blk_size;	/* don't know why */
-/* round request up to next highest SG_SECTOR_SZ byte boundary */
-	blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
-	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, blk_size=%d\n",
-				   buff_size, blk_size));
-
-	/* N.B. ret_sz carried into this block ... */
-	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
-	if (mx_sc_elems < 0)
-		return mx_sc_elems;	/* most likely -ENOMEM */
-
-	num = scatter_elem_sz;
-	if (unlikely(num != scatter_elem_sz_prev)) {
-		if (num < PAGE_SIZE) {
-			scatter_elem_sz = PAGE_SIZE;
-			scatter_elem_sz_prev = PAGE_SIZE;
-		} else
-			scatter_elem_sz_prev = num;
-	}
-	for (k = 0, sg = schp->buffer, rem_sz = blk_size;
-	     (rem_sz > 0) && (k < mx_sc_elems);
-	     ++k, rem_sz -= ret_sz, sg = sg_next(sg)) {
-		
-		num = (rem_sz > scatter_elem_sz_prev) ?
-		      scatter_elem_sz_prev : rem_sz;
-		p = sg_page_malloc(num, sfp->low_dma, &ret_sz);
-		if (!p)
-			return -ENOMEM;
-
-		if (num == scatter_elem_sz_prev) {
-			if (unlikely(ret_sz > scatter_elem_sz_prev)) {
-				scatter_elem_sz = ret_sz;
-				scatter_elem_sz_prev = ret_sz;
-			}
-		}
-		sg->page = p;
-		sg->length = (ret_sz > num) ? num : ret_sz;
-
-		SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k=%d, num=%d, "
-				 "ret_sz=%d\n", k, num, ret_sz));
-	}		/* end of for loop */
-
-	schp->k_use_sg = k;
-	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, "
-			 "rem_sz=%d\n", k, rem_sz));
+	Sg_fd *sfp = srp->parentfp;
 
-	schp->bufflen = blk_size;
-	if (rem_sz > 0)	/* must have failed */
-		return -ENOMEM;
+	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
 
-	return 0;
+	if (srp->bio)
+		/*
+		 * buffer is left from something like a signal or close
+		 * which was being accessed at the time. We cannot copy
+		 * back to userspace so just release buffers.
+		 *
+		 * BUG: the old sg.c and this code, can get run from a softirq
+		 * and if dio was used then we need process context.
+		 * TODO: either document that you cannot use DIO and the feature
+		 * which closes devices or interrupts IO while DIO is in
+		 * progress. Or do something like James process context exec
+		 */
+		blk_rq_destroy_buffer(srp->bio);
+	sg_cleanup_transfer(srp);
+	sg_remove_request(sfp, srp);
 }
 
 static int
-sg_write_xfer(Sg_request * srp)
+sg_read_xfer(Sg_request * srp)
 {
 	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
-	struct scatterlist *sg = schp->buffer;
-	int num_xfer = 0;
-	int j, k, onum, usglen, ksglen, res;
 	int iovec_count = (int) hp->iovec_count;
-	int dxfer_dir = hp->dxfer_direction;
-	unsigned char *p;
-	unsigned char __user *up;
 	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
+	int res = 0, num_xfer = 0;
+	int dxfer_dir = hp->dxfer_direction;
 
-	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_TO_DEV == dxfer_dir) ||
-	    (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
-		num_xfer = (int) (new_interface ? hp->dxfer_len : hp->flags);
-		if (schp->bufflen < num_xfer)
-			num_xfer = schp->bufflen;
-	}
-	if ((num_xfer <= 0) || (schp->dio_in_use) ||
-	    (new_interface
-	     && ((SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO) & hp->flags)))
+	if (new_interface && (SG_FLAG_NO_DXFER & hp->flags))
 		return 0;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_write_xfer: num_xfer=%d, iovec_count=%d, k_use_sg=%d\n",
-			  num_xfer, iovec_count, schp->k_use_sg));
+	SCSI_LOG_TIMEOUT(4, printk("sg_read_xfer\n"));
+
+	if (SG_DXFER_UNKNOWN == dxfer_dir ||
+	    SG_DXFER_FROM_DEV == dxfer_dir ||
+	    SG_DXFER_TO_FROM_DEV == dxfer_dir)
+		num_xfer = hp->dxfer_len;
 	if (iovec_count) {
-		onum = iovec_count;
-		if (!access_ok(VERIFY_READ, hp->dxferp, SZ_SG_IOVEC * onum))
+		int size;
+		struct sg_iovec *u_iov;
+
+		if (!access_ok(VERIFY_READ, hp->dxferp,
+			      SZ_SG_IOVEC * iovec_count))
 			return -EFAULT;
-	} else
-		onum = 1;
 
-	ksglen = sg->length;
-	p = page_address(sg->page);
-	for (j = 0, k = 0; j < onum; ++j) {
-		res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
-		if (res)
-			return res;
+		size = SZ_SG_IOVEC * iovec_count;
+		u_iov = kmalloc(size, GFP_KERNEL);
+		if (!u_iov)
+			return -ENOMEM;
 
-		for (; p; sg = sg_next(sg), ksglen = sg->length,
-		     p = page_address(sg->page)) {
-			if (usglen <= 0)
-				break;
-			if (ksglen > usglen) {
-				if (usglen >= num_xfer) {
-					if (__copy_from_user(p, up, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_from_user(p, up, usglen))
-					return -EFAULT;
-				p += usglen;
-				ksglen -= usglen;
-				break;
-			} else {
-				if (ksglen >= num_xfer) {
-					if (__copy_from_user(p, up, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_from_user(p, up, ksglen))
-					return -EFAULT;
-				up += ksglen;
-				usglen -= ksglen;
-			}
-			++k;
-			if (k >= schp->k_use_sg)
-				return 0;
+		if (copy_from_user(u_iov, hp->dxferp, size)) {
+			kfree(u_iov);
+			return -EFAULT;
 		}
-	}
 
-	return 0;
+		res = blk_rq_uncopy_user_iov(srp->bio, u_iov, iovec_count);
+		kfree(u_iov);
+	} else if (!(new_interface && (SG_FLAG_MMAP_IO & hp->flags)))
+		/*
+		 * dio or non iovec copy user. For mmap blk/bio layer
+		 * handles the cleanup.
+		 */
+		res = blk_rq_complete_transfer(srp->bio, hp->dxferp, num_xfer);
+	sg_cleanup_transfer(srp);
+	return res;
 }
 
 static int
-sg_u_iovec(sg_io_hdr_t * hp, int sg_num, int ind,
-	   int wr_xf, int *countp, unsigned char __user **up)
+sg_res_in_use(Sg_fd * sfp)
 {
-	int num_xfer = (int) hp->dxfer_len;
-	unsigned char __user *p = hp->dxferp;
-	int count;
+	const Sg_request *srp;
+	unsigned long iflags;
 
-	if (0 == sg_num) {
-		if (wr_xf && ('\0' == hp->interface_id))
-			count = (int) hp->flags;	/* holds "old" input_size */
-		else
-			count = num_xfer;
-	} else {
-		sg_iovec_t iovec;
-		if (__copy_from_user(&iovec, p + ind*SZ_SG_IOVEC, SZ_SG_IOVEC))
-			return -EFAULT;
-		p = iovec.iov_base;
-		count = (int) iovec.iov_len;
-	}
-	if (!access_ok(wr_xf ? VERIFY_READ : VERIFY_WRITE, p, count))
-		return -EFAULT;
-	if (up)
-		*up = p;
-	if (countp)
-		*countp = count;
-	return 0;
+	read_lock_irqsave(&sfp->rq_list_lock, iflags);
+	for (srp = sfp->headrp; srp; srp = srp->nextrp)
+		if (srp->res_used)
+			break;
+	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	return srp ? 1 : 0;
 }
 
 static void
-sg_remove_scat(Sg_scatter_hold * schp)
+sg_calc_reserve_settings(struct request_queue *q, int req_size, int *order,
+			 int *nr_segs)
 {
-	SCSI_LOG_TIMEOUT(4, printk("sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
-	if (schp->buffer && (schp->sglist_len > 0)) {
-		struct scatterlist *sg = schp->buffer;
+	unsigned int bytes;
 
-		if (schp->dio_in_use) {
-#ifdef SG_ALLOW_DIO_CODE
-			st_unmap_user_pages(sg, schp->k_use_sg, TRUE);
-#endif
-		} else {
-			int k;
-
-			for (k = 0; (k < schp->k_use_sg) && sg->page;
-			     ++k, sg = sg_next(sg)) {
-				SCSI_LOG_TIMEOUT(5, printk(
-				    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
-				    k, sg->page, sg->length));
-				sg_page_free(sg->page, sg->length);
-			}
-		}
-		kfree(schp->buffer);
-	}
-	memset(schp, 0, sizeof (*schp));
-}
-
-static int
-sg_read_xfer(Sg_request * srp)
-{
-	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
-	struct scatterlist *sg = schp->buffer;
-	int num_xfer = 0;
-	int j, k, onum, usglen, ksglen, res;
-	int iovec_count = (int) hp->iovec_count;
-	int dxfer_dir = hp->dxfer_direction;
-	unsigned char *p;
-	unsigned char __user *up;
-	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
+	*order = 0;
+	*nr_segs = 0;
 
-	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_FROM_DEV == dxfer_dir)
-	    || (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
-		num_xfer = hp->dxfer_len;
-		if (schp->bufflen < num_xfer)
-			num_xfer = schp->bufflen;
+	if (req_size <= PAGE_SIZE) {
+		bytes = PAGE_SIZE;
+		*order = 0;
+		goto calc_segs;
 	}
-	if ((num_xfer <= 0) || (schp->dio_in_use) ||
-	    (new_interface
-	     && ((SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO) & hp->flags)))
-		return 0;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_read_xfer: num_xfer=%d, iovec_count=%d, k_use_sg=%d\n",
-			  num_xfer, iovec_count, schp->k_use_sg));
-	if (iovec_count) {
-		onum = iovec_count;
-		if (!access_ok(VERIFY_READ, hp->dxferp, SZ_SG_IOVEC * onum))
-			return -EFAULT;
-	} else
-		onum = 1;
 
-	p = page_address(sg->page);
-	ksglen = sg->length;
-	for (j = 0, k = 0; j < onum; ++j) {
-		res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
-		if (res)
-			return res;
-
-		for (; p; sg = sg_next(sg), ksglen = sg->length,
-		     p = page_address(sg->page)) {
-			if (usglen <= 0)
-				break;
-			if (ksglen > usglen) {
-				if (usglen >= num_xfer) {
-					if (__copy_to_user(up, p, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_to_user(up, p, usglen))
-					return -EFAULT;
-				p += usglen;
-				ksglen -= usglen;
-				break;
-			} else {
-				if (ksglen >= num_xfer) {
-					if (__copy_to_user(up, p, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_to_user(up, p, ksglen))
-					return -EFAULT;
-				up += ksglen;
-				usglen -= ksglen;
-			}
-			++k;
-			if (k >= schp->k_use_sg)
-				return 0;
-		}
+	if (!(q->queue_flags & (1 << QUEUE_FLAG_CLUSTER))) {
+		*order = 0;
+		bytes = PAGE_SIZE;
+		goto calc_segs;
 	}
 
-	return 0;
-}
-
-static int
-sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
-{
-	Sg_scatter_hold *schp = &srp->data;
-	struct scatterlist *sg = schp->buffer;
-	int k, num;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_read_oxfer: num_read_xfer=%d\n",
-				   num_read_xfer));
-	if ((!outp) || (num_read_xfer <= 0))
-		return 0;
+	bytes = min(q->max_segment_size, q->max_hw_sectors << 9);
+	if (bytes > BIO_MAX_SIZE)
+		bytes = BIO_MAX_SIZE;
+	else if (bytes > req_size)
+		bytes = req_size;
+	*order = get_order(bytes);
 
-	for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, sg = sg_next(sg)) {
-		num = sg->length;
-		if (num > num_read_xfer) {
-			if (__copy_to_user(outp, page_address(sg->page),
-					   num_read_xfer))
-				return -EFAULT;
-			break;
-		} else {
-			if (__copy_to_user(outp, page_address(sg->page),
-					   num))
-				return -EFAULT;
-			num_read_xfer -= num;
-			if (num_read_xfer <= 0)
-				break;
-			outp += num;
-		}
-	}
-
-	return 0;
+calc_segs:
+	*nr_segs = req_size / bytes;
+	if ((bytes * (*nr_segs)) < req_size)
+		*nr_segs = *nr_segs + 1;
 }
 
-static void
+static int
 sg_build_reserve(Sg_fd * sfp, int req_size)
 {
-	Sg_scatter_hold *schp = &sfp->reserve;
+	struct request_queue *q = sfp->parentdp->device->request_queue;
+	int order = 0, nr_segs = 0, old_nr_segs;
+	struct bio_set *old_bs = NULL;
+	unsigned old_bufflen;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_build_reserve: req_size=%d\n", req_size));
-	do {
-		if (req_size < PAGE_SIZE)
-			req_size = PAGE_SIZE;
-		if (0 == sg_build_indirect(schp, sfp, req_size))
-			return;
-		else
-			sg_remove_scat(schp);
-		req_size >>= 1;	/* divide by 2 */
-	} while (req_size > (PAGE_SIZE / 2));
-}
+	if (req_size < 0)
+		return -EINVAL;
 
-static void
-sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
-{
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
-	struct scatterlist *sg = rsv_schp->buffer;
-	int k, num, rem;
+	if (req_size == 0)
+		return 0;
 
-	srp->res_used = 1;
-	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
-	rem = size;
-
-	for (k = 0; k < rsv_schp->k_use_sg; ++k, sg = sg_next(sg)) {
-		num = sg->length;
-		if (rem <= num) {
-			sfp->save_scat_len = num;
-			sg->length = rem;
-			req_schp->k_use_sg = k + 1;
-			req_schp->sglist_len = rsv_schp->sglist_len;
-			req_schp->buffer = rsv_schp->buffer;
-
-			req_schp->bufflen = size;
-			req_schp->b_malloc_len = rsv_schp->b_malloc_len;
-			break;
-		} else
-			rem -= num;
+	if (sfp->reserve.bs &&
+	    (bioset_pagepool_get_size(sfp->reserve.bs) == req_size))
+		return 0;
+
+	if (sfp->mmap_called || sg_res_in_use(sfp))
+		return -EBUSY;
+
+	if (sfp->reserve.bs) {
+		old_bs = sfp->reserve.bs;
+		sfp->reserve.bs = NULL;
 	}
 
-	if (k >= rsv_schp->k_use_sg)
-		SCSI_LOG_TIMEOUT(1, printk("sg_link_reserve: BAD size\n"));
-}
+	old_bufflen = sfp->reserve.bufflen = 0;
+	old_nr_segs = sfp->reserve.k_use_sg = 0;
 
-static void
-sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
-{
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	sg_calc_reserve_settings(q, req_size, &order, &nr_segs);
+	/*
+	 * the max reserve size was limited to the q->max_sectors,
+	 * which fits in one bio.
+	 */
+	sfp->reserve.bs = bioset_pagepool_create(1, 1, nr_segs, order);
+	if (!sfp->reserve.bs) {
+		if (old_bs) {
+			sfp->reserve.bs = old_bs;
+			sfp->reserve.bufflen = old_bufflen;
+			sfp->reserve.k_use_sg = old_nr_segs;
+		}
+		return -ENOMEM;
+        }
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_unlink_reserve: req->k_use_sg=%d\n",
-				   (int) req_schp->k_use_sg));
-	if ((rsv_schp->k_use_sg > 0) && (req_schp->k_use_sg > 0)) {
-		struct scatterlist *sg = rsv_schp->buffer;
+	if (old_bs)
+		bioset_pagepool_free(old_bs);
 
-		if (sfp->save_scat_len > 0)
-			(sg + (req_schp->k_use_sg - 1))->length =
-			    (unsigned) sfp->save_scat_len;
-		else
-			SCSI_LOG_TIMEOUT(1, printk ("sg_unlink_reserve: BAD save_scat_len\n"));
-	}
-	req_schp->k_use_sg = 0;
-	req_schp->bufflen = 0;
-	req_schp->buffer = NULL;
-	req_schp->sglist_len = 0;
-	sfp->save_scat_len = 0;
-	srp->res_used = 0;
+	sfp->reserve.bufflen = bioset_pagepool_get_size(sfp->reserve.bs);
+	sfp->reserve.k_use_sg = nr_segs;
+	return 0;
 }
 
 static Sg_request *
@@ -2375,12 +1991,16 @@ __sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp)
 			prev_fp = fp;
 		}
 	}
+
 	if (sfp->reserve.bufflen > 0) {
 		SCSI_LOG_TIMEOUT(6, 
 			printk("__sg_remove_sfp:    bufflen=%d, k_use_sg=%d\n",
 			(int) sfp->reserve.bufflen, (int) sfp->reserve.k_use_sg));
-		sg_remove_scat(&sfp->reserve);
+		bioset_pagepool_free(sfp->reserve.bs);
+		sfp->reserve.bs = NULL;
+		sfp->reserve.bufflen  = 0;
 	}
+
 	sfp->parentdp = NULL;
 	SCSI_LOG_TIMEOUT(6, printk("__sg_remove_sfp:    sfp=0x%p\n", sfp));
 	kfree(sfp);
@@ -2425,67 +2045,6 @@ sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp)
 	return res;
 }
 
-static int
-sg_res_in_use(Sg_fd * sfp)
-{
-	const Sg_request *srp;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (srp = sfp->headrp; srp; srp = srp->nextrp)
-		if (srp->res_used)
-			break;
-	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return srp ? 1 : 0;
-}
-
-/* The size fetched (value output via retSzp) set when non-NULL return */
-static struct page *
-sg_page_malloc(int rqSz, int lowDma, int *retSzp)
-{
-	struct page *resp = NULL;
-	gfp_t page_mask;
-	int order, a_size;
-	int resSz;
-
-	if ((rqSz <= 0) || (NULL == retSzp))
-		return resp;
-
-	if (lowDma)
-		page_mask = GFP_ATOMIC | GFP_DMA | __GFP_COMP | __GFP_NOWARN;
-	else
-		page_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
-
-	for (order = 0, a_size = PAGE_SIZE; a_size < rqSz;
-	     order++, a_size <<= 1) ;
-	resSz = a_size;		/* rounded up if necessary */
-	resp = alloc_pages(page_mask, order);
-	while ((!resp) && order) {
-		--order;
-		a_size >>= 1;	/* divide by 2, until PAGE_SIZE */
-		resp =  alloc_pages(page_mask, order);	/* try half */
-		resSz = a_size;
-	}
-	if (resp) {
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			memset(page_address(resp), 0, resSz);
-		*retSzp = resSz;
-	}
-	return resp;
-}
-
-static void
-sg_page_free(struct page *page, int size)
-{
-	int order, a_size;
-
-	if (!page)
-		return;
-	for (order = 0, a_size = PAGE_SIZE; a_size < size;
-	     order++, a_size <<= 1) ;
-	__free_pages(page, order);
-}
-
 #ifndef MAINTENANCE_IN_CMD
 #define MAINTENANCE_IN_CMD 0xa3
 #endif
-- 
1.5.1.2
