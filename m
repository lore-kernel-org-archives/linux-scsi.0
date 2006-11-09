From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 1/4] aic94xx: SCSI timeout fix
Date: Thu, 09 Nov 2006 12:02:56 -0800
Message-ID: <1163102576.6521.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:63917 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S965418AbWKIUDX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2006 15:03:23 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA9K3Lth012148
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:03:21 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA9K30aJ244218
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:03:00 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA9K2wrH022891
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:02:58 -0500
Received: from [9.48.54.0] ([9.48.54.0])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kA9K2vwZ022764
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:02:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The patch updates DDB0 in the aic94xx driver itself. It doesn't supply 
or use lldd_port_formed field. DDB0 is updated prior to posting
notification to libsas layer.


Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

---

diff -r 445d70ce1ff2 drivers/scsi/aic94xx/aic94xx_hwi.c
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c	Wed Oct 04 10:02:16 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c	Wed Oct 04 10:03:57 2006 -0700
@@ -112,6 +112,21 @@ static int asd_init_phy(struct asd_phy *
 	return 0;
 }
 
+static void asd_init_ports(struct asd_ha_struct *asd_ha)
+{
+	int i;
+
+	spin_lock_init(&asd_ha->asd_ports_lock);
+	for (i = 0; i < ASD_MAX_PHYS; i++) {
+		struct asd_port *asd_port = &asd_ha->asd_ports[i];
+
+		memset(asd_port->sas_addr, 0, SAS_ADDR_SIZE);
+		memset(asd_port->attached_sas_addr, 0, SAS_ADDR_SIZE);
+		asd_port->phy_mask = 0;
+		asd_port->num_phys = 0;
+	}
+}
+
 static int asd_init_phys(struct asd_ha_struct *asd_ha)
 {
 	u8 i;
@@ -121,6 +136,7 @@ static int asd_init_phys(struct asd_ha_s
 		struct asd_phy *phy = &asd_ha->phys[i];
 
 		phy->phy_desc = &asd_ha->hw_prof.phy_desc[i];
+		phy->asd_port = NULL;
 
 		phy->sas_phy.enabled = 0;
 		phy->sas_phy.id = i;
@@ -657,6 +673,8 @@ int asd_init_hw(struct asd_ha_struct *as
 			    pci_name(asd_ha->pcidev));
 		goto Out;
 	}
+
+	asd_init_ports(asd_ha);
 
 	err = asd_init_scbs(asd_ha);
 	if (err) {
diff -r 445d70ce1ff2 drivers/scsi/aic94xx/aic94xx_hwi.h
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h	Wed Oct 04 10:02:16 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h	Wed Oct 04 10:03:57 2006 -0700
@@ -192,6 +192,16 @@ struct asd_seq_data {
 	struct asd_ascb **escb_arr; /* array of pointers to escbs */
 };
 
+/* This is an internal port structure. These are used to get accurate
+ * phy_mask for updating DDB 0.
+ */
+struct asd_port {
+	u8  sas_addr[SAS_ADDR_SIZE];
+	u8  attached_sas_addr[SAS_ADDR_SIZE];
+	u32 phy_mask;
+	int num_phys;
+};
+
 /* This is the Host Adapter structure.  It describes the hardware
  * SAS adapter.
  */
@@ -210,6 +220,8 @@ struct asd_ha_struct {
 	struct hw_profile hw_prof;
 
 	struct asd_phy    phys[ASD_MAX_PHYS];
+	spinlock_t        asd_ports_lock;
+	struct asd_port   asd_ports[ASD_MAX_PHYS];
 	struct asd_sas_port   ports[ASD_MAX_PHYS];
 
 	struct dma_pool  *scb_pool;
diff -r 445d70ce1ff2 drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c	Wed Oct 04 10:02:16 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_init.c	Wed Oct 04 10:03:57 2006 -0700
@@ -766,8 +766,6 @@ static void asd_remove_driver_attrs(stru
 }
 
 static struct sas_domain_function_template aic94xx_transport_functions = {
-	.lldd_port_formed	= asd_update_port_links,
-
 	.lldd_dev_found		= asd_dev_found,
 	.lldd_dev_gone		= asd_dev_gone,
 
diff -r 445d70ce1ff2 drivers/scsi/aic94xx/aic94xx_sas.h
--- a/drivers/scsi/aic94xx/aic94xx_sas.h	Wed Oct 04 10:02:16 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_sas.h	Wed Oct 04 10:03:57 2006 -0700
@@ -733,6 +733,7 @@ struct asd_phy {
 
 	struct sas_identify_frame *identify_frame;
 	struct asd_dma_tok  *id_frm_tok;
+	struct asd_port     *asd_port;
 
 	u8         frame_rcvd[ASD_EDB_SIZE];
 };
diff -r 445d70ce1ff2 drivers/scsi/aic94xx/aic94xx_scb.c
--- a/drivers/scsi/aic94xx/aic94xx_scb.c	Wed Oct 04 10:02:16 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c	Wed Oct 04 10:03:57 2006 -0700
@@ -168,6 +168,70 @@ static inline void asd_get_attached_sas_
 	}
 }
 
+static void asd_form_port(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
+{
+	int i;
+	struct asd_port *free_port = NULL;
+	struct asd_port *port;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	unsigned long flags;
+
+	spin_lock_irqsave(&asd_ha->asd_ports_lock, flags);
+	if (!phy->asd_port) {
+		for (i = 0; i < ASD_MAX_PHYS; i++) {
+			port = &asd_ha->asd_ports[i];
+
+			/* Check for wide port */
+			if (port->num_phys > 0 &&
+			    memcmp(port->sas_addr, sas_phy->sas_addr,
+				   SAS_ADDR_SIZE) == 0 &&
+			    memcmp(port->attached_sas_addr,
+				   sas_phy->attached_sas_addr,
+				   SAS_ADDR_SIZE) == 0) {
+				break;
+			}
+
+			/* Find a free port */
+			if (port->num_phys == 0 && free_port == NULL) {
+				free_port = port;
+			}
+		}
+
+		/* Use a free port if this doesn't form a wide port */
+		if (i >= ASD_MAX_PHYS) {
+			port = free_port;
+			BUG_ON(!port);
+			memcpy(port->sas_addr, sas_phy->sas_addr,
+			       SAS_ADDR_SIZE);
+			memcpy(port->attached_sas_addr,
+			       sas_phy->attached_sas_addr,
+			       SAS_ADDR_SIZE);
+		}
+		port->num_phys++;
+		port->phy_mask |= (1U << sas_phy->id);
+		phy->asd_port = port;
+	}
+	ASD_DPRINTK("%s: updating phy_mask 0x%x for phy%d\n",
+		    __FUNCTION__, phy->asd_port->phy_mask, sas_phy->id);
+	asd_update_port_links(asd_ha, phy);
+	spin_unlock_irqrestore(&asd_ha->asd_ports_lock, flags);
+}
+
+static void asd_deform_port(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
+{
+	struct asd_port *port = phy->asd_port;
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	unsigned long flags;
+
+	spin_lock_irqsave(&asd_ha->asd_ports_lock, flags);
+	if (port) {
+		port->num_phys--;
+		port->phy_mask &= ~(1U << sas_phy->id);
+		phy->asd_port = NULL;
+	}
+	spin_unlock_irqrestore(&asd_ha->asd_ports_lock, flags);
+}
+
 static inline void asd_bytes_dmaed_tasklet(struct asd_ascb *ascb,
 					   struct done_list_struct *dl,
 					   int edb_id, int phy_id)
@@ -187,6 +251,7 @@ static inline void asd_bytes_dmaed_taskl
 	asd_get_attached_sas_addr(phy, phy->sas_phy.attached_sas_addr);
 	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
 	asd_dump_frame_rcvd(phy, dl);
+	asd_form_port(ascb->ha, phy);
 	sas_ha->notify_port_event(&phy->sas_phy, PORTE_BYTES_DMAED);
 }
 
@@ -197,6 +262,7 @@ static inline void asd_link_reset_err_ta
 	struct asd_ha_struct *asd_ha = ascb->ha;
 	struct sas_ha_struct *sas_ha = &asd_ha->sas_ha;
 	struct asd_sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
+	struct asd_phy *phy = &asd_ha->phys[phy_id];
 	u8 lr_error = dl->status_block[1];
 	u8 retries_left = dl->status_block[2];
 
@@ -221,6 +287,7 @@ static inline void asd_link_reset_err_ta
 
 	asd_turn_led(asd_ha, phy_id, 0);
 	sas_phy_disconnected(sas_phy);
+	asd_deform_port(asd_ha, phy);
 	sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 
 	if (retries_left == 0) {
@@ -248,6 +315,8 @@ static inline void asd_primitive_rcvd_ta
 	unsigned long flags;
 	struct sas_ha_struct *sas_ha = &ascb->ha->sas_ha;
 	struct asd_sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
+	struct asd_ha_struct *asd_ha = ascb->ha;
+	struct asd_phy *phy = &asd_ha->phys[phy_id];
 	u8  reg  = dl->status_block[1];
 	u32 cont = dl->status_block[2] << ((reg & 3)*8);
 
@@ -284,6 +353,7 @@ static inline void asd_primitive_rcvd_ta
 				    phy_id);
 			/* The sequencer disables all phys on that port.
 			 * We have to re-enable the phys ourselves. */
+			asd_deform_port(asd_ha, phy);
 			sas_ha->notify_port_event(sas_phy, PORTE_HARD_RESET);
 			break;
 
@@ -351,6 +421,7 @@ static void escb_tasklet_complete(struct
 	u8  sb_opcode = dl->status_block[0];
 	int phy_id = sb_opcode & DL_PHY_MASK;
 	struct asd_sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
+	struct asd_phy *phy = &asd_ha->phys[phy_id];
 
 	if (edb > 6 || edb < 0) {
 		ASD_DPRINTK("edb is 0x%x! dl->opcode is 0x%x\n",
@@ -395,6 +466,7 @@ static void escb_tasklet_complete(struct
 		asd_turn_led(asd_ha, phy_id, 0);
 		/* the device is gone */
 		sas_phy_disconnected(sas_phy);
+		asd_deform_port(asd_ha, phy);
 		sas_ha->notify_port_event(sas_phy, PORTE_TIMER_EVENT);
 		break;
 	case REQ_TASK_ABORT:
diff -r 445d70ce1ff2 drivers/scsi/aic94xx/aic94xx_seq.c
--- a/drivers/scsi/aic94xx/aic94xx_seq.c	Wed Oct 04 10:02:16 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c	Wed Oct 04 10:03:57 2006 -0700
@@ -1369,10 +1369,9 @@ int asd_start_seqs(struct asd_ha_struct 
  * port_map_by_links is also used as the conn_mask byte in the
  * initiator/target port DDB.
  */
-void asd_update_port_links(struct asd_sas_phy *sas_phy)
-{
-	struct asd_ha_struct *asd_ha = sas_phy->ha->lldd_ha;
-	const u8 phy_mask = (u8) sas_phy->port->phy_mask;
+void asd_update_port_links(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
+{
+	const u8 phy_mask = (u8) phy->asd_port->phy_mask;
 	u8  phy_is_up;
 	u8  mask;
 	int i, err;
diff -r 445d70ce1ff2 drivers/scsi/aic94xx/aic94xx_seq.h
--- a/drivers/scsi/aic94xx/aic94xx_seq.h	Wed Oct 04 10:02:16 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_seq.h	Wed Oct 04 10:03:57 2006 -0700
@@ -64,7 +64,7 @@ int asd_init_seqs(struct asd_ha_struct *
 int asd_init_seqs(struct asd_ha_struct *asd_ha);
 int asd_start_seqs(struct asd_ha_struct *asd_ha);
 
-void asd_update_port_links(struct asd_sas_phy *phy);
+void asd_update_port_links(struct asd_ha_struct *asd_ha, struct asd_phy *phy);
 #endif
 
 #endif

