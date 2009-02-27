From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/24] libfc, fcoe: Cleanup function formatting and minor typos
Date: Fri, 27 Feb 2009 10:55:50 -0800
Message-ID: <20090227185550.25509.35783.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55205 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569AbZB0Szw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:55:52 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

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
index 0eea4c4..847453a 100644
--- a/drivers/scsi/fcoe/fc_transport_fcoe.c
+++ b/drivers/scsi/fcoe/fc_transport_fcoe.c
@@ -62,8 +62,9 @@ struct pci_dev *fcoe_transport_pcidev(const struct net_device *netdev)
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
 
@@ -184,7 +185,7 @@ static void fcoe_transport_device_remove_all(struct fcoe_transport *t)
  * Returns: true for match up
  */
 static bool fcoe_transport_match(struct fcoe_transport *t,
-				struct net_device *netdev)
+				 struct net_device *netdev)
 {
 	/* match transport by vendor and device id */
 	struct pci_dev *pci;
@@ -217,8 +218,8 @@ static bool fcoe_transport_match(struct fcoe_transport *t,
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
index 5e68652..d006d65 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -949,8 +949,8 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
  *
  * Returns: ptr to the struct module, NULL for failure
  */
-static struct module *fcoe_netdev_to_module_owner(
-	const struct net_device *netdev)
+static struct module *
+fcoe_netdev_to_module_owner(const struct net_device *netdev)
 {
 	struct device *dev;
 
@@ -1205,8 +1205,8 @@ EXPORT_SYMBOL_GPL(fcoe_clean_pending_queue);
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
@@ -1285,8 +1285,8 @@ EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
  *
  * Returns: NULL or the located fcoe_softc
  */
-static struct fcoe_softc *fcoe_hostlist_lookup_softc(
-	const struct net_device *dev)
+static struct fcoe_softc *
+fcoe_hostlist_lookup_softc(const struct net_device *dev)
 {
 	struct fcoe_softc *fc;
 
@@ -1426,7 +1426,6 @@ static int __init fcoe_init(void)
 			} else {
 				fcoe_percpu[cpu] = NULL;
 				kfree(p);
-
 			}
 		}
 	}
@@ -1476,7 +1475,7 @@ static void __exit fcoe_exit(void)
 	 */
 	del_timer_sync(&fcoe_timer);
 
-	/* releases the assocaited fcoe transport for each lport */
+	/* releases the associated fcoe transport for each lport */
 	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
 		fcoe_transport_release(fc->real_dev);
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 8c40189..7b93395 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -675,8 +675,8 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
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
@@ -994,9 +994,9 @@ static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
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
index 6f07de1..dae6513 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -179,8 +179,8 @@ EXPORT_SYMBOL(fc_set_rport_loss_tmo);
  * @flp: FLOGI payload structure
  * @maxval: upper limit, may be less than what is in the service parameters
  */
-static unsigned int
-fc_plogi_get_maxframe(struct fc_els_flogi *flp, unsigned int maxval)
+static unsigned int fc_plogi_get_maxframe(struct fc_els_flogi *flp,
+					  unsigned int maxval)
 {
 	unsigned int mfs;
 

