Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A17ECE598
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 07:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F7542053B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 07:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbfJHHuc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:50:32 -0400
Received: from smtp.infotech.no ([82.134.31.41]:34831 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730167AbfJHHu3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Oct 2019 03:50:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 5E233204275;
        Tue,  8 Oct 2019 09:50:24 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 54XPWn2yvLBc; Tue,  8 Oct 2019 09:50:24 +0200 (CEST)
Received: from xtwo70.bingwo.ca (unknown [82.134.31.172])
        by smtp.infotech.no (Postfix) with ESMTPA id C0928204197;
        Tue,  8 Oct 2019 09:50:23 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v5 18/23] sg: replace sg_allow_access
Date:   Tue,  8 Oct 2019 09:50:17 +0200
Message-Id: <20191008075022.30055-19-dgilbert@interlog.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191008075022.30055-1-dgilbert@interlog.com>
References: <20191008075022.30055-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the sg_allow_access() function with sg_fetch_cmnd()
which does a little more. Change sg_finish_scsi_blk_rq() from an
int to a void returning function. Rename sg_remove_request()
to sg_deact_request(). Other changes, mainly cosmetic.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 149 +++++++++++++++++++++++++---------------------
 1 file changed, 80 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2ad86aaaf74d..5ac21e41be27 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -189,7 +189,7 @@ static void sg_rq_end_io(struct request *rq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
 static int sg_proc_init(void);
 static int sg_start_req(struct sg_request *srp, u8 *cmd);
-static int sg_finish_scsi_blk_rq(struct sg_request *srp);
+static void sg_finish_scsi_blk_rq(struct sg_request *srp);
 static int sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
 			     int buff_size);
 static ssize_t sg_submit(struct sg_fd *sfp, struct file *filp,
@@ -207,7 +207,7 @@ static void sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
 static void sg_remove_sfp(struct kref *);
 static struct sg_request *sg_add_request(struct sg_fd *sfp);
-static int sg_remove_request(struct sg_fd *sfp, struct sg_request *srp);
+static int sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
 
@@ -545,7 +545,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	mutex_lock(&sfp->f_mutex);
 	if (sfp->next_cmd_len > 0) {
 		cmd_size = sfp->next_cmd_len;
-		sfp->next_cmd_len = 0;	/* reset so only this write() effected */
+		sfp->next_cmd_len = 0;	/* reset, only this write() effected */
 	} else {
 		cmd_size = COMMAND_SIZE(opcode);  /* old: SCSI command group */
 		if (opcode >= 0xc0 && ohp->twelve_byte)
@@ -559,7 +559,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	mxsize -= SZ_SG_HEADER;
 	input_size -= SZ_SG_HEADER;
 	if (input_size < 0) {
-		sg_remove_request(sfp, srp);
+		sg_deact_request(sfp, srp);
 		return -EIO;	/* User did not pass enough bytes for this command. */
 	}
 	h3p = &srp->header;
@@ -576,12 +576,12 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	h3p->dxfer_len = mxsize;
 	if (h3p->dxfer_direction == SG_DXFER_TO_DEV ||
 	    h3p->dxfer_direction == SG_DXFER_TO_FROM_DEV)
-		h3p->dxferp = (char __user *)p + cmd_size;
+		h3p->dxferp = (u8 __user *)p + cmd_size;
 	else
 		h3p->dxferp = NULL;
 	h3p->sbp = NULL;
-	h3p->timeout = ohp->reply_len;  /* structure abuse ... */
-	h3p->flags = input_size;        /* structure abuse ... */
+	h3p->timeout = ohp->reply_len;	/* structure abuse ... */
+	h3p->flags = input_size;	/* structure abuse ... */
 	h3p->pack_id = ohp->pack_id;
 	h3p->usr_ptr = NULL;
 	if (copy_from_user(cmnd, p, cmd_size))
@@ -610,14 +610,24 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
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
-	return blk_verify_command(cmd, filp->f_mode);
+	if (!u_cdbp || len < 6 || len > SG_MAX_CDB_SIZE)
+		return -EMSGSIZE;
+	if (copy_from_user(cdbp, u_cdbp, len))
+		return -EFAULT;
+	if (O_RDWR != (filp->f_flags & O_ACCMODE)) {	/* read-only */
+		switch (sfp->parentdp->device->type) {
+		case TYPE_DISK:
+		case TYPE_RBC:
+		case TYPE_ZBC:
+			return blk_verify_command(cdbp, filp->f_mode);
+		default:	/* SSC, SES, etc cbd_s may differ from SBC */
+			break;
+		}
+	}
+	return 0;
 }
 
 static ssize_t
@@ -625,12 +635,11 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
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
@@ -644,40 +653,33 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 	srp->sg_io_owned = sg_io_owned;
 	hp = &srp->header;
 	if (copy_from_user(hp, buf, SZ_SG_IO_HDR)) {
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
@@ -718,7 +720,7 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 	if (k) {
 		SG_LOG(1, sfp, "%s: start_req err=%d\n", __func__, k);
 		sg_finish_scsi_blk_rq(srp);
-		sg_remove_request(sfp, srp);
+		sg_deact_request(sfp, srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
 	if (SG_IS_DETACHING(sdp)) {
@@ -729,7 +731,7 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 		}
 
 		sg_finish_scsi_blk_rq(srp);
-		sg_remove_request(sfp, srp);
+		sg_deact_request(sfp, srp);
 		return -ENODEV;
 	}
 
@@ -776,11 +778,23 @@ sg_get_rq_mark(struct sg_fd *sfp, int pack_id)
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
 sg_v3_receive(struct sg_fd *sfp, char __user *buf, struct sg_request *srp)
 {
 	struct sg_io_hdr *hp = &srp->header;
-	int err = 0, err2;
+	int err = 0;
 	int len;
 
 	hp->sb_len_wr = 0;
@@ -807,25 +821,11 @@ sg_v3_receive(struct sg_fd *sfp, char __user *buf, struct sg_request *srp)
 		err = -EFAULT;
 
 err_out:
-	err2 = sg_finish_scsi_blk_rq(srp);
-	if (err2)
-		err = err ? err : err2;
-	sg_remove_request(sfp, srp);
+	sg_finish_scsi_blk_rq(srp);
+	sg_deact_request(sfp, srp);
 	return err ? err : 0;
 }
 
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
-}
-
 static int
 sg_rd_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 	   struct sg_request *srp)
@@ -895,7 +895,7 @@ sg_rd_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 	} else
 		res = (h2p->result == 0) ? 0 : -EIO;
 	sg_finish_scsi_blk_rq(srp);
-	sg_remove_request(sfp, srp);
+	sg_deact_request(sfp, srp);
 	return res;
 }
 
@@ -1507,7 +1507,7 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 	struct sg_fd *sfp = srp->parentfp;
 
 	sg_finish_scsi_blk_rq(srp);
-	sg_remove_request(sfp, srp);
+	sg_deact_request(sfp, srp);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 }
 
@@ -1632,7 +1632,7 @@ static const struct file_operations sg_fops = {
 
 static struct class *sg_sysfs_class;
 
-static int sg_sysfs_valid = 0;
+static bool sg_sysfs_valid;
 
 static struct sg_device *
 sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
@@ -1865,7 +1865,7 @@ init_sg(void)
 		rc = PTR_ERR(sg_sysfs_class);
 		goto err_out;
         }
-	sg_sysfs_valid = 1;
+	sg_sysfs_valid = true;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
 		sg_proc_init();
@@ -1892,7 +1892,7 @@ exit_sg(void)
 		remove_proc_subtree("scsi/sg", NULL);
 	scsi_unregister_interface(&sg_interface);
 	class_destroy(sg_sysfs_class);
-	sg_sysfs_valid = 0;
+	sg_sysfs_valid = false;
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
 				 SG_MAX_DEVS);
 	idr_destroy(&sg_index_idr);
@@ -2027,10 +2027,10 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
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
@@ -2041,8 +2041,13 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
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
 
 	if (srp->rq) {
 		scsi_req_free_cmd(scsi_req(srp->rq));
@@ -2053,8 +2058,6 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 		sg_unlink_reserve(sfp, srp);
 	else
 		sg_remove_scat(sfp, req_schp);
-
-	return ret;
 }
 
 static int
@@ -2298,7 +2301,7 @@ sg_add_request(struct sg_fd *sfp)
 
 /* Return of 1 for found; 0 for not found */
 static int
-sg_remove_request(struct sg_fd *sfp, struct sg_request *srp)
+sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 {
 	unsigned long iflags;
 	int res = 0;
@@ -2318,9 +2321,9 @@ sg_remove_request(struct sg_fd *sfp, struct sg_request *srp)
 static struct sg_fd *
 sg_add_sfp(struct sg_device *sdp)
 {
-	struct sg_fd *sfp;
 	unsigned long iflags;
 	int bufflen;
+	struct sg_fd *sfp;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
@@ -2366,10 +2369,16 @@ sg_add_sfp(struct sg_device *sdp)
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
@@ -2390,17 +2399,19 @@ sg_remove_sfp_usercontext(struct work_struct *work)
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
@@ -2615,7 +2626,7 @@ struct sg_proc_deviter {
 static void *
 dev_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct sg_proc_deviter * it = kmalloc(sizeof(*it), GFP_KERNEL);
+	struct sg_proc_deviter *it = kzalloc(sizeof(*it), GFP_KERNEL);
 
 	s->private = it;
 	if (! it)
-- 
2.23.0

