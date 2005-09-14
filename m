From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC/RFT 3/4] convert sg
Date: Wed, 14 Sep 2005 17:19:49 -0500
Message-ID: <1126736390.16778.26.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:1732 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030221AbVINWUR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 18:20:17 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8EMKBmj021634
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2005 17:20:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Convert sg to always to scatterlist IO.

This is not the complete cleanup I wanted to do, but nothing should
be broken like in my past patches. st and osst can be converted to
use the same interface. Eventually, I would like to convert them
to use the blk_rq_map_user* functions but becuase of the
large requests and them reserving the buffers themselves, and
sg's mmap code I coverted them to use the map_kern_iov function
first.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -49,6 +49,7 @@ static int sg_version_num = 30533;	/* 2 
 #include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/uio.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -107,8 +108,6 @@ static int sg_allow_dio = SG_ALLOW_DIO_D
 static int sg_add(struct class_device *);
 static void sg_remove(struct class_device *);
 
-static Scsi_Request *dummy_cmdp;	/* only used for sizeof */
-
 static DEFINE_RWLOCK(sg_dev_arr_lock);	/* Also used to lock
 							   file descriptor list for device */
 
@@ -131,12 +130,11 @@ struct sg_device;		/* forward declaratio
 struct sg_fd;
 
 typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
-	Scsi_Request *my_cmdp;	/* != 0  when request with lower levels */
 	struct sg_request *nextrp;	/* NULL -> tail request (slist) */
 	struct sg_fd *parentfp;	/* NULL -> not in use */
 	Sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
 	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
-	unsigned char sense_b[sizeof (dummy_cmdp->sr_sense_buffer)];
+	unsigned char sense_b[SCSI_SENSE_BUFFERSIZE];
 	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
@@ -177,7 +175,8 @@ typedef struct sg_device { /* holds the 
 } Sg_device;
 
 static int sg_fasync(int fd, struct file *filp, int mode);
-static void sg_cmd_done(Scsi_Cmnd * SCpnt);	/* tasklet or soft irq callback */
+/* tasklet or soft irq callback */
+static void sg_cmd_done(void *data, char *sense, int result, int resid);
 static int sg_start_req(Sg_request * srp);
 static void sg_finish_rem_req(Sg_request * srp);
 static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
@@ -210,7 +209,6 @@ static int sg_res_in_use(Sg_fd * sfp);
 static int sg_allow_access(unsigned char opcode, char dev_type);
 static int sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len);
 static Sg_device *sg_get_dev(int dev);
-static inline unsigned char *sg_scatg2virt(const struct scatterlist *sclp);
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
 #endif
@@ -343,6 +341,7 @@ sg_read(struct file *filp, char __user *
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_read: %s, count=%d\n",
 				   sdp->disk->disk_name, (int) count));
+
 	if (!access_ok(VERIFY_WRITE, buf, count))
 		return -EFAULT;
 	if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
@@ -495,7 +494,7 @@ sg_new_read(Sg_fd * sfp, char __user *bu
 	if ((hp->mx_sb_len > 0) && hp->sbp) {
 		if ((CHECK_CONDITION & hp->masked_status) ||
 		    (DRIVER_SENSE & hp->driver_status)) {
-			int sb_len = sizeof (dummy_cmdp->sr_sense_buffer);
+			int sb_len = SCSI_SENSE_BUFFERSIZE;
 			sb_len = (hp->mx_sb_len > sb_len) ? sb_len : hp->mx_sb_len;
 			len = 8 + (int) srp->sense_b[7];	/* Additional sense length field */
 			len = (len > sb_len) ? sb_len : len;
@@ -529,7 +528,7 @@ sg_write(struct file *filp, const char _
 	Sg_request *srp;
 	struct sg_header old_hdr;
 	sg_io_hdr_t *hp;
-	unsigned char cmnd[sizeof (dummy_cmdp->sr_cmnd)];
+	unsigned char cmnd[MAX_COMMAND_SIZE];
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
@@ -628,7 +627,7 @@ sg_new_write(Sg_fd * sfp, const char __u
 	int k;
 	Sg_request *srp;
 	sg_io_hdr_t *hp;
-	unsigned char cmnd[sizeof (dummy_cmdp->sr_cmnd)];
+	unsigned char cmnd[MAX_COMMAND_SIZE];
 	int timeout;
 	unsigned long ul_timeout;
 
@@ -696,11 +695,9 @@ static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		unsigned char *cmnd, int timeout, int blocking)
 {
-	int k;
-	Scsi_Request *SRpnt;
+	int k, data_dir;
 	Sg_device *sdp = sfp->parentdp;
 	sg_io_hdr_t *hp = &srp->header;
-	request_queue_t *q;
 
 	srp->data.cmd_opcode = cmnd[0];	/* hold opcode of command */
 	hp->status = 0;
@@ -727,51 +724,32 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 		sg_finish_rem_req(srp);
 		return -ENODEV;
 	}
-	SRpnt = scsi_allocate_request(sdp->device, GFP_ATOMIC);
-	if (SRpnt == NULL) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_write: no mem\n"));
-		sg_finish_rem_req(srp);
-		return -ENOMEM;
-	}
 
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
 	switch (hp->dxfer_direction) {
 	case SG_DXFER_TO_FROM_DEV:
 	case SG_DXFER_FROM_DEV:
-		SRpnt->sr_data_direction = DMA_FROM_DEVICE;
+		data_dir = DMA_FROM_DEVICE;
 		break;
 	case SG_DXFER_TO_DEV:
-		SRpnt->sr_data_direction = DMA_TO_DEVICE;
+		data_dir = DMA_TO_DEVICE;
 		break;
 	case SG_DXFER_UNKNOWN:
-		SRpnt->sr_data_direction = DMA_BIDIRECTIONAL;
+		data_dir = DMA_BIDIRECTIONAL;
 		break;
 	default:
-		SRpnt->sr_data_direction = DMA_NONE;
+		data_dir = DMA_NONE;
 		break;
 	}
-	SRpnt->upper_private_data = srp;
-	srp->data.k_use_sg = 0;
-	srp->data.sglist_len = 0;
-	srp->data.bufflen = 0;
-	srp->data.buffer = NULL;
 	hp->duration = jiffies_to_msecs(jiffies);
 /* Now send everything of to mid-level. The next time we hear about this
    packet is when sg_cmd_done() is called (i.e. a callback). */
-	scsi_do_req(SRpnt, (void *) cmnd,
-		    (void *) SRpnt->sr_buffer, hp->dxfer_len,
-		    sg_cmd_done, timeout, SG_DEFAULT_RETRIES);
-	/* dxfer_len overwrites SRpnt->sr_bufflen, hence need for b_malloc_len */
-	return 0;
+	if  (scsi_execute_async_iov_req(sdp->device, cmnd, data_dir,
+				srp->data.buffer, srp->data.k_use_sg,
+				timeout, SG_DEFAULT_RETRIES, srp,
+				sg_cmd_done))
+		return -ENOMEM;
+	else
+		return 0;
 }
 
 static int
@@ -1160,19 +1138,13 @@ sg_fasync(int fd, struct file *filp, int
 	return (retval < 0) ? retval : 0;
 }
 
-static inline unsigned char *
-sg_scatg2virt(const struct scatterlist *sclp)
-{
-	return (sclp && sclp->page) ?
-	    (unsigned char *) page_address(sclp->page) + sclp->offset : NULL;
-}
-
 /* When startFinish==1 increments page counts for pages other than the 
    first of scatter gather elements obtained from __get_free_pages().
    When startFinish==0 decrements ... */
 static void
 sg_rb_correct4mmap(Sg_scatter_hold * rsv_schp, int startFinish)
 {
+	struct kvec *vec = rsv_schp->buffer;
 	void *page_ptr;
 	struct page *page;
 	int k, m;
@@ -1180,24 +1152,9 @@ sg_rb_correct4mmap(Sg_scatter_hold * rsv
 	SCSI_LOG_TIMEOUT(3, printk("sg_rb_correct4mmap: startFinish=%d, scatg=%d\n", 
 				   startFinish, rsv_schp->k_use_sg));
 	/* N.B. correction _not_ applied to base page of each allocation */
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
+	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++vec) {
+		for (m = PAGE_SIZE; m < vec->iov_len; m += PAGE_SIZE) {
+			page_ptr = vec->iov_base + m;
 			page = virt_to_page(page_ptr);
 			if (startFinish)
 				get_page(page);
@@ -1215,8 +1172,10 @@ sg_vma_nopage(struct vm_area_struct *vma
 	Sg_fd *sfp;
 	struct page *page = NOPAGE_SIGBUS;
 	void *page_ptr = NULL;
-	unsigned long offset;
+	unsigned long offset, len, sa;
 	Sg_scatter_hold *rsv_schp;
+	struct kvec *vec;
+	int k;
 
 	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
 		return page;
@@ -1226,30 +1185,22 @@ sg_vma_nopage(struct vm_area_struct *vma
 		return page;
 	SCSI_LOG_TIMEOUT(3, printk("sg_vma_nopage: offset=%lu, scatg=%d\n",
 				   offset, rsv_schp->k_use_sg));
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
+	vec = rsv_schp->buffer;
+	sa = vma->vm_start;
+	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
+	     ++k, ++vec) {
+		len = vma->vm_end - sa;
+		len = (len < vec->iov_len) ? len : vec->iov_len;
+		if (offset < len) {
+			page_ptr = vec->iov_base + offset;
+			page = virt_to_page(page_ptr);
+			get_page(page);	/* increment page count */
+			break;
 		}
-	} else {		/* reserve buffer is just a single allocation */
-		page_ptr = (unsigned char *) rsv_schp->buffer + offset;
-		page = virt_to_page(page_ptr);
-		get_page(page);	/* increment page count */
+		sa += len;
+		offset -= len;
 	}
+
 	if (type)
 		*type = VM_FAULT_MINOR;
 	return page;
@@ -1263,8 +1214,10 @@ static int
 sg_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	Sg_fd *sfp;
-	unsigned long req_sz;
+	unsigned long req_sz, len, sa;
 	Sg_scatter_hold *rsv_schp;
+	int k;
+	struct kvec *vec;
 
 	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
 		return -ENXIO;
@@ -1277,24 +1230,16 @@ sg_mmap(struct file *filp, struct vm_are
 	if (req_sz > rsv_schp->bufflen)
 		return -ENOMEM;	/* cannot map more than reserved buffer */
 
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
+	//if (rsv_schp->k_use_sg) { /* reserve buffer is a scatter gather list */
+	sa = vma->vm_start;
+	vec = rsv_schp->buffer;
+	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
+	     ++k, ++vec) {
+		len = vma->vm_end - sa;
+		len = (len < vec->iov_len) ? len : vec->iov_len;
+		sa += len;
 	}
+
 	if (0 == sfp->mmap_called) {
 		sg_rb_correct4mmap(rsv_schp, 1);	/* do only once per fd lifetime */
 		sfp->mmap_called = 1;
@@ -1308,21 +1253,16 @@ sg_mmap(struct file *filp, struct vm_are
 /* This function is a "bottom half" handler that is called by the
  * mid level when a command is completed (or has failed). */
 static void
-sg_cmd_done(Scsi_Cmnd * SCpnt)
+sg_cmd_done(void *data, char *sense, int result, int resid)
 {
-	Scsi_Request *SRpnt = NULL;
+	Sg_request *srp = data;
 	Sg_device *sdp = NULL;
 	Sg_fd *sfp;
-	Sg_request *srp = NULL;
 	unsigned long iflags;
 	unsigned int ms;
 
-	if (SCpnt && (SRpnt = SCpnt->sc_request))
-		srp = (Sg_request *) SRpnt->upper_private_data;
 	if (NULL == srp) {
 		printk(KERN_ERR "sg_cmd_done: NULL request\n");
-		if (SRpnt)
-			scsi_release_request(SRpnt);
 		return;
 	}
 	sfp = srp->parentfp;
@@ -1330,49 +1270,34 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
 		sdp = sfp->parentdp;
 	if ((NULL == sdp) || sdp->detached) {
 		printk(KERN_INFO "sg_cmd_done: device detached\n");
-		scsi_release_request(SRpnt);
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
-	srp->my_cmdp = NULL;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
-		sdp->disk->disk_name, srp->header.pack_id, (int) SRpnt->sr_result));
-	srp->header.resid = SCpnt->resid;
+		sdp->disk->disk_name, srp->header.pack_id, result));
+	srp->header.resid = resid;
 	ms = jiffies_to_msecs(jiffies);
 	srp->header.duration = (ms > srp->header.duration) ?
 				(ms - srp->header.duration) : 0;
-	if (0 != SRpnt->sr_result) {
+	if (0 != result) {
 		struct scsi_sense_hdr sshdr;
 
-		memcpy(srp->sense_b, SRpnt->sr_sense_buffer,
-		       sizeof (srp->sense_b));
-		srp->header.status = 0xff & SRpnt->sr_result;
-		srp->header.masked_status = status_byte(SRpnt->sr_result);
-		srp->header.msg_status = msg_byte(SRpnt->sr_result);
-		srp->header.host_status = host_byte(SRpnt->sr_result);
-		srp->header.driver_status = driver_byte(SRpnt->sr_result);
+		memcpy(srp->sense_b, sense, sizeof (srp->sense_b));
+		srp->header.status = 0xff & result;
+		srp->header.masked_status = status_byte(result);
+		srp->header.msg_status = msg_byte(result);
+		srp->header.host_status = host_byte(result);
+		srp->header.driver_status = driver_byte(result);
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			scsi_print_req_sense("sg_cmd_done", SRpnt);
+			__scsi_print_sense("sg_cmd_done", sense,
+					   SCSI_SENSE_BUFFERSIZE);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
-		if (driver_byte(SRpnt->sr_result) != 0
-		    && scsi_command_normalize_sense(SCpnt, &sshdr)
+		if (driver_byte(result) != 0
+		    && scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)
 		    && !scsi_sense_is_deferred(&sshdr)
 		    && sshdr.sense_key == UNIT_ATTENTION
 		    && sdp->device->removable) {
@@ -1383,8 +1308,6 @@ sg_cmd_done(Scsi_Cmnd * SCpnt)
 	}
 	/* Rely on write phase to clean out srp status values, so no "else" */
 
-	scsi_release_request(SRpnt);
-	SRpnt = NULL;
 	if (sfp->closed) {	/* whoops this fd already released, cleanup */
 		SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, freeing ...\n"));
 		sg_finish_rem_req(srp);
@@ -1764,7 +1687,7 @@ static int
 sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 {
 	int ret_sz;
-	int elem_sz = sizeof (struct scatterlist);
+	int elem_sz = sizeof (struct kvec);
 	int sg_bufflen = tablesize * elem_sz;
 	int mx_sc_elems = tablesize;
 
@@ -1782,7 +1705,7 @@ sg_build_sgat(Sg_scatter_hold * schp, co
 
 #ifdef SG_ALLOW_DIO_CODE
 /* vvvvvvvv  following code borrowed from st driver's direct IO vvvvvvvvv */
-	/* hopefully this generic code will moved to a library */
+	/* TODO: hopefully we can use the generic block layer code */
 
 /* Pin down user pages and put them into a scatter gather list. Returns <= 0 if
    - mapping of all pages not successful
@@ -1790,7 +1713,7 @@ sg_build_sgat(Sg_scatter_hold * schp, co
    (i.e., either completely successful or fails)
 */
 static int 
-st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
+st_map_user_pages(struct kvec *vec, const unsigned int max_pages, 
 	          unsigned long uaddr, size_t count, int rw,
 	          unsigned long max_pfn)
 {
@@ -1845,21 +1768,24 @@ st_map_user_pages(struct scatterlist *sg
 		   goto out_unlock; */
         }
 
-	/* Populate the scatter/gather list */
-	sgl[0].page = pages[0]; 
-	sgl[0].offset = uaddr & ~PAGE_MASK;
+	/*
+	 * This never supported HighMem and we are still broken.
+	 * When we use the block layer code fori DIO we will support
+	 * it.
+	 */
+	/* addr + add offset */
+	vec[0].iov_base = page_address(pages[0]) + (uaddr & ~PAGE_MASK);
 	if (nr_pages > 1) {
-		sgl[0].length = PAGE_SIZE - sgl[0].offset;
-		count -= sgl[0].length;
+		vec[0].iov_len = PAGE_SIZE - (uaddr & ~PAGE_MASK);
+		count -= vec[0].iov_len;
 		for (i=1; i < nr_pages ; i++) {
-			sgl[i].offset = 0;
-			sgl[i].page = pages[i]; 
-			sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
+			vec[i].iov_base = page_address(pages[i]); 
+			vec[i].iov_len = count < PAGE_SIZE ? count : PAGE_SIZE;
 			count -= PAGE_SIZE;
 		}
 	}
 	else {
-		sgl[0].length = count;
+		vec[0].iov_len = count;
 	}
 
 	kfree(pages);
@@ -1880,19 +1806,21 @@ st_map_user_pages(struct scatterlist *sg
 
 /* And unmap them... */
 static int 
-st_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_pages,
+st_unmap_user_pages(struct kvec *vec, const unsigned int nr_pages,
 		    int dirtied)
 {
 	int i;
 
 	for (i=0; i < nr_pages; i++) {
-		if (dirtied && !PageReserved(sgl[i].page))
-			SetPageDirty(sgl[i].page);
+		struct page *p = virt_to_page(vec[i].iov_base);
+
+		if (dirtied && !PageReserved(p))
+			SetPageDirty(p);
 		/* unlock_page(sgl[i].page); */
 		/* FIXME: cache flush missing for rw==READ
 		 * FIXME: call the correct reference counting function
 		 */
-		page_cache_release(sgl[i].page);
+		page_cache_release(p);
 	}
 
 	return 0;
@@ -1910,19 +1838,23 @@ sg_build_direct(Sg_request * srp, Sg_fd 
 	sg_io_hdr_t *hp = &srp->header;
 	Sg_scatter_hold *schp = &srp->data;
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	struct scatterlist *sgl;
 	int mx_sc_elems, res;
 	struct scsi_device *sdev = sfp->parentdp->device;
 
 	if (((unsigned long)hp->dxferp &
 			queue_dma_alignment(sdev->request_queue)) != 0)
 		return 1;
+
+	if (((unsigned int)dxfer_len &
+			queue_dma_alignment(sdev->request_queue)) != 0)
+		return 1;
+
 	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
         if (mx_sc_elems <= 0) {
                 return 1;
         }
-	sgl = (struct scatterlist *)schp->buffer;
-	res = st_map_user_pages(sgl, mx_sc_elems, (unsigned long)hp->dxferp, dxfer_len, 
+	res = st_map_user_pages(schp->buffer, mx_sc_elems,
+				(unsigned long)hp->dxferp, dxfer_len, 
 				(SG_DXFER_TO_DEV == hp->dxfer_direction) ? 1 : 0, ULONG_MAX);
 	if (res <= 0)
 		return 1;
@@ -1938,7 +1870,9 @@ sg_build_direct(Sg_request * srp, Sg_fd 
 static int
 sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 {
-	int ret_sz;
+	struct kvec *vec;
+	int ret_sz = 0, k, rem_sz, num, mx_sc_elems;
+	int sg_tablesize = sfp->parentdp->sg_tablesize;
 	int blk_size = buff_size;
 	unsigned char *p = NULL;
 
@@ -1950,61 +1884,36 @@ sg_build_indirect(Sg_scatter_hold * schp
 	blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
 	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, blk_size=%d\n",
 				   buff_size, blk_size));
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
+
+	/* N.B. ret_sz carried into this block ... */
+	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
+	if (mx_sc_elems < 0)
+		return mx_sc_elems;	/* most likely -ENOMEM */
+
+	for (k = 0, vec = schp->buffer, rem_sz = blk_size;
+	     (rem_sz > 0) && (k < mx_sc_elems);
+	     ++k, rem_sz -= ret_sz, ++vec) {
+		
+		num = (rem_sz > SG_SCATTER_SZ) ? SG_SCATTER_SZ : rem_sz;
+		p = sg_page_malloc(num, sfp->low_dma, &ret_sz);
 		if (!p)
 			return -ENOMEM;
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
+
+		vec->iov_base = p;
+		vec->iov_len = ret_sz;
+
+
+		SCSI_LOG_TIMEOUT(5, printk("sg_build_build: k=%d, a=0x%p, len=%d\n",
+				  k, p, ret_sz));
+	}		/* end of for loop */
+
+	schp->k_use_sg = k;
+	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, rem_sz=%d\n", k, rem_sz));
+
+	schp->bufflen = blk_size;
+	if (rem_sz > 0)	/* must have failed */
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -2013,6 +1922,7 @@ sg_write_xfer(Sg_request * srp)
 {
 	sg_io_hdr_t *hp = &srp->header;
 	Sg_scatter_hold *schp = &srp->data;
+	struct kvec *vec = schp->buffer;
 	int num_xfer = 0;
 	int j, k, onum, usglen, ksglen, res;
 	int iovec_count = (int) hp->iovec_count;
@@ -2041,63 +1951,45 @@ sg_write_xfer(Sg_request * srp)
 	} else
 		onum = 1;
 
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
+	ksglen = vec->iov_len;
+	p = vec->iov_base;
+	for (j = 0, k = 0; j < onum; ++j) {
+		res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
+		if (res)
+			return res;
 
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
+		for (; p; ++vec, ksglen = vec->iov_len,
+		     p = vec->iov_base) {
+			if (usglen <= 0)
+				break;
+			if (ksglen > usglen) {
+				if (usglen >= num_xfer) {
+					if (__copy_from_user(p, up, num_xfer))
 						return -EFAULT;
-					up += ksglen;
-					usglen -= ksglen;
+					return 0;
 				}
-				++k;
-				if (k >= schp->k_use_sg)
+				if (__copy_from_user(p, up, usglen))
+					return -EFAULT;
+				p += usglen;
+				ksglen -= usglen;
+				break;
+			} else {
+				if (ksglen >= num_xfer) {
+					if (__copy_from_user(p, up, num_xfer))
+						return -EFAULT;
 					return 0;
+				}
+				if (__copy_from_user(p, up, ksglen))
+					return -EFAULT;
+				up += ksglen;
+				usglen -= ksglen;
 			}
+			++k;
+			if (k >= schp->k_use_sg)
+				return 0;
 		}
 	}
+
 	return 0;
 }
 
@@ -2135,29 +2027,25 @@ sg_remove_scat(Sg_scatter_hold * schp)
 {
 	SCSI_LOG_TIMEOUT(4, printk("sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
 	if (schp->buffer && (schp->sglist_len > 0)) {
-		struct scatterlist *sclp = (struct scatterlist *) schp->buffer;
+		struct kvec *vec = schp->buffer;
 
 		if (schp->dio_in_use) {
 #ifdef SG_ALLOW_DIO_CODE
-			st_unmap_user_pages(sclp, schp->k_use_sg, TRUE);
+			st_unmap_user_pages(vec, schp->k_use_sg, TRUE);
 #endif
 		} else {
 			int k;
 
-			for (k = 0; (k < schp->k_use_sg) && sg_scatg2virt(sclp);
-			     ++k, ++sclp) {
+			for (k = 0; (k < schp->k_use_sg) && vec->iov_base;
+			     ++k, ++vec) {
 				SCSI_LOG_TIMEOUT(5, printk(
 				    "sg_remove_scat: k=%d, a=0x%p, len=%d\n",
-				    k, sg_scatg2virt(sclp), sclp->length));
-				sg_page_free(sg_scatg2virt(sclp), sclp->length);
-				sclp->page = NULL;
-				sclp->offset = 0;
-				sclp->length = 0;
+				    k, vec->iov_base, vec->iov_len));
+				sg_page_free(vec->iov_base, vec->iov_len);
 			}
 		}
 		sg_page_free(schp->buffer, schp->sglist_len);
-	} else if (schp->buffer)
-		sg_page_free(schp->buffer, schp->b_malloc_len);
+	}
 	memset(schp, 0, sizeof (*schp));
 }
 
@@ -2166,6 +2054,7 @@ sg_read_xfer(Sg_request * srp)
 {
 	sg_io_hdr_t *hp = &srp->header;
 	Sg_scatter_hold *schp = &srp->data;
+	struct kvec *vec = schp->buffer;
 	int num_xfer = 0;
 	int j, k, onum, usglen, ksglen, res;
 	int iovec_count = (int) hp->iovec_count;
@@ -2194,63 +2083,49 @@ sg_read_xfer(Sg_request * srp)
 	} else
 		onum = 1;
 
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
+	if (!vec)
+		return 0;
 
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
+
+	p = vec->iov_base;
+	ksglen = vec->iov_len;
+
+	for (j = 0, k = 0; j < onum; ++j) {
+		res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
+		if (res)
+			return res;
+
+		for (; p; ++vec, ksglen = vec->iov_len, p = vec->iov_base) {
+			if (usglen <= 0)
+				break;
+			if (ksglen > usglen) {
+				if (usglen >= num_xfer) {
+					if (__copy_to_user(up, p, num_xfer))
 						return -EFAULT;
-					up += ksglen;
-					usglen -= ksglen;
+					return 0;
 				}
-				++k;
-				if (k >= schp->k_use_sg)
+				if (__copy_to_user(up, p, usglen))
+					return -EFAULT;
+				p += usglen;
+				ksglen -= usglen;
+				break;
+			} else {
+				if (ksglen >= num_xfer) {
+					if (__copy_to_user(up, p, num_xfer))
+						return -EFAULT;
 					return 0;
+				}
+				if (__copy_to_user(up, p, ksglen))
+					return -EFAULT;
+				up += ksglen;
+				usglen -= ksglen;
 			}
+			++k;
+			if (k >= schp->k_use_sg)
+				return 0;
 		}
 	}
+
 	return 0;
 }
 
@@ -2258,37 +2133,30 @@ static int
 sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 {
 	Sg_scatter_hold *schp = &srp->data;
+	struct kvec *vec = schp->buffer;
+	int k, num;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_read_oxfer: num_read_xfer=%d\n",
 				   num_read_xfer));
 	if ((!outp) || (num_read_xfer <= 0))
 		return 0;
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
+
+	for (k = 0; (k < schp->k_use_sg) && vec->iov_base; ++k, ++vec) {
+		num = vec->iov_len;
+		if (num > num_read_xfer) {
+			if (__copy_to_user(outp, vec->iov_base, num_read_xfer))
+				return -EFAULT;
+			break;
+		} else {
+			if (__copy_to_user(outp, vec->iov_base, num))
+				return -EFAULT;
+			num_read_xfer -= num;
+			if (num_read_xfer <= 0)
 				break;
-			} else {
-				if (__copy_to_user
-				    (outp, sg_scatg2virt(sclp), num))
-					return -EFAULT;
-				num_read_xfer -= num;
-				if (num_read_xfer <= 0)
-					break;
-				outp += num;
-			}
+			outp += num;
 		}
-	} else {
-		if (__copy_to_user(outp, schp->buffer, num_read_xfer))
-			return -EFAULT;
 	}
+
 	return 0;
 }
 
@@ -2314,44 +2182,31 @@ sg_link_reserve(Sg_fd * sfp, Sg_request 
 {
 	Sg_scatter_hold *req_schp = &srp->data;
 	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	struct kvec *vec = rsv_schp->buffer;
+	int k, num, rem;
 
 	srp->res_used = 1;
 	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
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
+	rem = size = (size + 1) & (~1);	/* round to even for aha1542 */
+
+	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++vec) {
+		num = vec->iov_len;
+		if (rem <= num) {
+			sfp->save_scat_len = num;
+			vec->iov_len = rem;
+			req_schp->k_use_sg = k + 1;
+			req_schp->sglist_len = rsv_schp->sglist_len;
+			req_schp->buffer = rsv_schp->buffer;
+
+			req_schp->bufflen = size;
+			req_schp->b_malloc_len = rsv_schp->b_malloc_len;
+			break;
+		} else
+			rem -= num;
 	}
+
+	if (k >= rsv_schp->k_use_sg)
+		SCSI_LOG_TIMEOUT(1, printk("sg_link_reserve: BAD size\n"));
 }
 
 static void
@@ -2363,11 +2218,10 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_reques
 	SCSI_LOG_TIMEOUT(4, printk("sg_unlink_reserve: req->k_use_sg=%d\n",
 				   (int) req_schp->k_use_sg));
 	if ((rsv_schp->k_use_sg > 0) && (req_schp->k_use_sg > 0)) {
-		struct scatterlist *sclp =
-		    (struct scatterlist *) rsv_schp->buffer;
+		struct kvec *vec = rsv_schp->buffer;
 
 		if (sfp->save_scat_len > 0)
-			(sclp + (req_schp->k_use_sg - 1))->length =
+			(vec + (req_schp->k_use_sg - 1))->iov_len =
 			    (unsigned) sfp->save_scat_len;
 		else
 			SCSI_LOG_TIMEOUT(1, printk ("sg_unlink_reserve: BAD save_scat_len\n"));
@@ -2453,7 +2307,6 @@ sg_add_request(Sg_fd * sfp)
 	if (resp) {
 		resp->nextrp = NULL;
 		resp->header.duration = jiffies_to_msecs(jiffies);
-		resp->my_cmdp = NULL;
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return resp;
@@ -2471,8 +2324,6 @@ sg_remove_request(Sg_fd * sfp, Sg_reques
 	if ((!sfp) || (!srp) || (!sfp->headrp))
 		return res;
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	if (srp->my_cmdp)
-		srp->my_cmdp->upper_private_data = NULL;
 	prev_rp = sfp->headrp;
 	if (srp == prev_rp) {
 		sfp->headrp = prev_rp->nextrp;
@@ -3076,13 +2927,11 @@ static void sg_proc_debug_helper(struct 
 					cp = "     ";
 			}
 			seq_printf(s, cp);
-			blen = srp->my_cmdp ? 
-				srp->my_cmdp->sr_bufflen : srp->data.bufflen;
-			usg = srp->my_cmdp ? 
-				srp->my_cmdp->sr_use_sg : srp->data.k_use_sg;
+			blen = srp->data.bufflen;
+			usg = srp->data.k_use_sg;
 			seq_printf(s, srp->done ? 
 				   ((1 == srp->done) ?  "rcv:" : "fin:")
-				   : (srp->my_cmdp ? "act:" : "prior:"));
+				   : "act:");
 			seq_printf(s, " id=%d blen=%d",
 				   srp->header.pack_id, blen);
 			if (srp->done)


