From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: [PATCH 1/2] qla2xxx: add support for NPIV
Date: Thu, 5 Jul 2007 13:16:51 -0700
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32B01293110@AVEXCH2.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7BF41.885ADD64"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:8668 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbXGEUSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 16:18:25 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linux Driver <Linux-Driver@qlogic.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7BF41.885ADD64
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Following patch adds support for NPIV (N-Port ID Virtualization) to the
qla2xxx.

- supported within switched-fabric topologies only.
- supports up to 63 virtual ports on each physical port.

The patch has been inlined and attached in a plain text format as well
to provide alternative way for using it in the case where the inlined
not working.
Also, the same patch can be downloaded from following link,
ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.02.00-k1/0001-qla2xxx-
Add-support-for-NPIV-N-Port-ID-Virtualizat.patch


Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
 drivers/scsi/qla2xxx/Makefile   |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c |  164 +++++++++++++
 drivers/scsi/qla2xxx/qla_dbg.h  |   10 +-
 drivers/scsi/qla2xxx/qla_def.h  |   83 +++++++
 drivers/scsi/qla2xxx/qla_fw.h   |   91 ++++++-
 drivers/scsi/qla2xxx/qla_gbl.h  |   39 +++-
 drivers/scsi/qla2xxx/qla_gs.c   |    3 +
 drivers/scsi/qla2xxx/qla_init.c |  168 ++++++++++++--
 drivers/scsi/qla2xxx/qla_iocb.c |   28 ++-
 drivers/scsi/qla2xxx/qla_isr.c  |   39 +++-
 drivers/scsi/qla2xxx/qla_mbx.c  |  396 ++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_mid.c  |  497
+++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |  229 +++++++++++--------
 13 files changed, 1594 insertions(+), 155 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_mid.c

diff --git a/drivers/scsi/qla2xxx/Makefile
b/drivers/scsi/qla2xxx/Makefile
index 411663a..71ddb5d 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,4 +1,4 @@
 qla2xxx-y :=3D qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o
qla_gs.o \
-		qla_dbg.o qla_sup.o qla_attr.o
+		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o
=20
 obj-$(CONFIG_SCSI_QLA_FC) +=3D qla2xxx.o
diff --git a/drivers/scsi/qla2xxx/qla_attr.c
b/drivers/scsi/qla2xxx/qla_attr.c
index 8081b63..95bee23 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -6,8 +6,11 @@
  */
 #include "qla_def.h"
=20
+#include <linux/kthread.h>
 #include <linux/vmalloc.h>
=20
+int qla24xx_vport_disable(struct fc_vport *, bool);
+
 /* SYSFS attributes
--------------------------------------------------------- */
=20
 static ssize_t
@@ -959,6 +962,122 @@ qla2x00_get_host_port_state(struct Scsi_Host
*shost)
 		fc_host_port_state(shost) =3D FC_PORTSTATE_ONLINE;
 }
=20
+static int
+qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
+{
+	int	ret =3D 0;
+	scsi_qla_host_t *ha =3D (scsi_qla_host_t *)
fc_vport->shost->hostdata;
+	scsi_qla_host_t *vha;
+
+	ret =3D qla24xx_vport_create_req_sanity_check(fc_vport);
+	if (ret) {
+		DEBUG15(printk("qla24xx_vport_create_req_sanity_check
failed, "
+		    "status %x\n", ret));
+		return (ret);
+	}
+
+	vha =3D qla24xx_create_vhost(fc_vport);
+	if (vha =3D=3D NULL) {
+		DEBUG15(printk ("qla24xx_create_vhost failed, vha =3D
%p\n",
+		    vha));
+		return FC_VPORT_FAILED;
+	}
+	if (disable) {
+		atomic_set(&vha->vp_state, VP_OFFLINE);
+		fc_vport_set_state(fc_vport, FC_VPORT_DISABLED);
+	} else
+		atomic_set(&vha->vp_state, VP_FAILED);
+
+	/* ready to create vport */
+	qla_printk(KERN_INFO, vha, "VP entry id %d assigned.\n",
vha->vp_idx);
+
+	/* initialized vport states */
+	atomic_set(&vha->loop_state, LOOP_DOWN);
+	vha->vp_err_state=3D  VP_ERR_PORTDWN;
+	vha->vp_prev_err_state=3D  VP_ERR_UNKWN;
+	/* Check if physical ha port is Up */
+	if (atomic_read(&ha->loop_state) =3D=3D LOOP_DOWN ||
+	    atomic_read(&ha->loop_state) =3D=3D LOOP_DEAD) {
+		/* Don't retry or attempt login of this virtual port */
+		DEBUG15(printk ("scsi(%ld): pport loop_state is not
UP.\n",
+		    vha->host_no));
+		atomic_set(&vha->loop_state, LOOP_DEAD);
+		if (!disable)
+			fc_vport_set_state(fc_vport, FC_VPORT_LINKDOWN);
+	}
+
+	if (scsi_add_host(vha->host, &fc_vport->dev)) {
+		DEBUG15(printk("scsi(%ld): scsi_add_host failure for
VP[%d].\n",
+			vha->host_no, vha->vp_idx));
+		goto vport_create_failed_2;
+	}
+
+	/* initialize attributes */
+	fc_host_node_name(vha->host) =3D wwn_to_u64(vha->node_name);
+	fc_host_port_name(vha->host) =3D wwn_to_u64(vha->port_name);
+	fc_host_supported_classes(vha->host) =3D
+		fc_host_supported_classes(ha->host);
+	fc_host_supported_speeds(vha->host) =3D
+		fc_host_supported_speeds(ha->host);
+
+	qla24xx_vport_disable(fc_vport, disable);
+
+	return 0;
+vport_create_failed_2:
+	qla24xx_disable_vp(vha);
+	qla24xx_deallocate_vp_id(vha);
+	kfree(vha->port_name);
+	kfree(vha->node_name);
+	scsi_host_put(vha->host);
+    	return FC_VPORT_FAILED;
+}
+
+int
+qla24xx_vport_delete(struct fc_vport *fc_vport)
+{
+	scsi_qla_host_t *ha =3D (scsi_qla_host_t *)
fc_vport->shost->hostdata;
+	scsi_qla_host_t *vha =3D fc_vport->dd_data;
+
+	qla24xx_disable_vp(vha);
+	qla24xx_deallocate_vp_id(vha);
+
+	down(&ha->vport_sem);
+	ha->cur_vport_count--;
+	clear_bit(vha->vp_idx, (unsigned long *)ha->vp_idx_map);
+	up(&ha->vport_sem);
+
+	kfree(vha->node_name);
+	kfree(vha->port_name);
+
+	if (vha->timer_active) {
+		qla2x00_vp_stop_timer(vha);
+		DEBUG15(printk ("scsi(%ld): timer for the vport[%d] =3D %p
"
+		    "has stopped\n",
+		    vha->host_no, vha->vp_idx, vha));
+        }
+
+	fc_remove_host(vha->host);
+
+	scsi_remove_host(vha->host);
+
+	scsi_host_put(vha->host);
+
+	return 0;
+}
+
+int
+qla24xx_vport_disable(struct fc_vport *fc_vport, bool disable)
+{
+	scsi_qla_host_t *vha =3D fc_vport->dd_data;
+
+	if (disable)
+		qla24xx_disable_vp(vha);
+	else
+		qla24xx_enable_vp(vha);
+
+	return 0;
+}
+
 struct fc_function_template qla2xxx_transport_functions =3D {
=20
 	.show_host_node_name =3D 1,
@@ -996,6 +1115,49 @@ struct fc_function_template
qla2xxx_transport_functions =3D {
=20
 	.issue_fc_host_lip =3D qla2x00_issue_lip,
 	.get_fc_host_stats =3D qla2x00_get_fc_host_stats,
+
+	.vport_create =3D qla24xx_vport_create,
+	.vport_disable =3D qla24xx_vport_disable,
+	.vport_delete =3D qla24xx_vport_delete,
+};
+
+struct fc_function_template qla2xxx_transport_vport_functions =3D {
+
+	.show_host_node_name =3D 1,
+	.show_host_port_name =3D 1,
+	.show_host_supported_classes =3D 1,
+
+	.get_host_port_id =3D qla2x00_get_host_port_id,
+	.show_host_port_id =3D 1,
+	.get_host_speed =3D qla2x00_get_host_speed,
+	.show_host_speed =3D 1,
+	.get_host_port_type =3D qla2x00_get_host_port_type,
+	.show_host_port_type =3D 1,
+	.get_host_symbolic_name =3D qla2x00_get_host_symbolic_name,
+	.show_host_symbolic_name =3D 1,
+	.set_host_system_hostname =3D qla2x00_set_host_system_hostname,
+	.show_host_system_hostname =3D 1,
+	.get_host_fabric_name =3D qla2x00_get_host_fabric_name,
+	.show_host_fabric_name =3D 1,
+	.get_host_port_state =3D qla2x00_get_host_port_state,
+	.show_host_port_state =3D 1,
+
+	.dd_fcrport_size =3D sizeof(struct fc_port *),
+	.show_rport_supported_classes =3D 1,
+
+	.get_starget_node_name =3D qla2x00_get_starget_node_name,
+	.show_starget_node_name =3D 1,
+	.get_starget_port_name =3D qla2x00_get_starget_port_name,
+	.show_starget_port_name =3D 1,
+	.get_starget_port_id  =3D qla2x00_get_starget_port_id,
+	.show_starget_port_id =3D 1,
+
+	.get_rport_dev_loss_tmo =3D qla2x00_get_rport_loss_tmo,
+	.set_rport_dev_loss_tmo =3D qla2x00_set_rport_loss_tmo,
+	.show_rport_dev_loss_tmo =3D 1,
+
+	.issue_fc_host_lip =3D qla2x00_issue_lip,
+	.get_fc_host_stats =3D qla2x00_get_fc_host_stats,
 };
=20
 void
@@ -1004,4 +1166,6 @@ qla2x00_init_host_attr(scsi_qla_host_t *ha)
 	fc_host_node_name(ha->host) =3D wwn_to_u64(ha->node_name);
 	fc_host_port_name(ha->host) =3D wwn_to_u64(ha->port_name);
 	fc_host_supported_classes(ha->host) =3D FC_COS_CLASS3;
+	fc_host_max_npiv_vports(ha->host) =3D MAX_NUM_VPORT_FABRIC;
+	fc_host_npiv_vports_inuse(ha->host) =3D ha->cur_vport_count;
 }
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h
b/drivers/scsi/qla2xxx/qla_dbg.h
index 5b12278..49dffeb 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -21,6 +21,7 @@
 /* #define QL_DEBUG_LEVEL_12 */ /* Output IP trace msgs */
 /* #define QL_DEBUG_LEVEL_13 */ /* Output fdmi function trace msgs */
 /* #define QL_DEBUG_LEVEL_14 */ /* Output RSCN trace msgs */
+/* #define QL_DEBUG_LEVEL_15 */ /* Output NPIV trace msgs */
 /*
  *  Local Macro Definitions.
  */
@@ -30,7 +31,8 @@
     defined(QL_DEBUG_LEVEL_7)  || defined(QL_DEBUG_LEVEL_8) || \
     defined(QL_DEBUG_LEVEL_9)  || defined(QL_DEBUG_LEVEL_10) || \
     defined(QL_DEBUG_LEVEL_11) || defined(QL_DEBUG_LEVEL_12) || \
-    defined(QL_DEBUG_LEVEL_13) || defined(QL_DEBUG_LEVEL_14)
+    defined(QL_DEBUG_LEVEL_13) || defined(QL_DEBUG_LEVEL_14) || \
+    defined(QL_DEBUG_LEVEL_15)
     #define QL_DEBUG_ROUTINES
 #endif
=20
@@ -125,6 +127,12 @@
 #define DEBUG14(x)	do {} while (0)
 #endif
=20
+#if defined(QL_DEBUG_LEVEL_15)
+#define DEBUG15(x)      do {x;} while (0)
+#else
+#define DEBUG15(x)	do {} while (0)
+#endif
+
 /*
  * Firmware Dump structure definition
  */
diff --git a/drivers/scsi/qla2xxx/qla_def.h
b/drivers/scsi/qla2xxx/qla_def.h
index e8948b6..a1ca590 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1551,6 +1551,9 @@ typedef struct fc_port {
=20
 	unsigned long last_queue_full;
 	unsigned long last_ramp_up;
+
+	struct list_head vp_fcport;
+	uint16_t vp_idx;
 } fc_port_t;
=20
 /*
@@ -1999,6 +2002,36 @@ struct gid_list_info {
 };
 #define GID_LIST_SIZE (sizeof(struct gid_list_info) *
MAX_FIBRE_DEVICES)
=20
+/* NPIV */
+typedef struct vport_info {
+	uint8_t		port_name[WWN_SIZE];
+	uint8_t		node_name[WWN_SIZE];
+	int		vp_id;
+	uint16_t	loop_id;
+	unsigned long	host_no;
+	uint8_t		port_id[3];
+	int		loop_state;
+} vport_info_t;
+
+typedef struct vport_params {
+	uint8_t 	port_name[WWN_SIZE];
+	uint8_t 	node_name[WWN_SIZE];
+	uint32_t 	options;
+#define	VP_OPTS_RETRY_ENABLE	BIT_0
+#define	VP_OPTS_VP_DISABLE	BIT_1
+} vport_params_t;
+
+/* NPIV - return codes of VP create and modify */
+#define VP_RET_CODE_OK			0
+#define VP_RET_CODE_FATAL		1
+#define VP_RET_CODE_WRONG_ID		2
+#define VP_RET_CODE_WWPN		3
+#define VP_RET_CODE_RESOURCES		4
+#define VP_RET_CODE_NO_MEM		5
+#define VP_RET_CODE_NOT_FOUND		6
+
+#define to_qla_parent(x) (((x)->parent) ? (x)->parent : (x))
+
 /*
  * ISP operations
  */
@@ -2073,6 +2106,16 @@ struct qla_msix_entry {
 	uint16_t msix_entry;
 };
=20
+#define	WATCH_INTERVAL		1       /* number of seconds */
+
+/* NPIV */
+#define MAX_MULTI_ID_LOOP                     126
+#define MAX_MULTI_ID_FABRIC                    64
+#define MAX_NUM_VPORT_LOOP                      (MAX_MULTI_ID_LOOP - 1)
+#define MAX_NUM_VPORT_FABRIC                    (MAX_MULTI_ID_FABRIC -
1)
+#define MAX_NUM_VHBA_LOOP                       (MAX_MULTI_ID_LOOP - 1)
+#define MAX_NUM_VHBA_FABRIC                     (MAX_MULTI_ID_FABRIC -
1)
+
 /*
  * Linux Host Adapter structure
  */
@@ -2108,6 +2151,8 @@ typedef struct scsi_qla_host {
 		uint32_t	msix_enabled		:1;
 		uint32_t	disable_serdes		:1;
 		uint32_t	gpsc_supported		:1;
+		uint32_t        vsan_enabled            :1;
+		uint32_t	npiv_supported		:1;
 	} flags;
=20
 	atomic_t	loop_state;
@@ -2147,6 +2192,7 @@ typedef struct scsi_qla_host {
 #define BEACON_BLINK_NEEDED	25
 #define REGISTER_FDMI_NEEDED	26
 #define FCPORT_UPDATE_NEEDED	27
+#define VP_DPC_NEEDED		28	/* wake up for VP dpc handling
*/
=20
 	uint32_t	device_flags;
 #define DFLG_LOCAL_DEVICES		BIT_0
@@ -2237,6 +2283,11 @@ typedef struct scsi_qla_host {
=20
 	/* ISP configuration data. */
 	uint16_t	loop_id;		/* Host adapter loop id
*/
+	uint16_t	switch_cap;
+#define FLOGI_SEQ_DEL		BIT_8
+#define FLOGI_MID_SUPPORT	BIT_10
+#define FLOGI_VSAN_SUPPORT	BIT_12
+#define FLOGI_SP_SUPPORT	BIT_13
 	uint16_t	fb_rev;
=20
 	port_id_t	d_id;			/* Host adapter port id
*/
@@ -2344,6 +2395,7 @@ typedef struct scsi_qla_host {
 #define MBX_UPDATE_FLASH_ACTIVE	3
=20
 	struct semaphore mbx_cmd_sem;	/* Serialialize mbx access */
+	struct semaphore vport_sem;	/* Virtual port synchronization
*/
 	struct semaphore mbx_intr_sem;  /* Used for completion
notification */
=20
 	uint32_t	mbx_flags;
@@ -2428,6 +2480,37 @@ typedef struct scsi_qla_host {
 	struct fc_host_statistics fc_host_stat;
=20
 	struct qla_msix_entry msix_entries[QLA_MSIX_ENTRIES];
+
+	struct list_head	vp_list;	/* list of VP */
+	struct fc_vport	*fc_vport;	/* holds fc_vport * for each
vport */
+	uint8_t		vp_idx_map[16];
+	uint16_t        num_vhosts;	/* number of vports created */
+	uint16_t        num_vsans;	/* number of vsan created */
+	uint16_t        vp_idx;		/* vport ID */
+
+	struct scsi_qla_host	*parent;	/* holds pport */
+	unsigned long		vp_flags;
+	struct list_head	vp_fcports;	/* list of fcports */
+#define VP_IDX_ACQUIRED		0	/* bit no 0 */
+#define VP_CREATE_NEEDED	1
+#define VP_BIND_NEEDED		2
+#define VP_DELETE_NEEDED	3
+#define VP_SCR_NEEDED		4	/* State Change Request
registration */
+	atomic_t 		vp_state;
+#define VP_OFFLINE		0
+#define VP_ACTIVE		1
+#define VP_FAILED		2
+// #define VP_DISABLE		3
+	uint16_t 	vp_err_state;
+	uint16_t	vp_prev_err_state;
+#define VP_ERR_UNKWN		0
+#define VP_ERR_PORTDWN		1
+#define VP_ERR_FAB_UNSUPPORTED	2
+#define VP_ERR_FAB_NORESOURCES	3
+#define VP_ERR_FAB_LOGOUT	4
+#define VP_ERR_ADAP_NORESOURCES	5
+	int		max_npiv_vports;	/* 63 or 125 per
topoloty */
+	int		cur_vport_count;
 } scsi_qla_host_t;
=20
=20
diff --git a/drivers/scsi/qla2xxx/qla_fw.h
b/drivers/scsi/qla2xxx/qla_fw.h
index a0a722c..63a11fe 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -69,6 +69,16 @@ struct port_database_24xx {
 	uint8_t reserved_3[24];
 };
=20
+struct vp_database_24xx {
+	uint16_t vp_status;
+	uint8_t  options;
+	uint8_t  id;
+	uint8_t  port_name[WWN_SIZE];
+	uint8_t  node_name[WWN_SIZE];
+	uint16_t port_id_low;
+	uint16_t port_id_high;
+};
+
 struct nvram_24xx {
 	/* NVRAM header. */
 	uint8_t id[4];
@@ -962,6 +972,25 @@ struct mid_db_24xx {
 	struct mid_db_entry_24xx entries[MAX_MID_VPS];
 };
=20
+ /*
+ * Virtual Fabric ID type definition.
+ */
+typedef struct vf_id {
+        uint16_t id : 12;
+        uint16_t priority : 4;
+} vf_id_t;
+
+/*
+ * Virtual Fabric HopCt type definition.
+ */
+typedef struct vf_hopct {
+        uint16_t reserved : 8;
+        uint16_t hopct : 8;
+} vf_hopct_t;
+
+/*
+ * Virtual Port Control IOCB
+ */
 #define VP_CTRL_IOCB_TYPE	0x30	/* Vitual Port Control entry. */
 struct vp_ctrl_entry_24xx {
 	uint8_t entry_type;		/* Entry type. */
@@ -974,6 +1003,7 @@ struct vp_ctrl_entry_24xx {
 	uint16_t vp_idx_failed;
=20
 	uint16_t comp_status;		/* Completion status. */
+#define CS_VCE_IOCB_ERROR       0x01    /* Error processing IOCB */
 #define CS_VCE_ACQ_ID_ERROR	0x02	/* Error while acquireing ID. */
 #define CS_VCE_BUSY		0x05	/* Firmware not ready to accept
cmd. */
=20
@@ -982,24 +1012,34 @@ struct vp_ctrl_entry_24xx {
 #define VCE_COMMAND_DISABLE_VPS	0x08	/* Disable VPs. */
 #define VCE_COMMAND_DISABLE_VPS_REINIT	0x09 /* Disable VPs and reinit
link. */
 #define VCE_COMMAND_DISABLE_VPS_LOGO	0x0a /* Disable VPs and LOGO
ports. */
+#define VCE_COMMAND_DISABLE_VPS_LOGO_ALL        0x0b /* Disable VPs and
LOGO ports. */
=20
 	uint16_t vp_count;
=20
 	uint8_t vp_idx_map[16];
-
-	uint8_t reserved_4[32];
+	uint16_t flags;
+	struct vf_id    id;
+	uint16_t reserved_4;
+	struct vf_hopct  hopct;
+	uint8_t reserved_5[8];
 };
=20
+/*
+ * Modify Virtual Port Configuration IOCB
+ */
 #define VP_CONFIG_IOCB_TYPE	0x31	/* Vitual Port Config entry. */
 struct vp_config_entry_24xx {
 	uint8_t entry_type;		/* Entry type. */
 	uint8_t entry_count;		/* Entry count. */
-	uint8_t sys_define;		/* System defined. */
+	uint8_t handle_count;
 	uint8_t entry_status;		/* Entry Status. */
=20
 	uint32_t handle;		/* System handle. */
=20
-	uint16_t reserved_1;
+	uint16_t flags;
+#define CS_VF_BIND_VPORTS_TO_VF         BIT_0
+#define CS_VF_SET_QOS_OF_VPORTS         BIT_1
+#define CS_VF_SET_HOPS_OF_VPORTS        BIT_2
=20
 	uint16_t comp_status;		/* Completion status. */
 #define CS_VCT_STS_ERROR	0x01	/* Specified VPs were not
disabled. */
@@ -1009,27 +1049,29 @@ struct vp_config_entry_24xx {
 #define CS_VCT_BUSY		0x05	/* Firmware not ready to accept
cmd. */
=20
 	uint8_t command;
-#define VCT_COMMAND_MOD_VPS	0x00	/* Enable VPs. */
-#define VCT_COMMAND_MOD_ENABLE_VPS 0x08	/* Disable VPs. */
+#define VCT_COMMAND_MOD_VPS     0x00    /* Modify VP configurations. */
+#define VCT_COMMAND_MOD_ENABLE_VPS 0x01 /* Modify configuration &
enable VPs. */
=20
 	uint8_t vp_count;
=20
-	uint8_t vp_idx1;
-	uint8_t vp_idx2;
+	uint8_t vp_index1;
+	uint8_t vp_index2;
=20
 	uint8_t options_idx1;
 	uint8_t hard_address_idx1;
-	uint16_t reserved_2;
+	uint16_t reserved_vp1;
 	uint8_t port_name_idx1[WWN_SIZE];
 	uint8_t node_name_idx1[WWN_SIZE];
=20
 	uint8_t options_idx2;
 	uint8_t hard_address_idx2;
-	uint16_t reserved_3;
+	uint16_t reserved_vp2;
 	uint8_t port_name_idx2[WWN_SIZE];
 	uint8_t node_name_idx2[WWN_SIZE];
-
-	uint8_t reserved_4[8];
+	struct vf_id    id;
+	uint16_t reserved_4;
+	struct vf_hopct  hopct;
+	uint8_t reserved_5;
 };
=20
 #define VP_RPT_ID_IOCB_TYPE	0x32	/* Report ID Acquisition entry.
*/
@@ -1054,5 +1096,30 @@ struct vp_rpt_id_entry_24xx {
 	uint8_t reserved_4[32];
 };
=20
+#define VF_EVFP_IOCB_TYPE       0x26    /* Exchange Virtual Fabric
Parameters entry. */
+struct vf_evfp_entry_24xx {
+        uint8_t entry_type;             /* Entry type. */
+        uint8_t entry_count;            /* Entry count. */
+        uint8_t sys_define;             /* System defined. */
+        uint8_t entry_status;           /* Entry Status. */
+
+        uint32_t handle;                /* System handle. */
+        uint16_t comp_status;           /* Completion status. */
+        uint16_t timeout;               /* timeout */
+        uint16_t adim_tagging_mode;
+
+        uint16_t vfport_id;
+        uint32_t exch_addr;
+
+        uint16_t nport_handle;          /* N_PORT handle. */
+        uint16_t control_flags;
+        uint32_t io_parameter_0;
+        uint32_t io_parameter_1;
+        uint32_t tx_address[2];         /* Data segment 0 address. */
+        uint32_t tx_len;                /* Data segment 0 length. */
+        uint32_t rx_address[2];         /* Data segment 1 address. */
+        uint32_t rx_len;                /* Data segment 1 length. */
+};
+
 /* END MID Support
***********************************************************/
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h
b/drivers/scsi/qla2xxx/qla_gbl.h
index 74544ae..b44eff2 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -62,6 +62,38 @@ extern int ql2xfdmienable;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
+extern int num_hosts;
+
+/*
+ * Global Functions in qla_mid.c source file.
+ */
+extern struct scsi_host_template qla2x00_driver_template;
+extern struct scsi_host_template qla24xx_driver_template;
+extern struct scsi_transport_template
*qla2xxx_transport_vport_template;
+extern uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
+extern void qla2x00_timer(scsi_qla_host_t *);
+extern void qla2x00_start_timer(scsi_qla_host_t *, void *, unsigned
long);
+extern void qla2x00_stop_timer(scsi_qla_host_t *);
+extern uint32_t qla24xx_allocate_vp_id(scsi_qla_host_t *);
+extern void qla24xx_deallocate_vp_id(scsi_qla_host_t *);
+extern int qla24xx_disable_vp (scsi_qla_host_t *);
+extern int qla24xx_enable_vp (scsi_qla_host_t *);
+extern void qla2x00_mem_free(scsi_qla_host_t *);
+extern int qla24xx_control_vp(scsi_qla_host_t *, int );
+extern int qla24xx_modify_vp_config(scsi_qla_host_t *);
+extern int qla2x00_send_change_request(scsi_qla_host_t *, uint16_t,
uint16_t);
+extern void qla2x00_vp_stop_timer(scsi_qla_host_t *);
+extern int qla24xx_configure_vhba (scsi_qla_host_t *);
+extern int qla24xx_get_vp_entry(scsi_qla_host_t *, uint16_t, int);
+extern int qla24xx_get_vp_database(scsi_qla_host_t *, uint16_t);
+extern int qla2x00_do_dpc_vp(scsi_qla_host_t *);
+extern void qla24xx_report_id_acquisition(scsi_qla_host_t *,
+    struct vp_rpt_id_entry_24xx *);
+extern scsi_qla_host_t * qla24xx_find_vhost_by_name(scsi_qla_host_t *,
+    uint8_t *);
+extern void qla2x00_do_dpc_all_vps(scsi_qla_host_t *);
+extern int qla24xx_vport_create_req_sanity_check(struct fc_vport *);
+extern scsi_qla_host_t * qla24xx_create_vhost(struct fc_vport *);
=20
 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
=20
@@ -77,6 +109,10 @@ extern struct fw_blob
*qla2x00_request_firmware(scsi_qla_host_t *);
 extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
=20
 extern void qla2xxx_wake_dpc(scsi_qla_host_t *);
+extern void qla2x00_alert_all_vps(scsi_qla_host_t *, uint16_t *);
+extern void qla2x00_async_event(scsi_qla_host_t *, uint16_t *);
+extern void qla2x00_vp_abort_isp(scsi_qla_host_t *);
+extern int qla24xx_vport_delete(struct fc_vport *);
=20
 /*
  * Global Function Prototypes in qla_iocb.c source file.
@@ -128,7 +164,7 @@ qla2x00_abort_target(fc_port_t *);
=20
 extern int
 qla2x00_get_adapter_id(scsi_qla_host_t *, uint16_t *, uint8_t *,
uint8_t *,
-    uint8_t *, uint16_t *);
+    uint8_t *, uint16_t *, uint16_t *);
=20
 extern int
 qla2x00_get_retry_cnt(scsi_qla_host_t *, uint8_t *, uint8_t *, uint16_t
*);
@@ -303,6 +339,7 @@ struct class_device_attribute;
 extern struct class_device_attribute *qla2x00_host_attrs[];
 struct fc_function_template;
 extern struct fc_function_template qla2xxx_transport_functions;
+extern struct fc_function_template qla2xxx_transport_vport_functions;
 extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_init_host_attr(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c
b/drivers/scsi/qla2xxx/qla_gs.c
index ec5b2dd..a086b3f 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -88,6 +88,7 @@ qla24xx_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t
req_size, uint32_t rsp_size)
 	ct_pkt->dseg_1_address[0] =3D cpu_to_le32(LSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_address[1] =3D cpu_to_le32(MSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_len =3D ct_pkt->rsp_byte_count;
+	ct_pkt->vp_index =3D ha->vp_idx;
=20
 	return (ct_pkt);
 }
@@ -1186,6 +1187,7 @@ qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *ha,
uint32_t req_size,
 	ct_pkt->dseg_1_address[0] =3D cpu_to_le32(LSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_address[1] =3D cpu_to_le32(MSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_len =3D ct_pkt->rsp_byte_count;
+	ct_pkt->vp_index =3D ha->vp_idx;
=20
 	return ct_pkt;
 }
@@ -1746,6 +1748,7 @@ qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *ha,
uint32_t req_size,
 	ct_pkt->dseg_1_address[0] =3D cpu_to_le32(LSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_address[1] =3D cpu_to_le32(MSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_len =3D ct_pkt->rsp_byte_count;
+	ct_pkt->vp_index =3D ha->vp_idx;
=20
 	return ct_pkt;
 }
diff --git a/drivers/scsi/qla2xxx/qla_init.c
b/drivers/scsi/qla2xxx/qla_init.c
index 2a45aec..847066b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -899,6 +899,10 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 				    &ha->fw_subminor_version,
 				    &ha->fw_attributes,
&ha->fw_memory_size);
 				qla2x00_resize_request_q(ha);
+				ha->flags.npiv_supported =3D 0;
+				if (IS_QLA24XX(ha) &&
+				    (ha->fw_attributes & BIT_2))
+					ha->flags.npiv_supported =3D 1;
=20
 				if (ql2xallocfwdump)
 					qla2x00_alloc_fw_dump(ha);
@@ -1101,6 +1105,8 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 	int	rval;
 	unsigned long flags =3D 0;
 	int cnt;
+	struct mid_init_cb_24xx *mid_init_cb =3D
+	    (struct mid_init_cb_24xx *) ha->init_cb;
=20
 	spin_lock_irqsave(&ha->hardware_lock, flags);
=20
@@ -1132,6 +1138,10 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 	ha->isp_ops.update_fw_options(ha);
=20
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
+
+	mid_init_cb->count =3D MAX_NUM_VPORT_FABRIC;
+	ha->max_npiv_vports =3D MAX_NUM_VPORT_FABRIC;
+
 	rval =3D qla2x00_init_firmware(ha, ha->init_cb_size);
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Init firmware **** FAILED
****.\n",
@@ -1263,6 +1273,7 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 	int       rval;
 	uint16_t      loop_id;
 	uint16_t      topo;
+	uint16_t      sw_cap;
 	uint8_t       al_pa;
 	uint8_t       area;
 	uint8_t       domain;
@@ -1270,7 +1281,7 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
=20
 	/* Get host addresses. */
 	rval =3D qla2x00_get_adapter_id(ha,
-	    &loop_id, &al_pa, &area, &domain, &topo);
+	    &loop_id, &al_pa, &area, &domain, &topo, &sw_cap);
 	if (rval !=3D QLA_SUCCESS) {
 		if (LOOP_TRANSITION(ha) ||
atomic_read(&ha->loop_down_timer) ||
 		    (rval =3D=3D QLA_COMMAND_ERROR && loop_id =3D=3D 0x7)) {
@@ -1295,6 +1306,7 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 	/* initialize */
 	ha->min_external_loopid =3D SNS_FIRST_LOOP_ID;
 	ha->operating_mode =3D LOOP;
+	ha->switch_cap =3D 0;
=20
 	switch (topo) {
 	case 0:
@@ -1307,6 +1319,7 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 	case 1:
 		DEBUG3(printk("scsi(%ld): HBA in FL topology.\n",
 		    ha->host_no));
+		ha->switch_cap =3D sw_cap;
 		ha->current_topology =3D ISP_CFG_FL;
 		strcpy(connect_type, "(FL_Port)");
 		break;
@@ -1322,6 +1335,7 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 	case 3:
 		DEBUG3(printk("scsi(%ld): HBA in F P2P topology.\n",
 		    ha->host_no));
+		ha->switch_cap =3D sw_cap;
 		ha->operating_mode =3D P2P;
 		ha->current_topology =3D ISP_CFG_F;
 		strcpy(connect_type, "(F_Port)");
@@ -1743,7 +1757,6 @@ qla2x00_rport_del(void *data)
 	spin_unlock_irqrestore(&fcport->rport_lock, flags);
 	if (rport)
 		fc_remote_port_delete(rport);
-
 }
=20
 /**
@@ -1765,6 +1778,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha, gfp_t
flags)
 	/* Setup fcport template structure. */
 	memset(fcport, 0, sizeof (fc_port_t));
 	fcport->ha =3D ha;
+	fcport->vp_idx =3D ha->vp_idx;
 	fcport->port_type =3D FCT_UNKNOWN;
 	fcport->loop_id =3D FC_NO_LOOP_ID;
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
@@ -1911,6 +1925,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 	char		*id_iter;
 	uint16_t	loop_id;
 	uint8_t		domain, area, al_pa;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	found_devs =3D 0;
 	new_fcport =3D NULL;
@@ -1942,7 +1957,10 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 	/*
 	 * Mark local devices that were present with FCF_DEVICE_LOST for
now.
 	 */
-	list_for_each_entry(fcport, &ha->fcports, list) {
+	list_for_each_entry(fcport, &pha->fcports, list) {
+		if (fcport->vp_idx !=3D ha->vp_idx)
+			continue;
+
 		if (atomic_read(&fcport->state) =3D=3D FCS_ONLINE &&
 		    fcport->port_type !=3D FCT_BROADCAST &&
 		    (fcport->flags & FCF_FABRIC_DEVICE) =3D=3D 0) {
@@ -1988,6 +2006,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 		new_fcport->d_id.b.area =3D area;
 		new_fcport->d_id.b.al_pa =3D al_pa;
 		new_fcport->loop_id =3D loop_id;
+		new_fcport->vp_idx =3D ha->vp_idx;
 		rval2 =3D qla2x00_get_port_database(ha, new_fcport, 0);
 		if (rval2 !=3D QLA_SUCCESS) {
 			DEBUG2(printk("scsi(%ld): Failed to retrieve
fcport "
@@ -2003,7 +2022,10 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 		/* Check for matching device in port list. */
 		found =3D 0;
 		fcport =3D NULL;
-		list_for_each_entry(fcport, &ha->fcports, list) {
+		list_for_each_entry(fcport, &pha->fcports, list) {
+			if (fcport->vp_idx !=3D ha->vp_idx)
+				continue;
+
 			if (memcmp(new_fcport->port_name,
fcport->port_name,
 			    WWN_SIZE))
 				continue;
@@ -2023,7 +2045,13 @@ qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 		if (!found) {
 			/* New device, add to fcports list. */
 			new_fcport->flags &=3D ~FCF_PERSISTENT_BOUND;
-			list_add_tail(&new_fcport->list, &ha->fcports);
+			if (ha->parent) {
+				new_fcport->ha =3D ha;
+				new_fcport->vp_idx =3D ha->vp_idx;
+				list_add_tail(&new_fcport->vp_fcport,
+				    &ha->vp_fcports);
+			}
+			list_add_tail(&new_fcport->list, &pha->fcports);
=20
 			/* Allocate a new replacement fcport. */
 			fcport =3D new_fcport;
@@ -2199,11 +2227,13 @@ qla2x00_reg_remote_port(scsi_qla_host_t *ha,
fc_port_t *fcport)
 void
 qla2x00_update_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
+
 	fcport->ha =3D ha;
 	fcport->login_retry =3D 0;
-	fcport->port_login_retry_count =3D ha->port_down_retry_count *
+	fcport->port_login_retry_count =3D pha->port_down_retry_count *
 	    PORT_RETRY_TIME;
-	atomic_set(&fcport->port_down_timer, ha->port_down_retry_count *
+	atomic_set(&fcport->port_down_timer, pha->port_down_retry_count
*
 	    PORT_RETRY_TIME);
 	fcport->flags &=3D ~FCF_LOGIN_NEEDED;
=20
@@ -2234,6 +2264,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 	uint16_t	mb[MAILBOX_REGISTER_COUNT];
 	uint16_t	loop_id;
 	LIST_HEAD(new_fcports);
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	/* If FL port exists, then SNS is present */
 	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
@@ -2307,7 +2338,10 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 		 * Logout all previous fabric devices marked lost,
except
 		 * tape devices.
 		 */
-		list_for_each_entry(fcport, &ha->fcports, list) {
+		list_for_each_entry(fcport, &pha->fcports, list) {
+			if (fcport->vp_idx !=3Dha->vp_idx)
+				continue;
+
 			if (test_bit(LOOP_RESYNC_NEEDED,
&ha->dpc_flags))
 				break;
=20
@@ -2332,13 +2366,16 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 		}
=20
 		/* Starting free loop ID. */
-		next_loopid =3D ha->min_external_loopid;
+		next_loopid =3D pha->min_external_loopid;
=20
 		/*
 		 * Scan through our port list and login entries that
need to be
 		 * logged in.
 		 */
-		list_for_each_entry(fcport, &ha->fcports, list) {
+		list_for_each_entry(fcport, &pha->fcports, list) {
+			if (fcport->vp_idx !=3D ha->vp_idx)
+				continue;
+
 			if (atomic_read(&ha->loop_down_timer) ||
 			    test_bit(LOOP_RESYNC_NEEDED,
&ha->dpc_flags))
 				break;
@@ -2380,11 +2417,18 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 				break;
 			}
=20
-			/* Remove device from the new list and add it to
DB */
-			list_move_tail(&fcport->list, &ha->fcports);
-
 			/* Login and update database */
 			qla2x00_fabric_dev_login(ha, fcport,
&next_loopid);
+
+			if (ha->parent) {
+				fcport->ha =3D ha;
+				fcport->vp_idx =3D ha->vp_idx;
+				list_add_tail(&fcport->vp_fcport,
+				    &ha->vp_fcports);
+				list_move_tail(&fcport->list,
+				    &ha->parent->fcports);
+			} else
+				list_move_tail(&fcport->list,
&ha->fcports);
 		}
 	} while (0);
=20
@@ -2428,6 +2472,11 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha,
struct list_head *new_fcports)
 	int		swl_idx;
 	int		first_dev, last_dev;
 	port_id_t	wrap, nxt_d_id;
+	int 		vp_index;
+	int		empty_vp_index;
+	int		found_vp;
+	scsi_qla_host_t *vha;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	rval =3D QLA_SUCCESS;
=20
@@ -2461,13 +2510,13 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t
*ha, struct list_head *new_fcports)
 		return (QLA_MEMORY_ALLOC_FAILED);
 	}
 	new_fcport->flags |=3D (FCF_FABRIC_DEVICE | FCF_LOGIN_NEEDED);
-
+	new_fcport->vp_idx =3D ha->vp_idx;
 	/* Set start port ID scan at adapter ID. */
 	first_dev =3D 1;
 	last_dev =3D 0;
=20
 	/* Starting free loop ID. */
-	loop_id =3D ha->min_external_loopid;
+	loop_id =3D pha->min_external_loopid;
 	for (; loop_id <=3D ha->last_loop_id; loop_id++) {
 		if (qla2x00_is_reserved_id(ha, loop_id))
 			continue;
@@ -2521,9 +2570,41 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha,
struct list_head *new_fcports)
 			break;
 		}
=20
-		/* Bypass if host adapter. */
-		if (new_fcport->d_id.b24 =3D=3D ha->d_id.b24)
-			continue;
+		/* Bypass if same physical adapter. */
+		if (new_fcport->d_id.b24 =3D=3D pha->d_id.b24)
+ 			continue;
+
+		/* Bypass virtual ports of the same host. */
+		if (pha->num_vhosts) {
+			vp_index =3D find_next_bit(
+			    (unsigned long *)pha->vp_idx_map,
+			    MAX_MULTI_ID_FABRIC + 1, 1);
+
+			for (;vp_index <=3D MAX_MULTI_ID_FABRIC;
+			    vp_index =3D find_next_bit(
+			    (unsigned long *)pha->vp_idx_map,
+			    MAX_MULTI_ID_FABRIC + 1, vp_index + 1)) {
+				empty_vp_index =3D 1;
+				found_vp =3D 0;
+				list_for_each_entry(vha, &pha->vp_list,
+				    vp_list) {
+					if (vp_index =3D=3D vha->vp_idx) {
+						empty_vp_index =3D 0;
+						found_vp =3D 1;
+						break;
+					}
+				}
+
+				if (empty_vp_index)
+					continue;
+
+				if (found_vp &&
+				    new_fcport->d_id.b24 =3D=3D
vha->d_id.b24)
+					break;
+			}
+			if (vp_index <=3D MAX_MULTI_ID_FABRIC)
+				continue;
+		}
=20
 		/* Bypass if same domain and area of adapter. */
 		if (((new_fcport->d_id.b24 & 0xffff00) =3D=3D
@@ -2537,7 +2618,9 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha,
struct list_head *new_fcports)
=20
 		/* Locate matching device in database. */
 		found =3D 0;
-		list_for_each_entry(fcport, &ha->fcports, list) {
+		list_for_each_entry(fcport, &pha->fcports, list) {
+			if (new_fcport->vp_idx !=3D fcport->vp_idx)
+				continue;
 			if (memcmp(new_fcport->port_name,
fcport->port_name,
 			    WWN_SIZE))
 				continue;
@@ -2605,6 +2688,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha,
struct list_head *new_fcports)
 		}
 		new_fcport->flags |=3D (FCF_FABRIC_DEVICE |
FCF_LOGIN_NEEDED);
 		new_fcport->d_id.b24 =3D nxt_d_id.b24;
+		new_fcport->vp_idx =3D ha->vp_idx;
 	}
=20
 	kfree(swl);
@@ -2637,6 +2721,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *ha,
fc_port_t *dev)
 	int	found;
 	fc_port_t *fcport;
 	uint16_t first_loop_id;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	rval =3D QLA_SUCCESS;
=20
@@ -2663,7 +2748,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *ha,
fc_port_t *dev)
 		/* Check for loop ID being already in use. */
 		found =3D 0;
 		fcport =3D NULL;
-		list_for_each_entry(fcport, &ha->fcports, list) {
+		list_for_each_entry(fcport, &pha->fcports, list) {
 			if (fcport->loop_id =3D=3D dev->loop_id && fcport !=3D
dev) {
 				/* ID possibly in use */
 				found++;
@@ -2710,6 +2795,7 @@ qla2x00_device_resync(scsi_qla_host_t *ha)
 	uint8_t rscn_out_iter;
 	uint8_t format;
 	port_id_t d_id;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	rval =3D QLA_RSCNS_HANDLED;
=20
@@ -2776,7 +2862,10 @@ qla2x00_device_resync(scsi_qla_host_t *ha)
=20
 		rval =3D QLA_SUCCESS;
=20
-		list_for_each_entry(fcport, &ha->fcports, list) {
+		list_for_each_entry(fcport, &pha->fcports, list) {
+			if (fcport->vp_idx !=3D ha->vp_idx)
+				continue;
+
 			if ((fcport->flags & FCF_FABRIC_DEVICE) =3D=3D 0 ||
 			    (fcport->d_id.b24 & mask) !=3D d_id.b24 ||
 			    fcport->port_type =3D=3D FCT_BROADCAST)
@@ -3940,3 +4029,40 @@ qla2x00_try_to_stop_firmware(scsi_qla_host_t *ha)
 		ret =3D qla2x00_stop_firmware(ha);
 	}
 }
+
+int
+qla24xx_configure_vhba(scsi_qla_host_t *ha)
+{
+	int rval =3D QLA_SUCCESS;
+	uint16_t mb[MAILBOX_REGISTER_COUNT];
+
+	if (!ha->parent)
+		return -EINVAL;
+
+	rval =3D qla2x00_fw_ready(ha);
+	if (rval =3D=3D QLA_SUCCESS) {
+		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
+		qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
+	}
+
+	ha->flags.management_server_logged_in =3D 0;
+
+	/* Login to SNS first */
+	qla24xx_login_fabric(ha, NPH_SNS, 0xff, 0xff, 0xfc,
+	    mb, BIT_1);
+	if (mb[0] !=3D MBS_COMMAND_COMPLETE) {
+		DEBUG15(qla_printk(KERN_INFO, ha,
+		    "Failed SNS login: loop_id=3D%x mb[0]=3D%x mb[1]=3D%x "
+		    "mb[2]=3D%x mb[6]=3D%x mb[7]=3D%x\n", NPH_SNS,
+		    mb[0], mb[1], mb[2], mb[6], mb[7]));
+		return (QLA_FUNCTION_FAILED);
+	}
+
+	atomic_set(&ha->loop_down_timer, 0);
+	atomic_set(&ha->loop_state, LOOP_UP);
+	set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
+	set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
+	rval =3D qla2x00_loop_resync(ha);
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c
b/drivers/scsi/qla2xxx/qla_iocb.c
index c517a14..c71863f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -179,7 +179,6 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp,
cmd_entry_t *cmd_pkt,
 	cur_dsd =3D (uint32_t *)&cmd_pkt->dseg_0_address;
=20
 	/* Load data segments */
-
 	scsi_for_each_sg(cmd, sg, tot_dsds, i) {
 		cont_entry_t *cont_pkt;
=20
@@ -316,9 +315,14 @@ qla2x00_start_scsi(srb_t *sp)
 		goto queuing_error;
=20
 	/* Map the sg table so we have an accurate count of sg entries
needed */
-	nseg =3D scsi_dma_map(cmd);
-	if (nseg < 0)
-		goto queuing_error;
+	if (scsi_sg_count(cmd)) {
+		nseg =3D dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
+		    scsi_sg_count(cmd), cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			goto queuing_error;
+	} else
+		nseg =3D 0;
+
 	tot_dsds =3D nseg;
=20
 	/* Calculate the number of request entries needed. */
@@ -414,9 +418,10 @@ __qla2x00_marker(scsi_qla_host_t *ha, uint16_t
loop_id, uint16_t lun,
 {
 	mrk_entry_t *mrk;
 	struct mrk_entry_24xx *mrk24;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	mrk24 =3D NULL;
-	mrk =3D (mrk_entry_t *)qla2x00_req_pkt(ha);
+	mrk =3D (mrk_entry_t *)qla2x00_req_pkt(pha);
 	if (mrk =3D=3D NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Marker
IOCB.\n",
 		    __func__, ha->host_no));
@@ -433,6 +438,7 @@ __qla2x00_marker(scsi_qla_host_t *ha, uint16_t
loop_id, uint16_t lun,
 			mrk24->lun[1] =3D LSB(lun);
 			mrk24->lun[2] =3D MSB(lun);
 			host_to_fcp_swap(mrk24->lun,
sizeof(mrk24->lun));
+			mrk24->vp_index =3D ha->vp_idx;
 		} else {
 			SET_TARGET_ID(ha, mrk->target, loop_id);
 			mrk->lun =3D cpu_to_le16(lun);
@@ -440,7 +446,7 @@ __qla2x00_marker(scsi_qla_host_t *ha, uint16_t
loop_id, uint16_t lun,
 	}
 	wmb();
=20
-	qla2x00_isp_cmd(ha);
+	qla2x00_isp_cmd(pha);
=20
 	return (QLA_SUCCESS);
 }
@@ -712,9 +718,14 @@ qla24xx_start_scsi(srb_t *sp)
 		goto queuing_error;
=20
 	/* Map the sg table so we have an accurate count of sg entries
needed */
-	nseg =3D scsi_dma_map(cmd);
-	if (nseg < 0)
+	if (scsi_sg_count(cmd)) {
+		nseg =3D dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
+		    scsi_sg_count(cmd), cmd->sc_data_direction);
+		if (unlikely(!nseg))
 			goto queuing_error;
+	} else
+		nseg =3D 0;
+
 	tot_dsds =3D nseg;
=20
 	req_cnt =3D qla24xx_calc_iocbs(tot_dsds);
@@ -750,6 +761,7 @@ qla24xx_start_scsi(srb_t *sp)
 	cmd_pkt->port_id[0] =3D sp->fcport->d_id.b.al_pa;
 	cmd_pkt->port_id[1] =3D sp->fcport->d_id.b.area;
 	cmd_pkt->port_id[2] =3D sp->fcport->d_id.b.domain;
+	cmd_pkt->vp_index =3D sp->fcport->vp_idx;
=20
 	int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
 	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun,
sizeof(cmd_pkt->lun));
diff --git a/drivers/scsi/qla2xxx/qla_isr.c
b/drivers/scsi/qla2xxx/qla_isr.c
index 6ce532c..0ba4c8d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -9,7 +9,6 @@
 #include <scsi/scsi_tcq.h>
=20
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
-static void qla2x00_async_event(scsi_qla_host_t *, uint16_t *);
 static void qla2x00_process_completed_request(struct scsi_qla_host *,
uint32_t);
 static void qla2x00_status_entry(scsi_qla_host_t *, void *);
 static void qla2x00_status_cont_entry(scsi_qla_host_t *,
sts_cont_entry_t *);
@@ -244,7 +243,7 @@ qla2x00_mbx_completion(scsi_qla_host_t *ha, uint16_t
mb0)
  * @ha: SCSI driver HA context
  * @mb: Mailbox registers (0 - 3)
  */
-static void
+void
 qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 {
 #define LS_UNKNOWN	2
@@ -386,6 +385,11 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t
*mb)
 			qla2x00_mark_all_devices_lost(ha, 1);
 		}
=20
+		if (ha->parent) {
+			atomic_set(&ha->vp_state, VP_FAILED);
+			fc_vport_set_state(ha->fc_vport,
FC_VPORT_FAILED);
+		}
+
 		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
=20
 		ha->flags.management_server_logged_in =3D 0;
@@ -422,6 +426,11 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t
*mb)
 			qla2x00_mark_all_devices_lost(ha, 1);
 		}
=20
+		if (ha->parent) {
+			atomic_set(&ha->vp_state, VP_FAILED);
+			fc_vport_set_state(ha->fc_vport,
FC_VPORT_FAILED);
+		}
+
 		ha->flags.management_server_logged_in =3D 0;
 		ha->link_data_rate =3D PORT_SPEED_UNKNOWN;
 		if (ql2xfdmienable)
@@ -440,6 +449,11 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t
*mb)
 			qla2x00_mark_all_devices_lost(ha, 1);
 		}
=20
+		if (ha->parent) {
+			atomic_set(&ha->vp_state, VP_FAILED);
+			fc_vport_set_state(ha->fc_vport,
FC_VPORT_FAILED);
+		}
+
 		set_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
=20
 		ha->operating_mode =3D LOOP;
@@ -465,6 +479,11 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t
*mb)
 			qla2x00_mark_all_devices_lost(ha, 1);
 		}
=20
+		if (ha->parent) {
+			atomic_set(&ha->vp_state, VP_FAILED);
+			fc_vport_set_state(ha->fc_vport,
FC_VPORT_FAILED);
+		}
+
 		if (!(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags))) {
 			set_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 		}
@@ -491,6 +510,11 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t
*mb)
 			qla2x00_mark_all_devices_lost(ha, 1);
 		}
=20
+		if (ha->parent) {
+			atomic_set(&ha->vp_state, VP_FAILED);
+			fc_vport_set_state(ha->fc_vport,
FC_VPORT_FAILED);
+		}
+
 		set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
 		break;
@@ -530,6 +554,10 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t
*mb)
 		break;
=20
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
+		/* Check if the Vport has issued a SCR */
+		if (ha->parent && test_bit(VP_SCR_NEEDED,
&ha->vp_flags))
+			break;
+
 		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
 		    ha->host_no));
 		DEBUG(printk(KERN_INFO
@@ -589,6 +617,9 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t
*mb)
 		ha->host_no, mb[1], mb[2]));
 		break;
 	}
+
+	if (!ha->parent && ha->num_vhosts)
+		qla2x00_alert_all_vps(ha, mb);
 }
=20
 static void
@@ -1393,6 +1424,10 @@ qla24xx_process_response_queue(struct
scsi_qla_host *ha)
 		case MS_IOCB_TYPE:
 			qla24xx_ms_entry(ha, (struct ct_entry_24xx
*)pkt);
 			break;
+		case VP_RPT_ID_IOCB_TYPE:
+			qla24xx_report_id_acquisition(ha,
+			    (struct vp_rpt_id_entry_24xx *)pkt);
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c
b/drivers/scsi/qla2xxx/qla_mbx.c
index 71e32a2..ee2ab85 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -42,25 +42,29 @@ qla2x00_mbx_sem_timeout(unsigned long data)
  *	Kernel context.
  */
 static int
-qla2x00_mailbox_command(scsi_qla_host_t *ha, mbx_cmd_t *mcp)
+qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 {
 	int		rval;
 	unsigned long    flags =3D 0;
-	device_reg_t __iomem *reg =3D ha->iobase;
+	device_reg_t __iomem *reg;
 	struct timer_list	tmp_intr_timer;
 	uint8_t		abort_active;
-	uint8_t		io_lock_on =3D ha->flags.init_done;
+	uint8_t		io_lock_on;
 	uint16_t	command;
 	uint16_t	*iptr;
 	uint16_t __iomem *optr;
 	uint32_t	cnt;
 	uint32_t	mboxes;
 	unsigned long	wait_time;
+	scsi_qla_host_t *ha =3D to_qla_parent(pvha);
+
+	reg =3D ha->iobase;
+	io_lock_on =3D ha->flags.init_done;
=20
 	rval =3D QLA_SUCCESS;
 	abort_active =3D test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
=20
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, pvha->host_no));
=20
 	/*
 	 * Wait for active mailbox commands to finish by waiting at most
tov
@@ -889,7 +893,7 @@ qla2x00_abort_target(fc_port_t *fcport)
  */
 int
 qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t
*al_pa,
-    uint8_t *area, uint8_t *domain, uint16_t *top)
+    uint8_t *area, uint8_t *domain, uint16_t *top, uint16_t *sw_cap)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -899,8 +903,9 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t
*id, uint8_t *al_pa,
 	    ha->host_no));
=20
 	mcp->mb[0] =3D MBC_GET_ADAPTER_LOOP_ID;
+	mcp->mb[9] =3D ha->vp_idx;
 	mcp->out_mb =3D MBX_0;
-	mcp->in_mb =3D MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb =3D MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov =3D 30;
 	mcp->flags =3D 0;
 	rval =3D qla2x00_mailbox_command(ha, mcp);
@@ -913,6 +918,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t
*id, uint8_t *al_pa,
 	*area =3D MSB(mcp->mb[2]);
 	*domain	=3D LSB(mcp->mb[3]);
 	*top =3D mcp->mb[6];
+	*sw_cap =3D mcp->mb[7];
=20
 	if (rval !=3D QLA_SUCCESS) {
 		/*EMPTY*/
@@ -1009,7 +1015,11 @@ qla2x00_init_firmware(scsi_qla_host_t *ha,
uint16_t size)
 	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
 	    ha->host_no));
=20
-	mcp->mb[0] =3D MBC_INITIALIZE_FIRMWARE;
+	if (ha->flags.npiv_supported)
+		mcp->mb[0] =3D MBC_MID_INITIALIZE_FIRMWARE;
+	else
+		mcp->mb[0] =3D MBC_INITIALIZE_FIRMWARE;
+
 	mcp->mb[2] =3D MSW(ha->init_cb_dma);
 	mcp->mb[3] =3D LSW(ha->init_cb_dma);
 	mcp->mb[4] =3D 0;
@@ -1081,7 +1091,8 @@ qla2x00_get_port_database(scsi_qla_host_t *ha,
fc_port_t *fcport, uint8_t opt)
 	mcp->mb[3] =3D LSW(pd_dma);
 	mcp->mb[6] =3D MSW(MSD(pd_dma));
 	mcp->mb[7] =3D LSW(MSD(pd_dma));
-	mcp->out_mb =3D MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
+	mcp->mb[9] =3D ha->vp_idx;
+	mcp->out_mb =3D MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb =3D MBX_0;
 	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[1] =3D fcport->loop_id;
@@ -1259,7 +1270,8 @@ qla2x00_get_port_name(scsi_qla_host_t *ha,
uint16_t loop_id, uint8_t *name,
 	    ha->host_no));
=20
 	mcp->mb[0] =3D MBC_GET_PORT_NAME;
-	mcp->out_mb =3D MBX_1|MBX_0;
+	mcp->mb[9] =3D ha->vp_idx;
+	mcp->out_mb =3D MBX_9|MBX_1|MBX_0;
 	if (HAS_EXTENDED_IDS(ha)) {
 		mcp->mb[1] =3D loop_id;
 		mcp->mb[10] =3D opt;
@@ -1447,6 +1459,7 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t
loop_id, uint8_t domain,
 	lg->port_id[0] =3D al_pa;
 	lg->port_id[1] =3D area;
 	lg->port_id[2] =3D domain;
+	lg->vp_index =3D cpu_to_le16(ha->vp_idx);
 	rval =3D qla2x00_issue_iocb(ha, lg, lg_dma, 0);
 	if (rval !=3D QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Login IOCB
"
@@ -1701,6 +1714,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *ha,
uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] =3D al_pa;
 	lg->port_id[1] =3D area;
 	lg->port_id[2] =3D domain;
+	lg->vp_index =3D cpu_to_le16(ha->vp_idx);
 	rval =3D qla2x00_issue_iocb(ha, lg, lg_dma, 0);
 	if (rval !=3D QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Logout IOCB
"
@@ -1863,7 +1877,8 @@ qla2x00_get_id_list(scsi_qla_host_t *ha, void
*id_list, dma_addr_t id_list_dma,
 		mcp->mb[6] =3D MSW(MSD(id_list_dma));
 		mcp->mb[7] =3D LSW(MSD(id_list_dma));
 		mcp->mb[8] =3D 0;
-		mcp->out_mb |=3D MBX_8|MBX_7|MBX_6|MBX_3|MBX_2;
+		mcp->mb[9] =3D ha->vp_idx;
+		mcp->out_mb |=3D MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2;
 	} else {
 		mcp->mb[1] =3D MSW(id_list_dma);
 		mcp->mb[2] =3D LSW(id_list_dma);
@@ -2212,6 +2227,7 @@ qla24xx_abort_command(scsi_qla_host_t *ha, srb_t
*sp)
 	abt->port_id[0] =3D fcport->d_id.b.al_pa;
 	abt->port_id[1] =3D fcport->d_id.b.area;
 	abt->port_id[2] =3D fcport->d_id.b.domain;
+	abt->vp_index =3D fcport->vp_idx;
 	rval =3D qla2x00_issue_iocb(ha, abt, abt_dma, 0);
 	if (rval !=3D QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue IOCB
(%x).\n",
@@ -2249,7 +2265,7 @@ qla24xx_abort_target(fc_port_t *fcport)
 	int		rval;
 	struct tsk_mgmt_cmd *tsk;
 	dma_addr_t	tsk_dma;
-	scsi_qla_host_t *ha;
+	scsi_qla_host_t *ha, *pha;
=20
 	if (fcport =3D=3D NULL)
 		return 0;
@@ -2257,7 +2273,8 @@ qla24xx_abort_target(fc_port_t *fcport)
 	DEBUG11(printk("%s(%ld): entered.\n", __func__,
fcport->ha->host_no));
=20
 	ha =3D fcport->ha;
-	tsk =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
+	pha =3D to_qla_parent(ha);
+	tsk =3D dma_pool_alloc(pha->s_dma_pool, GFP_KERNEL, &tsk_dma);
 	if (tsk =3D=3D NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Task
Management "
 		    "IOCB.\n", __func__, ha->host_no));
@@ -2273,6 +2290,8 @@ qla24xx_abort_target(fc_port_t *fcport)
 	tsk->p.tsk.port_id[0] =3D fcport->d_id.b.al_pa;
 	tsk->p.tsk.port_id[1] =3D fcport->d_id.b.area;
 	tsk->p.tsk.port_id[2] =3D fcport->d_id.b.domain;
+	tsk->p.tsk.vp_index =3D fcport->vp_idx;
+
 	rval =3D qla2x00_issue_iocb(ha, tsk, tsk_dma, 0);
 	if (rval !=3D QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Target
Reset IOCB "
@@ -2303,7 +2322,7 @@ qla24xx_abort_target(fc_port_t *fcport)
 	}
=20
 atarget_done:
-	dma_pool_free(ha->s_dma_pool, tsk, tsk_dma);
+	dma_pool_free(pha->s_dma_pool, tsk, tsk_dma);
=20
 	return rval;
 }
@@ -2610,3 +2629,354 @@ qla2x00_set_idma_speed(scsi_qla_host_t *ha,
uint16_t loop_id,
=20
 	return rval;
 }
+
+/*
+ * qla24xx_get_vp_database
+ *	Get the VP's database for all configured ports.
+ *
+ * Input:
+ *	ha =3D adapter block pointer.
+ *	size =3D size of initialization control block.
+ *
+ * Returns:
+ *	qla2x00 local function return status code.
+ *
+ * Context:
+ *	Kernel context.
+ */
+int
+qla24xx_get_vp_database(scsi_qla_host_t *ha, uint16_t size)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp =3D &mc;
+
+	DEBUG11(printk("scsi(%ld):%s - entered.\n",
+	    ha->host_no, __func__));
+
+	mcp->mb[0] =3D MBC_MID_GET_VP_DATABASE;
+	mcp->mb[2] =3D MSW(ha->init_cb_dma);
+	mcp->mb[3] =3D LSW(ha->init_cb_dma);
+	mcp->mb[4] =3D 0;
+	mcp->mb[5] =3D 0;
+	mcp->mb[6] =3D MSW(MSD(ha->init_cb_dma));
+	mcp->mb[7] =3D LSW(MSD(ha->init_cb_dma));
+	mcp->out_mb =3D MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
+	mcp->in_mb =3D MBX_1|MBX_0;
+	mcp->buf_size =3D size;
+	mcp->flags =3D MBX_DMA_OUT;
+	mcp->tov =3D MBX_TOV_SECONDS;
+	rval =3D qla2x00_mailbox_command(ha, mcp);
+
+	if (rval !=3D QLA_SUCCESS) {
+		/*EMPTY*/
+		DEBUG2_3_11(printk("%s(%ld): failed=3D%x "
+		    "mb0=3D%x.\n",
+		    __func__, ha->host_no, rval, mcp->mb[0]));
+	} else {
+		/*EMPTY*/
+		DEBUG11(printk("%s(%ld): done.\n",
+		    __func__, ha->host_no));
+	}
+
+	return rval;
+}
+
+int
+qla24xx_get_vp_entry(scsi_qla_host_t *ha, uint16_t size, int vp_id)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp =3D &mc;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] =3D MBC_MID_GET_VP_ENTRY;
+	mcp->mb[2] =3D MSW(ha->init_cb_dma);
+	mcp->mb[3] =3D LSW(ha->init_cb_dma);
+	mcp->mb[4] =3D 0;
+	mcp->mb[5] =3D 0;
+	mcp->mb[6] =3D MSW(MSD(ha->init_cb_dma));
+	mcp->mb[7] =3D LSW(MSD(ha->init_cb_dma));
+	mcp->mb[9] =3D vp_id;
+	mcp->out_mb =3D MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
+	mcp->in_mb =3D MBX_0;
+	mcp->buf_size =3D size;
+	mcp->flags =3D MBX_DMA_OUT;
+	mcp->tov =3D 30;
+	rval =3D qla2x00_mailbox_command(ha, mcp);
+
+	if (rval !=3D QLA_SUCCESS) {
+		/*EMPTY*/
+		DEBUG2_3_11(printk("qla24xx_get_vp_entry(%ld): failed=3D%x
"
+		    "mb0=3D%x.\n",
+		    ha->host_no, rval, mcp->mb[0]));
+	} else {
+		/*EMPTY*/
+		DEBUG11(printk("qla24xx_get_vp_entry(%ld): done.\n",
+		    ha->host_no));
+	}
+
+	return rval;
+}
+
+void
+qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
+	struct vp_rpt_id_entry_24xx *rptid_entry)
+{
+	uint8_t vp_idx;
+	scsi_qla_host_t *vha;
+
+	if (rptid_entry->entry_status !=3D 0)
+		return;
+	if (rptid_entry->entry_status !=3D
__constant_cpu_to_le16(CS_COMPLETE))
+		return;
+
+	if (rptid_entry->format =3D=3D 0) {
+		DEBUG15(printk("%s:format 0 : scsi(%ld) number of VPs
setup %d,"
+			" number of VPs acquired %d\n", __func__,
ha->host_no,
+			MSB(rptid_entry->vp_count),
LSB(rptid_entry->vp_count)));
+		DEBUG15(printk("%s primary port id %02x%02x%02x\n",
__func__,
+			rptid_entry->port_id[2],
rptid_entry->port_id[1],
+			rptid_entry->port_id[0]));
+	} else if (rptid_entry->format =3D=3D 1) {
+		vp_idx =3D LSB(rptid_entry->vp_idx);
+		DEBUG15(printk("%s:format 1: scsi(%ld): VP[%d] enabled "
+		    "- status %d - "
+		    "with port id %02x%02x%02x\n",__func__,ha->host_no,
+		    vp_idx, MSB(rptid_entry->vp_idx),
+		    rptid_entry->port_id[2], rptid_entry->port_id[1],
+		    rptid_entry->port_id[0]));
+		if (vp_idx =3D=3D 0)
+			return;
+
+		if (MSB(rptid_entry->vp_idx) =3D=3D 1)
+			return;
+
+		list_for_each_entry(vha, &ha->vp_list, vp_list)
+			if (vp_idx =3D=3D vha->vp_idx)
+				break;
+
+		if (!vha)
+			return;
+
+		vha->d_id.b.domain =3D rptid_entry->port_id[2];
+		vha->d_id.b.area =3D  rptid_entry->port_id[1];
+		vha->d_id.b.al_pa =3D rptid_entry->port_id[0];
+
+		/*
+		 * Cannot configure here as we are still sitting on the
+		 * response queue. Handle it in dpc context.
+		 */
+		set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
+	    	set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
+
+		wake_up_process(ha->dpc_thread);
+	}
+}
+
+/*
+ * qla24xx_modify_vp_config
+ *	Change VP configuration for vha
+ *
+ * Input:
+ *	vha =3D adapter block pointer.
+ *
+ * Returns:
+ *	qla2xxx local function return status code.
+ *
+ * Context:
+ *	Kernel context.
+ */
+int
+qla24xx_modify_vp_config(scsi_qla_host_t *vha)
+{
+	int		rval;
+	struct vp_config_entry_24xx *vpmod;
+	dma_addr_t	vpmod_dma;
+	scsi_qla_host_t *pha;
+
+	/* This can be called by the parent */
+	pha =3D to_qla_parent(vha);
+
+	vpmod =3D dma_pool_alloc(pha->s_dma_pool, GFP_KERNEL, &vpmod_dma);
+	if (!vpmod) {
+		DEBUG2_3(printk("%s(%ld): failed to allocate Modify VP "
+		    "IOCB.\n", __func__, pha->host_no));
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+
+	memset(vpmod, 0, sizeof(struct vp_config_entry_24xx));
+	vpmod->entry_type =3D VP_CONFIG_IOCB_TYPE;
+	vpmod->entry_count =3D 1;
+	vpmod->command =3D VCT_COMMAND_MOD_ENABLE_VPS;
+	vpmod->vp_count =3D 1;
+	vpmod->vp_index1 =3D vha->vp_idx;
+	vpmod->options_idx1 =3D BIT_3|BIT_4|BIT_5;
+	memcpy(vpmod->node_name_idx1, vha->node_name, WWN_SIZE);
+	memcpy(vpmod->port_name_idx1, vha->port_name, WWN_SIZE);
+	vpmod->entry_count =3D 1;
+
+	rval =3D qla2x00_issue_iocb(pha, vpmod, vpmod_dma, 0);
+	if (rval !=3D QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed to issue VP config
IOCB"
+			"(%x).\n", __func__, pha->host_no, rval));
+	} else if (vpmod->comp_status !=3D 0) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+			"-- error status (%x).\n", __func__,
pha->host_no,
+			vpmod->comp_status));
+		rval =3D QLA_FUNCTION_FAILED;
+	} else if (vpmod->comp_status !=3D
__constant_cpu_to_le16(CS_COMPLETE)) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- completion status (%x).\n", __func__,
pha->host_no,
+		    le16_to_cpu(vpmod->comp_status)));
+		rval =3D QLA_FUNCTION_FAILED;
+	} else {
+		/* EMPTY */
+		DEBUG11(printk("%s(%ld): done.\n", __func__,
pha->host_no));
+		fc_vport_set_state(vha->fc_vport,
FC_VPORT_INITIALIZING);
+	}
+	dma_pool_free(pha->s_dma_pool, vpmod, vpmod_dma);
+
+	return rval;
+}
+
+/*
+ * qla24xx_control_vp
+ *	Enable a virtual port for given host
+ *
+ * Input:
+ *	ha =3D adapter block pointer.
+ *	vhba =3D virtual adapter (unused)
+ *	index =3D index number for enabled VP
+ *
+ * Returns:
+ *	qla2xxx local function return status code.
+ *
+ * Context:
+ *	Kernel context.
+ */
+int
+qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
+{
+	int		rval;
+	int		map, pos;
+	struct vp_ctrl_entry_24xx   *vce;
+	dma_addr_t	vce_dma;
+	scsi_qla_host_t *ha =3D vha->parent;
+	int	vp_index =3D vha->vp_idx;
+
+	DEBUG11(printk("%s(%ld): entered. Enabling index %d\n",
__func__,
+	    ha->host_no, vp_index));
+
+	if (vp_index =3D=3D 0 || vp_index >=3D MAX_MULTI_ID_LOOP)
+		return QLA_PARAMETER_ERROR;
+
+	vce =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &vce_dma);
+	if (!vce) {
+		DEBUG2_3(printk("%s(%ld): "
+		    "failed to allocate VP Control IOCB.\n", __func__,
+		    ha->host_no));
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+	memset(vce, 0, sizeof(struct vp_ctrl_entry_24xx));
+
+	vce->entry_type =3D VP_CTRL_IOCB_TYPE;
+	vce->entry_count =3D 1;
+	vce->command =3D cpu_to_le16(cmd);
+	vce->vp_count =3D __constant_cpu_to_le16(1);
+
+	/* index map in firmware starts with 1; decrement index
+	 * this is ok as we never use index 0
+	 */
+	map =3D (vp_index - 1) / 8;
+	pos =3D (vp_index - 1) & 7;
+	down(&ha->vport_sem);
+	vce->vp_idx_map[map] |=3D 1 << pos;
+	up(&ha->vport_sem);
+
+	rval =3D qla2x00_issue_iocb(ha, vce, vce_dma, 0);
+	if (rval !=3D QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed to issue VP control
IOCB"
+		    "(%x).\n", __func__, ha->host_no, rval));
+		printk("%s(%ld): failed to issue VP control IOCB"
+		    "(%x).\n", __func__, ha->host_no, rval);
+	} else if (vce->entry_status !=3D 0) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- error status (%x).\n", __func__, ha->host_no,
+		    vce->entry_status));
+		printk("%s(%ld): failed to complete IOCB "
+		    "-- error status (%x).\n", __func__, ha->host_no,
+		    vce->entry_status);
+		rval =3D QLA_FUNCTION_FAILED;
+	} else if (vce->comp_status !=3D
__constant_cpu_to_le16(CS_COMPLETE)) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- completion status (%x).\n", __func__,
ha->host_no,
+		    le16_to_cpu(vce->comp_status)));
+		printk("%s(%ld): failed to complete IOCB "
+		    "-- completion status (%x).\n", __func__,
ha->host_no,
+		    le16_to_cpu(vce->comp_status));
+		rval =3D QLA_FUNCTION_FAILED;
+	} else {
+		DEBUG2(printk("%s(%ld): done.\n", __func__,
ha->host_no));
+	}
+
+	dma_pool_free(ha->s_dma_pool, vce, vce_dma);
+
+	return rval;
+}
+
+/*
+ * qla2x00_send_change_request
+ *	Receive or disable RSCN request from fabric controller
+ *
+ * Input:
+ *	ha =3D adapter block pointer
+ *	format =3D registration format:
+ *		0 - Reserved
+ *		1 - Fabric detected registration
+ *		2 - N_port detected registration
+ *		3 - Full registration
+ *		FF - clear registration
+ *	vp_idx =3D Virtual port index
+ *
+ * Returns:
+ *	qla2x00 local function return status code.
+ *
+ * Context:
+ *	Kernel Context
+ */
+
+int
+qla2x00_send_change_request(scsi_qla_host_t *ha, uint16_t format,
+			    uint16_t vp_idx)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp =3D &mc;
+
+	/*
+	 * This command is implicitly executed by firmware during login
for the
+	 * physical hosts
+	 */
+	if (vp_idx =3D=3D 0)
+		return QLA_FUNCTION_FAILED;
+
+	mcp->mb[0] =3D MBC_SEND_CHANGE_REQUEST;
+	mcp->mb[1] =3D format;
+	mcp->mb[9] =3D vp_idx;
+	mcp->out_mb =3D MBX_9|MBX_1|MBX_0;
+	mcp->in_mb =3D MBX_0|MBX_1;
+	mcp->tov =3D MBX_TOV_SECONDS;
+	mcp->flags =3D 0;
+	rval =3D qla2x00_mailbox_command(ha, mcp);
+
+	if (rval =3D=3D QLA_SUCCESS) {
+		if (mcp->mb[0] !=3D MBS_COMMAND_COMPLETE) {
+			rval =3D BIT_1;
+		}
+	} else
+		rval =3D BIT_1;
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_mid.c
b/drivers/scsi/qla2xxx/qla_mid.c
new file mode 100644
index 0000000..8e0c57b
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -0,0 +1,497 @@
+/*
+ *                  QLOGIC LINUX SOFTWARE
+ *
+ * QLogic ISP2x00 device driver for Linux 2.6.x
+ * Copyright (C) 2003-2005 QLogic Corporation
+ * (www.qlogic.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License as published by
the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+#include "qla_def.h"
+
+#include <linux/version.h>
+#include <linux/moduleparam.h>
+#include <linux/vmalloc.h>
+#include <linux/smp_lock.h>
+#include <linux/list.h>
+
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsicam.h>
+#include <linux/delay.h>
+
+void qla2x00_vp_stop_timer(scsi_qla_host_t *);
+
+void
+qla2x00_vp_stop_timer(scsi_qla_host_t *vha)
+{
+	if (vha->parent && vha->timer_active) {
+		del_timer_sync(&vha->timer);
+		vha->timer_active =3D 0;
+	}
+}
+
+uint32_t
+qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
+{
+	uint32_t vp_id;
+	scsi_qla_host_t *ha =3D vha->parent;
+
+	/* Find an empty slot and assign an vp_id */
+	down(&ha->vport_sem);
+	vp_id =3D find_first_zero_bit((unsigned long *)ha->vp_idx_map,
+				MAX_MULTI_ID_FABRIC);
+	if (vp_id > MAX_MULTI_ID_FABRIC) {
+		DEBUG15(printk ("vp_id %d is bigger than
MAX_MULTI_ID_FABRID\n",
+		    vp_id));
+		up(&ha->vport_sem);
+		return vp_id;
+	}
+
+	set_bit(vp_id, (unsigned long *)ha->vp_idx_map);
+	ha->num_vhosts++;
+	vha->vp_idx =3D vp_id;
+	list_add_tail(&vha->vp_list, &ha->vp_list);
+	up(&ha->vport_sem);
+	return vp_id;
+}
+
+void
+qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
+{
+	uint16_t vp_id;
+	scsi_qla_host_t *ha =3D vha->parent;
+
+	down(&ha->vport_sem);
+	vp_id =3D vha->vp_idx;
+	ha->num_vhosts--;
+	clear_bit(vp_id, (unsigned long *)ha->vp_idx_map);
+	list_del(&vha->vp_list);
+	up(&ha->vport_sem);
+}
+
+scsi_qla_host_t *
+qla24xx_find_vhost_by_name(scsi_qla_host_t *ha, uint8_t *port_name)
+{
+	scsi_qla_host_t *vha;
+
+	/* Locate matching device in database. */
+	list_for_each_entry(vha, &ha->vp_list, vp_list) {
+		if (!memcmp(port_name, vha->port_name, WWN_SIZE))
+			return vha;
+	}
+	return NULL;
+}
+
+/*
+ * qla2x00_mark_vp_devices_dead
+ *	Updates fcport state when device goes offline.
+ *
+ * Input:
+ *	ha =3D adapter block pointer.
+ *	fcport =3D port structure pointer.
+ *
+ * Return:
+ *	None.
+ *
+ * Context:
+ */
+void
+qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
+{
+	fc_port_t *fcport;
+	scsi_qla_host_t *pha =3D to_qla_parent(vha);
+
+	list_for_each_entry(fcport, &pha->fcports, list) {
+		if (fcport->vp_idx !=3D vha->vp_idx)
+			continue;
+
+		DEBUG15(printk("scsi(%ld): Marking port dead, "
+		    "loop_id=3D0x%04x :%x\n",
+		    vha->host_no, fcport->loop_id, fcport->vp_idx));
+
+		atomic_set(&fcport->state, FCS_DEVICE_DEAD);
+		qla2x00_mark_device_lost(vha, fcport, 0, 0);
+	}
+}
+
+int
+qla24xx_disable_vp(scsi_qla_host_t *vha)
+{
+	int ret;
+
+	ret =3D qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
+	atomic_set(&vha->loop_state, LOOP_DOWN);
+	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+
+	/* Delete all vp's fcports from parent's list */
+	qla2x00_mark_vp_devices_dead(vha);
+	atomic_set(&vha->vp_state, VP_FAILED);
+	vha->flags.management_server_logged_in =3D 0;
+	if (ret =3D=3D QLA_SUCCESS) {
+		fc_vport_set_state(vha->fc_vport, FC_VPORT_DISABLED);
+	} else {
+		fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
+		return -1;
+	}
+	return 0;
+}
+
+int
+qla24xx_enable_vp(scsi_qla_host_t *vha)
+{
+	int ret;
+	scsi_qla_host_t *ha =3D vha->parent;
+
+	/* Check if physical ha port is Up */
+	if (atomic_read(&ha->loop_state) =3D=3D LOOP_DOWN  ||
+		atomic_read(&ha->loop_state) =3D=3D LOOP_DEAD ) {
+		vha->vp_err_state =3D  VP_ERR_PORTDWN;
+		fc_vport_set_state(vha->fc_vport, FC_VPORT_LINKDOWN);
+		goto enable_failed;
+	}
+
+	/* Initialize the new vport unless it is a persistent port */
+	down(&ha->vport_sem);
+	ret =3D qla24xx_modify_vp_config(vha);
+	up(&ha->vport_sem);
+
+	if (ret !=3D QLA_SUCCESS) {
+		fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
+		goto enable_failed;
+	}
+
+	DEBUG15(qla_printk(KERN_INFO, ha,
+	    "Virtual port with id: %d - Enabled\n", vha->vp_idx));
+	return 0;
+
+enable_failed:
+	DEBUG15(qla_printk(KERN_INFO, ha,
+	    "Virtual port with id: %d - Disabled\n", vha->vp_idx));
+	return 1;
+}
+
+/**
+ * qla24xx_modify_vport() -  Modifies the virtual fabric port's
configuration
+ * @ha: HA context
+ * @vp: pointer to buffer of virtual port parameters.
+ * @ret_code: return error code:
+ *
+ * Returns the virtual port id, or MAX_VSAN_ID, if couldn't create.
+ */
+uint32_t
+qla24xx_modify_vhba(scsi_qla_host_t *ha, vport_params_t *vp, uint32_t
*vp_id)
+{
+	scsi_qla_host_t *vha;
+
+	vha =3D qla24xx_find_vhost_by_name(ha, vp->port_name);
+	if (!vha) {
+		*vp_id =3D MAX_NUM_VPORT_LOOP;
+		return VP_RET_CODE_WWPN;
+	}
+
+	if (qla24xx_enable_vp(vha)) {
+		scsi_host_put(vha->host);
+		qla2x00_mem_free(vha);
+		*vp_id =3D MAX_NUM_VPORT_LOOP;
+		return VP_RET_CODE_RESOURCES;
+	}
+
+	*vp_id =3D vha->vp_idx;
+	return VP_RET_CODE_OK;
+}
+
+void
+qla24xx_configure_vp(scsi_qla_host_t *vha)
+{
+	struct fc_vport *fc_vport;
+	int ret;
+
+	fc_vport =3D vha->fc_vport;
+
+	DEBUG15(printk("scsi(%ld): %s: change request #3 for this
host.\n",
+	    vha->host_no, __func__));
+	ret =3D qla2x00_send_change_request(vha, 0x3, vha->vp_idx);
+	if (ret !=3D QLA_SUCCESS) {
+		DEBUG15(qla_printk(KERN_ERR, vha, "Failed to enable
receiving"
+		    " of RSCN requests: 0x%x\n", ret));
+		return;
+	} else {
+		/* Corresponds to SCR enabled */
+		clear_bit(VP_SCR_NEEDED, &vha->vp_flags);
+	}
+
+	vha->flags.online =3D 1;
+	if (qla24xx_configure_vhba(vha))
+		return;
+
+	atomic_set(&vha->vp_state, VP_ACTIVE);
+	fc_vport_set_state(fc_vport, FC_VPORT_ACTIVE);
+}
+
+void
+qla2x00_alert_all_vps(scsi_qla_host_t *ha, uint16_t *mb)
+{
+	int i, vp_idx_matched;
+	scsi_qla_host_t *vha;
+
+	if (ha->parent)
+		return;
+
+	i =3D find_next_bit((unsigned long *)ha->vp_idx_map,
+	    MAX_MULTI_ID_FABRIC + 1, 1);
+	for (;i <=3D MAX_MULTI_ID_FABRIC;
+	    i =3D find_next_bit((unsigned long *)ha->vp_idx_map,
+	    MAX_MULTI_ID_FABRIC + 1, i + 1)) {
+		vp_idx_matched =3D 0;
+
+		list_for_each_entry(vha, &ha->vp_list, vp_list) {
+			if (i =3D=3D vha->vp_idx) {
+				vp_idx_matched =3D 1;
+				break;
+			}
+		}
+
+		if (vp_idx_matched) {
+			switch (mb[0]) {
+			case MBA_LIP_OCCURRED:
+			case MBA_LOOP_UP:
+			case MBA_LOOP_DOWN:
+			case MBA_LIP_RESET:
+			case MBA_POINT_TO_POINT:
+			case MBA_CHG_IN_CONNECTION:
+			case MBA_PORT_UPDATE:
+			case MBA_RSCN_UPDATE:
+				DEBUG15(printk("scsi(%ld)%s: Async_event
for"
+				    " VP[%d], mb =3D 0x%x, vha=3D%p\n",
+				    vha->host_no, __func__,i, *mb,
vha));
+				qla2x00_async_event(vha, mb);
+				break;
+			}
+		}
+	}
+}
+
+void
+qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
+{
+	/*
+	 * Physical port will do most of the abort and recovery work. We
can
+	 * just treat it as a loop down
+	 */
+	if (atomic_read(&vha->loop_state) !=3D LOOP_DOWN) {
+		atomic_set(&vha->loop_state, LOOP_DOWN);
+		qla2x00_mark_all_devices_lost(vha, 0);
+	} else {
+		if (!atomic_read(&vha->loop_down_timer))
+			atomic_set(&vha->loop_down_timer,
LOOP_DOWN_TIME);
+	}
+
+	DEBUG15(printk("scsi(%ld): Scheduling enable of Vport %d...\n",
+	    vha->host_no, vha->vp_idx));
+	qla24xx_enable_vp(vha);
+}
+
+int
+qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
+{
+	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
+		/* VP acquired. complete port configuration */
+		qla24xx_configure_vp(vha);
+		return 0;
+	}
+
+	if (test_and_clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
+		qla2x00_vp_abort_isp(vha);
+
+	if (test_and_clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags) &&
+	    (!(test_and_set_bit(RESET_ACTIVE, &vha->dpc_flags)))) {
+		clear_bit(RESET_ACTIVE, &vha->dpc_flags);
+	}
+
+	if (test_and_clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
+		if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE,
&vha->dpc_flags))) {
+			qla2x00_loop_resync(vha);
+			clear_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags);
+		}
+	}
+
+	return 0;
+}
+
+void
+qla2x00_do_dpc_all_vps(scsi_qla_host_t *ha)
+{
+	int ret;
+	int i, vp_idx_matched;
+	scsi_qla_host_t *vha;
+
+	if (ha->parent)
+		return;
+	if (list_empty(&ha->vp_list))
+		return;
+
+	clear_bit(VP_DPC_NEEDED, &ha->dpc_flags);
+
+	i =3D find_next_bit((unsigned long *)ha->vp_idx_map,
+	    MAX_MULTI_ID_FABRIC + 1, 1);
+	for (;i <=3D MAX_MULTI_ID_FABRIC;
+	    i =3D find_next_bit((unsigned long *)ha->vp_idx_map,
+	    MAX_MULTI_ID_FABRIC + 1, i + 1)) {
+		vp_idx_matched =3D 0;
+
+		list_for_each_entry(vha, &ha->vp_list, vp_list) {
+			if (i =3D=3D vha->vp_idx) {
+				vp_idx_matched =3D 1;
+				break;
+			}
+		}
+
+		if (vp_idx_matched)
+			ret =3D qla2x00_do_dpc_vp(vha);
+	}
+}
+
+int
+qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
+{
+	scsi_qla_host_t *ha =3D (scsi_qla_host_t *)
fc_vport->shost->hostdata;
+	scsi_qla_host_t *vha;
+	uint8_t port_name[WWN_SIZE];
+
+	if (fc_vport->roles !=3D FC_PORT_ROLE_FCP_INITIATOR)
+		return VPCERR_UNSUPPORTED;
+
+	/* Check up the F/W and H/W support NPIV */
+	if (!ha->flags.npiv_supported)
+		return VPCERR_UNSUPPORTED;
+
+	/* Check up whether npiv supported switch presented */
+	if (!(ha->switch_cap & FLOGI_MID_SUPPORT))
+		return VPCERR_NO_FABRIC_SUPP;
+
+	/* Check up unique WWPN */
+	u64_to_wwn(fc_vport->port_name, port_name);
+	vha =3D qla24xx_find_vhost_by_name(ha, port_name);
+	if (vha)
+		return VPCERR_BAD_WWN;
+
+	/* Check up max-npiv-supports */
+	if (ha->num_vhosts > ha->max_npiv_vports) {
+		DEBUG15(printk("scsi(%ld): num_vhosts %d is bigger than
"
+		    "max_npv_vports %d.\n", ha->host_no,
+		    (uint16_t) ha->num_vhosts, (int)
ha->max_npiv_vports));
+		return VPCERR_UNSUPPORTED;
+	}
+	return 0;
+}
+
+scsi_qla_host_t *
+qla24xx_create_vhost(struct fc_vport *fc_vport)
+{
+	scsi_qla_host_t *ha =3D (scsi_qla_host_t *)
fc_vport->shost->hostdata;
+	scsi_qla_host_t *vha;
+	struct Scsi_Host *host;
+
+	host =3D scsi_host_alloc(&qla24xx_driver_template,
+	    sizeof(scsi_qla_host_t));
+	if (!host) {
+		printk(KERN_WARNING
+		    "qla2xxx: scsi_host_alloc() failed for vport\n");
+		return(NULL);
+	}
+
+	vha =3D (scsi_qla_host_t *)host->hostdata;
+
+	/* clone the parent hba */
+	memcpy(vha, ha, sizeof (scsi_qla_host_t));
+
+	fc_vport->dd_data =3D vha;
+
+	vha->node_name =3D kmalloc(WWN_SIZE * sizeof(char), GFP_KERNEL);
+	if (!vha->node_name)
+		goto create_vhost_failed_1;
+
+	vha->port_name =3D kmalloc(WWN_SIZE * sizeof(char), GFP_KERNEL);
+	if (!vha->port_name)
+		goto create_vhost_failed_2;
+
+	/* New host info */
+	u64_to_wwn(fc_vport->node_name, vha->node_name);
+	u64_to_wwn(fc_vport->port_name, vha->port_name);
+
+	vha->host =3D host;
+	vha->host_no =3D host->host_no;
+	vha->parent =3D ha;
+	vha->fc_vport =3D fc_vport;
+	vha->device_flags =3D 0;
+	vha->instance =3D num_hosts;
+	vha->vp_idx =3D qla24xx_allocate_vp_id(vha);
+	if (vha->vp_idx > ha->max_npiv_vports) {
+		DEBUG15(printk("scsi(%ld): Couldn't allocate vp_id.\n",
+			vha->host_no));
+		goto create_vhost_failed_3;
+	}
+	vha->mgmt_svr_loop_id =3D 10 + vha->vp_idx;
+
+	init_MUTEX(&vha->mbx_cmd_sem);
+	init_MUTEX_LOCKED(&vha->mbx_intr_sem);
+
+	INIT_LIST_HEAD(&vha->list);
+	INIT_LIST_HEAD(&vha->fcports);
+	INIT_LIST_HEAD(&vha->vp_fcports);
+
+	vha->dpc_flags =3D 0L;
+	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
+	set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
+
+	/*
+	 * To fix the issue of processing a parent's RSCN for the vport
before
+	 * its SCR is complete.
+	 */
+	set_bit(VP_SCR_NEEDED, &vha->vp_flags);
+	atomic_set(&vha->loop_state, LOOP_DOWN);
+	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+
+ 	qla2x00_start_timer(vha, qla2x00_timer, WATCH_INTERVAL);
+
+	host->can_queue =3D vha->request_q_length + 128;
+	host->this_id =3D 255;
+	host->cmd_per_lun =3D 3;
+	host->max_cmd_len =3D MAX_CMDSZ;
+	host->max_channel =3D MAX_BUSES - 1;
+	host->max_lun =3D MAX_LUNS;
+	host->unique_id =3D vha->instance;
+	host->max_id =3D MAX_TARGETS_2200;
+	host->transportt =3D qla2xxx_transport_vport_template;
+
+	DEBUG15(printk("DEBUG: detect vport hba %ld at address =3D %p\n",
+	    vha->host_no, vha));
+
+	vha->flags.init_done =3D 1;
+	num_hosts++;
+
+	down(&ha->vport_sem);
+	set_bit(vha->vp_idx, (unsigned long *)ha->vp_idx_map);
+	ha->cur_vport_count++;
+	up(&ha->vport_sem);
+
+	return vha;
+
+create_vhost_failed_3:
+	kfree(vha->port_name);
+
+create_vhost_failed_2:
+	kfree(vha->node_name);
+
+create_vhost_failed_1:
+	return NULL;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c
b/drivers/scsi/qla2xxx/qla_os.c
index 18baa5b..7333ca7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -29,8 +29,7 @@ static struct kmem_cache *srb_cachep;
 /*
  * Ioctl related information.
  */
-static int num_hosts;
-
+int num_hosts;
 int ql2xlogintimeout =3D 20;
 module_param(ql2xlogintimeout, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xlogintimeout,
@@ -112,7 +111,7 @@ static int qla2x00_device_reset(scsi_qla_host_t *,
fc_port_t *);
 static int qla2x00_change_queue_depth(struct scsi_device *, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
=20
-static struct scsi_host_template qla2x00_driver_template =3D {
+struct scsi_host_template qla2x00_driver_template =3D {
 	.module			=3D THIS_MODULE,
 	.name			=3D QLA2XXX_DRIVER_NAME,
 	.queuecommand		=3D qla2x00_queuecommand,
@@ -143,7 +142,7 @@ static struct scsi_host_template
qla2x00_driver_template =3D {
 	.shost_attrs		=3D qla2x00_host_attrs,
 };
=20
-static struct scsi_host_template qla24xx_driver_template =3D {
+struct scsi_host_template qla24xx_driver_template =3D {
 	.module			=3D THIS_MODULE,
 	.name			=3D QLA2XXX_DRIVER_NAME,
 	.queuecommand		=3D qla24xx_queuecommand,
@@ -171,21 +170,21 @@ static struct scsi_host_template
qla24xx_driver_template =3D {
 };
=20
 static struct scsi_transport_template *qla2xxx_transport_template =3D
NULL;
+struct scsi_transport_template *qla2xxx_transport_vport_template =3D
NULL;
=20
 /* TODO Convert to inlines
  *
  * Timer routines
  */
-#define	WATCH_INTERVAL		1       /* number of seconds */
=20
-static void qla2x00_timer(scsi_qla_host_t *);
+void qla2x00_timer(scsi_qla_host_t *);
=20
-static __inline__ void qla2x00_start_timer(scsi_qla_host_t *,
+__inline__ void qla2x00_start_timer(scsi_qla_host_t *,
     void *, unsigned long);
 static __inline__ void qla2x00_restart_timer(scsi_qla_host_t *,
unsigned long);
-static __inline__ void qla2x00_stop_timer(scsi_qla_host_t *);
+__inline__ void qla2x00_stop_timer(scsi_qla_host_t *);
=20
-static inline void
+__inline__ void
 qla2x00_start_timer(scsi_qla_host_t *ha, void *func, unsigned long
interval)
 {
 	init_timer(&ha->timer);
@@ -202,7 +201,7 @@ qla2x00_restart_timer(scsi_qla_host_t *ha, unsigned
long interval)
 	mod_timer(&ha->timer, jiffies + interval * HZ);
 }
=20
-static __inline__ void
+__inline__ void
 qla2x00_stop_timer(scsi_qla_host_t *ha)
 {
 	del_timer_sync(&ha->timer);
@@ -213,8 +212,8 @@ static int qla2x00_do_dpc(void *data);
=20
 static void qla2x00_rst_aen(scsi_qla_host_t *);
=20
-static uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
-static void qla2x00_mem_free(scsi_qla_host_t *ha);
+uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
+void qla2x00_mem_free(scsi_qla_host_t *ha);
 static int qla2x00_allocate_sp_pool( scsi_qla_host_t *ha);
 static void qla2x00_free_sp_pool(scsi_qla_host_t *ha);
 static void qla2x00_sp_free_dma(scsi_qla_host_t *, srb_t *);
@@ -438,6 +437,7 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void
(*done)(struct scsi_cmnd *))
 	struct fc_rport *rport =3D
starget_to_rport(scsi_target(cmd->device));
 	srb_t *sp;
 	int rval;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	rval =3D fc_remote_port_chkready(rport);
 	if (rval) {
@@ -453,7 +453,7 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void
(*done)(struct scsi_cmnd *))
=20
 	if (atomic_read(&fcport->state) !=3D FCS_ONLINE) {
 		if (atomic_read(&fcport->state) =3D=3D FCS_DEVICE_DEAD ||
-		    atomic_read(&ha->loop_state) =3D=3D LOOP_DEAD) {
+		    atomic_read(&pha->loop_state) =3D=3D LOOP_DEAD) {
 			cmd->result =3D DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 		}
@@ -462,7 +462,7 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void
(*done)(struct scsi_cmnd *))
=20
 	spin_unlock_irq(ha->host->host_lock);
=20
-	sp =3D qla2x00_get_new_sp(ha, fcport, cmd, done);
+	sp =3D qla2x00_get_new_sp(pha, fcport, cmd, done);
 	if (!sp)
 		goto qc24_host_busy_lock;
=20
@@ -475,8 +475,8 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void
(*done)(struct scsi_cmnd *))
 	return 0;
=20
 qc24_host_busy_free_sp:
-	qla2x00_sp_free_dma(ha, sp);
-	mempool_free(sp, ha->srb_mempool);
+	qla2x00_sp_free_dma(pha, sp);
+	mempool_free(sp, pha->srb_mempool);
=20
 qc24_host_busy_lock:
 	spin_lock_irq(ha->host->host_lock);
@@ -548,16 +548,17 @@ qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
 {
 	int		return_status;
 	unsigned long	wait_online;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	wait_online =3D jiffies + (MAX_LOOP_TIMEOUT * HZ);
-	while (((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) ||
-	    test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) ||
-	    test_bit(ISP_ABORT_RETRY, &ha->dpc_flags) ||
-	    ha->dpc_active) && time_before(jiffies, wait_online)) {
+	while (((test_bit(ISP_ABORT_NEEDED, &pha->dpc_flags)) ||
+	    test_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags) ||
+	    test_bit(ISP_ABORT_RETRY, &pha->dpc_flags) ||
+	    pha->dpc_active) && time_before(jiffies, wait_online)) {
=20
 		msleep(1000);
 	}
-	if (ha->flags.online)
+	if (pha->flags.online)
 		return_status =3D QLA_SUCCESS;
 	else
 		return_status =3D QLA_FUNCTION_FAILED;
@@ -588,14 +589,15 @@ qla2x00_wait_for_loop_ready(scsi_qla_host_t *ha)
 {
 	int 	 return_status =3D QLA_SUCCESS;
 	unsigned long loop_timeout ;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	/* wait for 5 min at the max for loop to be ready */
 	loop_timeout =3D jiffies + (MAX_LOOP_TIMEOUT * HZ);
=20
-	while ((!atomic_read(&ha->loop_down_timer) &&
-	    atomic_read(&ha->loop_state) =3D=3D LOOP_DOWN) ||
-	    atomic_read(&ha->loop_state) !=3D LOOP_READY) {
-		if (atomic_read(&ha->loop_state) =3D=3D LOOP_DEAD) {
+	while ((!atomic_read(&pha->loop_down_timer) &&
+	    atomic_read(&pha->loop_state) =3D=3D LOOP_DOWN) ||
+	    atomic_read(&pha->loop_state) !=3D LOOP_READY) {
+		if (atomic_read(&pha->loop_state) =3D=3D LOOP_DEAD) {
 			return_status =3D QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -650,6 +652,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	unsigned long serial;
 	unsigned long flags;
 	int wait =3D 0;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	qla2x00_block_error_handler(cmd);
=20
@@ -663,9 +666,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	serial =3D cmd->serial_number;
=20
 	/* Check active list for command command. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&pha->hardware_lock, flags);
 	for (i =3D 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
-		sp =3D ha->outstanding_cmds[i];
+		sp =3D pha->outstanding_cmds[i];
=20
 		if (sp =3D=3D NULL)
 			continue;
@@ -677,7 +680,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		    __func__, ha->host_no, sp, serial));
 		DEBUG3(qla2x00_print_scsi_cmd(cmd));
=20
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock_irqrestore(&pha->hardware_lock, flags);
 		if (ha->isp_ops.abort_command(ha, sp)) {
 			DEBUG2(printk("%s(%ld): abort_command "
 			    "mbx failed.\n", __func__, ha->host_no));
@@ -686,11 +689,11 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 			    "mbx success.\n", __func__, ha->host_no));
 			wait =3D 1;
 		}
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock_irqsave(&pha->hardware_lock, flags);
=20
 		break;
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&pha->hardware_lock, flags);
=20
 	/* Wait for the command to be returned. */
 	if (wait) {
@@ -731,6 +734,7 @@
qla2x00_eh_wait_for_pending_target_commands(scsi_qla_host_t *ha,
unsigned int t)
 	srb_t		*sp;
 	struct scsi_cmnd *cmd;
 	unsigned long flags;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	status =3D 0;
=20
@@ -739,19 +743,20 @@
qla2x00_eh_wait_for_pending_target_commands(scsi_qla_host_t *ha,
unsigned int t)
 	 * array
 	 */
 	for (cnt =3D 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		sp =3D ha->outstanding_cmds[cnt];
+		spin_lock_irqsave(&pha->hardware_lock, flags);
+		sp =3D pha->outstanding_cmds[cnt];
 		if (sp) {
 			cmd =3D sp->cmd;
-			spin_unlock_irqrestore(&ha->hardware_lock,
flags);
-			if (cmd->device->id =3D=3D t) {
+			spin_unlock_irqrestore(&pha->hardware_lock,
flags);
+			if (cmd->device->id =3D=3D t &&
+			    ha->vp_idx =3D=3D sp->ha->vp_idx) {
 				if (!qla2x00_eh_wait_on_command(ha,
cmd)) {
 					status =3D 1;
 					break;
 				}
 			}
 		} else {
-			spin_unlock_irqrestore(&ha->hardware_lock,
flags);
+			spin_unlock_irqrestore(&pha->hardware_lock,
flags);
 		}
 	}
 	return (status);
@@ -782,14 +787,12 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha =3D to_qla_host(cmd->device->host);
 	fc_port_t *fcport =3D (struct fc_port *) cmd->device->hostdata;
-	int ret;
+	int ret =3D FAILED;
 	unsigned int id, lun;
 	unsigned long serial;
=20
 	qla2x00_block_error_handler(cmd);
=20
-	ret =3D FAILED;
-
 	id =3D cmd->device->id;
 	lun =3D cmd->device->lun;
 	serial =3D cmd->serial_number;
@@ -912,15 +915,14 @@ static int
 qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha =3D to_qla_host(cmd->device->host);
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
 	fc_port_t *fcport =3D (struct fc_port *) cmd->device->hostdata;
-	int ret;
+	int ret =3D FAILED;
 	unsigned int id, lun;
 	unsigned long serial;
=20
 	qla2x00_block_error_handler(cmd);
=20
-	ret =3D FAILED;
-
 	id =3D cmd->device->id;
 	lun =3D cmd->device->lun;
 	serial =3D cmd->serial_number;
@@ -944,7 +946,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 		goto eh_bus_reset_done;
=20
 	/* Flush outstanding commands. */
-	if (!qla2x00_eh_wait_for_pending_commands(ha))
+	if (!qla2x00_eh_wait_for_pending_commands(pha))
 		ret =3D FAILED;
=20
 eh_bus_reset_done:
@@ -974,14 +976,13 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha =3D to_qla_host(cmd->device->host);
 	fc_port_t *fcport =3D (struct fc_port *) cmd->device->hostdata;
-	int ret;
+	int ret =3D FAILED;
 	unsigned int id, lun;
 	unsigned long serial;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	qla2x00_block_error_handler(cmd);
=20
-	ret =3D FAILED;
-
 	id =3D cmd->device->id;
 	lun =3D cmd->device->lun;
 	serial =3D cmd->serial_number;
@@ -1004,21 +1005,24 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	 * while dpc is stuck for the mailbox to complete.
 	 */
 	qla2x00_wait_for_loop_ready(ha);
-	set_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
-	if (qla2x00_abort_isp(ha)) {
-		clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+	set_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags);
+	if (qla2x00_abort_isp(pha)) {
+		clear_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags);
 		/* failed. schedule dpc to try */
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		set_bit(ISP_ABORT_NEEDED, &pha->dpc_flags);
=20
 		if (qla2x00_wait_for_hba_online(ha) !=3D QLA_SUCCESS)
 			goto eh_host_reset_lock;
 	}
-	clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+	clear_bit(ABORT_ISP_ACTIVE, &pha->dpc_flags);
=20
 	/* Waiting for our command in done_queue to be returned to OS.*/
-	if (qla2x00_eh_wait_for_pending_commands(ha))
+	if (qla2x00_eh_wait_for_pending_commands(pha))
 		ret =3D SUCCESS;
=20
+	if (ha->parent)
+		qla2x00_vp_abort_isp(ha);
+
 eh_host_reset_lock:
 	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
 	    (ret =3D=3D FAILED) ? "failed" : "succeded");
@@ -1435,6 +1439,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const
struct pci_device_id *id)
 	ha->host =3D host;
 	ha->host_no =3D host->host_no;
 	sprintf(ha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME,
ha->host_no);
+	ha->parent =3D NULL;
=20
 	/* Set ISP-type information. */
 	qla2x00_set_isp_flags(ha);
@@ -1452,7 +1457,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const
struct pci_device_id *id)
=20
 	ha->prev_topology =3D 0;
 	ha->init_cb_size =3D sizeof(init_cb_t);
-	ha->mgmt_svr_loop_id =3D MANAGEMENT_SERVER;
+	ha->mgmt_svr_loop_id =3D MANAGEMENT_SERVER + ha->vp_idx;
 	ha->link_data_rate =3D PORT_SPEED_UNKNOWN;
 	ha->optrom_size =3D OPTROM_SIZE_2300;
=20
@@ -1524,8 +1529,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const
struct pci_device_id *id)
 		ha->request_q_length =3D REQUEST_ENTRY_CNT_24XX;
 		ha->response_q_length =3D RESPONSE_ENTRY_CNT_2300;
 		ha->last_loop_id =3D SNS_LAST_LOOP_ID_2300;
-		ha->init_cb_size =3D sizeof(struct init_cb_24xx);
-		ha->mgmt_svr_loop_id =3D 10;
+		ha->init_cb_size =3D sizeof(struct mid_init_cb_24xx);
+		ha->mgmt_svr_loop_id =3D 10 + ha->vp_idx;
 		ha->isp_ops.pci_config =3D qla24xx_pci_config;
 		ha->isp_ops.reset_chip =3D qla24xx_reset_chip;
 		ha->isp_ops.chip_diag =3D qla24xx_chip_diag;
@@ -1563,10 +1568,14 @@ qla2x00_probe_one(struct pci_dev *pdev, const
struct pci_device_id *id)
 	ha->instance =3D num_hosts;
=20
 	init_MUTEX(&ha->mbx_cmd_sem);
+	init_MUTEX(&ha->vport_sem);
 	init_MUTEX_LOCKED(&ha->mbx_intr_sem);
=20
 	INIT_LIST_HEAD(&ha->list);
 	INIT_LIST_HEAD(&ha->fcports);
+	INIT_LIST_HEAD(&ha->vp_list);
+
+	set_bit(0, (unsigned long *) ha->vp_idx_map);
=20
 	qla2x00_config_dma_addressing(ha);
 	if (qla2x00_mem_alloc(ha)) {
@@ -1789,7 +1798,8 @@ qla2x00_schedule_rport_del(struct scsi_qla_host
*ha, fc_port_t *fcport,
 void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
     int do_login, int defer)
 {
-	if (atomic_read(&fcport->state) =3D=3D FCS_ONLINE)
+	if (atomic_read(&fcport->state) =3D=3D FCS_ONLINE &&
+	    ha->vp_idx =3D=3D fcport->vp_idx)
 		qla2x00_schedule_rport_del(ha, fcport, defer);
=20
 	/*
@@ -1840,19 +1850,23 @@ void
 qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 {
 	fc_port_t *fcport;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
-	list_for_each_entry(fcport, &ha->fcports, list) {
-		if (fcport->port_type !=3D FCT_TARGET)
+	list_for_each_entry(fcport, &pha->fcports, list) {
+		if (ha->vp_idx !=3D 0 && ha->vp_idx !=3D fcport->vp_idx)
 			continue;
-
 		/*
 		 * No point in marking the device as lost, if the device
is
 		 * already DEAD.
 		 */
 		if (atomic_read(&fcport->state) =3D=3D FCS_DEVICE_DEAD)
 			continue;
-		if (atomic_read(&fcport->state) =3D=3D FCS_ONLINE)
-			qla2x00_schedule_rport_del(ha, fcport, defer);
+		if (atomic_read(&fcport->state) =3D=3D FCS_ONLINE) {
+			if (defer)
+				qla2x00_schedule_rport_del(ha, fcport,
defer);
+			else if (ha->vp_idx =3D=3D fcport->vp_idx)
+				qla2x00_schedule_rport_del(ha, fcport,
defer);
+		}
 		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
=20
@@ -1868,7 +1882,7 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha,
int defer)
 *      0  =3D success.
 *      1  =3D failure.
 */
-static uint8_t
+uint8_t
 qla2x00_mem_alloc(scsi_qla_host_t *ha)
 {
 	char	name[16];
@@ -1920,33 +1934,33 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			continue;
 		}
=20
-		snprintf(name, sizeof(name), "%s_%ld",
QLA2XXX_DRIVER_NAME,
-		    ha->host_no);
-		ha->s_dma_pool =3D dma_pool_create(name, &ha->pdev->dev,
-		    DMA_POOL_SIZE, 8, 0);
-		if (ha->s_dma_pool =3D=3D NULL) {
+		/* get consistent memory allocated for init control
block */
+		ha->init_cb =3D dma_alloc_coherent(&ha->pdev->dev,
+		    ha->init_cb_size, &ha->init_cb_dma, GFP_KERNEL);
+		if (ha->init_cb =3D=3D NULL) {
 			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - s_dma_pool\n");
+			    "Memory Allocation failed - init_cb\n");
=20
 			qla2x00_mem_free(ha);
 			msleep(100);
=20
 			continue;
 		}
+		memset(ha->init_cb, 0, ha->init_cb_size);
=20
-		/* get consistent memory allocated for init control
block */
-		ha->init_cb =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
-		    &ha->init_cb_dma);
-		if (ha->init_cb =3D=3D NULL) {
+		snprintf(name, sizeof(name), "%s_%ld",
QLA2XXX_DRIVER_NAME,
+		    ha->host_no);
+		ha->s_dma_pool =3D dma_pool_create(name, &ha->pdev->dev,
+		    DMA_POOL_SIZE, 8, 0);
+		if (ha->s_dma_pool =3D=3D NULL) {
 			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - init_cb\n");
+			    "Memory Allocation failed - s_dma_pool\n");
=20
 			qla2x00_mem_free(ha);
 			msleep(100);
=20
 			continue;
 		}
-		memset(ha->init_cb, 0, ha->init_cb_size);
=20
 		if (qla2x00_allocate_sp_pool(ha)) {
 			qla_printk(KERN_WARNING, ha,
@@ -2052,7 +2066,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 * Input:
 *      ha =3D adapter block pointer.
 */
-static void
+void
 qla2x00_mem_free(scsi_qla_host_t *ha)
 {
 	struct list_head	*fcpl, *fcptemp;
@@ -2088,12 +2102,13 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	if (ha->ms_iocb)
 		dma_pool_free(ha->s_dma_pool, ha->ms_iocb,
ha->ms_iocb_dma);
=20
-	if (ha->init_cb)
-		dma_pool_free(ha->s_dma_pool, ha->init_cb,
ha->init_cb_dma);
-
 	if (ha->s_dma_pool)
 		dma_pool_destroy(ha->s_dma_pool);
=20
+	if (ha->init_cb)
+		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,=20
+		    ha->init_cb, ha->init_cb_dma);
+
 	if (ha->gid_list)
 		dma_free_coherent(&ha->pdev->dev, GID_LIST_SIZE,
ha->gid_list,
 		    ha->gid_list_dma);
@@ -2199,6 +2214,7 @@ qla2x00_free_sp_pool( scsi_qla_host_t *ha)
 static int
 qla2x00_do_dpc(void *data)
 {
+	int		rval;
 	scsi_qla_host_t *ha;
 	fc_port_t	*fcport;
 	uint8_t		status;
@@ -2347,7 +2363,7 @@ qla2x00_do_dpc(void *data)
 			if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE,
 			    &ha->dpc_flags))) {
=20
-				qla2x00_loop_resync(ha);
+				rval =3D qla2x00_loop_resync(ha);
=20
 				clear_bit(LOOP_RESYNC_ACTIVE,
&ha->dpc_flags);
 			}
@@ -2374,6 +2390,8 @@ qla2x00_do_dpc(void *data)
 		if (test_and_clear_bit(BEACON_BLINK_NEEDED,
&ha->dpc_flags))
 			ha->isp_ops.beacon_blink(ha);
=20
+		qla2x00_do_dpc_all_vps(ha);
+
 		ha->dpc_active =3D 0;
 	} /* End of while(1) */
=20
@@ -2452,7 +2470,7 @@ qla2x00_sp_compl(scsi_qla_host_t *ha, srb_t *sp)
 *
 * Context: Interrupt
=20
************************************************************************
***/
-static void
+void
 qla2x00_timer(scsi_qla_host_t *ha)
 {
 	unsigned long	cpu_flags =3D 0;
@@ -2461,6 +2479,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	int		index;
 	srb_t		*sp;
 	int		t;
+	scsi_qla_host_t *pha =3D to_qla_parent(ha);
=20
 	/*
 	 * Ports - Port down timer.
@@ -2506,23 +2525,29 @@ qla2x00_timer(scsi_qla_host_t *ha)
 				atomic_set(&ha->loop_state, LOOP_DEAD);
=20
 			/* Schedule an ISP abort to return any tape
commands. */
-			spin_lock_irqsave(&ha->hardware_lock,
cpu_flags);
-			for (index =3D 1; index <
MAX_OUTSTANDING_COMMANDS;
-			    index++) {
-				fc_port_t *sfcp;
+			/* NPIV - scan physical port only */
+			if (!ha->parent) {
+				spin_lock_irqsave(&ha->hardware_lock,
+				    cpu_flags);
+				for (index =3D 1;
+				    index < MAX_OUTSTANDING_COMMANDS;
+				    index++) {
+					fc_port_t *sfcp;
+
+					sp =3D
ha->outstanding_cmds[index];
+					if (!sp)
+						continue;
+					sfcp =3D sp->fcport;
+					if (!(sfcp->flags &
FCF_TAPE_PRESENT))
+						continue;
=20
-				sp =3D ha->outstanding_cmds[index];
-				if (!sp)
-					continue;
-				sfcp =3D sp->fcport;
-				if (!(sfcp->flags & FCF_TAPE_PRESENT))
-					continue;
-
-				set_bit(ISP_ABORT_NEEDED,
&ha->dpc_flags);
-				break;
+					set_bit(ISP_ABORT_NEEDED,
+					    &ha->dpc_flags);
+					break;
+				}
+
spin_unlock_irqrestore(&ha->hardware_lock,
+				    cpu_flags);
 			}
-			spin_unlock_irqrestore(&ha->hardware_lock,
cpu_flags);
-
 			set_bit(ABORT_QUEUES_NEEDED, &ha->dpc_flags);
 			start_dpc++;
 		}
@@ -2566,8 +2591,9 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	    test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags) ||
 	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
 	    test_bit(BEACON_BLINK_NEEDED, &ha->dpc_flags) ||
+	    test_bit(VP_DPC_NEEDED, &ha->dpc_flags) ||
 	    test_bit(RELOGIN_NEEDED, &ha->dpc_flags)))
-		qla2xxx_wake_dpc(ha);
+		qla2xxx_wake_dpc(pha);
=20
 	qla2x00_restart_timer(ha, WATCH_INTERVAL);
 }
@@ -2711,14 +2737,24 @@ qla2x00_module_init(void)
=20
 	qla2xxx_transport_template =3D
 	    fc_attach_transport(&qla2xxx_transport_functions);
-	if (!qla2xxx_transport_template)
+	if (!qla2xxx_transport_template) {
+		kmem_cache_destroy(srb_cachep);
+		return -ENODEV;
+	}
+	qla2xxx_transport_vport_template =3D
+	    fc_attach_transport(&qla2xxx_transport_vport_functions);
+	if (!qla2xxx_transport_vport_template) {
+		kmem_cache_destroy(srb_cachep);
+		fc_release_transport(qla2xxx_transport_template);
 		return -ENODEV;
+	}
=20
 	printk(KERN_INFO "QLogic Fibre Channel HBA Driver\n");
 	ret =3D pci_register_driver(&qla2xxx_pci_driver);
 	if (ret) {
 		kmem_cache_destroy(srb_cachep);
 		fc_release_transport(qla2xxx_transport_template);
+		fc_release_transport(qla2xxx_transport_vport_template);
 	}
 	return ret;
 }
@@ -2733,6 +2769,7 @@ qla2x00_module_exit(void)
 	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
 	fc_release_transport(qla2xxx_transport_template);
+	fc_release_transport(qla2xxx_transport_vport_template);
 }
=20
 module_init(qla2x00_module_init);
--=20
1.5.2.2.603.g7c851

------_=_NextPart_001_01C7BF41.885ADD64
Content-Type: application/octet-stream;
	name="0001-qla2xxx-Add-support-for-NPIV-N-Port-ID-Virtualizat.patch"
Content-Transfer-Encoding: base64
Content-Description: 0001-qla2xxx-Add-support-for-NPIV-N-Port-ID-Virtualizat.patch
Content-Disposition: attachment;
	filename="0001-qla2xxx-Add-support-for-NPIV-N-Port-ID-Virtualizat.patch"

RnJvbSA5MzIyZjFlMThhZDFjOWY1N2Q1ZDk1NjgzY2NiYzVhYjMxNmI1MmJlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZW9rbWFubiBKdSA8c2Vva21hbm4uanVAcWxvZ2ljLmNvbT4K
RGF0ZTogVGh1LCA1IEp1bCAyMDA3IDA4OjA4OjA3IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gcWxh
Mnh4eDogQWRkIHN1cHBvcnQgZm9yIE5QSVYgKE4tUG9ydCBJRCBWaXJ0dWFsaXphdGlvbikuCgot
IHN1cHBvcnRlZCB3aXRoaW4gc3dpdGNoZWQtZmFicmljIHRvcG9sb2dpZXMgb25seS4KLSBzdXBw
b3J0cyB1cCB0byA2MyB2aXJ0dWFsIHBvcnRzIG9uIGVhY2ggcGh5c2ljYWwgcG9ydC4KClNpZ25l
ZC1vZmYtYnk6IFNlb2ttYW5uIEp1IDxzZW9rbWFubi5qdUBxbG9naWMuY29tPgotLS0KIGRyaXZl
cnMvc2NzaS9xbGEyeHh4L01ha2VmaWxlICAgfCAgICAyICstCiBkcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfYXR0ci5jIHwgIDE2NCArKysrKysrKysrKysrCiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfZGJnLmggIHwgICAxMCArLQogZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2RlZi5oICB8ICAg
ODMgKysrKysrKwogZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2Z3LmggICB8ICAgOTEgKysrKysr
LQogZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2dibC5oICB8ICAgMzkgKysrLQogZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX2dzLmMgICB8ICAgIDMgKwogZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2luaXQuYyB8ICAxNjggKysrKysrKysrKysrLS0KIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9p
b2NiLmMgfCAgIDI4ICsrLQogZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jICB8ICAgMzkg
KysrLQogZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21ieC5jICB8ICAzOTYgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrLQogZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21pZC5jICB8ICA0
OTcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiBkcml2ZXJzL3Njc2kv
cWxhMnh4eC9xbGFfb3MuYyAgIHwgIDIyOSArKysrKysrKysrKy0tLS0tLS0tCiAxMyBmaWxlcyBj
aGFuZ2VkLCAxNTk0IGluc2VydGlvbnMoKyksIDE1NSBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2Rl
IDEwMDY0NCBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbWlkLmMKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3Njc2kvcWxhMnh4eC9NYWtlZmlsZSBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L01ha2VmaWxl
CmluZGV4IDQxMTY2M2EuLjcxZGRiNWQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L01ha2VmaWxlCisrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L01ha2VmaWxlCkBAIC0xLDQgKzEs
NCBAQAogcWxhMnh4eC15IDo9IHFsYV9vcy5vIHFsYV9pbml0Lm8gcWxhX21ieC5vIHFsYV9pb2Ni
Lm8gcWxhX2lzci5vIHFsYV9ncy5vIFwKLQkJcWxhX2RiZy5vIHFsYV9zdXAubyBxbGFfYXR0ci5v
CisJCXFsYV9kYmcubyBxbGFfc3VwLm8gcWxhX2F0dHIubyBxbGFfbWlkLm8KIAogb2JqLSQoQ09O
RklHX1NDU0lfUUxBX0ZDKSArPSBxbGEyeHh4Lm8KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9x
bGEyeHh4L3FsYV9hdHRyLmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfYXR0ci5jCmluZGV4
IDgwODFiNjMuLjk1YmVlMjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9h
dHRyLmMKKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2F0dHIuYwpAQCAtNiw4ICs2LDEx
IEBACiAgKi8KICNpbmNsdWRlICJxbGFfZGVmLmgiCiAKKyNpbmNsdWRlIDxsaW51eC9rdGhyZWFk
Lmg+CiAjaW5jbHVkZSA8bGludXgvdm1hbGxvYy5oPgogCitpbnQgcWxhMjR4eF92cG9ydF9kaXNh
YmxlKHN0cnVjdCBmY192cG9ydCAqLCBib29sKTsKKwogLyogU1lTRlMgYXR0cmlidXRlcyAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi8K
IAogc3RhdGljIHNzaXplX3QKQEAgLTk1OSw2ICs5NjIsMTIyIEBAIHFsYTJ4MDBfZ2V0X2hvc3Rf
cG9ydF9zdGF0ZShzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCkKIAkJZmNfaG9zdF9wb3J0X3N0YXRl
KHNob3N0KSA9IEZDX1BPUlRTVEFURV9PTkxJTkU7CiB9CiAKK3N0YXRpYyBpbnQKK3FsYTI0eHhf
dnBvcnRfY3JlYXRlKHN0cnVjdCBmY192cG9ydCAqZmNfdnBvcnQsIGJvb2wgZGlzYWJsZSkKK3sK
KwlpbnQJcmV0ID0gMDsKKwlzY3NpX3FsYV9ob3N0X3QgKmhhID0gKHNjc2lfcWxhX2hvc3RfdCAq
KSBmY192cG9ydC0+c2hvc3QtPmhvc3RkYXRhOworCXNjc2lfcWxhX2hvc3RfdCAqdmhhOworCisJ
cmV0ID0gcWxhMjR4eF92cG9ydF9jcmVhdGVfcmVxX3Nhbml0eV9jaGVjayhmY192cG9ydCk7CisJ
aWYgKHJldCkgeworCQlERUJVRzE1KHByaW50aygicWxhMjR4eF92cG9ydF9jcmVhdGVfcmVxX3Nh
bml0eV9jaGVjayBmYWlsZWQsICIKKwkJICAgICJzdGF0dXMgJXhcbiIsIHJldCkpOworCQlyZXR1
cm4gKHJldCk7CisJfQorCisJdmhhID0gcWxhMjR4eF9jcmVhdGVfdmhvc3QoZmNfdnBvcnQpOwor
CWlmICh2aGEgPT0gTlVMTCkgeworCQlERUJVRzE1KHByaW50ayAoInFsYTI0eHhfY3JlYXRlX3Zo
b3N0IGZhaWxlZCwgdmhhID0gJXBcbiIsCisJCSAgICB2aGEpKTsKKwkJcmV0dXJuIEZDX1ZQT1JU
X0ZBSUxFRDsKKwl9CisJaWYgKGRpc2FibGUpIHsKKwkJYXRvbWljX3NldCgmdmhhLT52cF9zdGF0
ZSwgVlBfT0ZGTElORSk7CisJCWZjX3Zwb3J0X3NldF9zdGF0ZShmY192cG9ydCwgRkNfVlBPUlRf
RElTQUJMRUQpOworCX0gZWxzZQorCQlhdG9taWNfc2V0KCZ2aGEtPnZwX3N0YXRlLCBWUF9GQUlM
RUQpOworCisJLyogcmVhZHkgdG8gY3JlYXRlIHZwb3J0ICovCisJcWxhX3ByaW50ayhLRVJOX0lO
Rk8sIHZoYSwgIlZQIGVudHJ5IGlkICVkIGFzc2lnbmVkLlxuIiwgdmhhLT52cF9pZHgpOworCisJ
LyogaW5pdGlhbGl6ZWQgdnBvcnQgc3RhdGVzICovCisJYXRvbWljX3NldCgmdmhhLT5sb29wX3N0
YXRlLCBMT09QX0RPV04pOworCXZoYS0+dnBfZXJyX3N0YXRlPSAgVlBfRVJSX1BPUlREV047CisJ
dmhhLT52cF9wcmV2X2Vycl9zdGF0ZT0gIFZQX0VSUl9VTktXTjsKKwkvKiBDaGVjayBpZiBwaHlz
aWNhbCBoYSBwb3J0IGlzIFVwICovCisJaWYgKGF0b21pY19yZWFkKCZoYS0+bG9vcF9zdGF0ZSkg
PT0gTE9PUF9ET1dOIHx8CisJICAgIGF0b21pY19yZWFkKCZoYS0+bG9vcF9zdGF0ZSkgPT0gTE9P
UF9ERUFEKSB7CisJCS8qIERvbid0IHJldHJ5IG9yIGF0dGVtcHQgbG9naW4gb2YgdGhpcyB2aXJ0
dWFsIHBvcnQgKi8KKwkJREVCVUcxNShwcmludGsgKCJzY3NpKCVsZCk6IHBwb3J0IGxvb3Bfc3Rh
dGUgaXMgbm90IFVQLlxuIiwKKwkJICAgIHZoYS0+aG9zdF9ubykpOworCQlhdG9taWNfc2V0KCZ2
aGEtPmxvb3Bfc3RhdGUsIExPT1BfREVBRCk7CisJCWlmICghZGlzYWJsZSkKKwkJCWZjX3Zwb3J0
X3NldF9zdGF0ZShmY192cG9ydCwgRkNfVlBPUlRfTElOS0RPV04pOworCX0KKworCWlmIChzY3Np
X2FkZF9ob3N0KHZoYS0+aG9zdCwgJmZjX3Zwb3J0LT5kZXYpKSB7CisJCURFQlVHMTUocHJpbnRr
KCJzY3NpKCVsZCk6IHNjc2lfYWRkX2hvc3QgZmFpbHVyZSBmb3IgVlBbJWRdLlxuIiwKKwkJCXZo
YS0+aG9zdF9ubywgdmhhLT52cF9pZHgpKTsKKwkJZ290byB2cG9ydF9jcmVhdGVfZmFpbGVkXzI7
CisJfQorCisJLyogaW5pdGlhbGl6ZSBhdHRyaWJ1dGVzICovCisJZmNfaG9zdF9ub2RlX25hbWUo
dmhhLT5ob3N0KSA9IHd3bl90b191NjQodmhhLT5ub2RlX25hbWUpOworCWZjX2hvc3RfcG9ydF9u
YW1lKHZoYS0+aG9zdCkgPSB3d25fdG9fdTY0KHZoYS0+cG9ydF9uYW1lKTsKKwlmY19ob3N0X3N1
cHBvcnRlZF9jbGFzc2VzKHZoYS0+aG9zdCkgPQorCQlmY19ob3N0X3N1cHBvcnRlZF9jbGFzc2Vz
KGhhLT5ob3N0KTsKKwlmY19ob3N0X3N1cHBvcnRlZF9zcGVlZHModmhhLT5ob3N0KSA9CisJCWZj
X2hvc3Rfc3VwcG9ydGVkX3NwZWVkcyhoYS0+aG9zdCk7CisKKwlxbGEyNHh4X3Zwb3J0X2Rpc2Fi
bGUoZmNfdnBvcnQsIGRpc2FibGUpOworCisJcmV0dXJuIDA7Cit2cG9ydF9jcmVhdGVfZmFpbGVk
XzI6CisJcWxhMjR4eF9kaXNhYmxlX3ZwKHZoYSk7CisJcWxhMjR4eF9kZWFsbG9jYXRlX3ZwX2lk
KHZoYSk7CisJa2ZyZWUodmhhLT5wb3J0X25hbWUpOworCWtmcmVlKHZoYS0+bm9kZV9uYW1lKTsK
KwlzY3NpX2hvc3RfcHV0KHZoYS0+aG9zdCk7CisgICAgCXJldHVybiBGQ19WUE9SVF9GQUlMRUQ7
Cit9CisKK2ludAorcWxhMjR4eF92cG9ydF9kZWxldGUoc3RydWN0IGZjX3Zwb3J0ICpmY192cG9y
dCkKK3sKKwlzY3NpX3FsYV9ob3N0X3QgKmhhID0gKHNjc2lfcWxhX2hvc3RfdCAqKSBmY192cG9y
dC0+c2hvc3QtPmhvc3RkYXRhOworCXNjc2lfcWxhX2hvc3RfdCAqdmhhID0gZmNfdnBvcnQtPmRk
X2RhdGE7CisKKwlxbGEyNHh4X2Rpc2FibGVfdnAodmhhKTsKKwlxbGEyNHh4X2RlYWxsb2NhdGVf
dnBfaWQodmhhKTsKKworCWRvd24oJmhhLT52cG9ydF9zZW0pOworCWhhLT5jdXJfdnBvcnRfY291
bnQtLTsKKwljbGVhcl9iaXQodmhhLT52cF9pZHgsICh1bnNpZ25lZCBsb25nICopaGEtPnZwX2lk
eF9tYXApOworCXVwKCZoYS0+dnBvcnRfc2VtKTsKKworCWtmcmVlKHZoYS0+bm9kZV9uYW1lKTsK
KwlrZnJlZSh2aGEtPnBvcnRfbmFtZSk7CisKKwlpZiAodmhhLT50aW1lcl9hY3RpdmUpIHsKKwkJ
cWxhMngwMF92cF9zdG9wX3RpbWVyKHZoYSk7CisJCURFQlVHMTUocHJpbnRrICgic2NzaSglbGQp
OiB0aW1lciBmb3IgdGhlIHZwb3J0WyVkXSA9ICVwICIKKwkJICAgICJoYXMgc3RvcHBlZFxuIiwK
KwkJICAgIHZoYS0+aG9zdF9ubywgdmhhLT52cF9pZHgsIHZoYSkpOworICAgICAgICB9CisKKwlm
Y19yZW1vdmVfaG9zdCh2aGEtPmhvc3QpOworCisJc2NzaV9yZW1vdmVfaG9zdCh2aGEtPmhvc3Qp
OworCisJc2NzaV9ob3N0X3B1dCh2aGEtPmhvc3QpOworCisJcmV0dXJuIDA7Cit9CisKK2ludAor
cWxhMjR4eF92cG9ydF9kaXNhYmxlKHN0cnVjdCBmY192cG9ydCAqZmNfdnBvcnQsIGJvb2wgZGlz
YWJsZSkKK3sKKwlzY3NpX3FsYV9ob3N0X3QgKnZoYSA9IGZjX3Zwb3J0LT5kZF9kYXRhOworCisJ
aWYgKGRpc2FibGUpCisJCXFsYTI0eHhfZGlzYWJsZV92cCh2aGEpOworCWVsc2UKKwkJcWxhMjR4
eF9lbmFibGVfdnAodmhhKTsKKworCXJldHVybiAwOworfQorCiBzdHJ1Y3QgZmNfZnVuY3Rpb25f
dGVtcGxhdGUgcWxhMnh4eF90cmFuc3BvcnRfZnVuY3Rpb25zID0gewogCiAJLnNob3dfaG9zdF9u
b2RlX25hbWUgPSAxLApAQCAtOTk2LDYgKzExMTUsNDkgQEAgc3RydWN0IGZjX2Z1bmN0aW9uX3Rl
bXBsYXRlIHFsYTJ4eHhfdHJhbnNwb3J0X2Z1bmN0aW9ucyA9IHsKIAogCS5pc3N1ZV9mY19ob3N0
X2xpcCA9IHFsYTJ4MDBfaXNzdWVfbGlwLAogCS5nZXRfZmNfaG9zdF9zdGF0cyA9IHFsYTJ4MDBf
Z2V0X2ZjX2hvc3Rfc3RhdHMsCisKKwkudnBvcnRfY3JlYXRlID0gcWxhMjR4eF92cG9ydF9jcmVh
dGUsCisJLnZwb3J0X2Rpc2FibGUgPSBxbGEyNHh4X3Zwb3J0X2Rpc2FibGUsCisJLnZwb3J0X2Rl
bGV0ZSA9IHFsYTI0eHhfdnBvcnRfZGVsZXRlLAorfTsKKworc3RydWN0IGZjX2Z1bmN0aW9uX3Rl
bXBsYXRlIHFsYTJ4eHhfdHJhbnNwb3J0X3Zwb3J0X2Z1bmN0aW9ucyA9IHsKKworCS5zaG93X2hv
c3Rfbm9kZV9uYW1lID0gMSwKKwkuc2hvd19ob3N0X3BvcnRfbmFtZSA9IDEsCisJLnNob3dfaG9z
dF9zdXBwb3J0ZWRfY2xhc3NlcyA9IDEsCisKKwkuZ2V0X2hvc3RfcG9ydF9pZCA9IHFsYTJ4MDBf
Z2V0X2hvc3RfcG9ydF9pZCwKKwkuc2hvd19ob3N0X3BvcnRfaWQgPSAxLAorCS5nZXRfaG9zdF9z
cGVlZCA9IHFsYTJ4MDBfZ2V0X2hvc3Rfc3BlZWQsCisJLnNob3dfaG9zdF9zcGVlZCA9IDEsCisJ
LmdldF9ob3N0X3BvcnRfdHlwZSA9IHFsYTJ4MDBfZ2V0X2hvc3RfcG9ydF90eXBlLAorCS5zaG93
X2hvc3RfcG9ydF90eXBlID0gMSwKKwkuZ2V0X2hvc3Rfc3ltYm9saWNfbmFtZSA9IHFsYTJ4MDBf
Z2V0X2hvc3Rfc3ltYm9saWNfbmFtZSwKKwkuc2hvd19ob3N0X3N5bWJvbGljX25hbWUgPSAxLAor
CS5zZXRfaG9zdF9zeXN0ZW1faG9zdG5hbWUgPSBxbGEyeDAwX3NldF9ob3N0X3N5c3RlbV9ob3N0
bmFtZSwKKwkuc2hvd19ob3N0X3N5c3RlbV9ob3N0bmFtZSA9IDEsCisJLmdldF9ob3N0X2ZhYnJp
Y19uYW1lID0gcWxhMngwMF9nZXRfaG9zdF9mYWJyaWNfbmFtZSwKKwkuc2hvd19ob3N0X2ZhYnJp
Y19uYW1lID0gMSwKKwkuZ2V0X2hvc3RfcG9ydF9zdGF0ZSA9IHFsYTJ4MDBfZ2V0X2hvc3RfcG9y
dF9zdGF0ZSwKKwkuc2hvd19ob3N0X3BvcnRfc3RhdGUgPSAxLAorCisJLmRkX2ZjcnBvcnRfc2l6
ZSA9IHNpemVvZihzdHJ1Y3QgZmNfcG9ydCAqKSwKKwkuc2hvd19ycG9ydF9zdXBwb3J0ZWRfY2xh
c3NlcyA9IDEsCisKKwkuZ2V0X3N0YXJnZXRfbm9kZV9uYW1lID0gcWxhMngwMF9nZXRfc3Rhcmdl
dF9ub2RlX25hbWUsCisJLnNob3dfc3RhcmdldF9ub2RlX25hbWUgPSAxLAorCS5nZXRfc3Rhcmdl
dF9wb3J0X25hbWUgPSBxbGEyeDAwX2dldF9zdGFyZ2V0X3BvcnRfbmFtZSwKKwkuc2hvd19zdGFy
Z2V0X3BvcnRfbmFtZSA9IDEsCisJLmdldF9zdGFyZ2V0X3BvcnRfaWQgID0gcWxhMngwMF9nZXRf
c3RhcmdldF9wb3J0X2lkLAorCS5zaG93X3N0YXJnZXRfcG9ydF9pZCA9IDEsCisKKwkuZ2V0X3Jw
b3J0X2Rldl9sb3NzX3RtbyA9IHFsYTJ4MDBfZ2V0X3Jwb3J0X2xvc3NfdG1vLAorCS5zZXRfcnBv
cnRfZGV2X2xvc3NfdG1vID0gcWxhMngwMF9zZXRfcnBvcnRfbG9zc190bW8sCisJLnNob3dfcnBv
cnRfZGV2X2xvc3NfdG1vID0gMSwKKworCS5pc3N1ZV9mY19ob3N0X2xpcCA9IHFsYTJ4MDBfaXNz
dWVfbGlwLAorCS5nZXRfZmNfaG9zdF9zdGF0cyA9IHFsYTJ4MDBfZ2V0X2ZjX2hvc3Rfc3RhdHMs
CiB9OwogCiB2b2lkCkBAIC0xMDA0LDQgKzExNjYsNiBAQCBxbGEyeDAwX2luaXRfaG9zdF9hdHRy
KHNjc2lfcWxhX2hvc3RfdCAqaGEpCiAJZmNfaG9zdF9ub2RlX25hbWUoaGEtPmhvc3QpID0gd3du
X3RvX3U2NChoYS0+bm9kZV9uYW1lKTsKIAlmY19ob3N0X3BvcnRfbmFtZShoYS0+aG9zdCkgPSB3
d25fdG9fdTY0KGhhLT5wb3J0X25hbWUpOwogCWZjX2hvc3Rfc3VwcG9ydGVkX2NsYXNzZXMoaGEt
Pmhvc3QpID0gRkNfQ09TX0NMQVNTMzsKKwlmY19ob3N0X21heF9ucGl2X3Zwb3J0cyhoYS0+aG9z
dCkgPSBNQVhfTlVNX1ZQT1JUX0ZBQlJJQzsKKwlmY19ob3N0X25waXZfdnBvcnRzX2ludXNlKGhh
LT5ob3N0KSA9IGhhLT5jdXJfdnBvcnRfY291bnQ7CiB9CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfZGJnLmggYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZGJnLmgKaW5k
ZXggNWIxMjI3OC4uNDlkZmZlYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2RiZy5oCisrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kYmcuaApAQCAtMjEsNiArMjEs
NyBAQAogLyogI2RlZmluZSBRTF9ERUJVR19MRVZFTF8xMiAqLyAvKiBPdXRwdXQgSVAgdHJhY2Ug
bXNncyAqLwogLyogI2RlZmluZSBRTF9ERUJVR19MRVZFTF8xMyAqLyAvKiBPdXRwdXQgZmRtaSBm
dW5jdGlvbiB0cmFjZSBtc2dzICovCiAvKiAjZGVmaW5lIFFMX0RFQlVHX0xFVkVMXzE0ICovIC8q
IE91dHB1dCBSU0NOIHRyYWNlIG1zZ3MgKi8KKy8qICNkZWZpbmUgUUxfREVCVUdfTEVWRUxfMTUg
Ki8gLyogT3V0cHV0IE5QSVYgdHJhY2UgbXNncyAqLwogLyoKICAqICBMb2NhbCBNYWNybyBEZWZp
bml0aW9ucy4KICAqLwpAQCAtMzAsNyArMzEsOCBAQAogICAgIGRlZmluZWQoUUxfREVCVUdfTEVW
RUxfNykgIHx8IGRlZmluZWQoUUxfREVCVUdfTEVWRUxfOCkgfHwgXAogICAgIGRlZmluZWQoUUxf
REVCVUdfTEVWRUxfOSkgIHx8IGRlZmluZWQoUUxfREVCVUdfTEVWRUxfMTApIHx8IFwKICAgICBk
ZWZpbmVkKFFMX0RFQlVHX0xFVkVMXzExKSB8fCBkZWZpbmVkKFFMX0RFQlVHX0xFVkVMXzEyKSB8
fCBcCi0gICAgZGVmaW5lZChRTF9ERUJVR19MRVZFTF8xMykgfHwgZGVmaW5lZChRTF9ERUJVR19M
RVZFTF8xNCkKKyAgICBkZWZpbmVkKFFMX0RFQlVHX0xFVkVMXzEzKSB8fCBkZWZpbmVkKFFMX0RF
QlVHX0xFVkVMXzE0KSB8fCBcCisgICAgZGVmaW5lZChRTF9ERUJVR19MRVZFTF8xNSkKICAgICAj
ZGVmaW5lIFFMX0RFQlVHX1JPVVRJTkVTCiAjZW5kaWYKIApAQCAtMTI1LDYgKzEyNywxMiBAQAog
I2RlZmluZSBERUJVRzE0KHgpCWRvIHt9IHdoaWxlICgwKQogI2VuZGlmCiAKKyNpZiBkZWZpbmVk
KFFMX0RFQlVHX0xFVkVMXzE1KQorI2RlZmluZSBERUJVRzE1KHgpICAgICAgZG8ge3g7fSB3aGls
ZSAoMCkKKyNlbHNlCisjZGVmaW5lIERFQlVHMTUoeCkJZG8ge30gd2hpbGUgKDApCisjZW5kaWYK
KwogLyoKICAqIEZpcm13YXJlIER1bXAgc3RydWN0dXJlIGRlZmluaXRpb24KICAqLwpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2RlZi5oIGIvZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX2RlZi5oCmluZGV4IGU4OTQ4YjYuLmExY2E1OTAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV9kZWYuaAorKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZGVm
LmgKQEAgLTE1NTEsNiArMTU1MSw5IEBAIHR5cGVkZWYgc3RydWN0IGZjX3BvcnQgewogCiAJdW5z
aWduZWQgbG9uZyBsYXN0X3F1ZXVlX2Z1bGw7CiAJdW5zaWduZWQgbG9uZyBsYXN0X3JhbXBfdXA7
CisKKwlzdHJ1Y3QgbGlzdF9oZWFkIHZwX2ZjcG9ydDsKKwl1aW50MTZfdCB2cF9pZHg7CiB9IGZj
X3BvcnRfdDsKIAogLyoKQEAgLTE5OTksNiArMjAwMiwzNiBAQCBzdHJ1Y3QgZ2lkX2xpc3RfaW5m
byB7CiB9OwogI2RlZmluZSBHSURfTElTVF9TSVpFIChzaXplb2Yoc3RydWN0IGdpZF9saXN0X2lu
Zm8pICogTUFYX0ZJQlJFX0RFVklDRVMpCiAKKy8qIE5QSVYgKi8KK3R5cGVkZWYgc3RydWN0IHZw
b3J0X2luZm8geworCXVpbnQ4X3QJCXBvcnRfbmFtZVtXV05fU0laRV07CisJdWludDhfdAkJbm9k
ZV9uYW1lW1dXTl9TSVpFXTsKKwlpbnQJCXZwX2lkOworCXVpbnQxNl90CWxvb3BfaWQ7CisJdW5z
aWduZWQgbG9uZwlob3N0X25vOworCXVpbnQ4X3QJCXBvcnRfaWRbM107CisJaW50CQlsb29wX3N0
YXRlOworfSB2cG9ydF9pbmZvX3Q7CisKK3R5cGVkZWYgc3RydWN0IHZwb3J0X3BhcmFtcyB7CisJ
dWludDhfdCAJcG9ydF9uYW1lW1dXTl9TSVpFXTsKKwl1aW50OF90IAlub2RlX25hbWVbV1dOX1NJ
WkVdOworCXVpbnQzMl90IAlvcHRpb25zOworI2RlZmluZQlWUF9PUFRTX1JFVFJZX0VOQUJMRQlC
SVRfMAorI2RlZmluZQlWUF9PUFRTX1ZQX0RJU0FCTEUJQklUXzEKK30gdnBvcnRfcGFyYW1zX3Q7
CisKKy8qIE5QSVYgLSByZXR1cm4gY29kZXMgb2YgVlAgY3JlYXRlIGFuZCBtb2RpZnkgKi8KKyNk
ZWZpbmUgVlBfUkVUX0NPREVfT0sJCQkwCisjZGVmaW5lIFZQX1JFVF9DT0RFX0ZBVEFMCQkxCisj
ZGVmaW5lIFZQX1JFVF9DT0RFX1dST05HX0lECQkyCisjZGVmaW5lIFZQX1JFVF9DT0RFX1dXUE4J
CTMKKyNkZWZpbmUgVlBfUkVUX0NPREVfUkVTT1VSQ0VTCQk0CisjZGVmaW5lIFZQX1JFVF9DT0RF
X05PX01FTQkJNQorI2RlZmluZSBWUF9SRVRfQ09ERV9OT1RfRk9VTkQJCTYKKworI2RlZmluZSB0
b19xbGFfcGFyZW50KHgpICgoKHgpLT5wYXJlbnQpID8gKHgpLT5wYXJlbnQgOiAoeCkpCisKIC8q
CiAgKiBJU1Agb3BlcmF0aW9ucwogICovCkBAIC0yMDczLDYgKzIxMDYsMTYgQEAgc3RydWN0IHFs
YV9tc2l4X2VudHJ5IHsKIAl1aW50MTZfdCBtc2l4X2VudHJ5OwogfTsKIAorI2RlZmluZQlXQVRD
SF9JTlRFUlZBTAkJMSAgICAgICAvKiBudW1iZXIgb2Ygc2Vjb25kcyAqLworCisvKiBOUElWICov
CisjZGVmaW5lIE1BWF9NVUxUSV9JRF9MT09QICAgICAgICAgICAgICAgICAgICAgMTI2CisjZGVm
aW5lIE1BWF9NVUxUSV9JRF9GQUJSSUMgICAgICAgICAgICAgICAgICAgIDY0CisjZGVmaW5lIE1B
WF9OVU1fVlBPUlRfTE9PUCAgICAgICAgICAgICAgICAgICAgICAoTUFYX01VTFRJX0lEX0xPT1Ag
LSAxKQorI2RlZmluZSBNQVhfTlVNX1ZQT1JUX0ZBQlJJQyAgICAgICAgICAgICAgICAgICAgKE1B
WF9NVUxUSV9JRF9GQUJSSUMgLSAxKQorI2RlZmluZSBNQVhfTlVNX1ZIQkFfTE9PUCAgICAgICAg
ICAgICAgICAgICAgICAgKE1BWF9NVUxUSV9JRF9MT09QIC0gMSkKKyNkZWZpbmUgTUFYX05VTV9W
SEJBX0ZBQlJJQyAgICAgICAgICAgICAgICAgICAgIChNQVhfTVVMVElfSURfRkFCUklDIC0gMSkK
KwogLyoKICAqIExpbnV4IEhvc3QgQWRhcHRlciBzdHJ1Y3R1cmUKICAqLwpAQCAtMjEwOCw2ICsy
MTUxLDggQEAgdHlwZWRlZiBzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCB7CiAJCXVpbnQzMl90CW1zaXhf
ZW5hYmxlZAkJOjE7CiAJCXVpbnQzMl90CWRpc2FibGVfc2VyZGVzCQk6MTsKIAkJdWludDMyX3QJ
Z3BzY19zdXBwb3J0ZWQJCToxOworCQl1aW50MzJfdCAgICAgICAgdnNhbl9lbmFibGVkICAgICAg
ICAgICAgOjE7CisJCXVpbnQzMl90CW5waXZfc3VwcG9ydGVkCQk6MTsKIAl9IGZsYWdzOwogCiAJ
YXRvbWljX3QJbG9vcF9zdGF0ZTsKQEAgLTIxNDcsNiArMjE5Miw3IEBAIHR5cGVkZWYgc3RydWN0
IHNjc2lfcWxhX2hvc3QgewogI2RlZmluZSBCRUFDT05fQkxJTktfTkVFREVECTI1CiAjZGVmaW5l
IFJFR0lTVEVSX0ZETUlfTkVFREVECTI2CiAjZGVmaW5lIEZDUE9SVF9VUERBVEVfTkVFREVECTI3
CisjZGVmaW5lIFZQX0RQQ19ORUVERUQJCTI4CS8qIHdha2UgdXAgZm9yIFZQIGRwYyBoYW5kbGlu
ZyAqLwogCiAJdWludDMyX3QJZGV2aWNlX2ZsYWdzOwogI2RlZmluZSBERkxHX0xPQ0FMX0RFVklD
RVMJCUJJVF8wCkBAIC0yMjM3LDYgKzIyODMsMTEgQEAgdHlwZWRlZiBzdHJ1Y3Qgc2NzaV9xbGFf
aG9zdCB7CiAKIAkvKiBJU1AgY29uZmlndXJhdGlvbiBkYXRhLiAqLwogCXVpbnQxNl90CWxvb3Bf
aWQ7CQkvKiBIb3N0IGFkYXB0ZXIgbG9vcCBpZCAqLworCXVpbnQxNl90CXN3aXRjaF9jYXA7Cisj
ZGVmaW5lIEZMT0dJX1NFUV9ERUwJCUJJVF84CisjZGVmaW5lIEZMT0dJX01JRF9TVVBQT1JUCUJJ
VF8xMAorI2RlZmluZSBGTE9HSV9WU0FOX1NVUFBPUlQJQklUXzEyCisjZGVmaW5lIEZMT0dJX1NQ
X1NVUFBPUlQJQklUXzEzCiAJdWludDE2X3QJZmJfcmV2OwogCiAJcG9ydF9pZF90CWRfaWQ7CQkJ
LyogSG9zdCBhZGFwdGVyIHBvcnQgaWQgKi8KQEAgLTIzNDQsNiArMjM5NSw3IEBAIHR5cGVkZWYg
c3RydWN0IHNjc2lfcWxhX2hvc3QgewogI2RlZmluZSBNQlhfVVBEQVRFX0ZMQVNIX0FDVElWRQkz
CiAKIAlzdHJ1Y3Qgc2VtYXBob3JlIG1ieF9jbWRfc2VtOwkvKiBTZXJpYWxpYWxpemUgbWJ4IGFj
Y2VzcyAqLworCXN0cnVjdCBzZW1hcGhvcmUgdnBvcnRfc2VtOwkvKiBWaXJ0dWFsIHBvcnQgc3lu
Y2hyb25pemF0aW9uICovCiAJc3RydWN0IHNlbWFwaG9yZSBtYnhfaW50cl9zZW07ICAvKiBVc2Vk
IGZvciBjb21wbGV0aW9uIG5vdGlmaWNhdGlvbiAqLwogCiAJdWludDMyX3QJbWJ4X2ZsYWdzOwpA
QCAtMjQyOCw2ICsyNDgwLDM3IEBAIHR5cGVkZWYgc3RydWN0IHNjc2lfcWxhX2hvc3QgewogCXN0
cnVjdCBmY19ob3N0X3N0YXRpc3RpY3MgZmNfaG9zdF9zdGF0OwogCiAJc3RydWN0IHFsYV9tc2l4
X2VudHJ5IG1zaXhfZW50cmllc1tRTEFfTVNJWF9FTlRSSUVTXTsKKworCXN0cnVjdCBsaXN0X2hl
YWQJdnBfbGlzdDsJLyogbGlzdCBvZiBWUCAqLworCXN0cnVjdCBmY192cG9ydAkqZmNfdnBvcnQ7
CS8qIGhvbGRzIGZjX3Zwb3J0ICogZm9yIGVhY2ggdnBvcnQgKi8KKwl1aW50OF90CQl2cF9pZHhf
bWFwWzE2XTsKKwl1aW50MTZfdCAgICAgICAgbnVtX3Zob3N0czsJLyogbnVtYmVyIG9mIHZwb3J0
cyBjcmVhdGVkICovCisJdWludDE2X3QgICAgICAgIG51bV92c2FuczsJLyogbnVtYmVyIG9mIHZz
YW4gY3JlYXRlZCAqLworCXVpbnQxNl90ICAgICAgICB2cF9pZHg7CQkvKiB2cG9ydCBJRCAqLwor
CisJc3RydWN0IHNjc2lfcWxhX2hvc3QJKnBhcmVudDsJLyogaG9sZHMgcHBvcnQgKi8KKwl1bnNp
Z25lZCBsb25nCQl2cF9mbGFnczsKKwlzdHJ1Y3QgbGlzdF9oZWFkCXZwX2ZjcG9ydHM7CS8qIGxp
c3Qgb2YgZmNwb3J0cyAqLworI2RlZmluZSBWUF9JRFhfQUNRVUlSRUQJCTAJLyogYml0IG5vIDAg
Ki8KKyNkZWZpbmUgVlBfQ1JFQVRFX05FRURFRAkxCisjZGVmaW5lIFZQX0JJTkRfTkVFREVECQky
CisjZGVmaW5lIFZQX0RFTEVURV9ORUVERUQJMworI2RlZmluZSBWUF9TQ1JfTkVFREVECQk0CS8q
IFN0YXRlIENoYW5nZSBSZXF1ZXN0IHJlZ2lzdHJhdGlvbiAqLworCWF0b21pY190IAkJdnBfc3Rh
dGU7CisjZGVmaW5lIFZQX09GRkxJTkUJCTAKKyNkZWZpbmUgVlBfQUNUSVZFCQkxCisjZGVmaW5l
IFZQX0ZBSUxFRAkJMgorLy8gI2RlZmluZSBWUF9ESVNBQkxFCQkzCisJdWludDE2X3QgCXZwX2Vy
cl9zdGF0ZTsKKwl1aW50MTZfdAl2cF9wcmV2X2Vycl9zdGF0ZTsKKyNkZWZpbmUgVlBfRVJSX1VO
S1dOCQkwCisjZGVmaW5lIFZQX0VSUl9QT1JURFdOCQkxCisjZGVmaW5lIFZQX0VSUl9GQUJfVU5T
VVBQT1JURUQJMgorI2RlZmluZSBWUF9FUlJfRkFCX05PUkVTT1VSQ0VTCTMKKyNkZWZpbmUgVlBf
RVJSX0ZBQl9MT0dPVVQJNAorI2RlZmluZSBWUF9FUlJfQURBUF9OT1JFU09VUkNFUwk1CisJaW50
CQltYXhfbnBpdl92cG9ydHM7CS8qIDYzIG9yIDEyNSBwZXIgdG9wb2xvdHkgKi8KKwlpbnQJCWN1
cl92cG9ydF9jb3VudDsKIH0gc2NzaV9xbGFfaG9zdF90OwogCiAKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9mdy5oIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2Z3LmgK
aW5kZXggYTBhNzIyYy4uNjNhMTFmZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2Z3LmgKKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2Z3LmgKQEAgLTY5LDYgKzY5
LDE2IEBAIHN0cnVjdCBwb3J0X2RhdGFiYXNlXzI0eHggewogCXVpbnQ4X3QgcmVzZXJ2ZWRfM1sy
NF07CiB9OwogCitzdHJ1Y3QgdnBfZGF0YWJhc2VfMjR4eCB7CisJdWludDE2X3QgdnBfc3RhdHVz
OworCXVpbnQ4X3QgIG9wdGlvbnM7CisJdWludDhfdCAgaWQ7CisJdWludDhfdCAgcG9ydF9uYW1l
W1dXTl9TSVpFXTsKKwl1aW50OF90ICBub2RlX25hbWVbV1dOX1NJWkVdOworCXVpbnQxNl90IHBv
cnRfaWRfbG93OworCXVpbnQxNl90IHBvcnRfaWRfaGlnaDsKK307CisKIHN0cnVjdCBudnJhbV8y
NHh4IHsKIAkvKiBOVlJBTSBoZWFkZXIuICovCiAJdWludDhfdCBpZFs0XTsKQEAgLTk2Miw2ICs5
NzIsMjUgQEAgc3RydWN0IG1pZF9kYl8yNHh4IHsKIAlzdHJ1Y3QgbWlkX2RiX2VudHJ5XzI0eHgg
ZW50cmllc1tNQVhfTUlEX1ZQU107CiB9OwogCisgLyoKKyAqIFZpcnR1YWwgRmFicmljIElEIHR5
cGUgZGVmaW5pdGlvbi4KKyAqLwordHlwZWRlZiBzdHJ1Y3QgdmZfaWQgeworICAgICAgICB1aW50
MTZfdCBpZCA6IDEyOworICAgICAgICB1aW50MTZfdCBwcmlvcml0eSA6IDQ7Cit9IHZmX2lkX3Q7
CisKKy8qCisgKiBWaXJ0dWFsIEZhYnJpYyBIb3BDdCB0eXBlIGRlZmluaXRpb24uCisgKi8KK3R5
cGVkZWYgc3RydWN0IHZmX2hvcGN0IHsKKyAgICAgICAgdWludDE2X3QgcmVzZXJ2ZWQgOiA4Owor
ICAgICAgICB1aW50MTZfdCBob3BjdCA6IDg7Cit9IHZmX2hvcGN0X3Q7CisKKy8qCisgKiBWaXJ0
dWFsIFBvcnQgQ29udHJvbCBJT0NCCisgKi8KICNkZWZpbmUgVlBfQ1RSTF9JT0NCX1RZUEUJMHgz
MAkvKiBWaXR1YWwgUG9ydCBDb250cm9sIGVudHJ5LiAqLwogc3RydWN0IHZwX2N0cmxfZW50cnlf
MjR4eCB7CiAJdWludDhfdCBlbnRyeV90eXBlOwkJLyogRW50cnkgdHlwZS4gKi8KQEAgLTk3NCw2
ICsxMDAzLDcgQEAgc3RydWN0IHZwX2N0cmxfZW50cnlfMjR4eCB7CiAJdWludDE2X3QgdnBfaWR4
X2ZhaWxlZDsKIAogCXVpbnQxNl90IGNvbXBfc3RhdHVzOwkJLyogQ29tcGxldGlvbiBzdGF0dXMu
ICovCisjZGVmaW5lIENTX1ZDRV9JT0NCX0VSUk9SICAgICAgIDB4MDEgICAgLyogRXJyb3IgcHJv
Y2Vzc2luZyBJT0NCICovCiAjZGVmaW5lIENTX1ZDRV9BQ1FfSURfRVJST1IJMHgwMgkvKiBFcnJv
ciB3aGlsZSBhY3F1aXJlaW5nIElELiAqLwogI2RlZmluZSBDU19WQ0VfQlVTWQkJMHgwNQkvKiBG
aXJtd2FyZSBub3QgcmVhZHkgdG8gYWNjZXB0IGNtZC4gKi8KIApAQCAtOTgyLDI0ICsxMDEyLDM0
IEBAIHN0cnVjdCB2cF9jdHJsX2VudHJ5XzI0eHggewogI2RlZmluZSBWQ0VfQ09NTUFORF9ESVNB
QkxFX1ZQUwkweDA4CS8qIERpc2FibGUgVlBzLiAqLwogI2RlZmluZSBWQ0VfQ09NTUFORF9ESVNB
QkxFX1ZQU19SRUlOSVQJMHgwOSAvKiBEaXNhYmxlIFZQcyBhbmQgcmVpbml0IGxpbmsuICovCiAj
ZGVmaW5lIFZDRV9DT01NQU5EX0RJU0FCTEVfVlBTX0xPR08JMHgwYSAvKiBEaXNhYmxlIFZQcyBh
bmQgTE9HTyBwb3J0cy4gKi8KKyNkZWZpbmUgVkNFX0NPTU1BTkRfRElTQUJMRV9WUFNfTE9HT19B
TEwgICAgICAgIDB4MGIgLyogRGlzYWJsZSBWUHMgYW5kIExPR08gcG9ydHMuICovCiAKIAl1aW50
MTZfdCB2cF9jb3VudDsKIAogCXVpbnQ4X3QgdnBfaWR4X21hcFsxNl07Ci0KLQl1aW50OF90IHJl
c2VydmVkXzRbMzJdOworCXVpbnQxNl90IGZsYWdzOworCXN0cnVjdCB2Zl9pZCAgICBpZDsKKwl1
aW50MTZfdCByZXNlcnZlZF80OworCXN0cnVjdCB2Zl9ob3BjdCAgaG9wY3Q7CisJdWludDhfdCBy
ZXNlcnZlZF81WzhdOwogfTsKIAorLyoKKyAqIE1vZGlmeSBWaXJ0dWFsIFBvcnQgQ29uZmlndXJh
dGlvbiBJT0NCCisgKi8KICNkZWZpbmUgVlBfQ09ORklHX0lPQ0JfVFlQRQkweDMxCS8qIFZpdHVh
bCBQb3J0IENvbmZpZyBlbnRyeS4gKi8KIHN0cnVjdCB2cF9jb25maWdfZW50cnlfMjR4eCB7CiAJ
dWludDhfdCBlbnRyeV90eXBlOwkJLyogRW50cnkgdHlwZS4gKi8KIAl1aW50OF90IGVudHJ5X2Nv
dW50OwkJLyogRW50cnkgY291bnQuICovCi0JdWludDhfdCBzeXNfZGVmaW5lOwkJLyogU3lzdGVt
IGRlZmluZWQuICovCisJdWludDhfdCBoYW5kbGVfY291bnQ7CiAJdWludDhfdCBlbnRyeV9zdGF0
dXM7CQkvKiBFbnRyeSBTdGF0dXMuICovCiAKIAl1aW50MzJfdCBoYW5kbGU7CQkvKiBTeXN0ZW0g
aGFuZGxlLiAqLwogCi0JdWludDE2X3QgcmVzZXJ2ZWRfMTsKKwl1aW50MTZfdCBmbGFnczsKKyNk
ZWZpbmUgQ1NfVkZfQklORF9WUE9SVFNfVE9fVkYgICAgICAgICBCSVRfMAorI2RlZmluZSBDU19W
Rl9TRVRfUU9TX09GX1ZQT1JUUyAgICAgICAgIEJJVF8xCisjZGVmaW5lIENTX1ZGX1NFVF9IT1BT
X09GX1ZQT1JUUyAgICAgICAgQklUXzIKIAogCXVpbnQxNl90IGNvbXBfc3RhdHVzOwkJLyogQ29t
cGxldGlvbiBzdGF0dXMuICovCiAjZGVmaW5lIENTX1ZDVF9TVFNfRVJST1IJMHgwMQkvKiBTcGVj
aWZpZWQgVlBzIHdlcmUgbm90IGRpc2FibGVkLiAqLwpAQCAtMTAwOSwyNyArMTA0OSwyOSBAQCBz
dHJ1Y3QgdnBfY29uZmlnX2VudHJ5XzI0eHggewogI2RlZmluZSBDU19WQ1RfQlVTWQkJMHgwNQkv
KiBGaXJtd2FyZSBub3QgcmVhZHkgdG8gYWNjZXB0IGNtZC4gKi8KIAogCXVpbnQ4X3QgY29tbWFu
ZDsKLSNkZWZpbmUgVkNUX0NPTU1BTkRfTU9EX1ZQUwkweDAwCS8qIEVuYWJsZSBWUHMuICovCi0j
ZGVmaW5lIFZDVF9DT01NQU5EX01PRF9FTkFCTEVfVlBTIDB4MDgJLyogRGlzYWJsZSBWUHMuICov
CisjZGVmaW5lIFZDVF9DT01NQU5EX01PRF9WUFMgICAgIDB4MDAgICAgLyogTW9kaWZ5IFZQIGNv
bmZpZ3VyYXRpb25zLiAqLworI2RlZmluZSBWQ1RfQ09NTUFORF9NT0RfRU5BQkxFX1ZQUyAweDAx
IC8qIE1vZGlmeSBjb25maWd1cmF0aW9uICYgZW5hYmxlIFZQcy4gKi8KIAogCXVpbnQ4X3QgdnBf
Y291bnQ7CiAKLQl1aW50OF90IHZwX2lkeDE7Ci0JdWludDhfdCB2cF9pZHgyOworCXVpbnQ4X3Qg
dnBfaW5kZXgxOworCXVpbnQ4X3QgdnBfaW5kZXgyOwogCiAJdWludDhfdCBvcHRpb25zX2lkeDE7
CiAJdWludDhfdCBoYXJkX2FkZHJlc3NfaWR4MTsKLQl1aW50MTZfdCByZXNlcnZlZF8yOworCXVp
bnQxNl90IHJlc2VydmVkX3ZwMTsKIAl1aW50OF90IHBvcnRfbmFtZV9pZHgxW1dXTl9TSVpFXTsK
IAl1aW50OF90IG5vZGVfbmFtZV9pZHgxW1dXTl9TSVpFXTsKIAogCXVpbnQ4X3Qgb3B0aW9uc19p
ZHgyOwogCXVpbnQ4X3QgaGFyZF9hZGRyZXNzX2lkeDI7Ci0JdWludDE2X3QgcmVzZXJ2ZWRfMzsK
Kwl1aW50MTZfdCByZXNlcnZlZF92cDI7CiAJdWludDhfdCBwb3J0X25hbWVfaWR4MltXV05fU0la
RV07CiAJdWludDhfdCBub2RlX25hbWVfaWR4MltXV05fU0laRV07Ci0KLQl1aW50OF90IHJlc2Vy
dmVkXzRbOF07CisJc3RydWN0IHZmX2lkICAgIGlkOworCXVpbnQxNl90IHJlc2VydmVkXzQ7CisJ
c3RydWN0IHZmX2hvcGN0ICBob3BjdDsKKwl1aW50OF90IHJlc2VydmVkXzU7CiB9OwogCiAjZGVm
aW5lIFZQX1JQVF9JRF9JT0NCX1RZUEUJMHgzMgkvKiBSZXBvcnQgSUQgQWNxdWlzaXRpb24gZW50
cnkuICovCkBAIC0xMDU0LDUgKzEwOTYsMzAgQEAgc3RydWN0IHZwX3JwdF9pZF9lbnRyeV8yNHh4
IHsKIAl1aW50OF90IHJlc2VydmVkXzRbMzJdOwogfTsKIAorI2RlZmluZSBWRl9FVkZQX0lPQ0Jf
VFlQRSAgICAgICAweDI2ICAgIC8qIEV4Y2hhbmdlIFZpcnR1YWwgRmFicmljIFBhcmFtZXRlcnMg
ZW50cnkuICovCitzdHJ1Y3QgdmZfZXZmcF9lbnRyeV8yNHh4IHsKKyAgICAgICAgdWludDhfdCBl
bnRyeV90eXBlOyAgICAgICAgICAgICAvKiBFbnRyeSB0eXBlLiAqLworICAgICAgICB1aW50OF90
IGVudHJ5X2NvdW50OyAgICAgICAgICAgIC8qIEVudHJ5IGNvdW50LiAqLworICAgICAgICB1aW50
OF90IHN5c19kZWZpbmU7ICAgICAgICAgICAgIC8qIFN5c3RlbSBkZWZpbmVkLiAqLworICAgICAg
ICB1aW50OF90IGVudHJ5X3N0YXR1czsgICAgICAgICAgIC8qIEVudHJ5IFN0YXR1cy4gKi8KKwor
ICAgICAgICB1aW50MzJfdCBoYW5kbGU7ICAgICAgICAgICAgICAgIC8qIFN5c3RlbSBoYW5kbGUu
ICovCisgICAgICAgIHVpbnQxNl90IGNvbXBfc3RhdHVzOyAgICAgICAgICAgLyogQ29tcGxldGlv
biBzdGF0dXMuICovCisgICAgICAgIHVpbnQxNl90IHRpbWVvdXQ7ICAgICAgICAgICAgICAgLyog
dGltZW91dCAqLworICAgICAgICB1aW50MTZfdCBhZGltX3RhZ2dpbmdfbW9kZTsKKworICAgICAg
ICB1aW50MTZfdCB2ZnBvcnRfaWQ7CisgICAgICAgIHVpbnQzMl90IGV4Y2hfYWRkcjsKKworICAg
ICAgICB1aW50MTZfdCBucG9ydF9oYW5kbGU7ICAgICAgICAgIC8qIE5fUE9SVCBoYW5kbGUuICov
CisgICAgICAgIHVpbnQxNl90IGNvbnRyb2xfZmxhZ3M7CisgICAgICAgIHVpbnQzMl90IGlvX3Bh
cmFtZXRlcl8wOworICAgICAgICB1aW50MzJfdCBpb19wYXJhbWV0ZXJfMTsKKyAgICAgICAgdWlu
dDMyX3QgdHhfYWRkcmVzc1syXTsgICAgICAgICAvKiBEYXRhIHNlZ21lbnQgMCBhZGRyZXNzLiAq
LworICAgICAgICB1aW50MzJfdCB0eF9sZW47ICAgICAgICAgICAgICAgIC8qIERhdGEgc2VnbWVu
dCAwIGxlbmd0aC4gKi8KKyAgICAgICAgdWludDMyX3QgcnhfYWRkcmVzc1syXTsgICAgICAgICAv
KiBEYXRhIHNlZ21lbnQgMSBhZGRyZXNzLiAqLworICAgICAgICB1aW50MzJfdCByeF9sZW47ICAg
ICAgICAgICAgICAgIC8qIERhdGEgc2VnbWVudCAxIGxlbmd0aC4gKi8KK307CisKIC8qIEVORCBN
SUQgU3VwcG9ydCAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKi8KICNlbmRpZgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2dibC5oIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2dibC5oCmluZGV4IDc0NTQ0YWUu
LmI0NGVmZjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9nYmwuaAorKysg
Yi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZ2JsLmgKQEAgLTYyLDYgKzYyLDM4IEBAIGV4dGVy
biBpbnQgcWwyeGZkbWllbmFibGU7CiBleHRlcm4gaW50IHFsMnhhbGxvY2Z3ZHVtcDsKIGV4dGVy
biBpbnQgcWwyeGV4dGVuZGVkX2Vycm9yX2xvZ2dpbmc7CiBleHRlcm4gaW50IHFsMnhxZnVsbHJh
bXB1cDsKK2V4dGVybiBpbnQgbnVtX2hvc3RzOworCisvKgorICogR2xvYmFsIEZ1bmN0aW9ucyBp
biBxbGFfbWlkLmMgc291cmNlIGZpbGUuCisgKi8KK2V4dGVybiBzdHJ1Y3Qgc2NzaV9ob3N0X3Rl
bXBsYXRlIHFsYTJ4MDBfZHJpdmVyX3RlbXBsYXRlOworZXh0ZXJuIHN0cnVjdCBzY3NpX2hvc3Rf
dGVtcGxhdGUgcWxhMjR4eF9kcml2ZXJfdGVtcGxhdGU7CitleHRlcm4gc3RydWN0IHNjc2lfdHJh
bnNwb3J0X3RlbXBsYXRlICpxbGEyeHh4X3RyYW5zcG9ydF92cG9ydF90ZW1wbGF0ZTsKK2V4dGVy
biB1aW50OF90IHFsYTJ4MDBfbWVtX2FsbG9jKHNjc2lfcWxhX2hvc3RfdCAqKTsKK2V4dGVybiB2
b2lkIHFsYTJ4MDBfdGltZXIoc2NzaV9xbGFfaG9zdF90ICopOworZXh0ZXJuIHZvaWQgcWxhMngw
MF9zdGFydF90aW1lcihzY3NpX3FsYV9ob3N0X3QgKiwgdm9pZCAqLCB1bnNpZ25lZCBsb25nKTsK
K2V4dGVybiB2b2lkIHFsYTJ4MDBfc3RvcF90aW1lcihzY3NpX3FsYV9ob3N0X3QgKik7CitleHRl
cm4gdWludDMyX3QgcWxhMjR4eF9hbGxvY2F0ZV92cF9pZChzY3NpX3FsYV9ob3N0X3QgKik7Citl
eHRlcm4gdm9pZCBxbGEyNHh4X2RlYWxsb2NhdGVfdnBfaWQoc2NzaV9xbGFfaG9zdF90ICopOwor
ZXh0ZXJuIGludCBxbGEyNHh4X2Rpc2FibGVfdnAgKHNjc2lfcWxhX2hvc3RfdCAqKTsKK2V4dGVy
biBpbnQgcWxhMjR4eF9lbmFibGVfdnAgKHNjc2lfcWxhX2hvc3RfdCAqKTsKK2V4dGVybiB2b2lk
IHFsYTJ4MDBfbWVtX2ZyZWUoc2NzaV9xbGFfaG9zdF90ICopOworZXh0ZXJuIGludCBxbGEyNHh4
X2NvbnRyb2xfdnAoc2NzaV9xbGFfaG9zdF90ICosIGludCApOworZXh0ZXJuIGludCBxbGEyNHh4
X21vZGlmeV92cF9jb25maWcoc2NzaV9xbGFfaG9zdF90ICopOworZXh0ZXJuIGludCBxbGEyeDAw
X3NlbmRfY2hhbmdlX3JlcXVlc3Qoc2NzaV9xbGFfaG9zdF90ICosIHVpbnQxNl90LCB1aW50MTZf
dCk7CitleHRlcm4gdm9pZCBxbGEyeDAwX3ZwX3N0b3BfdGltZXIoc2NzaV9xbGFfaG9zdF90ICop
OworZXh0ZXJuIGludCBxbGEyNHh4X2NvbmZpZ3VyZV92aGJhIChzY3NpX3FsYV9ob3N0X3QgKik7
CitleHRlcm4gaW50IHFsYTI0eHhfZ2V0X3ZwX2VudHJ5KHNjc2lfcWxhX2hvc3RfdCAqLCB1aW50
MTZfdCwgaW50KTsKK2V4dGVybiBpbnQgcWxhMjR4eF9nZXRfdnBfZGF0YWJhc2Uoc2NzaV9xbGFf
aG9zdF90ICosIHVpbnQxNl90KTsKK2V4dGVybiBpbnQgcWxhMngwMF9kb19kcGNfdnAoc2NzaV9x
bGFfaG9zdF90ICopOworZXh0ZXJuIHZvaWQgcWxhMjR4eF9yZXBvcnRfaWRfYWNxdWlzaXRpb24o
c2NzaV9xbGFfaG9zdF90ICosCisgICAgc3RydWN0IHZwX3JwdF9pZF9lbnRyeV8yNHh4ICopOwor
ZXh0ZXJuIHNjc2lfcWxhX2hvc3RfdCAqIHFsYTI0eHhfZmluZF92aG9zdF9ieV9uYW1lKHNjc2lf
cWxhX2hvc3RfdCAqLAorICAgIHVpbnQ4X3QgKik7CitleHRlcm4gdm9pZCBxbGEyeDAwX2RvX2Rw
Y19hbGxfdnBzKHNjc2lfcWxhX2hvc3RfdCAqKTsKK2V4dGVybiBpbnQgcWxhMjR4eF92cG9ydF9j
cmVhdGVfcmVxX3Nhbml0eV9jaGVjayhzdHJ1Y3QgZmNfdnBvcnQgKik7CitleHRlcm4gc2NzaV9x
bGFfaG9zdF90ICogcWxhMjR4eF9jcmVhdGVfdmhvc3Qoc3RydWN0IGZjX3Zwb3J0ICopOwogCiBl
eHRlcm4gdm9pZCBxbGEyeDAwX3NwX2NvbXBsKHNjc2lfcWxhX2hvc3RfdCAqLCBzcmJfdCAqKTsK
IApAQCAtNzcsNiArMTA5LDEwIEBAIGV4dGVybiBzdHJ1Y3QgZndfYmxvYiAqcWxhMngwMF9yZXF1
ZXN0X2Zpcm13YXJlKHNjc2lfcWxhX2hvc3RfdCAqKTsKIGV4dGVybiBpbnQgcWxhMngwMF93YWl0
X2Zvcl9oYmFfb25saW5lKHNjc2lfcWxhX2hvc3RfdCAqKTsKIAogZXh0ZXJuIHZvaWQgcWxhMnh4
eF93YWtlX2RwYyhzY3NpX3FsYV9ob3N0X3QgKik7CitleHRlcm4gdm9pZCBxbGEyeDAwX2FsZXJ0
X2FsbF92cHMoc2NzaV9xbGFfaG9zdF90ICosIHVpbnQxNl90ICopOworZXh0ZXJuIHZvaWQgcWxh
MngwMF9hc3luY19ldmVudChzY3NpX3FsYV9ob3N0X3QgKiwgdWludDE2X3QgKik7CitleHRlcm4g
dm9pZCBxbGEyeDAwX3ZwX2Fib3J0X2lzcChzY3NpX3FsYV9ob3N0X3QgKik7CitleHRlcm4gaW50
IHFsYTI0eHhfdnBvcnRfZGVsZXRlKHN0cnVjdCBmY192cG9ydCAqKTsKIAogLyoKICAqIEdsb2Jh
bCBGdW5jdGlvbiBQcm90b3R5cGVzIGluIHFsYV9pb2NiLmMgc291cmNlIGZpbGUuCkBAIC0xMjgs
NyArMTY0LDcgQEAgcWxhMngwMF9hYm9ydF90YXJnZXQoZmNfcG9ydF90ICopOwogCiBleHRlcm4g
aW50CiBxbGEyeDAwX2dldF9hZGFwdGVyX2lkKHNjc2lfcWxhX2hvc3RfdCAqLCB1aW50MTZfdCAq
LCB1aW50OF90ICosIHVpbnQ4X3QgKiwKLSAgICB1aW50OF90ICosIHVpbnQxNl90ICopOworICAg
IHVpbnQ4X3QgKiwgdWludDE2X3QgKiwgdWludDE2X3QgKik7CiAKIGV4dGVybiBpbnQKIHFsYTJ4
MDBfZ2V0X3JldHJ5X2NudChzY3NpX3FsYV9ob3N0X3QgKiwgdWludDhfdCAqLCB1aW50OF90ICos
IHVpbnQxNl90ICopOwpAQCAtMzAzLDYgKzMzOSw3IEBAIHN0cnVjdCBjbGFzc19kZXZpY2VfYXR0
cmlidXRlOwogZXh0ZXJuIHN0cnVjdCBjbGFzc19kZXZpY2VfYXR0cmlidXRlICpxbGEyeDAwX2hv
c3RfYXR0cnNbXTsKIHN0cnVjdCBmY19mdW5jdGlvbl90ZW1wbGF0ZTsKIGV4dGVybiBzdHJ1Y3Qg
ZmNfZnVuY3Rpb25fdGVtcGxhdGUgcWxhMnh4eF90cmFuc3BvcnRfZnVuY3Rpb25zOworZXh0ZXJu
IHN0cnVjdCBmY19mdW5jdGlvbl90ZW1wbGF0ZSBxbGEyeHh4X3RyYW5zcG9ydF92cG9ydF9mdW5j
dGlvbnM7CiBleHRlcm4gdm9pZCBxbGEyeDAwX2FsbG9jX3N5c2ZzX2F0dHIoc2NzaV9xbGFfaG9z
dF90ICopOwogZXh0ZXJuIHZvaWQgcWxhMngwMF9mcmVlX3N5c2ZzX2F0dHIoc2NzaV9xbGFfaG9z
dF90ICopOwogZXh0ZXJuIHZvaWQgcWxhMngwMF9pbml0X2hvc3RfYXR0cihzY3NpX3FsYV9ob3N0
X3QgKik7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZ3MuYyBiL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9ncy5jCmluZGV4IGVjNWIyZGQuLmEwODZiM2YgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9ncy5jCisrKyBiL2RyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9ncy5jCkBAIC04OCw2ICs4OCw3IEBAIHFsYTI0eHhfcHJlcF9tc19pb2NiKHNjc2lf
cWxhX2hvc3RfdCAqaGEsIHVpbnQzMl90IHJlcV9zaXplLCB1aW50MzJfdCByc3Bfc2l6ZSkKIAlj
dF9wa3QtPmRzZWdfMV9hZGRyZXNzWzBdID0gY3B1X3RvX2xlMzIoTFNEKGhhLT5jdF9zbnNfZG1h
KSk7CiAJY3RfcGt0LT5kc2VnXzFfYWRkcmVzc1sxXSA9IGNwdV90b19sZTMyKE1TRChoYS0+Y3Rf
c25zX2RtYSkpOwogCWN0X3BrdC0+ZHNlZ18xX2xlbiA9IGN0X3BrdC0+cnNwX2J5dGVfY291bnQ7
CisJY3RfcGt0LT52cF9pbmRleCA9IGhhLT52cF9pZHg7CiAKIAlyZXR1cm4gKGN0X3BrdCk7CiB9
CkBAIC0xMTg2LDYgKzExODcsNyBAQCBxbGEyNHh4X3ByZXBfbXNfZmRtaV9pb2NiKHNjc2lfcWxh
X2hvc3RfdCAqaGEsIHVpbnQzMl90IHJlcV9zaXplLAogCWN0X3BrdC0+ZHNlZ18xX2FkZHJlc3Nb
MF0gPSBjcHVfdG9fbGUzMihMU0QoaGEtPmN0X3Nuc19kbWEpKTsKIAljdF9wa3QtPmRzZWdfMV9h
ZGRyZXNzWzFdID0gY3B1X3RvX2xlMzIoTVNEKGhhLT5jdF9zbnNfZG1hKSk7CiAJY3RfcGt0LT5k
c2VnXzFfbGVuID0gY3RfcGt0LT5yc3BfYnl0ZV9jb3VudDsKKwljdF9wa3QtPnZwX2luZGV4ID0g
aGEtPnZwX2lkeDsKIAogCXJldHVybiBjdF9wa3Q7CiB9CkBAIC0xNzQ2LDYgKzE3NDgsNyBAQCBx
bGEyNHh4X3ByZXBfbXNfZm1faW9jYihzY3NpX3FsYV9ob3N0X3QgKmhhLCB1aW50MzJfdCByZXFf
c2l6ZSwKIAljdF9wa3QtPmRzZWdfMV9hZGRyZXNzWzBdID0gY3B1X3RvX2xlMzIoTFNEKGhhLT5j
dF9zbnNfZG1hKSk7CiAJY3RfcGt0LT5kc2VnXzFfYWRkcmVzc1sxXSA9IGNwdV90b19sZTMyKE1T
RChoYS0+Y3Rfc25zX2RtYSkpOwogCWN0X3BrdC0+ZHNlZ18xX2xlbiA9IGN0X3BrdC0+cnNwX2J5
dGVfY291bnQ7CisJY3RfcGt0LT52cF9pbmRleCA9IGhhLT52cF9pZHg7CiAKIAlyZXR1cm4gY3Rf
cGt0OwogfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyBiL2Ry
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMKaW5kZXggMmE0NWFlYy4uODQ3MDY2YiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYworKysgYi9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfaW5pdC5jCkBAIC04OTksNiArODk5LDEwIEBAIHFsYTJ4MDBfc2V0dXBf
Y2hpcChzY3NpX3FsYV9ob3N0X3QgKmhhKQogCQkJCSAgICAmaGEtPmZ3X3N1Ym1pbm9yX3ZlcnNp
b24sCiAJCQkJICAgICZoYS0+ZndfYXR0cmlidXRlcywgJmhhLT5md19tZW1vcnlfc2l6ZSk7CiAJ
CQkJcWxhMngwMF9yZXNpemVfcmVxdWVzdF9xKGhhKTsKKwkJCQloYS0+ZmxhZ3MubnBpdl9zdXBw
b3J0ZWQgPSAwOworCQkJCWlmIChJU19RTEEyNFhYKGhhKSAmJgorCQkJCSAgICAoaGEtPmZ3X2F0
dHJpYnV0ZXMgJiBCSVRfMikpCisJCQkJCWhhLT5mbGFncy5ucGl2X3N1cHBvcnRlZCA9IDE7CiAK
IAkJCQlpZiAocWwyeGFsbG9jZndkdW1wKQogCQkJCQlxbGEyeDAwX2FsbG9jX2Z3X2R1bXAoaGEp
OwpAQCAtMTEwMSw2ICsxMTA1LDggQEAgcWxhMngwMF9pbml0X3JpbmdzKHNjc2lfcWxhX2hvc3Rf
dCAqaGEpCiAJaW50CXJ2YWw7CiAJdW5zaWduZWQgbG9uZyBmbGFncyA9IDA7CiAJaW50IGNudDsK
KwlzdHJ1Y3QgbWlkX2luaXRfY2JfMjR4eCAqbWlkX2luaXRfY2IgPQorCSAgICAoc3RydWN0IG1p
ZF9pbml0X2NiXzI0eHggKikgaGEtPmluaXRfY2I7CiAKIAlzcGluX2xvY2tfaXJxc2F2ZSgmaGEt
PmhhcmR3YXJlX2xvY2ssIGZsYWdzKTsKIApAQCAtMTEzMiw2ICsxMTM4LDEwIEBAIHFsYTJ4MDBf
aW5pdF9yaW5ncyhzY3NpX3FsYV9ob3N0X3QgKmhhKQogCWhhLT5pc3Bfb3BzLnVwZGF0ZV9md19v
cHRpb25zKGhhKTsKIAogCURFQlVHKHByaW50aygic2NzaSglbGQpOiBJc3N1ZSBpbml0IGZpcm13
YXJlLlxuIiwgaGEtPmhvc3Rfbm8pKTsKKworCW1pZF9pbml0X2NiLT5jb3VudCA9IE1BWF9OVU1f
VlBPUlRfRkFCUklDOworCWhhLT5tYXhfbnBpdl92cG9ydHMgPSBNQVhfTlVNX1ZQT1JUX0ZBQlJJ
QzsKKwogCXJ2YWwgPSBxbGEyeDAwX2luaXRfZmlybXdhcmUoaGEsIGhhLT5pbml0X2NiX3NpemUp
OwogCWlmIChydmFsKSB7CiAJCURFQlVHMl8zKHByaW50aygic2NzaSglbGQpOiBJbml0IGZpcm13
YXJlICoqKiogRkFJTEVEICoqKiouXG4iLApAQCAtMTI2Myw2ICsxMjczLDcgQEAgcWxhMngwMF9j
b25maWd1cmVfaGJhKHNjc2lfcWxhX2hvc3RfdCAqaGEpCiAJaW50ICAgICAgIHJ2YWw7CiAJdWlu
dDE2X3QgICAgICBsb29wX2lkOwogCXVpbnQxNl90ICAgICAgdG9wbzsKKwl1aW50MTZfdCAgICAg
IHN3X2NhcDsKIAl1aW50OF90ICAgICAgIGFsX3BhOwogCXVpbnQ4X3QgICAgICAgYXJlYTsKIAl1
aW50OF90ICAgICAgIGRvbWFpbjsKQEAgLTEyNzAsNyArMTI4MSw3IEBAIHFsYTJ4MDBfY29uZmln
dXJlX2hiYShzY3NpX3FsYV9ob3N0X3QgKmhhKQogCiAJLyogR2V0IGhvc3QgYWRkcmVzc2VzLiAq
LwogCXJ2YWwgPSBxbGEyeDAwX2dldF9hZGFwdGVyX2lkKGhhLAotCSAgICAmbG9vcF9pZCwgJmFs
X3BhLCAmYXJlYSwgJmRvbWFpbiwgJnRvcG8pOworCSAgICAmbG9vcF9pZCwgJmFsX3BhLCAmYXJl
YSwgJmRvbWFpbiwgJnRvcG8sICZzd19jYXApOwogCWlmIChydmFsICE9IFFMQV9TVUNDRVNTKSB7
CiAJCWlmIChMT09QX1RSQU5TSVRJT04oaGEpIHx8IGF0b21pY19yZWFkKCZoYS0+bG9vcF9kb3du
X3RpbWVyKSB8fAogCQkgICAgKHJ2YWwgPT0gUUxBX0NPTU1BTkRfRVJST1IgJiYgbG9vcF9pZCA9
PSAweDcpKSB7CkBAIC0xMjk1LDYgKzEzMDYsNyBAQCBxbGEyeDAwX2NvbmZpZ3VyZV9oYmEoc2Nz
aV9xbGFfaG9zdF90ICpoYSkKIAkvKiBpbml0aWFsaXplICovCiAJaGEtPm1pbl9leHRlcm5hbF9s
b29waWQgPSBTTlNfRklSU1RfTE9PUF9JRDsKIAloYS0+b3BlcmF0aW5nX21vZGUgPSBMT09QOwor
CWhhLT5zd2l0Y2hfY2FwID0gMDsKIAogCXN3aXRjaCAodG9wbykgewogCWNhc2UgMDoKQEAgLTEz
MDcsNiArMTMxOSw3IEBAIHFsYTJ4MDBfY29uZmlndXJlX2hiYShzY3NpX3FsYV9ob3N0X3QgKmhh
KQogCWNhc2UgMToKIAkJREVCVUczKHByaW50aygic2NzaSglbGQpOiBIQkEgaW4gRkwgdG9wb2xv
Z3kuXG4iLAogCQkgICAgaGEtPmhvc3Rfbm8pKTsKKwkJaGEtPnN3aXRjaF9jYXAgPSBzd19jYXA7
CiAJCWhhLT5jdXJyZW50X3RvcG9sb2d5ID0gSVNQX0NGR19GTDsKIAkJc3RyY3B5KGNvbm5lY3Rf
dHlwZSwgIihGTF9Qb3J0KSIpOwogCQlicmVhazsKQEAgLTEzMjIsNiArMTMzNSw3IEBAIHFsYTJ4
MDBfY29uZmlndXJlX2hiYShzY3NpX3FsYV9ob3N0X3QgKmhhKQogCWNhc2UgMzoKIAkJREVCVUcz
KHByaW50aygic2NzaSglbGQpOiBIQkEgaW4gRiBQMlAgdG9wb2xvZ3kuXG4iLAogCQkgICAgaGEt
Pmhvc3Rfbm8pKTsKKwkJaGEtPnN3aXRjaF9jYXAgPSBzd19jYXA7CiAJCWhhLT5vcGVyYXRpbmdf
bW9kZSA9IFAyUDsKIAkJaGEtPmN1cnJlbnRfdG9wb2xvZ3kgPSBJU1BfQ0ZHX0Y7CiAJCXN0cmNw
eShjb25uZWN0X3R5cGUsICIoRl9Qb3J0KSIpOwpAQCAtMTc0Myw3ICsxNzU3LDYgQEAgcWxhMngw
MF9ycG9ydF9kZWwodm9pZCAqZGF0YSkKIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZmY3BvcnQt
PnJwb3J0X2xvY2ssIGZsYWdzKTsKIAlpZiAocnBvcnQpCiAJCWZjX3JlbW90ZV9wb3J0X2RlbGV0
ZShycG9ydCk7Ci0KIH0KIAogLyoqCkBAIC0xNzY1LDYgKzE3NzgsNyBAQCBxbGEyeDAwX2FsbG9j
X2ZjcG9ydChzY3NpX3FsYV9ob3N0X3QgKmhhLCBnZnBfdCBmbGFncykKIAkvKiBTZXR1cCBmY3Bv
cnQgdGVtcGxhdGUgc3RydWN0dXJlLiAqLwogCW1lbXNldChmY3BvcnQsIDAsIHNpemVvZiAoZmNf
cG9ydF90KSk7CiAJZmNwb3J0LT5oYSA9IGhhOworCWZjcG9ydC0+dnBfaWR4ID0gaGEtPnZwX2lk
eDsKIAlmY3BvcnQtPnBvcnRfdHlwZSA9IEZDVF9VTktOT1dOOwogCWZjcG9ydC0+bG9vcF9pZCA9
IEZDX05PX0xPT1BfSUQ7CiAJYXRvbWljX3NldCgmZmNwb3J0LT5zdGF0ZSwgRkNTX1VOQ09ORklH
VVJFRCk7CkBAIC0xOTExLDYgKzE5MjUsNyBAQCBxbGEyeDAwX2NvbmZpZ3VyZV9sb2NhbF9sb29w
KHNjc2lfcWxhX2hvc3RfdCAqaGEpCiAJY2hhcgkJKmlkX2l0ZXI7CiAJdWludDE2X3QJbG9vcF9p
ZDsKIAl1aW50OF90CQlkb21haW4sIGFyZWEsIGFsX3BhOworCXNjc2lfcWxhX2hvc3RfdCAqcGhh
ID0gdG9fcWxhX3BhcmVudChoYSk7CiAKIAlmb3VuZF9kZXZzID0gMDsKIAluZXdfZmNwb3J0ID0g
TlVMTDsKQEAgLTE5NDIsNyArMTk1NywxMCBAQCBxbGEyeDAwX2NvbmZpZ3VyZV9sb2NhbF9sb29w
KHNjc2lfcWxhX2hvc3RfdCAqaGEpCiAJLyoKIAkgKiBNYXJrIGxvY2FsIGRldmljZXMgdGhhdCB3
ZXJlIHByZXNlbnQgd2l0aCBGQ0ZfREVWSUNFX0xPU1QgZm9yIG5vdy4KIAkgKi8KLQlsaXN0X2Zv
cl9lYWNoX2VudHJ5KGZjcG9ydCwgJmhhLT5mY3BvcnRzLCBsaXN0KSB7CisJbGlzdF9mb3JfZWFj
aF9lbnRyeShmY3BvcnQsICZwaGEtPmZjcG9ydHMsIGxpc3QpIHsKKwkJaWYgKGZjcG9ydC0+dnBf
aWR4ICE9IGhhLT52cF9pZHgpCisJCQljb250aW51ZTsKKwogCQlpZiAoYXRvbWljX3JlYWQoJmZj
cG9ydC0+c3RhdGUpID09IEZDU19PTkxJTkUgJiYKIAkJICAgIGZjcG9ydC0+cG9ydF90eXBlICE9
IEZDVF9CUk9BRENBU1QgJiYKIAkJICAgIChmY3BvcnQtPmZsYWdzICYgRkNGX0ZBQlJJQ19ERVZJ
Q0UpID09IDApIHsKQEAgLTE5ODgsNiArMjAwNiw3IEBAIHFsYTJ4MDBfY29uZmlndXJlX2xvY2Fs
X2xvb3Aoc2NzaV9xbGFfaG9zdF90ICpoYSkKIAkJbmV3X2ZjcG9ydC0+ZF9pZC5iLmFyZWEgPSBh
cmVhOwogCQluZXdfZmNwb3J0LT5kX2lkLmIuYWxfcGEgPSBhbF9wYTsKIAkJbmV3X2ZjcG9ydC0+
bG9vcF9pZCA9IGxvb3BfaWQ7CisJCW5ld19mY3BvcnQtPnZwX2lkeCA9IGhhLT52cF9pZHg7CiAJ
CXJ2YWwyID0gcWxhMngwMF9nZXRfcG9ydF9kYXRhYmFzZShoYSwgbmV3X2ZjcG9ydCwgMCk7CiAJ
CWlmIChydmFsMiAhPSBRTEFfU1VDQ0VTUykgewogCQkJREVCVUcyKHByaW50aygic2NzaSglbGQp
OiBGYWlsZWQgdG8gcmV0cmlldmUgZmNwb3J0ICIKQEAgLTIwMDMsNyArMjAyMiwxMCBAQCBxbGEy
eDAwX2NvbmZpZ3VyZV9sb2NhbF9sb29wKHNjc2lfcWxhX2hvc3RfdCAqaGEpCiAJCS8qIENoZWNr
IGZvciBtYXRjaGluZyBkZXZpY2UgaW4gcG9ydCBsaXN0LiAqLwogCQlmb3VuZCA9IDA7CiAJCWZj
cG9ydCA9IE5VTEw7Ci0JCWxpc3RfZm9yX2VhY2hfZW50cnkoZmNwb3J0LCAmaGEtPmZjcG9ydHMs
IGxpc3QpIHsKKwkJbGlzdF9mb3JfZWFjaF9lbnRyeShmY3BvcnQsICZwaGEtPmZjcG9ydHMsIGxp
c3QpIHsKKwkJCWlmIChmY3BvcnQtPnZwX2lkeCAhPSBoYS0+dnBfaWR4KQorCQkJCWNvbnRpbnVl
OworCiAJCQlpZiAobWVtY21wKG5ld19mY3BvcnQtPnBvcnRfbmFtZSwgZmNwb3J0LT5wb3J0X25h
bWUsCiAJCQkgICAgV1dOX1NJWkUpKQogCQkJCWNvbnRpbnVlOwpAQCAtMjAyMyw3ICsyMDQ1LDEz
IEBAIHFsYTJ4MDBfY29uZmlndXJlX2xvY2FsX2xvb3Aoc2NzaV9xbGFfaG9zdF90ICpoYSkKIAkJ
aWYgKCFmb3VuZCkgewogCQkJLyogTmV3IGRldmljZSwgYWRkIHRvIGZjcG9ydHMgbGlzdC4gKi8K
IAkJCW5ld19mY3BvcnQtPmZsYWdzICY9IH5GQ0ZfUEVSU0lTVEVOVF9CT1VORDsKLQkJCWxpc3Rf
YWRkX3RhaWwoJm5ld19mY3BvcnQtPmxpc3QsICZoYS0+ZmNwb3J0cyk7CisJCQlpZiAoaGEtPnBh
cmVudCkgeworCQkJCW5ld19mY3BvcnQtPmhhID0gaGE7CisJCQkJbmV3X2ZjcG9ydC0+dnBfaWR4
ID0gaGEtPnZwX2lkeDsKKwkJCQlsaXN0X2FkZF90YWlsKCZuZXdfZmNwb3J0LT52cF9mY3BvcnQs
CisJCQkJICAgICZoYS0+dnBfZmNwb3J0cyk7CisJCQl9CisJCQlsaXN0X2FkZF90YWlsKCZuZXdf
ZmNwb3J0LT5saXN0LCAmcGhhLT5mY3BvcnRzKTsKIAogCQkJLyogQWxsb2NhdGUgYSBuZXcgcmVw
bGFjZW1lbnQgZmNwb3J0LiAqLwogCQkJZmNwb3J0ID0gbmV3X2ZjcG9ydDsKQEAgLTIxOTksMTEg
KzIyMjcsMTMgQEAgcWxhMngwMF9yZWdfcmVtb3RlX3BvcnQoc2NzaV9xbGFfaG9zdF90ICpoYSwg
ZmNfcG9ydF90ICpmY3BvcnQpCiB2b2lkCiBxbGEyeDAwX3VwZGF0ZV9mY3BvcnQoc2NzaV9xbGFf
aG9zdF90ICpoYSwgZmNfcG9ydF90ICpmY3BvcnQpCiB7CisJc2NzaV9xbGFfaG9zdF90ICpwaGEg
PSB0b19xbGFfcGFyZW50KGhhKTsKKwogCWZjcG9ydC0+aGEgPSBoYTsKIAlmY3BvcnQtPmxvZ2lu
X3JldHJ5ID0gMDsKLQlmY3BvcnQtPnBvcnRfbG9naW5fcmV0cnlfY291bnQgPSBoYS0+cG9ydF9k
b3duX3JldHJ5X2NvdW50ICoKKwlmY3BvcnQtPnBvcnRfbG9naW5fcmV0cnlfY291bnQgPSBwaGEt
PnBvcnRfZG93bl9yZXRyeV9jb3VudCAqCiAJICAgIFBPUlRfUkVUUllfVElNRTsKLQlhdG9taWNf
c2V0KCZmY3BvcnQtPnBvcnRfZG93bl90aW1lciwgaGEtPnBvcnRfZG93bl9yZXRyeV9jb3VudCAq
CisJYXRvbWljX3NldCgmZmNwb3J0LT5wb3J0X2Rvd25fdGltZXIsIHBoYS0+cG9ydF9kb3duX3Jl
dHJ5X2NvdW50ICoKIAkgICAgUE9SVF9SRVRSWV9USU1FKTsKIAlmY3BvcnQtPmZsYWdzICY9IH5G
Q0ZfTE9HSU5fTkVFREVEOwogCkBAIC0yMjM0LDYgKzIyNjQsNyBAQCBxbGEyeDAwX2NvbmZpZ3Vy
ZV9mYWJyaWMoc2NzaV9xbGFfaG9zdF90ICpoYSkKIAl1aW50MTZfdAltYltNQUlMQk9YX1JFR0lT
VEVSX0NPVU5UXTsKIAl1aW50MTZfdAlsb29wX2lkOwogCUxJU1RfSEVBRChuZXdfZmNwb3J0cyk7
CisJc2NzaV9xbGFfaG9zdF90ICpwaGEgPSB0b19xbGFfcGFyZW50KGhhKTsKIAogCS8qIElmIEZM
IHBvcnQgZXhpc3RzLCB0aGVuIFNOUyBpcyBwcmVzZW50ICovCiAJaWYgKElTX1FMQTI0WFgoaGEp
IHx8IElTX1FMQTU0WFgoaGEpKQpAQCAtMjMwNyw3ICsyMzM4LDEwIEBAIHFsYTJ4MDBfY29uZmln
dXJlX2ZhYnJpYyhzY3NpX3FsYV9ob3N0X3QgKmhhKQogCQkgKiBMb2dvdXQgYWxsIHByZXZpb3Vz
IGZhYnJpYyBkZXZpY2VzIG1hcmtlZCBsb3N0LCBleGNlcHQKIAkJICogdGFwZSBkZXZpY2VzLgog
CQkgKi8KLQkJbGlzdF9mb3JfZWFjaF9lbnRyeShmY3BvcnQsICZoYS0+ZmNwb3J0cywgbGlzdCkg
eworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGZjcG9ydCwgJnBoYS0+ZmNwb3J0cywgbGlzdCkgewor
CQkJaWYgKGZjcG9ydC0+dnBfaWR4ICE9aGEtPnZwX2lkeCkKKwkJCQljb250aW51ZTsKKwogCQkJ
aWYgKHRlc3RfYml0KExPT1BfUkVTWU5DX05FRURFRCwgJmhhLT5kcGNfZmxhZ3MpKQogCQkJCWJy
ZWFrOwogCkBAIC0yMzMyLDEzICsyMzY2LDE2IEBAIHFsYTJ4MDBfY29uZmlndXJlX2ZhYnJpYyhz
Y3NpX3FsYV9ob3N0X3QgKmhhKQogCQl9CiAKIAkJLyogU3RhcnRpbmcgZnJlZSBsb29wIElELiAq
LwotCQluZXh0X2xvb3BpZCA9IGhhLT5taW5fZXh0ZXJuYWxfbG9vcGlkOworCQluZXh0X2xvb3Bp
ZCA9IHBoYS0+bWluX2V4dGVybmFsX2xvb3BpZDsKIAogCQkvKgogCQkgKiBTY2FuIHRocm91Z2gg
b3VyIHBvcnQgbGlzdCBhbmQgbG9naW4gZW50cmllcyB0aGF0IG5lZWQgdG8gYmUKIAkJICogbG9n
Z2VkIGluLgogCQkgKi8KLQkJbGlzdF9mb3JfZWFjaF9lbnRyeShmY3BvcnQsICZoYS0+ZmNwb3J0
cywgbGlzdCkgeworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGZjcG9ydCwgJnBoYS0+ZmNwb3J0cywg
bGlzdCkgeworCQkJaWYgKGZjcG9ydC0+dnBfaWR4ICE9IGhhLT52cF9pZHgpCisJCQkJY29udGlu
dWU7CisKIAkJCWlmIChhdG9taWNfcmVhZCgmaGEtPmxvb3BfZG93bl90aW1lcikgfHwKIAkJCSAg
ICB0ZXN0X2JpdChMT09QX1JFU1lOQ19ORUVERUQsICZoYS0+ZHBjX2ZsYWdzKSkKIAkJCQlicmVh
azsKQEAgLTIzODAsMTEgKzI0MTcsMTggQEAgcWxhMngwMF9jb25maWd1cmVfZmFicmljKHNjc2lf
cWxhX2hvc3RfdCAqaGEpCiAJCQkJYnJlYWs7CiAJCQl9CiAKLQkJCS8qIFJlbW92ZSBkZXZpY2Ug
ZnJvbSB0aGUgbmV3IGxpc3QgYW5kIGFkZCBpdCB0byBEQiAqLwotCQkJbGlzdF9tb3ZlX3RhaWwo
JmZjcG9ydC0+bGlzdCwgJmhhLT5mY3BvcnRzKTsKLQogCQkJLyogTG9naW4gYW5kIHVwZGF0ZSBk
YXRhYmFzZSAqLwogCQkJcWxhMngwMF9mYWJyaWNfZGV2X2xvZ2luKGhhLCBmY3BvcnQsICZuZXh0
X2xvb3BpZCk7CisKKwkJCWlmIChoYS0+cGFyZW50KSB7CisJCQkJZmNwb3J0LT5oYSA9IGhhOwor
CQkJCWZjcG9ydC0+dnBfaWR4ID0gaGEtPnZwX2lkeDsKKwkJCQlsaXN0X2FkZF90YWlsKCZmY3Bv
cnQtPnZwX2ZjcG9ydCwKKwkJCQkgICAgJmhhLT52cF9mY3BvcnRzKTsKKwkJCQlsaXN0X21vdmVf
dGFpbCgmZmNwb3J0LT5saXN0LAorCQkJCSAgICAmaGEtPnBhcmVudC0+ZmNwb3J0cyk7CisJCQl9
IGVsc2UKKwkJCQlsaXN0X21vdmVfdGFpbCgmZmNwb3J0LT5saXN0LCAmaGEtPmZjcG9ydHMpOwog
CQl9CiAJfSB3aGlsZSAoMCk7CiAKQEAgLTI0MjgsNiArMjQ3MiwxMSBAQCBxbGEyeDAwX2ZpbmRf
YWxsX2ZhYnJpY19kZXZzKHNjc2lfcWxhX2hvc3RfdCAqaGEsIHN0cnVjdCBsaXN0X2hlYWQgKm5l
d19mY3BvcnRzKQogCWludAkJc3dsX2lkeDsKIAlpbnQJCWZpcnN0X2RldiwgbGFzdF9kZXY7CiAJ
cG9ydF9pZF90CXdyYXAsIG54dF9kX2lkOworCWludCAJCXZwX2luZGV4OworCWludAkJZW1wdHlf
dnBfaW5kZXg7CisJaW50CQlmb3VuZF92cDsKKwlzY3NpX3FsYV9ob3N0X3QgKnZoYTsKKwlzY3Np
X3FsYV9ob3N0X3QgKnBoYSA9IHRvX3FsYV9wYXJlbnQoaGEpOwogCiAJcnZhbCA9IFFMQV9TVUND
RVNTOwogCkBAIC0yNDYxLDEzICsyNTEwLDEzIEBAIHFsYTJ4MDBfZmluZF9hbGxfZmFicmljX2Rl
dnMoc2NzaV9xbGFfaG9zdF90ICpoYSwgc3RydWN0IGxpc3RfaGVhZCAqbmV3X2ZjcG9ydHMpCiAJ
CXJldHVybiAoUUxBX01FTU9SWV9BTExPQ19GQUlMRUQpOwogCX0KIAluZXdfZmNwb3J0LT5mbGFn
cyB8PSAoRkNGX0ZBQlJJQ19ERVZJQ0UgfCBGQ0ZfTE9HSU5fTkVFREVEKTsKLQorCW5ld19mY3Bv
cnQtPnZwX2lkeCA9IGhhLT52cF9pZHg7CiAJLyogU2V0IHN0YXJ0IHBvcnQgSUQgc2NhbiBhdCBh
ZGFwdGVyIElELiAqLwogCWZpcnN0X2RldiA9IDE7CiAJbGFzdF9kZXYgPSAwOwogCiAJLyogU3Rh
cnRpbmcgZnJlZSBsb29wIElELiAqLwotCWxvb3BfaWQgPSBoYS0+bWluX2V4dGVybmFsX2xvb3Bp
ZDsKKwlsb29wX2lkID0gcGhhLT5taW5fZXh0ZXJuYWxfbG9vcGlkOwogCWZvciAoOyBsb29wX2lk
IDw9IGhhLT5sYXN0X2xvb3BfaWQ7IGxvb3BfaWQrKykgewogCQlpZiAocWxhMngwMF9pc19yZXNl
cnZlZF9pZChoYSwgbG9vcF9pZCkpCiAJCQljb250aW51ZTsKQEAgLTI1MjEsOSArMjU3MCw0MSBA
QCBxbGEyeDAwX2ZpbmRfYWxsX2ZhYnJpY19kZXZzKHNjc2lfcWxhX2hvc3RfdCAqaGEsIHN0cnVj
dCBsaXN0X2hlYWQgKm5ld19mY3BvcnRzKQogCQkJYnJlYWs7CiAJCX0KIAotCQkvKiBCeXBhc3Mg
aWYgaG9zdCBhZGFwdGVyLiAqLwotCQlpZiAobmV3X2ZjcG9ydC0+ZF9pZC5iMjQgPT0gaGEtPmRf
aWQuYjI0KQotCQkJY29udGludWU7CisJCS8qIEJ5cGFzcyBpZiBzYW1lIHBoeXNpY2FsIGFkYXB0
ZXIuICovCisJCWlmIChuZXdfZmNwb3J0LT5kX2lkLmIyNCA9PSBwaGEtPmRfaWQuYjI0KQorIAkJ
CWNvbnRpbnVlOworCisJCS8qIEJ5cGFzcyB2aXJ0dWFsIHBvcnRzIG9mIHRoZSBzYW1lIGhvc3Qu
ICovCisJCWlmIChwaGEtPm51bV92aG9zdHMpIHsKKwkJCXZwX2luZGV4ID0gZmluZF9uZXh0X2Jp
dCgKKwkJCSAgICAodW5zaWduZWQgbG9uZyAqKXBoYS0+dnBfaWR4X21hcCwKKwkJCSAgICBNQVhf
TVVMVElfSURfRkFCUklDICsgMSwgMSk7CisKKwkJCWZvciAoO3ZwX2luZGV4IDw9IE1BWF9NVUxU
SV9JRF9GQUJSSUM7CisJCQkgICAgdnBfaW5kZXggPSBmaW5kX25leHRfYml0KAorCQkJICAgICh1
bnNpZ25lZCBsb25nICopcGhhLT52cF9pZHhfbWFwLAorCQkJICAgIE1BWF9NVUxUSV9JRF9GQUJS
SUMgKyAxLCB2cF9pbmRleCArIDEpKSB7CisJCQkJZW1wdHlfdnBfaW5kZXggPSAxOworCQkJCWZv
dW5kX3ZwID0gMDsKKwkJCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KHZoYSwgJnBoYS0+dnBfbGlzdCwK
KwkJCQkgICAgdnBfbGlzdCkgeworCQkJCQlpZiAodnBfaW5kZXggPT0gdmhhLT52cF9pZHgpIHsK
KwkJCQkJCWVtcHR5X3ZwX2luZGV4ID0gMDsKKwkJCQkJCWZvdW5kX3ZwID0gMTsKKwkJCQkJCWJy
ZWFrOworCQkJCQl9CisJCQkJfQorCisJCQkJaWYgKGVtcHR5X3ZwX2luZGV4KQorCQkJCQljb250
aW51ZTsKKworCQkJCWlmIChmb3VuZF92cCAmJgorCQkJCSAgICBuZXdfZmNwb3J0LT5kX2lkLmIy
NCA9PSB2aGEtPmRfaWQuYjI0KQorCQkJCQlicmVhazsKKwkJCX0KKwkJCWlmICh2cF9pbmRleCA8
PSBNQVhfTVVMVElfSURfRkFCUklDKQorCQkJCWNvbnRpbnVlOworCQl9CiAKIAkJLyogQnlwYXNz
IGlmIHNhbWUgZG9tYWluIGFuZCBhcmVhIG9mIGFkYXB0ZXIuICovCiAJCWlmICgoKG5ld19mY3Bv
cnQtPmRfaWQuYjI0ICYgMHhmZmZmMDApID09CkBAIC0yNTM3LDcgKzI2MTgsOSBAQCBxbGEyeDAw
X2ZpbmRfYWxsX2ZhYnJpY19kZXZzKHNjc2lfcWxhX2hvc3RfdCAqaGEsIHN0cnVjdCBsaXN0X2hl
YWQgKm5ld19mY3BvcnRzKQogCiAJCS8qIExvY2F0ZSBtYXRjaGluZyBkZXZpY2UgaW4gZGF0YWJh
c2UuICovCiAJCWZvdW5kID0gMDsKLQkJbGlzdF9mb3JfZWFjaF9lbnRyeShmY3BvcnQsICZoYS0+
ZmNwb3J0cywgbGlzdCkgeworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGZjcG9ydCwgJnBoYS0+ZmNw
b3J0cywgbGlzdCkgeworCQkJaWYgKG5ld19mY3BvcnQtPnZwX2lkeCAhPSBmY3BvcnQtPnZwX2lk
eCkKKwkJCQljb250aW51ZTsKIAkJCWlmIChtZW1jbXAobmV3X2ZjcG9ydC0+cG9ydF9uYW1lLCBm
Y3BvcnQtPnBvcnRfbmFtZSwKIAkJCSAgICBXV05fU0laRSkpCiAJCQkJY29udGludWU7CkBAIC0y
NjA1LDYgKzI2ODgsNyBAQCBxbGEyeDAwX2ZpbmRfYWxsX2ZhYnJpY19kZXZzKHNjc2lfcWxhX2hv
c3RfdCAqaGEsIHN0cnVjdCBsaXN0X2hlYWQgKm5ld19mY3BvcnRzKQogCQl9CiAJCW5ld19mY3Bv
cnQtPmZsYWdzIHw9IChGQ0ZfRkFCUklDX0RFVklDRSB8IEZDRl9MT0dJTl9ORUVERUQpOwogCQlu
ZXdfZmNwb3J0LT5kX2lkLmIyNCA9IG54dF9kX2lkLmIyNDsKKwkJbmV3X2ZjcG9ydC0+dnBfaWR4
ID0gaGEtPnZwX2lkeDsKIAl9CiAKIAlrZnJlZShzd2wpOwpAQCAtMjYzNyw2ICsyNzIxLDcgQEAg
cWxhMngwMF9maW5kX25ld19sb29wX2lkKHNjc2lfcWxhX2hvc3RfdCAqaGEsIGZjX3BvcnRfdCAq
ZGV2KQogCWludAlmb3VuZDsKIAlmY19wb3J0X3QgKmZjcG9ydDsKIAl1aW50MTZfdCBmaXJzdF9s
b29wX2lkOworCXNjc2lfcWxhX2hvc3RfdCAqcGhhID0gdG9fcWxhX3BhcmVudChoYSk7CiAKIAly
dmFsID0gUUxBX1NVQ0NFU1M7CiAKQEAgLTI2NjMsNyArMjc0OCw3IEBAIHFsYTJ4MDBfZmluZF9u
ZXdfbG9vcF9pZChzY3NpX3FsYV9ob3N0X3QgKmhhLCBmY19wb3J0X3QgKmRldikKIAkJLyogQ2hl
Y2sgZm9yIGxvb3AgSUQgYmVpbmcgYWxyZWFkeSBpbiB1c2UuICovCiAJCWZvdW5kID0gMDsKIAkJ
ZmNwb3J0ID0gTlVMTDsKLQkJbGlzdF9mb3JfZWFjaF9lbnRyeShmY3BvcnQsICZoYS0+ZmNwb3J0
cywgbGlzdCkgeworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGZjcG9ydCwgJnBoYS0+ZmNwb3J0cywg
bGlzdCkgewogCQkJaWYgKGZjcG9ydC0+bG9vcF9pZCA9PSBkZXYtPmxvb3BfaWQgJiYgZmNwb3J0
ICE9IGRldikgewogCQkJCS8qIElEIHBvc3NpYmx5IGluIHVzZSAqLwogCQkJCWZvdW5kKys7CkBA
IC0yNzEwLDYgKzI3OTUsNyBAQCBxbGEyeDAwX2RldmljZV9yZXN5bmMoc2NzaV9xbGFfaG9zdF90
ICpoYSkKIAl1aW50OF90IHJzY25fb3V0X2l0ZXI7CiAJdWludDhfdCBmb3JtYXQ7CiAJcG9ydF9p
ZF90IGRfaWQ7CisJc2NzaV9xbGFfaG9zdF90ICpwaGEgPSB0b19xbGFfcGFyZW50KGhhKTsKIAog
CXJ2YWwgPSBRTEFfUlNDTlNfSEFORExFRDsKIApAQCAtMjc3Niw3ICsyODYyLDEwIEBAIHFsYTJ4
MDBfZGV2aWNlX3Jlc3luYyhzY3NpX3FsYV9ob3N0X3QgKmhhKQogCiAJCXJ2YWwgPSBRTEFfU1VD
Q0VTUzsKIAotCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGZjcG9ydCwgJmhhLT5mY3BvcnRzLCBsaXN0
KSB7CisJCWxpc3RfZm9yX2VhY2hfZW50cnkoZmNwb3J0LCAmcGhhLT5mY3BvcnRzLCBsaXN0KSB7
CisJCQlpZiAoZmNwb3J0LT52cF9pZHggIT0gaGEtPnZwX2lkeCkKKwkJCQljb250aW51ZTsKKwog
CQkJaWYgKChmY3BvcnQtPmZsYWdzICYgRkNGX0ZBQlJJQ19ERVZJQ0UpID09IDAgfHwKIAkJCSAg
ICAoZmNwb3J0LT5kX2lkLmIyNCAmIG1hc2spICE9IGRfaWQuYjI0IHx8CiAJCQkgICAgZmNwb3J0
LT5wb3J0X3R5cGUgPT0gRkNUX0JST0FEQ0FTVCkKQEAgLTM5NDAsMyArNDAyOSw0MCBAQCBxbGEy
eDAwX3RyeV90b19zdG9wX2Zpcm13YXJlKHNjc2lfcWxhX2hvc3RfdCAqaGEpCiAJCXJldCA9IHFs
YTJ4MDBfc3RvcF9maXJtd2FyZShoYSk7CiAJfQogfQorCitpbnQKK3FsYTI0eHhfY29uZmlndXJl
X3ZoYmEoc2NzaV9xbGFfaG9zdF90ICpoYSkKK3sKKwlpbnQgcnZhbCA9IFFMQV9TVUNDRVNTOwor
CXVpbnQxNl90IG1iW01BSUxCT1hfUkVHSVNURVJfQ09VTlRdOworCisJaWYgKCFoYS0+cGFyZW50
KQorCQlyZXR1cm4gLUVJTlZBTDsKKworCXJ2YWwgPSBxbGEyeDAwX2Z3X3JlYWR5KGhhKTsKKwlp
ZiAocnZhbCA9PSBRTEFfU1VDQ0VTUykgeworCQljbGVhcl9iaXQoUkVTRVRfTUFSS0VSX05FRURF
RCwgJmhhLT5kcGNfZmxhZ3MpOworCQlxbGEyeDAwX21hcmtlcihoYSwgMCwgMCwgTUtfU1lOQ19B
TEwpOworCX0KKworCWhhLT5mbGFncy5tYW5hZ2VtZW50X3NlcnZlcl9sb2dnZWRfaW4gPSAwOwor
CisJLyogTG9naW4gdG8gU05TIGZpcnN0ICovCisJcWxhMjR4eF9sb2dpbl9mYWJyaWMoaGEsIE5Q
SF9TTlMsIDB4ZmYsIDB4ZmYsIDB4ZmMsCisJICAgIG1iLCBCSVRfMSk7CisJaWYgKG1iWzBdICE9
IE1CU19DT01NQU5EX0NPTVBMRVRFKSB7CisJCURFQlVHMTUocWxhX3ByaW50ayhLRVJOX0lORk8s
IGhhLAorCQkgICAgIkZhaWxlZCBTTlMgbG9naW46IGxvb3BfaWQ9JXggbWJbMF09JXggbWJbMV09
JXggIgorCQkgICAgIm1iWzJdPSV4IG1iWzZdPSV4IG1iWzddPSV4XG4iLCBOUEhfU05TLAorCQkg
ICAgbWJbMF0sIG1iWzFdLCBtYlsyXSwgbWJbNl0sIG1iWzddKSk7CisJCXJldHVybiAoUUxBX0ZV
TkNUSU9OX0ZBSUxFRCk7CisJfQorCisJYXRvbWljX3NldCgmaGEtPmxvb3BfZG93bl90aW1lciwg
MCk7CisJYXRvbWljX3NldCgmaGEtPmxvb3Bfc3RhdGUsIExPT1BfVVApOworCXNldF9iaXQoTE9P
UF9SRVNZTkNfTkVFREVELCAmaGEtPmRwY19mbGFncyk7CisJc2V0X2JpdChMT0NBTF9MT09QX1VQ
REFURSwgJmhhLT5kcGNfZmxhZ3MpOworCXJ2YWwgPSBxbGEyeDAwX2xvb3BfcmVzeW5jKGhhKTsK
KworCXJldHVybiBydmFsOworfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2lvY2IuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMKaW5kZXggYzUxN2ExNC4u
YzcxODYzZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lvY2IuYworKysg
Yi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW9jYi5jCkBAIC0xNzksNyArMTc5LDYgQEAgdm9p
ZCBxbGEyeDAwX2J1aWxkX3Njc2lfaW9jYnNfMzIoc3JiX3QgKnNwLCBjbWRfZW50cnlfdCAqY21k
X3BrdCwKIAljdXJfZHNkID0gKHVpbnQzMl90ICopJmNtZF9wa3QtPmRzZWdfMF9hZGRyZXNzOwog
CiAJLyogTG9hZCBkYXRhIHNlZ21lbnRzICovCi0KIAlzY3NpX2Zvcl9lYWNoX3NnKGNtZCwgc2cs
IHRvdF9kc2RzLCBpKSB7CiAJCWNvbnRfZW50cnlfdCAqY29udF9wa3Q7CiAKQEAgLTMxNiw5ICsz
MTUsMTQgQEAgcWxhMngwMF9zdGFydF9zY3NpKHNyYl90ICpzcCkKIAkJZ290byBxdWV1aW5nX2Vy
cm9yOwogCiAJLyogTWFwIHRoZSBzZyB0YWJsZSBzbyB3ZSBoYXZlIGFuIGFjY3VyYXRlIGNvdW50
IG9mIHNnIGVudHJpZXMgbmVlZGVkICovCi0JbnNlZyA9IHNjc2lfZG1hX21hcChjbWQpOwotCWlm
IChuc2VnIDwgMCkKLQkJZ290byBxdWV1aW5nX2Vycm9yOworCWlmIChzY3NpX3NnX2NvdW50KGNt
ZCkpIHsKKwkJbnNlZyA9IGRtYV9tYXBfc2coJmhhLT5wZGV2LT5kZXYsIHNjc2lfc2dsaXN0KGNt
ZCksCisJCSAgICBzY3NpX3NnX2NvdW50KGNtZCksIGNtZC0+c2NfZGF0YV9kaXJlY3Rpb24pOwor
CQlpZiAodW5saWtlbHkoIW5zZWcpKQorCQkJZ290byBxdWV1aW5nX2Vycm9yOworCX0gZWxzZQor
CQluc2VnID0gMDsKKwogCXRvdF9kc2RzID0gbnNlZzsKIAogCS8qIENhbGN1bGF0ZSB0aGUgbnVt
YmVyIG9mIHJlcXVlc3QgZW50cmllcyBuZWVkZWQuICovCkBAIC00MTQsOSArNDE4LDEwIEBAIF9f
cWxhMngwMF9tYXJrZXIoc2NzaV9xbGFfaG9zdF90ICpoYSwgdWludDE2X3QgbG9vcF9pZCwgdWlu
dDE2X3QgbHVuLAogewogCW1ya19lbnRyeV90ICptcms7CiAJc3RydWN0IG1ya19lbnRyeV8yNHh4
ICptcmsyNDsKKwlzY3NpX3FsYV9ob3N0X3QgKnBoYSA9IHRvX3FsYV9wYXJlbnQoaGEpOwogCiAJ
bXJrMjQgPSBOVUxMOwotCW1yayA9IChtcmtfZW50cnlfdCAqKXFsYTJ4MDBfcmVxX3BrdChoYSk7
CisJbXJrID0gKG1ya19lbnRyeV90ICopcWxhMngwMF9yZXFfcGt0KHBoYSk7CiAJaWYgKG1yayA9
PSBOVUxMKSB7CiAJCURFQlVHMl8zKHByaW50aygiJXMoJWxkKTogZmFpbGVkIHRvIGFsbG9jYXRl
IE1hcmtlciBJT0NCLlxuIiwKIAkJICAgIF9fZnVuY19fLCBoYS0+aG9zdF9ubykpOwpAQCAtNDMz
LDYgKzQzOCw3IEBAIF9fcWxhMngwMF9tYXJrZXIoc2NzaV9xbGFfaG9zdF90ICpoYSwgdWludDE2
X3QgbG9vcF9pZCwgdWludDE2X3QgbHVuLAogCQkJbXJrMjQtPmx1blsxXSA9IExTQihsdW4pOwog
CQkJbXJrMjQtPmx1blsyXSA9IE1TQihsdW4pOwogCQkJaG9zdF90b19mY3Bfc3dhcChtcmsyNC0+
bHVuLCBzaXplb2YobXJrMjQtPmx1bikpOworCQkJbXJrMjQtPnZwX2luZGV4ID0gaGEtPnZwX2lk
eDsKIAkJfSBlbHNlIHsKIAkJCVNFVF9UQVJHRVRfSUQoaGEsIG1yay0+dGFyZ2V0LCBsb29wX2lk
KTsKIAkJCW1yay0+bHVuID0gY3B1X3RvX2xlMTYobHVuKTsKQEAgLTQ0MCw3ICs0NDYsNyBAQCBf
X3FsYTJ4MDBfbWFya2VyKHNjc2lfcWxhX2hvc3RfdCAqaGEsIHVpbnQxNl90IGxvb3BfaWQsIHVp
bnQxNl90IGx1biwKIAl9CiAJd21iKCk7CiAKLQlxbGEyeDAwX2lzcF9jbWQoaGEpOworCXFsYTJ4
MDBfaXNwX2NtZChwaGEpOwogCiAJcmV0dXJuIChRTEFfU1VDQ0VTUyk7CiB9CkBAIC03MTIsOSAr
NzE4LDE0IEBAIHFsYTI0eHhfc3RhcnRfc2NzaShzcmJfdCAqc3ApCiAJCWdvdG8gcXVldWluZ19l
cnJvcjsKIAogCS8qIE1hcCB0aGUgc2cgdGFibGUgc28gd2UgaGF2ZSBhbiBhY2N1cmF0ZSBjb3Vu
dCBvZiBzZyBlbnRyaWVzIG5lZWRlZCAqLwotCW5zZWcgPSBzY3NpX2RtYV9tYXAoY21kKTsKLQlp
ZiAobnNlZyA8IDApCisJaWYgKHNjc2lfc2dfY291bnQoY21kKSkgeworCQluc2VnID0gZG1hX21h
cF9zZygmaGEtPnBkZXYtPmRldiwgc2NzaV9zZ2xpc3QoY21kKSwKKwkJICAgIHNjc2lfc2dfY291
bnQoY21kKSwgY21kLT5zY19kYXRhX2RpcmVjdGlvbik7CisJCWlmICh1bmxpa2VseSghbnNlZykp
CiAJCQlnb3RvIHF1ZXVpbmdfZXJyb3I7CisJfSBlbHNlCisJCW5zZWcgPSAwOworCiAJdG90X2Rz
ZHMgPSBuc2VnOwogCiAJcmVxX2NudCA9IHFsYTI0eHhfY2FsY19pb2Nicyh0b3RfZHNkcyk7CkBA
IC03NTAsNiArNzYxLDcgQEAgcWxhMjR4eF9zdGFydF9zY3NpKHNyYl90ICpzcCkKIAljbWRfcGt0
LT5wb3J0X2lkWzBdID0gc3AtPmZjcG9ydC0+ZF9pZC5iLmFsX3BhOwogCWNtZF9wa3QtPnBvcnRf
aWRbMV0gPSBzcC0+ZmNwb3J0LT5kX2lkLmIuYXJlYTsKIAljbWRfcGt0LT5wb3J0X2lkWzJdID0g
c3AtPmZjcG9ydC0+ZF9pZC5iLmRvbWFpbjsKKwljbWRfcGt0LT52cF9pbmRleCA9IHNwLT5mY3Bv
cnQtPnZwX2lkeDsKIAogCWludF90b19zY3NpbHVuKHNwLT5jbWQtPmRldmljZS0+bHVuLCAmY21k
X3BrdC0+bHVuKTsKIAlob3N0X3RvX2ZjcF9zd2FwKCh1aW50OF90ICopJmNtZF9wa3QtPmx1biwg
c2l6ZW9mKGNtZF9wa3QtPmx1bikpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2lzci5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jCmluZGV4IDZjZTUzMmMu
LjBiYTRjOGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYworKysg
Yi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMKQEAgLTksNyArOSw2IEBACiAjaW5jbHVk
ZSA8c2NzaS9zY3NpX3RjcS5oPgogCiBzdGF0aWMgdm9pZCBxbGEyeDAwX21ieF9jb21wbGV0aW9u
KHNjc2lfcWxhX2hvc3RfdCAqLCB1aW50MTZfdCk7Ci1zdGF0aWMgdm9pZCBxbGEyeDAwX2FzeW5j
X2V2ZW50KHNjc2lfcWxhX2hvc3RfdCAqLCB1aW50MTZfdCAqKTsKIHN0YXRpYyB2b2lkIHFsYTJ4
MDBfcHJvY2Vzc19jb21wbGV0ZWRfcmVxdWVzdChzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqLCB1aW50
MzJfdCk7CiBzdGF0aWMgdm9pZCBxbGEyeDAwX3N0YXR1c19lbnRyeShzY3NpX3FsYV9ob3N0X3Qg
Kiwgdm9pZCAqKTsKIHN0YXRpYyB2b2lkIHFsYTJ4MDBfc3RhdHVzX2NvbnRfZW50cnkoc2NzaV9x
bGFfaG9zdF90ICosIHN0c19jb250X2VudHJ5X3QgKik7CkBAIC0yNDQsNyArMjQzLDcgQEAgcWxh
MngwMF9tYnhfY29tcGxldGlvbihzY3NpX3FsYV9ob3N0X3QgKmhhLCB1aW50MTZfdCBtYjApCiAg
KiBAaGE6IFNDU0kgZHJpdmVyIEhBIGNvbnRleHQKICAqIEBtYjogTWFpbGJveCByZWdpc3RlcnMg
KDAgLSAzKQogICovCi1zdGF0aWMgdm9pZAordm9pZAogcWxhMngwMF9hc3luY19ldmVudChzY3Np
X3FsYV9ob3N0X3QgKmhhLCB1aW50MTZfdCAqbWIpCiB7CiAjZGVmaW5lIExTX1VOS05PV04JMgpA
QCAtMzg2LDYgKzM4NSwxMSBAQCBxbGEyeDAwX2FzeW5jX2V2ZW50KHNjc2lfcWxhX2hvc3RfdCAq
aGEsIHVpbnQxNl90ICptYikKIAkJCXFsYTJ4MDBfbWFya19hbGxfZGV2aWNlc19sb3N0KGhhLCAx
KTsKIAkJfQogCisJCWlmIChoYS0+cGFyZW50KSB7CisJCQlhdG9taWNfc2V0KCZoYS0+dnBfc3Rh
dGUsIFZQX0ZBSUxFRCk7CisJCQlmY192cG9ydF9zZXRfc3RhdGUoaGEtPmZjX3Zwb3J0LCBGQ19W
UE9SVF9GQUlMRUQpOworCQl9CisKIAkJc2V0X2JpdChSRUdJU1RFUl9GQzRfTkVFREVELCAmaGEt
PmRwY19mbGFncyk7CiAKIAkJaGEtPmZsYWdzLm1hbmFnZW1lbnRfc2VydmVyX2xvZ2dlZF9pbiA9
IDA7CkBAIC00MjIsNiArNDI2LDExIEBAIHFsYTJ4MDBfYXN5bmNfZXZlbnQoc2NzaV9xbGFfaG9z
dF90ICpoYSwgdWludDE2X3QgKm1iKQogCQkJcWxhMngwMF9tYXJrX2FsbF9kZXZpY2VzX2xvc3Qo
aGEsIDEpOwogCQl9CiAKKwkJaWYgKGhhLT5wYXJlbnQpIHsKKwkJCWF0b21pY19zZXQoJmhhLT52
cF9zdGF0ZSwgVlBfRkFJTEVEKTsKKwkJCWZjX3Zwb3J0X3NldF9zdGF0ZShoYS0+ZmNfdnBvcnQs
IEZDX1ZQT1JUX0ZBSUxFRCk7CisJCX0KKwogCQloYS0+ZmxhZ3MubWFuYWdlbWVudF9zZXJ2ZXJf
bG9nZ2VkX2luID0gMDsKIAkJaGEtPmxpbmtfZGF0YV9yYXRlID0gUE9SVF9TUEVFRF9VTktOT1dO
OwogCQlpZiAocWwyeGZkbWllbmFibGUpCkBAIC00NDAsNiArNDQ5LDExIEBAIHFsYTJ4MDBfYXN5
bmNfZXZlbnQoc2NzaV9xbGFfaG9zdF90ICpoYSwgdWludDE2X3QgKm1iKQogCQkJcWxhMngwMF9t
YXJrX2FsbF9kZXZpY2VzX2xvc3QoaGEsIDEpOwogCQl9CiAKKwkJaWYgKGhhLT5wYXJlbnQpIHsK
KwkJCWF0b21pY19zZXQoJmhhLT52cF9zdGF0ZSwgVlBfRkFJTEVEKTsKKwkJCWZjX3Zwb3J0X3Nl
dF9zdGF0ZShoYS0+ZmNfdnBvcnQsIEZDX1ZQT1JUX0ZBSUxFRCk7CisJCX0KKwogCQlzZXRfYml0
KFJFU0VUX01BUktFUl9ORUVERUQsICZoYS0+ZHBjX2ZsYWdzKTsKIAogCQloYS0+b3BlcmF0aW5n
X21vZGUgPSBMT09QOwpAQCAtNDY1LDYgKzQ3OSwxMSBAQCBxbGEyeDAwX2FzeW5jX2V2ZW50KHNj
c2lfcWxhX2hvc3RfdCAqaGEsIHVpbnQxNl90ICptYikKIAkJCXFsYTJ4MDBfbWFya19hbGxfZGV2
aWNlc19sb3N0KGhhLCAxKTsKIAkJfQogCisJCWlmIChoYS0+cGFyZW50KSB7CisJCQlhdG9taWNf
c2V0KCZoYS0+dnBfc3RhdGUsIFZQX0ZBSUxFRCk7CisJCQlmY192cG9ydF9zZXRfc3RhdGUoaGEt
PmZjX3Zwb3J0LCBGQ19WUE9SVF9GQUlMRUQpOworCQl9CisKIAkJaWYgKCEodGVzdF9iaXQoQUJP
UlRfSVNQX0FDVElWRSwgJmhhLT5kcGNfZmxhZ3MpKSkgewogCQkJc2V0X2JpdChSRVNFVF9NQVJL
RVJfTkVFREVELCAmaGEtPmRwY19mbGFncyk7CiAJCX0KQEAgLTQ5MSw2ICs1MTAsMTEgQEAgcWxh
MngwMF9hc3luY19ldmVudChzY3NpX3FsYV9ob3N0X3QgKmhhLCB1aW50MTZfdCAqbWIpCiAJCQlx
bGEyeDAwX21hcmtfYWxsX2RldmljZXNfbG9zdChoYSwgMSk7CiAJCX0KIAorCQlpZiAoaGEtPnBh
cmVudCkgeworCQkJYXRvbWljX3NldCgmaGEtPnZwX3N0YXRlLCBWUF9GQUlMRUQpOworCQkJZmNf
dnBvcnRfc2V0X3N0YXRlKGhhLT5mY192cG9ydCwgRkNfVlBPUlRfRkFJTEVEKTsKKwkJfQorCiAJ
CXNldF9iaXQoTE9PUF9SRVNZTkNfTkVFREVELCAmaGEtPmRwY19mbGFncyk7CiAJCXNldF9iaXQo
TE9DQUxfTE9PUF9VUERBVEUsICZoYS0+ZHBjX2ZsYWdzKTsKIAkJYnJlYWs7CkBAIC01MzAsNiAr
NTU0LDEwIEBAIHFsYTJ4MDBfYXN5bmNfZXZlbnQoc2NzaV9xbGFfaG9zdF90ICpoYSwgdWludDE2
X3QgKm1iKQogCQlicmVhazsKIAogCWNhc2UgTUJBX1JTQ05fVVBEQVRFOgkJLyogU3RhdGUgQ2hh
bmdlIFJlZ2lzdHJhdGlvbiAqLworCQkvKiBDaGVjayBpZiB0aGUgVnBvcnQgaGFzIGlzc3VlZCBh
IFNDUiAqLworCQlpZiAoaGEtPnBhcmVudCAmJiB0ZXN0X2JpdChWUF9TQ1JfTkVFREVELCAmaGEt
PnZwX2ZsYWdzKSkKKwkJCWJyZWFrOworCiAJCURFQlVHMihwcmludGsoInNjc2koJWxkKTogQXN5
bmNocm9ub3VzIFJTQ1IgVVBEQVRFLlxuIiwKIAkJICAgIGhhLT5ob3N0X25vKSk7CiAJCURFQlVH
KHByaW50ayhLRVJOX0lORk8KQEAgLTU4OSw2ICs2MTcsOSBAQCBxbGEyeDAwX2FzeW5jX2V2ZW50
KHNjc2lfcWxhX2hvc3RfdCAqaGEsIHVpbnQxNl90ICptYikKIAkJaGEtPmhvc3Rfbm8sIG1iWzFd
LCBtYlsyXSkpOwogCQlicmVhazsKIAl9CisKKwlpZiAoIWhhLT5wYXJlbnQgJiYgaGEtPm51bV92
aG9zdHMpCisJCXFsYTJ4MDBfYWxlcnRfYWxsX3ZwcyhoYSwgbWIpOwogfQogCiBzdGF0aWMgdm9p
ZApAQCAtMTM5Myw2ICsxNDI0LDEwIEBAIHFsYTI0eHhfcHJvY2Vzc19yZXNwb25zZV9xdWV1ZShz
dHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqaGEpCiAJCWNhc2UgTVNfSU9DQl9UWVBFOgogCQkJcWxhMjR4
eF9tc19lbnRyeShoYSwgKHN0cnVjdCBjdF9lbnRyeV8yNHh4ICopcGt0KTsKIAkJCWJyZWFrOwor
CQljYXNlIFZQX1JQVF9JRF9JT0NCX1RZUEU6CisJCQlxbGEyNHh4X3JlcG9ydF9pZF9hY3F1aXNp
dGlvbihoYSwKKwkJCSAgICAoc3RydWN0IHZwX3JwdF9pZF9lbnRyeV8yNHh4ICopcGt0KTsKKwkJ
CWJyZWFrOwogCQlkZWZhdWx0OgogCQkJLyogVHlwZSBOb3QgU3VwcG9ydGVkLiAqLwogCQkJREVC
VUc0KHByaW50ayhLRVJOX1dBUk5JTkcKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9tYnguYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9tYnguYwppbmRleCA3MWUzMmEy
Li5lZTJhYjg1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbWJ4LmMKKysr
IGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21ieC5jCkBAIC00MiwyNSArNDIsMjkgQEAgcWxh
MngwMF9tYnhfc2VtX3RpbWVvdXQodW5zaWduZWQgbG9uZyBkYXRhKQogICoJS2VybmVsIGNvbnRl
eHQuCiAgKi8KIHN0YXRpYyBpbnQKLXFsYTJ4MDBfbWFpbGJveF9jb21tYW5kKHNjc2lfcWxhX2hv
c3RfdCAqaGEsIG1ieF9jbWRfdCAqbWNwKQorcWxhMngwMF9tYWlsYm94X2NvbW1hbmQoc2NzaV9x
bGFfaG9zdF90ICpwdmhhLCBtYnhfY21kX3QgKm1jcCkKIHsKIAlpbnQJCXJ2YWw7CiAJdW5zaWdu
ZWQgbG9uZyAgICBmbGFncyA9IDA7Ci0JZGV2aWNlX3JlZ190IF9faW9tZW0gKnJlZyA9IGhhLT5p
b2Jhc2U7CisJZGV2aWNlX3JlZ190IF9faW9tZW0gKnJlZzsKIAlzdHJ1Y3QgdGltZXJfbGlzdAl0
bXBfaW50cl90aW1lcjsKIAl1aW50OF90CQlhYm9ydF9hY3RpdmU7Ci0JdWludDhfdAkJaW9fbG9j
a19vbiA9IGhhLT5mbGFncy5pbml0X2RvbmU7CisJdWludDhfdAkJaW9fbG9ja19vbjsKIAl1aW50
MTZfdAljb21tYW5kOwogCXVpbnQxNl90CSppcHRyOwogCXVpbnQxNl90IF9faW9tZW0gKm9wdHI7
CiAJdWludDMyX3QJY250OwogCXVpbnQzMl90CW1ib3hlczsKIAl1bnNpZ25lZCBsb25nCXdhaXRf
dGltZTsKKwlzY3NpX3FsYV9ob3N0X3QgKmhhID0gdG9fcWxhX3BhcmVudChwdmhhKTsKKworCXJl
ZyA9IGhhLT5pb2Jhc2U7CisJaW9fbG9ja19vbiA9IGhhLT5mbGFncy5pbml0X2RvbmU7CiAKIAly
dmFsID0gUUxBX1NVQ0NFU1M7CiAJYWJvcnRfYWN0aXZlID0gdGVzdF9iaXQoQUJPUlRfSVNQX0FD
VElWRSwgJmhhLT5kcGNfZmxhZ3MpOwogCi0JREVCVUcxMShwcmludGsoIiVzKCVsZCk6IGVudGVy
ZWQuXG4iLCBfX2Z1bmNfXywgaGEtPmhvc3Rfbm8pKTsKKwlERUJVRzExKHByaW50aygiJXMoJWxk
KTogZW50ZXJlZC5cbiIsIF9fZnVuY19fLCBwdmhhLT5ob3N0X25vKSk7CiAKIAkvKgogCSAqIFdh
aXQgZm9yIGFjdGl2ZSBtYWlsYm94IGNvbW1hbmRzIHRvIGZpbmlzaCBieSB3YWl0aW5nIGF0IG1v
c3QgdG92CkBAIC04ODksNyArODkzLDcgQEAgcWxhMngwMF9hYm9ydF90YXJnZXQoZmNfcG9ydF90
ICpmY3BvcnQpCiAgKi8KIGludAogcWxhMngwMF9nZXRfYWRhcHRlcl9pZChzY3NpX3FsYV9ob3N0
X3QgKmhhLCB1aW50MTZfdCAqaWQsIHVpbnQ4X3QgKmFsX3BhLAotICAgIHVpbnQ4X3QgKmFyZWEs
IHVpbnQ4X3QgKmRvbWFpbiwgdWludDE2X3QgKnRvcCkKKyAgICB1aW50OF90ICphcmVhLCB1aW50
OF90ICpkb21haW4sIHVpbnQxNl90ICp0b3AsIHVpbnQxNl90ICpzd19jYXApCiB7CiAJaW50IHJ2
YWw7CiAJbWJ4X2NtZF90IG1jOwpAQCAtODk5LDggKzkwMyw5IEBAIHFsYTJ4MDBfZ2V0X2FkYXB0
ZXJfaWQoc2NzaV9xbGFfaG9zdF90ICpoYSwgdWludDE2X3QgKmlkLCB1aW50OF90ICphbF9wYSwK
IAkgICAgaGEtPmhvc3Rfbm8pKTsKIAogCW1jcC0+bWJbMF0gPSBNQkNfR0VUX0FEQVBURVJfTE9P
UF9JRDsKKwltY3AtPm1iWzldID0gaGEtPnZwX2lkeDsKIAltY3AtPm91dF9tYiA9IE1CWF8wOwot
CW1jcC0+aW5fbWIgPSBNQlhfN3xNQlhfNnxNQlhfM3xNQlhfMnxNQlhfMXxNQlhfMDsKKwltY3At
PmluX21iID0gTUJYXzl8TUJYXzd8TUJYXzZ8TUJYXzN8TUJYXzJ8TUJYXzF8TUJYXzA7CiAJbWNw
LT50b3YgPSAzMDsKIAltY3AtPmZsYWdzID0gMDsKIAlydmFsID0gcWxhMngwMF9tYWlsYm94X2Nv
bW1hbmQoaGEsIG1jcCk7CkBAIC05MTMsNiArOTE4LDcgQEAgcWxhMngwMF9nZXRfYWRhcHRlcl9p
ZChzY3NpX3FsYV9ob3N0X3QgKmhhLCB1aW50MTZfdCAqaWQsIHVpbnQ4X3QgKmFsX3BhLAogCSph
cmVhID0gTVNCKG1jcC0+bWJbMl0pOwogCSpkb21haW4JPSBMU0IobWNwLT5tYlszXSk7CiAJKnRv
cCA9IG1jcC0+bWJbNl07CisJKnN3X2NhcCA9IG1jcC0+bWJbN107CiAKIAlpZiAocnZhbCAhPSBR
TEFfU1VDQ0VTUykgewogCQkvKkVNUFRZKi8KQEAgLTEwMDksNyArMTAxNSwxMSBAQCBxbGEyeDAw
X2luaXRfZmlybXdhcmUoc2NzaV9xbGFfaG9zdF90ICpoYSwgdWludDE2X3Qgc2l6ZSkKIAlERUJV
RzExKHByaW50aygicWxhMngwMF9pbml0X2Zpcm13YXJlKCVsZCk6IGVudGVyZWQuXG4iLAogCSAg
ICBoYS0+aG9zdF9ubykpOwogCi0JbWNwLT5tYlswXSA9IE1CQ19JTklUSUFMSVpFX0ZJUk1XQVJF
OworCWlmIChoYS0+ZmxhZ3MubnBpdl9zdXBwb3J0ZWQpCisJCW1jcC0+bWJbMF0gPSBNQkNfTUlE
X0lOSVRJQUxJWkVfRklSTVdBUkU7CisJZWxzZQorCQltY3AtPm1iWzBdID0gTUJDX0lOSVRJQUxJ
WkVfRklSTVdBUkU7CisKIAltY3AtPm1iWzJdID0gTVNXKGhhLT5pbml0X2NiX2RtYSk7CiAJbWNw
LT5tYlszXSA9IExTVyhoYS0+aW5pdF9jYl9kbWEpOwogCW1jcC0+bWJbNF0gPSAwOwpAQCAtMTA4
MSw3ICsxMDkxLDggQEAgcWxhMngwMF9nZXRfcG9ydF9kYXRhYmFzZShzY3NpX3FsYV9ob3N0X3Qg
KmhhLCBmY19wb3J0X3QgKmZjcG9ydCwgdWludDhfdCBvcHQpCiAJbWNwLT5tYlszXSA9IExTVyhw
ZF9kbWEpOwogCW1jcC0+bWJbNl0gPSBNU1coTVNEKHBkX2RtYSkpOwogCW1jcC0+bWJbN10gPSBM
U1coTVNEKHBkX2RtYSkpOwotCW1jcC0+b3V0X21iID0gTUJYXzd8TUJYXzZ8TUJYXzN8TUJYXzJ8
TUJYXzA7CisJbWNwLT5tYls5XSA9IGhhLT52cF9pZHg7CisJbWNwLT5vdXRfbWIgPSBNQlhfOXxN
QlhfN3xNQlhfNnxNQlhfM3xNQlhfMnxNQlhfMDsKIAltY3AtPmluX21iID0gTUJYXzA7CiAJaWYg
KElTX1FMQTI0WFgoaGEpIHx8IElTX1FMQTU0WFgoaGEpKSB7CiAJCW1jcC0+bWJbMV0gPSBmY3Bv
cnQtPmxvb3BfaWQ7CkBAIC0xMjU5LDcgKzEyNzAsOCBAQCBxbGEyeDAwX2dldF9wb3J0X25hbWUo
c2NzaV9xbGFfaG9zdF90ICpoYSwgdWludDE2X3QgbG9vcF9pZCwgdWludDhfdCAqbmFtZSwKIAkg
ICAgaGEtPmhvc3Rfbm8pKTsKIAogCW1jcC0+bWJbMF0gPSBNQkNfR0VUX1BPUlRfTkFNRTsKLQlt
Y3AtPm91dF9tYiA9IE1CWF8xfE1CWF8wOworCW1jcC0+bWJbOV0gPSBoYS0+dnBfaWR4OworCW1j
cC0+b3V0X21iID0gTUJYXzl8TUJYXzF8TUJYXzA7CiAJaWYgKEhBU19FWFRFTkRFRF9JRFMoaGEp
KSB7CiAJCW1jcC0+bWJbMV0gPSBsb29wX2lkOwogCQltY3AtPm1iWzEwXSA9IG9wdDsKQEAgLTE0
NDcsNiArMTQ1OSw3IEBAIHFsYTI0eHhfbG9naW5fZmFicmljKHNjc2lfcWxhX2hvc3RfdCAqaGEs
IHVpbnQxNl90IGxvb3BfaWQsIHVpbnQ4X3QgZG9tYWluLAogCWxnLT5wb3J0X2lkWzBdID0gYWxf
cGE7CiAJbGctPnBvcnRfaWRbMV0gPSBhcmVhOwogCWxnLT5wb3J0X2lkWzJdID0gZG9tYWluOwor
CWxnLT52cF9pbmRleCA9IGNwdV90b19sZTE2KGhhLT52cF9pZHgpOwogCXJ2YWwgPSBxbGEyeDAw
X2lzc3VlX2lvY2IoaGEsIGxnLCBsZ19kbWEsIDApOwogCWlmIChydmFsICE9IFFMQV9TVUNDRVNT
KSB7CiAJCURFQlVHMl8zXzExKHByaW50aygiJXMoJWxkKTogZmFpbGVkIHRvIGlzc3VlIExvZ2lu
IElPQ0IgIgpAQCAtMTcwMSw2ICsxNzE0LDcgQEAgcWxhMjR4eF9mYWJyaWNfbG9nb3V0KHNjc2lf
cWxhX2hvc3RfdCAqaGEsIHVpbnQxNl90IGxvb3BfaWQsIHVpbnQ4X3QgZG9tYWluLAogCWxnLT5w
b3J0X2lkWzBdID0gYWxfcGE7CiAJbGctPnBvcnRfaWRbMV0gPSBhcmVhOwogCWxnLT5wb3J0X2lk
WzJdID0gZG9tYWluOworCWxnLT52cF9pbmRleCA9IGNwdV90b19sZTE2KGhhLT52cF9pZHgpOwog
CXJ2YWwgPSBxbGEyeDAwX2lzc3VlX2lvY2IoaGEsIGxnLCBsZ19kbWEsIDApOwogCWlmIChydmFs
ICE9IFFMQV9TVUNDRVNTKSB7CiAJCURFQlVHMl8zXzExKHByaW50aygiJXMoJWxkKTogZmFpbGVk
IHRvIGlzc3VlIExvZ291dCBJT0NCICIKQEAgLTE4NjMsNyArMTg3Nyw4IEBAIHFsYTJ4MDBfZ2V0
X2lkX2xpc3Qoc2NzaV9xbGFfaG9zdF90ICpoYSwgdm9pZCAqaWRfbGlzdCwgZG1hX2FkZHJfdCBp
ZF9saXN0X2RtYSwKIAkJbWNwLT5tYls2XSA9IE1TVyhNU0QoaWRfbGlzdF9kbWEpKTsKIAkJbWNw
LT5tYls3XSA9IExTVyhNU0QoaWRfbGlzdF9kbWEpKTsKIAkJbWNwLT5tYls4XSA9IDA7Ci0JCW1j
cC0+b3V0X21iIHw9IE1CWF84fE1CWF83fE1CWF82fE1CWF8zfE1CWF8yOworCQltY3AtPm1iWzld
ID0gaGEtPnZwX2lkeDsKKwkJbWNwLT5vdXRfbWIgfD0gTUJYXzl8TUJYXzh8TUJYXzd8TUJYXzZ8
TUJYXzN8TUJYXzI7CiAJfSBlbHNlIHsKIAkJbWNwLT5tYlsxXSA9IE1TVyhpZF9saXN0X2RtYSk7
CiAJCW1jcC0+bWJbMl0gPSBMU1coaWRfbGlzdF9kbWEpOwpAQCAtMjIxMiw2ICsyMjI3LDcgQEAg
cWxhMjR4eF9hYm9ydF9jb21tYW5kKHNjc2lfcWxhX2hvc3RfdCAqaGEsIHNyYl90ICpzcCkKIAlh
YnQtPnBvcnRfaWRbMF0gPSBmY3BvcnQtPmRfaWQuYi5hbF9wYTsKIAlhYnQtPnBvcnRfaWRbMV0g
PSBmY3BvcnQtPmRfaWQuYi5hcmVhOwogCWFidC0+cG9ydF9pZFsyXSA9IGZjcG9ydC0+ZF9pZC5i
LmRvbWFpbjsKKwlhYnQtPnZwX2luZGV4ID0gZmNwb3J0LT52cF9pZHg7CiAJcnZhbCA9IHFsYTJ4
MDBfaXNzdWVfaW9jYihoYSwgYWJ0LCBhYnRfZG1hLCAwKTsKIAlpZiAocnZhbCAhPSBRTEFfU1VD
Q0VTUykgewogCQlERUJVRzJfM18xMShwcmludGsoIiVzKCVsZCk6IGZhaWxlZCB0byBpc3N1ZSBJ
T0NCICgleCkuXG4iLApAQCAtMjI0OSw3ICsyMjY1LDcgQEAgcWxhMjR4eF9hYm9ydF90YXJnZXQo
ZmNfcG9ydF90ICpmY3BvcnQpCiAJaW50CQlydmFsOwogCXN0cnVjdCB0c2tfbWdtdF9jbWQgKnRz
azsKIAlkbWFfYWRkcl90CXRza19kbWE7Ci0Jc2NzaV9xbGFfaG9zdF90ICpoYTsKKwlzY3NpX3Fs
YV9ob3N0X3QgKmhhLCAqcGhhOwogCiAJaWYgKGZjcG9ydCA9PSBOVUxMKQogCQlyZXR1cm4gMDsK
QEAgLTIyNTcsNyArMjI3Myw4IEBAIHFsYTI0eHhfYWJvcnRfdGFyZ2V0KGZjX3BvcnRfdCAqZmNw
b3J0KQogCURFQlVHMTEocHJpbnRrKCIlcyglbGQpOiBlbnRlcmVkLlxuIiwgX19mdW5jX18sIGZj
cG9ydC0+aGEtPmhvc3Rfbm8pKTsKIAogCWhhID0gZmNwb3J0LT5oYTsKLQl0c2sgPSBkbWFfcG9v
bF9hbGxvYyhoYS0+c19kbWFfcG9vbCwgR0ZQX0tFUk5FTCwgJnRza19kbWEpOworCXBoYSA9IHRv
X3FsYV9wYXJlbnQoaGEpOworCXRzayA9IGRtYV9wb29sX2FsbG9jKHBoYS0+c19kbWFfcG9vbCwg
R0ZQX0tFUk5FTCwgJnRza19kbWEpOwogCWlmICh0c2sgPT0gTlVMTCkgewogCQlERUJVRzJfMyhw
cmludGsoIiVzKCVsZCk6IGZhaWxlZCB0byBhbGxvY2F0ZSBUYXNrIE1hbmFnZW1lbnQgIgogCQkg
ICAgIklPQ0IuXG4iLCBfX2Z1bmNfXywgaGEtPmhvc3Rfbm8pKTsKQEAgLTIyNzMsNiArMjI5MCw4
IEBAIHFsYTI0eHhfYWJvcnRfdGFyZ2V0KGZjX3BvcnRfdCAqZmNwb3J0KQogCXRzay0+cC50c2su
cG9ydF9pZFswXSA9IGZjcG9ydC0+ZF9pZC5iLmFsX3BhOwogCXRzay0+cC50c2sucG9ydF9pZFsx
XSA9IGZjcG9ydC0+ZF9pZC5iLmFyZWE7CiAJdHNrLT5wLnRzay5wb3J0X2lkWzJdID0gZmNwb3J0
LT5kX2lkLmIuZG9tYWluOworCXRzay0+cC50c2sudnBfaW5kZXggPSBmY3BvcnQtPnZwX2lkeDsK
KwogCXJ2YWwgPSBxbGEyeDAwX2lzc3VlX2lvY2IoaGEsIHRzaywgdHNrX2RtYSwgMCk7CiAJaWYg
KHJ2YWwgIT0gUUxBX1NVQ0NFU1MpIHsKIAkJREVCVUcyXzNfMTEocHJpbnRrKCIlcyglbGQpOiBm
YWlsZWQgdG8gaXNzdWUgVGFyZ2V0IFJlc2V0IElPQ0IgIgpAQCAtMjMwMyw3ICsyMzIyLDcgQEAg
cWxhMjR4eF9hYm9ydF90YXJnZXQoZmNfcG9ydF90ICpmY3BvcnQpCiAJfQogCiBhdGFyZ2V0X2Rv
bmU6Ci0JZG1hX3Bvb2xfZnJlZShoYS0+c19kbWFfcG9vbCwgdHNrLCB0c2tfZG1hKTsKKwlkbWFf
cG9vbF9mcmVlKHBoYS0+c19kbWFfcG9vbCwgdHNrLCB0c2tfZG1hKTsKIAogCXJldHVybiBydmFs
OwogfQpAQCAtMjYxMCwzICsyNjI5LDM1NCBAQCBxbGEyeDAwX3NldF9pZG1hX3NwZWVkKHNjc2lf
cWxhX2hvc3RfdCAqaGEsIHVpbnQxNl90IGxvb3BfaWQsCiAKIAlyZXR1cm4gcnZhbDsKIH0KKwor
LyoKKyAqIHFsYTI0eHhfZ2V0X3ZwX2RhdGFiYXNlCisgKglHZXQgdGhlIFZQJ3MgZGF0YWJhc2Ug
Zm9yIGFsbCBjb25maWd1cmVkIHBvcnRzLgorICoKKyAqIElucHV0OgorICoJaGEgPSBhZGFwdGVy
IGJsb2NrIHBvaW50ZXIuCisgKglzaXplID0gc2l6ZSBvZiBpbml0aWFsaXphdGlvbiBjb250cm9s
IGJsb2NrLgorICoKKyAqIFJldHVybnM6CisgKglxbGEyeDAwIGxvY2FsIGZ1bmN0aW9uIHJldHVy
biBzdGF0dXMgY29kZS4KKyAqCisgKiBDb250ZXh0OgorICoJS2VybmVsIGNvbnRleHQuCisgKi8K
K2ludAorcWxhMjR4eF9nZXRfdnBfZGF0YWJhc2Uoc2NzaV9xbGFfaG9zdF90ICpoYSwgdWludDE2
X3Qgc2l6ZSkKK3sKKwlpbnQgcnZhbDsKKwltYnhfY21kX3QgbWM7CisJbWJ4X2NtZF90ICptY3Ag
PSAmbWM7CisKKwlERUJVRzExKHByaW50aygic2NzaSglbGQpOiVzIC0gZW50ZXJlZC5cbiIsCisJ
ICAgIGhhLT5ob3N0X25vLCBfX2Z1bmNfXykpOworCisJbWNwLT5tYlswXSA9IE1CQ19NSURfR0VU
X1ZQX0RBVEFCQVNFOworCW1jcC0+bWJbMl0gPSBNU1coaGEtPmluaXRfY2JfZG1hKTsKKwltY3At
Pm1iWzNdID0gTFNXKGhhLT5pbml0X2NiX2RtYSk7CisJbWNwLT5tYls0XSA9IDA7CisJbWNwLT5t
Yls1XSA9IDA7CisJbWNwLT5tYls2XSA9IE1TVyhNU0QoaGEtPmluaXRfY2JfZG1hKSk7CisJbWNw
LT5tYls3XSA9IExTVyhNU0QoaGEtPmluaXRfY2JfZG1hKSk7CisJbWNwLT5vdXRfbWIgPSBNQlhf
N3xNQlhfNnxNQlhfM3xNQlhfMnxNQlhfMDsKKwltY3AtPmluX21iID0gTUJYXzF8TUJYXzA7CisJ
bWNwLT5idWZfc2l6ZSA9IHNpemU7CisJbWNwLT5mbGFncyA9IE1CWF9ETUFfT1VUOworCW1jcC0+
dG92ID0gTUJYX1RPVl9TRUNPTkRTOworCXJ2YWwgPSBxbGEyeDAwX21haWxib3hfY29tbWFuZCho
YSwgbWNwKTsKKworCWlmIChydmFsICE9IFFMQV9TVUNDRVNTKSB7CisJCS8qRU1QVFkqLworCQlE
RUJVRzJfM18xMShwcmludGsoIiVzKCVsZCk6IGZhaWxlZD0leCAiCisJCSAgICAibWIwPSV4Llxu
IiwKKwkJICAgIF9fZnVuY19fLCBoYS0+aG9zdF9ubywgcnZhbCwgbWNwLT5tYlswXSkpOworCX0g
ZWxzZSB7CisJCS8qRU1QVFkqLworCQlERUJVRzExKHByaW50aygiJXMoJWxkKTogZG9uZS5cbiIs
CisJCSAgICBfX2Z1bmNfXywgaGEtPmhvc3Rfbm8pKTsKKwl9CisKKwlyZXR1cm4gcnZhbDsKK30K
KworaW50CitxbGEyNHh4X2dldF92cF9lbnRyeShzY3NpX3FsYV9ob3N0X3QgKmhhLCB1aW50MTZf
dCBzaXplLCBpbnQgdnBfaWQpCit7CisJaW50IHJ2YWw7CisJbWJ4X2NtZF90IG1jOworCW1ieF9j
bWRfdCAqbWNwID0gJm1jOworCisJREVCVUcxMShwcmludGsoIiVzKCVsZCk6IGVudGVyZWQuXG4i
LCBfX2Z1bmNfXywgaGEtPmhvc3Rfbm8pKTsKKworCW1jcC0+bWJbMF0gPSBNQkNfTUlEX0dFVF9W
UF9FTlRSWTsKKwltY3AtPm1iWzJdID0gTVNXKGhhLT5pbml0X2NiX2RtYSk7CisJbWNwLT5tYlsz
XSA9IExTVyhoYS0+aW5pdF9jYl9kbWEpOworCW1jcC0+bWJbNF0gPSAwOworCW1jcC0+bWJbNV0g
PSAwOworCW1jcC0+bWJbNl0gPSBNU1coTVNEKGhhLT5pbml0X2NiX2RtYSkpOworCW1jcC0+bWJb
N10gPSBMU1coTVNEKGhhLT5pbml0X2NiX2RtYSkpOworCW1jcC0+bWJbOV0gPSB2cF9pZDsKKwlt
Y3AtPm91dF9tYiA9IE1CWF85fE1CWF83fE1CWF82fE1CWF8zfE1CWF8yfE1CWF8wOworCW1jcC0+
aW5fbWIgPSBNQlhfMDsKKwltY3AtPmJ1Zl9zaXplID0gc2l6ZTsKKwltY3AtPmZsYWdzID0gTUJY
X0RNQV9PVVQ7CisJbWNwLT50b3YgPSAzMDsKKwlydmFsID0gcWxhMngwMF9tYWlsYm94X2NvbW1h
bmQoaGEsIG1jcCk7CisKKwlpZiAocnZhbCAhPSBRTEFfU1VDQ0VTUykgeworCQkvKkVNUFRZKi8K
KwkJREVCVUcyXzNfMTEocHJpbnRrKCJxbGEyNHh4X2dldF92cF9lbnRyeSglbGQpOiBmYWlsZWQ9
JXggIgorCQkgICAgIm1iMD0leC5cbiIsCisJCSAgICBoYS0+aG9zdF9ubywgcnZhbCwgbWNwLT5t
YlswXSkpOworCX0gZWxzZSB7CisJCS8qRU1QVFkqLworCQlERUJVRzExKHByaW50aygicWxhMjR4
eF9nZXRfdnBfZW50cnkoJWxkKTogZG9uZS5cbiIsCisJCSAgICBoYS0+aG9zdF9ubykpOworCX0K
KworCXJldHVybiBydmFsOworfQorCit2b2lkCitxbGEyNHh4X3JlcG9ydF9pZF9hY3F1aXNpdGlv
bihzY3NpX3FsYV9ob3N0X3QgKmhhLAorCXN0cnVjdCB2cF9ycHRfaWRfZW50cnlfMjR4eCAqcnB0
aWRfZW50cnkpCit7CisJdWludDhfdCB2cF9pZHg7CisJc2NzaV9xbGFfaG9zdF90ICp2aGE7CisK
KwlpZiAocnB0aWRfZW50cnktPmVudHJ5X3N0YXR1cyAhPSAwKQorCQlyZXR1cm47CisJaWYgKHJw
dGlkX2VudHJ5LT5lbnRyeV9zdGF0dXMgIT0gX19jb25zdGFudF9jcHVfdG9fbGUxNihDU19DT01Q
TEVURSkpCisJCXJldHVybjsKKworCWlmIChycHRpZF9lbnRyeS0+Zm9ybWF0ID09IDApIHsKKwkJ
REVCVUcxNShwcmludGsoIiVzOmZvcm1hdCAwIDogc2NzaSglbGQpIG51bWJlciBvZiBWUHMgc2V0
dXAgJWQsIgorCQkJIiBudW1iZXIgb2YgVlBzIGFjcXVpcmVkICVkXG4iLCBfX2Z1bmNfXywgaGEt
Pmhvc3Rfbm8sCisJCQlNU0IocnB0aWRfZW50cnktPnZwX2NvdW50KSwgTFNCKHJwdGlkX2VudHJ5
LT52cF9jb3VudCkpKTsKKwkJREVCVUcxNShwcmludGsoIiVzIHByaW1hcnkgcG9ydCBpZCAlMDJ4
JTAyeCUwMnhcbiIsIF9fZnVuY19fLAorCQkJcnB0aWRfZW50cnktPnBvcnRfaWRbMl0sIHJwdGlk
X2VudHJ5LT5wb3J0X2lkWzFdLAorCQkJcnB0aWRfZW50cnktPnBvcnRfaWRbMF0pKTsKKwl9IGVs
c2UgaWYgKHJwdGlkX2VudHJ5LT5mb3JtYXQgPT0gMSkgeworCQl2cF9pZHggPSBMU0IocnB0aWRf
ZW50cnktPnZwX2lkeCk7CisJCURFQlVHMTUocHJpbnRrKCIlczpmb3JtYXQgMTogc2NzaSglbGQp
OiBWUFslZF0gZW5hYmxlZCAiCisJCSAgICAiLSBzdGF0dXMgJWQgLSAiCisJCSAgICAid2l0aCBw
b3J0IGlkICUwMnglMDJ4JTAyeFxuIixfX2Z1bmNfXyxoYS0+aG9zdF9ubywKKwkJICAgIHZwX2lk
eCwgTVNCKHJwdGlkX2VudHJ5LT52cF9pZHgpLAorCQkgICAgcnB0aWRfZW50cnktPnBvcnRfaWRb
Ml0sIHJwdGlkX2VudHJ5LT5wb3J0X2lkWzFdLAorCQkgICAgcnB0aWRfZW50cnktPnBvcnRfaWRb
MF0pKTsKKwkJaWYgKHZwX2lkeCA9PSAwKQorCQkJcmV0dXJuOworCisJCWlmIChNU0IocnB0aWRf
ZW50cnktPnZwX2lkeCkgPT0gMSkKKwkJCXJldHVybjsKKworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5
KHZoYSwgJmhhLT52cF9saXN0LCB2cF9saXN0KQorCQkJaWYgKHZwX2lkeCA9PSB2aGEtPnZwX2lk
eCkKKwkJCQlicmVhazsKKworCQlpZiAoIXZoYSkKKwkJCXJldHVybjsKKworCQl2aGEtPmRfaWQu
Yi5kb21haW4gPSBycHRpZF9lbnRyeS0+cG9ydF9pZFsyXTsKKwkJdmhhLT5kX2lkLmIuYXJlYSA9
ICBycHRpZF9lbnRyeS0+cG9ydF9pZFsxXTsKKwkJdmhhLT5kX2lkLmIuYWxfcGEgPSBycHRpZF9l
bnRyeS0+cG9ydF9pZFswXTsKKworCQkvKgorCQkgKiBDYW5ub3QgY29uZmlndXJlIGhlcmUgYXMg
d2UgYXJlIHN0aWxsIHNpdHRpbmcgb24gdGhlCisJCSAqIHJlc3BvbnNlIHF1ZXVlLiBIYW5kbGUg
aXQgaW4gZHBjIGNvbnRleHQuCisJCSAqLworCQlzZXRfYml0KFZQX0lEWF9BQ1FVSVJFRCwgJnZo
YS0+dnBfZmxhZ3MpOworCSAgICAJc2V0X2JpdChWUF9EUENfTkVFREVELCAmaGEtPmRwY19mbGFn
cyk7CisKKwkJd2FrZV91cF9wcm9jZXNzKGhhLT5kcGNfdGhyZWFkKTsKKwl9Cit9CisKKy8qCisg
KiBxbGEyNHh4X21vZGlmeV92cF9jb25maWcKKyAqCUNoYW5nZSBWUCBjb25maWd1cmF0aW9uIGZv
ciB2aGEKKyAqCisgKiBJbnB1dDoKKyAqCXZoYSA9IGFkYXB0ZXIgYmxvY2sgcG9pbnRlci4KKyAq
CisgKiBSZXR1cm5zOgorICoJcWxhMnh4eCBsb2NhbCBmdW5jdGlvbiByZXR1cm4gc3RhdHVzIGNv
ZGUuCisgKgorICogQ29udGV4dDoKKyAqCUtlcm5lbCBjb250ZXh0LgorICovCitpbnQKK3FsYTI0
eHhfbW9kaWZ5X3ZwX2NvbmZpZyhzY3NpX3FsYV9ob3N0X3QgKnZoYSkKK3sKKwlpbnQJCXJ2YWw7
CisJc3RydWN0IHZwX2NvbmZpZ19lbnRyeV8yNHh4ICp2cG1vZDsKKwlkbWFfYWRkcl90CXZwbW9k
X2RtYTsKKwlzY3NpX3FsYV9ob3N0X3QgKnBoYTsKKworCS8qIFRoaXMgY2FuIGJlIGNhbGxlZCBi
eSB0aGUgcGFyZW50ICovCisJcGhhID0gdG9fcWxhX3BhcmVudCh2aGEpOworCisJdnBtb2QgPSBk
bWFfcG9vbF9hbGxvYyhwaGEtPnNfZG1hX3Bvb2wsIEdGUF9LRVJORUwsICZ2cG1vZF9kbWEpOwor
CWlmICghdnBtb2QpIHsKKwkJREVCVUcyXzMocHJpbnRrKCIlcyglbGQpOiBmYWlsZWQgdG8gYWxs
b2NhdGUgTW9kaWZ5IFZQICIKKwkJICAgICJJT0NCLlxuIiwgX19mdW5jX18sIHBoYS0+aG9zdF9u
bykpOworCQlyZXR1cm4gUUxBX01FTU9SWV9BTExPQ19GQUlMRUQ7CisJfQorCisJbWVtc2V0KHZw
bW9kLCAwLCBzaXplb2Yoc3RydWN0IHZwX2NvbmZpZ19lbnRyeV8yNHh4KSk7CisJdnBtb2QtPmVu
dHJ5X3R5cGUgPSBWUF9DT05GSUdfSU9DQl9UWVBFOworCXZwbW9kLT5lbnRyeV9jb3VudCA9IDE7
CisJdnBtb2QtPmNvbW1hbmQgPSBWQ1RfQ09NTUFORF9NT0RfRU5BQkxFX1ZQUzsKKwl2cG1vZC0+
dnBfY291bnQgPSAxOworCXZwbW9kLT52cF9pbmRleDEgPSB2aGEtPnZwX2lkeDsKKwl2cG1vZC0+
b3B0aW9uc19pZHgxID0gQklUXzN8QklUXzR8QklUXzU7CisJbWVtY3B5KHZwbW9kLT5ub2RlX25h
bWVfaWR4MSwgdmhhLT5ub2RlX25hbWUsIFdXTl9TSVpFKTsKKwltZW1jcHkodnBtb2QtPnBvcnRf
bmFtZV9pZHgxLCB2aGEtPnBvcnRfbmFtZSwgV1dOX1NJWkUpOworCXZwbW9kLT5lbnRyeV9jb3Vu
dCA9IDE7CisKKwlydmFsID0gcWxhMngwMF9pc3N1ZV9pb2NiKHBoYSwgdnBtb2QsIHZwbW9kX2Rt
YSwgMCk7CisJaWYgKHJ2YWwgIT0gUUxBX1NVQ0NFU1MpIHsKKwkJREVCVUcyXzNfMTEocHJpbnRr
KCIlcyglbGQpOiBmYWlsZWQgdG8gaXNzdWUgVlAgY29uZmlnIElPQ0IiCisJCQkiKCV4KS5cbiIs
IF9fZnVuY19fLCBwaGEtPmhvc3Rfbm8sIHJ2YWwpKTsKKwl9IGVsc2UgaWYgKHZwbW9kLT5jb21w
X3N0YXR1cyAhPSAwKSB7CisJCURFQlVHMl8zXzExKHByaW50aygiJXMoJWxkKTogZmFpbGVkIHRv
IGNvbXBsZXRlIElPQ0IgIgorCQkJIi0tIGVycm9yIHN0YXR1cyAoJXgpLlxuIiwgX19mdW5jX18s
IHBoYS0+aG9zdF9ubywKKwkJCXZwbW9kLT5jb21wX3N0YXR1cykpOworCQlydmFsID0gUUxBX0ZV
TkNUSU9OX0ZBSUxFRDsKKwl9IGVsc2UgaWYgKHZwbW9kLT5jb21wX3N0YXR1cyAhPSBfX2NvbnN0
YW50X2NwdV90b19sZTE2KENTX0NPTVBMRVRFKSkgeworCQlERUJVRzJfM18xMShwcmludGsoIiVz
KCVsZCk6IGZhaWxlZCB0byBjb21wbGV0ZSBJT0NCICIKKwkJICAgICItLSBjb21wbGV0aW9uIHN0
YXR1cyAoJXgpLlxuIiwgX19mdW5jX18sIHBoYS0+aG9zdF9ubywKKwkJICAgIGxlMTZfdG9fY3B1
KHZwbW9kLT5jb21wX3N0YXR1cykpKTsKKwkJcnZhbCA9IFFMQV9GVU5DVElPTl9GQUlMRUQ7CisJ
fSBlbHNlIHsKKwkJLyogRU1QVFkgKi8KKwkJREVCVUcxMShwcmludGsoIiVzKCVsZCk6IGRvbmUu
XG4iLCBfX2Z1bmNfXywgcGhhLT5ob3N0X25vKSk7CisJCWZjX3Zwb3J0X3NldF9zdGF0ZSh2aGEt
PmZjX3Zwb3J0LCBGQ19WUE9SVF9JTklUSUFMSVpJTkcpOworCX0KKwlkbWFfcG9vbF9mcmVlKHBo
YS0+c19kbWFfcG9vbCwgdnBtb2QsIHZwbW9kX2RtYSk7CisKKwlyZXR1cm4gcnZhbDsKK30KKwor
LyoKKyAqIHFsYTI0eHhfY29udHJvbF92cAorICoJRW5hYmxlIGEgdmlydHVhbCBwb3J0IGZvciBn
aXZlbiBob3N0CisgKgorICogSW5wdXQ6CisgKgloYSA9IGFkYXB0ZXIgYmxvY2sgcG9pbnRlci4K
KyAqCXZoYmEgPSB2aXJ0dWFsIGFkYXB0ZXIgKHVudXNlZCkKKyAqCWluZGV4ID0gaW5kZXggbnVt
YmVyIGZvciBlbmFibGVkIFZQCisgKgorICogUmV0dXJuczoKKyAqCXFsYTJ4eHggbG9jYWwgZnVu
Y3Rpb24gcmV0dXJuIHN0YXR1cyBjb2RlLgorICoKKyAqIENvbnRleHQ6CisgKglLZXJuZWwgY29u
dGV4dC4KKyAqLworaW50CitxbGEyNHh4X2NvbnRyb2xfdnAoc2NzaV9xbGFfaG9zdF90ICp2aGEs
IGludCBjbWQpCit7CisJaW50CQlydmFsOworCWludAkJbWFwLCBwb3M7CisJc3RydWN0IHZwX2N0
cmxfZW50cnlfMjR4eCAgICp2Y2U7CisJZG1hX2FkZHJfdAl2Y2VfZG1hOworCXNjc2lfcWxhX2hv
c3RfdCAqaGEgPSB2aGEtPnBhcmVudDsKKwlpbnQJdnBfaW5kZXggPSB2aGEtPnZwX2lkeDsKKwor
CURFQlVHMTEocHJpbnRrKCIlcyglbGQpOiBlbnRlcmVkLiBFbmFibGluZyBpbmRleCAlZFxuIiwg
X19mdW5jX18sCisJICAgIGhhLT5ob3N0X25vLCB2cF9pbmRleCkpOworCisJaWYgKHZwX2luZGV4
ID09IDAgfHwgdnBfaW5kZXggPj0gTUFYX01VTFRJX0lEX0xPT1ApCisJCXJldHVybiBRTEFfUEFS
QU1FVEVSX0VSUk9SOworCisJdmNlID0gZG1hX3Bvb2xfYWxsb2MoaGEtPnNfZG1hX3Bvb2wsIEdG
UF9LRVJORUwsICZ2Y2VfZG1hKTsKKwlpZiAoIXZjZSkgeworCQlERUJVRzJfMyhwcmludGsoIiVz
KCVsZCk6ICIKKwkJICAgICJmYWlsZWQgdG8gYWxsb2NhdGUgVlAgQ29udHJvbCBJT0NCLlxuIiwg
X19mdW5jX18sCisJCSAgICBoYS0+aG9zdF9ubykpOworCQlyZXR1cm4gUUxBX01FTU9SWV9BTExP
Q19GQUlMRUQ7CisJfQorCW1lbXNldCh2Y2UsIDAsIHNpemVvZihzdHJ1Y3QgdnBfY3RybF9lbnRy
eV8yNHh4KSk7CisKKwl2Y2UtPmVudHJ5X3R5cGUgPSBWUF9DVFJMX0lPQ0JfVFlQRTsKKwl2Y2Ut
PmVudHJ5X2NvdW50ID0gMTsKKwl2Y2UtPmNvbW1hbmQgPSBjcHVfdG9fbGUxNihjbWQpOworCXZj
ZS0+dnBfY291bnQgPSBfX2NvbnN0YW50X2NwdV90b19sZTE2KDEpOworCisJLyogaW5kZXggbWFw
IGluIGZpcm13YXJlIHN0YXJ0cyB3aXRoIDE7IGRlY3JlbWVudCBpbmRleAorCSAqIHRoaXMgaXMg
b2sgYXMgd2UgbmV2ZXIgdXNlIGluZGV4IDAKKwkgKi8KKwltYXAgPSAodnBfaW5kZXggLSAxKSAv
IDg7CisJcG9zID0gKHZwX2luZGV4IC0gMSkgJiA3OworCWRvd24oJmhhLT52cG9ydF9zZW0pOwor
CXZjZS0+dnBfaWR4X21hcFttYXBdIHw9IDEgPDwgcG9zOworCXVwKCZoYS0+dnBvcnRfc2VtKTsK
KworCXJ2YWwgPSBxbGEyeDAwX2lzc3VlX2lvY2IoaGEsIHZjZSwgdmNlX2RtYSwgMCk7CisJaWYg
KHJ2YWwgIT0gUUxBX1NVQ0NFU1MpIHsKKwkJREVCVUcyXzNfMTEocHJpbnRrKCIlcyglbGQpOiBm
YWlsZWQgdG8gaXNzdWUgVlAgY29udHJvbCBJT0NCIgorCQkgICAgIigleCkuXG4iLCBfX2Z1bmNf
XywgaGEtPmhvc3Rfbm8sIHJ2YWwpKTsKKwkJcHJpbnRrKCIlcyglbGQpOiBmYWlsZWQgdG8gaXNz
dWUgVlAgY29udHJvbCBJT0NCIgorCQkgICAgIigleCkuXG4iLCBfX2Z1bmNfXywgaGEtPmhvc3Rf
bm8sIHJ2YWwpOworCX0gZWxzZSBpZiAodmNlLT5lbnRyeV9zdGF0dXMgIT0gMCkgeworCQlERUJV
RzJfM18xMShwcmludGsoIiVzKCVsZCk6IGZhaWxlZCB0byBjb21wbGV0ZSBJT0NCICIKKwkJICAg
ICItLSBlcnJvciBzdGF0dXMgKCV4KS5cbiIsIF9fZnVuY19fLCBoYS0+aG9zdF9ubywKKwkJICAg
IHZjZS0+ZW50cnlfc3RhdHVzKSk7CisJCXByaW50aygiJXMoJWxkKTogZmFpbGVkIHRvIGNvbXBs
ZXRlIElPQ0IgIgorCQkgICAgIi0tIGVycm9yIHN0YXR1cyAoJXgpLlxuIiwgX19mdW5jX18sIGhh
LT5ob3N0X25vLAorCQkgICAgdmNlLT5lbnRyeV9zdGF0dXMpOworCQlydmFsID0gUUxBX0ZVTkNU
SU9OX0ZBSUxFRDsKKwl9IGVsc2UgaWYgKHZjZS0+Y29tcF9zdGF0dXMgIT0gX19jb25zdGFudF9j
cHVfdG9fbGUxNihDU19DT01QTEVURSkpIHsKKwkJREVCVUcyXzNfMTEocHJpbnRrKCIlcyglbGQp
OiBmYWlsZWQgdG8gY29tcGxldGUgSU9DQiAiCisJCSAgICAiLS0gY29tcGxldGlvbiBzdGF0dXMg
KCV4KS5cbiIsIF9fZnVuY19fLCBoYS0+aG9zdF9ubywKKwkJICAgIGxlMTZfdG9fY3B1KHZjZS0+
Y29tcF9zdGF0dXMpKSk7CisJCXByaW50aygiJXMoJWxkKTogZmFpbGVkIHRvIGNvbXBsZXRlIElP
Q0IgIgorCQkgICAgIi0tIGNvbXBsZXRpb24gc3RhdHVzICgleCkuXG4iLCBfX2Z1bmNfXywgaGEt
Pmhvc3Rfbm8sCisJCSAgICBsZTE2X3RvX2NwdSh2Y2UtPmNvbXBfc3RhdHVzKSk7CisJCXJ2YWwg
PSBRTEFfRlVOQ1RJT05fRkFJTEVEOworCX0gZWxzZSB7CisJCURFQlVHMihwcmludGsoIiVzKCVs
ZCk6IGRvbmUuXG4iLCBfX2Z1bmNfXywgaGEtPmhvc3Rfbm8pKTsKKwl9CisKKwlkbWFfcG9vbF9m
cmVlKGhhLT5zX2RtYV9wb29sLCB2Y2UsIHZjZV9kbWEpOworCisJcmV0dXJuIHJ2YWw7Cit9CisK
Ky8qCisgKiBxbGEyeDAwX3NlbmRfY2hhbmdlX3JlcXVlc3QKKyAqCVJlY2VpdmUgb3IgZGlzYWJs
ZSBSU0NOIHJlcXVlc3QgZnJvbSBmYWJyaWMgY29udHJvbGxlcgorICoKKyAqIElucHV0OgorICoJ
aGEgPSBhZGFwdGVyIGJsb2NrIHBvaW50ZXIKKyAqCWZvcm1hdCA9IHJlZ2lzdHJhdGlvbiBmb3Jt
YXQ6CisgKgkJMCAtIFJlc2VydmVkCisgKgkJMSAtIEZhYnJpYyBkZXRlY3RlZCByZWdpc3RyYXRp
b24KKyAqCQkyIC0gTl9wb3J0IGRldGVjdGVkIHJlZ2lzdHJhdGlvbgorICoJCTMgLSBGdWxsIHJl
Z2lzdHJhdGlvbgorICoJCUZGIC0gY2xlYXIgcmVnaXN0cmF0aW9uCisgKgl2cF9pZHggPSBWaXJ0
dWFsIHBvcnQgaW5kZXgKKyAqCisgKiBSZXR1cm5zOgorICoJcWxhMngwMCBsb2NhbCBmdW5jdGlv
biByZXR1cm4gc3RhdHVzIGNvZGUuCisgKgorICogQ29udGV4dDoKKyAqCUtlcm5lbCBDb250ZXh0
CisgKi8KKworaW50CitxbGEyeDAwX3NlbmRfY2hhbmdlX3JlcXVlc3Qoc2NzaV9xbGFfaG9zdF90
ICpoYSwgdWludDE2X3QgZm9ybWF0LAorCQkJICAgIHVpbnQxNl90IHZwX2lkeCkKK3sKKwlpbnQg
cnZhbDsKKwltYnhfY21kX3QgbWM7CisJbWJ4X2NtZF90ICptY3AgPSAmbWM7CisKKwkvKgorCSAq
IFRoaXMgY29tbWFuZCBpcyBpbXBsaWNpdGx5IGV4ZWN1dGVkIGJ5IGZpcm13YXJlIGR1cmluZyBs
b2dpbiBmb3IgdGhlCisJICogcGh5c2ljYWwgaG9zdHMKKwkgKi8KKwlpZiAodnBfaWR4ID09IDAp
CisJCXJldHVybiBRTEFfRlVOQ1RJT05fRkFJTEVEOworCisJbWNwLT5tYlswXSA9IE1CQ19TRU5E
X0NIQU5HRV9SRVFVRVNUOworCW1jcC0+bWJbMV0gPSBmb3JtYXQ7CisJbWNwLT5tYls5XSA9IHZw
X2lkeDsKKwltY3AtPm91dF9tYiA9IE1CWF85fE1CWF8xfE1CWF8wOworCW1jcC0+aW5fbWIgPSBN
QlhfMHxNQlhfMTsKKwltY3AtPnRvdiA9IE1CWF9UT1ZfU0VDT05EUzsKKwltY3AtPmZsYWdzID0g
MDsKKwlydmFsID0gcWxhMngwMF9tYWlsYm94X2NvbW1hbmQoaGEsIG1jcCk7CisKKwlpZiAocnZh
bCA9PSBRTEFfU1VDQ0VTUykgeworCQlpZiAobWNwLT5tYlswXSAhPSBNQlNfQ09NTUFORF9DT01Q
TEVURSkgeworCQkJcnZhbCA9IEJJVF8xOworCQl9CisJfSBlbHNlCisJCXJ2YWwgPSBCSVRfMTsK
KworCXJldHVybiBydmFsOworfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X21pZC5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21pZC5jCm5ldyBmaWxlIG1vZGUgMTAw
NjQ0CmluZGV4IDAwMDAwMDAuLjhlMGM1N2IKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfbWlkLmMKQEAgLTAsMCArMSw0OTcgQEAKKy8qCisgKiAgICAgICAgICAg
ICAgICAgIFFMT0dJQyBMSU5VWCBTT0ZUV0FSRQorICoKKyAqIFFMb2dpYyBJU1AyeDAwIGRldmlj
ZSBkcml2ZXIgZm9yIExpbnV4IDIuNi54CisgKiBDb3B5cmlnaHQgKEMpIDIwMDMtMjAwNSBRTG9n
aWMgQ29ycG9yYXRpb24KKyAqICh3d3cucWxvZ2ljLmNvbSkKKyAqCisgKiBUaGlzIHByb2dyYW0g
aXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeSBp
dAorICogdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBh
cyBwdWJsaXNoZWQgYnkgdGhlCisgKiBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2
ZXJzaW9uIDIsIG9yIChhdCB5b3VyIG9wdGlvbikgYW55CisgKiBsYXRlciB2ZXJzaW9uLgorICoK
KyAqIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwg
YmUgdXNlZnVsLCBidXQKKyAqIFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhl
IGltcGxpZWQgd2FycmFudHkgb2YKKyAqIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBB
IFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUgR05VCisgKiBHZW5lcmFsIFB1YmxpYyBMaWNl
bnNlIGZvciBtb3JlIGRldGFpbHMuCisgKgorICovCisjaW5jbHVkZSAicWxhX2RlZi5oIgorCisj
aW5jbHVkZSA8bGludXgvdmVyc2lvbi5oPgorI2luY2x1ZGUgPGxpbnV4L21vZHVsZXBhcmFtLmg+
CisjaW5jbHVkZSA8bGludXgvdm1hbGxvYy5oPgorI2luY2x1ZGUgPGxpbnV4L3NtcF9sb2NrLmg+
CisjaW5jbHVkZSA8bGludXgvbGlzdC5oPgorCisjaW5jbHVkZSA8c2NzaS9zY3NpX3RjcS5oPgor
I2luY2x1ZGUgPHNjc2kvc2NzaWNhbS5oPgorI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+CisKK3Zv
aWQgcWxhMngwMF92cF9zdG9wX3RpbWVyKHNjc2lfcWxhX2hvc3RfdCAqKTsKKwordm9pZAorcWxh
MngwMF92cF9zdG9wX3RpbWVyKHNjc2lfcWxhX2hvc3RfdCAqdmhhKQoreworCWlmICh2aGEtPnBh
cmVudCAmJiB2aGEtPnRpbWVyX2FjdGl2ZSkgeworCQlkZWxfdGltZXJfc3luYygmdmhhLT50aW1l
cik7CisJCXZoYS0+dGltZXJfYWN0aXZlID0gMDsKKwl9Cit9CisKK3VpbnQzMl90CitxbGEyNHh4
X2FsbG9jYXRlX3ZwX2lkKHNjc2lfcWxhX2hvc3RfdCAqdmhhKQoreworCXVpbnQzMl90IHZwX2lk
OworCXNjc2lfcWxhX2hvc3RfdCAqaGEgPSB2aGEtPnBhcmVudDsKKworCS8qIEZpbmQgYW4gZW1w
dHkgc2xvdCBhbmQgYXNzaWduIGFuIHZwX2lkICovCisJZG93bigmaGEtPnZwb3J0X3NlbSk7CisJ
dnBfaWQgPSBmaW5kX2ZpcnN0X3plcm9fYml0KCh1bnNpZ25lZCBsb25nICopaGEtPnZwX2lkeF9t
YXAsCisJCQkJTUFYX01VTFRJX0lEX0ZBQlJJQyk7CisJaWYgKHZwX2lkID4gTUFYX01VTFRJX0lE
X0ZBQlJJQykgeworCQlERUJVRzE1KHByaW50ayAoInZwX2lkICVkIGlzIGJpZ2dlciB0aGFuIE1B
WF9NVUxUSV9JRF9GQUJSSURcbiIsCisJCSAgICB2cF9pZCkpOworCQl1cCgmaGEtPnZwb3J0X3Nl
bSk7CisJCXJldHVybiB2cF9pZDsKKwl9CisKKwlzZXRfYml0KHZwX2lkLCAodW5zaWduZWQgbG9u
ZyAqKWhhLT52cF9pZHhfbWFwKTsKKwloYS0+bnVtX3Zob3N0cysrOworCXZoYS0+dnBfaWR4ID0g
dnBfaWQ7CisJbGlzdF9hZGRfdGFpbCgmdmhhLT52cF9saXN0LCAmaGEtPnZwX2xpc3QpOworCXVw
KCZoYS0+dnBvcnRfc2VtKTsKKwlyZXR1cm4gdnBfaWQ7Cit9CisKK3ZvaWQKK3FsYTI0eHhfZGVh
bGxvY2F0ZV92cF9pZChzY3NpX3FsYV9ob3N0X3QgKnZoYSkKK3sKKwl1aW50MTZfdCB2cF9pZDsK
KwlzY3NpX3FsYV9ob3N0X3QgKmhhID0gdmhhLT5wYXJlbnQ7CisKKwlkb3duKCZoYS0+dnBvcnRf
c2VtKTsKKwl2cF9pZCA9IHZoYS0+dnBfaWR4OworCWhhLT5udW1fdmhvc3RzLS07CisJY2xlYXJf
Yml0KHZwX2lkLCAodW5zaWduZWQgbG9uZyAqKWhhLT52cF9pZHhfbWFwKTsKKwlsaXN0X2RlbCgm
dmhhLT52cF9saXN0KTsKKwl1cCgmaGEtPnZwb3J0X3NlbSk7Cit9CisKK3Njc2lfcWxhX2hvc3Rf
dCAqCitxbGEyNHh4X2ZpbmRfdmhvc3RfYnlfbmFtZShzY3NpX3FsYV9ob3N0X3QgKmhhLCB1aW50
OF90ICpwb3J0X25hbWUpCit7CisJc2NzaV9xbGFfaG9zdF90ICp2aGE7CisKKwkvKiBMb2NhdGUg
bWF0Y2hpbmcgZGV2aWNlIGluIGRhdGFiYXNlLiAqLworCWxpc3RfZm9yX2VhY2hfZW50cnkodmhh
LCAmaGEtPnZwX2xpc3QsIHZwX2xpc3QpIHsKKwkJaWYgKCFtZW1jbXAocG9ydF9uYW1lLCB2aGEt
PnBvcnRfbmFtZSwgV1dOX1NJWkUpKQorCQkJcmV0dXJuIHZoYTsKKwl9CisJcmV0dXJuIE5VTEw7
Cit9CisKKy8qCisgKiBxbGEyeDAwX21hcmtfdnBfZGV2aWNlc19kZWFkCisgKglVcGRhdGVzIGZj
cG9ydCBzdGF0ZSB3aGVuIGRldmljZSBnb2VzIG9mZmxpbmUuCisgKgorICogSW5wdXQ6CisgKglo
YSA9IGFkYXB0ZXIgYmxvY2sgcG9pbnRlci4KKyAqCWZjcG9ydCA9IHBvcnQgc3RydWN0dXJlIHBv
aW50ZXIuCisgKgorICogUmV0dXJuOgorICoJTm9uZS4KKyAqCisgKiBDb250ZXh0OgorICovCit2
b2lkCitxbGEyeDAwX21hcmtfdnBfZGV2aWNlc19kZWFkKHNjc2lfcWxhX2hvc3RfdCAqdmhhKQor
eworCWZjX3BvcnRfdCAqZmNwb3J0OworCXNjc2lfcWxhX2hvc3RfdCAqcGhhID0gdG9fcWxhX3Bh
cmVudCh2aGEpOworCisJbGlzdF9mb3JfZWFjaF9lbnRyeShmY3BvcnQsICZwaGEtPmZjcG9ydHMs
IGxpc3QpIHsKKwkJaWYgKGZjcG9ydC0+dnBfaWR4ICE9IHZoYS0+dnBfaWR4KQorCQkJY29udGlu
dWU7CisKKwkJREVCVUcxNShwcmludGsoInNjc2koJWxkKTogTWFya2luZyBwb3J0IGRlYWQsICIK
KwkJICAgICJsb29wX2lkPTB4JTA0eCA6JXhcbiIsCisJCSAgICB2aGEtPmhvc3Rfbm8sIGZjcG9y
dC0+bG9vcF9pZCwgZmNwb3J0LT52cF9pZHgpKTsKKworCQlhdG9taWNfc2V0KCZmY3BvcnQtPnN0
YXRlLCBGQ1NfREVWSUNFX0RFQUQpOworCQlxbGEyeDAwX21hcmtfZGV2aWNlX2xvc3QodmhhLCBm
Y3BvcnQsIDAsIDApOworCX0KK30KKworaW50CitxbGEyNHh4X2Rpc2FibGVfdnAoc2NzaV9xbGFf
aG9zdF90ICp2aGEpCit7CisJaW50IHJldDsKKworCXJldCA9IHFsYTI0eHhfY29udHJvbF92cCh2
aGEsIFZDRV9DT01NQU5EX0RJU0FCTEVfVlBTX0xPR09fQUxMKTsKKwlhdG9taWNfc2V0KCZ2aGEt
Pmxvb3Bfc3RhdGUsIExPT1BfRE9XTik7CisJYXRvbWljX3NldCgmdmhhLT5sb29wX2Rvd25fdGlt
ZXIsIExPT1BfRE9XTl9USU1FKTsKKworCS8qIERlbGV0ZSBhbGwgdnAncyBmY3BvcnRzIGZyb20g
cGFyZW50J3MgbGlzdCAqLworCXFsYTJ4MDBfbWFya192cF9kZXZpY2VzX2RlYWQodmhhKTsKKwlh
dG9taWNfc2V0KCZ2aGEtPnZwX3N0YXRlLCBWUF9GQUlMRUQpOworCXZoYS0+ZmxhZ3MubWFuYWdl
bWVudF9zZXJ2ZXJfbG9nZ2VkX2luID0gMDsKKwlpZiAocmV0ID09IFFMQV9TVUNDRVNTKSB7CisJ
CWZjX3Zwb3J0X3NldF9zdGF0ZSh2aGEtPmZjX3Zwb3J0LCBGQ19WUE9SVF9ESVNBQkxFRCk7CisJ
fSBlbHNlIHsKKwkJZmNfdnBvcnRfc2V0X3N0YXRlKHZoYS0+ZmNfdnBvcnQsIEZDX1ZQT1JUX0ZB
SUxFRCk7CisJCXJldHVybiAtMTsKKwl9CisJcmV0dXJuIDA7Cit9CisKK2ludAorcWxhMjR4eF9l
bmFibGVfdnAoc2NzaV9xbGFfaG9zdF90ICp2aGEpCit7CisJaW50IHJldDsKKwlzY3NpX3FsYV9o
b3N0X3QgKmhhID0gdmhhLT5wYXJlbnQ7CisKKwkvKiBDaGVjayBpZiBwaHlzaWNhbCBoYSBwb3J0
IGlzIFVwICovCisJaWYgKGF0b21pY19yZWFkKCZoYS0+bG9vcF9zdGF0ZSkgPT0gTE9PUF9ET1dO
ICB8fAorCQlhdG9taWNfcmVhZCgmaGEtPmxvb3Bfc3RhdGUpID09IExPT1BfREVBRCApIHsKKwkJ
dmhhLT52cF9lcnJfc3RhdGUgPSAgVlBfRVJSX1BPUlREV047CisJCWZjX3Zwb3J0X3NldF9zdGF0
ZSh2aGEtPmZjX3Zwb3J0LCBGQ19WUE9SVF9MSU5LRE9XTik7CisJCWdvdG8gZW5hYmxlX2ZhaWxl
ZDsKKwl9CisKKwkvKiBJbml0aWFsaXplIHRoZSBuZXcgdnBvcnQgdW5sZXNzIGl0IGlzIGEgcGVy
c2lzdGVudCBwb3J0ICovCisJZG93bigmaGEtPnZwb3J0X3NlbSk7CisJcmV0ID0gcWxhMjR4eF9t
b2RpZnlfdnBfY29uZmlnKHZoYSk7CisJdXAoJmhhLT52cG9ydF9zZW0pOworCisJaWYgKHJldCAh
PSBRTEFfU1VDQ0VTUykgeworCQlmY192cG9ydF9zZXRfc3RhdGUodmhhLT5mY192cG9ydCwgRkNf
VlBPUlRfRkFJTEVEKTsKKwkJZ290byBlbmFibGVfZmFpbGVkOworCX0KKworCURFQlVHMTUocWxh
X3ByaW50ayhLRVJOX0lORk8sIGhhLAorCSAgICAiVmlydHVhbCBwb3J0IHdpdGggaWQ6ICVkIC0g
RW5hYmxlZFxuIiwgdmhhLT52cF9pZHgpKTsKKwlyZXR1cm4gMDsKKworZW5hYmxlX2ZhaWxlZDoK
KwlERUJVRzE1KHFsYV9wcmludGsoS0VSTl9JTkZPLCBoYSwKKwkgICAgIlZpcnR1YWwgcG9ydCB3
aXRoIGlkOiAlZCAtIERpc2FibGVkXG4iLCB2aGEtPnZwX2lkeCkpOworCXJldHVybiAxOworfQor
CisvKioKKyAqIHFsYTI0eHhfbW9kaWZ5X3Zwb3J0KCkgLSAgTW9kaWZpZXMgdGhlIHZpcnR1YWwg
ZmFicmljIHBvcnQncyBjb25maWd1cmF0aW9uCisgKiBAaGE6IEhBIGNvbnRleHQKKyAqIEB2cDog
cG9pbnRlciB0byBidWZmZXIgb2YgdmlydHVhbCBwb3J0IHBhcmFtZXRlcnMuCisgKiBAcmV0X2Nv
ZGU6IHJldHVybiBlcnJvciBjb2RlOgorICoKKyAqIFJldHVybnMgdGhlIHZpcnR1YWwgcG9ydCBp
ZCwgb3IgTUFYX1ZTQU5fSUQsIGlmIGNvdWxkbid0IGNyZWF0ZS4KKyAqLwordWludDMyX3QKK3Fs
YTI0eHhfbW9kaWZ5X3ZoYmEoc2NzaV9xbGFfaG9zdF90ICpoYSwgdnBvcnRfcGFyYW1zX3QgKnZw
LCB1aW50MzJfdCAqdnBfaWQpCit7CisJc2NzaV9xbGFfaG9zdF90ICp2aGE7CisKKwl2aGEgPSBx
bGEyNHh4X2ZpbmRfdmhvc3RfYnlfbmFtZShoYSwgdnAtPnBvcnRfbmFtZSk7CisJaWYgKCF2aGEp
IHsKKwkJKnZwX2lkID0gTUFYX05VTV9WUE9SVF9MT09QOworCQlyZXR1cm4gVlBfUkVUX0NPREVf
V1dQTjsKKwl9CisKKwlpZiAocWxhMjR4eF9lbmFibGVfdnAodmhhKSkgeworCQlzY3NpX2hvc3Rf
cHV0KHZoYS0+aG9zdCk7CisJCXFsYTJ4MDBfbWVtX2ZyZWUodmhhKTsKKwkJKnZwX2lkID0gTUFY
X05VTV9WUE9SVF9MT09QOworCQlyZXR1cm4gVlBfUkVUX0NPREVfUkVTT1VSQ0VTOworCX0KKwor
CSp2cF9pZCA9IHZoYS0+dnBfaWR4OworCXJldHVybiBWUF9SRVRfQ09ERV9PSzsKK30KKwordm9p
ZAorcWxhMjR4eF9jb25maWd1cmVfdnAoc2NzaV9xbGFfaG9zdF90ICp2aGEpCit7CisJc3RydWN0
IGZjX3Zwb3J0ICpmY192cG9ydDsKKwlpbnQgcmV0OworCisJZmNfdnBvcnQgPSB2aGEtPmZjX3Zw
b3J0OworCisJREVCVUcxNShwcmludGsoInNjc2koJWxkKTogJXM6IGNoYW5nZSByZXF1ZXN0ICMz
IGZvciB0aGlzIGhvc3QuXG4iLAorCSAgICB2aGEtPmhvc3Rfbm8sIF9fZnVuY19fKSk7CisJcmV0
ID0gcWxhMngwMF9zZW5kX2NoYW5nZV9yZXF1ZXN0KHZoYSwgMHgzLCB2aGEtPnZwX2lkeCk7CisJ
aWYgKHJldCAhPSBRTEFfU1VDQ0VTUykgeworCQlERUJVRzE1KHFsYV9wcmludGsoS0VSTl9FUlIs
IHZoYSwgIkZhaWxlZCB0byBlbmFibGUgcmVjZWl2aW5nIgorCQkgICAgIiBvZiBSU0NOIHJlcXVl
c3RzOiAweCV4XG4iLCByZXQpKTsKKwkJcmV0dXJuOworCX0gZWxzZSB7CisJCS8qIENvcnJlc3Bv
bmRzIHRvIFNDUiBlbmFibGVkICovCisJCWNsZWFyX2JpdChWUF9TQ1JfTkVFREVELCAmdmhhLT52
cF9mbGFncyk7CisJfQorCisJdmhhLT5mbGFncy5vbmxpbmUgPSAxOworCWlmIChxbGEyNHh4X2Nv
bmZpZ3VyZV92aGJhKHZoYSkpCisJCXJldHVybjsKKworCWF0b21pY19zZXQoJnZoYS0+dnBfc3Rh
dGUsIFZQX0FDVElWRSk7CisJZmNfdnBvcnRfc2V0X3N0YXRlKGZjX3Zwb3J0LCBGQ19WUE9SVF9B
Q1RJVkUpOworfQorCit2b2lkCitxbGEyeDAwX2FsZXJ0X2FsbF92cHMoc2NzaV9xbGFfaG9zdF90
ICpoYSwgdWludDE2X3QgKm1iKQoreworCWludCBpLCB2cF9pZHhfbWF0Y2hlZDsKKwlzY3NpX3Fs
YV9ob3N0X3QgKnZoYTsKKworCWlmIChoYS0+cGFyZW50KQorCQlyZXR1cm47CisKKwlpID0gZmlu
ZF9uZXh0X2JpdCgodW5zaWduZWQgbG9uZyAqKWhhLT52cF9pZHhfbWFwLAorCSAgICBNQVhfTVVM
VElfSURfRkFCUklDICsgMSwgMSk7CisJZm9yICg7aSA8PSBNQVhfTVVMVElfSURfRkFCUklDOwor
CSAgICBpID0gZmluZF9uZXh0X2JpdCgodW5zaWduZWQgbG9uZyAqKWhhLT52cF9pZHhfbWFwLAor
CSAgICBNQVhfTVVMVElfSURfRkFCUklDICsgMSwgaSArIDEpKSB7CisJCXZwX2lkeF9tYXRjaGVk
ID0gMDsKKworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KHZoYSwgJmhhLT52cF9saXN0LCB2cF9saXN0
KSB7CisJCQlpZiAoaSA9PSB2aGEtPnZwX2lkeCkgeworCQkJCXZwX2lkeF9tYXRjaGVkID0gMTsK
KwkJCQlicmVhazsKKwkJCX0KKwkJfQorCisJCWlmICh2cF9pZHhfbWF0Y2hlZCkgeworCQkJc3dp
dGNoIChtYlswXSkgeworCQkJY2FzZSBNQkFfTElQX09DQ1VSUkVEOgorCQkJY2FzZSBNQkFfTE9P
UF9VUDoKKwkJCWNhc2UgTUJBX0xPT1BfRE9XTjoKKwkJCWNhc2UgTUJBX0xJUF9SRVNFVDoKKwkJ
CWNhc2UgTUJBX1BPSU5UX1RPX1BPSU5UOgorCQkJY2FzZSBNQkFfQ0hHX0lOX0NPTk5FQ1RJT046
CisJCQljYXNlIE1CQV9QT1JUX1VQREFURToKKwkJCWNhc2UgTUJBX1JTQ05fVVBEQVRFOgorCQkJ
CURFQlVHMTUocHJpbnRrKCJzY3NpKCVsZCklczogQXN5bmNfZXZlbnQgZm9yIgorCQkJCSAgICAi
IFZQWyVkXSwgbWIgPSAweCV4LCB2aGE9JXBcbiIsCisJCQkJICAgIHZoYS0+aG9zdF9ubywgX19m
dW5jX18saSwgKm1iLCB2aGEpKTsKKwkJCQlxbGEyeDAwX2FzeW5jX2V2ZW50KHZoYSwgbWIpOwor
CQkJCWJyZWFrOworCQkJfQorCQl9CisJfQorfQorCit2b2lkCitxbGEyeDAwX3ZwX2Fib3J0X2lz
cChzY3NpX3FsYV9ob3N0X3QgKnZoYSkKK3sKKwkvKgorCSAqIFBoeXNpY2FsIHBvcnQgd2lsbCBk
byBtb3N0IG9mIHRoZSBhYm9ydCBhbmQgcmVjb3Zlcnkgd29yay4gV2UgY2FuCisJICoganVzdCB0
cmVhdCBpdCBhcyBhIGxvb3AgZG93bgorCSAqLworCWlmIChhdG9taWNfcmVhZCgmdmhhLT5sb29w
X3N0YXRlKSAhPSBMT09QX0RPV04pIHsKKwkJYXRvbWljX3NldCgmdmhhLT5sb29wX3N0YXRlLCBM
T09QX0RPV04pOworCQlxbGEyeDAwX21hcmtfYWxsX2RldmljZXNfbG9zdCh2aGEsIDApOworCX0g
ZWxzZSB7CisJCWlmICghYXRvbWljX3JlYWQoJnZoYS0+bG9vcF9kb3duX3RpbWVyKSkKKwkJCWF0
b21pY19zZXQoJnZoYS0+bG9vcF9kb3duX3RpbWVyLCBMT09QX0RPV05fVElNRSk7CisJfQorCisJ
REVCVUcxNShwcmludGsoInNjc2koJWxkKTogU2NoZWR1bGluZyBlbmFibGUgb2YgVnBvcnQgJWQu
Li5cbiIsCisJICAgIHZoYS0+aG9zdF9ubywgdmhhLT52cF9pZHgpKTsKKwlxbGEyNHh4X2VuYWJs
ZV92cCh2aGEpOworfQorCitpbnQKK3FsYTJ4MDBfZG9fZHBjX3ZwKHNjc2lfcWxhX2hvc3RfdCAq
dmhhKQoreworCWlmICh0ZXN0X2FuZF9jbGVhcl9iaXQoVlBfSURYX0FDUVVJUkVELCAmdmhhLT52
cF9mbGFncykpIHsKKwkJLyogVlAgYWNxdWlyZWQuIGNvbXBsZXRlIHBvcnQgY29uZmlndXJhdGlv
biAqLworCQlxbGEyNHh4X2NvbmZpZ3VyZV92cCh2aGEpOworCQlyZXR1cm4gMDsKKwl9CisKKwlp
ZiAodGVzdF9hbmRfY2xlYXJfYml0KElTUF9BQk9SVF9ORUVERUQsICZ2aGEtPmRwY19mbGFncykp
CisJCXFsYTJ4MDBfdnBfYWJvcnRfaXNwKHZoYSk7CisKKwlpZiAodGVzdF9hbmRfY2xlYXJfYml0
KFJFU0VUX01BUktFUl9ORUVERUQsICZ2aGEtPmRwY19mbGFncykgJiYKKwkgICAgKCEodGVzdF9h
bmRfc2V0X2JpdChSRVNFVF9BQ1RJVkUsICZ2aGEtPmRwY19mbGFncykpKSkgeworCQljbGVhcl9i
aXQoUkVTRVRfQUNUSVZFLCAmdmhhLT5kcGNfZmxhZ3MpOworCX0KKworCWlmICh0ZXN0X2FuZF9j
bGVhcl9iaXQoTE9PUF9SRVNZTkNfTkVFREVELCAmdmhhLT5kcGNfZmxhZ3MpKSB7CisJCWlmICgh
KHRlc3RfYW5kX3NldF9iaXQoTE9PUF9SRVNZTkNfQUNUSVZFLCAmdmhhLT5kcGNfZmxhZ3MpKSkg
eworCQkJcWxhMngwMF9sb29wX3Jlc3luYyh2aGEpOworCQkJY2xlYXJfYml0KExPT1BfUkVTWU5D
X0FDVElWRSwgJnZoYS0+ZHBjX2ZsYWdzKTsKKwkJfQorCX0KKworCXJldHVybiAwOworfQorCit2
b2lkCitxbGEyeDAwX2RvX2RwY19hbGxfdnBzKHNjc2lfcWxhX2hvc3RfdCAqaGEpCit7CisJaW50
IHJldDsKKwlpbnQgaSwgdnBfaWR4X21hdGNoZWQ7CisJc2NzaV9xbGFfaG9zdF90ICp2aGE7CisK
KwlpZiAoaGEtPnBhcmVudCkKKwkJcmV0dXJuOworCWlmIChsaXN0X2VtcHR5KCZoYS0+dnBfbGlz
dCkpCisJCXJldHVybjsKKworCWNsZWFyX2JpdChWUF9EUENfTkVFREVELCAmaGEtPmRwY19mbGFn
cyk7CisKKwlpID0gZmluZF9uZXh0X2JpdCgodW5zaWduZWQgbG9uZyAqKWhhLT52cF9pZHhfbWFw
LAorCSAgICBNQVhfTVVMVElfSURfRkFCUklDICsgMSwgMSk7CisJZm9yICg7aSA8PSBNQVhfTVVM
VElfSURfRkFCUklDOworCSAgICBpID0gZmluZF9uZXh0X2JpdCgodW5zaWduZWQgbG9uZyAqKWhh
LT52cF9pZHhfbWFwLAorCSAgICBNQVhfTVVMVElfSURfRkFCUklDICsgMSwgaSArIDEpKSB7CisJ
CXZwX2lkeF9tYXRjaGVkID0gMDsKKworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KHZoYSwgJmhhLT52
cF9saXN0LCB2cF9saXN0KSB7CisJCQlpZiAoaSA9PSB2aGEtPnZwX2lkeCkgeworCQkJCXZwX2lk
eF9tYXRjaGVkID0gMTsKKwkJCQlicmVhazsKKwkJCX0KKwkJfQorCisJCWlmICh2cF9pZHhfbWF0
Y2hlZCkKKwkJCXJldCA9IHFsYTJ4MDBfZG9fZHBjX3ZwKHZoYSk7CisJfQorfQorCitpbnQKK3Fs
YTI0eHhfdnBvcnRfY3JlYXRlX3JlcV9zYW5pdHlfY2hlY2soc3RydWN0IGZjX3Zwb3J0ICpmY192
cG9ydCkKK3sKKwlzY3NpX3FsYV9ob3N0X3QgKmhhID0gKHNjc2lfcWxhX2hvc3RfdCAqKSBmY192
cG9ydC0+c2hvc3QtPmhvc3RkYXRhOworCXNjc2lfcWxhX2hvc3RfdCAqdmhhOworCXVpbnQ4X3Qg
cG9ydF9uYW1lW1dXTl9TSVpFXTsKKworCWlmIChmY192cG9ydC0+cm9sZXMgIT0gRkNfUE9SVF9S
T0xFX0ZDUF9JTklUSUFUT1IpCisJCXJldHVybiBWUENFUlJfVU5TVVBQT1JURUQ7CisKKwkvKiBD
aGVjayB1cCB0aGUgRi9XIGFuZCBIL1cgc3VwcG9ydCBOUElWICovCisJaWYgKCFoYS0+ZmxhZ3Mu
bnBpdl9zdXBwb3J0ZWQpCisJCXJldHVybiBWUENFUlJfVU5TVVBQT1JURUQ7CisKKwkvKiBDaGVj
ayB1cCB3aGV0aGVyIG5waXYgc3VwcG9ydGVkIHN3aXRjaCBwcmVzZW50ZWQgKi8KKwlpZiAoISho
YS0+c3dpdGNoX2NhcCAmIEZMT0dJX01JRF9TVVBQT1JUKSkKKwkJcmV0dXJuIFZQQ0VSUl9OT19G
QUJSSUNfU1VQUDsKKworCS8qIENoZWNrIHVwIHVuaXF1ZSBXV1BOICovCisJdTY0X3RvX3d3bihm
Y192cG9ydC0+cG9ydF9uYW1lLCBwb3J0X25hbWUpOworCXZoYSA9IHFsYTI0eHhfZmluZF92aG9z
dF9ieV9uYW1lKGhhLCBwb3J0X25hbWUpOworCWlmICh2aGEpCisJCXJldHVybiBWUENFUlJfQkFE
X1dXTjsKKworCS8qIENoZWNrIHVwIG1heC1ucGl2LXN1cHBvcnRzICovCisJaWYgKGhhLT5udW1f
dmhvc3RzID4gaGEtPm1heF9ucGl2X3Zwb3J0cykgeworCQlERUJVRzE1KHByaW50aygic2NzaSgl
bGQpOiBudW1fdmhvc3RzICVkIGlzIGJpZ2dlciB0aGFuICIKKwkJICAgICJtYXhfbnB2X3Zwb3J0
cyAlZC5cbiIsIGhhLT5ob3N0X25vLAorCQkgICAgKHVpbnQxNl90KSBoYS0+bnVtX3Zob3N0cywg
KGludCkgaGEtPm1heF9ucGl2X3Zwb3J0cykpOworCQlyZXR1cm4gVlBDRVJSX1VOU1VQUE9SVEVE
OworCX0KKwlyZXR1cm4gMDsKK30KKworc2NzaV9xbGFfaG9zdF90ICoKK3FsYTI0eHhfY3JlYXRl
X3Zob3N0KHN0cnVjdCBmY192cG9ydCAqZmNfdnBvcnQpCit7CisJc2NzaV9xbGFfaG9zdF90ICpo
YSA9IChzY3NpX3FsYV9ob3N0X3QgKikgZmNfdnBvcnQtPnNob3N0LT5ob3N0ZGF0YTsKKwlzY3Np
X3FsYV9ob3N0X3QgKnZoYTsKKwlzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0OworCisJaG9zdCA9IHNj
c2lfaG9zdF9hbGxvYygmcWxhMjR4eF9kcml2ZXJfdGVtcGxhdGUsCisJICAgIHNpemVvZihzY3Np
X3FsYV9ob3N0X3QpKTsKKwlpZiAoIWhvc3QpIHsKKwkJcHJpbnRrKEtFUk5fV0FSTklORworCQkg
ICAgInFsYTJ4eHg6IHNjc2lfaG9zdF9hbGxvYygpIGZhaWxlZCBmb3IgdnBvcnRcbiIpOworCQly
ZXR1cm4oTlVMTCk7CisJfQorCisJdmhhID0gKHNjc2lfcWxhX2hvc3RfdCAqKWhvc3QtPmhvc3Rk
YXRhOworCisJLyogY2xvbmUgdGhlIHBhcmVudCBoYmEgKi8KKwltZW1jcHkodmhhLCBoYSwgc2l6
ZW9mIChzY3NpX3FsYV9ob3N0X3QpKTsKKworCWZjX3Zwb3J0LT5kZF9kYXRhID0gdmhhOworCisJ
dmhhLT5ub2RlX25hbWUgPSBrbWFsbG9jKFdXTl9TSVpFICogc2l6ZW9mKGNoYXIpLCBHRlBfS0VS
TkVMKTsKKwlpZiAoIXZoYS0+bm9kZV9uYW1lKQorCQlnb3RvIGNyZWF0ZV92aG9zdF9mYWlsZWRf
MTsKKworCXZoYS0+cG9ydF9uYW1lID0ga21hbGxvYyhXV05fU0laRSAqIHNpemVvZihjaGFyKSwg
R0ZQX0tFUk5FTCk7CisJaWYgKCF2aGEtPnBvcnRfbmFtZSkKKwkJZ290byBjcmVhdGVfdmhvc3Rf
ZmFpbGVkXzI7CisKKwkvKiBOZXcgaG9zdCBpbmZvICovCisJdTY0X3RvX3d3bihmY192cG9ydC0+
bm9kZV9uYW1lLCB2aGEtPm5vZGVfbmFtZSk7CisJdTY0X3RvX3d3bihmY192cG9ydC0+cG9ydF9u
YW1lLCB2aGEtPnBvcnRfbmFtZSk7CisKKwl2aGEtPmhvc3QgPSBob3N0OworCXZoYS0+aG9zdF9u
byA9IGhvc3QtPmhvc3Rfbm87CisJdmhhLT5wYXJlbnQgPSBoYTsKKwl2aGEtPmZjX3Zwb3J0ID0g
ZmNfdnBvcnQ7CisJdmhhLT5kZXZpY2VfZmxhZ3MgPSAwOworCXZoYS0+aW5zdGFuY2UgPSBudW1f
aG9zdHM7CisJdmhhLT52cF9pZHggPSBxbGEyNHh4X2FsbG9jYXRlX3ZwX2lkKHZoYSk7CisJaWYg
KHZoYS0+dnBfaWR4ID4gaGEtPm1heF9ucGl2X3Zwb3J0cykgeworCQlERUJVRzE1KHByaW50aygi
c2NzaSglbGQpOiBDb3VsZG4ndCBhbGxvY2F0ZSB2cF9pZC5cbiIsCisJCQl2aGEtPmhvc3Rfbm8p
KTsKKwkJZ290byBjcmVhdGVfdmhvc3RfZmFpbGVkXzM7CisJfQorCXZoYS0+bWdtdF9zdnJfbG9v
cF9pZCA9IDEwICsgdmhhLT52cF9pZHg7CisKKwlpbml0X01VVEVYKCZ2aGEtPm1ieF9jbWRfc2Vt
KTsKKwlpbml0X01VVEVYX0xPQ0tFRCgmdmhhLT5tYnhfaW50cl9zZW0pOworCisJSU5JVF9MSVNU
X0hFQUQoJnZoYS0+bGlzdCk7CisJSU5JVF9MSVNUX0hFQUQoJnZoYS0+ZmNwb3J0cyk7CisJSU5J
VF9MSVNUX0hFQUQoJnZoYS0+dnBfZmNwb3J0cyk7CisKKwl2aGEtPmRwY19mbGFncyA9IDBMOwor
CXNldF9iaXQoUkVHSVNURVJfRkRNSV9ORUVERUQsICZ2aGEtPmRwY19mbGFncyk7CisJc2V0X2Jp
dChSRUdJU1RFUl9GQzRfTkVFREVELCAmdmhhLT5kcGNfZmxhZ3MpOworCisJLyoKKwkgKiBUbyBm
aXggdGhlIGlzc3VlIG9mIHByb2Nlc3NpbmcgYSBwYXJlbnQncyBSU0NOIGZvciB0aGUgdnBvcnQg
YmVmb3JlCisJICogaXRzIFNDUiBpcyBjb21wbGV0ZS4KKwkgKi8KKwlzZXRfYml0KFZQX1NDUl9O
RUVERUQsICZ2aGEtPnZwX2ZsYWdzKTsKKwlhdG9taWNfc2V0KCZ2aGEtPmxvb3Bfc3RhdGUsIExP
T1BfRE9XTik7CisJYXRvbWljX3NldCgmdmhhLT5sb29wX2Rvd25fdGltZXIsIExPT1BfRE9XTl9U
SU1FKTsKKworIAlxbGEyeDAwX3N0YXJ0X3RpbWVyKHZoYSwgcWxhMngwMF90aW1lciwgV0FUQ0hf
SU5URVJWQUwpOworCisJaG9zdC0+Y2FuX3F1ZXVlID0gdmhhLT5yZXF1ZXN0X3FfbGVuZ3RoICsg
MTI4OworCWhvc3QtPnRoaXNfaWQgPSAyNTU7CisJaG9zdC0+Y21kX3Blcl9sdW4gPSAzOworCWhv
c3QtPm1heF9jbWRfbGVuID0gTUFYX0NNRFNaOworCWhvc3QtPm1heF9jaGFubmVsID0gTUFYX0JV
U0VTIC0gMTsKKwlob3N0LT5tYXhfbHVuID0gTUFYX0xVTlM7CisJaG9zdC0+dW5pcXVlX2lkID0g
dmhhLT5pbnN0YW5jZTsKKwlob3N0LT5tYXhfaWQgPSBNQVhfVEFSR0VUU18yMjAwOworCWhvc3Qt
PnRyYW5zcG9ydHQgPSBxbGEyeHh4X3RyYW5zcG9ydF92cG9ydF90ZW1wbGF0ZTsKKworCURFQlVH
MTUocHJpbnRrKCJERUJVRzogZGV0ZWN0IHZwb3J0IGhiYSAlbGQgYXQgYWRkcmVzcyA9ICVwXG4i
LAorCSAgICB2aGEtPmhvc3Rfbm8sIHZoYSkpOworCisJdmhhLT5mbGFncy5pbml0X2RvbmUgPSAx
OworCW51bV9ob3N0cysrOworCisJZG93bigmaGEtPnZwb3J0X3NlbSk7CisJc2V0X2JpdCh2aGEt
PnZwX2lkeCwgKHVuc2lnbmVkIGxvbmcgKiloYS0+dnBfaWR4X21hcCk7CisJaGEtPmN1cl92cG9y
dF9jb3VudCsrOworCXVwKCZoYS0+dnBvcnRfc2VtKTsKKworCXJldHVybiB2aGE7CisKK2NyZWF0
ZV92aG9zdF9mYWlsZWRfMzoKKwlrZnJlZSh2aGEtPnBvcnRfbmFtZSk7CisKK2NyZWF0ZV92aG9z
dF9mYWlsZWRfMjoKKwlrZnJlZSh2aGEtPm5vZGVfbmFtZSk7CisKK2NyZWF0ZV92aG9zdF9mYWls
ZWRfMToKKwlyZXR1cm4gTlVMTDsKK30KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9vcy5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMKaW5kZXggMThiYWE1Yi4u
NzMzM2NhNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMKKysrIGIv
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMKQEAgLTI5LDggKzI5LDcgQEAgc3RhdGljIHN0
cnVjdCBrbWVtX2NhY2hlICpzcmJfY2FjaGVwOwogLyoKICAqIElvY3RsIHJlbGF0ZWQgaW5mb3Jt
YXRpb24uCiAgKi8KLXN0YXRpYyBpbnQgbnVtX2hvc3RzOwotCitpbnQgbnVtX2hvc3RzOwogaW50
IHFsMnhsb2dpbnRpbWVvdXQgPSAyMDsKIG1vZHVsZV9wYXJhbShxbDJ4bG9naW50aW1lb3V0LCBp
bnQsIFNfSVJVR098U19JUlVTUik7CiBNT0RVTEVfUEFSTV9ERVNDKHFsMnhsb2dpbnRpbWVvdXQs
CkBAIC0xMTIsNyArMTExLDcgQEAgc3RhdGljIGludCBxbGEyeDAwX2RldmljZV9yZXNldChzY3Np
X3FsYV9ob3N0X3QgKiwgZmNfcG9ydF90ICopOwogc3RhdGljIGludCBxbGEyeDAwX2NoYW5nZV9x
dWV1ZV9kZXB0aChzdHJ1Y3Qgc2NzaV9kZXZpY2UgKiwgaW50KTsKIHN0YXRpYyBpbnQgcWxhMngw
MF9jaGFuZ2VfcXVldWVfdHlwZShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKiwgaW50KTsKIAotc3RhdGlj
IHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgcWxhMngwMF9kcml2ZXJfdGVtcGxhdGUgPSB7Citz
dHJ1Y3Qgc2NzaV9ob3N0X3RlbXBsYXRlIHFsYTJ4MDBfZHJpdmVyX3RlbXBsYXRlID0gewogCS5t
b2R1bGUJCQk9IFRISVNfTU9EVUxFLAogCS5uYW1lCQkJPSBRTEEyWFhYX0RSSVZFUl9OQU1FLAog
CS5xdWV1ZWNvbW1hbmQJCT0gcWxhMngwMF9xdWV1ZWNvbW1hbmQsCkBAIC0xNDMsNyArMTQyLDcg
QEAgc3RhdGljIHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgcWxhMngwMF9kcml2ZXJfdGVtcGxh
dGUgPSB7CiAJLnNob3N0X2F0dHJzCQk9IHFsYTJ4MDBfaG9zdF9hdHRycywKIH07CiAKLXN0YXRp
YyBzdHJ1Y3Qgc2NzaV9ob3N0X3RlbXBsYXRlIHFsYTI0eHhfZHJpdmVyX3RlbXBsYXRlID0gewor
c3RydWN0IHNjc2lfaG9zdF90ZW1wbGF0ZSBxbGEyNHh4X2RyaXZlcl90ZW1wbGF0ZSA9IHsKIAku
bW9kdWxlCQkJPSBUSElTX01PRFVMRSwKIAkubmFtZQkJCT0gUUxBMlhYWF9EUklWRVJfTkFNRSwK
IAkucXVldWVjb21tYW5kCQk9IHFsYTI0eHhfcXVldWVjb21tYW5kLApAQCAtMTcxLDIxICsxNzAs
MjEgQEAgc3RhdGljIHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgcWxhMjR4eF9kcml2ZXJfdGVt
cGxhdGUgPSB7CiB9OwogCiBzdGF0aWMgc3RydWN0IHNjc2lfdHJhbnNwb3J0X3RlbXBsYXRlICpx
bGEyeHh4X3RyYW5zcG9ydF90ZW1wbGF0ZSA9IE5VTEw7CitzdHJ1Y3Qgc2NzaV90cmFuc3BvcnRf
dGVtcGxhdGUgKnFsYTJ4eHhfdHJhbnNwb3J0X3Zwb3J0X3RlbXBsYXRlID0gTlVMTDsKIAogLyog
VE9ETyBDb252ZXJ0IHRvIGlubGluZXMKICAqCiAgKiBUaW1lciByb3V0aW5lcwogICovCi0jZGVm
aW5lCVdBVENIX0lOVEVSVkFMCQkxICAgICAgIC8qIG51bWJlciBvZiBzZWNvbmRzICovCiAKLXN0
YXRpYyB2b2lkIHFsYTJ4MDBfdGltZXIoc2NzaV9xbGFfaG9zdF90ICopOwordm9pZCBxbGEyeDAw
X3RpbWVyKHNjc2lfcWxhX2hvc3RfdCAqKTsKIAotc3RhdGljIF9faW5saW5lX18gdm9pZCBxbGEy
eDAwX3N0YXJ0X3RpbWVyKHNjc2lfcWxhX2hvc3RfdCAqLAorX19pbmxpbmVfXyB2b2lkIHFsYTJ4
MDBfc3RhcnRfdGltZXIoc2NzaV9xbGFfaG9zdF90ICosCiAgICAgdm9pZCAqLCB1bnNpZ25lZCBs
b25nKTsKIHN0YXRpYyBfX2lubGluZV9fIHZvaWQgcWxhMngwMF9yZXN0YXJ0X3RpbWVyKHNjc2lf
cWxhX2hvc3RfdCAqLCB1bnNpZ25lZCBsb25nKTsKLXN0YXRpYyBfX2lubGluZV9fIHZvaWQgcWxh
MngwMF9zdG9wX3RpbWVyKHNjc2lfcWxhX2hvc3RfdCAqKTsKK19faW5saW5lX18gdm9pZCBxbGEy
eDAwX3N0b3BfdGltZXIoc2NzaV9xbGFfaG9zdF90ICopOwogCi1zdGF0aWMgaW5saW5lIHZvaWQK
K19faW5saW5lX18gdm9pZAogcWxhMngwMF9zdGFydF90aW1lcihzY3NpX3FsYV9ob3N0X3QgKmhh
LCB2b2lkICpmdW5jLCB1bnNpZ25lZCBsb25nIGludGVydmFsKQogewogCWluaXRfdGltZXIoJmhh
LT50aW1lcik7CkBAIC0yMDIsNyArMjAxLDcgQEAgcWxhMngwMF9yZXN0YXJ0X3RpbWVyKHNjc2lf
cWxhX2hvc3RfdCAqaGEsIHVuc2lnbmVkIGxvbmcgaW50ZXJ2YWwpCiAJbW9kX3RpbWVyKCZoYS0+
dGltZXIsIGppZmZpZXMgKyBpbnRlcnZhbCAqIEhaKTsKIH0KIAotc3RhdGljIF9faW5saW5lX18g
dm9pZAorX19pbmxpbmVfXyB2b2lkCiBxbGEyeDAwX3N0b3BfdGltZXIoc2NzaV9xbGFfaG9zdF90
ICpoYSkKIHsKIAlkZWxfdGltZXJfc3luYygmaGEtPnRpbWVyKTsKQEAgLTIxMyw4ICsyMTIsOCBA
QCBzdGF0aWMgaW50IHFsYTJ4MDBfZG9fZHBjKHZvaWQgKmRhdGEpOwogCiBzdGF0aWMgdm9pZCBx
bGEyeDAwX3JzdF9hZW4oc2NzaV9xbGFfaG9zdF90ICopOwogCi1zdGF0aWMgdWludDhfdCBxbGEy
eDAwX21lbV9hbGxvYyhzY3NpX3FsYV9ob3N0X3QgKik7Ci1zdGF0aWMgdm9pZCBxbGEyeDAwX21l
bV9mcmVlKHNjc2lfcWxhX2hvc3RfdCAqaGEpOwordWludDhfdCBxbGEyeDAwX21lbV9hbGxvYyhz
Y3NpX3FsYV9ob3N0X3QgKik7Cit2b2lkIHFsYTJ4MDBfbWVtX2ZyZWUoc2NzaV9xbGFfaG9zdF90
ICpoYSk7CiBzdGF0aWMgaW50IHFsYTJ4MDBfYWxsb2NhdGVfc3BfcG9vbCggc2NzaV9xbGFfaG9z
dF90ICpoYSk7CiBzdGF0aWMgdm9pZCBxbGEyeDAwX2ZyZWVfc3BfcG9vbChzY3NpX3FsYV9ob3N0
X3QgKmhhKTsKIHN0YXRpYyB2b2lkIHFsYTJ4MDBfc3BfZnJlZV9kbWEoc2NzaV9xbGFfaG9zdF90
ICosIHNyYl90ICopOwpAQCAtNDM4LDYgKzQzNyw3IEBAIHFsYTI0eHhfcXVldWVjb21tYW5kKHN0
cnVjdCBzY3NpX2NtbmQgKmNtZCwgdm9pZCAoKmRvbmUpKHN0cnVjdCBzY3NpX2NtbmQgKikpCiAJ
c3RydWN0IGZjX3Jwb3J0ICpycG9ydCA9IHN0YXJnZXRfdG9fcnBvcnQoc2NzaV90YXJnZXQoY21k
LT5kZXZpY2UpKTsKIAlzcmJfdCAqc3A7CiAJaW50IHJ2YWw7CisJc2NzaV9xbGFfaG9zdF90ICpw
aGEgPSB0b19xbGFfcGFyZW50KGhhKTsKIAogCXJ2YWwgPSBmY19yZW1vdGVfcG9ydF9jaGtyZWFk
eShycG9ydCk7CiAJaWYgKHJ2YWwpIHsKQEAgLTQ1Myw3ICs0NTMsNyBAQCBxbGEyNHh4X3F1ZXVl
Y29tbWFuZChzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQsIHZvaWQgKCpkb25lKShzdHJ1Y3Qgc2NzaV9j
bW5kICopKQogCiAJaWYgKGF0b21pY19yZWFkKCZmY3BvcnQtPnN0YXRlKSAhPSBGQ1NfT05MSU5F
KSB7CiAJCWlmIChhdG9taWNfcmVhZCgmZmNwb3J0LT5zdGF0ZSkgPT0gRkNTX0RFVklDRV9ERUFE
IHx8Ci0JCSAgICBhdG9taWNfcmVhZCgmaGEtPmxvb3Bfc3RhdGUpID09IExPT1BfREVBRCkgewor
CQkgICAgYXRvbWljX3JlYWQoJnBoYS0+bG9vcF9zdGF0ZSkgPT0gTE9PUF9ERUFEKSB7CiAJCQlj
bWQtPnJlc3VsdCA9IERJRF9OT19DT05ORUNUIDw8IDE2OwogCQkJZ290byBxYzI0X2ZhaWxfY29t
bWFuZDsKIAkJfQpAQCAtNDYyLDcgKzQ2Miw3IEBAIHFsYTI0eHhfcXVldWVjb21tYW5kKHN0cnVj
dCBzY3NpX2NtbmQgKmNtZCwgdm9pZCAoKmRvbmUpKHN0cnVjdCBzY3NpX2NtbmQgKikpCiAKIAlz
cGluX3VubG9ja19pcnEoaGEtPmhvc3QtPmhvc3RfbG9jayk7CiAKLQlzcCA9IHFsYTJ4MDBfZ2V0
X25ld19zcChoYSwgZmNwb3J0LCBjbWQsIGRvbmUpOworCXNwID0gcWxhMngwMF9nZXRfbmV3X3Nw
KHBoYSwgZmNwb3J0LCBjbWQsIGRvbmUpOwogCWlmICghc3ApCiAJCWdvdG8gcWMyNF9ob3N0X2J1
c3lfbG9jazsKIApAQCAtNDc1LDggKzQ3NSw4IEBAIHFsYTI0eHhfcXVldWVjb21tYW5kKHN0cnVj
dCBzY3NpX2NtbmQgKmNtZCwgdm9pZCAoKmRvbmUpKHN0cnVjdCBzY3NpX2NtbmQgKikpCiAJcmV0
dXJuIDA7CiAKIHFjMjRfaG9zdF9idXN5X2ZyZWVfc3A6Ci0JcWxhMngwMF9zcF9mcmVlX2RtYSho
YSwgc3ApOwotCW1lbXBvb2xfZnJlZShzcCwgaGEtPnNyYl9tZW1wb29sKTsKKwlxbGEyeDAwX3Nw
X2ZyZWVfZG1hKHBoYSwgc3ApOworCW1lbXBvb2xfZnJlZShzcCwgcGhhLT5zcmJfbWVtcG9vbCk7
CiAKIHFjMjRfaG9zdF9idXN5X2xvY2s6CiAJc3Bpbl9sb2NrX2lycShoYS0+aG9zdC0+aG9zdF9s
b2NrKTsKQEAgLTU0OCwxNiArNTQ4LDE3IEBAIHFsYTJ4MDBfd2FpdF9mb3JfaGJhX29ubGluZShz
Y3NpX3FsYV9ob3N0X3QgKmhhKQogewogCWludAkJcmV0dXJuX3N0YXR1czsKIAl1bnNpZ25lZCBs
b25nCXdhaXRfb25saW5lOworCXNjc2lfcWxhX2hvc3RfdCAqcGhhID0gdG9fcWxhX3BhcmVudCho
YSk7CiAKIAl3YWl0X29ubGluZSA9IGppZmZpZXMgKyAoTUFYX0xPT1BfVElNRU9VVCAqIEhaKTsK
LQl3aGlsZSAoKCh0ZXN0X2JpdChJU1BfQUJPUlRfTkVFREVELCAmaGEtPmRwY19mbGFncykpIHx8
Ci0JICAgIHRlc3RfYml0KEFCT1JUX0lTUF9BQ1RJVkUsICZoYS0+ZHBjX2ZsYWdzKSB8fAotCSAg
ICB0ZXN0X2JpdChJU1BfQUJPUlRfUkVUUlksICZoYS0+ZHBjX2ZsYWdzKSB8fAotCSAgICBoYS0+
ZHBjX2FjdGl2ZSkgJiYgdGltZV9iZWZvcmUoamlmZmllcywgd2FpdF9vbmxpbmUpKSB7CisJd2hp
bGUgKCgodGVzdF9iaXQoSVNQX0FCT1JUX05FRURFRCwgJnBoYS0+ZHBjX2ZsYWdzKSkgfHwKKwkg
ICAgdGVzdF9iaXQoQUJPUlRfSVNQX0FDVElWRSwgJnBoYS0+ZHBjX2ZsYWdzKSB8fAorCSAgICB0
ZXN0X2JpdChJU1BfQUJPUlRfUkVUUlksICZwaGEtPmRwY19mbGFncykgfHwKKwkgICAgcGhhLT5k
cGNfYWN0aXZlKSAmJiB0aW1lX2JlZm9yZShqaWZmaWVzLCB3YWl0X29ubGluZSkpIHsKIAogCQlt
c2xlZXAoMTAwMCk7CiAJfQotCWlmIChoYS0+ZmxhZ3Mub25saW5lKQorCWlmIChwaGEtPmZsYWdz
Lm9ubGluZSkKIAkJcmV0dXJuX3N0YXR1cyA9IFFMQV9TVUNDRVNTOwogCWVsc2UKIAkJcmV0dXJu
X3N0YXR1cyA9IFFMQV9GVU5DVElPTl9GQUlMRUQ7CkBAIC01ODgsMTQgKzU4OSwxNSBAQCBxbGEy
eDAwX3dhaXRfZm9yX2xvb3BfcmVhZHkoc2NzaV9xbGFfaG9zdF90ICpoYSkKIHsKIAlpbnQgCSBy
ZXR1cm5fc3RhdHVzID0gUUxBX1NVQ0NFU1M7CiAJdW5zaWduZWQgbG9uZyBsb29wX3RpbWVvdXQg
OworCXNjc2lfcWxhX2hvc3RfdCAqcGhhID0gdG9fcWxhX3BhcmVudChoYSk7CiAKIAkvKiB3YWl0
IGZvciA1IG1pbiBhdCB0aGUgbWF4IGZvciBsb29wIHRvIGJlIHJlYWR5ICovCiAJbG9vcF90aW1l
b3V0ID0gamlmZmllcyArIChNQVhfTE9PUF9USU1FT1VUICogSFopOwogCi0Jd2hpbGUgKCghYXRv
bWljX3JlYWQoJmhhLT5sb29wX2Rvd25fdGltZXIpICYmCi0JICAgIGF0b21pY19yZWFkKCZoYS0+
bG9vcF9zdGF0ZSkgPT0gTE9PUF9ET1dOKSB8fAotCSAgICBhdG9taWNfcmVhZCgmaGEtPmxvb3Bf
c3RhdGUpICE9IExPT1BfUkVBRFkpIHsKLQkJaWYgKGF0b21pY19yZWFkKCZoYS0+bG9vcF9zdGF0
ZSkgPT0gTE9PUF9ERUFEKSB7CisJd2hpbGUgKCghYXRvbWljX3JlYWQoJnBoYS0+bG9vcF9kb3du
X3RpbWVyKSAmJgorCSAgICBhdG9taWNfcmVhZCgmcGhhLT5sb29wX3N0YXRlKSA9PSBMT09QX0RP
V04pIHx8CisJICAgIGF0b21pY19yZWFkKCZwaGEtPmxvb3Bfc3RhdGUpICE9IExPT1BfUkVBRFkp
IHsKKwkJaWYgKGF0b21pY19yZWFkKCZwaGEtPmxvb3Bfc3RhdGUpID09IExPT1BfREVBRCkgewog
CQkJcmV0dXJuX3N0YXR1cyA9IFFMQV9GVU5DVElPTl9GQUlMRUQ7CiAJCQlicmVhazsKIAkJfQpA
QCAtNjUwLDYgKzY1Miw3IEBAIHFsYTJ4eHhfZWhfYWJvcnQoc3RydWN0IHNjc2lfY21uZCAqY21k
KQogCXVuc2lnbmVkIGxvbmcgc2VyaWFsOwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAJaW50IHdh
aXQgPSAwOworCXNjc2lfcWxhX2hvc3RfdCAqcGhhID0gdG9fcWxhX3BhcmVudChoYSk7CiAKIAlx
bGEyeDAwX2Jsb2NrX2Vycm9yX2hhbmRsZXIoY21kKTsKIApAQCAtNjYzLDkgKzY2Niw5IEBAIHFs
YTJ4eHhfZWhfYWJvcnQoc3RydWN0IHNjc2lfY21uZCAqY21kKQogCXNlcmlhbCA9IGNtZC0+c2Vy
aWFsX251bWJlcjsKIAogCS8qIENoZWNrIGFjdGl2ZSBsaXN0IGZvciBjb21tYW5kIGNvbW1hbmQu
ICovCi0Jc3Bpbl9sb2NrX2lycXNhdmUoJmhhLT5oYXJkd2FyZV9sb2NrLCBmbGFncyk7CisJc3Bp
bl9sb2NrX2lycXNhdmUoJnBoYS0+aGFyZHdhcmVfbG9jaywgZmxhZ3MpOwogCWZvciAoaSA9IDE7
IGkgPCBNQVhfT1VUU1RBTkRJTkdfQ09NTUFORFM7IGkrKykgewotCQlzcCA9IGhhLT5vdXRzdGFu
ZGluZ19jbWRzW2ldOworCQlzcCA9IHBoYS0+b3V0c3RhbmRpbmdfY21kc1tpXTsKIAogCQlpZiAo
c3AgPT0gTlVMTCkKIAkJCWNvbnRpbnVlOwpAQCAtNjc3LDcgKzY4MCw3IEBAIHFsYTJ4eHhfZWhf
YWJvcnQoc3RydWN0IHNjc2lfY21uZCAqY21kKQogCQkgICAgX19mdW5jX18sIGhhLT5ob3N0X25v
LCBzcCwgc2VyaWFsKSk7CiAJCURFQlVHMyhxbGEyeDAwX3ByaW50X3Njc2lfY21kKGNtZCkpOwog
Ci0JCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhhLT5oYXJkd2FyZV9sb2NrLCBmbGFncyk7CisJ
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnBoYS0+aGFyZHdhcmVfbG9jaywgZmxhZ3MpOwogCQlp
ZiAoaGEtPmlzcF9vcHMuYWJvcnRfY29tbWFuZChoYSwgc3ApKSB7CiAJCQlERUJVRzIocHJpbnRr
KCIlcyglbGQpOiBhYm9ydF9jb21tYW5kICIKIAkJCSAgICAibWJ4IGZhaWxlZC5cbiIsIF9fZnVu
Y19fLCBoYS0+aG9zdF9ubykpOwpAQCAtNjg2LDExICs2ODksMTEgQEAgcWxhMnh4eF9laF9hYm9y
dChzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpCiAJCQkgICAgIm1ieCBzdWNjZXNzLlxuIiwgX19mdW5j
X18sIGhhLT5ob3N0X25vKSk7CiAJCQl3YWl0ID0gMTsKIAkJfQotCQlzcGluX2xvY2tfaXJxc2F2
ZSgmaGEtPmhhcmR3YXJlX2xvY2ssIGZsYWdzKTsKKwkJc3Bpbl9sb2NrX2lycXNhdmUoJnBoYS0+
aGFyZHdhcmVfbG9jaywgZmxhZ3MpOwogCiAJCWJyZWFrOwogCX0KLQlzcGluX3VubG9ja19pcnFy
ZXN0b3JlKCZoYS0+aGFyZHdhcmVfbG9jaywgZmxhZ3MpOworCXNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoJnBoYS0+aGFyZHdhcmVfbG9jaywgZmxhZ3MpOwogCiAJLyogV2FpdCBmb3IgdGhlIGNvbW1h
bmQgdG8gYmUgcmV0dXJuZWQuICovCiAJaWYgKHdhaXQpIHsKQEAgLTczMSw2ICs3MzQsNyBAQCBx
bGEyeDAwX2VoX3dhaXRfZm9yX3BlbmRpbmdfdGFyZ2V0X2NvbW1hbmRzKHNjc2lfcWxhX2hvc3Rf
dCAqaGEsIHVuc2lnbmVkIGludCB0KQogCXNyYl90CQkqc3A7CiAJc3RydWN0IHNjc2lfY21uZCAq
Y21kOwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisJc2NzaV9xbGFfaG9zdF90ICpwaGEgPSB0b19x
bGFfcGFyZW50KGhhKTsKIAogCXN0YXR1cyA9IDA7CiAKQEAgLTczOSwxOSArNzQzLDIwIEBAIHFs
YTJ4MDBfZWhfd2FpdF9mb3JfcGVuZGluZ190YXJnZXRfY29tbWFuZHMoc2NzaV9xbGFfaG9zdF90
ICpoYSwgdW5zaWduZWQgaW50IHQpCiAJICogYXJyYXkKIAkgKi8KIAlmb3IgKGNudCA9IDE7IGNu
dCA8IE1BWF9PVVRTVEFORElOR19DT01NQU5EUzsgY250KyspIHsKLQkJc3Bpbl9sb2NrX2lycXNh
dmUoJmhhLT5oYXJkd2FyZV9sb2NrLCBmbGFncyk7Ci0JCXNwID0gaGEtPm91dHN0YW5kaW5nX2Nt
ZHNbY250XTsKKwkJc3Bpbl9sb2NrX2lycXNhdmUoJnBoYS0+aGFyZHdhcmVfbG9jaywgZmxhZ3Mp
OworCQlzcCA9IHBoYS0+b3V0c3RhbmRpbmdfY21kc1tjbnRdOwogCQlpZiAoc3ApIHsKIAkJCWNt
ZCA9IHNwLT5jbWQ7Ci0JCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZoYS0+aGFyZHdhcmVfbG9j
aywgZmxhZ3MpOwotCQkJaWYgKGNtZC0+ZGV2aWNlLT5pZCA9PSB0KSB7CisJCQlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZwaGEtPmhhcmR3YXJlX2xvY2ssIGZsYWdzKTsKKwkJCWlmIChjbWQtPmRl
dmljZS0+aWQgPT0gdCAmJgorCQkJICAgIGhhLT52cF9pZHggPT0gc3AtPmhhLT52cF9pZHgpIHsK
IAkJCQlpZiAoIXFsYTJ4MDBfZWhfd2FpdF9vbl9jb21tYW5kKGhhLCBjbWQpKSB7CiAJCQkJCXN0
YXR1cyA9IDE7CiAJCQkJCWJyZWFrOwogCQkJCX0KIAkJCX0KIAkJfSBlbHNlIHsKLQkJCXNwaW5f
dW5sb2NrX2lycXJlc3RvcmUoJmhhLT5oYXJkd2FyZV9sb2NrLCBmbGFncyk7CisJCQlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZwaGEtPmhhcmR3YXJlX2xvY2ssIGZsYWdzKTsKIAkJfQogCX0KIAly
ZXR1cm4gKHN0YXR1cyk7CkBAIC03ODIsMTQgKzc4NywxMiBAQCBxbGEyeHh4X2VoX2RldmljZV9y
ZXNldChzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpCiB7CiAJc2NzaV9xbGFfaG9zdF90ICpoYSA9IHRv
X3FsYV9ob3N0KGNtZC0+ZGV2aWNlLT5ob3N0KTsKIAlmY19wb3J0X3QgKmZjcG9ydCA9IChzdHJ1
Y3QgZmNfcG9ydCAqKSBjbWQtPmRldmljZS0+aG9zdGRhdGE7Ci0JaW50IHJldDsKKwlpbnQgcmV0
ID0gRkFJTEVEOwogCXVuc2lnbmVkIGludCBpZCwgbHVuOwogCXVuc2lnbmVkIGxvbmcgc2VyaWFs
OwogCiAJcWxhMngwMF9ibG9ja19lcnJvcl9oYW5kbGVyKGNtZCk7CiAKLQlyZXQgPSBGQUlMRUQ7
Ci0KIAlpZCA9IGNtZC0+ZGV2aWNlLT5pZDsKIAlsdW4gPSBjbWQtPmRldmljZS0+bHVuOwogCXNl
cmlhbCA9IGNtZC0+c2VyaWFsX251bWJlcjsKQEAgLTkxMiwxNSArOTE1LDE0IEBAIHN0YXRpYyBp
bnQKIHFsYTJ4eHhfZWhfYnVzX3Jlc2V0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkKIHsKIAlzY3Np
X3FsYV9ob3N0X3QgKmhhID0gdG9fcWxhX2hvc3QoY21kLT5kZXZpY2UtPmhvc3QpOworCXNjc2lf
cWxhX2hvc3RfdCAqcGhhID0gdG9fcWxhX3BhcmVudChoYSk7CiAJZmNfcG9ydF90ICpmY3BvcnQg
PSAoc3RydWN0IGZjX3BvcnQgKikgY21kLT5kZXZpY2UtPmhvc3RkYXRhOwotCWludCByZXQ7CisJ
aW50IHJldCA9IEZBSUxFRDsKIAl1bnNpZ25lZCBpbnQgaWQsIGx1bjsKIAl1bnNpZ25lZCBsb25n
IHNlcmlhbDsKIAogCXFsYTJ4MDBfYmxvY2tfZXJyb3JfaGFuZGxlcihjbWQpOwogCi0JcmV0ID0g
RkFJTEVEOwotCiAJaWQgPSBjbWQtPmRldmljZS0+aWQ7CiAJbHVuID0gY21kLT5kZXZpY2UtPmx1
bjsKIAlzZXJpYWwgPSBjbWQtPnNlcmlhbF9udW1iZXI7CkBAIC05NDQsNyArOTQ2LDcgQEAgcWxh
Mnh4eF9laF9idXNfcmVzZXQoc3RydWN0IHNjc2lfY21uZCAqY21kKQogCQlnb3RvIGVoX2J1c19y
ZXNldF9kb25lOwogCiAJLyogRmx1c2ggb3V0c3RhbmRpbmcgY29tbWFuZHMuICovCi0JaWYgKCFx
bGEyeDAwX2VoX3dhaXRfZm9yX3BlbmRpbmdfY29tbWFuZHMoaGEpKQorCWlmICghcWxhMngwMF9l
aF93YWl0X2Zvcl9wZW5kaW5nX2NvbW1hbmRzKHBoYSkpCiAJCXJldCA9IEZBSUxFRDsKIAogZWhf
YnVzX3Jlc2V0X2RvbmU6CkBAIC05NzQsMTQgKzk3NiwxMyBAQCBxbGEyeHh4X2VoX2hvc3RfcmVz
ZXQoc3RydWN0IHNjc2lfY21uZCAqY21kKQogewogCXNjc2lfcWxhX2hvc3RfdCAqaGEgPSB0b19x
bGFfaG9zdChjbWQtPmRldmljZS0+aG9zdCk7CiAJZmNfcG9ydF90ICpmY3BvcnQgPSAoc3RydWN0
IGZjX3BvcnQgKikgY21kLT5kZXZpY2UtPmhvc3RkYXRhOwotCWludCByZXQ7CisJaW50IHJldCA9
IEZBSUxFRDsKIAl1bnNpZ25lZCBpbnQgaWQsIGx1bjsKIAl1bnNpZ25lZCBsb25nIHNlcmlhbDsK
KwlzY3NpX3FsYV9ob3N0X3QgKnBoYSA9IHRvX3FsYV9wYXJlbnQoaGEpOwogCiAJcWxhMngwMF9i
bG9ja19lcnJvcl9oYW5kbGVyKGNtZCk7CiAKLQlyZXQgPSBGQUlMRUQ7Ci0KIAlpZCA9IGNtZC0+
ZGV2aWNlLT5pZDsKIAlsdW4gPSBjbWQtPmRldmljZS0+bHVuOwogCXNlcmlhbCA9IGNtZC0+c2Vy
aWFsX251bWJlcjsKQEAgLTEwMDQsMjEgKzEwMDUsMjQgQEAgcWxhMnh4eF9laF9ob3N0X3Jlc2V0
KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkKIAkgKiB3aGlsZSBkcGMgaXMgc3R1Y2sgZm9yIHRoZSBt
YWlsYm94IHRvIGNvbXBsZXRlLgogCSAqLwogCXFsYTJ4MDBfd2FpdF9mb3JfbG9vcF9yZWFkeSho
YSk7Ci0Jc2V0X2JpdChBQk9SVF9JU1BfQUNUSVZFLCAmaGEtPmRwY19mbGFncyk7Ci0JaWYgKHFs
YTJ4MDBfYWJvcnRfaXNwKGhhKSkgewotCQljbGVhcl9iaXQoQUJPUlRfSVNQX0FDVElWRSwgJmhh
LT5kcGNfZmxhZ3MpOworCXNldF9iaXQoQUJPUlRfSVNQX0FDVElWRSwgJnBoYS0+ZHBjX2ZsYWdz
KTsKKwlpZiAocWxhMngwMF9hYm9ydF9pc3AocGhhKSkgeworCQljbGVhcl9iaXQoQUJPUlRfSVNQ
X0FDVElWRSwgJnBoYS0+ZHBjX2ZsYWdzKTsKIAkJLyogZmFpbGVkLiBzY2hlZHVsZSBkcGMgdG8g
dHJ5ICovCi0JCXNldF9iaXQoSVNQX0FCT1JUX05FRURFRCwgJmhhLT5kcGNfZmxhZ3MpOworCQlz
ZXRfYml0KElTUF9BQk9SVF9ORUVERUQsICZwaGEtPmRwY19mbGFncyk7CiAKIAkJaWYgKHFsYTJ4
MDBfd2FpdF9mb3JfaGJhX29ubGluZShoYSkgIT0gUUxBX1NVQ0NFU1MpCiAJCQlnb3RvIGVoX2hv
c3RfcmVzZXRfbG9jazsKIAl9Ci0JY2xlYXJfYml0KEFCT1JUX0lTUF9BQ1RJVkUsICZoYS0+ZHBj
X2ZsYWdzKTsKKwljbGVhcl9iaXQoQUJPUlRfSVNQX0FDVElWRSwgJnBoYS0+ZHBjX2ZsYWdzKTsK
IAogCS8qIFdhaXRpbmcgZm9yIG91ciBjb21tYW5kIGluIGRvbmVfcXVldWUgdG8gYmUgcmV0dXJu
ZWQgdG8gT1MuKi8KLQlpZiAocWxhMngwMF9laF93YWl0X2Zvcl9wZW5kaW5nX2NvbW1hbmRzKGhh
KSkKKwlpZiAocWxhMngwMF9laF93YWl0X2Zvcl9wZW5kaW5nX2NvbW1hbmRzKHBoYSkpCiAJCXJl
dCA9IFNVQ0NFU1M7CiAKKwlpZiAoaGEtPnBhcmVudCkKKwkJcWxhMngwMF92cF9hYm9ydF9pc3Ao
aGEpOworCiBlaF9ob3N0X3Jlc2V0X2xvY2s6CiAJcWxhX3ByaW50ayhLRVJOX0lORk8sIGhhLCAi
JXM6IHJlc2V0ICVzXG4iLCBfX2Z1bmNfXywKIAkgICAgKHJldCA9PSBGQUlMRUQpID8gImZhaWxl
ZCIgOiAic3VjY2VkZWQiKTsKQEAgLTE0MzUsNiArMTQzOSw3IEBAIHFsYTJ4MDBfcHJvYmVfb25l
KHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpCiAJ
aGEtPmhvc3QgPSBob3N0OwogCWhhLT5ob3N0X25vID0gaG9zdC0+aG9zdF9ubzsKIAlzcHJpbnRm
KGhhLT5ob3N0X3N0ciwgIiVzXyVsZCIsIFFMQTJYWFhfRFJJVkVSX05BTUUsIGhhLT5ob3N0X25v
KTsKKwloYS0+cGFyZW50ID0gTlVMTDsKIAogCS8qIFNldCBJU1AtdHlwZSBpbmZvcm1hdGlvbi4g
Ki8KIAlxbGEyeDAwX3NldF9pc3BfZmxhZ3MoaGEpOwpAQCAtMTQ1Miw3ICsxNDU3LDcgQEAgcWxh
MngwMF9wcm9iZV9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2
aWNlX2lkICppZCkKIAogCWhhLT5wcmV2X3RvcG9sb2d5ID0gMDsKIAloYS0+aW5pdF9jYl9zaXpl
ID0gc2l6ZW9mKGluaXRfY2JfdCk7Ci0JaGEtPm1nbXRfc3ZyX2xvb3BfaWQgPSBNQU5BR0VNRU5U
X1NFUlZFUjsKKwloYS0+bWdtdF9zdnJfbG9vcF9pZCA9IE1BTkFHRU1FTlRfU0VSVkVSICsgaGEt
PnZwX2lkeDsKIAloYS0+bGlua19kYXRhX3JhdGUgPSBQT1JUX1NQRUVEX1VOS05PV047CiAJaGEt
Pm9wdHJvbV9zaXplID0gT1BUUk9NX1NJWkVfMjMwMDsKIApAQCAtMTUyNCw4ICsxNTI5LDggQEAg
cWxhMngwMF9wcm9iZV9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lf
ZGV2aWNlX2lkICppZCkKIAkJaGEtPnJlcXVlc3RfcV9sZW5ndGggPSBSRVFVRVNUX0VOVFJZX0NO
VF8yNFhYOwogCQloYS0+cmVzcG9uc2VfcV9sZW5ndGggPSBSRVNQT05TRV9FTlRSWV9DTlRfMjMw
MDsKIAkJaGEtPmxhc3RfbG9vcF9pZCA9IFNOU19MQVNUX0xPT1BfSURfMjMwMDsKLQkJaGEtPmlu
aXRfY2Jfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgaW5pdF9jYl8yNHh4KTsKLQkJaGEtPm1nbXRfc3Zy
X2xvb3BfaWQgPSAxMDsKKwkJaGEtPmluaXRfY2Jfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgbWlkX2lu
aXRfY2JfMjR4eCk7CisJCWhhLT5tZ210X3N2cl9sb29wX2lkID0gMTAgKyBoYS0+dnBfaWR4Owog
CQloYS0+aXNwX29wcy5wY2lfY29uZmlnID0gcWxhMjR4eF9wY2lfY29uZmlnOwogCQloYS0+aXNw
X29wcy5yZXNldF9jaGlwID0gcWxhMjR4eF9yZXNldF9jaGlwOwogCQloYS0+aXNwX29wcy5jaGlw
X2RpYWcgPSBxbGEyNHh4X2NoaXBfZGlhZzsKQEAgLTE1NjMsMTAgKzE1NjgsMTQgQEAgcWxhMngw
MF9wcm9iZV9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNl
X2lkICppZCkKIAloYS0+aW5zdGFuY2UgPSBudW1faG9zdHM7CiAKIAlpbml0X01VVEVYKCZoYS0+
bWJ4X2NtZF9zZW0pOworCWluaXRfTVVURVgoJmhhLT52cG9ydF9zZW0pOwogCWluaXRfTVVURVhf
TE9DS0VEKCZoYS0+bWJ4X2ludHJfc2VtKTsKIAogCUlOSVRfTElTVF9IRUFEKCZoYS0+bGlzdCk7
CiAJSU5JVF9MSVNUX0hFQUQoJmhhLT5mY3BvcnRzKTsKKwlJTklUX0xJU1RfSEVBRCgmaGEtPnZw
X2xpc3QpOworCisJc2V0X2JpdCgwLCAodW5zaWduZWQgbG9uZyAqKSBoYS0+dnBfaWR4X21hcCk7
CiAKIAlxbGEyeDAwX2NvbmZpZ19kbWFfYWRkcmVzc2luZyhoYSk7CiAJaWYgKHFsYTJ4MDBfbWVt
X2FsbG9jKGhhKSkgewpAQCAtMTc4OSw3ICsxNzk4LDggQEAgcWxhMngwMF9zY2hlZHVsZV9ycG9y
dF9kZWwoc3RydWN0IHNjc2lfcWxhX2hvc3QgKmhhLCBmY19wb3J0X3QgKmZjcG9ydCwKIHZvaWQg
cWxhMngwMF9tYXJrX2RldmljZV9sb3N0KHNjc2lfcWxhX2hvc3RfdCAqaGEsIGZjX3BvcnRfdCAq
ZmNwb3J0LAogICAgIGludCBkb19sb2dpbiwgaW50IGRlZmVyKQogewotCWlmIChhdG9taWNfcmVh
ZCgmZmNwb3J0LT5zdGF0ZSkgPT0gRkNTX09OTElORSkKKwlpZiAoYXRvbWljX3JlYWQoJmZjcG9y
dC0+c3RhdGUpID09IEZDU19PTkxJTkUgJiYKKwkgICAgaGEtPnZwX2lkeCA9PSBmY3BvcnQtPnZw
X2lkeCkKIAkJcWxhMngwMF9zY2hlZHVsZV9ycG9ydF9kZWwoaGEsIGZjcG9ydCwgZGVmZXIpOwog
CiAJLyoKQEAgLTE4NDAsMTkgKzE4NTAsMjMgQEAgdm9pZAogcWxhMngwMF9tYXJrX2FsbF9kZXZp
Y2VzX2xvc3Qoc2NzaV9xbGFfaG9zdF90ICpoYSwgaW50IGRlZmVyKQogewogCWZjX3BvcnRfdCAq
ZmNwb3J0OworCXNjc2lfcWxhX2hvc3RfdCAqcGhhID0gdG9fcWxhX3BhcmVudChoYSk7CiAKLQls
aXN0X2Zvcl9lYWNoX2VudHJ5KGZjcG9ydCwgJmhhLT5mY3BvcnRzLCBsaXN0KSB7Ci0JCWlmIChm
Y3BvcnQtPnBvcnRfdHlwZSAhPSBGQ1RfVEFSR0VUKQorCWxpc3RfZm9yX2VhY2hfZW50cnkoZmNw
b3J0LCAmcGhhLT5mY3BvcnRzLCBsaXN0KSB7CisJCWlmIChoYS0+dnBfaWR4ICE9IDAgJiYgaGEt
PnZwX2lkeCAhPSBmY3BvcnQtPnZwX2lkeCkKIAkJCWNvbnRpbnVlOwotCiAJCS8qCiAJCSAqIE5v
IHBvaW50IGluIG1hcmtpbmcgdGhlIGRldmljZSBhcyBsb3N0LCBpZiB0aGUgZGV2aWNlIGlzCiAJ
CSAqIGFscmVhZHkgREVBRC4KIAkJICovCiAJCWlmIChhdG9taWNfcmVhZCgmZmNwb3J0LT5zdGF0
ZSkgPT0gRkNTX0RFVklDRV9ERUFEKQogCQkJY29udGludWU7Ci0JCWlmIChhdG9taWNfcmVhZCgm
ZmNwb3J0LT5zdGF0ZSkgPT0gRkNTX09OTElORSkKLQkJCXFsYTJ4MDBfc2NoZWR1bGVfcnBvcnRf
ZGVsKGhhLCBmY3BvcnQsIGRlZmVyKTsKKwkJaWYgKGF0b21pY19yZWFkKCZmY3BvcnQtPnN0YXRl
KSA9PSBGQ1NfT05MSU5FKSB7CisJCQlpZiAoZGVmZXIpCisJCQkJcWxhMngwMF9zY2hlZHVsZV9y
cG9ydF9kZWwoaGEsIGZjcG9ydCwgZGVmZXIpOworCQkJZWxzZSBpZiAoaGEtPnZwX2lkeCA9PSBm
Y3BvcnQtPnZwX2lkeCkKKwkJCQlxbGEyeDAwX3NjaGVkdWxlX3Jwb3J0X2RlbChoYSwgZmNwb3J0
LCBkZWZlcik7CisJCX0KIAkJYXRvbWljX3NldCgmZmNwb3J0LT5zdGF0ZSwgRkNTX0RFVklDRV9M
T1NUKTsKIAl9CiAKQEAgLTE4NjgsNyArMTg4Miw3IEBAIHFsYTJ4MDBfbWFya19hbGxfZGV2aWNl
c19sb3N0KHNjc2lfcWxhX2hvc3RfdCAqaGEsIGludCBkZWZlcikKICogICAgICAwICA9IHN1Y2Nl
c3MuCiAqICAgICAgMSAgPSBmYWlsdXJlLgogKi8KLXN0YXRpYyB1aW50OF90Cit1aW50OF90CiBx
bGEyeDAwX21lbV9hbGxvYyhzY3NpX3FsYV9ob3N0X3QgKmhhKQogewogCWNoYXIJbmFtZVsxNl07
CkBAIC0xOTIwLDMzICsxOTM0LDMzIEBAIHFsYTJ4MDBfbWVtX2FsbG9jKHNjc2lfcWxhX2hvc3Rf
dCAqaGEpCiAJCQljb250aW51ZTsKIAkJfQogCi0JCXNucHJpbnRmKG5hbWUsIHNpemVvZihuYW1l
KSwgIiVzXyVsZCIsIFFMQTJYWFhfRFJJVkVSX05BTUUsCi0JCSAgICBoYS0+aG9zdF9ubyk7Ci0J
CWhhLT5zX2RtYV9wb29sID0gZG1hX3Bvb2xfY3JlYXRlKG5hbWUsICZoYS0+cGRldi0+ZGV2LAot
CQkgICAgRE1BX1BPT0xfU0laRSwgOCwgMCk7Ci0JCWlmIChoYS0+c19kbWFfcG9vbCA9PSBOVUxM
KSB7CisJCS8qIGdldCBjb25zaXN0ZW50IG1lbW9yeSBhbGxvY2F0ZWQgZm9yIGluaXQgY29udHJv
bCBibG9jayAqLworCQloYS0+aW5pdF9jYiA9IGRtYV9hbGxvY19jb2hlcmVudCgmaGEtPnBkZXYt
PmRldiwKKwkJICAgIGhhLT5pbml0X2NiX3NpemUsICZoYS0+aW5pdF9jYl9kbWEsIEdGUF9LRVJO
RUwpOworCQlpZiAoaGEtPmluaXRfY2IgPT0gTlVMTCkgewogCQkJcWxhX3ByaW50ayhLRVJOX1dB
Uk5JTkcsIGhhLAotCQkJICAgICJNZW1vcnkgQWxsb2NhdGlvbiBmYWlsZWQgLSBzX2RtYV9wb29s
XG4iKTsKKwkJCSAgICAiTWVtb3J5IEFsbG9jYXRpb24gZmFpbGVkIC0gaW5pdF9jYlxuIik7CiAK
IAkJCXFsYTJ4MDBfbWVtX2ZyZWUoaGEpOwogCQkJbXNsZWVwKDEwMCk7CiAKIAkJCWNvbnRpbnVl
OwogCQl9CisJCW1lbXNldChoYS0+aW5pdF9jYiwgMCwgaGEtPmluaXRfY2Jfc2l6ZSk7CiAKLQkJ
LyogZ2V0IGNvbnNpc3RlbnQgbWVtb3J5IGFsbG9jYXRlZCBmb3IgaW5pdCBjb250cm9sIGJsb2Nr
ICovCi0JCWhhLT5pbml0X2NiID0gZG1hX3Bvb2xfYWxsb2MoaGEtPnNfZG1hX3Bvb2wsIEdGUF9L
RVJORUwsCi0JCSAgICAmaGEtPmluaXRfY2JfZG1hKTsKLQkJaWYgKGhhLT5pbml0X2NiID09IE5V
TEwpIHsKKwkJc25wcmludGYobmFtZSwgc2l6ZW9mKG5hbWUpLCAiJXNfJWxkIiwgUUxBMlhYWF9E
UklWRVJfTkFNRSwKKwkJICAgIGhhLT5ob3N0X25vKTsKKwkJaGEtPnNfZG1hX3Bvb2wgPSBkbWFf
cG9vbF9jcmVhdGUobmFtZSwgJmhhLT5wZGV2LT5kZXYsCisJCSAgICBETUFfUE9PTF9TSVpFLCA4
LCAwKTsKKwkJaWYgKGhhLT5zX2RtYV9wb29sID09IE5VTEwpIHsKIAkJCXFsYV9wcmludGsoS0VS
Tl9XQVJOSU5HLCBoYSwKLQkJCSAgICAiTWVtb3J5IEFsbG9jYXRpb24gZmFpbGVkIC0gaW5pdF9j
YlxuIik7CisJCQkgICAgIk1lbW9yeSBBbGxvY2F0aW9uIGZhaWxlZCAtIHNfZG1hX3Bvb2xcbiIp
OwogCiAJCQlxbGEyeDAwX21lbV9mcmVlKGhhKTsKIAkJCW1zbGVlcCgxMDApOwogCiAJCQljb250
aW51ZTsKIAkJfQotCQltZW1zZXQoaGEtPmluaXRfY2IsIDAsIGhhLT5pbml0X2NiX3NpemUpOwog
CiAJCWlmIChxbGEyeDAwX2FsbG9jYXRlX3NwX3Bvb2woaGEpKSB7CiAJCQlxbGFfcHJpbnRrKEtF
Uk5fV0FSTklORywgaGEsCkBAIC0yMDUyLDcgKzIwNjYsNyBAQCBxbGEyeDAwX21lbV9hbGxvYyhz
Y3NpX3FsYV9ob3N0X3QgKmhhKQogKiBJbnB1dDoKICogICAgICBoYSA9IGFkYXB0ZXIgYmxvY2sg
cG9pbnRlci4KICovCi1zdGF0aWMgdm9pZAordm9pZAogcWxhMngwMF9tZW1fZnJlZShzY3NpX3Fs
YV9ob3N0X3QgKmhhKQogewogCXN0cnVjdCBsaXN0X2hlYWQJKmZjcGwsICpmY3B0ZW1wOwpAQCAt
MjA4OCwxMiArMjEwMiwxMyBAQCBxbGEyeDAwX21lbV9mcmVlKHNjc2lfcWxhX2hvc3RfdCAqaGEp
CiAJaWYgKGhhLT5tc19pb2NiKQogCQlkbWFfcG9vbF9mcmVlKGhhLT5zX2RtYV9wb29sLCBoYS0+
bXNfaW9jYiwgaGEtPm1zX2lvY2JfZG1hKTsKIAotCWlmIChoYS0+aW5pdF9jYikKLQkJZG1hX3Bv
b2xfZnJlZShoYS0+c19kbWFfcG9vbCwgaGEtPmluaXRfY2IsIGhhLT5pbml0X2NiX2RtYSk7Ci0K
IAlpZiAoaGEtPnNfZG1hX3Bvb2wpCiAJCWRtYV9wb29sX2Rlc3Ryb3koaGEtPnNfZG1hX3Bvb2wp
OwogCisJaWYgKGhhLT5pbml0X2NiKQorCQlkbWFfZnJlZV9jb2hlcmVudCgmaGEtPnBkZXYtPmRl
diwgaGEtPmluaXRfY2Jfc2l6ZSwgCisJCSAgICBoYS0+aW5pdF9jYiwgaGEtPmluaXRfY2JfZG1h
KTsKKwogCWlmIChoYS0+Z2lkX2xpc3QpCiAJCWRtYV9mcmVlX2NvaGVyZW50KCZoYS0+cGRldi0+
ZGV2LCBHSURfTElTVF9TSVpFLCBoYS0+Z2lkX2xpc3QsCiAJCSAgICBoYS0+Z2lkX2xpc3RfZG1h
KTsKQEAgLTIxOTksNiArMjIxNCw3IEBAIHFsYTJ4MDBfZnJlZV9zcF9wb29sKCBzY3NpX3FsYV9o
b3N0X3QgKmhhKQogc3RhdGljIGludAogcWxhMngwMF9kb19kcGModm9pZCAqZGF0YSkKIHsKKwlp
bnQJCXJ2YWw7CiAJc2NzaV9xbGFfaG9zdF90ICpoYTsKIAlmY19wb3J0X3QJKmZjcG9ydDsKIAl1
aW50OF90CQlzdGF0dXM7CkBAIC0yMzQ3LDcgKzIzNjMsNyBAQCBxbGEyeDAwX2RvX2RwYyh2b2lk
ICpkYXRhKQogCQkJaWYgKCEodGVzdF9hbmRfc2V0X2JpdChMT09QX1JFU1lOQ19BQ1RJVkUsCiAJ
CQkgICAgJmhhLT5kcGNfZmxhZ3MpKSkgewogCi0JCQkJcWxhMngwMF9sb29wX3Jlc3luYyhoYSk7
CisJCQkJcnZhbCA9IHFsYTJ4MDBfbG9vcF9yZXN5bmMoaGEpOwogCiAJCQkJY2xlYXJfYml0KExP
T1BfUkVTWU5DX0FDVElWRSwgJmhhLT5kcGNfZmxhZ3MpOwogCQkJfQpAQCAtMjM3NCw2ICsyMzkw
LDggQEAgcWxhMngwMF9kb19kcGModm9pZCAqZGF0YSkKIAkJaWYgKHRlc3RfYW5kX2NsZWFyX2Jp
dChCRUFDT05fQkxJTktfTkVFREVELCAmaGEtPmRwY19mbGFncykpCiAJCQloYS0+aXNwX29wcy5i
ZWFjb25fYmxpbmsoaGEpOwogCisJCXFsYTJ4MDBfZG9fZHBjX2FsbF92cHMoaGEpOworCiAJCWhh
LT5kcGNfYWN0aXZlID0gMDsKIAl9IC8qIEVuZCBvZiB3aGlsZSgxKSAqLwogCkBAIC0yNDUyLDcg
KzI0NzAsNyBAQCBxbGEyeDAwX3NwX2NvbXBsKHNjc2lfcWxhX2hvc3RfdCAqaGEsIHNyYl90ICpz
cCkKICoKICogQ29udGV4dDogSW50ZXJydXB0CiAqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovCi1zdGF0aWMg
dm9pZAordm9pZAogcWxhMngwMF90aW1lcihzY3NpX3FsYV9ob3N0X3QgKmhhKQogewogCXVuc2ln
bmVkIGxvbmcJY3B1X2ZsYWdzID0gMDsKQEAgLTI0NjEsNiArMjQ3OSw3IEBAIHFsYTJ4MDBfdGlt
ZXIoc2NzaV9xbGFfaG9zdF90ICpoYSkKIAlpbnQJCWluZGV4OwogCXNyYl90CQkqc3A7CiAJaW50
CQl0OworCXNjc2lfcWxhX2hvc3RfdCAqcGhhID0gdG9fcWxhX3BhcmVudChoYSk7CiAKIAkvKgog
CSAqIFBvcnRzIC0gUG9ydCBkb3duIHRpbWVyLgpAQCAtMjUwNiwyMyArMjUyNSwyOSBAQCBxbGEy
eDAwX3RpbWVyKHNjc2lfcWxhX2hvc3RfdCAqaGEpCiAJCQkJYXRvbWljX3NldCgmaGEtPmxvb3Bf
c3RhdGUsIExPT1BfREVBRCk7CiAKIAkJCS8qIFNjaGVkdWxlIGFuIElTUCBhYm9ydCB0byByZXR1
cm4gYW55IHRhcGUgY29tbWFuZHMuICovCi0JCQlzcGluX2xvY2tfaXJxc2F2ZSgmaGEtPmhhcmR3
YXJlX2xvY2ssIGNwdV9mbGFncyk7Ci0JCQlmb3IgKGluZGV4ID0gMTsgaW5kZXggPCBNQVhfT1VU
U1RBTkRJTkdfQ09NTUFORFM7Ci0JCQkgICAgaW5kZXgrKykgewotCQkJCWZjX3BvcnRfdCAqc2Zj
cDsKKwkJCS8qIE5QSVYgLSBzY2FuIHBoeXNpY2FsIHBvcnQgb25seSAqLworCQkJaWYgKCFoYS0+
cGFyZW50KSB7CisJCQkJc3Bpbl9sb2NrX2lycXNhdmUoJmhhLT5oYXJkd2FyZV9sb2NrLAorCQkJ
CSAgICBjcHVfZmxhZ3MpOworCQkJCWZvciAoaW5kZXggPSAxOworCQkJCSAgICBpbmRleCA8IE1B
WF9PVVRTVEFORElOR19DT01NQU5EUzsKKwkJCQkgICAgaW5kZXgrKykgeworCQkJCQlmY19wb3J0
X3QgKnNmY3A7CisKKwkJCQkJc3AgPSBoYS0+b3V0c3RhbmRpbmdfY21kc1tpbmRleF07CisJCQkJ
CWlmICghc3ApCisJCQkJCQljb250aW51ZTsKKwkJCQkJc2ZjcCA9IHNwLT5mY3BvcnQ7CisJCQkJ
CWlmICghKHNmY3AtPmZsYWdzICYgRkNGX1RBUEVfUFJFU0VOVCkpCisJCQkJCQljb250aW51ZTsK
IAotCQkJCXNwID0gaGEtPm91dHN0YW5kaW5nX2NtZHNbaW5kZXhdOwotCQkJCWlmICghc3ApCi0J
CQkJCWNvbnRpbnVlOwotCQkJCXNmY3AgPSBzcC0+ZmNwb3J0OwotCQkJCWlmICghKHNmY3AtPmZs
YWdzICYgRkNGX1RBUEVfUFJFU0VOVCkpCi0JCQkJCWNvbnRpbnVlOwotCi0JCQkJc2V0X2JpdChJ
U1BfQUJPUlRfTkVFREVELCAmaGEtPmRwY19mbGFncyk7Ci0JCQkJYnJlYWs7CisJCQkJCXNldF9i
aXQoSVNQX0FCT1JUX05FRURFRCwKKwkJCQkJICAgICZoYS0+ZHBjX2ZsYWdzKTsKKwkJCQkJYnJl
YWs7CisJCQkJfQorCQkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhhLT5oYXJkd2FyZV9sb2Nr
LAorCQkJCSAgICBjcHVfZmxhZ3MpOwogCQkJfQotCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
aGEtPmhhcmR3YXJlX2xvY2ssIGNwdV9mbGFncyk7Ci0KIAkJCXNldF9iaXQoQUJPUlRfUVVFVUVT
X05FRURFRCwgJmhhLT5kcGNfZmxhZ3MpOwogCQkJc3RhcnRfZHBjKys7CiAJCX0KQEAgLTI1NjYs
OCArMjU5MSw5IEBAIHFsYTJ4MDBfdGltZXIoc2NzaV9xbGFfaG9zdF90ICpoYSkKIAkgICAgdGVz
dF9iaXQoTE9HSU5fUkVUUllfTkVFREVELCAmaGEtPmRwY19mbGFncykgfHwKIAkgICAgdGVzdF9i
aXQoUkVTRVRfTUFSS0VSX05FRURFRCwgJmhhLT5kcGNfZmxhZ3MpIHx8CiAJICAgIHRlc3RfYml0
KEJFQUNPTl9CTElOS19ORUVERUQsICZoYS0+ZHBjX2ZsYWdzKSB8fAorCSAgICB0ZXN0X2JpdChW
UF9EUENfTkVFREVELCAmaGEtPmRwY19mbGFncykgfHwKIAkgICAgdGVzdF9iaXQoUkVMT0dJTl9O
RUVERUQsICZoYS0+ZHBjX2ZsYWdzKSkpCi0JCXFsYTJ4eHhfd2FrZV9kcGMoaGEpOworCQlxbGEy
eHh4X3dha2VfZHBjKHBoYSk7CiAKIAlxbGEyeDAwX3Jlc3RhcnRfdGltZXIoaGEsIFdBVENIX0lO
VEVSVkFMKTsKIH0KQEAgLTI3MTEsMTQgKzI3MzcsMjQgQEAgcWxhMngwMF9tb2R1bGVfaW5pdCh2
b2lkKQogCiAJcWxhMnh4eF90cmFuc3BvcnRfdGVtcGxhdGUgPQogCSAgICBmY19hdHRhY2hfdHJh
bnNwb3J0KCZxbGEyeHh4X3RyYW5zcG9ydF9mdW5jdGlvbnMpOwotCWlmICghcWxhMnh4eF90cmFu
c3BvcnRfdGVtcGxhdGUpCisJaWYgKCFxbGEyeHh4X3RyYW5zcG9ydF90ZW1wbGF0ZSkgeworCQlr
bWVtX2NhY2hlX2Rlc3Ryb3koc3JiX2NhY2hlcCk7CisJCXJldHVybiAtRU5PREVWOworCX0KKwlx
bGEyeHh4X3RyYW5zcG9ydF92cG9ydF90ZW1wbGF0ZSA9CisJICAgIGZjX2F0dGFjaF90cmFuc3Bv
cnQoJnFsYTJ4eHhfdHJhbnNwb3J0X3Zwb3J0X2Z1bmN0aW9ucyk7CisJaWYgKCFxbGEyeHh4X3Ry
YW5zcG9ydF92cG9ydF90ZW1wbGF0ZSkgeworCQlrbWVtX2NhY2hlX2Rlc3Ryb3koc3JiX2NhY2hl
cCk7CisJCWZjX3JlbGVhc2VfdHJhbnNwb3J0KHFsYTJ4eHhfdHJhbnNwb3J0X3RlbXBsYXRlKTsK
IAkJcmV0dXJuIC1FTk9ERVY7CisJfQogCiAJcHJpbnRrKEtFUk5fSU5GTyAiUUxvZ2ljIEZpYnJl
IENoYW5uZWwgSEJBIERyaXZlclxuIik7CiAJcmV0ID0gcGNpX3JlZ2lzdGVyX2RyaXZlcigmcWxh
Mnh4eF9wY2lfZHJpdmVyKTsKIAlpZiAocmV0KSB7CiAJCWttZW1fY2FjaGVfZGVzdHJveShzcmJf
Y2FjaGVwKTsKIAkJZmNfcmVsZWFzZV90cmFuc3BvcnQocWxhMnh4eF90cmFuc3BvcnRfdGVtcGxh
dGUpOworCQlmY19yZWxlYXNlX3RyYW5zcG9ydChxbGEyeHh4X3RyYW5zcG9ydF92cG9ydF90ZW1w
bGF0ZSk7CiAJfQogCXJldHVybiByZXQ7CiB9CkBAIC0yNzMzLDYgKzI3NjksNyBAQCBxbGEyeDAw
X21vZHVsZV9leGl0KHZvaWQpCiAJcWxhMngwMF9yZWxlYXNlX2Zpcm13YXJlKCk7CiAJa21lbV9j
YWNoZV9kZXN0cm95KHNyYl9jYWNoZXApOwogCWZjX3JlbGVhc2VfdHJhbnNwb3J0KHFsYTJ4eHhf
dHJhbnNwb3J0X3RlbXBsYXRlKTsKKwlmY19yZWxlYXNlX3RyYW5zcG9ydChxbGEyeHh4X3RyYW5z
cG9ydF92cG9ydF90ZW1wbGF0ZSk7CiB9CiAKIG1vZHVsZV9pbml0KHFsYTJ4MDBfbW9kdWxlX2lu
aXQpOwotLSAKMS41LjIuMi42MDMuZzdjODUxCgo=

------_=_NextPart_001_01C7BF41.885ADD64--
