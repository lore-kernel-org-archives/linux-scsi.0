From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 1/6] cxlflash: Avoid mutex when destroying context
Date: Tue,  9 Aug 2016 18:39:18 -0500
Message-ID: <1470785958-9152-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63826 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932551AbcHIXjf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 19:39:35 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u79Ncxsa063801
	for <linux-scsi@vger.kernel.org>; Tue, 9 Aug 2016 19:39:35 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
	by mx0b-001b2d01.pphosted.com with ESMTP id 24qm9r22rn-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2016 19:39:34 -0400
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 9 Aug 2016 17:39:33 -0600
In-Reply-To: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Context information structures are protected by a mutex that is held
when accessing/manipulating the context. When the code that manages
these structures was authored, a decision was made to include taking
the mutex as part of the allocation/initialization sequence and also
handle the scenario where the mutex was already held when freeing the
context.

While not a problem outright, this design decision has been deemed as
too flexible and the code should be made more rigid to avoid future bugs.
In addition, further review of the code yields that the existing mutex
manipulations in both of these context management paths are superfluous.

This commit removes the obtaining of the context mutex in the context
initialization routine and assumes the mutex is not held in the context
free path.

Inspired-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index ce15070..ab5c893 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -709,14 +709,13 @@ int cxlflash_disk_release(struct scsi_device *sdev,
  * @cfg:	Internal structure associated with the host.
  * @ctxi:	Context to release.
  *
- * This routine is safe to be called with a a non-initialized context
- * and is tolerant of being called with the context's mutex held (it
- * will be unlocked if necessary before freeing). Also note that the
- * routine conditionally checks for the existence of the context control
- * map before clearing the RHT registers and context capabilities because
- * it is possible to destroy a context while the context is in the error
- * state (previous mapping was removed [so there is no need to worry about
- * clearing] and context is waiting for a new mapping).
+ * This routine is safe to be called with a a non-initialized context.
+ * Also note that the routine conditionally checks for the existence
+ * of the context control map before clearing the RHT registers and
+ * context capabilities because it is possible to destroy a context
+ * while the context is in the error state (previous mapping was
+ * removed [so there is no need to worry about clearing] and context
+ * is waiting for a new mapping).
  */
 static void destroy_context(struct cxlflash_cfg *cfg,
 			    struct ctx_info *ctxi)
@@ -732,9 +731,6 @@ static void destroy_context(struct cxlflash_cfg *cfg,
 			writeq_be(0, &ctxi->ctrl_map->rht_cnt_id);
 			writeq_be(0, &ctxi->ctrl_map->ctx_cap);
 		}
-
-		if (mutex_is_locked(&ctxi->mutex))
-			mutex_unlock(&ctxi->mutex);
 	}
 
 	/* Free memory associated with context */
@@ -795,9 +791,6 @@ err:
  * @adap_fd:	Previously obtained adapter fd associated with CXL context.
  * @file:	Previously obtained file associated with CXL context.
  * @perms:	User-specified permissions.
- *
- * Upon return, the context is marked as initialized and the context's mutex
- * is locked.
  */
 static void init_context(struct ctx_info *ctxi, struct cxlflash_cfg *cfg,
 			 struct cxl_context *ctx, int ctxid, int adap_fd,
@@ -816,8 +809,6 @@ static void init_context(struct ctx_info *ctxi, struct cxlflash_cfg *cfg,
 	mutex_init(&ctxi->mutex);
 	INIT_LIST_HEAD(&ctxi->luns);
 	INIT_LIST_HEAD(&ctxi->list); /* initialize for list_empty() */
-
-	mutex_lock(&ctxi->mutex);
 }
 
 /**
@@ -1445,7 +1436,6 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	 * knows about us yet; we can be the only one holding our mutex.
 	 */
 	list_add(&lun_access->list, &ctxi->luns);
-	mutex_unlock(&ctxi->mutex);
 	mutex_lock(&cfg->ctx_tbl_list_mutex);
 	mutex_lock(&ctxi->mutex);
 	cfg->ctx_tbl[ctxid] = ctxi;
@@ -1494,7 +1484,7 @@ err:
 		file = NULL;
 	}
 
-	/* Cleanup our context; safe to call even with mutex locked */
+	/* Cleanup our context */
 	if (ctxi) {
 		destroy_context(cfg, ctxi);
 		ctxi = NULL;
-- 
2.1.0

