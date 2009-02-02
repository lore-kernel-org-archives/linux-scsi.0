From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ALUA]: Add initial support for
	MAINTENANCE_IN+REPORT_TARGET_PORT_GROUP
Date: Mon, 02 Feb 2009 00:47:56 -0800
Message-ID: <1233564476.12375.69.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:43970 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751050AbZBBItF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2009 03:49:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Zhang <blackmagic02881@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Rafiu Fakunle <rafiu@openfiler.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Al Tobey <tobert@gmail.com>

Greetings all,

This patch adds initial support for Asymmetric Logical Unit Assignment (ALUA) in
Target_Core_Mod.  It adds some basic ALUA infrastructure and adds
se_cmd_t->transport_emulate_cdb usage in transport_generic_cmd_sequencer() for
MAINTENANCE_IN+REPORT_TARGET_PORT_GROUP emulation.

It also sets SCCS=1 + TPGS=1 bits in INQUIRY response data, as well
changing Target_Core_Mod/IBLOCK to return linux/include/scsi/scsi.h:SCSI_SPC_2
so that SPC-3 shows up in INQUIRY response data.

Here is what it looks like in action with sg3_utils for the updated
INQUIRY response information for a Target_Core_Mod/IBLOCK across a
LIO-Target v3.0 iSCSI Target Port:

initiator# sg_inq -v /dev/sdh
    inquiry cdb: 12 00 00 00 24 00
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=0
  SCCS=1  ACC=0  TPGS=1  3PC=0  Protect=0  BQue=0
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=1  Sync=1  Linked=0  [TranDis=0]  CmdQue=1
    length=36 (0x24)   Peripheral device type: disk
 Vendor identification: LIO-ORG
 Product identification: IBLOCK
 Product revision level: v3.0
    inquiry cdb: 12 01 00 00 fc 00
    inquiry cdb: 12 01 80 00 fc 00
 Unit serial number: eEaqKo-gYF8-vnDA-jJhf-Xqzy-pjGF-G6Y50v

And for MAINTENANCE_IN+REPORT_TARGET_PORT_GROUP

initiator# sg_rtpg -v /dev/sdh
    report target port groups cdb: a3 0a 00 00 00 00 00 00 04 00 00 00
Report list length = 16
Report target port groups:
  target port group id : 0x0 , Pref=0
    target port group asymmetric access state : 0x00
    T_SUP : 0, O_SUP : 0, U_SUP : 0, S_SUP : 0, AN_SUP : 0, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x01

This is the initial support for implict non-transitional aware ALUA.
Functionality for both explict and implict transitional ALUA will be
added in future patch series.  The latter will be able to be controlled
via Target_Core_Mod/ConfigFS and ConfigFS aware $FABRIC_MODs.

This patch is made against lio-core-2.6.git/master
and tested on v2.6.29-rc2 x86 32-bit HVM.  The lio-core-2.6.git tree can be
found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/Makefile                |    1 +
 drivers/lio-core/target_core_alua.c      |  157 ++++++++++++++++++++++++++++++
 drivers/lio-core/target_core_alua.h      |   38 +++++++
 drivers/lio-core/target_core_base.h      |   13 +++
 drivers/lio-core/target_core_device.c    |    1 +
 drivers/lio-core/target_core_iblock.c    |    2 +-
 drivers/lio-core/target_core_transport.c |   35 ++++++-
 drivers/lio-core/target_core_transport.h |    1 +
 8 files changed, 243 insertions(+), 5 deletions(-)
 create mode 100644 drivers/lio-core/target_core_alua.c
 create mode 100644 drivers/lio-core/target_core_alua.h

diff --git a/drivers/lio-core/Makefile b/drivers/lio-core/Makefile
index 98a5ef3..7691c32 100644
--- a/drivers/lio-core/Makefile
+++ b/drivers/lio-core/Makefile
@@ -34,6 +34,7 @@ target_core_mod-objs			:=	target_core_configfs.o \
 						target_core_hba.o \
 						target_core_plugin.o \
 						target_core_pr.o \
+						target_core_alua.o \
 						target_core_scdb.o \
 						target_core_seobj.o \
 						target_core_tpg.o \
diff --git a/drivers/lio-core/target_core_alua.c b/drivers/lio-core/target_core_alua.c
new file mode 100644
index 0000000..af94532
--- /dev/null
+++ b/drivers/lio-core/target_core_alua.c
@@ -0,0 +1,157 @@
+/*********************************************************************************
+ * Filename:  target_core_pr.c
+ *
+ * This file contains SPC-3 compliant asymmetric logical unit assigntment (ALUA)
+ *
+ * Copyright (c) 2009 Rising Tide, Inc.
+ * Copyright (c) 2009 Linux-iSCSI.org
+ *
+ * Nicholas A. Bellinger <nab@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ *********************************************************************************/
+
+#define TARGET_CORE_ALUA_C
+
+#include <linux/version.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+
+#include <target_core_base.h>
+#include <target_core_device.h>
+#include <target_core_hba.h>
+#include <target_core_transport.h>
+#include <target_core_alua.h>
+#include <target_core_transport_plugin.h>
+#include <target_core_fabric_ops.h>
+#include <target_core_configfs.h>
+
+#undef TARGET_CORE_ALUA_C
+
+extern int core_scsi3_emulate_report_target_port_groups (se_cmd_t *cmd)
+{
+	se_lun_t *lun = SE_LUN(cmd);
+	se_port_t *port;
+	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	u32 rd_len = 0, off = 4;
+	u16 tg_pg = 0;
+	u8 tg_pg_count = 1; // Assume 1 for now
+	
+	if (!(lun)) {
+		printk(KERN_ERR "SPC-3 ALUA se_lun_t is NULL!\n");
+		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+	}
+	if (!(port = lun->lun_sep)) {
+		printk(KERN_ERR "SPC-3 ALUA se_port_t is NULL\n");
+		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+	}
+	/*
+	 * PREF: Preferred target port bit
+	 */
+//	buf[off] = 0x80;
+	/*
+	 * Set the ASYMMETRIC ACCESS State
+	 */
+	buf[off++] |= ALUA_ACCESS_STATE_ACTIVE_OPTMIZED;
+	/*
+	 * Set supported ASYMMETRIC ACCESS State bits
+	 */
+//	buf[off] = 0x80; // T_SUP
+//	buf[off] |= 0x40; // O_SUP
+//	buf[off] |= 0x8; // U_SUP
+//	buf[off] |= 0x4; // S_SUP
+//	buf[off] |= 0x2; // AN_SUP
+	buf[off++] |= 0x1; // AO_SUP
+	/*
+	 * TARGET PORT GROUP
+	 */
+	buf[off++] = ((tg_pg >> 8) & 0xff);
+	buf[off++] = (tg_pg & 0xff);
+	
+	off++; // Skip over Reserved
+	/*
+	 * STATUS CODE
+	 */
+	buf[off++] = ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
+	/*
+	 * Vendor Specific field
+	 */
+	buf[off++] = 0x00;
+	/*
+	 * TARGET PORT COUNT
+	 */
+	buf[off++] = tg_pg_count;
+
+	rd_len += 8;
+	/*
+	 * Start Target Port descriptor format
+	 *
+	 * See spc4r17 section 6.2.7 Table 247
+	 */
+	off += 2; // Skip over Obsolete
+	/*
+	 * Set RELATIVE TARGET PORT IDENTIFIER
+	 */
+	buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
+	buf[off++] = (port->sep_rtpi & 0xff);
+
+	rd_len += 4;
+	/*
+	 * Set the RETURN DATA LENGTH set in the header of the DataIN Payload
+	 */
+	buf[0] = ((rd_len >> 24) & 0xff);
+	buf[1] = ((rd_len >> 16) & 0xff);
+	buf[2] = ((rd_len >> 8) & 0xff);
+	buf[3] = (rd_len & 0xff);
+
+	return(0);	
+}
+
+extern int core_setup_alua (se_device_t *dev)
+{
+	se_subsystem_dev_t *su_dev = dev->se_sub_dev;
+	t10_alua_t *alua = T10_ALUA(su_dev);
+	/*
+	 * If this device is from Target_Core_Mod/pSCSI, use the ALUA logic
+	 * of the Underlying SCSI hardware.  In Linux/SCSI terms, this can
+	 * cause a problem because libata and some SATA RAID HBAs appear
+	 * under Linux/SCSI, but emulate SCSI logic themselves.
+	 */ 
+	if ((TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) &&
+	    !(DEV_ATTRIB(dev)->emulate_alua)) {
+		alua->alua_type = SPC_ALUA_PASSTHROUGH;
+		printk("%s: Using SPC_ALUA_PASSTHROUGH, no ALUA emulation\n",
+				TRANSPORT(dev)->name);
+		return(0);
+	}
+	/*
+	 * If SPC-3 or above is reported by real or emulated se_device_t,
+	 * use emulated ALUA.
+	 */
+	if (TRANSPORT(dev)->get_device_rev(dev) >= SCSI_3) {
+		alua->alua_type = SPC3_ALUA_EMULATED;
+		printk("%s: Enabling ALUA Emulation for SPC-3 device\n",
+				TRANSPORT(dev)->name);
+	} else {
+		alua->alua_type = SPC2_ALUA_DISABLED;
+		printk("%s: Disabling ALUA for SPC-2 device\n",
+				TRANSPORT(dev)->name);
+	}
+
+	return(0);
+}
diff --git a/drivers/lio-core/target_core_alua.h b/drivers/lio-core/target_core_alua.h
new file mode 100644
index 0000000..e08cbf4
--- /dev/null
+++ b/drivers/lio-core/target_core_alua.h
@@ -0,0 +1,38 @@
+#ifndef TARGET_CORE_ALUA_H
+#define TARGET_CORE_ALUA_H
+
+/*
+ * INQUIRY response data, TPGS Field
+ *
+ * from spc4r17 section 6.4.2 Table 135
+ */
+#define TPGS_NO_ALUA				0x00
+#define TPGS_IMPLICT_ALUA			0x10
+#define TPGS_EXPLICT_ALUA			0x20
+#define TPGS_EXPLICT_AND_IMPLICT_ALUA		0x40
+ 
+/*
+ * ASYMMETRIC ACCESS STATE field
+ *
+ * from spc4r17 section 6.27 Table 245
+ */
+#define ALUA_ACCESS_STATE_ACTIVE_OPTMIZED	0x0
+#define ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED	0x1
+#define ALUA_ACCESS_STATE_STANDBY		0x2
+#define ALUA_ACCESS_STATE_UNAVAILABLE		0x3
+#define ALUA_ACCESS_STATE_OFFLINE		0xe
+#define ALUA_ACCESS_STATE_TRANSITION		0xf
+
+/*
+ * REPORT_TARGET_PORT_GROUP STATUS CODE
+ *
+ * from spc4r17 section 6.27 Table 246
+ */
+#define ALUA_STATUS_NONE				0x00
+#define ALUA_STATUS_ALTERED_BY_EXPLICT_STPG		0x01
+#define ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA		0x02
+
+extern int core_scsi3_emulate_report_target_port_groups (struct se_cmd_s *);
+extern int core_setup_alua (struct se_device_s *);
+
+#endif // TARGET_CORE_ALUA_H
diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 5e979ff..a5208e8 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -179,6 +179,16 @@ typedef struct se_obj_s {
 	atomic_t obj_access_count;
 } ____cacheline_aligned se_obj_t;
 
+typedef enum {
+	SPC_ALUA_PASSTHROUGH,
+	SPC2_ALUA_DISABLED,
+	SPC3_ALUA_EMULATED
+} t10_alua_index_t;
+
+typedef struct t10_alua_s {
+	t10_alua_index_t alua_type;	
+} ____cacheline_aligned t10_alua_t;
+
 typedef struct t10_evpd_s {
 	unsigned char device_identifier[INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN];
 	int protocol_identifier_set;
@@ -508,6 +518,7 @@ typedef struct se_dev_attrib_s {
         int             status_thread;
         int             status_thread_tur;
 	int		emulate_reservations;
+	int		emulate_alua;
 	u32		hw_max_sectors;
         u32             max_sectors;
 	u32		hw_queue_depth;
@@ -522,6 +533,7 @@ typedef struct se_subsystem_dev_s {
         struct se_hba_s *se_dev_hba;
         struct se_device_s *se_dev_ptr;
         se_dev_attrib_t se_dev_attrib;
+	t10_alua_t	t10_alua;	/* T10 Asymmetric Logical Unit Assignment Information */
 	t10_wwn_t	t10_wwn;	/* T10 Inquiry and EVPD WWN Information */
 	t10_reservation_template_t t10_reservation;	/* T10 SPC-2 + SPC-3 Reservations */
         spinlock_t      se_dev_lock;
@@ -530,6 +542,7 @@ typedef struct se_subsystem_dev_s {
 	struct config_group se_dev_pr_group;	/* For T10 Reservations */
 } ____cacheline_aligned se_subsystem_dev_t;
 
+#define T10_ALUA(su_dev)	(&(su_dev)->t10_alua)
 #define T10_RES(su_dev)		(&(su_dev)->t10_reservation)
 
 typedef struct se_device_s {
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 53741d8..ced583a 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -791,6 +791,7 @@ extern void se_dev_set_default_attribs (se_device_t *dev)
 	DEV_ATTRIB(dev)->status_thread = DA_STATUS_THREAD;
 	DEV_ATTRIB(dev)->status_thread_tur = DA_STATUS_THREAD_TUR;
 	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
+	DEV_ATTRIB(dev)->emulate_alua = DA_EMULATE_ALUA;
 	/*
 	 * max_sectors is based on subsystem plugin dependent requirements.
 	 */
diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index a94526c..d71d766 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -836,7 +836,7 @@ extern u32 iblock_get_blocksize (se_device_t *dev)
 
 extern u32 iblock_get_device_rev (se_device_t *dev)
 {
-	return(SCSI_3);
+	return(SCSI_SPC_2); // Returns SPC-3 in Initiator Data
 }
 
 extern u32 iblock_get_device_type (se_device_t *dev)
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 5bb13b2..7254f02 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -59,6 +59,7 @@
 #include <target_core_hba.h>
 #include <target_core_scdb.h>
 #include <target_core_pr.h>
+#include <target_core_alua.h>
 #include <target_core_transport.h>
 #include <target_core_plugin.h>
 #include <target_core_seobj.h>
@@ -2099,6 +2100,10 @@ extern se_device_t *transport_add_device_to_core_hba (
 	 */
 	core_setup_reservations(dev);
 	/*
+	 * Setup the Asymmetric Logical Unit Assignment for se_device_t
+	 */
+	core_setup_alua(dev);
+	/*
 	 * Startup the se_device_t processing thread
 	 */	
 	transport_generic_activate_device(dev);
@@ -4044,6 +4049,19 @@ extern int transport_generic_emulate_inquiry (
 			buf[1] = 0x80;
 		buf[2]          = TRANSPORT(dev)->get_device_rev(dev);
 		buf[4]          = 31;
+		/*
+		 * Enable SCCS and TPGS fields for Emulated ALUA
+		 */
+		if (T10_ALUA(dev->se_sub_dev)->alua_type == SPC3_ALUA_EMULATED) {
+			/*
+			 * Set SCCS for MAINTENANCE_IN + REPORT_TARGET_PORT_GROUPS
+			 */
+			buf[5]	= 0x80;
+			/*
+			 * Set TPGS field, see spc4r17 section 6.4.2 Table 135
+			 */	
+			buf[5] |= TPGS_IMPLICT_ALUA;
+		}
 		buf[7]		= 0x32; /* Sync=1 and CmdQue=1 */
 		
 		sprintf((unsigned char *)&buf[8], "LIO-ORG");
@@ -4612,16 +4630,25 @@ static int transport_generic_cmd_sequencer (
 		break;
 	case 0xa3:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
-		if (TRANSPORT(dev)->get_device_type(dev) == TYPE_RAID) {
+		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
 			// MAINTENANCE_IN from SCC-2
+			/*
+			 * Check for emulated MI_REPORT_TARGET_PGS.
+			 */
+			if (cdb[1] == MI_REPORT_TARGET_PGS) {
+				cmd->transport_emulate_cdb =
+					(T10_ALUA(su_dev)->alua_type == SPC3_ALUA_EMULATED) ?		
+					&core_scsi3_emulate_report_target_port_groups :
+					NULL;
+			}
 			size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
 		} else {
 			// GPCMD_SEND_KEY from multi media commands
 			size = (cdb[8] << 8) + cdb[9];
 		}
-		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
-		ret = 1;
+		ret = 2;
 		break;
 	case MODE_SELECT:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
@@ -4700,7 +4727,7 @@ static int transport_generic_cmd_sequencer (
 		break;
 	case 0xa4:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
-		if (TRANSPORT(dev)->get_device_type(dev) == TYPE_RAID) {
+		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
 			// MAINTENANCE_OUT from SCC-2
 			size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
 		} else  {
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 768b8c7..70131d1 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -99,6 +99,7 @@
 #define DA_STATUS_THREAD			0 /* Disabled by default */
 #define DA_STATUS_THREAD_TUR			0 /* Disabled by default */
 #define DA_EMULATE_RESERVATIONS			0 /* No Emulation for PSCSI by default */
+#define DA_EMULATE_ALUA				0 /* No Emulation for PSCSI by default */
 #define DA_STATUS_MAX_SECTORS_MIN		16
 #define DA_STATUS_MAX_SECTORS_MAX		8192
 
-- 
1.5.4.1



