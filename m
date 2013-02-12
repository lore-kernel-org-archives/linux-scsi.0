From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 03/15] pm80xx: Added and modified structures, variables and
 macros for SPCv/ve
Date: Tue, 12 Feb 2013 04:29:24 -0800
Message-ID: <511A35A4.7040109@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:53726 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932303Ab3BLM2m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 07:28:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

>From 5afe6aff983aed38a46bdc9ec26d1035d79d9bb0 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 4 Feb 2013 13:46:35 +0530
Subject: [PATCH 03/15] pm80xx: Added and modified structures, variables and macros for SPCv/ve

Added SPCv/ve related macros. Updated macros, hba info structure and
other structures for SPCv/ve.

Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_defs.h |   19 ++++++--
 drivers/scsi/pm8001/pm8001_init.c |   10 ++++-
 drivers/scsi/pm8001/pm8001_sas.h  |   96 ++++++++++++++++++++++++++++++++-----
 3 files changed, 108 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index c3d20c8..b25f87c 100755
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -1,5 +1,5 @@
 /*
- * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver
+ * PMC-Sierra 8001/8081/8088/8089 SAS/SATA based host adapters driver
  *
  * Copyright (c) 2008-2009 USI Co., Ltd.
  * All rights reserved.
@@ -43,6 +43,10 @@
 
 enum chip_flavors {
 	chip_8001,
+	chip_8008,
+	chip_8009,
+	chip_8018,
+	chip_8019
 };
 #define USI_MAX_MEMCNT			9
 #define PM8001_MAX_DMA_SG		SG_ALL
@@ -69,12 +73,19 @@ enum port_type {
 #define PM8001_MPI_QUEUE         1024   /* maximum mpi queue entries */
 #define	PM8001_MAX_INB_NUM	 1
 #define	PM8001_MAX_OUTB_NUM	 1
+#define	PM8001_MAX_SPCV_INB_NUM		1
+#define	PM8001_MAX_SPCV_OUTB_NUM	4
 #define	PM8001_CAN_QUEUE	 508	/* SCSI Queue depth */
 
+/* Inbound/Outbound queue size */
+#define IOMB_SIZE_SPC		64
+#define IOMB_SIZE_SPCV		128
+
 /* unchangeable hardware details */
-#define	PM8001_MAX_PHYS		 8	/* max. possible phys */
-#define	PM8001_MAX_PORTS	 8	/* max. possible ports */
-#define	PM8001_MAX_DEVICES	 1024	/* max supported device */
+#define	PM8001_MAX_PHYS		 16	/* max. possible phys */
+#define	PM8001_MAX_PORTS	 16	/* max. possible ports */
+#define	PM8001_MAX_DEVICES	 2048	/* max supported device */
+#define	PM8001_MAX_MSIX_VEC	 64	/* max msi-x int for spcv/ve */
 
 enum memory_region_num {
 	AAP1 = 0x0, /* application acceleration processor */
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 1d883e9..5ce8330 100755
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -44,8 +44,16 @@
 
 static struct scsi_transport_template *pm8001_stt;
 
+/**
+ * chip info structure to identify chip key functionality as
+ * encryption available/not, no of ports, hw specific function ref
+ */
 static const struct pm8001_chip_info pm8001_chips[] = {
-	[chip_8001] = {  8, &pm8001_8001_dispatch,},
+	[chip_8001] = {0,  8, &pm8001_8001_dispatch,},
+	[chip_8008] = {0,  8, &pm8001_80xx_dispatch,},
+	[chip_8009] = {1,  8, &pm8001_80xx_dispatch,},
+	[chip_8018] = {0,  16, &pm8001_80xx_dispatch,},
+	[chip_8019] = {1,  16, &pm8001_80xx_dispatch,},
 };
 static int pm8001_id;
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 1100820..bf4963e 100755
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -108,6 +108,7 @@ do {						\
 #define PM8001_NAME_LENGTH		32/* generic length of strings */
 extern struct list_head hba_list;
 extern const struct pm8001_dispatch pm8001_8001_dispatch;
+extern const struct pm8001_dispatch pm8001_80xx_dispatch;
 
 struct pm8001_hba_info;
 struct pm8001_ccb_info;
@@ -173,6 +174,7 @@ struct pm8001_dispatch {
 };
 
 struct pm8001_chip_info {
+	u32     encrypt;
 	u32	n_phy;
 	const struct pm8001_dispatch	*dispatch;
 };
@@ -256,7 +258,20 @@ struct mpi_mem_req {
 	struct mpi_mem		region[USI_MAX_MEMCNT];
 };
 
-struct main_cfg_table {
+struct encrypt {
+	u32	cipher_mode;
+	u32	sec_mode;
+	u32	status;
+	u32	flag;
+};
+
+struct sas_phy_attribute_table {
+	u32	phystart1_16[16];
+	u32	outbound_hw_event_pid1_16[16];
+};
+
+union main_cfg_table {
+	struct {
 	u32			signature;
 	u32			interface_rev;
 	u32			firmware_rev;
@@ -292,19 +307,67 @@ struct main_cfg_table {
 	u32			fatal_err_dump_length1;
 	u32			hda_mode_flag;
 	u32			anolog_setup_table_offset;
+	u32			rsvd[4];
+	} pm8001_tbl;
+
+	struct {
+	u32			signature;
+	u32			interface_rev;
+	u32			firmware_rev;
+	u32			max_out_io;
+	u32			max_sgl;
+	u32			ctrl_cap_flag;
+	u32			gst_offset;
+	u32			inbound_queue_offset;
+	u32			outbound_queue_offset;
+	u32			inbound_q_nppd_hppd;
+	u32			rsvd[10];
+	u32			upper_event_log_addr;
+	u32			lower_event_log_addr;
+	u32			event_log_size;
+	u32			event_log_severity;
+	u32			upper_pcs_event_log_addr;
+	u32			lower_pcs_event_log_addr;
+	u32			pcs_event_log_size;
+	u32			pcs_event_log_severity;
+	u32			fatal_err_interrupt;
+	u32			fatal_err_dump_offset0;
+	u32			fatal_err_dump_length0;
+	u32			fatal_err_dump_offset1;
+	u32			fatal_err_dump_length1;
+	u32			gpio_led_mapping;
+	u32			analog_setup_table_offset;
+	u32			int_vec_table_offset;
+	u32			phy_attr_table_offset;
+	u32			port_recovery_timer;
+	u32			interrupt_reassertion_delay;
+	} pm80xx_tbl;
 };
-struct general_status_table {
+
+union general_status_table {
+	struct {
 	u32			gst_len_mpistate;
 	u32			iq_freeze_state0;
 	u32			iq_freeze_state1;
 	u32			msgu_tcnt;
 	u32			iop_tcnt;
-	u32			reserved;
+	u32			rsvd;
 	u32			phy_state[8];
-	u32			reserved1;
-	u32			reserved2;
-	u32			reserved3;
+	u32			gpio_input_val;
+	u32			rsvd1[2];
+	u32			recover_err_info[8];
+	} pm8001_tbl;
+	struct {
+	u32			gst_len_mpistate;
+	u32			iq_freeze_state0;
+	u32			iq_freeze_state1;
+	u32			msgu_tcnt;
+	u32			iop_tcnt;
+	u32			rsvd[9];
+	u32			gpio_input_val;
+	u32			rsvd1[2];
 	u32			recover_err_info[8];
+	} pm80xx_tbl;
 };
 struct inbound_queue_table {
 	u32			element_pri_size_cnt;
@@ -351,15 +414,21 @@ struct pm8001_hba_info {
 	struct device		*dev;
 	struct pm8001_hba_memspace io_mem[6];
 	struct mpi_mem_req	memoryMap;
+	struct encrypt		encrypt_info; /* support encryption */
 	void __iomem	*msg_unit_tbl_addr;/*Message Unit Table Addr*/
 	void __iomem	*main_cfg_tbl_addr;/*Main Config Table Addr*/
 	void __iomem	*general_stat_tbl_addr;/*General Status Table Addr*/
 	void __iomem	*inbnd_q_tbl_addr;/*Inbound Queue Config Table Addr*/
 	void __iomem	*outbnd_q_tbl_addr;/*Outbound Queue Config Table Addr*/
-	struct main_cfg_table	main_cfg_tbl;
-	struct general_status_table	gs_tbl;
-	struct inbound_queue_table	inbnd_q_tbl[PM8001_MAX_INB_NUM];
-	struct outbound_queue_table	outbnd_q_tbl[PM8001_MAX_OUTB_NUM];
+	void __iomem	*pspa_q_tbl_addr;
+			/*MPI SAS PHY attributes Queue Config Table Addr*/
+	void __iomem	*ivt_tbl_addr; /*MPI IVT Table Addr */
+	union main_cfg_table	main_cfg_tbl;
+	union general_status_table	gs_tbl;
+	struct inbound_queue_table	inbnd_q_tbl[PM8001_MAX_SPCV_INB_NUM];
+	struct outbound_queue_table	outbnd_q_tbl[PM8001_MAX_SPCV_OUTB_NUM];
+	struct sas_phy_attribute_table	phy_attr_table;
+					/* MPI SAS PHY attributes */
 	u8			sas_addr[SAS_ADDR_SIZE];
 	struct sas_ha_struct	*sas;/* SCSI/SAS glue */
 	struct Scsi_Host	*shost;
@@ -372,14 +441,17 @@ struct pm8001_hba_info {
 	struct pm8001_port	port[PM8001_MAX_PHYS];
 	u32			id;
 	u32			irq;
+	u32			iomb_size; /* SPC and SPCV IOMB size */
 	struct pm8001_device	*devices;
 	struct pm8001_ccb_info	*ccb_info;
 #ifdef PM8001_USE_MSIX
-	struct msix_entry	msix_entries[16];/*for msi-x interrupt*/
+	struct msix_entry	msix_entries[PM8001_MAX_MSIX_VEC];
+					/*for msi-x interrupt*/
 	int			number_of_intr;/*will be used in remove()*/
 #endif
 #ifdef PM8001_USE_TASKLET
-	struct tasklet_struct	tasklet;
+	struct tasklet_struct	tasklet[PM8001_MAX_MSIX_VEC];
+				/* spcv - multiple tasklet for msi-x */
 #endif
 	u32			logging_level;
 	u32			fw_status;
-- 
1.7.1

