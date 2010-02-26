From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 15/32] bfa: PCI VPD, FIP and include file changes.
Date: Thu, 25 Feb 2010 17:48:48 -0800
Message-ID: <1267148928-22777-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:59509 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934915Ab0BZBv4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:51:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Change details:

	- Changed PCI VPD to incorporate specific OEM vendors.

	- Added FCoE specific interrupt latency and delay params.

	- Added some variables needed by FIP 2.0.

	- Added some new logging and tracing definitions.

	- Added reserved members to make the structures (IOC, IOCFC) 64bit aligned.

	- Changed the module identifiers, as some files were moved.
---
 drivers/scsi/bfa/bfa_ioc.c                      |    4 +-
 drivers/scsi/bfa/bfa_trcmod_priv.h              |   62 ++++++-------
 drivers/scsi/bfa/include/defs/bfa_defs_cee.h    |   14 ++--
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h    |    1 +
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h  |   11 ++-
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h    |  109 ++++++++++++++++++++---
 drivers/scsi/bfa/include/defs/bfa_defs_port.h   |    4 +-
 drivers/scsi/bfa/include/defs/bfa_defs_status.h |   12 ++-
 drivers/scsi/bfa/include/log/bfa_log_hal.h      |    6 ++
 drivers/scsi/bfa/include/log/bfa_log_linux.h    |   16 ++++
 10 files changed, 179 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index a5f9745..8a6361c 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -18,7 +18,7 @@
 #include <bfa.h>
 #include <bfa_ioc.h>
 #include <bfa_fwimg_priv.h>
-#include <bfa_trcmod_priv.h>
+#include <cna/bfa_cna_trcmod.h>
 #include <cs/bfa_debug.h>
 #include <bfi/bfi_ioc.h>
 #include <bfi/bfi_ctreg.h>
@@ -27,7 +27,7 @@
 #include <log/bfa_log_hal.h>
 #include <defs/bfa_defs_pci.h>
 
-BFA_TRC_FILE(HAL, IOC);
+BFA_TRC_FILE(CNA, IOC);
 
 /**
  * IOC local definitions
diff --git a/drivers/scsi/bfa/bfa_trcmod_priv.h b/drivers/scsi/bfa/bfa_trcmod_priv.h
index b3562dc..a7a8261 100644
--- a/drivers/scsi/bfa/bfa_trcmod_priv.h
+++ b/drivers/scsi/bfa/bfa_trcmod_priv.h
@@ -29,38 +29,36 @@
  * !!! needed between trace utility and driver version
  */
 enum {
-	BFA_TRC_HAL_IOC		= 1,
-	BFA_TRC_HAL_INTR	= 2,
-	BFA_TRC_HAL_FCXP	= 3,
-	BFA_TRC_HAL_UF		= 4,
-	BFA_TRC_HAL_DIAG	= 5,
-	BFA_TRC_HAL_RPORT	= 6,
-	BFA_TRC_HAL_FCPIM	= 7,
-	BFA_TRC_HAL_IOIM	= 8,
-	BFA_TRC_HAL_TSKIM	= 9,
-	BFA_TRC_HAL_ITNIM	= 10,
-	BFA_TRC_HAL_PPORT	= 11,
-	BFA_TRC_HAL_SGPG	= 12,
-	BFA_TRC_HAL_FLASH	= 13,
-	BFA_TRC_HAL_DEBUG	= 14,
-	BFA_TRC_HAL_WWN		= 15,
-	BFA_TRC_HAL_FLASH_RAW	= 16,
-	BFA_TRC_HAL_SBOOT	= 17,
-	BFA_TRC_HAL_SBOOT_IO	= 18,
-	BFA_TRC_HAL_SBOOT_INTR	= 19,
-	BFA_TRC_HAL_SBTEST	= 20,
-	BFA_TRC_HAL_IPFC	= 21,
-	BFA_TRC_HAL_IOCFC	= 22,
-	BFA_TRC_HAL_FCPTM	= 23,
-	BFA_TRC_HAL_IOTM	= 24,
-	BFA_TRC_HAL_TSKTM	= 25,
-	BFA_TRC_HAL_TIN		= 26,
-	BFA_TRC_HAL_LPS		= 27,
-	BFA_TRC_HAL_FCDIAG	= 28,
-	BFA_TRC_HAL_PBIND	= 29,
-	BFA_TRC_HAL_IOCFC_CT	= 30,
-	BFA_TRC_HAL_IOCFC_CB	= 31,
-	BFA_TRC_HAL_IOCFC_Q	= 32,
+	BFA_TRC_HAL_INTR	= 1,
+	BFA_TRC_HAL_FCXP	= 2,
+	BFA_TRC_HAL_UF		= 3,
+	BFA_TRC_HAL_RPORT	= 4,
+	BFA_TRC_HAL_FCPIM	= 5,
+	BFA_TRC_HAL_IOIM	= 6,
+	BFA_TRC_HAL_TSKIM	= 7,
+	BFA_TRC_HAL_ITNIM	= 8,
+	BFA_TRC_HAL_FCPORT	= 9,
+	BFA_TRC_HAL_SGPG	= 10,
+	BFA_TRC_HAL_FLASH	= 11,
+	BFA_TRC_HAL_DEBUG	= 12,
+	BFA_TRC_HAL_WWN		= 13,
+	BFA_TRC_HAL_FLASH_RAW	= 14,
+	BFA_TRC_HAL_SBOOT	= 15,
+	BFA_TRC_HAL_SBOOT_IO	= 16,
+	BFA_TRC_HAL_SBOOT_INTR	= 17,
+	BFA_TRC_HAL_SBTEST	= 18,
+	BFA_TRC_HAL_IPFC	= 19,
+	BFA_TRC_HAL_IOCFC	= 20,
+	BFA_TRC_HAL_FCPTM	= 21,
+	BFA_TRC_HAL_IOTM	= 22,
+	BFA_TRC_HAL_TSKTM	= 23,
+	BFA_TRC_HAL_TIN		= 24,
+	BFA_TRC_HAL_LPS		= 25,
+	BFA_TRC_HAL_FCDIAG	= 26,
+	BFA_TRC_HAL_PBIND	= 27,
+	BFA_TRC_HAL_IOCFC_CT	= 28,
+	BFA_TRC_HAL_IOCFC_CB	= 29,
+	BFA_TRC_HAL_IOCFC_Q	= 30,
 };
 
 #endif /* __BFA_TRCMOD_PRIV_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_cee.h b/drivers/scsi/bfa/include/defs/bfa_defs_cee.h
index 520a22f..b0ac9ac 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_cee.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_cee.h
@@ -28,10 +28,6 @@
 
 #define BFA_CEE_LLDP_MAX_STRING_LEN (128)
 
-
-/* FIXME: this is coming from the protocol spec. Can the host & apps share the
-   protocol .h files ?
- */
 #define BFA_CEE_LLDP_SYS_CAP_OTHER       0x0001
 #define BFA_CEE_LLDP_SYS_CAP_REPEATER    0x0002
 #define BFA_CEE_LLDP_SYS_CAP_MAC_BRIDGE  0x0004
@@ -94,9 +90,10 @@ struct bfa_cee_dcbx_cfg_s {
 /* CEE status */
 /* Making this to tri-state for the benefit of port list command */
 enum bfa_cee_status_e {
-    CEE_PHY_DOWN = 0,
-    CEE_PHY_UP = 1,
-    CEE_UP = 2,
+	CEE_UP = 0,
+	CEE_PHY_UP = 1,
+	CEE_LOOPBACK = 2,
+	CEE_PHY_DOWN = 3,
 };
 
 /* CEE Query */
@@ -107,7 +104,8 @@ struct bfa_cee_attr_s {
 	struct bfa_cee_dcbx_cfg_s dcbx_remote;
 	mac_t src_mac;
 	u8 link_speed;
-	u8 filler[3];
+	u8 nw_priority;
+	u8 filler[2];
 };
 
 
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h b/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
index b1d532d..6c721b1 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
@@ -126,6 +126,7 @@ struct bfa_ioc_attr_s {
 	struct bfa_ioc_driver_attr_s 	driver_attr;	/*  driver attr    */
 	struct bfa_ioc_pci_attr_s	pci_attr;
 	u8				port_id;	/*  port number    */
+	u8				rsvd[7];	/*!< 64bit align    */
 };
 
 /**
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h b/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
index d76bcbd..87f0401 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
@@ -26,6 +26,8 @@
 
 #define BFA_IOCFC_INTR_DELAY	1125
 #define BFA_IOCFC_INTR_LATENCY	225
+#define BFA_IOCFCOE_INTR_DELAY  25
+#define BFA_IOCFCOE_INTR_LATENCY 5
 
 /**
  * Interrupt coalescing configuration.
@@ -50,7 +52,7 @@ struct bfa_iocfc_fwcfg_s {
 	u16        num_fcxp_reqs;	/*  unassisted FC exchanges	*/
 	u16        num_uf_bufs;	/*  unsolicited recv buffers	*/
 	u8		num_cqs;
-	u8		rsvd;
+	u8		rsvd[5];
 };
 
 struct bfa_iocfc_drvcfg_s {
@@ -224,6 +226,11 @@ struct bfa_fw_port_physm_stats_s {
 
 
 struct bfa_fw_fip_stats_s {
+    u32    vlan_req;           /*  vlan discovery requests             */
+    u32    vlan_notify;        /*  vlan notifications                  */
+    u32    vlan_err;           /*  vlan response error                 */
+    u32    vlan_timeouts;      /*  vlan disvoery timeouts              */
+    u32    vlan_invalids;      /*  invalid vlan in discovery advert.   */
     u32    disc_req;           /*  Discovery solicit requests          */
     u32    disc_rsp;           /*  Discovery solicit response          */
     u32    disc_err;           /*  Discovery advt. parse errors        */
@@ -235,7 +242,7 @@ struct bfa_fw_fip_stats_s {
     u32    clrvlink_req;       /*  Clear virtual link req              */
     u32    op_unsupp;          /*  Unsupported FIP operation           */
     u32    untagged;           /*  Untagged frames (ignored)           */
-    u32    rsvd;
+    u32	   invalid_version;    /*!< Invalid FIP version           */
 };
 
 
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h b/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
index 13fd4ab..bc61656 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
@@ -22,7 +22,47 @@
 /**
  * Manufacturing block version
  */
-#define BFA_MFG_VERSION				1
+#define BFA_MFG_VERSION				2
+
+/**
+ * Manufacturing block encrypted version
+ */
+#define BFA_MFG_ENC_VER				2
+
+/**
+ * Manufacturing block version 1 length
+ */
+#define BFA_MFG_VER1_LEN			128
+
+/**
+ * Manufacturing block header length
+ */
+#define BFA_MFG_HDR_LEN				4
+
+/**
+ * Checksum size
+ */
+#define BFA_MFG_CHKSUM_SIZE			16
+
+/**
+ * Manufacturing block encrypted version
+ */
+#define BFA_MFG_ENC_VER				2
+
+/**
+ * Manufacturing block version 1 length
+ */
+#define BFA_MFG_VER1_LEN			128
+
+/**
+ * Manufacturing block header length
+ */
+#define BFA_MFG_HDR_LEN				4
+
+/**
+ * Checksum size
+ */
+#define BFA_MFG_CHKSUM_SIZE			16
 
 /**
  * Manufacturing block format
@@ -30,29 +70,72 @@
 #define BFA_MFG_SERIALNUM_SIZE			11
 #define BFA_MFG_PARTNUM_SIZE			14
 #define BFA_MFG_SUPPLIER_ID_SIZE		10
-#define BFA_MFG_SUPPLIER_PARTNUM_SIZE	20
-#define BFA_MFG_SUPPLIER_SERIALNUM_SIZE	20
-#define BFA_MFG_SUPPLIER_REVISION_SIZE	4
+#define BFA_MFG_SUPPLIER_PARTNUM_SIZE		20
+#define BFA_MFG_SUPPLIER_SERIALNUM_SIZE		20
+#define BFA_MFG_SUPPLIER_REVISION_SIZE		4
 #define STRSZ(_n)	(((_n) + 4) & ~3)
 
 /**
+ * Manufacturing card type
+ */
+enum {
+	BFA_MFG_TYPE_CB_MAX  = 825,      /*  Crossbow card type max	*/
+	BFA_MFG_TYPE_FC8P2   = 825,      /*  8G 2port FC card		*/
+	BFA_MFG_TYPE_FC8P1   = 815,      /*  8G 1port FC card		*/
+	BFA_MFG_TYPE_FC4P2   = 425,      /*  4G 2port FC card		*/
+	BFA_MFG_TYPE_FC4P1   = 415,      /*  4G 1port FC card		*/
+	BFA_MFG_TYPE_CNA10P2 = 1020,     /*  10G 2port CNA card	*/
+	BFA_MFG_TYPE_CNA10P1 = 1010,     /*  10G 1port CNA card	*/
+};
+
+#pragma pack(1)
+
+/**
+ * Card type to port number conversion
+ */
+#define bfa_mfg_type2port_num(card_type) (((card_type) / 10) % 10)
+
+
+/**
+ * All numerical fields are in big-endian format.
+ */
+struct bfa_mfg_block_s {
+};
+
+/**
  * VPD data length
  */
-#define BFA_MFG_VPD_LEN     256
+#define BFA_MFG_VPD_LEN		512
+
+#define BFA_MFG_VPD_PCI_HDR_OFF		137
+#define BFA_MFG_VPD_PCI_VER_MASK	0x07	/*  version mask 3 bits */
+#define BFA_MFG_VPD_PCI_VDR_MASK	0xf8	/*  vendor mask 5 bits */
+
+/**
+ * VPD vendor tag
+ */
+enum {
+	BFA_MFG_VPD_UNKNOWN	= 0,     /*  vendor unknown 		*/
+	BFA_MFG_VPD_IBM 	= 1,     /*  vendor IBM 		*/
+	BFA_MFG_VPD_HP  	= 2,     /*  vendor HP  		*/
+	BFA_MFG_VPD_PCI_IBM 	= 0x08,  /*  PCI VPD IBM     		*/
+	BFA_MFG_VPD_PCI_HP  	= 0x10,  /*  PCI VPD HP		*/
+	BFA_MFG_VPD_PCI_BRCD 	= 0xf8,  /*  PCI VPD Brocade 		*/
+};
 
 /**
  * All numerical fields are in big-endian format.
  */
 struct bfa_mfg_vpd_s {
-    u8     version;    /*  vpd data version */
-    u8     vpd_sig[3]; /*  characters 'V', 'P', 'D' */
-    u8     chksum;     /*  u8 checksum */
-    u8     vendor;     /*  vendor */
-    u8     len;        /*  vpd data length excluding header */
-    u8     rsv;
-    u8     data[BFA_MFG_VPD_LEN];  /*  vpd data */
+	u8		version;	/*  vpd data version */
+	u8		vpd_sig[3];	/*  characters 'V', 'P', 'D' */
+	u8		chksum;		/*  u8 checksum */
+	u8		vendor;		/*  vendor */
+	u8 	len;		/*  vpd data length excluding header */
+	u8 	rsv;
+	u8		data[BFA_MFG_VPD_LEN];	/*  vpd data */
 };
 
-#pragma pack(1)
+#pragma pack()
 
 #endif /* __BFA_DEFS_MFG_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_port.h b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
index de0696c..b54b341 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_port.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
@@ -185,6 +185,8 @@ struct bfa_port_attr_s {
 	wwn_t		fabric_name; /*  attached switch's nwwn */
 	u8		fabric_ip_addr[BFA_FCS_FABRIC_IPADDR_SZ]; /*  attached
 							* fabric's ip addr */
+	struct mac_s    fpma_mac;       /*  Lport's FPMA Mac address */
+	u16     authfail;       /*  auth failed state */
 };
 
 /**
@@ -235,7 +237,7 @@ struct bfa_port_aen_data_s {
 	enum bfa_ioc_type_e ioc_type;
 	wwn_t           pwwn;	      /*  WWN of the physical port */
 	wwn_t           fwwn;	      /*  WWN of the fabric port */
-	mac_t           mac;	      /*  MAC addres of the ethernet port,
+	mac_t           mac;	      /*  MAC address of the ethernet port,
 				       * applicable to CNA port only */
 	int             phy_port_num; /*! For SFP related events */
 	enum bfa_port_aen_sfp_pom level; /*  Only transitions will
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_status.h b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
index cdceaeb..d8a74eb 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_status.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
@@ -180,8 +180,8 @@ enum bfa_status {
 	BFA_STATUS_IM_ADAPT_ALREADY_IN_TEAM = 114, /*  Given adapter is part
 						    * of another team */
 	BFA_STATUS_IM_ADAPT_HAS_VLANS = 115, /*  Adapter has VLANs configured.
-					      * Delete all VLANs before
-					      * creating team */
+					      * Delete all VLANs to become
+					      * part of the team */
 	BFA_STATUS_IM_PVID_MISMATCH = 116, /*  Mismatching PVIDs configured
 					    * for adapters */
 	BFA_STATUS_IM_LINK_SPEED_MISMATCH = 117, /*  Mismatching link speeds
@@ -242,6 +242,14 @@ enum bfa_status {
 					  * failed */
 	BFA_STATUS_IM_UNBIND_FAILED = 149, /* ! < IM Driver unbind operation
 					    * failed */
+	BFA_STATUS_IM_PORT_IN_TEAM = 150, /*  Port is already part of the
+					   * team */
+	BFA_STATUS_IM_VLAN_NOT_FOUND = 151, /*  VLAN ID doesn't exists */
+	BFA_STATUS_IM_TEAM_NOT_FOUND = 152, /*  Teaming configuration doesn't
+					     * exists */
+	BFA_STATUS_IM_TEAM_CFG_NOT_ALLOWED = 153, /*  Given settings are not
+						* allowed for the current
+						* Teaming mode */
 	BFA_STATUS_MAX_VAL		/*  Unknown error code */
 };
 #define bfa_status_t enum bfa_status
diff --git a/drivers/scsi/bfa/include/log/bfa_log_hal.h b/drivers/scsi/bfa/include/log/bfa_log_hal.h
index 0412aea..5f8f5e3 100644
--- a/drivers/scsi/bfa/include/log/bfa_log_hal.h
+++ b/drivers/scsi/bfa/include/log/bfa_log_hal.h
@@ -27,4 +27,10 @@
 	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 3)
 #define BFA_LOG_HAL_SM_ASSERT \
 	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 4)
+#define BFA_LOG_HAL_DRIVER_ERROR \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 5)
+#define BFA_LOG_HAL_DRIVER_CONFIG_ERROR \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 6)
+#define BFA_LOG_HAL_MBOX_ERROR \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 7)
 #endif
diff --git a/drivers/scsi/bfa/include/log/bfa_log_linux.h b/drivers/scsi/bfa/include/log/bfa_log_linux.h
index 317c054..bd451db 100644
--- a/drivers/scsi/bfa/include/log/bfa_log_linux.h
+++ b/drivers/scsi/bfa/include/log/bfa_log_linux.h
@@ -41,4 +41,20 @@
 		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 10)
 #define BFA_LOG_LINUX_SCSI_ABORT_COMP \
 		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 11)
+#define BFA_LOG_LINUX_DRIVER_CONFIG_ERROR \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 12)
+#define BFA_LOG_LINUX_BNA_STATE_MACHINE \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 13)
+#define BFA_LOG_LINUX_IOC_ERROR \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 14)
+#define BFA_LOG_LINUX_RESOURCE_ALLOC_ERROR \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 15)
+#define BFA_LOG_LINUX_RING_BUFFER_ERROR \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 16)
+#define BFA_LOG_LINUX_DRIVER_ERROR \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 17)
+#define BFA_LOG_LINUX_DRIVER_DIAG \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 18)
+#define BFA_LOG_LINUX_DRIVER_AEN \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 19)
 #endif
-- 
1.6.5.3

