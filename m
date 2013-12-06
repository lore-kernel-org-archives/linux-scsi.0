From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.13-rc2
Date: Fri, 06 Dec 2013 06:57:25 -0800
Message-ID: <1386341845.1981.9.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35214 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758254Ab3LFO51 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Dec 2013 09:57:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a set of nine fixes (and one author update). The libsas one
should fix discovery in eSATA devices, the WRITE_SAME one is the largest
and most invasive but it should fix a lot of problems we've been getting
with the emulated RAID devices (they've been effectively lying about
support and then firmware has been choking on the commands).  The rest
are various crash, hang or warn driver fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Williams (1):
      libsas: fix usage of ata_tf_to_fis

James Bottomley (1):
      enclosure: fix WARN_ON in dual path device removing

Martin K. Petersen (1):
      Disable WRITE SAME for RAID and virtual host adapter drivers

Nikith Ganigarakoppal (4):
      pm80xx: Tasklets synchronization fix.
      pm80xx: Resetting the phy state.
      pm80xx: Fix for direct attached device.
      pm80xx: Module author addition

Stephen M. Cameron (2):
      hpsa: return 0 from driver probe function on success, not 1
      hpsa: do not discard scsi status on aborted commands

Vijaya Mohan Guvva (1):
      bfa: Fix crash when symb name set for offline vport

And the diffstat:

 drivers/ata/libata-scsi.c                 |  1 +
 drivers/firewire/sbp2.c                   |  1 +
 drivers/misc/enclosure.c                  |  7 +++
 drivers/scsi/3w-9xxx.c                    |  3 +-
 drivers/scsi/3w-sas.c                     |  3 +-
 drivers/scsi/3w-xxxx.c                    |  3 +-
 drivers/scsi/aacraid/linit.c              |  1 +
 drivers/scsi/arcmsr/arcmsr_hba.c          |  1 +
 drivers/scsi/bfa/bfa_fcs.h                |  1 +
 drivers/scsi/bfa/bfa_fcs_lport.c          | 14 ++++-
 drivers/scsi/bfa/bfad_attr.c              |  7 +--
 drivers/scsi/gdth.c                       |  1 +
 drivers/scsi/hosts.c                      |  1 +
 drivers/scsi/hpsa.c                       |  5 +-
 drivers/scsi/ipr.c                        |  3 +-
 drivers/scsi/ips.c                        |  1 +
 drivers/scsi/libsas/sas_ata.c             |  2 +-
 drivers/scsi/megaraid.c                   |  1 +
 drivers/scsi/megaraid/megaraid_mbox.c     |  1 +
 drivers/scsi/megaraid/megaraid_sas_base.c |  1 +
 drivers/scsi/pm8001/pm8001_hwi.c          |  2 +
 drivers/scsi/pm8001/pm8001_hwi.h          |  4 ++
 drivers/scsi/pm8001/pm8001_init.c         | 91 ++++++++++++++++++-------------
 drivers/scsi/pm8001/pm8001_sas.c          |  4 +-
 drivers/scsi/pm8001/pm8001_sas.h          |  9 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c          |  2 +
 drivers/scsi/pm8001/pm80xx_hwi.h          |  2 +
 drivers/scsi/pmcraid.c                    |  1 +
 drivers/scsi/sd.c                         |  6 ++
 drivers/scsi/storvsc_drv.c                |  1 +
 include/scsi/scsi_host.h                  |  6 ++
 31 files changed, 129 insertions(+), 57 deletions(-)

with full diff attached below.

James

---
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index db6dfcf..ab58556 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3625,6 +3625,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		shost->max_lun = 1;
 		shost->max_channel = 1;
 		shost->max_cmd_len = 16;
+		shost->no_write_same = 1;
 
 		/* Schedule policy is determined by ->qc_defer()
 		 * callback and it needs to see every deferred qc.
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 281029d..b0bb056 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1623,6 +1623,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
+	.no_write_same		= 1,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 0e8df41..2cf2bbc 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -198,6 +198,13 @@ static void enclosure_remove_links(struct enclosure_component *cdev)
 {
 	char name[ENCLOSURE_NAME_SIZE];
 
+	/*
+	 * In odd circumstances, like multipath devices, something else may
+	 * already have removed the links, so check for this condition first.
+	 */
+	if (!cdev->dev->kobj.sd)
+		return;
+
 	enclosure_link_name(cdev, name);
 	sysfs_remove_link(&cdev->dev->kobj, name);
 	sysfs_remove_link(&cdev->cdev.kobj, "device");
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 5e1e12c..0a73253 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2025,7 +2025,8 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= twa_host_attrs,
-	.emulated		= 1
+	.emulated		= 1,
+	.no_write_same		= 1,
 };
 
 /* This function will probe and initialize a card */
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index c845bdb..4de3460 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1600,7 +1600,8 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= twl_host_attrs,
-	.emulated		= 1
+	.emulated		= 1,
+	.no_write_same		= 1,
 };
 
 /* This function will probe and initialize a card */
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index b9276d1..752624e 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2279,7 +2279,8 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= tw_host_attrs,
-	.emulated		= 1
+	.emulated		= 1,
+	.no_write_same		= 1,
 };
 
 /* This function will probe and initialize a card */
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index f0d432c..4921ed1 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1081,6 +1081,7 @@ static struct scsi_host_template aac_driver_template = {
 #endif
 	.use_clustering			= ENABLE_CLUSTERING,
 	.emulated			= 1,
+	.no_write_same			= 1,
 };
 
 static void __aac_shutdown(struct aac_dev * aac)
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 97fd450..4f6a30b 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -137,6 +137,7 @@ static struct scsi_host_template arcmsr_scsi_host_template = {
 	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= arcmsr_host_attrs,
+	.no_write_same		= 1,
 };
 static struct pci_device_id arcmsr_device_id_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110)},
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 94d5d01..42bcb97 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -296,6 +296,7 @@ wwn_t bfa_fcs_lport_get_rport(struct bfa_fcs_lport_s *port, wwn_t wwn,
 struct bfa_fcs_lport_s *bfa_fcs_lookup_port(struct bfa_fcs_s *fcs,
 					    u16 vf_id, wwn_t lpwwn);
 
+void bfa_fcs_lport_set_symname(struct bfa_fcs_lport_s *port, char *symname);
 void bfa_fcs_lport_get_info(struct bfa_fcs_lport_s *port,
 			    struct bfa_lport_info_s *port_info);
 void bfa_fcs_lport_get_attr(struct bfa_fcs_lport_s *port,
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 2f61a5a..f5e4e61 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1097,6 +1097,17 @@ bfa_fcs_lport_init(struct bfa_fcs_lport_s *lport,
 	bfa_sm_send_event(lport, BFA_FCS_PORT_SM_CREATE);
 }
 
+void
+bfa_fcs_lport_set_symname(struct bfa_fcs_lport_s *port,
+				char *symname)
+{
+	strcpy(port->port_cfg.sym_name.symname, symname);
+
+	if (bfa_sm_cmp_state(port, bfa_fcs_lport_sm_online))
+		bfa_fcs_lport_ns_util_send_rspn_id(
+			BFA_FCS_GET_NS_FROM_PORT(port), NULL);
+}
+
 /*
  *  fcs_lport_api
  */
@@ -5140,9 +5151,6 @@ bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	u8 *psymbl = &symbl[0];
 	int len;
 
-	if (!bfa_sm_cmp_state(port, bfa_fcs_lport_sm_online))
-		return;
-
 	/* Avoid sending RSPN in the following states. */
 	if (bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_offline) ||
 	    bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_plogi_sending) ||
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index e9a681d..40be670 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -593,11 +593,8 @@ bfad_im_vport_set_symbolic_name(struct fc_vport *fc_vport)
 		return;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	if (strlen(sym_name) > 0) {
-		strcpy(fcs_vport->lport.port_cfg.sym_name.symname, sym_name);
-		bfa_fcs_lport_ns_util_send_rspn_id(
-			BFA_FCS_GET_NS_FROM_PORT((&fcs_vport->lport)), NULL);
-	}
+	if (strlen(sym_name) > 0)
+		bfa_fcs_lport_set_symname(&fcs_vport->lport, sym_name);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index ee4fa40..ce5ef01 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4684,6 +4684,7 @@ static struct scsi_host_template gdth_template = {
         .cmd_per_lun            = GDTH_MAXC_P_L,
         .unchecked_isa_dma      = 1,
         .use_clustering         = ENABLE_CLUSTERING,
+	.no_write_same		= 1,
 };
 
 #ifdef CONFIG_ISA
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f334859..f2c5005 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -395,6 +395,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
 	shost->eh_deadline = shost_eh_deadline * HZ;
+	shost->no_write_same = sht->no_write_same;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 22f6432..20a5e6e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -561,6 +561,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.sdev_attrs = hpsa_sdev_attrs,
 	.shost_attrs = hpsa_shost_attrs,
 	.max_sectors = 8192,
+	.no_write_same = 1,
 };
 
 
@@ -1288,7 +1289,7 @@ static void complete_scsi_command(struct CommandList *cp)
 					"has check condition: aborted command: "
 					"ASC: 0x%x, ASCQ: 0x%x\n",
 					cp, asc, ascq);
-				cmd->result = DID_SOFT_ERROR << 16;
+				cmd->result |= DID_SOFT_ERROR << 16;
 				break;
 			}
 			/* Must be some other type of check condition */
@@ -4925,7 +4926,7 @@ reinit_after_soft_reset:
 	hpsa_hba_inquiry(h);
 	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
 	start_controller_lockup_detector(h);
-	return 1;
+	return 0;
 
 clean4:
 	hpsa_free_sg_chain_blocks(h);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 36ac1c3..573f412 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6305,7 +6305,8 @@ static struct scsi_host_template driver_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = ipr_ioa_attrs,
 	.sdev_attrs = ipr_dev_attrs,
-	.proc_name = IPR_NAME
+	.proc_name = IPR_NAME,
+	.no_write_same = 1,
 };
 
 /**
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 8d5ea8a..52a216f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -374,6 +374,7 @@ static struct scsi_host_template ips_driver_template = {
 	.sg_tablesize		= IPS_MAX_SG,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.no_write_same		= 1,
 };
 
 
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 161c98e..d289583 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -211,7 +211,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		qc->tf.nsect = 0;
 	}
 
-	ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *)&task->ata_task.fis);
 	task->uldd_task = qc;
 	if (ata_is_atapi(qc->tf.protocol)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 90c95a3..816db12 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4244,6 +4244,7 @@ static struct scsi_host_template megaraid_template = {
 	.eh_device_reset_handler	= megaraid_reset,
 	.eh_bus_reset_handler		= megaraid_reset,
 	.eh_host_reset_handler		= megaraid_reset,
+	.no_write_same			= 1,
 };
 
 static int
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index d1a4b82..e2237a9 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -367,6 +367,7 @@ static struct scsi_host_template megaraid_template_g = {
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.change_queue_depth		= megaraid_change_queue_depth,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.no_write_same			= 1,
 	.sdev_attrs			= megaraid_sdev_attrs,
 	.shost_attrs			= megaraid_shost_attrs,
 };
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 0a743a5..c99812b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2148,6 +2148,7 @@ static struct scsi_host_template megasas_template = {
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
 	.change_queue_depth = megasas_change_queue_depth,
+	.no_write_same = 1,
 };
 
 /**
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index f16ece9..0a1296a 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3403,6 +3403,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	unsigned long flags;
 	u8 deviceType = pPayload->sas_identify.dev_type;
 	port->port_state =  portstate;
+	phy->phy_state = PHY_STATE_LINK_UP_SPC;
 	PM8001_MSG_DBG(pm8001_ha,
 		pm8001_printk("HW_EVENT_SAS_PHY_UP port id = %d, phy id = %d\n",
 		port_id, phy_id));
@@ -3483,6 +3484,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_printk("HW_EVENT_SATA_PHY_UP port id = %d,"
 		" phy id = %d\n", port_id, phy_id));
 	port->port_state =  portstate;
+	phy->phy_state = PHY_STATE_LINK_UP_SPC;
 	port->port_attached = 1;
 	pm8001_get_lrate_mode(phy, link_rate);
 	phy->phy_type |= PORT_TYPE_SATA;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index 6d91e24..e4867e6 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -131,6 +131,10 @@
 #define LINKRATE_30			(0x02 << 8)
 #define LINKRATE_60			(0x04 << 8)
 
+/* for phy state */
+
+#define PHY_STATE_LINK_UP_SPC		0x1
+
 /* for new SPC controllers MEMBASE III is shared between BIOS and DATA */
 #define GSM_SM_BASE			0x4F0000
 struct mpi_msg_hdr{
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 34f5f5f..73a120d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -175,20 +175,16 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 static void pm8001_tasklet(unsigned long opaque)
 {
 	struct pm8001_hba_info *pm8001_ha;
-	u32 vec;
-	pm8001_ha = (struct pm8001_hba_info *)opaque;
+	struct isr_param *irq_vector;
+
+	irq_vector = (struct isr_param *)opaque;
+	pm8001_ha = irq_vector->drv_inst;
 	if (unlikely(!pm8001_ha))
 		BUG_ON(1);
-	vec = pm8001_ha->int_vector;
-	PM8001_CHIP_DISP->isr(pm8001_ha, vec);
+	PM8001_CHIP_DISP->isr(pm8001_ha, irq_vector->irq_id);
 }
 #endif
 
-static struct  pm8001_hba_info *outq_to_hba(u8 *outq)
-{
-	return container_of((outq - *outq), struct pm8001_hba_info, outq[0]);
-}
-
 /**
  * pm8001_interrupt_handler_msix - main MSIX interrupt handler.
  * It obtains the vector number and calls the equivalent bottom
@@ -198,18 +194,20 @@ static struct  pm8001_hba_info *outq_to_hba(u8 *outq)
  */
 static irqreturn_t pm8001_interrupt_handler_msix(int irq, void *opaque)
 {
-	struct pm8001_hba_info *pm8001_ha = outq_to_hba(opaque);
-	u8 outq = *(u8 *)opaque;
+	struct isr_param *irq_vector;
+	struct pm8001_hba_info *pm8001_ha;
 	irqreturn_t ret = IRQ_HANDLED;
+	irq_vector = (struct isr_param *)opaque;
+	pm8001_ha = irq_vector->drv_inst;
+
 	if (unlikely(!pm8001_ha))
 		return IRQ_NONE;
 	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
 		return IRQ_NONE;
-	pm8001_ha->int_vector = outq;
 #ifdef PM8001_USE_TASKLET
-	tasklet_schedule(&pm8001_ha->tasklet);
+	tasklet_schedule(&pm8001_ha->tasklet[irq_vector->irq_id]);
 #else
-	ret = PM8001_CHIP_DISP->isr(pm8001_ha, outq);
+	ret = PM8001_CHIP_DISP->isr(pm8001_ha, irq_vector->irq_id);
 #endif
 	return ret;
 }
@@ -230,9 +228,8 @@ static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
 		return IRQ_NONE;
 
-	pm8001_ha->int_vector = 0;
 #ifdef PM8001_USE_TASKLET
-	tasklet_schedule(&pm8001_ha->tasklet);
+	tasklet_schedule(&pm8001_ha->tasklet[0]);
 #else
 	ret = PM8001_CHIP_DISP->isr(pm8001_ha, 0);
 #endif
@@ -457,7 +454,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 {
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
-
+	int j;
 
 	pm8001_ha = sha->lldd_ha;
 	if (!pm8001_ha)
@@ -480,12 +477,14 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 		pm8001_ha->iomb_size = IOMB_SIZE_SPC;
 
 #ifdef PM8001_USE_TASKLET
-	/**
-	* default tasklet for non msi-x interrupt handler/first msi-x
-	* interrupt handler
-	**/
-	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
-			(unsigned long)pm8001_ha);
+	/* Tasklet for non msi-x interrupt handler */
+	if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
+		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
+			(unsigned long)&(pm8001_ha->irq_vector[0]));
+	else
+		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
+			tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
+				(unsigned long)&(pm8001_ha->irq_vector[j]));
 #endif
 	pm8001_ioremap(pm8001_ha);
 	if (!pm8001_alloc(pm8001_ha, ent))
@@ -733,19 +732,20 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 			"pci_enable_msix request ret:%d no of intr %d\n",
 					rc, pm8001_ha->number_of_intr));
 
-		for (i = 0; i < number_of_intr; i++)
-			pm8001_ha->outq[i] = i;
 
 		for (i = 0; i < number_of_intr; i++) {
 			snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
 					DRV_NAME"%d", i);
+			pm8001_ha->irq_vector[i].irq_id = i;
+			pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
+
 			if (request_irq(pm8001_ha->msix_entries[i].vector,
 				pm8001_interrupt_handler_msix, flag,
-				intr_drvname[i], &pm8001_ha->outq[i])) {
+				intr_drvname[i], &(pm8001_ha->irq_vector[i]))) {
 				for (j = 0; j < i; j++)
 					free_irq(
 					pm8001_ha->msix_entries[j].vector,
-					&pm8001_ha->outq[j]);
+					&(pm8001_ha->irq_vector[i]));
 				pci_disable_msix(pm8001_ha->pdev);
 				break;
 			}
@@ -907,7 +907,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
-	int i;
+	int i, j;
 	pm8001_ha = sha->lldd_ha;
 	sas_unregister_ha(sha);
 	sas_remove_host(pm8001_ha->shost);
@@ -921,13 +921,18 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		free_irq(pm8001_ha->msix_entries[i].vector,
-				&pm8001_ha->outq[i]);
+				&(pm8001_ha->irq_vector[i]));
 	pci_disable_msix(pdev);
 #else
 	free_irq(pm8001_ha->irq, sha);
 #endif
 #ifdef PM8001_USE_TASKLET
-	tasklet_kill(&pm8001_ha->tasklet);
+	/* For non-msix and msix interrupts */
+	if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
+		tasklet_kill(&pm8001_ha->tasklet[0]);
+	else
+		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
+			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
 	pm8001_free(pm8001_ha);
 	kfree(sha->sas_phy);
@@ -948,7 +953,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
-	int i;
+	int  i, j;
 	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
 	flush_workqueue(pm8001_wq);
@@ -964,13 +969,18 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		free_irq(pm8001_ha->msix_entries[i].vector,
-				&pm8001_ha->outq[i]);
+				&(pm8001_ha->irq_vector[i]));
 	pci_disable_msix(pdev);
 #else
 	free_irq(pm8001_ha->irq, sha);
 #endif
 #ifdef PM8001_USE_TASKLET
-	tasklet_kill(&pm8001_ha->tasklet);
+	/* For non-msix and msix interrupts */
+	if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
+		tasklet_kill(&pm8001_ha->tasklet[0]);
+	else
+		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
+			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
 	device_state = pci_choose_state(pdev, state);
 	pm8001_printk("pdev=0x%p, slot=%s, entering "
@@ -993,7 +1003,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
-	u8 i = 0;
+	u8 i = 0, j;
 	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
 	device_state = pdev->current_state;
@@ -1033,10 +1043,14 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	if (rc)
 		goto err_out_disable;
 #ifdef PM8001_USE_TASKLET
-	/* default tasklet for non msi-x interrupt handler/first msi-x
-	* interrupt handler */
-	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
-			(unsigned long)pm8001_ha);
+	/*  Tasklet for non msi-x interrupt handler */
+	if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
+		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
+			(unsigned long)&(pm8001_ha->irq_vector[0]));
+	else
+		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
+			tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
+				(unsigned long)&(pm8001_ha->irq_vector[j]));
 #endif
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
 	if (pm8001_ha->chip_id != chip_8001) {
@@ -1169,6 +1183,7 @@ module_exit(pm8001_exit);
 MODULE_AUTHOR("Jack Wang <jack_wang@usish.com>");
 MODULE_AUTHOR("Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>");
 MODULE_AUTHOR("Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>");
+MODULE_AUTHOR("Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>");
 MODULE_DESCRIPTION(
 		"PMC-Sierra PM8001/8081/8088/8089/8074/8076/8077 "
 		"SAS/SATA controller driver");
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f4eb18e..f50ac44 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1098,15 +1098,17 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 	struct pm8001_tmf_task tmf_task;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 	struct pm8001_hba_info *pm8001_ha = pm8001_find_ha_by_dev(dev);
+	DECLARE_COMPLETION_ONSTACK(completion_setstate);
 	if (dev_is_sata(dev)) {
 		struct sas_phy *phy = sas_get_local_phy(dev);
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
 			dev, 1, 0);
 		rc = sas_phy_reset(phy, 1);
 		sas_put_local_phy(phy);
+		pm8001_dev->setds_completion = &completion_setstate;
 		rc = PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
 			pm8001_dev, 0x01);
-		msleep(2000);
+		wait_for_completion(&completion_setstate);
 	} else {
 		tmf_task.tmf = TMF_LU_RESET;
 		rc = pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 6037d47..6c5fd5e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -466,6 +466,10 @@ struct pm8001_hba_memspace {
 	u64			membase;
 	u32			memsize;
 };
+struct isr_param {
+	struct pm8001_hba_info *drv_inst;
+	u32 irq_id;
+};
 struct pm8001_hba_info {
 	char			name[PM8001_NAME_LENGTH];
 	struct list_head	list;
@@ -519,14 +523,13 @@ struct pm8001_hba_info {
 	int			number_of_intr;/*will be used in remove()*/
 #endif
 #ifdef PM8001_USE_TASKLET
-	struct tasklet_struct	tasklet;
+	struct tasklet_struct	tasklet[PM8001_MAX_MSIX_VEC];
 #endif
 	u32			logging_level;
 	u32			fw_status;
 	u32			smp_exp_mode;
-	u32			int_vector;
 	const struct firmware 	*fw_image;
-	u8			outq[PM8001_MAX_MSIX_VEC];
+	struct isr_param irq_vector[PM8001_MAX_MSIX_VEC];
 };
 
 struct pm8001_work {
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8987b17..c950dc5 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2894,6 +2894,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	unsigned long flags;
 	u8 deviceType = pPayload->sas_identify.dev_type;
 	port->port_state = portstate;
+	phy->phy_state = PHY_STATE_LINK_UP_SPCV;
 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
 		"portid:%d; phyid:%d; linkrate:%d; "
 		"portstate:%x; devicetype:%x\n",
@@ -2978,6 +2979,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				port_id, phy_id, link_rate, portstate));
 
 	port->port_state = portstate;
+	phy->phy_state = PHY_STATE_LINK_UP_SPCV;
 	port->port_attached = 1;
 	pm8001_get_lrate_mode(phy, link_rate);
 	phy->phy_type |= PORT_TYPE_SATA;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index c86816b..9970a38 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -215,6 +215,8 @@
 #define SAS_DOPNRJT_RTRY_TMO            128
 #define SAS_COPNRJT_RTRY_TMO            128
 
+/* for phy state */
+#define PHY_STATE_LINK_UP_SPCV		0x2
 /*
   Making ORR bigger than IT NEXUS LOSS which is 2000000us = 2 second.
   Assuming a bigger value 3 second, 3000000/128 = 23437.5 where 128
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bd6f743..f413ef7 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4315,6 +4315,7 @@ static struct scsi_host_template pmcraid_host_template = {
 	.this_id = -1,
 	.sg_tablesize = PMCRAID_MAX_IOADLS,
 	.max_sectors = PMCRAID_IOA_MAX_SECTORS,
+	.no_write_same = 1,
 	.cmd_per_lun = PMCRAID_MAX_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = pmcraid_host_attrs,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e6c4bff..69725f7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2659,6 +2659,12 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	struct scsi_device *sdev = sdkp->device;
 
+	if (sdev->host->no_write_same) {
+		sdev->no_write_same = 1;
+
+		return;
+	}
+
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
 		/* too large values might cause issues with arcmsr */
 		int vpd_buf_len = 64;
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 1a28f56..17d7404 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1697,6 +1697,7 @@ static struct scsi_host_template scsi_driver = {
 	.use_clustering =	DISABLE_CLUSTERING,
 	/* Make sure we dont get a sg segment crosses a page boundary */
 	.dma_boundary =		PAGE_SIZE-1,
+	.no_write_same =	1,
 };
 
 enum {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5460849..fe3b58e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -475,6 +475,9 @@ struct scsi_host_template {
 	 */
 	unsigned ordered_tag:1;
 
+	/* True if the controller does not support WRITE SAME */
+	unsigned no_write_same:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -677,6 +680,9 @@ struct Scsi_Host {
 	/* Don't resume host in EH */
 	unsigned eh_noresume:1;
 
+	/* The controller does not support WRITE SAME */
+	unsigned no_write_same:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */


