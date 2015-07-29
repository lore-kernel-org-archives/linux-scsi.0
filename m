From: <Viswas.G@pmcs.com>
Subject: [PATCH 6/8] pm80xx: Add PORT RECOVERY TIMEOUT support
Date: Wed, 29 Jul 2015 11:57:18 +0530
Message-ID: <1438151240-4097-7-git-send-email-Viswas.G@pmcs.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:35402 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbbG2G0b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 02:26:31 -0400
In-Reply-To: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

From: Viswas G <Viswas.G@pmcs.com>

PORT RECOVERY TIMEOUT is the maximum time between the controller's
detection of the PHY down until the receipt of the ID_Frame (from the
same remote SAS port). If the time expires before the ID_FRAME is
received, the port is considered INVALID and can be removed. The
IOP_EVENT_PORT_RECOVERY_TIMER_TMO event is reported following the
IOP_EVENT_ PHY_DOWN event when the PHY/port does not recover after
Port Recovery Time.

Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com> 
---
 drivers/scsi/pm8001/pm8001_sas.h |    2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c |   83 ++++++++++++++++++++++++++++++-------
 2 files changed, 68 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index c9736cc..2788026 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -241,7 +241,7 @@ struct pm8001_chip_info {
 struct pm8001_port {
 	struct asd_sas_port	sas_port;
 	u8			port_attached;
-	u8			wide_port_phymap;
+	u16			wide_port_phymap;
 	u8			port_state;
 	struct list_head	list;
 };
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 3d8b4ae..8817ce6 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -309,6 +309,9 @@ static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
 		pm8001_mr32(address, MAIN_INT_VECTOR_TABLE_OFFSET);
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.phy_attr_table_offset =
 		pm8001_mr32(address, MAIN_SAS_PHY_ATTR_TABLE_OFFSET);
+	/* read port recover and reset timeout */
+	pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer =
+		pm8001_mr32(address, MAIN_PORT_RECOVERY_TIMER);
 }
 
 /**
@@ -585,6 +588,12 @@ static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer);
 	pm8001_mw32(address, MAIN_INT_REASSERTION_DELAY,
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.interrupt_reassertion_delay);
+
+	pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer &= 0xffff0000;
+	pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer |=
+							PORT_RECOVERY_TIMEOUT;
+	pm8001_mw32(address, MAIN_PORT_RECOVERY_TIMER,
+			pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer);
 }
 
 /**
@@ -2836,6 +2845,32 @@ static void pm80xx_hw_event_ack_req(struct pm8001_hba_info *pm8001_ha,
 static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	u32 phyId, u32 phy_op);
 
+static void hw_event_port_recover(struct pm8001_hba_info *pm8001_ha,
+					void *piomb)
+{
+	struct hw_event_resp *pPayload = (struct hw_event_resp *)(piomb + 4);
+	u32 phyid_npip_portstate = le32_to_cpu(pPayload->phyid_npip_portstate);
+	u8 phy_id = (u8)((phyid_npip_portstate & 0xFF0000) >> 16);
+	u32 lr_status_evt_portid =
+		le32_to_cpu(pPayload->lr_status_evt_portid);
+	u8 deviceType = pPayload->sas_identify.dev_type;
+	u8 link_rate = (u8)((lr_status_evt_portid & 0xF0000000) >> 28);
+	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
+	u8 port_id = (u8)(lr_status_evt_portid & 0x000000FF);
+	struct pm8001_port *port = &pm8001_ha->port[port_id];
+
+	if (deviceType == SAS_END_DEVICE) {
+		pm80xx_chip_phy_ctl_req(pm8001_ha, phy_id,
+					PHY_NOTIFY_ENABLE_SPINUP);
+	}
+
+	port->wide_port_phymap |= (1U << phy_id);
+	pm8001_get_lrate_mode(phy, link_rate);
+	phy->sas_phy.oob_mode = SAS_OOB_MODE;
+	phy->phy_state = PHY_STATE_LINK_UP_SPCV;
+	phy->phy_attached = 1;
+}
+
 /**
  * hw_event_sas_phy_up -FW tells me a SAS phy up event.
  * @pm8001_ha: our hba card information
@@ -2863,6 +2898,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	unsigned long flags;
 	u8 deviceType = pPayload->sas_identify.dev_type;
 	port->port_state = portstate;
+	port->wide_port_phymap |= (1U << phy_id);
 	phy->phy_state = PHY_STATE_LINK_UP_SPCV;
 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
 		"portid:%d; phyid:%d; linkrate:%d; "
@@ -2988,7 +3024,6 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	struct pm8001_port *port = &pm8001_ha->port[port_id];
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	port->port_state = portstate;
-	phy->phy_type = 0;
 	phy->identify.device_type = 0;
 	phy->phy_attached = 0;
 	memset(&phy->dev_sas_addr, 0, SAS_ADDR_SIZE);
@@ -3000,9 +3035,13 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk(" PortInvalid portID %d\n", port_id));
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" Last phy Down and port invalid\n"));
-		port->port_attached = 0;
-		pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
-			port_id, phy_id, 0, 0);
+		if (phy->phy_type & PORT_TYPE_SATA) {
+			phy->phy_type = 0;
+			port->port_attached = 0;
+			pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
+					port_id, phy_id, 0, 0);
+		}
+		sas_phy_disconnected(&phy->sas_phy);
 		break;
 	case PORT_IN_RESET:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3010,22 +3049,26 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case PORT_NOT_ESTABLISHED:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" phy Down and PORT_NOT_ESTABLISHED\n"));
+			pm8001_printk(" Phy Down and PORT_NOT_ESTABLISHED\n"));
 		port->port_attached = 0;
 		break;
 	case PORT_LOSTCOMM:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" phy Down and PORT_LOSTCOMM\n"));
+			pm8001_printk(" Phy Down and PORT_LOSTCOMM\n"));
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" Last phy Down and port invalid\n"));
-		port->port_attached = 0;
-		pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
-			port_id, phy_id, 0, 0);
+		if (phy->phy_type & PORT_TYPE_SATA) {
+			port->port_attached = 0;
+			phy->phy_type = 0;
+			pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
+					port_id, phy_id, 0, 0);
+		}
+		sas_phy_disconnected(&phy->sas_phy);
 		break;
 	default:
 		port->port_attached = 0;
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" phy Down and(default) = 0x%x\n",
+			pm8001_printk(" Phy Down and(default) = 0x%x\n",
 			portstate));
 		break;
 
@@ -3091,7 +3134,7 @@ static int mpi_thermal_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
  */
 static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
-	unsigned long flags;
+	unsigned long flags, i;
 	struct hw_event_resp *pPayload =
 		(struct hw_event_resp *)(piomb + 4);
 	u32 lr_status_evt_portid =
@@ -3104,9 +3147,9 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		(u16)((lr_status_evt_portid & 0x00FFFF00) >> 8);
 	u8 status =
 		(u8)((lr_status_evt_portid & 0x0F000000) >> 24);
-
 	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
+	struct pm8001_port *port = &pm8001_ha->port[port_id];
 	struct asd_sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
 	PM8001_MSG_DBG(pm8001_ha,
 		pm8001_printk("portid:%d phyid:%d event:0x%x status:0x%x\n",
@@ -3132,7 +3175,9 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case HW_EVENT_PHY_DOWN:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_PHY_DOWN\n"));
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
+		if (phy->phy_type & PORT_TYPE_SATA)
+			sas_ha->notify_phy_event(&phy->sas_phy,
+				PHYE_LOSS_OF_SIGNAL);
 		phy->phy_attached = 0;
 		phy->phy_state = 0;
 		hw_event_phy_down(pm8001_ha, piomb);
@@ -3252,13 +3297,19 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_PORT_RECOVERY_TIMER_TMO,
 			port_id, phy_id, 0, 0);
-		sas_phy_disconnected(sas_phy);
-		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
+			if (port->wide_port_phymap & (1 << i)) {
+				phy = &pm8001_ha->phy[i];
+				sas_ha->notify_phy_event(&phy->sas_phy,
+						PHYE_LOSS_OF_SIGNAL);
+				port->wide_port_phymap &= ~(1 << i);
+			}
+		}
 		break;
 	case HW_EVENT_PORT_RECOVER:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_PORT_RECOVER\n"));
+		hw_event_port_recover(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_PORT_RESET_COMPLETE:
 		PM8001_MSG_DBG(pm8001_ha,
-- 
1.7.1

