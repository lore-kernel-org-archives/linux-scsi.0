From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/5] libsas: use the supplied address for SATA devices
	rather than changing it
Date: Sat, 23 Feb 2008 23:38:44 -0600
Message-ID: <1203831524.3139.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59730 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbYBXFis (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 00:38:48 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 046F0871C
	for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:38:46 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UfW5Vfuu1xn4 for <linux-scsi@vger.kernel.org>;
	Sat, 23 Feb 2008 23:38:46 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 42D918112
	for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:38:45 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Once the phy reset is plumbed in properly, SATA error handling fails
nastily because we change the port attached_sas_address using the WWN
field of the IDENTIFY message.  This is a nice thing to do in theory,
but it really destroys hotplug because any event on the port causes an
automatic mismatch between the sas_address the phy just picked up and
the one we propagate into the port.  However ugly they are, we have to
stick with the sas addresses made up by the phys and expanders.

Also does a few cosmetic changes to the way port printing is done to
make it clearer how a port is formed.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/libsas/sas_ata.c  |   39 ++-------------------------------------
 drivers/scsi/libsas/sas_port.c |   11 ++++++-----
 2 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 7cd05b5..b0e5ac3 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -236,12 +236,12 @@ static void sas_ata_phy_reset(struct ata_port *ap)
 	struct domain_device *dev = ap->private_data;
 	struct sas_internal *i =
 		to_sas_internal(dev->port->ha->core.shost->transportt);
-	int res = 0;
+	int res = TMF_RESP_FUNC_FAILED;
 
 	if (i->dft->lldd_I_T_nexus_reset)
 		res = i->dft->lldd_I_T_nexus_reset(dev);
 
-	if (res)
+	if (res != TMF_RESP_FUNC_COMPLETE)
 		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __FUNCTION__);
 
 	switch (dev->sata_dev.command_set) {
@@ -656,21 +656,6 @@ out:
 	return res;
 }
 
-static void sas_sata_propagate_sas_addr(struct domain_device *dev)
-{
-	unsigned long flags;
-	struct asd_sas_port *port = dev->port;
-	struct asd_sas_phy  *phy;
-
-	BUG_ON(dev->parent);
-
-	memcpy(port->attached_sas_addr, dev->sas_addr, SAS_ADDR_SIZE);
-	spin_lock_irqsave(&port->phy_list_lock, flags);
-	list_for_each_entry(phy, &port->phy_list, port_phy_el)
-		memcpy(phy->attached_sas_addr, dev->sas_addr, SAS_ADDR_SIZE);
-	spin_unlock_irqrestore(&port->phy_list_lock, flags);
-}
-
 #define ATA_IDENTIFY_DEV         0xEC
 #define ATA_IDENTIFY_PACKET_DEV  0xA1
 #define ATA_SET_FEATURES         0xEF
@@ -728,26 +713,6 @@ static int sas_discover_sata_dev(struct domain_device *dev)
 			goto out_err;
 	}
 cont1:
-	/* Get WWN */
-	if (dev->port->oob_mode != SATA_OOB_MODE) {
-		memcpy(dev->sas_addr, dev->sata_dev.rps_resp.rps.stp_sas_addr,
-		       SAS_ADDR_SIZE);
-	} else if (dev->sata_dev.command_set == ATA_COMMAND_SET &&
-		   (le16_to_cpu(dev->sata_dev.identify_device[108]) & 0xF000)
-		   == 0x5000) {
-		int i;
-
-		for (i = 0; i < 4; i++) {
-			dev->sas_addr[2*i] =
-	     (le16_to_cpu(dev->sata_dev.identify_device[108+i]) & 0xFF00) >> 8;
-			dev->sas_addr[2*i+1] =
-	      le16_to_cpu(dev->sata_dev.identify_device[108+i]) & 0x00FF;
-		}
-	}
-	sas_hash_addr(dev->hashed_sas_addr, dev->sas_addr);
-	if (!dev->parent)
-		sas_sata_propagate_sas_addr(dev);
-
 	/* XXX Hint: register this SATA device with SATL.
 	   When this returns, dev->sata_dev->lu is alive and
 	   present.
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index e1e2d08..39ae68a 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -92,9 +92,6 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	if (!port->phy)
 		port->phy = phy->phy;
 
-	SAS_DPRINTK("phy%d added to port%d, phy_mask:0x%x\n", phy->id,
-		    port->id, port->phy_mask);
-
 	if (*(u64 *)port->attached_sas_addr == 0) {
 		port->class = phy->class;
 		memcpy(port->attached_sas_addr, phy->attached_sas_addr,
@@ -115,6 +112,11 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	}
 	sas_port_add_phy(port->port, phy->phy);
 
+	SAS_DPRINTK("%s added to %s, phy_mask:0x%x (%16llx)\n",
+		    phy->phy->dev.bus_id,port->port->dev.bus_id,
+		    port->phy_mask,
+		    SAS_ADDR(port->attached_sas_addr));
+
 	if (port->port_dev)
 		port->port_dev->pathways = port->num_phys;
 
@@ -255,12 +257,11 @@ void sas_porte_hard_reset(struct work_struct *work)
 static void sas_init_port(struct asd_sas_port *port,
 			  struct sas_ha_struct *sas_ha, int i)
 {
+	memset(port, 0, sizeof(*port));
 	port->id = i;
 	INIT_LIST_HEAD(&port->dev_list);
 	spin_lock_init(&port->phy_list_lock);
 	INIT_LIST_HEAD(&port->phy_list);
-	port->num_phys = 0;
-	port->phy_mask = 0;
 	port->ha = sas_ha;
 
 	spin_lock_init(&port->dev_list_lock);
-- 
1.5.4.1



