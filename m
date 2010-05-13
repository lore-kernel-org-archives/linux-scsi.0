From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 6/9] cxgb3i: use kvzalloc and kvfree
Date: Thu, 13 May 2010 19:08:07 +0800
Message-ID: <1273748887-10364-1-git-send-email-xiaosuo@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63721 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592Ab0EMLI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2010 07:08:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>

use kvzalloc and kvfree

use kvzalloc and kvfree

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 drivers/scsi/cxgb3i/cxgb3i_ddp.c     |   12 +++++-------
 drivers/scsi/cxgb3i/cxgb3i_ddp.h     |   26 --------------------------
 drivers/scsi/cxgb3i/cxgb3i_offload.c |    6 +++---
 3 files changed, 8 insertions(+), 36 deletions(-)
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index b58d913..2795440 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -648,7 +648,7 @@ static void ddp_cleanup(struct kref *kref)
 		} else
 			i++;
 	}
-	cxgb3i_free_big_mem(ddp);
+	kvfree(ddp);
 }
 
 void cxgb3i_ddp_cleanup(struct t3cdev *tdev)
@@ -692,11 +692,9 @@ static void ddp_init(struct t3cdev *tdev)
 		bits = PPOD_IDX_MAX_SIZE;
 	ppmax = (1 << (bits - 1)) - 1;
 
-	ddp = cxgb3i_alloc_big_mem(sizeof(struct cxgb3i_ddp_info) +
-				   ppmax *
-					(sizeof(struct cxgb3i_gather_list *) +
-					sizeof(struct sk_buff *)),
-				   GFP_KERNEL);
+	ddp = kvzalloc(sizeof(struct cxgb3i_ddp_info) + ppmax *
+		       (sizeof(struct cxgb3i_gather_list *) +
+			sizeof(struct sk_buff *)));
 	if (!ddp) {
 		ddp_log_warn("%s unable to alloc ddp 0x%d, ddp disabled.\n",
 			     tdev->name, ppmax);
@@ -743,7 +741,7 @@ static void ddp_init(struct t3cdev *tdev)
 	return;
 
 free_ddp_map:
-	cxgb3i_free_big_mem(ddp);
+	kvfree(ddp);
 }
 
 /**
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
index 6761b32..1be8c20 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -13,9 +13,6 @@
 #ifndef __CXGB3I_ULP2_DDP_H__
 #define __CXGB3I_ULP2_DDP_H__
 
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-
 /**
  * struct cxgb3i_tag_format - cxgb3i ulp tag format for an iscsi entity
  *
@@ -143,29 +140,6 @@ struct pagepod {
 #define V_PPOD_PGSZ(x) ((x) << S_PPOD_PGSZ)
 
 /*
- * large memory chunk allocation/release
- * use vmalloc() if kmalloc() fails
- */
-static inline void *cxgb3i_alloc_big_mem(unsigned int size,
-					 gfp_t gfp)
-{
-	void *p = kmalloc(size, gfp);
-	if (!p)
-		p = vmalloc(size);
-	if (p)
-		memset(p, 0, size);
-	return p;
-}
-
-static inline void cxgb3i_free_big_mem(void *addr)
-{
-	if (is_vmalloc_addr(addr))
-		vfree(addr);
-	else
-		kfree(addr);
-}
-
-/*
  * cxgb3i ddp tag are 32 bits, it consists of reserved bits used by h/w and
  * non-reserved bits that can be used by the iscsi s/w.
  * The reserved bits are identified by the rsvd_bits and rsvd_shift fields
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index a175be9..720d199 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1841,7 +1841,7 @@ static void sdev_data_cleanup(struct cxgb3i_sdev_data *cdata)
 	for (i = 0; i < ports->nports; i++)
 		NDEV2CDATA(ports->lldevs[i]) = NULL;
 
-	cxgb3i_free_big_mem(cdata);
+	kvfree(cdata);
 }
 
 void cxgb3i_sdev_cleanup(void)
@@ -1885,7 +1885,7 @@ void cxgb3i_sdev_add(struct t3cdev *cdev, struct cxgb3_client *client)
 	int mapsize = cxgb3_max_connect * sizeof(struct s3_conn *);
 	int i;
 
-	cdata =  cxgb3i_alloc_big_mem(sizeof(*cdata) + mapsize, GFP_KERNEL);
+	cdata = kvzalloc(sizeof(*cdata) + mapsize);
 	if (!cdata) {
 		cxgb3i_log_warn("t3dev 0x%p, offload up, OOM %d.\n",
 				cdev, mapsize);
@@ -1918,7 +1918,7 @@ void cxgb3i_sdev_add(struct t3cdev *cdev, struct cxgb3_client *client)
 	return;
 
 free_cdata:
-	cxgb3i_free_big_mem(cdata);
+	kvfree(cdata);
 }
 
 /**
