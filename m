Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CBBC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB614613C5
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbhD0WAc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:32 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38843 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239343AbhD0V7v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 5F320204199;
        Tue, 27 Apr 2021 23:59:06 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1a-apQQs3JNO; Tue, 27 Apr 2021 23:59:04 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id E74EA204295;
        Tue, 27 Apr 2021 23:59:02 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 58/83] sg: tweak sg_find_sfp_by_fd()
Date:   Tue, 27 Apr 2021 17:57:08 -0400
Message-Id: <20210427215733.417746-60-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sg_find_sfp_by_fd() function is called every time a file share
is established. If request sharing is being used to copy to two
or more destinations, there will be many calls to this function
to swap between those destination, so its performance may become
important. Simplify the "search" by drilling into the given
fd's 'struct file' as, if all is well, the wanted sfp is in
filp->private_data.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 193 +++++++++++++++-------------------------------
 1 file changed, 62 insertions(+), 131 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 02435d2ef555..7f62cd9bffe0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -457,9 +457,8 @@ sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 		while (atomic_read(&sdp->open_cnt) > 0) {
 			mutex_unlock(&sdp->open_rel_lock);
 			res = wait_event_interruptible
-					(sdp->open_wait,
-					 (SG_IS_DETACHING(sdp) ||
-					  atomic_read(&sdp->open_cnt) == 0));
+				(sdp->open_wait,
+				 (SG_IS_DETACHING(sdp) || atomic_read(&sdp->open_cnt) == 0));
 			mutex_lock(&sdp->open_rel_lock);
 
 			if (res) /* -ERESTARTSYS */
@@ -471,9 +470,7 @@ sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 		while (SG_HAVE_EXCLUDE(sdp)) {
 			mutex_unlock(&sdp->open_rel_lock);
 			res = wait_event_interruptible
-					(sdp->open_wait,
-					 (SG_IS_DETACHING(sdp) ||
-					  !SG_HAVE_EXCLUDE(sdp)));
+				(sdp->open_wait, (SG_IS_DETACHING(sdp) || !SG_HAVE_EXCLUDE(sdp)));
 			mutex_lock(&sdp->open_rel_lock);
 
 			if (res) /* -ERESTARTSYS */
@@ -2589,7 +2586,7 @@ sg_unshare_rs_fd(struct sg_fd *rs_sfp, bool lck)
 	__xa_clear_mark(xadp, rs_sfp->idx, SG_XA_FD_RS_SHARE);
 	if (lck)
 		xa_unlock_irqrestore(xadp, iflags);
-	kref_put(&rs_sfp->f_ref, sg_remove_sfp);/* get: sg_find_sfp_helper() */
+	kref_put(&rs_sfp->f_ref, sg_remove_sfp);/* get: sg_find_sfp_by_fd() */
 }
 
 static void
@@ -2606,7 +2603,7 @@ sg_unshare_ws_fd(struct sg_fd *ws_sfp, bool lck)
 	/* SG_XA_FD_RS_SHARE mark should be already clear */
 	if (lck)
 		xa_unlock_irqrestore(xadp, iflags);
-	kref_put(&ws_sfp->f_ref, sg_remove_sfp);/* get: sg_find_sfp_helper() */
+	kref_put(&ws_sfp->f_ref, sg_remove_sfp);/* get: sg_find_sfp_by_fd() */
 }
 
 /*
@@ -3249,144 +3246,67 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	return res;
 }
 
-static int
-sg_idr_max_id(int id, void *p, void *data)
-		__must_hold(&sg_index_lock)
-{
-	int *k = data;
-
-	if (*k < id)
-		*k = id;
-	return 0;
-}
-
-static int
-sg_find_sfp_helper(struct sg_fd *from_sfp, struct sg_fd *pair_sfp,
-		   bool from_rd_side, int search_fd)
+/*
+ * Check if search_for is a "char" device fd whose MAJOR is this driver.
+ * If so filp->private_data must be the sfp we are looking for. Do further
+ * checks (e.g. not already in a file share). If all is well set up cross
+ * references and adjust xarray marks. Returns a sfp or negative errno
+ * twisted by ERR_PTR().
+ */
+static struct sg_fd *
+sg_find_sfp_by_fd(const struct file *search_for, struct sg_fd *from_sfp,
+		  bool is_reshare)
 		__must_hold(&from_sfp->f_mutex)
 {
-	bool same_sdp;
 	int res = 0;
 	unsigned long iflags;
+	struct sg_fd *sfp;
 	struct sg_device *from_sdp = from_sfp->parentdp;
-	struct sg_device *pair_sdp = pair_sfp->parentdp;
+	struct sg_device *sdp;
 
-	if (unlikely(!mutex_trylock(&pair_sfp->f_mutex)))
-		return -EPROBE_DEFER;	/* use to suggest re-invocation */
-	if (unlikely(sg_fd_is_shared(pair_sfp)))
+	SG_LOG(6, from_sfp, "%s: enter,  from_sfp=%pK search_for=%pK\n",
+	       __func__, from_sfp, search_for);
+	if (!(S_ISCHR(search_for->f_inode->i_mode) &&
+	      MAJOR(search_for->f_inode->i_rdev) == SCSI_GENERIC_MAJOR))
+		return ERR_PTR(-EBADF);
+	sfp = search_for->private_data;
+	if (!sfp)
+		return ERR_PTR(-ENXIO);
+	sdp = sfp->parentdp;
+	if (!sdp)
+		return ERR_PTR(-ENXIO);
+	if (unlikely(!mutex_trylock(&sfp->f_mutex)))
+		return ERR_PTR(-EPROBE_DEFER);	/* suggest re-invocation */
+	if (unlikely(sg_fd_is_shared(sfp)))
 		res = -EADDRNOTAVAIL;
-	else if (unlikely(SG_HAVE_EXCLUDE(pair_sdp)))
+	else if (unlikely(SG_HAVE_EXCLUDE(sdp)))
 		res = -EPERM;
 	if (res) {
-		mutex_unlock(&pair_sfp->f_mutex);
-		return res;
+		mutex_unlock(&sfp->f_mutex);
+		return ERR_PTR(res);
 	}
-	same_sdp = (from_sdp == pair_sdp);
+
 	xa_lock_irqsave(&from_sdp->sfp_arr, iflags);
-	rcu_assign_pointer(from_sfp->share_sfp, pair_sfp);
+	rcu_assign_pointer(from_sfp->share_sfp, sfp);
 	__xa_clear_mark(&from_sdp->sfp_arr, from_sfp->idx, SG_XA_FD_UNSHARED);
-	kref_get(&from_sfp->f_ref);	/* so unshare done before release */
-	if (from_rd_side)
+	if (is_reshare)	/* reshare case: no kref_get() on read-side */
 		__xa_set_mark(&from_sdp->sfp_arr, from_sfp->idx,
 			      SG_XA_FD_RS_SHARE);
-
-	if (!same_sdp) {
+	else
+		kref_get(&from_sfp->f_ref);/* so unshare done before release */
+	if (from_sdp != sdp) {
 		xa_unlock_irqrestore(&from_sdp->sfp_arr, iflags);
-		xa_lock_irqsave(&pair_sdp->sfp_arr, iflags);
-	}
-
-	mutex_unlock(&pair_sfp->f_mutex);
-	rcu_assign_pointer(pair_sfp->share_sfp, from_sfp);
-	__xa_clear_mark(&pair_sdp->sfp_arr, pair_sfp->idx, SG_XA_FD_UNSHARED);
-	if (!from_rd_side)
-		__xa_set_mark(&pair_sdp->sfp_arr, pair_sfp->idx,
-			      SG_XA_FD_RS_SHARE);
-	kref_get(&pair_sfp->f_ref);	/* keep symmetry */
-	xa_unlock_irqrestore(&pair_sdp->sfp_arr, iflags);
-	return 0;
-}
-
-/*
- * Scans sg driver object tree looking for search_for. Returns valid pointer
- * if found; returns negated errno twisted by ERR_PTR(); or return NULL if
- * not found (and no error).
- */
-static struct sg_fd *
-sg_find_sfp_by_fd(const struct file *search_for, int search_fd,
-		  struct sg_fd *from_sfp, bool from_is_rd_side)
-		__must_hold(&from_sfp->f_mutex)
-{
-	bool found = false;
-	int k, num_d;
-	int res = 0;
-	unsigned long iflags, idx;
-	struct sg_fd *sfp;
-	struct sg_device *sdp;
-
-	num_d = -1;
-	SG_LOG(6, from_sfp, "%s: enter,  from_sfp=%pK search_for=%pK\n",
-	       __func__, from_sfp, search_for);
-	read_lock_irqsave(&sg_index_lock, iflags);
-	idr_for_each(&sg_index_idr, sg_idr_max_id, &num_d);
-	++num_d;
-	for (k = 0; k < num_d; ++k) {
-		sdp = idr_find(&sg_index_idr, k);
-		if (unlikely(!sdp) || SG_IS_DETACHING(sdp))
-			continue;
-		xa_for_each_marked(&sdp->sfp_arr, idx, sfp,
-				   SG_XA_FD_UNSHARED) {
-			if (sfp == from_sfp)
-				continue;
-			if (test_bit(SG_FFD_RELEASE, sfp->ffd_bm))
-				continue;
-			if (search_for != sfp->filp)
-				continue;       /* not this one */
-			res = sg_find_sfp_helper(from_sfp, sfp,
-						 from_is_rd_side, search_fd);
-			if (likely(res == 0)) {
-				found = true;
-				break;
-			}
-		}       /* end of loop of all fd_s in current device */
-		if (res || found)
-			break;
-	}       /* end of loop of all sg devices */
-	read_unlock_irqrestore(&sg_index_lock, iflags);
-	if (found) {	/* mark both fds as part of share */
-		struct sg_device *from_sdp = from_sfp->parentdp;
-
 		xa_lock_irqsave(&sdp->sfp_arr, iflags);
-		__xa_clear_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_UNSHARED);
-		xa_unlock_irqrestore(&sdp->sfp_arr, iflags);
-		xa_lock_irqsave(&from_sdp->sfp_arr, iflags);
-		__xa_clear_mark(&from_sfp->parentdp->sfp_arr, from_sfp->idx,
-				SG_XA_FD_UNSHARED);
-		xa_unlock_irqrestore(&from_sdp->sfp_arr, iflags);
-	} else if (res == 0) {	/* fine tune error response */
-		num_d = -1;
-		read_lock_irqsave(&sg_index_lock, iflags);
-		idr_for_each(&sg_index_idr, sg_idr_max_id, &num_d);
-		++num_d;
-		for (k = 0; k < num_d; ++k) {
-			sdp = idr_find(&sg_index_idr, k);
-			if (unlikely(!sdp) || SG_IS_DETACHING(sdp))
-				continue;
-			xa_for_each(&sdp->sfp_arr, idx, sfp) {
-				if (!sg_fd_is_shared(sfp))
-					continue;
-				if (search_for == sfp->filp) {
-					res = -EADDRNOTAVAIL;  /* already */
-					break;
-				}
-			}
-			if (res)
-				break;
-		}
-		read_unlock_irqrestore(&sg_index_lock, iflags);
 	}
-	if (unlikely(res < 0))
-		return ERR_PTR(res);
-	return found ? sfp : NULL;
+	mutex_unlock(&sfp->f_mutex);
+	rcu_assign_pointer(sfp->share_sfp, from_sfp);
+	__xa_clear_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_UNSHARED);
+	if (!is_reshare)
+		__xa_set_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE);
+	kref_get(&sfp->f_ref);		/* undone: sg_unshare_*_fd() */
+	xa_unlock_irqrestore(&sdp->sfp_arr, iflags);
+
+	return sfp;
 }
 
 /*
@@ -3423,7 +3343,7 @@ sg_fd_share(struct sg_fd *ws_sfp, int m_fd)
 	SG_LOG(6, ws_sfp, "%s: read-side fd okay, scan for filp=0x%pK\n",
 	       __func__, filp);
 again:
-	rs_sfp = sg_find_sfp_by_fd(filp, m_fd, ws_sfp, false);
+	rs_sfp = sg_find_sfp_by_fd(filp, ws_sfp, false);
 	if (IS_ERR(rs_sfp)) {
 		res = PTR_ERR(rs_sfp);
 		if (res == -EPROBE_DEFER) {
@@ -3494,7 +3414,7 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 	       filp);
 	sg_unshare_ws_fd(ws_sfp, false);
 again:
-	ws_sfp = sg_find_sfp_by_fd(filp, new_ws_fd, rs_sfp, true);
+	ws_sfp = sg_find_sfp_by_fd(filp, rs_sfp, true);
 	if (IS_ERR(ws_sfp)) {
 		res = PTR_ERR(ws_sfp);
 		if (res == -EPROBE_DEFER) {
@@ -6406,6 +6326,17 @@ struct sg_proc_deviter {
 	int fd_index;
 };
 
+static int
+sg_idr_max_id(int id, void *p, void *data)
+		__must_hold(&sg_index_lock)
+{
+	int *k = data;
+
+	if (*k < id)
+		*k = id;
+	return 0;
+}
+
 static int
 sg_last_dev(void)
 {
-- 
2.25.1

