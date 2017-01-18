From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 08/12] qla2xxx: Add framework for Async fabric discovery.
Date: Wed, 18 Jan 2017 15:19:41 -0800
Message-ID: <1484781585-27252-9-git-send-email-himanshu.madhani@cavium.com>
References: <1484781585-27252-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0088.outbound.protection.outlook.com ([104.47.38.88]:3264
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751474AbdARXUs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 18:20:48 -0500
In-Reply-To: <1484781585-27252-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Currently code performs a full scan of the fabric for
every RSCN. Its an expensive process in a noisy large SAN.

This patch optimizes exepsive fabric discovery process by
scanning switch for the affected port when RSCN is received.

Currently Initiator Mode code makes login/logout decision without
knowlege of target mode. This causes driver and firmware to go
out-of-sync. This framework synchronizes both Initiator mode
personality and Target mode personality in making login/logout
decision.

This patch adds following capabilities in the driver

- Send Notification Acknowledgement asynchronously.
- Update session/fcport state asynchronously.
- Create a session or fcport struct asynchronously.
- Send GNL asynchronously. The command will ask FW to
  provide a list of FC Port entries FW knows about.
- Send GPDB asynchronously. The command will ask FW to
  provide detail data of an FC Port FW knows about or
  perform ADISC to verify the state of the session.
- Send GPNID asynchronously. The command will ask switch
  to provide WWPN for provided NPort ID.
- Send GPSC asynchronously. The command will ask switch
  to provide registered port speed for provided WWPN.
- Send GIDPN asynchronously. The command will ask the
  switch to provide Nport ID for provided WWPN.
- In driver unload path, schedule all session for deletion
  and wait for deletion to complete before allowing driver
  unload to proceed.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |    3 +
 drivers/scsi/qla2xxx/qla_def.h    |  175 ++++-
 drivers/scsi/qla2xxx/qla_fw.h     |   31 +
 drivers/scsi/qla2xxx/qla_gbl.h    |   56 +-
 drivers/scsi/qla2xxx/qla_gs.c     |  724 +++++++++++++++++--
 drivers/scsi/qla2xxx/qla_init.c   | 1396 ++++++++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_inline.h |    7 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |   71 +-
 drivers/scsi/qla2xxx/qla_isr.c    |  261 +++++--
 drivers/scsi/qla2xxx/qla_mbx.c    |   88 ---
 drivers/scsi/qla2xxx/qla_os.c     |  271 ++++---
 drivers/scsi/qla2xxx/qla_target.c | 1002 ++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_target.h |   17 +-
 13 files changed, 3115 insertions(+), 987 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 47eb4d5..5d450c0 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2156,6 +2156,9 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	clear_bit(vha->vp_idx, ha->vp_idx_map);
 	mutex_unlock(&ha->vport_lock);
 
+	dma_free_coherent(&ha->pdev->dev, vha->gnl.size, vha->gnl.l,
+	    vha->gnl.ldma);
+
 	if (vha->qpair->vp_idx == vha->vp_idx) {
 		if (qla2xxx_delete_qpair(vha, vha->qpair) != QLA_SUCCESS)
 			ql_log(ql_log_warn, vha, 0x7087,
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 11d5288..253f991 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -55,6 +55,8 @@
 
 #include "qla_settings.h"
 
+#define MODE_DUAL (MODE_TARGET | MODE_INITIATOR)
+
 /*
  * Data bit definitions
  */
@@ -251,6 +253,14 @@
 
 #define MAX_CMDSZ	16		/* SCSI maximum CDB size. */
 #include "qla_fw.h"
+
+struct name_list_extended {
+	struct get_name_list_extended *l;
+	dma_addr_t		ldma;
+	struct list_head 	fcports;	/* protect by sess_list */
+	u32			size;
+	u8			sent;
+};
 /*
  * Timeout timer counts in seconds
  */
@@ -309,6 +319,17 @@ struct els_logo_payload {
 	uint8_t wwpn[WWN_SIZE];
 };
 
+struct ct_arg {
+	void		*iocb;
+	u16		nport_handle;
+	dma_addr_t	req_dma;
+	dma_addr_t	rsp_dma;
+	u32		req_size;
+	u32		rsp_size;
+	void		*req;
+	void		*rsp;
+};
+
 /*
  * SRB extensions.
  */
@@ -320,6 +341,7 @@ struct srb_iocb {
 #define SRB_LOGIN_COND_PLOGI	BIT_1
 #define SRB_LOGIN_SKIP_PRLI	BIT_2
 			uint16_t data[2];
+			u32 iop[2];
 		} logio;
 		struct {
 #define ELS_DCMD_TIMEOUT 20
@@ -372,6 +394,16 @@ struct srb_iocb {
 			__le16 comp_status;
 			struct completion comp;
 		} abt;
+		struct ct_arg ctarg;
+		struct {
+			__le16 in_mb[28]; 	/* fr fw */
+			__le16 out_mb[28];	/* to fw */
+			void *out, *in;
+			dma_addr_t out_dma, in_dma;
+		} mbx;
+		struct {
+			struct imm_ntfy_from_isp *ntfy;
+		} nack;
 	} u;
 
 	struct timer_list timer;
@@ -392,16 +424,24 @@ struct srb_iocb {
 #define SRB_FXIOCB_BCMD	11
 #define SRB_ABT_CMD	12
 #define SRB_ELS_DCMD	13
+#define SRB_MB_IOCB	14
+#define SRB_CT_PTHRU_CMD 15
+#define SRB_NACK_PLOGI	16
+#define SRB_NACK_PRLI	17
+#define SRB_NACK_LOGO	18
 
 typedef struct srb {
 	atomic_t ref_count;
 	struct fc_port *fcport;
+	void *vha;
 	uint32_t handle;
 	uint16_t flags;
 	uint16_t type;
 	char *name;
 	int iocbs;
 	struct qla_qpair *qpair;
+	u32 gen1;	/* scratch */
+	u32 gen2;	/* scratch */
 	union {
 		struct srb_iocb iocb_cmd;
 		struct bsg_job *bsg_job;
@@ -2101,6 +2141,18 @@ struct imm_ntfy_from_isp {
 #define FC4_TYPE_OTHER		0x0
 #define FC4_TYPE_UNKNOWN	0xff
 
+/* mailbox command 4G & above */
+struct mbx_24xx_entry {
+	uint8_t		entry_type;
+	uint8_t		entry_count;
+	uint8_t		sys_define1;
+	uint8_t		entry_status;
+	uint32_t	handle;
+	uint16_t	mb[28];
+};
+
+#define IOCB_SIZE 64
+
 /*
  * Fibre channel port type.
  */
@@ -2113,6 +2165,12 @@ struct imm_ntfy_from_isp {
 	FCT_TARGET
 } fc_port_type_t;
 
+enum qla_sess_deletion {
+	QLA_SESS_DELETION_NONE		= 0,
+	QLA_SESS_DELETION_IN_PROGRESS,
+	QLA_SESS_DELETED,
+};
+
 enum qlt_plogi_link_t {
 	QLT_PLOGI_LINK_SAME_WWN,
 	QLT_PLOGI_LINK_CONFLICT,
@@ -2124,6 +2182,48 @@ struct qlt_plogi_ack_t {
 	struct imm_ntfy_from_isp iocb;
 	port_id_t	id;
 	int		ref_count;
+	void		*fcport;
+};
+
+struct ct_sns_desc {
+	struct ct_sns_pkt	*ct_sns;
+	dma_addr_t		ct_sns_dma;
+};
+
+enum discovery_state {
+	DSC_DELETED,
+	DSC_GID_PN,
+	DSC_GNL,
+	DSC_LOGIN_PEND,
+	DSC_LOGIN_FAILED,
+	DSC_GPDB,
+	DSC_GPSC,
+	DSC_UPD_FCPORT,
+	DSC_LOGIN_COMPLETE,
+	DSC_DELETE_PEND,
+};
+
+enum login_state {	/* FW control Target side */
+	DSC_LS_LLIOCB_SENT = 2,
+	DSC_LS_PLOGI_PEND,
+	DSC_LS_PLOGI_COMP,
+	DSC_LS_PRLI_PEND,
+	DSC_LS_PRLI_COMP,
+	DSC_LS_PORT_UNAVAIL,
+	DSC_LS_PRLO_PEND = 9,
+	DSC_LS_LOGO_PEND,
+};
+
+enum fcport_mgt_event {
+	FCME_RELOGIN = 1,
+	FCME_RSCN,
+	FCME_GIDPN_DONE,
+	FCME_PLOGI_DONE,	/* Initiator side sent LLIOCB */
+	FCME_GNL_DONE,
+	FCME_GPSC_DONE,
+	FCME_GPDB_DONE,
+	FCME_GPNID_DONE,
+	FCME_DELETE_DONE,
 };
 
 /*
@@ -2143,9 +2243,13 @@ struct qlt_plogi_ack_t {
 	unsigned int deleted:2;
 	unsigned int local:1;
 	unsigned int logout_on_delete:1;
+	unsigned int logo_ack_needed:1;
 	unsigned int keep_nport_handle:1;
 	unsigned int send_els_logo:1;
+	unsigned int login_pause:1;
+	unsigned int login_succ:1;
 
+	struct fc_port *conflict;
 	unsigned char logout_completed;
 	int generation;
 
@@ -2186,8 +2290,30 @@ struct qlt_plogi_ack_t {
 
 	unsigned long retry_delay_timestamp;
 	struct qla_tgt_sess *tgt_session;
+	struct ct_sns_desc ct_desc;
+	enum discovery_state disc_state;
+	enum login_state fw_login_state;
+	u32 login_gen, last_login_gen;
+	u32 rscn_gen, last_rscn_gen;
+	u32 chip_reset;
+	struct list_head gnl_entry;
+	struct work_struct del_work;
+	u8 iocb[IOCB_SIZE];
 } fc_port_t;
 
+#define QLA_FCPORT_SCAN		1
+#define QLA_FCPORT_FOUND	2
+
+struct event_arg {
+	enum fcport_mgt_event	event;
+	fc_port_t		*fcport;
+	srb_t			*sp;
+	port_id_t		id;
+	u16			data[2], rc;
+	u8			port_name[WWN_SIZE];
+	u32			iop[2];
+};
+
 #include "qla_mr.h"
 
 /*
@@ -2265,6 +2391,10 @@ struct qlt_plogi_ack_t {
 #define	GFT_ID_REQ_SIZE	(16 + 4)
 #define	GFT_ID_RSP_SIZE	(16 + 32)
 
+#define GID_PN_CMD 0x121
+#define GID_PN_REQ_SIZE (16 + 8)
+#define GID_PN_RSP_SIZE (16 + 4)
+
 #define	RFT_ID_CMD	0x217
 #define	RFT_ID_REQ_SIZE	(16 + 4 + 32)
 #define	RFT_ID_RSP_SIZE	16
@@ -2590,6 +2720,10 @@ struct ct_sns_req {
 			uint8_t reserved;
 			uint8_t port_name[3];
 		} gff_id;
+
+		struct {
+			uint8_t port_name[8];
+		} gid_pn;
 	} req;
 };
 
@@ -2669,6 +2803,10 @@ struct ct_sns_rsp {
 		struct {
 			uint8_t fc4_features[128];
 		} gff_id;
+		struct {
+			uint8_t reserved;
+			uint8_t port_id[3];
+		} gid_pn;
 	} rsp;
 };
 
@@ -2810,11 +2948,11 @@ struct isp_operations {
 
 	uint16_t (*calc_req_entries) (uint16_t);
 	void (*build_iocbs) (srb_t *, cmd_entry_t *, uint16_t);
-	void * (*prep_ms_iocb) (struct scsi_qla_host *, uint32_t, uint32_t);
-	void * (*prep_ms_fdmi_iocb) (struct scsi_qla_host *, uint32_t,
+	void *(*prep_ms_iocb) (struct scsi_qla_host *, struct ct_arg *);
+	void *(*prep_ms_fdmi_iocb) (struct scsi_qla_host *, uint32_t,
 	    uint32_t);
 
-	uint8_t * (*read_nvram) (struct scsi_qla_host *, uint8_t *,
+	uint8_t *(*read_nvram) (struct scsi_qla_host *, uint8_t *,
 		uint32_t, uint32_t);
 	int (*write_nvram) (struct scsi_qla_host *, uint8_t *, uint32_t,
 		uint32_t);
@@ -2877,13 +3015,21 @@ enum qla_work_type {
 	QLA_EVT_AEN,
 	QLA_EVT_IDC_ACK,
 	QLA_EVT_ASYNC_LOGIN,
-	QLA_EVT_ASYNC_LOGIN_DONE,
 	QLA_EVT_ASYNC_LOGOUT,
 	QLA_EVT_ASYNC_LOGOUT_DONE,
 	QLA_EVT_ASYNC_ADISC,
 	QLA_EVT_ASYNC_ADISC_DONE,
 	QLA_EVT_UEVENT,
 	QLA_EVT_AENFX,
+	QLA_EVT_GIDPN,
+	QLA_EVT_GPNID,
+	QLA_EVT_GPNID_DONE,
+	QLA_EVT_NEW_SESS,
+	QLA_EVT_GPDB,
+	QLA_EVT_GPSC,
+	QLA_EVT_UPD_FCPORT,
+	QLA_EVT_GNL,
+	QLA_EVT_NACK,
 };
 
 
@@ -2919,6 +3065,23 @@ struct qla_work_evt {
 		struct {
 			srb_t *sp;
 		} iosb;
+		struct {
+			port_id_t id;
+		} gpnid;
+		struct {
+			port_id_t id;
+			u8 port_name[8];
+			void *pla;
+		} new_sess;
+		struct { /*Get PDB, Get Speed, update fcport, gnl, gidpn */
+			fc_port_t *fcport;
+			u8 opt;
+		} fcport;
+		struct {
+			fc_port_t *fcport;
+			u8 iocb[IOCB_SIZE];
+			int type;
+		} nack;
 	 } u;
 };
 
@@ -3900,6 +4063,10 @@ struct qla_tgt_counters {
 	struct qla8044_reset_template reset_tmplt;
 	struct qla_tgt_counters tgt_counters;
 	uint16_t	bbcr;
+	struct name_list_extended gnl;
+	/* Count of active session/fcport */
+	int fcport_count;
+	wait_queue_head_t fcport_waitQ;
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 8a2368b..ee135cf 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -72,6 +72,37 @@ struct port_database_24xx {
 	uint8_t reserved_3[24];
 };
 
+/*
+ * MB 75h returns a list of DB entries similar to port_database_24xx(64B).
+ * However, in this case it returns 1st 40 bytes.
+ */
+struct get_name_list_extended {
+	__le16 flags;
+	u8 current_login_state;
+	u8 last_login_state;
+	u8 hard_address[3];
+	u8 reserved_1;
+	u8 port_id[3];
+	u8 sequence_id;
+	__le16 port_timer;
+	__le16 nport_handle;			/* N_PORT handle. */
+	__le16 receive_data_size;
+	__le16 reserved_2;
+
+	/* PRLI SVC Param are Big endian */
+	u8 prli_svc_param_word_0[2]; /* Bits 15-0 of word 0 */
+	u8 prli_svc_param_word_3[2]; /* Bits 15-0 of word 3 */
+	u8 port_name[WWN_SIZE];
+	u8 node_name[WWN_SIZE];
+};
+
+/* MB 75h: This is the short version of the database */
+struct get_name_list {
+	u8 port_node_name[WWN_SIZE]; /* B7 most sig, B0 least sig */
+	__le16 nport_handle;
+	u8 reserved;
+};
+
 struct vp_database_24xx {
 	uint16_t vp_status;
 	uint8_t  options;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index afa0116..dd95ff6 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -73,6 +73,10 @@ extern void qla2x00_async_logout_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern void qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
+struct qla_work_evt *qla2x00_alloc_work(struct scsi_qla_host *,
+    enum qla_work_type);
+extern int qla24xx_async_gnl(struct scsi_qla_host *, fc_port_t *);
+int qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e);
 extern void *qla2x00_alloc_iocbs(struct scsi_qla_host *, srb_t *);
 extern void *qla2x00_alloc_iocbs_ready(struct scsi_qla_host *, srb_t *);
 extern int qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *, fc_port_t *);
@@ -94,6 +98,13 @@ extern void qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
 extern struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *,
 	int, int);
 extern int qla2xxx_delete_qpair(struct scsi_qla_host *, struct qla_qpair *);
+void qla2x00_fcport_event_handler(scsi_qla_host_t *, struct event_arg *);
+int qla24xx_async_gpdb(struct scsi_qla_host *, fc_port_t *, u8);
+int qla24xx_async_notify_ack(scsi_qla_host_t *, fc_port_t *,
+	struct imm_ntfy_from_isp *, int);
+int qla24xx_post_newsess_work(struct scsi_qla_host *, port_id_t *, u8 *,
+    void *);
+int qla24xx_fcport_handle_login(struct scsi_qla_host *, fc_port_t *);
 
 /*
  * Global Data in qla_os.c source file.
@@ -135,8 +146,6 @@ extern int qla2x00_post_aen_work(struct scsi_qla_host *, enum
 extern int qla2x00_post_idc_ack_work(struct scsi_qla_host *, uint16_t *);
 extern int qla2x00_post_async_login_work(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
-extern int qla2x00_post_async_login_done_work(struct scsi_qla_host *,
-    fc_port_t *, uint16_t *);
 extern int qla2x00_post_async_logout_work(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_post_async_logout_done_work(struct scsi_qla_host *,
@@ -179,6 +188,10 @@ extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
 extern void qla2x00_sp_compl(void *, void *, int);
 extern void qla2xxx_qpair_sp_free_dma(void *, void *);
 extern void qla2xxx_qpair_sp_compl(void *, void *, int);
+extern int qla24xx_post_upd_fcport_work(struct scsi_qla_host *, fc_port_t *);
+void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
+	uint16_t *);
+int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
 
 /*
  * Global Functions in qla_mid.c source file.
@@ -302,9 +315,6 @@ extern int qla24xx_build_scsi_crc_2_iocbs(srb_t *,
 qla2x00_init_firmware(scsi_qla_host_t *, uint16_t);
 
 extern int
-qla2x00_get_node_name_list(scsi_qla_host_t *, void **, int *);
-
-extern int
 qla2x00_get_port_database(scsi_qla_host_t *, fc_port_t *, uint8_t);
 
 extern int
@@ -483,6 +493,9 @@ extern int qla24xx_set_fcp_prio(scsi_qla_host_t *, uint16_t, uint16_t,
 	uint32_t);
 extern irqreturn_t
 qla2xxx_msix_rsp_q(int irq, void *dev_id);
+fc_port_t *qla2x00_find_fcport_by_loopid(scsi_qla_host_t *, uint16_t);
+fc_port_t *qla2x00_find_fcport_by_wwpn(scsi_qla_host_t *, u8 *, u8);
+fc_port_t *qla2x00_find_fcport_by_nportid(scsi_qla_host_t *, port_id_t *, u8);
 
 /*
  * Global Function Prototypes in qla_sup.c source file.
@@ -574,8 +587,8 @@ extern void ql_dump_buffer(uint32_t, scsi_qla_host_t *, int32_t,
 /*
  * Global Function Prototypes in qla_gs.c source file.
  */
-extern void *qla2x00_prep_ms_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
-extern void *qla24xx_prep_ms_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
+extern void *qla2x00_prep_ms_iocb(scsi_qla_host_t *, struct ct_arg *);
+extern void *qla24xx_prep_ms_iocb(scsi_qla_host_t *, struct ct_arg *);
 extern int qla2x00_ga_nxt(scsi_qla_host_t *, fc_port_t *);
 extern int qla2x00_gid_pt(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_gpn_id(scsi_qla_host_t *, sw_info_t *);
@@ -591,6 +604,23 @@ extern void ql_dump_buffer(uint32_t, scsi_qla_host_t *, int32_t,
 extern int qla2x00_gfpn_id(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_gpsc(scsi_qla_host_t *, sw_info_t *);
 extern void qla2x00_get_sym_node_name(scsi_qla_host_t *, uint8_t *, size_t);
+extern int qla2x00_chk_ms_status(scsi_qla_host_t *, ms_iocb_entry_t *,
+	struct ct_sns_rsp *, const char *);
+extern void qla2x00_async_iocb_timeout(void *data);
+extern int qla24xx_async_gidpn(scsi_qla_host_t *, fc_port_t *);
+int qla24xx_post_gidpn_work(struct scsi_qla_host *, fc_port_t *);
+void qla24xx_handle_gidpn_event(scsi_qla_host_t *, struct event_arg *);
+
+extern void qla2x00_free_fcport(fc_port_t *);
+
+extern int qla24xx_post_gpnid_work(struct scsi_qla_host *, port_id_t *);
+extern int qla24xx_async_gpnid(scsi_qla_host_t *, port_id_t *);
+void qla24xx_async_gpnid_done(scsi_qla_host_t *, srb_t*);
+void qla24xx_handle_gpnid_event(scsi_qla_host_t *, struct event_arg *);
+
+int qla24xx_post_gpsc_work(struct scsi_qla_host *, fc_port_t *);
+int qla24xx_async_gpsc(scsi_qla_host_t *, fc_port_t *);
+int qla2x00_mgmt_svr_login(scsi_qla_host_t *);
 
 /*
  * Global Function Prototypes in qla_attr.c source file.
@@ -803,4 +833,16 @@ extern int qla_get_exlogin_status(scsi_qla_host_t *, uint16_t *,
 extern int qla_set_exchoffld_mem_cfg(scsi_qla_host_t *, dma_addr_t);
 extern void qlt_handle_abts_recv(struct scsi_qla_host *, response_t *);
 
+int qla24xx_async_notify_ack(scsi_qla_host_t *, fc_port_t *,
+	struct imm_ntfy_from_isp *, int);
+void qla24xx_do_nack_work(struct scsi_qla_host *, struct qla_work_evt *);
+void qlt_plogi_ack_link(struct scsi_qla_host *, struct qlt_plogi_ack_t *,
+	struct fc_port *, enum qlt_plogi_link_t);
+void qlt_plogi_ack_unref(struct scsi_qla_host *, struct qlt_plogi_ack_t *);
+extern void qlt_schedule_sess_for_deletion(struct fc_port *, bool);
+extern void qlt_schedule_sess_for_deletion_lock(struct fc_port *);
+extern struct fc_port *qlt_find_sess_invalidate_other(scsi_qla_host_t *,
+	uint64_t wwn, port_id_t port_id, uint16_t loop_id, struct fc_port **);
+void qla24xx_delete_sess_fn(struct work_struct *);
+
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 94e8a85..8f7054d 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -24,12 +24,12 @@
  * Returns a pointer to the @ha's ms_iocb.
  */
 void *
-qla2x00_prep_ms_iocb(scsi_qla_host_t *vha, uint32_t req_size, uint32_t rsp_size)
+qla2x00_prep_ms_iocb(scsi_qla_host_t *vha, struct ct_arg *arg)
 {
 	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t *ms_pkt;
 
-	ms_pkt = ha->ms_iocb;
+	ms_pkt = (ms_iocb_entry_t *)arg->iocb;
 	memset(ms_pkt, 0, sizeof(ms_iocb_entry_t));
 
 	ms_pkt->entry_type = MS_IOCB_TYPE;
@@ -39,15 +39,15 @@
 	ms_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	ms_pkt->cmd_dsd_count = cpu_to_le16(1);
 	ms_pkt->total_dsd_count = cpu_to_le16(2);
-	ms_pkt->rsp_bytecount = cpu_to_le32(rsp_size);
-	ms_pkt->req_bytecount = cpu_to_le32(req_size);
+	ms_pkt->rsp_bytecount = cpu_to_le32(arg->rsp_size);
+	ms_pkt->req_bytecount = cpu_to_le32(arg->req_size);
 
-	ms_pkt->dseg_req_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
-	ms_pkt->dseg_req_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
+	ms_pkt->dseg_req_address[0] = cpu_to_le32(LSD(arg->req_dma));
+	ms_pkt->dseg_req_address[1] = cpu_to_le32(MSD(arg->req_dma));
 	ms_pkt->dseg_req_length = ms_pkt->req_bytecount;
 
-	ms_pkt->dseg_rsp_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
-	ms_pkt->dseg_rsp_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
+	ms_pkt->dseg_rsp_address[0] = cpu_to_le32(LSD(arg->rsp_dma));
+	ms_pkt->dseg_rsp_address[1] = cpu_to_le32(MSD(arg->rsp_dma));
 	ms_pkt->dseg_rsp_length = ms_pkt->rsp_bytecount;
 
 	vha->qla_stats.control_requests++;
@@ -64,29 +64,29 @@
  * Returns a pointer to the @ha's ms_iocb.
  */
 void *
-qla24xx_prep_ms_iocb(scsi_qla_host_t *vha, uint32_t req_size, uint32_t rsp_size)
+qla24xx_prep_ms_iocb(scsi_qla_host_t *vha, struct ct_arg *arg)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct ct_entry_24xx *ct_pkt;
 
-	ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
+	ct_pkt = (struct ct_entry_24xx *)arg->iocb;
 	memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
 
 	ct_pkt->entry_type = CT_IOCB_TYPE;
 	ct_pkt->entry_count = 1;
-	ct_pkt->nport_handle = cpu_to_le16(NPH_SNS);
+	ct_pkt->nport_handle = cpu_to_le16(arg->nport_handle);
 	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	ct_pkt->cmd_dsd_count = cpu_to_le16(1);
 	ct_pkt->rsp_dsd_count = cpu_to_le16(1);
-	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
-	ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
+	ct_pkt->rsp_byte_count = cpu_to_le32(arg->rsp_size);
+	ct_pkt->cmd_byte_count = cpu_to_le32(arg->req_size);
 
-	ct_pkt->dseg_0_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
-	ct_pkt->dseg_0_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
+	ct_pkt->dseg_0_address[0] = cpu_to_le32(LSD(arg->req_dma));
+	ct_pkt->dseg_0_address[1] = cpu_to_le32(MSD(arg->req_dma));
 	ct_pkt->dseg_0_len = ct_pkt->cmd_byte_count;
 
-	ct_pkt->dseg_1_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
-	ct_pkt->dseg_1_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
+	ct_pkt->dseg_1_address[0] = cpu_to_le32(LSD(arg->rsp_dma));
+	ct_pkt->dseg_1_address[1] = cpu_to_le32(MSD(arg->rsp_dma));
 	ct_pkt->dseg_1_len = ct_pkt->rsp_byte_count;
 	ct_pkt->vp_index = vha->vp_idx;
 
@@ -117,7 +117,7 @@
 	return &p->p.req;
 }
 
-static int
+int
 qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
     struct ct_sns_rsp *ct_rsp, const char *routine)
 {
@@ -183,14 +183,21 @@
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 	struct qla_hw_data *ha = vha->hw;
+	struct ct_arg arg;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return qla2x00_sns_ga_nxt(vha, fcport);
 
+	arg.iocb = ha->ms_iocb;
+	arg.req_dma = ha->ct_sns_dma;
+	arg.rsp_dma = ha->ct_sns_dma;
+	arg.req_size = GA_NXT_REQ_SIZE;
+	arg.rsp_size = GA_NXT_RSP_SIZE;
+	arg.nport_handle = NPH_SNS;
+
 	/* Issue GA_NXT */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GA_NXT_REQ_SIZE,
-	    GA_NXT_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, &arg);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(ha->ct_sns, GA_NXT_CMD,
@@ -269,16 +276,24 @@
 	struct ct_sns_gid_pt_data *gid_data;
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t gid_pt_rsp_size;
+	struct ct_arg arg;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return qla2x00_sns_gid_pt(vha, list);
 
 	gid_data = NULL;
 	gid_pt_rsp_size = qla2x00_gid_pt_rsp_size(vha);
+
+	arg.iocb = ha->ms_iocb;
+	arg.req_dma = ha->ct_sns_dma;
+	arg.rsp_dma = ha->ct_sns_dma;
+	arg.req_size = GID_PT_REQ_SIZE;
+	arg.rsp_size = gid_pt_rsp_size;
+	arg.nport_handle = NPH_SNS;
+
 	/* Issue GID_PT */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GID_PT_REQ_SIZE,
-	    gid_pt_rsp_size);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, &arg);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(ha->ct_sns, GID_PT_CMD, gid_pt_rsp_size);
@@ -344,15 +359,22 @@
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 	struct qla_hw_data *ha = vha->hw;
+	struct ct_arg arg;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return qla2x00_sns_gpn_id(vha, list);
 
+	arg.iocb = ha->ms_iocb;
+	arg.req_dma = ha->ct_sns_dma;
+	arg.rsp_dma = ha->ct_sns_dma;
+	arg.req_size = GPN_ID_REQ_SIZE;
+	arg.rsp_size = GPN_ID_RSP_SIZE;
+	arg.nport_handle = NPH_SNS;
+
 	for (i = 0; i < ha->max_fibre_devices; i++) {
 		/* Issue GPN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GPN_ID_REQ_SIZE,
-		    GPN_ID_RSP_SIZE);
+		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, &arg);
 
 		/* Prepare CT request */
 		ct_req = qla2x00_prep_ct_req(ha->ct_sns, GPN_ID_CMD,
@@ -406,15 +428,22 @@
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
+	struct ct_arg arg;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return qla2x00_sns_gnn_id(vha, list);
 
+	arg.iocb = ha->ms_iocb;
+	arg.req_dma = ha->ct_sns_dma;
+	arg.rsp_dma = ha->ct_sns_dma;
+	arg.req_size = GNN_ID_REQ_SIZE;
+	arg.rsp_size = GNN_ID_RSP_SIZE;
+	arg.nport_handle = NPH_SNS;
+
 	for (i = 0; i < ha->max_fibre_devices; i++) {
 		/* Issue GNN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GNN_ID_REQ_SIZE,
-		    GNN_ID_RSP_SIZE);
+		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, &arg);
 
 		/* Prepare CT request */
 		ct_req = qla2x00_prep_ct_req(ha->ct_sns, GNN_ID_CMD,
@@ -473,14 +502,21 @@
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
+	struct ct_arg arg;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return qla2x00_sns_rft_id(vha);
 
+	arg.iocb = ha->ms_iocb;
+	arg.req_dma = ha->ct_sns_dma;
+	arg.rsp_dma = ha->ct_sns_dma;
+	arg.req_size = RFT_ID_REQ_SIZE;
+	arg.rsp_size = RFT_ID_RSP_SIZE;
+	arg.nport_handle = NPH_SNS;
+
 	/* Issue RFT_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, RFT_ID_REQ_SIZE,
-	    RFT_ID_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, &arg);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(ha->ct_sns, RFT_ID_CMD,
@@ -526,6 +562,7 @@
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
+	struct ct_arg arg;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 		ql_dbg(ql_dbg_disc, vha, 0x2046,
@@ -533,10 +570,16 @@
 		return (QLA_SUCCESS);
 	}
 
+	arg.iocb = ha->ms_iocb;
+	arg.req_dma = ha->ct_sns_dma;
+	arg.rsp_dma = ha->ct_sns_dma;
+	arg.req_size = RFF_ID_REQ_SIZE;
+	arg.rsp_size = RFF_ID_RSP_SIZE;
+	arg.nport_handle = NPH_SNS;
+
 	/* Issue RFF_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, RFF_ID_REQ_SIZE,
-	    RFF_ID_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, &arg);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(ha->ct_sns, RFF_ID_CMD,
@@ -584,14 +627,21 @@
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
+	struct ct_arg arg;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return qla2x00_sns_rnn_id(vha);
 
+	arg.iocb = ha->ms_iocb;
+	arg.req_dma = ha->ct_sns_dma;
+	arg.rsp_dma = ha->ct_sns_dma;
+	arg.req_size = RNN_ID_REQ_SIZE;
+	arg.rsp_size = RNN_ID_RSP_SIZE;
+	arg.nport_handle = NPH_SNS;
+
 	/* Issue RNN_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, RNN_ID_REQ_SIZE,
-	    RNN_ID_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, &arg);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(ha->ct_sns, RNN_ID_CMD, RNN_ID_RSP_SIZE);
@@ -651,6 +701,7 @@
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
+	struct ct_arg arg;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 		ql_dbg(ql_dbg_disc, vha, 0x2050,
@@ -658,10 +709,17 @@
 		return (QLA_SUCCESS);
 	}
 
+	arg.iocb = ha->ms_iocb;
+	arg.req_dma = ha->ct_sns_dma;
+	arg.rsp_dma = ha->ct_sns_dma;
+	arg.req_size = 0;
+	arg.rsp_size = RSNN_NN_RSP_SIZE;
+	arg.nport_handle = NPH_SNS;
+
 	/* Issue RSNN_NN */
 	/* Prepare common MS IOCB */
 	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, 0, RSNN_NN_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, &arg);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(ha->ct_sns, RSNN_NN_CMD,
@@ -1103,7 +1161,7 @@
  *
  * Returns 0 on success.
  */
-static int
+int
 qla2x00_mgmt_svr_login(scsi_qla_host_t *vha)
 {
 	int ret, rval;
@@ -2425,15 +2483,22 @@
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
+	struct ct_arg arg;
 
 	if (!IS_IIDMA_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
+	arg.iocb = ha->ms_iocb;
+	arg.req_dma = ha->ct_sns_dma;
+	arg.rsp_dma = ha->ct_sns_dma;
+	arg.req_size = GFPN_ID_REQ_SIZE;
+	arg.rsp_size = GFPN_ID_RSP_SIZE;
+	arg.nport_handle = NPH_SNS;
+
 	for (i = 0; i < ha->max_fibre_devices; i++) {
 		/* Issue GFPN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GFPN_ID_REQ_SIZE,
-		    GFPN_ID_RSP_SIZE);
+		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, &arg);
 
 		/* Prepare CT request */
 		ct_req = qla2x00_prep_ct_req(ha->ct_sns, GFPN_ID_CMD,
@@ -2471,36 +2536,6 @@
 	return (rval);
 }
 
-static inline void *
-qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *vha, uint32_t req_size,
-    uint32_t rsp_size)
-{
-	struct ct_entry_24xx *ct_pkt;
-	struct qla_hw_data *ha = vha->hw;
-	ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
-	memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
-
-	ct_pkt->entry_type = CT_IOCB_TYPE;
-	ct_pkt->entry_count = 1;
-	ct_pkt->nport_handle = cpu_to_le16(vha->mgmt_svr_loop_id);
-	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
-	ct_pkt->cmd_dsd_count = cpu_to_le16(1);
-	ct_pkt->rsp_dsd_count = cpu_to_le16(1);
-	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
-	ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
-
-	ct_pkt->dseg_0_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
-	ct_pkt->dseg_0_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
-	ct_pkt->dseg_0_len = ct_pkt->cmd_byte_count;
-
-	ct_pkt->dseg_1_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
-	ct_pkt->dseg_1_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
-	ct_pkt->dseg_1_len = ct_pkt->rsp_byte_count;
-	ct_pkt->vp_index = vha->vp_idx;
-
-	return ct_pkt;
-}
-
 
 static inline struct ct_sns_req *
 qla24xx_prep_ct_fm_req(struct ct_sns_pkt *p, uint16_t cmd,
@@ -2530,9 +2565,10 @@
 	int		rval;
 	uint16_t	i;
 	struct qla_hw_data *ha = vha->hw;
-	ms_iocb_entry_t	*ms_pkt;
+	ms_iocb_entry_t *ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
+	struct ct_arg arg;
 
 	if (!IS_IIDMA_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
@@ -2543,11 +2579,17 @@
 	if (rval)
 		return rval;
 
+	arg.iocb = ha->ms_iocb;
+	arg.req_dma = ha->ct_sns_dma;
+	arg.rsp_dma = ha->ct_sns_dma;
+	arg.req_size = GPSC_REQ_SIZE;
+	arg.rsp_size = GPSC_RSP_SIZE;
+	arg.nport_handle = vha->mgmt_svr_loop_id;
+
 	for (i = 0; i < ha->max_fibre_devices; i++) {
 		/* Issue GFPN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = qla24xx_prep_ms_fm_iocb(vha, GPSC_REQ_SIZE,
-		    GPSC_RSP_SIZE);
+		ms_pkt = qla24xx_prep_ms_iocb(vha, &arg);
 
 		/* Prepare CT request */
 		ct_req = qla24xx_prep_ct_fm_req(ha->ct_sns, GPSC_CMD,
@@ -2641,6 +2683,7 @@
 	struct ct_sns_rsp	*ct_rsp;
 	struct qla_hw_data *ha = vha->hw;
 	uint8_t fcp_scsi_features = 0;
+	struct ct_arg arg;
 
 	for (i = 0; i < ha->max_fibre_devices; i++) {
 		/* Set default FC4 Type as UNKNOWN so the default is to
@@ -2651,9 +2694,15 @@
 		if (!IS_FWI2_CAPABLE(ha))
 			continue;
 
+		arg.iocb = ha->ms_iocb;
+		arg.req_dma = ha->ct_sns_dma;
+		arg.rsp_dma = ha->ct_sns_dma;
+		arg.req_size = GFF_ID_REQ_SIZE;
+		arg.rsp_size = GFF_ID_RSP_SIZE;
+		arg.nport_handle = NPH_SNS;
+
 		/* Prepare common MS IOCB */
-		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GFF_ID_REQ_SIZE,
-		    GFF_ID_RSP_SIZE);
+		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, &arg);
 
 		/* Prepare CT request */
 		ct_req = qla2x00_prep_ct_req(ha->ct_sns, GFF_ID_CMD,
@@ -2692,3 +2741,536 @@
 			break;
 	}
 }
+
+/* GID_PN completion processing. */
+void qla24xx_handle_gidpn_event(scsi_qla_host_t *vha, struct event_arg *ea)
+{
+	fc_port_t *fcport = ea->fcport;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"%s %8phC login state %d \n",
+		__func__, fcport->port_name, fcport->fw_login_state);
+
+	if (ea->sp->gen2 != fcport->login_gen) {
+		/* PLOGI/PRLI/LOGO came in while cmd was out.*/
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		    "%s %8phC generation changed rscn %d|%d login %d|%d \n",
+		    __func__, fcport->port_name, fcport->last_rscn_gen,
+		    fcport->rscn_gen, fcport->last_login_gen, fcport->login_gen);
+		return;
+	}
+
+	if (!ea->rc) {
+		if (ea->sp->gen1 == fcport->rscn_gen) {
+			fcport->scan_state = QLA_FCPORT_FOUND;
+			fcport->flags |= FCF_FABRIC_DEVICE;
+
+			if (fcport->d_id.b24 == ea->id.b24) {
+				/* cable plugged into the same place */
+				switch (vha->host->active_mode) {
+				case MODE_TARGET:
+					/* NOOP. let the other guy login to us.*/
+					break;
+				case MODE_INITIATOR:
+				case MODE_DUAL:
+				default:
+					if (atomic_read(&fcport->state) ==
+					    FCS_ONLINE)
+						break;
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+					    "%s %d %8phC post gnl\n",
+					    __func__, __LINE__, fcport->port_name);
+					qla24xx_post_gnl_work(vha, fcport);
+					break;
+				}
+			} else { /* fcport->d_id.b24 != ea->id.b24 */
+				fcport->d_id.b24 = ea->id.b24;
+				if (fcport->deleted == QLA_SESS_DELETED) {
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+					    "%s %d %8phC post del sess\n",
+					    __func__, __LINE__, fcport->port_name);
+					qlt_schedule_sess_for_deletion_lock(fcport);
+				}
+			}
+		} else { /* ea->sp->gen1 != fcport->rscn_gen */
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s %d %8phC post gidpn\n",
+			    __func__, __LINE__, fcport->port_name);
+			/* rscn came in while cmd was out */
+			qla24xx_post_gidpn_work(vha, fcport);
+		}
+	} else { /* ea->rc */
+		/* cable pulled */
+		if (ea->sp->gen1 == fcport->rscn_gen) {
+			if (ea->sp->gen2 == fcport->login_gen) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				    "%s %d %8phC post del sess\n", __func__,
+				    __LINE__, fcport->port_name);
+				qlt_schedule_sess_for_deletion_lock(fcport);
+			} else {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				    "%s %d %8phC login\n", __func__, __LINE__,
+				    fcport->port_name);
+				qla24xx_fcport_handle_login(vha, fcport);
+			}
+		} else {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s %d %8phC post gidpn\n", __func__, __LINE__,
+			    fcport->port_name);
+			qla24xx_post_gidpn_work(vha, fcport);
+		}
+	}
+} /* gidpn_event */
+
+static void qla2x00_async_gidpn_sp_done(void *v, void *s, int res)
+{
+	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
+	struct srb *sp = (struct srb *)s;
+	fc_port_t *fcport = sp->fcport;
+	u8 *id = fcport->ct_desc.ct_sns->p.rsp.rsp.gid_pn.port_id;
+	struct event_arg ea;
+
+	fcport->flags &= ~FCF_ASYNC_SENT;
+
+	memset(&ea, 0, sizeof(ea));
+	ea.fcport = fcport;
+	ea.id.b.domain = id[0];
+	ea.id.b.area = id[1];
+	ea.id.b.al_pa = id[2];
+	ea.sp = sp;
+	ea.rc = res;
+	ea.event = FCME_GIDPN_DONE;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "Async done-%s res %x, WWPN %8phC ID %3phC \n",
+	    sp->name, res, fcport->port_name, id);
+
+	qla2x00_fcport_event_handler(vha, &ea);
+
+	sp->free(vha, sp);
+}
+
+int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	struct ct_sns_req       *ct_req;
+	srb_t *sp;
+
+	if (!vha->flags.online)
+		goto done;
+
+	fcport->flags |= FCF_ASYNC_SENT;
+	fcport->disc_state = DSC_GID_PN;
+	fcport->scan_state = QLA_FCPORT_SCAN;
+	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
+	if (!sp)
+		goto done;
+
+	sp->type = SRB_CT_PTHRU_CMD;
+	sp->name = "gidpn";
+	sp->gen1 = fcport->rscn_gen;
+	sp->gen2 = fcport->login_gen;
+
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
+	/* CT_IU preamble  */
+	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GID_PN_CMD,
+		GID_PN_RSP_SIZE);
+
+	/* GIDPN req */
+	memcpy(ct_req->req.gid_pn.port_name, fcport->port_name,
+		WWN_SIZE);
+
+	/* req & rsp use the same buffer */
+	sp->u.iocb_cmd.u.ctarg.req = fcport->ct_desc.ct_sns;
+	sp->u.iocb_cmd.u.ctarg.req_dma = fcport->ct_desc.ct_sns_dma;
+	sp->u.iocb_cmd.u.ctarg.rsp = fcport->ct_desc.ct_sns;
+	sp->u.iocb_cmd.u.ctarg.rsp_dma = fcport->ct_desc.ct_sns_dma;
+	sp->u.iocb_cmd.u.ctarg.req_size = GID_PN_REQ_SIZE;
+	sp->u.iocb_cmd.u.ctarg.rsp_size = GID_PN_RSP_SIZE;
+	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
+
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
+	sp->done = qla2x00_async_gidpn_sp_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	ql_dbg(ql_dbg_disc, vha, 0x206f,
+		"Async-%s - %8phC hdl=%x loopid=%x portid %02x%02x%02x.\n",
+		sp->name, fcport->port_name,
+		sp->handle, fcport->loop_id, fcport->d_id.b.domain,
+		fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	return rval;
+
+done_free_sp:
+	sp->free(vha, sp);
+done:
+	fcport->flags &= ~FCF_ASYNC_SENT;
+	return rval;
+}
+
+int qla24xx_post_gidpn_work(struct scsi_qla_host *vha, fc_port_t *fcport)
+{
+	struct qla_work_evt *e;
+
+	if ((atomic_read(&vha->loop_state) != LOOP_READY) ||
+		test_bit(UNLOADING, &vha->dpc_flags))
+		return 0;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_GIDPN);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.fcport.fcport = fcport;
+	return qla2x00_post_work(vha, e);
+}
+
+int qla24xx_post_gpsc_work(struct scsi_qla_host *vha, fc_port_t *fcport)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_GPSC);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.fcport.fcport = fcport;
+	return qla2x00_post_work(vha, e);
+}
+
+static void qla24xx_async_gpsc_sp_done(void *v, void *s, int res)
+{
+	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
+	struct qla_hw_data *ha = vha->hw;
+	struct srb *sp = (struct srb *)s;
+	fc_port_t *fcport = sp->fcport;
+	struct ct_sns_rsp       *ct_rsp;
+	struct event_arg ea;
+
+	ct_rsp = &fcport->ct_desc.ct_sns->p.rsp;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "Async done-%s res %x, WWPN %8phC \n",
+	    sp->name, res, fcport->port_name);
+
+	fcport->flags &= ~FCF_ASYNC_SENT;
+
+	if (res == (DID_ERROR << 16)) {
+		/* entry status error */
+		goto done;
+	} else if (res) {
+		if ((ct_rsp->header.reason_code ==
+			 CT_REASON_INVALID_COMMAND_CODE) ||
+			(ct_rsp->header.reason_code ==
+			 CT_REASON_COMMAND_UNSUPPORTED)) {
+			ql_dbg(ql_dbg_disc, vha, 0x205a,
+				"GPSC command unsupported, disabling "
+				"query.\n");
+			ha->flags.gpsc_supported = 0;
+			res = QLA_SUCCESS;
+		}
+	} else {
+		switch (be16_to_cpu(ct_rsp->rsp.gpsc.speed)) {
+		case BIT_15:
+			fcport->fp_speed = PORT_SPEED_1GB;
+			break;
+		case BIT_14:
+			fcport->fp_speed = PORT_SPEED_2GB;
+			break;
+		case BIT_13:
+			fcport->fp_speed = PORT_SPEED_4GB;
+			break;
+		case BIT_12:
+			fcport->fp_speed = PORT_SPEED_10GB;
+			break;
+		case BIT_11:
+			fcport->fp_speed = PORT_SPEED_8GB;
+			break;
+		case BIT_10:
+			fcport->fp_speed = PORT_SPEED_16GB;
+			break;
+		case BIT_8:
+			fcport->fp_speed = PORT_SPEED_32GB;
+			break;
+		}
+
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"Async-%s OUT WWPN %8phC speeds=%04x speed=%04x.\n",
+			sp->name,
+			fcport->fabric_port_name,
+			be16_to_cpu(ct_rsp->rsp.gpsc.speeds),
+			be16_to_cpu(ct_rsp->rsp.gpsc.speed));
+	}
+done:
+	memset(&ea, 0, sizeof(ea));
+	ea.event = FCME_GPSC_DONE;
+	ea.rc = res;
+	ea.fcport = fcport;
+	qla2x00_fcport_event_handler(vha, &ea);
+
+	sp->free(vha, sp);
+}
+
+int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	struct ct_sns_req       *ct_req;
+	srb_t *sp;
+
+	if (!vha->flags.online)
+		goto done;
+
+	fcport->flags |= FCF_ASYNC_SENT;
+	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	if (!sp)
+		goto done;
+
+	sp->type = SRB_CT_PTHRU_CMD;
+	sp->name = "gpsc";
+	sp->gen1 = fcport->rscn_gen;
+	sp->gen2 = fcport->login_gen;
+
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
+	/* CT_IU preamble  */
+	ct_req = qla24xx_prep_ct_fm_req(fcport->ct_desc.ct_sns, GPSC_CMD,
+		GPSC_RSP_SIZE);
+
+	/* GPSC req */
+	memcpy(ct_req->req.gpsc.port_name, fcport->port_name,
+		WWN_SIZE);
+
+	sp->u.iocb_cmd.u.ctarg.req = fcport->ct_desc.ct_sns;
+	sp->u.iocb_cmd.u.ctarg.req_dma = fcport->ct_desc.ct_sns_dma;
+	sp->u.iocb_cmd.u.ctarg.rsp = fcport->ct_desc.ct_sns;
+	sp->u.iocb_cmd.u.ctarg.rsp_dma = fcport->ct_desc.ct_sns_dma;
+	sp->u.iocb_cmd.u.ctarg.req_size = GPSC_REQ_SIZE;
+	sp->u.iocb_cmd.u.ctarg.rsp_size = GPSC_RSP_SIZE;
+	sp->u.iocb_cmd.u.ctarg.nport_handle = vha->mgmt_svr_loop_id;
+
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
+	sp->done = qla24xx_async_gpsc_sp_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"Async-%s %8phC hdl=%x loopid=%x portid=%02x%02x%02x.\n",
+		sp->name, fcport->port_name, sp->handle,
+		fcport->loop_id, fcport->d_id.b.domain,
+		fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	return rval;
+
+done_free_sp:
+	sp->free(vha, sp);
+done:
+	fcport->flags &= ~FCF_ASYNC_SENT;
+	return rval;
+}
+
+int qla24xx_post_gpnid_work(struct scsi_qla_host *vha, port_id_t *id)
+{
+	struct qla_work_evt *e;
+
+	if (test_bit(UNLOADING, &vha->dpc_flags))
+		return 0;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_GPNID);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.gpnid.id = *id;
+	return qla2x00_post_work(vha, e);
+}
+
+void qla24xx_async_gpnid_done(scsi_qla_host_t *vha, srb_t *sp)
+{
+	if (sp->u.iocb_cmd.u.ctarg.req) {
+		dma_free_coherent(&vha->hw->pdev->dev,
+			sizeof(struct ct_sns_pkt),
+			sp->u.iocb_cmd.u.ctarg.req,
+			sp->u.iocb_cmd.u.ctarg.req_dma);
+		sp->u.iocb_cmd.u.ctarg.req = NULL;
+	}
+	if (sp->u.iocb_cmd.u.ctarg.rsp) {
+		dma_free_coherent(&vha->hw->pdev->dev,
+			sizeof(struct ct_sns_pkt),
+			sp->u.iocb_cmd.u.ctarg.rsp,
+			sp->u.iocb_cmd.u.ctarg.rsp_dma);
+		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+	}
+
+	sp->free(vha, sp);
+}
+
+void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
+{
+	fc_port_t *fcport;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	fcport = qla2x00_find_fcport_by_wwpn(vha, ea->port_name, 1);
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
+	if (fcport) {
+		/* cable moved. just plugged in */
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post del sess\n",
+			   __func__, __LINE__, fcport->port_name);
+
+		fcport->rscn_gen++;
+		fcport->d_id = ea->id;
+		fcport->scan_state = QLA_FCPORT_FOUND;
+		fcport->flags |= FCF_FABRIC_DEVICE;
+
+		qlt_schedule_sess_for_deletion_lock(fcport);
+	} else {
+		/* create new fcport */
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post new sess\n",
+			   __func__, __LINE__, ea->port_name);
+
+		qla24xx_post_newsess_work(vha, &ea->id, ea->port_name, NULL);
+	}
+}
+
+static void qla2x00_async_gpnid_sp_done(void *v, void *s, int res)
+{
+	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
+	struct srb *sp = (struct srb *)s;
+	struct ct_sns_req *ct_req =
+	    (struct ct_sns_req *)sp->u.iocb_cmd.u.ctarg.req;
+	struct ct_sns_rsp *ct_rsp =
+	    (struct ct_sns_rsp *)sp->u.iocb_cmd.u.ctarg.rsp;
+	struct event_arg ea;
+	struct qla_work_evt *e;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"Async done-%s res %x ID %3phC. %8phC\n",
+		sp->name, res, ct_req->req.port_id.port_id,
+		ct_rsp->rsp.gpn_id.port_name);
+
+	memset(&ea, 0, sizeof(ea));
+	memcpy(ea.port_name, ct_rsp->rsp.gpn_id.port_name, WWN_SIZE);
+	ea.sp = sp;
+	ea.id.b.domain = ct_req->req.port_id.port_id[0];
+	ea.id.b.area = ct_req->req.port_id.port_id[1];
+	ea.id.b.al_pa = ct_req->req.port_id.port_id[2];
+	ea.rc = res;
+	ea.event = FCME_GPNID_DONE;
+
+	qla2x00_fcport_event_handler(vha, &ea);
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_GPNID_DONE);
+	if (!e) {
+		/* please ignore kernel warning. otherwise, we have mem leak. */
+		if (sp->u.iocb_cmd.u.ctarg.req) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+				sizeof(struct ct_sns_pkt),
+				sp->u.iocb_cmd.u.ctarg.req,
+				sp->u.iocb_cmd.u.ctarg.req_dma);
+			sp->u.iocb_cmd.u.ctarg.req = NULL;
+		}
+		if (sp->u.iocb_cmd.u.ctarg.rsp) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+				sizeof(struct ct_sns_pkt),
+				sp->u.iocb_cmd.u.ctarg.rsp,
+				sp->u.iocb_cmd.u.ctarg.rsp_dma);
+			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+		}
+
+		sp->free(vha, sp);
+		return;
+	}
+
+	e->u.iosb.sp = sp;
+	qla2x00_post_work(vha, e);
+}
+
+/* Get WWPN with Nport ID. */
+int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	struct ct_sns_req       *ct_req;
+	srb_t *sp;
+	struct ct_sns_pkt *ct_sns;
+
+	if (!vha->flags.online)
+		goto done;
+
+	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
+	if (!sp)
+		goto done;
+
+	sp->type = SRB_CT_PTHRU_CMD;
+	sp->name = "gpnid";
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
+	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
+		sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
+		GFP_KERNEL);
+	if (!sp->u.iocb_cmd.u.ctarg.req) {
+		ql_log(ql_log_warn, vha, 0xffff,
+			"Failed to allocate ct_sns request.\n");
+		goto done_free_sp;
+	}
+
+	sp->u.iocb_cmd.u.ctarg.rsp = dma_alloc_coherent(&vha->hw->pdev->dev,
+		sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.rsp_dma,
+		GFP_KERNEL);
+	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
+		ql_log(ql_log_warn, vha, 0xffff,
+			"Failed to allocate ct_sns request.\n");
+		goto done_free_sp;
+	}
+
+	ct_sns = (struct ct_sns_pkt *)sp->u.iocb_cmd.u.ctarg.rsp;
+	memset(ct_sns, 0, sizeof(*ct_sns));
+
+	ct_sns = (struct ct_sns_pkt *)sp->u.iocb_cmd.u.ctarg.req;
+	/* CT_IU preamble  */
+	ct_req = qla2x00_prep_ct_req(ct_sns, GPN_ID_CMD, GPN_ID_RSP_SIZE);
+
+	/* GPN_ID req */
+	ct_req->req.port_id.port_id[0] = id->b.domain;
+	ct_req->req.port_id.port_id[1] = id->b.area;
+	ct_req->req.port_id.port_id[2] = id->b.al_pa;
+
+	sp->u.iocb_cmd.u.ctarg.req_size = GPN_ID_REQ_SIZE;
+	sp->u.iocb_cmd.u.ctarg.rsp_size = GPN_ID_RSP_SIZE;
+	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
+
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
+	sp->done = qla2x00_async_gpnid_sp_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"Async-%s hdl=%x ID %3phC.\n", sp->name,
+		sp->handle, ct_req->req.port_id.port_id);
+	return rval;
+
+done_free_sp:
+	if (sp->u.iocb_cmd.u.ctarg.req) {
+		dma_free_coherent(&vha->hw->pdev->dev,
+			sizeof(struct ct_sns_pkt),
+			sp->u.iocb_cmd.u.ctarg.req,
+			sp->u.iocb_cmd.u.ctarg.req_dma);
+		sp->u.iocb_cmd.u.ctarg.req = NULL;
+	}
+	if (sp->u.iocb_cmd.u.ctarg.rsp) {
+		dma_free_coherent(&vha->hw->pdev->dev,
+			sizeof(struct ct_sns_pkt),
+			sp->u.iocb_cmd.u.ctarg.rsp,
+			sp->u.iocb_cmd.u.ctarg.rsp_dma);
+		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+	}
+
+	sp->free(vha, sp);
+done:
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5978b79..e628107 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -30,15 +30,15 @@
 static int qla2x00_configure_loop(scsi_qla_host_t *);
 static int qla2x00_configure_local_loop(scsi_qla_host_t *);
 static int qla2x00_configure_fabric(scsi_qla_host_t *);
-static int qla2x00_find_all_fabric_devs(scsi_qla_host_t *, struct list_head *);
-static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
-    uint16_t *);
-
+static int qla2x00_find_all_fabric_devs(scsi_qla_host_t *);
 static int qla2x00_restart_isp(scsi_qla_host_t *);
 
 static struct qla_chip_state_84xx *qla84xx_get_chip(struct scsi_qla_host *);
 static int qla84xx_init_chip(scsi_qla_host_t *);
 static int qla25xx_init_queues(struct qla_hw_data *);
+static int qla24xx_post_gpdb_work(struct scsi_qla_host *, fc_port_t *, u8);
+static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
+    struct event_arg *);
 
 /* SRB Extensions ---------------------------------------------------------- */
 
@@ -47,8 +47,8 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 {
 	srb_t *sp = (srb_t *)__data;
 	struct srb_iocb *iocb;
-	fc_port_t *fcport = sp->fcport;
-	struct qla_hw_data *ha = fcport->vha->hw;
+	scsi_qla_host_t *vha = (scsi_qla_host_t *)sp->vha;
+	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
 	unsigned long flags;
 
@@ -57,7 +57,7 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 	req->outstanding_cmds[sp->handle] = NULL;
 	iocb = &sp->u.iocb_cmd;
 	iocb->timeout(sp);
-	sp->free(fcport->vha, sp);
+	sp->free(vha, sp);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
@@ -94,29 +94,44 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 	return tmo;
 }
 
-static void
+void
 qla2x00_async_iocb_timeout(void *data)
 {
 	srb_t *sp = (srb_t *)data;
 	fc_port_t *fcport = sp->fcport;
+	struct srb_iocb *lio = &sp->u.iocb_cmd;
+	struct event_arg ea;
 
 	ql_dbg(ql_dbg_disc, fcport->vha, 0x2071,
-	    "Async-%s timeout - hdl=%x portid=%02x%02x%02x.\n",
-	    sp->name, sp->handle, fcport->d_id.b.domain, fcport->d_id.b.area,
-	    fcport->d_id.b.al_pa);
+	    "Async-%s timeout - hdl=%x portid=%06x %8phC.\n",
+	    sp->name, sp->handle, fcport->d_id.b24, fcport->port_name);
 
 	fcport->flags &= ~FCF_ASYNC_SENT;
-	if (sp->type == SRB_LOGIN_CMD) {
-		struct srb_iocb *lio = &sp->u.iocb_cmd;
-		qla2x00_post_async_logout_work(fcport->vha, fcport, NULL);
+
+	switch (sp->type) {
+	case SRB_LOGIN_CMD:
 		/* Retry as needed. */
 		lio->u.logio.data[0] = MBS_COMMAND_ERROR;
 		lio->u.logio.data[1] = lio->u.logio.flags & SRB_LOGIN_RETRIED ?
 			QLA_LOGIO_LOGIN_RETRIED : 0;
-		qla2x00_post_async_login_done_work(fcport->vha, fcport,
-			lio->u.logio.data);
-	} else if (sp->type == SRB_LOGOUT_CMD) {
+		memset(&ea, 0, sizeof(ea));
+		ea.event = FCME_PLOGI_DONE;
+		ea.fcport = sp->fcport;
+		ea.data[0] = lio->u.logio.data[0];
+		ea.data[1] = lio->u.logio.data[1];
+		ea.sp = sp;
+		qla24xx_handle_plogi_done_event(fcport->vha, &ea);
+		break;
+	case SRB_LOGOUT_CMD:
 		qlt_logo_completion_handler(fcport, QLA_FUNCTION_TIMEOUT);
+		break;
+	case SRB_CT_PTHRU_CMD:
+	case SRB_MB_IOCB:
+	case SRB_NACK_PLOGI:
+	case SRB_NACK_PRLI:
+	case SRB_NACK_LOGO:
+		sp->done(sp->vha, sp, QLA_FUNCTION_TIMEOUT);
+		break;
 	}
 }
 
@@ -126,10 +141,25 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 	srb_t *sp = (srb_t *)ptr;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
+	struct event_arg ea;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"%s %8phC res %d \n",
+		   __func__, sp->fcport->port_name, res);
+
+	sp->fcport->flags &= ~FCF_ASYNC_SENT;
+	if (!test_bit(UNLOADING, &vha->dpc_flags)) {
+		memset(&ea, 0, sizeof(ea));
+		ea.event = FCME_PLOGI_DONE;
+		ea.fcport = sp->fcport;
+		ea.data[0] = lio->u.logio.data[0];
+		ea.data[1] = lio->u.logio.data[1];
+		ea.iop[0] = lio->u.logio.iop[0];
+		ea.iop[1] = lio->u.logio.iop[1];
+		ea.sp = sp;
+		qla2x00_fcport_event_handler(vha, &ea);
+	}
 
-	if (!test_bit(UNLOADING, &vha->dpc_flags))
-		qla2x00_post_async_login_done_work(sp->fcport->vha, sp->fcport,
-		    lio->u.logio.data);
 	sp->free(sp->fcport->vha, sp);
 }
 
@@ -139,13 +169,23 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 {
 	srb_t *sp;
 	struct srb_iocb *lio;
-	int rval;
+	int rval = QLA_FUNCTION_FAILED;
+
+	if (!vha->flags.online)
+		goto done;
+
+	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
+	    (fcport->fw_login_state == DSC_LS_PLOGI_COMP) ||
+	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
+		goto done;
 
-	rval = QLA_FUNCTION_FAILED;
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
+	fcport->flags |= FCF_ASYNC_SENT;
+	fcport->logout_completed = 0;
+
 	sp->type = SRB_LOGIN_CMD;
 	sp->name = "login";
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
@@ -165,8 +205,8 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 	}
 
 	ql_dbg(ql_dbg_disc, vha, 0x2072,
-	    "Async-login - hdl=%x, loopid=%x portid=%02x%02x%02x "
-	    "retries=%d.\n", sp->handle, fcport->loop_id,
+	    "Async-login - %8phC hdl=%x, loopid=%x portid=%02x%02x%02x "
+		"retries=%d.\n", fcport->port_name, sp->handle, fcport->loop_id,
 	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa,
 	    fcport->login_retry);
 	return rval;
@@ -174,6 +214,7 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 done_free_sp:
 	sp->free(fcport->vha, sp);
 done:
+	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
 
@@ -184,6 +225,7 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
 
+	sp->fcport->flags &= ~FCF_ASYNC_SENT;
 	if (!test_bit(UNLOADING, &vha->dpc_flags))
 		qla2x00_post_async_logout_done_work(sp->fcport->vha, sp->fcport,
 		    lio->u.logio.data);
@@ -198,6 +240,7 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 	int rval;
 
 	rval = QLA_FUNCTION_FAILED;
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -214,14 +257,16 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 		goto done_free_sp;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2070,
-	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
+	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC.\n",
 	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+		fcport->d_id.b.area, fcport->d_id.b.al_pa,
+		fcport->port_name);
 	return rval;
 
 done_free_sp:
 	sp->free(fcport->vha, sp);
 done:
+	sp->fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
 
@@ -247,6 +292,7 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 	int rval;
 
 	rval = QLA_FUNCTION_FAILED;
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -273,9 +319,817 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 done_free_sp:
 	sp->free(fcport->vha, sp);
 done:
+	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
 
+static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
+	struct event_arg *ea)
+{
+	fc_port_t *fcport, *conflict_fcport;
+	struct get_name_list_extended *e;
+	u16 i, n, found = 0, loop_id;
+	port_id_t id;
+	u64 wwn;
+	u8 opt = 0;
+
+	fcport = ea->fcport;
+
+	if (ea->rc) { /* rval */
+		if (fcport->login_retry == 0) {
+			fcport->login_retry = vha->hw->login_retry_count;
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+				"GNL failed Port login retry %8phN, retry cnt=%d.\n",
+				fcport->port_name, fcport->login_retry);
+		}
+		return;
+	}
+
+	if (fcport->last_rscn_gen != fcport->rscn_gen) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		    "%s %8phC rscn gen changed rscn %d|%d \n",
+		    __func__, fcport->port_name,
+		    fcport->last_rscn_gen, fcport->rscn_gen);
+		qla24xx_post_gidpn_work(vha, fcport);
+		return;
+	} else if (fcport->last_login_gen != fcport->login_gen) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			"%s %8phC login gen changed login %d|%d \n",
+			__func__, fcport->port_name,
+			fcport->last_login_gen, fcport->login_gen);
+		return;
+	}
+
+	n = ea->data[0] / sizeof(struct get_name_list_extended);
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "%s %d %8phC n %d %02x%02x%02x lid %d \n",
+	    __func__, __LINE__, fcport->port_name, n,
+	    fcport->d_id.b.domain, fcport->d_id.b.area,
+	    fcport->d_id.b.al_pa, fcport->loop_id);
+
+	for (i = 0; i < n; i++) {
+		e = &vha->gnl.l[i];
+		wwn = wwn_to_u64(e->port_name);
+
+		if (memcmp((u8 *)&wwn, fcport->port_name, WWN_SIZE))
+			continue;
+
+		found = 1;
+		id.b.domain = e->port_id[2];
+		id.b.area = e->port_id[1];
+		id.b.al_pa = e->port_id[0];
+		id.b.rsvd_1 = 0;
+
+		loop_id = le16_to_cpu(e->nport_handle);
+		loop_id = (loop_id & 0x7fff);
+
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			"%s found %8phC CLS [%d|%d] ID[%02x%02x%02x|%02x%02x%02x] lid[%d|%d]\n",
+			   __func__, fcport->port_name,
+			e->current_login_state, fcport->fw_login_state,
+			id.b.domain, id.b.area, id.b.al_pa,
+			fcport->d_id.b.domain, fcport->d_id.b.area,
+			fcport->d_id.b.al_pa, loop_id, fcport->loop_id);
+
+		if ((id.b24 != fcport->d_id.b24) ||
+		    ((fcport->loop_id != FC_NO_LOOP_ID) &&
+			(fcport->loop_id != loop_id))) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post del sess\n",
+			   __func__, __LINE__, fcport->port_name);
+			qlt_schedule_sess_for_deletion(fcport, 1);
+			return;
+		}
+
+		fcport->loop_id = loop_id;
+
+		wwn = wwn_to_u64(fcport->port_name);
+		qlt_find_sess_invalidate_other(vha, wwn,
+			id, loop_id, &conflict_fcport);
+
+		if (conflict_fcport) {
+			/*
+			 * Another share fcport share the same loop_id &
+			 * nport id. Conflict fcport needs to finish
+			 * cleanup before this fcport can proceed to login.
+			 */
+			conflict_fcport->conflict = fcport;
+			fcport->login_pause = 1;
+		}
+
+		switch (e->current_login_state) {
+		case DSC_LS_PRLI_COMP:
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gpdb\n",
+			   __func__, __LINE__, fcport->port_name);
+			opt = PDO_FORCE_ADISC;
+			qla24xx_post_gpdb_work(vha, fcport, opt);
+			break;
+
+		case DSC_LS_PORT_UNAVAIL:
+		default:
+			if (fcport->loop_id == FC_NO_LOOP_ID) {
+				qla2x00_find_new_loop_id(vha, fcport);
+				fcport->fw_login_state = DSC_LS_PORT_UNAVAIL;
+			}
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC \n",
+			   __func__, __LINE__, fcport->port_name);
+			qla24xx_fcport_handle_login(vha, fcport);
+			break;
+		}
+	}
+
+	if (!found) {
+		/* fw has no record of this port */
+		if (fcport->loop_id == FC_NO_LOOP_ID) {
+			qla2x00_find_new_loop_id(vha, fcport);
+			fcport->fw_login_state = DSC_LS_PORT_UNAVAIL;
+		} else {
+			for (i = 0; i < n; i++) {
+				e = &vha->gnl.l[i];
+				id.b.domain = e->port_id[0];
+				id.b.area = e->port_id[1];
+				id.b.al_pa = e->port_id[2];
+				id.b.rsvd_1 = 0;
+				loop_id = le16_to_cpu(e->nport_handle);
+
+				if (fcport->d_id.b24 == id.b24) {
+					conflict_fcport =
+					    qla2x00_find_fcport_by_wwpn(vha,
+						e->port_name, 0);
+
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+					    "%s %d %8phC post del sess\n",
+					    __func__, __LINE__,
+					    conflict_fcport->port_name);
+					qlt_schedule_sess_for_deletion
+						(conflict_fcport, 1);
+				}
+
+				if (fcport->loop_id == loop_id) {
+					/* FW already picked this loop id for another fcport */
+					qla2x00_find_new_loop_id(vha, fcport);
+				}
+			}
+		}
+		qla24xx_fcport_handle_login(vha, fcport);
+	}
+} /* gnl_event */
+
+static void
+qla24xx_async_gnl_sp_done(void *v, void *s, int res)
+{
+	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
+	struct srb *sp = (struct srb *)s;
+	unsigned long flags;
+	struct fc_port *fcport = NULL, *tf;
+	u16 i, n = 0, loop_id;
+	struct event_arg ea;
+	struct get_name_list_extended *e;
+	u64 wwn;
+	struct list_head h;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "Async done-%s res %x mb[1]=%x mb[2]=%x \n",
+	    sp->name, res, sp->u.iocb_cmd.u.mbx.in_mb[1],
+	    sp->u.iocb_cmd.u.mbx.in_mb[2]);
+
+	memset(&ea, 0, sizeof(ea));
+	ea.sp = sp;
+	ea.rc = res;
+	ea.event = FCME_GNL_DONE;
+
+	if (sp->u.iocb_cmd.u.mbx.in_mb[1] >=
+	    sizeof(struct get_name_list_extended)) {
+		n = sp->u.iocb_cmd.u.mbx.in_mb[1] /
+		    sizeof(struct get_name_list_extended);
+		ea.data[0] = sp->u.iocb_cmd.u.mbx.in_mb[1]; /* amnt xfered */
+	}
+
+	for (i = 0; i < n; i++) {
+		e = &vha->gnl.l[i];
+		loop_id = le16_to_cpu(e->nport_handle);
+		/* mask out reserve bit */
+		loop_id = (loop_id & 0x7fff);
+		set_bit(loop_id, vha->hw->loop_id_map);
+		wwn = wwn_to_u64(e->port_name);
+
+		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
+		    "%s %8phC %02x:%02x:%02x state %d/%d lid %x \n",
+		    __func__, (void *)&wwn, e->port_id[2], e->port_id[1],
+		    e->port_id[0], e->current_login_state, e->last_login_state,
+		    (loop_id & 0x7fff));
+	}
+
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	vha->gnl.sent = 0;
+
+	INIT_LIST_HEAD(&h);
+	fcport = tf = NULL;
+	if (!list_empty(&vha->gnl.fcports))
+		list_splice_init(&vha->gnl.fcports, &h);
+
+	list_for_each_entry_safe(fcport, tf, &h, gnl_entry) {
+		list_del_init(&fcport->gnl_entry);
+		fcport->flags &= ~FCF_ASYNC_SENT;
+		ea.fcport = fcport;
+
+		qla2x00_fcport_event_handler(vha, &ea);
+	}
+
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
+	sp->free(vha, sp);
+}
+
+int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
+{
+	srb_t *sp;
+	struct srb_iocb *mbx;
+	int rval = QLA_FUNCTION_FAILED;
+	unsigned long flags;
+	u16 *mb;
+
+	if (!vha->flags.online)
+		goto done;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "Async-gnlist WWPN %8phC \n", fcport->port_name);
+
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	fcport->flags |= FCF_ASYNC_SENT;
+	fcport->disc_state = DSC_GNL;
+	fcport->last_rscn_gen = fcport->rscn_gen;
+	fcport->last_login_gen = fcport->login_gen;
+
+	list_add_tail(&fcport->gnl_entry, &vha->gnl.fcports);
+	if (vha->gnl.sent) {
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+		rval = QLA_SUCCESS;
+		goto done;
+	}
+	vha->gnl.sent = 1;
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
+	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	if (!sp)
+		goto done;
+	sp->type = SRB_MB_IOCB;
+	sp->name = "gnlist";
+	sp->gen1 = fcport->rscn_gen;
+	sp->gen2 = fcport->login_gen;
+
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
+
+	mb = sp->u.iocb_cmd.u.mbx.out_mb;
+	mb[0] = MBC_PORT_NODE_NAME_LIST;
+	mb[1] = BIT_2 | BIT_3;
+	mb[2] = MSW(vha->gnl.ldma);
+	mb[3] = LSW(vha->gnl.ldma);
+	mb[6] = MSW(MSD(vha->gnl.ldma));
+	mb[7] = LSW(MSD(vha->gnl.ldma));
+	mb[8] = vha->gnl.size;
+	mb[9] = vha->vp_idx;
+
+	mbx = &sp->u.iocb_cmd;
+	mbx->timeout = qla2x00_async_iocb_timeout;
+
+	sp->done = qla24xx_async_gnl_sp_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"Async-%s - OUT WWPN %8phC hndl %x\n",
+		sp->name, fcport->port_name, sp->handle);
+
+	return rval;
+
+done_free_sp:
+	sp->free(fcport->vha, sp);
+done:
+	fcport->flags &= ~FCF_ASYNC_SENT;
+	return rval;
+}
+
+int qla24xx_post_gnl_work(struct scsi_qla_host *vha, fc_port_t *fcport)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_GNL);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.fcport.fcport = fcport;
+	return qla2x00_post_work(vha, e);
+}
+
+static
+void qla24xx_async_gpdb_sp_done(void *v, void *s, int res)
+{
+	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
+	struct srb *sp = (struct srb *)s;
+	struct qla_hw_data *ha = vha->hw;
+	uint64_t zero = 0;
+	struct port_database_24xx *pd;
+	fc_port_t *fcport = sp->fcport;
+	u16 *mb = sp->u.iocb_cmd.u.mbx.in_mb;
+	int rval = QLA_SUCCESS;
+	struct event_arg ea;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "Async done-%s res %x, WWPN %8phC mb[1]=%x mb[2]=%x \n",
+	    sp->name, res, fcport->port_name, mb[1], mb[2]);
+
+	fcport->flags &= ~FCF_ASYNC_SENT;
+
+	if (res) {
+		rval = res;
+		goto gpd_error_out;
+	}
+
+	pd = (struct port_database_24xx *)sp->u.iocb_cmd.u.mbx.in;
+
+	/* Check for logged in state. */
+	if (pd->current_login_state != PDS_PRLI_COMPLETE &&
+	    pd->last_login_state != PDS_PRLI_COMPLETE) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+		    "Unable to verify login-state (%x/%x) for "
+		    "loop_id %x.\n", pd->current_login_state,
+		    pd->last_login_state, fcport->loop_id);
+		rval = QLA_FUNCTION_FAILED;
+		goto gpd_error_out;
+	}
+
+	if (fcport->loop_id == FC_NO_LOOP_ID ||
+	    (memcmp(fcport->port_name, (uint8_t *)&zero, 8) &&
+		memcmp(fcport->port_name, pd->port_name, 8))) {
+		/* We lost the device mid way. */
+		rval = QLA_NOT_LOGGED_IN;
+		goto gpd_error_out;
+	}
+
+	/* Names are little-endian. */
+	memcpy(fcport->node_name, pd->node_name, WWN_SIZE);
+
+	/* Get port_id of device. */
+	fcport->d_id.b.domain = pd->port_id[0];
+	fcport->d_id.b.area = pd->port_id[1];
+	fcport->d_id.b.al_pa = pd->port_id[2];
+	fcport->d_id.b.rsvd_1 = 0;
+
+	/* If not target must be initiator or unknown type. */
+	if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
+		fcport->port_type = FCT_INITIATOR;
+	else
+		fcport->port_type = FCT_TARGET;
+
+	/* Passback COS information. */
+	fcport->supported_classes = (pd->flags & PDF_CLASS_2) ?
+		FC_COS_CLASS2 : FC_COS_CLASS3;
+
+	if (pd->prli_svc_param_word_3[0] & BIT_7) {
+		fcport->flags |= FCF_CONF_COMP_SUPPORTED;
+		fcport->conf_compl_supported = 1;
+	}
+
+gpd_error_out:
+	memset(&ea, 0, sizeof(ea));
+	ea.event = FCME_GPDB_DONE;
+	ea.rc = rval;
+	ea.fcport = fcport;
+	ea.sp = sp;
+
+	qla2x00_fcport_event_handler(vha, &ea);
+
+	dma_pool_free(ha->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
+		sp->u.iocb_cmd.u.mbx.in_dma);
+
+	sp->free(vha, sp);
+}
+
+static int qla24xx_post_gpdb_work(struct scsi_qla_host *vha, fc_port_t *fcport,
+    u8 opt)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_GPDB);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.fcport.fcport = fcport;
+	e->u.fcport.opt = opt;
+	return qla2x00_post_work(vha, e);
+}
+
+int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
+{
+	srb_t *sp;
+	struct srb_iocb *mbx;
+	int rval = QLA_FUNCTION_FAILED;
+	u16 *mb;
+	dma_addr_t pd_dma;
+	struct port_database_24xx *pd;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!vha->flags.online)
+		goto done;
+
+	fcport->flags |= FCF_ASYNC_SENT;
+	fcport->disc_state = DSC_GPDB;
+
+	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	if (!sp)
+		goto done;
+
+	pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
+	if (pd == NULL) {
+		ql_log(ql_log_warn, vha, 0xffff,
+			"Failed to allocate port database structure.\n");
+		goto done_free_sp;
+	}
+	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
+
+	sp->type = SRB_MB_IOCB;
+	sp->name = "gpdb";
+	sp->gen1 = fcport->rscn_gen;
+	sp->gen2 = fcport->login_gen;
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
+	mb = sp->u.iocb_cmd.u.mbx.out_mb;
+	mb[0] = MBC_GET_PORT_DATABASE;
+	mb[1] = fcport->loop_id;
+	mb[2] = MSW(pd_dma);
+	mb[3] = LSW(pd_dma);
+	mb[6] = MSW(MSD(pd_dma));
+	mb[7] = LSW(MSD(pd_dma));
+	mb[9] = vha->vp_idx;
+	mb[10] = opt;
+
+	mbx = &sp->u.iocb_cmd;
+	mbx->timeout = qla2x00_async_iocb_timeout;
+	mbx->u.mbx.in = (void *)pd;
+	mbx->u.mbx.in_dma = pd_dma;
+
+	sp->done = qla24xx_async_gpdb_sp_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"Async-%s %8phC hndl %x opt %x\n",
+		sp->name, fcport->port_name, sp->handle, opt);
+
+	return rval;
+
+done_free_sp:
+	if (pd)
+		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
+
+	sp->free(vha, sp);
+done:
+	fcport->flags &= ~FCF_ASYNC_SENT;
+	qla24xx_post_gpdb_work(vha, fcport, opt);
+	return rval;
+}
+
+static
+void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
+{
+	int rval = ea->rc;
+	fc_port_t *fcport = ea->fcport;
+	unsigned long flags;
+
+	fcport->flags &= ~FCF_ASYNC_SENT;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "%s %8phC DS %d LS %d rval %d\n", __func__, fcport->port_name,
+	    fcport->disc_state, fcport->fw_login_state, rval);
+
+	if (ea->sp->gen2 != fcport->login_gen) {
+		/* target side must have changed it. */
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		    "%s %8phC generation changed rscn %d|%d login %d|%d \n",
+		    __func__, fcport->port_name, fcport->last_rscn_gen,
+		    fcport->rscn_gen, fcport->last_login_gen,
+		    fcport->login_gen);
+		return;
+	} else if (ea->sp->gen1 != fcport->rscn_gen) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %d %8phC post gidpn\n",
+		    __func__, __LINE__, fcport->port_name);
+		qla24xx_post_gidpn_work(vha, fcport);
+		return;
+	}
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %d %8phC post del sess\n",
+		    __func__, __LINE__, fcport->port_name);
+		qlt_schedule_sess_for_deletion_lock(fcport);
+		return;
+	}
+
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	ea->fcport->login_gen++;
+	ea->fcport->deleted = 0;
+	ea->fcport->logout_on_delete = 1;
+
+	if (!ea->fcport->login_succ && !IS_SW_RESV_ADDR(ea->fcport->d_id)) {
+		vha->fcport_count++;
+		ea->fcport->login_succ = 1;
+
+		if (!IS_IIDMA_CAPABLE(vha->hw) ||
+		    !vha->hw->flags.gpsc_supported) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s %d %8phC post upd_fcport fcp_cnt %d\n",
+			    __func__, __LINE__, fcport->port_name,
+			    vha->fcport_count);
+
+			qla24xx_post_upd_fcport_work(vha, fcport);
+		} else {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s %d %8phC post gpsc fcp_cnt %d\n",
+			    __func__, __LINE__, fcport->port_name,
+			    vha->fcport_count);
+
+			qla24xx_post_gpsc_work(vha, fcport);
+		}
+	}
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+} /* gpdb event */
+
+int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
+{
+	if (fcport->login_retry == 0)
+		return 0;
+
+	if (fcport->scan_state != QLA_FCPORT_FOUND)
+		return 0;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d|%d retry %d lid %d\n",
+	    __func__, fcport->port_name, fcport->disc_state,
+	    fcport->fw_login_state, fcport->login_pause, fcport->flags,
+	    fcport->conflict, fcport->last_rscn_gen, fcport->rscn_gen,
+	    fcport->last_login_gen, fcport->login_gen, fcport->login_retry,
+	    fcport->loop_id);
+
+	fcport->login_retry--;
+
+	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
+	    (fcport->fw_login_state == DSC_LS_PLOGI_COMP) ||
+	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
+		return 0;
+
+	/* for pure Target Mode. Login will not be initiated */
+	if (vha->host->active_mode == MODE_TARGET)
+		return 0;
+
+	if (fcport->flags & FCF_ASYNC_SENT) {
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+		return 0;
+	}
+
+	switch (fcport->disc_state) {
+	case DSC_DELETED:
+		if (fcport->loop_id == FC_NO_LOOP_ID) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gnl\n",
+			   __func__, __LINE__, fcport->port_name);
+			qla24xx_async_gnl(vha, fcport);
+		} else {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post login\n",
+			   __func__, __LINE__, fcport->port_name);
+			fcport->disc_state = DSC_LOGIN_PEND;
+			qla2x00_post_async_login_work(vha, fcport, NULL);
+		}
+		break;
+
+	case DSC_GNL:
+		if (fcport->login_pause) {
+			fcport->last_rscn_gen = fcport->rscn_gen;
+			fcport->last_login_gen = fcport->login_gen;
+			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			break;
+		}
+
+		if (fcport->flags & FCF_FCP2_DEVICE) {
+			u8 opt = PDO_FORCE_ADISC;
+
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gpdb\n",
+			   __func__, __LINE__, fcport->port_name);
+
+			fcport->disc_state = DSC_GPDB;
+			qla24xx_post_gpdb_work(vha, fcport, opt);
+		} else {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post login \n",
+			   __func__, __LINE__, fcport->port_name);
+			fcport->disc_state = DSC_LOGIN_PEND;
+			qla2x00_post_async_login_work(vha, fcport, NULL);
+		}
+
+		break;
+
+	case DSC_LOGIN_FAILED:
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gidpn \n",
+			   __func__, __LINE__, fcport->port_name);
+
+		qla24xx_post_gidpn_work(vha, fcport);
+		break;
+
+	case DSC_LOGIN_COMPLETE:
+		/* recheck login state */
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gpdb \n",
+			   __func__, __LINE__, fcport->port_name);
+
+		qla24xx_post_gpdb_work(vha, fcport, PDO_FORCE_ADISC);
+		break;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static
+void qla24xx_handle_rscn_event(fc_port_t *fcport, struct event_arg *ea)
+{
+	fcport->rscn_gen++;
+
+	ql_dbg(ql_dbg_disc, fcport->vha, 0xffff,
+		"%s %8phC DS %d LS %d\n",
+		__func__, fcport->port_name, fcport->disc_state,
+		fcport->fw_login_state);
+
+	if (fcport->flags & FCF_ASYNC_SENT)
+		return;
+
+	switch (fcport->disc_state) {
+	case DSC_DELETED:
+	case DSC_LOGIN_COMPLETE:
+		qla24xx_post_gidpn_work(fcport->vha, fcport);
+		break;
+
+	default:
+		break;
+	}
+}
+
+int qla24xx_post_newsess_work(struct scsi_qla_host *vha, port_id_t *id,
+	u8 *port_name, void *pla)
+{
+	struct qla_work_evt *e;
+	e = qla2x00_alloc_work(vha, QLA_EVT_NEW_SESS);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.new_sess.id = *id;
+	e->u.new_sess.pla = pla;
+	memcpy(e->u.new_sess.port_name, port_name, WWN_SIZE);
+
+	return qla2x00_post_work(vha, e);
+}
+
+static
+int qla24xx_handle_delete_done_event(scsi_qla_host_t *vha,
+	struct event_arg *ea)
+{
+	fc_port_t *fcport = ea->fcport;
+
+	if (test_bit(UNLOADING, &vha->dpc_flags))
+		return 0;
+
+	switch (vha->host->active_mode) {
+	case MODE_INITIATOR:
+	case MODE_DUAL:
+		if (fcport->scan_state == QLA_FCPORT_FOUND)
+			qla24xx_fcport_handle_login(vha, fcport);
+		break;
+
+	case MODE_TARGET:
+	default:
+		/* no-op */
+		break;
+	}
+
+	return 0;
+}
+
+static
+void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
+	struct event_arg *ea)
+{
+	fc_port_t *fcport = ea->fcport;
+
+	if (fcport->scan_state != QLA_FCPORT_FOUND) {
+		fcport->login_retry++;
+		return;
+	}
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"%s %8phC DS %d LS %d P %d del %d cnfl %p rscn %d|%d login %d|%d fl %x\n",
+		__func__, fcport->port_name, fcport->disc_state,
+		fcport->fw_login_state, fcport->login_pause,
+		fcport->deleted, fcport->conflict,
+		fcport->last_rscn_gen, fcport->rscn_gen,
+		fcport->last_login_gen, fcport->login_gen,
+		fcport->flags);
+
+	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
+	    (fcport->fw_login_state == DSC_LS_PLOGI_COMP) ||
+	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
+		return;
+
+	if (fcport->flags & FCF_ASYNC_SENT) {
+		fcport->login_retry++;
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+		return;
+	}
+
+	if (fcport->disc_state == DSC_DELETE_PEND) {
+		fcport->login_retry++;
+		return;
+	}
+
+	if (fcport->last_rscn_gen != fcport->rscn_gen) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %d %8phC post gidpn\n",
+		    __func__, __LINE__, fcport->port_name);
+
+		qla24xx_async_gidpn(vha, fcport);
+		return;
+	}
+
+	qla24xx_fcport_handle_login(vha, fcport);
+}
+
+void qla2x00_fcport_event_handler(scsi_qla_host_t *vha,
+	struct event_arg *ea)
+{
+	fc_port_t *fcport;
+	int rc;
+
+	switch (ea->event) {
+	case FCME_RELOGIN:
+		if (test_bit(UNLOADING, &vha->dpc_flags))
+			return;
+
+		qla24xx_handle_relogin_event(vha, ea);
+		break;
+	case FCME_RSCN:
+		if (test_bit(UNLOADING, &vha->dpc_flags))
+			return;
+
+		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
+		if (!fcport) {
+			/* cable moved */
+			rc = qla24xx_post_gpnid_work(vha, &ea->id);
+			if (rc) {
+				ql_log(ql_log_warn, vha, 0xffff,
+					"RSCN GPNID work failed %02x%02x%02x\n",
+					ea->id.b.domain, ea->id.b.area,
+					ea->id.b.al_pa);
+			}
+		} else {
+			ea->fcport = fcport;
+			qla24xx_handle_rscn_event(fcport, ea);
+		}
+		break;
+	case FCME_GIDPN_DONE:
+		qla24xx_handle_gidpn_event(vha, ea);
+		break;
+	case FCME_GNL_DONE:
+		qla24xx_handle_gnl_done_event(vha, ea);
+		break;
+	case FCME_GPSC_DONE:
+		qla24xx_post_upd_fcport_work(vha, ea->fcport);
+		break;
+	case FCME_PLOGI_DONE:	/* Initiator side sent LLIOCB */
+		qla24xx_handle_plogi_done_event(vha, ea);
+		break;
+	case FCME_GPDB_DONE:
+		qla24xx_handle_gpdb_event(vha, ea);
+		break;
+	case FCME_GPNID_DONE:
+		qla24xx_handle_gpnid_event(vha, ea);
+		break;
+	case FCME_DELETE_DONE:
+		qla24xx_handle_delete_done_event(vha, ea);
+		break;
+	default:
+		BUG_ON(1);
+		break;
+	}
+}
+
 static void
 qla2x00_tmf_iocb_timeout(void *data)
 {
@@ -441,59 +1295,65 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 	return qla24xx_async_abort_cmd(sp);
 }
 
-void
-qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
-    uint16_t *data)
+static void
+qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 {
-	int rval;
+	port_id_t cid;	/* conflict Nport id */
 
-	switch (data[0]) {
+	switch (ea->data[0]) {
 	case MBS_COMMAND_COMPLETE:
 		/*
 		 * Driver must validate login state - If PRLI not complete,
 		 * force a relogin attempt via implicit LOGO, PLOGI, and PRLI
 		 * requests.
 		 */
-		rval = qla2x00_get_port_database(vha, fcport, 0);
-		if (rval == QLA_NOT_LOGGED_IN) {
-			fcport->flags &= ~FCF_ASYNC_SENT;
-			fcport->flags |= FCF_LOGIN_NEEDED;
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-			break;
-		}
-
-		if (rval != QLA_SUCCESS) {
-			qla2x00_post_async_logout_work(vha, fcport, NULL);
-			qla2x00_post_async_login_work(vha, fcport, NULL);
-			break;
-		}
-		if (fcport->flags & FCF_FCP2_DEVICE) {
-			qla2x00_post_async_adisc_work(vha, fcport, data);
-			break;
-		}
-		qla2x00_update_fcport(vha, fcport);
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gpdb\n",
+			   __func__, __LINE__, ea->fcport->port_name);
+		ea->fcport->chip_reset = vha->hw->chip_reset;
+		ea->fcport->logout_on_delete = 1;
+		qla24xx_post_gpdb_work(vha, ea->fcport, 0);
 		break;
 	case MBS_COMMAND_ERROR:
-		fcport->flags &= ~FCF_ASYNC_SENT;
-		if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
+		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %d %8phC cmd error %x\n",
+		    __func__, __LINE__, ea->fcport->port_name, ea->data[1]);
+
+		ea->fcport->flags &= ~FCF_ASYNC_SENT;
+		ea->fcport->disc_state = DSC_LOGIN_FAILED;
+		if (ea->data[1] & QLA_LOGIO_LOGIN_RETRIED)
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		else
-			qla2x00_mark_device_lost(vha, fcport, 1, 0);
-		break;
-	case MBS_PORT_ID_USED:
-		fcport->loop_id = data[1];
-		qla2x00_post_async_logout_work(vha, fcport, NULL);
-		qla2x00_post_async_login_work(vha, fcport, NULL);
+			qla2x00_mark_device_lost(vha, ea->fcport, 1, 0);
 		break;
 	case MBS_LOOP_ID_USED:
-		fcport->loop_id++;
-		rval = qla2x00_find_new_loop_id(vha, fcport);
-		if (rval != QLA_SUCCESS) {
-			fcport->flags &= ~FCF_ASYNC_SENT;
-			qla2x00_mark_device_lost(vha, fcport, 1, 0);
-			break;
+		/* data[1] = IO PARAM 1 = nport ID  */
+		cid.b.domain = (ea->iop[1] >> 16) & 0xff;
+		cid.b.area   = (ea->iop[1] >>  8) & 0xff;
+		cid.b.al_pa  = ea->iop[1] & 0xff;
+		cid.b.rsvd_1 = 0;
+
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			"%s %d %8phC LoopID 0x%x in use post gnl\n",
+			__func__, __LINE__, ea->fcport->port_name,
+			ea->fcport->loop_id);
+
+		if (IS_SW_RESV_ADDR(cid)) {
+			set_bit(ea->fcport->loop_id, vha->hw->loop_id_map);
+			ea->fcport->loop_id = FC_NO_LOOP_ID;
+		} else {
+			qla2x00_clear_loop_id(ea->fcport);
 		}
-		qla2x00_post_async_login_work(vha, fcport, NULL);
+		qla24xx_post_gnl_work(vha, ea->fcport);
+		break;
+	case MBS_PORT_ID_USED:
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			"%s %d %8phC NPortId %02x%02x%02x inuse post gidpn\n",
+			__func__, __LINE__, ea->fcport->port_name,
+			ea->fcport->d_id.b.domain, ea->fcport->d_id.b.area,
+			ea->fcport->d_id.b.al_pa);
+
+		qla2x00_clear_loop_id(ea->fcport);
+		qla24xx_post_gidpn_work(vha, ea->fcport);
 		break;
 	}
 	return;
@@ -503,10 +1363,9 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 qla2x00_async_logout_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
 {
-	/* Don't re-login in target mode */
-	if (!fcport->tgt_session)
-		qla2x00_mark_device_lost(vha, fcport, 1, 0);
+	qla2x00_mark_device_lost(vha, fcport, 1, 0);
 	qlt_logo_completion_handler(fcport, data[0]);
+	fcport->login_gen++;
 	return;
 }
 
@@ -709,7 +1568,8 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 		}
 	}
 
-	if (qla_ini_mode_enabled(vha))
+	if (qla_ini_mode_enabled(vha) ||
+		qla_dual_mode_enabled(vha))
 		rval = qla2x00_init_rings(vha);
 
 	ha->flags.chip_reset_done = 1;
@@ -2968,8 +3828,14 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	rport = fcport->drport ? fcport->drport: fcport->rport;
 	fcport->drport = NULL;
 	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
-	if (rport)
+	if (rport) {
+		ql_dbg(ql_dbg_disc, fcport->vha, 0xffff,
+			"%s %8phN. rport %p roles %x \n",
+			__func__, fcport->port_name, rport,
+			rport->roles);
+
 		fc_remote_port_delete(rport);
+	}
 }
 
 /**
@@ -2995,9 +3861,42 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	qla2x00_set_fcport_state(fcport, FCS_UNCONFIGURED);
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
 
+	fcport->ct_desc.ct_sns = dma_alloc_coherent(&vha->hw->pdev->dev,
+		sizeof(struct ct_sns_pkt), &fcport->ct_desc.ct_sns_dma,
+			GFP_ATOMIC);
+	fcport->disc_state = DSC_DELETED;
+	fcport->fw_login_state = DSC_LS_PORT_UNAVAIL;
+	fcport->deleted = QLA_SESS_DELETED;
+	fcport->login_retry = vha->hw->login_retry_count;
+	fcport->login_retry = 5;
+	fcport->logout_on_delete = 1;
+
+	if (!fcport->ct_desc.ct_sns) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "Failed to allocate ct_sns request.\n");
+		kfree(fcport);
+		fcport = NULL;
+	}
+	INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
+	INIT_LIST_HEAD(&fcport->gnl_entry);
+	INIT_LIST_HEAD(&fcport->list);
+
 	return fcport;
 }
 
+void
+qla2x00_free_fcport(fc_port_t *fcport)
+{
+	if (fcport->ct_desc.ct_sns) {
+		dma_free_coherent(&fcport->vha->hw->pdev->dev,
+			sizeof(struct ct_sns_pkt), fcport->ct_desc.ct_sns,
+			fcport->ct_desc.ct_sns_dma);
+
+		fcport->ct_desc.ct_sns = NULL;
+	}
+	kfree(fcport);
+}
+
 /*
  * qla2x00_configure_loop
  *      Updates Fibre Channel Device Database with what is actually on loop.
@@ -3334,6 +4233,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	}
 }
 
+/* qla2x00_reg_remote_port is reserved for Initiator Mode only.*/
 static void
 qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
@@ -3364,6 +4264,12 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_INITIATOR;
 	if (fcport->port_type == FCT_TARGET)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"%s %8phN. rport %p is %s mode \n",
+		__func__, fcport->port_name, rport,
+		(fcport->port_type == FCT_TARGET) ? "tgt" : "ini");
+
 	fc_remote_port_rolechg(rport, rport_ids.roles);
 }
 
@@ -3387,20 +4293,45 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 {
 	fcport->vha = vha;
 
+	if (IS_SW_RESV_ADDR(fcport->d_id))
+		return;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %8phC \n",
+	    __func__, fcport->port_name);
+
 	if (IS_QLAFX00(vha->hw)) {
 		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		goto reg_port;
 	}
 	fcport->login_retry = 0;
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+	fcport->disc_state = DSC_LOGIN_COMPLETE;
+	fcport->deleted = 0;
+	fcport->logout_on_delete = 1;
 
 	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 	qla2x00_iidma_fcport(vha, fcport);
 	qla24xx_update_fcport_fcp_prio(vha, fcport);
 
 reg_port:
-	if (qla_ini_mode_enabled(vha))
+	switch (vha->host->active_mode) {
+	case MODE_INITIATOR:
 		qla2x00_reg_remote_port(vha, fcport);
+		break;
+	case MODE_TARGET:
+		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
+			!vha->vha_tgt.qla_tgt->tgt_stopped)
+			qlt_fc_port_added(vha, fcport);
+		break;
+	case MODE_DUAL:
+		qla2x00_reg_remote_port(vha, fcport);
+		if (!vha->vha_tgt.qla_tgt->tgt_stop &&
+			!vha->vha_tgt.qla_tgt->tgt_stopped)
+			qlt_fc_port_added(vha, fcport);
+		break;
+	default:
+		break;
+	}
 }
 
 /*
@@ -3418,13 +4349,11 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 qla2x00_configure_fabric(scsi_qla_host_t *vha)
 {
 	int	rval;
-	fc_port_t	*fcport, *fcptemp;
-	uint16_t	next_loopid;
+	fc_port_t	*fcport;
 	uint16_t	mb[MAILBOX_REGISTER_COUNT];
 	uint16_t	loop_id;
 	LIST_HEAD(new_fcports);
 	struct qla_hw_data *ha = vha->hw;
-	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	int		discovery_gen;
 
 	/* If FL port exists, then SNS is present */
@@ -3443,6 +4372,8 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	vha->device_flags |= SWITCH_FOUND;
 
 	do {
+		qla2x00_mgmt_svr_login(vha);
+
 		/* FDMI support. */
 		if (ql2xfdmienable &&
 		    test_and_clear_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags))
@@ -3489,9 +4420,6 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			}
 		}
 
-#define QLA_FCPORT_SCAN		1
-#define QLA_FCPORT_FOUND	2
-
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			fcport->scan_state = QLA_FCPORT_SCAN;
 		}
@@ -3504,174 +4432,14 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 		 * will be newer than discovery_gen. */
 		qlt_do_generation_tick(vha, &discovery_gen);
 
-		rval = qla2x00_find_all_fabric_devs(vha, &new_fcports);
+		rval = qla2x00_find_all_fabric_devs(vha);
 		if (rval != QLA_SUCCESS)
 			break;
-
-		/*
-		 * Logout all previous fabric devices marked lost, except
-		 * FCP2 devices.
-		 */
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
-				break;
-
-			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0)
-				continue;
-
-			if (fcport->scan_state == QLA_FCPORT_SCAN) {
-				if (qla_ini_mode_enabled(base_vha) &&
-				    atomic_read(&fcport->state) == FCS_ONLINE) {
-					qla2x00_mark_device_lost(vha, fcport,
-					    ql2xplogiabsentdevice, 0);
-					if (fcport->loop_id != FC_NO_LOOP_ID &&
-					    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
-					    fcport->port_type != FCT_INITIATOR &&
-					    fcport->port_type != FCT_BROADCAST) {
-						ha->isp_ops->fabric_logout(vha,
-						    fcport->loop_id,
-						    fcport->d_id.b.domain,
-						    fcport->d_id.b.area,
-						    fcport->d_id.b.al_pa);
-						qla2x00_clear_loop_id(fcport);
-					}
-				} else if (!qla_ini_mode_enabled(base_vha)) {
-					/*
-					 * In target mode, explicitly kill
-					 * sessions and log out of devices
-					 * that are gone, so that we don't
-					 * end up with an initiator using the
-					 * wrong ACL (if the fabric recycles
-					 * an FC address and we have a stale
-					 * session around) and so that we don't
-					 * report initiators that are no longer
-					 * on the fabric.
-					 */
-					ql_dbg(ql_dbg_tgt_mgt, vha, 0xf077,
-					    "port gone, logging out/killing session: "
-					    "%8phC state 0x%x flags 0x%x fc4_type 0x%x "
-					    "scan_state %d\n",
-					    fcport->port_name,
-					    atomic_read(&fcport->state),
-					    fcport->flags, fcport->fc4_type,
-					    fcport->scan_state);
-					qlt_fc_port_deleted(vha, fcport,
-					    discovery_gen);
-				}
-			}
-		}
-
-		/* Starting free loop ID. */
-		next_loopid = ha->min_external_loopid;
-
-		/*
-		 * Scan through our port list and login entries that need to be
-		 * logged in.
-		 */
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (atomic_read(&vha->loop_down_timer) ||
-			    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
-				break;
-
-			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0 ||
-			    (fcport->flags & FCF_LOGIN_NEEDED) == 0)
-				continue;
-
-			/*
-			 * If we're not an initiator, skip looking for devices
-			 * and logging in.  There's no reason for us to do it,
-			 * and it seems to actively cause problems in target
-			 * mode if we race with the initiator logging into us
-			 * (we might get the "port ID used" status back from
-			 * our login command and log out the initiator, which
-			 * seems to cause havoc).
-			 */
-			if (!qla_ini_mode_enabled(base_vha)) {
-				if (fcport->scan_state == QLA_FCPORT_FOUND) {
-					ql_dbg(ql_dbg_tgt_mgt, vha, 0xf078,
-					    "port %8phC state 0x%x flags 0x%x fc4_type 0x%x "
-					    "scan_state %d (initiator mode disabled; skipping "
-					    "login)\n", fcport->port_name,
-					    atomic_read(&fcport->state),
-					    fcport->flags, fcport->fc4_type,
-					    fcport->scan_state);
-				}
-				continue;
-			}
-
-			if (fcport->loop_id == FC_NO_LOOP_ID) {
-				fcport->loop_id = next_loopid;
-				rval = qla2x00_find_new_loop_id(
-				    base_vha, fcport);
-				if (rval != QLA_SUCCESS) {
-					/* Ran out of IDs to use */
-					break;
-				}
-			}
-			/* Login and update database */
-			qla2x00_fabric_dev_login(vha, fcport, &next_loopid);
-		}
-
-		/* Exit if out of loop IDs. */
-		if (rval != QLA_SUCCESS) {
-			break;
-		}
-
-		/*
-		 * Login and add the new devices to our port list.
-		 */
-		list_for_each_entry_safe(fcport, fcptemp, &new_fcports, list) {
-			if (atomic_read(&vha->loop_down_timer) ||
-			    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
-				break;
-
-			/*
-			 * If we're not an initiator, skip looking for devices
-			 * and logging in.  There's no reason for us to do it,
-			 * and it seems to actively cause problems in target
-			 * mode if we race with the initiator logging into us
-			 * (we might get the "port ID used" status back from
-			 * our login command and log out the initiator, which
-			 * seems to cause havoc).
-			 */
-			if (qla_ini_mode_enabled(base_vha)) {
-				/* Find a new loop ID to use. */
-				fcport->loop_id = next_loopid;
-				rval = qla2x00_find_new_loop_id(base_vha,
-				    fcport);
-				if (rval != QLA_SUCCESS) {
-					/* Ran out of IDs to use */
-					break;
-				}
-
-				/* Login and update database */
-				qla2x00_fabric_dev_login(vha, fcport,
-				    &next_loopid);
-			} else {
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf079,
-					"new port %8phC state 0x%x flags 0x%x fc4_type "
-					"0x%x scan_state %d (initiator mode disabled; "
-					"skipping login)\n",
-					fcport->port_name,
-					atomic_read(&fcport->state),
-					fcport->flags, fcport->fc4_type,
-					fcport->scan_state);
-			}
-
-			list_move_tail(&fcport->list, &vha->vp_fcports);
-		}
 	} while (0);
 
-	/* Free all new device structures not processed. */
-	list_for_each_entry_safe(fcport, fcptemp, &new_fcports, list) {
-		list_del(&fcport->list);
-		kfree(fcport);
-	}
-
-	if (rval) {
+	if (rval)
 		ql_dbg(ql_dbg_disc, vha, 0x2068,
 		    "Configure fabric error exit rval=%d.\n", rval);
-	}
 
 	return (rval);
 }
@@ -3690,12 +4458,11 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
  *	Kernel context.
  */
 static int
-qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
-	struct list_head *new_fcports)
+qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 {
 	int		rval;
 	uint16_t	loop_id;
-	fc_port_t	*fcport, *new_fcport, *fcptemp;
+	fc_port_t	*fcport, *new_fcport;
 	int		found;
 
 	sw_info_t	*swl;
@@ -3704,6 +4471,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	port_id_t	wrap = {}, nxt_d_id;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	unsigned long flags;
 
 	rval = QLA_SUCCESS;
 
@@ -3724,9 +4492,8 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			swl = NULL;
 		} else if (qla2x00_gnn_id(vha, swl) != QLA_SUCCESS) {
 			swl = NULL;
-		} else if (ql2xiidmaenable &&
-		    qla2x00_gfpn_id(vha, swl) == QLA_SUCCESS) {
-			qla2x00_gpsc(vha, swl);
+		} else if (qla2x00_gfpn_id(vha, swl) != QLA_SUCCESS) {
+			swl = NULL;
 		}
 
 		/* If other queries succeeded probe for FC-4 type */
@@ -3788,11 +4555,6 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 				ql_log(ql_log_warn, vha, 0x2064,
 				    "SNS scan failed -- assuming "
 				    "zero-entry result.\n");
-				list_for_each_entry_safe(fcport, fcptemp,
-				    new_fcports, list) {
-					list_del(&fcport->list);
-					kfree(fcport);
-				}
 				rval = QLA_SUCCESS;
 				break;
 			}
@@ -3835,6 +4597,8 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 		    new_fcport->fc4_type != FC4_TYPE_UNKNOWN))
 			continue;
 
+		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+
 		/* Locate matching device in database. */
 		found = 0;
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
@@ -3857,7 +4621,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			 */
 			if (fcport->d_id.b24 == new_fcport->d_id.b24 &&
 			    (atomic_read(&fcport->state) == FCS_ONLINE ||
-			     !qla_ini_mode_enabled(base_vha))) {
+			     (vha->host->active_mode == MODE_TARGET))) {
 				break;
 			}
 
@@ -3877,7 +4641,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			 * Log it out if still logged in and mark it for
 			 * relogin later.
 			 */
-			if (!qla_ini_mode_enabled(base_vha)) {
+			if (qla_tgt_mode_enabled(base_vha)) {
 				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf080,
 					 "port changed FC ID, %8phC"
 					 " old %x:%x:%x (loop_id 0x%04x)-> new %x:%x:%x\n",
@@ -3895,25 +4659,19 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 
 			fcport->d_id.b24 = new_fcport->d_id.b24;
 			fcport->flags |= FCF_LOGIN_NEEDED;
-			if (fcport->loop_id != FC_NO_LOOP_ID &&
-			    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
-			    (fcport->flags & FCF_ASYNC_SENT) == 0 &&
-			    fcport->port_type != FCT_INITIATOR &&
-			    fcport->port_type != FCT_BROADCAST) {
-				ha->isp_ops->fabric_logout(vha, fcport->loop_id,
-				    fcport->d_id.b.domain, fcport->d_id.b.area,
-				    fcport->d_id.b.al_pa);
-				qla2x00_clear_loop_id(fcport);
-			}
-
 			break;
 		}
 
-		if (found)
+		if (found) {
+			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 			continue;
+		}
 		/* If device was not in our fcports list, then add it. */
 		new_fcport->scan_state = QLA_FCPORT_FOUND;
-		list_add_tail(&new_fcport->list, new_fcports);
+		list_add_tail(&new_fcport->list, &vha->vp_fcports);
+
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
 
 		/* Allocate a new replacement fcport. */
 		nxt_d_id.b24 = new_fcport->d_id.b24;
@@ -3927,8 +4685,44 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 		new_fcport->d_id.b24 = nxt_d_id.b24;
 	}
 
-	kfree(new_fcport);
+	qla2x00_free_fcport(new_fcport);
+
+	/*
+	 * Logout all previous fabric dev marked lost, except FCP2 devices.
+	 */
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
+			break;
+
+		if ((fcport->flags & FCF_FABRIC_DEVICE) == 0 ||
+		    (fcport->flags & FCF_LOGIN_NEEDED) == 0)
+			continue;
+
+		if (fcport->scan_state == QLA_FCPORT_SCAN) {
+			if ((qla_dual_mode_enabled(vha) ||
+			    qla_ini_mode_enabled(vha)) &&
+			    atomic_read(&fcport->state) == FCS_ONLINE) {
+				qla2x00_mark_device_lost(vha, fcport,
+					ql2xplogiabsentdevice, 0);
+				if (fcport->loop_id != FC_NO_LOOP_ID &&
+				    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
+				    fcport->port_type != FCT_INITIATOR &&
+				    fcport->port_type != FCT_BROADCAST) {
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+					    "%s %d %8phC post del sess\n",
+					    __func__, __LINE__,
+					    fcport->port_name);
+
+					qlt_schedule_sess_for_deletion_lock
+						(fcport);
+					continue;
+				}
+			}
+		}
 
+		if (fcport->scan_state == QLA_FCPORT_FOUND)
+			qla24xx_fcport_handle_login(vha, fcport);
+	}
 	return (rval);
 }
 
@@ -3980,64 +4774,6 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	return (rval);
 }
 
-/*
- * qla2x00_fabric_dev_login
- *	Login fabric target device and update FC port database.
- *
- * Input:
- *	ha:		adapter state pointer.
- *	fcport:		port structure list pointer.
- *	next_loopid:	contains value of a new loop ID that can be used
- *			by the next login attempt.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-static int
-qla2x00_fabric_dev_login(scsi_qla_host_t *vha, fc_port_t *fcport,
-    uint16_t *next_loopid)
-{
-	int	rval;
-	uint8_t opts;
-	struct qla_hw_data *ha = vha->hw;
-
-	rval = QLA_SUCCESS;
-
-	if (IS_ALOGIO_CAPABLE(ha)) {
-		if (fcport->flags & FCF_ASYNC_SENT)
-			return rval;
-		fcport->flags |= FCF_ASYNC_SENT;
-		rval = qla2x00_post_async_login_work(vha, fcport, NULL);
-		if (!rval)
-			return rval;
-	}
-
-	fcport->flags &= ~FCF_ASYNC_SENT;
-	rval = qla2x00_fabric_login(vha, fcport, next_loopid);
-	if (rval == QLA_SUCCESS) {
-		/* Send an ADISC to FCP2 devices.*/
-		opts = 0;
-		if (fcport->flags & FCF_FCP2_DEVICE)
-			opts |= BIT_1;
-		rval = qla2x00_get_port_database(vha, fcport, opts);
-		if (rval != QLA_SUCCESS) {
-			ha->isp_ops->fabric_logout(vha, fcport->loop_id,
-			    fcport->d_id.b.domain, fcport->d_id.b.area,
-			    fcport->d_id.b.al_pa);
-			qla2x00_mark_device_lost(vha, fcport, 1, 0);
-		} else {
-			qla2x00_update_fcport(vha, fcport);
-		}
-	} else {
-		/* Retry Login. */
-		qla2x00_mark_device_lost(vha, fcport, 1, 0);
-	}
-
-	return (rval);
-}
 
 /*
  * qla2x00_fabric_login
@@ -4329,13 +5065,6 @@ int qla2x00_perform_loop_resync(scsi_qla_host_t *ha)
 				spin_unlock_irqrestore(&ha->vport_slock, flags);
 				qla2x00_rport_del(fcport);
 
-				/*
-				 * Release the target mode FC NEXUS in
-				 * qla_target.c, if target mod is enabled.
-				 */
-				qlt_fc_port_deleted(vha, fcport,
-				    base_vha->total_fcport_update_gen);
-
 				spin_lock_irqsave(&ha->vport_slock, flags);
 			}
 		}
@@ -4718,6 +5447,8 @@ int qla2x00_perform_loop_resync(scsi_qla_host_t *ha)
 	if (!(IS_P3P_TYPE(ha)))
 		ha->isp_ops->reset_chip(vha);
 
+	ha->chip_reset++;
+
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
@@ -4772,8 +5503,6 @@ int qla2x00_perform_loop_resync(scsi_qla_host_t *ha)
 		/* Requeue all commands in outstanding command list. */
 		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
 	}
-
-	ha->chip_reset++;
 	/* memory barrier */
 	wmb();
 }
@@ -4969,7 +5698,6 @@ int qla2x00_perform_loop_resync(scsi_qla_host_t *ha)
 		if (!status) {
 			/* Issue a marker after FW becomes ready. */
 			qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
-
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		}
 
@@ -5197,7 +5925,7 @@ static void qla24xx_nvram_wwn_from_ofw(scsi_qla_host_t *vha,
 		rval = 1;
 	}
 
-	if (!qla_ini_mode_enabled(vha)) {
+	if (qla_tgt_mode_enabled(vha)) {
 		/* Don't enable full login after initial LIP */
 		nv->firmware_options_1 &= cpu_to_le32(~BIT_13);
 		/* Don't enable LIP full login for initiator */
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 44e4045..647828b 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -166,8 +166,8 @@
 	/* Don't print state transitions during initial allocation of fcport */
 	if (old_state && old_state != state) {
 		ql_dbg(ql_dbg_disc, fcport->vha, 0x207d,
-		    "FCPort state transitioned from %s to %s - "
-		    "portid=%02x%02x%02x.\n",
+		    "FCPort %8phC state transitioned from %s to %s - "
+			"portid=%02x%02x%02x.\n", fcport->port_name,
 		    port_state_str[old_state], port_state_str[state],
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa);
@@ -263,6 +263,7 @@
 	memset(sp, 0, sizeof(*sp));
 	sp->fcport = fcport;
 	sp->iocbs = 1;
+	sp->vha = vha;
 done:
 	if (!sp)
 		QLA_VHA_MARK_NOT_BUSY(vha);
@@ -285,7 +286,7 @@
 	sp->u.iocb_cmd.timer.function = qla2x00_sp_timeout;
 	add_timer(&sp->u.iocb_cmd.timer);
 	sp->free = qla2x00_sp_free;
-	if ((IS_QLAFX00(sp->fcport->vha->hw)) &&
+	if ((IS_QLAFX00(((scsi_qla_host_t *)sp->vha)->hw)) &&
 	    (sp->type == SRB_FXIOCB_DCMD))
 		init_completion(&sp->u.iocb_cmd.u.fxiocb.fxiocb_comp);
 	if (sp->type == SRB_ELS_DCMD)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 834e221..33d3d90 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2247,7 +2247,7 @@ struct fw_dif_context {
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	logio->control_flags =
 	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
-	if (!sp->fcport->tgt_session ||
+	if (!sp->fcport->se_sess ||
 	    !sp->fcport->keep_nport_handle)
 		logio->control_flags |= cpu_to_le16(LCF_FREE_NPORT);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
@@ -3079,19 +3079,69 @@ struct fw_dif_context {
 	wmb();
 }
 
+static void
+qla2x00_mb_iocb(srb_t *sp, struct mbx_24xx_entry *mbx)
+{
+	int i, sz;
+
+	mbx->entry_type = MBX_IOCB_TYPE;
+	mbx->handle = sp->handle;
+	sz = min(ARRAY_SIZE(mbx->mb), ARRAY_SIZE(sp->u.iocb_cmd.u.mbx.out_mb));
+
+	for (i = 0; i < sz; i++)
+		mbx->mb[i] = cpu_to_le16(sp->u.iocb_cmd.u.mbx.out_mb[i]);
+}
+
+static void
+qla2x00_ctpthru_cmd_iocb(srb_t *sp, struct ct_entry_24xx *ct_pkt)
+{
+	sp->u.iocb_cmd.u.ctarg.iocb = ct_pkt;
+	qla24xx_prep_ms_iocb(sp->vha, &sp->u.iocb_cmd.u.ctarg);
+	ct_pkt->handle = sp->handle;
+}
+
+static void qla2x00_send_notify_ack_iocb(srb_t *sp,
+	struct nack_to_isp *nack)
+{
+	struct imm_ntfy_from_isp *ntfy = sp->u.iocb_cmd.u.nack.ntfy;
+
+	nack->entry_type = NOTIFY_ACK_TYPE;
+	nack->entry_count = 1;
+	nack->ox_id = ntfy->ox_id;
+
+	nack->u.isp24.handle = sp->handle;
+	nack->u.isp24.nport_handle = ntfy->u.isp24.nport_handle;
+	if (le16_to_cpu(ntfy->u.isp24.status) == IMM_NTFY_ELS) {
+		nack->u.isp24.flags = ntfy->u.isp24.flags &
+			cpu_to_le32(NOTIFY24XX_FLAGS_PUREX_IOCB);
+	}
+	nack->u.isp24.srr_rx_id = ntfy->u.isp24.srr_rx_id;
+	nack->u.isp24.status = ntfy->u.isp24.status;
+	nack->u.isp24.status_subcode = ntfy->u.isp24.status_subcode;
+	nack->u.isp24.fw_handle = ntfy->u.isp24.fw_handle;
+	nack->u.isp24.exchange_address = ntfy->u.isp24.exchange_address;
+	nack->u.isp24.srr_rel_offs = ntfy->u.isp24.srr_rel_offs;
+	nack->u.isp24.srr_ui = ntfy->u.isp24.srr_ui;
+	nack->u.isp24.srr_flags = 0;
+	nack->u.isp24.srr_reject_code = 0;
+	nack->u.isp24.srr_reject_code_expl = 0;
+	nack->u.isp24.vp_index = ntfy->u.isp24.vp_index;
+}
+
 int
 qla2x00_start_sp(srb_t *sp)
 {
 	int rval;
-	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	scsi_qla_host_t *vha = (scsi_qla_host_t *)sp->vha;
+	struct qla_hw_data *ha = vha->hw;
 	void *pkt;
 	unsigned long flags;
 
 	rval = QLA_FUNCTION_FAILED;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	pkt = qla2x00_alloc_iocbs(sp->fcport->vha, sp);
+	pkt = qla2x00_alloc_iocbs(vha, sp);
 	if (!pkt) {
-		ql_log(ql_log_warn, sp->fcport->vha, 0x700c,
+		ql_log(ql_log_warn, vha, 0x700c,
 		    "qla2x00_alloc_iocbs failed.\n");
 		goto done;
 	}
@@ -3139,12 +3189,23 @@ struct fw_dif_context {
 	case SRB_ELS_DCMD:
 		qla24xx_els_logo_iocb(sp, pkt);
 		break;
+	case SRB_CT_PTHRU_CMD:
+		qla2x00_ctpthru_cmd_iocb(sp, pkt);
+		break;
+	case SRB_MB_IOCB:
+		qla2x00_mb_iocb(sp, pkt);
+		break;
+	case SRB_NACK_PLOGI:
+	case SRB_NACK_PRLI:
+	case SRB_NACK_LOGO:
+		qla2x00_send_notify_ack_iocb(sp, pkt);
+		break;
 	default:
 		break;
 	}
 
 	wmb();
-	qla2x00_start_iocbs(sp->fcport->vha, ha->req_q_map[0]);
+	qla2x00_start_iocbs(vha, ha->req_q_map[0]);
 done:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 87b57bf..99088ff 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -565,14 +565,50 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	return ret;
 }
 
-static inline fc_port_t *
+fc_port_t *
 qla2x00_find_fcport_by_loopid(scsi_qla_host_t *vha, uint16_t loop_id)
 {
-	fc_port_t *fcport;
+	fc_port_t *f, *tf;
+
+	f = tf = NULL;
+	list_for_each_entry_safe(f, tf, &vha->vp_fcports, list)
+		if (f->loop_id == loop_id)
+			return f;
+	return NULL;
+}
+
+fc_port_t *
+qla2x00_find_fcport_by_wwpn(scsi_qla_host_t *vha, u8 *wwpn, u8 incl_deleted)
+{
+	fc_port_t *f, *tf;
+
+	f = tf = NULL;
+	list_for_each_entry_safe(f, tf, &vha->vp_fcports, list) {
+		if (memcmp(f->port_name, wwpn, WWN_SIZE) == 0) {
+			if (incl_deleted)
+				return f;
+			else if (f->deleted == 0)
+				return f;
+		}
+	}
+	return NULL;
+}
 
-	list_for_each_entry(fcport, &vha->vp_fcports, list)
-		if (fcport->loop_id == loop_id)
-			return fcport;
+fc_port_t *
+qla2x00_find_fcport_by_nportid(scsi_qla_host_t *vha, port_id_t *id,
+	u8 incl_deleted)
+{
+	fc_port_t *f, *tf;
+
+	f = tf = NULL;
+	list_for_each_entry_safe(f, tf, &vha->vp_fcports, list) {
+		if (f->d_id.b24 == id->b24) {
+			if (incl_deleted)
+				return f;
+			else if (f->deleted == 0)
+				return f;
+		}
+	}
 	return NULL;
 }
 
@@ -938,7 +974,11 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 			ql_dbg(ql_dbg_async, vha, 0x508a,
 			    "Marking port lost loopid=%04x portid=%06x.\n",
 			    fcport->loop_id, fcport->d_id.b24);
-			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
+			if (qla_ini_mode_enabled(vha)) {
+				qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
+				fcport->logout_on_delete = 0;
+				qlt_schedule_sess_for_deletion_lock(fcport);
+			}
 			break;
 
 global_port_update:
@@ -1028,27 +1068,17 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		if (qla2x00_is_a_vp_did(vha, rscn_entry))
 			break;
 
-		/*
-		 * Search for the rport related to this RSCN entry and mark it
-		 * as lost.
-		 */
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (atomic_read(&fcport->state) != FCS_ONLINE)
-				continue;
-			if (fcport->d_id.b24 == rscn_entry) {
-				qla2x00_mark_device_lost(vha, fcport, 0, 0);
-				break;
-			}
-		}
-
 		atomic_set(&vha->loop_down_timer, 0);
 		vha->flags.management_server_logged_in = 0;
+		{
+			struct event_arg ea;
 
-		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-		set_bit(RSCN_UPDATE, &vha->dpc_flags);
-		qla2x00_post_aen_work(vha, FCH_EVT_RSCN, rscn_entry);
+			memset(&ea, 0, sizeof(ea));
+			ea.event = FCME_RSCN;
+			ea.id.b24 = rscn_entry;
+			qla2x00_fcport_event_handler(vha, &ea);
+		}
 		break;
-
 	/* case MBA_RIO_RESPONSE: */
 	case MBA_ZIO_RESPONSE:
 		ql_dbg(ql_dbg_async, vha, 0x5015,
@@ -1239,7 +1269,8 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	index = LSW(pkt->handle);
 	if (index >= req->num_outstanding_cmds) {
 		ql_log(ql_log_warn, vha, 0x5031,
-		    "Invalid command index (%x).\n", index);
+			   "Invalid command index (%x) type %8ph.\n",
+			   index, iocb);
 		if (IS_P3P_TYPE(ha))
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
 		else
@@ -1351,6 +1382,49 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 }
 
 static void
+qla24xx_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
+    struct mbx_24xx_entry *pkt)
+{
+	const char func[] = "MBX-IOCB2";
+	srb_t *sp;
+	struct srb_iocb *si;
+	u16 sz, i;
+	int res;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	if (!sp)
+		return;
+
+	si = &sp->u.iocb_cmd;
+	sz = min(ARRAY_SIZE(pkt->mb), ARRAY_SIZE(sp->u.iocb_cmd.u.mbx.in_mb));
+
+	for (i = 0; i < sz; i++)
+		si->u.mbx.in_mb[i] = le16_to_cpu(pkt->mb[i]);
+
+	res = (si->u.mbx.in_mb[0] & MBS_MASK);
+
+	sp->done(vha, sp, res);
+}
+
+static void
+qla24xxx_nack_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
+    struct nack_to_isp *pkt)
+{
+	const char func[] = "nack";
+	srb_t *sp;
+	int res = 0;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	if (!sp)
+		return;
+
+	if (pkt->u.isp2x.status != cpu_to_le16(NOTIFY_ACK_SUCCESS))
+		res = QLA_FUNCTION_FAILED;
+
+	sp->done(vha, sp, res);
+}
+
+static void
 qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
     sts_entry_t *pkt, int iocb_type)
 {
@@ -1360,50 +1434,64 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	struct bsg_job *bsg_job;
 	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
-	int res;
+	int res = 0;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (!sp)
 		return;
 
-	bsg_job = sp->u.bsg_job;
-	bsg_reply = bsg_job->reply;
-
-	type = "ct pass-through";
-
-	comp_status = le16_to_cpu(pkt->comp_status);
-
-	/* return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
-	 * fc payload  to the caller
-	 */
-	bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
-	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-
-	if (comp_status != CS_COMPLETE) {
-		if (comp_status == CS_DATA_UNDERRUN) {
-			res = DID_OK << 16;
-			bsg_reply->reply_payload_rcv_len =
-			    le16_to_cpu(((sts_entry_t *)pkt)->rsp_info_len);
-
-			ql_log(ql_log_warn, vha, 0x5048,
-			    "CT pass-through-%s error "
-			    "comp_status-status=0x%x total_byte = 0x%x.\n",
-			    type, comp_status,
-			    bsg_reply->reply_payload_rcv_len);
-		} else {
-			ql_log(ql_log_warn, vha, 0x5049,
-			    "CT pass-through-%s error "
-			    "comp_status-status=0x%x.\n", type, comp_status);
-			res = DID_ERROR << 16;
-			bsg_reply->reply_payload_rcv_len = 0;
-		}
-		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5035,
-		    (uint8_t *)pkt, sizeof(*pkt));
-	} else {
-		res = DID_OK << 16;
-		bsg_reply->reply_payload_rcv_len =
-		    bsg_job->reply_payload.payload_len;
-		bsg_job->reply_len = 0;
+	switch (sp->type) {
+	case SRB_CT_CMD:
+	    bsg_job = sp->u.bsg_job;
+	    bsg_reply = bsg_job->reply;
+
+	    type = "ct pass-through";
+
+	    comp_status = le16_to_cpu(pkt->comp_status);
+
+	     /*
+	      * return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
+	      * fc payload  to the caller
+	      */
+
+	     bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	     bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+
+	     if (comp_status != CS_COMPLETE) {
+		     if (comp_status == CS_DATA_UNDERRUN) {
+			    res = DID_OK << 16;
+			    bsg_reply->reply_payload_rcv_len =
+				le16_to_cpu(((sts_entry_t *)pkt)->rsp_info_len);
+
+			    ql_log(ql_log_warn, vha, 0x5048,
+				"CT pass-through-%s error comp_status=0x%x total_byte=0x%x.\n",
+				type, comp_status,
+				bsg_reply->reply_payload_rcv_len);
+		     } else {
+			     ql_log(ql_log_warn, vha, 0x5049,
+				 "CT pass-through-%s error comp_status=0x%x.\n",
+				 type, comp_status);
+			     res = DID_ERROR << 16;
+			     bsg_reply->reply_payload_rcv_len = 0;
+		     }
+		     ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5035,
+			 (uint8_t *)pkt, sizeof(*pkt));
+	     } else {
+		     res = DID_OK << 16;
+		     bsg_reply->reply_payload_rcv_len =
+			 bsg_job->reply_payload.payload_len;
+		     bsg_job->reply_len = 0;
+	     }
+	     break;
+	case SRB_CT_PTHRU_CMD:
+	    /*
+	     * borrowing sts_entry_24xx.comp_status.
+	     * same location as ct_entry_24xx.comp_status
+	     */
+	     res = qla2x00_chk_ms_status(vha, (ms_iocb_entry_t *)pkt,
+		 (struct ct_sns_rsp *)sp->u.iocb_cmd.u.ctarg.rsp,
+		 sp->name);
+	     break;
 	}
 
 	sp->done(vha, sp, res);
@@ -1444,6 +1532,15 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		    "Completing %s: (%p) type=%d.\n", type, sp, sp->type);
 		sp->done(vha, sp, 0);
 		return;
+	case SRB_CT_PTHRU_CMD:
+		/* borrowing sts_entry_24xx.comp_status.
+		   same location as ct_entry_24xx.comp_status
+		 */
+		res = qla2x00_chk_ms_status(vha, (ms_iocb_entry_t *)pkt,
+			(struct ct_sns_rsp *)sp->u.iocb_cmd.u.ctarg.rsp,
+			sp->name);
+		sp->done(vha, sp, res);
+		return;
 	default:
 		ql_dbg(ql_dbg_user, vha, 0x503e,
 		    "Unrecognized SRB: (%p) type=%d.\n", sp, sp->type);
@@ -1570,6 +1667,8 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 
 	iop[0] = le32_to_cpu(logio->io_parameter[0]);
 	iop[1] = le32_to_cpu(logio->io_parameter[1]);
+	lio->u.logio.iop[0] = iop[0];
+	lio->u.logio.iop[1] = iop[1];
 	switch (iop[0]) {
 	case LSC_SCODE_PORTID_USED:
 		data[0] = MBS_PORT_ID_USED;
@@ -2078,6 +2177,7 @@ struct scsi_dif_tuple {
 	int res = 0;
 	uint16_t state_flags = 0;
 	uint16_t retry_delay = 0;
+	uint8_t no_logout = 0;
 
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
@@ -2338,6 +2438,7 @@ struct scsi_dif_tuple {
 		break;
 
 	case CS_PORT_LOGGED_OUT:
+		no_logout = 1;
 	case CS_PORT_CONFIG_CHG:
 	case CS_PORT_BUSY:
 	case CS_INCOMPLETE:
@@ -2360,14 +2461,21 @@ struct scsi_dif_tuple {
 				break;
 		}
 
-		ql_dbg(ql_dbg_io, fcport->vha, 0x3021,
-		    "Port to be marked lost on fcport=%02x%02x%02x, current "
-		    "port state= %s.\n", fcport->d_id.b.domain,
-		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
-		    port_state_str[atomic_read(&fcport->state)]);
+		if (atomic_read(&fcport->state) == FCS_ONLINE) {
+			ql_dbg(ql_dbg_disc, fcport->vha, 0x3021,
+				"Port to be marked lost on fcport=%02x%02x%02x, current "
+				"port state= %s comp_status %x.\n", fcport->d_id.b.domain,
+				fcport->d_id.b.area, fcport->d_id.b.al_pa,
+				port_state_str[atomic_read(&fcport->state)],
+				comp_status);
+
+			if (no_logout)
+				fcport->logout_on_delete = 0;
 
-		if (atomic_read(&fcport->state) == FCS_ONLINE)
 			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
+			qlt_schedule_sess_for_deletion_lock(fcport);
+		}
+
 		break;
 
 	case CS_ABORTED:
@@ -2639,10 +2747,16 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			}
 		case ABTS_RESP_24XX:
 		case CTIO_TYPE7:
-		case NOTIFY_ACK_TYPE:
 		case CTIO_CRC2:
 			qlt_response_pkt_all_vps(vha, (response_t *)pkt);
 			break;
+		case NOTIFY_ACK_TYPE:
+			if (pkt->handle == QLA_TGT_SKIP_HANDLE)
+				qlt_response_pkt_all_vps(vha, (response_t *)pkt);
+			else
+				qla24xxx_nack_iocb_entry(vha, rsp->req,
+					(struct nack_to_isp *)pkt);
+			break;
 		case MARKER_TYPE:
 			/* Do nothing in this case, this check is to prevent it
 			 * from falling into default case
@@ -2652,6 +2766,10 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla24xx_abort_iocb_entry(vha, rsp->req,
 			    (struct abort_entry_24xx *)pkt);
 			break;
+		case MBX_IOCB_TYPE:
+			qla24xx_mbx_iocb_entry(vha, rsp->req,
+			    (struct mbx_24xx_entry *)pkt);
+			break;
 		default:
 			/* Type Not Supported. */
 			ql_dbg(ql_dbg_async, vha, 0x5042,
@@ -2668,8 +2786,9 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	if (IS_P3P_TYPE(ha)) {
 		struct device_reg_82xx __iomem *reg = &ha->iobase->isp82;
 		WRT_REG_DWORD(&reg->rsp_q_out[0], rsp->ring_index);
-	} else
+	} else {
 		WRT_REG_DWORD(rsp->rsp_q_out, rsp->ring_index);
+	}
 }
 
 static void
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b4386fc..e8be16a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1639,94 +1639,6 @@ static int is_rom_cmd(uint16_t cmd)
 	return rval;
 }
 
-/*
- * qla2x00_get_node_name_list
- *      Issue get node name list mailbox command, kmalloc()
- *      and return the resulting list. Caller must kfree() it!
- *
- * Input:
- *      ha = adapter state pointer.
- *      out_data = resulting list
- *      out_len = length of the resulting list
- *
- * Returns:
- *      qla2x00 local function return status code.
- *
- * Context:
- *      Kernel context.
- */
-int
-qla2x00_get_node_name_list(scsi_qla_host_t *vha, void **out_data, int *out_len)
-{
-	struct qla_hw_data *ha = vha->hw;
-	struct qla_port_24xx_data *list = NULL;
-	void *pmap;
-	mbx_cmd_t mc;
-	dma_addr_t pmap_dma;
-	ulong dma_size;
-	int rval, left;
-
-	left = 1;
-	while (left > 0) {
-		dma_size = left * sizeof(*list);
-		pmap = dma_alloc_coherent(&ha->pdev->dev, dma_size,
-					 &pmap_dma, GFP_KERNEL);
-		if (!pmap) {
-			ql_log(ql_log_warn, vha, 0x113f,
-			    "%s(%ld): DMA Alloc failed of %ld\n",
-			    __func__, vha->host_no, dma_size);
-			rval = QLA_MEMORY_ALLOC_FAILED;
-			goto out;
-		}
-
-		mc.mb[0] = MBC_PORT_NODE_NAME_LIST;
-		mc.mb[1] = BIT_1 | BIT_3;
-		mc.mb[2] = MSW(pmap_dma);
-		mc.mb[3] = LSW(pmap_dma);
-		mc.mb[6] = MSW(MSD(pmap_dma));
-		mc.mb[7] = LSW(MSD(pmap_dma));
-		mc.mb[8] = dma_size;
-		mc.out_mb = MBX_0|MBX_1|MBX_2|MBX_3|MBX_6|MBX_7|MBX_8;
-		mc.in_mb = MBX_0|MBX_1;
-		mc.tov = 30;
-		mc.flags = MBX_DMA_IN;
-
-		rval = qla2x00_mailbox_command(vha, &mc);
-		if (rval != QLA_SUCCESS) {
-			if ((mc.mb[0] == MBS_COMMAND_ERROR) &&
-			    (mc.mb[1] == 0xA)) {
-				left += le16_to_cpu(mc.mb[2]) /
-				    sizeof(struct qla_port_24xx_data);
-				goto restart;
-			}
-			goto out_free;
-		}
-
-		left = 0;
-
-		list = kmemdup(pmap, dma_size, GFP_KERNEL);
-		if (!list) {
-			ql_log(ql_log_warn, vha, 0x1140,
-			    "%s(%ld): failed to allocate node names list "
-			    "structure.\n", __func__, vha->host_no);
-			rval = QLA_MEMORY_ALLOC_FAILED;
-			goto out_free;
-		}
-
-restart:
-		dma_free_coherent(&ha->pdev->dev, dma_size, pmap, pmap_dma);
-	}
-
-	*out_data = list;
-	*out_len = dma_size;
-
-out:
-	return rval;
-
-out_free:
-	dma_free_coherent(&ha->pdev->dev, dma_size, pmap, pmap_dma);
-	return rval;
-}
 
 /*
  * qla2x00_get_port_database
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 65eca89..1656cff 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1043,6 +1043,34 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	return (return_status);
 }
 
+static inline int test_fcport_count(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
+	int res;
+
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	ql_dbg(ql_dbg_init, vha, 0xffff,
+		"tgt %p, fcport_count=%d\n",
+		vha, vha->fcport_count);
+	res = (vha->fcport_count == 0);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+	return res;
+}
+
+/*
+ * qla2x00_wait_for_sess_deletion can only be called from remove_one.
+ * it has dependency on UNLOADING flag to stop device discovery
+ */
+static void
+qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
+{
+	qla2x00_mark_all_devices_lost(vha, 0);
+
+	wait_event(vha->fcport_waitQ, test_fcport_count(vha));
+}
+
 /*
  * qla2x00_wait_for_hba_ready
  * Wait till the HBA is ready before doing driver unload
@@ -2904,6 +2932,18 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	if (ret)
 		goto probe_init_failed;
 
+	base_vha->gnl.size = (ha->max_loop_id + 1) *
+		sizeof(struct get_name_list_extended);
+	base_vha->gnl.l = dma_alloc_coherent(&ha->pdev->dev,
+		base_vha->gnl.size, &base_vha->gnl.ldma, GFP_KERNEL);
+	INIT_LIST_HEAD(&base_vha->gnl.fcports);
+
+	if (base_vha->gnl.l == NULL) {
+		ql_log(ql_log_fatal, base_vha, 0xffff,
+			"Alloc failed for name list.\n");
+		goto probe_init_failed;
+	}
+
 	/* Alloc arrays of request and response ring ptrs */
 	if (!qla2x00_alloc_queues(ha, req, rsp)) {
 		ql_log(ql_log_fatal, base_vha, 0x003d,
@@ -3123,7 +3163,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	ql_dbg(ql_dbg_init, base_vha, 0x00f2,
 	    "Init done and hba is online.\n");
 
-	if (qla_ini_mode_enabled(base_vha))
+	if (qla_ini_mode_enabled(base_vha) ||
+		qla_dual_mode_enabled(base_vha))
 		scsi_scan_host(host);
 	else
 		ql_dbg(ql_dbg_init, base_vha, 0x0122,
@@ -3372,21 +3413,26 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	 * resources.
 	 */
 	if (!atomic_read(&pdev->enable_cnt)) {
+		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
+		    base_vha->gnl.l, base_vha->gnl.ldma);
+
 		scsi_host_put(base_vha->host);
 		kfree(ha);
 		pci_set_drvdata(pdev, NULL);
 		return;
 	}
-
 	qla2x00_wait_for_hba_ready(base_vha);
 
-	/* if UNLOAD flag is already set, then continue unload,
+	/*
+	 * if UNLOAD flag is already set, then continue unload,
 	 * where it was set first.
 	 */
 	if (test_bit(UNLOADING, &base_vha->dpc_flags))
 		return;
 
 	set_bit(UNLOADING, &base_vha->dpc_flags);
+	dma_free_coherent(&ha->pdev->dev,
+		base_vha->gnl.size, base_vha->gnl.l, base_vha->gnl.ldma);
 
 	if (IS_QLAFX00(ha))
 		qlafx00_driver_shutdown(base_vha, 20);
@@ -3535,10 +3581,14 @@ void qla2x00_free_fcports(struct scsi_qla_host *vha)
 		qla2xxx_wake_dpc(base_vha);
 	} else {
 		int now;
-		if (rport)
+		if (rport) {
+			ql_dbg(ql_dbg_disc, fcport->vha, 0xffff,
+				"%s %8phN. rport %p roles %x \n",
+				__func__, fcport->port_name, rport,
+				rport->roles);
 			fc_remote_port_delete(rport);
+		}
 		qlt_do_generation_tick(vha, &now);
-		qlt_fc_port_deleted(vha, fcport, now);
 	}
 }
 
@@ -3581,7 +3631,7 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 		fcport->login_retry = vha->hw->login_retry_count;
 
 		ql_dbg(ql_dbg_disc, vha, 0x2067,
-		    "Port login retry %8phN, id = 0x%04x retry cnt=%d.\n",
+		    "Port login retry %8phN, lid 0x%04x retry cnt=%d.\n",
 		    fcport->port_name, fcport->loop_id, fcport->login_retry);
 	}
 }
@@ -3604,7 +3654,13 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 {
 	fc_port_t *fcport;
 
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		   "Mark all dev lost\n");
+
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		fcport->scan_state = 0;
+		qlt_schedule_sess_for_deletion_lock(fcport);
+
 		if (vha->vp_idx != 0 && vha->vp_idx != fcport->vha->vp_idx)
 			continue;
 
@@ -4219,6 +4275,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 
 	spin_lock_init(&vha->work_lock);
 	spin_lock_init(&vha->cmd_list_lock);
+	init_waitqueue_head(&vha->fcport_waitQ);
 
 	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha->host_no);
 	ql_dbg(ql_dbg_init, vha, 0x0041,
@@ -4232,7 +4289,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	return vha;
 }
 
-static struct qla_work_evt *
+struct qla_work_evt *
 qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
 {
 	struct qla_work_evt *e;
@@ -4254,7 +4311,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	return e;
 }
 
-static int
+int
 qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
 {
 	unsigned long flags;
@@ -4315,7 +4372,6 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 }
 
 qla2x00_post_async_work(login, QLA_EVT_ASYNC_LOGIN);
-qla2x00_post_async_work(login_done, QLA_EVT_ASYNC_LOGIN_DONE);
 qla2x00_post_async_work(logout, QLA_EVT_ASYNC_LOGOUT);
 qla2x00_post_async_work(logout_done, QLA_EVT_ASYNC_LOGOUT_DONE);
 qla2x00_post_async_work(adisc, QLA_EVT_ASYNC_ADISC);
@@ -4368,6 +4424,67 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	return qla2x00_post_work(vha, e);
 }
 
+int qla24xx_post_upd_fcport_work(struct scsi_qla_host *vha, fc_port_t *fcport)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_UPD_FCPORT);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.fcport.fcport = fcport;
+	return qla2x00_post_work(vha, e);
+}
+
+static
+void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
+{
+	unsigned long flags;
+	fc_port_t *fcport =  NULL;
+	struct qlt_plogi_ack_t *pla =
+	    (struct qlt_plogi_ack_t *)e->u.new_sess.pla;
+
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	fcport = qla2x00_find_fcport_by_wwpn(vha, e->u.new_sess.port_name, 1);
+	if (fcport) {
+		fcport->d_id = e->u.new_sess.id;
+		if (pla) {
+			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
+			qlt_plogi_ack_link(vha, pla, fcport, QLT_PLOGI_LINK_SAME_WWN);
+			/* we took an extra ref_count to prevent PLOGI ACK when
+			 * fcport/sess has not been created.
+			 */
+			pla->ref_count--;
+		}
+	} else {
+		fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
+		if (fcport) {
+			fcport->d_id = e->u.new_sess.id;
+			fcport->scan_state = QLA_FCPORT_FOUND;
+			fcport->flags |= FCF_FABRIC_DEVICE;
+			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
+
+			memcpy(fcport->port_name, e->u.new_sess.port_name,
+			    WWN_SIZE);
+			list_add_tail(&fcport->list, &vha->vp_fcports);
+
+			if (pla) {
+				qlt_plogi_ack_link(vha, pla, fcport,
+				    QLT_PLOGI_LINK_SAME_WWN);
+				pla->ref_count--;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
+	if (fcport) {
+		if (pla)
+			qlt_plogi_ack_unref(vha, pla);
+		else
+			qla24xx_async_gnl(vha, fcport);
+	}
+}
+
 void
 qla2x00_do_work(struct scsi_qla_host *vha)
 {
@@ -4394,10 +4511,6 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 			qla2x00_async_login(vha, e->u.logio.fcport,
 			    e->u.logio.data);
 			break;
-		case QLA_EVT_ASYNC_LOGIN_DONE:
-			qla2x00_async_login_done(vha, e->u.logio.fcport,
-			    e->u.logio.data);
-			break;
 		case QLA_EVT_ASYNC_LOGOUT:
 			qla2x00_async_logout(vha, e->u.logio.fcport);
 			break;
@@ -4419,6 +4532,34 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 		case QLA_EVT_AENFX:
 			qlafx00_process_aen(vha, e);
 			break;
+		case QLA_EVT_GIDPN:
+			qla24xx_async_gidpn(vha, e->u.fcport.fcport);
+			break;
+		case QLA_EVT_GPNID:
+			qla24xx_async_gpnid(vha, &e->u.gpnid.id);
+			break;
+		case QLA_EVT_GPNID_DONE:
+			qla24xx_async_gpnid_done(vha, e->u.iosb.sp);
+			break;
+		case QLA_EVT_NEW_SESS:
+			qla24xx_create_new_sess(vha, e);
+			break;
+		case QLA_EVT_GPDB:
+			qla24xx_async_gpdb(vha, e->u.fcport.fcport,
+			    e->u.fcport.opt);
+			break;
+		case QLA_EVT_GPSC:
+			qla24xx_async_gpsc(vha, e->u.fcport.fcport);
+			break;
+		case QLA_EVT_UPD_FCPORT:
+			qla2x00_update_fcport(vha, e->u.fcport.fcport);
+			break;
+		case QLA_EVT_GNL:
+			qla24xx_async_gnl(vha, e->u.fcport.fcport);
+			break;
+		case QLA_EVT_NACK:
+			qla24xx_do_nack_work(vha, e);
+			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
@@ -4435,9 +4576,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 {
 	fc_port_t       *fcport;
 	int status;
-	uint16_t        next_loopid = 0;
-	struct qla_hw_data *ha = vha->hw;
-	uint16_t data[2];
+	struct event_arg ea;
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 	/*
@@ -4448,77 +4587,38 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 		    fcport->login_retry && !(fcport->flags & FCF_ASYNC_SENT)) {
 			fcport->login_retry--;
 			if (fcport->flags & FCF_FABRIC_DEVICE) {
-				if (fcport->flags & FCF_FCP2_DEVICE)
-					ha->isp_ops->fabric_logout(vha,
-							fcport->loop_id,
-							fcport->d_id.b.domain,
-							fcport->d_id.b.area,
-							fcport->d_id.b.al_pa);
-
-				if (fcport->loop_id == FC_NO_LOOP_ID) {
-					fcport->loop_id = next_loopid =
-					    ha->min_external_loopid;
-					status = qla2x00_find_new_loop_id(
-					    vha, fcport);
-					if (status != QLA_SUCCESS) {
-						/* Ran out of IDs to use */
-						break;
-					}
-				}
-
-				if (IS_ALOGIO_CAPABLE(ha)) {
-					fcport->flags |= FCF_ASYNC_SENT;
-					data[0] = 0;
-					data[1] = QLA_LOGIO_LOGIN_RETRIED;
-					status = qla2x00_post_async_login_work(
-					    vha, fcport, data);
-					if (status == QLA_SUCCESS)
-						continue;
-					/* Attempt a retry. */
-					status = 1;
-				} else {
-					status = qla2x00_fabric_login(vha,
-					    fcport, &next_loopid);
-					if (status ==  QLA_SUCCESS) {
-						int status2;
-						uint8_t opts;
-
-						opts = 0;
-						if (fcport->flags &
-						    FCF_FCP2_DEVICE)
-							opts |= BIT_1;
-						status2 =
-						    qla2x00_get_port_database(
-							vha, fcport, opts);
-						if (status2 != QLA_SUCCESS)
-							status = 1;
-					}
-				}
-			} else
+				ql_dbg(ql_dbg_disc, fcport->vha, 0xffff,
+				    "%s %8phC DS %d LS %d\n", __func__,
+				    fcport->port_name, fcport->disc_state,
+				    fcport->fw_login_state);
+				memset(&ea, 0, sizeof(ea));
+				ea.event = FCME_RELOGIN;
+				ea.fcport = fcport;
+				qla2x00_fcport_event_handler(vha, &ea);
+			} else {
 				status = qla2x00_local_device_login(vha,
 								fcport);
+				if (status == QLA_SUCCESS) {
+					fcport->old_loop_id = fcport->loop_id;
+					ql_dbg(ql_dbg_disc, vha, 0x2003,
+					    "Port login OK: logged in ID 0x%x.\n",
+					    fcport->loop_id);
+					qla2x00_update_fcport(vha, fcport);
+				} else if (status == 1) {
+					set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+					/* retry the login again */
+					ql_dbg(ql_dbg_disc, vha, 0x2007,
+					    "Retrying %d login again loop_id 0x%x.\n",
+					    fcport->login_retry,
+					    fcport->loop_id);
+				} else {
+					fcport->login_retry = 0;
+				}
 
-			if (status == QLA_SUCCESS) {
-				fcport->old_loop_id = fcport->loop_id;
-
-				ql_dbg(ql_dbg_disc, vha, 0x2003,
-				    "Port login OK: logged in ID 0x%x.\n",
-				    fcport->loop_id);
-
-				qla2x00_update_fcport(vha, fcport);
-
-			} else if (status == 1) {
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-				/* retry the login again */
-				ql_dbg(ql_dbg_disc, vha, 0x2007,
-				    "Retrying %d login again loop_id 0x%x.\n",
-				    fcport->login_retry, fcport->loop_id);
-			} else {
-				fcport->login_retry = 0;
+				if (fcport->login_retry == 0 &&
+				    status != QLA_SUCCESS)
+					qla2x00_clear_loop_id(fcport);
 			}
-
-			if (fcport->login_retry == 0 && status != QLA_SUCCESS)
-				qla2x00_clear_loop_id(fcport);
 		}
 		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 			break;
@@ -5182,7 +5282,8 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 	struct pci_dev *pdev = ha->pdev;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	/* if UNLOAD flag is already set, then continue unload,
+	/*
+	 * if UNLOAD flag is already set, then continue unload,
 	 * where it was set first.
 	 */
 	if (test_bit(UNLOADING, &base_vha->dpc_flags))
@@ -5191,6 +5292,8 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 	ql_log(ql_log_warn, base_vha, 0x015b,
 	    "Disabling adapter.\n");
 
+	qla2x00_wait_for_sess_deletion(base_vha);
+
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 
 	qla2x00_delete_all_vps(ha, base_vha);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 99ed753..b5cfab0 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -118,6 +118,9 @@ static void qlt_send_notify_ack(struct scsi_qla_host *vha,
 	uint16_t srr_flags, uint16_t srr_reject_code, uint8_t srr_explan);
 static void qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 	struct imm_ntfy_from_isp *imm, int ha_locked);
+static struct fc_port *qlt_create_sess(struct scsi_qla_host *vha,
+	fc_port_t *fcport, bool local);
+void qlt_unreg_sess(struct fc_port *sess);
 /*
  * Global Variables
  */
@@ -378,6 +381,247 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
 /*
  * All qlt_plogi_ack_t operations are protected by hardware_lock
  */
+static int qla24xx_post_nack_work(struct scsi_qla_host *vha, fc_port_t *fcport,
+	struct imm_ntfy_from_isp *ntfy, int type)
+{
+	struct qla_work_evt *e;
+	e = qla2x00_alloc_work(vha, QLA_EVT_NACK);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.nack.fcport = fcport;
+	e->u.nack.type = type;
+	memcpy(e->u.nack.iocb, ntfy, sizeof(struct imm_ntfy_from_isp));
+	return qla2x00_post_work(vha, e);
+}
+
+static
+void qla2x00_async_nack_sp_done(void *v, void *s, int res)
+{
+	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
+	struct srb *sp = (struct srb *)s;
+	unsigned long flags;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"Async done-%s res %x %8phC  type %d\n",
+		sp->name, res, sp->fcport->port_name, sp->type);
+
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	sp->fcport->flags &= ~FCF_ASYNC_SENT;
+	sp->fcport->chip_reset = vha->hw->chip_reset;
+
+	switch (sp->type) {
+	case SRB_NACK_PLOGI:
+		sp->fcport->login_gen++;
+		sp->fcport->fw_login_state = DSC_LS_PLOGI_COMP;
+		sp->fcport->logout_on_delete = 1;
+		break;
+
+	case SRB_NACK_PRLI:
+		sp->fcport->fw_login_state = DSC_LS_PRLI_COMP;
+		sp->fcport->deleted = 0;
+
+		if (!sp->fcport->login_succ &&
+		    !IS_SW_RESV_ADDR(sp->fcport->d_id)) {
+			sp->fcport->login_succ = 1;
+
+			vha->fcport_count++;
+
+			if (!IS_IIDMA_CAPABLE(vha->hw) ||
+			    !vha->hw->flags.gpsc_supported) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+					"%s %d %8phC post upd_fcport fcp_cnt %d\n",
+					__func__, __LINE__,
+					sp->fcport->port_name,
+					vha->fcport_count);
+
+				qla24xx_post_upd_fcport_work(vha, sp->fcport);
+			} else {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+					"%s %d %8phC post gpsc fcp_cnt %d\n",
+					__func__, __LINE__,
+					sp->fcport->port_name,
+					vha->fcport_count);
+
+				qla24xx_post_gpsc_work(vha, sp->fcport);
+			}
+		}
+		break;
+
+	case SRB_NACK_LOGO:
+		sp->fcport->login_gen++;
+		sp->fcport->fw_login_state = DSC_LS_PORT_UNAVAIL;
+		qlt_logo_completion_handler(sp->fcport, MBS_COMMAND_COMPLETE);
+		break;
+	}
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
+	sp->free(vha, sp);
+}
+
+int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
+	struct imm_ntfy_from_isp *ntfy, int type)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	srb_t *sp;
+	char *c = NULL;
+
+	fcport->flags |= FCF_ASYNC_SENT;
+	switch (type) {
+	case SRB_NACK_PLOGI:
+		fcport->fw_login_state = DSC_LS_PLOGI_PEND;
+		c = "PLOGI";
+		break;
+	case SRB_NACK_PRLI:
+		fcport->fw_login_state = DSC_LS_PRLI_PEND;
+		c = "PRLI";
+		break;
+	case SRB_NACK_LOGO:
+		fcport->fw_login_state = DSC_LS_LOGO_PEND;
+		c = "LOGO";
+		break;
+	}
+
+	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
+	if (!sp)
+		goto done;
+
+	sp->type = type;
+	sp->name = "nack";
+
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
+
+	sp->u.iocb_cmd.u.nack.ntfy = ntfy;
+
+	sp->done = qla2x00_async_nack_sp_done;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"Async-%s %8phC hndl %x %s\n",
+		sp->name, fcport->port_name, sp->handle, c);
+
+	return rval;
+
+done_free_sp:
+	sp->free(vha, sp);
+done:
+	fcport->flags &= ~FCF_ASYNC_SENT;
+	return rval;
+}
+
+void qla24xx_do_nack_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
+{
+	fc_port_t *t;
+	unsigned long flags;
+
+	switch (e->u.nack.type) {
+	case SRB_NACK_PRLI:
+		mutex_lock(&vha->vha_tgt.tgt_mutex);
+		t = qlt_create_sess(vha, e->u.nack.fcport, 0);
+		mutex_unlock(&vha->vha_tgt.tgt_mutex);
+		if (t) {
+			ql_log(ql_log_info, vha, 0xffff,
+			    "%s create sess success %p", __func__, t);
+			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+			/* create sess has an extra kref */
+			vha->hw->tgt.tgt_ops->put_sess(e->u.nack.fcport);
+			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+		}
+		break;
+	}
+	qla24xx_async_notify_ack(vha, e->u.nack.fcport,
+	    (struct imm_ntfy_from_isp*)e->u.nack.iocb, e->u.nack.type);
+}
+
+void qla24xx_delete_sess_fn(struct work_struct *work)
+{
+	fc_port_t *fcport = container_of(work, struct fc_port, del_work);
+	struct qla_hw_data *ha = fcport->vha->hw;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+
+	if (fcport->se_sess) {
+		ha->tgt.tgt_ops->shutdown_sess(fcport);
+		ha->tgt.tgt_ops->put_sess(fcport);
+	} else {
+		qlt_unreg_sess(fcport);
+	}
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+}
+
+/*
+ * Called from qla2x00_reg_remote_port()
+ */
+void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+	struct fc_port *sess = fcport;
+	unsigned long flags;
+
+	if (!vha->hw->tgt.tgt_ops)
+		return;
+
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	if (tgt->tgt_stop) {
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+		return;
+	}
+
+	if (fcport->disc_state == DSC_DELETE_PEND) {
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+		return;
+	}
+
+	if (!sess->se_sess) {
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+		mutex_lock(&vha->vha_tgt.tgt_mutex);
+		sess = qlt_create_sess(vha, fcport, false);
+		mutex_unlock(&vha->vha_tgt.tgt_mutex);
+
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	} else {
+		if (fcport->fw_login_state == DSC_LS_PRLI_COMP) {
+			spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+			return;
+		}
+
+		if (!kref_get_unless_zero(&sess->sess_kref)) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s: kref_get fail sess %8phC \n",
+			    __func__, sess->port_name);
+			spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+			return;
+		}
+
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04c,
+		    "qla_target(%u): %ssession for port %8phC "
+		    "(loop ID %d) reappeared\n", vha->vp_idx,
+		    sess->local ? "local " : "", sess->port_name, sess->loop_id);
+
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf007,
+		    "Reappeared sess %p\n", sess);
+
+		ha->tgt.tgt_ops->update_sess(sess, fcport->d_id,
+		    fcport->loop_id,
+		    (fcport->flags & FCF_CONF_COMP_SUPPORTED));
+	}
+
+	if (sess && sess->local) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04d,
+		    "qla_target(%u): local session for "
+		    "port %8phC (loop ID %d) became global\n", vha->vp_idx,
+		    fcport->port_name, sess->loop_id);
+		sess->local = 0;
+	}
+	ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+}
 
 /*
  * This is a zero-base ref-counting solution, since hardware_lock
@@ -413,30 +657,51 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
 	return pla;
 }
 
-static void qlt_plogi_ack_unref(struct scsi_qla_host *vha,
+void qlt_plogi_ack_unref(struct scsi_qla_host *vha,
     struct qlt_plogi_ack_t *pla)
 {
 	struct imm_ntfy_from_isp *iocb = &pla->iocb;
+	port_id_t port_id;
+	uint16_t loop_id;
+	fc_port_t *fcport = pla->fcport;
+
 	BUG_ON(!pla->ref_count);
 	pla->ref_count--;
 
 	if (pla->ref_count)
 		return;
 
-	ql_dbg(ql_dbg_async, vha, 0x5089,
+	ql_dbg(ql_dbg_disc, vha, 0x5089,
 	    "Sending PLOGI ACK to wwn %8phC s_id %02x:%02x:%02x loop_id %#04x"
 	    " exch %#x ox_id %#x\n", iocb->u.isp24.port_name,
 	    iocb->u.isp24.port_id[2], iocb->u.isp24.port_id[1],
 	    iocb->u.isp24.port_id[0],
 	    le16_to_cpu(iocb->u.isp24.nport_handle),
 	    iocb->u.isp24.exchange_address, iocb->ox_id);
-	qlt_send_notify_ack(vha, iocb, 0, 0, 0, 0, 0, 0);
+
+	port_id.b.domain = iocb->u.isp24.port_id[2];
+	port_id.b.area   = iocb->u.isp24.port_id[1];
+	port_id.b.al_pa  = iocb->u.isp24.port_id[0];
+	port_id.b.rsvd_1 = 0;
+
+	loop_id = le16_to_cpu(iocb->u.isp24.nport_handle);
+
+	fcport->loop_id = loop_id;
+	fcport->d_id = port_id;
+	qla24xx_post_nack_work(vha, fcport, iocb, SRB_NACK_PLOGI);
+
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (fcport->plogi_link[QLT_PLOGI_LINK_SAME_WWN] == pla)
+			fcport->plogi_link[QLT_PLOGI_LINK_SAME_WWN] = NULL;
+		if (fcport->plogi_link[QLT_PLOGI_LINK_CONFLICT] == pla)
+			fcport->plogi_link[QLT_PLOGI_LINK_CONFLICT] = NULL;
+	}
 
 	list_del(&pla->list);
 	kmem_cache_free(qla_tgt_plogi_cachep, pla);
 }
 
-static void
+void
 qlt_plogi_ack_link(struct scsi_qla_host *vha, struct qlt_plogi_ack_t *pla,
     struct fc_port *sess, enum qlt_plogi_link_t link)
 {
@@ -444,15 +709,19 @@ static void qlt_plogi_ack_unref(struct scsi_qla_host *vha,
 	/* Inc ref_count first because link might already be pointing at pla */
 	pla->ref_count++;
 
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf097,
+		"Linking sess %p [%d] wwn %8phC with PLOGI ACK to wwn %8phC"
+		" s_id %02x:%02x:%02x, ref=%d pla %p link %d\n",
+		sess, link, sess->port_name,
+		iocb->u.isp24.port_name, iocb->u.isp24.port_id[2],
+		iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[0],
+		pla->ref_count, pla, link);
+
 	if (sess->plogi_link[link])
 		qlt_plogi_ack_unref(vha, sess->plogi_link[link]);
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf097,
-	    "Linking sess %p [%d] wwn %8phC with PLOGI ACK to wwn %8phC"
-	    " s_id %02x:%02x:%02x, ref=%d\n", sess, link, sess->port_name,
-	    iocb->u.isp24.port_name, iocb->u.isp24.port_id[2],
-	    iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[0],
-	    pla->ref_count);
+	if (link == QLT_PLOGI_LINK_SAME_WWN)
+		pla->fcport = sess;
 
 	sess->plogi_link[link] = pla;
 }
@@ -512,7 +781,7 @@ static void qlt_free_session_done(struct work_struct *work)
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
 	bool logout_started = false;
-	fc_port_t fcport;
+	struct event_arg ea;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf084,
 		"%s: se_sess %p / sess %p from port %8phC loop_id %#04x"
@@ -522,8 +791,8 @@ static void qlt_free_session_done(struct work_struct *work)
 		sess->logout_on_delete, sess->keep_nport_handle,
 		sess->send_els_logo);
 
-	BUG_ON(!tgt);
 
+	if (!IS_SW_RESV_ADDR(sess->d_id)) {
 	if (sess->send_els_logo) {
 		qlt_port_logo_t logo;
 		logo.id = sess->d_id;
@@ -533,14 +802,7 @@ static void qlt_free_session_done(struct work_struct *work)
 
 	if (sess->logout_on_delete) {
 		int rc;
-
-		memset(&fcport, 0, sizeof(fcport));
-		fcport.loop_id = sess->loop_id;
-		fcport.d_id = sess->d_id;
-		memcpy(fcport.port_name, sess->port_name, WWN_SIZE);
-		fcport.vha = vha;
-
-		rc = qla2x00_post_async_logout_work(vha, &fcport, NULL);
+		rc = qla2x00_post_async_logout_work(vha, sess, NULL);
 		if (rc != QLA_SUCCESS)
 			ql_log(ql_log_warn, vha, 0xf085,
 			       "Schedule logo failed sess %p rc %d\n",
@@ -548,6 +810,7 @@ static void qlt_free_session_done(struct work_struct *work)
 		else
 			logout_started = true;
 	}
+	}
 
 	/*
 	 * Release the target session for FC Nexus from fabric module code.
@@ -568,12 +831,38 @@ static void qlt_free_session_done(struct work_struct *work)
 			msleep(100);
 		}
 
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf087,
+		ql_dbg(ql_dbg_disc, vha, 0xf087,
 			"%s: sess %p logout completed\n",
 			__func__, sess);
 	}
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	if (sess->se_sess) {
+		sess->se_sess = NULL;
+		if (tgt && !IS_SW_RESV_ADDR(sess->d_id))
+			tgt->sess_count--;
+	}
+
+	sess->disc_state = DSC_DELETED;
+	sess->fw_login_state = DSC_LS_PORT_UNAVAIL;
+	sess->deleted = QLA_SESS_DELETED;
+	sess->login_retry = vha->hw->login_retry_count;
+
+	if (sess->login_succ && !IS_SW_RESV_ADDR(sess->d_id)) {
+		vha->fcport_count--;
+		sess->login_succ = 0;
+	}
+
+	if (sess->chip_reset != sess->vha->hw->chip_reset)
+		qla2x00_clear_loop_id(sess);
+
+	if (sess->conflict) {
+		sess->conflict->login_pause = 0;
+		sess->conflict = NULL;
+		if (!test_bit(UNLOADING, &vha->dpc_flags))
+			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+	}
+
 	{
 		struct qlt_plogi_ack_t *own =
 		    sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
@@ -591,6 +880,7 @@ static void qlt_free_session_done(struct work_struct *work)
 				 own ? own->ref_count : -1,
 				 iocb->u.isp24.port_name, con->ref_count);
 			qlt_plogi_ack_unref(vha, con);
+			sess->plogi_link[QLT_PLOGI_LINK_CONFLICT] = NULL;
 		} else {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf09a,
 			    "se_sess %p / sess %p port %8phC is gone, %s (ref=%d)\n",
@@ -600,25 +890,30 @@ static void qlt_free_session_done(struct work_struct *work)
 			    own ? own->ref_count : -1);
 		}
 
-		if (own)
+		if (own) {
+			sess->fw_login_state = DSC_LS_PLOGI_PEND;
 			qlt_plogi_ack_unref(vha, own);
+			sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN] = NULL;
+		}
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	sess->se_sess = NULL;
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf001,
-	    "Unregistration of sess %p finished\n", sess);
+	    "Unregistration of sess %p %8phC finished fcp_cnt %d\n",
+		sess, sess->port_name, vha->fcport_count);
 
-	/*
-	 * We need to protect against race, when tgt is freed before or
-	 * inside wake_up()
-	 */
-	tgt->sess_count--;
-	if (tgt->sess_count == 0)
+	if (tgt && (tgt->sess_count == 0))
 		wake_up_all(&tgt->waitQ);
+
+	if (vha->fcport_count == 0)
+		wake_up_all(&vha->fcport_waitQ);
+
+	if (!tgt || !tgt->tgt_stop) {
+		memset(&ea, 0, sizeof(ea));
+		ea.event = FCME_DELETE_DONE;
+		ea.fcport = sess;
+		qla2x00_fcport_event_handler(vha, &ea);
+	}
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
@@ -636,6 +931,9 @@ void qlt_unreg_sess(struct fc_port *sess)
 	qla2x00_mark_device_lost(vha, sess, 1, 1);
 
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
+	sess->disc_state = DSC_DELETE_PEND;
+	sess->last_rscn_gen = sess->rscn_gen;
+	sess->last_login_gen = sess->login_gen;
 
 	INIT_WORK(&sess->free_work, qlt_free_session_done);
 	schedule_work(&sess->free_work);
@@ -679,48 +977,57 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 	return qlt_issue_task_mgmt(sess, 0, mcmd, iocb, QLA24XX_MGMT_SEND_NACK);
 }
 
+static void qla24xx_chk_fcp_state(struct fc_port *sess)
+{
+	if (sess->chip_reset != sess->vha->hw->chip_reset) {
+		sess->logout_on_delete = 0;
+		sess->logo_ack_needed = 0;
+		sess->fw_login_state = DSC_LS_PORT_UNAVAIL;
+		sess->scan_state = 0;
+	}
+}
+
 /* ha->tgt.sess_lock supposed to be held on entry */
-static void qlt_schedule_sess_for_deletion(struct fc_port *sess,
+void qlt_schedule_sess_for_deletion(struct fc_port *sess,
 	bool immediate)
 {
 	struct qla_tgt *tgt = sess->tgt;
-	uint32_t dev_loss_tmo = tgt->ha->port_down_retry_count + 5;
 
-	if (sess->deleted) {
-		/* Upgrade to unconditional deletion in case it was temporary */
-		if (immediate && sess->deleted == QLA_SESS_DELETION_PENDING)
-			list_del(&sess->del_list_entry);
-		else
+	if (sess->disc_state == DSC_DELETE_PEND)
+		return;
+
+	if (sess->disc_state == DSC_DELETED) {
+		if (tgt && tgt->tgt_stop && (tgt->sess_count == 0))
+			wake_up_all(&tgt->waitQ);
+		if (sess->vha->fcport_count == 0)
+			wake_up_all(&sess->vha->fcport_waitQ);
+
+		if (!sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN] &&
+			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT])
 			return;
 	}
 
-	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
-	    "Scheduling sess %p for deletion\n", sess);
+	sess->disc_state = DSC_DELETE_PEND;
 
-	if (immediate) {
-		dev_loss_tmo = 0;
-		sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
-		list_add(&sess->del_list_entry, &tgt->del_sess_list);
-	} else {
-		sess->deleted = QLA_SESS_DELETION_PENDING;
-		list_add_tail(&sess->del_list_entry, &tgt->del_sess_list);
-	}
+	if (sess->deleted == QLA_SESS_DELETED)
+		sess->logout_on_delete = 0;
+
+	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
+	qla24xx_chk_fcp_state(sess);
 
-	sess->expires = jiffies + dev_loss_tmo * HZ;
+	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
+	    "Scheduling sess %p for deletion\n", sess);
 
-	ql_dbg(ql_dbg_tgt, sess->vha, 0xe048,
-	    "qla_target(%d): session for port %8phC (loop ID %d s_id %02x:%02x:%02x)"
-	    " scheduled for deletion in %u secs (expires: %lu) immed: %d, logout: %d, gen: %#x\n",
-	    sess->vha->vp_idx, sess->port_name, sess->loop_id,
-	    sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa,
-	    dev_loss_tmo, sess->expires, immediate, sess->logout_on_delete,
-	    sess->generation);
+	schedule_work(&sess->del_work);
+}
 
-	if (immediate)
-		mod_delayed_work(system_wq, &tgt->sess_del_work, 0);
-	else
-		schedule_delayed_work(&tgt->sess_del_work,
-		    sess->expires - jiffies);
+void qlt_schedule_sess_for_deletion_lock(struct fc_port *sess)
+{
+	unsigned long flags;
+	struct qla_hw_data *ha = sess->vha->hw;
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	qlt_schedule_sess_for_deletion(sess, 1);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
@@ -731,7 +1038,7 @@ static void qlt_clear_tgt_db(struct qla_tgt *tgt)
 
 	list_for_each_entry(sess, &vha->vp_fcports, list) {
 		if (sess->se_sess)
-			qlt_schedule_sess_for_deletion(sess, true);
+			qlt_schedule_sess_for_deletion(sess, 1);
 	}
 
 	/* At this point tgt could be already dead */
@@ -786,49 +1093,6 @@ static int qla24xx_get_loop_id(struct scsi_qla_host *vha, const uint8_t *s_id,
 	return res;
 }
 
-/* ha->tgt.sess_lock supposed to be held on entry */
-static void qlt_undelete_sess(struct fc_port *sess)
-{
-	BUG_ON(sess->deleted != QLA_SESS_DELETION_PENDING);
-
-	list_del_init(&sess->del_list_entry);
-	sess->deleted = 0;
-}
-
-static void qlt_del_sess_work_fn(struct delayed_work *work)
-{
-	struct qla_tgt *tgt = container_of(work, struct qla_tgt,
-	    sess_del_work);
-	struct scsi_qla_host *vha = tgt->vha;
-	struct qla_hw_data *ha = vha->hw;
-	struct fc_port *sess;
-	unsigned long flags, elapsed;
-
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	while (!list_empty(&tgt->del_sess_list)) {
-		sess = list_entry(tgt->del_sess_list.next, typeof(*sess),
-		    del_list_entry);
-		elapsed = jiffies;
-		if (time_after_eq(elapsed, sess->expires)) {
-			/* No turning back */
-			list_del_init(&sess->del_list_entry);
-			sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
-
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
-			    "Timeout: sess %p about to be deleted\n",
-			    sess);
-			if (sess->se_sess)
-				ha->tgt.tgt_ops->shutdown_sess(sess);
-			ha->tgt.tgt_ops->put_sess(sess);
-		} else {
-			schedule_delayed_work(&tgt->sess_del_work,
-			    sess->expires - elapsed);
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-}
-
 /*
  * Adds an extra ref to allow to drop hw lock after adding sess to the list.
  * Caller must put it.
@@ -839,93 +1103,65 @@ static struct fc_port *qlt_create_sess(
 	bool local)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct fc_port *sess;
+	struct fc_port *sess = fcport;
 	unsigned long flags;
 
-	/* Check to avoid double sessions */
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	list_for_each_entry(sess, &vha->vp_fcports, list) {
-		if (!memcmp(sess->port_name, fcport->port_name, WWN_SIZE)) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf005,
-			    "Double sess %p found (s_id %x:%x:%x, "
-			    "loop_id %d), updating to d_id %x:%x:%x, "
-			    "loop_id %d", sess, sess->d_id.b.domain,
-			    sess->d_id.b.al_pa, sess->d_id.b.area,
-			    sess->loop_id, fcport->d_id.b.domain,
-			    fcport->d_id.b.al_pa, fcport->d_id.b.area,
-			    fcport->loop_id);
-
-			/* Cannot undelete at this point */
-			if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
-				spin_unlock_irqrestore(&ha->tgt.sess_lock,
-				    flags);
-				return NULL;
-			}
-
-			if (sess->deleted)
-				qlt_undelete_sess(sess);
-
-			if (!sess->se_sess) {
-				if (ha->tgt.tgt_ops->check_initiator_node_acl(vha,
-				    &sess->port_name[0], sess) < 0) {
-					spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-					return NULL;
-				}
-			}
-
-			kref_get(&sess->sess_kref);
-			ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
-						(fcport->flags & FCF_CONF_COMP_SUPPORTED));
-
-			if (sess->local && !local)
-				sess->local = 0;
-
-			qlt_do_generation_tick(vha, &sess->generation);
-
-			spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+	if (vha->vha_tgt.qla_tgt->tgt_stop)
+		return NULL;
 
-			return sess;
+	if (fcport->se_sess) {
+		if (!kref_get_unless_zero(&sess->sess_kref)) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s: kref_get_unless_zero failed for %8phC\n",
+			    __func__, sess->port_name);
+			return NULL;
 		}
-	}
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-
-	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
-	if (!sess) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04a,
-		    "qla_target(%u): session allocation failed, all commands "
-		    "from port %8phC will be refused", vha->vp_idx,
-		    fcport->port_name);
-
-		return NULL;
+		return fcport;
 	}
 	sess->tgt = vha->vha_tgt.qla_tgt;
-	sess->vha = vha;
-	sess->d_id = fcport->d_id;
-	sess->loop_id = fcport->loop_id;
 	sess->local = local;
-	kref_init(&sess->sess_kref);
-	INIT_LIST_HEAD(&sess->del_list_entry);
 
-	/* Under normal circumstances we want to logout from firmware when
+	/*
+	 * Under normal circumstances we want to logout from firmware when
 	 * session eventually ends and release corresponding nport handle.
 	 * In the exception cases (e.g. when new PLOGI is waiting) corresponding
-	 * code will adjust these flags as necessary. */
+	 * code will adjust these flags as necessary.
+	 */
 	sess->logout_on_delete = 1;
 	sess->keep_nport_handle = 0;
+	sess->logout_completed = 0;
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf006,
-	    "Adding sess %p to tgt %p via ->check_initiator_node_acl()\n",
-	    sess, vha->vha_tgt.qla_tgt);
+	if (ha->tgt.tgt_ops->check_initiator_node_acl(vha,
+	    &fcport->port_name[0], sess) < 0) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
+		    "(%d) %8phC check_initiator_node_acl failed\n",
+		    vha->vp_idx, fcport->port_name);
+		return NULL;
+	} else {
+		kref_init(&fcport->sess_kref);
+		/*
+		 * Take an extra reference to ->sess_kref here to handle
+		 * fc_port access across ->tgt.sess_lock reaquire.
+		 */
+		if (!kref_get_unless_zero(&sess->sess_kref)) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s: kref_get_unless_zero failed for %8phC\n",
+			    __func__, sess->port_name);
+			return NULL;
+		}
 
-	sess->conf_compl_supported = (fcport->flags & FCF_CONF_COMP_SUPPORTED);
-	BUILD_BUG_ON(sizeof(sess->port_name) != sizeof(fcport->port_name));
-	memcpy(sess->port_name, fcport->port_name, sizeof(sess->port_name));
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+		if (!IS_SW_RESV_ADDR(sess->d_id))
+			vha->vha_tgt.qla_tgt->sess_count++;
 
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	list_add_tail(&sess->list, &vha->vp_fcports);
-	vha->vha_tgt.qla_tgt->sess_count++;
-	qlt_do_generation_tick(vha, &sess->generation);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+		qlt_do_generation_tick(vha, &sess->generation);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+	}
+
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf006,
+	    "Adding sess %p se_sess %p  to tgt %p sess_count %d\n",
+	    sess, sess->se_sess, vha->vha_tgt.qla_tgt,
+	    vha->vha_tgt.qla_tgt->sess_count);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04b,
 	    "qla_target(%d): %ssession for wwn %8phC (loop_id %d, "
@@ -934,23 +1170,6 @@ static struct fc_port *qlt_create_sess(
 	    fcport->loop_id, sess->d_id.b.domain, sess->d_id.b.area,
 	    sess->d_id.b.al_pa, sess->conf_compl_supported ?  "" : "not ");
 
-	/*
-	 * Determine if this fc_port->port_name is allowed to access
-	 * target mode using explict NodeACLs+MappedLUNs, or using
-	 * TPG demo mode.  If this is successful a target mode FC nexus
-	 * is created.
-	 */
-	if (ha->tgt.tgt_ops->check_initiator_node_acl(vha,
-	    &fcport->port_name[0], sess) < 0) {
-		return NULL;
-	} else {
-		/*
-		 * Take an extra reference to ->sess_kref here to handle fc_port
-		 * access across ->tgt.sess_lock reaquire.
-		 */
-		kref_get(&sess->sess_kref);
-	}
-
 	return sess;
 }
 
@@ -1007,12 +1226,12 @@ static inline int test_tgt_sess_count(struct qla_tgt *tgt)
 	 * We need to protect against race, when tgt is freed before or
 	 * inside wake_up()
 	 */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	ql_dbg(ql_dbg_tgt, tgt->vha, 0xe002,
 	    "tgt %p, sess_count=%d\n",
 	    tgt, tgt->sess_count);
 	res = (tgt->sess_count == 0);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 	return res;
 }
@@ -1060,8 +1279,6 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 	mutex_unlock(&qla_tgt_mutex);
 
-	flush_delayed_work(&tgt->sess_del_work);
-
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf009,
 	    "Waiting for sess works (tgt %p)", tgt);
 	spin_lock_irqsave(&tgt->sess_work_lock, flags);
@@ -1205,6 +1422,7 @@ static void qlt_send_notify_ack(struct scsi_qla_host *vha,
 	nack = (struct nack_to_isp *)pkt;
 	nack->ox_id = ntfy->ox_id;
 
+	nack->u.isp24.handle = QLA_TGT_SKIP_HANDLE;
 	nack->u.isp24.nport_handle = ntfy->u.isp24.nport_handle;
 	if (le16_to_cpu(ntfy->u.isp24.status) == IMM_NTFY_ELS) {
 		nack->u.isp24.flags = ntfy->u.isp24.flags &
@@ -1552,7 +1770,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 
-	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+	if (sess->deleted) {
 		qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_REJECTED, false);
 		return;
 	}
@@ -1650,10 +1868,19 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 		return;
 	}
 
-	if (mcmd->flags == QLA24XX_MGMT_SEND_NACK)
-		qlt_send_notify_ack(vha, &mcmd->orig_iocb.imm_ntfy,
-		    0, 0, 0, 0, 0, 0);
-	else {
+	if (mcmd->flags == QLA24XX_MGMT_SEND_NACK) {
+		if (mcmd->orig_iocb.imm_ntfy.u.isp24.status_subcode ==
+		    ELS_LOGO) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "TM response logo %phC status %#x state %#x",
+			    mcmd->sess->port_name, mcmd->fc_tm_rsp,
+			    mcmd->flags);
+			qlt_schedule_sess_for_deletion_lock(mcmd->sess);
+		} else {
+			qlt_send_notify_ack(vha, &mcmd->orig_iocb.imm_ntfy,
+				0, 0, 0, 0, 0, 0);
+		}
+	} else {
 		if (mcmd->orig_iocb.atio.u.raw.entry_type == ABTS_RECV_24XX)
 			qlt_24xx_send_abts_resp(vha, &mcmd->orig_iocb.abts,
 			    mcmd->fc_tm_rsp, false);
@@ -2470,7 +2697,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	int res;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	if (cmd->sess && cmd->sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+	if (cmd->sess && cmd->sess->deleted) {
 		cmd->state = QLA_TGT_STATE_PROCESSED;
 		if (cmd->sess->logout_completed)
 			/* no need to terminate. FW already freed exchange. */
@@ -2645,7 +2872,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	if (!vha->flags.online || (cmd->reset_count != ha->chip_reset) ||
-	    (cmd->sess && cmd->sess->deleted == QLA_SESS_DELETION_IN_PROGRESS)) {
+	    (cmd->sess && cmd->sess->deleted)) {
 		/*
 		 * Either the port is not online or this request was from
 		 * previous life, just abort the processing.
@@ -3342,7 +3569,11 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 				 */
 				cmd->sess->logout_on_delete = 0;
 				cmd->sess->send_els_logo = 1;
-				qlt_schedule_sess_for_deletion(cmd->sess, true);
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				    "%s %d %8phC post del sess\n",
+				    __func__, __LINE__, cmd->sess->port_name);
+
+				qlt_schedule_sess_for_deletion_lock(cmd->sess);
 			}
 			break;
 		}
@@ -3646,6 +3877,7 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 		kfree(op);
 		return;
 	}
+
 	/*
 	 * __qlt_do_work() will call qlt_put_sess() to release
 	 * the extra reference taken above by qlt_make_local_sess()
@@ -3653,13 +3885,11 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 	__qlt_do_work(cmd);
 	kfree(op);
 	return;
-
 out_term:
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_send_term_exchange(vha, NULL, &op->atio, 1, 0);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	kfree(op);
-
 }
 
 /* ha->hardware_lock supposed to be held on entry */
@@ -3699,7 +3929,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	/* Another WWN used to have our s_id. Our PLOGI scheduled its
 	 * session deletion, but it's still in sess_del_work wq */
-	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+	if (sess->deleted) {
 		ql_dbg(ql_dbg_io, vha, 0x3061,
 		    "New command while old session %p is being deleted\n",
 		    sess);
@@ -3709,7 +3939,13 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	/*
 	 * Do kref_get() before returning + dropping qla_hw_data->hardware_lock.
 	 */
-	kref_get(&sess->sess_kref);
+	if (!kref_get_unless_zero(&sess->sess_kref)) {
+		ql_dbg(ql_dbg_tgt, vha, 0xffff,
+		    "%s: kref_get fail, %8phC oxid %x \n",
+		    __func__, sess->port_name,
+		     be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id));
+		return -EFAULT;
+	}
 
 	cmd = qlt_get_tag(vha, sess, atio);
 	if (!cmd) {
@@ -3726,9 +3962,9 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	cmd->se_cmd.cpuid = ha->msix_count ?
 		ha->tgt.rspq_vector_cpuid : WORK_CPU_UNBOUND;
 
-	spin_lock(&vha->cmd_list_lock);
+	spin_lock_irqsave(&vha->cmd_list_lock, flags);
 	list_add_tail(&cmd->cmd_list, &vha->qla_cmd_list);
-	spin_unlock(&vha->cmd_list_lock);
+	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
 
 	INIT_WORK(&cmd->work, qlt_do_work);
 	if (ha->msix_count) {
@@ -3823,7 +4059,7 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 		    sizeof(struct atio_from_isp));
 	}
 
-	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS)
+	if (sess->deleted)
 		return -EFAULT;
 
 	return qlt_issue_task_mgmt(sess, unpacked_lun, fn, iocb, 0);
@@ -3898,22 +4134,20 @@ static int qlt_abort_task(struct scsi_qla_host *vha,
 
 void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 {
-	if (fcport->tgt_session) {
-		if (rc != MBS_COMMAND_COMPLETE) {
-			ql_dbg(ql_dbg_tgt_mgt, fcport->vha, 0xf093,
-				"%s: se_sess %p / sess %p from"
-				" port %8phC loop_id %#04x s_id %02x:%02x:%02x"
-				" LOGO failed: %#x\n",
-				__func__,
-				fcport->se_sess,
-				fcport->tgt_session,
-				fcport->port_name, fcport->loop_id,
-				fcport->d_id.b.domain, fcport->d_id.b.area,
-				fcport->d_id.b.al_pa, rc);
-		}
-
-		fcport->logout_completed = 1;
+	if (rc != MBS_COMMAND_COMPLETE) {
+		ql_dbg(ql_dbg_tgt_mgt, fcport->vha, 0xf093,
+			"%s: se_sess %p / sess %p from"
+			" port %8phC loop_id %#04x s_id %02x:%02x:%02x"
+			" LOGO failed: %#x\n",
+			__func__,
+			fcport->se_sess,
+			fcport,
+			fcport->port_name, fcport->loop_id,
+			fcport->d_id.b.domain, fcport->d_id.b.area,
+			fcport->d_id.b.al_pa, rc);
 	}
+
+	fcport->logout_completed = 1;
 }
 
 /*
@@ -3923,13 +4157,12 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 * deletion. Returns existing session with matching wwn if present.
 * Null otherwise.
 */
-static struct fc_port *
-qlt_find_sess_invalidate_other(struct qla_tgt *tgt, uint64_t wwn,
+struct fc_port *
+qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
     port_id_t port_id, uint16_t loop_id, struct fc_port **conflict_sess)
 {
 	struct fc_port *sess = NULL, *other_sess;
 	uint64_t other_wwn;
-	scsi_qla_host_t *vha = tgt->vha;
 
 	*conflict_sess = NULL;
 
@@ -3946,7 +4179,7 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 		/* find other sess with nport_id collision */
 		if (port_id.b24 == other_sess->d_id.b24) {
 			if (loop_id != other_sess->loop_id) {
-				ql_dbg(ql_dbg_tgt_tmr, tgt->vha, 0x1000c,
+				ql_dbg(ql_dbg_tgt_tmr, vha, 0x1000c,
 				    "Invalidating sess %p loop_id %d wwn %llx.\n",
 				    other_sess, other_sess->loop_id, other_wwn);
 
@@ -3962,6 +4195,11 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 				 * Another wwn used to have our s_id/loop_id
 				 * kill the session, but don't free the loop_id
 				 */
+				ql_dbg(ql_dbg_tgt_tmr, vha, 0xffff,
+				    "Invalidating sess %p loop_id %d wwn %llx.\n",
+				    other_sess, other_sess->loop_id, other_wwn);
+
+
 				other_sess->keep_nport_handle = 1;
 				*conflict_sess = other_sess;
 				qlt_schedule_sess_for_deletion(other_sess,
@@ -3971,8 +4209,9 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 		}
 
 		/* find other sess with nport handle collision */
-		if (loop_id == other_sess->loop_id) {
-			ql_dbg(ql_dbg_tgt_tmr, tgt->vha, 0x1000d,
+		if ((loop_id == other_sess->loop_id) &&
+			(loop_id != FC_NO_LOOP_ID)) {
+			ql_dbg(ql_dbg_tgt_tmr, vha, 0x1000d,
 			       "Invalidating sess %p loop_id %d wwn %llx.\n",
 			       other_sess, other_sess->loop_id, other_wwn);
 
@@ -4043,9 +4282,12 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 
 	loop_id = le16_to_cpu(iocb->u.isp24.nport_handle);
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf026,
-	    "qla_target(%d): Port ID: 0x%3phC ELS opcode: 0x%02x\n",
-	    vha->vp_idx, iocb->u.isp24.port_id, iocb->u.isp24.status_subcode);
+	ql_dbg(ql_dbg_disc, vha, 0xf026,
+	    "qla_target(%d): Port ID: %02x:%02x:%02x ELS opcode: 0x%02x lid %d %8phC\n",
+	    vha->vp_idx, iocb->u.isp24.port_id[2],
+		iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[0],
+		   iocb->u.isp24.status_subcode, loop_id,
+		iocb->u.isp24.port_name);
 
 	/* res = 1 means ack at the end of thread
 	 * res = 0 means ack async/later.
@@ -4058,12 +4300,12 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 
 		if (wwn) {
 			spin_lock_irqsave(&tgt->ha->tgt.sess_lock, flags);
-			sess = qlt_find_sess_invalidate_other(tgt, wwn,
-			    port_id, loop_id, &conflict_sess);
+			sess = qlt_find_sess_invalidate_other(vha, wwn,
+				port_id, loop_id, &conflict_sess);
 			spin_unlock_irqrestore(&tgt->ha->tgt.sess_lock, flags);
 		}
 
-		if (IS_SW_RESV_ADDR(port_id) || (!sess && !conflict_sess)) {
+		if (IS_SW_RESV_ADDR(port_id)) {
 			res = 1;
 			break;
 		}
@@ -4071,42 +4313,66 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		pla = qlt_plogi_ack_find_add(vha, &port_id, iocb);
 		if (!pla) {
 			qlt_send_term_imm_notif(vha, iocb, 1);
-
-			res = 0;
 			break;
 		}
 
 		res = 0;
 
-		if (conflict_sess)
+		if (conflict_sess) {
+			conflict_sess->login_gen++;
 			qlt_plogi_ack_link(vha, pla, conflict_sess,
-			    QLT_PLOGI_LINK_CONFLICT);
+				QLT_PLOGI_LINK_CONFLICT);
+		}
 
-		if (!sess)
+		if (!sess) {
+			pla->ref_count++;
+			qla24xx_post_newsess_work(vha, &port_id,
+				iocb->u.isp24.port_name, pla);
+			res = 0;
 			break;
+		}
 
 		qlt_plogi_ack_link(vha, pla, sess, QLT_PLOGI_LINK_SAME_WWN);
-		 /*
-		  * Under normal circumstances we want to release nport handle
-		  * during LOGO process to avoid nport handle leaks inside FW.
-		  * The exception is when LOGO is done while another PLOGI with
-		  * the same nport handle is waiting as might be the case here.
-		  * Note: there is always a possibily of a race where session
-		  * deletion has already started for other reasons (e.g. ACL
-		  * removal) and now PLOGI arrives:
-		  * 1. if PLOGI arrived in FW after nport handle has been freed,
-		  *    FW must have assigned this PLOGI a new/same handle and we
-		  *    can proceed ACK'ing it as usual when session deletion
-		  *    completes.
-		  * 2. if PLOGI arrived in FW before LOGO with LCF_FREE_NPORT
-		  *    bit reached it, the handle has now been released. We'll
-		  *    get an error when we ACK this PLOGI. Nothing will be sent
-		  *    back to initiator. Initiator should eventually retry
-		  *    PLOGI and situation will correct itself.
-		  */
-		sess->keep_nport_handle = ((sess->loop_id == loop_id) &&
-					   (sess->d_id.b24 == port_id.b24));
-		qlt_schedule_sess_for_deletion(sess, true);
+		sess->fw_login_state = DSC_LS_PLOGI_PEND;
+		sess->d_id = port_id;
+		sess->login_gen++;
+
+		switch (sess->disc_state) {
+		case DSC_DELETED:
+			qlt_plogi_ack_unref(vha, pla);
+			break;
+
+		default:
+			/*
+			 * Under normal circumstances we want to release nport handle
+			 * during LOGO process to avoid nport handle leaks inside FW.
+			 * The exception is when LOGO is done while another PLOGI with
+			 * the same nport handle is waiting as might be the case here.
+			 * Note: there is always a possibily of a race where session
+			 * deletion has already started for other reasons (e.g. ACL
+			 * removal) and now PLOGI arrives:
+			 * 1. if PLOGI arrived in FW after nport handle has been freed,
+			 *    FW must have assigned this PLOGI a new/same handle and we
+			 *    can proceed ACK'ing it as usual when session deletion
+			 *    completes.
+			 * 2. if PLOGI arrived in FW before LOGO with LCF_FREE_NPORT
+			 *    bit reached it, the handle has now been released. We'll
+			 *    get an error when we ACK this PLOGI. Nothing will be sent
+			 *    back to initiator. Initiator should eventually retry
+			 *    PLOGI and situation will correct itself.
+			 */
+			sess->keep_nport_handle = ((sess->loop_id == loop_id) &&
+			   (sess->d_id.b24 == port_id.b24));
+
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+				   "%s %d %8phC post del sess\n",
+				   __func__, __LINE__, sess->port_name);
+
+
+			qlt_schedule_sess_for_deletion_lock(sess);
+			break;
+		}
+
 		break;
 
 	case ELS_PRLI:
@@ -4114,8 +4380,8 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 
 		if (wwn) {
 			spin_lock_irqsave(&tgt->ha->tgt.sess_lock, flags);
-			sess = qlt_find_sess_invalidate_other(tgt, wwn, port_id,
-			    loop_id, &conflict_sess);
+			sess = qlt_find_sess_invalidate_other(vha, wwn, port_id,
+				loop_id, &conflict_sess);
 			spin_unlock_irqrestore(&tgt->ha->tgt.sess_lock, flags);
 		}
 
@@ -4129,7 +4395,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		}
 
 		if (sess != NULL) {
-			if (sess->deleted) {
+			if (sess->fw_login_state == DSC_LS_PLOGI_PEND) {
 				/*
 				 * Impatient initiator sent PRLI before last
 				 * PLOGI could finish. Will force him to re-try,
@@ -4154,10 +4420,15 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			sess->local = 0;
 			sess->loop_id = loop_id;
 			sess->d_id = port_id;
+			sess->fw_login_state = DSC_LS_PRLI_PEND;
 
 			if (wd3_lo & BIT_7)
 				sess->conf_compl_supported = 1;
 
+			if ((wd3_lo & BIT_4) == 0)
+				sess->port_type = FCT_INITIATOR;
+			else
+				sess->port_type = FCT_TARGET;
 		}
 		res = 1; /* send notify ack */
 
@@ -4167,15 +4438,50 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		} else {
-			/* todo: else - create sess here. */
-			res = 1; /* send notify ack */
-		}
+			if (sess) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+					   "%s %d %8phC post nack\n",
+					   __func__, __LINE__, sess->port_name);
 
+				qla24xx_post_nack_work(vha, sess, iocb,
+					SRB_NACK_PRLI);
+				res = 0;
+			}
+		}
 		break;
 
 	case ELS_LOGO:
 	case ELS_PRLO:
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+		sess = qla2x00_find_fcport_by_loopid(vha, loop_id);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+		if (sess) {
+			sess->login_gen++;
+			sess->fw_login_state = DSC_LS_LOGO_PEND;
+			sess->logout_on_delete = 0;
+			sess->logo_ack_needed = 1;
+			memcpy(sess->iocb, iocb, IOCB_SIZE);
+		}
+
 		res = qlt_reset(vha, iocb, QLA_TGT_NEXUS_LOSS_SESS);
+
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		    "%s: logo %llx res %d sess %p ",
+		    __func__, wwn, res, sess);
+		if (res == 0) {
+			/* cmd went up to ULP. look for qlt_xmit_tm_rsp()
+			   for LOGO_ACK */
+			BUG_ON(!sess);
+			res = 0;
+		} else {
+			/* cmd did not go upstair. */
+			if (sess) {
+				qlt_schedule_sess_for_deletion_lock(sess);
+				res = 0;
+			}
+			/* else logo will be ack */
+		}
 		break;
 	case ELS_PDISC:
 	case ELS_ADISC:
@@ -4186,6 +4492,16 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			    0, 0, 0, 0, 0, 0);
 			tgt->link_reinit_iocb_pending = 0;
 		}
+
+		sess = qla2x00_find_fcport_by_wwpn(vha,
+		    iocb->u.isp24.port_name, 1);
+		if (sess) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+				"sess %p lid %d|%d DS %d LS %d\n",
+				sess, sess->loop_id, loop_id,
+				sess->disc_state, sess->fw_login_state);
+		}
+
 		res = 1; /* send notify ack */
 		break;
 	}
@@ -4963,7 +5279,6 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03f,
 			    "Async MB 2: Port Logged Out\n");
 		break;
-
 	default:
 		break;
 	}
@@ -4974,8 +5289,10 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 	uint16_t loop_id)
 {
-	fc_port_t *fcport;
+	fc_port_t *fcport, *tfcp, *del;
 	int rc;
+	unsigned long flags;
+	u8 newfcport = 0;
 
 	fcport = kzalloc(sizeof(*fcport), GFP_KERNEL);
 	if (!fcport) {
@@ -4997,6 +5314,59 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 		return NULL;
 	}
 
+	del = NULL;
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	tfcp = qla2x00_find_fcport_by_wwpn(vha, fcport->port_name, 1);
+
+	if (tfcp) {
+		tfcp->d_id = fcport->d_id;
+		tfcp->port_type = fcport->port_type;
+		tfcp->supported_classes = fcport->supported_classes;
+		tfcp->flags |= fcport->flags;
+
+		del = fcport;
+		fcport = tfcp;
+	} else {
+		if (vha->hw->current_topology == ISP_CFG_F)
+			fcport->flags |= FCF_FABRIC_DEVICE;
+
+		list_add_tail(&fcport->list, &vha->vp_fcports);
+		if (!IS_SW_RESV_ADDR(fcport->d_id))
+		   vha->fcport_count++;
+		fcport->login_gen++;
+		fcport->disc_state = DSC_LOGIN_COMPLETE;
+		fcport->login_succ = 1;
+		newfcport = 1;
+	}
+
+	fcport->deleted = 0;
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
+	switch (vha->host->active_mode) {
+	case MODE_INITIATOR:
+	case MODE_DUAL:
+		if (newfcport) {
+			if (!IS_IIDMA_CAPABLE(vha->hw) || !vha->hw->flags.gpsc_supported) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				   "%s %d %8phC post upd_fcport fcp_cnt %d\n",
+				   __func__, __LINE__, fcport->port_name, vha->fcport_count);
+				qla24xx_post_upd_fcport_work(vha, fcport);
+			} else {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				   "%s %d %8phC post gpsc fcp_cnt %d\n",
+				   __func__, __LINE__, fcport->port_name, vha->fcport_count);
+				qla24xx_post_gpsc_work(vha, fcport);
+			}
+		}
+		break;
+
+	case MODE_TARGET:
+	default:
+		break;
+	}
+	if (del)
+		qla2x00_free_fcport(del);
+
 	return fcport;
 }
 
@@ -5009,6 +5379,17 @@ static struct fc_port *qlt_make_local_sess(struct scsi_qla_host *vha,
 	int rc, global_resets;
 	uint16_t loop_id = 0;
 
+	if ((s_id[0] == 0xFF) && (s_id[1] == 0xFC)) {
+		/*
+		 * This is Domain Controller, so it should be
+		 * OK to drop SCSI commands from it.
+		 */
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf042,
+		    "Unable to find initiator with S_ID %x:%x:%x",
+		    s_id[0], s_id[1], s_id[2]);
+		return NULL;
+	}
+
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
 
 retry:
@@ -5019,21 +5400,11 @@ static struct fc_port *qlt_make_local_sess(struct scsi_qla_host *vha,
 	if (rc != 0) {
 		mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
-		if ((s_id[0] == 0xFF) &&
-		    (s_id[1] == 0xFC)) {
-			/*
-			 * This is Domain Controller, so it should be
-			 * OK to drop SCSI commands from it.
-			 */
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf042,
-			    "Unable to find initiator with S_ID %x:%x:%x",
-			    s_id[0], s_id[1], s_id[2]);
-		} else
-			ql_log(ql_log_info, vha, 0xf071,
-			    "qla_target(%d): Unable to find "
-			    "initiator with S_ID %x:%x:%x",
-			    vha->vp_idx, s_id[0], s_id[1],
-			    s_id[2]);
+		ql_log(ql_log_info, vha, 0xf071,
+		    "qla_target(%d): Unable to find "
+		    "initiator with S_ID %x:%x:%x",
+		    vha->vp_idx, s_id[0], s_id[1],
+		    s_id[2]);
 
 		if (rc == -ENOENT) {
 			qlt_port_logo_t logo;
@@ -5101,12 +5472,18 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 		if (!sess)
 			goto out_term2;
 	} else {
-		if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+		if (sess->deleted) {
 			sess = NULL;
 			goto out_term2;
 		}
 
-		kref_get(&sess->sess_kref);
+		if (!kref_get_unless_zero(&sess->sess_kref)) {
+			ql_dbg(ql_dbg_tgt_tmr, vha, 0xffff,
+			    "%s: kref_get fail %8phC \n",
+			     __func__, sess->port_name);
+			sess = NULL;
+			goto out_term2;
+		}
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -5130,7 +5507,8 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	qlt_24xx_send_abts_resp(vha, &prm->abts, FCP_TMF_REJECTED, false);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	ha->tgt.tgt_ops->put_sess(sess);
+	if (sess)
+		ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 }
 
@@ -5165,12 +5543,18 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 		if (!sess)
 			goto out_term;
 	} else {
-		if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+		if (sess->deleted) {
 			sess = NULL;
 			goto out_term;
 		}
 
-		kref_get(&sess->sess_kref);
+		if (!kref_get_unless_zero(&sess->sess_kref)) {
+			ql_dbg(ql_dbg_tgt_tmr, vha, 0xffff,
+			    "%s: kref_get fail %8phC\n",
+			     __func__, sess->port_name);
+			sess = NULL;
+			goto out_term;
+		}
 	}
 
 	iocb = a;
@@ -5188,8 +5572,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 
 out_term:
 	qlt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 1, 0);
-	if (sess)
-		ha->tgt.tgt_ops->put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
@@ -5267,8 +5650,6 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	tgt->vha = base_vha;
 	init_waitqueue_head(&tgt->waitQ);
 	INIT_LIST_HEAD(&tgt->del_sess_list);
-	INIT_DELAYED_WORK(&tgt->sess_del_work,
-		(void (*)(struct work_struct *))qlt_del_sess_work_fn);
 	spin_lock_init(&tgt->sess_work_lock);
 	INIT_WORK(&tgt->sess_work, qlt_sess_work_fn);
 	INIT_LIST_HEAD(&tgt->sess_works_list);
@@ -5469,6 +5850,7 @@ static void qlt_clear_mode(struct scsi_qla_host *vha)
 		break;
 	case QLA2XXX_INI_MODE_ENABLED:
 		vha->host->active_mode &= ~MODE_TARGET;
+		vha->host->active_mode |= MODE_INITIATOR;
 		break;
 	default:
 		break;
@@ -5591,13 +5973,12 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	 * FC-4 Feature bit 0 indicates target functionality to the name server.
 	 */
 	if (qla_tgt_mode_enabled(vha)) {
-		if (qla_ini_mode_enabled(vha))
-			ct_req->req.rff_id.fc4_feature = BIT_0 | BIT_1;
-		else
-			ct_req->req.rff_id.fc4_feature = BIT_0;
+		ct_req->req.rff_id.fc4_feature = BIT_0;
 	} else if (qla_ini_mode_enabled(vha)) {
 		ct_req->req.rff_id.fc4_feature = BIT_1;
-	}
+	} else if (qla_dual_mode_enabled(vha))
+		ct_req->req.rff_id.fc4_feature = BIT_0 | BIT_1;
+
 }
 
 /*
@@ -5729,7 +6110,7 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 		nv->firmware_options_1 |= cpu_to_le32(BIT_4);
 
 		/* Disable ini mode, if requested */
-		if (!qla_ini_mode_enabled(vha))
+		if (qla_tgt_mode_enabled(vha))
 			nv->firmware_options_1 |= cpu_to_le32(BIT_5);
 
 		/* Disable Full Login after LIP */
@@ -5831,7 +6212,7 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 		nv->firmware_options_1 |= cpu_to_le32(BIT_4);
 
 		/* Disable ini mode, if requested */
-		if (!qla_ini_mode_enabled(vha))
+		if (qla_tgt_mode_enabled(vha))
 			nv->firmware_options_1 |= cpu_to_le32(BIT_5);
 		/* Disable Full Login after LIP */
 		nv->firmware_options_1 &= cpu_to_le32(~BIT_13);
@@ -5937,8 +6318,9 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 {
 	if (qla_tgt_mode_enabled(vha))
 		vpmod->options_idx1 &= ~BIT_5;
-	/* Disable ini mode, if requested */
-	if (!qla_ini_mode_enabled(vha))
+
+	/* Disable ini mode, if requested. */
+	if (qla_tgt_mode_enabled(vha))
 		vpmod->options_idx1 &= ~BIT_4;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 9c35ba1..5e56192 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -799,7 +799,6 @@ struct qla_tgt {
 
 	/* Protected by hardware_lock */
 	struct list_head del_sess_list;
-	struct delayed_work sess_del_work;
 
 	spinlock_t sess_work_lock;
 	struct list_head sess_works_list;
@@ -823,13 +822,6 @@ struct qla_tgt_sess_op {
 	bool aborted;
 };
 
-enum qla_sess_deletion {
-	QLA_SESS_DELETION_NONE		= 0,
-	QLA_SESS_DELETION_PENDING	= 1, /* hopefully we can get rid of
-					      * this one */
-	QLA_SESS_DELETION_IN_PROGRESS	= 2,
-};
-
 enum trace_flags {
 	TRC_NEW_CMD = BIT_0,
 	TRC_DO_WORK = BIT_1,
@@ -987,12 +979,17 @@ extern int qlt_lport_register(void *, u64, u64, u64,
 
 static inline bool qla_tgt_mode_enabled(struct scsi_qla_host *ha)
 {
-	return ha->host->active_mode & MODE_TARGET;
+	return ha->host->active_mode == MODE_TARGET;
 }
 
 static inline bool qla_ini_mode_enabled(struct scsi_qla_host *ha)
 {
-	return ha->host->active_mode & MODE_INITIATOR;
+	return ha->host->active_mode == MODE_INITIATOR;
+}
+
+static inline bool qla_dual_mode_enabled(struct scsi_qla_host *ha)
+{
+	return (ha->host->active_mode == MODE_DUAL);
 }
 
 static inline void qla_reverse_ini_mode(struct scsi_qla_host *ha)
-- 
1.8.3.1

