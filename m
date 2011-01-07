From: kxie@chelsio.com
Subject: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info
Date: Fri, 07 Jan 2011 14:45:39 -0800
Message-ID: <201101072245.p07MjdBm027576@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:9710 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab1AGWpt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 17:45:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

[PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info.

From: Karen Xie <kxie@chelsio.com>

Remove gl_skb from cxgbi_ddp_info as it is only used by cxgb3i.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |   51 +++++-------------------------------
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    2 -
 drivers/scsi/cxgbi/libcxgbi.c      |   15 +----------
 drivers/scsi/cxgbi/libcxgbi.h      |    3 --
 4 files changed, 8 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index a129a17..e2362b9 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -1108,10 +1108,11 @@ static int ddp_set_map(struct cxgbi_sock *csk, struct cxgbi_pagepod_hdr *hdr,
 		csk, idx, npods, gl);
 
 	for (i = 0; i < npods; i++, idx++, pm_addr += PPOD_SIZE) {
-		struct sk_buff *skb = ddp->gl_skb[idx];
+		struct sk_buff *skb = alloc_wr(sizeof(struct ulp_mem_io) +
+						PPOD_SIZE, 0, GFP_ATOMIC);
 
-		/* hold on to the skb until we clear the ddp mapping */
-		skb_get(skb);
+		if (!skb)
+			return -ENOMEM;
 
 		ulp_mem_io_set_hdr(skb, pm_addr);
 		cxgbi_ddp_ppod_set((struct cxgbi_pagepod *)(skb->head +
@@ -1136,56 +1137,20 @@ static void ddp_clear_map(struct cxgbi_hba *chba, unsigned int tag,
 		cdev, idx, npods, tag);
 
 	for (i = 0; i < npods; i++, idx++, pm_addr += PPOD_SIZE) {
-		struct sk_buff *skb = ddp->gl_skb[idx];
+		struct sk_buff *skb = alloc_wr(sizeof(struct ulp_mem_io) +
+						PPOD_SIZE, 0, GFP_ATOMIC);
 
 		if (!skb) {
-			pr_err("tag 0x%x, 0x%x, %d/%u, skb NULL.\n",
+			pr_err("tag 0x%x, 0x%x, %d/%u, skb OOM.\n",
 				tag, idx, i, npods);
 			continue;
 		}
-		ddp->gl_skb[idx] = NULL;
-		memset(skb->head + sizeof(struct ulp_mem_io), 0, PPOD_SIZE);
 		ulp_mem_io_set_hdr(skb, pm_addr);
 		skb->priority = CPL_PRIORITY_CONTROL;
 		cxgb3_ofld_send(cdev->lldev, skb);
 	}
 }
 
-static void ddp_free_gl_skb(struct cxgbi_ddp_info *ddp, int idx, int cnt)
-{
-	int i;
-
-	log_debug(1 << CXGBI_DBG_DDP,
-		"ddp 0x%p, idx %d, cnt %d.\n", ddp, idx, cnt);
-
-	for (i = 0; i < cnt; i++, idx++)
-		if (ddp->gl_skb[idx]) {
-			kfree_skb(ddp->gl_skb[idx]);
-			ddp->gl_skb[idx] = NULL;
-		}
-}
-
-static int ddp_alloc_gl_skb(struct cxgbi_ddp_info *ddp, int idx,
-				   int cnt, gfp_t gfp)
-{
-	int i;
-
-	log_debug(1 << CXGBI_DBG_DDP,
-		"ddp 0x%p, idx %d, cnt %d.\n", ddp, idx, cnt);
-
-	for (i = 0; i < cnt; i++) {
-		struct sk_buff *skb = alloc_wr(sizeof(struct ulp_mem_io) +
-						PPOD_SIZE, 0, gfp);
-		if (skb)
-			ddp->gl_skb[idx + i] = skb;
-		else {
-			ddp_free_gl_skb(ddp, idx, i);
-			return -ENOMEM;
-		}
-	}
-	return 0;
-}
-
 static int ddp_setup_conn_pgidx(struct cxgbi_sock *csk,
 				       unsigned int tid, int pg_idx, bool reply)
 {
@@ -1316,8 +1281,6 @@ static int cxgb3i_ddp_init(struct cxgbi_device *cdev)
 	}
 	tdev->ulp_iscsi = ddp;
 
-	cdev->csk_ddp_free_gl_skb = ddp_free_gl_skb;
-	cdev->csk_ddp_alloc_gl_skb = ddp_alloc_gl_skb;
 	cdev->csk_ddp_setup_digest = ddp_setup_conn_digest;
 	cdev->csk_ddp_setup_pgidx = ddp_setup_conn_pgidx;
 	cdev->csk_ddp_set = ddp_set_map;
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 8c04fad..5b1f078 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1425,8 +1425,6 @@ static int cxgb4i_ddp_init(struct cxgbi_device *cdev)
 	cxgbi_ddp_page_size_factor(pgsz_factor);
 	cxgb4_iscsi_init(lldi->ports[0], tagmask, pgsz_factor);
 
-	cdev->csk_ddp_free_gl_skb = NULL;
-	cdev->csk_ddp_alloc_gl_skb = NULL;
 	cdev->csk_ddp_setup_digest = ddp_setup_conn_digest;
 	cdev->csk_ddp_setup_pgidx = ddp_setup_conn_pgidx;
 	cdev->csk_ddp_set = ddp_set_map;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 17dcada..bfeb0b6 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1277,12 +1277,6 @@ static int ddp_tag_reserve(struct cxgbi_sock *csk, unsigned int tid,
 		return idx;
 	}
 
-	if (cdev->csk_ddp_alloc_gl_skb) {
-		err = cdev->csk_ddp_alloc_gl_skb(ddp, idx, npods, gfp);
-		if (err < 0)
-			goto unmark_entries;
-	}
-
 	tag = cxgbi_ddp_tag_base(tformat, sw_tag);
 	tag |= idx << PPOD_IDX_SHIFT;
 
@@ -1293,11 +1287,8 @@ static int ddp_tag_reserve(struct cxgbi_sock *csk, unsigned int tid,
 	hdr.page_offset = htonl(gl->offset);
 
 	err = cdev->csk_ddp_set(csk, &hdr, idx, npods, gl);
-	if (err < 0) {
-		if (cdev->csk_ddp_free_gl_skb)
-			cdev->csk_ddp_free_gl_skb(ddp, idx, npods);
+	if (err < 0)
 		goto unmark_entries;
-	}
 
 	ddp->idx_last = idx;
 	log_debug(1 << CXGBI_DBG_DDP,
@@ -1363,8 +1354,6 @@ static void ddp_destroy(struct kref *kref)
 					>> PPOD_PAGES_SHIFT;
 			pr_info("cdev 0x%p, ddp %d + %d.\n", cdev, i, npods);
 			kfree(gl);
-			if (cdev->csk_ddp_free_gl_skb)
-				cdev->csk_ddp_free_gl_skb(ddp, i, npods);
 			i += npods;
 		} else
 			i++;
@@ -1407,8 +1396,6 @@ int cxgbi_ddp_init(struct cxgbi_device *cdev,
 		return -ENOMEM;
 	}
 	ddp->gl_map = (struct cxgbi_gather_list **)(ddp + 1);
-	ddp->gl_skb = (struct sk_buff **)(((char *)ddp->gl_map) +
-				ppmax * sizeof(struct cxgbi_gather_list *));
 	cdev->ddp = ddp;
 
 	spin_lock_init(&ddp->map_lock);
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index c57d59d..23cbc58 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -131,7 +131,6 @@ struct cxgbi_ddp_info {
 	unsigned int rsvd_tag_mask;
 	spinlock_t map_lock;
 	struct cxgbi_gather_list **gl_map;
-	struct sk_buff **gl_skb;
 };
 
 #define DDP_PGIDX_MAX		4
@@ -536,8 +535,6 @@ struct cxgbi_device {
 	struct cxgbi_ddp_info *ddp;
 
 	void (*dev_ddp_cleanup)(struct cxgbi_device *);
-	void (*csk_ddp_free_gl_skb)(struct cxgbi_ddp_info *, int, int);
-	int (*csk_ddp_alloc_gl_skb)(struct cxgbi_ddp_info *, int, int, gfp_t);
 	int (*csk_ddp_set)(struct cxgbi_sock *, struct cxgbi_pagepod_hdr *,
 				unsigned int, unsigned int,
 				struct cxgbi_gather_list *);
