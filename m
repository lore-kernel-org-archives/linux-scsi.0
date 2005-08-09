From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/2] convert sg to blk_rq map functions
Date: Mon, 08 Aug 2005 23:38:21 -0500
Message-ID: <1123562301.6090.14.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:63377 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932377AbVHIGif (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2005 02:38:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, linux-scsi@vger.kernel.org

Make sg.c use block layer functions so we always use
scatterlists in scsi.

Changes from original driver (junk that is broken or
new *features* :) ):

- mmap currently not supported. Need some block layer helpers
so we can support this for all ULDs. Is this needed?
- Always do DIO for the new interface if buffer is aligned properly.
- Always obey LLD queue restrictions.
- Rely on block layer reserves and bio bounce buffer for
memory allocations.
- SG_DXFER_TO_FROM_DEV may be broken. sg currently works like
the block layer SG_IO code right now.

Patch has been tested by running the sg3 and sg utils
packaages, so this is not ready for merging (more cleanup
of old code needed). We also may want to add some scsi
helpers, but because of the sg_read copy_to_user case and
sg.c requiring a pointer to the bio to do the uncopy it
gets a little strange if we are also going to kill
scsi_request. In this patch sg.c just accesses the bio
and request directly :(

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -71,9 +71,6 @@ static void sg_proc_cleanup(void);
 #include <linux/version.h>
 #endif				/* LINUX_VERSION_CODE */
 
-#define SG_ALLOW_DIO_DEF 0
-#define SG_ALLOW_DIO_CODE /* compile out by commenting this define */
-
 #define SG_MAX_DEVS 32768
 
 /*
@@ -89,16 +86,6 @@ static void sg_proc_cleanup(void);
 
 #define SG_DEFAULT_TIMEOUT MULDIV(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 
-int sg_big_buff = SG_DEF_RESERVED_SIZE;
-/* N.B. This variable is readable and writeable via
-   /proc/scsi/sg/def_reserved_size . Each time sg_open() is called a buffer
-   of this size (or less if there is not enough memory) will be reserved
-   for use by this file descriptor. [Deprecated usage: this variable is also
-   readable via /proc/sys/kernel/sg-big-buff if the sg driver is built into
-   the kernel (i.e. it is not a module).] */
-static int def_reserved_size = -1;	/* picks up init parameter */
-static int sg_allow_dio = SG_ALLOW_DIO_DEF;
-
 #define SG_SECTOR_SZ 512
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
@@ -107,8 +94,6 @@ static int sg_allow_dio = SG_ALLOW_DIO_D
 static int sg_add(struct class_device *);
 static void sg_remove(struct class_device *);
 
-static Scsi_Request *dummy_cmdp;	/* only used for sizeof */
-
 static DEFINE_RWLOCK(sg_dev_arr_lock);	/* Also used to lock
 							   file descriptor list for device */
 
@@ -117,27 +102,17 @@ static struct class_interface sg_interfa
 	.remove		= sg_remove,
 };
 
-typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
-	unsigned short k_use_sg; /* Count of kernel scatter-gather pieces */
-	unsigned short sglist_len; /* size of malloc'd scatter-gather list ++ */
-	unsigned bufflen;	/* Size of (aggregate) data buffer */
-	unsigned b_malloc_len;	/* actual len malloc'ed in buffer */
-	void *buffer;		/* Data buffer or scatter list (k_use_sg>0) */
-	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
-	unsigned char cmd_opcode; /* first byte of command */
-} Sg_scatter_hold;
-
 struct sg_device;		/* forward declarations */
 struct sg_fd;
 
 typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
-	Scsi_Request *my_cmdp;	/* != 0  when request with lower levels */
+	unsigned char cmd_opcode;	/* first byte of command */
+	struct request *my_cmdp;	/* != 0  when request with lower levels */
+	struct bio *bio;	/* needed for unmapping */
 	struct sg_request *nextrp;	/* NULL -> tail request (slist) */
 	struct sg_fd *parentfp;	/* NULL -> not in use */
-	Sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
 	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
-	unsigned char sense_b[sizeof (dummy_cmdp->sr_sense_buffer)];
-	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
+	unsigned char sense_b[SCSI_SENSE_BUFFERSIZE];
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
@@ -150,7 +125,6 @@ typedef struct sg_fd {		/* holds the sta
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
-	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
 	unsigned save_scat_len;	/* original length of trunc. scat. element */
 	Sg_request *headrp;	/* head of request slist, NULL->empty */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
@@ -177,27 +151,15 @@ typedef struct sg_device { /* holds the 
 } Sg_device;
 
 static int sg_fasync(int fd, struct file *filp, int mode);
-static void sg_cmd_done(Scsi_Cmnd * SCpnt);	/* tasklet or soft irq callback */
+static void sg_cmd_done(struct request *rq);	/* tasklet or soft irq callback */
 static int sg_start_req(Sg_request * srp);
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
-static int sg_read_xfer(Sg_request * srp);
-static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
-static void sg_remove_scat(Sg_scatter_hold * schp);
-static void sg_build_reserve(Sg_fd * sfp, int req_size);
-static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
-static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
 static char *sg_page_malloc(int rqSz, int lowDma, int *retSzp);
 static void sg_page_free(char *buff, int size);
 static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
@@ -206,11 +168,8 @@ static void __sg_remove_sfp(Sg_device * 
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
-static int sg_res_in_use(Sg_fd * sfp);
 static int sg_allow_access(unsigned char opcode, char dev_type);
-static int sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len);
 static Sg_device *sg_get_dev(int dev);
-static inline unsigned char *sg_scatg2virt(const struct scatterlist *sclp);
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
 #endif
@@ -418,7 +377,7 @@ sg_read(struct file *filp, char __user *
 	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
 	old_hdr->pack_id = hp->pack_id;
 	old_hdr->twelve_byte =
-	    ((srp->data.cmd_opcode >= 0xc0) && (12 == hp->cmd_len)) ? 1 : 0;
+	    ((srp->cmd_opcode >= 0xc0) && (12 == hp->cmd_len)) ? 1 : 0;
 	old_hdr->target_status = hp->masked_status;
 	old_hdr->host_status = hp->host_status;
 	old_hdr->driver_status = hp->driver_status;
@@ -465,13 +424,16 @@ sg_read(struct file *filp, char __user *
 		if (count > old_hdr->reply_len)
 			count = old_hdr->reply_len;
 		if (count > SZ_SG_HEADER) {
-			if (sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)) {
+			if (blk_rq_unmap_user(srp->bio, buf,
+					      count - SZ_SG_HEADER)) {
 				retval = -EFAULT;
+				/* srp leak ? */
 				goto free_old_hdr;
 			}
 		}
 	} else
 		count = (old_hdr->result == 0) ? 0 : -EIO;
+	srp->bio = NULL;
 	sg_finish_rem_req(srp);
 	retval = count;
 free_old_hdr:
@@ -487,6 +449,8 @@ sg_new_read(Sg_fd * sfp, char __user *bu
 	int err = 0;
 	int len;
 
+	printk(KERN_ERR "sg_new_read %d %d\n", count, hp->dxfer_len);
+
 	if (count < SZ_SG_IO_HDR) {
 		err = -EINVAL;
 		goto err_out;
@@ -495,7 +459,7 @@ sg_new_read(Sg_fd * sfp, char __user *bu
 	if ((hp->mx_sb_len > 0) && hp->sbp) {
 		if ((CHECK_CONDITION & hp->masked_status) ||
 		    (DRIVER_SENSE & hp->driver_status)) {
-			int sb_len = sizeof (dummy_cmdp->sr_sense_buffer);
+			int sb_len = SCSI_SENSE_BUFFERSIZE;
 			sb_len = (hp->mx_sb_len > sb_len) ? sb_len : hp->mx_sb_len;
 			len = 8 + (int) srp->sense_b[7];	/* Additional sense length field */
 			len = (len > sb_len) ? sb_len : len;
@@ -508,11 +472,12 @@ sg_new_read(Sg_fd * sfp, char __user *bu
 	}
 	if (hp->masked_status || hp->host_status || hp->driver_status)
 		hp->info |= SG_INFO_CHECK;
-	if (copy_to_user(buf, hp, SZ_SG_IO_HDR)) {
+	if (copy_to_user(buf, hp, SZ_SG_IO_HDR))
 		err = -EFAULT;
-		goto err_out;
-	}
-	err = sg_read_xfer(srp);
+		/* fall through and unmap the bio so we do not leak */
+	if (blk_rq_unmap_user(srp->bio, hp->dxferp, hp->dxfer_len))
+		err = -EFAULT;
+	srp->bio = NULL;
       err_out:
 	sg_finish_rem_req(srp);
 	return (0 == err) ? count : err;
@@ -529,7 +494,7 @@ sg_write(struct file *filp, const char _
 	Sg_request *srp;
 	struct sg_header old_hdr;
 	sg_io_hdr_t *hp;
-	unsigned char cmnd[sizeof (dummy_cmdp->sr_cmnd)];
+	unsigned char cmnd[MAX_COMMAND_SIZE];
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
@@ -628,7 +593,7 @@ sg_new_write(Sg_fd * sfp, const char __u
 	int k;
 	Sg_request *srp;
 	sg_io_hdr_t *hp;
-	unsigned char cmnd[sizeof (dummy_cmdp->sr_cmnd)];
+	unsigned char cmnd[MAX_COMMAND_SIZE];
 	int timeout;
 	unsigned long ul_timeout;
 
@@ -651,20 +616,9 @@ sg_new_write(Sg_fd * sfp, const char __u
 		sg_remove_request(sfp, srp);
 		return -ENOSYS;
 	}
-	if (hp->flags & SG_FLAG_MMAP_IO) {
-		if (hp->dxfer_len > sfp->reserve.bufflen) {
-			sg_remove_request(sfp, srp);
-			return -ENOMEM;	/* MMAP_IO size must fit in reserve buffer */
-		}
-		if (hp->flags & SG_FLAG_DIRECT_IO) {
-			sg_remove_request(sfp, srp);
-			return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
-		}
-		if (sg_res_in_use(sfp)) {
-			sg_remove_request(sfp, srp);
-			return -EBUSY;	/* reserve buffer already being used */
-		}
-	}
+	if (hp->flags & SG_FLAG_MMAP_IO)
+		return -EOPNOTSUPP;
+
 	ul_timeout = msecs_to_jiffies(srp->header.timeout);
 	timeout = (ul_timeout < INT_MAX) ? ul_timeout : INT_MAX;
 	if ((!hp->cmdp) || (hp->cmd_len < 6) || (hp->cmd_len > sizeof (cmnd))) {
@@ -697,12 +651,12 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 		unsigned char *cmnd, int timeout, int blocking)
 {
 	int k;
-	Scsi_Request *SRpnt;
 	Sg_device *sdp = sfp->parentdp;
 	sg_io_hdr_t *hp = &srp->header;
-	request_queue_t *q;
+	request_queue_t *q = sdp->device->request_queue;
+	struct request *rq;
 
-	srp->data.cmd_opcode = cmnd[0];	/* hold opcode of command */
+	srp->cmd_opcode = cmnd[0];	/* hold opcode of command */
 	hp->status = 0;
 	hp->masked_status = 0;
 	hp->msg_status = 0;
@@ -713,65 +667,53 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 	SCSI_LOG_TIMEOUT(4, printk("sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			  (int) cmnd[0], (int) hp->cmd_len));
 
-	if ((k = sg_start_req(srp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_write: start_req err=%d\n", k));
-		sg_finish_rem_req(srp);
-		return k;	/* probably out of space --> ENOMEM */
+	rq = blk_get_request(q, hp->dxfer_direction == SG_DXFER_TO_DEV,
+			     GFP_ATOMIC);
+	if (!rq) {
+		SCSI_LOG_TIMEOUT(1, printk("sg_write: no mem\n"));
+		return -ENOMEM;
 	}
-	if ((k = sg_write_xfer(srp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_write: write_xfer, bad address\n"));
-		sg_finish_rem_req(srp);
-		return k;
+	srp->my_cmdp = rq;
+
+	rq->sense = kcalloc(1, SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
+	if (!rq->sense) {
+		SCSI_LOG_TIMEOUT(1, printk("sg_write: no mem\n"));
+		k = -ENOMEM;
+		goto free_rq;
 	}
+	rq->sense_len = 0;
+
 	if (sdp->detached) {
-		sg_finish_rem_req(srp);
-		return -ENODEV;
-	}
-	SRpnt = scsi_allocate_request(sdp->device, GFP_ATOMIC);
-	if (SRpnt == NULL) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_write: no mem\n"));
-		sg_finish_rem_req(srp);
-		return -ENOMEM;
+		k = -ENODEV;
+		goto free_rq;
 	}
 
-	srp->my_cmdp = SRpnt;
-	q = SRpnt->sr_device->request_queue;
-	SRpnt->sr_request->rq_disk = sdp->disk;
-	SRpnt->sr_sense_buffer[0] = 0;
-	SRpnt->sr_cmd_len = hp->cmd_len;
-	SRpnt->sr_use_sg = srp->data.k_use_sg;
-	SRpnt->sr_sglist_len = srp->data.sglist_len;
-	SRpnt->sr_bufflen = srp->data.bufflen;
-	SRpnt->sr_underflow = 0;
-	SRpnt->sr_buffer = srp->data.buffer;
-	switch (hp->dxfer_direction) {
-	case SG_DXFER_TO_FROM_DEV:
-	case SG_DXFER_FROM_DEV:
-		SRpnt->sr_data_direction = DMA_FROM_DEVICE;
-		break;
-	case SG_DXFER_TO_DEV:
-		SRpnt->sr_data_direction = DMA_TO_DEVICE;
-		break;
-	case SG_DXFER_UNKNOWN:
-		SRpnt->sr_data_direction = DMA_BIDIRECTIONAL;
-		break;
-	default:
-		SRpnt->sr_data_direction = DMA_NONE;
-		break;
+	if ((k = sg_start_req(srp))) {
+		SCSI_LOG_TIMEOUT(1, printk("sg_write: start_req err=%d\n", k));
+		goto free_rq;	/* probably out of space --> ENOMEM */
 	}
-	SRpnt->upper_private_data = srp;
-	srp->data.k_use_sg = 0;
-	srp->data.sglist_len = 0;
-	srp->data.bufflen = 0;
-	srp->data.buffer = NULL;
+
+	rq->cmd_len = hp->cmd_len;
+	memcpy(rq->cmd, cmnd, rq->cmd_len);
+	rq->timeout = timeout;
+	rq->flags |= REQ_BLOCK_PC;
+	rq->end_io_data = srp;
+
+	srp->bio = rq->bio;
+	if (rq->bio)
+		blk_queue_bounce(q, &rq->bio);
+
 	hp->duration = jiffies_to_msecs(jiffies);
 /* Now send everything of to mid-level. The next time we hear about this
    packet is when sg_cmd_done() is called (i.e. a callback). */
-	scsi_do_req(SRpnt, (void *) cmnd,
-		    (void *) SRpnt->sr_buffer, hp->dxfer_len,
-		    sg_cmd_done, timeout, SG_DEFAULT_RETRIES);
-	/* dxfer_len overwrites SRpnt->sr_bufflen, hence need for b_malloc_len */
+	blk_execute_rq_nowait(q, NULL, rq, 1, sg_cmd_done);
 	return 0;
+
+ free_rq:
+	kfree(rq->sense);
+	blk_put_request(rq);
+	return k;
+
 }
 
 static int
@@ -856,25 +798,6 @@ sg_ioctl(struct inode *inode, struct fil
 	case SG_GET_TIMEOUT:	/* N.B. User receives timeout as return value */
 				/* strange ..., for backward compatibility */
 		return sfp->timeout_user;
-	case SG_SET_FORCE_LOW_DMA:
-		result = get_user(val, ip);
-		if (result)
-			return result;
-		if (val) {
-			sfp->low_dma = 1;
-			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
-				val = (int) sfp->reserve.bufflen;
-				sg_remove_scat(&sfp->reserve);
-				sg_build_reserve(sfp, val);
-			}
-		} else {
-			if (sdp->detached)
-				return -ENODEV;
-			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
-		}
-		return 0;
-	case SG_GET_LOW_DMA:
-		return put_user((int) sfp->low_dma, ip);
 	case SG_GET_SCSI_ID:
 		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t)))
 			return -EFAULT;
@@ -929,22 +852,6 @@ sg_ioctl(struct inode *inode, struct fil
 		return put_user(val, ip);
 	case SG_GET_SG_TABLESIZE:
 		return put_user(sdp->sg_tablesize, ip);
-	case SG_SET_RESERVED_SIZE:
-		result = get_user(val, ip);
-		if (result)
-			return result;
-                if (val < 0)
-                        return -EINVAL;
-		if (val != sfp->reserve.bufflen) {
-			if (sg_res_in_use(sfp) || sfp->mmap_called)
-				return -EBUSY;
-			sg_remove_scat(&sfp->reserve);
-			sg_build_reserve(sfp, val);
-		}
-		return 0;
-	case SG_GET_RESERVED_SIZE:
-		val = (int) sfp->reserve.bufflen;
-		return put_user(val, ip);
 	case SG_SET_COMMAND_Q:
 		result = get_user(val, ip);
 		if (result)
@@ -1080,6 +987,22 @@ sg_ioctl(struct inode *inode, struct fil
 		if (sdp->detached)
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
+	/*
+	 * These ioctls may or may not be needed any longer. Since we
+	 * use the block layer functions we will always have memory allocated
+	 * from the right place (sg's use of GFP_DMA is a little more
+	 * restricting than using the block layer's queue limits though) and
+	 * we will rely on the block layer reserving memory correctly.
+	 *
+ 	 * Bleh! So for testing we just lie.
+	 */
+	case SG_SET_FORCE_LOW_DMA:
+	case SG_SET_RESERVED_SIZE:
+		return 0;
+	case SG_GET_LOW_DMA:
+		return put_user(1, ip);
+	case SG_GET_RESERVED_SIZE:
+		return put_user(1048576, ip);
 	default:
 		if (read_only)
 			return -EPERM;	/* don't know so take safe approach */
@@ -1161,219 +1084,63 @@ sg_fasync(int fd, struct file *filp, int
 	return (retval < 0) ? retval : 0;
 }
 
-static inline unsigned char *
-sg_scatg2virt(const struct scatterlist *sclp)
-{
-	return (sclp && sclp->page) ?
-	    (unsigned char *) page_address(sclp->page) + sclp->offset : NULL;
-}
-
-/* When startFinish==1 increments page counts for pages other than the 
-   first of scatter gather elements obtained from __get_free_pages().
-   When startFinish==0 decrements ... */
 static void
-sg_rb_correct4mmap(Sg_scatter_hold * rsv_schp, int startFinish)
-{
-	void *page_ptr;
-	struct page *page;
-	int k, m;
-
-	SCSI_LOG_TIMEOUT(3, printk("sg_rb_correct4mmap: startFinish=%d, scatg=%d\n", 
-				   startFinish, rsv_schp->k_use_sg));
-	/* N.B. correction _not_ applied to base page of each allocation */
-	if (rsv_schp->k_use_sg) {	/* reserve buffer is a scatter gather list */
-		struct scatterlist *sclp = rsv_schp->buffer;
-
-		for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sclp) {
-			for (m = PAGE_SIZE; m < sclp->length; m += PAGE_SIZE) {
-				page_ptr = sg_scatg2virt(sclp) + m;
-				page = virt_to_page(page_ptr);
-				if (startFinish)
-					get_page(page);
-				else {
-					if (page_count(page) > 0)
-						__put_page(page);
-				}
-			}
-		}
-	} else {		/* reserve buffer is just a single allocation */
-		for (m = PAGE_SIZE; m < rsv_schp->bufflen; m += PAGE_SIZE) {
-			page_ptr = (unsigned char *) rsv_schp->buffer + m;
-			page = virt_to_page(page_ptr);
-			if (startFinish)
-				get_page(page);
-			else {
-				if (page_count(page) > 0)
-					__put_page(page);
-			}
-		}
-	}
-}
-
-static struct page *
-sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
-{
-	Sg_fd *sfp;
-	struct page *page = NOPAGE_SIGBUS;
-	void *page_ptr = NULL;
-	unsigned long offset;
-	Sg_scatter_hold *rsv_schp;
-
-	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return page;
-	rsv_schp = &sfp->reserve;
-	offset = addr - vma->vm_start;
-	if (offset >= rsv_schp->bufflen)
-		return page;
-	SCSI_LOG_TIMEOUT(3, printk("sg_vma_nopage: offset=%lu, scatg=%d\n",
-				   offset, rsv_schp->k_use_sg));
-	if (rsv_schp->k_use_sg) {	/* reserve buffer is a scatter gather list */
-		int k;
-		unsigned long sa = vma->vm_start;
-		unsigned long len;
-		struct scatterlist *sclp = rsv_schp->buffer;
-
-		for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-		     ++k, ++sclp) {
-			len = vma->vm_end - sa;
-			len = (len < sclp->length) ? len : sclp->length;
-			if (offset < len) {
-				page_ptr = sg_scatg2virt(sclp) + offset;
-				page = virt_to_page(page_ptr);
-				get_page(page);	/* increment page count */
-				break;
-			}
-			sa += len;
-			offset -= len;
-		}
-	} else {		/* reserve buffer is just a single allocation */
-		page_ptr = (unsigned char *) rsv_schp->buffer + offset;
-		page = virt_to_page(page_ptr);
-		get_page(page);	/* increment page count */
-	}
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
-}
-
-static struct vm_operations_struct sg_mmap_vm_ops = {
-	.nopage = sg_vma_nopage,
-};
-
-static int
-sg_mmap(struct file *filp, struct vm_area_struct *vma)
+sg_free_request(struct request *rq)
 {
-	Sg_fd *sfp;
-	unsigned long req_sz;
-	Sg_scatter_hold *rsv_schp;
-
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
-		return -ENXIO;
-	req_sz = vma->vm_end - vma->vm_start;
-	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p, len=%d\n",
-				   (void *) vma->vm_start, (int) req_sz));
-	if (vma->vm_pgoff)
-		return -EINVAL;	/* want no offset */
-	rsv_schp = &sfp->reserve;
-	if (req_sz > rsv_schp->bufflen)
-		return -ENOMEM;	/* cannot map more than reserved buffer */
-
-	if (rsv_schp->k_use_sg) { /* reserve buffer is a scatter gather list */
-		int k;
-		unsigned long sa = vma->vm_start;
-		unsigned long len;
-		struct scatterlist *sclp = rsv_schp->buffer;
-
-		for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-		     ++k, ++sclp) {
-			if (0 != sclp->offset)
-				return -EFAULT;	/* non page aligned memory ?? */
-			len = vma->vm_end - sa;
-			len = (len < sclp->length) ? len : sclp->length;
-			sa += len;
-		}
-	} else {	/* reserve buffer is just a single allocation */
-		if ((unsigned long) rsv_schp->buffer & (PAGE_SIZE - 1))
-			return -EFAULT;	/* non page aligned memory ?? */
-	}
-	if (0 == sfp->mmap_called) {
-		sg_rb_correct4mmap(rsv_schp, 1);	/* do only once per fd lifetime */
-		sfp->mmap_called = 1;
-	}
-	vma->vm_flags |= (VM_RESERVED | VM_IO);
-	vma->vm_private_data = sfp;
-	vma->vm_ops = &sg_mmap_vm_ops;
-	return 0;
+	kfree(rq->sense);
+	__blk_put_request(rq->q, rq);
 }
 
 /* This function is a "bottom half" handler that is called by the
- * mid level when a command is completed (or has failed). */
+ * block layer when a command is completed (or has failed). */
 static void
-sg_cmd_done(Scsi_Cmnd * SCpnt)
+sg_cmd_done(struct request *rq)
 {
-	Scsi_Request *SRpnt = NULL;
+	Sg_request *srp = rq->end_io_data;
+	Sg_fd *sfp = srp->parentfp;
 	Sg_device *sdp = NULL;
-	Sg_fd *sfp;
-	Sg_request *srp = NULL;
 	unsigned long iflags;
 	unsigned int ms;
 
-	if (SCpnt && (SRpnt = SCpnt->sc_request))
-		srp = (Sg_request *) SRpnt->upper_private_data;
-	if (NULL == srp) {
-		printk(KERN_ERR "sg_cmd_done: NULL request\n");
-		if (SRpnt)
-			scsi_release_request(SRpnt);
-		return;
-	}
-	sfp = srp->parentfp;
 	if (sfp)
 		sdp = sfp->parentdp;
 	if ((NULL == sdp) || sdp->detached) {
 		printk(KERN_INFO "sg_cmd_done: device detached\n");
-		scsi_release_request(SRpnt);
+		sg_free_request(rq);
 		return;
 	}
 
-	/* First transfer ownership of data buffers to sg_device object. */
-	srp->data.k_use_sg = SRpnt->sr_use_sg;
-	srp->data.sglist_len = SRpnt->sr_sglist_len;
-	srp->data.bufflen = SRpnt->sr_bufflen;
-	srp->data.buffer = SRpnt->sr_buffer;
-	/* now clear out request structure */
-	SRpnt->sr_use_sg = 0;
-	SRpnt->sr_sglist_len = 0;
-	SRpnt->sr_bufflen = 0;
-	SRpnt->sr_buffer = NULL;
-	SRpnt->sr_underflow = 0;
-	SRpnt->sr_request->rq_disk = NULL; /* "sg" _disowns_ request blk */
-
 	srp->my_cmdp = NULL;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
-		sdp->disk->disk_name, srp->header.pack_id, (int) SRpnt->sr_result));
-	srp->header.resid = SCpnt->resid;
+		sdp->disk->disk_name, srp->header.pack_id, (int) rq->errors));
+
+	/*
+	 * TODO combine sg completion paths
+	 */
+	srp->header.resid = rq->data_len; 
 	ms = jiffies_to_msecs(jiffies);
 	srp->header.duration = (ms > srp->header.duration) ?
 				(ms - srp->header.duration) : 0;
-	if (0 != SRpnt->sr_result) {
+	if (0 != rq->errors) {
 		struct scsi_sense_hdr sshdr;
 
-		memcpy(srp->sense_b, SRpnt->sr_sense_buffer,
-		       sizeof (srp->sense_b));
-		srp->header.status = 0xff & SRpnt->sr_result;
-		srp->header.masked_status = status_byte(SRpnt->sr_result);
-		srp->header.msg_status = msg_byte(SRpnt->sr_result);
-		srp->header.host_status = host_byte(SRpnt->sr_result);
-		srp->header.driver_status = driver_byte(SRpnt->sr_result);
+		printk(KERN_ERR "sg_cmnd_done %d\n",  rq->errors);
+
+		memcpy(srp->sense_b, rq->sense, sizeof (srp->sense_b));
+		srp->header.status = 0xff & rq->errors;
+		srp->header.masked_status = status_byte(rq->errors);
+		srp->header.msg_status = msg_byte(rq->errors);
+		srp->header.host_status = host_byte(rq->errors);
+		srp->header.driver_status = driver_byte(rq->errors);
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			scsi_print_req_sense("sg_cmd_done", SRpnt);
+			scsi_print_rq_sense("sg_cmd_done", rq);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
-		if (driver_byte(SRpnt->sr_result) != 0
-		    && scsi_command_normalize_sense(SCpnt, &sshdr)
+		if (driver_byte(rq->errors) != 0
+		    && scsi_rq_normalize_sense(rq, &sshdr)
 		    && !scsi_sense_is_deferred(&sshdr)
 		    && sshdr.sense_key == UNIT_ATTENTION
 		    && sdp->device->removable) {
@@ -1384,8 +1151,8 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
 	}
 	/* Rely on write phase to clean out srp status values, so no "else" */
 
-	scsi_release_request(SRpnt);
-	SRpnt = NULL;
+	sg_free_request(rq);
+
 	if (sfp->closed) {	/* whoops this fd already released, cleanup */
 		SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, freeing ...\n"));
 		sg_finish_rem_req(srp);
@@ -1425,7 +1192,6 @@ static struct file_operations sg_fops = 
 	.compat_ioctl = sg_compat_ioctl,
 #endif
 	.open = sg_open,
-	.mmap = sg_mmap,
 	.release = sg_release,
 	.fasync = sg_fasync,
 };
@@ -1654,25 +1420,17 @@ sg_remove(struct class_device *cl_dev)
  * of sysfs parameters (which module_param doesn't yet support).
  * Sysfs parameters defined explicitly below.
  */
-module_param_named(def_reserved_size, def_reserved_size, int, S_IRUGO);
-module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
 
 MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(SG_VERSION_STR);
 
-MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
-MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
-
 static int __init
 init_sg(void)
 {
 	int rc;
 
-	if (def_reserved_size >= 0)
-		sg_big_buff = def_reserved_size;
-
 	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), 
 				    SG_MAX_DEVS, "sg");
 	if (rc)
@@ -1717,668 +1475,57 @@ exit_sg(void)
 static int
 sg_start_req(Sg_request * srp)
 {
-	int res;
-	Sg_fd *sfp = srp->parentfp;
 	sg_io_hdr_t *hp = &srp->header;
+	struct request *rq = srp->my_cmdp;
 	int dxfer_len = (int) hp->dxfer_len;
-	int dxfer_dir = hp->dxfer_direction;
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
-	int ret_sz;
-	int elem_sz = sizeof (struct scatterlist);
-	int sg_bufflen = tablesize * elem_sz;
-	int mx_sc_elems = tablesize;
-
-	schp->buffer = sg_page_malloc(sg_bufflen, sfp->low_dma, &ret_sz);
-	if (!schp->buffer)
-		return -ENOMEM;
-	else if (ret_sz != sg_bufflen) {
-		sg_bufflen = ret_sz;
-		mx_sc_elems = sg_bufflen / elem_sz;
-	}
-	schp->sglist_len = sg_bufflen;
-	memset(schp->buffer, 0, sg_bufflen);
-	return mx_sc_elems;	/* number of scat_gath elements allocated */
-}
-
-#ifdef SG_ALLOW_DIO_CODE
-/* vvvvvvvv  following code borrowed from st driver's direct IO vvvvvvvvv */
-	/* hopefully this generic code will moved to a library */
-
-/* Pin down user pages and put them into a scatter gather list. Returns <= 0 if
-   - mapping of all pages not successful
-   - any page is above max_pfn
-   (i.e., either completely successful or fails)
-*/
-static int 
-st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
-	          unsigned long uaddr, size_t count, int rw,
-	          unsigned long max_pfn)
-{
-	int res, i, j;
-	unsigned int nr_pages;
-	struct page **pages;
-
-	nr_pages = ((uaddr & ~PAGE_MASK) + count + ~PAGE_MASK) >> PAGE_SHIFT;
-
-	/* User attempted Overflow! */
-	if ((uaddr + count) < uaddr)
-		return -EINVAL;
-
-	/* Too big */
-        if (nr_pages > max_pages)
-		return -ENOMEM;
-
-	/* Hmm? */
-	if (count == 0)
-		return 0;
-
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
-		if (page_to_pfn(pages[i]) > max_pfn)
-			goto out_unlock;
-		/* ?? Is locking needed? I don't think so */
-		/* if (TestSetPageLocked(pages[i]))
-		   goto out_unlock; */
-        }
-
-	/* Populate the scatter/gather list */
-	sgl[0].page = pages[0]; 
-	sgl[0].offset = uaddr & ~PAGE_MASK;
-	if (nr_pages > 1) {
-		sgl[0].length = PAGE_SIZE - sgl[0].offset;
-		count -= sgl[0].length;
-		for (i=1; i < nr_pages ; i++) {
-			sgl[i].offset = 0;
-			sgl[i].page = pages[i]; 
-			sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
-			count -= PAGE_SIZE;
-		}
-	}
-	else {
-		sgl[0].length = count;
-	}
-
-	kfree(pages);
-	return nr_pages;
-
- out_unlock:
-	/* for (j=0; j < i; j++)
-	   unlock_page(pages[j]); */
-	res = 0;
- out_unmap:
-	if (res > 0)
-		for (j=0; j < res; j++)
-			page_cache_release(pages[j]);
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
-		if (dirtied && !PageReserved(sgl[i].page))
-			SetPageDirty(sgl[i].page);
-		/* unlock_page(sgl[i].page); */
-		/* FIXME: cache flush missing for rw==READ
-		 * FIXME: call the correct reference counting function
-		 */
-		page_cache_release(sgl[i].page);
-	}
-
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
-	struct scatterlist *sgl;
-	int mx_sc_elems, res;
-	struct scsi_device *sdev = sfp->parentdp->device;
-
-	if (((unsigned long)hp->dxferp &
-			queue_dma_alignment(sdev->request_queue)) != 0)
-		return 1;
-	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
-        if (mx_sc_elems <= 0) {
-                return 1;
-        }
-	sgl = (struct scatterlist *)schp->buffer;
-	res = st_map_user_pages(sgl, mx_sc_elems, (unsigned long)hp->dxferp, dxfer_len, 
-				(SG_DXFER_TO_DEV == hp->dxfer_direction) ? 1 : 0, ULONG_MAX);
-	if (res <= 0)
-		return 1;
-	schp->k_use_sg = res;
-	schp->dio_in_use = 1;
-	hp->info |= SG_INFO_DIRECT_IO;
-	return 0;
-#else
-	return 1;
-#endif
-}
-
-static int
-sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
-{
-	int ret_sz;
-	int blk_size = buff_size;
-	unsigned char *p = NULL;
-
-	if ((blk_size < 0) || (!sfp))
-		return -EFAULT;
-	if (0 == blk_size)
-		++blk_size;	/* don't know why */
-/* round request up to next highest SG_SECTOR_SZ byte boundary */
-	blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
-	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, blk_size=%d\n",
-				   buff_size, blk_size));
-	if (blk_size <= SG_SCATTER_SZ) {
-		p = sg_page_malloc(blk_size, sfp->low_dma, &ret_sz);
-		if (!p)
-			return -ENOMEM;
-		if (blk_size == ret_sz) {	/* got it on the first attempt */
-			schp->k_use_sg = 0;
-			schp->buffer = p;
-			schp->bufflen = blk_size;
-			schp->b_malloc_len = blk_size;
-			return 0;
-		}
-	} else {
-		p = sg_page_malloc(SG_SCATTER_SZ, sfp->low_dma, &ret_sz);
-		if (!p)
-			return -ENOMEM;
-	}
-/* Want some local declarations, so start new block ... */
-	{			/* lets try and build a scatter gather list */
-		struct scatterlist *sclp;
-		int k, rem_sz, num;
-		int mx_sc_elems;
-		int sg_tablesize = sfp->parentdp->sg_tablesize;
-		int first = 1;
-
-		/* N.B. ret_sz carried into this block ... */
-		mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
-		if (mx_sc_elems < 0)
-			return mx_sc_elems;	/* most likely -ENOMEM */
-
-		for (k = 0, sclp = schp->buffer, rem_sz = blk_size;
-		     (rem_sz > 0) && (k < mx_sc_elems);
-		     ++k, rem_sz -= ret_sz, ++sclp) {
-			if (first)
-				first = 0;
-			else {
-				num =
-				    (rem_sz >
-				     SG_SCATTER_SZ) ? SG_SCATTER_SZ : rem_sz;
-				p = sg_page_malloc(num, sfp->low_dma, &ret_sz);
-				if (!p)
-					break;
-			}
-			sclp->page = virt_to_page(p);
-			sclp->offset = offset_in_page(p);
-			sclp->length = ret_sz;
-
-			SCSI_LOG_TIMEOUT(5, printk("sg_build_build: k=%d, a=0x%p, len=%d\n",
-					  k, sg_scatg2virt(sclp), ret_sz));
-		}		/* end of for loop */
-		schp->k_use_sg = k;
-		SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, rem_sz=%d\n", k, rem_sz));
-		schp->bufflen = blk_size;
-		if (rem_sz > 0)	/* must have failed */
-			return -ENOMEM;
-	}
-	return 0;
-}
-
-static int
-sg_write_xfer(Sg_request * srp)
-{
-	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
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
-	}
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
-
-	if (0 == schp->k_use_sg) {	/* kernel has single buffer */
-		for (j = 0, p = schp->buffer; j < onum; ++j) {
-			res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
-			if (res)
-				return res;
-			usglen = (num_xfer > usglen) ? usglen : num_xfer;
-			if (__copy_from_user(p, up, usglen))
-				return -EFAULT;
-			p += usglen;
-			num_xfer -= usglen;
-			if (num_xfer <= 0)
-				return 0;
-		}
-	} else {		/* kernel using scatter gather list */
-		struct scatterlist *sclp = (struct scatterlist *) schp->buffer;
-
-		ksglen = (int) sclp->length;
-		p = sg_scatg2virt(sclp);
-		for (j = 0, k = 0; j < onum; ++j) {
-			res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
-			if (res)
-				return res;
-
-			for (; p; ++sclp, ksglen = (int) sclp->length,
-				  p = sg_scatg2virt(sclp)) {
-				if (usglen <= 0)
-					break;
-				if (ksglen > usglen) {
-					if (usglen >= num_xfer) {
-						if (__copy_from_user
-						    (p, up, num_xfer))
-							return -EFAULT;
-						return 0;
-					}
-					if (__copy_from_user(p, up, usglen))
-						return -EFAULT;
-					p += usglen;
-					ksglen -= usglen;
-					break;
-				} else {
-					if (ksglen >= num_xfer) {
-						if (__copy_from_user
-						    (p, up, num_xfer))
-							return -EFAULT;
-						return 0;
-					}
-					if (__copy_from_user(p, up, ksglen))
-						return -EFAULT;
-					up += ksglen;
-					usglen -= ksglen;
-				}
-				++k;
-				if (k >= schp->k_use_sg)
-					return 0;
-			}
-		}
-	}
-	return 0;
-}
+	int new_intf = ('\0' == hp->interface_id) ? 0 : 1;
+	int ret = 0;
 
-static int
-sg_u_iovec(sg_io_hdr_t * hp, int sg_num, int ind,
-	   int wr_xf, int *countp, unsigned char __user **up)
-{
-	int num_xfer = (int) hp->dxfer_len;
-	unsigned char __user *p = hp->dxferp;
-	int count;
-
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
-}
-
-static void
-sg_remove_scat(Sg_scatter_hold * schp)
-{
-	SCSI_LOG_TIMEOUT(4, printk("sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
-	if (schp->buffer && (schp->sglist_len > 0)) {
-		struct scatterlist *sclp = (struct scatterlist *) schp->buffer;
-
-		if (schp->dio_in_use) {
-#ifdef SG_ALLOW_DIO_CODE
-			st_unmap_user_pages(sclp, schp->k_use_sg, TRUE);
-#endif
-		} else {
-			int k;
+	SCSI_LOG_TIMEOUT(4, printk("sg_start_req: dxfer_len=%d\n",
+				   dxfer_len));
 
-			for (k = 0; (k < schp->k_use_sg) && sg_scatg2virt(sclp);
-			     ++k, ++sclp) {
-				SCSI_LOG_TIMEOUT(5, printk(
-				    "sg_remove_scat: k=%d, a=0x%p, len=%d\n",
-				    k, sg_scatg2virt(sclp), sclp->length));
-				sg_page_free(sg_scatg2virt(sclp), sclp->length);
-				sclp->page = NULL;
-				sclp->offset = 0;
-				sclp->length = 0;
-			}
+	if (dxfer_len <= 0 || hp->dxfer_direction == SG_DXFER_NONE)
+		return ret;
+	/*
+	 * For the old interface we must always do copy from/to user
+	 * so we set zero_copy=1 (we actually could do zero copy if
+	 * we are only doing a write here too).
+	 * For the new interface we will try map iovec, then dio, then
+	 * kernel bounce buffers.
+	 */
+	if (!new_intf)
+		ret = blk_rq_map_user(rq->q, rq, hp->dxferp, dxfer_len, 0);
+	else if (hp->iovec_count) {
+		const int size = sizeof(struct sg_iovec) * hp->iovec_count;
+		struct sg_iovec *iov;
+
+		iov = kmalloc(size, GFP_KERNEL);
+		if (!iov) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		if (copy_from_user(iov, hp->dxferp, size)) {
+			kfree(iov);
+			ret = -EFAULT;
+			goto out;
 		}
-		sg_page_free(schp->buffer, schp->sglist_len);
-	} else if (schp->buffer)
-		sg_page_free(schp->buffer, schp->b_malloc_len);
-	memset(schp, 0, sizeof (*schp));
-}
 
-static int
-sg_read_xfer(Sg_request * srp)
-{
-	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
-	int num_xfer = 0;
-	int j, k, onum, usglen, ksglen, res;
-	int iovec_count = (int) hp->iovec_count;
-	int dxfer_dir = hp->dxfer_direction;
-	unsigned char *p;
-	unsigned char __user *up;
-	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
-
-	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_FROM_DEV == dxfer_dir)
-	    || (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
-		num_xfer = hp->dxfer_len;
-		if (schp->bufflen < num_xfer)
-			num_xfer = schp->bufflen;
-	}
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
+		ret = blk_rq_map_user_iov(rq->q, rq, iov, hp->iovec_count);
+		kfree(iov);
 	} else
-		onum = 1;
-
-	if (0 == schp->k_use_sg) {	/* kernel has single buffer */
-		for (j = 0, p = schp->buffer; j < onum; ++j) {
-			res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
-			if (res)
-				return res;
-			usglen = (num_xfer > usglen) ? usglen : num_xfer;
-			if (__copy_to_user(up, p, usglen))
-				return -EFAULT;
-			p += usglen;
-			num_xfer -= usglen;
-			if (num_xfer <= 0)
-				return 0;
-		}
-	} else {		/* kernel using scatter gather list */
-		struct scatterlist *sclp = (struct scatterlist *) schp->buffer;
-
-		ksglen = (int) sclp->length;
-		p = sg_scatg2virt(sclp);
-		for (j = 0, k = 0; j < onum; ++j) {
-			res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
-			if (res)
-				return res;
-
-			for (; p; ++sclp, ksglen = (int) sclp->length,
-				  p = sg_scatg2virt(sclp)) {
-				if (usglen <= 0)
-					break;
-				if (ksglen > usglen) {
-					if (usglen >= num_xfer) {
-						if (__copy_to_user
-						    (up, p, num_xfer))
-							return -EFAULT;
-						return 0;
-					}
-					if (__copy_to_user(up, p, usglen))
-						return -EFAULT;
-					p += usglen;
-					ksglen -= usglen;
-					break;
-				} else {
-					if (ksglen >= num_xfer) {
-						if (__copy_to_user
-						    (up, p, num_xfer))
-							return -EFAULT;
-						return 0;
-					}
-					if (__copy_to_user(up, p, ksglen))
-						return -EFAULT;
-					up += ksglen;
-					usglen -= ksglen;
-				}
-				++k;
-				if (k >= schp->k_use_sg)
-					return 0;
-			}
-		}
-	}
-	return 0;
-}
-
-static int
-sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
-{
-	Sg_scatter_hold *schp = &srp->data;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_read_oxfer: num_read_xfer=%d\n",
-				   num_read_xfer));
-	if ((!outp) || (num_read_xfer <= 0))
-		return 0;
-	if (schp->k_use_sg > 0) {
-		int k, num;
-		struct scatterlist *sclp = (struct scatterlist *) schp->buffer;
-
-		for (k = 0; (k < schp->k_use_sg) && sg_scatg2virt(sclp);
-		     ++k, ++sclp) {
-			num = (int) sclp->length;
-			if (num > num_read_xfer) {
-				if (__copy_to_user
-				    (outp, sg_scatg2virt(sclp), num_read_xfer))
-					return -EFAULT;
-				break;
-			} else {
-				if (__copy_to_user
-				    (outp, sg_scatg2virt(sclp), num))
-					return -EFAULT;
-				num_read_xfer -= num;
-				if (num_read_xfer <= 0)
-					break;
-				outp += num;
-			}
-		}
-	} else {
-		if (__copy_to_user(outp, schp->buffer, num_read_xfer))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static void
-sg_build_reserve(Sg_fd * sfp, int req_size)
-{
-	Sg_scatter_hold *schp = &sfp->reserve;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_build_reserve: req_size=%d\n", req_size));
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
-
-static void
-sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
-{
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
-
-	srp->res_used = 1;
-	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
-	size = (size + 1) & (~1);	/* round to even for aha1542 */
-	if (rsv_schp->k_use_sg > 0) {
-		int k, num;
-		int rem = size;
-		struct scatterlist *sclp =
-		    (struct scatterlist *) rsv_schp->buffer;
-
-		for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sclp) {
-			num = (int) sclp->length;
-			if (rem <= num) {
-				if (0 == k) {
-					req_schp->k_use_sg = 0;
-					req_schp->buffer = sg_scatg2virt(sclp);
-				} else {
-					sfp->save_scat_len = num;
-					sclp->length = (unsigned) rem;
-					req_schp->k_use_sg = k + 1;
-					req_schp->sglist_len =
-					    rsv_schp->sglist_len;
-					req_schp->buffer = rsv_schp->buffer;
-				}
-				req_schp->bufflen = size;
-				req_schp->b_malloc_len = rsv_schp->b_malloc_len;
-				break;
-			} else
-				rem -= num;
-		}
-		if (k >= rsv_schp->k_use_sg)
-			SCSI_LOG_TIMEOUT(1, printk("sg_link_reserve: BAD size\n"));
-	} else {
-		req_schp->k_use_sg = 0;
-		req_schp->bufflen = size;
-		req_schp->buffer = rsv_schp->buffer;
-		req_schp->b_malloc_len = rsv_schp->b_malloc_len;
-	}
+		ret = blk_rq_map_user(rq->q, rq, hp->dxferp, dxfer_len, 1);
+ out:
+	return ret;
 }
 
 static void
-sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
+sg_finish_rem_req(Sg_request * srp)
 {
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	Sg_fd *sfp = srp->parentfp;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_unlink_reserve: req->k_use_sg=%d\n",
-				   (int) req_schp->k_use_sg));
-	if ((rsv_schp->k_use_sg > 0) && (req_schp->k_use_sg > 0)) {
-		struct scatterlist *sclp =
-		    (struct scatterlist *) rsv_schp->buffer;
-
-		if (sfp->save_scat_len > 0)
-			(sclp + (req_schp->k_use_sg - 1))->length =
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
+	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req\n"));
+	sg_remove_request(sfp, srp);
 }
 
 static Sg_request *
@@ -2473,7 +1620,7 @@ sg_remove_request(Sg_fd * sfp, Sg_reques
 		return res;
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (srp->my_cmdp)
-		srp->my_cmdp->upper_private_data = NULL;
+		srp->my_cmdp->end_io_data = NULL;
 	prev_rp = sfp->headrp;
 	if (srp == prev_rp) {
 		sfp->headrp = prev_rp->nextrp;
@@ -2542,9 +1689,6 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	}
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
-	sg_build_reserve(sfp, sg_big_buff);
-	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
-			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
 	return sfp;
 }
 
@@ -2566,14 +1710,7 @@ __sg_remove_sfp(Sg_device * sdp, Sg_fd *
 			prev_fp = fp;
 		}
 	}
-	if (sfp->reserve.bufflen > 0) {
-		SCSI_LOG_TIMEOUT(6, 
-			printk("__sg_remove_sfp:    bufflen=%d, k_use_sg=%d\n",
-			(int) sfp->reserve.bufflen, (int) sfp->reserve.k_use_sg));
-		if (sfp->mmap_called)
-			sg_rb_correct4mmap(&sfp->reserve, 0);	/* undo correction */
-		sg_remove_scat(&sfp->reserve);
-	}
+
 	sfp->parentdp = NULL;
 	SCSI_LOG_TIMEOUT(6, printk("__sg_remove_sfp:    sfp=0x%p\n", sfp));
 	sg_page_free((char *) sfp, sizeof (Sg_fd));
@@ -2626,20 +1763,6 @@ sg_remove_sfp(Sg_device * sdp, Sg_fd * s
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
 /* If retSzp==NULL want exact size or fail */
 static char *
 sg_page_malloc(int rqSz, int lowDma, int *retSzp)
@@ -2748,27 +1871,6 @@ static struct proc_dir_entry *sg_proc_sg
 
 static char sg_proc_sg_dirname[] = "scsi/sg";
 
-static int sg_proc_seq_show_int(struct seq_file *s, void *v);
-
-static int sg_proc_single_open_adio(struct inode *inode, struct file *file);
-static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
-			          size_t count, loff_t *off);
-static struct file_operations adio_fops = {
-	/* .owner, .read and .llseek added in sg_proc_init() */
-	.open = sg_proc_single_open_adio,
-	.write = sg_proc_write_adio,
-	.release = single_release,
-};
-
-static int sg_proc_single_open_dressz(struct inode *inode, struct file *file);
-static ssize_t sg_proc_write_dressz(struct file *filp, 
-		const char __user *buffer, size_t count, loff_t *off);
-static struct file_operations dressz_fops = {
-	.open = sg_proc_single_open_dressz,
-	.write = sg_proc_write_dressz,
-	.release = single_release,
-};
-
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
 static int sg_proc_single_open_version(struct inode *inode, struct file *file);
 static struct file_operations version_fops = {
@@ -2832,9 +1934,7 @@ struct sg_proc_leaf {
 };
 
 static struct sg_proc_leaf sg_proc_leaf_arr[] = {
-	{"allow_dio", &adio_fops},
 	{"debug", &debug_fops},
-	{"def_reserved_size", &dressz_fops},
 	{"device_hdr", &devhdr_fops},
 	{"devices", &dev_fops},
 	{"device_strs", &devstrs_fops},
@@ -2882,62 +1982,6 @@ sg_proc_cleanup(void)
 	remove_proc_entry(sg_proc_sg_dirname, NULL);
 }
 
-
-static int sg_proc_seq_show_int(struct seq_file *s, void *v)
-{
-	seq_printf(s, "%d\n", *((int *)s->private));
-	return 0;
-}
-
-static int sg_proc_single_open_adio(struct inode *inode, struct file *file)
-{
-	return single_open(file, sg_proc_seq_show_int, &sg_allow_dio);
-}
-
-static ssize_t 
-sg_proc_write_adio(struct file *filp, const char __user *buffer,
-		   size_t count, loff_t *off)
-{
-	int num;
-	char buff[11];
-
-	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-		return -EACCES;
-	num = (count < 10) ? count : 10;
-	if (copy_from_user(buff, buffer, num))
-		return -EFAULT;
-	buff[num] = '\0';
-	sg_allow_dio = simple_strtoul(buff, NULL, 10) ? 1 : 0;
-	return count;
-}
-
-static int sg_proc_single_open_dressz(struct inode *inode, struct file *file)
-{
-	return single_open(file, sg_proc_seq_show_int, &sg_big_buff);
-}
-
-static ssize_t 
-sg_proc_write_dressz(struct file *filp, const char __user *buffer,
-		     size_t count, loff_t *off)
-{
-	int num;
-	unsigned long k = ULONG_MAX;
-	char buff[11];
-
-	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-		return -EACCES;
-	num = (count < 10) ? count : 10;
-	if (copy_from_user(buff, buffer, num))
-		return -EFAULT;
-	buff[num] = '\0';
-	k = simple_strtoul(buff, NULL, 10);
-	if (k <= 1048576) {	/* limit "big buff" to 1 MB */
-		sg_big_buff = k;
-		return count;
-	}
-	return -ERANGE;
-}
-
 static int sg_proc_seq_show_version(struct seq_file *s, void *v)
 {
 	seq_printf(s, "%d\t%s [%s]\n", sg_version_num, SG_VERSION_STR,
@@ -3053,11 +2097,9 @@ static void sg_proc_debug_helper(struct 
 	unsigned int ms;
 
 	for (k = 0; (fp = sg_get_nth_sfp(sdp, k)); ++k) {
-		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
-			   "(res)sgat=%d low_dma=%d\n", k + 1,
+		seq_printf(s, "   FD(%d): timeout=%dms "
+			   "low_dma=%d\n", k + 1,
 			   jiffies_to_msecs(fp->timeout),
-			   fp->reserve.bufflen,
-			   (int) fp->reserve.k_use_sg,
 			   (int) fp->low_dma);
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=%d\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
@@ -3065,23 +2107,15 @@ static void sg_proc_debug_helper(struct 
 		for (m = 0; (srp = sg_get_nth_request(fp, m)); ++m) {
 			hp = &srp->header;
 			new_interface = (hp->interface_id == '\0') ? 0 : 1;
-			if (srp->res_used) {
-				if (new_interface && 
-				    (SG_FLAG_MMAP_IO & hp->flags))
-					cp = "     mmap>> ";
-				else
-					cp = "     rb>> ";
-			} else {
-				if (SG_INFO_DIRECT_IO_MASK & hp->info)
-					cp = "     dio>> ";
-				else
-					cp = "     ";
-			}
+			if (SG_INFO_DIRECT_IO_MASK & hp->info)
+				cp = "     dio>> ";
+			else
+				cp = "     ";
 			seq_printf(s, cp);
 			blen = srp->my_cmdp ? 
-				srp->my_cmdp->sr_bufflen : srp->data.bufflen;
+				srp->my_cmdp->hard_cur_sectors << 9 : 0;
 			usg = srp->my_cmdp ? 
-				srp->my_cmdp->sr_use_sg : srp->data.k_use_sg;
+				srp->my_cmdp->nr_hw_segments : 0;
 			seq_printf(s, srp->done ? 
 				   ((1 == srp->done) ?  "rcv:" : "fin:")
 				   : (srp->my_cmdp ? "act:" : "prior:"));
@@ -3097,7 +2131,7 @@ static void sg_proc_debug_helper(struct 
 					(ms > hp->duration ? ms - hp->duration : 0));
 			}
 			seq_printf(s, "ms sgat=%d op=0x%02x\n", usg,
-				   (int) srp->data.cmd_opcode);
+				   (int) srp->cmd_opcode);
 		}
 		if (0 == m)
 			seq_printf(s, "     No requests active\n");
@@ -3117,7 +2151,6 @@ static int sg_proc_seq_show_debug(struct
 	if (it && (0 == it->index)) {
 		seq_printf(s, "dev_max(currently)=%d max_active_device=%d "
 			   "(origin 1)\n", sg_dev_max, (int)it->max);
-		seq_printf(s, " def_reserved_size=%d\n", sg_big_buff);
 	}
 	sdp = it ? sg_get_dev(it->index) : NULL;
 	if (sdp) {


