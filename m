From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 19/21] libsas: phy port lock needs irq spinlocks
Date: Thu, 11 Jan 2007 14:15:40 -0800
Message-ID: <20070111221540.3543.85507.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35590 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbXAKWPX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:15:23 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMFMWY026533
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:22 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMFK0u284382
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:20 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMFKLq019187
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:20 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Convert the phy port locks to use irq spinlocks.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_port.c      |   12 +++++++-----
 drivers/scsi/libsas/sas_scsi_host.c |    5 +++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 971c37c..a796ae3 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -42,6 +42,7 @@ static void sas_form_port(struct asd_sas
 	struct asd_sas_port *port = phy->port;
 	struct sas_internal *si =
 		to_sas_internal(sas_ha->core.shost->transportt);
+	unsigned long flags;
 
 	if (port) {
 		if (memcmp(port->attached_sas_addr, phy->attached_sas_addr,
@@ -56,7 +57,7 @@ static void sas_form_port(struct asd_sas
 	}
 
 	/* find a port */
-	spin_lock(&sas_ha->phy_port_lock);
+	spin_lock_irqsave(&sas_ha->phy_port_lock, flags);
 	for (i = 0; i < sas_ha->num_phys; i++) {
 		port = sas_ha->sas_port[i];
 		spin_lock(&port->phy_list_lock);
@@ -78,7 +79,7 @@ static void sas_form_port(struct asd_sas
 	if (i >= sas_ha->num_phys) {
 		printk(KERN_NOTICE "%s: couldn't find a free port, bug?\n",
 		       __FUNCTION__);
-		spin_unlock(&sas_ha->phy_port_lock);
+		spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 		return;
 	}
 
@@ -105,7 +106,7 @@ static void sas_form_port(struct asd_sas
 	} else
 		port->linkrate = max(port->linkrate, phy->linkrate);
 	spin_unlock(&port->phy_list_lock);
-	spin_unlock(&sas_ha->phy_port_lock);
+	spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 
 	if (!port->port) {
 		port->port = sas_port_alloc(phy->phy->dev.parent, port->id);
@@ -137,6 +138,7 @@ void sas_deform_port(struct asd_sas_phy 
 	struct asd_sas_port *port = phy->port;
 	struct sas_internal *si =
 		to_sas_internal(sas_ha->core.shost->transportt);
+	unsigned long flags;
 
 	if (!port)
 		return;		  /* done by a phy event */
@@ -155,7 +157,7 @@ void sas_deform_port(struct asd_sas_phy 
 	if (si->dft->lldd_port_deformed)
 		si->dft->lldd_port_deformed(phy);
 
-	spin_lock(&sas_ha->phy_port_lock);
+	spin_lock_irqsave(&sas_ha->phy_port_lock, flags);
 	spin_lock(&port->phy_list_lock);
 
 	list_del_init(&phy->port_phy_el);
@@ -174,7 +176,7 @@ void sas_deform_port(struct asd_sas_phy 
 		port->phy_mask = 0;
 	}
 	spin_unlock(&port->phy_list_lock);
-	spin_unlock(&sas_ha->phy_port_lock);
+	spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 
 	return;
 }
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f867455..8a1b98e 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -589,8 +589,9 @@ struct domain_device *sas_find_dev_by_rp
 	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
 	struct domain_device *found_dev = NULL;
 	int i;
+	unsigned long flags;
 
-	spin_lock(&ha->phy_port_lock);
+	spin_lock_irqsave(&ha->phy_port_lock, flags);
 	for (i = 0; i < ha->num_phys; i++) {
 		struct asd_sas_port *port = ha->sas_port[i];
 		struct domain_device *dev;
@@ -606,7 +607,7 @@ struct domain_device *sas_find_dev_by_rp
 		spin_unlock(&port->dev_list_lock);
 	}
  found:
-	spin_unlock(&ha->phy_port_lock);
+	spin_unlock_irqrestore(&ha->phy_port_lock, flags);
 
 	return found_dev;
 }
