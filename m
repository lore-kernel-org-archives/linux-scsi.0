Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FADECE599
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 07:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77F142053B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 07:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfJHHue (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:50:34 -0400
Received: from smtp.infotech.no ([82.134.31.41]:34832 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbfJHHuc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Oct 2019 03:50:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C56DD204237;
        Tue,  8 Oct 2019 09:50:24 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2lXwAFI9u4M1; Tue,  8 Oct 2019 09:50:24 +0200 (CEST)
Received: from xtwo70.bingwo.ca (unknown [82.134.31.172])
        by smtp.infotech.no (Postfix) with ESMTPA id 2C2DE204199;
        Tue,  8 Oct 2019 09:50:24 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v5 23/23] sg: printk change %p to %pK
Date:   Tue,  8 Oct 2019 09:50:22 +0200
Message-Id: <20191008075022.30055-24-dgilbert@interlog.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191008075022.30055-1-dgilbert@interlog.com>
References: <20191008075022.30055-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This driver does a lot of buffer juggling in an attempt to
take some of that chore away from its users. When debugging
problems associated with that buffer juggling getting
sensible pointer values is a major aid. So change %p
to %pK. The system administrator can choose to obfuscate
%pK pointers. They are also easier to search for.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index aaae37ab77ba..dc8f19f6ce26 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -909,7 +909,7 @@ sg_v3_receive(struct sg_fd *sfp, struct sg_request *srp, void __user *p)
 	int err = 0;
 	struct sg_io_hdr *hp = &srp->header;
 
-	SG_LOG(3, sfp, "%s: srp=0x%p\n", __func__, srp);
+	SG_LOG(3, sfp, "%s: srp=0x%pK\n", __func__, srp);
 	err = sg_rec_v3_state(sfp, srp);
 	if (hp->masked_status || hp->host_status || hp->driver_status)
 		hp->info |= SG_INFO_CHECK;
@@ -1653,7 +1653,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -ENXIO;
 	}
 	req_sz = vma->vm_end - vma->vm_start;
-	SG_LOG(3, sfp, "%s: vm_start=%p, len=%d\n", __func__,
+	SG_LOG(3, sfp, "%s: vm_start=%pK, len=%d\n", __func__,
 	       (void *)vma->vm_start, (int)req_sz);
 	if (vma->vm_pgoff)
 		return -EINVAL; /* only an offset of 0 accepted */
@@ -1701,7 +1701,7 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 		WARN_ONCE(1, "%s: sfp unexpectedly NULL\n", __func__);
 		return;
 	}
-	SG_LOG(3, sfp, "%s: srp=0x%p\n", __func__, srp);
+	SG_LOG(3, sfp, "%s: srp=0x%pK\n", __func__, srp);
 	sg_finish_scsi_blk_rq(srp);
 	sg_deact_request(sfp, srp);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
@@ -1874,7 +1874,7 @@ sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	k = error;
 
 	SCSI_LOG_TIMEOUT(3, sdev_printk(KERN_INFO, scsidp,
-			 "%s: dev=%d, sdp=0x%p ++\n", __func__, k, sdp));
+			 "%s: dev=%d, sdp=0x%pK ++\n", __func__, k, sdp));
 	sprintf(disk->disk_name, "sg%d", k);
 	disk->first_minor = k;
 	sdp->disk = disk;
@@ -1993,7 +1993,7 @@ sg_device_destroy(struct kref *kref)
 	idr_remove(&sg_index_idr, sdp->index);
 	write_unlock_irqrestore(&sg_index_lock, flags);
 
-	sdev_printk(KERN_INFO, sdp->device, "[tid=%d] %s: sdp=0x%p --\n",
+	sdev_printk(KERN_INFO, sdp->device, "[tid=%d] %s: sdp=0x%pK --\n",
 		    (current ? current->pid : -1), __func__, sdp);
 
 	put_disk(sdp->disk);
@@ -2015,7 +2015,7 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 		return; /* only want to do following once per device */
 
 	SCSI_LOG_TIMEOUT(3, sdev_printk(KERN_INFO, sdp->device,
-					"%s: 0x%p\n", __func__, sdp));
+					"%s: 0x%pK\n", __func__, sdp));
 
 	read_lock_irqsave(&sdp->sfd_lock, iflags);
 	list_for_each_entry(sfp, &sdp->sfds, sfd_entry) {
@@ -2144,7 +2144,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
 		long_cmdp = kzalloc(hp->cmd_len, GFP_KERNEL);
 		if (!long_cmdp)
 			return -ENOMEM;
-		SG_LOG(5, sfp, "%s: long_cmdp=0x%p ++\n", __func__, long_cmdp);
+		SG_LOG(5, sfp, "%s: long_cmdp=0x%pK ++\n", __func__, long_cmdp);
 	}
 	SG_LOG(4, sfp, "%s: dxfer_len=%d, data-%s\n", __func__, dxfer_len,
 	       (r0w ? "OUT" : "IN"));
@@ -2252,7 +2252,7 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 	struct sg_fd *sfp = srp->parentfp;
 	struct sg_scatter_hold *req_schp = &srp->data;
 
-	SG_LOG(4, sfp, "%s: srp=0x%p%s\n", __func__, srp,
+	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp,
 	       (srp->res_used) ? " rsv" : "");
 	if (!srp->sg_io_owned) {
 		atomic_dec(&sfp->submitted);
@@ -2298,7 +2298,7 @@ sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp, int minlen)
 	align_sz = ALIGN(m_size, SG_DEF_SECTOR_SZ);
 
 	schp->pages = kcalloc(mx_sgat_elems, struct_page_sz, mask_kz);
-	SG_LOG(4, sfp, "%s: minlen=%d, align_sz=%d [sz=%zu, 0x%p ++]\n",
+	SG_LOG(4, sfp, "%s: minlen=%d, align_sz=%d [sz=%zu, 0x%pK ++]\n",
 	       __func__, minlen, align_sz, mx_sgat_elems * struct_page_sz,
 	       schp->pages);
 	if (unlikely(!schp->pages))
@@ -2317,7 +2317,7 @@ sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp, int minlen)
 		schp->pages[k] = alloc_pages(mask_ap, order);
 		if (!schp->pages[k])
 			goto err_out;
-		SG_LOG(5, sfp, "%s: k=%d, rup_sz=%d [0x%p ++]\n", __func__, k,
+		SG_LOG(5, sfp, "%s: k=%d, rup_sz=%d [0x%pK ++]\n", __func__, k,
 		       rup_sz, schp->pages[k]);
 	}
 	schp->page_order = order;
@@ -2347,12 +2347,12 @@ sg_remove_sgat_helper(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 		return;
 	for (k = 0; k < schp->num_sgat; ++k) {
 		p = schp->pages[k];
-		SG_LOG(5, sfp, "%s: pg[%d]=0x%p --\n", __func__, k, p);
+		SG_LOG(5, sfp, "%s: pg[%d]=0x%pK --\n", __func__, k, p);
 		if (unlikely(!p))
 			continue;
 		__free_pages(p, schp->page_order);
 	}
-	SG_LOG(5, sfp, "%s: pg_order=%u, free pgs=0x%p --\n", __func__,
+	SG_LOG(5, sfp, "%s: pg_order=%u, free pgs=0x%pK --\n", __func__,
 	       schp->page_order, schp->pages);
 	kfree(schp->pages);
 }
@@ -2589,7 +2589,7 @@ sg_add_sfp(struct sg_device *sdp)
 	}
 	list_add_tail(&sfp->sfd_entry, &sdp->sfds);
 	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
-	SG_LOG(3, sfp, "%s: sfp=0x%p\n", __func__, sfp);
+	SG_LOG(3, sfp, "%s: sfp=0x%pK\n", __func__, sfp);
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
 
@@ -2599,7 +2599,7 @@ sg_add_sfp(struct sg_device *sdp)
 
 	kref_get(&sdp->d_ref);
 	__module_get(THIS_MODULE);
-	SG_LOG(3, sfp, "%s: success, sfp=0x%p ++\n", __func__, sfp);
+	SG_LOG(3, sfp, "%s: success, sfp=0x%pK ++\n", __func__, sfp);
 	return sfp;
 }
 
@@ -2642,7 +2642,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 		sg_remove_sgat(sfp, &sfp->reserve);
 	}
 
-	SG_LOG(6, sfp, "%s: sfp=0x%p\n", __func__, sfp);
+	SG_LOG(6, sfp, "%s: sfp=0x%pK\n", __func__, sfp);
 	kfree(sfp);
 
 	if (sdp) {
-- 
2.23.0

