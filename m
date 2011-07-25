From: michaelc@cs.wisc.edu
Subject: =?UTF-8?q?=5BPATCH=2017/19=5D=20qla4xxx=3A=20support=20iscsiadm=20session=20mgmt?=
Date: Mon, 25 Jul 2011 13:48:53 -0500
Message-ID: <1311619735-15323-18-git-send-email-michaelc@cs.wisc.edu>
References: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab1GYSqU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 14:46:20 -0400
In-Reply-To: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Manish Rangankar <manish.rangankar@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

=46rom: Manish Rangankar <manish.rangankar@qlogic.com>

Add scsi_transport_iscsi hooks in qla4xxx to support
iSCSI session management using iscsiadm.

This patch is based on discussion here
http://groups.google.com/group/open-iscsi/browse_thread/thread/e89fd888=
baf656a0#

Now users can use iscsiadm to do target discovery and do login/logout t=
o
individual targets using the qla4xxx iSCSI class interface.

This patch leaves some dead code, but to make it easier to review
we are leaving and in the next patch we will remove that old code.

V2 - NOTE: Added code to avoid waiting for AEN during login/logout
in the driver, instead added a kernel to user event
to notify iscsid about login status. Because of this
iscsid will not get blocked.

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_def.h  |   36 ++-
 drivers/scsi/qla4xxx/ql4_fw.h   |   82 +++-
 drivers/scsi/qla4xxx/ql4_glbl.h |   21 +-
 drivers/scsi/qla4xxx/ql4_init.c |  128 ++---
 drivers/scsi/qla4xxx/ql4_iocb.c |   66 +++
 drivers/scsi/qla4xxx/ql4_isr.c  |   81 +++-
 drivers/scsi/qla4xxx/ql4_mbx.c  |  360 +++++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c   | 1007 ++++++++++++++++++++++++++++++-=
--------
 8 files changed, 1416 insertions(+), 365 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_=
def.h
index b17f5c4..3e404fe 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -36,9 +36,12 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/scsi_bsg_iscsi.h>
 #include <scsi/scsi_netlink.h>
+#include <scsi/libiscsi.h>
=20
 #include "ql4_dbg.h"
 #include "ql4_nx.h"
+#include "ql4_fw.h"
+#include "ql4_nvram.h"
=20
 #ifndef PCI_DEVICE_ID_QLOGIC_ISP4010
 #define PCI_DEVICE_ID_QLOGIC_ISP4010	0x4010
@@ -112,7 +115,7 @@
 #define MAX_BUSES		1
 #define MAX_TARGETS		MAX_DEV_DB_ENTRIES
 #define MAX_LUNS		0xffff
-#define MAX_AEN_ENTRIES		256 /* should be > EXT_DEF_MAX_AEN_QUEUE */
+#define MAX_AEN_ENTRIES		MAX_DEV_DB_ENTRIES
 #define MAX_DDB_ENTRIES		MAX_DEV_DB_ENTRIES
 #define MAX_PDU_ENTRIES		32
 #define INVALID_ENTRY		0xFFFF
@@ -296,8 +299,6 @@ struct ddb_entry {
 #define DF_FO_MASKED		3
=20
=20
-#include "ql4_fw.h"
-#include "ql4_nvram.h"
=20
 struct ql82xx_hw_data {
 	/* Offsets for flash/nvram access (set to ~0 if not used). */
@@ -607,6 +608,33 @@ struct scsi_qla_host {
 #define	QLFLASH_WAITING		0
 #define	QLFLASH_READING		1
 #define	QLFLASH_WRITING		2
+	struct dma_pool *chap_dma_pool;
+#define CHAP_DMA_BLOCK_SIZE    512
+	struct workqueue_struct *task_wq;
+	unsigned long ddb_idx_map[MAX_DDB_ENTRIES / BITS_PER_LONG];
+};
+
+struct ql4_task_data {
+	struct scsi_qla_host *ha;
+	uint8_t iocb_req_cnt;
+	dma_addr_t data_dma;
+	void *req_buffer;
+	dma_addr_t req_dma;
+	void *resp_buffer;
+	dma_addr_t resp_dma;
+	uint32_t resp_len;
+	struct iscsi_task *task;
+	struct passthru_status sts;
+	struct work_struct task_work;
+};
+
+struct qla_endpoint {
+	struct Scsi_Host *host;
+	struct sockaddr dst_addr;
+};
+
+struct qla_conn {
+	struct qla_endpoint *qla_ep;
 };
=20
 static inline int is_ipv4_enabled(struct scsi_qla_host *ha)
@@ -657,7 +685,7 @@ static inline int adapter_up(struct scsi_qla_host *=
ha)
=20
 static inline struct scsi_qla_host* to_qla_host(struct Scsi_Host *shos=
t)
 {
-	return (struct scsi_qla_host *)shost->hostdata;
+	return (struct scsi_qla_host *)iscsi_host_priv(shost);
 }
=20
 static inline void __iomem* isp_semaphore(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_f=
w.h
index 83e009c..99098d5 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -331,9 +331,11 @@ struct qla_flt_region {
 #define MBOX_CMD_WRITE_FLASH			0x0025
 #define MBOX_CMD_READ_FLASH			0x0026
 #define MBOX_CMD_CLEAR_DATABASE_ENTRY		0x0031
+#define MBOX_CMD_CONN_OPEN			0x0074
 #define MBOX_CMD_CONN_CLOSE_SESS_LOGOUT		0x0056
-#define LOGOUT_OPTION_CLOSE_SESSION		0x01
-#define LOGOUT_OPTION_RELOGIN			0x02
+#define LOGOUT_OPTION_CLOSE_SESSION		0x0002
+#define LOGOUT_OPTION_RELOGIN			0x0004
+#define LOGOUT_OPTION_FREE_DDB			0x0008
 #define MBOX_CMD_EXECUTE_IOCB_A64		0x005A
 #define MBOX_CMD_INITIALIZE_FIRMWARE		0x0060
 #define MBOX_CMD_GET_INIT_FW_CTRL_BLOCK		0x0061
@@ -342,6 +344,7 @@ struct qla_flt_region {
 #define MBOX_CMD_GET_DATABASE_ENTRY		0x0064
 #define DDB_DS_UNASSIGNED			0x00
 #define DDB_DS_NO_CONNECTION_ACTIVE		0x01
+#define DDB_DS_DISCOVERY			0x02
 #define DDB_DS_SESSION_ACTIVE			0x04
 #define DDB_DS_SESSION_FAILED			0x06
 #define DDB_DS_LOGIN_IN_PROCESS			0x07
@@ -375,7 +378,10 @@ struct qla_flt_region {
 #define FW_ADDSTATE_DHCPv4_LEASE_EXPIRED	0x0008
 #define FW_ADDSTATE_LINK_UP			0x0010
 #define FW_ADDSTATE_ISNS_SVC_ENABLED		0x0020
+
 #define MBOX_CMD_GET_DATABASE_ENTRY_DEFAULTS	0x006B
+#define IPV6_DEFAULT_DDB_ENTRY			0x0001
+
 #define MBOX_CMD_CONN_OPEN_SESS_LOGIN		0x0074
 #define MBOX_CMD_GET_CRASH_RECORD		0x0076	/* 4010 only */
 #define MBOX_CMD_GET_CONN_EVENT_LOG		0x0077
@@ -463,7 +469,8 @@ struct addr_ctrl_blk {
 	uint8_t res0;	/* 07 */
 	uint16_t eth_mtu_size;	/* 08-09 */
 	uint16_t add_fw_options;	/* 0A-0B */
-#define SERIALIZE_TASK_MGMT		0x0400
+#define ADFWOPT_SERIALIZE_TASK_MGMT	0x0400
+#define ADFWOPT_AUTOCONN_DISABLE	0x0002
=20
 	uint8_t hb_interval;	/* 0C */
 	uint8_t inst_num; /* 0D */
@@ -655,11 +662,30 @@ struct addr_ctrl_blk_def {
=20
 /*********************************************************************=
****/
=20
+#define MAX_CHAP_ENTRIES_40XX	128
+#define MAX_CHAP_ENTRIES_82XX	1024
+
+struct ql4_chap_table {
+	uint16_t link;
+	uint8_t flags;
+	uint8_t secret_len;
+#define MIN_CHAP_SECRET_LEN	12
+#define MAX_CHAP_SECRET_LEN	100
+	uint8_t secret[MAX_CHAP_SECRET_LEN];
+#define MAX_CHAP_NAME_LEN	256
+	uint8_t name[MAX_CHAP_NAME_LEN];
+	uint16_t reserved;
+#define CHAP_VALID_COOKIE	0x4092
+#define CHAP_INVALID_COOKIE	0xFFEE
+	uint16_t cookie;
+};
+
 struct dev_db_entry {
 	uint16_t options;	/* 00-01 */
 #define DDB_OPT_DISC_SESSION  0x10
 #define DDB_OPT_TARGET	      0x02 /* device is a target */
 #define DDB_OPT_IPV6_DEVICE	0x100
+#define DDB_OPT_AUTO_SENDTGTS_DISABLE		0x40
 #define DDB_OPT_IPV6_NULL_LINK_LOCAL		0x800 /* post connection */
 #define DDB_OPT_IPV6_FW_DEFINED_LINK_LOCAL	0x800 /* pre connection */
=20
@@ -670,6 +696,7 @@ struct dev_db_entry {
 	uint16_t tcp_options;	/* 0A-0B */
 	uint16_t ip_options;	/* 0C-0D */
 	uint16_t iscsi_max_rcv_data_seg_len;	/* 0E-0F */
+#define BYTE_UNITS	512
 	uint32_t res1;	/* 10-13 */
 	uint16_t iscsi_max_snd_data_seg_len;	/* 14-15 */
 	uint16_t iscsi_first_burst_len;	/* 16-17 */
@@ -853,6 +880,7 @@ struct qla4_header {
=20
 	uint8_t entryStatus;
 	uint8_t systemDefined;
+#define SD_ISCSI_PDU	0x01
 	uint8_t entryCount;
=20
 	/* SyetemDefined definition */
@@ -1010,21 +1038,22 @@ struct passthru0 {
 	struct qla4_header hdr;		       /* 00-03 */
 	uint32_t handle;	/* 04-07 */
 	uint16_t target;	/* 08-09 */
-	uint16_t connectionID;	/* 0A-0B */
+	uint16_t connection_id;	/* 0A-0B */
 #define ISNS_DEFAULT_SERVER_CONN_ID	((uint16_t)0x8000)
=20
-	uint16_t controlFlags;	/* 0C-0D */
+	uint16_t control_flags;	/* 0C-0D */
 #define PT_FLAG_ETHERNET_FRAME		0x8000
 #define PT_FLAG_ISNS_PDU		0x8000
 #define PT_FLAG_SEND_BUFFER		0x0200
 #define PT_FLAG_WAIT_4_RESPONSE		0x0100
+#define PT_FLAG_ISCSI_PDU		0x1000
=20
 	uint16_t timeout;	/* 0E-0F */
 #define PT_DEFAULT_TIMEOUT		30 /* seconds */
=20
-	struct data_seg_a64 outDataSeg64;	/* 10-1B */
+	struct data_seg_a64 out_dsd;    /* 10-1B */
 	uint32_t res1;		/* 1C-1F */
-	struct data_seg_a64 inDataSeg64;	/* 20-2B */
+	struct data_seg_a64 in_dsd;     /* 20-2B */
 	uint8_t res2[20];	/* 2C-3F */
 };
=20
@@ -1057,4 +1086,43 @@ struct response {
 #define RESPONSE_PROCESSED	0xDEADDEAD	/* Signature */
 };
=20
+struct ql_iscsi_stats {
+	uint8_t reserved1[656]; /* 0000-028F */
+	uint32_t tx_cmd_pdu; /* 0290-0293 */
+	uint32_t tx_resp_pdu; /* 0294-0297 */
+	uint32_t rx_cmd_pdu; /* 0298-029B */
+	uint32_t rx_resp_pdu; /* 029C-029F */
+
+	uint64_t tx_data_octets; /* 02A0-02A7 */
+	uint64_t rx_data_octets; /* 02A8-02AF */
+
+	uint32_t hdr_digest_err; /* 02B0=E2=80=9302B3 */
+	uint32_t data_digest_err; /* 02B4=E2=80=9302B7 */
+	uint32_t conn_timeout_err; /* 02B8=E2=80=9302BB */
+	uint32_t framing_err; /* 02BC=E2=80=9302BF */
+
+	uint32_t tx_nopout_pdus; /* 02C0=E2=80=9302C3 */
+	uint32_t tx_scsi_cmd_pdus;  /* 02C4=E2=80=9302C7 */
+	uint32_t tx_tmf_cmd_pdus; /* 02C8=E2=80=9302CB */
+	uint32_t tx_login_cmd_pdus; /* 02CC=E2=80=9302CF */
+	uint32_t tx_text_cmd_pdus; /* 02D0=E2=80=9302D3 */
+	uint32_t tx_scsi_write_pdus; /* 02D4=E2=80=9302D7 */
+	uint32_t tx_logout_cmd_pdus; /* 02D8=E2=80=9302DB */
+	uint32_t tx_snack_req_pdus; /* 02DC=E2=80=9302DF */
+
+	uint32_t rx_nopin_pdus; /* 02E0=E2=80=9302E3 */
+	uint32_t rx_scsi_resp_pdus; /* 02E4=E2=80=9302E7 */
+	uint32_t rx_tmf_resp_pdus; /* 02E8=E2=80=9302EB */
+	uint32_t rx_login_resp_pdus; /* 02EC=E2=80=9302EF */
+	uint32_t rx_text_resp_pdus; /* 02F0=E2=80=9302F3 */
+	uint32_t rx_scsi_read_pdus; /* 02F4=E2=80=9302F7 */
+	uint32_t rx_logout_resp_pdus; /* 02F8=E2=80=9302FB */
+
+	uint32_t rx_r2t_pdus; /* 02FC=E2=80=9302FF */
+	uint32_t rx_async_pdus; /* 0300=E2=80=930303 */
+	uint32_t rx_reject_pdus; /* 0304=E2=80=930307 */
+
+	uint8_t reserved2[264]; /* 0x0308 - 0x040F */
+};
+
 #endif /*  _QLA4X_FW_H */
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4=
_glbl.h
index 77539ae..d802340 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -51,7 +51,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
 			    uint16_t *connection_id);
=20
 int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_i=
ndex,
-			  dma_addr_t fw_ddb_entry_dma);
+			  dma_addr_t fw_ddb_entry_dma, uint32_t *mbx_sts);
 uint8_t qla4xxx_get_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 			 uint32_t *mbox_sts, dma_addr_t init_fw_cb_dma);
 int qla4xxx_conn_close_sess_logout(struct scsi_qla_host *ha,
@@ -63,8 +63,7 @@ int qla4xxx_set_acb(struct scsi_qla_host *ha, uint32_=
t *mbox_cmd,
 		    uint32_t *mbox_sts, dma_addr_t acb_dma);
 int qla4xxx_get_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 		    uint32_t *mbox_sts, dma_addr_t acb_dma);
-void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
-				 struct ddb_entry *ddb_entry);
+void qla4xxx_mark_device_missing(struct iscsi_cls_session *cls_session=
);
 u16 rd_nvram_word(struct scsi_qla_host *ha, int offset);
 void qla4xxx_get_crash_record(struct scsi_qla_host *ha);
 struct ddb_entry *qla4xxx_alloc_sess(struct scsi_qla_host *ha);
@@ -150,7 +149,21 @@ int qla4_8xxx_device_state_handler(struct scsi_qla=
_host *ha);
 void qla4_8xxx_need_qsnt_handler(struct scsi_qla_host *ha);
 void qla4_8xxx_clear_drv_active(struct scsi_qla_host *ha);
 void qla4_8xxx_set_drv_active(struct scsi_qla_host *ha);
-
+int qla4xxx_conn_open(struct scsi_qla_host *ha, uint16_t fw_ddb_index)=
;
+int qla4xxx_set_param_ddbentry(struct scsi_qla_host *ha,
+			       struct ddb_entry *ddb_entry,
+			       struct iscsi_cls_conn *cls_conn,
+			       uint32_t *mbx_sts);
+int qla4xxx_session_logout_ddb(struct scsi_qla_host *ha,
+			       struct ddb_entry *ddb_entry, int options);
+int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t fw_ddb_in=
dex,
+			  uint32_t *mbx_sts);
+int qla4xxx_clear_ddb_entry(struct scsi_qla_host *ha, uint32_t fw_ddb_=
index);
+int qla4xxx_send_passthru0(struct iscsi_task *task);
+int qla4xxx_get_mgmt_data(struct scsi_qla_host *ha, uint16_t fw_ddb_in=
dex,
+			  uint16_t stats_size, dma_addr_t stats_dma);
+void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
+				       struct ddb_entry *ddb_entry);
 /* BSG Functions */
 int qla4xxx_bsg_request(struct bsg_job *bsg_job);
 int qla4xxx_process_vendor_specific(struct bsg_job *bsg_job);
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4=
_init.c
index 3068012..ca6b2c5 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -48,22 +48,15 @@ static void ql4xxx_set_mac_number(struct scsi_qla_h=
ost *ha)
  * @ha: pointer to host adapter structure.
  * @ddb_entry: pointer to device database entry
  *
- * This routine deallocates and unlinks the specified ddb_entry from t=
he
- * adapter's
+ * This routine marks a DDB entry INVALID
  **/
 void qla4xxx_free_ddb(struct scsi_qla_host *ha,
     struct ddb_entry *ddb_entry)
 {
-	/* Remove device entry from list */
-	list_del_init(&ddb_entry->list);
-
 	/* Remove device pointer from index mapping arrays */
 	ha->fw_ddb_index_map[ddb_entry->fw_ddb_index] =3D
 		(struct ddb_entry *) INVALID_ENTRY;
 	ha->tot_ddbs--;
-
-	/* Free memory and scsi-ml struct for device entry */
-	qla4xxx_destroy_sess(ddb_entry);
 }
=20
 /**
@@ -820,7 +813,8 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_h=
ost *ha)
 					((!ipv6_device &&
 					  *((uint32_t *)fw_ddb_entry->ip_addr))
 					 || ipv6_device)) {
-				qla4xxx_set_ddb_entry(ha, fw_ddb_index, 0);
+				qla4xxx_set_ddb_entry(ha, fw_ddb_index, 0,
+						      NULL);
 				if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index,
 							NULL, 0, NULL,
 							&next_fw_ddb_index,
@@ -927,7 +921,7 @@ int qla4xxx_reinitialize_ddb_list(struct scsi_qla_h=
ost *ha)
 				       ddb_entry->fw_ddb_index));
 			iscsi_unblock_session(ddb_entry->sess);
 		} else if (atomic_read(&ddb_entry->state) =3D=3D DDB_STATE_ONLINE)
-			qla4xxx_mark_device_missing(ha, ddb_entry);
+			qla4xxx_mark_device_missing(ddb_entry->sess);
 	}
 	return status;
 }
@@ -952,7 +946,7 @@ int qla4xxx_relogin_device(struct scsi_qla_host *ha=
,
 	DEBUG2(printk("scsi%ld: Relogin ddb [%d]. TOV=3D%d\n", ha->host_no,
 		      ddb_entry->fw_ddb_index, relogin_timer));
=20
-	qla4xxx_set_ddb_entry(ha, ddb_entry->fw_ddb_index, 0);
+	qla4xxx_set_ddb_entry(ha, ddb_entry->fw_ddb_index, 0, NULL);
=20
 	return QLA_SUCCESS;
 }
@@ -1418,88 +1412,66 @@ int qla4xxx_process_ddb_changed(struct scsi_qla=
_host *ha, uint32_t fw_ddb_index,
 		uint32_t state, uint32_t conn_err)
 {
 	struct ddb_entry * ddb_entry;
+	uint32_t old_fw_ddb_device_state;
+	int status =3D QLA_ERROR;
=20
 	/* check for out of range index */
 	if (fw_ddb_index >=3D MAX_DDB_ENTRIES)
-		return QLA_ERROR;
+		goto exit_ddb_event;
=20
 	/* Get the corresponging ddb entry */
 	ddb_entry =3D qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
 	/* Device does not currently exist in our database. */
 	if (ddb_entry =3D=3D NULL) {
-		if (state =3D=3D DDB_DS_SESSION_ACTIVE)
-			qla4xxx_add_device_dynamically(ha, fw_ddb_index);
-		return QLA_SUCCESS;
+		ql4_printk(KERN_ERR, ha, "%s: No ddb_entry at FW index [%d]\n",
+			   __func__, fw_ddb_index);
+		goto exit_ddb_event;
 	}
=20
-	/* Device already exists in our database. */
-	DEBUG2(printk("scsi%ld: %s DDB - old state=3D 0x%x, new state=3D0x%x =
for "
-		      "index [%d]\n", ha->host_no, __func__,
-		      ddb_entry->fw_ddb_device_state, state, fw_ddb_index));
+	old_fw_ddb_device_state =3D ddb_entry->fw_ddb_device_state;
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "%s: DDB - old state =3D 0x%x, new state =3D 0x%x for "
+			  "index [%d]\n", __func__,
+			  ddb_entry->fw_ddb_device_state, state, fw_ddb_index));
=20
 	ddb_entry->fw_ddb_device_state =3D state;
-	/* Device is back online. */
-	if ((ddb_entry->fw_ddb_device_state =3D=3D DDB_DS_SESSION_ACTIVE) &&
-	   (atomic_read(&ddb_entry->state) !=3D DDB_STATE_ONLINE)) {
-		atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
-		atomic_set(&ddb_entry->relogin_retry_count, 0);
-		atomic_set(&ddb_entry->relogin_timer, 0);
-		clear_bit(DF_RELOGIN, &ddb_entry->flags);
-		iscsi_unblock_session(ddb_entry->sess);
-		iscsi_session_event(ddb_entry->sess,
-				    ISCSI_KEVENT_CREATE_SESSION);
-		/*
-		 * Change the lun state to READY in case the lun TIMEOUT before
-		 * the device came back.
-		 */
-	} else if (ddb_entry->fw_ddb_device_state !=3D DDB_DS_SESSION_ACTIVE)=
 {
-		/* Device went away, mark device missing */
-		if (atomic_read(&ddb_entry->state) =3D=3D DDB_STATE_ONLINE) {
-			DEBUG2(ql4_printk(KERN_INFO, ha, "%s mark missing "
-					"ddb_entry 0x%p sess 0x%p conn 0x%p\n",
-					__func__, ddb_entry,
-					ddb_entry->sess, ddb_entry->conn));
-			qla4xxx_mark_device_missing(ha, ddb_entry);
-		}
=20
-		/*
-		 * Relogin if device state changed to a not active state.
-		 * However, do not relogin if a RELOGIN is in process, or
-		 * we are not allowed to relogin to this DDB.
-		 */
-		if (ddb_entry->fw_ddb_device_state =3D=3D DDB_DS_SESSION_FAILED &&
-		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
-		    qla4_is_relogin_allowed(ha, conn_err)) {
+	switch (old_fw_ddb_device_state) {
+	case DDB_DS_LOGIN_IN_PROCESS:
+		switch (state) {
+		case DDB_DS_SESSION_ACTIVE:
+		case DDB_DS_DISCOVERY:
+			iscsi_conn_login_event(ddb_entry->conn,
+					       ISCSI_CONN_STATE_LOGGED_IN);
+			qla4xxx_update_session_conn_param(ha, ddb_entry);
+			status =3D QLA_SUCCESS;
+			break;
+		case DDB_DS_SESSION_FAILED:
+		case DDB_DS_NO_CONNECTION_ACTIVE:
+			iscsi_conn_login_event(ddb_entry->conn,
+					       ISCSI_CONN_STATE_FREE);
+			status =3D QLA_SUCCESS;
+			break;
+		}
+		break;
+	case DDB_DS_SESSION_ACTIVE:
+		if (state =3D=3D DDB_DS_SESSION_FAILED) {
 			/*
-			 * This triggers a relogin.  After the relogin_timer
-			 * expires, the relogin gets scheduled.	 We must wait a
-			 * minimum amount of time since receiving an 0x8014 AEN
-			 * with failed device_state or a logout response before
-			 * we can issue another relogin.
-			 */
-			/* Firmware pads this timeout: (time2wait +1).
-			 * Driver retry to login should be longer than F/W.
-			 * Otherwise F/W will fail
-			 * set_ddb() mbx cmd with 0x4005 since it still
-			 * counting down its time2wait.
+			 * iscsi_session failure  will cause userspace to
+			 * stop the connection which in turn would block the
+			 * iscsi_session and start relogin
 			 */
-			atomic_set(&ddb_entry->relogin_timer, 0);
-			atomic_set(&ddb_entry->retry_relogin_timer,
-				   ddb_entry->default_time2wait + 4);
-			DEBUG(printk("scsi%ld: %s: ddb[%d] "
-			    "initiate relogin after %d seconds\n",
-			    ha->host_no, __func__,
-			    ddb_entry->fw_ddb_index,
-			    ddb_entry->default_time2wait + 4));
-		} else {
-			DEBUG(printk("scsi%ld: %s: ddb[%d] "
-			    "relogin not initiated, state =3D %d, "
-			    "ddb_entry->flags =3D 0x%lx\n",
-			    ha->host_no, __func__,
-			    ddb_entry->fw_ddb_index,
-			    ddb_entry->fw_ddb_device_state,
-			    ddb_entry->flags));
+			iscsi_session_failure(ddb_entry->sess->dd_data,
+					      ISCSI_ERR_CONN_FAILED);
+			status =3D QLA_SUCCESS;
 		}
+		break;
+	default:
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Unknown Event\n",
+				__func__));
+		break;
 	}
-	return QLA_SUCCESS;
+
+exit_ddb_event:
+	return status;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4=
_iocb.c
index 75fcd82..e9def62 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -381,3 +381,69 @@ queuing_error:
 	return QLA_ERROR;
 }
=20
+int qla4xxx_send_passthru0(struct iscsi_task *task)
+{
+	struct passthru0 *passthru_iocb;
+	struct iscsi_session *sess =3D task->conn->session;
+	struct ddb_entry *ddb_entry =3D sess->dd_data;
+	struct scsi_qla_host *ha =3D ddb_entry->ha;
+	struct ql4_task_data *task_data =3D task->dd_data;
+	uint16_t ctrl_flags =3D 0;
+	unsigned long flags;
+	int ret =3D QLA_ERROR;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	task_data->iocb_req_cnt =3D 1;
+	/* Put the IOCB on the request queue */
+	if (!qla4xxx_space_in_req_ring(ha, task_data->iocb_req_cnt))
+		goto queuing_error;
+
+	passthru_iocb =3D (struct passthru0 *) ha->request_ptr;
+
+	memset(passthru_iocb, 0, sizeof(struct passthru0));
+	passthru_iocb->hdr.entryType =3D ET_PASSTHRU0;
+	passthru_iocb->hdr.systemDefined =3D SD_ISCSI_PDU;
+	passthru_iocb->hdr.entryCount =3D task_data->iocb_req_cnt;
+	passthru_iocb->handle =3D task->itt;
+	passthru_iocb->target =3D cpu_to_le16(ddb_entry->fw_ddb_index);
+	passthru_iocb->timeout =3D cpu_to_le16(PT_DEFAULT_TIMEOUT);
+
+	/* Setup the out & in DSDs */
+	if (task->data_count) {
+		memcpy((uint8_t *)task_data->req_buffer +
+		       sizeof(struct iscsi_hdr), task->data, task->data_count);
+		ctrl_flags |=3D PT_FLAG_SEND_BUFFER;
+		passthru_iocb->out_dsd.base.addrLow =3D
+					cpu_to_le32(LSDW(task_data->req_dma));
+		passthru_iocb->out_dsd.base.addrHigh =3D
+					cpu_to_le32(MSDW(task_data->req_dma));
+		passthru_iocb->out_dsd.count =3D
+					cpu_to_le32(task->data_count +
+						    sizeof(struct iscsi_hdr));
+	}
+	if (task_data->resp_len) {
+		passthru_iocb->in_dsd.base.addrLow =3D
+					cpu_to_le32(LSDW(task_data->resp_dma));
+		passthru_iocb->in_dsd.base.addrHigh =3D
+					cpu_to_le32(MSDW(task_data->resp_dma));
+		passthru_iocb->in_dsd.count =3D
+			cpu_to_le32(task_data->resp_len);
+	}
+
+	ctrl_flags |=3D (PT_FLAG_ISCSI_PDU | PT_FLAG_WAIT_4_RESPONSE);
+	passthru_iocb->control_flags =3D cpu_to_le16(ctrl_flags);
+
+	/* Update the request pointer */
+	qla4xxx_advance_req_ring_ptr(ha);
+	wmb();
+
+	/* Track IOCB used */
+	ha->iocb_cnt +=3D task_data->iocb_req_cnt;
+	ha->req_q_count -=3D task_data->iocb_req_cnt;
+	ha->isp_ops->queue_iocb(ha);
+	ret =3D QLA_SUCCESS;
+
+queuing_error:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return ret;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_=
isr.c
index 0e72921..ee1104a 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -224,8 +224,8 @@ static void qla4xxx_status_entry(struct scsi_qla_ho=
st *ha,
 		 * I/O to this device.	We should get a ddb state change
 		 * AEN soon.
 		 */
-		if (atomic_read(&ddb_entry->state) =3D=3D DDB_STATE_ONLINE)
-			qla4xxx_mark_device_missing(ha, ddb_entry);
+		if (iscsi_is_session_online(ddb_entry->sess))
+			qla4xxx_mark_device_missing(ddb_entry->sess);
 		break;
=20
 	case SCS_DATA_UNDERRUN:
@@ -306,8 +306,8 @@ static void qla4xxx_status_entry(struct scsi_qla_ho=
st *ha,
 		 * send I/O to this device.  We should get a ddb
 		 * state change AEN soon.
 		 */
-		if (atomic_read(&ddb_entry->state) =3D=3D DDB_STATE_ONLINE)
-			qla4xxx_mark_device_missing(ha, ddb_entry);
+		if (iscsi_is_session_online(ddb_entry->sess))
+			qla4xxx_mark_device_missing(ddb_entry->sess);
=20
 		cmd->result =3D DID_TRANSPORT_DISRUPTED << 16;
 		break;
@@ -341,6 +341,51 @@ status_entry_exit:
 }
=20
 /**
+ * qla4xxx_passthru_status_entry - processes passthru status IOCBs (0x=
3C)
+ * @ha: Pointer to host adapter structure.
+ * @sts_entry: Pointer to status entry structure.
+ **/
+static void qla4xxx_passthru_status_entry(struct scsi_qla_host *ha,
+					  struct passthru_status *sts_entry)
+{
+	struct iscsi_task *task;
+	struct ddb_entry *ddb_entry;
+	struct ql4_task_data *task_data;
+	struct iscsi_cls_conn *cls_conn;
+	struct iscsi_conn *conn;
+	itt_t itt;
+	uint32_t fw_ddb_index;
+
+	itt =3D sts_entry->handle;
+	fw_ddb_index =3D le32_to_cpu(sts_entry->target);
+
+	ddb_entry =3D qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
+
+	if (ddb_entry =3D=3D NULL) {
+		ql4_printk(KERN_ERR, ha, "%s: Invalid target index =3D 0x%x\n",
+			   __func__, sts_entry->target);
+		return;
+	}
+
+	cls_conn =3D ddb_entry->conn;
+	conn =3D cls_conn->dd_data;
+	spin_lock(&conn->session->lock);
+	task =3D iscsi_itt_to_task(conn, itt);
+	spin_unlock(&conn->session->lock);
+
+	if (task =3D=3D NULL) {
+		ql4_printk(KERN_ERR, ha, "%s: Task is NULL\n", __func__);
+		return;
+	}
+
+	task_data =3D task->dd_data;
+	memcpy(&task_data->sts, sts_entry, sizeof(struct passthru_status));
+	ha->req_q_count +=3D task_data->iocb_req_cnt;
+	ha->iocb_cnt -=3D task_data->iocb_req_cnt;
+	queue_work(ha->task_wq, &task_data->task_work);
+}
+
+/**
  * qla4xxx_process_response_queue - process response queue completions
  * @ha: Pointer to host adapter structure.
  *
@@ -375,6 +420,14 @@ void qla4xxx_process_response_queue(struct scsi_ql=
a_host *ha)
 			break;
=20
 		case ET_PASSTHRU_STATUS:
+			if (sts_entry->hdr.systemDefined =3D=3D SD_ISCSI_PDU)
+				qla4xxx_passthru_status_entry(ha,
+					(struct passthru_status *)sts_entry);
+			else
+				ql4_printk(KERN_ERR, ha,
+					   "%s: Invalid status received\n",
+					   __func__);
+
 			break;
=20
 		case ET_STATUS_CONTINUATION:
@@ -1009,23 +1062,23 @@ void qla4xxx_process_aen(struct scsi_qla_host *=
 ha, uint8_t process_aen)
=20
 		switch (mbox_sts[0]) {
 		case MBOX_ASTS_DATABASE_CHANGED:
-			if (process_aen =3D=3D FLUSH_DDB_CHANGED_AENS) {
+			switch (process_aen) {
+			case FLUSH_DDB_CHANGED_AENS:
 				DEBUG2(printk("scsi%ld: AEN[%d] %04x, index "
 					      "[%d] state=3D%04x FLUSHED!\n",
 					      ha->host_no, ha->aen_out,
 					      mbox_sts[0], mbox_sts[2],
 					      mbox_sts[3]));
 				break;
+			case PROCESS_ALL_AENS:
+			default:
+				/* Specific device. */
+				if (mbox_sts[1] =3D=3D 1)
+					qla4xxx_process_ddb_changed(ha,
+						mbox_sts[2], mbox_sts[3],
+						mbox_sts[4]);
+				break;
 			}
-		case PROCESS_ALL_AENS:
-		default:
-			if (mbox_sts[1] =3D=3D 0) {	/* Global DB change. */
-				qla4xxx_reinitialize_ddb_list(ha);
-			} else if (mbox_sts[1] =3D=3D 1) {	/* Specific device. */
-				qla4xxx_process_ddb_changed(ha, mbox_sts[2],
-						mbox_sts[3], mbox_sts[4]);
-			}
-			break;
 		}
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_=
mbx.c
index ea04b6c..32e40cb 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -477,10 +477,11 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host=
 * ha)
=20
 	init_fw_cb->fw_options &=3D __constant_cpu_to_le16(~FWOPT_TARGET_MODE=
);
=20
-	/* Set bit for "serialize task mgmt" all other bits need to be zero *=
/
 	init_fw_cb->add_fw_options =3D 0;
 	init_fw_cb->add_fw_options |=3D
-	    __constant_cpu_to_le16(SERIALIZE_TASK_MGMT);
+			__constant_cpu_to_le16(ADFWOPT_SERIALIZE_TASK_MGMT);
+	init_fw_cb->add_fw_options |=3D
+			__constant_cpu_to_le16(ADFWOPT_AUTOCONN_DISABLE);
=20
 	if (qla4xxx_set_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma)
 		!=3D QLA_SUCCESS) {
@@ -706,19 +707,38 @@ exit_get_fwddb:
 	return status;
 }
=20
+int qla4xxx_conn_open(struct scsi_qla_host *ha, uint16_t fw_ddb_index)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status;
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] =3D MBOX_CMD_CONN_OPEN;
+	mbox_cmd[1] =3D fw_ddb_index;
+
+	status =3D qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0=
],
+					 &mbox_sts[0]);
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "%s: status =3D %d mbx0 =3D 0x%x mbx1 =3D 0x%x\n",
+			  __func__, status, mbox_sts[0], mbox_sts[1]));
+	return status;
+}
+
 /**
  * qla4xxx_set_fwddb_entry - sets a ddb entry.
  * @ha: Pointer to host adapter structure.
  * @fw_ddb_index: Firmware's device database index
- * @fw_ddb_entry: Pointer to firmware's ddb entry structure, or NULL.
+ * @fw_ddb_entry_dma: dma address of ddb entry
+ * @mbx_sts: mailbox 0 to be returned or NULL
  *
  * This routine initializes or updates the adapter's device database
- * entry for the specified device. It also triggers a login for the
- * specified device. Therefore, it may also be used as a secondary
- * login routine when a NULL pointer is specified for the fw_ddb_entry=
=2E
+ * entry for the specified device.
  **/
 int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_i=
ndex,
-			  dma_addr_t fw_ddb_entry_dma)
+			  dma_addr_t fw_ddb_entry_dma, uint32_t *mbx_sts)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
@@ -737,13 +757,41 @@ int qla4xxx_set_ddb_entry(struct scsi_qla_host * =
ha, uint16_t fw_ddb_index,
 	mbox_cmd[4] =3D sizeof(struct dev_db_entry);
=20
 	status =3D qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0=
],
-	    &mbox_sts[0]);
+					 &mbox_sts[0]);
+	if (mbx_sts)
+		*mbx_sts =3D mbox_sts[0];
 	DEBUG2(printk("scsi%ld: %s: status=3D%d mbx0=3D0x%x mbx4=3D0x%x\n",
 	    ha->host_no, __func__, status, mbox_sts[0], mbox_sts[4]);)
=20
 	return status;
 }
=20
+int qla4xxx_session_logout_ddb(struct scsi_qla_host *ha,
+			       struct ddb_entry *ddb_entry, int options)
+{
+	int status;
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] =3D MBOX_CMD_CONN_CLOSE_SESS_LOGOUT;
+	mbox_cmd[1] =3D ddb_entry->fw_ddb_index;
+	mbox_cmd[3] =3D options;
+
+	status =3D qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0=
],
+					 &mbox_sts[0]);
+	if (status !=3D QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "%s: MBOX_CMD_CONN_CLOSE_SESS_LOGOUT "
+				  "failed sts %04X %04X", __func__,
+				  mbox_sts[0], mbox_sts[1]));
+	}
+
+	return status;
+}
+
 /**
  * qla4xxx_get_crash_record - retrieves crash record.
  * @ha: Pointer to host adapter structure.
@@ -1119,7 +1167,7 @@ exit_about_fw:
 	return status;
 }
=20
-static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
+static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha, uint32_t =
options,
 				   dma_addr_t dma_addr)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
@@ -1129,6 +1177,7 @@ static int qla4xxx_get_default_ddb(struct scsi_ql=
a_host *ha,
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
=20
 	mbox_cmd[0] =3D MBOX_CMD_GET_DATABASE_ENTRY_DEFAULTS;
+	mbox_cmd[1] =3D options;
 	mbox_cmd[2] =3D LSDW(dma_addr);
 	mbox_cmd[3] =3D MSDW(dma_addr);
=20
@@ -1141,8 +1190,10 @@ static int qla4xxx_get_default_ddb(struct scsi_q=
la_host *ha,
 	return QLA_SUCCESS;
 }
=20
-static int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t *d=
db_index)
+int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t ddb_index=
,
+			  uint32_t *mbx_sts)
 {
+	int status;
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
=20
@@ -1150,30 +1201,26 @@ static int qla4xxx_req_ddb_entry(struct scsi_ql=
a_host *ha, uint32_t *ddb_index)
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
=20
 	mbox_cmd[0] =3D MBOX_CMD_REQUEST_DATABASE_ENTRY;
-	mbox_cmd[1] =3D MAX_PRST_DEV_DB_ENTRIES;
+	mbox_cmd[1] =3D ddb_index;
=20
-	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 3, &mbox_cmd[0], &mbo=
x_sts[0]) !=3D
-	    QLA_SUCCESS) {
-		if (mbox_sts[0] =3D=3D MBOX_STS_COMMAND_ERROR) {
-			*ddb_index =3D mbox_sts[2];
-		} else {
-			DEBUG2(printk("scsi%ld: %s: failed status %04X\n",
-			     ha->host_no, __func__, mbox_sts[0]));
-			return QLA_ERROR;
-		}
-	} else {
-		*ddb_index =3D MAX_PRST_DEV_DB_ENTRIES;
+	status =3D qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0=
],
+					 &mbox_sts[0]);
+	if (status !=3D QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: failed status %04X\n",
+				   __func__, mbox_sts[0]));
 	}
=20
-	return QLA_SUCCESS;
+	*mbx_sts =3D mbox_sts[0];
+	return status;
 }
=20
-
 int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t por=
t)
 {
 	struct dev_db_entry *fw_ddb_entry;
 	dma_addr_t fw_ddb_entry_dma;
 	uint32_t ddb_index;
+	uint32_t mbx_sts;
+	uint32_t options =3D 0;
 	int ret_val =3D QLA_SUCCESS;
=20
=20
@@ -1187,11 +1234,11 @@ int qla4xxx_send_tgts(struct scsi_qla_host *ha,=
 char *ip, uint16_t port)
 		goto exit_send_tgts_no_free;
 	}
=20
-	ret_val =3D qla4xxx_get_default_ddb(ha, fw_ddb_entry_dma);
+	ret_val =3D qla4xxx_get_default_ddb(ha, options, fw_ddb_entry_dma);
 	if (ret_val !=3D QLA_SUCCESS)
 		goto exit_send_tgts;
=20
-	ret_val =3D qla4xxx_req_ddb_entry(ha, &ddb_index);
+	ret_val =3D qla4xxx_req_ddb_entry(ha, &ddb_index, &mbx_sts);
 	if (ret_val !=3D QLA_SUCCESS)
 		goto exit_send_tgts;
=20
@@ -1213,7 +1260,7 @@ int qla4xxx_send_tgts(struct scsi_qla_host *ha, c=
har *ip, uint16_t port)
 	fw_ddb_entry->ip_addr[2] =3D *(ip + 2);
 	fw_ddb_entry->ip_addr[3] =3D *(ip + 3);
=20
-	ret_val =3D qla4xxx_set_ddb_entry(ha, ddb_index, fw_ddb_entry_dma);
+	ret_val =3D qla4xxx_set_ddb_entry(ha, ddb_index, fw_ddb_entry_dma, NU=
LL);
=20
 exit_send_tgts:
 	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
@@ -1222,6 +1269,28 @@ exit_send_tgts_no_free:
 	return ret_val;
 }
=20
+int qla4xxx_clear_ddb_entry(struct scsi_qla_host *ha, uint32_t ddb_ind=
ex)
+{
+	int status;
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] =3D MBOX_CMD_CLEAR_DATABASE_ENTRY;
+	mbox_cmd[1] =3D ddb_index;
+
+	status =3D qla4xxx_mailbox_command(ha, 2, 1, &mbox_cmd[0],
+					 &mbox_sts[0]);
+	if (status !=3D QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: failed status %04X\n",
+				   __func__, mbox_sts[0]));
+	}
+
+	return status;
+}
+
 int qla4xxx_set_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
 		      uint32_t offset, uint32_t length, uint32_t options)
 {
@@ -1248,6 +1317,42 @@ int qla4xxx_set_flash(struct scsi_qla_host *ha, =
dma_addr_t dma_addr,
 	return status;
 }
=20
+static int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username,
+			    char *password, uint16_t idx, int bidi)
+{
+	int ret =3D 0;
+	int rval =3D QLA_ERROR;
+	uint32_t offset =3D 0;
+	struct ql4_chap_table *chap_table;
+	dma_addr_t chap_dma;
+
+	chap_table =3D dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dm=
a);
+	if (chap_table =3D=3D NULL) {
+		ret =3D  -ENOMEM;
+		goto exit_set_chap;
+	}
+
+	memset(chap_table, 0, sizeof(struct ql4_chap_table));
+	if (bidi)
+		chap_table->flags |=3D BIT_6; /* peer */
+	else
+		chap_table->flags |=3D BIT_7; /* local */
+	chap_table->secret_len =3D strlen(password);
+	strncpy(chap_table->secret, password, MAX_CHAP_SECRET_LEN);
+	strncpy(chap_table->name, username, MAX_CHAP_NAME_LEN);
+	chap_table->cookie =3D __constant_cpu_to_le16(CHAP_VALID_COOKIE);
+	offset =3D 0x06000000 | (idx * sizeof(struct ql4_chap_table));
+	rval =3D qla4xxx_set_flash(ha, chap_dma, offset,
+				sizeof(struct ql4_chap_table),
+				FLASH_OPT_RMW_COMMIT);
+	dma_pool_free(ha->chap_dma_pool, chap_table, chap_dma);
+	if (rval !=3D QLA_SUCCESS)
+		ret =3D  -EINVAL;
+
+exit_set_chap:
+	return ret;
+}
+
 int qla4xxx_conn_close_sess_logout(struct scsi_qla_host *ha,
 				   uint16_t fw_ddb_index,
 				   uint16_t connection_id,
@@ -1337,3 +1442,204 @@ int qla4xxx_set_acb(struct scsi_qla_host *ha, u=
int32_t *mbox_cmd,
 	}
 	return status;
 }
+
+int qla4xxx_set_param_ddbentry(struct scsi_qla_host *ha,
+			       struct ddb_entry *ddb_entry,
+			       struct iscsi_cls_conn *cls_conn,
+			       uint32_t *mbx_sts)
+{
+	struct dev_db_entry *fw_ddb_entry;
+	struct iscsi_conn *conn;
+	struct iscsi_session *sess;
+	struct qla_conn *qla_conn;
+	struct sockaddr *dst_addr;
+	dma_addr_t fw_ddb_entry_dma;
+	int status =3D QLA_SUCCESS;
+	int rval =3D 0;
+	struct sockaddr_in *addr;
+	struct sockaddr_in6 *addr6;
+	char *ip;
+	uint16_t iscsi_opts =3D 0;
+	uint32_t options =3D 0;
+	uint16_t idx;
+	int max_chap_entries =3D 0;
+
+	fw_ddb_entry =3D dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_en=
try),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		DEBUG2(ql4_printk(KERN_ERR, ha,
+				  "%s: Unable to allocate dma buffer.\n",
+				  __func__));
+		rval =3D -ENOMEM;
+		goto exit_set_param_no_free;
+	}
+
+	conn =3D cls_conn->dd_data;
+	qla_conn =3D conn->dd_data;
+	sess =3D conn->session;
+	dst_addr =3D &qla_conn->qla_ep->dst_addr;
+
+	if (dst_addr->sa_family =3D=3D AF_INET6)
+		options |=3D IPV6_DEFAULT_DDB_ENTRY;
+
+	status =3D qla4xxx_get_default_ddb(ha, options, fw_ddb_entry_dma);
+	if (status =3D=3D QLA_ERROR) {
+		rval =3D -EINVAL;
+		goto exit_set_param;
+	}
+
+	iscsi_opts =3D le16_to_cpu(fw_ddb_entry->iscsi_options);
+	memset(fw_ddb_entry->iscsi_alias, 0, sizeof(fw_ddb_entry->iscsi_alias=
));
+
+	memset(fw_ddb_entry->iscsi_name, 0, sizeof(fw_ddb_entry->iscsi_name))=
;
+
+	if (sess->targetname !=3D NULL) {
+		memcpy(fw_ddb_entry->iscsi_name, sess->targetname,
+		       min(strlen(sess->targetname),
+		       sizeof(fw_ddb_entry->iscsi_name)));
+	}
+
+	memset(fw_ddb_entry->ip_addr, 0, sizeof(fw_ddb_entry->ip_addr));
+	memset(fw_ddb_entry->tgt_addr, 0, sizeof(fw_ddb_entry->tgt_addr));
+
+	fw_ddb_entry->options =3D  DDB_OPT_TARGET | DDB_OPT_AUTO_SENDTGTS_DIS=
ABLE;
+
+	if (dst_addr->sa_family =3D=3D AF_INET) {
+		addr =3D (struct sockaddr_in *)dst_addr;
+		ip =3D (char *)&addr->sin_addr;
+		memcpy(fw_ddb_entry->ip_addr, ip, IP_ADDR_LEN);
+		fw_ddb_entry->port =3D cpu_to_le16(ntohs(addr->sin_port));
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "%s: Destination Address [%pI4]: index [%d]\n",
+				   __func__, fw_ddb_entry->ip_addr,
+				  ddb_entry->fw_ddb_index));
+	} else if (dst_addr->sa_family =3D=3D AF_INET6) {
+		addr6 =3D (struct sockaddr_in6 *)dst_addr;
+		ip =3D (char *)&addr6->sin6_addr;
+		memcpy(fw_ddb_entry->ip_addr, ip, IPv6_ADDR_LEN);
+		fw_ddb_entry->port =3D cpu_to_le16(ntohs(addr6->sin6_port));
+		fw_ddb_entry->options |=3D DDB_OPT_IPV6_DEVICE;
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "%s: Destination Address [%pI6]: index [%d]\n",
+				   __func__, fw_ddb_entry->ip_addr,
+				  ddb_entry->fw_ddb_index));
+	} else {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Failed to get IP Address\n",
+			   __func__);
+		rval =3D -EINVAL;
+		goto exit_set_param;
+	}
+
+	if (is_qla8022(ha))
+		max_chap_entries =3D MAX_CHAP_ENTRIES_82XX;
+	else
+		max_chap_entries =3D MAX_CHAP_ENTRIES_40XX;
+	/* CHAP */
+	if (sess->username !=3D NULL && sess->password !=3D NULL) {
+		if (strlen(sess->username) && strlen(sess->password)) {
+			iscsi_opts |=3D BIT_7;
+			idx =3D ddb_entry->fw_ddb_index * 2;
+			if (idx > max_chap_entries) {
+				ql4_printk(KERN_ERR, ha,
+					   "%s: Invalid ddb or chap index\n",
+					   __func__);
+				rval  =3D -EINVAL;
+				goto exit_set_param;
+			}
+
+			rval =3D qla4xxx_set_chap(ha, sess->username,
+						sess->password, idx, 0);
+			if (rval)
+				goto exit_set_param;
+
+			fw_ddb_entry->chap_tbl_idx =3D cpu_to_le16(idx);
+		}
+	}
+
+	if (sess->username_in !=3D NULL && sess->password_in !=3D NULL) {
+		/* Check if BIDI CHAP */
+		if (strlen(sess->username_in) && strlen(sess->password_in)) {
+			iscsi_opts |=3D BIT_4;
+			idx =3D (ddb_entry->fw_ddb_index * 2) + 1;
+			if (idx > max_chap_entries) {
+				ql4_printk(KERN_ERR, ha,
+					   "%s: Invalid ddb or bidi chap "
+					   "index\n", __func__);
+				rval  =3D -EINVAL;
+				goto exit_set_param;
+			}
+			rval =3D qla4xxx_set_chap(ha, sess->username_in,
+						sess->password_in, idx, 0);
+			if (rval)
+				goto exit_set_param;
+		}
+	}
+
+	if (sess->initial_r2t_en)
+		iscsi_opts |=3D BIT_10;
+
+	if (sess->imm_data_en)
+		iscsi_opts |=3D BIT_11;
+
+	fw_ddb_entry->iscsi_options =3D cpu_to_le16(iscsi_opts);
+
+	if (conn->max_recv_dlength)
+		fw_ddb_entry->iscsi_max_rcv_data_seg_len =3D
+		  __constant_cpu_to_le16((conn->max_recv_dlength / BYTE_UNITS));
+
+	if (sess->max_r2t)
+		fw_ddb_entry->iscsi_max_outsnd_r2t =3D cpu_to_le16(sess->max_r2t);
+
+	if (sess->first_burst)
+		fw_ddb_entry->iscsi_first_burst_len =3D
+		       __constant_cpu_to_le16((sess->first_burst / BYTE_UNITS));
+
+	if (sess->max_burst)
+		fw_ddb_entry->iscsi_max_burst_len =3D
+			__constant_cpu_to_le16((sess->max_burst / BYTE_UNITS));
+
+	if (sess->time2wait)
+		fw_ddb_entry->iscsi_def_time2wait =3D
+			cpu_to_le16(sess->time2wait);
+
+	if (sess->time2retain)
+		fw_ddb_entry->iscsi_def_time2retain =3D
+			cpu_to_le16(sess->time2retain);
+
+	status =3D qla4xxx_set_ddb_entry(ha, ddb_entry->fw_ddb_index,
+				       fw_ddb_entry_dma, mbx_sts);
+
+	if (status !=3D QLA_SUCCESS)
+		rval =3D -EINVAL;
+exit_set_param:
+	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+			  fw_ddb_entry, fw_ddb_entry_dma);
+exit_set_param_no_free:
+	return rval;
+}
+
+int qla4xxx_get_mgmt_data(struct scsi_qla_host *ha, uint16_t fw_ddb_in=
dex,
+			  uint16_t stats_size, dma_addr_t stats_dma)
+{
+	int status =3D QLA_SUCCESS;
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(mbox_cmd, 0, sizeof(mbox_cmd[0]) * MBOX_REG_COUNT);
+	memset(mbox_sts, 0, sizeof(mbox_sts[0]) * MBOX_REG_COUNT);
+	mbox_cmd[0] =3D MBOX_CMD_GET_MANAGEMENT_DATA;
+	mbox_cmd[1] =3D fw_ddb_index;
+	mbox_cmd[2] =3D LSDW(stats_dma);
+	mbox_cmd[3] =3D MSDW(stats_dma);
+	mbox_cmd[4] =3D stats_size;
+
+	status =3D qla4xxx_mailbox_command(ha, 5, 1, &mbox_cmd[0], &mbox_sts[=
0]);
+	if (status !=3D QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha,
+				  "%s: MBOX_CMD_GET_MANAGEMENT_DATA "
+				  "failed w/ status %04X\n", __func__,
+				  mbox_sts[0]));
+	}
+	return status;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_o=
s.c
index 4e47bb1..2374475 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -63,6 +63,7 @@ MODULE_PARM_DESC(ql4xsess_recovery_tmo,
 		"Target Session Recovery Timeout.\n"
 		" Default: 30 sec.");
=20
+static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha);
 /*
  * SCSI host template entry points
  */
@@ -76,8 +77,6 @@ static int qla4xxx_tgt_dscvr(struct Scsi_Host *shost,
 			     struct sockaddr *dst_addr);
 static int qla4xxx_conn_get_param(struct iscsi_cls_conn *conn,
 				  enum iscsi_param param, char *buf);
-static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
-				  enum iscsi_param param, char *buf);
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf);
 static int qla4xxx_iface_set_param(struct Scsi_Host *shost, char *data=
,
@@ -85,9 +84,32 @@ static int qla4xxx_iface_set_param(struct Scsi_Host =
*shost, char *data,
 static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 				   enum iscsi_param_type param_type,
 				   int param, char *buf);
-static void qla4xxx_recovery_timedout(struct iscsi_cls_session *sessio=
n);
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_c=
mnd *sc);
-
+static struct iscsi_endpoint *qla4xxx_ep_connect(struct Scsi_Host *sho=
st,
+						 struct sockaddr *dst_addr,
+						 int non_blocking);
+static int qla4xxx_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);
+static void qla4xxx_ep_disconnect(struct iscsi_endpoint *ep);
+static int qla4xxx_get_ep_param(struct iscsi_endpoint *ep,
+				enum iscsi_param param, char *buf);
+static int qla4xxx_conn_start(struct iscsi_cls_conn *conn);
+static struct iscsi_cls_conn *
+qla4xxx_conn_create(struct iscsi_cls_session *cls_sess, uint32_t conn_=
idx);
+static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
+			     struct iscsi_cls_conn *cls_conn,
+			     uint64_t transport_fd, int is_leading);
+static void qla4xxx_conn_destroy(struct iscsi_cls_conn *conn);
+static struct iscsi_cls_session *
+qla4xxx_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
+			uint16_t qdepth, uint32_t initial_cmdsn);
+static void qla4xxx_session_destroy(struct iscsi_cls_session *sess);
+static void qla4xxx_task_work(struct work_struct *wdata);
+static int qla4xxx_alloc_pdu(struct iscsi_task *, uint8_t);
+static int qla4xxx_task_xmit(struct iscsi_task *);
+static void qla4xxx_task_cleanup(struct iscsi_task *);
+static void qla4xxx_fail_session(struct iscsi_cls_session *cls_session=
);
+static void qla4xxx_conn_get_stats(struct iscsi_cls_conn *cls_conn,
+				   struct iscsi_stats *stats);
 /*
  * SCSI host template entry points
  */
@@ -121,9 +143,6 @@ static struct scsi_host_template qla4xxx_driver_tem=
plate =3D {
 	.slave_alloc		=3D qla4xxx_slave_alloc,
 	.slave_destroy		=3D qla4xxx_slave_destroy,
=20
-	.scan_finished		=3D iscsi_scan_finished,
-	.scan_start		=3D qla4xxx_scan_start,
-
 	.this_id		=3D -1,
 	.cmd_per_lun		=3D 3,
 	.use_clustering		=3D ENABLE_CLUSTERING,
@@ -137,15 +156,34 @@ static struct scsi_host_template qla4xxx_driver_t=
emplate =3D {
 static struct iscsi_transport qla4xxx_iscsi_transport =3D {
 	.owner			=3D THIS_MODULE,
 	.name			=3D DRIVER_NAME,
-	.caps			=3D CAP_FW_DB | CAP_SENDTARGETS_OFFLOAD |
-				  CAP_DATA_PATH_OFFLOAD,
+	.caps			=3D CAP_TEXT_NEGO |
+				  CAP_DATA_PATH_OFFLOAD | CAP_HDRDGST |
+				  CAP_DATADGST | CAP_LOGIN_OFFLOAD |
+				  CAP_MULTI_R2T,
 	.tgt_dscvr		=3D qla4xxx_tgt_dscvr,
 	.attr_is_visible	=3D ql4_attr_is_visible,
+	.create_session         =3D qla4xxx_session_create,
+	.destroy_session        =3D qla4xxx_session_destroy,
+	.start_conn             =3D qla4xxx_conn_start,
+	.create_conn            =3D qla4xxx_conn_create,
+	.bind_conn              =3D qla4xxx_conn_bind,
+	.stop_conn              =3D iscsi_conn_stop,
+	.destroy_conn           =3D qla4xxx_conn_destroy,
+	.set_param              =3D iscsi_set_param,
 	.get_conn_param		=3D qla4xxx_conn_get_param,
-	.get_session_param	=3D qla4xxx_sess_get_param,
+	.get_session_param	=3D iscsi_session_get_param,
+	.get_ep_param           =3D qla4xxx_get_ep_param,
+	.ep_connect		=3D qla4xxx_ep_connect,
+	.ep_poll		=3D qla4xxx_ep_poll,
+	.ep_disconnect		=3D qla4xxx_ep_disconnect,
+	.get_stats		=3D qla4xxx_conn_get_stats,
+	.send_pdu		=3D iscsi_conn_send_pdu,
+	.xmit_task		=3D qla4xxx_task_xmit,
+	.cleanup_task		=3D qla4xxx_task_cleanup,
+	.alloc_pdu		=3D qla4xxx_alloc_pdu,
+
 	.get_host_param		=3D qla4xxx_host_get_param,
 	.set_iface_param	=3D qla4xxx_iface_set_param,
-	.session_recovery_timedout =3D qla4xxx_recovery_timedout,
 	.get_iface_param	=3D qla4xxx_get_iface_param,
 	.bsg_request		=3D qla4xxx_bsg_request,
 };
@@ -171,6 +209,11 @@ static mode_t ql4_attr_is_visible(int param_type, =
int param)
 		case ISCSI_PARAM_TARGET_NAME:
 		case ISCSI_PARAM_TPGT:
 		case ISCSI_PARAM_TARGET_ALIAS:
+		case ISCSI_PARAM_MAX_BURST:
+		case ISCSI_PARAM_MAX_R2T:
+		case ISCSI_PARAM_FIRST_BURST:
+		case ISCSI_PARAM_MAX_RECV_DLENGTH:
+		case ISCSI_PARAM_MAX_XMIT_DLENGTH:
 			return S_IRUGO;
 		default:
 			return 0;
@@ -302,36 +345,187 @@ static int qla4xxx_get_iface_param(struct iscsi_=
iface *iface,
 	return len;
 }
=20
-static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_c=
mnd *sc)
+static struct iscsi_endpoint *
+qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
+		   int non_blocking)
 {
-	struct iscsi_cls_session *session;
-	struct ddb_entry *ddb_entry;
+	int ret;
+	struct iscsi_endpoint *ep;
+	struct qla_endpoint *qla_ep;
+	struct scsi_qla_host *ha;
+	struct sockaddr_in *addr;
+	struct sockaddr_in6 *addr6;
=20
-	session =3D starget_to_session(scsi_target(sc->device));
-	ddb_entry =3D session->dd_data;
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	if (!shost) {
+		ret =3D -ENXIO;
+		printk(KERN_ERR "%s: shost is NULL\n",
+		       __func__);
+		return ERR_PTR(ret);
+	}
=20
-	/* if we are not logged in then the LLD is going to clean up the cmd =
*/
-	if (atomic_read(&ddb_entry->state) !=3D DDB_STATE_ONLINE)
-		return BLK_EH_RESET_TIMER;
-	else
-		return BLK_EH_NOT_HANDLED;
+	ha =3D iscsi_host_priv(shost);
+
+	ep =3D iscsi_create_endpoint(sizeof(struct qla_endpoint));
+	if (!ep) {
+		ret =3D -ENOMEM;
+		return ERR_PTR(ret);
+	}
+
+	qla_ep =3D ep->dd_data;
+	memset(qla_ep, 0, sizeof(struct qla_endpoint));
+	if (dst_addr->sa_family =3D=3D AF_INET) {
+		memcpy(&qla_ep->dst_addr, dst_addr, sizeof(struct sockaddr_in));
+		addr =3D (struct sockaddr_in *)&qla_ep->dst_addr;
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI4\n", __func__,
+				  (char *)&addr->sin_addr));
+	} else if (dst_addr->sa_family =3D=3D AF_INET6) {
+		memcpy(&qla_ep->dst_addr, dst_addr,
+		       sizeof(struct sockaddr_in6));
+		addr6 =3D (struct sockaddr_in6 *)&qla_ep->dst_addr;
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI6\n", __func__,
+				  (char *)&addr6->sin6_addr));
+	}
+
+	qla_ep->host =3D shost;
+
+	return ep;
 }
=20
-static void qla4xxx_recovery_timedout(struct iscsi_cls_session *sessio=
n)
+static int qla4xxx_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 {
-	struct ddb_entry *ddb_entry =3D session->dd_data;
-	struct scsi_qla_host *ha =3D ddb_entry->ha;
+	struct qla_endpoint *qla_ep;
+	struct scsi_qla_host *ha;
+	int ret =3D 0;
=20
-	if (atomic_read(&ddb_entry->state) !=3D DDB_STATE_ONLINE) {
-		atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	qla_ep =3D ep->dd_data;
+	ha =3D to_qla_host(qla_ep->host);
+
+	if (adapter_up(ha))
+		ret =3D 1;
+
+	return ret;
+}
+
+static void qla4xxx_ep_disconnect(struct iscsi_endpoint *ep)
+{
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	iscsi_destroy_endpoint(ep);
+}
+
+static int qla4xxx_get_ep_param(struct iscsi_endpoint *ep,
+				enum iscsi_param param,
+				char *buf)
+{
+	struct qla_endpoint *qla_ep =3D ep->dd_data;
+	struct sockaddr *dst_addr;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+
+	switch (param) {
+	case ISCSI_PARAM_CONN_PORT:
+	case ISCSI_PARAM_CONN_ADDRESS:
+		if (!qla_ep)
+			return -ENOTCONN;
=20
-		DEBUG2(printk("scsi%ld: %s: ddb [%d] session recovery timeout "
-			      "of (%d) secs exhausted, marking device DEAD.\n",
-			      ha->host_no, __func__, ddb_entry->fw_ddb_index,
-			      ddb_entry->sess->recovery_tmo));
+		dst_addr =3D (struct sockaddr *)&qla_ep->dst_addr;
+		if (!dst_addr)
+			return -ENOTCONN;
+
+		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
+						 &qla_ep->dst_addr, param, buf);
+	default:
+		return -ENOSYS;
 	}
 }
=20
+static void qla4xxx_conn_get_stats(struct iscsi_cls_conn *cls_conn,
+				   struct iscsi_stats *stats)
+{
+	struct iscsi_session *sess;
+	struct iscsi_cls_session *cls_sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	struct ql_iscsi_stats *ql_iscsi_stats;
+	int stats_size;
+	int ret;
+	dma_addr_t iscsi_stats_dma;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+
+	cls_sess =3D iscsi_conn_to_session(cls_conn);
+	sess =3D cls_sess->dd_data;
+	ddb_entry =3D sess->dd_data;
+	ha =3D ddb_entry->ha;
+
+	stats_size =3D PAGE_ALIGN(sizeof(struct ql_iscsi_stats));
+	/* Allocate memory */
+	ql_iscsi_stats =3D dma_alloc_coherent(&ha->pdev->dev, stats_size,
+					    &iscsi_stats_dma, GFP_KERNEL);
+	if (!ql_iscsi_stats) {
+		ql4_printk(KERN_ERR, ha,
+			   "Unable to allocate memory for iscsi stats\n");
+		goto exit_get_stats;
+	}
+
+	ret =3D  qla4xxx_get_mgmt_data(ha, ddb_entry->fw_ddb_index, stats_siz=
e,
+				     iscsi_stats_dma);
+	if (ret !=3D QLA_SUCCESS) {
+		ql4_printk(KERN_ERR, ha,
+			   "Unable to retreive iscsi stats\n");
+		goto free_stats;
+	}
+
+	/* octets */
+	stats->txdata_octets =3D le64_to_cpu(ql_iscsi_stats->tx_data_octets);
+	stats->rxdata_octets =3D le64_to_cpu(ql_iscsi_stats->rx_data_octets);
+	/* xmit pdus */
+	stats->noptx_pdus =3D le32_to_cpu(ql_iscsi_stats->tx_nopout_pdus);
+	stats->scsicmd_pdus =3D le32_to_cpu(ql_iscsi_stats->tx_scsi_cmd_pdus)=
;
+	stats->tmfcmd_pdus =3D le32_to_cpu(ql_iscsi_stats->tx_tmf_cmd_pdus);
+	stats->login_pdus =3D le32_to_cpu(ql_iscsi_stats->tx_login_cmd_pdus);
+	stats->text_pdus =3D le32_to_cpu(ql_iscsi_stats->tx_text_cmd_pdus);
+	stats->dataout_pdus =3D le32_to_cpu(ql_iscsi_stats->tx_scsi_write_pdu=
s);
+	stats->logout_pdus =3D le32_to_cpu(ql_iscsi_stats->tx_logout_cmd_pdus=
);
+	stats->snack_pdus =3D le32_to_cpu(ql_iscsi_stats->tx_snack_req_pdus);
+	/* recv pdus */
+	stats->noprx_pdus =3D le32_to_cpu(ql_iscsi_stats->rx_nopin_pdus);
+	stats->scsirsp_pdus =3D le32_to_cpu(ql_iscsi_stats->rx_scsi_resp_pdus=
);
+	stats->tmfrsp_pdus =3D le32_to_cpu(ql_iscsi_stats->rx_tmf_resp_pdus);
+	stats->textrsp_pdus =3D le32_to_cpu(ql_iscsi_stats->rx_text_resp_pdus=
);
+	stats->datain_pdus =3D le32_to_cpu(ql_iscsi_stats->rx_scsi_read_pdus)=
;
+	stats->logoutrsp_pdus =3D
+			le32_to_cpu(ql_iscsi_stats->rx_logout_resp_pdus);
+	stats->r2t_pdus =3D le32_to_cpu(ql_iscsi_stats->rx_r2t_pdus);
+	stats->async_pdus =3D le32_to_cpu(ql_iscsi_stats->rx_async_pdus);
+	stats->rjt_pdus =3D le32_to_cpu(ql_iscsi_stats->rx_reject_pdus);
+
+free_stats:
+	dma_free_coherent(&ha->pdev->dev, stats_size, ql_iscsi_stats,
+			  iscsi_stats_dma);
+exit_get_stats:
+	return;
+}
+
+static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_c=
mnd *sc)
+{
+	struct iscsi_cls_session *session;
+	struct iscsi_session *sess;
+	unsigned long flags;
+	enum blk_eh_timer_return ret =3D BLK_EH_NOT_HANDLED;
+
+	session =3D starget_to_session(scsi_target(sc->device));
+	sess =3D session->dd_data;
+
+	spin_lock_irqsave(&session->lock, flags);
+	if (session->state =3D=3D ISCSI_SESSION_FAILED)
+		ret =3D BLK_EH_RESET_TIMER;
+	spin_unlock_irqrestore(&session->lock, flags);
+
+	return ret;
+}
+
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf)
 {
@@ -730,54 +924,29 @@ exit_init_fw_cb:
 	return rval;
 }
=20
-static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
+static int qla4xxx_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				  enum iscsi_param param, char *buf)
 {
-	struct ddb_entry *ddb_entry =3D sess->dd_data;
-	int len;
-
-	switch (param) {
-	case ISCSI_PARAM_TARGET_NAME:
-		len =3D snprintf(buf, PAGE_SIZE - 1, "%s\n",
-			       ddb_entry->iscsi_name);
-		break;
-	case ISCSI_PARAM_TPGT:
-		len =3D sprintf(buf, "%u\n", ddb_entry->tpgt);
-		break;
-	case ISCSI_PARAM_TARGET_ALIAS:
-		len =3D snprintf(buf, PAGE_SIZE - 1, "%s\n",
-		    ddb_entry->iscsi_alias);
-		break;
-	default:
-		return -ENOSYS;
-	}
-
-	return len;
-}
-
-static int qla4xxx_conn_get_param(struct iscsi_cls_conn *conn,
-				  enum iscsi_param param, char *buf)
-{
-	struct iscsi_cls_session *session;
-	struct ddb_entry *ddb_entry;
-	int len;
+	struct iscsi_conn *conn;
+	struct qla_conn *qla_conn;
+	struct sockaddr *dst_addr;
+	int len =3D 0;
=20
-	session =3D iscsi_dev_to_session(conn->dev.parent);
-	ddb_entry =3D session->dd_data;
+	conn =3D cls_conn->dd_data;
+	qla_conn =3D conn->dd_data;
+	dst_addr =3D &qla_conn->qla_ep->dst_addr;
=20
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
-		len =3D sprintf(buf, "%hu\n", ddb_entry->port);
-		break;
 	case ISCSI_PARAM_CONN_ADDRESS:
-		/* TODO: what are the ipv6 bits */
-		len =3D sprintf(buf, "%pI4\n", &ddb_entry->ip_addr);
-		break;
+		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
+						 dst_addr, param, buf);
 	default:
-		return -ENOSYS;
+		return iscsi_conn_get_param(cls_conn, param, buf);
 	}
=20
 	return len;
+
 }
=20
 static int qla4xxx_tgt_dscvr(struct Scsi_Host *shost,
@@ -789,7 +958,7 @@ static int qla4xxx_tgt_dscvr(struct Scsi_Host *shos=
t,
 	struct sockaddr_in6 *addr6;
 	int ret =3D 0;
=20
-	ha =3D (struct scsi_qla_host *) shost->hostdata;
+	ha =3D (struct scsi_qla_host *) to_qla_host(shost);
=20
 	switch (type) {
 	case ISCSI_TGT_DSCVR_SEND_TARGETS:
@@ -815,6 +984,95 @@ static int qla4xxx_tgt_dscvr(struct Scsi_Host *sho=
st,
 	return ret;
 }
=20
+static struct iscsi_cls_session *
+qla4xxx_session_create(struct iscsi_endpoint *ep,
+			uint16_t cmds_max, uint16_t qdepth,
+			uint32_t initial_cmdsn)
+{
+	struct iscsi_cls_session *cls_sess;
+	struct scsi_qla_host *ha;
+	struct qla_endpoint *qla_ep;
+	struct ddb_entry *ddb_entry;
+	uint32_t ddb_index;
+	uint32_t mbx_sts =3D 0;
+	struct iscsi_session *sess;
+	struct sockaddr *dst_addr;
+	int ret;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	if (!ep) {
+		printk(KERN_ERR "qla4xxx: missing ep.\n");
+		return NULL;
+	}
+
+	qla_ep =3D ep->dd_data;
+	dst_addr =3D (struct sockaddr *)&qla_ep->dst_addr;
+	ha =3D to_qla_host(qla_ep->host);
+get_ddb_index:
+	ddb_index =3D find_first_zero_bit(ha->ddb_idx_map, MAX_DDB_ENTRIES);
+
+	if (ddb_index >=3D MAX_DDB_ENTRIES) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "Free DDB index not available\n"));
+		return NULL;
+	}
+
+	if (test_and_set_bit(ddb_index, ha->ddb_idx_map))
+		goto get_ddb_index;
+
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "Found a free DDB index at %d\n", ddb_index));
+	ret =3D qla4xxx_req_ddb_entry(ha, ddb_index, &mbx_sts);
+	if (ret =3D=3D QLA_ERROR) {
+		if (mbx_sts =3D=3D MBOX_STS_COMMAND_ERROR) {
+			ql4_printk(KERN_INFO, ha,
+				   "DDB index =3D %d not available trying next\n",
+				   ddb_index);
+			goto get_ddb_index;
+		}
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "Free FW DDB not available\n"));
+		return NULL;
+	}
+
+	cls_sess =3D iscsi_session_setup(&qla4xxx_iscsi_transport, qla_ep->ho=
st,
+				       cmds_max, sizeof(struct ddb_entry),
+				       sizeof(struct ql4_task_data),
+				       initial_cmdsn, ddb_index);
+	if (!cls_sess)
+		return NULL;
+
+	sess =3D cls_sess->dd_data;
+	ddb_entry =3D sess->dd_data;
+	ddb_entry->fw_ddb_index =3D ddb_index;
+	ddb_entry->fw_ddb_device_state =3D DDB_DS_NO_CONNECTION_ACTIVE;
+	ddb_entry->ha =3D ha;
+	ddb_entry->sess =3D cls_sess;
+	cls_sess->recovery_tmo =3D ql4xsess_recovery_tmo;
+	ha->fw_ddb_index_map[ddb_entry->fw_ddb_index] =3D ddb_entry;
+	ha->tot_ddbs++;
+
+	return cls_sess;
+}
+
+static void qla4xxx_session_destroy(struct iscsi_cls_session *cls_sess=
)
+{
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	unsigned long flags;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	sess =3D cls_sess->dd_data;
+	ddb_entry =3D sess->dd_data;
+	ha =3D ddb_entry->ha;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	qla4xxx_free_ddb(ha, ddb_entry);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	iscsi_session_teardown(cls_sess);
+}
+
 void qla4xxx_destroy_sess(struct ddb_entry *ddb_entry)
 {
 	if (!ddb_entry->sess)
@@ -827,6 +1085,350 @@ void qla4xxx_destroy_sess(struct ddb_entry *ddb_=
entry)
 	iscsi_free_session(ddb_entry->sess);
 }
=20
+static struct iscsi_cls_conn *
+qla4xxx_conn_create(struct iscsi_cls_session *cls_sess, uint32_t conn_=
idx)
+{
+	struct iscsi_cls_conn *cls_conn;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	cls_conn =3D iscsi_conn_setup(cls_sess, sizeof(struct qla_conn),
+				    conn_idx);
+	sess =3D cls_sess->dd_data;
+	ddb_entry =3D sess->dd_data;
+	ddb_entry->conn =3D cls_conn;
+
+	return cls_conn;
+}
+
+static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
+			     struct iscsi_cls_conn *cls_conn,
+			     uint64_t transport_fd, int is_leading)
+{
+	struct iscsi_conn *conn;
+	struct qla_conn *qla_conn;
+	struct iscsi_endpoint *ep;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
+		return -EINVAL;
+	ep =3D iscsi_lookup_endpoint(transport_fd);
+	conn =3D cls_conn->dd_data;
+	qla_conn =3D conn->dd_data;
+	qla_conn->qla_ep =3D ep->dd_data;
+	return 0;
+}
+
+static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
+{
+	struct iscsi_cls_session *cls_sess =3D iscsi_conn_to_session(cls_conn=
);
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	struct dev_db_entry *fw_ddb_entry;
+	dma_addr_t fw_ddb_entry_dma;
+	uint32_t fw_ddb_device_state;
+	uint32_t mbx_sts =3D 0;
+	int ret =3D 0;
+	int status =3D QLA_SUCCESS;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	sess =3D cls_sess->dd_data;
+	ddb_entry =3D sess->dd_data;
+	ha =3D ddb_entry->ha;
+
+	fw_ddb_entry =3D dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_en=
try),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Unable to allocate dma buffer\n", __func__);
+		return -ENOMEM;
+	}
+
+	ret =3D qla4xxx_set_param_ddbentry(ha, ddb_entry, cls_conn, &mbx_sts)=
;
+	if (ret) {
+		/* If iscsid is stopped and started then no need to do
+		* set param again since ddb state will be already
+		* active and FW does not allow set ddb to an
+		* active session.
+		*/
+		if (mbx_sts)
+			if (ddb_entry->fw_ddb_device_state =3D=3D
+							DDB_DS_SESSION_ACTIVE)
+				goto exit_set_param;
+
+		ql4_printk(KERN_ERR, ha, "%s: Failed set param for index[%d]\n",
+			   __func__, ddb_entry->fw_ddb_index);
+		goto exit_conn_start;
+	}
+
+	status =3D qla4xxx_conn_open(ha, ddb_entry->fw_ddb_index);
+	if (status =3D=3D QLA_ERROR) {
+		ql4_printk(KERN_ERR, ha, "%s: Login failed: %s %s:%d\n",
+			   __func__, ddb_entry->iscsi_name,
+			   ddb_entry->ip_addr, ddb_entry->port);
+		ret =3D -EINVAL;
+		goto exit_conn_start;
+	}
+
+	ddb_entry->fw_ddb_device_state =3D DDB_DS_LOGIN_IN_PROCESS;
+
+exit_set_param:
+	iscsi_conn_start(cls_conn);
+	ret =3D 0;
+
+exit_conn_start:
+	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+			  fw_ddb_entry, fw_ddb_entry_dma);
+	return ret;
+}
+
+static void qla4xxx_conn_destroy(struct iscsi_cls_conn *cls_conn)
+{
+	struct iscsi_cls_session *cls_sess =3D iscsi_conn_to_session(cls_conn=
);
+	struct iscsi_session *sess;
+	struct scsi_qla_host *ha;
+	struct ddb_entry *ddb_entry;
+	int options;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	sess =3D cls_sess->dd_data;
+	ddb_entry =3D sess->dd_data;
+	ha =3D ddb_entry->ha;
+
+	options =3D LOGOUT_OPTION_CLOSE_SESSION;
+	if (qla4xxx_session_logout_ddb(ha, ddb_entry, options) =3D=3D QLA_ERR=
OR)
+		ql4_printk(KERN_ERR, ha, "%s: Logout failed\n", __func__);
+	else
+		qla4xxx_clear_ddb_entry(ha, ddb_entry->fw_ddb_index);
+
+	/*
+	 * Clear the DDB bit so that next login can use the bit
+	 * if FW is not clearing the DDB entry then set DDB will fail anyways
+	 */
+	clear_bit(ddb_entry->fw_ddb_index, ha->ddb_idx_map);
+}
+
+static void qla4xxx_task_work(struct work_struct *wdata)
+{
+	struct ql4_task_data *task_data;
+	struct scsi_qla_host *ha;
+	struct passthru_status *sts;
+	struct iscsi_task *task;
+	struct iscsi_hdr *hdr;
+	uint8_t *data;
+	uint32_t data_len;
+	struct iscsi_conn *conn;
+	int hdr_len;
+	itt_t itt;
+
+	task_data =3D container_of(wdata, struct ql4_task_data, task_work);
+	ha =3D task_data->ha;
+	task =3D task_data->task;
+	sts =3D &task_data->sts;
+	hdr_len =3D sizeof(struct iscsi_hdr);
+
+	DEBUG3(printk(KERN_INFO "Status returned\n"));
+	DEBUG3(qla4xxx_dump_buffer(sts, 64));
+	DEBUG3(printk(KERN_INFO "Response buffer"));
+	DEBUG3(qla4xxx_dump_buffer(task_data->resp_buffer, 64));
+
+	conn =3D task->conn;
+
+	switch (sts->completionStatus) {
+	case PASSTHRU_STATUS_COMPLETE:
+		hdr =3D (struct iscsi_hdr *)task_data->resp_buffer;
+		/* Assign back the itt in hdr, until we use the PREASSIGN_TAG */
+		itt =3D sts->handle;
+		hdr->itt =3D itt;
+		data =3D task_data->resp_buffer + hdr_len;
+		data_len =3D task_data->resp_len - hdr_len;
+		iscsi_complete_pdu(conn, hdr, data, data_len);
+		break;
+	default:
+		ql4_printk(KERN_ERR, ha, "Passthru failed status =3D 0x%x\n",
+			   sts->completionStatus);
+		break;
+	}
+	return;
+}
+
+static int qla4xxx_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
+{
+	struct ql4_task_data *task_data;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	int hdr_len;
+
+	sess =3D task->conn->session;
+	ddb_entry =3D sess->dd_data;
+	ha =3D ddb_entry->ha;
+	task_data =3D task->dd_data;
+	memset(task_data, 0, sizeof(struct ql4_task_data));
+
+	if (task->sc) {
+		ql4_printk(KERN_INFO, ha,
+			   "%s: SCSI Commands not implemented\n", __func__);
+		return -EINVAL;
+	}
+
+	hdr_len =3D sizeof(struct iscsi_hdr);
+	task_data->ha =3D ha;
+	task_data->task =3D task;
+
+	if (task->data_count) {
+		task_data->data_dma =3D dma_map_single(&ha->pdev->dev, task->data,
+						     task->data_count,
+						     PCI_DMA_TODEVICE);
+	}
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: MaxRecvLen %u, iscsi hrd %d\n",
+		      __func__, task->conn->max_recv_dlength, hdr_len));
+
+	task_data->resp_len =3D task->conn->max_recv_dlength;
+	task_data->resp_buffer =3D dma_alloc_coherent(&ha->pdev->dev,
+						    task_data->resp_len,
+						    &task_data->resp_dma,
+						    GFP_ATOMIC);
+	if (!task_data->resp_buffer)
+		goto exit_alloc_pdu;
+
+	task_data->req_buffer =3D dma_alloc_coherent(&ha->pdev->dev,
+						   task->data_count + hdr_len,
+						   &task_data->req_dma,
+						   GFP_ATOMIC);
+	if (!task_data->req_buffer)
+		goto exit_alloc_pdu;
+
+	task->hdr =3D task_data->req_buffer;
+
+	INIT_WORK(&task_data->task_work, qla4xxx_task_work);
+
+	return 0;
+
+exit_alloc_pdu:
+	if (task_data->resp_buffer)
+		dma_free_coherent(&ha->pdev->dev, task_data->resp_len,
+				  task_data->resp_buffer, task_data->resp_dma);
+
+	if (task_data->req_buffer)
+		dma_free_coherent(&ha->pdev->dev, task->data_count + hdr_len,
+				  task_data->req_buffer, task_data->req_dma);
+	return -ENOMEM;
+}
+
+static void qla4xxx_task_cleanup(struct iscsi_task *task)
+{
+	struct ql4_task_data *task_data;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	int hdr_len;
+
+	hdr_len =3D sizeof(struct iscsi_hdr);
+	sess =3D task->conn->session;
+	ddb_entry =3D sess->dd_data;
+	ha =3D ddb_entry->ha;
+	task_data =3D task->dd_data;
+
+	if (task->data_count) {
+		dma_unmap_single(&ha->pdev->dev, task_data->data_dma,
+				 task->data_count, PCI_DMA_TODEVICE);
+	}
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: MaxRecvLen %u, iscsi hrd %d\n",
+		      __func__, task->conn->max_recv_dlength, hdr_len));
+
+	dma_free_coherent(&ha->pdev->dev, task_data->resp_len,
+			  task_data->resp_buffer, task_data->resp_dma);
+	dma_free_coherent(&ha->pdev->dev, task->data_count + hdr_len,
+			  task_data->req_buffer, task_data->req_dma);
+	return;
+}
+
+static int qla4xxx_task_xmit(struct iscsi_task *task)
+{
+	struct scsi_cmnd *sc =3D task->sc;
+	struct iscsi_session *sess =3D task->conn->session;
+	struct ddb_entry *ddb_entry =3D sess->dd_data;
+	struct scsi_qla_host *ha =3D ddb_entry->ha;
+
+	if (!sc)
+		return qla4xxx_send_passthru0(task);
+
+	ql4_printk(KERN_INFO, ha, "%s: scsi cmd xmit not implemented\n",
+		   __func__);
+	return -ENOSYS;
+}
+
+void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
+				       struct ddb_entry *ddb_entry)
+{
+	struct iscsi_cls_session *cls_sess;
+	struct iscsi_cls_conn *cls_conn;
+	struct iscsi_session *sess;
+	struct iscsi_conn *conn;
+	uint32_t ddb_state;
+	dma_addr_t fw_ddb_entry_dma;
+	struct dev_db_entry *fw_ddb_entry;
+
+	fw_ddb_entry =3D dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_en=
try),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Unable to allocate dma buffer\n", __func__);
+		return;
+	}
+
+	if (qla4xxx_get_fwddb_entry(ha, ddb_entry->fw_ddb_index, fw_ddb_entry=
,
+				    fw_ddb_entry_dma, NULL, NULL, &ddb_state,
+				    NULL, NULL, NULL) =3D=3D QLA_ERROR) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "scsi%ld: %s: failed "
+				  "get_ddb_entry for fw_ddb_index %d\n",
+				  ha->host_no, __func__,
+				  ddb_entry->fw_ddb_index));
+		return;
+	}
+
+	cls_sess =3D ddb_entry->sess;
+	sess =3D cls_sess->dd_data;
+
+	cls_conn =3D ddb_entry->conn;
+	conn =3D cls_conn->dd_data;
+
+	/* Update params */
+	conn->max_recv_dlength =3D BYTE_UNITS *
+			  le16_to_cpu(fw_ddb_entry->iscsi_max_rcv_data_seg_len);
+
+	conn->max_xmit_dlength =3D BYTE_UNITS *
+			  le16_to_cpu(fw_ddb_entry->iscsi_max_snd_data_seg_len);
+
+	sess->initial_r2t_en =3D
+			    (BIT_10 & le16_to_cpu(fw_ddb_entry->iscsi_options));
+
+	sess->max_r2t =3D le16_to_cpu(fw_ddb_entry->iscsi_max_outsnd_r2t);
+
+	sess->imm_data_en =3D (BIT_11 & le16_to_cpu(fw_ddb_entry->iscsi_optio=
ns));
+
+	sess->first_burst =3D BYTE_UNITS *
+			       le16_to_cpu(fw_ddb_entry->iscsi_first_burst_len);
+
+	sess->max_burst =3D BYTE_UNITS *
+				 le16_to_cpu(fw_ddb_entry->iscsi_max_burst_len);
+
+	sess->time2wait =3D le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
+
+	sess->time2retain =3D le16_to_cpu(fw_ddb_entry->iscsi_def_time2retain=
);
+
+	sess->tpgt =3D le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
+
+	memcpy(sess->initiatorname, ha->name_string,
+	       min(sizeof(ha->name_string), sizeof(sess->initiatorname)));
+}
+
 int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
 {
 	int err;
@@ -870,7 +1472,7 @@ struct ddb_entry *qla4xxx_alloc_sess(struct scsi_q=
la_host *ha)
=20
 static void qla4xxx_scan_start(struct Scsi_Host *shost)
 {
-	struct scsi_qla_host *ha =3D shost_priv(shost);
+	struct scsi_qla_host *ha =3D to_qla_host(shost);
 	struct ddb_entry *ddb_entry, *ddbtemp;
=20
 	/* finish setup of sessions that were already setup in firmware */
@@ -904,25 +1506,15 @@ static void qla4xxx_stop_timer(struct scsi_qla_h=
ost *ha)
 }
=20
 /***
- * qla4xxx_mark_device_missing - mark a device as missing.
- * @ha: Pointer to host adapter structure.
+ * qla4xxx_mark_device_missing - blocks the session
+ * @cls_session: Pointer to the session to be blocked
  * @ddb_entry: Pointer to device database entry
  *
  * This routine marks a device missing and close connection.
  **/
-void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
-				 struct ddb_entry *ddb_entry)
+void qla4xxx_mark_device_missing(struct iscsi_cls_session *cls_session=
)
 {
-	if ((atomic_read(&ddb_entry->state) !=3D DDB_STATE_DEAD)) {
-		atomic_set(&ddb_entry->state, DDB_STATE_MISSING);
-		DEBUG2(printk("scsi%ld: ddb [%d] marked MISSING\n",
-		    ha->host_no, ddb_entry->fw_ddb_index));
-	} else
-		DEBUG2(printk("scsi%ld: ddb [%d] DEAD\n", ha->host_no,
-		    ddb_entry->fw_ddb_index))
-
-	iscsi_block_session(ddb_entry->sess);
-	iscsi_conn_error_event(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
+	iscsi_block_session(cls_session);
 }
=20
 /**
@@ -933,10 +1525,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_=
host *ha,
  **/
 void qla4xxx_mark_all_devices_missing(struct scsi_qla_host *ha)
 {
-	struct ddb_entry *ddb_entry, *ddbtemp;
-	list_for_each_entry_safe(ddb_entry, ddbtemp, &ha->ddb_list, list) {
-		qla4xxx_mark_device_missing(ha, ddb_entry);
-	}
+	iscsi_host_for_each_session(ha->host, qla4xxx_mark_device_missing);
 }
=20
 static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
@@ -1023,20 +1612,13 @@ static int qla4xxx_queuecommand(struct Scsi_Hos=
t *host, struct scsi_cmnd *cmd)
 		goto qc_fail_command;
 	}
=20
-	if (atomic_read(&ddb_entry->state) !=3D DDB_STATE_ONLINE) {
-		if (atomic_read(&ddb_entry->state) =3D=3D DDB_STATE_DEAD) {
-			cmd->result =3D DID_NO_CONNECT << 16;
-			goto qc_fail_command;
-		}
-		return SCSI_MLQUEUE_TARGET_BUSY;
-	}
-
 	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
 	    test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags) ||
 	    test_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags) ||
 	    !test_bit(AF_ONLINE, &ha->flags) ||
+	    !test_bit(AF_LINK_UP, &ha->flags) ||
 	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))
 		goto qc_host_busy;
=20
@@ -1091,6 +1673,9 @@ static void qla4xxx_mem_free(struct scsi_qla_host=
 *ha)
=20
 	ha->srb_mempool =3D NULL;
=20
+	if (ha->chap_dma_pool)
+		dma_pool_destroy(ha->chap_dma_pool);
+
 	/* release io space registers  */
 	if (is_qla8022(ha)) {
 		if (ha->nx_pcibase)
@@ -1164,6 +1749,15 @@ static int qla4xxx_mem_alloc(struct scsi_qla_hos=
t *ha)
 		goto mem_alloc_error_exit;
 	}
=20
+	ha->chap_dma_pool =3D dma_pool_create("ql4_chap", &ha->pdev->dev,
+					    CHAP_DMA_BLOCK_SIZE, 8, 0);
+
+	if (ha->chap_dma_pool =3D=3D NULL) {
+		ql4_printk(KERN_WARNING, ha,
+		    "%s: chap_dma_pool allocation failed..\n", __func__);
+		goto mem_alloc_error_exit;
+	}
+
 	return QLA_SUCCESS;
=20
 mem_alloc_error_exit:
@@ -1281,7 +1875,6 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
  **/
 static void qla4xxx_timer(struct scsi_qla_host *ha)
 {
-	struct ddb_entry *ddb_entry, *dtemp;
 	int start_dpc =3D 0;
 	uint16_t w;
=20
@@ -1301,69 +1894,6 @@ static void qla4xxx_timer(struct scsi_qla_host *=
ha)
 		qla4_8xxx_watchdog(ha);
 	}
=20
-	/* Search for relogin's to time-out and port down retry. */
-	list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
-		/* Count down time between sending relogins */
-		if (adapter_up(ha) &&
-		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
-		    atomic_read(&ddb_entry->state) !=3D DDB_STATE_ONLINE) {
-			if (atomic_read(&ddb_entry->retry_relogin_timer) !=3D
-			    INVALID_ENTRY) {
-				if (atomic_read(&ddb_entry->retry_relogin_timer)
-				    		=3D=3D 0) {
-					atomic_set(&ddb_entry->
-						retry_relogin_timer,
-						INVALID_ENTRY);
-					set_bit(DPC_RELOGIN_DEVICE,
-						&ha->dpc_flags);
-					set_bit(DF_RELOGIN, &ddb_entry->flags);
-					DEBUG2(printk("scsi%ld: %s: ddb [%d]"
-						      " login device\n",
-						      ha->host_no, __func__,
-						      ddb_entry->fw_ddb_index));
-				} else
-					atomic_dec(&ddb_entry->
-							retry_relogin_timer);
-			}
-		}
-
-		/* Wait for relogin to timeout */
-		if (atomic_read(&ddb_entry->relogin_timer) &&
-		    (atomic_dec_and_test(&ddb_entry->relogin_timer) !=3D 0)) {
-			/*
-			 * If the relogin times out and the device is
-			 * still NOT ONLINE then try and relogin again.
-			 */
-			if (atomic_read(&ddb_entry->state) !=3D
-			    DDB_STATE_ONLINE &&
-			    ddb_entry->fw_ddb_device_state =3D=3D
-			    DDB_DS_SESSION_FAILED) {
-				/* Reset retry relogin timer */
-				atomic_inc(&ddb_entry->relogin_retry_count);
-				DEBUG2(printk("scsi%ld: ddb [%d] relogin"
-					      " timed out-retrying"
-					      " relogin (%d)\n",
-					      ha->host_no,
-					      ddb_entry->fw_ddb_index,
-					      atomic_read(&ddb_entry->
-							  relogin_retry_count))
-					);
-				start_dpc++;
-				DEBUG(printk("scsi%ld:%d:%d: ddb [%d] "
-					     "initiate relogin after"
-					     " %d seconds\n",
-					     ha->host_no, ddb_entry->bus,
-					     ddb_entry->target,
-					     ddb_entry->fw_ddb_index,
-					     ddb_entry->default_time2wait + 4)
-					);
-
-				atomic_set(&ddb_entry->retry_relogin_timer,
-					   ddb_entry->default_time2wait + 4);
-			}
-		}
-	}
-
 	if (!is_qla8022(ha)) {
 		/* Check for heartbeat interval. */
 		if (ha->firmware_options & FWOPT_HEARTBEAT_ENABLE &&
@@ -1609,6 +2139,17 @@ void qla4xxx_dead_adapter_cleanup(struct scsi_ql=
a_host *ha)
 	clear_bit(AF_INIT_DONE, &ha->flags);
 }
=20
+static void qla4xxx_fail_session(struct iscsi_cls_session *cls_session=
)
+{
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+
+	sess =3D cls_session->dd_data;
+	ddb_entry =3D sess->dd_data;
+	ddb_entry->fw_ddb_device_state =3D DDB_DS_SESSION_FAILED;
+	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
+}
+
 /**
  * qla4xxx_recover_adapter - recovers adapter after a fatal error
  * @ha: Pointer to host adapter structure.
@@ -1621,11 +2162,14 @@ static int qla4xxx_recover_adapter(struct scsi_=
qla_host *ha)
 	/* Stall incoming I/O until we are done */
 	scsi_block_requests(ha->host);
 	clear_bit(AF_ONLINE, &ha->flags);
+	clear_bit(AF_LINK_UP, &ha->flags);
=20
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: adapter OFFLINE\n", __func__));
=20
 	set_bit(DPC_RESET_ACTIVE, &ha->dpc_flags);
=20
+	iscsi_host_for_each_session(ha->host, qla4xxx_fail_session);
+
 	if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
 		reset_chip =3D 1;
=20
@@ -1753,27 +2297,34 @@ recover_ha_init_adapter:
 	return status;
 }
=20
-static void qla4xxx_relogin_all_devices(struct scsi_qla_host *ha)
+static void qla4xxx_relogin_devices(struct iscsi_cls_session *cls_sess=
ion)
 {
-	struct ddb_entry *ddb_entry, *dtemp;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
=20
-	list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
-		if ((atomic_read(&ddb_entry->state) =3D=3D DDB_STATE_MISSING) ||
-		    (atomic_read(&ddb_entry->state) =3D=3D DDB_STATE_DEAD)) {
-			if (ddb_entry->fw_ddb_device_state =3D=3D
-			    DDB_DS_SESSION_ACTIVE) {
-				atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
-				ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
-				    " marked ONLINE\n",	ha->host_no, __func__,
-				    ddb_entry->fw_ddb_index);
-
-				iscsi_unblock_session(ddb_entry->sess);
-			} else
-				qla4xxx_relogin_device(ha, ddb_entry);
+	sess =3D cls_session->dd_data;
+	ddb_entry =3D sess->dd_data;
+	ha =3D ddb_entry->ha;
+	if (!iscsi_is_session_online(cls_session)) {
+		if (ddb_entry->fw_ddb_device_state =3D=3D DDB_DS_SESSION_ACTIVE) {
+			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
+				   " unblock session\n", ha->host_no, __func__,
+				   ddb_entry->fw_ddb_index);
+			iscsi_unblock_session(ddb_entry->sess);
+		} else {
+			/* Trigger relogin */
+			iscsi_session_failure(cls_session->dd_data,
+					      ISCSI_ERR_CONN_FAILED);
 		}
 	}
 }
=20
+static void qla4xxx_relogin_all_devices(struct scsi_qla_host *ha)
+{
+	iscsi_host_for_each_session(ha->host, qla4xxx_relogin_devices);
+}
+
 void qla4xxx_wake_dpc(struct scsi_qla_host *ha)
 {
 	if (ha->dpc_thread)
@@ -1795,7 +2346,6 @@ static void qla4xxx_do_dpc(struct work_struct *wo=
rk)
 {
 	struct scsi_qla_host *ha =3D
 		container_of(work, struct scsi_qla_host, dpc_work);
-	struct ddb_entry *ddb_entry, *dtemp;
 	int status =3D QLA_ERROR;
=20
 	DEBUG2(printk("scsi%ld: %s: DPC handler waking up."
@@ -1891,31 +2441,6 @@ dpc_post_reset_ha:
 			qla4xxx_relogin_all_devices(ha);
 		}
 	}
-
-	/* ---- relogin device? --- */
-	if (adapter_up(ha) &&
-	    test_and_clear_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags)) {
-		list_for_each_entry_safe(ddb_entry, dtemp,
-					 &ha->ddb_list, list) {
-			if (test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags) &&
-			    atomic_read(&ddb_entry->state) !=3D DDB_STATE_ONLINE)
-				qla4xxx_relogin_device(ha, ddb_entry);
-
-			/*
-			 * If mbx cmd times out there is no point
-			 * in continuing further.
-			 * With large no of targets this can hang
-			 * the system.
-			 */
-			if (test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
-				printk(KERN_WARNING "scsi%ld: %s: "
-				       "need to reset hba\n",
-				       ha->host_no, __func__);
-				break;
-			}
-		}
-	}
-
 }
=20
 /**
@@ -1938,6 +2463,10 @@ static void qla4xxx_free_adapter(struct scsi_qla=
_host *ha)
 	if (ha->dpc_thread)
 		destroy_workqueue(ha->dpc_thread);
=20
+	/* Kill the kernel thread for this host */
+	if (ha->task_wq)
+		destroy_workqueue(ha->task_wq);
+
 	/* Put firmware in known state */
 	ha->isp_ops->reset_firmware(ha);
=20
@@ -2152,7 +2681,7 @@ static int __devinit qla4xxx_probe_adapter(struct=
 pci_dev *pdev,
 	if (pci_enable_device(pdev))
 		return -1;
=20
-	host =3D scsi_host_alloc(&qla4xxx_driver_template, sizeof(*ha));
+	host =3D iscsi_host_alloc(&qla4xxx_driver_template, sizeof(*ha), 0);
 	if (host =3D=3D NULL) {
 		printk(KERN_WARNING
 		       "qla4xxx: Couldn't allocate host from scsi layer!\n");
@@ -2160,7 +2689,7 @@ static int __devinit qla4xxx_probe_adapter(struct=
 pci_dev *pdev,
 	}
=20
 	/* Clear our data area */
-	ha =3D (struct scsi_qla_host *) host->hostdata;
+	ha =3D to_qla_host(host);
 	memset(ha, 0, sizeof(*ha));
=20
 	/* Save the information from PCI BIOS.	*/
@@ -2220,6 +2749,27 @@ static int __devinit qla4xxx_probe_adapter(struc=
t pci_dev *pdev,
 		goto probe_failed;
 	}
=20
+	host->cmd_per_lun =3D 3;
+	host->max_channel =3D 0;
+	host->max_lun =3D MAX_LUNS - 1;
+	host->max_id =3D MAX_TARGETS;
+	host->max_cmd_len =3D IOCB_MAX_CDB_LEN;
+	host->can_queue =3D MAX_SRBS ;
+	host->transportt =3D qla4xxx_scsi_transport;
+
+	ret =3D scsi_init_shared_tag_map(host, MAX_SRBS);
+	if (ret) {
+		ql4_printk(KERN_WARNING, ha,
+			   "%s: scsi_init_shared_tag_map failed\n", __func__);
+		goto probe_failed;
+	}
+
+	pci_set_drvdata(pdev, ha);
+
+	ret =3D scsi_add_host(host, &pdev->dev);
+	if (ret)
+		goto probe_failed;
+
 	if (is_qla8022(ha))
 		(void) qla4_8xxx_get_flash_info(ha);
=20
@@ -2264,24 +2814,9 @@ static int __devinit qla4xxx_probe_adapter(struc=
t pci_dev *pdev,
 			qla4_8xxx_idc_unlock(ha);
 		}
 		ret =3D -ENODEV;
-		goto probe_failed;
+		goto remove_host;
 	}
=20
-	host->cmd_per_lun =3D 3;
-	host->max_channel =3D 0;
-	host->max_lun =3D MAX_LUNS - 1;
-	host->max_id =3D MAX_TARGETS;
-	host->max_cmd_len =3D IOCB_MAX_CDB_LEN;
-	host->can_queue =3D MAX_SRBS ;
-	host->transportt =3D qla4xxx_scsi_transport;
-
-        ret =3D scsi_init_shared_tag_map(host, MAX_SRBS);
-        if (ret) {
-		ql4_printk(KERN_WARNING, ha,
-		    "scsi_init_shared_tag_map failed\n");
-		goto probe_failed;
-        }
-
 	/* Startup the kernel thread for this host adapter. */
 	DEBUG2(printk("scsi: %s: Starting kernel thread for "
 		      "qla4xxx_dpc\n", __func__));
@@ -2290,10 +2825,18 @@ static int __devinit qla4xxx_probe_adapter(stru=
ct pci_dev *pdev,
 	if (!ha->dpc_thread) {
 		ql4_printk(KERN_WARNING, ha, "Unable to start DPC thread!\n");
 		ret =3D -ENODEV;
-		goto probe_failed;
+		goto remove_host;
 	}
 	INIT_WORK(&ha->dpc_work, qla4xxx_do_dpc);
=20
+	sprintf(buf, "qla4xxx_%lu_task", ha->host_no);
+	ha->task_wq =3D alloc_workqueue(buf, WQ_MEM_RECLAIM, 1);
+	if (!ha->task_wq) {
+		ql4_printk(KERN_WARNING, ha, "Unable to start task thread!\n");
+		ret =3D -ENODEV;
+		goto remove_host;
+	}
+
 	/* For ISP-82XX, request_irqs is called in qla4_8xxx_load_risc
 	 * (which is called indirectly by qla4xxx_initialize_adapter),
 	 * so that irqs will be registered after crbinit but before
@@ -2304,7 +2847,7 @@ static int __devinit qla4xxx_probe_adapter(struct=
 pci_dev *pdev,
 		if (ret) {
 			ql4_printk(KERN_WARNING, ha, "Failed to reserve "
 			    "interrupt %d already in use.\n", pdev->irq);
-			goto probe_failed;
+			goto remove_host;
 		}
 	}
=20
@@ -2316,23 +2859,19 @@ static int __devinit qla4xxx_probe_adapter(stru=
ct pci_dev *pdev,
=20
 	set_bit(AF_INIT_DONE, &ha->flags);
=20
-	pci_set_drvdata(pdev, ha);
-
-	ret =3D scsi_add_host(host, &pdev->dev);
-	if (ret)
-		goto probe_failed;
-
 	printk(KERN_INFO
 	       " QLogic iSCSI HBA Driver version: %s\n"
 	       "  QLogic ISP%04x @ %s, host#=3D%ld, fw=3D%02d.%02d.%02d.%02d\=
n",
 	       qla4xxx_version_str, ha->pdev->device, pci_name(ha->pdev),
 	       ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
 	       ha->patch_number, ha->build_number);
-	scsi_scan_host(host);
=20
 	qla4xxx_create_ifaces(ha);
 	return 0;
=20
+remove_host:
+	scsi_remove_host(ha->host);
+
 probe_failed:
 	qla4xxx_free_adapter(ha);
=20
@@ -2440,10 +2979,15 @@ static void qla4xxx_config_dma_addressing(struc=
t scsi_qla_host *ha)
=20
 static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 {
-	struct iscsi_cls_session *sess =3D starget_to_session(sdev->sdev_targ=
et);
-	struct ddb_entry *ddb =3D sess->dd_data;
+	struct iscsi_cls_session *cls_sess;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb;
 	int queue_depth =3D QL4_DEF_QDEPTH;
=20
+	cls_sess =3D starget_to_session(sdev->sdev_target);
+	sess =3D cls_sess->dd_data;
+	ddb =3D sess->dd_data;
+
 	sdev->hostdata =3D ddb;
 	sdev->tagged_supported =3D 1;
=20
@@ -2781,7 +3325,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd=
 *cmd)
 	int return_status =3D FAILED;
 	struct scsi_qla_host *ha;
=20
-	ha =3D (struct scsi_qla_host *) cmd->device->host->hostdata;
+	ha =3D to_qla_host(cmd->device->host);
=20
 	if (ql4xdontresethba) {
 		DEBUG2(printk("scsi%ld: %s: Don't Reset HBA\n",
@@ -2893,7 +3437,8 @@ static uint32_t qla4_8xxx_error_recovery(struct s=
csi_qla_host *ha)
=20
 	if (test_bit(AF_ONLINE, &ha->flags)) {
 		clear_bit(AF_ONLINE, &ha->flags);
-		qla4xxx_mark_all_devices_missing(ha);
+		clear_bit(AF_LINK_UP, &ha->flags);
+		iscsi_host_for_each_session(ha->host, qla4xxx_fail_session);
 		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
 	}
=20
--=20
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
