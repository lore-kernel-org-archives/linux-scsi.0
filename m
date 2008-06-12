From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [RFC] Move FC definitions from zfcp to global header
Date: Thu, 12 Jun 2008 15:02:46 +0200
Message-ID: <20080612130245.GA13761@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:51416 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761099AbYFLNDf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2008 09:03:35 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate8.uk.ibm.com (8.13.8/8.13.8) with ESMTP id m5CD2q95450274
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2008 13:02:52 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CD2qGQ2039964
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2008 14:02:52 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CD2qTT010066
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2008 14:02:52 +0100
Received: from localhost (schmichrtp.mainz.de.ibm.com [9.155.23.50])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m5CD2pd5009920
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2008 14:02:51 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This was suggested a while ago, now i finally put together a patch
that moves the Fibre Channel protocol definitions from zfcp to a new
global header file. With the global header, the definitions can be
shared across all FC drives.

The new file contains only the definitions used by zfcp. My idea is
that others add definitions for other parts of the protocols as
needed.

Would this approach be ok, or should i take a different approach?

Christof
---
 drivers/s390/scsi/zfcp_aux.c  |   15 +-
 drivers/s390/scsi/zfcp_dbf.c  |    1 
 drivers/s390/scsi/zfcp_def.h  |  199 -----------------------------------
 drivers/s390/scsi/zfcp_ext.h  |    1 
 drivers/s390/scsi/zfcp_fc.c   |   57 +++++-----
 drivers/s390/scsi/zfcp_fsf.c  |   31 ++---
 drivers/s390/scsi/zfcp_scsi.c |    1 
 include/scsi/fc.h             |  233 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 290 insertions(+), 248 deletions(-)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/include/scsi/fc.h	2008-06-12 14:34:03.000000000 +0200
@@ -0,0 +1,233 @@
+/*
+ * Fibre Channel protocol definitions.
+ */
+
+#ifndef _SCSI_FC_H
+#define _SCSI_FC_H
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+/*
+ * FC-GS - Fibre Channel Generic Services
+ */
+
+/* well-known address identifiers for generic services */
+#define FC_WKA_KEY_DIST_SERVICE		0xFFFFF7
+#define FC_WKA_ALIAS_SERVICE		0xFFFFF8
+#define FC_WKA_MANAGEMENT_SERVICE	0xFFFFFA
+#define FC_WKA_TIME_SERVICE		0xFFFFFB
+#define FC_WKA_DIRECTORY_SERVICE	0xFFFFFC
+#define FC_WKA_LINK_SERVICE		0xFFFFFE
+
+#define FC_DID_MASK			0xFFFFFF
+
+/* Common Transport for Generic Services (CT) */
+#define FC_CT_SYNCHRONOUS		0x00
+#define FC_CT_REVISION			0x01
+#define FC_CT_NAME_SERVER		0x02
+#define FC_CT_SCSI_FCP			0x08
+#define FC_CT_UNABLE_TO_PERFORM_CMD	0x09
+#define FC_CT_DIRECTORY_SERVICE		0xFC
+
+#define FC_CT_GID_PN			0x0121
+#define FC_CT_GPN_FT			0x0172
+#define FC_CT_MAX_SIZE			0x1020
+#define FC_CT_REJECT			0x8001
+#define FC_CT_ACCEPT			0x8002
+
+struct ct_hdr {
+	u8 revision;
+	u8 in_id[3];
+	u8 gs_type;
+	u8 gs_subtype;
+	u8 options;
+	u8 reserved0;
+	u16 cmd_rsp_code;
+	u16 max_res_size;
+	u8 reserved1;
+	u8 reason_code;
+	u8 reason_code_expl;
+	u8 vendor_unique;
+} __attribute__ ((packed));
+
+struct ct_iu_gid_pn_req {
+	struct ct_hdr header;
+	u64 wwpn;
+} __attribute__ ((packed));
+
+struct ct_iu_gid_pn_resp {
+	struct ct_hdr header;
+	u32 d_id;
+} __attribute__ ((packed));
+
+/*
+ * FCP - Fibre Channel Protocol for SCSI
+ */
+
+/* task attribute values in FCP-2 FCP_CMND IU */
+#define FCP_SIMPLE_Q	0x0
+#define FCP_HEAD_OF_Q	0x1
+#define FCP_ORDERED_Q	0x2
+/* reserved		0x3 */
+#define FCP_ACA_Q	0x4
+#define FCP_UNTAGGED	0x5
+
+/* task management flags in FCP-2 FCP_CMND IU */
+/* reserved			0x01 */
+#define FCP_ABORT_TASK_SET	0x02
+#define FCP_CLEAR_TASK_SET	0x04
+/* reserved			0x08 */
+#define FCP_LOGICAL_UNIT_RESET	0x10
+#define FCP_TARGET_RESET	0x20
+#define FCP_CLEAR_ACA		0x40
+/* obsolete			0x80 */
+
+/* FCP(-2) FCP_RSP IU */
+#define FC_RSP_CODE_GOOD		0x00
+#define FC_RSP_CODE_LENGTH_MISMATCH	0x01
+#define FC_RSP_CODE_FIELD_INVALID	0x02
+#define FC_RSP_CODE_RO_MISMATCH		0x03
+#define FC_RSP_CODE_TASKMAN_UNSUPP	0x04
+#define FC_RSP_CODE_FAILED		0x05
+/* reserved				0x06 -- 0xff */
+
+#define FCP_CDB_LENGTH          16
+
+/* FCP(-2) FCP_CMND IU */
+struct fcp_cmnd_iu {
+	u64 fcp_lun;
+	u8  crn;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8  reserved0:5;
+	u8  task_attribute:3;
+	u8  task_management_flags;
+	u8  add_fcp_cdb_length:6;
+	u8  rddata:1;
+	u8  wddata:1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8  wddata:1;
+	u8  rddata:1;
+	u8  add_fcp_cdb_length:6;
+	u8  task_management_flags;
+	u8  task_attribute:3;
+	u8  reserved0:5;
+#endif
+	u8  fcp_cdb[FCP_CDB_LENGTH];
+} __attribute__((packed));
+
+/* FCP(-2) FCP_RSP IU */
+struct fcp_rsp_iu {
+	u8  reserved0[10];
+	union {
+		struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+			u8 reserved1:3;
+			u8 fcp_conf_req:1;
+			u8 fcp_resid_under:1;
+			u8 fcp_resid_over:1;
+			u8 fcp_sns_len_valid:1;
+			u8 fcp_rsp_len_valid:1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+			u8 fcp_rsp_len_valid:1;
+			u8 fcp_sns_len_valid:1;
+			u8 fcp_resid_over:1;
+			u8 fcp_resid_under:1;
+			u8 fcp_conf_req:1;
+			u8 reserved1:3;
+#endif
+		} bits;
+		u8 value;
+	} validity;
+	u8  scsi_status;
+	u32 fcp_resid;
+	u32 fcp_sns_len;
+	u32 fcp_rsp_len;
+} __attribute__((packed));
+
+/*
+ * FC-LS - Fibre Channel Link Services
+ */
+
+#define FC_LS_PLOGI		0x03
+#define FC_LS_LOGO		0x05
+#define FC_LS_RLS		0x0f
+#define FC_LS_ADISC		0x52
+#define FC_LS_RPS		0x56
+#define FC_LS_RSCN		0x61
+#define FC_LS_RNID		0x78
+
+/* RSCN element address format */
+#define FC_RSCN_ADDR_PORT		0x0
+#define FC_RSCN_ADDR_AREA		0x1
+#define FC_RSCN_ADDR_DOMAIN		0x2
+#define FC_RSCN_ADDR_FABRIC		0x3
+
+#define FC_DID_MASK_PORT		0xffffff
+#define FC_DID_MASK_AREA		0xffff00
+#define FC_DID_MASK_DOMAIN		0xff0000
+#define FC_DID_MASK_FABRIC		0x000000
+
+struct fcp_rscn_head {
+	u8  command;
+	u8  page_length;
+	u16 payload_len;
+} __attribute__((packed));
+
+struct fcp_rscn_element {
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8  reserved:2;
+	u8  event_qual:4;
+	u8  addr_format:2;
+	u32 nport_did:24;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u32 nport_did:24;
+	u8  addr_format:2;
+	u8  event_qual:4;
+	u8  reserved:2;
+#endif
+} __attribute__((packed));
+
+/*
+ * FC-FS - Framing and Signaling
+ */
+
+/* Resource allocation timeout default */
+#define FC_R_A_TOV			10 /* seconds */
+
+struct zfcp_ls_rjt_par {
+	u8 action;
+	u8 reason_code;
+	u8 reason_expl;
+	u8 vendor_unique;
+} __attribute__ ((packed));
+
+struct zfcp_ls_adisc {
+	u8		code;
+	u8		field[3];
+	u32		hard_nport_id;
+	u64		wwpn;
+	u64		wwnn;
+	u32		nport_id;
+} __attribute__ ((packed));
+
+struct zfcp_ls_adisc_acc {
+	u8		code;
+	u8		field[3];
+	u32		hard_nport_id;
+	u64		wwpn;
+	u64		wwnn;
+	u32		nport_id;
+} __attribute__ ((packed));
+
+/*
+ * FC-PH - Fibre Channel Physical Interface
+ */
+
+struct fcp_logo {
+	u32 command;
+	u32 nport_did;
+	u64 nport_wwpn;
+} __attribute__((packed));
+
+#endif /* _SCSI_FC_H */
--- a/drivers/s390/scsi/zfcp_aux.c	2008-06-12 14:31:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-06-12 14:31:48.000000000 +0200
@@ -27,6 +27,7 @@
 
 #include <linux/miscdevice.h>
 #include "zfcp_ext.h"
+#include <scsi/fc.h>
 
 static char *device;
 /*********************** FUNCTION PROTOTYPES *********************************/
@@ -573,7 +574,7 @@ static int zfcp_nameserver_enqueue(struc
 	struct zfcp_port *port;
 
 	port = zfcp_port_enqueue(adapter, 0, ZFCP_STATUS_PORT_WKA,
-				 ZFCP_DID_DIRECTORY_SERVICE);
+				 FC_WKA_DIRECTORY_SERVICE);
 	if (!port)
 		return -ENXIO;
 	zfcp_port_put(port);
@@ -809,23 +810,23 @@ zfcp_port_enqueue(struct zfcp_adapter *a
 	/* setup for sysfs registration */
 	if (status & ZFCP_STATUS_PORT_WKA) {
 		switch (d_id) {
-		case ZFCP_DID_DIRECTORY_SERVICE:
+		case FC_WKA_DIRECTORY_SERVICE:
 			snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE,
 				 "directory");
 			break;
-		case ZFCP_DID_MANAGEMENT_SERVICE:
+		case FC_WKA_MANAGEMENT_SERVICE:
 			snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE,
 				 "management");
 			break;
-		case ZFCP_DID_KEY_DISTRIBUTION_SERVICE:
+		case FC_WKA_KEY_DIST_SERVICE:
 			snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE,
 				 "key_distribution");
 			break;
-		case ZFCP_DID_ALIAS_SERVICE:
+		case FC_WKA_ALIAS_SERVICE:
 			snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE,
 				 "alias");
 			break;
-		case ZFCP_DID_TIME_SERVICE:
+		case FC_WKA_TIME_SERVICE:
 			snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE,
 				 "time");
 			break;
@@ -864,7 +865,7 @@ zfcp_port_enqueue(struct zfcp_adapter *a
 	list_add_tail(&port->list, &adapter->port_list_head);
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &port->status);
-	if (d_id == ZFCP_DID_DIRECTORY_SERVICE)
+	if (d_id == FC_WKA_DIRECTORY_SERVICE)
 		if (!adapter->nameserver_port)
 			adapter->nameserver_port = port;
 	adapter->ports++;
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-06-12 14:31:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-06-12 14:31:48.000000000 +0200
@@ -8,6 +8,7 @@
 
 #include <linux/ctype.h>
 #include <asm/debug.h>
+#include <scsi/fc.h>
 #include "zfcp_ext.h"
 
 static u32 dbfsize = 4;
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-12 14:31:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-12 14:31:48.000000000 +0200
@@ -22,6 +22,7 @@
 #include <linux/syscalls.h>
 #include <linux/scatterlist.h>
 #include <linux/ioctl.h>
+#include <scsi/fc.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_cmnd.h>
@@ -135,166 +136,6 @@ typedef unsigned int       fcp_dl_t;
 /* maximum number of commands in LUN queue (tagged queueing) */
 #define ZFCP_CMND_PER_LUN               32
 
-/* task attribute values in FCP-2 FCP_CMND IU */
-#define SIMPLE_Q	0
-#define HEAD_OF_Q	1
-#define ORDERED_Q	2
-#define ACA_Q		4
-#define UNTAGGED	5
-
-/* task management flags in FCP-2 FCP_CMND IU */
-#define FCP_CLEAR_ACA		0x40
-#define FCP_TARGET_RESET	0x20
-#define FCP_LOGICAL_UNIT_RESET	0x10
-#define FCP_CLEAR_TASK_SET	0x04
-#define FCP_ABORT_TASK_SET	0x02
-
-#define FCP_CDB_LENGTH		16
-
-#define ZFCP_DID_MASK           0x00FFFFFF
-
-/* FCP(-2) FCP_CMND IU */
-struct fcp_cmnd_iu {
-	fcp_lun_t fcp_lun;	   /* FCP logical unit number */
-	u8  crn;	           /* command reference number */
-	u8  reserved0:5;	   /* reserved */
-	u8  task_attribute:3;	   /* task attribute */
-	u8  task_management_flags; /* task management flags */
-	u8  add_fcp_cdb_length:6;  /* additional FCP_CDB length */
-	u8  rddata:1;              /* read data */
-	u8  wddata:1;              /* write data */
-	u8  fcp_cdb[FCP_CDB_LENGTH];
-} __attribute__((packed));
-
-/* FCP(-2) FCP_RSP IU */
-struct fcp_rsp_iu {
-	u8  reserved0[10];
-	union {
-		struct {
-			u8 reserved1:3;
-			u8 fcp_conf_req:1;
-			u8 fcp_resid_under:1;
-			u8 fcp_resid_over:1;
-			u8 fcp_sns_len_valid:1;
-			u8 fcp_rsp_len_valid:1;
-		} bits;
-		u8 value;
-	} validity;
-	u8  scsi_status;
-	u32 fcp_resid;
-	u32 fcp_sns_len;
-	u32 fcp_rsp_len;
-} __attribute__((packed));
-
-
-#define RSP_CODE_GOOD		 0
-#define RSP_CODE_LENGTH_MISMATCH 1
-#define RSP_CODE_FIELD_INVALID	 2
-#define RSP_CODE_RO_MISMATCH	 3
-#define RSP_CODE_TASKMAN_UNSUPP	 4
-#define RSP_CODE_TASKMAN_FAILED	 5
-
-/* see fc-fs */
-#define LS_RSCN  0x61
-#define LS_LOGO  0x05
-#define LS_PLOGI 0x03
-
-struct fcp_rscn_head {
-        u8  command;
-        u8  page_length; /* always 0x04 */
-        u16 payload_len;
-} __attribute__((packed));
-
-struct fcp_rscn_element {
-        u8  reserved:2;
-        u8  event_qual:4;
-        u8  addr_format:2;
-        u32 nport_did:24;
-} __attribute__((packed));
-
-#define ZFCP_PORT_ADDRESS   0x0
-#define ZFCP_AREA_ADDRESS   0x1
-#define ZFCP_DOMAIN_ADDRESS 0x2
-#define ZFCP_FABRIC_ADDRESS 0x3
-
-#define ZFCP_PORTS_RANGE_PORT   0xFFFFFF
-#define ZFCP_PORTS_RANGE_AREA   0xFFFF00
-#define ZFCP_PORTS_RANGE_DOMAIN 0xFF0000
-#define ZFCP_PORTS_RANGE_FABRIC 0x000000
-
-#define ZFCP_NO_PORTS_PER_AREA    0x100
-#define ZFCP_NO_PORTS_PER_DOMAIN  0x10000
-#define ZFCP_NO_PORTS_PER_FABRIC  0x1000000
-
-/* see fc-ph */
-struct fcp_logo {
-        u32 command;
-        u32 nport_did;
-        wwn_t nport_wwpn;
-} __attribute__((packed));
-
-/*
- * FC-FS stuff
- */
-#define R_A_TOV				10 /* seconds */
-#define ZFCP_ELS_TIMEOUT		(2 * R_A_TOV)
-
-#define ZFCP_LS_RLS			0x0f
-#define ZFCP_LS_ADISC			0x52
-#define ZFCP_LS_RPS			0x56
-#define ZFCP_LS_RSCN			0x61
-#define ZFCP_LS_RNID			0x78
-
-struct zfcp_ls_rjt_par {
-	u8 action;
- 	u8 reason_code;
- 	u8 reason_expl;
- 	u8 vendor_unique;
-} __attribute__ ((packed));
-
-struct zfcp_ls_adisc {
-	u8		code;
-	u8		field[3];
-	u32		hard_nport_id;
-	u64		wwpn;
-	u64		wwnn;
-	u32		nport_id;
-} __attribute__ ((packed));
-
-struct zfcp_ls_adisc_acc {
-	u8		code;
-	u8		field[3];
-	u32		hard_nport_id;
-	u64		wwpn;
-	u64		wwnn;
-	u32		nport_id;
-} __attribute__ ((packed));
-
-struct zfcp_rc_entry {
-	u8 code;
-	const char *description;
-};
-
-/*
- * FC-GS-2 stuff
- */
-#define ZFCP_CT_REVISION		0x01
-#define ZFCP_CT_DIRECTORY_SERVICE	0xFC
-#define ZFCP_CT_NAME_SERVER		0x02
-#define ZFCP_CT_SYNCHRONOUS		0x00
-#define ZFCP_CT_SCSI_FCP		0x08
-#define ZFCP_CT_UNABLE_TO_PERFORM_CMD	0x09
-#define ZFCP_CT_GID_PN			0x0121
-#define ZFCP_CT_GPN_FT			0x0172
-#define ZFCP_CT_MAX_SIZE		0x1020
-#define ZFCP_CT_ACCEPT			0x8002
-#define ZFCP_CT_REJECT			0x8001
-
-/*
- * FC-GS-4 stuff
- */
-#define ZFCP_CT_TIMEOUT			(3 * R_A_TOV)
-
 /*************** ADAPTER/PORT/UNIT AND FSF_REQ STATUS FLAGS ******************/
 
 /*
@@ -327,13 +168,6 @@ struct zfcp_rc_entry {
 #define ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED	0x00000200
 #define ZFCP_STATUS_ADAPTER_XPORT_OK		0x00000800
 
-/* FC-PH/FC-GS well-known address identifiers for generic services */
-#define ZFCP_DID_MANAGEMENT_SERVICE		0xFFFFFA
-#define ZFCP_DID_TIME_SERVICE			0xFFFFFB
-#define ZFCP_DID_DIRECTORY_SERVICE		0xFFFFFC
-#define ZFCP_DID_ALIAS_SERVICE			0xFFFFF8
-#define ZFCP_DID_KEY_DISTRIBUTION_SERVICE	0xFFFFF7
-
 /* remote port status */
 #define ZFCP_STATUS_PORT_PHYS_OPEN		0x00000001
 #define ZFCP_STATUS_PORT_DID_DID		0x00000002
@@ -423,37 +257,6 @@ struct zfcp_adapter_mempool {
 	mempool_t *data_gid_pn;
 };
 
-/*
- * header for CT_IU
- */
-struct ct_hdr {
-	u8 revision;		// 0x01
-	u8 in_id[3];		// 0x00
-	u8 gs_type;		// 0xFC	Directory Service
-	u8 gs_subtype;		// 0x02	Name Server
-	u8 options;		// 0x00 single bidirectional exchange
-	u8 reserved0;
-	u16 cmd_rsp_code;	// 0x0121 GID_PN, or 0x0100 GA_NXT
-	u16 max_res_size;	// <= (4096 - 16) / 4
-	u8 reserved1;
-	u8 reason_code;
-	u8 reason_code_expl;
-	u8 vendor_unique;
-} __attribute__ ((packed));
-
-/* nameserver request CT_IU -- for requests where
- * a port name is required */
-struct ct_iu_gid_pn_req {
-	struct ct_hdr header;
-	wwn_t wwpn;
-} __attribute__ ((packed));
-
-/* FS_ACC IU and data unit for GID_PN nameserver request */
-struct ct_iu_gid_pn_resp {
-	struct ct_hdr header;
-	u32 d_id;
-} __attribute__ ((packed));
-
 typedef void (*zfcp_send_ct_handler_t)(unsigned long);
 
 /**
--- a/drivers/s390/scsi/zfcp_fc.c	2008-06-12 14:31:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-06-12 14:31:48.000000000 +0200
@@ -7,6 +7,7 @@
  */
 
 #include "zfcp_ext.h"
+#include <scsi/fc.h>
 
 struct ct_iu_gpn_ft_req {
 	struct ct_hdr header;
@@ -82,17 +83,17 @@ static void zfcp_fc_incoming_rscn(struct
 		/* skip head and start with 1st element */
 		fcp_rscn_element++;
 		switch (fcp_rscn_element->addr_format) {
-		case ZFCP_PORT_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_PORT;
+		case FC_RSCN_ADDR_PORT:
+			range_mask = FC_DID_MASK_PORT;
 			break;
-		case ZFCP_AREA_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_AREA;
+		case FC_RSCN_ADDR_AREA:
+			range_mask = FC_DID_MASK_AREA;
 			break;
-		case ZFCP_DOMAIN_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_DOMAIN;
+		case FC_RSCN_ADDR_DOMAIN:
+			range_mask = FC_DID_MASK_DOMAIN;
 			break;
-		case ZFCP_FABRIC_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_FABRIC;
+		case FC_RSCN_ADDR_FABRIC:
+			range_mask = FC_DID_MASK_FABRIC;
 			break;
 		default:
 			continue;
@@ -148,11 +149,11 @@ void zfcp_fc_incoming_els(struct zfcp_fs
 	unsigned int els_type = status_buffer->payload[0];
 
 	zfcp_san_dbf_event_incoming_els(fsf_req);
-	if (els_type == LS_PLOGI)
+	if (els_type == FC_LS_PLOGI)
 		zfcp_fc_incoming_plogi(fsf_req);
-	else if (els_type == LS_LOGO)
+	else if (els_type == FC_LS_LOGO)
 		zfcp_fc_incoming_logo(fsf_req);
-	else if (els_type == LS_RSCN)
+	else if (els_type == FC_LS_RSCN)
 		zfcp_fc_incoming_rscn(fsf_req);
 }
 
@@ -166,7 +167,7 @@ static void zfcp_ns_gid_pn_handler(unsig
 
 	if (ct->status)
 		goto out;
-	if (ct_iu_resp->header.cmd_rsp_code != ZFCP_CT_ACCEPT) {
+	if (ct_iu_resp->header.cmd_rsp_code != FC_CT_ACCEPT) {
 		atomic_set_mask(ZFCP_STATUS_PORT_INVALID_WWPN, &port->status);
 		goto out;
 	}
@@ -174,7 +175,7 @@ static void zfcp_ns_gid_pn_handler(unsig
 	if (ct_iu_req->wwpn != port->wwpn)
 		goto out;
 	/* looks like a valid d_id */
-	port->d_id = ct_iu_resp->d_id & ZFCP_DID_MASK;
+	port->d_id = ct_iu_resp->d_id & FC_DID_MASK;
 	atomic_set_mask(ZFCP_STATUS_PORT_DID_DID, &port->status);
 out:
 	mempool_free(gid_pn, port->adapter->pool.data_gid_pn);
@@ -213,12 +214,12 @@ int zfcp_fc_ns_gid_pn_request(struct zfc
 		    sizeof(struct ct_iu_gid_pn_resp));
 
 	/* setup nameserver request */
-	gid_pn->ct_iu_req.header.revision = ZFCP_CT_REVISION;
-	gid_pn->ct_iu_req.header.gs_type = ZFCP_CT_DIRECTORY_SERVICE;
-	gid_pn->ct_iu_req.header.gs_subtype = ZFCP_CT_NAME_SERVER;
-	gid_pn->ct_iu_req.header.options = ZFCP_CT_SYNCHRONOUS;
-	gid_pn->ct_iu_req.header.cmd_rsp_code = ZFCP_CT_GID_PN;
-	gid_pn->ct_iu_req.header.max_res_size = ZFCP_CT_MAX_SIZE;
+	gid_pn->ct_iu_req.header.revision = FC_CT_REVISION;
+	gid_pn->ct_iu_req.header.gs_type = FC_CT_DIRECTORY_SERVICE;
+	gid_pn->ct_iu_req.header.gs_subtype = FC_CT_NAME_SERVER;
+	gid_pn->ct_iu_req.header.options = FC_CT_SYNCHRONOUS;
+	gid_pn->ct_iu_req.header.cmd_rsp_code = FC_CT_GID_PN;
+	gid_pn->ct_iu_req.header.max_res_size = FC_CT_MAX_SIZE;
 	gid_pn->ct_iu_req.wwpn = erp_action->port->wwpn;
 
 	ret = zfcp_fsf_send_ct(&gid_pn->ct, adapter->pool.fsf_req_erp,
@@ -303,7 +304,7 @@ static int zfcp_fc_adisc(struct zfcp_por
 	adisc->els.d_id = port->d_id;
 	adisc->els.handler = zfcp_fc_adisc_handler;
 	adisc->els.handler_data = (unsigned long) adisc;
-	adisc->els.ls_code = adisc->ls_adisc.code = ZFCP_LS_ADISC;
+	adisc->els.ls_code = adisc->ls_adisc.code = FC_LS_ADISC;
 
 	/* acc. to FC-FS, hard_nport_id in ADISC should not be set for ports
 	   without FC-AL-2 capability, so we don't set it */
@@ -406,17 +407,17 @@ static int zfcp_scan_issue_gpn_ft(struct
 	int ret;
 
 	/* prepare CT IU for GPN_FT */
-	req->header.revision = ZFCP_CT_REVISION;
-	req->header.gs_type = ZFCP_CT_DIRECTORY_SERVICE;
-	req->header.gs_subtype = ZFCP_CT_NAME_SERVER;
-	req->header.options = ZFCP_CT_SYNCHRONOUS;
-	req->header.cmd_rsp_code = ZFCP_CT_GPN_FT;
+	req->header.revision = FC_CT_REVISION;
+	req->header.gs_type = FC_CT_DIRECTORY_SERVICE;
+	req->header.gs_subtype = FC_CT_NAME_SERVER;
+	req->header.options = FC_CT_SYNCHRONOUS;
+	req->header.cmd_rsp_code = FC_CT_GPN_FT;
 	req->header.max_res_size = (sizeof(struct gpn_ft_resp_acc) *
 					(ZFCP_GPN_FT_MAX_ENTRIES - 1)) >> 2;
 	req->flags = 0;
 	req->domain_id_scope = 0;
 	req->area_id_scope = 0;
-	req->fc4_type = ZFCP_CT_SCSI_FCP;
+	req->fc4_type = FC_CT_SCSI_FCP;
 
 	/* prepare zfcp_send_ct */
 	ct->port = adapter->nameserver_port;
@@ -467,8 +468,8 @@ static int zfcp_scan_eval_gpn_ft(struct 
 	if (ct->status)
 		return -EIO;
 
-	if (hdr->cmd_rsp_code != ZFCP_CT_ACCEPT) {
-		if (hdr->reason_code == ZFCP_CT_UNABLE_TO_PERFORM_CMD)
+	if (hdr->cmd_rsp_code != FC_CT_ACCEPT) {
+		if (hdr->reason_code == FC_CT_UNABLE_TO_PERFORM_CMD)
 			return -EAGAIN; /* might be a temporary condition */
 		return -EIO;
 	}
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-06-12 14:31:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-06-12 14:31:48.000000000 +0200
@@ -7,6 +7,7 @@
  */
 
 #include "zfcp_ext.h"
+#include <scsi/fc.h>
 
 static int zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *);
 static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *);
@@ -728,11 +729,11 @@ zfcp_fsf_status_read_port_closed(struct 
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	list_for_each_entry(port, &adapter->port_list_head, list)
-	    if (port->d_id == (status_buffer->d_id & ZFCP_DID_MASK))
+	    if (port->d_id == (status_buffer->d_id & FC_DID_MASK))
 		break;
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
-	if (!port || (port->d_id != (status_buffer->d_id & ZFCP_DID_MASK)))
+	if (!port || (port->d_id != (status_buffer->d_id & FC_DID_MASK)))
 		goto out;
 
 	switch (status_buffer->status_subtype) {
@@ -1372,7 +1373,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 	fsf_req->qtcb->bottom.support.d_id = d_id;
 	fsf_req->qtcb->bottom.support.service_class =
 		ZFCP_FC_SERVICE_CLASS_DEFAULT;
-	fsf_req->qtcb->bottom.support.timeout = ZFCP_ELS_TIMEOUT;
+	fsf_req->qtcb->bottom.support.timeout = 2 * FC_R_A_TOV;
 	fsf_req->data = (unsigned long) els;
 
 	sbale = zfcp_qdio_sbale_req(fsf_req);
@@ -1440,7 +1441,7 @@ static int zfcp_fsf_send_els_handler(str
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]){
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			if (port && (send_els->ls_code != ZFCP_LS_ADISC))
+			if (port && (send_els->ls_code != FC_LS_ADISC))
 				zfcp_test_link(port);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
@@ -1598,7 +1599,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 
 		fc_host_node_name(shost) = bottom->nport_serv_param.wwnn;
 		fc_host_port_name(shost) = bottom->nport_serv_param.wwpn;
-		fc_host_port_id(shost) = bottom->s_id & ZFCP_DID_MASK;
+		fc_host_port_id(shost) = bottom->s_id & FC_DID_MASK;
 		fc_host_speed(shost) = bottom->fc_link_speed;
 		fc_host_supported_classes(shost) =
 				FC_COS_CLASS2 | FC_COS_CLASS3;
@@ -1608,7 +1609,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 			fc_host_permanent_port_name(shost) =
 				fc_host_port_name(shost);
 		if (bottom->fc_topology == FSF_TOPO_P2P) {
-			adapter->peer_d_id = bottom->peer_d_id & ZFCP_DID_MASK;
+			adapter->peer_d_id = bottom->peer_d_id & FC_DID_MASK;
 			adapter->peer_wwpn = bottom->plogi_payload.wwpn;
 			adapter->peer_wwnn = bottom->plogi_payload.wwnn;
 			fc_host_port_type(shost) = FC_PORTTYPE_PTP;
@@ -2718,9 +2719,9 @@ zfcp_fsf_send_fcp_command_task(struct zf
 	/* set task attributes in FCP_CMND IU in QTCB */
 	if (likely((scsi_cmnd->device->simple_tags) ||
 		   (atomic_test_mask(mask, &unit->status))))
-		fcp_cmnd_iu->task_attribute = SIMPLE_Q;
+		fcp_cmnd_iu->task_attribute = FCP_SIMPLE_Q;
 	else
-		fcp_cmnd_iu->task_attribute = UNTAGGED;
+		fcp_cmnd_iu->task_attribute = FCP_UNTAGGED;
 
 	/* set additional length of FCP_CDB in FCP_CMND IU in QTCB, if needed */
 	if (unlikely(scsi_cmnd->cmd_len > FCP_CDB_LENGTH))
@@ -3065,19 +3066,19 @@ zfcp_fsf_send_fcp_command_task_handler(s
 	/* check FCP_RSP_INFO */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_rsp_len_valid)) {
 		switch (fcp_rsp_info[3]) {
-		case RSP_CODE_GOOD:
+		case FC_RSP_CODE_GOOD:
 			/* ok, continue */
 			set_host_byte(&scpnt->result, DID_OK);
 			break;
-		case RSP_CODE_LENGTH_MISMATCH:
+		case FC_RSP_CODE_LENGTH_MISMATCH:
 			/* hardware bug */
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
-		case RSP_CODE_FIELD_INVALID:
+		case FC_RSP_CODE_FIELD_INVALID:
 			/* driver or hardware bug */
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
-		case RSP_CODE_RO_MISMATCH:
+		case FC_RSP_CODE_RO_MISMATCH:
 			/* hardware bug */
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
@@ -3154,13 +3155,13 @@ zfcp_fsf_send_fcp_command_task_managemen
 
 	/* check FCP_RSP_INFO */
 	switch (fcp_rsp_info[3]) {
-	case RSP_CODE_GOOD:
+	case FC_RSP_CODE_GOOD:
 		/* ok, continue */
 		break;
-	case RSP_CODE_TASKMAN_UNSUPP:
+	case FC_RSP_CODE_TASKMAN_UNSUPP:
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP;
 		break;
-	case RSP_CODE_TASKMAN_FAILED:
+	case FC_RSP_CODE_FAILED:
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
 		break;
 	default:
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-06-12 14:31:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-06-12 14:31:48.000000000 +0200
@@ -8,6 +8,7 @@
 
 #include "zfcp_ext.h"
 #include <asm/atomic.h>
+#include <scsi/fc.h>
 
 static void zfcp_scsi_slave_destroy(struct scsi_device *sdp);
 static int zfcp_scsi_slave_alloc(struct scsi_device *sdp);
--- a/drivers/s390/scsi/zfcp_ext.h	2008-06-12 14:31:28.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-06-12 14:31:48.000000000 +0200
@@ -9,6 +9,7 @@
 #ifndef ZFCP_EXT_H
 #define ZFCP_EXT_H
 
+#include <scsi/fc.h>
 #include "zfcp_def.h"
 
 extern struct zfcp_data zfcp_data;
