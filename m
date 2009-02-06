From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/17] libfc, fcoe: Cleanup function formatting and minor typos
Date: Fri, 06 Feb 2009 10:56:59 -0800
Message-ID: <20090206185658.26188.86332.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14023 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZBFS47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:59 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

1) There were a few functions with a strange layout, i.e. all
   arguments on the second line, when not necessary.

   Where ever possible I moved the return value to the same line
   as the function name. However, when the line was too long
   to have a single argument on the same line I moved the
   return value to above line. For example:

   <short return> <function name>(<arg 1>, <arg2>)

   and

   <very long return value>
   <function name>(<arg1>,
		   <arg2>)

2) Removed one extra whitespace line

3) Fixed two typos

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fc_transport_fcoe.c |   11 ++++++-----
 drivers/scsi/fcoe/libfcoe.c           |   15 +++++++--------
 drivers/scsi/libfc/fc_exch.c          |   10 +++++-----
 drivers/scsi/libfc/fc_rport.c         |    4 ++--
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/fcoe/fc_transport_fcoe.c b/drivers/scsi/fcoe/fc_transport_fcoe.c
index f48c0b0..c9f75b4 100644
--- a/drivers/scsi/fcoe/fc_transport_fcoe.c
+++ b/drivers/scsi/fcoe/fc_transport_fcoe.c
@@ -64,8 +64,9 @@ struct pci_dev *fcoe_transport_pcidev(const struct net_device *netdev)
  *
  * Returns: 0 for success
  */
-static struct fcoe_transport_internal *fcoe_transport_device_lookup(
-	struct fcoe_transport *t, struct net_device *netdev)
+static struct fcoe_transport_internal *
+fcoe_transport_device_lookup(struct fcoe_transport *t,
+			     struct net_device *netdev)
 {
 	struct fcoe_transport_internal *ti;
 
@@ -182,7 +183,7 @@ static void fcoe_transport_device_remove_all(struct fcoe_transport *t)
  * Returns: true for match up
  */
 static bool fcoe_transport_match(struct fcoe_transport *t,
-				struct net_device *netdev)
+				 struct net_device *netdev)
 {
 	/* match transport by vendor and device id */
 	struct pci_dev *pci;
@@ -214,8 +215,8 @@ static bool fcoe_transport_match(struct fcoe_transport *t,
  *
  * TODO: return default sw transport if no other transport is found
  */
-static struct fcoe_transport *fcoe_transport_lookup(
-	struct net_device *netdev)
+static struct fcoe_transport *
+fcoe_transport_lookup(struct net_device *netdev)
 {
 	struct fcoe_transport *t;
 
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 60677a8..e76e4f6 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -951,8 +951,8 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
  *
  * Returns: ptr to the struct module, NULL for failure
  */
-static struct module *fcoe_netdev_to_module_owner(
-	const struct net_device *netdev)
+static struct module *
+fcoe_netdev_to_module_owner(const struct net_device *netdev)
 {
 	struct device *dev;
 
@@ -1207,8 +1207,8 @@ EXPORT_SYMBOL_GPL(fcoe_clean_pending_queue);
  * Returns: ptr to Scsi_Host
  * TODO: to libfc?
  */
-static inline struct Scsi_Host *libfc_host_alloc(
-	struct scsi_host_template *sht, int priv_size)
+static inline struct Scsi_Host *
+libfc_host_alloc(struct scsi_host_template *sht, int priv_size)
 {
 	return scsi_host_alloc(sht, sizeof(struct fc_lport) + priv_size);
 }
@@ -1287,8 +1287,8 @@ EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
  *
  * Returns: NULL or the located fcoe_softc
  */
-static struct fcoe_softc *fcoe_hostlist_lookup_softc(
-	const struct net_device *dev)
+static struct fcoe_softc *
+fcoe_hostlist_lookup_softc(const struct net_device *dev)
 {
 	struct fcoe_softc *fc;
 
@@ -1428,7 +1428,6 @@ static int __init fcoe_init(void)
 			} else {
 				fcoe_percpu[cpu] = NULL;
 				kfree(p);
-
 			}
 		}
 	}
@@ -1478,7 +1477,7 @@ static void __exit fcoe_exit(void)
 	 */
 	del_timer_sync(&fcoe_timer);
 
-	/* releases the assocaited fcoe transport for each lport */
+	/* releases the associated fcoe transport for each lport */
 	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
 		fcoe_transport_release(fc->real_dev);
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index b0d3ec7..4026959 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -664,8 +664,8 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
  * If fc_pf_rjt_reason is FC_RJT_NONE then this function will have a hold
  * on the ep that should be released by the caller.
  */
-static enum fc_pf_rjt_reason
-fc_seq_lookup_recip(struct fc_exch_mgr *mp, struct fc_frame *fp)
+static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_exch_mgr *mp,
+						 struct fc_frame *fp)
 {
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 	struct fc_exch *ep = NULL;
@@ -983,9 +983,9 @@ static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
  * Send BLS Reject.
  * This is for rejecting BA_ABTS only.
  */
-static void
-fc_exch_send_ba_rjt(struct fc_frame *rx_fp, enum fc_ba_rjt_reason reason,
-		    enum fc_ba_rjt_explan explan)
+static void fc_exch_send_ba_rjt(struct fc_frame *rx_fp,
+				enum fc_ba_rjt_reason reason,
+				enum fc_ba_rjt_explan explan)
 {
 	struct fc_frame *fp;
 	struct fc_frame_header *rx_fh;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index b008f49..a6d3406 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -171,8 +171,8 @@ EXPORT_SYMBOL(fc_set_rport_loss_tmo);
  * @flp: FLOGI payload structure
  * @maxval: upper limit, may be less than what is in the service parameters
  */
-static unsigned int
-fc_plogi_get_maxframe(struct fc_els_flogi *flp, unsigned int maxval)
+static unsigned int fc_plogi_get_maxframe(struct fc_els_flogi *flp,
+					  unsigned int maxval)
 {
 	unsigned int mfs;
 

