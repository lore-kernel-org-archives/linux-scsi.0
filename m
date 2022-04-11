Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFA0C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 02:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbiDKCb4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 22:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244360AbiDKCbW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 22:31:22 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03CC3C2F
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 19:29:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D0D7A2041CE;
        Mon, 11 Apr 2022 04:29:04 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Tpmasq6scmuH; Mon, 11 Apr 2022 04:29:02 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 5BE1A2041C0;
        Mon, 11 Apr 2022 04:29:00 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v24 17/46] sg: replace sg_allow_access
Date:   Sun, 10 Apr 2022 22:28:07 -0400
Message-Id: <20220411022836.11871-18-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411022836.11871-1-dgilbert@interlog.com>
References: <20220411022836.11871-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the sg_allow_access() function with sg_fetch_cmnd()
which does a little more. Change sg_finish_scsi_blk_rq() from an
int to a void returning function. Rename sg_remove_request()
to sg_deact_request(). Other changes, mainly cosmetic.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 151 +++++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c906f70e47fd..29f93b4f4cce 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -191,7 +191,7 @@ static void sg_rq_end_io(struct request *rq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
 static int sg_proc_init(void);
 static int sg_start_req(struct sg_request *srp, u8 *cmd);
-static int sg_finish_scsi_blk_rq(struct sg_request *srp);
+static void sg_finish_scsi_blk_rq(struct sg_request *srp);
 static int sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
 			     int buff_size);
 static ssize_t sg_submit(struct sg_fd *sfp, struct file *filp,
@@ -209,7 +209,7 @@ static void sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
 static void sg_remove_sfp(struct kref *);
 static struct sg_request *sg_setup_req(struct sg_fd *sfp);
-static int sg_remove_request(struct sg_fd *sfp, struct sg_request *srp);
+static int sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
 
@@ -539,7 +539,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	mutex_lock(&sfp->f_mutex);
 	if (sfp->next_cmd_len > 0) {
 		cmd_size = sfp->next_cmd_len;
-		sfp->next_cmd_len = 0;	/* reset so only this write() effected */
+		sfp->next_cmd_len = 0;	/* reset, only this write() effected */
 	} else {
 		cmd_size = COMMAND_SIZE(opcode);  /* old: SCSI command group */
 		if (opcode >= 0xc0 && ohp->twelve_byte)
@@ -553,7 +553,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	mxsize -= SZ_SG_HEADER;
 	input_size -= SZ_SG_HEADER;
 	if (input_size < 0) {
-		sg_remove_request(sfp, srp);
+		sg_deact_request(sfp, srp);
 		return -EIO;	/* User did not pass enough bytes for this command. */
 	}
 	h3p = &srp->header;
@@ -570,7 +570,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	h3p->dxfer_len = mxsize;
 	if (h3p->dxfer_direction == SG_DXFER_TO_DEV ||
 	    h3p->dxfer_direction == SG_DXFER_TO_FROM_DEV)
-		h3p->dxferp = (char __user *)p + cmd_size;
+		h3p->dxferp = (u8 __user *)p + cmd_size;
 	else
 		h3p->dxferp = NULL;
 	h3p->sbp = NULL;
@@ -579,7 +579,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	h3p->pack_id = ohp->pack_id;
 	h3p->usr_ptr = NULL;
 	if (copy_from_user(cmnd, p, cmd_size)) {
-		sg_remove_request(sfp, srp);
+		sg_deact_request(sfp, srp);
 		return -EFAULT;
 	}
 	/*
@@ -606,15 +606,24 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 }
 
 static int
-sg_allow_access(struct file *filp, u8 *cmd)
+sg_fetch_cmnd(struct file *filp, struct sg_fd *sfp, const u8 __user *u_cdbp,
+	      int len, u8 *cdbp)
 {
-	struct sg_fd *sfp = filp->private_data;
-
-	if (sfp->parentdp->device->type == TYPE_SCANNER)
-		return 0;
-
-	if (!scsi_cmd_allowed(cmd, filp->f_mode))
-		return -EPERM;
+	if (!u_cdbp || len < 6 || len > SG_MAX_CDB_SIZE)
+		return -EMSGSIZE;
+	if (copy_from_user(cdbp, u_cdbp, len))
+		return -EFAULT;
+	if (O_RDWR != (filp->f_flags & O_ACCMODE)) {	/* read-only */
+		switch (sfp->parentdp->device->type) {
+		case TYPE_DISK:
+		case TYPE_RBC:
+		case TYPE_ZBC:
+		if (!scsi_cmd_allowed(cdbp, filp->f_mode))
+			return -EPERM;
+		default:	/* SSC, SES, etc cbd_s may differ from SBC */
+			break;
+		}
+	}
 	return 0;
 }
 
@@ -623,12 +632,11 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 	  size_t count, bool blocking, bool read_only, bool sg_io_owned,
 	  struct sg_request **o_srp)
 {
-	int k;
+	int k, res, timeout;
 	struct sg_request *srp;
 	struct sg_io_hdr *hp;
 	struct sg_comm_wr_t cwr;
 	u8 cmnd[SG_MAX_CDB_SIZE];
-	int timeout;
 	unsigned long ul_timeout;
 
 	if (count < SZ_SG_IO_HDR)
@@ -641,41 +649,35 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 	}
 	srp->sg_io_owned = sg_io_owned;
 	hp = &srp->header;
+	/* get_sg_io_hdr() is defined in block/scsi_ioctl.c */
 	if (get_sg_io_hdr(hp, buf)) {
-		sg_remove_request(sfp, srp);
+		sg_deact_request(sfp, srp);
 		return -EFAULT;
 	}
 	if (hp->interface_id != 'S') {
-		sg_remove_request(sfp, srp);
+		sg_deact_request(sfp, srp);
 		return -ENOSYS;
 	}
 	if (hp->flags & SG_FLAG_MMAP_IO) {
 		if (hp->dxfer_len > sfp->reserve.buflen) {
-			sg_remove_request(sfp, srp);
+			sg_deact_request(sfp, srp);
 			return -ENOMEM;	/* MMAP_IO size must fit in reserve buffer */
 		}
 		if (hp->flags & SG_FLAG_DIRECT_IO) {
-			sg_remove_request(sfp, srp);
+			sg_deact_request(sfp, srp);
 			return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
 		}
 		if (sfp->res_in_use) {
-			sg_remove_request(sfp, srp);
+			sg_deact_request(sfp, srp);
 			return -EBUSY;	/* reserve buffer already being used */
 		}
 	}
 	ul_timeout = msecs_to_jiffies(srp->header.timeout);
 	timeout = (ul_timeout < INT_MAX) ? ul_timeout : INT_MAX;
-	if ((!hp->cmdp) || (hp->cmd_len < 6) || (hp->cmd_len > sizeof (cmnd))) {
-		sg_remove_request(sfp, srp);
-		return -EMSGSIZE;
-	}
-	if (copy_from_user(cmnd, hp->cmdp, hp->cmd_len)) {
-		sg_remove_request(sfp, srp);
-		return -EFAULT;
-	}
-	if (read_only && sg_allow_access(filp, cmnd)) {
-		sg_remove_request(sfp, srp);
-		return -EPERM;
+	res = sg_fetch_cmnd(filp, sfp, hp->cmdp, hp->cmd_len, cmnd);
+	if (res) {
+		sg_deact_request(sfp, srp);
+		return res;
 	}
 	cwr.timeout = timeout;
 	cwr.blocking = blocking;
@@ -710,7 +712,7 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 	       (int)cwrp->cmnd[0], hp->cmd_len);
 
 	if (hp->dxfer_len >= SZ_256M) {
-		sg_remove_request(sfp, srp);
+		sg_deact_request(sfp, srp);
 		return -EINVAL;
 	}
 
@@ -718,7 +720,7 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 	if (k) {
 		SG_LOG(1, sfp, "%s: start_req err=%d\n", __func__, k);
 		sg_finish_scsi_blk_rq(srp);
-		sg_remove_request(sfp, srp);
+		sg_deact_request(sfp, srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
 	if (SG_IS_DETACHING(sdp)) {
@@ -728,7 +730,7 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 		}
 
 		sg_finish_scsi_blk_rq(srp);
-		sg_remove_request(sfp, srp);
+		sg_deact_request(sfp, srp);
 		return -ENODEV;
 	}
 
@@ -773,12 +775,24 @@ sg_get_rq_mark(struct sg_fd *sfp, int pack_id)
 	return NULL;
 }
 
+static int
+srp_done(struct sg_fd *sfp, struct sg_request *srp)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&sfp->rq_list_lock, flags);
+	ret = srp->done;
+	spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
+	return ret;
+}
+
 static ssize_t
 sg_receive_v3(struct sg_fd *sfp, char __user *buf, size_t count,
 	      struct sg_request *srp)
 {
 	struct sg_io_hdr *hp = &srp->header;
-	int err = 0, err2;
+	int err = 0;
 	int len;
 
 	if (in_compat_syscall()) {
@@ -813,21 +827,9 @@ sg_receive_v3(struct sg_fd *sfp, char __user *buf, size_t count,
 		hp->info |= SG_INFO_CHECK;
 	err = put_sg_io_hdr(hp, buf);
 err_out:
-	err2 = sg_finish_scsi_blk_rq(srp);
-	sg_remove_request(sfp, srp);
-	return err ? : err2 ? : count;
-}
-
-static int
-srp_done(struct sg_fd *sfp, struct sg_request *srp)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&sfp->rq_list_lock, flags);
-	ret = srp->done;
-	spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
-	return ret;
+	sg_finish_scsi_blk_rq(srp);
+	sg_deact_request(sfp, srp);
+	return err;
 }
 
 static int
@@ -901,7 +903,7 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 		res = (h2p->result == 0) ? 0 : -EIO;
 	}
 	sg_finish_scsi_blk_rq(srp);
-	sg_remove_request(sfp, srp);
+	sg_deact_request(sfp, srp);
 	return res;
 }
 
@@ -1524,7 +1526,7 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 	struct sg_fd *sfp = srp->parentfp;
 
 	sg_finish_scsi_blk_rq(srp);
-	sg_remove_request(sfp, srp);
+	sg_deact_request(sfp, srp);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 }
 
@@ -1646,7 +1648,7 @@ static const struct file_operations sg_fops = {
 
 static struct class *sg_sysfs_class;
 
-static int sg_sysfs_valid = 0;
+static bool sg_sysfs_valid;
 
 static struct sg_device *
 sg_add_device_helper(struct scsi_device *scsidp)
@@ -1899,7 +1901,7 @@ init_sg(void)
 		rc = PTR_ERR(sg_sysfs_class);
 		goto err_out;
         }
-	sg_sysfs_valid = 1;
+	sg_sysfs_valid = true;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
 		sg_proc_init();
@@ -1928,7 +1930,7 @@ exit_sg(void)
 		remove_proc_subtree("scsi/sg", NULL);
 	scsi_unregister_interface(&sg_interface);
 	class_destroy(sg_sysfs_class);
-	sg_sysfs_valid = 0;
+	sg_sysfs_valid = false;
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
 				 SG_MAX_DEVS);
 	idr_destroy(&sg_index_idr);
@@ -2056,10 +2058,10 @@ sg_start_req(struct sg_request *srp, unsigned char *cmd)
 	return res;
 }
 
-static int
+static void
 sg_finish_scsi_blk_rq(struct sg_request *srp)
 {
-	int ret = 0;
+	int ret;
 
 	struct sg_fd *sfp = srp->parentfp;
 	struct sg_scatter_hold *req_schp = &srp->data;
@@ -2070,8 +2072,13 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 		atomic_dec(&sfp->submitted);
 		atomic_dec(&sfp->waiting);
 	}
-	if (srp->bio)
+	if (srp->bio) {
 		ret = blk_rq_unmap_user(srp->bio);
+		if (ret)	/* -EINTR (-4) can be ignored */
+			SG_LOG(6, sfp, "%s: blk_rq_unmap_user() --> %d\n",
+			       __func__, ret);
+		srp->bio = NULL;
+	}
 
 	if (srp->rq)
 		blk_mq_free_request(srp->rq);
@@ -2080,8 +2087,6 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 		sg_unlink_reserve(sfp, srp);
 	else
 		sg_remove_scat(sfp, req_schp);
-
-	return ret;
 }
 
 static int
@@ -2321,7 +2326,7 @@ sg_setup_req(struct sg_fd *sfp)
 
 /* Return of 1 for found; 0 for not found */
 static int
-sg_remove_request(struct sg_fd *sfp, struct sg_request *srp)
+sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 {
 	unsigned long iflags;
 	int res = 0;
@@ -2341,9 +2346,9 @@ sg_remove_request(struct sg_fd *sfp, struct sg_request *srp)
 static struct sg_fd *
 sg_add_sfp(struct sg_device *sdp)
 {
-	struct sg_fd *sfp;
 	unsigned long iflags;
 	int bufflen;
+	struct sg_fd *sfp;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
@@ -2389,10 +2394,16 @@ sg_add_sfp(struct sg_device *sdp)
 static void
 sg_remove_sfp_usercontext(struct work_struct *work)
 {
+	unsigned long iflags;
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew_fd.work);
-	struct sg_device *sdp = sfp->parentdp;
+	struct sg_device *sdp;
 	struct sg_request *srp;
-	unsigned long iflags;
+
+	if (!sfp) {
+		pr_warn("sg: %s: sfp is NULL\n", __func__);
+		return;
+	}
+	sdp = sfp->parentdp;
 
 	/* Cleanup any responses which were never read(). */
 	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
@@ -2413,17 +2424,19 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	SG_LOG(6, sfp, "%s: sfp=0x%p\n", __func__, sfp);
 	kfree(sfp);
 
-	scsi_device_put(sdp->device);
-	kref_put(&sdp->d_ref, sg_device_destroy);
+	if (sdp) {
+		scsi_device_put(sdp->device);
+		kref_put(&sdp->d_ref, sg_device_destroy);
+	}
 	module_put(THIS_MODULE);
 }
 
 static void
 sg_remove_sfp(struct kref *kref)
 {
+	unsigned long iflags;
 	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
 	struct sg_device *sdp = sfp->parentdp;
-	unsigned long iflags;
 
 	write_lock_irqsave(&sdp->sfd_lock, iflags);
 	list_del(&sfp->sfd_entry);
@@ -2636,7 +2649,7 @@ struct sg_proc_deviter {
 static void *
 dev_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct sg_proc_deviter * it = kmalloc(sizeof(*it), GFP_KERNEL);
+	struct sg_proc_deviter *it = kzalloc(sizeof(*it), GFP_KERNEL);
 
 	s->private = it;
 	if (! it)
-- 
2.25.1

