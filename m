From: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Subject: [PATCH 04/13] fcoe: fix fcoe_create_interface goto paths
Date: Sun, 29 Jun 2008 13:23:54 -0500
Message-ID: <1214763843-5548-5-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-4-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1214763843-5548-4-git-send-email-michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

1. If fc_scsi_init fails no one noticed.
2. fcoe_find_fc_lport was called before real_dev was set
so were hitting a null ptr.
3. On the cleanup paths, fc_put_dev does a put on the host so there
was not need to do it again in the out_host_put. fc_lport_destroy removed
the host so no need to do it in out_host_rem.

And fc_put_dev does the host put was sort of wierd because the driver
called host alloc, so this moves that call the driver (maybe this
should be done for the host remove call too).

Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
---
 drivers/scsi/fcoe/fcoe_if.c  |   70 ++++++++++++++++++++++++------------------
 drivers/scsi/libfc/fc_exch.c |    1 +
 drivers/scsi/libfc/fc_scsi.c |    1 -
 3 files changed, 41 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_if.c b/drivers/scsi/fcoe/fcoe_if.c
index 24efe01..1f32743 100644
--- a/drivers/scsi/fcoe/fcoe_if.c
+++ b/drivers/scsi/fcoe/fcoe_if.c
@@ -375,6 +375,7 @@ int fcoe_destroy_interface(const char *ifname)
 	}
 
 	fcoe_put_dev(lp);
+	scsi_host_put(lp->host);
 	return 0;
 }
 
@@ -446,13 +447,26 @@ int fcoe_create_interface(const char *ifname)
 	u8 flogi_maddr[ETH_ALEN];
 #endif
 
+	net_dev = (void *)dev_get_by_name(&init_net, ifname);
+	if (net_dev == NULL) {
+		FC_DBG("could not get network device for %s",
+		       ifname);
+		return -ENODEV;
+	}
+
+	if (fcoe_find_fc_lport(net_dev->name) != NULL) {
+		rc = -EEXIST;
+		goto out_put_dev;
+	}
+
 	host = scsi_host_alloc(&fcoe_driver_template,
 			       sizeof(struct fc_lport) +
 			       sizeof(struct fcoe_softc));
 
 	if (host == NULL) {
 		FC_DBG("openfc: Could not allocate host structure\n");
-		goto out;
+		rc = -ENOMEM;
+		goto out_put_dev;
 	}
 
 	host->transportt = fcoe_transport_template;
@@ -465,6 +479,7 @@ int fcoe_create_interface(const char *ifname)
 	fc = (struct fcoe_softc *)lp->drv_priv;
 	memset(fc, 0, sizeof(struct fcoe_softc));
 	fc->lp = lp;
+	fc->real_dev = net_dev;
 
 	/* Set the function pointers set by the LLDD */
 	memcpy(&lp->tt, &fcoe_libfc_transport_template, sizeof(struct fc_transport_template));
@@ -474,17 +489,16 @@ int fcoe_create_interface(const char *ifname)
 	host->max_id = FC_MAX_FCP_TARGET;
 	host->max_channel = 0;
 
-	/* Add the new host to the SCSI-ml */
-	rc = scsi_add_host(lp->host, NULL);
-	if (rc) {
-		FC_DBG("error on scsi_add_host\n");
-		goto out_host_put;
-	}
-
 	/* Allocate an EM for this driver */
 	lp->emp = fc_exch_mgr_alloc(FC_CLASS_3, 0, 0);
 	if (!lp->emp)
-		goto out_host_rem;
+		goto out_host_put;
+
+	/* Initialize the scsi block */
+	if (fc_scsi_init(lp, &fcoe_libfc_transport_template)) {
+		rc = -ENOMEM;
+		goto out_exch_free;
+	}
 
 	/* Configure the fc_lport for this host */
 	lp->state = FC_INITIALIZATION;
@@ -495,6 +509,13 @@ int fcoe_create_interface(const char *ifname)
 	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
 			      FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
 
+	/* Add the new host to the SCSI-ml */
+	rc = scsi_add_host(lp->host, NULL);
+	if (rc) {
+		FC_DBG("error on scsi_add_host\n");
+		goto out_scsi_free;
+	}
+
 	/* Initialize most of libfc */
 	fc_exch_init(lp, &fcoe_libfc_transport_template);
 	fc_lport_init(lp, &fcoe_libfc_transport_template);
@@ -505,9 +526,6 @@ int fcoe_create_interface(const char *ifname)
 	/* Finish fc_lport configuration */
 	fc_lport_config(lp);
 
-	/* Initialize the scsi block */
-	fc_scsi_init(lp, &fcoe_libfc_transport_template);
-
 	/* XXX - Can this be moved into fabric_login()? */
 	if (lp->link_status == TRANS_LINK_DOWN) {
 		lp->fl_logon_req = 0;
@@ -519,19 +537,6 @@ int fcoe_create_interface(const char *ifname)
 	lp->fc_boot_time = jiffies;
 	lp->state = FC_RUNNING;
 
-	if (fcoe_find_fc_lport(fc->real_dev->name) != NULL) {
-		rc = -EEXIST;
-		goto out;
-	}
-
-	fc->real_dev = (void *)dev_get_by_name(&init_net, ifname);
-	if (fc->real_dev == NULL) {
-		FC_DBG("could not get network device for %s",
-		       ifname);
-		rc = -ENODEV;
-		goto out;
-	}
-
 	/* Do not support for bonding device */
 	if ((fc->real_dev->priv_flags & IFF_MASTER_ALB) ||
 	    (fc->real_dev->priv_flags & IFF_SLAVE_INACTIVE) ||
@@ -634,15 +639,20 @@ int fcoe_create_interface(const char *ifname)
 
 	return rc;
 out:
-	fcoe_put_dev(lp);
 	fc_rport_destroy(lp);
 	fc_lport_destroy(lp);	/* also closes port */
-out_host_rem:
-	scsi_remove_host(lp->host);
-out_host_put:
+	fcoe_put_dev(lp);
 	scsi_host_put(lp->host);
-	WARN_ON(1);
+	return rc;
 
+out_scsi_free:
+	fc_put_dev(lp);
+out_exch_free:
+	fc_exch_mgr_free(lp->emp);
+out_host_put:
+	scsi_host_put(lp->host);
+out_put_dev:
+	dev_put(net_dev);
 	return rc;
 }
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 9333999..a663442 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1701,6 +1701,7 @@ void fc_exch_mgr_free(struct fc_exch_mgr *mp)
 	kmem_cache_destroy(mp->em_cp);
 	kfree(mp);
 }
+EXPORT_SYMBOL(fc_exch_mgr_free);
 
 struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp, fc_xid_t ex_id)
 {
diff --git a/drivers/scsi/libfc/fc_scsi.c b/drivers/scsi/libfc/fc_scsi.c
index b877daa..a438aa0 100644
--- a/drivers/scsi/libfc/fc_scsi.c
+++ b/drivers/scsi/libfc/fc_scsi.c
@@ -2248,7 +2248,6 @@ void fc_put_dev(struct fc_lport *lp)
 	fc_destroy_scsi_slab(lp);
 	kfree(fc_get_scsi_internal(lp));
 	lp->scsi_priv = NULL;
-	scsi_host_put(lp->host);
 }
 EXPORT_SYMBOL(fc_put_dev);
 
-- 
1.5.4.1
