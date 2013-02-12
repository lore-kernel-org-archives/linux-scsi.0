From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 04/15] pm80xx: Structure and variable name update for SPC
Date: Tue, 12 Feb 2013 04:30:30 -0800
Message-ID: <511A35E6.50303@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60490 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932927Ab3BLM3s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 07:29:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

>From a08478c7c29817c887469192069dbce8463a5730 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 4 Feb 2013 14:26:19 +0530
Subject: [PATCH 04/15] pm80xx: Structure and variable name update for SPC

Update of structure and variable names for SPC hardware functionalities.

Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c |   69 ++++++++++---
 drivers/scsi/pm8001/pm8001_hwi.c |  210 +++++++++++++++++++++++---------------
 2 files changed, 181 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 45bc197..ae2b124 100755
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -1,5 +1,5 @@
 /*
- * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver
+ * PMC-Sierra 8001/8081/8088/8089 SAS/SATA based host adapters driver
  *
  * Copyright (c) 2008-2009 USI Co., Ltd.
  * All rights reserved.
@@ -58,8 +58,13 @@ static ssize_t pm8001_ctl_mpi_interface_rev_show(struct device *cdev,
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-		pm8001_ha->main_cfg_tbl.interface_rev);
+	if (pm8001_ha->chip_id == chip_8001) {
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+			pm8001_ha->main_cfg_tbl.pm8001_tbl.interface_rev);
+	} else {
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+			pm8001_ha->main_cfg_tbl.pm80xx_tbl.interface_rev);
+	}
 }
 static
 DEVICE_ATTR(interface_rev, S_IRUGO, pm8001_ctl_mpi_interface_rev_show, NULL);
@@ -78,11 +83,19 @@ static ssize_t pm8001_ctl_fw_version_show(struct device *cdev,
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 
-	return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x\n",
-		       (u8)(pm8001_ha->main_cfg_tbl.firmware_rev >> 24),
-		       (u8)(pm8001_ha->main_cfg_tbl.firmware_rev >> 16),
-		       (u8)(pm8001_ha->main_cfg_tbl.firmware_rev >> 8),
-		       (u8)(pm8001_ha->main_cfg_tbl.firmware_rev));
+	if (pm8001_ha->chip_id == chip_8001) {
+		return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x\n",
+		(u8)(pm8001_ha->main_cfg_tbl.pm8001_tbl.firmware_rev >> 24),
+		(u8)(pm8001_ha->main_cfg_tbl.pm8001_tbl.firmware_rev >> 16),
+		(u8)(pm8001_ha->main_cfg_tbl.pm8001_tbl.firmware_rev >> 8),
+		(u8)(pm8001_ha->main_cfg_tbl.pm8001_tbl.firmware_rev));
+	} else {
+		return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x\n",
+		(u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.firmware_rev >> 24),
+		(u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.firmware_rev >> 16),
+		(u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.firmware_rev >> 8),
+		(u8)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.firmware_rev));
+	}
 }
 static DEVICE_ATTR(fw_version, S_IRUGO, pm8001_ctl_fw_version_show, NULL);
 /**
@@ -99,8 +112,13 @@ static ssize_t pm8001_ctl_max_out_io_show(struct device *cdev,
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-			pm8001_ha->main_cfg_tbl.max_out_io);
+	if (pm8001_ha->chip_id == chip_8001) {
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+			pm8001_ha->main_cfg_tbl.pm8001_tbl.max_out_io);
+	} else {
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+			pm8001_ha->main_cfg_tbl.pm80xx_tbl.max_out_io);
+	}
 }
 static DEVICE_ATTR(max_out_io, S_IRUGO, pm8001_ctl_max_out_io_show, NULL);
 /**
@@ -117,8 +135,15 @@ static ssize_t pm8001_ctl_max_devices_show(struct device *cdev,
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 
-	return snprintf(buf, PAGE_SIZE, "%04d\n",
-			(u16)(pm8001_ha->main_cfg_tbl.max_sgl >> 16));
+	if (pm8001_ha->chip_id == chip_8001) {
+		return snprintf(buf, PAGE_SIZE, "%04d\n",
+			(u16)(pm8001_ha->main_cfg_tbl.pm8001_tbl.max_sgl >> 16)
+			);
+	} else {
+		return snprintf(buf, PAGE_SIZE, "%04d\n",
+			(u16)(pm8001_ha->main_cfg_tbl.pm80xx_tbl.max_sgl >> 16)
+			);
+	}
 }
 static DEVICE_ATTR(max_devices, S_IRUGO, pm8001_ctl_max_devices_show, NULL);
 /**
@@ -136,8 +161,15 @@ static ssize_t pm8001_ctl_max_sg_list_show(struct device *cdev,
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 
-	return snprintf(buf, PAGE_SIZE, "%04d\n",
-			pm8001_ha->main_cfg_tbl.max_sgl & 0x0000FFFF);
+	if (pm8001_ha->chip_id == chip_8001) {
+		return snprintf(buf, PAGE_SIZE, "%04d\n",
+			pm8001_ha->main_cfg_tbl.pm8001_tbl.max_sgl & 0x0000FFFF
+			);
+	} else {
+		return snprintf(buf, PAGE_SIZE, "%04d\n",
+			pm8001_ha->main_cfg_tbl.pm80xx_tbl.max_sgl & 0x0000FFFF
+			);
+	}
 }
 static DEVICE_ATTR(max_sg_list, S_IRUGO, pm8001_ctl_max_sg_list_show, NULL);
 
@@ -173,7 +205,14 @@ static ssize_t pm8001_ctl_sas_spec_support_show(struct device *cdev,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
-	mode = (pm8001_ha->main_cfg_tbl.ctrl_cap_flag & 0xfe000000)>>25;
+	/* fe000000 means supports SAS2.1 */
+	if (pm8001_ha->chip_id == chip_8001)
+		mode = (pm8001_ha->main_cfg_tbl.pm8001_tbl.ctrl_cap_flag &
+							0xfe000000)>>25;
+	else
+		/* fe000000 means supports SAS2.1 */
+		mode = (pm8001_ha->main_cfg_tbl.pm80xx_tbl.ctrl_cap_flag &
+							0xfe000000)>>25;
 	return show_sas_spec_support_status(mode, buf);
 }
 static DEVICE_ATTR(sas_spec_support, S_IRUGO,
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index b8dd050..d04a613 100755
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -50,32 +50,39 @@
 static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
 {
 	void __iomem *address = pm8001_ha->main_cfg_tbl_addr;
-	pm8001_ha->main_cfg_tbl.signature	= pm8001_mr32(address, 0x00);
-	pm8001_ha->main_cfg_tbl.interface_rev	= pm8001_mr32(address, 0x04);
-	pm8001_ha->main_cfg_tbl.firmware_rev	= pm8001_mr32(address, 0x08);
-	pm8001_ha->main_cfg_tbl.max_out_io	= pm8001_mr32(address, 0x0C);
-	pm8001_ha->main_cfg_tbl.max_sgl		= pm8001_mr32(address, 0x10);
-	pm8001_ha->main_cfg_tbl.ctrl_cap_flag	= pm8001_mr32(address, 0x14);
-	pm8001_ha->main_cfg_tbl.gst_offset	= pm8001_mr32(address, 0x18);
-	pm8001_ha->main_cfg_tbl.inbound_queue_offset =
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.signature	=
+				pm8001_mr32(address, 0x00);
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.interface_rev =
+				pm8001_mr32(address, 0x04);
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.firmware_rev	=
+				pm8001_mr32(address, 0x08);
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.max_out_io	=
+				pm8001_mr32(address, 0x0C);
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.max_sgl	=
+				pm8001_mr32(address, 0x10);
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.ctrl_cap_flag =
+				pm8001_mr32(address, 0x14);
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.gst_offset	=
+				pm8001_mr32(address, 0x18);
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.inbound_queue_offset =
 		pm8001_mr32(address, MAIN_IBQ_OFFSET);
-	pm8001_ha->main_cfg_tbl.outbound_queue_offset =
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_queue_offset =
 		pm8001_mr32(address, MAIN_OBQ_OFFSET);
-	pm8001_ha->main_cfg_tbl.hda_mode_flag	=
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.hda_mode_flag	=
 		pm8001_mr32(address, MAIN_HDA_FLAGS_OFFSET);
 
 	/* read analog Setting offset from the configuration table */
-	pm8001_ha->main_cfg_tbl.anolog_setup_table_offset =
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.anolog_setup_table_offset =
 		pm8001_mr32(address, MAIN_ANALOG_SETUP_OFFSET);
 
 	/* read Error Dump Offset and Length */
-	pm8001_ha->main_cfg_tbl.fatal_err_dump_offset0 =
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_offset0 =
 		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP0_OFFSET);
-	pm8001_ha->main_cfg_tbl.fatal_err_dump_length0 =
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_length0 =
 		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP0_LENGTH);
-	pm8001_ha->main_cfg_tbl.fatal_err_dump_offset1 =
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_offset1 =
 		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP1_OFFSET);
-	pm8001_ha->main_cfg_tbl.fatal_err_dump_length1 =
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_dump_length1 =
 		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP1_LENGTH);
 }
 
@@ -86,31 +93,56 @@ static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
 static void read_general_status_table(struct pm8001_hba_info *pm8001_ha)
 {
 	void __iomem *address = pm8001_ha->general_stat_tbl_addr;
-	pm8001_ha->gs_tbl.gst_len_mpistate	= pm8001_mr32(address, 0x00);
-	pm8001_ha->gs_tbl.iq_freeze_state0	= pm8001_mr32(address, 0x04);
-	pm8001_ha->gs_tbl.iq_freeze_state1	= pm8001_mr32(address, 0x08);
-	pm8001_ha->gs_tbl.msgu_tcnt		= pm8001_mr32(address, 0x0C);
-	pm8001_ha->gs_tbl.iop_tcnt		= pm8001_mr32(address, 0x10);
-	pm8001_ha->gs_tbl.reserved		= pm8001_mr32(address, 0x14);
-	pm8001_ha->gs_tbl.phy_state[0]	= pm8001_mr32(address, 0x18);
-	pm8001_ha->gs_tbl.phy_state[1]	= pm8001_mr32(address, 0x1C);
-	pm8001_ha->gs_tbl.phy_state[2]	= pm8001_mr32(address, 0x20);
-	pm8001_ha->gs_tbl.phy_state[3]	= pm8001_mr32(address, 0x24);
-	pm8001_ha->gs_tbl.phy_state[4]	= pm8001_mr32(address, 0x28);
-	pm8001_ha->gs_tbl.phy_state[5]	= pm8001_mr32(address, 0x2C);
-	pm8001_ha->gs_tbl.phy_state[6]	= pm8001_mr32(address, 0x30);
-	pm8001_ha->gs_tbl.phy_state[7]	= pm8001_mr32(address, 0x34);
-	pm8001_ha->gs_tbl.reserved1		= pm8001_mr32(address, 0x38);
-	pm8001_ha->gs_tbl.reserved2		= pm8001_mr32(address, 0x3C);
-	pm8001_ha->gs_tbl.reserved3		= pm8001_mr32(address, 0x40);
-	pm8001_ha->gs_tbl.recover_err_info[0]	= pm8001_mr32(address, 0x44);
-	pm8001_ha->gs_tbl.recover_err_info[1]	= pm8001_mr32(address, 0x48);
-	pm8001_ha->gs_tbl.recover_err_info[2]	= pm8001_mr32(address, 0x4C);
-	pm8001_ha->gs_tbl.recover_err_info[3]	= pm8001_mr32(address, 0x50);
-	pm8001_ha->gs_tbl.recover_err_info[4]	= pm8001_mr32(address, 0x54);
-	pm8001_ha->gs_tbl.recover_err_info[5]	= pm8001_mr32(address, 0x58);
-	pm8001_ha->gs_tbl.recover_err_info[6]	= pm8001_mr32(address, 0x5C);
-	pm8001_ha->gs_tbl.recover_err_info[7]	= pm8001_mr32(address, 0x60);
+	pm8001_ha->gs_tbl.pm8001_tbl.gst_len_mpistate	=
+				pm8001_mr32(address, 0x00);
+	pm8001_ha->gs_tbl.pm8001_tbl.iq_freeze_state0	=
+				pm8001_mr32(address, 0x04);
+	pm8001_ha->gs_tbl.pm8001_tbl.iq_freeze_state1	=
+				pm8001_mr32(address, 0x08);
+	pm8001_ha->gs_tbl.pm8001_tbl.msgu_tcnt		=
+				pm8001_mr32(address, 0x0C);
+	pm8001_ha->gs_tbl.pm8001_tbl.iop_tcnt		=
+				pm8001_mr32(address, 0x10);
+	pm8001_ha->gs_tbl.pm8001_tbl.rsvd		=
+				pm8001_mr32(address, 0x14);
+	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[0]	=
+				pm8001_mr32(address, 0x18);
+	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[1]	=
+				pm8001_mr32(address, 0x1C);
+	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[2]	=
+				pm8001_mr32(address, 0x20);
+	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[3]	=
+				pm8001_mr32(address, 0x24);
+	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[4]	=
+				pm8001_mr32(address, 0x28);
+	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[5]	=
+				pm8001_mr32(address, 0x2C);
+	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[6]	=
+				pm8001_mr32(address, 0x30);
+	pm8001_ha->gs_tbl.pm8001_tbl.phy_state[7]	=
+				pm8001_mr32(address, 0x34);
+	pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[0]		=
+				pm8001_mr32(address, 0x38);
+	pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[1]		=
+				pm8001_mr32(address, 0x3C);
+	pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[2]		=
+				pm8001_mr32(address, 0x40);
+	pm8001_ha->gs_tbl.pm8001_tbl.recover_err_info[0]	=
+				pm8001_mr32(address, 0x44);
+	pm8001_ha->gs_tbl.pm8001_tbl.recover_err_info[1]	=
+				pm8001_mr32(address, 0x48);
+	pm8001_ha->gs_tbl.pm8001_tbl.recover_err_info[2]	=
+				pm8001_mr32(address, 0x4C);
+	pm8001_ha->gs_tbl.pm8001_tbl.recover_err_info[3]	=
+				pm8001_mr32(address, 0x50);
+	pm8001_ha->gs_tbl.pm8001_tbl.recover_err_info[4]	=
+				pm8001_mr32(address, 0x54);
+	pm8001_ha->gs_tbl.pm8001_tbl.recover_err_info[5]	=
+				pm8001_mr32(address, 0x58);
+	pm8001_ha->gs_tbl.pm8001_tbl.recover_err_info[6]	=
+				pm8001_mr32(address, 0x5C);
+	pm8001_ha->gs_tbl.pm8001_tbl.recover_err_info[7]	=
+				pm8001_mr32(address, 0x60);
 }
 
 /**
@@ -155,38 +187,41 @@ static void read_outbnd_queue_table(struct pm8001_hba_info *pm8001_ha)
  */
 static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 {
-	int qn = 1;
 	int i;
 	u32 offsetib, offsetob;
 	void __iomem *addressib = pm8001_ha->inbnd_q_tbl_addr;
 	void __iomem *addressob = pm8001_ha->outbnd_q_tbl_addr;
 
-	pm8001_ha->main_cfg_tbl.inbound_q_nppd_hppd			= 0;
-	pm8001_ha->main_cfg_tbl.outbound_hw_event_pid0_3 		= 0;
-	pm8001_ha->main_cfg_tbl.outbound_hw_event_pid4_7		= 0;
-	pm8001_ha->main_cfg_tbl.outbound_ncq_event_pid0_3		= 0;
-	pm8001_ha->main_cfg_tbl.outbound_ncq_event_pid4_7		= 0;
-	pm8001_ha->main_cfg_tbl.outbound_tgt_ITNexus_event_pid0_3	= 0;
-	pm8001_ha->main_cfg_tbl.outbound_tgt_ITNexus_event_pid4_7	= 0;
-	pm8001_ha->main_cfg_tbl.outbound_tgt_ssp_event_pid0_3	= 0;
-	pm8001_ha->main_cfg_tbl.outbound_tgt_ssp_event_pid4_7	= 0;
-	pm8001_ha->main_cfg_tbl.outbound_tgt_smp_event_pid0_3	= 0;
-	pm8001_ha->main_cfg_tbl.outbound_tgt_smp_event_pid4_7	= 0;
-
-	pm8001_ha->main_cfg_tbl.upper_event_log_addr		=
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.inbound_q_nppd_hppd		= 0;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_hw_event_pid0_3	= 0;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_hw_event_pid4_7	= 0;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_ncq_event_pid0_3	= 0;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_ncq_event_pid4_7	= 0;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_tgt_ITNexus_event_pid0_3 =
+									 0;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_tgt_ITNexus_event_pid4_7 =
+									 0;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_tgt_ssp_event_pid0_3 = 0;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_tgt_ssp_event_pid4_7 = 0;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_tgt_smp_event_pid0_3 = 0;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_tgt_smp_event_pid4_7 = 0;
+
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.upper_event_log_addr		=
 		pm8001_ha->memoryMap.region[AAP1].phys_addr_hi;
-	pm8001_ha->main_cfg_tbl.lower_event_log_addr		=
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.lower_event_log_addr		=
 		pm8001_ha->memoryMap.region[AAP1].phys_addr_lo;
-	pm8001_ha->main_cfg_tbl.event_log_size	= PM8001_EVENT_LOG_SIZE;
-	pm8001_ha->main_cfg_tbl.event_log_option		= 0x01;
-	pm8001_ha->main_cfg_tbl.upper_iop_event_log_addr	=
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.event_log_size		=
+		PM8001_EVENT_LOG_SIZE;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.event_log_option		= 0x01;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.upper_iop_event_log_addr	=
 		pm8001_ha->memoryMap.region[IOP].phys_addr_hi;
-	pm8001_ha->main_cfg_tbl.lower_iop_event_log_addr	=
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.lower_iop_event_log_addr	=
 		pm8001_ha->memoryMap.region[IOP].phys_addr_lo;
-	pm8001_ha->main_cfg_tbl.iop_event_log_size	= PM8001_EVENT_LOG_SIZE;
-	pm8001_ha->main_cfg_tbl.iop_event_log_option		= 0x01;
-	pm8001_ha->main_cfg_tbl.fatal_err_interrupt		= 0x01;
-	for (i = 0; i < qn; i++) {
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.iop_event_log_size		=
+		PM8001_EVENT_LOG_SIZE;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.iop_event_log_option		= 0x01;
+	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_interrupt		= 0x01;
+	for (i = 0; i < PM8001_MAX_INB_NUM; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
 			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
@@ -212,7 +247,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->inbnd_q_tbl[i].producer_idx		= 0;
 		pm8001_ha->inbnd_q_tbl[i].consumer_index	= 0;
 	}
-	for (i = 0; i < qn; i++) {
+	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
 			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
@@ -250,42 +285,51 @@ static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 {
 	void __iomem *address = pm8001_ha->main_cfg_tbl_addr;
 	pm8001_mw32(address, 0x24,
-		pm8001_ha->main_cfg_tbl.inbound_q_nppd_hppd);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.inbound_q_nppd_hppd);
 	pm8001_mw32(address, 0x28,
-		pm8001_ha->main_cfg_tbl.outbound_hw_event_pid0_3);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_hw_event_pid0_3);
 	pm8001_mw32(address, 0x2C,
-		pm8001_ha->main_cfg_tbl.outbound_hw_event_pid4_7);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_hw_event_pid4_7);
 	pm8001_mw32(address, 0x30,
-		pm8001_ha->main_cfg_tbl.outbound_ncq_event_pid0_3);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_ncq_event_pid0_3);
 	pm8001_mw32(address, 0x34,
-		pm8001_ha->main_cfg_tbl.outbound_ncq_event_pid4_7);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.outbound_ncq_event_pid4_7);
 	pm8001_mw32(address, 0x38,
-		pm8001_ha->main_cfg_tbl.outbound_tgt_ITNexus_event_pid0_3);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.
+					outbound_tgt_ITNexus_event_pid0_3);
 	pm8001_mw32(address, 0x3C,
-		pm8001_ha->main_cfg_tbl.outbound_tgt_ITNexus_event_pid4_7);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.
+					outbound_tgt_ITNexus_event_pid4_7);
 	pm8001_mw32(address, 0x40,
-		pm8001_ha->main_cfg_tbl.outbound_tgt_ssp_event_pid0_3);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.
+					outbound_tgt_ssp_event_pid0_3);
 	pm8001_mw32(address, 0x44,
-		pm8001_ha->main_cfg_tbl.outbound_tgt_ssp_event_pid4_7);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.
+					outbound_tgt_ssp_event_pid4_7);
 	pm8001_mw32(address, 0x48,
-		pm8001_ha->main_cfg_tbl.outbound_tgt_smp_event_pid0_3);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.
+					outbound_tgt_smp_event_pid0_3);
 	pm8001_mw32(address, 0x4C,
-		pm8001_ha->main_cfg_tbl.outbound_tgt_smp_event_pid4_7);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.
+					outbound_tgt_smp_event_pid4_7);
 	pm8001_mw32(address, 0x50,
-		pm8001_ha->main_cfg_tbl.upper_event_log_addr);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.upper_event_log_addr);
 	pm8001_mw32(address, 0x54,
-		pm8001_ha->main_cfg_tbl.lower_event_log_addr);
-	pm8001_mw32(address, 0x58, pm8001_ha->main_cfg_tbl.event_log_size);
-	pm8001_mw32(address, 0x5C, pm8001_ha->main_cfg_tbl.event_log_option);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.lower_event_log_addr);
+	pm8001_mw32(address, 0x58,
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.event_log_size);
+	pm8001_mw32(address, 0x5C,
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.event_log_option);
 	pm8001_mw32(address, 0x60,
-		pm8001_ha->main_cfg_tbl.upper_iop_event_log_addr);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.upper_iop_event_log_addr);
 	pm8001_mw32(address, 0x64,
-		pm8001_ha->main_cfg_tbl.lower_iop_event_log_addr);
-	pm8001_mw32(address, 0x68, pm8001_ha->main_cfg_tbl.iop_event_log_size);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.lower_iop_event_log_addr);
+	pm8001_mw32(address, 0x68,
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.iop_event_log_size);
 	pm8001_mw32(address, 0x6C,
-		pm8001_ha->main_cfg_tbl.iop_event_log_option);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.iop_event_log_option);
 	pm8001_mw32(address, 0x70,
-		pm8001_ha->main_cfg_tbl.fatal_err_interrupt);
+		pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_interrupt);
 }
 
 /**
-- 
1.7.1

