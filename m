From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/6] lpfc 8.3.19: Add SLI4 FC Discovery support
Date: Sat, 20 Nov 2010 23:11:48 -0500
Message-ID: <1290312708.32645.12.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23292 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752501Ab0KUEOi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Nov 2010 23:14:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add SLI4 FC Discovery support

- Replace READ_LA and READ_LA64 with READ_TOPOLOGY mailbox command.
- Converted the old READ_LA structure to use bf_set/get instead of bit fields.
- Rename HBA_FCOE_SUPPORT flag to HBA_FCOE_MODE. Flag now indicates function
  is running as SLI-4 FC or FCoE port. Make sure flag reset each time
  READ_REV completed as it can dynamically change.
- Removed BDE union in the READ_TOPOLOGY mailbox command and added a define to
  define the ALPA MAP SIZE. Added FC Code for async events.
- Added code to support new 16G link speed.
- Define new set of values to keep track of valid user settable link speeds.
- Used new link speed definitions to define link speed max and bitmap.
- Redefined FDMI Port sppeds to be hax values and added the 16G value.
- Added new CQE trailer code for FC Events.
- Add lpfc_issue_init_vfi and lpfc_init_vfi_cmpl routines.
- Replace many calls to the initial_flogi routine with lpfc_issue_init_vfi.
- Add vp and vpi fields to the INIT_VFI mailbox command.
- Addapt lpfc_hba_init_link routine for SLI4 use.
- Use lpfc_hba_init_link call from lpfc_sli4_hba_setup.
- Add a check for FC mode to register the FCFI before init link.
- Convert lpfc_sli4_init_vpi to be called without a vpi (get it from vport).


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |   19 +++++
 lpfc_attr.c    |   91 ++++++++++++--------------
 lpfc_bsg.c     |    5 -
 lpfc_crtn.h    |    5 -
 lpfc_ct.c      |   48 +++++++------
 lpfc_els.c     |   45 +++++++-----
 lpfc_hbadisc.c |  186 +++++++++++++++++++++++++++++++++++++----------------
 lpfc_hw.h      |  198 +++++++++++++++++++++++++++------------------------------
 lpfc_hw4.h     |    7 ++
 lpfc_init.c    |  137 ++++++++++++++++++++++-----------------
 lpfc_mbox.c    |   64 ++++++++++++------
 lpfc_sli.c     |   81 +++++++++++------------
 lpfc_sli4.h    |    2 
 lpfc_vport.c   |   10 +-
 14 files changed, 516 insertions(+), 382 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-11-19 16:10:35.000000000 -0500
@@ -52,10 +52,6 @@
 #define LPFC_MIN_DEVLOSS_TMO 1
 #define LPFC_MAX_DEVLOSS_TMO 255
 
-#define LPFC_MAX_LINK_SPEED 8
-#define LPFC_LINK_SPEED_BITMAP 0x00000117
-#define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8"
-
 /**
  * lpfc_jedec_to_ascii - Hex to ascii convertor according to JEDEC rules
  * @incr: integer to convert.
@@ -463,7 +459,7 @@ lpfc_link_state_show(struct device *dev,
 		if (phba->sli.sli_flag & LPFC_MENLO_MAINT)
 			len += snprintf(buf + len, PAGE_SIZE-len,
 					"   Menlo Maint Mode\n");
-		else if (phba->fc_topology == TOPOLOGY_LOOP) {
+		else if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 			if (vport->fc_flag & FC_PUBLIC_LOOP)
 				len += snprintf(buf + len, PAGE_SIZE-len,
 						"   Public Loop\n");
@@ -2837,14 +2833,8 @@ static struct bin_attribute sysfs_drvr_s
 /*
 # lpfc_link_speed: Link speed selection for initializing the Fibre Channel
 # connection.
-#       0  = auto select (default)
-#       1  = 1 Gigabaud
-#       2  = 2 Gigabaud
-#       4  = 4 Gigabaud
-#       8  = 8 Gigabaud
-# Value range is [0,8]. Default value is 0.
+# Value range is [0,16]. Default value is 0.
 */
-
 /**
  * lpfc_link_speed_set - Set the adapters link speed
  * @phba: lpfc_hba pointer.
@@ -2869,7 +2859,7 @@ lpfc_link_speed_store(struct device *dev
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	int val = 0;
+	int val = LPFC_USER_LINK_SPEED_AUTO;
 	int nolip = 0;
 	const char *val_buf = buf;
 	int err;
@@ -2885,15 +2875,20 @@ lpfc_link_speed_store(struct device *dev
 	if (sscanf(val_buf, "%i", &val) != 1)
 		return -EINVAL;
 
-	if (((val == LINK_SPEED_1G) && !(phba->lmt & LMT_1Gb)) ||
-		((val == LINK_SPEED_2G) && !(phba->lmt & LMT_2Gb)) ||
-		((val == LINK_SPEED_4G) && !(phba->lmt & LMT_4Gb)) ||
-		((val == LINK_SPEED_8G) && !(phba->lmt & LMT_8Gb)) ||
-		((val == LINK_SPEED_10G) && !(phba->lmt & LMT_10Gb)))
+	if (((val == LPFC_USER_LINK_SPEED_1G) && !(phba->lmt & LMT_1Gb)) ||
+	    ((val == LPFC_USER_LINK_SPEED_2G) && !(phba->lmt & LMT_2Gb)) ||
+	    ((val == LPFC_USER_LINK_SPEED_4G) && !(phba->lmt & LMT_4Gb)) ||
+	    ((val == LPFC_USER_LINK_SPEED_8G) && !(phba->lmt & LMT_8Gb)) ||
+	    ((val == LPFC_USER_LINK_SPEED_10G) && !(phba->lmt & LMT_10Gb)) ||
+	    ((val == LPFC_USER_LINK_SPEED_16G) && !(phba->lmt & LMT_16Gb))) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2879 lpfc_link_speed attribute cannot be set "
+				"to %d. Speed is not supported by this port.\n",
+				val);
 		return -EINVAL;
-
-	if ((val >= 0 && val <= 8)
-		&& (LPFC_LINK_SPEED_BITMAP & (1 << val))) {
+	}
+	if ((val >= 0) && (val <= LPFC_USER_LINK_SPEED_MAX) &&
+	    (LPFC_USER_LINK_SPEED_BITMAP & (1 << val))) {
 		prev_val = phba->cfg_link_speed;
 		phba->cfg_link_speed = val;
 		if (nolip)
@@ -2906,11 +2901,9 @@ lpfc_link_speed_store(struct device *dev
 		} else
 			return strlen(buf);
 	}
-
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-		"%d:0469 lpfc_link_speed attribute cannot be set to %d, "
-		"allowed range is [0, 8]\n",
-		phba->brd_no, val);
+		"0469 lpfc_link_speed attribute cannot be set to %d, "
+		"allowed values are ["LPFC_LINK_SPEED_STRING"]\n", val);
 	return -EINVAL;
 }
 
@@ -2938,8 +2931,8 @@ lpfc_param_show(link_speed)
 static int
 lpfc_link_speed_init(struct lpfc_hba *phba, int val)
 {
-	if ((val >= 0 && val <= LPFC_MAX_LINK_SPEED)
-		&& (LPFC_LINK_SPEED_BITMAP & (1 << val))) {
+	if ((val >= 0) && (val <= LPFC_USER_LINK_SPEED_MAX) &&
+	    (LPFC_USER_LINK_SPEED_BITMAP & (1 << val))) {
 		phba->cfg_link_speed = val;
 		return 0;
 	}
@@ -2947,12 +2940,12 @@ lpfc_link_speed_init(struct lpfc_hba *ph
 			"0405 lpfc_link_speed attribute cannot "
 			"be set to %d, allowed values are "
 			"["LPFC_LINK_SPEED_STRING"]\n", val);
-	phba->cfg_link_speed = 0;
+	phba->cfg_link_speed = LPFC_USER_LINK_SPEED_AUTO;
 	return -EINVAL;
 }
 
 static DEVICE_ATTR(lpfc_link_speed, S_IRUGO | S_IWUSR,
-		lpfc_link_speed_show, lpfc_link_speed_store);
+		   lpfc_link_speed_show, lpfc_link_speed_store);
 
 /*
 # lpfc_aer_support: Support PCIe device Advanced Error Reporting (AER)
@@ -3798,8 +3791,7 @@ sysfs_mbox_read(struct file *filp, struc
 			}
 			break;
 		case MBX_READ_SPARM64:
-		case MBX_READ_LA:
-		case MBX_READ_LA64:
+		case MBX_READ_TOPOLOGY:
 		case MBX_REG_LOGIN:
 		case MBX_REG_LOGIN64:
 		case MBX_CONFIG_PORT:
@@ -3989,7 +3981,7 @@ lpfc_get_host_port_type(struct Scsi_Host
 	if (vport->port_type == LPFC_NPIV_PORT) {
 		fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
 	} else if (lpfc_is_link_up(phba)) {
-		if (phba->fc_topology == TOPOLOGY_LOOP) {
+		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 			if (vport->fc_flag & FC_PUBLIC_LOOP)
 				fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
 			else
@@ -4058,23 +4050,26 @@ lpfc_get_host_speed(struct Scsi_Host *sh
 
 	if (lpfc_is_link_up(phba)) {
 		switch(phba->fc_linkspeed) {
-			case LA_1GHZ_LINK:
-				fc_host_speed(shost) = FC_PORTSPEED_1GBIT;
+		case LPFC_LINK_SPEED_1GHZ:
+			fc_host_speed(shost) = FC_PORTSPEED_1GBIT;
 			break;
-			case LA_2GHZ_LINK:
-				fc_host_speed(shost) = FC_PORTSPEED_2GBIT;
+		case LPFC_LINK_SPEED_2GHZ:
+			fc_host_speed(shost) = FC_PORTSPEED_2GBIT;
 			break;
-			case LA_4GHZ_LINK:
-				fc_host_speed(shost) = FC_PORTSPEED_4GBIT;
+		case LPFC_LINK_SPEED_4GHZ:
+			fc_host_speed(shost) = FC_PORTSPEED_4GBIT;
 			break;
-			case LA_8GHZ_LINK:
-				fc_host_speed(shost) = FC_PORTSPEED_8GBIT;
+		case LPFC_LINK_SPEED_8GHZ:
+			fc_host_speed(shost) = FC_PORTSPEED_8GBIT;
 			break;
-			case LA_10GHZ_LINK:
-				fc_host_speed(shost) = FC_PORTSPEED_10GBIT;
+		case LPFC_LINK_SPEED_10GHZ:
+			fc_host_speed(shost) = FC_PORTSPEED_10GBIT;
 			break;
-			default:
-				fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
+		case LPFC_LINK_SPEED_16GHZ:
+			fc_host_speed(shost) = FC_PORTSPEED_16GBIT;
+			break;
+		default:
+			fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 			break;
 		}
 	} else
@@ -4097,7 +4092,7 @@ lpfc_get_host_fabric_name (struct Scsi_H
 	spin_lock_irq(shost->host_lock);
 
 	if ((vport->fc_flag & FC_FABRIC) ||
-	    ((phba->fc_topology == TOPOLOGY_LOOP) &&
+	    ((phba->fc_topology == LPFC_TOPOLOGY_LOOP) &&
 	     (vport->fc_flag & FC_PUBLIC_LOOP)))
 		node_name = wwn_to_u64(phba->fc_fabparam.nodeName.u.wwn);
 	else
@@ -4208,11 +4203,11 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	hs->invalid_crc_count -= lso->invalid_crc_count;
 	hs->error_frames -= lso->error_frames;
 
-	if (phba->hba_flag & HBA_FCOE_SUPPORT) {
+	if (phba->hba_flag & HBA_FCOE_MODE) {
 		hs->lip_count = -1;
 		hs->nos_count = (phba->link_events >> 1);
 		hs->nos_count -= lso->link_events;
-	} else if (phba->fc_topology == TOPOLOGY_LOOP) {
+	} else if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 		hs->lip_count = (phba->fc_eventTag >> 1);
 		hs->lip_count -= lso->link_events;
 		hs->nos_count = -1;
@@ -4303,7 +4298,7 @@ lpfc_reset_stats(struct Scsi_Host *shost
 	lso->invalid_tx_word_count = pmb->un.varRdLnk.invalidXmitWord;
 	lso->invalid_crc_count = pmb->un.varRdLnk.crcCnt;
 	lso->error_frames = pmb->un.varRdLnk.crcCnt;
-	if (phba->hba_flag & HBA_FCOE_SUPPORT)
+	if (phba->hba_flag & HBA_FCOE_MODE)
 		lso->link_events = (phba->link_events >> 1);
 	else
 		lso->link_events = (phba->fc_eventTag >> 1);
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-11-19 16:08:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-11-19 16:10:35.000000000 -0500
@@ -2601,12 +2601,11 @@ static int lpfc_bsg_check_cmd_access(str
 			phba->wait_4_mlo_maint_flg = 1;
 		} else if (mb->un.varWords[0] == SETVAR_MLORST) {
 			phba->link_flag &= ~LS_LOOPBACK_MODE;
-			phba->fc_topology = TOPOLOGY_PT_PT;
+			phba->fc_topology = LPFC_TOPOLOGY_PT_PT;
 		}
 		break;
 	case MBX_READ_SPARM64:
-	case MBX_READ_LA:
-	case MBX_READ_LA64:
+	case MBX_READ_TOPOLOGY:
 	case MBX_REG_LOGIN:
 	case MBX_REG_LOGIN64:
 	case MBX_CONFIG_PORT:
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-11-19 16:10:35.000000000 -0500
@@ -31,7 +31,7 @@ void lpfc_read_nv(struct lpfc_hba *, LPF
 void lpfc_config_async(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 
 void lpfc_heart_beat(struct lpfc_hba *, LPFC_MBOXQ_t *);
-int lpfc_read_la(struct lpfc_hba *, LPFC_MBOXQ_t *, struct lpfc_dmabuf *);
+int lpfc_read_topology(struct lpfc_hba *, LPFC_MBOXQ_t *, struct lpfc_dmabuf *);
 void lpfc_clear_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_issue_clear_la(struct lpfc_hba *, struct lpfc_vport *);
 void lpfc_config_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
@@ -64,7 +64,7 @@ void lpfc_cleanup_pending_mbox(struct lp
 int lpfc_linkdown(struct lpfc_hba *);
 void lpfc_linkdown_port(struct lpfc_vport *);
 void lpfc_port_link_failure(struct lpfc_vport *);
-void lpfc_mbx_cmpl_read_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_mbx_cmpl_read_topology(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_init_vpi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_cancel_all_vport_retry_delay_timer(struct lpfc_hba *);
 void lpfc_retry_pport_discovery(struct lpfc_hba *);
@@ -121,6 +121,7 @@ void lpfc_end_rscn(struct lpfc_vport *);
 int lpfc_els_chk_latt(struct lpfc_vport *);
 int lpfc_els_abort_flogi(struct lpfc_hba *);
 int lpfc_initial_flogi(struct lpfc_vport *);
+void lpfc_issue_init_vfi(struct lpfc_vport *);
 int lpfc_initial_fdisc(struct lpfc_vport *);
 int lpfc_issue_els_plogi(struct lpfc_vport *, uint32_t, uint8_t);
 int lpfc_issue_els_prli(struct lpfc_vport *, struct lpfc_nodelist *, uint8_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2010-11-19 16:10:35.000000000 -0500
@@ -48,14 +48,14 @@
 #include "lpfc_vport.h"
 #include "lpfc_debugfs.h"
 
-#define HBA_PORTSPEED_UNKNOWN               0	/* Unknown - transceiver
-						 * incapable of reporting */
-#define HBA_PORTSPEED_1GBIT                 1	/* 1 GBit/sec */
-#define HBA_PORTSPEED_2GBIT                 2	/* 2 GBit/sec */
-#define HBA_PORTSPEED_4GBIT                 8   /* 4 GBit/sec */
-#define HBA_PORTSPEED_8GBIT                16   /* 8 GBit/sec */
-#define HBA_PORTSPEED_10GBIT                4	/* 10 GBit/sec */
-#define HBA_PORTSPEED_NOT_NEGOTIATED        5	/* Speed not established */
+/* FDMI Port Speed definitions */
+#define HBA_PORTSPEED_1GBIT		0x0001	/* 1 GBit/sec */
+#define HBA_PORTSPEED_2GBIT		0x0002	/* 2 GBit/sec */
+#define HBA_PORTSPEED_4GBIT		0x0008	/* 4 GBit/sec */
+#define HBA_PORTSPEED_10GBIT		0x0004	/* 10 GBit/sec */
+#define HBA_PORTSPEED_8GBIT		0x0010	/* 8 GBit/sec */
+#define HBA_PORTSPEED_16GBIT		0x0020	/* 16 GBit/sec */
+#define HBA_PORTSPEED_UNKNOWN		0x0800	/* Unknown */
 
 #define FOURBYTES	4
 
@@ -1593,8 +1593,10 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, 
 			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + 4);
 
 			ae->un.SupportSpeed = 0;
+			if (phba->lmt & LMT_16Gb)
+				ae->un.SupportSpeed |= HBA_PORTSPEED_16GBIT;
 			if (phba->lmt & LMT_10Gb)
-				ae->un.SupportSpeed = HBA_PORTSPEED_10GBIT;
+				ae->un.SupportSpeed |= HBA_PORTSPEED_10GBIT;
 			if (phba->lmt & LMT_8Gb)
 				ae->un.SupportSpeed |= HBA_PORTSPEED_8GBIT;
 			if (phba->lmt & LMT_4Gb)
@@ -1612,24 +1614,26 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, 
 			ae->ad.bits.AttrType = be16_to_cpu(PORT_SPEED);
 			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + 4);
 			switch(phba->fc_linkspeed) {
-				case LA_1GHZ_LINK:
-					ae->un.PortSpeed = HBA_PORTSPEED_1GBIT;
+			case LPFC_LINK_SPEED_1GHZ:
+				ae->un.PortSpeed = HBA_PORTSPEED_1GBIT;
 				break;
-				case LA_2GHZ_LINK:
-					ae->un.PortSpeed = HBA_PORTSPEED_2GBIT;
+			case LPFC_LINK_SPEED_2GHZ:
+				ae->un.PortSpeed = HBA_PORTSPEED_2GBIT;
 				break;
-				case LA_4GHZ_LINK:
-					ae->un.PortSpeed = HBA_PORTSPEED_4GBIT;
+			case LPFC_LINK_SPEED_4GHZ:
+				ae->un.PortSpeed = HBA_PORTSPEED_4GBIT;
 				break;
-				case LA_8GHZ_LINK:
-					ae->un.PortSpeed = HBA_PORTSPEED_8GBIT;
+			case LPFC_LINK_SPEED_8GHZ:
+				ae->un.PortSpeed = HBA_PORTSPEED_8GBIT;
 				break;
-				case LA_10GHZ_LINK:
-					ae->un.PortSpeed = HBA_PORTSPEED_10GBIT;
+			case LPFC_LINK_SPEED_10GHZ:
+				ae->un.PortSpeed = HBA_PORTSPEED_10GBIT;
 				break;
-				default:
-					ae->un.PortSpeed =
-						HBA_PORTSPEED_UNKNOWN;
+			case LPFC_LINK_SPEED_16GHZ:
+				ae->un.PortSpeed = HBA_PORTSPEED_16GBIT;
+				break;
+			default:
+				ae->un.PortSpeed = HBA_PORTSPEED_UNKNOWN;
 				break;
 			}
 			pab->ab.EntryCnt++;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-11-19 16:08:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-11-19 16:10:35.000000000 -0500
@@ -523,7 +523,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 	phba->fc_edtovResol = sp->cmn.edtovResolution;
 	phba->fc_ratov = (be32_to_cpu(sp->cmn.w2.r_a_tov) + 999) / 1000;
 
-	if (phba->fc_topology == TOPOLOGY_LOOP) {
+	if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_PUBLIC_LOOP;
 		spin_unlock_irq(shost->host_lock);
@@ -832,6 +832,12 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
 			goto out;
 
+		/* FLOGI failure */
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "0100 FLOGI failure Status:x%x/x%x TMO:x%x\n",
+				 irsp->ulpStatus, irsp->un.ulpWord[4],
+				 irsp->ulpTimeout);
+
 		/* FLOGI failed, so there is no fabric */
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
@@ -843,13 +849,16 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		 */
 		if (phba->alpa_map[0] == 0) {
 			vport->cfg_discovery_threads = LPFC_MAX_DISC_THREADS;
+			if ((phba->sli_rev == LPFC_SLI_REV4) &&
+			    (!(vport->fc_flag & FC_VFI_REGISTERED) ||
+			     (vport->fc_prevDID != vport->fc_myDID))) {
+				if (vport->fc_flag & FC_VFI_REGISTERED)
+					lpfc_sli4_unreg_all_rpis(vport);
+				lpfc_issue_reg_vfi(vport);
+				lpfc_nlp_put(ndlp);
+				goto out;
+			}
 		}
-
-		/* FLOGI failure */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				 "0100 FLOGI failure Status:x%x/x%x TMO:x%x\n",
-				 irsp->ulpStatus, irsp->un.ulpWord[4],
-				 irsp->ulpTimeout);
 		goto flogifail;
 	}
 	spin_lock_irq(shost->host_lock);
@@ -879,7 +888,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		 */
 		if (sp->cmn.fPort)
 			rc = lpfc_cmpl_els_flogi_fabric(vport, ndlp, sp, irsp);
-		else if (!(phba->hba_flag & HBA_FCOE_SUPPORT))
+		else if (!(phba->hba_flag & HBA_FCOE_MODE))
 			rc = lpfc_cmpl_els_flogi_nport(vport, ndlp, sp);
 		else {
 			lpfc_printf_vlog(vport, KERN_ERR,
@@ -1027,7 +1036,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *
 		icmd->ulpCt_l = 0;
 	}
 
-	if (phba->fc_topology != TOPOLOGY_LOOP) {
+	if (phba->fc_topology != LPFC_TOPOLOGY_LOOP) {
 		icmd->un.elsreq64.myID = 0;
 		icmd->un.elsreq64.fl = 1;
 	}
@@ -2722,7 +2731,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 			if (cmd == ELS_CMD_FLOGI) {
 				if (PCI_DEVICE_ID_HORNET ==
 					phba->pcidev->device) {
-					phba->fc_topology = TOPOLOGY_LOOP;
+					phba->fc_topology = LPFC_TOPOLOGY_LOOP;
 					phba->pport->fc_myDID = 0;
 					phba->alpa_map[0] = 0;
 					phba->alpa_map[1] = 0;
@@ -2877,7 +2886,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 		retry = 1;
 
 	if (((cmd == ELS_CMD_FLOGI) || (cmd == ELS_CMD_FDISC)) &&
-	    (phba->fc_topology != TOPOLOGY_LOOP) &&
+	    (phba->fc_topology != LPFC_TOPOLOGY_LOOP) &&
 	    !lpfc_error_lost_link(irsp)) {
 		/* FLOGI retry policy */
 		retry = 1;
@@ -4597,7 +4606,7 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vp
 
 	lpfc_set_disctmo(vport);
 
-	if (phba->fc_topology == TOPOLOGY_LOOP) {
+	if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 		/* We should never receive a FLOGI in loop mode, ignore it */
 		did = icmd->un.elsreq64.remoteID;
 
@@ -4940,7 +4949,7 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *ph
 	pcmd += sizeof(uint32_t); /* Skip past command */
 	rps_rsp = (RPS_RSP *)pcmd;
 
-	if (phba->fc_topology != TOPOLOGY_LOOP)
+	if (phba->fc_topology != LPFC_TOPOLOGY_LOOP)
 		status = 0x10;
 	else
 		status = 0x8;
@@ -5482,7 +5491,7 @@ lpfc_els_rcv_fan(struct lpfc_vport *vpor
 		    (memcmp(&phba->fc_fabparam.portName, &fp->FportName,
 			    sizeof(struct lpfc_name)))) {
 			/* This port has switched fabrics. FLOGI is required */
-			lpfc_initial_flogi(vport);
+			lpfc_issue_init_vfi(vport);
 		} else {
 			/* FAN verified - skip FLOGI */
 			vport->fc_myDID = vport->fc_prevDID;
@@ -6373,7 +6382,7 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 	if (!ndlp) {
 		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
 		if (!ndlp) {
-			if (phba->fc_topology == TOPOLOGY_LOOP) {
+			if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 				lpfc_disc_start(vport);
 				return;
 			}
@@ -6386,7 +6395,7 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
 		if (!ndlp) {
-			if (phba->fc_topology == TOPOLOGY_LOOP) {
+			if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 				lpfc_disc_start(vport);
 				return;
 			}
@@ -6510,7 +6519,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 			spin_unlock_irq(shost->host_lock);
 			if (vport->port_type == LPFC_PHYSICAL_PORT
 				&& !(vport->fc_flag & FC_LOGO_RCVD_DID_CHNG))
-				lpfc_initial_flogi(vport);
+				lpfc_issue_init_vfi(vport);
 			else
 				lpfc_initial_fdisc(vport);
 			break;
@@ -6747,7 +6756,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 	vport->fc_flag &= ~FC_VPORT_CVL_RCVD;
 	vport->fc_flag &= ~FC_VPORT_LOGO_RCVD;
 	vport->fc_flag |= FC_FABRIC;
-	if (vport->phba->fc_topology == TOPOLOGY_LOOP)
+	if (vport->phba->fc_topology == LPFC_TOPOLOGY_LOOP)
 		vport->fc_flag |=  FC_PUBLIC_LOOP;
 	spin_unlock_irq(shost->host_lock);
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2010-11-19 16:10:35.000000000 -0500
@@ -464,6 +464,23 @@ struct unsol_rcv_ct_ctx {
 #define UNSOL_VALID	0x00000001
 };
 
+#define LPFC_USER_LINK_SPEED_AUTO	0	/* auto select (default)*/
+#define LPFC_USER_LINK_SPEED_1G		1	/* 1 Gigabaud */
+#define LPFC_USER_LINK_SPEED_2G		2	/* 2 Gigabaud */
+#define LPFC_USER_LINK_SPEED_4G		4	/* 4 Gigabaud */
+#define LPFC_USER_LINK_SPEED_8G		8	/* 8 Gigabaud */
+#define LPFC_USER_LINK_SPEED_10G	10	/* 10 Gigabaud */
+#define LPFC_USER_LINK_SPEED_16G	16	/* 16 Gigabaud */
+#define LPFC_USER_LINK_SPEED_MAX	LPFC_USER_LINK_SPEED_16G
+#define LPFC_USER_LINK_SPEED_BITMAP ((1 << LPFC_USER_LINK_SPEED_16G) | \
+				     (1 << LPFC_USER_LINK_SPEED_10G) | \
+				     (1 << LPFC_USER_LINK_SPEED_8G) | \
+				     (1 << LPFC_USER_LINK_SPEED_4G) | \
+				     (1 << LPFC_USER_LINK_SPEED_2G) | \
+				     (1 << LPFC_USER_LINK_SPEED_1G) | \
+				     (1 << LPFC_USER_LINK_SPEED_AUTO))
+#define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8, 10, 16"
+
 struct lpfc_hba {
 	/* SCSI interface function jump table entries */
 	int (*lpfc_new_scsi_buf)
@@ -545,7 +562,7 @@ struct lpfc_hba {
 	uint32_t hba_flag;	/* hba generic flags */
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
 #define DEFER_ERATT		0x2 /* Deferred error attention in progress */
-#define HBA_FCOE_SUPPORT	0x4 /* HBA function supports FCOE */
+#define HBA_FCOE_MODE		0x4 /* HBA function in FCoE Mode */
 #define HBA_SP_QUEUE_EVT	0x8 /* Slow-path qevt posted to worker thread*/
 #define HBA_POST_RECEIVE_BUFFER 0x10 /* Rcv buffers need to be posted */
 #define FCP_XRI_ABORT_EVENT	0x20
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-11-19 16:08:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-11-19 16:10:35.000000000 -0500
@@ -1064,7 +1064,7 @@ lpfc_mbx_cmpl_local_config_link(struct l
 
 	mempool_free(pmb, phba->mbox_mem_pool);
 
-	if (phba->fc_topology == TOPOLOGY_LOOP &&
+	if (phba->fc_topology == LPFC_TOPOLOGY_LOOP &&
 	    vport->fc_flag & FC_PUBLIC_LOOP &&
 	    !(vport->fc_flag & FC_LBIT)) {
 			/* Need to wait for FAN - use discovery timer
@@ -1078,9 +1078,8 @@ lpfc_mbx_cmpl_local_config_link(struct l
 	/* Start discovery by sending a FLOGI. port_state is identically
 	 * LPFC_FLOGI while waiting for FLOGI cmpl
 	 */
-	if (vport->port_state != LPFC_FLOGI) {
+	if (vport->port_state != LPFC_FLOGI)
 		lpfc_initial_flogi(vport);
-	}
 	return;
 
 out:
@@ -1131,7 +1130,7 @@ lpfc_mbx_cmpl_reg_fcfi(struct lpfc_hba *
 	if (vport->port_state != LPFC_FLOGI) {
 		phba->hba_flag |= FCF_RR_INPROG;
 		spin_unlock_irq(&phba->hbalock);
-		lpfc_initial_flogi(vport);
+		lpfc_issue_init_vfi(vport);
 		goto out;
 	}
 	spin_unlock_irq(&phba->hbalock);
@@ -1353,7 +1352,7 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 		if (phba->pport->port_state != LPFC_FLOGI) {
 			phba->hba_flag |= FCF_RR_INPROG;
 			spin_unlock_irq(&phba->hbalock);
-			lpfc_initial_flogi(phba->pport);
+			lpfc_issue_init_vfi(phba->pport);
 			return;
 		}
 		spin_unlock_irq(&phba->hbalock);
@@ -2331,7 +2330,7 @@ lpfc_mbx_cmpl_fcf_rr_read_fcf_rec(struct
 				phba->fcf.current_rec.fcf_indx, fcf_index);
 		/* Wait 500 ms before retrying FLOGI to current FCF */
 		msleep(500);
-		lpfc_initial_flogi(phba->pport);
+		lpfc_issue_init_vfi(phba->pport);
 		goto out;
 	}
 
@@ -2422,6 +2421,63 @@ out:
 }
 
 /**
+ * lpfc_init_vfi_cmpl - Completion handler for init_vfi mbox command.
+ * @phba: pointer to lpfc hba data structure.
+ * @mboxq: pointer to mailbox data structure.
+ *
+ * This function handles completion of init vfi mailbox command.
+ */
+void
+lpfc_init_vfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	struct lpfc_vport *vport = mboxq->vport;
+
+	if (mboxq->u.mb.mbxStatus && (mboxq->u.mb.mbxStatus != 0x4002)) {
+		lpfc_printf_vlog(vport, KERN_ERR,
+				LOG_MBOX,
+				"2891 Init VFI mailbox failed 0x%x\n",
+				mboxq->u.mb.mbxStatus);
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+		return;
+	}
+	lpfc_initial_flogi(vport);
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return;
+}
+
+/**
+ * lpfc_issue_init_vfi - Issue init_vfi mailbox command.
+ * @vport: pointer to lpfc_vport data structure.
+ *
+ * This function issue a init_vfi mailbox command to initialize the VFI and
+ * VPI for the physical port.
+ */
+void
+lpfc_issue_init_vfi(struct lpfc_vport *vport)
+{
+	LPFC_MBOXQ_t *mboxq;
+	int rc;
+	struct lpfc_hba *phba = vport->phba;
+
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_vlog(vport, KERN_ERR,
+			LOG_MBOX, "2892 Failed to allocate "
+			"init_vfi mailbox\n");
+		return;
+	}
+	lpfc_init_vfi(mboxq, vport);
+	mboxq->mbox_cmpl = lpfc_init_vfi_cmpl;
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED) {
+		lpfc_printf_vlog(vport, KERN_ERR,
+			LOG_MBOX, "2893 Failed to issue init_vfi mailbox\n");
+		mempool_free(mboxq, vport->phba->mbox_mem_pool);
+	}
+}
+
+/**
  * lpfc_init_vpi_cmpl - Completion handler for init_vpi mbox command.
  * @phba: pointer to lpfc hba data structure.
  * @mboxq: pointer to mailbox data structure.
@@ -2528,7 +2584,7 @@ lpfc_start_fdiscs(struct lpfc_hba *phba)
 						     FC_VPORT_FAILED);
 				continue;
 			}
-			if (phba->fc_topology == TOPOLOGY_LOOP) {
+			if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 				lpfc_vport_set_state(vports[i],
 						     FC_VPORT_LINKDOWN);
 				continue;
@@ -2564,7 +2620,7 @@ lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *p
 			 "2018 REG_VFI mbxStatus error x%x "
 			 "HBA state x%x\n",
 			 mboxq->u.mb.mbxStatus, vport->port_state);
-		if (phba->fc_topology == TOPOLOGY_LOOP) {
+		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 			/* FLOGI failed, use loop map to make discovery list */
 			lpfc_disc_list_loopmap(vport);
 			/* Start discovery */
@@ -2582,8 +2638,18 @@ lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *p
 	spin_unlock_irq(shost->host_lock);
 
 	if (vport->port_state == LPFC_FABRIC_CFG_LINK) {
-		lpfc_start_fdiscs(phba);
-		lpfc_do_scr_ns_plogi(phba, vport);
+		/* For private loop just start discovery and we are done. */
+		if ((phba->fc_topology == LPFC_TOPOLOGY_LOOP) &&
+		    (phba->alpa_map[0] == 0) &&
+		    !(vport->fc_flag & FC_PUBLIC_LOOP)) {
+			/* Use loop map to make discovery list */
+			lpfc_disc_list_loopmap(vport);
+			/* Start discovery */
+			lpfc_disc_start(vport);
+		} else {
+			lpfc_start_fdiscs(phba);
+			lpfc_do_scr_ns_plogi(phba, vport);
+		}
 	}
 
 fail_free_mem:
@@ -2644,7 +2710,7 @@ out:
 }
 
 static void
-lpfc_mbx_process_link_up(struct lpfc_hba *phba, READ_LA_VAR *la)
+lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 {
 	struct lpfc_vport *vport = phba->pport;
 	LPFC_MBOXQ_t *sparam_mbox, *cfglink_mbox = NULL;
@@ -2654,31 +2720,24 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	struct fcf_record *fcf_record;
 
 	spin_lock_irq(&phba->hbalock);
-	switch (la->UlnkSpeed) {
-	case LA_1GHZ_LINK:
-		phba->fc_linkspeed = LA_1GHZ_LINK;
-		break;
-	case LA_2GHZ_LINK:
-		phba->fc_linkspeed = LA_2GHZ_LINK;
-		break;
-	case LA_4GHZ_LINK:
-		phba->fc_linkspeed = LA_4GHZ_LINK;
-		break;
-	case LA_8GHZ_LINK:
-		phba->fc_linkspeed = LA_8GHZ_LINK;
-		break;
-	case LA_10GHZ_LINK:
-		phba->fc_linkspeed = LA_10GHZ_LINK;
+	switch (bf_get(lpfc_mbx_read_top_link_spd, la)) {
+	case LPFC_LINK_SPEED_1GHZ:
+	case LPFC_LINK_SPEED_2GHZ:
+	case LPFC_LINK_SPEED_4GHZ:
+	case LPFC_LINK_SPEED_8GHZ:
+	case LPFC_LINK_SPEED_10GHZ:
+	case LPFC_LINK_SPEED_16GHZ:
+		phba->fc_linkspeed = bf_get(lpfc_mbx_read_top_link_spd, la);
 		break;
 	default:
-		phba->fc_linkspeed = LA_UNKNW_LINK;
+		phba->fc_linkspeed = LPFC_LINK_SPEED_UNKNOWN;
 		break;
 	}
 
-	phba->fc_topology = la->topology;
+	phba->fc_topology = bf_get(lpfc_mbx_read_top_topology, la);
 	phba->link_flag &= ~LS_NPIV_FAB_SUPPORTED;
 
-	if (phba->fc_topology == TOPOLOGY_LOOP) {
+	if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 		phba->sli3_options &= ~LPFC_SLI3_NPIV_ENABLED;
 
 		/* if npiv is enabled and this adapter supports npiv log
@@ -2689,11 +2748,11 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 				"1309 Link Up Event npiv not supported in loop "
 				"topology\n");
 				/* Get Loop Map information */
-		if (la->il)
+		if (bf_get(lpfc_mbx_read_top_il, la))
 			vport->fc_flag |= FC_LBIT;
 
-		vport->fc_myDID = la->granted_AL_PA;
-		i = la->un.lilpBde64.tus.f.bdeSize;
+		vport->fc_myDID = bf_get(lpfc_mbx_read_top_alpa_granted, la);
+		i = la->lilpBde64.tus.f.bdeSize;
 
 		if (i == 0) {
 			phba->alpa_map[0] = 0;
@@ -2764,7 +2823,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		goto out;
 	}
 
-	if (!(phba->hba_flag & HBA_FCOE_SUPPORT)) {
+	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
 		cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (!cfglink_mbox)
 			goto out;
@@ -2874,17 +2933,17 @@ lpfc_mbx_issue_link_down(struct lpfc_hba
 

 /*
- * This routine handles processing a READ_LA mailbox
+ * This routine handles processing a READ_TOPOLOGY mailbox
  * command upon completion. It is setup in the LPFC_MBOXQ
  * as the completion routine when the command is
  * handed off to the SLI layer.
  */
 void
-lpfc_mbx_cmpl_read_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-	READ_LA_VAR *la;
+	struct lpfc_mbx_read_top *la;
 	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 
@@ -2897,15 +2956,15 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 				mb->mbxStatus, vport->port_state);
 		lpfc_mbx_issue_link_down(phba);
 		phba->link_state = LPFC_HBA_ERROR;
-		goto lpfc_mbx_cmpl_read_la_free_mbuf;
+		goto lpfc_mbx_cmpl_read_topology_free_mbuf;
 	}
 
-	la = (READ_LA_VAR *) &pmb->u.mb.un.varReadLA;
+	la = (struct lpfc_mbx_read_top *) &pmb->u.mb.un.varReadTop;
 
 	memcpy(&phba->alpa_map[0], mp->virt, 128);
 
 	spin_lock_irq(shost->host_lock);
-	if (la->pb)
+	if (bf_get(lpfc_mbx_read_top_pb, la))
 		vport->fc_flag |= FC_BYPASSED_MODE;
 	else
 		vport->fc_flag &= ~FC_BYPASSED_MODE;
@@ -2914,41 +2973,48 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 	if ((phba->fc_eventTag  < la->eventTag) ||
 	    (phba->fc_eventTag == la->eventTag)) {
 		phba->fc_stat.LinkMultiEvent++;
-		if (la->attType == AT_LINK_UP)
+		if (bf_get(lpfc_mbx_read_top_att_type, la) == LPFC_ATT_LINK_UP)
 			if (phba->fc_eventTag != 0)
 				lpfc_linkdown(phba);
 	}
 
 	phba->fc_eventTag = la->eventTag;
 	spin_lock_irq(&phba->hbalock);
-	if (la->mm)
+	if (bf_get(lpfc_mbx_read_top_mm, la))
 		phba->sli.sli_flag |= LPFC_MENLO_MAINT;
 	else
 		phba->sli.sli_flag &= ~LPFC_MENLO_MAINT;
 	spin_unlock_irq(&phba->hbalock);
 
 	phba->link_events++;
-	if (la->attType == AT_LINK_UP && (!la->mm)) {
+	if ((bf_get(lpfc_mbx_read_top_att_type, la) == LPFC_ATT_LINK_UP) &&
+	    (!bf_get(lpfc_mbx_read_top_mm, la))) {
 		phba->fc_stat.LinkUp++;
 		if (phba->link_flag & LS_LOOPBACK_MODE) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 					"1306 Link Up Event in loop back mode "
 					"x%x received Data: x%x x%x x%x x%x\n",
 					la->eventTag, phba->fc_eventTag,
-					la->granted_AL_PA, la->UlnkSpeed,
+					bf_get(lpfc_mbx_read_top_alpa_granted,
+					       la),
+					bf_get(lpfc_mbx_read_top_link_spd, la),
 					phba->alpa_map[0]);
 		} else {
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 					"1303 Link Up Event x%x received "
 					"Data: x%x x%x x%x x%x x%x x%x %d\n",
 					la->eventTag, phba->fc_eventTag,
-					la->granted_AL_PA, la->UlnkSpeed,
+					bf_get(lpfc_mbx_read_top_alpa_granted,
+					       la),
+					bf_get(lpfc_mbx_read_top_link_spd, la),
 					phba->alpa_map[0],
-					la->mm, la->fa,
+					bf_get(lpfc_mbx_read_top_mm, la),
+					bf_get(lpfc_mbx_read_top_fa, la),
 					phba->wait_4_mlo_maint_flg);
 		}
 		lpfc_mbx_process_link_up(phba, la);
-	} else if (la->attType == AT_LINK_DOWN) {
+	} else if (bf_get(lpfc_mbx_read_top_att_type, la) ==
+		   LPFC_ATT_LINK_DOWN) {
 		phba->fc_stat.LinkDown++;
 		if (phba->link_flag & LS_LOOPBACK_MODE) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
@@ -2964,11 +3030,13 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 				"Data: x%x x%x x%x x%x x%x\n",
 				la->eventTag, phba->fc_eventTag,
 				phba->pport->port_state, vport->fc_flag,
-				la->mm, la->fa);
+				bf_get(lpfc_mbx_read_top_mm, la),
+				bf_get(lpfc_mbx_read_top_fa, la));
 		}
 		lpfc_mbx_issue_link_down(phba);
 	}
-	if (la->mm && la->attType == AT_LINK_UP) {
+	if ((bf_get(lpfc_mbx_read_top_mm, la)) &&
+	    (bf_get(lpfc_mbx_read_top_att_type, la) == LPFC_ATT_LINK_UP)) {
 		if (phba->link_state != LPFC_LINK_DOWN) {
 			phba->fc_stat.LinkDown++;
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
@@ -2996,14 +3064,15 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 		}
 	}
 
-	if (la->fa) {
-		if (la->mm)
+	if (bf_get(lpfc_mbx_read_top_fa, la)) {
+		if (bf_get(lpfc_mbx_read_top_mm, la))
 			lpfc_issue_clear_la(phba, vport);
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
-				"1311 fa %d\n", la->fa);
+				"1311 fa %d\n",
+				bf_get(lpfc_mbx_read_top_fa, la));
 	}
 
-lpfc_mbx_cmpl_read_la_free_mbuf:
+lpfc_mbx_cmpl_read_topology_free_mbuf:
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
@@ -3333,7 +3402,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 		kfree(mp);
 		mempool_free(pmb, phba->mbox_mem_pool);
 
-		if (phba->fc_topology == TOPOLOGY_LOOP) {
+		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 			/* FLOGI failed, use loop map to make discovery list */
 			lpfc_disc_list_loopmap(vport);
 
@@ -3413,7 +3482,7 @@ out:
 		/* If no other thread is using the ndlp, free it */
 		lpfc_nlp_not_used(ndlp);
 
-		if (phba->fc_topology == TOPOLOGY_LOOP) {
+		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 			/*
 			 * RegLogin failed, use loop map to make discovery
 			 * list
@@ -4441,7 +4510,7 @@ lpfc_disc_list_loopmap(struct lpfc_vport
 	if (!lpfc_is_link_up(phba))
 		return;
 
-	if (phba->fc_topology != TOPOLOGY_LOOP)
+	if (phba->fc_topology != LPFC_TOPOLOGY_LOOP)
 		return;
 
 	/* Check for loop map present or not */
@@ -4793,7 +4862,10 @@ lpfc_disc_timeout_handler(struct lpfc_vp
 			}
 		}
 		if (vport->port_state != LPFC_FLOGI) {
-			lpfc_initial_flogi(vport);
+			if (phba->sli_rev <= LPFC_SLI_REV3)
+				lpfc_initial_flogi(vport);
+			else
+				lpfc_issue_init_vfi(vport);
 			return;
 		}
 		break;
@@ -5559,7 +5631,7 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 	 * registered, do nothing.
 	 */
 	spin_lock_irq(&phba->hbalock);
-	if (!(phba->hba_flag & HBA_FCOE_SUPPORT) ||
+	if (!(phba->hba_flag & HBA_FCOE_MODE) ||
 	    !(phba->fcf.fcf_flag & FCF_REGISTERED) ||
 	    !(phba->hba_flag & HBA_FIP_SUPPORT) ||
 	    (phba->fcf.fcf_flag & FCF_DISCOVERY) ||
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-11-19 16:10:18.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-11-19 16:10:35.000000000 -0500
@@ -1444,10 +1444,16 @@ struct lpfc_mbx_init_vfi {
 #define lpfc_init_vfi_vf_SHIFT		29
 #define lpfc_init_vfi_vf_MASK		0x00000001
 #define lpfc_init_vfi_vf_WORD		word1
+#define lpfc_init_vfi_vp_SHIFT		28
+#define lpfc_init_vfi_vp_MASK		0x00000001
+#define lpfc_init_vfi_vp_WORD		word1
 #define lpfc_init_vfi_vfi_SHIFT		0
 #define lpfc_init_vfi_vfi_MASK		0x0000FFFF
 #define lpfc_init_vfi_vfi_WORD		word1
 	uint32_t word2;
+#define lpfc_init_vfi_vpi_SHIFT		16
+#define lpfc_init_vfi_vpi_MASK		0x0000FFFF
+#define lpfc_init_vfi_vpi_WORD		word2
 #define lpfc_init_vfi_fcfi_SHIFT	0
 #define lpfc_init_vfi_fcfi_MASK		0x0000FFFF
 #define lpfc_init_vfi_fcfi_WORD		word2
@@ -2155,6 +2161,7 @@ struct lpfc_mcqe {
 #define LPFC_TRAILER_CODE_FCOE	0x2
 #define LPFC_TRAILER_CODE_DCBX	0x3
 #define LPFC_TRAILER_CODE_GRP5	0x5
+#define LPFC_TRAILER_CODE_FC	0x10
 };
 
 struct lpfc_acqe_link {
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-11-19 16:10:17.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-11-19 16:10:35.000000000 -0500
@@ -1370,7 +1370,6 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_READ_LNK_STAT   0x12
 #define MBX_REG_LOGIN       0x13
 #define MBX_UNREG_LOGIN     0x14
-#define MBX_READ_LA         0x15
 #define MBX_CLEAR_LA        0x16
 #define MBX_DUMP_MEMORY     0x17
 #define MBX_DUMP_CONTEXT    0x18
@@ -1404,7 +1403,7 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_READ_SPARM64    0x8D
 #define MBX_READ_RPI64      0x8F
 #define MBX_REG_LOGIN64     0x93
-#define MBX_READ_LA64       0x95
+#define MBX_READ_TOPOLOGY   0x95
 #define MBX_REG_VPI	    0x96
 #define MBX_UNREG_VPI	    0x97
 
@@ -1825,12 +1824,13 @@ typedef struct {
 #define FLAGS_IMED_ABORT             0x04000	/* Bit 14 */
 
 	uint32_t link_speed;
-#define LINK_SPEED_AUTO 0       /* Auto selection */
-#define LINK_SPEED_1G   1       /* 1 Gigabaud */
-#define LINK_SPEED_2G   2       /* 2 Gigabaud */
-#define LINK_SPEED_4G   4       /* 4 Gigabaud */
-#define LINK_SPEED_8G   8       /* 8 Gigabaud */
-#define LINK_SPEED_10G   16      /* 10 Gigabaud */
+#define LINK_SPEED_AUTO 0x0     /* Auto selection */
+#define LINK_SPEED_1G   0x1     /* 1 Gigabaud */
+#define LINK_SPEED_2G   0x2     /* 2 Gigabaud */
+#define LINK_SPEED_4G   0x4     /* 4 Gigabaud */
+#define LINK_SPEED_8G   0x8     /* 8 Gigabaud */
+#define LINK_SPEED_10G  0x10    /* 10 Gigabaud */
+#define LINK_SPEED_16G  0x11    /* 16 Gigabaud */
 
 } INIT_LINK_VAR;
 
@@ -2001,6 +2001,7 @@ typedef struct {
 #define LMT_4Gb       0x040
 #define LMT_8Gb       0x080
 #define LMT_10Gb      0x100
+#define LMT_16Gb      0x200
 	uint32_t rsvd2;
 	uint32_t rsvd3;
 	uint32_t max_xri;
@@ -2396,100 +2397,93 @@ typedef struct {
 #endif
 } UNREG_D_ID_VAR;
 
-/* Structure for MB Command READ_LA (21) */
-/* Structure for MB Command READ_LA64 (0x95) */
-
-typedef struct {
+/* Structure for MB Command READ_TOPOLOGY (0x95) */
+struct lpfc_mbx_read_top {
 	uint32_t eventTag;	/* Event tag */
-#ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t rsvd1:19;
-	uint32_t fa:1;
-	uint32_t mm:1;		/* Menlo Maintenance mode enabled */
-	uint32_t rx:1;
-	uint32_t pb:1;
-	uint32_t il:1;
-	uint32_t attType:8;
-#else	/*  __LITTLE_ENDIAN_BITFIELD */
-	uint32_t attType:8;
-	uint32_t il:1;
-	uint32_t pb:1;
-	uint32_t rx:1;
-	uint32_t mm:1;
-	uint32_t fa:1;
-	uint32_t rsvd1:19;
-#endif
-
-#define AT_RESERVED    0x00	/* Reserved - attType */
-#define AT_LINK_UP     0x01	/* Link is up */
-#define AT_LINK_DOWN   0x02	/* Link is down */
-
-#ifdef __BIG_ENDIAN_BITFIELD
-	uint8_t granted_AL_PA;
-	uint8_t lipAlPs;
-	uint8_t lipType;
-	uint8_t topology;
-#else	/*  __LITTLE_ENDIAN_BITFIELD */
-	uint8_t topology;
-	uint8_t lipType;
-	uint8_t lipAlPs;
-	uint8_t granted_AL_PA;
-#endif
-
-#define TOPOLOGY_PT_PT 0x01	/* Topology is pt-pt / pt-fabric */
-#define TOPOLOGY_LOOP  0x02	/* Topology is FC-AL */
-#define TOPOLOGY_LNK_MENLO_MAINTENANCE 0x05 /* maint mode zephtr to menlo */
-
-	union {
-		struct ulp_bde lilpBde; /* This BDE points to a 128 byte buffer
-					   to */
-		/* store the LILP AL_PA position map into */
-		struct ulp_bde64 lilpBde64;
-	} un;
-
-#ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t Dlu:1;
-	uint32_t Dtf:1;
-	uint32_t Drsvd2:14;
-	uint32_t DlnkSpeed:8;
-	uint32_t DnlPort:4;
-	uint32_t Dtx:2;
-	uint32_t Drx:2;
-#else	/*  __LITTLE_ENDIAN_BITFIELD */
-	uint32_t Drx:2;
-	uint32_t Dtx:2;
-	uint32_t DnlPort:4;
-	uint32_t DlnkSpeed:8;
-	uint32_t Drsvd2:14;
-	uint32_t Dtf:1;
-	uint32_t Dlu:1;
-#endif
-
-#ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t Ulu:1;
-	uint32_t Utf:1;
-	uint32_t Ursvd2:14;
-	uint32_t UlnkSpeed:8;
-	uint32_t UnlPort:4;
-	uint32_t Utx:2;
-	uint32_t Urx:2;
-#else	/*  __LITTLE_ENDIAN_BITFIELD */
-	uint32_t Urx:2;
-	uint32_t Utx:2;
-	uint32_t UnlPort:4;
-	uint32_t UlnkSpeed:8;
-	uint32_t Ursvd2:14;
-	uint32_t Utf:1;
-	uint32_t Ulu:1;
-#endif
-
-#define LA_UNKNW_LINK  0x0    /* lnkSpeed */
-#define LA_1GHZ_LINK   0x04   /* lnkSpeed */
-#define LA_2GHZ_LINK   0x08   /* lnkSpeed */
-#define LA_4GHZ_LINK   0x10   /* lnkSpeed */
-#define LA_8GHZ_LINK   0x20   /* lnkSpeed */
-#define LA_10GHZ_LINK  0x40   /* lnkSpeed */
-
-} READ_LA_VAR;
+	uint32_t word2;
+#define lpfc_mbx_read_top_fa_SHIFT		12
+#define lpfc_mbx_read_top_fa_MASK		0x00000001
+#define lpfc_mbx_read_top_fa_WORD		word2
+#define lpfc_mbx_read_top_mm_SHIFT		11
+#define lpfc_mbx_read_top_mm_MASK		0x00000001
+#define lpfc_mbx_read_top_mm_WORD		word2
+#define lpfc_mbx_read_top_pb_SHIFT		9
+#define lpfc_mbx_read_top_pb_MASK		0X00000001
+#define lpfc_mbx_read_top_pb_WORD		word2
+#define lpfc_mbx_read_top_il_SHIFT		8
+#define lpfc_mbx_read_top_il_MASK		0x00000001
+#define lpfc_mbx_read_top_il_WORD		word2
+#define lpfc_mbx_read_top_att_type_SHIFT	0
+#define lpfc_mbx_read_top_att_type_MASK		0x000000FF
+#define lpfc_mbx_read_top_att_type_WORD		word2
+#define LPFC_ATT_RESERVED    0x00	/* Reserved - attType */
+#define LPFC_ATT_LINK_UP     0x01	/* Link is up */
+#define LPFC_ATT_LINK_DOWN   0x02	/* Link is down */
+	uint32_t word3;
+#define lpfc_mbx_read_top_alpa_granted_SHIFT	24
+#define lpfc_mbx_read_top_alpa_granted_MASK	0x000000FF
+#define lpfc_mbx_read_top_alpa_granted_WORD	word3
+#define lpfc_mbx_read_top_lip_alps_SHIFT	16
+#define lpfc_mbx_read_top_lip_alps_MASK		0x000000FF
+#define lpfc_mbx_read_top_lip_alps_WORD		word3
+#define lpfc_mbx_read_top_lip_type_SHIFT	8
+#define lpfc_mbx_read_top_lip_type_MASK		0x000000FF
+#define lpfc_mbx_read_top_lip_type_WORD		word3
+#define lpfc_mbx_read_top_topology_SHIFT	0
+#define lpfc_mbx_read_top_topology_MASK		0x000000FF
+#define lpfc_mbx_read_top_topology_WORD		word3
+#define LPFC_TOPOLOGY_PT_PT 0x01	/* Topology is pt-pt / pt-fabric */
+#define LPFC_TOPOLOGY_LOOP  0x02	/* Topology is FC-AL */
+#define LPFC_TOPOLOGY_MM    0x05	/* maint mode zephtr to menlo */
+	/* store the LILP AL_PA position map into */
+	struct ulp_bde64 lilpBde64;
+#define LPFC_ALPA_MAP_SIZE	128
+	uint32_t word7;
+#define lpfc_mbx_read_top_ld_lu_SHIFT		31
+#define lpfc_mbx_read_top_ld_lu_MASK		0x00000001
+#define lpfc_mbx_read_top_ld_lu_WORD		word7
+#define lpfc_mbx_read_top_ld_tf_SHIFT		30
+#define lpfc_mbx_read_top_ld_tf_MASK		0x00000001
+#define lpfc_mbx_read_top_ld_tf_WORD		word7
+#define lpfc_mbx_read_top_ld_link_spd_SHIFT	8
+#define lpfc_mbx_read_top_ld_link_spd_MASK	0x000000FF
+#define lpfc_mbx_read_top_ld_link_spd_WORD	word7
+#define lpfc_mbx_read_top_ld_nl_port_SHIFT	4
+#define lpfc_mbx_read_top_ld_nl_port_MASK	0x0000000F
+#define lpfc_mbx_read_top_ld_nl_port_WORD	word7
+#define lpfc_mbx_read_top_ld_tx_SHIFT		2
+#define lpfc_mbx_read_top_ld_tx_MASK		0x00000003
+#define lpfc_mbx_read_top_ld_tx_WORD		word7
+#define lpfc_mbx_read_top_ld_rx_SHIFT		0
+#define lpfc_mbx_read_top_ld_rx_MASK		0x00000003
+#define lpfc_mbx_read_top_ld_rx_WORD		word7
+	uint32_t word8;
+#define lpfc_mbx_read_top_lu_SHIFT		31
+#define lpfc_mbx_read_top_lu_MASK		0x00000001
+#define lpfc_mbx_read_top_lu_WORD		word8
+#define lpfc_mbx_read_top_tf_SHIFT		30
+#define lpfc_mbx_read_top_tf_MASK		0x00000001
+#define lpfc_mbx_read_top_tf_WORD		word8
+#define lpfc_mbx_read_top_link_spd_SHIFT	8
+#define lpfc_mbx_read_top_link_spd_MASK		0x000000FF
+#define lpfc_mbx_read_top_link_spd_WORD		word8
+#define lpfc_mbx_read_top_nl_port_SHIFT		4
+#define lpfc_mbx_read_top_nl_port_MASK		0x0000000F
+#define lpfc_mbx_read_top_nl_port_WORD		word8
+#define lpfc_mbx_read_top_tx_SHIFT		2
+#define lpfc_mbx_read_top_tx_MASK		0x00000003
+#define lpfc_mbx_read_top_tx_WORD		word8
+#define lpfc_mbx_read_top_rx_SHIFT		0
+#define lpfc_mbx_read_top_rx_MASK		0x00000003
+#define lpfc_mbx_read_top_rx_WORD		word8
+#define LPFC_LINK_SPEED_UNKNOWN	0x0
+#define LPFC_LINK_SPEED_1GHZ	0x04
+#define LPFC_LINK_SPEED_2GHZ	0x08
+#define LPFC_LINK_SPEED_4GHZ	0x10
+#define LPFC_LINK_SPEED_8GHZ	0x20
+#define LPFC_LINK_SPEED_10GHZ	0x40
+#define LPFC_LINK_SPEED_16GHZ	0x80
+};
 
 /* Structure for MB Command CLEAR_LA (22) */
 
@@ -3018,7 +3012,6 @@ typedef union {
 	READ_LNK_VAR varRdLnk;		/* cmd = 18 (READ_LNK_STAT)  */
 	REG_LOGIN_VAR varRegLogin;	/* cmd = 19 (REG_LOGIN(64))  */
 	UNREG_LOGIN_VAR varUnregLogin;	/* cmd = 20 (UNREG_LOGIN)    */
-	READ_LA_VAR varReadLA;		/* cmd = 21 (READ_LA(64))    */
 	CLEAR_LA_VAR varClearLA;	/* cmd = 22 (CLEAR_LA)       */
 	DUMP_VAR varDmp;		/* Warm Start DUMP mbx cmd   */
 	UNREG_D_ID_VAR varUnregDID;	/* cmd = 0x23 (UNREG_D_ID)   */
@@ -3028,6 +3021,7 @@ typedef union {
 	struct config_hbq_var varCfgHbq;/* cmd = 0x7c (CONFIG_HBQ)  */
 	struct update_cfg_var varUpdateCfg; /* cmd = 0x1B (UPDATE_CFG)*/
 	CONFIG_PORT_VAR varCfgPort;	/* cmd = 0x88 (CONFIG_PORT)  */
+	struct lpfc_mbx_read_top varReadTop; /* cmd = 0x95 (READ_TOPOLOGY) */
 	REG_VPI_VAR varRegVpi;		/* cmd = 0x96 (REG_VPI) */
 	UNREG_VPI_VAR varUnregVpi;	/* cmd = 0x97 (UNREG_VPI) */
 	ASYNCEVT_ENABLE_VAR varCfgAsyncEvent; /*cmd = x33 (CONFIG_ASYNC) */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-11-19 16:10:18.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-11-19 16:10:35.000000000 -0500
@@ -446,23 +446,25 @@ lpfc_config_port_post(struct lpfc_hba *p
 	/* Get the default values for Model Name and Description */
 	lpfc_get_hba_model_desc(phba, phba->ModelName, phba->ModelDesc);
 
-	if ((phba->cfg_link_speed > LINK_SPEED_10G)
-	    || ((phba->cfg_link_speed == LINK_SPEED_1G)
+	if ((phba->cfg_link_speed > LPFC_USER_LINK_SPEED_16G)
+	    || ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_1G)
 		&& !(phba->lmt & LMT_1Gb))
-	    || ((phba->cfg_link_speed == LINK_SPEED_2G)
+	    || ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_2G)
 		&& !(phba->lmt & LMT_2Gb))
-	    || ((phba->cfg_link_speed == LINK_SPEED_4G)
+	    || ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_4G)
 		&& !(phba->lmt & LMT_4Gb))
-	    || ((phba->cfg_link_speed == LINK_SPEED_8G)
+	    || ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_8G)
 		&& !(phba->lmt & LMT_8Gb))
-	    || ((phba->cfg_link_speed == LINK_SPEED_10G)
-		&& !(phba->lmt & LMT_10Gb))) {
+	    || ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_10G)
+		&& !(phba->lmt & LMT_10Gb))
+	    || ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_16G)
+		&& !(phba->lmt & LMT_16Gb))) {
 		/* Reset link speed to auto */
 		lpfc_printf_log(phba, KERN_WARNING, LOG_LINK_EVENT,
 			"1302 Invalid speed for this board: "
 			"Reset link speed to auto: x%x\n",
 			phba->cfg_link_speed);
-			phba->cfg_link_speed = LINK_SPEED_AUTO;
+			phba->cfg_link_speed = LPFC_USER_LINK_SPEED_AUTO;
 	}
 
 	phba->link_state = LPFC_LINK_DOWN;
@@ -648,22 +650,23 @@ lpfc_hba_init_link(struct lpfc_hba *phba
 	mb = &pmb->u.mb;
 	pmb->vport = vport;
 
-	lpfc_init_link(phba, pmb, phba->cfg_topology,
-		phba->cfg_link_speed);
+	lpfc_init_link(phba, pmb, phba->cfg_topology, phba->cfg_link_speed);
 	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	lpfc_set_loopback_flag(phba);
 	rc = lpfc_sli_issue_mbox(phba, pmb, flag);
-	if (rc != MBX_SUCCESS) {
+	if ((rc != MBX_BUSY) && (rc != MBX_SUCCESS)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"0498 Adapter failed to init, mbxCmd x%x "
 			"INIT_LINK, mbxStatus x%x\n",
 			mb->mbxCommand, mb->mbxStatus);
-		/* Clear all interrupt enable conditions */
-		writel(0, phba->HCregaddr);
-		readl(phba->HCregaddr); /* flush */
-		/* Clear all pending interrupts */
-		writel(0xffffffff, phba->HAregaddr);
-		readl(phba->HAregaddr); /* flush */
+		if (phba->sli_rev <= LPFC_SLI_REV3) {
+			/* Clear all interrupt enable conditions */
+			writel(0, phba->HCregaddr);
+			readl(phba->HCregaddr); /* flush */
+			/* Clear all pending interrupts */
+			writel(0xffffffff, phba->HAregaddr);
+			readl(phba->HAregaddr); /* flush */
+		}
 		phba->link_state = LPFC_HBA_ERROR;
 		if (rc != MBX_BUSY || flag == MBX_POLL)
 			mempool_free(pmb, phba->mbox_mem_pool);
@@ -1459,8 +1462,8 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	lpfc_els_flush_all_cmd(phba);
 
 	psli->slistat.link_event++;
-	lpfc_read_la(phba, pmb, mp);
-	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_la;
+	lpfc_read_topology(phba, pmb, mp);
+	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_topology;
 	pmb->vport = vport;
 	/* Block ELS IOCBs until we have processed this mbox command */
 	phba->sli.ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
@@ -3059,20 +3062,20 @@ lpfc_sli4_parse_latt_type(struct lpfc_hb
 	switch (bf_get(lpfc_acqe_link_status, acqe_link)) {
 	case LPFC_ASYNC_LINK_STATUS_DOWN:
 	case LPFC_ASYNC_LINK_STATUS_LOGICAL_DOWN:
-		att_type = AT_LINK_DOWN;
+		att_type = LPFC_ATT_LINK_DOWN;
 		break;
 	case LPFC_ASYNC_LINK_STATUS_UP:
 		/* Ignore physical link up events - wait for logical link up */
-		att_type = AT_RESERVED;
+		att_type = LPFC_ATT_RESERVED;
 		break;
 	case LPFC_ASYNC_LINK_STATUS_LOGICAL_UP:
-		att_type = AT_LINK_UP;
+		att_type = LPFC_ATT_LINK_UP;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0399 Invalid link attention type: x%x\n",
 				bf_get(lpfc_acqe_link_status, acqe_link));
-		att_type = AT_RESERVED;
+		att_type = LPFC_ATT_RESERVED;
 		break;
 	}
 	return att_type;
@@ -3096,32 +3099,28 @@ lpfc_sli4_parse_latt_link_speed(struct l
 
 	switch (bf_get(lpfc_acqe_link_speed, acqe_link)) {
 	case LPFC_ASYNC_LINK_SPEED_ZERO:
-		link_speed = LA_UNKNW_LINK;
-		break;
 	case LPFC_ASYNC_LINK_SPEED_10MBPS:
-		link_speed = LA_UNKNW_LINK;
-		break;
 	case LPFC_ASYNC_LINK_SPEED_100MBPS:
-		link_speed = LA_UNKNW_LINK;
+		link_speed = LPFC_LINK_SPEED_UNKNOWN;
 		break;
 	case LPFC_ASYNC_LINK_SPEED_1GBPS:
-		link_speed = LA_1GHZ_LINK;
+		link_speed = LPFC_LINK_SPEED_1GHZ;
 		break;
 	case LPFC_ASYNC_LINK_SPEED_10GBPS:
-		link_speed = LA_10GHZ_LINK;
+		link_speed = LPFC_LINK_SPEED_10GHZ;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0483 Invalid link-attention link speed: x%x\n",
 				bf_get(lpfc_acqe_link_speed, acqe_link));
-		link_speed = LA_UNKNW_LINK;
+		link_speed = LPFC_LINK_SPEED_UNKNOWN;
 		break;
 	}
 	return link_speed;
 }
 
 /**
- * lpfc_sli4_async_link_evt - Process the asynchronous link event
+ * lpfc_sli4_async_link_evt - Process the asynchronous FC or FCoE link event
  * @phba: pointer to lpfc hba data structure.
  * @acqe_link: pointer to the async link completion queue entry.
  *
@@ -3134,11 +3133,12 @@ lpfc_sli4_async_link_evt(struct lpfc_hba
 	struct lpfc_dmabuf *mp;
 	LPFC_MBOXQ_t *pmb;
 	MAILBOX_t *mb;
-	READ_LA_VAR *la;
+	struct lpfc_mbx_read_top *la;
 	uint8_t att_type;
+	int rc;
 
 	att_type = lpfc_sli4_parse_latt_type(phba, acqe_link);
-	if (att_type != AT_LINK_DOWN && att_type != AT_LINK_UP)
+	if (att_type != LPFC_ATT_LINK_DOWN && att_type != LPFC_ATT_LINK_UP)
 		return;
 	phba->fcoe_eventtag = acqe_link->event_tag;
 	pmb = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -3169,28 +3169,11 @@ lpfc_sli4_async_link_evt(struct lpfc_hba
 	/* Update link event statistics */
 	phba->sli.slistat.link_event++;
 
-	/* Create pseudo lpfc_handle_latt mailbox command from link ACQE */
-	lpfc_read_la(phba, pmb, mp);
+	/* Create lpfc_handle_latt mailbox command from link ACQE */
+	lpfc_read_topology(phba, pmb, mp);
+	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_topology;
 	pmb->vport = phba->pport;
 
-	/* Parse and translate status field */
-	mb = &pmb->u.mb;
-	mb->mbxStatus = lpfc_sli4_parse_latt_fault(phba, acqe_link);
-
-	/* Parse and translate link attention fields */
-	la = (READ_LA_VAR *) &pmb->u.mb.un.varReadLA;
-	la->eventTag = acqe_link->event_tag;
-	la->attType = att_type;
-	la->UlnkSpeed = lpfc_sli4_parse_latt_link_speed(phba, acqe_link);
-
-	/* Fake the the following irrelvant fields */
-	la->topology = TOPOLOGY_PT_PT;
-	la->granted_AL_PA = 0;
-	la->il = 0;
-	la->pb = 0;
-	la->fa = 0;
-	la->mm = 0;
-
 	/* Keep the link status for extra SLI4 state machine reference */
 	phba->sli4_hba.link_state.speed =
 				bf_get(lpfc_acqe_link_speed, acqe_link);
@@ -3204,9 +3187,42 @@ lpfc_sli4_async_link_evt(struct lpfc_hba
 				bf_get(lpfc_acqe_link_fault, acqe_link);
 	phba->sli4_hba.link_state.logical_speed =
 				bf_get(lpfc_acqe_qos_link_speed, acqe_link);
+	/*
+	 * For FC Mode: issue the READ_TOPOLOGY mailbox command to fetch
+	 * topology info. Note: Optional for non FC-AL ports.
+	 */
+	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
+		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED)
+			goto out_free_dmabuf;
+		return;
+	}
+	/*
+	 * For FCoE Mode: fill in all the topology information we need and call
+	 * the READ_TOPOLOGY completion routine to continue without actually
+	 * sending the READ_TOPOLOGY mailbox command to the port.
+	 */
+	/* Parse and translate status field */
+	mb = &pmb->u.mb;
+	mb->mbxStatus = lpfc_sli4_parse_latt_fault(phba, acqe_link);
+
+	/* Parse and translate link attention fields */
+	la = (struct lpfc_mbx_read_top *) &pmb->u.mb.un.varReadTop;
+	la->eventTag = acqe_link->event_tag;
+	bf_set(lpfc_mbx_read_top_att_type, la, att_type);
+	bf_set(lpfc_mbx_read_top_link_spd, la,
+	       lpfc_sli4_parse_latt_link_speed(phba, acqe_link));
+
+	/* Fake the the following irrelvant fields */
+	bf_set(lpfc_mbx_read_top_topology, la, LPFC_TOPOLOGY_PT_PT);
+	bf_set(lpfc_mbx_read_top_alpa_granted, la, 0);
+	bf_set(lpfc_mbx_read_top_il, la, 0);
+	bf_set(lpfc_mbx_read_top_pb, la, 0);
+	bf_set(lpfc_mbx_read_top_fa, la, 0);
+	bf_set(lpfc_mbx_read_top_mm, la, 0);
 
 	/* Invoke the lpfc_handle_latt mailbox command callback function */
-	lpfc_mbx_cmpl_read_la(phba, pmb);
+	lpfc_mbx_cmpl_read_topology(phba, pmb);
 
 	return;
 
@@ -3295,15 +3311,15 @@ lpfc_sli4_perform_all_vport_cvl(struct l
 }
 
 /**
- * lpfc_sli4_async_fcoe_evt - Process the asynchronous fcoe event
+ * lpfc_sli4_async_fip_evt - Process the asynchronous FCoE FIP event
  * @phba: pointer to lpfc hba data structure.
  * @acqe_link: pointer to the async fcoe completion queue entry.
  *
  * This routine is to handle the SLI4 asynchronous fcoe event.
  **/
 static void
-lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
-			 struct lpfc_acqe_fcoe *acqe_fcoe)
+lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
+			struct lpfc_acqe_fcoe *acqe_fcoe)
 {
 	uint8_t event_type = bf_get(lpfc_acqe_fcoe_event_type, acqe_fcoe);
 	int rc;
@@ -3605,12 +3621,13 @@ void lpfc_sli4_async_event_proc(struct l
 		/* Process the asynchronous event */
 		switch (bf_get(lpfc_trailer_code, &cq_event->cqe.mcqe_cmpl)) {
 		case LPFC_TRAILER_CODE_LINK:
+		case LPFC_TRAILER_CODE_FC:
 			lpfc_sli4_async_link_evt(phba,
 						 &cq_event->cqe.acqe_link);
 			break;
 		case LPFC_TRAILER_CODE_FCOE:
-			lpfc_sli4_async_fcoe_evt(phba,
-						 &cq_event->cqe.acqe_fcoe);
+			lpfc_sli4_async_fip_evt(phba,
+						&cq_event->cqe.acqe_fcoe);
 			break;
 		case LPFC_TRAILER_CODE_DCBX:
 			lpfc_sli4_async_dcbx_evt(phba,
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-11-19 16:10:35.000000000 -0500
@@ -263,18 +263,19 @@ lpfc_heart_beat(struct lpfc_hba * phba, 
 }
 
 /**
- * lpfc_read_la - Prepare a mailbox command for reading HBA link attention
+ * lpfc_read_topology - Prepare a mailbox command for reading HBA topology
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @mp: DMA buffer memory for reading the link attention information into.
  *
- * The read link attention mailbox command is issued to read the Link Event
- * Attention information indicated by the HBA port when the Link Event bit
- * of the Host Attention (HSTATT) register is set to 1. A Link Event
+ * The read topology mailbox command is issued to read the link topology
+ * information indicated by the HBA port when the Link Event bit of the Host
+ * Attention (HSTATT) register is set to 1 (For SLI-3) or when an FC Link
+ * Attention ACQE is received from the port (For SLI-4). A Link Event
  * Attention occurs based on an exception detected at the Fibre Channel link
  * interface.
  *
- * This routine prepares the mailbox command for reading HBA link attention
+ * This routine prepares the mailbox command for reading HBA link topology
  * information. A DMA memory has been set aside and address passed to the
  * HBA through @mp for the HBA to DMA link attention information into the
  * memory as part of the execution of the mailbox command.
@@ -283,7 +284,8 @@ lpfc_heart_beat(struct lpfc_hba * phba, 
  *    0 - Success (currently always return 0)
  **/
 int
-lpfc_read_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, struct lpfc_dmabuf *mp)
+lpfc_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb,
+		   struct lpfc_dmabuf *mp)
 {
 	MAILBOX_t *mb;
 	struct lpfc_sli *psli;
@@ -293,15 +295,15 @@ lpfc_read_la(struct lpfc_hba * phba, LPF
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 
 	INIT_LIST_HEAD(&mp->list);
-	mb->mbxCommand = MBX_READ_LA64;
-	mb->un.varReadLA.un.lilpBde64.tus.f.bdeSize = 128;
-	mb->un.varReadLA.un.lilpBde64.addrHigh = putPaddrHigh(mp->phys);
-	mb->un.varReadLA.un.lilpBde64.addrLow = putPaddrLow(mp->phys);
+	mb->mbxCommand = MBX_READ_TOPOLOGY;
+	mb->un.varReadTop.lilpBde64.tus.f.bdeSize = LPFC_ALPA_MAP_SIZE;
+	mb->un.varReadTop.lilpBde64.addrHigh = putPaddrHigh(mp->phys);
+	mb->un.varReadTop.lilpBde64.addrLow = putPaddrLow(mp->phys);
 
 	/* Save address for later completion and set the owner to host so that
 	 * the FW knows this mailbox is available for processing.
 	 */
-	pmb->context1 = (uint8_t *) mp;
+	pmb->context1 = (uint8_t *)mp;
 	mb->mbxOwner = OWN_HOST;
 	return (0);
 }
@@ -516,18 +518,33 @@ lpfc_init_link(struct lpfc_hba * phba,
 	vpd = &phba->vpd;
 	if (vpd->rev.feaLevelHigh >= 0x02){
 		switch(linkspeed){
-			case LINK_SPEED_1G:
-			case LINK_SPEED_2G:
-			case LINK_SPEED_4G:
-			case LINK_SPEED_8G:
-				mb->un.varInitLnk.link_flags |=
-							FLAGS_LINK_SPEED;
-				mb->un.varInitLnk.link_speed = linkspeed;
+		case LPFC_USER_LINK_SPEED_1G:
+			mb->un.varInitLnk.link_flags |= FLAGS_LINK_SPEED;
+			mb->un.varInitLnk.link_speed = LINK_SPEED_1G;
+			break;
+		case LPFC_USER_LINK_SPEED_2G:
+			mb->un.varInitLnk.link_flags |=	FLAGS_LINK_SPEED;
+			mb->un.varInitLnk.link_speed = LINK_SPEED_2G;
+			break;
+		case LPFC_USER_LINK_SPEED_4G:
+			mb->un.varInitLnk.link_flags |=	FLAGS_LINK_SPEED;
+			mb->un.varInitLnk.link_speed = LINK_SPEED_4G;
+			break;
+		case LPFC_USER_LINK_SPEED_8G:
+			mb->un.varInitLnk.link_flags |=	FLAGS_LINK_SPEED;
+			mb->un.varInitLnk.link_speed = LINK_SPEED_8G;
+			break;
+		case LPFC_USER_LINK_SPEED_10G:
+			mb->un.varInitLnk.link_flags |=	FLAGS_LINK_SPEED;
+			mb->un.varInitLnk.link_speed = LINK_SPEED_10G;
+			break;
+		case LPFC_USER_LINK_SPEED_16G:
+			mb->un.varInitLnk.link_flags |=	FLAGS_LINK_SPEED;
+			mb->un.varInitLnk.link_speed = LINK_SPEED_16G;
 			break;
-			case LINK_SPEED_AUTO:
-			default:
-				mb->un.varInitLnk.link_speed =
-							LINK_SPEED_AUTO;
+		case LPFC_USER_LINK_SPEED_AUTO:
+		default:
+			mb->un.varInitLnk.link_speed = LINK_SPEED_AUTO;
 			break;
 		}
 
@@ -1918,11 +1935,14 @@ lpfc_init_vfi(struct lpfcMboxq *mbox, st
 	struct lpfc_mbx_init_vfi *init_vfi;
 
 	memset(mbox, 0, sizeof(*mbox));
+	mbox->vport = vport;
 	init_vfi = &mbox->u.mqe.un.init_vfi;
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_INIT_VFI);
 	bf_set(lpfc_init_vfi_vr, init_vfi, 1);
 	bf_set(lpfc_init_vfi_vt, init_vfi, 1);
+	bf_set(lpfc_init_vfi_vp, init_vfi, 1);
 	bf_set(lpfc_init_vfi_vfi, init_vfi, vport->vfi + vport->phba->vfi_base);
+	bf_set(lpfc_init_vpi_vpi, init_vfi, vport->vpi + vport->phba->vpi_base);
 	bf_set(lpfc_init_vfi_fcfi, init_vfi, vport->phba->fcf.fcfi);
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-11-19 16:10:35.000000000 -0500
@@ -548,7 +548,7 @@ int lpfc_sli4_brdreset(struct lpfc_hba *
 int lpfc_sli4_add_fcf_record(struct lpfc_hba *, struct fcf_record *);
 void lpfc_sli_remove_dflt_fcf(struct lpfc_hba *);
 int lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *);
-int lpfc_sli4_init_vpi(struct lpfc_hba *, uint16_t);
+int lpfc_sli4_init_vpi(struct lpfc_vport *);
 uint32_t lpfc_sli4_cq_release(struct lpfc_queue *, bool);
 uint32_t lpfc_sli4_eq_release(struct lpfc_queue *, bool);
 void lpfc_sli4_fcfi_unreg(struct lpfc_hba *, uint16_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-11-19 16:08:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-11-19 16:10:35.000000000 -0500
@@ -1634,7 +1634,6 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_READ_LNK_STAT:
 	case MBX_REG_LOGIN:
 	case MBX_UNREG_LOGIN:
-	case MBX_READ_LA:
 	case MBX_CLEAR_LA:
 	case MBX_DUMP_MEMORY:
 	case MBX_DUMP_CONTEXT:
@@ -1656,7 +1655,7 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_READ_SPARM64:
 	case MBX_READ_RPI64:
 	case MBX_REG_LOGIN64:
-	case MBX_READ_LA64:
+	case MBX_READ_TOPOLOGY:
 	case MBX_WRITE_WWN:
 	case MBX_SET_DEBUG:
 	case MBX_LOAD_EXP_ROM:
@@ -4357,13 +4356,16 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	}
 
 	rc = lpfc_sli4_read_rev(phba, mboxq, vpd, &vpd_size);
-	if (unlikely(rc))
-		goto out_free_vpd;
-
+	if (unlikely(rc)) {
+		kfree(vpd);
+		goto out_free_mbox;
+	}
 	mqe = &mboxq->u.mqe;
 	phba->sli_rev = bf_get(lpfc_mbx_rd_rev_sli_lvl, &mqe->un.read_rev);
 	if (bf_get(lpfc_mbx_rd_rev_fcoe, &mqe->un.read_rev))
-		phba->hba_flag |= HBA_FCOE_SUPPORT;
+		phba->hba_flag |= HBA_FCOE_MODE;
+	else
+		phba->hba_flag &= ~HBA_FCOE_MODE;
 
 	if (bf_get(lpfc_mbx_rd_rev_cee_ver, &mqe->un.read_rev) ==
 		LPFC_DCBX_CEE_MODE)
@@ -4372,13 +4374,14 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 		phba->hba_flag &= ~HBA_FIP_SUPPORT;
 
 	if (phba->sli_rev != LPFC_SLI_REV4 ||
-	    !(phba->hba_flag & HBA_FCOE_SUPPORT)) {
+	    !(phba->hba_flag & HBA_FCOE_MODE)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 			"0376 READ_REV Error. SLI Level %d "
 			"FCoE enabled %d\n",
-			phba->sli_rev, phba->hba_flag & HBA_FCOE_SUPPORT);
+			phba->sli_rev, phba->hba_flag & HBA_FCOE_MODE);
 		rc = -EIO;
-		goto out_free_vpd;
+		kfree(vpd);
+		goto out_free_mbox;
 	}
 	/*
 	 * Evaluate the read rev and vpd data. Populate the driver
@@ -4392,6 +4395,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 				"Using defaults.\n", rc);
 		rc = 0;
 	}
+	kfree(vpd);
 
 	/* Save information as VPD data */
 	phba->vpd.rev.biuRev = mqe->un.read_rev.first_hw_rev;
@@ -4428,7 +4432,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
 	if (unlikely(rc)) {
 		rc = -EIO;
-		goto out_free_vpd;
+		goto out_free_mbox;
 	}
 
 	/*
@@ -4476,7 +4480,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	if (rc) {
 		phba->link_state = LPFC_HBA_ERROR;
 		rc = -ENOMEM;
-		goto out_free_vpd;
+		goto out_free_mbox;
 	}
 
 	mboxq->vport = vport;
@@ -4501,7 +4505,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 				rc, bf_get(lpfc_mqe_status, mqe));
 		phba->link_state = LPFC_HBA_ERROR;
 		rc = -EIO;
-		goto out_free_vpd;
+		goto out_free_mbox;
 	}
 
 	if (phba->cfg_soft_wwnn)
@@ -4526,7 +4530,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 				"0582 Error %d during sgl post operation\n",
 					rc);
 		rc = -ENODEV;
-		goto out_free_vpd;
+		goto out_free_mbox;
 	}
 
 	/* Register SCSI SGL pool to the device */
@@ -4538,7 +4542,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 		/* Some Scsi buffers were moved to the abort scsi list */
 		/* A pci function reset will repost them */
 		rc = -ENODEV;
-		goto out_free_vpd;
+		goto out_free_mbox;
 	}
 
 	/* Post the rpi header region to the device. */
@@ -4548,7 +4552,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 				"0393 Error %d during rpi post operation\n",
 				rc);
 		rc = -ENODEV;
-		goto out_free_vpd;
+		goto out_free_mbox;
 	}
 
 	/* Set up all the queues to the device */
@@ -4608,33 +4612,33 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 		}
 	}
 
+	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
+		/*
+		 * The FC Port needs to register FCFI (index 0)
+		 */
+		lpfc_reg_fcfi(phba, mboxq);
+		mboxq->vport = phba->pport;
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+		if (rc == MBX_SUCCESS)
+			rc = 0;
+		else
+			goto out_unset_queue;
+	}
 	/*
 	 * The port is ready, set the host's link state to LINK_DOWN
 	 * in preparation for link interrupts.
 	 */
-	lpfc_init_link(phba, mboxq, phba->cfg_topology, phba->cfg_link_speed);
-	mboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-	lpfc_set_loopback_flag(phba);
-	/* Change driver state to LPFC_LINK_DOWN right before init link */
 	spin_lock_irq(&phba->hbalock);
 	phba->link_state = LPFC_LINK_DOWN;
 	spin_unlock_irq(&phba->hbalock);
-	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
-	if (unlikely(rc != MBX_NOT_FINISHED)) {
-		kfree(vpd);
-		return 0;
-	} else
-		rc = -EIO;
-
+	rc = phba->lpfc_hba_init_link(phba, MBX_NOWAIT);
+out_unset_queue:
 	/* Unset all the queues set up in this routine when error out */
 	if (rc)
 		lpfc_sli4_queue_unset(phba);
-
 out_stop_timers:
 	if (rc)
 		lpfc_stop_hba_timers(phba);
-out_free_vpd:
-	kfree(vpd);
 out_free_mbox:
 	mempool_free(mboxq, phba->mbox_mem_pool);
 	return rc;
@@ -12157,42 +12161,37 @@ lpfc_sli4_resume_rpi(struct lpfc_nodelis
 
 /**
  * lpfc_sli4_init_vpi - Initialize a vpi with the port
- * @phba: pointer to lpfc hba data structure.
- * @vpi: vpi value to activate with the port.
+ * @vport: Pointer to the vport for which the vpi is being initialized
  *
- * This routine is invoked to activate a vpi with the
- * port when the host intends to use vports with a
- * nonzero vpi.
+ * This routine is invoked to activate a vpi with the port.
  *
  * Returns:
  *    0 success
  *    -Evalue otherwise
  **/
 int
-lpfc_sli4_init_vpi(struct lpfc_hba *phba, uint16_t vpi)
+lpfc_sli4_init_vpi(struct lpfc_vport *vport)
 {
 	LPFC_MBOXQ_t *mboxq;
 	int rc = 0;
 	int retval = MBX_SUCCESS;
 	uint32_t mbox_tmo;
-
-	if (vpi == 0)
-		return -EINVAL;
+	struct lpfc_hba *phba = vport->phba;
 	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mboxq)
 		return -ENOMEM;
-	lpfc_init_vpi(phba, mboxq, vpi);
+	lpfc_init_vpi(phba, mboxq, vport->vpi);
 	mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_INIT_VPI);
 	rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
 	if (rc != MBX_SUCCESS) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_SLI,
 				"2022 INIT VPI Mailbox failed "
 				"status %d, mbxStatus x%x\n", rc,
 				bf_get(lpfc_mqe_status, &mboxq->u.mqe));
 		retval = -EIO;
 	}
 	if (rc != MBX_TIMEOUT)
-		mempool_free(mboxq, phba->mbox_mem_pool);
+		mempool_free(mboxq, vport->phba->mbox_mem_pool);
 
 	return retval;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2010-10-11 12:32:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2010-11-19 16:10:35.000000000 -0500
@@ -395,8 +395,8 @@ lpfc_vport_create(struct fc_vport *fc_vp
 	 * by the port.
 	 */
 	if ((phba->sli_rev == LPFC_SLI_REV4) &&
-		(pport->fc_flag & FC_VFI_REGISTERED)) {
-		rc = lpfc_sli4_init_vpi(phba, vpi);
+	    (pport->fc_flag & FC_VFI_REGISTERED)) {
+		rc = lpfc_sli4_init_vpi(vport);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
 					"1838 Failed to INIT_VPI on vpi %d "
@@ -418,7 +418,7 @@ lpfc_vport_create(struct fc_vport *fc_vp
 
 	if ((phba->link_state < LPFC_LINK_UP) ||
 	    (pport->port_state < LPFC_FABRIC_CFG_LINK) ||
-	    (phba->fc_topology == TOPOLOGY_LOOP)) {
+	    (phba->fc_topology == LPFC_TOPOLOGY_LOOP)) {
 		lpfc_vport_set_state(vport, FC_VPORT_LINKDOWN);
 		rc = VPORT_OK;
 		goto out;
@@ -514,7 +514,7 @@ enable_vport(struct fc_vport *fc_vport)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	if ((phba->link_state < LPFC_LINK_UP) ||
-	    (phba->fc_topology == TOPOLOGY_LOOP)) {
+	    (phba->fc_topology == LPFC_TOPOLOGY_LOOP)) {
 		lpfc_vport_set_state(vport, FC_VPORT_LINKDOWN);
 		return VPORT_OK;
 	}
@@ -665,7 +665,7 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
 	    ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
 	    phba->link_state >= LPFC_LINK_UP &&
-	    phba->fc_topology != TOPOLOGY_LOOP) {
+	    phba->fc_topology != LPFC_TOPOLOGY_LOOP) {
 		if (vport->cfg_enable_da_id) {
 			timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
 			if (!lpfc_ns_cmd(vport, SLI_CTNS_DA_ID, 0, 0))


