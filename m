From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/8] fcoe,
	libfc: initialize EM anchors list and then update npiv EMs
Date: Fri, 25 Feb 2011 15:03:01 -0800
Message-ID: <20110225230301.9310.96934.stgit@localhost6.localdomain6>
References: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab1BYXDF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 18:03:05 -0500
In-Reply-To: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

EM anchors list initialization for only master port was not enough to
keep npiv working as described here:-
https://lists.open-fcoe.org/pipermail/devel/2011-January/011063.html

So this patch moves fc_exch_mgr_list_clone to update npiv ports
EMs once EM anchors list initialized.

Also some cleanup, no need to set lport = NULL as that always
get initialized later.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c      |   50 +++++++++++++++++++++--------------------
 drivers/scsi/libfc/fc_exch.c  |    1 +
 drivers/scsi/libfc/fc_lport.c |    1 +
 drivers/scsi/libfc/fc_npiv.c  |    9 +------
 4 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 495456f..0b5fbb8 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -928,8 +928,9 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 				       struct device *parent, int npiv)
 {
 	struct net_device *netdev = fcoe->netdev;
-	struct fc_lport *lport = NULL;
+	struct fc_lport *lport, *n_port;
 	struct fcoe_port *port;
+	struct Scsi_Host *shost;
 	int rc;
 	/*
 	 * parent is only a vport if npiv is 1,
@@ -939,13 +940,11 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 
 	FCOE_NETDEV_DBG(netdev, "Create Interface\n");
 
-	if (!npiv) {
-		lport = libfc_host_alloc(&fcoe_shost_template,
-					 sizeof(struct fcoe_port));
-	} else	{
-		lport = libfc_vport_create(vport,
-					   sizeof(struct fcoe_port));
-	}
+	if (!npiv)
+		lport = libfc_host_alloc(&fcoe_shost_template, sizeof(*port));
+	else
+		lport = libfc_vport_create(vport, sizeof(*port));
+
 	if (!lport) {
 		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
 		rc = -ENOMEM;
@@ -998,24 +997,27 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 		goto out_lp_destroy;
 	}
 
-	if (!npiv) {
-		/*
-		 * fcoe_em_alloc() and fcoe_hostlist_add() both
-		 * need to be atomic with respect to other changes to the
-		 * hostlist since fcoe_em_alloc() looks for an existing EM
-		 * instance on host list updated by fcoe_hostlist_add().
-		 *
-		 * This is currently handled through the fcoe_config_mutex
-		 * begin held.
-		 */
-
+	/*
+	 * fcoe_em_alloc() and fcoe_hostlist_add() both
+	 * need to be atomic with respect to other changes to the
+	 * hostlist since fcoe_em_alloc() looks for an existing EM
+	 * instance on host list updated by fcoe_hostlist_add().
+	 *
+	 * This is currently handled through the fcoe_config_mutex
+	 * begin held.
+	 */
+	if (!npiv)
 		/* lport exch manager allocation */
 		rc = fcoe_em_config(lport);
-		if (rc) {
-			FCOE_NETDEV_DBG(netdev, "Could not configure the EM "
-					"for the interface\n");
-			goto out_lp_destroy;
-		}
+	else {
+		shost = vport_to_shost(vport);
+		n_port = shost_priv(shost);
+		rc = fc_exch_mgr_list_clone(n_port, lport);
+	}
+
+	if (rc) {
+		FCOE_NETDEV_DBG(netdev, "Could not configure the EM\n");
+		goto out_lp_destroy;
 	}
 
 	fcoe_interface_get(fcoe);
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 10a5436..28231ba 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2175,6 +2175,7 @@ err:
 		fc_exch_mgr_del(ema);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL(fc_exch_mgr_list_clone);
 
 /**
  * fc_exch_mgr_alloc() - Allocate an exchange manager
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 735f1f8..8c08b21 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1590,6 +1590,7 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
  */
 int fc_lport_config(struct fc_lport *lport)
 {
+	INIT_LIST_HEAD(&lport->ema_list);
 	INIT_DELAYED_WORK(&lport->retry_work, fc_lport_timeout);
 	mutex_init(&lport->lp_mutex);
 
diff --git a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_npiv.c
index 076cd5f..f33b897 100644
--- a/drivers/scsi/libfc/fc_npiv.c
+++ b/drivers/scsi/libfc/fc_npiv.c
@@ -37,9 +37,7 @@ struct fc_lport *libfc_vport_create(struct fc_vport *vport, int privsize)
 
 	vn_port = libfc_host_alloc(shost->hostt, privsize);
 	if (!vn_port)
-		goto err_out;
-	if (fc_exch_mgr_list_clone(n_port, vn_port))
-		goto err_put;
+		return vn_port;
 
 	vn_port->vport = vport;
 	vport->dd_data = vn_port;
@@ -49,11 +47,6 @@ struct fc_lport *libfc_vport_create(struct fc_vport *vport, int privsize)
 	mutex_unlock(&n_port->lp_mutex);
 
 	return vn_port;
-
-err_put:
-	scsi_host_put(vn_port->host);
-err_out:
-	return NULL;
 }
 EXPORT_SYMBOL(libfc_vport_create);
 

