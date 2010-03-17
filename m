From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 2/2] RFC: The be2iscsi driver support for bsg
Date: Wed, 17 Mar 2010 23:37:07 +0530
Message-ID: <20100317180647.GA25863@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:59117 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755322Ab0CQSHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 14:07:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu, open-iscsi@googlegroups.com

  This patch contains the necessary changes to support
the bsg interface

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_cmds.h  |  137 ++++++++++++++++++++---
 drivers/scsi/be2iscsi/be_iscsi.c |    3 +-
 drivers/scsi/be2iscsi/be_main.c  |   99 ++++++++++++++--
 drivers/scsi/be2iscsi/be_main.h  |    6 +-
 drivers/scsi/be2iscsi/be_mgmt.c  |  230 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/be2iscsi/be_mgmt.h  |  107 ++++++++++++++++++
 include/scsi/scsi_bsg_iscsi.h    |    1 +
 7 files changed, 547 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 49fcc78..d5c14cf 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -18,6 +18,7 @@
 #ifndef BEISCSI_CMDS_H
 #define BEISCSI_CMDS_H
 
+#include <scsi/scsi_bsg_iscsi.h>
 /**
  * The driver sends configuration and managements command requests to the
  * firmware in the BE. These requests are communicated to the processor
@@ -162,6 +163,13 @@ struct be_mcc_mailbox {
 #define OPCODE_COMMON_ISCSI_CFG_POST_SGL_PAGES		2
 #define OPCODE_COMMON_ISCSI_CFG_REMOVE_SGL_PAGES        3
 #define OPCODE_COMMON_ISCSI_NTWK_GET_NIC_CONFIG		7
+#define OPCODE_COMMON_ISCSI_NTWK_SET_VLAN		14
+#define OPCODE_COMMON_ISCSI_NTWK_CONFIGURE_STATELESS_IP_ADDR	17
+#define OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR		21
+#define OPCODE_COMMON_ISCSI_NTWK_GET_DEFAULT_GATEWAY	22
+#define OPCODE_COMMON_ISCSI_NTWK_MODIFY_DEFAULT_GATEWAY 23
+#define OPCODE_COMMON_ISCSI_NTWK_GET_ALL_IF_ID		24
+#define OPCODE_COMMON_ISCSI_NTWK_GET_IF_INFO		25
 #define OPCODE_COMMON_ISCSI_SET_FRAGNUM_BITS_FOR_SGL_CRA 61
 #define OPCODE_COMMON_ISCSI_DEFQ_CREATE                 64
 #define OPCODE_COMMON_ISCSI_DEFQ_DESTROY 		65
@@ -237,6 +245,86 @@ struct be_cmd_resp_eq_create {
 	u16 rsvd0;		/* sword */
 } __packed;
 
+struct mgmt_chap_format {
+	u32 flags;
+	u8  intr_chap_name[256];
+	u8  intr_secret[16];
+	u8  target_chap_name[256];
+	u8  target_secret[16];
+	u16 intr_chap_name_length;
+	u16 intr_secret_length;
+	u16 target_chap_name_length;
+	u16 target_secret_length;
+} __packed;
+
+struct mgmt_auth_method_format {
+	u8	auth_method_type;
+	u8	padding[3];
+	struct	mgmt_chap_format chap;
+} __packed;
+
+struct mgmt_conn_login_options {
+	u8 flags;
+	u8 header_digest;
+	u8 data_digest;
+	u8 rsvd0;
+	u32 max_recv_datasegment_len_ini;
+	u32 max_recv_datasegment_len_tgt;
+	u32 tcp_mss;
+	u32 tcp_window_size;
+	struct	mgmt_auth_method_format auth_data;
+} __packed;
+
+struct	mgmt_conn_info {
+	u32	connection_handle;
+	u32	connection_status;
+	u16	src_port;
+	u16	dest_port;
+	u16	dest_port_redirected;
+	u16	cid;
+	u32	estimated_throughput;
+	struct	ip_address_format	src_ipaddr;
+	struct	ip_address_format	dest_ipaddr;
+	struct	ip_address_format	dest_ipaddr_redirected;
+	struct	mgmt_conn_login_options	negotiated_login_options;
+} __packed;
+
+struct mgmt_session_login_options {
+	u8	flags;
+	u8	error_recovery_level;
+	u16	rsvd0;
+	u32	first_burst_length;
+	u32	max_burst_length;
+	u16	max_connections;
+	u16	max_outstanding_r2t;
+	u16	default_time2wait;
+	u16	default_time2retain;
+} __packed;
+
+struct mgmt_session_info {
+	u32	session_handle;
+	u32	status;
+	u8	isid[6];
+	u16	tsih;
+	u32	session_flags;
+	u16	conn_count;
+	u16	pad;
+	u8	target_name[224];
+	u8	initiator_iscsiname[224];
+	struct	mgmt_session_login_options	negotiated_login_options;
+	struct	mgmt_conn_info	conn_list[1];
+} __packed;
+
+struct  be_cmd_req_geta_session {
+	struct be_cmd_resp_hdr resp_hdr;
+	u32 session_handle;
+} __packed;
+
+struct  be_cmd_resp_geta_session {
+	struct be_cmd_resp_hdr resp_hdr;
+	struct mgmt_session_info session_info;
+} __packed;
+
 struct mac_addr {
 	u16 size_of_struct;
 	u8 addr[ETH_ALEN];
@@ -254,6 +342,16 @@ struct be_cmd_resp_mac_query {
 	struct mac_addr mac;
 };
 
+struct be_cmd_req_get_boot_target {
+	struct be_cmd_req_hdr hdr;
+} __packed;
+
+struct be_cmd_resp_get_boot_target {
+	struct be_cmd_resp_hdr hdr;
+	u32  boot_session_count;
+	u32  boot_session_handle;
+};
+
 /******************** Create CQ ***************************/
 /**
  * Pseudo amap definition in which each bit of the actual structure is defined
@@ -601,14 +699,6 @@ struct be_eq_delay_params_in {
 	struct eq_delay delay[8];
 } __packed;
 
-struct ip_address_format {
-	u16 size_of_structure;
-	u8 reserved;
-	u8 ip_type;
-	u8 ip_address[16];
-	u32 rsvd0;
-} __packed;
-
 struct tcp_connect_and_offload_in {
 	struct be_cmd_req_hdr hdr;
 	struct ip_address_format ip_address;
@@ -688,18 +778,31 @@ struct be_fw_cfg {
 	u32 function_caps;
 } __packed;
 
-#define CMD_ISCSI_COMMAND_INVALIDATE  1
-#define ISCSI_OPCODE_SCSI_DATA_OUT      5
+struct be_all_if_id {
+	struct be_cmd_req_hdr hdr;
+	u32 if_count;
+	u32 if_hndl_list[1];
+} __packed;
+
+
+#define ISCSI_OPCODE_SCSI_DATA_OUT		5
 #define OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD 70
-#define OPCODE_ISCSI_INI_DRIVER_OFFLOAD_SESSION 41
-#define OPCODE_COMMON_MODIFY_EQ_DELAY	41
-#define OPCODE_COMMON_ISCSI_CLEANUP	59
-#define	OPCODE_COMMON_TCP_UPLOAD	56
+#define OPCODE_COMMON_MODIFY_EQ_DELAY		41
+#define OPCODE_COMMON_ISCSI_CLEANUP		59
+#define	OPCODE_COMMON_TCP_UPLOAD		56
 #define OPCODE_COMMON_ISCSI_ERROR_RECOVERY_INVALIDATE_COMMANDS 1
-/* --- CMD_ISCSI_INVALIDATE_CONNECTION_TYPE --- */
-#define CMD_ISCSI_CONNECTION_INVALIDATE 0x8001
-#define CMD_ISCSI_CONNECTION_ISSUE_TCP_RST 0x8002
+#define OPCODE_ISCSI_INI_CFG_GET_HBA_NAME	6
+#define OPCODE_ISCSI_INI_CFG_SET_HBA_NAME	7
+#define OPCODE_ISCSI_INI_SESSION_GET_A_SESSION  14
+#define OPCODE_ISCSI_INI_DRIVER_OFFLOAD_SESSION 41
 #define OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION 42
+#define OPCODE_ISCSI_INI_BOOT_GET_BOOT_TARGET	52
+
+/* --- CMD_ISCSI_INVALIDATE_CONNECTION_TYPE --- */
+#define CMD_ISCSI_COMMAND_INVALIDATE		1
+#define CMD_ISCSI_CONNECTION_INVALIDATE		0x8001
+#define CMD_ISCSI_CONNECTION_ISSUE_TCP_RST	0x8002
+
 
 #define INI_WR_CMD			1	/* Initiator write command */
 #define INI_TMF_CMD			2	/* Initiator TMF command */
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index c3928cb..eae98de 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -696,8 +696,7 @@ void beiscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_stop  ep_cid = %d\n",
 			     beiscsi_ep->ep_cid);
 	tag = mgmt_invalidate_connection(phba, beiscsi_ep,
-					    beiscsi_ep->ep_cid, 1,
-					    savecfg_flag);
+					 beiscsi_ep->ep_cid, 0, savecfg_flag);
 	if (!tag) {
 		SE_DEBUG(DBG_LVL_1,
 			 "mgmt_invalidate_connection Failed for cid=%d \n",
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fcfb29e..82ec2cc 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -28,6 +28,7 @@
 
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_transport_iscsi.h>
+#include <scsi/scsi_bsg_iscsi.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -73,6 +74,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
+
 	spin_lock_bh(&session->lock);
 	if (!aborted_task || !aborted_task->sc) {
 		/* we raced */
@@ -229,6 +231,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 	phba->shost = shost;
 	phba->pcidev = pci_dev_get(pcidev);
 	pci_set_drvdata(pcidev, phba);
+	phba->interface_handle = 0xFFFFFFFF;
 
 	if (iscsi_host_add(shost, &phba->pcidev->dev))
 		goto free_devices;
@@ -1074,7 +1077,6 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 			be_complete_logout(beiscsi_conn, task, psol);
 		else
 			be_complete_tmf(beiscsi_conn, task, psol);
-
 		break;
 
 	case HWH_TYPE_LOGIN:
@@ -1763,7 +1765,7 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
 	      unsigned int num_sg, struct beiscsi_io_task *io_task)
 {
 	struct iscsi_sge *psgl;
-	unsigned short sg_len, index;
+	unsigned int sg_len, index;
 	unsigned int sge_len = 0;
 	unsigned long long addr;
 	struct scatterlist *l_sg;
@@ -3201,7 +3203,9 @@ static unsigned char hwi_enable_intr(struct beiscsi_hba *phba)
 				hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
 			}
 		}
-	}
+	} else
+		shost_printk(KERN_WARNING, phba->shost,
+			     "In hwi_enable_intr, Not Enabled \n");
 	return true;
 }
 
@@ -3427,21 +3431,23 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		return -ENOMEM;
 	io_task->bhs_pa.u.a64.address = paddr;
 	io_task->libiscsi_itt = (itt_t)task->itt;
-	io_task->pwrb_handle = alloc_wrb_handle(phba,
-						beiscsi_conn->beiscsi_conn_cid -
-						phba->fw_config.iscsi_cid_start
-						);
 	io_task->conn = beiscsi_conn;
 
 	task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs->iscsi_hdr;
 	task->hdr_max = sizeof(struct be_cmd_bhs);
-
+	io_task->psgl_handle = NULL;
+	io_task->psgl_handle = NULL;
 	if (task->sc) {
 		spin_lock(&phba->io_sgl_lock);
 		io_task->psgl_handle = alloc_io_sgl_handle(phba);
 		spin_unlock(&phba->io_sgl_lock);
 		if (!io_task->psgl_handle)
 			goto free_hndls;
+		io_task->pwrb_handle = alloc_wrb_handle(phba,
+					beiscsi_conn->beiscsi_conn_cid -
+					phba->fw_config.iscsi_cid_start);
+		if (!io_task->pwrb_handle)
+			goto free_io_hndls;
 	} else {
 		io_task->scsi_cmnd = NULL;
 		if ((opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
@@ -3456,9 +3462,19 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				beiscsi_conn->login_in_progress = 1;
 				beiscsi_conn->plogin_sgl_handle =
 							io_task->psgl_handle;
+				io_task->pwrb_handle =
+					alloc_wrb_handle(phba,
+					beiscsi_conn->beiscsi_conn_cid -
+					phba->fw_config.iscsi_cid_start);
+				if (!io_task->pwrb_handle)
+					goto free_io_hndls;
+				beiscsi_conn->plogin_wrb_handle =
+							io_task->pwrb_handle;
 			} else {
 				io_task->psgl_handle =
 						beiscsi_conn->plogin_sgl_handle;
+				io_task->pwrb_handle =
+						beiscsi_conn->plogin_wrb_handle;
 			}
 		} else {
 			spin_lock(&phba->mgmt_sgl_lock);
@@ -3466,6 +3482,12 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			spin_unlock(&phba->mgmt_sgl_lock);
 			if (!io_task->psgl_handle)
 				goto free_hndls;
+			io_task->pwrb_handle =
+					alloc_wrb_handle(phba,
+					beiscsi_conn->beiscsi_conn_cid -
+					phba->fw_config.iscsi_cid_start);
+			if (!io_task->pwrb_handle)
+				goto free_mgmt_hndls;
 		}
 	}
 	itt = (itt_t) cpu_to_be32(((unsigned int)io_task->pwrb_handle->
@@ -3475,13 +3497,22 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 
 	io_task->cmd_bhs->iscsi_hdr.itt = itt;
 	return 0;
-
+free_io_hndls:
+	spin_lock(&phba->io_sgl_lock);
+	free_io_sgl_handle(phba, io_task->psgl_handle);
+	spin_unlock(&phba->io_sgl_lock);
+	goto free_hndls;
+free_mgmt_hndls:
+	spin_lock(&phba->mgmt_sgl_lock);
+	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
+	spin_unlock(&phba->mgmt_sgl_lock);
 free_hndls:
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pwrb_context = &phwi_ctrlr->wrb_context[
 			beiscsi_conn->beiscsi_conn_cid -
 			phba->fw_config.iscsi_cid_start];
-	free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
+	if (io_task->pwrb_handle)
+		free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
 	io_task->pwrb_handle = NULL;
 	pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
 		      io_task->bhs_pa.u.a64.address);
@@ -3688,8 +3719,6 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 		SE_DEBUG(DBG_LVL_1, " scsi_dma_map Failed\n")
 		return num_sg;
 	}
-	SE_DEBUG(DBG_LVL_4, "xferlen=0x%08x scmd=%p num_sg=%d sernum=%lu\n",
-		  (scsi_bufflen(sc)), sc, num_sg, sc->serial_number);
 	xferlen = scsi_bufflen(sc);
 	sg = scsi_sglist(sc);
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
@@ -3701,6 +3730,50 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	return beiscsi_iotask(task, sg, num_sg, xferlen, writedir);
 }
 
+/**
+* beiscsi_bsg_request - handle bsg request from ISCSI transport
+ * @job: iscsi_bsg_job to handle
+ */
+static int beiscsi_bsg_request(struct iscsi_bsg_job *job)
+{
+	uint32_t msgcode;
+	int rc = -EINVAL;
+	unsigned int tag;
+	unsigned short status, extd_status;
+	struct beiscsi_hba *phba;
+
+	msgcode = job->request->msgcode;
+	phba = iscsi_host_priv(job->shost);
+	switch (msgcode) {
+	case ISCSI_BSG_HST_VENDOR:
+		shost_printk(KERN_ERR, phba->shost,
+			"No Vendor Specific Commands Supported \n");
+		break;
+	case ISCSI_BSG_HST_NET_CONFIG:
+		tag = mgmt_netcfg_fw_cmd(&phba->ctrl, phba, job);
+		if (!tag) {
+			SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed \n");
+			return -EAGAIN;
+		} else
+			wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+						 phba->ctrl.mcc_numtag[tag]);
+
+		extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
+		status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
+		free_mcc_tag(&phba->ctrl, tag);
+		if (status || extd_status) {
+			SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed"
+					    " status = %d extd_status = %d \n",
+					    status, extd_status);
+			return -EIO;
+		}
+
+	default:
+		break;
+	}
+	return rc;
+}
+
 static void beiscsi_remove(struct pci_dev *pcidev)
 {
 	struct beiscsi_hba *phba = NULL;
@@ -3736,6 +3809,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 
 	beiscsi_clean_port(phba);
 	beiscsi_free_mem(phba);
+
 	beiscsi_unmap_pci_function(phba);
 	pci_free_consistent(phba->pcidev,
 			    phba->ctrl.mbox_mem_alloced.size,
@@ -3965,6 +4039,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.ep_poll = beiscsi_ep_poll,
 	.ep_disconnect = beiscsi_ep_disconnect,
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
+	.bsg_request = beiscsi_bsg_request,
 };
 
 static struct pci_driver beiscsi_pci_driver = {
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 87ec212..18a02a7 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -62,7 +62,7 @@
 #define BEISCSI_SGLIST_ELEMENTS	30
 
 #define BEISCSI_CMD_PER_LUN	128	/* scsi_host->cmd_per_lun */
-#define BEISCSI_MAX_SECTORS	256	/* scsi_host->max_sectors */
+#define BEISCSI_MAX_SECTORS	2048	/* scsi_host->max_sectors */
 
 #define BEISCSI_MAX_CMD_LEN	16	/* scsi_host->max_cmd_len */
 #define BEISCSI_NUM_MAX_LUN	256	/* scsi_host->max_lun */
@@ -77,7 +77,7 @@
 #define MAX_CMD_SZ			65536
 #define IIOC_SCSI_DATA                  0x05	/* Write Operation */
 
-#define DBG_LVL				0x00000001
+#define DBG_LVL				0x000000FF
 #define DBG_LVL_1			0x00000001
 #define DBG_LVL_2			0x00000002
 #define DBG_LVL_3			0x00000004
@@ -334,6 +334,7 @@ struct beiscsi_hba {
 	struct work_struct work_cqs;	/* The work being queued */
 	struct be_ctrl_info ctrl;
 	unsigned int generation;
+	unsigned int interface_handle;
 	struct invalidate_command_table inv_tbl[128];
 
 };
@@ -353,6 +354,7 @@ struct beiscsi_conn {
 	struct beiscsi_endpoint *ep;
 	unsigned short login_in_progress;
 	struct sgl_handle *plogin_sgl_handle;
+	struct wrb_handle *plogin_wrb_handle;
 	struct beiscsi_session *beiscsi_sess;
 	struct iscsi_task *task;
 };
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 72617b6..15f8203 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -20,6 +20,8 @@
 
 #include "be_mgmt.h"
 #include "be_iscsi.h"
+#include <scsi/scsi_transport_iscsi.h>
+#include <scsi/scsi_bsg_iscsi.h>
 
 unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				struct beiscsi_hba *phba)
@@ -112,11 +114,210 @@ unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 	spin_unlock(&ctrl->mbox_lock);
 	if (nonemb_cmd.va)
 		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
-				    nonemb_cmd.va, nonemb_cmd.dma);
+			    nonemb_cmd.va, nonemb_cmd.dma);
+
+	return status;
+}
+
+unsigned char mgmt_get_all_if_id(struct be_ctrl_info *ctrl,
+				struct beiscsi_hba *phba)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_all_if_id *req = embedded_payload(wrb);
+	struct be_all_if_id *pbe_allid = req;
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
 
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			   OPCODE_COMMON_ISCSI_NTWK_GET_ALL_IF_ID,
+			   sizeof(*req));
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+
+		phba->interface_handle = pbe_allid->if_hndl_list[0];
+	} else {
+		shost_printk(KERN_WARNING, phba->shost,
+			     "Failed in mgmt_get_all_if_id\n");
+	}
+	spin_unlock(&ctrl->mbox_lock);
 	return status;
 }
 
+int  mgmt_netcfg_fw_cmd(struct be_ctrl_info *ctrl,
+		 struct beiscsi_hba *phba,
+		 struct iscsi_bsg_job *job)
+{
+	struct be_dma_mem nonemb_cmd;
+	unsigned char *pdata;
+	int num, i, status = -EIO;
+	struct scatterlist *sge = NULL;
+	struct be_cmd_resp_hdr *resp;
+	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
+	struct be_cmd_req_hdr *phdr;
+	struct be_sge *mcc_sge = nonembedded_sgl(wrb);
+	struct iscsi_bsg_common_format *bsgdata;
+	struct be_modify_ip_addr *setip;
+	struct be_modify_default_gateway *setdefgw;
+	struct be_set_vlan *setvlan;
+	struct be_set_get_hba_name *sethbaname;
+	struct be_stateless_ip_addr *dhcp;
+	struct be_get_default_gateway_request *getdefgw;
+	struct be_get_if_info_request *getifinfo;
+	unsigned int tag = 0;
+
+	if (phba->interface_handle == 0xFFFFFFFF) {
+		if (mgmt_get_all_if_id(ctrl, phba)) {
+			shost_printk(KERN_WARNING, phba->shost,
+				"Did not get Interface ID \n");
+			return -EAGAIN;
+		}
+	}
+
+
+	nonemb_cmd.va = pci_alloc_consistent(ctrl->pdev,
+					     job->request_payload.size,
+					     &nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Failed to allocate memory for mgmt_netcfg_fw_cmd\n");
+		return -EIO;
+	}
+
+	phdr = nonemb_cmd.va;
+	nonemb_cmd.size = job->request_payload.size;
+	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
+	resp = nonemb_cmd.va;
+
+	bsgdata = (struct iscsi_bsg_common_format *)job->request_payload.va;
+	switch (job->request->rqst_data.h_netconfig.set_op) {
+	case ISCSI_SET_IP_ADDR:
+		be_cmd_hdr_prepare(phdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR,
+			sizeof(struct be_modify_ip_addr));
+		setip = nonemb_cmd.va;
+		setip->ip_params.record_entry_count = bsgdata->ip_params.
+						      record_entry_count;
+		for (i = 0; i < setip->ip_params.record_entry_count; i++) {
+			memcpy(&setip->ip_params.ip_record[i],
+				&bsgdata->ip_params.ip_record[i],
+				sizeof(struct iscsi_ip_addr_record));
+		}
+		break;
+
+	case ISCSI_SET_DEFAULT_GATEWAY:
+		be_cmd_hdr_prepare(phdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_NTWK_MODIFY_DEFAULT_GATEWAY,
+			sizeof(struct be_modify_default_gateway));
+		setdefgw = nonemb_cmd.va;
+		setdefgw->action =  bsgdata->action;
+		memcpy(&setdefgw->gateway, &bsgdata->gateway,
+			sizeof(struct ip_address_format));
+
+		break;
+
+	case ISCSI_SET_VLAN:
+		be_cmd_hdr_prepare(phdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_NTWK_SET_VLAN,
+			sizeof(struct be_set_vlan));
+		setvlan = nonemb_cmd.va;
+		setvlan->interface_hndl = bsgdata->interface_hndl;
+		setvlan->vlan_priority = bsgdata->vlan_priority;
+
+		break;
+
+	case ISCSI_SET_HBA_NAME:
+		be_cmd_hdr_prepare(phdr, CMD_SUBSYSTEM_ISCSI_INI,
+			OPCODE_ISCSI_INI_CFG_SET_HBA_NAME,
+			sizeof(struct be_set_get_hba_name));
+		sethbaname = nonemb_cmd.va;
+		sethbaname->flags = bsgdata->flags;
+		memcpy(&sethbaname->iscsiname, &bsgdata->iscsiname, 224);
+		memcpy(&sethbaname->iscsialias, &bsgdata->iscsialias, 32);
+		break;
+
+	case ISCSI_CONFIGURE_STATELESS_IP:
+		be_cmd_hdr_prepare(phdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_NTWK_CONFIGURE_STATELESS_IP_ADDR,
+			sizeof(struct be_stateless_ip_addr));
+		dhcp = nonemb_cmd.va;
+		dhcp->interface_hndl = bsgdata->interface_hndl;
+		dhcp->ip_type = bsgdata->ip_type;
+		dhcp->flags = bsgdata->flags;
+		dhcp->retry_count = bsgdata->retry_count;
+		break;
+
+	case ISCSI_GET_HBA_NAME:
+		be_cmd_hdr_prepare(phdr, CMD_SUBSYSTEM_ISCSI_INI,
+			OPCODE_ISCSI_INI_CFG_GET_HBA_NAME,
+			sizeof(struct be_set_get_hba_name));
+		sethbaname = nonemb_cmd.va;
+		sethbaname->flags = bsgdata->flags;
+		break;
+	case ISCSI_GET_IF_INFO:
+		be_cmd_hdr_prepare(phdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_NTWK_GET_IF_INFO,
+			sizeof(struct be_get_if_info_request));
+		getifinfo = nonemb_cmd.va;
+		getifinfo->interface_hndl = phba->interface_handle;
+		getifinfo->ip_type = bsgdata->ip_type;
+		break;
+	case ISCSI_GET_DEFAULT_GATEWAY:
+		be_cmd_hdr_prepare(phdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_NTWK_GET_DEFAULT_GATEWAY,
+			sizeof(struct be_get_default_gateway_request));
+		getdefgw = nonemb_cmd.va;
+		getdefgw->ip_type = bsgdata->ip_type;
+		break;
+	case ISCSI_GET_MAC_ADDRESS:
+	be_cmd_hdr_prepare(phdr, CMD_SUBSYSTEM_ISCSI,
+			   OPCODE_COMMON_ISCSI_NTWK_GET_NIC_CONFIG,
+			   sizeof(struct be_cmd_req_get_mac_addr));
+
+	default:
+		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
+				    nonemb_cmd.va, nonemb_cmd.dma);
+		return -EIO;
+	}
+
+	spin_lock(&ctrl->mbox_lock);
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		return tag;
+	}
+
+	memset(wrb, 0, sizeof(*wrb));
+	be_wrb_hdr_prepare(wrb, nonemb_cmd.size, false,
+			   job->request_payload.sg_cnt);
+	mcc_sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
+	mcc_sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
+	mcc_sge->len = cpu_to_le32(nonemb_cmd.size);
+	wrb->tag0 |= tag;
+
+	be_mcc_notify(phba);
+
+	pdata = nonemb_cmd.va;
+	for_each_sg(job->reply_payload.sg_list, sge,
+		    job->reply_payload.sg_cnt, num) {
+		if (sge->length) {
+			memcpy(sg_virt(sge), pdata, sge->length);
+			pdata += sge->length;
+		}
+	}
+
+	pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
+				    nonemb_cmd.va, nonemb_cmd.dma);
+
+	spin_unlock(&ctrl->mbox_lock);
+	job->reply->reply_payload_rcv_len = resp->response_length;
+	job->reply->result = status;
+	job->job_done(job);
+	return tag;
+ }
 
 unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 {
@@ -169,6 +370,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 		SE_DEBUG(DBG_LVL_1,
 			 "Failed to allocate memory for"
 			 "mgmt_invalidate_icds \n");
+		spin_unlock(&ctrl->mbox_lock);
 		return -1;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
@@ -277,6 +479,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	struct sockaddr_in6 *daddr_in6 = (struct sockaddr_in6 *)dst_addr;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct be_mcc_wrb *wrb;
+	struct be_dma_mem nonemb_cmd;
 	struct tcp_connect_and_offload_in *req;
 	unsigned short def_hdr_id;
 	unsigned short def_data_id;
@@ -285,6 +488,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	unsigned int tag = 0;
 	unsigned int i;
 	unsigned short cid = beiscsi_ep->ep_cid;
+	struct be_sge *sge;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
@@ -293,17 +497,34 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 
 	ptemplate_address = &template_address;
 	ISCSI_GET_PDU_TEMPLATE_ADDRESS(phba, ptemplate_address);
+
 	spin_lock(&ctrl->mbox_lock);
 	tag = alloc_mcc_tag(phba);
 	if (!tag) {
 		spin_unlock(&ctrl->mbox_lock);
 		return tag;
 	}
+
+	nonemb_cmd.va = pci_alloc_consistent(ctrl->pdev,
+				sizeof(struct tcp_connect_and_offload_in),
+				&nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Failed to allocate memory for mgmt_open_connection"
+			 "\n");
+		return -1;
+	}
+	nonemb_cmd.size = sizeof(struct tcp_connect_and_offload_in);
+
 	wrb = wrb_from_mccq(phba);
-	req = embedded_payload(wrb);
+	memset(wrb, 0, sizeof(*wrb));
+	sge = nonembedded_sgl(wrb);
+
+	req = nonemb_cmd.va;
+	memset(req, 0, sizeof(*req));
 	wrb->tag0 |= tag;
 
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
 			   OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD,
 			   sizeof(*req));
@@ -346,6 +567,9 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	req->do_offload = 1;
 	req->dataout_template_pa.lo = ptemplate_address->lo;
 	req->dataout_template_pa.hi = ptemplate_address->hi;
+	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
+	sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
+	sge->len = cpu_to_le32(nonemb_cmd.size);
 	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
 	return tag;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 3d316b8..ed878d1 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include "be_iscsi.h"
 #include "be_main.h"
+#include <scsi/scsi_bsg_iscsi.h>
 
 /**
  * Pseudo amap definition in which each bit of the actual structure is defined
@@ -202,6 +203,106 @@ struct be_mgmt_controller_attributes_resp {
 	struct mgmt_controller_attributes params;
 } __packed;
 
+/*
+struct ip_address_subnet_format {
+	u16 sizeofstructure;
+	u8  iptype;
+	u8  ipv6_prefix_length;
+	u8  ipaddress[16];
+	u8  subnetmask[16];
+	u32 rsvd0;
+} __packed;
+
+struct iscsi_ip_addr_record {
+	u32  action;
+	u32  interface_hndl;
+	struct ip_address_subnet_format ip_address;
+	u32  status;
+} __packed;
+
+struct iscsi_ip_addr_record_params {
+	u32 record_entry_count;
+	struct iscsi_ip_addr_record ip_record[1];
+} __packed;
+*/
+struct be_modify_ip_addr {
+	struct be_cmd_req_hdr hdr;
+	struct iscsi_ip_addr_record_params ip_params;
+} __packed;
+
+struct be_modify_default_gateway {
+	struct be_cmd_req_hdr hdr;
+	u32    action;
+	struct ip_address_format gateway;
+} __packed;
+
+struct be_set_vlan {
+	struct be_cmd_req_hdr hdr;
+	u32  interface_hndl;
+	u32  vlan_priority;
+} __packed;
+
+struct be_set_get_hba_name {
+	struct be_cmd_req_hdr hdr;
+	u16 flags;
+	u16 rsvd0;
+	u8  iscsiname[224];
+	u8  iscsialias[32];
+} __packed;
+
+struct be_stateless_ip_addr {
+	struct be_cmd_req_hdr hdr;
+	u32  interface_hndl;
+	u32  ip_type;
+	u32  flags;
+	u32  retry_count;
+} __packed;
+
+struct be_get_if_info_request {
+	struct be_cmd_req_hdr hdr;
+	u32 interface_hndl;
+	u32 ip_type;
+} __packed;
+
+struct be_get_if_info_response {
+	struct be_cmd_req_hdr hdr;
+	u32    interface_hndl;
+	u32    vlan_priority;
+	u32    ip_address_count;
+	u32    dhcp_state;
+	struct ip_address_subnet_format ip_address[1];
+} __packed;
+
+struct be_get_default_gateway_request {
+	struct be_cmd_req_hdr hdr;
+	u32    ip_type;
+} __packed;
+
+struct be_get_default_gateway_response {
+	struct be_cmd_req_hdr hdr;
+	struct ip_address_format gateway;
+} __packed;
+
+struct be_bsg_common_format {
+	u8 opcode;		/* dword 0 */
+	u8 subsystem;		/* dword 0 */
+	u8 port_number;		/* dword 0 */
+	u8 domain;		/* dword 0 */
+	u32 timeout;		/* dword 1 */
+	u32 request_length;	/* dword 2 */
+	u32 rsvd0;		/* dword 3 */
+	u32    action;
+	struct ip_address_format gateway;
+	u32  interface_hndl;
+	u32  vlan_priority;
+	u32  flags;
+	u8   iscsiname[224];
+	u8   iscsialias[32];
+	u32  ip_type;
+	u32  retry_count;
+	struct iscsi_ip_addr_record_params ip_params;
+} __packed;
+
 /* configuration management */
 
 #define GET_MGMT_CONTROLLER_WS(phba)    (phba->pmgmt_ws)
@@ -246,4 +347,10 @@ unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 unsigned short issue_reset,
 					 unsigned short savecfg_flag);
 
+unsigned char mgmt_get_all_if_id(struct be_ctrl_info *ctrl,
+				struct beiscsi_hba *phba);
+
+int  mgmt_netcfg_fw_cmd(struct be_ctrl_info *ctrl,
+		 struct beiscsi_hba *phba,
+		 struct iscsi_bsg_job *job);
 #endif
diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
index 10c91c3..2c85dd0 100644
--- a/include/scsi/scsi_bsg_iscsi.h
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -56,6 +56,7 @@
 #define ISCSI_GET_HBA_NAME		6
 #define ISCSI_GET_IF_INFO		7
 #define ISCSI_GET_DEFAULT_GATEWAY	8
+#define ISCSI_GET_MAC_ADDRESS           9
 
 /*
  * iSCSI Host Messages
-- 
1.6.4

