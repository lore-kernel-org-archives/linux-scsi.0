Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D33CC33CAB
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DD7D20724
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbgALX6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 18:58:07 -0500
Received: from smtp.infotech.no ([82.134.31.41]:51933 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387493AbgALX6G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jan 2020 18:58:06 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 6A32120415B;
        Mon, 13 Jan 2020 00:58:03 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bjsUKnsy+4jo; Mon, 13 Jan 2020 00:57:59 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [213.52.86.138])
        by smtp.infotech.no (Postfix) with ESMTPA id A111520424C;
        Mon, 13 Jan 2020 00:57:56 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>
Subject: [PATCH v6 02/37] sg: remove typedefs, type+formatting cleanup
Date:   Mon, 13 Jan 2020 00:57:20 +0100
Message-Id: <20200112235755.14197-3-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200112235755.14197-1-dgilbert@interlog.com>
References: <20200112235755.14197-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Typedefs for structure types are discouraged so those structures
that are private to the driver have had their typedefs removed.

This also means that most "camel" type variable names (i.e. mixed
case) have been removed.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 394 ++++++++++++++++++++++++++--------------------
 1 file changed, 219 insertions(+), 175 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d954ff639c9e..62c5f58ff567 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -3,7 +3,7 @@
  *  History:
  *  Started: Aug 9 by Lawrence Foard (entropy@world.std.com),
  *           to allow user process control of SCSI devices.
- *  Development Sponsored by Killy Corp. NY NY
+ *  Development Sponsored by Killy Corp. NY NY   [1992 ??]
  *
  * Original driver (sg.c):
  *        Copyright (C) 1992 Lawrence Foard
@@ -15,13 +15,6 @@ static int sg_version_num = 30901;  /* [x]xyyzz where [x] empty when x=0 */
 #define SG_VERSION_STR "3.9.01"		/* [x]x.[y]y.zz */
 static char *sg_version_date = "20190606";
 
-/*
- *  D. P. Gilbert (dgilbert@interlog.com), notes:
- *      - scsi logging is available via SCSI_LOG_TIMEOUT macros. First
- *        the kernel/module needs to be built with CONFIG_SCSI_LOGGING
- *        (otherwise the macros compile to empty statements).
- *
- */
 #include <linux/module.h>
 
 #include <linux/fs.h>
@@ -91,33 +84,32 @@ static int sg_add_device(struct device *, struct class_interface *);
 static void sg_remove_device(struct device *, struct class_interface *);
 
 static DEFINE_IDR(sg_index_idr);
-static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
-							   file descriptor list for device */
+static DEFINE_RWLOCK(sg_index_lock); /* Also used to lock fd list for device */
 
 static struct class_interface sg_interface = {
 	.add_dev        = sg_add_device,
 	.remove_dev     = sg_remove_device,
 };
 
-typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
-	unsigned short k_use_sg; /* Count of kernel scatter-gather pieces */
-	unsigned sglist_len; /* size of malloc'd scatter-gather list ++ */
-	unsigned bufflen;	/* Size of (aggregate) data buffer */
+struct sg_scatter_hold { /* holding area for scsi scatter gather info */
+	u16 k_use_sg; /* Count of kernel scatter-gather pieces */
+	unsigned int sglist_len; /* size of malloc'd scatter-gather list ++ */
+	unsigned int bufflen;	/* Size of (aggregate) data buffer */
 	struct page **pages;
 	int page_order;
 	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
-	unsigned char cmd_opcode; /* first byte of command */
-} Sg_scatter_hold;
+	u8 cmd_opcode;		/* first byte of command */
+};
 
 struct sg_device;		/* forward declarations */
 struct sg_fd;
 
-typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
+struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	struct list_head entry;	/* list entry */
 	struct sg_fd *parentfp;	/* NULL -> not in use */
-	Sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
+	struct sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
 	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
-	unsigned char sense_b[SCSI_SENSE_BUFFERSIZE];
+	u8 sense_b[SCSI_SENSE_BUFFERSIZE];
 	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
@@ -126,9 +118,9 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	struct request *rq;
 	struct bio *bio;
 	struct execute_work ew;
-} Sg_request;
+};
 
-typedef struct sg_fd {		/* holds the state of a file descriptor */
+struct sg_fd {		/* holds the state of a file descriptor */
 	struct list_head sfd_siblings;  /* protected by device's sfd_lock */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
@@ -136,21 +128,21 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
 	struct mutex f_mutex;	/* protect against changes in this fd */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
-	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
+	struct sg_scatter_hold reserve;	/* buffer for this file descriptor */
 	struct list_head rq_list; /* head of request list */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
-	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
+	struct sg_request req_arr[SG_MAX_QUEUE];/* use as singly-linked list */
 	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
 	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
-	unsigned char next_cmd_len; /* 0: automatic, >0: use on next write() */
+	u8 next_cmd_len;	/* 0: automatic, >0: use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
 	char res_in_use;	/* 1 -> 'reserve' array in use */
 	struct kref f_ref;
 	struct execute_work ew;
-} Sg_fd;
+};
 
-typedef struct sg_device { /* holds the state of each scsi generic device */
+struct sg_device { /* holds the state of each scsi generic device */
 	struct scsi_device *device;
 	wait_queue_head_t open_wait;    /* queue open() when O_EXCL present */
 	struct mutex open_rel_lock;     /* held when in open() or release() */
@@ -165,30 +157,34 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
 	struct kref d_ref;
-} Sg_device;
+};
 
 /* tasklet or soft irq callback */
 static void sg_rq_end_io(struct request *rq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
 static int sg_proc_init(void);
-static int sg_start_req(Sg_request *srp, unsigned char *cmd);
-static int sg_finish_rem_req(Sg_request * srp);
-static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
-static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
+static int sg_start_req(struct sg_request *srp, u8 *cmd);
+static int sg_finish_rem_req(struct sg_request *srp);
+static int sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
+			     int buff_size);
+static ssize_t sg_new_write(struct sg_fd *sfp, struct file *file,
 			const char __user *buf, size_t count, int blocking,
-			int read_only, int sg_io_owned, Sg_request **o_srp);
-static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
-			   unsigned char *cmnd, int timeout, int blocking);
-static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
-static void sg_remove_scat(Sg_fd * sfp, Sg_scatter_hold * schp);
-static void sg_build_reserve(Sg_fd * sfp, int req_size);
-static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
-static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
-static Sg_fd *sg_add_sfp(Sg_device * sdp);
+			int read_only, int sg_io_owned,
+			struct sg_request **o_srp);
+static int sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
+			   u8 *cmnd, int timeout, int blocking);
+static int sg_read_oxfer(struct sg_request *srp, char __user *outp,
+			 int num_read_xfer);
+static void sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
+static void sg_build_reserve(struct sg_fd *sfp, int req_size);
+static void sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp,
+			    int size);
+static void sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp);
+static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
 static void sg_remove_sfp(struct kref *);
-static Sg_request *sg_add_request(Sg_fd * sfp);
-static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
-static Sg_device *sg_get_dev(int dev);
+static struct sg_request *sg_add_request(struct sg_fd *sfp);
+static int sg_remove_request(struct sg_fd *sfp, struct sg_request *srp);
+static struct sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
 
 #define SZ_SG_HEADER sizeof(struct sg_header)
@@ -212,7 +208,8 @@ static void sg_device_destroy(struct kref *kref);
  * This function provides protection for the legacy API by restricting the
  * calling context.
  */
-static int sg_check_file_access(struct file *filp, const char *caller)
+static int
+sg_check_file_access(struct file *filp, const char *caller)
 {
 	if (filp->f_cred != current_real_cred()) {
 		pr_err_once("%s: process %d (%s) changed security contexts after opening file descriptor, this is not allowed.\n",
@@ -228,11 +225,11 @@ static int sg_check_file_access(struct file *filp, const char *caller)
 }
 
 static int
-open_wait(Sg_device *sdp, int flags)
+sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 {
 	int retval = 0;
 
-	if (flags & O_EXCL) {
+	if (o_excl) {
 		while (sdp->open_cnt > 0) {
 			mutex_unlock(&sdp->open_rel_lock);
 			retval = wait_event_interruptible(sdp->open_wait,
@@ -263,26 +260,34 @@ open_wait(Sg_device *sdp, int flags)
 	return retval;
 }
 
-/* Returns 0 on success, else a negated errno value */
+/*
+ * Corresponds to the open() system call on sg devices. Implements O_EXCL on
+ * a per device basis using 'open_cnt'. If O_EXCL and O_NONBLOCK and there is
+ * already a sg handle open on this device then it fails with an errno of
+ * EBUSY. Without the O_NONBLOCK flag then this thread enters an interruptible
+ * wait until the other handle(s) are closed.
+ */
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
-	int dev = iminor(inode);
-	int flags = filp->f_flags;
+	bool o_excl;
+	int min_dev = iminor(inode);
+	int op_flags = filp->f_flags;
 	struct request_queue *q;
-	Sg_device *sdp;
-	Sg_fd *sfp;
+	struct sg_device *sdp;
+	struct sg_fd *sfp;
 	int retval;
 
 	nonseekable_open(inode, filp);
-	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE)))
+	o_excl = !!(op_flags & O_EXCL);
+	if (o_excl && ((op_flags & O_ACCMODE) == O_RDONLY))
 		return -EPERM; /* Can't lock it with read only access */
-	sdp = sg_get_dev(dev);
+	sdp = sg_get_dev(min_dev);
 	if (IS_ERR(sdp))
 		return PTR_ERR(sdp);
 
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
-				      "sg_open: flags=0x%x\n", flags));
+				      "sg_open: flags=0x%x\n", op_flags));
 
 	/* This driver's module count bumped by fops_get in <linux/fs.h> */
 	/* Prevent the device driver from vanishing while we sleep */
@@ -297,7 +302,7 @@ sg_open(struct inode *inode, struct file *filp)
 	/* scsi_block_when_processing_errors() may block so bypass
 	 * check if O_NONBLOCK. Permits SCSI commands to be issued
 	 * during error recovery. Tread carefully. */
-	if (!((flags & O_NONBLOCK) ||
+	if (!((op_flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
 		/* we are in error recovery for this device */
@@ -305,8 +310,8 @@ sg_open(struct inode *inode, struct file *filp)
 	}
 
 	mutex_lock(&sdp->open_rel_lock);
-	if (flags & O_NONBLOCK) {
-		if (flags & O_EXCL) {
+	if (op_flags & O_NONBLOCK) {
+		if (o_excl) {
 			if (sdp->open_cnt > 0) {
 				retval = -EBUSY;
 				goto error_mutex_locked;
@@ -318,13 +323,13 @@ sg_open(struct inode *inode, struct file *filp)
 			}
 		}
 	} else {
-		retval = open_wait(sdp, flags);
+		retval = sg_wait_open_event(sdp, o_excl);
 		if (retval) /* -ERESTARTSYS or -ENODEV */
 			goto error_mutex_locked;
 	}
 
 	/* N.B. at this point we are holding the open_rel_lock */
-	if (flags & O_EXCL)
+	if (o_excl)
 		sdp->exclude = true;
 
 	if (sdp->open_cnt < 1) {  /* no existing opens */
@@ -348,7 +353,7 @@ sg_open(struct inode *inode, struct file *filp)
 	return retval;
 
 out_undo:
-	if (flags & O_EXCL) {
+	if (o_excl) {
 		sdp->exclude = false;   /* undo if error */
 		wake_up_interruptible(&sdp->open_wait);
 	}
@@ -366,10 +371,12 @@ sg_open(struct inode *inode, struct file *filp)
 static int
 sg_release(struct inode *inode, struct file *filp)
 {
-	Sg_device *sdp;
-	Sg_fd *sfp;
+	struct sg_device *sdp;
+	struct sg_fd *sfp;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	sfp = filp->private_data;
+	sdp = sfp->parentdp;
+	if (!sdp)
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp, "sg_release\n"));
 
@@ -401,20 +408,22 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 {
 	int mxsize, cmd_size, k;
 	int input_size, blocking;
-	unsigned char opcode;
-	Sg_device *sdp;
-	Sg_fd *sfp;
-	Sg_request *srp;
+	u8 opcode;
+	struct sg_device *sdp;
+	struct sg_fd *sfp;
+	struct sg_request *srp;
 	struct sg_header old_hdr;
 	sg_io_hdr_t *hp;
-	unsigned char cmnd[SG_MAX_CDB_SIZE];
+	u8 cmnd[SG_MAX_CDB_SIZE];
 	int retval;
 
 	retval = sg_check_file_access(filp, __func__);
 	if (retval)
 		return retval;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	sfp = filp->private_data;
+	sdp = sfp->parentdp;
+	if (!sdp)
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				      "sg_write: count=%d\n", (int) count));
@@ -467,7 +476,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	}
 	hp = &srp->header;
 	hp->interface_id = '\0';	/* indicator of old interface tunnelled */
-	hp->cmd_len = (unsigned char) cmd_size;
+	hp->cmd_len = (u8) cmd_size;
 	hp->iovec_count = 0;
 	hp->mx_sb_len = 0;
 	if (input_size > 0)
@@ -507,7 +516,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	return (k < 0) ? k : count;
 }
 
-static int sg_allow_access(struct file *filp, unsigned char *cmd)
+static int
+sg_allow_access(struct file *filp, u8 *cmd)
 {
 	struct sg_fd *sfp = filp->private_data;
 
@@ -518,14 +528,14 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 }
 
 static ssize_t
-sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
+sg_new_write(struct sg_fd *sfp, struct file *file, const char __user *buf,
 		 size_t count, int blocking, int read_only, int sg_io_owned,
-		 Sg_request **o_srp)
+		 struct sg_request **o_srp)
 {
 	int k;
-	Sg_request *srp;
+	struct sg_request *srp;
 	sg_io_hdr_t *hp;
-	unsigned char cmnd[SG_MAX_CDB_SIZE];
+	u8 cmnd[SG_MAX_CDB_SIZE];
 	int timeout;
 	unsigned long ul_timeout;
 
@@ -585,11 +595,11 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 }
 
 static int
-sg_common_write(Sg_fd * sfp, Sg_request * srp,
-		unsigned char *cmnd, int timeout, int blocking)
+sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
+		u8 *cmnd, int timeout, int blocking)
 {
 	int k, at_head;
-	Sg_device *sdp = sfp->parentdp;
+	struct sg_device *sdp = sfp->parentdp;
 	sg_io_hdr_t *hp = &srp->header;
 
 	srp->data.cmd_opcode = cmnd[0];	/* hold opcode of command */
@@ -648,10 +658,10 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
  * half of the ioctl(SG_IO) share code with read(2).
  */
 
-static Sg_request *
-sg_get_rq_mark(Sg_fd *sfp, int pack_id)
+static struct sg_request *
+sg_get_rq_mark(struct sg_fd *sfp, int pack_id)
 {
-	Sg_request *resp;
+	struct sg_request *resp;
 	unsigned long iflags;
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
@@ -669,7 +679,8 @@ sg_get_rq_mark(Sg_fd *sfp, int pack_id)
 }
 
 static ssize_t
-sg_new_read(Sg_fd *sfp, char __user *buf, size_t count, Sg_request *srp)
+sg_new_read(struct sg_fd *sfp, char __user *buf, size_t count,
+	    struct sg_request *srp)
 {
 	sg_io_hdr_t *hp = &srp->header;
 	int err = 0, err2;
@@ -709,7 +720,8 @@ sg_new_read(Sg_fd *sfp, char __user *buf, size_t count, Sg_request *srp)
 	return err ? : err2 ? : count;
 }
 
-static int srp_done(Sg_fd *sfp, Sg_request *srp)
+static int
+srp_done(struct sg_fd *sfp, struct sg_request *srp)
 {
 	unsigned long flags;
 	int ret;
@@ -723,9 +735,9 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
 static ssize_t
 sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 {
-	Sg_device *sdp;
-	Sg_fd *sfp;
-	Sg_request *srp;
+	struct sg_device *sdp;
+	struct sg_fd *sfp;
+	struct sg_request *srp;
 	int req_pack_id = -1;
 	sg_io_hdr_t *hp;
 	struct sg_header *old_hdr = NULL;
@@ -882,7 +894,8 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 	return retval;
 }
 
-static int max_sectors_bytes(struct request_queue *q)
+static int
+max_sectors_bytes(struct request_queue *q)
 {
 	unsigned int max_sectors = queue_max_sectors(q);
 
@@ -892,9 +905,9 @@ static int max_sectors_bytes(struct request_queue *q)
 }
 
 static void
-sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
+sg_fill_request_table(struct sg_fd *sfp, struct sg_req_info *rinfo)
 {
-	Sg_request *srp;
+	struct sg_request *srp;
 	int val;
 	unsigned int ms;
 
@@ -957,14 +970,15 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	void __user *p = (void __user *)arg;
 	int __user *ip = p;
 	int result, val, read_only;
-	Sg_device *sdp;
-	Sg_fd *sfp;
-	Sg_request *srp;
+	struct sg_device *sdp;
+	struct sg_fd *sfp;
+	struct sg_request *srp;
 	unsigned long iflags;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	sfp = filp->private_data;
+	sdp = sfp->parentdp;
+	if (!sdp)
 		return -ENXIO;
-
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				   "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
 	read_only = (O_RDWR != (filp->f_flags & O_ACCMODE));
@@ -1191,13 +1205,16 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 }
 
 #ifdef CONFIG_COMPAT
-static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
+static long
+sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
-	Sg_device *sdp;
-	Sg_fd *sfp;
+	struct sg_device *sdp;
+	struct sg_fd *sfp;
 	struct scsi_device *sdev;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	sfp = filp->private_data;
+	sdp = sfp->parentdp;
+	if (!sdp)
 		return -ENXIO;
 
 	sdev = sdp->device;
@@ -1217,9 +1234,9 @@ static __poll_t
 sg_poll(struct file *filp, poll_table * wait)
 {
 	__poll_t res = 0;
-	Sg_device *sdp;
-	Sg_fd *sfp;
-	Sg_request *srp;
+	struct sg_device *sdp;
+	struct sg_fd *sfp;
+	struct sg_request *srp;
 	int count = 0;
 	unsigned long iflags;
 
@@ -1254,10 +1271,12 @@ sg_poll(struct file *filp, poll_table * wait)
 static int
 sg_fasync(int fd, struct file *filp, int mode)
 {
-	Sg_device *sdp;
-	Sg_fd *sfp;
+	struct sg_device *sdp;
+	struct sg_fd *sfp;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	sfp = filp->private_data;
+	sdp = sfp->parentdp;
+	if (!sdp)
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				      "sg_fasync: mode=%d\n", mode));
@@ -1269,13 +1288,21 @@ static vm_fault_t
 sg_vma_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	Sg_fd *sfp;
+	struct sg_fd *sfp;
 	unsigned long offset, len, sa;
-	Sg_scatter_hold *rsv_schp;
+	struct sg_scatter_hold *rsv_schp;
 	int k, length;
+	const char *nbp = "==NULL, bad";
 
-	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return VM_FAULT_SIGBUS;
+	if (!vma) {
+		pr_warn("%s: vma%s\n", __func__, nbp);
+		goto out_err;
+	}
+	sfp = vma->vm_private_data;
+	if (!sfp) {
+		pr_warn("%s: sfp%s\n", __func__, nbp);
+		goto out_err;
+	}
 	rsv_schp = &sfp->reserve;
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= rsv_schp->bufflen)
@@ -1298,7 +1325,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		sa += len;
 		offset -= len;
 	}
-
+out_err:
 	return VM_FAULT_SIGBUS;
 }
 
@@ -1309,14 +1336,19 @@ static const struct vm_operations_struct sg_mmap_vm_ops = {
 static int
 sg_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	Sg_fd *sfp;
+	struct sg_fd *sfp;
 	unsigned long req_sz, len, sa;
-	Sg_scatter_hold *rsv_schp;
+	struct sg_scatter_hold *rsv_schp;
 	int k, length;
 	int ret = 0;
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if (!filp || !vma)
+		return -ENXIO;
+	sfp = filp->private_data;
+	if (!sfp) {
+		pr_warn("sg: %s: sfp is NULL\n", __func__);
 		return -ENXIO;
+	}
 	req_sz = vma->vm_end - vma->vm_start;
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_mmap starting, vm_start=%p, len=%d\n",
@@ -1367,8 +1399,8 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 {
 	struct sg_request *srp = rq->end_io_data;
 	struct scsi_request *req = scsi_req(rq);
-	Sg_device *sdp;
-	Sg_fd *sfp;
+	struct sg_device *sdp;
+	struct sg_fd *sfp;
 	unsigned long iflags;
 	unsigned int ms;
 	char *sense;
@@ -1480,21 +1512,18 @@ static struct class *sg_sysfs_class;
 
 static int sg_sysfs_valid = 0;
 
-static Sg_device *
+static struct sg_device *
 sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 {
 	struct request_queue *q = scsidp->request_queue;
-	Sg_device *sdp;
+	struct sg_device *sdp;
 	unsigned long iflags;
 	int error;
 	u32 k;
 
-	sdp = kzalloc(sizeof(Sg_device), GFP_KERNEL);
-	if (!sdp) {
-		sdev_printk(KERN_WARNING, scsidp, "%s: kmalloc Sg_device "
-			    "failure\n", __func__);
+	sdp = kzalloc(sizeof(struct sg_device), GFP_KERNEL);
+	if (!sdp)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	idr_preload(GFP_KERNEL);
 	write_lock_irqsave(&sg_index_lock, iflags);
@@ -1507,8 +1536,8 @@ sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 				    scsidp->type, SG_MAX_DEVS - 1);
 			error = -ENODEV;
 		} else {
-			sdev_printk(KERN_WARNING, scsidp, "%s: idr "
-				    "allocation Sg_device failure: %d\n",
+			sdev_printk(KERN_WARNING, scsidp,
+				    "%s: idr alloc sg_device failure: %d\n",
 				    __func__, error);
 		}
 		goto out_unlock;
@@ -1547,7 +1576,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
 	struct gendisk *disk;
-	Sg_device *sdp = NULL;
+	struct sg_device *sdp = NULL;
 	struct cdev * cdev = NULL;
 	int error;
 	unsigned long iflags;
@@ -1646,9 +1675,9 @@ static void
 sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
-	Sg_device *sdp = dev_get_drvdata(cl_dev);
+	struct sg_device *sdp = dev_get_drvdata(cl_dev);
 	unsigned long iflags;
-	Sg_fd *sfp;
+	struct sg_fd *sfp;
 	int val;
 
 	if (!sdp)
@@ -1751,22 +1780,22 @@ exit_sg(void)
 }
 
 static int
-sg_start_req(Sg_request *srp, unsigned char *cmd)
+sg_start_req(struct sg_request *srp, u8 *cmd)
 {
 	int res;
 	struct request *rq;
 	struct scsi_request *req;
-	Sg_fd *sfp = srp->parentfp;
+	struct sg_fd *sfp = srp->parentfp;
 	sg_io_hdr_t *hp = &srp->header;
 	int dxfer_len = (int) hp->dxfer_len;
 	int dxfer_dir = hp->dxfer_direction;
 	unsigned int iov_count = hp->iovec_count;
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	struct sg_scatter_hold *req_schp = &srp->data;
+	struct sg_scatter_hold *rsv_schp = &sfp->reserve;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 	struct rq_map_data *md, map_data;
 	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
-	unsigned char *long_cmdp = NULL;
+	u8 *long_cmdp = NULL;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_start_req: dxfer_len=%d\n",
@@ -1888,12 +1917,12 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 }
 
 static int
-sg_finish_rem_req(Sg_request *srp)
+sg_finish_rem_req(struct sg_request *srp)
 {
 	int ret = 0;
 
-	Sg_fd *sfp = srp->parentfp;
-	Sg_scatter_hold *req_schp = &srp->data;
+	struct sg_fd *sfp = srp->parentfp;
+	struct sg_scatter_hold *req_schp = &srp->data;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_finish_rem_req: res_used=%d\n",
@@ -1915,7 +1944,8 @@ sg_finish_rem_req(Sg_request *srp)
 }
 
 static int
-sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
+sg_build_sgat(struct sg_scatter_hold *schp, const struct sg_fd *sfp,
+	      int tablesize)
 {
 	int sg_bufflen = tablesize * sizeof(struct page *);
 	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
@@ -1928,7 +1958,8 @@ sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 }
 
 static int
-sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
+sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
+		  int buff_size)
 {
 	int ret_sz = 0, i, k, rem_sz, num, mx_sc_elems;
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
@@ -2010,7 +2041,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 }
 
 static void
-sg_remove_scat(Sg_fd * sfp, Sg_scatter_hold * schp)
+sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 {
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
 			 "sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
@@ -2033,9 +2064,9 @@ sg_remove_scat(Sg_fd * sfp, Sg_scatter_hold * schp)
 }
 
 static int
-sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
+sg_read_oxfer(struct sg_request *srp, char __user *outp, int num_read_xfer)
 {
-	Sg_scatter_hold *schp = &srp->data;
+	struct sg_scatter_hold *schp = &srp->data;
 	int k, num;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, srp->parentfp->parentdp,
@@ -2066,9 +2097,9 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 }
 
 static void
-sg_build_reserve(Sg_fd * sfp, int req_size)
+sg_build_reserve(struct sg_fd *sfp, int req_size)
 {
-	Sg_scatter_hold *schp = &sfp->reserve;
+	struct sg_scatter_hold *schp = &sfp->reserve;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
 			 "sg_build_reserve: req_size=%d\n", req_size));
@@ -2084,10 +2115,10 @@ sg_build_reserve(Sg_fd * sfp, int req_size)
 }
 
 static void
-sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
+sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp, int size)
 {
-	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	struct sg_scatter_hold *req_schp = &srp->data;
+	struct sg_scatter_hold *rsv_schp = &sfp->reserve;
 	int k, num, rem;
 
 	srp->res_used = 1;
@@ -2116,9 +2147,9 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 }
 
 static void
-sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
+sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp)
 {
-	Sg_scatter_hold *req_schp = &srp->data;
+	struct sg_scatter_hold *req_schp = &srp->data;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, srp->parentfp->parentdp,
 				      "sg_unlink_reserve: req->k_use_sg=%d\n",
@@ -2134,12 +2165,12 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
 }
 
 /* always adds to end of list */
-static Sg_request *
-sg_add_request(Sg_fd * sfp)
+static struct sg_request *
+sg_add_request(struct sg_fd *sfp)
 {
 	int k;
 	unsigned long iflags;
-	Sg_request *rp = sfp->req_arr;
+	struct sg_request *rp = sfp->req_arr;
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (!list_empty(&sfp->rq_list)) {
@@ -2153,7 +2184,7 @@ sg_add_request(Sg_fd * sfp)
 		if (k >= SG_MAX_QUEUE)
 			goto out_unlock;
 	}
-	memset(rp, 0, sizeof (Sg_request));
+	memset(rp, 0, sizeof(struct sg_request));
 	rp->parentfp = sfp;
 	rp->header.duration = jiffies_to_msecs(jiffies);
 	list_add_tail(&rp->entry, &sfp->rq_list);
@@ -2166,7 +2197,7 @@ sg_add_request(Sg_fd * sfp)
 
 /* Return of 1 for found; 0 for not found */
 static int
-sg_remove_request(Sg_fd * sfp, Sg_request * srp)
+sg_remove_request(struct sg_fd *sfp, struct sg_request *srp)
 {
 	unsigned long iflags;
 	int res = 0;
@@ -2183,10 +2214,10 @@ sg_remove_request(Sg_fd * sfp, Sg_request * srp)
 	return res;
 }
 
-static Sg_fd *
-sg_add_sfp(Sg_device * sdp)
+static struct sg_fd *
+sg_add_sfp(struct sg_device *sdp)
 {
-	Sg_fd *sfp;
+	struct sg_fd *sfp;
 	unsigned long iflags;
 	int bufflen;
 
@@ -2236,13 +2267,13 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 {
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
-	Sg_request *srp;
+	struct sg_request *srp;
 	unsigned long iflags;
 
 	/* Cleanup any responses which were never read(). */
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	while (!list_empty(&sfp->rq_list)) {
-		srp = list_first_entry(&sfp->rq_list, Sg_request, entry);
+		srp = list_first_entry(&sfp->rq_list, struct sg_request, entry);
 		sg_finish_rem_req(srp);
 		list_del(&srp->entry);
 		srp->parentfp = NULL;
@@ -2307,12 +2338,13 @@ sg_last_dev(void)
 #endif
 
 /* must be called with sg_index_lock held */
-static Sg_device *sg_lookup_dev(int dev)
+static struct sg_device *
+sg_lookup_dev(int dev)
 {
 	return idr_find(&sg_index_idr, dev);
 }
 
-static Sg_device *
+static struct sg_device *
 sg_get_dev(int dev)
 {
 	struct sg_device *sdp;
@@ -2410,13 +2442,15 @@ sg_proc_init(void)
 }
 
 
-static int sg_proc_seq_show_int(struct seq_file *s, void *v)
+static int
+sg_proc_seq_show_int(struct seq_file *s, void *v)
 {
 	seq_printf(s, "%d\n", *((int *)s->private));
 	return 0;
 }
 
-static int sg_proc_single_open_adio(struct inode *inode, struct file *file)
+static int
+sg_proc_single_open_adio(struct inode *inode, struct file *file)
 {
 	return single_open(file, sg_proc_seq_show_int, &sg_allow_dio);
 }
@@ -2437,7 +2471,8 @@ sg_proc_write_adio(struct file *filp, const char __user *buffer,
 	return count;
 }
 
-static int sg_proc_single_open_dressz(struct inode *inode, struct file *file)
+static int
+sg_proc_single_open_dressz(struct inode *inode, struct file *file)
 {
 	return single_open(file, sg_proc_seq_show_int, &sg_big_buff);
 }
@@ -2462,14 +2497,16 @@ sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 	return -ERANGE;
 }
 
-static int sg_proc_seq_show_version(struct seq_file *s, void *v)
+static int
+sg_proc_seq_show_version(struct seq_file *s, void *v)
 {
 	seq_printf(s, "%d\t%s [%s]\n", sg_version_num, SG_VERSION_STR,
 		   sg_version_date);
 	return 0;
 }
 
-static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
+static int
+sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
 {
 	seq_puts(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\tonline\n");
 	return 0;
@@ -2480,7 +2517,8 @@ struct sg_proc_deviter {
 	size_t	max;
 };
 
-static void * dev_seq_start(struct seq_file *s, loff_t *pos)
+static void *
+dev_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct sg_proc_deviter * it = kmalloc(sizeof(*it), GFP_KERNEL);
 
@@ -2495,7 +2533,8 @@ static void * dev_seq_start(struct seq_file *s, loff_t *pos)
 	return it;
 }
 
-static void * dev_seq_next(struct seq_file *s, void *v, loff_t *pos)
+static void *
+dev_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct sg_proc_deviter * it = s->private;
 
@@ -2503,15 +2542,17 @@ static void * dev_seq_next(struct seq_file *s, void *v, loff_t *pos)
 	return (it->index < it->max) ? it : NULL;
 }
 
-static void dev_seq_stop(struct seq_file *s, void *v)
+static void
+dev_seq_stop(struct seq_file *s, void *v)
 {
 	kfree(s->private);
 }
 
-static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
+static int
+sg_proc_seq_show_dev(struct seq_file *s, void *v)
 {
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
-	Sg_device *sdp;
+	struct sg_device *sdp;
 	struct scsi_device *scsidp;
 	unsigned long iflags;
 
@@ -2534,10 +2575,11 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 	return 0;
 }
 
-static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
+static int
+sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 {
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
-	Sg_device *sdp;
+	struct sg_device *sdp;
 	struct scsi_device *scsidp;
 	unsigned long iflags;
 
@@ -2554,11 +2596,12 @@ static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 }
 
 /* must be called while holding sg_index_lock */
-static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
+static void
+sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 {
 	int k, new_interface, blen, usg;
-	Sg_request *srp;
-	Sg_fd *fp;
+	struct sg_request *srp;
+	struct sg_fd *fp;
 	const sg_io_hdr_t *hp;
 	const char * cp;
 	unsigned int ms;
@@ -2617,10 +2660,11 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 	}
 }
 
-static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
+static int
+sg_proc_seq_show_debug(struct seq_file *s, void *v)
 {
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
-	Sg_device *sdp;
+	struct sg_device *sdp;
 	unsigned long iflags;
 
 	if (it && (0 == it->index))
-- 
2.24.1

