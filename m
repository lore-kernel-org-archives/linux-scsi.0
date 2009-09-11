From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/35] libfc: changes to libfc_host_alloc to consolidate
	initialization with allocation
Date: Fri, 11 Sep 2009 16:57:48 -0700
Message-ID: <20090911235748.27223.25828.stgit@localhost.localdomain>
References: <20090911235655.27223.69728.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36661 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172AbZIKX5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:57:45 -0400
In-Reply-To: <20090911235655.27223.69728.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

I'd like to keep basic initialization together with allocation, which means
this can't just be a tail-call to scsi_host_alloc.

This is needed to create a generic libfc host allocation routine for NPIV
VN_Ports, which will share the exchange ID space (through sharing exchange
manager structures) with the parent lport.  In order to clone the exchange
manager list when the lport is allocated, the list head must be initialized
earlier.

Also, update fnic to use the libfc_host_alloc so that later changes do not break
it. (contribution by Joe Eykholt)

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c      |    8 +++-----
 drivers/scsi/fnic/fnic_main.c |   10 ++++------
 drivers/scsi/libfc/fc_lport.c |    1 -
 include/scsi/libfc.h          |   15 ++++++++++++---
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 6926ed7..a0e27e3 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -493,8 +493,6 @@ static int fcoe_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
 	int rc = 0;
 
 	/* lport scsi host config */
-	lp->host = shost;
-
 	lp->host->max_lun = FCOE_MAX_LUN;
 	lp->host->max_id = FCOE_MAX_FCP_TARGET;
 	lp->host->max_channel = 0;
@@ -712,14 +710,14 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 
 	FCOE_NETDEV_DBG(netdev, "Create Interface\n");
 
-	shost = libfc_host_alloc(&fcoe_shost_template,
+	lport = libfc_host_alloc(&fcoe_shost_template,
 				 sizeof(struct fcoe_port));
-	if (!shost) {
+	if (!lport) {
 		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
 		rc = -ENOMEM;
 		goto out;
 	}
-	lport = shost_priv(shost);
+	shost = lport->host;
 	port = lport_priv(lport);
 	port->lport = lport;
 	port->fcoe = fcoe;
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 71c7bbe..bfc341c 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -424,15 +424,13 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	 * Allocate SCSI Host and set up association between host,
 	 * local port, and fnic
 	 */
-	host = scsi_host_alloc(&fnic_host_template,
-			       sizeof(struct fc_lport) + sizeof(struct fnic));
-	if (!host) {
-		printk(KERN_ERR PFX "Unable to alloc SCSI host\n");
+	lp = libfc_host_alloc(&fnic_host_template, sizeof(struct fnic));
+	if (!lp) {
+		printk(KERN_ERR PFX "Unable to alloc libfc local port\n");
 		err = -ENOMEM;
 		goto err_out;
 	}
-	lp = shost_priv(host);
-	lp->host = host;
+	host = lp->host;
 	fnic = lport_priv(lp);
 	fnic->lport = lp;
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 646dee1..c5f50e2 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1502,7 +1502,6 @@ int fc_lport_init(struct fc_lport *lport)
 	if (lport->link_supported_speeds & FC_PORTSPEED_10GBIT)
 		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_10GBIT;
 
-	INIT_LIST_HEAD(&lport->ema_list);
 	return 0;
 }
 EXPORT_SYMBOL(fc_lport_init);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 81901fa..ab12671 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -739,12 +739,21 @@ static inline void *lport_priv(const struct fc_lport *lp)
  * @sht: ptr to the scsi host templ
  * @priv_size: size of private data after fc_lport
  *
- * Returns: ptr to Scsi_Host
+ * Returns: libfc lport
  */
-static inline struct Scsi_Host *
+static inline struct fc_lport *
 libfc_host_alloc(struct scsi_host_template *sht, int priv_size)
 {
-	return scsi_host_alloc(sht, sizeof(struct fc_lport) + priv_size);
+	struct fc_lport *lport;
+	struct Scsi_Host *shost;
+
+	shost = scsi_host_alloc(sht, sizeof(*lport) + priv_size);
+	if (!shost)
+		return NULL;
+	lport = shost_priv(shost);
+	lport->host = shost;
+	INIT_LIST_HEAD(&lport->ema_list);
+	return lport;
 }
 
 /*

