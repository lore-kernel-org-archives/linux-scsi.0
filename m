Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72FBC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiJXDZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiJXDXD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:23:03 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C87BB6E2EC
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9A7D42041C0;
        Mon, 24 Oct 2022 05:21:56 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id p9Zv5hqK1Q9n; Mon, 24 Oct 2022 05:21:56 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 70BF42041AF;
        Mon, 24 Oct 2022 05:21:55 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v25 37/44] sg: add mmap_sz tracking
Date:   Sun, 23 Oct 2022 23:20:51 -0400
Message-Id: <20221024032058.14077-38-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Track mmap_sz from prior mmap(2) call, per sg file descriptor. Also
reset this value whenever munmap(2) is called. Fail SG_FLAG_MMAP_IO
uses if mmap(2) hasn't been called or the memory associated with it
is not large enough for the current request.

Remove SG_FFD_MMAP_CALLED bit as it can be deduced from
sfp->mmap_sz where a value of 0 implies no mmap() call active.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c9eb9e842f9e..a37e1156e4c2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -124,8 +124,7 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
 #define SG_FFD_CMD_Q		1	/* clear: only 1 active req per fd */
 #define SG_FFD_KEEP_ORPHAN	2	/* policy for this fd */
-#define SG_FFD_MMAP_CALLED	3	/* mmap(2) system call made on fd */
-#define SG_FFD_Q_AT_TAIL	5	/* set: queue reqs at tail of blk q */
+#define SG_FFD_Q_AT_TAIL	3	/* set: queue reqs at tail of blk q */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -234,6 +233,7 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	atomic_t waiting;	/* number of requests awaiting receive */
 	atomic_t req_cnt;	/* number of requests */
 	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
+	int mmap_sz;		/* byte size of previous mmap() call */
 	unsigned long ffd_bm[1];	/* see SG_FFD_* defines above */
 	pid_t tid;		/* thread id when opened */
 	u8 next_cmd_len;	/* 0: automatic, >0: use on next write() */
@@ -724,10 +724,14 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 static inline int
 sg_chk_mmap(struct sg_fd *sfp, int rq_flags, int len)
 {
+	if (unlikely(sfp->mmap_sz == 0))
+		return -EBADFD;
 	if (atomic_read(&sfp->submitted) > 0)
 		return -EBUSY;  /* already active requests on fd */
 	if (len > sfp->rsv_srp->sgat_h.buflen)
 		return -ENOMEM; /* MMAP_IO size must fit in reserve */
+	if (unlikely(len > sfp->mmap_sz))
+		return -ENOMEM; /* MMAP_IO size can't exceed mmap() size */
 	if (rq_flags & SG_FLAG_DIRECT_IO)
 		return -EINVAL; /* not both MMAP_IO and DIRECT_IO */
 	return 0;
@@ -1751,13 +1755,12 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 	int new_sz, blen, res;
 	unsigned long iflags;
 	struct sg_scatter_hold n_schp, o_schp;
-	struct sg_request *srp;
+	struct sg_request *srp = sfp->rsv_srp;
 	struct xarray *xafp = &sfp->srp_arr;
 
-	srp = sfp->rsv_srp;
 	if (!srp)
 		return -EPROTO;
-	if (test_bit(SG_FRQ_FOR_MMAP, srp->frq_bm))
+	if (SG_RS_ACTIVE(srp) || sfp->mmap_sz > 0)
 		return -EBUSY;
 	new_sz = min_t(int, want_rsv_sz, sfp->parentdp->max_sgat_sz);
 	new_sz = max_t(int, new_sz, sfp->sgat_elem_sz);
@@ -2171,6 +2174,7 @@ sg_vma_close(struct vm_area_struct *vma)
 		pr_warn("%s: sfp null\n", __func__);
 		return;
 	}
+	sfp->mmap_sz = 0;
 	kref_put(&sfp->f_ref, sg_remove_sfp); /* get in: sg_vma_open() */
 }
 
@@ -2261,7 +2265,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	req_sz = vma->vm_end - vma->vm_start;
 	SG_LOG(3, sfp, "%s: vm_start=%pK, len=%d\n", __func__,
 	       (void *)vma->vm_start, (int)req_sz);
-	if (vma->vm_pgoff) {
+	if (unlikely(vma->vm_pgoff || req_sz < SG_DEF_SECTOR_SZ)) {
 		res = -EINVAL; /* only an offset of 0 accepted */
 		goto fini;
 	}
@@ -2275,7 +2279,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		res = -ENOMEM;
 		goto fini;
 	}
-	if (test_and_set_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm)) {
+	if (sfp->mmap_sz > 0) {
 		SG_LOG(1, sfp, "%s: multiple invocations on this fd\n",
 		       __func__);
 		res = -EADDRINUSE;
@@ -2292,6 +2296,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 			goto fini;
 		}
 	}
+	sfp->mmap_sz = req_sz;
 	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = sfp;
 	vma->vm_ops = &sg_mmap_vm_ops;
@@ -3924,8 +3929,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 		       (int)test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm),
 		       (int)test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm),
 		       fp->ffd_bm[0]);
-	n += scnprintf(obp + n, len - n, "   mmap_called=%d\n",
-		       test_bit(SG_FFD_MMAP_CALLED, fp->ffd_bm));
+	n += scnprintf(obp + n, len - n, "   mmap_sz=%d\n", fp->mmap_sz);
 	n += scnprintf(obp + n, len - n,
 		       "   submitted=%d waiting=%d   open thr_id=%d\n",
 		       atomic_read(&fp->submitted),
-- 
2.37.3

