From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/2] libsas: Fix various sparse complaints
Date: Mon, 5 Nov 2007 11:52:14 -0800
Message-ID: <20071105195214.GC7010@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:53873 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbXKETw2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 14:52:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Annotate sas_queuecommand with locking details, and clean up a few
more sparse warnings about static/non-static declarations.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |    6 +++++-
 include/scsi/libsas.h               |    4 +---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 0fa0296..c29ba47 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -202,6 +202,10 @@ int sas_queue_up(struct sas_task *task)
  */
 int sas_queuecommand(struct scsi_cmnd *cmd,
 		     void (*scsi_done)(struct scsi_cmnd *))
+	__releases(host->host_lock)
+	__acquires(dev->sata_dev.ap->lock)
+	__releases(dev->sata_dev.ap->lock)
+	__acquires(host->host_lock)
 {
 	int res = 0;
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
@@ -412,7 +416,7 @@ static int sas_recover_I_T(struct domain_device *dev)
 }
 
 /* Find the sas_phy that's attached to this device */
-struct sas_phy *find_local_sas_phy(struct domain_device *dev)
+static struct sas_phy *find_local_sas_phy(struct domain_device *dev)
 {
 	struct domain_device *pdev = dev->parent;
 	struct ex_phy *exphy = NULL;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index fe24bbc..cd11fe2 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -563,7 +563,7 @@ struct sas_task {
 	struct work_struct abort_work;
 };
 
-
+extern struct kmem_cache *sas_task_cache;
 
 #define SAS_TASK_STATE_PENDING      1
 #define SAS_TASK_STATE_DONE         2
@@ -573,7 +573,6 @@ struct sas_task {
 
 static inline struct sas_task *sas_alloc_task(gfp_t flags)
 {
-	extern struct kmem_cache *sas_task_cache;
 	struct sas_task *task = kmem_cache_zalloc(sas_task_cache, flags);
 
 	if (task) {
@@ -590,7 +589,6 @@ static inline struct sas_task *sas_alloc_task(gfp_t flags)
 static inline void sas_free_task(struct sas_task *task)
 {
 	if (task) {
-		extern struct kmem_cache *sas_task_cache;
 		BUG_ON(!list_empty(&task->list));
 		kmem_cache_free(sas_task_cache, task);
 	}
