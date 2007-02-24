From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/2] convert sg to use block layer helpers v4
Date: Sat, 24 Feb 2007 05:51:21 -0500
Message-ID: <1172314281.5437.5.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33452 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbXBXLyE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Feb 2007 06:54:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, dougg@torque.net

v4.

Convert sg to block layer helpers. I have tested with sg3_utils and
sg_utils. I have tested the mmap, iovec, dio and indirect IO paths,
by running those tools and the example programs against software
iscsi which does not support clustering, scsi_debug which has
a large segment size limit, and libata.

I think this patch is only missing some access_ok calls which the block
layer SGIO code did not have. I will add these back to sg.c, and let
others worry about merging that path :) I am just doing the scatterlist
and request paths :)

One change in behavior is that previously if the reserved buffer
allocation failed sg.c would just allocated what it could. In
this code we either allocate what was requested or we get nothing.
I will change this for the final patches since some apps may be
relying on that behavior.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

 sg.c | 1007 ++++++++++++++++---------------------------------------------------
 1 file changed, 247 insertions(+), 760 deletions(-)

Changes since v1 - v3.
- Support mutiple reserved buffers per queue. DougG pointed out that
sg.c uses a reserved buffer per file descripter.
- iovec fix ups

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 81e3bc7..9d9fa93 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -66,8 +66,7 @@ static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
 #endif
 
-#define SG_ALLOW_DIO_DEF 0
-#define SG_ALLOW_DIO_CODE /* compile out by commenting this define */
+#define SG_ALLOW_DIO_DEF 1
 
 #define SG_MAX_DEVS 32768
 
@@ -94,9 +93,6 @@ int sg_big_buff = SG_DEF_RESERVED_SIZE;
 static int def_reserved_size = -1;	/* picks up init parameter */
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
-static int scatter_elem_sz = SG_SCATTER_SZ;
-static int scatter_elem_sz_prev = SG_SCATTER_SZ;
-
 #define SG_SECTOR_SZ 512
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
@@ -115,12 +111,9 @@ static struct class_interface sg_interfa
 
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
 	unsigned short k_use_sg; /* Count of kernel scatter-gather pieces */
-	unsigned short sglist_len; /* size of malloc'd scatter-gather list ++ */
 	unsigned bufflen;	/* Size of (aggregate) data buffer */
-	unsigned b_malloc_len;	/* actual len malloc'ed in buffer */
-	struct scatterlist *buffer;/* scatter list */
-	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
 	unsigned char cmd_opcode; /* first byte of command */
+	struct bio_reserve_buf *rbuf; /* reserve memory */
 } Sg_scatter_hold;
 
 struct sg_device;		/* forward declarations */
@@ -132,6 +125,8 @@ typedef struct sg_request {	/* SG_MAX_QU
 	Sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
 	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
 	unsigned char sense_b[SCSI_SENSE_BUFFERSIZE];
+	struct request *request;
+	struct bio *bio;	/* ptr to bio for later unmapping */
 	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
@@ -146,7 +141,6 @@ typedef struct sg_fd {		/* holds the sta
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
-	unsigned save_scat_len;	/* original length of trunc. scat. element */
 	Sg_request *headrp;	/* head of request slist, NULL->empty */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
@@ -173,38 +167,24 @@ typedef struct sg_device { /* holds the 
 
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
@@ -305,6 +285,16 @@ sg_open(struct inode *inode, struct file
 	return retval;
 }
 
+static void sg_cleanup_transfer(struct sg_request *srp)
+{
+	struct sg_fd *sfp = srp->parentfp;
+
+	srp->bio = NULL;
+	if (srp->res_used)
+		bio_release_reserve_buf(sfp->reserve.rbuf);
+	srp->res_used = 0;
+}
+
 /* Following function was formerly called 'sg_close' */
 static int
 sg_release(struct inode *inode, struct file *filp)
@@ -464,7 +454,9 @@ sg_read(struct file *filp, char __user *
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
@@ -650,18 +642,13 @@ sg_new_write(Sg_fd * sfp, const char __u
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
@@ -694,9 +681,11 @@ static int
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
@@ -706,54 +695,46 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 	hp->host_status = 0;
 	hp->driver_status = 0;
 	hp->resid = 0;
+
 	SCSI_LOG_TIMEOUT(4, printk("sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			  (int) cmnd[0], (int) hp->cmd_len));
 
-	if ((k = sg_start_req(srp))) {
+	rq = blk_get_request(q, hp->dxfer_direction == SG_DXFER_TO_DEV,
+			     GFP_NOIO);
+	if (!rq) {
+		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: Could "
+				"not allocate request\n"));
+		return -ENOMEM;
+	}
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
+	if ((k = sg_setup_req(srp))) {
 		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=%d\n", k));
 		sg_finish_rem_req(srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
-	if ((k = sg_write_xfer(srp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: write_xfer, bad address\n"));
-		sg_finish_rem_req(srp);
-		return k;
-	}
+	/* must save for later unmapping */
+	srp->bio = rq->bio;
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
-	}
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
@@ -842,14 +823,13 @@ sg_ioctl(struct inode *inode, struct fil
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
@@ -917,13 +897,7 @@ sg_ioctl(struct inode *inode, struct fil
 			return result;
                 if (val < 0)
                         return -EINVAL;
-		if (val != sfp->reserve.bufflen) {
-			if (sg_res_in_use(sfp) || sfp->mmap_called)
-				return -EBUSY;
-			sg_remove_scat(&sfp->reserve);
-			sg_build_reserve(sfp, val);
-		}
-		return 0;
+		return sg_build_reserve(sfp, val);
 	case SG_GET_RESERVED_SIZE:
 		val = (int) sfp->reserve.bufflen;
 		return put_user(val, ip);
@@ -1146,38 +1120,11 @@ static struct page *
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
-	     ++k, ++sg) {
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
+	return blk_rq_vma_nopage(sfp->reserve.rbuf, vma, addr, type);
 }
 
 static struct vm_operations_struct sg_mmap_vm_ops = {
@@ -1188,30 +1135,21 @@ static int
 sg_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	Sg_fd *sfp;
-	unsigned long req_sz, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k;
-	struct scatterlist *sg;
+	int res;
 
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
-	     ++k, ++sg) {
-		len = vma->vm_end - sa;
-		len = (len < sg->length) ? len : sg->length;
-		sa += len;
-	}
+	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p\n",
+				   (void *) vma->vm_start));
+
+	/*
+	 * This only checks that we can execute the op.
+	 * We do not reserve the buffer and build the request
+	 * until it is sent down through the write.
+	 */
+	res = blk_rq_mmap(sfp->reserve.rbuf, vma);
+	if (res)
+		return res;
 
 	sfp->mmap_called = 1;
 	vma->vm_flags |= VM_RESERVED;
@@ -1221,53 +1159,51 @@ sg_mmap(struct file *filp, struct vm_are
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
 	if (sfp)
 		sdp = sfp->parentdp;
 	if ((NULL == sdp) || sdp->detached) {
-		printk(KERN_INFO "sg_cmd_done: device detached\n");
+		__blk_put_request(rq->q, rq);
 		return;
 	}
 
-
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
@@ -1276,12 +1212,14 @@ sg_cmd_done(void *data, char *sense, int
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
@@ -1292,10 +1230,8 @@ sg_cmd_done(void *data, char *sense, int
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
@@ -1540,7 +1476,6 @@ sg_remove(struct class_device *cl_dev, s
 		msleep(10);	/* dirty detach so delay device destruction */
 }
 
-module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
 module_param_named(def_reserved_size, def_reserved_size, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
@@ -1551,8 +1486,6 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(SG_VERSION_STR);
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_GENERIC_MAJOR);
 
-MODULE_PARM_DESC(scatter_elem_sz, "scatter gather element "
-                "size (default: max(SG_SCATTER_SZ, PAGE_SIZE))");
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
 
@@ -1561,10 +1494,6 @@ init_sg(void)
 {
 	int rc;
 
-	if (scatter_elem_sz < PAGE_SIZE) {
-		scatter_elem_sz = PAGE_SIZE;
-		scatter_elem_sz_prev = scatter_elem_sz;
-	}
 	if (def_reserved_size >= 0)
 		sg_big_buff = def_reserved_size;
 	else
@@ -1610,602 +1539,219 @@ #endif				/* CONFIG_SCSI_PROC_FS */
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
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_start_req: dxfer_len=%d\n", dxfer_len));
-	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
-		return 0;
-	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
-	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
-	    (!sfp->parentdp->device->host->unchecked_isa_dma)) {
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
-		}
-	}
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
+	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
+	int res = 0, num_xfer = 0, size;
+	struct bio_reserve_buf *rbuf = NULL;
 
-	/* Too big */
-        if (nr_pages > max_pages)
-		return -ENOMEM;
+	SCSI_LOG_TIMEOUT(4, printk("sg_setup_req: dxfer_len=%d\n", dxfer_len));
 
-	/* Hmm? */
-	if (count == 0)
+	/* no transfer */
+	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE) ||
+	  (new_interface && (SG_FLAG_NO_DXFER & hp->flags)))
 		return 0;
 
-	if ((pages = kmalloc(max_pages * sizeof(*pages), GFP_ATOMIC)) == NULL)
-		return -ENOMEM;
-
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
+	/* mmap */
+	if (new_interface && (SG_FLAG_MMAP_IO & hp->flags)) {
+		res = bio_claim_reserve_buf(sfp->reserve.rbuf, dxfer_len);
+		if (res)
+			return res;
+		rbuf = sfp->reserve.rbuf;
 
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
+		res = blk_rq_setup_buffer(rq, NULL, dxfer_len, -1, rbuf);
+		if (res)
+			goto release_rbuf;
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
+	/* dio */
+	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
+	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
+	    (!sfp->parentdp->device->host->unchecked_isa_dma)) {
+		res = blk_rq_map_user(rq->q, rq, hp->dxferp, dxfer_len, -1);
+		if (!res)
+			return 0;
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
 
-	for (i=0; i < nr_pages; i++) {
-		struct page *page = sgl[i].page;
-
-		if (dirtied)
-			SetPageDirty(page);
-		/* unlock_page(page); */
-		/* FIXME: cache flush missing for rw==READ
-		 * FIXME: call the correct reference counting function
-		 */
-		page_cache_release(page);
+	/* copy */
+	/* old interface put SG_DXFER_TO_DEV/SG_DXFER_TO_FROM_DEV in flags */
+	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_TO_DEV == dxfer_dir) ||
+	    (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
+		num_xfer = (int) (new_interface ? hp->dxfer_len : hp->flags);
+		if (num_xfer > dxfer_len)
+			num_xfer = dxfer_len;
 	}
 
-	return 0;
-}
-
-/* ^^^^^^^^  above code borrowed from st driver's direct IO ^^^^^^^^^ */
-#endif
+	SCSI_LOG_TIMEOUT(4, printk("sg_setup_req: Try xfer num_xfer=%d, "
+			"iovec_count=%d\n", dxfer_len, hp->iovec_count));
 
+	/* check if reserve buf is available and correct size */
+	if (!bio_claim_reserve_buf(sfp->reserve.rbuf, dxfer_len))
+		rbuf = sfp->reserve.rbuf;
 
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
+	if (!hp->iovec_count) {
+		struct sg_iovec iov;
 
-	if (((unsigned long)hp->dxferp &
-			queue_dma_alignment(sdev->request_queue)) != 0)
-		return 1;
+		iov.iov_base = hp->dxferp;
+		iov.iov_len = num_xfer; 
 
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
+		res = blk_rq_copy_user_iov(rq, &iov, 1, dxfer_len, rbuf);
+		if (res)
+			goto release_rbuf;
+		goto done;
 	}
-	schp->k_use_sg = res;
-	schp->dio_in_use = 1;
-	hp->info |= SG_INFO_DIRECT_IO;
-	return 0;
-#else
-	return 1;
-#endif
-}
 
-static int
-sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
-{
-	struct scatterlist *sg;
-	int ret_sz = 0, k, rem_sz, num, mx_sc_elems;
-	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	int blk_size = buff_size;
-	struct page *p = NULL;
-
-	if ((blk_size < 0) || (!sfp))
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
-	     ++k, rem_sz -= ret_sz, ++sg) {
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
-
-	schp->bufflen = blk_size;
-	if (rem_sz > 0)	/* must have failed */
-		return -ENOMEM;
-
-	return 0;
-}
-
-static int
-sg_write_xfer(Sg_request * srp)
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
-
-	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_TO_DEV == dxfer_dir) ||
-	    (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
-		num_xfer = (int) (new_interface ? hp->dxfer_len : hp->flags);
-		if (schp->bufflen < num_xfer)
-			num_xfer = schp->bufflen;
+	if (!access_ok(VERIFY_READ, hp->dxferp,
+			SZ_SG_IOVEC * hp->iovec_count)) {
+		res = -EFAULT;
+		goto release_rbuf;
 	}
-	if ((num_xfer <= 0) || (schp->dio_in_use) ||
-	    (new_interface
-	     && ((SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO) & hp->flags)))
-		return 0;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_write_xfer: num_xfer=%d, iovec_count=%d, k_use_sg=%d\n",
-			  num_xfer, iovec_count, schp->k_use_sg));
-	if (iovec_count) {
-		onum = iovec_count;
-		if (!access_ok(VERIFY_READ, hp->dxferp, SZ_SG_IOVEC * onum))
-			return -EFAULT;
-	} else
-		onum = 1;
 
-	ksglen = sg->length;
-	p = page_address(sg->page);
-	for (j = 0, k = 0; j < onum; ++j) {
-		res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
-		if (res)
-			return res;
-
-		for (; p; ++sg, ksglen = sg->length,
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
-		}
+	size = SZ_SG_IOVEC * hp->iovec_count;
+	u_iov = kmalloc(size, GFP_KERNEL);
+	if (!u_iov) {
+		res = -ENOMEM;
+		goto release_rbuf;
 	}
 
-	return 0;
-}
+	if (copy_from_user(u_iov, hp->dxferp, size)) {
+		kfree(u_iov);
+		res = -EFAULT;
+		goto release_rbuf;
+	}
 
-static int
-sg_u_iovec(sg_io_hdr_t * hp, int sg_num, int ind,
-	   int wr_xf, int *countp, unsigned char __user **up)
-{
-	int num_xfer = (int) hp->dxfer_len;
-	unsigned char __user *p = hp->dxferp;
-	int count;
+	res = blk_rq_copy_user_iov(rq, u_iov, hp->iovec_count, dxfer_len,
+				   rbuf);
+	kfree(u_iov);
+	if (res)
+		goto release_rbuf;
 
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
+done:
+	if (rbuf)
+		srp->res_used = 1;
 	return 0;
+
+release_rbuf:
+	if (rbuf)
+		bio_release_reserve_buf(rbuf);
+	return res;
 }
 
 static void
-sg_remove_scat(Sg_scatter_hold * schp)
+sg_finish_rem_req(Sg_request * srp)
 {
-	SCSI_LOG_TIMEOUT(4, printk("sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
-	if (schp->buffer && (schp->sglist_len > 0)) {
-		struct scatterlist *sg = schp->buffer;
+	Sg_fd *sfp = srp->parentfp;
 
-		if (schp->dio_in_use) {
-#ifdef SG_ALLOW_DIO_CODE
-			st_unmap_user_pages(sg, schp->k_use_sg, TRUE);
-#endif
-		} else {
-			int k;
-
-			for (k = 0; (k < schp->k_use_sg) && sg->page;
-			     ++k, ++sg) {
-				SCSI_LOG_TIMEOUT(5, printk(
-				    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
-				    k, sg->page, sg->length));
-				sg_page_free(sg->page, sg->length);
-			}
-		}
-		kfree(schp->buffer);
+	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
+
+	if (srp->bio) {
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
+		sg_cleanup_transfer(srp);
 	}
-	memset(schp, 0, sizeof (*schp));
+	sg_remove_request(sfp, srp);
 }
 
 static int
 sg_read_xfer(Sg_request * srp)
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
 
-	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_FROM_DEV == dxfer_dir)
-	    || (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
-		num_xfer = hp->dxfer_len;
-		if (schp->bufflen < num_xfer)
-			num_xfer = schp->bufflen;
-	}
-	if ((num_xfer <= 0) || (schp->dio_in_use) ||
-	    (new_interface
-	     && ((SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO) & hp->flags)))
+	if (new_interface && (SG_FLAG_NO_DXFER & hp->flags))
 		return 0;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_read_xfer: num_xfer=%d, iovec_count=%d, k_use_sg=%d\n",
-			  num_xfer, iovec_count, schp->k_use_sg));
-	if (iovec_count) {
-		onum = iovec_count;
-		if (!access_ok(VERIFY_READ, hp->dxferp, SZ_SG_IOVEC * onum))
-			return -EFAULT;
-	} else
-		onum = 1;
-
-	p = page_address(sg->page);
-	ksglen = sg->length;
-	for (j = 0, k = 0; j < onum; ++j) {
-		res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
-		if (res)
-			return res;
+	SCSI_LOG_TIMEOUT(4, printk("sg_read_xfer\n"));
 
-		for (; p; ++sg, ksglen = sg->length,
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
-	}
+	if (SG_DXFER_UNKNOWN == dxfer_dir ||
+	    SG_DXFER_FROM_DEV == dxfer_dir ||
+	    SG_DXFER_TO_FROM_DEV == dxfer_dir)
+		num_xfer = hp->dxfer_len;
 
-	return 0;
-}
+	if (new_interface && (SG_FLAG_MMAP_IO & hp->flags))
+		blk_rq_destroy_buffer(srp->bio);
+	else if (iovec_count) {
+		int size;
+		struct sg_iovec *u_iov;
 
-static int
-sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
-{
-	Sg_scatter_hold *schp = &srp->data;
-	struct scatterlist *sg = schp->buffer;
-	int k, num;
+		if (!access_ok(VERIFY_READ, hp->dxferp,
+			      SZ_SG_IOVEC * iovec_count))
+			return -EFAULT;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_read_oxfer: num_read_xfer=%d\n",
-				   num_read_xfer));
-	if ((!outp) || (num_read_xfer <= 0))
-		return 0;
+		size = SZ_SG_IOVEC * iovec_count;
+		u_iov = kmalloc(size, GFP_KERNEL);
+		if (!u_iov)
+			return -ENOMEM;
 
-	for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, ++sg) {
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
+		if (copy_from_user(u_iov, hp->dxferp, size)) {
+			kfree(u_iov);
+			return -EFAULT;
 		}
-	}
 
-	return 0;
+		/* TODO add in wr_xf ? VERIFY_READ : VERIFY_WRITE access_ok */
+		res = blk_rq_uncopy_user_iov(srp->bio, u_iov, iovec_count);
+		kfree(u_iov);
+	} else {
+		/* map user or non iovec copy user */
+		res = blk_rq_complete_transfer(srp->bio, hp->dxferp, num_xfer);
+	}
+	sg_cleanup_transfer(srp);
+	return res;
 }
 
-static void
+static int
 sg_build_reserve(Sg_fd * sfp, int req_size)
 {
-	Sg_scatter_hold *schp = &sfp->reserve;
+	struct request_queue *q = sfp->parentdp->device->request_queue;
+	int res;
 
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
-
-	srp->res_used = 1;
-	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
-	rem = size;
-
-	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
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
-	}
+	if (sfp->reserve.rbuf && (sfp->reserve.rbuf->buf_size == req_size))
+		return 0;
 
-	if (k >= rsv_schp->k_use_sg)
-		SCSI_LOG_TIMEOUT(1, printk("sg_link_reserve: BAD size\n"));
-}
+	if (sfp->mmap_called)
+		return -EBUSY;
 
-static void
-sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
-{
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	if (sfp->reserve.rbuf) {
+		res = bio_free_reserve_buf(sfp->reserve.rbuf);
+		if (res)
+			/* it is in use */
+			return res;
+		sfp->reserve.rbuf = NULL;
+	}
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_unlink_reserve: req->k_use_sg=%d\n",
-				   (int) req_schp->k_use_sg));
-	if ((rsv_schp->k_use_sg > 0) && (req_schp->k_use_sg > 0)) {
-		struct scatterlist *sg = rsv_schp->buffer;
+	sfp->reserve.bufflen = 0;
+	sfp->reserve.k_use_sg = 0;
 
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
+	sfp->reserve.rbuf = bio_alloc_reserve_buf(q, req_size);
+	if (!sfp->reserve.rbuf)
+		return res;
+	sfp->reserve.bufflen = sfp->reserve.rbuf->buf_size;
+	sfp->reserve.k_use_sg = sfp->reserve.rbuf->sg_count;
+	return 0;
 }
 
 static Sg_request *
@@ -2370,6 +1916,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 		sg_big_buff = def_reserved_size;
 
 	sg_build_reserve(sfp, sg_big_buff);
+
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
 			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
 	return sfp;
@@ -2397,7 +1944,8 @@ __sg_remove_sfp(Sg_device * sdp, Sg_fd *
 		SCSI_LOG_TIMEOUT(6, 
 			printk("__sg_remove_sfp:    bufflen=%d, k_use_sg=%d\n",
 			(int) sfp->reserve.bufflen, (int) sfp->reserve.k_use_sg));
-		sg_remove_scat(&sfp->reserve);
+		bio_free_reserve_buf(sfp->reserve.rbuf);
+		sfp->reserve.bufflen  = 0;
 	}
 	sfp->parentdp = NULL;
 	SCSI_LOG_TIMEOUT(6, printk("__sg_remove_sfp:    sfp=0x%p\n", sfp));
@@ -2451,67 +1999,6 @@ sg_remove_sfp(Sg_device * sdp, Sg_fd * s
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


