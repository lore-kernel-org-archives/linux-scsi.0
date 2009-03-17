From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/14] fcoe, libfc: fix double fcoe_softc memory alloc
Date: Tue, 17 Mar 2009 11:42:29 -0700
Message-ID: <20090317184229.22987.26325.stgit@fritz>
References: <20090317184124.22987.65368.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8698 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760428AbZCQSmb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 14:42:31 -0400
In-Reply-To: <20090317184124.22987.65368.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

The foce_softc mem was reserved by libfc_host_alloc as well as
by fcoe_host_alloc.

Removes one liner fcoe_host_alloc completely, instead directly calls
libfc_host_alloc to alloc scsi_host with libfc for just one fcoe_softc
as fcoe private data.

Moves libfc_host_alloc to libfc.h since it is a libfc API, placed
lport_priv API adjacent to libfc_host_alloc since this is related
to scsi_host priv data.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   33 ++-------------------------------
 include/scsi/libfc.h     |   22 +++++++++++++++++-----
 2 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c76ff5d..ef60144 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -70,8 +70,6 @@ static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
 static int fcoe_hostlist_add(const struct fc_lport *);
 static int fcoe_hostlist_remove(const struct fc_lport *);
 
-static struct Scsi_Host *fcoe_host_alloc(struct scsi_host_template *, int);
-
 static int fcoe_check_wait_queue(struct fc_lport *);
 static void fcoe_recv_flogi(struct fcoe_softc *, struct fc_frame *, u8 *);
 static int fcoe_device_notification(struct notifier_block *, ulong, void *);
@@ -464,8 +462,8 @@ static int fcoe_if_create(struct net_device *netdev)
 	if (lp)
 		return -EEXIST;
 
-	shost = fcoe_host_alloc(&fcoe_shost_template,
-				sizeof(struct fcoe_softc));
+	shost = libfc_host_alloc(&fcoe_shost_template,
+				 sizeof(struct fcoe_softc));
 	if (!shost) {
 		FC_DBG("Could not allocate host structure\n");
 		return -ENOMEM;
@@ -1706,33 +1704,6 @@ void fcoe_clean_pending_queue(struct fc_lport *lp)
 EXPORT_SYMBOL_GPL(fcoe_clean_pending_queue);
 
 /**
- * libfc_host_alloc() - Allocate a Scsi_Host with room for the fc_lport
- * @sht: ptr to the scsi host templ
- * @priv_size: size of private data after fc_lport
- *
- * Returns: ptr to Scsi_Host
- * TODO: to libfc?
- */
-static inline struct Scsi_Host *
-libfc_host_alloc(struct scsi_host_template *sht, int priv_size)
-{
-	return scsi_host_alloc(sht, sizeof(struct fc_lport) + priv_size);
-}
-
-/**
- * fcoe_host_alloc() - Allocate a Scsi_Host with room for the fcoe_softc
- * @sht: ptr to the scsi host templ
- * @priv_size: size of private data after fc_lport
- *
- * Returns: ptr to Scsi_Host
- */
-struct Scsi_Host *fcoe_host_alloc(struct scsi_host_template *sht, int priv_size)
-{
-	return libfc_host_alloc(sht, sizeof(struct fcoe_softc) + priv_size);
-}
-EXPORT_SYMBOL_GPL(fcoe_host_alloc);
-
-/**
  * fcoe_reset() - Resets the fcoe
  * @shost: shost the reset is from
  *
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 4e1d394..0303a6a 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -696,11 +696,6 @@ struct fc_lport {
 /*
  * FC_LPORT HELPER FUNCTIONS
  *****************************/
-static inline void *lport_priv(const struct fc_lport *lp)
-{
-	return (void *)(lp + 1);
-}
-
 static inline int fc_lport_test_ready(struct fc_lport *lp)
 {
 	return lp->state == LPORT_ST_READY;
@@ -743,6 +738,23 @@ static inline struct fcoe_dev_stats *fc_lport_get_stats(struct fc_lport *lp)
 	return per_cpu_ptr(lp->dev_stats, smp_processor_id());
 }
 
+static inline void *lport_priv(const struct fc_lport *lp)
+{
+	return (void *)(lp + 1);
+}
+
+/**
+ * libfc_host_alloc() - Allocate a Scsi_Host with room for the fc_lport
+ * @sht: ptr to the scsi host templ
+ * @priv_size: size of private data after fc_lport
+ *
+ * Returns: ptr to Scsi_Host
+ */
+static inline struct Scsi_Host *
+libfc_host_alloc(struct scsi_host_template *sht, int priv_size)
+{
+	return scsi_host_alloc(sht, sizeof(struct fc_lport) + priv_size);
+}
 
 /*
  * LOCAL PORT LAYER

