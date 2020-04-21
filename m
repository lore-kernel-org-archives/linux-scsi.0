Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41ECC54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CE4820724
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgDUVx5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:53:57 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43184 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgDUVxy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 17:53:54 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 4FF862041AF;
        Tue, 21 Apr 2020 23:53:52 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RGr25NROIchS; Tue, 21 Apr 2020 23:53:50 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id EBCFA2041B2;
        Tue, 21 Apr 2020 23:53:46 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v9 39/40] sg: add mmap_sz tracking
Date:   Tue, 21 Apr 2020 17:52:57 -0400
Message-Id: <20200421215258.14348-40-dgilbert@interlog.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421215258.14348-1-dgilbert@interlog.com>
References: <20200421215258.14348-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Track mmap_sz from prior mmap(2) call, per sg file descriptor. Also
reset this value whenever munmap(2) is called. Fail SG_FLAG_MMAP_IO
uses if mmap(2) hasn't been called or the memory associated with it
is not large enough for the current request.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7e261b065190..ba9f08b932a5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -231,6 +231,7 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	atomic_t waiting;	/* number of requests awaiting receive */
 	atomic_t req_cnt;	/* number of requests */
 	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
+	int mmap_sz;		/* byte size of previous mmap() call */
 	unsigned long ffd_bm[1];	/* see SG_FFD_* defines above */
 	pid_t tid;		/* thread id when opened */
 	u8 next_cmd_len;	/* 0: automatic, >0: use on next write() */
@@ -725,10 +726,14 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 static inline int
 sg_chk_mmap(struct sg_fd *sfp, int rq_flags, int len)
 {
+	if (!test_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm))
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
@@ -2260,6 +2265,8 @@ sg_vma_close(struct vm_area_struct *vma)
 		pr_warn("%s: sfp null\n", __func__);
 		return;
 	}
+	sfp->mmap_sz = 0;
+	clear_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm);
 	kref_put(&sfp->f_ref, sg_remove_sfp); /* get in: sg_vma_open() */
 }
 
@@ -2380,6 +2387,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 			goto fini;
 		}
 	}
+	sfp->mmap_sz = req_sz;
 	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = sfp;
 	vma->vm_ops = &sg_mmap_vm_ops;
@@ -4060,8 +4068,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
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
2.26.1

