From: <jayamohan.kallickal@emulex.com>
Subject: [PATCH 1/2] be2iscsi: Adding shutdown routing
Date: Tue, 12 Jul 2011 10:12:34 -0700
Message-ID: <9f89710f-b612-4066-94a2-b44656c7d069@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:50430 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754177Ab1GLRNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 13:13:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

  This patch adds a  shutdown routine

Signed-off-by: Jayamohan Kallickal <jayamohan,kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    2 +-
 drivers/scsi/be2iscsi/be_main.c |   10 +
 drivers/scsi/be2iscsi/be_main.h |    1 +
 drivers/scsi/be2iscsi/tags      | 1588 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 1600 insertions(+), 1 deletions(-)
 create mode 100644 drivers/scsi/be2iscsi/tags

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index b8a82f2..7ef77c8 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -221,7 +221,7 @@ static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phba)
 	return NULL;
 }
 
-static void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
+void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
 {
 	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
 }
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0a9bdfa..97c134a 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4158,6 +4158,15 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	iscsi_host_free(phba->shost);
 }
 
+static void beiscsi_shutdown(struct pci_dev *pcidev)
+{
+	struct beiscsi_hba *phba = pci_get_drvdata(pcidev);
+	phba->state |= BE_ADAPTER_LINK_DOWN;
+	iscsi_host_for_each_session(phba->shost,
+				    be2iscsi_fail_session);
+	beiscsi_remove(pcidev);
+}
+
 static void beiscsi_msix_enable(struct beiscsi_hba *phba)
 {
 	int i, status;
@@ -4418,6 +4427,7 @@ static struct pci_driver beiscsi_pci_driver = {
 	.name = DRV_NAME,
 	.probe = beiscsi_dev_probe,
 	.remove = beiscsi_remove,
+	.shutdown= beiscsi_shutdown,
 	.id_table = beiscsi_pci_id_table
 };
 
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 081c171..4677de9 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -619,6 +619,7 @@ struct amap_cq_db {
 } __packed;
 
 void beiscsi_process_eq(struct beiscsi_hba *phba);
+void be2iscsi_fail_session(struct iscsi_cls_session *cls_session);
 
 struct iscsi_wrb {
 	u32 dw[16];
diff --git a/drivers/scsi/be2iscsi/tags b/drivers/scsi/be2iscsi/tags
new file mode 100644
index 0000000..2db2357
--- /dev/null
+++ b/drivers/scsi/be2iscsi/tags
@@ -0,0 +1,1588 @@
+!_TAG_FILE_FORMAT	2	/extended format; --format=1 will not append ;" to lines/
+!_TAG_FILE_SORTED	1	/0=unsorted, 1=sorted, 2=foldcase/
+!_TAG_PROGRAM_AUTHOR	Darren Hiebert	/dhiebert@users.sourceforge.net/
+!_TAG_PROGRAM_NAME	Exuberant Ctags	//
+!_TAG_PROGRAM_URL	http://ctags.sourceforge.net	/official site/
+!_TAG_PROGRAM_VERSION	5.8	//
+AMAP_BIT_OFFSET	be.h	140;"	d
+AMAP_GET_BITS	be.h	170;"	d
+AMAP_SET_BITS	be.h	157;"	d
+ASYNC_EVENT_CODE_LINK_STATE	be_cmds.h	104;"	d
+ASYNC_EVENT_LINK_DOWN	be_cmds.h	/^	ASYNC_EVENT_LINK_DOWN = 0x0,$/;"	e	enum:__anon2
+ASYNC_EVENT_LINK_UP	be_cmds.h	/^	ASYNC_EVENT_LINK_UP = 0x1$/;"	e	enum:__anon2
+ASYNC_TRAILER_EVENT_CODE_MASK	be_cmds.h	103;"	d
+ASYNC_TRAILER_EVENT_CODE_SHIFT	be_cmds.h	102;"	d
+BE2_CMDS_PER_CXN	be_main.h	54;"	d
+BE2_DEFPDU_DATA_SZ	be_main.h	59;"	d
+BE2_DEFPDU_HDR_SZ	be_main.h	58;"	d
+BE2_IO_DEPTH	be_main.h	52;"	d
+BE2_IPV4	be_iscsi.h	26;"	d
+BE2_IPV6	be_iscsi.h	27;"	d
+BE2_MAX_SESSIONS	be_main.h	53;"	d
+BE2_MPU_IRAM_ONLINE	be_main.h	79;"	d
+BE2_NOPOUT_REQ	be_main.h	56;"	d
+BE2_PCI_ONLINE0	be_main.h	76;"	d
+BE2_PCI_ONLINE1	be_main.h	77;"	d
+BE2_SET_RESET	be_main.h	78;"	d
+BE2_SGE	be_main.h	57;"	d
+BE2_SOFT_RESET	be_main.h	75;"	d
+BE2_TMFS	be_main.h	55;"	d
+BEISCSI_CMDS_H	be_cmds.h	19;"	d
+BEISCSI_CMD_PER_LUN	be_main.h	64;"	d
+BEISCSI_H	be.h	19;"	d
+BEISCSI_MAX_CMD_LEN	be_main.h	67;"	d
+BEISCSI_MAX_FRAGS_INIT	be_main.h	70;"	d
+BEISCSI_MAX_SECTORS	be_main.h	65;"	d
+BEISCSI_NUM_DEVICES_SUPPORTED	be_main.h	69;"	d
+BEISCSI_NUM_MAX_LUN	be_main.h	68;"	d
+BEISCSI_SGLIST_ELEMENTS	be_main.h	62;"	d
+BE_ADAPTER_LINK_DOWN	be_main.h	106;"	d
+BE_ADAPTER_UP	be_main.h	105;"	d
+BE_DEVICE_ID1	be_main.h	44;"	d
+BE_DEVICE_ID2	be_main.h	49;"	d
+BE_GEN2	be.h	29;"	d
+BE_GEN3	be.h	30;"	d
+BE_ISCSI_PDU_HEADER_SIZE	be_main.h	82;"	d
+BE_MIN_MEM_SIZE	be_main.h	83;"	d
+BE_NAME	be_main.h	38;"	d
+BE_NUMBER_OF_FIELD	be_cmds.h	863;"	d
+BE_NUM_MSIX_ENTRIES	be_main.h	71;"	d
+BE_SENSE_INFO_SIZE	be_main.h	81;"	d
+BE_VENDOR_ID	be_main.h	42;"	d
+BUILD_STR	be_main.h	37;"	d
+CEV_ISR0_OFFSET	be_main.h	126;"	d
+CEV_ISR_SIZE	be_main.h	127;"	d
+CMD_COMMON_TCP_UPLOAD	be_cmds.h	138;"	d
+CMD_CONNECTION_CHUTE_0	be_cmds.h	839;"	d
+CMD_CONNECTION_CHUTE_1	be_cmds.h	840;"	d
+CMD_CONNECTION_CHUTE_2	be_cmds.h	841;"	d
+CMD_CXN_KILLED_ICD_INVALID	be_cmds.h	961;"	d
+CMD_CXN_KILLED_INVALID_DATASN_RCVD	be_cmds.h	974;"	d
+CMD_CXN_KILLED_ITT_INVALID	be_cmds.h	966;"	d
+CMD_CXN_KILLED_LUN_INVALID	be_cmds.h	957;"	d
+CMD_CXN_KILLED_SEQ_OUTOFORDER	be_cmds.h	970;"	d
+CMD_INVALIDATED_NOTIFY	be_cmds.h	986;"	d
+CMD_ISCSI_COMMAND_INVALIDATE	be_cmds.h	813;"	d
+CMD_ISCSI_CONNECTION_INVALIDATE	be_cmds.h	814;"	d
+CMD_ISCSI_CONNECTION_ISSUE_TCP_RST	be_cmds.h	815;"	d
+CMD_ISCSI_SESSION_DEL_CFG_FROM_FLASH	be_cmds.h	845;"	d
+CMD_ISCSI_SESSION_SAVE_CFG_ON_FLASH	be_cmds.h	846;"	d
+CMD_KILLED_INVALID_R2T_RCVD	be_cmds.h	952;"	d
+CMD_KILLED_INVALID_STATSN_RCVD	be_cmds.h	948;"	d
+CMD_SUBSYSTEM_COMMON	be_cmds.h	134;"	d
+CMD_SUBSYSTEM_ETH	be_cmds.h	136;"	d
+CMD_SUBSYSTEM_ISCSI	be_cmds.h	135;"	d
+CMD_SUBSYSTEM_ISCSI_INI	be_cmds.h	137;"	d
+CONNECTION_UPLOAD_ABORT	be_cmds.h	854;"	d
+CONNECTION_UPLOAD_ABORT_RESET	be_cmds.h	851;"	d
+CONNECTION_UPLOAD_ABORT_WITH_SEQ	be_cmds.h	857;"	d
+CONNECTION_UPLOAD_GRACEFUL	be_cmds.h	850;"	d
+CQE_CID_MASK	be_main.h	582;"	d
+CQE_CODE_MASK	be_main.h	581;"	d
+CQE_FLAGS_ASYNC_MASK	be_cmds.h	49;"	d
+CQE_FLAGS_COMPLETED_MASK	be_cmds.h	50;"	d
+CQE_FLAGS_CONSUMED_MASK	be_cmds.h	51;"	d
+CQE_FLAGS_VALID_MASK	be_cmds.h	48;"	d
+CQE_STATUS_COMPL_MASK	be_cmds.h	56;"	d
+CQE_STATUS_COMPL_SHIFT	be_cmds.h	57;"	d
+CQE_STATUS_EXTD_MASK	be_cmds.h	58;"	d
+CQE_STATUS_EXTD_SHIFT	be_cmds.h	59;"	d
+CQE_VALID_MASK	be_main.h	580;"	d
+CXN_INVALIDATE_INDEX_NOTIFY	be_cmds.h	982;"	d
+CXN_INVALIDATE_NOTIFY	be_cmds.h	979;"	d
+CXN_KILLED_AHS_RCVD	be_cmds.h	888;"	d
+CXN_KILLED_BAD_UNSOL_PDU_RCVD	be_cmds.h	928;"	d
+CXN_KILLED_BAD_WRB_INDEX_ERROR	be_cmds.h	934;"	d
+CXN_KILLED_BURST_LEN_MISMATCH	be_cmds.h	883;"	d
+CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN	be_cmds.h	997;"	d
+CXN_KILLED_FIN_RCVD	be_cmds.h	924;"	d
+CXN_KILLED_HDR_DIGEST_ERR	be_cmds.h	892;"	d
+CXN_KILLED_IMM_DATA_RCVD	be_cmds.h	1010;"	d
+CXN_KILLED_INVALID_ITT_TTT_RCVD	be_cmds.h	906;"	d
+CXN_KILLED_OVER_RUN_RESIDUAL	be_cmds.h	938;"	d
+CXN_KILLED_PDU_SIZE_EXCEEDS_DSL	be_cmds.h	878;"	d
+CXN_KILLED_RST_RCVD	be_cmds.h	911;"	d
+CXN_KILLED_RST_SENT	be_cmds.h	920;"	d
+CXN_KILLED_STALE_ITT_TTT_RCVD	be_cmds.h	901;"	d
+CXN_KILLED_SYN_RCVD	be_cmds.h	1006;"	d
+CXN_KILLED_TIMED_OUT	be_cmds.h	915;"	d
+CXN_KILLED_UNDER_RUN_RESIDUAL	be_cmds.h	943;"	d
+CXN_KILLED_UNKNOWN_HDR	be_cmds.h	896;"	d
+DBG_LVL	be_main.h	87;"	d
+DBG_LVL_1	be_main.h	88;"	d
+DBG_LVL_2	be_main.h	89;"	d
+DBG_LVL_3	be_main.h	90;"	d
+DBG_LVL_4	be_main.h	91;"	d
+DBG_LVL_5	be_main.h	92;"	d
+DBG_LVL_6	be_main.h	93;"	d
+DBG_LVL_7	be_main.h	94;"	d
+DBG_LVL_8	be_main.h	95;"	d
+DB_CQ_NUM_POPPED_SHIFT	be_main.h	152;"	d
+DB_CQ_OFFSET	be_main.h	149;"	d
+DB_CQ_REARM_SHIFT	be_main.h	154;"	d
+DB_CQ_RING_ID_MASK	be_main.h	150;"	d
+DB_DEF_PDU_CQPROC_MASK	be_cmds.h	742;"	d
+DB_DEF_PDU_CQPROC_SHIFT	be_cmds.h	745;"	d
+DB_DEF_PDU_EVENT_SHIFT	be_cmds.h	744;"	d
+DB_DEF_PDU_NUM_POSTED_SHIFT	be_cmds.h	687;"	d
+DB_DEF_PDU_REARM_SHIFT	be_cmds.h	743;"	d
+DB_DEF_PDU_RING_ID_MASK	be_cmds.h	741;"	d
+DB_DEF_PDU_WRB_INDEX_MASK	be_cmds.h	684;"	d
+DB_DEF_PDU_WRB_INDEX_SHIFT	be_cmds.h	686;"	d
+DB_EQ_CLR_SHIFT	be_main.h	140;"	d
+DB_EQ_EVNT_SHIFT	be_main.h	142;"	d
+DB_EQ_NUM_POPPED_SHIFT	be_main.h	144;"	d
+DB_EQ_OFFSET	be_main.h	137;"	d
+DB_EQ_REARM_SHIFT	be_main.h	146;"	d
+DB_EQ_RING_ID_MASK	be_main.h	138;"	d
+DB_MCCQ_NUM_POSTED_SHIFT	be_cmds.h	93;"	d
+DB_MCCQ_OFFSET	be_cmds.h	90;"	d
+DB_MCCQ_RING_ID_MASK	be_cmds.h	91;"	d
+DB_RXULP0_OFFSET	be_main.h	135;"	d
+DB_TXULP0_OFFSET	be_main.h	134;"	d
+DB_WRB_POST_CID_MASK	be_cmds.h	683;"	d
+DRIVERMSG_NOTIFY	be_cmds.h	994;"	d
+DRV_DESC	be_main.h	40;"	d
+DRV_NAME	be_main.h	36;"	d
+EP_SEMAPHORE_POST_ERR_MASK	be_cmds.h	86;"	d
+EP_SEMAPHORE_POST_ERR_SHIFT	be_cmds.h	87;"	d
+EP_SEMAPHORE_POST_STAGE_MASK	be_cmds.h	85;"	d
+EQE_MAJORCODE_MASK	be_main.h	585;"	d
+EQE_RESID_MASK	be_main.h	586;"	d
+EQE_VALID_MASK	be_main.h	584;"	d
+EQ_MAJOR_CODE_COMPLETION	be_cmds.h	843;"	d
+ETH_ALEN	be_cmds.h	490;"	d
+FW_VER_LEN	be.h	24;"	d
+GET_HWI_CONTROLLER_WS	be_main.h	156;"	d
+GET_MGMT_CONTROLLER_WS	be_mgmt.h	209;"	d
+HWH_TYPE_INVALID	be_main.h	/^	HWH_TYPE_INVALID = 0xFFFFFFFF$/;"	e	enum:hwh_type_enum
+HWH_TYPE_IO	be_main.h	/^	HWH_TYPE_IO = 1,$/;"	e	enum:hwh_type_enum
+HWH_TYPE_IO_RD	be_main.h	/^	HWH_TYPE_IO_RD = 5,$/;"	e	enum:hwh_type_enum
+HWH_TYPE_LOGIN	be_main.h	/^	HWH_TYPE_LOGIN = 11,$/;"	e	enum:hwh_type_enum
+HWH_TYPE_LOGOUT	be_main.h	/^	HWH_TYPE_LOGOUT = 2,$/;"	e	enum:hwh_type_enum
+HWH_TYPE_NOP	be_main.h	/^	HWH_TYPE_NOP = 4,$/;"	e	enum:hwh_type_enum
+HWH_TYPE_TMF	be_main.h	/^	HWH_TYPE_TMF = 3,$/;"	e	enum:hwh_type_enum
+HWI_GET_ASYNC_PDU_CTX	be_main.h	112;"	d
+HWI_GET_DEF_BUFQ_ID	be_main.h	157;"	d
+HWI_GET_DEF_HDRQ_ID	be_main.h	159;"	d
+HWI_MEM_ADDN_CONTEXT	be_main.h	/^	HWI_MEM_ADDN_CONTEXT,$/;"	e	enum:be_mem_enum
+HWI_MEM_ASYNC_DATA_BUF	be_main.h	/^	HWI_MEM_ASYNC_DATA_BUF,$/;"	e	enum:be_mem_enum
+HWI_MEM_ASYNC_DATA_HANDLE	be_main.h	/^	HWI_MEM_ASYNC_DATA_HANDLE,	\/* 10 *\/$/;"	e	enum:be_mem_enum
+HWI_MEM_ASYNC_DATA_RING	be_main.h	/^	HWI_MEM_ASYNC_DATA_RING,$/;"	e	enum:be_mem_enum
+HWI_MEM_ASYNC_HEADER_BUF	be_main.h	/^	HWI_MEM_ASYNC_HEADER_BUF,	\/* 5 *\/$/;"	e	enum:be_mem_enum
+HWI_MEM_ASYNC_HEADER_HANDLE	be_main.h	/^	HWI_MEM_ASYNC_HEADER_HANDLE,$/;"	e	enum:be_mem_enum
+HWI_MEM_ASYNC_HEADER_RING	be_main.h	/^	HWI_MEM_ASYNC_HEADER_RING,$/;"	e	enum:be_mem_enum
+HWI_MEM_ASYNC_PDU_CONTEXT	be_main.h	/^	HWI_MEM_ASYNC_PDU_CONTEXT,$/;"	e	enum:be_mem_enum
+HWI_MEM_SGE	be_main.h	/^	HWI_MEM_SGE,$/;"	e	enum:be_mem_enum
+HWI_MEM_SGLH	be_main.h	/^	HWI_MEM_SGLH,$/;"	e	enum:be_mem_enum
+HWI_MEM_WRB	be_main.h	/^	HWI_MEM_WRB,$/;"	e	enum:be_mem_enum
+HWI_MEM_WRBH	be_main.h	/^	HWI_MEM_WRBH,$/;"	e	enum:be_mem_enum
+IIOC_SCSI_DATA	be_main.h	85;"	d
+INI_NOPOUT_CMD	be_cmds.h	819;"	d
+INI_RD_CMD	be_cmds.h	820;"	d
+INI_TMF_CMD	be_cmds.h	818;"	d
+INI_WR_CMD	be_cmds.h	817;"	d
+ISCSI_GET_PDU_TEMPLATE_ADDRESS	be_mgmt.h	221;"	d
+ISCSI_MEM_GLOBAL_HEADER	be_main.h	/^	ISCSI_MEM_GLOBAL_HEADER,$/;"	e	enum:be_mem_enum
+ISCSI_OPCODE_SCSI_DATA_OUT	be_cmds.h	799;"	d
+MAX_CMD_SZ	be_main.h	84;"	d
+MAX_CPUS	be_main.h	61;"	d
+MAX_INTR_RATE	be_cmds.c	480;"	d	file:
+MAX_MCC_CMD	be.h	27;"	d
+MCC_CQ_LEN	be.h	26;"	d
+MCC_Q_LEN	be.h	25;"	d
+MCC_STATUS_SUCCESS	be_cmds.h	54;"	d
+MCC_WRB_EMBEDDED_MASK	be_mgmt.h	78;"	d
+MCC_WRB_SGE_CNT_MASK	be_cmds.h	35;"	d
+MCC_WRB_SGE_CNT_SHIFT	be_cmds.h	34;"	d
+MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK	be_main.h	123;"	d
+MGMT_CMDH_FREE	be_mgmt.h	213;"	d
+MGMT_STATUS_FAILED	be_mgmt.h	218;"	d
+MGMT_STATUS_SUCCESS	be_mgmt.h	217;"	d
+MODULO	be.h	/^static inline u32 MODULO(u16 val, u16 limit)$/;"	f
+MPU_EP_CONTROL	be_main.h	73;"	d
+MPU_EP_SEMAPHORE	be_main.h	74;"	d
+MPU_EP_SEMAPHORE_OFFSET	be_cmds.h	84;"	d
+MPU_MAILBOX_DB_HI_MASK	be_cmds.h	81;"	d
+MPU_MAILBOX_DB_OFFSET	be_cmds.h	79;"	d
+MPU_MAILBOX_DB_RDY_MASK	be_cmds.h	80;"	d
+OC_DEVICE_ID1	be_main.h	45;"	d
+OC_DEVICE_ID2	be_main.h	46;"	d
+OC_DEVICE_ID3	be_main.h	50;"	d
+OFFLD_PARAMS_DDE	be_main.h	463;"	d
+OFFLD_PARAMS_ERL	be_main.h	462;"	d
+OFFLD_PARAMS_HDE	be_main.h	464;"	d
+OFFLD_PARAMS_IMD	be_main.h	466;"	d
+OFFLD_PARAMS_IR2T	be_main.h	465;"	d
+OFFSET_IN_PAGE	be.h	136;"	d
+OPCODE_COMMON_CQ_CREATE	be_cmds.h	144;"	d
+OPCODE_COMMON_CQ_DESTROY	be_cmds.h	152;"	d
+OPCODE_COMMON_EQ_CREATE	be_cmds.h	145;"	d
+OPCODE_COMMON_EQ_DESTROY	be_cmds.h	153;"	d
+OPCODE_COMMON_FIRMWARE_CONFIG	be_cmds.h	150;"	d
+OPCODE_COMMON_FUNCTION_RESET	be_cmds.h	155;"	d
+OPCODE_COMMON_GET_CNTL_ATTRIBUTES	be_cmds.h	147;"	d
+OPCODE_COMMON_GET_FW_VERSION	be_cmds.h	148;"	d
+OPCODE_COMMON_ISCSI_CFG_POST_SGL_PAGES	be_cmds.h	162;"	d
+OPCODE_COMMON_ISCSI_CFG_REMOVE_SGL_PAGES	be_cmds.h	163;"	d
+OPCODE_COMMON_ISCSI_CLEANUP	be_cmds.h	801;"	d
+OPCODE_COMMON_ISCSI_DEFQ_CREATE	be_cmds.h	173;"	d
+OPCODE_COMMON_ISCSI_DEFQ_DESTROY	be_cmds.h	174;"	d
+OPCODE_COMMON_ISCSI_ERROR_RECOVERY_INVALIDATE_COMMANDS	be_cmds.h	804;"	d
+OPCODE_COMMON_ISCSI_NTWK_CONFIGURE_STATELESS_IP_ADDR	be_cmds.h	166;"	d
+OPCODE_COMMON_ISCSI_NTWK_GET_ALL_IF_ID	be_cmds.h	170;"	d
+OPCODE_COMMON_ISCSI_NTWK_GET_DEFAULT_GATEWAY	be_cmds.h	168;"	d
+OPCODE_COMMON_ISCSI_NTWK_GET_IF_INFO	be_cmds.h	171;"	d
+OPCODE_COMMON_ISCSI_NTWK_GET_NIC_CONFIG	be_cmds.h	164;"	d
+OPCODE_COMMON_ISCSI_NTWK_MODIFY_DEFAULT_GATEWAY	be_cmds.h	169;"	d
+OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR	be_cmds.h	167;"	d
+OPCODE_COMMON_ISCSI_NTWK_SET_VLAN	be_cmds.h	165;"	d
+OPCODE_COMMON_ISCSI_SET_FRAGNUM_BITS_FOR_SGL_CRA	be_cmds.h	172;"	d
+OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD	be_cmds.h	803;"	d
+OPCODE_COMMON_ISCSI_WRBQ_CREATE	be_cmds.h	175;"	d
+OPCODE_COMMON_ISCSI_WRBQ_DESTROY	be_cmds.h	176;"	d
+OPCODE_COMMON_MCC_CREATE	be_cmds.h	146;"	d
+OPCODE_COMMON_MCC_DESTROY	be_cmds.h	151;"	d
+OPCODE_COMMON_MODIFY_EQ_DELAY	be_cmds.h	149;"	d
+OPCODE_COMMON_MODIFY_EQ_DELAY	be_cmds.h	800;"	d
+OPCODE_COMMON_QUERY_FIRMWARE_CONFIG	be_cmds.h	154;"	d
+OPCODE_COMMON_TCP_UPLOAD	be_cmds.h	802;"	d
+OPCODE_ISCSI_INI_BOOT_GET_BOOT_TARGET	be_cmds.h	810;"	d
+OPCODE_ISCSI_INI_CFG_GET_HBA_NAME	be_cmds.h	805;"	d
+OPCODE_ISCSI_INI_CFG_SET_HBA_NAME	be_cmds.h	806;"	d
+OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION	be_cmds.h	809;"	d
+OPCODE_ISCSI_INI_DRIVER_OFFLOAD_SESSION	be_cmds.h	808;"	d
+OPCODE_ISCSI_INI_SESSION_GET_A_SESSION	be_cmds.h	807;"	d
+PAGES_4K_SPANNED	be.h	131;"	d
+PAGES_REQUIRED	be_main.h	162;"	d
+PAGE_SHIFT_4K	be.h	126;"	d
+PAGE_SIZE_4K	be.h	127;"	d
+PCICFG_MEMBAR_CTRL_INT_CTRL_OFFSET	be_main.h	115;"	d
+PDUBASE_DATALENHI_MASK	be_main.h	707;"	d
+PDUBASE_DATALENLO_MASK	be_main.h	708;"	d
+PDUBASE_OPCODE_MASK	be_main.h	706;"	d
+PDUCQE_CODE_MASK	be_main.h	555;"	d
+PDUCQE_DPL_MASK	be_main.h	556;"	d
+PDUCQE_INDEX_MASK	be_main.h	557;"	d
+POST_STAGE_ARMFW_RDY	be_cmds.h	96;"	d
+QTYPE_CQ	be_cmds.h	/^	QTYPE_CQ,$/;"	e	enum:__anon3
+QTYPE_DPDUQ	be_cmds.h	/^	QTYPE_DPDUQ,$/;"	e	enum:__anon3
+QTYPE_EQ	be_cmds.h	/^	QTYPE_EQ = 1,$/;"	e	enum:__anon3
+QTYPE_MCCQ	be_cmds.h	/^	QTYPE_MCCQ,$/;"	e	enum:__anon3
+QTYPE_SGL	be_cmds.h	/^	QTYPE_SGL$/;"	e	enum:__anon3
+QTYPE_WRBQ	be_cmds.h	/^	QTYPE_WRBQ,$/;"	e	enum:__anon3
+SE_DEBUG	be_main.h	97;"	d
+SE_MEM_MAX	be_main.h	/^	SE_MEM_MAX$/;"	e	enum:be_mem_enum
+SOL_CID_MASK	be_cmds.h	629;"	d
+SOL_CMD_COMPLETE	be_cmds.h	871;"	d
+SOL_CMD_KILLED_DATA_DIGEST_ERR	be_cmds.h	874;"	d
+SOL_CMD_KILLED_DIF_ERR	be_cmds.h	1002;"	d
+SOL_CMD_WND_MASK	be_cmds.h	632;"	d
+SOL_CODE_MASK	be_cmds.h	630;"	d
+SOL_EXP_CMD_SN_MASK	be_cmds.h	634;"	d
+SOL_FLAGS_MASK	be_cmds.h	638;"	d
+SOL_HW_STS_MASK	be_cmds.h	635;"	d
+SOL_ICD_INDEX_MASK	be_cmds.h	660;"	d
+SOL_RESP_MASK	be_cmds.h	637;"	d
+SOL_RES_CNT_MASK	be_cmds.h	633;"	d
+SOL_STS_MASK	be_cmds.h	636;"	d
+SOL_S_MASK	be_cmds.h	639;"	d
+SOL_WRB_INDEX_MASK	be_cmds.h	631;"	d
+TGT_CTX_UPDT_CMD	be_cmds.h	823;"	d
+TGT_DATAIN_CMD	be_cmds.h	828;"	d
+TGT_DM_CMD	be_cmds.h	834;"	d
+TGT_SOS_PDU	be_cmds.h	831;"	d
+TGT_STS_CMD	be_cmds.h	824;"	d
+UNSOL_DATA_DIGEST_ERROR_NOTIFY	be_cmds.h	991;"	d
+UNSOL_DATA_NOTIFY	be_cmds.h	990;"	d
+UNSOL_HDR_NOTIFY	be_cmds.h	989;"	d
+WRB_TYPE_MASK	be_main.h	627;"	d
+_BEISCSI_MAIN_	be_main.h	21;"	d
+_BEISCSI_MGMT_	be_mgmt.h	21;"	d
+_BE_ISCSI_	be_iscsi.h	21;"	d
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:amap_be_default_pdu_context
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:amap_cq_context
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:amap_eq_context
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:amap_mcc_context
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:amap_sol_cqe
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:amap_sol_cqe_ring
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_all_if_id
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_async_event_link_state
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_req_cq_create
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_req_eq_create
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_req_get_boot_target
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_req_get_session
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_req_mac_query
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_req_mcast_mac_config
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_req_mcc_create
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_req_modify_eq_delay
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_req_q_destroy
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_resp_cq_create
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_resp_eq_create
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_resp_get_session
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_cmd_resp_mcc_create
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_default_pdu_context
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_defq_create_req
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_defq_create_resp
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_eq_delay_params_in
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_fw_cfg
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_mcc_wrb_context
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_post_sgl_pages_req
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_wrbq_create_req
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:be_wrbq_create_resp
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:dmsg_cqe
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:eq_delay
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:fragnum_bits_for_sgl_cra_in
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:ip_address_format
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:iscsi_cleanup_req
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:mac_addr
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:mgmt_auth_method_format
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:mgmt_chap_format
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:mgmt_conn_info
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:mgmt_conn_login_options
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:mgmt_session_info
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:mgmt_session_login_options
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:tcp_connect_and_offload_in
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:tcp_connect_and_offload_out
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:tcp_upload_params_in
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:struct:tcp_upload_params_out
+__packed	be_cmds.h	/^} __packed;$/;"	v	typeref:union:tcp_upload_params
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:amap_cq_db
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:amap_eq_entry
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:amap_i_t_dpdu_cqe
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:amap_iscsi_target_context_update_wrb
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:amap_iscsi_wrb
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:be_eq_entry
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:cq_db
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:i_t_dpdu_cqe
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:invalidate_command_table
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:iscsi_target_context_update_wrb
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:iscsi_wrb
+__packed	be_main.h	/^} __packed;$/;"	v	typeref:struct:pdu_base
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:amap_mcc_sge
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:amap_mcc_wrb_payload
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:be_mgmt_controller_attributes
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:be_mgmt_controller_attributes_resp
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:invalidate_commands_params_in
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:invalidate_commands_params_out
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:iscsi_invalidate_connection_params_in
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:iscsi_invalidate_connection_params_out
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:mcc_sge
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:mcc_wrb_payload
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:mgmt_controller_attributes
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:struct:mgmt_hba_attributes
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:union:invalidate_commands_params
+__packed	be_mgmt.h	/^} __packed;$/;"	v	typeref:union:iscsi_invalidate_connection_params
+a32	be_main.h	/^		struct be_bus_address32 a32;$/;"	m	union:be_bus_address::__anon5	typeref:struct:be_bus_address::__anon5::be_bus_address32
+a64	be_main.h	/^		struct be_bus_address64 a64;$/;"	m	union:be_bus_address::__anon5	typeref:struct:be_bus_address::__anon5::be_bus_address64
+actual_resp_len	be_cmds.h	/^	u32 actual_resp_len;	\/* dword 3 *\/$/;"	m	struct:be_cmd_resp_hdr
+addr	be_cmds.h	/^	u8 addr[ETH_ALEN];$/;"	m	struct:mac_addr
+addr_hi	be_main.h	/^	u8 addr_hi[32];$/;"	m	struct:amap_iscsi_sge
+addr_lo	be_main.h	/^	u8 addr_lo[32];$/;"	m	struct:amap_iscsi_sge
+address	be_main.h	/^	unsigned long long address;$/;"	m	struct:be_bus_address64
+address_hi	be_main.h	/^	unsigned int address_hi;$/;"	m	struct:be_bus_address32
+address_lo	be_main.h	/^	unsigned int address_lo;$/;"	m	struct:be_bus_address32
+age	be_main.h	/^	unsigned int age;$/;"	m	struct:beiscsi_hba
+ahs_length	be_main.h	/^	u8 ahs_length[8];	\/* length units is 4 byte words *\/$/;"	m	struct:amap_pdu_base
+ahs_length	be_main.h	/^	u8 ahs_length[8];	\/* no AHS *\/$/;"	m	struct:amap_pdu_data_out
+ahs_length	be_main.h	/^	u8 ahs_length[8];	\/* no AHS *\/$/;"	m	struct:amap_pdu_nop_out
+alignment_mask	be_main.h	/^	unsigned int alignment_mask;	\/* Alignment mask for this block *\/$/;"	m	struct:be_mem_descriptor
+alloc_index	be_main.h	/^	unsigned short alloc_index;$/;"	m	struct:hwi_wrb_context
+alloc_io_sgl_handle	be_main.c	/^static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)$/;"	f	file:
+alloc_mcc_tag	be_cmds.c	/^unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)$/;"	f
+alloc_mgmt_sgl_handle	be_main.c	/^static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)$/;"	f	file:
+alloc_wrb_handle	be_main.c	/^struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid)$/;"	f
+amap_be_default_pdu_context	be_cmds.h	/^struct amap_be_default_pdu_context {$/;"	s
+amap_beiscsi_offload_params	be_main.h	/^struct amap_beiscsi_offload_params {$/;"	s
+amap_cq_context	be_cmds.h	/^struct amap_cq_context {$/;"	s
+amap_cq_db	be_main.h	/^struct amap_cq_db {$/;"	s
+amap_eq_context	be_cmds.h	/^struct amap_eq_context {$/;"	s
+amap_eq_entry	be_main.h	/^struct amap_eq_entry {$/;"	s
+amap_get	be.h	/^static inline u32 amap_get(void *ptr, u32 dw_offset, u32 mask, u32 offset)$/;"	f
+amap_i_t_dpdu_cqe	be_main.h	/^struct amap_i_t_dpdu_cqe {$/;"	s
+amap_iscsi_sge	be_main.h	/^struct amap_iscsi_sge {$/;"	s
+amap_iscsi_target_context_update_wrb	be_main.h	/^struct amap_iscsi_target_context_update_wrb {$/;"	s
+amap_iscsi_wrb	be_main.h	/^struct amap_iscsi_wrb {$/;"	s
+amap_mask	be.h	/^static inline u32 amap_mask(u32 bitsize)$/;"	f
+amap_mcc_context	be_cmds.h	/^struct amap_mcc_context {$/;"	s
+amap_mcc_sge	be_mgmt.h	/^struct amap_mcc_sge {$/;"	s
+amap_mcc_wrb	be_mgmt.h	/^struct amap_mcc_wrb {$/;"	s
+amap_mcc_wrb_payload	be_mgmt.h	/^struct amap_mcc_wrb_payload {$/;"	s
+amap_pdu_base	be_main.h	/^struct amap_pdu_base {$/;"	s
+amap_pdu_data_out	be_main.h	/^struct amap_pdu_data_out {$/;"	s
+amap_pdu_nop_out	be_main.h	/^struct amap_pdu_nop_out {$/;"	s
+amap_set	be.h	/^static inline void amap_set(void *ptr, u32 dw_offset, u32 mask,$/;"	f
+amap_sol_cqe	be_cmds.h	/^struct amap_sol_cqe {$/;"	s
+amap_sol_cqe_ring	be_cmds.h	/^struct amap_sol_cqe_ring {$/;"	s
+armed	be_cmds.h	/^	u8 armed;		\/* dword 1 *\/$/;"	m	struct:amap_cq_context
+armed	be_cmds.h	/^	u8 armed;		\/* dword 1 *\/$/;"	m	struct:amap_eq_context
+asic_revision	be_cmds.h	/^	u32 asic_revision;$/;"	m	struct:be_fw_cfg
+asic_revision	be_main.h	/^	unsigned short asic_revision;$/;"	m	struct:beiscsi_hba
+asic_revision	be_mgmt.h	/^	u8 asic_revision;$/;"	m	struct:mgmt_hba_attributes
+async_data	be_main.h	/^	} async_data;$/;"	m	struct:hwi_async_pdu_context	typeref:struct:hwi_async_pdu_context::__anon9
+async_entry	be_main.h	/^	struct hwi_async_entry async_entry[BE2_MAX_SESSIONS * 2];$/;"	m	struct:hwi_async_pdu_context	typeref:struct:hwi_async_pdu_context::hwi_async_entry
+async_header	be_main.h	/^	} async_header;$/;"	m	struct:hwi_async_pdu_context	typeref:struct:hwi_async_pdu_context::__anon8
+async_pdu_handle	be_main.h	/^struct async_pdu_handle {$/;"	s
+asyncpdus_per_ctrl	be_main.h	/^	unsigned int asyncpdus_per_ctrl;$/;"	m	struct:hba_parameters
+auth_data	be_cmds.h	/^	struct	mgmt_auth_method_format auth_data;$/;"	m	struct:mgmt_conn_login_options	typeref:struct:mgmt_conn_login_options::mgmt_auth_method_format
+auth_method_type	be_cmds.h	/^	u8	auth_method_type;$/;"	m	struct:mgmt_auth_method_format
+avlbl_cids	be_main.h	/^		unsigned short avlbl_cids;$/;"	m	struct:beiscsi_hba::__anon6
+avlbl_cids	be_main.h	/^	unsigned short avlbl_cids;$/;"	m	struct:beiscsi_hba
+be2iscsi-y	Makefile	/^be2iscsi-y := be_iscsi.o be_main.o be_mgmt.o be_cmds.o$/;"	m
+be2iscsi_fail_session	be_cmds.c	/^static void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)$/;"	f	file:
+be_all_if_id	be_cmds.h	/^struct be_all_if_id {$/;"	s
+be_async_event_link_state	be_cmds.h	/^struct be_async_event_link_state {$/;"	s
+be_async_event_trailer	be_cmds.h	/^struct be_async_event_trailer {$/;"	s
+be_bus_address	be_main.h	/^struct be_bus_address {$/;"	s
+be_bus_address32	be_main.h	/^struct be_bus_address32 {$/;"	s
+be_bus_address64	be_main.h	/^struct be_bus_address64 {$/;"	s
+be_chk_reset_complete	be_cmds.c	/^int be_chk_reset_complete(struct beiscsi_hba *phba)$/;"	f
+be_cmd_bhs	be_main.h	/^struct be_cmd_bhs {$/;"	s
+be_cmd_create_default_pdu_queue	be_cmds.c	/^int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,$/;"	f
+be_cmd_fw_initialize	be_cmds.c	/^int be_cmd_fw_initialize(struct be_ctrl_info *ctrl)$/;"	f
+be_cmd_get_mac_addr	be_mgmt.c	/^unsigned int be_cmd_get_mac_addr(struct beiscsi_hba *phba)$/;"	f
+be_cmd_hdr_prepare	be_cmds.c	/^void be_cmd_hdr_prepare(struct be_cmd_req_hdr *req_hdr,$/;"	f
+be_cmd_iscsi_post_sgl_pages	be_cmds.c	/^int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,$/;"	f
+be_cmd_page_addrs_prepare	be_cmds.c	/^static void be_cmd_page_addrs_prepare(struct phys_addr *pages, u32 max_pages,$/;"	f	file:
+be_cmd_req_cq_create	be_cmds.h	/^struct be_cmd_req_cq_create {$/;"	s
+be_cmd_req_eq_create	be_cmds.h	/^struct be_cmd_req_eq_create {$/;"	s
+be_cmd_req_get_boot_target	be_cmds.h	/^struct be_cmd_req_get_boot_target {$/;"	s
+be_cmd_req_get_mac_addr	be_cmds.h	/^struct be_cmd_req_get_mac_addr {$/;"	s
+be_cmd_req_get_session	be_cmds.h	/^struct  be_cmd_req_get_session {$/;"	s
+be_cmd_req_hdr	be_cmds.h	/^struct be_cmd_req_hdr {$/;"	s
+be_cmd_req_mac_query	be_cmds.h	/^struct be_cmd_req_mac_query {$/;"	s
+be_cmd_req_mcast_mac_config	be_cmds.h	/^struct be_cmd_req_mcast_mac_config {$/;"	s
+be_cmd_req_mcc_create	be_cmds.h	/^struct be_cmd_req_mcc_create {$/;"	s
+be_cmd_req_modify_eq_delay	be_cmds.h	/^struct be_cmd_req_modify_eq_delay {$/;"	s
+be_cmd_req_q_destroy	be_cmds.h	/^struct be_cmd_req_q_destroy {$/;"	s
+be_cmd_resp_cq_create	be_cmds.h	/^struct be_cmd_resp_cq_create {$/;"	s
+be_cmd_resp_eq_create	be_cmds.h	/^struct be_cmd_resp_eq_create {$/;"	s
+be_cmd_resp_get_boot_target	be_cmds.h	/^struct be_cmd_resp_get_boot_target {$/;"	s
+be_cmd_resp_get_mac_addr	be_cmds.h	/^struct be_cmd_resp_get_mac_addr {$/;"	s
+be_cmd_resp_get_session	be_cmds.h	/^struct  be_cmd_resp_get_session {$/;"	s
+be_cmd_resp_hdr	be_cmds.h	/^struct be_cmd_resp_hdr {$/;"	s
+be_cmd_resp_mac_query	be_cmds.h	/^struct be_cmd_resp_mac_query {$/;"	s
+be_cmd_resp_mcc_create	be_cmds.h	/^struct be_cmd_resp_mcc_create {$/;"	s
+be_cmd_wrbq_create	be_cmds.c	/^int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,$/;"	f
+be_complete_io	be_main.c	/^be_complete_io(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+be_complete_logout	be_main.c	/^be_complete_logout(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+be_complete_nopin_resp	be_main.c	/^be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+be_complete_tmf	be_main.c	/^be_complete_tmf(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+be_config_number	be_cmds.h	/^	u32 be_config_number;$/;"	m	struct:be_fw_cfg
+be_cq	be_main.h	/^	struct be_queue_info be_cq[MAX_CPUS];$/;"	m	struct:hwi_context_memory	typeref:struct:hwi_context_memory::be_queue_info
+be_ctrl_info	be.h	/^struct be_ctrl_info {$/;"	s
+be_ctrl_init	be_main.c	/^static int be_ctrl_init(struct beiscsi_hba *phba, struct pci_dev *pdev)$/;"	f	file:
+be_def_dataq	be_main.h	/^	struct be_queue_info be_def_dataq;$/;"	m	struct:hwi_context_memory	typeref:struct:hwi_context_memory::be_queue_info
+be_def_hdrq	be_main.h	/^	struct be_queue_info be_def_hdrq;$/;"	m	struct:hwi_context_memory	typeref:struct:hwi_context_memory::be_queue_info
+be_default_pdu_context	be_cmds.h	/^struct be_default_pdu_context {$/;"	s
+be_defq_create_req	be_cmds.h	/^struct be_defq_create_req {$/;"	s
+be_defq_create_resp	be_cmds.h	/^struct be_defq_create_resp {$/;"	s
+be_dma_mem	be.h	/^struct be_dma_mem {$/;"	s
+be_dws_cpu_to_le	be.h	176;"	d
+be_dws_le_to_cpu	be.h	177;"	d
+be_encoded_q_len	be_cmds.c	/^static u32 be_encoded_q_len(int q_len)$/;"	f	file:
+be_eq	be_main.h	/^	struct be_eq_obj be_eq[MAX_CPUS];$/;"	m	struct:hwi_context_memory	typeref:struct:hwi_context_memory::be_eq_obj
+be_eq_delay_params_in	be_cmds.h	/^struct be_eq_delay_params_in {$/;"	s
+be_eq_entry	be_main.h	/^struct be_eq_entry {$/;"	s
+be_eq_obj	be.h	/^struct be_eq_obj {$/;"	s
+be_fill_queue	be_main.c	/^static int be_fill_queue(struct be_queue_info *q,$/;"	f	file:
+be_fw_cfg	be_cmds.h	/^struct be_fw_cfg {$/;"	s
+be_iopoll	be_main.c	/^static int be_iopoll(struct blk_iopoll *iop, int budget)$/;"	f	file:
+be_iopoll_budget	be_main.c	/^static unsigned int be_iopoll_budget = 10;$/;"	v	file:
+be_isr	be_main.c	/^static irqreturn_t be_isr(int irq, void *dev_id)$/;"	f	file:
+be_isr_mcc	be_main.c	/^static irqreturn_t be_isr_mcc(int irq, void *dev_id)$/;"	f	file:
+be_isr_msix	be_main.c	/^static irqreturn_t be_isr_msix(int irq, void *dev_id)$/;"	f	file:
+be_max_phys_size	be_main.c	/^static unsigned int be_max_phys_size = 64;$/;"	v	file:
+be_mbox_db_ready_wait	be_cmds.c	/^static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)$/;"	f	file:
+be_mbox_notify	be_cmds.c	/^int be_mbox_notify(struct be_ctrl_info *ctrl)$/;"	f
+be_mbox_notify_wait	be_cmds.c	/^static int be_mbox_notify_wait(struct beiscsi_hba *phba)$/;"	f	file:
+be_mcc_compl	be_cmds.h	/^struct be_mcc_compl {$/;"	s
+be_mcc_compl_get	be_cmds.c	/^static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phba)$/;"	f	file:
+be_mcc_compl_is_new	be_cmds.c	/^static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)$/;"	f	file:
+be_mcc_compl_process	be_cmds.c	/^static int be_mcc_compl_process(struct be_ctrl_info *ctrl,$/;"	f	file:
+be_mcc_compl_process_isr	be_cmds.c	/^int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,$/;"	f
+be_mcc_compl_use	be_cmds.c	/^static inline void be_mcc_compl_use(struct be_mcc_compl *compl)$/;"	f	file:
+be_mcc_mailbox	be_cmds.h	/^struct be_mcc_mailbox {$/;"	s
+be_mcc_notify	be_cmds.c	/^void be_mcc_notify(struct beiscsi_hba *phba)$/;"	f
+be_mcc_notify_wait	be_cmds.c	/^int be_mcc_notify_wait(struct beiscsi_hba *phba)$/;"	f
+be_mcc_obj	be.h	/^struct be_mcc_obj {$/;"	s
+be_mcc_queues_create	be_main.c	/^static int be_mcc_queues_create(struct beiscsi_hba *phba,$/;"	f	file:
+be_mcc_queues_destroy	be_main.c	/^static void be_mcc_queues_destroy(struct beiscsi_hba *phba)$/;"	f	file:
+be_mcc_wait_compl	be_cmds.c	/^static int be_mcc_wait_compl(struct beiscsi_hba *phba)$/;"	f	file:
+be_mcc_wrb	be_cmds.h	/^struct be_mcc_wrb {$/;"	s
+be_mcc_wrb_context	be_cmds.h	/^struct be_mcc_wrb_context {$/;"	s
+be_mem_descriptor	be_main.h	/^struct be_mem_descriptor {$/;"	s
+be_mem_enum	be_main.h	/^enum be_mem_enum {$/;"	g
+be_mgmt_controller_attributes	be_mgmt.h	/^struct be_mgmt_controller_attributes {$/;"	s
+be_mgmt_controller_attributes_resp	be_mgmt.h	/^struct be_mgmt_controller_attributes_resp {$/;"	s
+be_nonio_bhs	be_main.h	/^struct be_nonio_bhs {$/;"	s
+be_post_sgl_pages_req	be_cmds.h	/^struct be_post_sgl_pages_req {$/;"	s
+be_queue_alloc	be_main.c	/^static int be_queue_alloc(struct beiscsi_hba *phba, struct be_queue_info *q,$/;"	f	file:
+be_queue_free	be_main.c	/^static void be_queue_free(struct beiscsi_hba *phba, struct be_queue_info *q)$/;"	f	file:
+be_queue_info	be.h	/^struct be_queue_info {$/;"	s
+be_ring	be_main.h	/^struct be_ring {$/;"	s
+be_sge	be_cmds.h	/^struct be_sge {$/;"	s
+be_sgl_create_contiguous	be_main.c	/^be_sgl_create_contiguous(void *virtual_address,$/;"	f	file:
+be_sgl_destroy_contiguous	be_main.c	/^static void be_sgl_destroy_contiguous(struct be_dma_mem *sgl)$/;"	f	file:
+be_status_bhs	be_main.h	/^struct be_status_bhs {$/;"	s
+be_ulp_fw_cfg	be_cmds.h	/^struct be_ulp_fw_cfg {$/;"	s
+be_wrb_hdr_prepare	be_cmds.c	/^void be_wrb_hdr_prepare(struct be_mcc_wrb *wrb, int payload_len,$/;"	f
+be_wrbq	be_main.h	/^	struct be_queue_info be_wrbq[BE2_MAX_SESSIONS];$/;"	m	struct:hwi_context_memory	typeref:struct:hwi_context_memory::be_queue_info
+be_wrbq_create_req	be_cmds.h	/^struct be_wrbq_create_req {$/;"	s
+be_wrbq_create_resp	be_cmds.h	/^struct be_wrbq_create_resp {$/;"	s
+beiscsi_alloc_mem	be_main.c	/^static int beiscsi_alloc_mem(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_alloc_pdu	be_main.c	/^static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)$/;"	f	file:
+beiscsi_async_link_state_process	be_cmds.c	/^void beiscsi_async_link_state_process(struct beiscsi_hba *phba,$/;"	f
+beiscsi_bindconn_cid	be_iscsi.c	/^static int beiscsi_bindconn_cid(struct beiscsi_hba *phba,$/;"	f	file:
+beiscsi_clean_port	be_main.c	/^static void beiscsi_clean_port(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_cleanup_task	be_main.c	/^static void beiscsi_cleanup_task(struct iscsi_task *task)$/;"	f	file:
+beiscsi_close_conn	be_iscsi.c	/^static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)$/;"	f	file:
+beiscsi_cmd_cq_create	be_cmds.c	/^int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,$/;"	f
+beiscsi_cmd_eq_create	be_cmds.c	/^int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,$/;"	f
+beiscsi_cmd_mccq_create	be_cmds.c	/^int beiscsi_cmd_mccq_create(struct beiscsi_hba *phba,$/;"	f
+beiscsi_cmd_q_destroy	be_cmds.c	/^int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,$/;"	f
+beiscsi_conn	be_main.h	/^struct beiscsi_conn {$/;"	s
+beiscsi_conn_bind	be_iscsi.c	/^int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,$/;"	f
+beiscsi_conn_cid	be_main.h	/^	u32 beiscsi_conn_cid;$/;"	m	struct:beiscsi_conn
+beiscsi_conn_create	be_iscsi.c	/^beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)$/;"	f
+beiscsi_conn_get_stats	be_iscsi.c	/^void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,$/;"	f
+beiscsi_conn_start	be_iscsi.c	/^int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)$/;"	f
+beiscsi_cq_notify	be_cmds.c	/^static void beiscsi_cq_notify(struct beiscsi_hba *phba, u16 qid, bool arm,$/;"	f	file:
+beiscsi_create_cqs	be_main.c	/^static int beiscsi_create_cqs(struct beiscsi_hba *phba,$/;"	f	file:
+beiscsi_create_def_data	be_main.c	/^beiscsi_create_def_data(struct beiscsi_hba *phba,$/;"	f	file:
+beiscsi_create_def_hdr	be_main.c	/^beiscsi_create_def_hdr(struct beiscsi_hba *phba,$/;"	f	file:
+beiscsi_create_eqs	be_main.c	/^static int beiscsi_create_eqs(struct beiscsi_hba *phba,$/;"	f	file:
+beiscsi_create_wrb_rings	be_main.c	/^beiscsi_create_wrb_rings(struct beiscsi_hba *phba,$/;"	f	file:
+beiscsi_dev_probe	be_main.c	/^static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,$/;"	f	file:
+beiscsi_eh_abort	be_main.c	/^static int beiscsi_eh_abort(struct scsi_cmnd *sc)$/;"	f	file:
+beiscsi_eh_device_reset	be_main.c	/^static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)$/;"	f	file:
+beiscsi_enable_pci	be_main.c	/^static int beiscsi_enable_pci(struct pci_dev *pcidev)$/;"	f	file:
+beiscsi_endpoint	be_mgmt.h	/^struct beiscsi_endpoint {$/;"	s
+beiscsi_ep_connect	be_iscsi.c	/^beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,$/;"	f
+beiscsi_ep_disconnect	be_iscsi.c	/^void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)$/;"	f
+beiscsi_ep_get_param	be_iscsi.c	/^int beiscsi_ep_get_param(struct iscsi_endpoint *ep,$/;"	f
+beiscsi_ep_poll	be_iscsi.c	/^int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)$/;"	f
+beiscsi_eth_get_attr_visibility	be_main.c	/^static mode_t beiscsi_eth_get_attr_visibility(void *data, int type)$/;"	f	file:
+beiscsi_find_mem_req	be_main.c	/^static void beiscsi_find_mem_req(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_free_ep	be_iscsi.c	/^static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)$/;"	f	file:
+beiscsi_free_mem	be_main.c	/^static void beiscsi_free_mem(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_get_boot_info	be_main.c	/^static int beiscsi_get_boot_info(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_get_boot_target	be_mgmt.c	/^unsigned int beiscsi_get_boot_target(struct beiscsi_hba *phba)$/;"	f
+beiscsi_get_cid	be_iscsi.c	/^static int beiscsi_get_cid(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_get_host_param	be_iscsi.c	/^int beiscsi_get_host_param(struct Scsi_Host *shost,$/;"	f
+beiscsi_get_macaddr	be_iscsi.c	/^int beiscsi_get_macaddr(char *buf, struct beiscsi_hba *phba)$/;"	f
+beiscsi_get_memory	be_main.c	/^static int beiscsi_get_memory(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_get_params	be_main.c	/^static void beiscsi_get_params(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_get_session_info	be_mgmt.c	/^unsigned int beiscsi_get_session_info(struct beiscsi_hba *phba,$/;"	f
+beiscsi_hba	be_main.h	/^struct beiscsi_hba {$/;"	s
+beiscsi_hba_alloc	be_main.c	/^static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)$/;"	f	file:
+beiscsi_ini_get_attr_visibility	be_main.c	/^static mode_t beiscsi_ini_get_attr_visibility(void *data, int type)$/;"	f	file:
+beiscsi_init_controller	be_main.c	/^static int beiscsi_init_controller(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_init_irqs	be_main.c	/^static int beiscsi_init_irqs(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_init_port	be_main.c	/^static int beiscsi_init_port(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_init_sgl_handle	be_main.c	/^static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_init_wrb_handle	be_main.c	/^static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_io_task	be_main.h	/^struct beiscsi_io_task {$/;"	s
+beiscsi_iotask	be_main.c	/^static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,$/;"	f	file:
+beiscsi_iscsi_transport	be_main.c	/^struct iscsi_transport beiscsi_iscsi_transport = {$/;"	v	typeref:struct:iscsi_transport
+beiscsi_map_pci_bars	be_main.c	/^static int beiscsi_map_pci_bars(struct beiscsi_hba *phba,$/;"	f	file:
+beiscsi_module_exit	be_main.c	/^module_exit(beiscsi_module_exit);$/;"	v
+beiscsi_module_exit	be_main.c	/^static void __exit beiscsi_module_exit(void)$/;"	f	file:
+beiscsi_module_init	be_main.c	/^module_init(beiscsi_module_init);$/;"	v
+beiscsi_module_init	be_main.c	/^static int __init beiscsi_module_init(void)$/;"	f	file:
+beiscsi_msix_enable	be_main.c	/^static void beiscsi_msix_enable(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_mtask	be_main.c	/^static int beiscsi_mtask(struct iscsi_task *task)$/;"	f	file:
+beiscsi_offload_connection	be_main.c	/^beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,$/;"	f
+beiscsi_offload_params	be_main.h	/^struct beiscsi_offload_params {$/;"	s
+beiscsi_open_conn	be_iscsi.c	/^static int beiscsi_open_conn(struct iscsi_endpoint *ep,$/;"	f	file:
+beiscsi_parse_pdu	be_main.c	/^static void beiscsi_parse_pdu(struct iscsi_conn *conn, itt_t itt,$/;"	f	file:
+beiscsi_pci_driver	be_main.c	/^static struct pci_driver beiscsi_pci_driver = {$/;"	v	typeref:struct:pci_driver	file:
+beiscsi_pci_id_table	be_main.c	/^static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {$/;"	v	file:
+beiscsi_pci_soft_reset	be_cmds.c	/^int beiscsi_pci_soft_reset(struct beiscsi_hba *phba)$/;"	f
+beiscsi_post_pages	be_main.c	/^beiscsi_post_pages(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_process_all_cqs	be_main.c	/^void beiscsi_process_all_cqs(struct work_struct *work)$/;"	f
+beiscsi_process_async_pdu	be_main.c	/^beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+beiscsi_process_cq	be_main.c	/^static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)$/;"	f	file:
+beiscsi_process_mcc	be_cmds.c	/^int beiscsi_process_mcc(struct beiscsi_hba *phba)$/;"	f
+beiscsi_process_mcc_isr	be_main.c	/^static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_put_cid	be_iscsi.c	/^static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)$/;"	f	file:
+beiscsi_remove	be_main.c	/^static void beiscsi_remove(struct pci_dev *pcidev)$/;"	f	file:
+beiscsi_scsi_transport	be_main.c	/^static struct scsi_transport_template *beiscsi_scsi_transport;$/;"	v	typeref:struct:scsi_transport_template	file:
+beiscsi_sess	be_main.h	/^	struct beiscsi_session *beiscsi_sess;$/;"	m	struct:beiscsi_conn	typeref:struct:beiscsi_conn::beiscsi_session
+beiscsi_session	be_main.h	/^struct beiscsi_session {$/;"	s
+beiscsi_session_create	be_iscsi.c	/^struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,$/;"	f
+beiscsi_session_destroy	be_iscsi.c	/^void beiscsi_session_destroy(struct iscsi_cls_session *cls_session)$/;"	f
+beiscsi_set_param	be_iscsi.c	/^int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,$/;"	f
+beiscsi_set_params_for_offld	be_iscsi.c	/^static void  beiscsi_set_params_for_offld(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+beiscsi_setup_boot_info	be_main.c	/^static int beiscsi_setup_boot_info(struct beiscsi_hba *phba)$/;"	f	file:
+beiscsi_show_boot_eth_info	be_main.c	/^static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char *buf)$/;"	f	file:
+beiscsi_show_boot_ini_info	be_main.c	/^static ssize_t beiscsi_show_boot_ini_info(void *data, int type, char *buf)$/;"	f	file:
+beiscsi_show_boot_tgt_info	be_main.c	/^static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)$/;"	f	file:
+beiscsi_sht	be_main.c	/^static struct scsi_host_template beiscsi_sht = {$/;"	v	typeref:struct:scsi_host_template	file:
+beiscsi_slave_configure	be_main.c	/^static int beiscsi_slave_configure(struct scsi_device *sdev)$/;"	f	file:
+beiscsi_task_xmit	be_main.c	/^static int beiscsi_task_xmit(struct iscsi_task *task)$/;"	f	file:
+beiscsi_tgt_get_attr_visibility	be_main.c	/^static mode_t beiscsi_tgt_get_attr_visibility(void *data, int type)$/;"	f	file:
+beiscsi_unbind_conn_to_cid	be_iscsi.c	/^static int beiscsi_unbind_conn_to_cid(struct beiscsi_hba *phba,$/;"	f	file:
+beiscsi_unmap_pci_function	be_main.c	/^static void beiscsi_unmap_pci_function(struct beiscsi_hba *phba)$/;"	f	file:
+bhs_len	be_main.h	/^	unsigned short bhs_len;$/;"	m	struct:beiscsi_io_task
+bhs_pa	be_main.h	/^	struct be_bus_address bhs_pa;$/;"	m	struct:beiscsi_io_task	typeref:struct:beiscsi_io_task::be_bus_address
+bhs_pool	be_main.h	/^	struct pci_pool *bhs_pool;$/;"	m	struct:beiscsi_session	typeref:struct:beiscsi_session::pci_pool
+bios_version_string	be_mgmt.h	/^	u8 bios_version_string[32];$/;"	m	struct:mgmt_hba_attributes
+boot_kset	be_main.h	/^	struct iscsi_boot_kset *boot_kset;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::iscsi_boot_kset
+boot_sess	be_main.h	/^	struct mgmt_session_info boot_sess;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::mgmt_session_info
+boot_session_count	be_cmds.h	/^	u32  boot_session_count;$/;"	m	struct:be_cmd_resp_get_boot_target
+boot_session_handle	be_cmds.h	/^	int  boot_session_handle;$/;"	m	struct:be_cmd_resp_get_boot_target
+buffer_len	be_main.h	/^	unsigned long buffer_len;$/;"	m	struct:async_pdu_handle
+buffer_offset	be_main.h	/^	u8 buffer_offset[32];$/;"	m	struct:amap_pdu_data_out
+buffer_size	be_main.h	/^		unsigned int buffer_size;$/;"	m	struct:hwi_async_pdu_context::__anon8
+buffer_size	be_main.h	/^		unsigned int buffer_size;$/;"	m	struct:hwi_async_pdu_context::__anon9
+bus_address	be_main.h	/^	struct be_bus_address bus_address;	\/* Bus address of location *\/$/;"	m	struct:mem_array	typeref:struct:mem_array::be_bus_address
+busy_entries	be_main.h	/^		unsigned int busy_entries;$/;"	m	struct:hwi_async_pdu_context::__anon8
+busy_entries	be_main.h	/^		unsigned int busy_entries;$/;"	m	struct:hwi_async_pdu_context::__anon9
+bypass_flush	be_cmds.h	/^	u16 bypass_flush;	\/* valid only for rx q destroy *\/$/;"	m	struct:be_cmd_req_q_destroy
+byte	be_cmds.h	/^	u8 byte[ETH_ALEN];$/;"	m	struct:macaddr
+bytes_needed	be_main.h	/^		unsigned int bytes_needed;$/;"	m	struct:hwi_async_entry::__anon7
+bytes_received	be_main.h	/^		unsigned short bytes_received;$/;"	m	struct:hwi_async_entry::__anon7
+cache_valid	be_mgmt.h	/^	u8 cache_valid;$/;"	m	struct:mgmt_hba_attributes
+category	be_main.h	/^	unsigned int category;	\/* type indicates cached\/non-cached *\/$/;"	m	struct:be_mem_descriptor
+chap	be_cmds.h	/^	struct	mgmt_chap_format chap;$/;"	m	struct:mgmt_auth_method_format	typeref:struct:mgmt_auth_method_format::mgmt_chap_format
+chute	be_cmds.h	/^	u16 chute;$/;"	m	struct:iscsi_cleanup_req
+cid	be_cmds.h	/^	u16	cid;$/;"	m	struct:mgmt_conn_info
+cid	be_cmds.h	/^	u16 cid;$/;"	m	struct:be_wrbq_create_resp
+cid	be_cmds.h	/^	u16 cid;$/;"	m	struct:tcp_connect_and_offload_in
+cid	be_cmds.h	/^	u16 cid;$/;"	m	struct:tcp_connect_and_offload_out
+cid	be_cmds.h	/^	u8 cid[10];		\/* dword 2 *\/$/;"	m	struct:amap_sol_cqe
+cid	be_main.h	/^	u8 cid[10];$/;"	m	struct:amap_i_t_dpdu_cqe
+cid	be_main.h	/^	unsigned int cid;$/;"	m	struct:sgl_handle
+cid	be_main.h	/^	unsigned short cid;$/;"	m	struct:beiscsi_io_task
+cid	be_main.h	/^	unsigned short cid;$/;"	m	struct:hwi_wrb_context
+cid	be_main.h	/^	unsigned short cid;$/;"	m	struct:invalidate_command_table
+cid	be_mgmt.h	/^	unsigned short cid;$/;"	m	struct:iscsi_invalidate_connection_params_in
+cid	be_mgmt.h	/^	unsigned short cid;$/;"	m	struct:iscsi_invalidate_connection_params_out
+cid_alloc	be_main.h	/^		unsigned short cid_alloc;$/;"	m	struct:beiscsi_hba::__anon6
+cid_alloc	be_main.h	/^	unsigned short cid_alloc;$/;"	m	struct:beiscsi_hba
+cid_array	be_main.h	/^	unsigned short *cid_array;$/;"	m	struct:beiscsi_hba
+cid_free	be_main.h	/^		unsigned short cid_free;$/;"	m	struct:beiscsi_hba::__anon6
+cid_free	be_main.h	/^	unsigned short cid_free;$/;"	m	struct:beiscsi_hba
+cid_lock	be_main.h	/^		spinlock_t cid_lock;$/;"	m	struct:beiscsi_hba::__anon6
+cid_vld	be_mgmt.h	/^	u16 cid_vld;$/;"	m	struct:beiscsi_endpoint
+cidx	be_cmds.h	/^	u8 cidx[11];		\/* dword 0 *\/$/;"	m	struct:amap_cq_context
+cidx	be_cmds.h	/^	u8 cidx[13];		\/* dword 0 *\/$/;"	m	struct:amap_eq_context
+cidx	be_main.h	/^	u32 cidx;		\/* consumer index *\/$/;"	m	struct:be_ring
+cleanup_type	be_mgmt.h	/^	unsigned short cleanup_type;$/;"	m	struct:invalidate_commands_params_in
+cleanup_type	be_mgmt.h	/^	unsigned short cleanup_type;$/;"	m	struct:iscsi_invalidate_connection_params_in
+cmd_bhs	be_main.h	/^	struct be_cmd_bhs *cmd_bhs;$/;"	m	struct:beiscsi_io_task	typeref:struct:beiscsi_io_task::be_cmd_bhs
+cmd_sn	be_main.h	/^	u8 cmd_sn[32];$/;"	m	struct:amap_pdu_nop_out
+cmd_sn	be_main.h	/^	unsigned int cmd_sn;$/;"	m	struct:beiscsi_io_task
+cmdsn_itt	be_main.h	/^	u8 cmdsn_itt[32];	\/* DWORD 6 *\/$/;"	m	struct:amap_iscsi_wrb
+coalescwm	be_cmds.h	/^	u8 coalescwm[2];	\/* dword 0 *\/$/;"	m	struct:amap_cq_context
+code	be_cmds.h	/^	u32 code;$/;"	m	struct:be_async_event_trailer
+code	be_cmds.h	/^	u8 code[6];		\/* dword 2 *\/$/;"	m	struct:amap_sol_cqe
+code	be_cmds.h	/^	u8 code[6];		\/* dword 2 *\/$/;"	m	struct:amap_sol_cqe_ring
+code	be_main.h	/^	u8 code[6];$/;"	m	struct:amap_i_t_dpdu_cqe
+compl	be_cmds.h	/^	struct be_mcc_compl compl;$/;"	m	struct:be_mcc_mailbox	typeref:struct:be_mcc_mailbox::be_mcc_compl
+compltonack	be_main.h	/^	u8 compltonack;		\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+con_index	be_cmds.h	/^	u8 con_index[14];$/;"	m	struct:amap_mcc_context
+conn	be_main.h	/^	struct beiscsi_conn *conn;$/;"	m	struct:beiscsi_io_task	typeref:struct:beiscsi_io_task::beiscsi_conn
+conn	be_main.h	/^	struct iscsi_conn *conn;$/;"	m	struct:beiscsi_conn	typeref:struct:beiscsi_conn::iscsi_conn
+conn	be_mgmt.h	/^	struct beiscsi_conn *conn;$/;"	m	struct:beiscsi_endpoint	typeref:struct:beiscsi_endpoint::beiscsi_conn
+conn_count	be_cmds.h	/^	u16	conn_count;$/;"	m	struct:mgmt_session_info
+conn_list	be_cmds.h	/^	struct	mgmt_conn_info	conn_list[1];$/;"	m	struct:mgmt_session_info	typeref:struct:mgmt_session_info::mgmt_conn_info
+conn_table	be_main.h	/^	struct beiscsi_conn *conn_table[BE2_MAX_SESSIONS * 2];$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::beiscsi_conn
+connection_handle	be_cmds.h	/^	u32	connection_handle;$/;"	m	struct:mgmt_conn_info
+connection_handle	be_cmds.h	/^	u32 connection_handle;$/;"	m	struct:tcp_connect_and_offload_out
+connection_status	be_cmds.h	/^	u32	connection_status;$/;"	m	struct:mgmt_conn_info
+consumed	be_main.h	/^	unsigned int consumed;$/;"	m	struct:async_pdu_handle
+context	be_cmds.h	/^	struct be_default_pdu_context context;$/;"	m	struct:be_defq_create_req	typeref:struct:be_defq_create_req::be_default_pdu_context
+context	be_cmds.h	/^	u8 context[sizeof(struct amap_cq_context) \/ 8];$/;"	m	struct:be_cmd_req_cq_create
+context	be_cmds.h	/^	u8 context[sizeof(struct amap_eq_context) \/ 8];	\/* dw[4] *\/$/;"	m	struct:be_cmd_req_eq_create
+context	be_cmds.h	/^	u8 context[sizeof(struct amap_mcc_context) \/ 8];$/;"	m	struct:be_cmd_req_mcc_create
+controller_description	be_mgmt.h	/^	u8 controller_description[64];$/;"	m	struct:mgmt_hba_attributes
+controller_model_number	be_mgmt.h	/^	u8 controller_model_number[32];$/;"	m	struct:mgmt_hba_attributes
+controller_serial_number	be_mgmt.h	/^	u8 controller_serial_number[32];$/;"	m	struct:mgmt_hba_attributes
+count	be_cmds.h	/^	u8 count[2];		\/* dword 0 *\/$/;"	m	struct:amap_cq_context
+count	be_cmds.h	/^	u8 count[3];		\/* dword 1 *\/$/;"	m	struct:amap_eq_context
+cq	be.h	/^	struct be_queue_info *cq;$/;"	m	struct:be_eq_obj	typeref:struct:be_eq_obj::be_queue_info
+cq	be.h	/^	struct be_queue_info cq;$/;"	m	struct:be_mcc_obj	typeref:struct:be_mcc_obj::be_queue_info
+cq_db	be_main.h	/^struct cq_db {$/;"	s
+cq_id	be_cmds.h	/^	u16 cq_id;$/;"	m	struct:be_cmd_resp_cq_create
+cq_id	be_cmds.h	/^	u16 cq_id;$/;"	m	struct:tcp_connect_and_offload_in
+cq_id	be_cmds.h	/^	u8 cq_id[10];$/;"	m	struct:amap_mcc_context
+cq_id_recv	be_cmds.h	/^	u8 cq_id_recv[10];	\/* dword 2 *\/$/;"	m	struct:amap_be_default_pdu_context
+crashmode	be_main.h	/^	unsigned int crashmode;$/;"	m	struct:hba_parameters
+created	be.h	/^	bool created;$/;"	m	struct:be_queue_info
+cri	be_main.h	/^	unsigned short cri;$/;"	m	struct:async_pdu_handle
+csr	be.h	/^	u8 __iomem *csr;$/;"	m	struct:be_ctrl_info
+csr_pa	be_main.h	/^	struct be_bus_address csr_pa;	\/* CSR *\/$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::be_bus_address
+csr_va	be_main.h	/^	u8 __iomem *csr_va;	\/* CSR *\/$/;"	m	struct:beiscsi_hba
+ctrl	be_main.h	/^	struct be_ctrl_info ctrl;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::be_ctrl_info
+cur_eqd	be_main.h	/^	u16 cur_eqd;		\/* in usecs *\/$/;"	m	struct:hwi_context_memory
+cxns_per_ctrl	be_main.h	/^	unsigned int cxns_per_ctrl;$/;"	m	struct:hba_parameters
+data_busy_list	be_main.h	/^	struct list_head data_busy_list;$/;"	m	struct:hwi_async_entry	typeref:struct:hwi_async_entry::list_head
+data_digest	be_cmds.h	/^	u8 data_digest;$/;"	m	struct:mgmt_conn_login_options
+data_len_hi	be_main.h	/^	u8 data_len_hi[8];$/;"	m	struct:amap_pdu_base
+data_len_hi	be_main.h	/^	u8 data_len_hi[8];$/;"	m	struct:amap_pdu_data_out
+data_len_hi	be_main.h	/^	u8 data_len_hi[8];$/;"	m	struct:amap_pdu_nop_out
+data_len_lo	be_main.h	/^	u8 data_len_lo[16];	\/* DataSegmentLength *\/$/;"	m	struct:amap_pdu_data_out
+data_len_lo	be_main.h	/^	u8 data_len_lo[16];	\/* DataSegmentLength *\/$/;"	m	struct:amap_pdu_nop_out
+data_len_lo	be_main.h	/^	u8 data_len_lo[16];	\/* DatasegmentLength *\/$/;"	m	struct:amap_pdu_base
+data_ring_id	be_cmds.h	/^	u16 data_ring_id;$/;"	m	struct:tcp_connect_and_offload_in
+data_ring_id	be_cmds.h	/^	u8 data_ring_id;$/;"	m	struct:iscsi_cleanup_req
+data_sn	be_main.h	/^	u8 data_sn[32];$/;"	m	struct:amap_pdu_data_out
+dataout_template_pa	be_cmds.h	/^	struct phys_addr dataout_template_pa;$/;"	m	struct:tcp_connect_and_offload_in	typeref:struct:tcp_connect_and_offload_in::phys_addr
+db	be.h	/^	u8 __iomem *db;		\/* Door Bell *\/$/;"	m	struct:be_ctrl_info
+db_addr_hi	be_main.h	/^	u8 db_addr_hi[32];$/;"	m	struct:amap_i_t_dpdu_cqe
+db_addr_lo	be_main.h	/^	u8 db_addr_lo[32];$/;"	m	struct:amap_i_t_dpdu_cqe
+db_pa	be_main.h	/^	struct be_bus_address db_pa;	\/* CSR *\/$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::be_bus_address
+db_va	be_main.h	/^	u8 __iomem *db_va;	\/* Door  Bell  *\/$/;"	m	struct:beiscsi_hba
+dbg_flags	be_main.h	/^	unsigned int dbg_flags;$/;"	m	struct:hba_parameters
+dbuf_cindex	be_cmds.h	/^	u8 dbuf_cindex[13];	\/* dword 0 *\/$/;"	m	struct:amap_be_default_pdu_context
+dbuf_pindex	be_cmds.h	/^	u8 dbuf_pindex[13];	\/* dword 1 *\/$/;"	m	struct:amap_be_default_pdu_context
+dde	be_main.h	/^	u8 dde;			\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+dde	be_main.h	/^	u8 dde[1];$/;"	m	struct:amap_beiscsi_offload_params
+default_buffer_size	be_cmds.h	/^	u8 default_buffer_size[16];	\/* dword 2 *\/$/;"	m	struct:amap_be_default_pdu_context
+default_extended_timeout	be_mgmt.h	/^	u32 default_extended_timeout;$/;"	m	struct:mgmt_hba_attributes
+default_link_down_timeout	be_mgmt.h	/^	u16 default_link_down_timeout;$/;"	m	struct:mgmt_hba_attributes
+default_pdu_data	be_main.h	/^	struct be_ring default_pdu_data;$/;"	m	struct:hwi_controller	typeref:struct:hwi_controller::be_ring
+default_pdu_hdr	be_main.h	/^	struct be_ring default_pdu_hdr;$/;"	m	struct:hwi_controller	typeref:struct:hwi_controller::be_ring
+default_time2retain	be_cmds.h	/^	u16	default_time2retain;$/;"	m	struct:mgmt_session_login_options
+default_time2wait	be_cmds.h	/^	u16	default_time2wait;$/;"	m	struct:mgmt_session_login_options
+defpdu_data_sz	be_main.h	/^	unsigned int defpdu_data_sz;$/;"	m	struct:hba_parameters
+defpdu_hdr_sz	be_main.h	/^	unsigned int defpdu_hdr_sz;$/;"	m	struct:hba_parameters
+defq_id	be_cmds.h	/^	u16 defq_id;$/;"	m	struct:tcp_connect_and_offload_in
+delay	be_cmds.h	/^	struct eq_delay delay[8];$/;"	m	struct:be_eq_delay_params_in	typeref:struct:be_eq_delay_params_in::eq_delay
+delay	be_cmds.h	/^	} delay[8];$/;"	m	struct:be_cmd_req_modify_eq_delay	typeref:struct:be_cmd_req_modify_eq_delay::__anon4
+delay_multiplier	be_cmds.h	/^		u32 delay_multiplier;$/;"	m	struct:be_cmd_req_modify_eq_delay::__anon4
+delay_multiplier	be_cmds.h	/^	u32 delay_multiplier;$/;"	m	struct:eq_delay
+delaymult	be_cmds.h	/^	u8 delaymult[10];	\/* dword 2 *\/$/;"	m	struct:amap_eq_context
+dest_ipaddr	be_cmds.h	/^	struct	ip_address_format	dest_ipaddr;$/;"	m	struct:mgmt_conn_info	typeref:struct:mgmt_conn_info::ip_address_format
+dest_ipaddr_redirected	be_cmds.h	/^	struct	ip_address_format	dest_ipaddr_redirected;$/;"	m	struct:mgmt_conn_info	typeref:struct:mgmt_conn_info::ip_address_format
+dest_port	be_cmds.h	/^	u16	dest_port;$/;"	m	struct:mgmt_conn_info
+dest_port_redirected	be_cmds.h	/^	u16	dest_port_redirected;$/;"	m	struct:mgmt_conn_info
+dif_meta_tag	be_main.h	/^	u8 dif_meta_tag[14];	\/* DWORD 11 *\/$/;"	m	struct:amap_iscsi_wrb
+dif_mode	be_main.h	/^	u8 dif_mode[2];		\/* DWORD 10 *\/$/;"	m	struct:amap_iscsi_wrb
+dif_ref_tag	be_main.h	/^	u8 dif_ref_tag[32];	\/* DWORD 7 *\/$/;"	m	struct:amap_iscsi_wrb
+dma	be.h	/^	dma_addr_t dma;$/;"	m	struct:be_dma_mem
+dma_mem	be.h	/^	struct be_dma_mem dma_mem;$/;"	m	struct:be_queue_info	typeref:struct:be_queue_info::be_dma_mem
+dmsg	be_main.h	/^	u8 dmsg;		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+dmsg	be_main.h	/^	u8 dmsg;		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_wrb
+dmsg_cqe	be_cmds.h	/^struct dmsg_cqe {$/;"	s
+do_offload	be_cmds.h	/^	u8 do_offload;$/;"	m	struct:tcp_connect_and_offload_in
+domain	be_cmds.h	/^	u8 domain;		\/* dword 0 *\/$/;"	m	struct:be_cmd_req_hdr
+domain_id	be_main.h	/^	u8 domain_id[5];		\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+dpl	be_main.h	/^	u8 dpl[16];$/;"	m	struct:amap_i_t_dpdu_cqe
+dq_base	be_cmds.h	/^	u32 dq_base;$/;"	m	struct:be_ulp_fw_cfg
+dq_count	be_cmds.h	/^	u32 dq_count;$/;"	m	struct:be_ulp_fw_cfg
+driver_version_string	be_mgmt.h	/^	u8 driver_version_string[32];$/;"	m	struct:mgmt_hba_attributes
+dsp	be_main.h	/^	u8 dsp;			\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+dsp	be_main.h	/^	u8 dsp;			\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_wrb
+dst6_addr	be_mgmt.h	/^	char dst6_addr[ISCSI_ADDRESS_BUF_LEN];$/;"	m	struct:beiscsi_endpoint
+dst_addr	be_mgmt.h	/^	unsigned long dst_addr;$/;"	m	struct:beiscsi_endpoint
+dst_tcpport	be_mgmt.h	/^	u16 dst_tcpport;$/;"	m	struct:beiscsi_endpoint
+dw	be_cmds.h	/^	u32 dw[32];$/;"	m	struct:tcp_upload_params_out
+dw	be_cmds.h	/^	u32 dw[4];$/;"	m	struct:be_default_pdu_context
+dw	be_cmds.h	/^	u32 dw[4];$/;"	m	struct:dmsg_cqe
+dw	be_cmds.h	/^	u32 dw[4];$/;"	m	struct:sol_cqe
+dw	be_main.h	/^	u32 dw[12];$/;"	m	struct:pdu_data_out
+dw	be_main.h	/^	u32 dw[12];$/;"	m	struct:pdu_nop_out
+dw	be_main.h	/^	u32 dw[16];$/;"	m	struct:iscsi_target_context_update_wrb
+dw	be_main.h	/^	u32 dw[16];$/;"	m	struct:iscsi_wrb
+dw	be_main.h	/^	u32 dw[16];$/;"	m	struct:pdu_base
+dw	be_main.h	/^	u32 dw[1];$/;"	m	struct:be_eq_entry
+dw	be_main.h	/^	u32 dw[1];$/;"	m	struct:cq_db
+dw	be_main.h	/^	u32 dw[4];$/;"	m	struct:i_t_dpdu_cqe
+dw	be_main.h	/^	u32 dw[4];$/;"	m	struct:iscsi_sge
+dw	be_main.h	/^	u32 dw[5];$/;"	m	struct:beiscsi_offload_params
+dw	be_mgmt.h	/^	u32 dw[0];		\/* DWORD 0 *\/$/;"	m	struct:mcc_wrb
+eh_sgl_alloc_index	be_main.h	/^	unsigned short eh_sgl_alloc_index;$/;"	m	struct:beiscsi_hba
+eh_sgl_free_index	be_main.h	/^	unsigned short eh_sgl_free_index;$/;"	m	struct:beiscsi_hba
+eh_sgl_hndl_avbl	be_main.h	/^	unsigned short eh_sgl_hndl_avbl;$/;"	m	struct:beiscsi_hba
+eh_sgl_hndl_base	be_main.h	/^	struct sgl_handle **eh_sgl_hndl_base;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::sgl_handle
+eh_sgl_list	be_main.h	/^	struct list_head eh_sgl_list;$/;"	m	struct:hwi_controller	typeref:struct:hwi_controller::list_head
+embedded	be_cmds.h	/^	u32 embedded;		\/* dword 0 *\/$/;"	m	struct:be_mcc_wrb
+embedded	be_mgmt.h	/^		u32 embedded[59];	\/* DWORDS 57 to 115 *\/$/;"	m	union:mcc_wrb_payload::__anon11
+embedded	be_mgmt.h	/^		u8 embedded[59 * 32];	\/* DWORDS 57 to 115 *\/$/;"	m	union:amap_mcc_wrb_payload::__anon10
+embedded	be_mgmt.h	/^	u8 embedded;		\/* DWORD 0 *\/$/;"	m	struct:amap_mcc_wrb
+embedded_payload	be_cmds.h	/^		u8 embedded_payload[236];	\/* used by embedded cmds *\/$/;"	m	union:be_mcc_wrb::__anon1
+embedded_payload	be_cmds.h	/^static inline void *embedded_payload(struct be_mcc_wrb *wrb)$/;"	f
+enable_msix	be_main.c	/^static unsigned int enable_msix = 1;$/;"	v	file:
+entry_size	be.h	/^	u16 entry_size;		\/* Size of an element in the queue *\/$/;"	m	struct:be_queue_info
+ep	be_main.h	/^	struct beiscsi_endpoint *ep;$/;"	m	struct:beiscsi_conn	typeref:struct:beiscsi_conn::beiscsi_endpoint
+ep_array	be_main.h	/^	struct iscsi_endpoint **ep_array;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::iscsi_endpoint
+ep_cid	be_mgmt.h	/^	unsigned short ep_cid;$/;"	m	struct:beiscsi_endpoint
+ep_fw_data_struct_version	be_mgmt.h	/^	u32 ep_fw_data_struct_version;$/;"	m	struct:mgmt_hba_attributes
+ep_read_ptr	be_main.h	/^		unsigned int ep_read_ptr;$/;"	m	struct:hwi_async_pdu_context::__anon8
+ep_read_ptr	be_main.h	/^		unsigned int ep_read_ptr;$/;"	m	struct:hwi_async_pdu_context::__anon9
+epidx	be_cmds.h	/^	u8 epidx[11];		\/* dword 0 *\/$/;"	m	struct:amap_cq_context
+epidx	be_cmds.h	/^	u8 epidx[13];		\/* dword 0 *\/$/;"	m	struct:amap_eq_context
+eq_delay	be_cmds.h	/^struct eq_delay {$/;"	s
+eq_delay_to_mult	be_cmds.c	/^static u32 eq_delay_to_mult(u32 usec_delay)$/;"	f	file:
+eq_id	be_cmds.h	/^		u32 eq_id;$/;"	m	struct:be_cmd_req_modify_eq_delay::__anon4
+eq_id	be_cmds.h	/^	u16 eq_id;		\/* sword *\/$/;"	m	struct:be_cmd_resp_eq_create
+eq_id	be_cmds.h	/^	u32 eq_id;$/;"	m	struct:eq_delay
+eq_timer	be_main.h	/^	unsigned int eq_timer;$/;"	m	struct:hba_parameters
+eqid	be_cmds.h	/^	u8 eqid[8];		\/* dword 1 *\/$/;"	m	struct:amap_cq_context
+erl	be_main.h	/^	u8 erl[2];		\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+erl	be_main.h	/^	u8 erl[2];$/;"	m	struct:amap_beiscsi_offload_params
+error_recovery_level	be_cmds.h	/^	u8	error_recovery_level;$/;"	m	struct:mgmt_session_login_options
+estimated_throughput	be_cmds.h	/^	u32	estimated_throughput;$/;"	m	struct:mgmt_conn_info
+eto	be_main.h	/^	unsigned int eto;$/;"	m	struct:hba_parameters
+etx_base	be_cmds.h	/^	u32 etx_base;$/;"	m	struct:be_ulp_fw_cfg
+etx_count	be_cmds.h	/^	u32 etx_count;$/;"	m	struct:be_ulp_fw_cfg
+event	be_main.h	/^	u8 event[1];$/;"	m	struct:amap_cq_db
+eventable	be_cmds.h	/^	u8 eventable;		\/* dword 0 *\/$/;"	m	struct:amap_cq_context
+exp_data_sn	be_main.h	/^	u8 exp_data_sn[32];	\/* DWORD 3 *\/$/;"	m	struct:amap_iscsi_wrb
+exp_stat_sn	be_main.h	/^	u8 exp_stat_sn[32];$/;"	m	struct:amap_pdu_data_out
+exp_stat_sn	be_main.h	/^	u8 exp_stat_sn[32];$/;"	m	struct:amap_pdu_nop_out
+exp_statsn	be_main.h	/^	u32 exp_statsn;$/;"	m	struct:beiscsi_conn
+exp_statsn	be_main.h	/^	u8 exp_statsn[32];$/;"	m	struct:amap_beiscsi_offload_params
+f_bit	be_main.h	/^	u8 f_bit;		\/* always 1 *\/$/;"	m	struct:amap_pdu_nop_out
+fetch_r2t	be_cmds.h	/^	u8 fetch_r2t;$/;"	m	struct:amap_mcc_context
+fetch_wrb	be_cmds.h	/^	u8 fetch_wrb;$/;"	m	struct:amap_mcc_context
+fid	be_cmds.h	/^	u8 fid[8];$/;"	m	struct:amap_mcc_context
+final	be_main.h	/^	u8 final;$/;"	m	struct:amap_i_t_dpdu_cqe
+final_bit	be_main.h	/^	u8 final_bit;		\/* F bit *\/$/;"	m	struct:amap_pdu_data_out
+find_num_cpus	be_main.c	/^static int find_num_cpus(void)$/;"	f	file:
+firmware_post_status	be_mgmt.h	/^	u32 firmware_post_status;$/;"	m	struct:mgmt_hba_attributes
+firmware_version_string	be_mgmt.h	/^	u8 firmware_version_string[32];$/;"	m	struct:mgmt_hba_attributes
+first_burst_length	be_cmds.h	/^	u32	first_burst_length;$/;"	m	struct:mgmt_session_login_options
+first_burst_length	be_main.h	/^	u8 first_burst_length[14];	\/* DWORD 3 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+first_burst_length	be_main.h	/^	u8 first_burst_length[32];$/;"	m	struct:amap_beiscsi_offload_params
+flags	be_cmds.h	/^	u32 flags;		\/* dword 3 *\/$/;"	m	struct:be_mcc_compl
+flags	be_cmds.h	/^	u32 flags;$/;"	m	struct:mgmt_chap_format
+flags	be_cmds.h	/^	u8	flags;$/;"	m	struct:mgmt_session_login_options
+flags	be_cmds.h	/^	u8 flags;$/;"	m	struct:mgmt_conn_login_options
+flags	be_main.h	/^	unsigned int flags;$/;"	m	struct:beiscsi_io_task
+flashrom_version_string	be_mgmt.h	/^	u8 flashrom_version_string[32];$/;"	m	struct:mgmt_hba_attributes
+fp_bit_filler1	be_main.h	/^	u8 fp_bit_filler1[7];$/;"	m	struct:amap_pdu_nop_out
+fragnum_bits_for_sgl_cra_in	be_cmds.h	/^struct fragnum_bits_for_sgl_cra_in {$/;"	s
+free_entries	be_main.h	/^		unsigned int free_entries;$/;"	m	struct:hwi_async_pdu_context::__anon8
+free_entries	be_main.h	/^		unsigned int free_entries;$/;"	m	struct:hwi_async_pdu_context::__anon9
+free_index	be_main.h	/^	unsigned short free_index;$/;"	m	struct:hwi_wrb_context
+free_io_sgl_handle	be_main.c	/^free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)$/;"	f	file:
+free_list	be_main.h	/^		struct list_head free_list;$/;"	m	struct:hwi_async_pdu_context::__anon8	typeref:struct:hwi_async_pdu_context::__anon8::list_head
+free_list	be_main.h	/^		struct list_head free_list;$/;"	m	struct:hwi_async_pdu_context::__anon9	typeref:struct:hwi_async_pdu_context::__anon9::list_head
+free_mcc_tag	be_cmds.c	/^void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)$/;"	f
+free_mgmt_sgl_handle	be_main.c	/^free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)$/;"	f
+free_wrb_handle	be_main.c	/^free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,$/;"	f	file:
+free_wrb_handles	be_main.c	/^static void free_wrb_handles(struct beiscsi_hba *phba)$/;"	f	file:
+func	be_cmds.h	/^	u8 func[8];		\/* dword 2 *\/$/;"	m	struct:amap_cq_context
+func	be_cmds.h	/^	u8 func[8];		\/* dword 2 *\/$/;"	m	struct:amap_eq_context
+function_caps	be_cmds.h	/^	u32 function_caps;$/;"	m	struct:be_fw_cfg
+function_mode	be_cmds.h	/^	u32 function_mode;$/;"	m	struct:be_fw_cfg
+functionalities_supported	be_mgmt.h	/^	u32 functionalities_supported;$/;"	m	struct:mgmt_hba_attributes
+future_reserved	be_mgmt.h	/^	u32 future_reserved[12];$/;"	m	struct:mgmt_hba_attributes
+future_u32	be_mgmt.h	/^	u32 future_u32[3];$/;"	m	struct:mgmt_hba_attributes
+future_u32	be_mgmt.h	/^	u8 future_u32[4];$/;"	m	struct:mgmt_controller_attributes
+future_u8	be_mgmt.h	/^	u8 future_u8[3];$/;"	m	struct:mgmt_hba_attributes
+fw_cmd_data_struct_version	be_mgmt.h	/^	u32 fw_cmd_data_struct_version;$/;"	m	struct:mgmt_hba_attributes
+fw_config	be_main.h	/^	} fw_config;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::__anon6
+fw_handle	be_mgmt.h	/^	unsigned int fw_handle;$/;"	m	struct:beiscsi_endpoint
+fw_on_flash_version_string	be_mgmt.h	/^	u8 fw_on_flash_version_string[32];$/;"	m	struct:mgmt_hba_attributes
+gcrashmode	be_main.c	/^static unsigned int gcrashmode = 0;$/;"	v	file:
+generation	be_main.h	/^	unsigned int generation;$/;"	m	struct:beiscsi_hba
+generational_guid	be_mgmt.h	/^	u8 generational_guid[16];$/;"	m	struct:mgmt_hba_attributes
+handle_base	be_main.h	/^		struct async_pdu_handle *handle_base;$/;"	m	struct:hwi_async_pdu_context::__anon8	typeref:struct:hwi_async_pdu_context::__anon8::async_pdu_handle
+handle_base	be_main.h	/^		struct async_pdu_handle *handle_base;$/;"	m	struct:hwi_async_pdu_context::__anon9	typeref:struct:hwi_async_pdu_context::__anon9::async_pdu_handle
+hba_attribs	be_mgmt.h	/^	struct mgmt_hba_attributes hba_attribs;$/;"	m	struct:mgmt_controller_attributes	typeref:struct:mgmt_controller_attributes::mgmt_hba_attributes
+hba_mtu	be_mgmt.h	/^	u32 hba_mtu[8];$/;"	m	struct:mgmt_hba_attributes
+hba_num	be_main.h	/^	unsigned int hba_num;$/;"	m	struct:hba_parameters
+hba_parameters	be_main.h	/^struct hba_parameters {$/;"	s
+hba_port_count	be_mgmt.h	/^	u8 hba_port_count;$/;"	m	struct:mgmt_hba_attributes
+hba_queue	be_main.h	/^	struct list_head hba_queue;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::list_head
+hba_setup_cid_tbls	be_main.c	/^static int hba_setup_cid_tbls(struct beiscsi_hba *phba)$/;"	f	file:
+hba_status	be_mgmt.h	/^	u8 hba_status;$/;"	m	struct:mgmt_hba_attributes
+hde	be_main.h	/^	u8 hde;			\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+hde	be_main.h	/^	u8 hde[1];$/;"	m	struct:amap_beiscsi_offload_params
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;	\/* dw[4] *\/$/;"	m	struct:be_cmd_req_eq_create	typeref:struct:be_cmd_req_eq_create::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_all_if_id	typeref:struct:be_all_if_id::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_cmd_req_cq_create	typeref:struct:be_cmd_req_cq_create::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_cmd_req_get_boot_target	typeref:struct:be_cmd_req_get_boot_target::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_cmd_req_get_mac_addr	typeref:struct:be_cmd_req_get_mac_addr::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_cmd_req_get_session	typeref:struct:be_cmd_req_get_session::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_cmd_req_mac_query	typeref:struct:be_cmd_req_mac_query::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_cmd_req_mcast_mac_config	typeref:struct:be_cmd_req_mcast_mac_config::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_cmd_req_mcc_create	typeref:struct:be_cmd_req_mcc_create::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_cmd_req_modify_eq_delay	typeref:struct:be_cmd_req_modify_eq_delay::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_cmd_req_q_destroy	typeref:struct:be_cmd_req_q_destroy::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_defq_create_req	typeref:struct:be_defq_create_req::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_defq_create_resp	typeref:struct:be_defq_create_resp::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_eq_delay_params_in	typeref:struct:be_eq_delay_params_in::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_fw_cfg	typeref:struct:be_fw_cfg::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_post_sgl_pages_req	typeref:struct:be_post_sgl_pages_req::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_wrbq_create_req	typeref:struct:be_wrbq_create_req::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:fragnum_bits_for_sgl_cra_in	typeref:struct:fragnum_bits_for_sgl_cra_in::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:iscsi_cleanup_req	typeref:struct:iscsi_cleanup_req::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:tcp_connect_and_offload_in	typeref:struct:tcp_connect_and_offload_in::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:tcp_upload_params_in	typeref:struct:tcp_upload_params_in::be_cmd_req_hdr
+hdr	be_cmds.h	/^	struct be_cmd_resp_hdr hdr;$/;"	m	struct:be_cmd_resp_cq_create	typeref:struct:be_cmd_resp_cq_create::be_cmd_resp_hdr
+hdr	be_cmds.h	/^	struct be_cmd_resp_hdr hdr;$/;"	m	struct:be_cmd_resp_get_boot_target	typeref:struct:be_cmd_resp_get_boot_target::be_cmd_resp_hdr
+hdr	be_cmds.h	/^	struct be_cmd_resp_hdr hdr;$/;"	m	struct:be_cmd_resp_get_mac_addr	typeref:struct:be_cmd_resp_get_mac_addr::be_cmd_resp_hdr
+hdr	be_cmds.h	/^	struct be_cmd_resp_hdr hdr;$/;"	m	struct:be_cmd_resp_get_session	typeref:struct:be_cmd_resp_get_session::be_cmd_resp_hdr
+hdr	be_cmds.h	/^	struct be_cmd_resp_hdr hdr;$/;"	m	struct:be_cmd_resp_mac_query	typeref:struct:be_cmd_resp_mac_query::be_cmd_resp_hdr
+hdr	be_cmds.h	/^	struct be_cmd_resp_hdr hdr;$/;"	m	struct:be_cmd_resp_mcc_create	typeref:struct:be_cmd_resp_mcc_create::be_cmd_resp_hdr
+hdr	be_cmds.h	/^	struct be_cmd_resp_hdr hdr;$/;"	m	struct:tcp_connect_and_offload_out	typeref:struct:tcp_connect_and_offload_out::be_cmd_resp_hdr
+hdr	be_mgmt.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:be_mgmt_controller_attributes	typeref:struct:be_mgmt_controller_attributes::be_cmd_req_hdr
+hdr	be_mgmt.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:invalidate_commands_params_in	typeref:struct:invalidate_commands_params_in::be_cmd_req_hdr
+hdr	be_mgmt.h	/^	struct be_cmd_req_hdr hdr;$/;"	m	struct:iscsi_invalidate_connection_params_in	typeref:struct:iscsi_invalidate_connection_params_in::be_cmd_req_hdr
+hdr	be_mgmt.h	/^	struct be_cmd_resp_hdr hdr;$/;"	m	struct:be_mgmt_controller_attributes_resp	typeref:struct:be_mgmt_controller_attributes_resp::be_cmd_resp_hdr
+hdr_len	be_main.h	/^		unsigned char hdr_len;$/;"	m	struct:hwi_async_entry::__anon7
+hdr_received	be_main.h	/^		unsigned char hdr_received;$/;"	m	struct:hwi_async_entry::__anon7
+hdr_ring_id	be_cmds.h	/^	u16 hdr_ring_id;$/;"	m	struct:tcp_connect_and_offload_in
+hdr_ring_id	be_cmds.h	/^	u8 hdr_ring_id;$/;"	m	struct:iscsi_cleanup_req
+head	be.h	/^	u16 tail, head;$/;"	m	struct:be_queue_info
+header_busy_list	be_main.h	/^	struct list_head header_busy_list;$/;"	m	struct:hwi_async_entry	typeref:struct:hwi_async_entry::list_head
+header_digest	be_cmds.h	/^	u8 header_digest;$/;"	m	struct:mgmt_conn_login_options
+header_len	be_main.h	/^	unsigned short header_len;$/;"	m	struct:beiscsi_io_task
+hi	be_cmds.h	/^	u32 hi;$/;"	m	struct:phys_addr
+host_write_ptr	be_main.h	/^		unsigned int host_write_ptr;$/;"	m	struct:hwi_async_pdu_context::__anon8
+host_write_ptr	be_main.h	/^		unsigned int host_write_ptr;$/;"	m	struct:hwi_async_pdu_context::__anon9
+hw_sts	be_cmds.h	/^	u8 hw_sts[8];		\/* dword 0 *\/$/;"	m	struct:amap_sol_cqe
+hw_sts	be_cmds.h	/^	u8 hw_sts[8];		\/* dword 0 *\/$/;"	m	struct:amap_sol_cqe_ring
+hwh_type_enum	be_main.h	/^enum hwh_type_enum {$/;"	g
+hwi_async_entry	be_main.h	/^struct hwi_async_entry {$/;"	s
+hwi_async_pdu_context	be_main.h	/^struct hwi_async_pdu_context {$/;"	s
+hwi_build_be_sgl_arr	be_main.c	/^hwi_build_be_sgl_arr(struct beiscsi_hba *phba,$/;"	f	file:
+hwi_build_be_sgl_by_offset	be_main.c	/^hwi_build_be_sgl_by_offset(struct beiscsi_hba *phba,$/;"	f	file:
+hwi_cleanup	be_main.c	/^static void hwi_cleanup(struct beiscsi_hba *phba)$/;"	f	file:
+hwi_complete_cmd	be_main.c	/^static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+hwi_complete_drvr_msgs	be_main.c	/^hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+hwi_context_memory	be_main.h	/^struct hwi_context_memory {$/;"	s
+hwi_controller	be_main.h	/^struct hwi_controller {$/;"	s
+hwi_disable_intr	be_main.c	/^static void hwi_disable_intr(struct beiscsi_hba *phba)$/;"	f	file:
+hwi_enable_intr	be_main.c	/^static void hwi_enable_intr(struct beiscsi_hba *phba)$/;"	f	file:
+hwi_flush_default_pdu_buffer	be_main.c	/^static void hwi_flush_default_pdu_buffer(struct beiscsi_hba *phba,$/;"	f	file:
+hwi_free_async_msg	be_main.c	/^static unsigned int hwi_free_async_msg(struct beiscsi_hba *phba,$/;"	f	file:
+hwi_fwd_async_msg	be_main.c	/^hwi_fwd_async_msg(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+hwi_gather_async_pdu	be_main.c	/^hwi_gather_async_pdu(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+hwi_get_async_busy_list	be_main.c	/^static struct list_head *hwi_get_async_busy_list(struct hwi_async_pdu_context$/;"	f	file:
+hwi_get_async_handle	be_main.c	/^hwi_get_async_handle(struct beiscsi_hba *phba,$/;"	f	file:
+hwi_get_ring_address	be_main.c	/^hwi_get_ring_address(struct hwi_async_pdu_context *pasync_ctx,$/;"	f	file:
+hwi_init_async_pdu_ctx	be_main.c	/^static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)$/;"	f	file:
+hwi_init_controller	be_main.c	/^static int hwi_init_controller(struct beiscsi_hba *phba)$/;"	f	file:
+hwi_init_port	be_main.c	/^static int hwi_init_port(struct beiscsi_hba *phba)$/;"	f	file:
+hwi_post_async_buffers	be_main.c	/^static void hwi_post_async_buffers(struct beiscsi_hba *phba,$/;"	f	file:
+hwi_process_default_pdu_ring	be_main.c	/^static void hwi_process_default_pdu_ring(struct beiscsi_conn *beiscsi_conn,$/;"	f	file:
+hwi_purge_eq	be_main.c	/^static void hwi_purge_eq(struct beiscsi_hba *phba)$/;"	f	file:
+hwi_ring_cq_db	be_main.c	/^static void hwi_ring_cq_db(struct beiscsi_hba *phba,$/;"	f	file:
+hwi_ring_eq_db	be_main.c	/^static void hwi_ring_eq_db(struct beiscsi_hba *phba,$/;"	f	file:
+hwi_update_async_writables	be_main.c	/^hwi_update_async_writables(struct hwi_async_pdu_context *pasync_ctx,$/;"	f	file:
+hwi_wrb_context	be_main.h	/^struct hwi_wrb_context {$/;"	s
+hwi_write_buffer	be_main.c	/^static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)$/;"	f	file:
+hwi_write_sgl	be_main.c	/^hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,$/;"	f	file:
+hwi_ws_sz	be_main.h	/^	unsigned int hwi_ws_sz;$/;"	m	struct:hba_parameters
+i_bit	be_main.h	/^	u8 i_bit;		\/* I Bit *\/$/;"	m	struct:amap_pdu_nop_out
+i_bit	be_main.h	/^	u8 i_bit;		\/* immediate bit *\/$/;"	m	struct:amap_pdu_base
+i_cmd_wnd	be_cmds.h	/^	u8 i_cmd_wnd[8];	\/* dword 2 *\/$/;"	m	struct:amap_sol_cqe
+i_cmd_wnd	be_cmds.h	/^	u8 i_cmd_wnd[8];	\/* dword 2 *\/$/;"	m	struct:amap_sol_cqe_ring
+i_exp_cmd_sn	be_cmds.h	/^	u8 i_exp_cmd_sn[32];	\/* dword 1 *\/$/;"	m	struct:amap_sol_cqe
+i_exp_cmd_sn	be_cmds.h	/^	u8 i_exp_cmd_sn[32];	\/* dword 1 *\/$/;"	m	struct:amap_sol_cqe_ring
+i_flags	be_cmds.h	/^	u8 i_flags[7];		\/* dword 0 *\/$/;"	m	struct:amap_sol_cqe
+i_flags	be_cmds.h	/^	u8 i_flags[7];		\/* dword 0 *\/$/;"	m	struct:amap_sol_cqe_ring
+i_res_cnt	be_cmds.h	/^	u8 i_res_cnt[31];	\/* dword 3 *\/$/;"	m	struct:amap_sol_cqe
+i_res_cnt	be_cmds.h	/^	u8 i_res_cnt[31];	\/* dword 3 *\/$/;"	m	struct:amap_sol_cqe_ring
+i_resp	be_cmds.h	/^	u8 i_resp[8];		\/* dword 0 *\/$/;"	m	struct:amap_sol_cqe
+i_resp	be_cmds.h	/^	u8 i_resp[8];		\/* dword 0 *\/$/;"	m	struct:amap_sol_cqe_ring
+i_sts	be_cmds.h	/^	u8 i_sts[8];		\/* dword 0 *\/$/;"	m	struct:amap_sol_cqe
+i_sts	be_cmds.h	/^	u8 i_sts[8];		\/* dword 0 *\/$/;"	m	struct:amap_sol_cqe_ring
+i_t_dpdu_cqe	be_main.h	/^struct i_t_dpdu_cqe {$/;"	s
+icd	be_main.h	/^	unsigned short icd;$/;"	m	struct:invalidate_command_table
+icd_base	be_cmds.h	/^	u32 icd_base;$/;"	m	struct:be_ulp_fw_cfg
+icd_count	be_cmds.h	/^	u32 icd_count;$/;"	m	struct:be_ulp_fw_cfg
+icd_count	be_mgmt.h	/^	unsigned int icd_count;$/;"	m	struct:invalidate_commands_params_in
+icd_count	be_mgmt.h	/^	unsigned int icd_count;$/;"	m	struct:invalidate_commands_params_out
+icd_index	be_cmds.h	/^	u8 icd_index[12];	\/* dword 2 *\/$/;"	m	struct:amap_sol_cqe_ring
+icd_status	be_mgmt.h	/^	unsigned int icd_status[128];$/;"	m	struct:invalidate_commands_params_out
+icds_per_ctrl	be_main.h	/^	unsigned int icds_per_ctrl;$/;"	m	struct:hba_parameters
+id	be.h	/^	u16 id;$/;"	m	struct:be_queue_info
+id	be_cmds.h	/^	u16 id;$/;"	m	struct:be_cmd_req_q_destroy
+id	be_cmds.h	/^	u16 id;$/;"	m	struct:be_cmd_resp_mcc_create
+id	be_cmds.h	/^	u16 id;$/;"	m	struct:be_defq_create_resp
+id	be_cmds.h	/^	u16 id;$/;"	m	struct:tcp_upload_params_in
+id	be_main.h	/^	u32 id;			\/* queue id assigned by beklib *\/$/;"	m	struct:be_ring
+if_count	be_cmds.h	/^	u32 if_count;$/;"	m	struct:be_all_if_id
+if_hndl_list	be_cmds.h	/^	u32 if_hndl_list[1];$/;"	m	struct:be_all_if_id
+if_id	be_cmds.h	/^	u16 if_id;$/;"	m	struct:be_cmd_req_mac_query
+imd	be_main.h	/^	u8 imd;			\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+imd	be_main.h	/^	u8 imd[1];$/;"	m	struct:amap_beiscsi_offload_params
+index	be_main.h	/^	u8 index[16];$/;"	m	struct:amap_i_t_dpdu_cqe
+index	be_main.h	/^	unsigned char index;$/;"	m	struct:async_pdu_handle
+index	be_main.h	/^	unsigned int index;	\/* Index of this memory parameter *\/$/;"	m	struct:be_mem_descriptor
+index_inc	be.h	/^static inline void index_inc(u16 *index, u16 limit)$/;"	f
+info	be_cmds.h	/^	u32 info;		\/* dword 0 *\/$/;"	m	struct:be_cmd_resp_hdr
+init_mem	be_main.h	/^	struct be_mem_descriptor *init_mem;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::be_mem_descriptor
+initiator_iscsiname	be_cmds.h	/^	u8	initiator_iscsiname[224];$/;"	m	struct:mgmt_session_info
+interface_id	be_cmds.h	/^	u8 interface_id;$/;"	m	struct:be_cmd_req_mcast_mac_config
+interface_type	be_mgmt.h	/^	u8 interface_type;$/;"	m	struct:mgmt_controller_attributes
+intr_chap_name	be_cmds.h	/^	u8  intr_chap_name[256];$/;"	m	struct:mgmt_chap_format
+intr_chap_name_length	be_cmds.h	/^	u16 intr_chap_name_length;$/;"	m	struct:mgmt_chap_format
+intr_secret	be_cmds.h	/^	u8  intr_secret[16];$/;"	m	struct:mgmt_chap_format
+intr_secret_length	be_cmds.h	/^	u16 intr_secret_length;$/;"	m	struct:mgmt_chap_format
+inv_tbl	be_main.h	/^	struct invalidate_command_table inv_tbl[128];$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::invalidate_command_table
+invalidate_command_table	be_main.h	/^struct invalidate_command_table {$/;"	s
+invalidate_commands_params	be_mgmt.h	/^union invalidate_commands_params {$/;"	u
+invalidate_commands_params_in	be_mgmt.h	/^struct invalidate_commands_params_in {$/;"	s
+invalidate_commands_params_out	be_mgmt.h	/^struct invalidate_commands_params_out {$/;"	s
+invld	be_main.h	/^	u8 invld;		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+invld	be_main.h	/^	u8 invld;		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_wrb
+io_sgl_alloc_index	be_main.h	/^	unsigned short io_sgl_alloc_index;$/;"	m	struct:beiscsi_hba
+io_sgl_free_index	be_main.h	/^	unsigned short io_sgl_free_index;$/;"	m	struct:beiscsi_hba
+io_sgl_hndl_avbl	be_main.h	/^	unsigned short io_sgl_hndl_avbl;$/;"	m	struct:beiscsi_hba
+io_sgl_hndl_base	be_main.h	/^	struct sgl_handle **io_sgl_hndl_base;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::sgl_handle
+io_sgl_list	be_main.h	/^	struct list_head io_sgl_list;$/;"	m	struct:hwi_controller	typeref:struct:hwi_controller::list_head
+io_sgl_lock	be_main.h	/^	spinlock_t io_sgl_lock;$/;"	m	struct:beiscsi_hba
+iopoll	be.h	/^	struct blk_iopoll	iopoll;$/;"	m	struct:be_eq_obj	typeref:struct:be_eq_obj::blk_iopoll
+ios_per_ctrl	be_main.h	/^	unsigned int ios_per_ctrl;$/;"	m	struct:hba_parameters
+ip_address	be_cmds.h	/^	struct ip_address_format ip_address;$/;"	m	struct:tcp_connect_and_offload_in	typeref:struct:tcp_connect_and_offload_in::ip_address_format
+ip_address	be_cmds.h	/^	u8 ip_address[16];$/;"	m	struct:ip_address_format
+ip_address_format	be_cmds.h	/^struct ip_address_format {$/;"	s
+ip_type	be_cmds.h	/^	u8 ip_type;$/;"	m	struct:ip_address_format
+ip_type	be_mgmt.h	/^	unsigned short ip_type;$/;"	m	struct:beiscsi_endpoint
+ip_version_string	be_mgmt.h	/^	u8 ip_version_string[32];$/;"	m	struct:mgmt_hba_attributes
+ir2t	be_main.h	/^	u8 ir2t;		\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+ir2t	be_main.h	/^	u8 ir2t[1];$/;"	m	struct:amap_beiscsi_offload_params
+is_header	be_main.h	/^	unsigned char is_header;$/;"	m	struct:async_pdu_handle
+is_link_state_evt	be_cmds.c	/^bool is_link_state_evt(u32 trailer)$/;"	f
+iscsi_bhs_addr_hi	be_main.h	/^	u8 iscsi_bhs_addr_hi[32];	\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_wrb
+iscsi_bhs_addr_lo	be_main.h	/^	u8 iscsi_bhs_addr_lo[32];	\/* DWORD 5 *\/$/;"	m	struct:amap_iscsi_wrb
+iscsi_cid_count	be_main.h	/^		unsigned int iscsi_cid_count;$/;"	m	struct:beiscsi_hba::__anon6
+iscsi_cid_start	be_main.h	/^		unsigned int iscsi_cid_start;$/;"	m	struct:beiscsi_hba::__anon6
+iscsi_cleanup_req	be_cmds.h	/^struct iscsi_cleanup_req {$/;"	s
+iscsi_data_pdu	be_main.h	/^	struct pdu_data_out iscsi_data_pdu;$/;"	m	struct:be_cmd_bhs	typeref:struct:be_cmd_bhs::pdu_data_out
+iscsi_data_pdu	be_main.h	/^	struct pdu_data_out iscsi_data_pdu;$/;"	m	struct:be_nonio_bhs	typeref:struct:be_nonio_bhs::pdu_data_out
+iscsi_features	be_main.h	/^		unsigned short iscsi_features;$/;"	m	struct:beiscsi_hba::__anon6
+iscsi_features	be_mgmt.h	/^	u8 iscsi_features;$/;"	m	struct:mgmt_hba_attributes
+iscsi_hdr	be_main.h	/^	struct iscsi_cmd iscsi_hdr;$/;"	m	struct:be_cmd_bhs	typeref:struct:be_cmd_bhs::iscsi_cmd
+iscsi_hdr	be_main.h	/^	struct iscsi_cmd iscsi_hdr;$/;"	m	struct:be_status_bhs	typeref:struct:be_status_bhs::iscsi_cmd
+iscsi_hdr	be_main.h	/^	struct iscsi_hdr iscsi_hdr;$/;"	m	struct:be_nonio_bhs	typeref:struct:be_nonio_bhs::iscsi_hdr
+iscsi_icd_count	be_main.h	/^		unsigned int iscsi_icd_count;$/;"	m	struct:beiscsi_hba::__anon6
+iscsi_icd_start	be_main.h	/^		unsigned int iscsi_icd_start;$/;"	m	struct:beiscsi_hba::__anon6
+iscsi_init_global_templates	be_main.c	/^static void iscsi_init_global_templates(struct beiscsi_hba *phba)$/;"	f	file:
+iscsi_invalidate_connection_params	be_mgmt.h	/^union iscsi_invalidate_connection_params {$/;"	u
+iscsi_invalidate_connection_params_in	be_mgmt.h	/^struct iscsi_invalidate_connection_params_in {$/;"	s
+iscsi_invalidate_connection_params_out	be_mgmt.h	/^struct iscsi_invalidate_connection_params_out {$/;"	s
+iscsi_sge	be_main.h	/^struct iscsi_sge {$/;"	s
+iscsi_target_context_update_wrb	be_main.h	/^struct iscsi_target_context_update_wrb {$/;"	s
+iscsi_ver_min_max	be_mgmt.h	/^	u8 iscsi_ver_min_max;$/;"	m	struct:mgmt_hba_attributes
+iscsi_wrb	be_main.h	/^struct iscsi_wrb {$/;"	s
+isid	be_cmds.h	/^	u8	isid[6];$/;"	m	struct:mgmt_session_info
+isr_lock	be_main.h	/^	spinlock_t isr_lock;$/;"	m	struct:beiscsi_hba
+isr_offset	be_main.h	/^		unsigned int isr_offset;$/;"	m	struct:beiscsi_hba::__anon6
+item_size	be_main.h	/^	u32 item_size;		\/* size in bytes of one object *\/$/;"	m	struct:be_ring
+itt	be_main.h	/^	u8 itt[32];		\/* ITT; initiator task tag *\/$/;"	m	struct:amap_pdu_data_out
+itt	be_main.h	/^	u8 itt[32];		\/* initiator id for ping or 0xffffffff *\/$/;"	m	struct:amap_pdu_nop_out
+itt	be_main.h	/^	u8 itt[32];		\/* initiator task tag *\/$/;"	m	struct:amap_pdu_base
+last_sge	be_main.h	/^	u8 last_sge;		\/* DWORD 2 *\/$/;"	m	struct:amap_iscsi_sge
+ldto	be_main.h	/^	unsigned int ldto;$/;"	m	struct:hba_parameters
+len	be.h	/^	u16 len;$/;"	m	struct:be_queue_info
+len	be_cmds.h	/^	u32 len;$/;"	m	struct:be_sge
+len	be_main.h	/^	u8 len[17];		\/* DWORD 3 *\/$/;"	m	struct:amap_iscsi_sge
+length	be_mgmt.h	/^	u32 length;		\/* DWORD 2 *\/$/;"	m	struct:mcc_sge
+length	be_mgmt.h	/^	u8 length[32];		\/* DWORD 2 *\/$/;"	m	struct:amap_mcc_sge
+libiscsi_itt	be_main.h	/^	itt_t libiscsi_itt;$/;"	m	struct:beiscsi_io_task
+link	be_main.h	/^	struct list_head link;$/;"	m	struct:async_pdu_handle	typeref:struct:async_pdu_handle::list_head
+link_state	be_cmds.h	/^	u32 link_state;$/;"	m	struct:be_cmd_req_get_mac_addr
+link_state	be_cmds.h	/^	u32 link_state;$/;"	m	struct:be_cmd_resp_get_mac_addr
+list	be_main.h	/^		struct list_head list;$/;"	m	struct:hwi_async_entry::__anon7	typeref:struct:hwi_async_entry::__anon7::list_head
+lo	be_cmds.h	/^	u32 lo;$/;"	m	struct:phys_addr
+login_in_progress	be_main.h	/^	unsigned short login_in_progress;$/;"	m	struct:beiscsi_conn
+long_delay	be_cmds.c	328;"	d	file:
+lro_base	be_cmds.h	/^	u32 lro_base;$/;"	m	struct:be_ulp_fw_cfg
+lro_count	be_cmds.h	/^	u32 lro_count;$/;"	m	struct:be_ulp_fw_cfg
+lt	be_main.h	/^	u8 lt;			\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+lt	be_main.h	/^	u8 lt;			\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_wrb
+lun	be_main.h	/^	u8 lun[14];		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+lun	be_main.h	/^	u8 lun[14];		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_wrb
+lun	be_main.h	/^	u8 lun[64];		\/* lun or opcode-specific fields *\/$/;"	m	struct:amap_pdu_base
+lun	be_main.h	/^	u8 lun[64];$/;"	m	struct:amap_pdu_data_out
+lun	be_main.h	/^	u8 lun[64];$/;"	m	struct:amap_pdu_nop_out
+mac	be_cmds.h	/^	struct mac_addr mac;$/;"	m	struct:be_cmd_resp_mac_query	typeref:struct:be_cmd_resp_mac_query::mac_addr
+mac	be_cmds.h	/^	struct macaddr mac[32];$/;"	m	struct:be_cmd_req_mcast_mac_config	typeref:struct:be_cmd_req_mcast_mac_config::macaddr
+mac_addr	be_cmds.h	/^struct mac_addr {$/;"	s
+mac_address	be_cmds.h	/^	u8 mac_address[6];$/;"	m	struct:be_cmd_resp_get_mac_addr
+mac_address	be_cmds.h	/^	u8 mac_address[ETH_ALEN];$/;"	m	struct:be_cmd_req_get_mac_addr
+mac_address	be_main.h	/^	u8 mac_address[ETH_ALEN];$/;"	m	struct:beiscsi_hba
+macaddr	be_cmds.h	/^struct macaddr {$/;"	s
+major_code	be_main.h	/^	u8 major_code[3];	\/* DWORD 0 *\/$/;"	m	struct:amap_eq_entry
+manufacturer_name	be_mgmt.h	/^	u8 manufacturer_name[32];$/;"	m	struct:mgmt_hba_attributes
+max_burst_length	be_cmds.h	/^	u32	max_burst_length;$/;"	m	struct:mgmt_session_login_options
+max_burst_length	be_main.h	/^	u8 max_burst_length[19];	\/* DWORD 1 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+max_burst_length	be_main.h	/^	u8 max_burst_length[32];$/;"	m	struct:amap_beiscsi_offload_params
+max_cdblength	be_mgmt.h	/^	u16 max_cdblength;$/;"	m	struct:mgmt_hba_attributes
+max_connections	be_cmds.h	/^	u16	max_connections;$/;"	m	struct:mgmt_session_login_options
+max_domains_supported	be_mgmt.h	/^	u8 max_domains_supported;$/;"	m	struct:mgmt_hba_attributes
+max_eqd	be_main.h	/^	u16 max_eqd;		\/* in usecs *\/$/;"	m	struct:hwi_context_memory
+max_frame_size	be_cmds.h	/^	u32 max_frame_size;$/;"	m	struct:be_cmd_req_get_mac_addr
+max_frame_size	be_cmds.h	/^	u32 max_frame_size;$/;"	m	struct:be_cmd_resp_get_mac_addr
+max_outstanding_r2t	be_cmds.h	/^	u16	max_outstanding_r2t;$/;"	m	struct:mgmt_session_login_options
+max_recv_datasegment_len_ini	be_cmds.h	/^	u32 max_recv_datasegment_len_ini;$/;"	m	struct:mgmt_conn_login_options
+max_recv_datasegment_len_tgt	be_cmds.h	/^	u32 max_recv_datasegment_len_tgt;$/;"	m	struct:mgmt_conn_login_options
+max_send_data_segment_length	be_main.h	/^	u8 max_send_data_segment_length[17];	\/* DWORD 2 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+max_send_data_segment_length	be_main.h	/^	u8 max_send_data_segment_length[32];$/;"	m	struct:amap_beiscsi_offload_params
+max_speed	be_cmds.h	/^	u32 max_speed;$/;"	m	struct:be_cmd_req_get_mac_addr
+max_speed	be_cmds.h	/^	u32 max_speed;$/;"	m	struct:be_cmd_resp_get_mac_addr
+mbox_lock	be.h	/^	spinlock_t mbox_lock;	\/* For serializing mbox cmds to BE card *\/$/;"	m	struct:be_ctrl_info
+mbox_mem	be.h	/^	struct be_dma_mem mbox_mem;$/;"	m	struct:be_ctrl_info	typeref:struct:be_ctrl_info::be_dma_mem
+mbox_mem_alloced	be.h	/^	struct be_dma_mem mbox_mem_alloced;$/;"	m	struct:be_ctrl_info	typeref:struct:be_ctrl_info::be_dma_mem
+mcc_alloc_index	be.h	/^	unsigned short mcc_alloc_index;$/;"	m	struct:be_ctrl_info
+mcc_cq_lock	be.h	/^	spinlock_t mcc_cq_lock;$/;"	m	struct:be_ctrl_info
+mcc_free_index	be.h	/^	unsigned short mcc_free_index;$/;"	m	struct:be_ctrl_info
+mcc_lock	be.h	/^	spinlock_t mcc_lock;	\/* For serializing mcc cmds to BE card *\/$/;"	m	struct:be_ctrl_info
+mcc_numtag	be.h	/^	unsigned int mcc_numtag[MAX_MCC_CMD + 1];$/;"	m	struct:be_ctrl_info
+mcc_obj	be.h	/^	struct be_mcc_obj mcc_obj;$/;"	m	struct:be_ctrl_info	typeref:struct:be_ctrl_info::be_mcc_obj
+mcc_sge	be_mgmt.h	/^struct mcc_sge {$/;"	s
+mcc_tag	be.h	/^	unsigned int mcc_tag[MAX_MCC_CMD];$/;"	m	struct:be_ctrl_info
+mcc_tag_available	be.h	/^	unsigned int mcc_tag_available;$/;"	m	struct:be_ctrl_info
+mcc_timeout	be.h	128;"	d
+mcc_wait	be.h	/^	wait_queue_head_t mcc_wait[MAX_MCC_CMD + 1];$/;"	m	struct:be_ctrl_info
+mcc_wrb	be_mgmt.h	/^struct mcc_wrb {$/;"	s
+mcc_wrb_payload	be_mgmt.h	/^struct mcc_wrb_payload {$/;"	s
+mem_array	be_main.h	/^	struct mem_array *mem_array;$/;"	m	struct:be_mem_descriptor	typeref:struct:be_mem_descriptor::mem_array
+mem_array	be_main.h	/^struct mem_array {$/;"	s
+mem_req	be_main.h	/^	unsigned int mem_req[SE_MEM_MAX];$/;"	m	struct:beiscsi_hba
+mgmt_auth_method_format	be_cmds.h	/^struct mgmt_auth_method_format {$/;"	s
+mgmt_chap_format	be_cmds.h	/^struct mgmt_chap_format {$/;"	s
+mgmt_check_supported_fw	be_mgmt.c	/^int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,$/;"	f
+mgmt_conn_info	be_cmds.h	/^struct	mgmt_conn_info {$/;"	s
+mgmt_conn_login_options	be_cmds.h	/^struct mgmt_conn_login_options {$/;"	s
+mgmt_controller_attributes	be_mgmt.h	/^struct mgmt_controller_attributes {$/;"	s
+mgmt_epfw_cleanup	be_mgmt.c	/^int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)$/;"	f
+mgmt_get_fw_config	be_mgmt.c	/^int mgmt_get_fw_config(struct be_ctrl_info *ctrl,$/;"	f
+mgmt_hba_attributes	be_mgmt.h	/^struct mgmt_hba_attributes {$/;"	s
+mgmt_invalidate_connection	be_mgmt.c	/^unsigned int mgmt_invalidate_connection(struct beiscsi_hba *phba,$/;"	f
+mgmt_invalidate_icds	be_mgmt.c	/^unsigned int  mgmt_invalidate_icds(struct beiscsi_hba *phba,$/;"	f
+mgmt_open_connection	be_mgmt.c	/^int mgmt_open_connection(struct beiscsi_hba *phba,$/;"	f
+mgmt_session_info	be_cmds.h	/^struct mgmt_session_info {$/;"	s
+mgmt_session_login_options	be_cmds.h	/^struct mgmt_session_login_options {$/;"	s
+mgmt_sgl_lock	be_main.h	/^	spinlock_t mgmt_sgl_lock;$/;"	m	struct:beiscsi_hba
+mgmt_upload_connection	be_mgmt.c	/^unsigned int mgmt_upload_connection(struct beiscsi_hba *phba,$/;"	f
+mgmt_ws_sz	be_main.h	/^	unsigned int mgmt_ws_sz;$/;"	m	struct:hba_parameters
+min_eqd	be_main.h	/^	u16 min_eqd;		\/* in usecs *\/$/;"	m	struct:hwi_context_memory
+minor_code	be_main.h	/^	u8 minor_code[12];	\/* DWORD 0 *\/$/;"	m	struct:amap_eq_entry
+mode	be_main.h	/^	u8 mode;		\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+msix_enabled	be_main.h	/^	bool msix_enabled;$/;"	m	struct:beiscsi_hba
+msix_entries	be_main.h	/^	struct msix_entry msix_entries[MAX_CPUS + 1];$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::msix_entry
+multifunction_device	be_mgmt.h	/^	u8 multifunction_device;$/;"	m	struct:mgmt_hba_attributes
+negotiated_login_options	be_cmds.h	/^	struct	mgmt_conn_login_options	negotiated_login_options;$/;"	m	struct:mgmt_conn_info	typeref:struct:mgmt_conn_info::mgmt_conn_login_options
+negotiated_login_options	be_cmds.h	/^	struct	mgmt_session_login_options negotiated_login_options;$/;"	m	struct:mgmt_session_info	typeref:struct:mgmt_session_info::mgmt_session_login_options
+netfilters	be_mgmt.h	/^	u8 netfilters;$/;"	m	struct:mgmt_controller_attributes
+nic_port_count	be_cmds.h	/^	u32 nic_port_count;$/;"	m	struct:be_cmd_req_get_mac_addr
+nic_port_count	be_cmds.h	/^	u32 nic_port_count;$/;"	m	struct:be_cmd_resp_get_mac_addr
+nodelay	be_cmds.h	/^	u8 nodelay;		\/* dword 0 *\/$/;"	m	struct:amap_cq_context
+nodelay	be_cmds.h	/^	u8 nodelay;		\/* dword 2 *\/$/;"	m	struct:amap_eq_context
+nonembedded_sgl	be_cmds.h	/^static inline struct be_sge *nonembedded_sgl(struct be_mcc_wrb *wrb)$/;"	f
+notpredblq	be_main.h	/^	u8 notpredblq[2];	\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+num	be_main.h	/^	u32 num;		\/* number of elements in queue *\/$/;"	m	struct:be_ring
+num_async_pdu_buf_cq_pages	be_main.h	/^	unsigned int num_async_pdu_buf_cq_pages;$/;"	m	struct:hba_parameters
+num_async_pdu_buf_pages	be_main.h	/^	unsigned int num_async_pdu_buf_pages;$/;"	m	struct:hba_parameters
+num_async_pdu_buf_sgl_pages	be_main.h	/^	unsigned int num_async_pdu_buf_sgl_pages;$/;"	m	struct:hba_parameters
+num_async_pdu_hdr_cq_pages	be_main.h	/^	unsigned int num_async_pdu_hdr_cq_pages;$/;"	m	struct:hba_parameters
+num_async_pdu_hdr_pages	be_main.h	/^	unsigned int num_async_pdu_hdr_pages;$/;"	m	struct:hba_parameters
+num_async_pdu_hdr_sgl_pages	be_main.h	/^	unsigned int num_async_pdu_hdr_sgl_pages;$/;"	m	struct:hba_parameters
+num_bits	be_cmds.h	/^	u32 num_bits;$/;"	m	struct:fragnum_bits_for_sgl_cra_in
+num_cons	be_main.h	/^	u8 num_cons[10];$/;"	m	struct:amap_i_t_dpdu_cqe
+num_cpus	be_main.h	/^	unsigned int num_cpus;$/;"	m	struct:beiscsi_hba
+num_cq_entries	be_main.h	/^	unsigned int num_cq_entries;$/;"	m	struct:hba_parameters
+num_cq_pages	be_main.h	/^	unsigned int num_cq_pages;$/;"	m	struct:hba_parameters
+num_cxn	be_main.h	/^	unsigned int num_cxn;$/;"	m	struct:hba_parameters
+num_elements	be_main.h	/^	unsigned int num_elements;	\/* number of elements in this$/;"	m	struct:be_mem_descriptor
+num_entries	be_main.h	/^		unsigned int num_entries;$/;"	m	struct:hwi_async_pdu_context::__anon8
+num_entries	be_main.h	/^		unsigned int num_entries;$/;"	m	struct:hwi_async_pdu_context::__anon9
+num_eq	be_cmds.h	/^	u32 num_eq;$/;"	m	struct:be_cmd_req_modify_eq_delay
+num_eq	be_cmds.h	/^	u32 num_eq;$/;"	m	struct:be_eq_delay_params_in
+num_eq_entries	be_main.h	/^	unsigned int num_eq_entries;$/;"	m	struct:hba_parameters
+num_eq_pages	be_main.h	/^	unsigned int num_eq_pages;$/;"	m	struct:hba_parameters
+num_hba	be_main.c	/^static unsigned int num_hba = 0;$/;"	v	file:
+num_mac	be_cmds.h	/^	u16 num_mac;$/;"	m	struct:be_cmd_req_mcast_mac_config
+num_mcc_cq_pages	be_main.h	/^	unsigned int num_mcc_cq_pages;$/;"	m	struct:hba_parameters
+num_mcc_pages	be_main.h	/^	unsigned int num_mcc_pages;$/;"	m	struct:hba_parameters
+num_pages	be_cmds.h	/^	u16 num_pages;		\/* sword *\/$/;"	m	struct:be_cmd_req_eq_create
+num_pages	be_cmds.h	/^	u16 num_pages;$/;"	m	struct:be_cmd_req_cq_create
+num_pages	be_cmds.h	/^	u16 num_pages;$/;"	m	struct:be_cmd_req_mcc_create
+num_pages	be_cmds.h	/^	u16 num_pages;$/;"	m	struct:be_defq_create_req
+num_pages	be_cmds.h	/^	u16 num_pages;$/;"	m	struct:be_post_sgl_pages_req
+num_pages	be_cmds.h	/^	u16 num_pages;$/;"	m	struct:be_wrbq_create_req
+num_popped	be_main.h	/^	u8 num_popped[13];$/;"	m	struct:amap_cq_db
+num_sge	be_main.h	/^	unsigned int num_sge;$/;"	m	struct:hba_parameters
+num_sge_per_io	be_main.h	/^	unsigned int num_sge_per_io;$/;"	m	struct:hba_parameters
+nxt_cqid	be_main.h	/^	unsigned int nxt_cqid;$/;"	m	struct:beiscsi_hba
+nxt_wrb_index	be_main.h	/^	unsigned short nxt_wrb_index;$/;"	m	struct:wrb_handle
+opcode	be_cmds.h	/^	u8 opcode;		\/* dword 0 *\/$/;"	m	struct:be_cmd_req_hdr
+opcode	be_main.h	/^	u8 opcode[6];		\/* opcode *\/$/;"	m	struct:amap_pdu_data_out
+opcode	be_main.h	/^	u8 opcode[6];		\/* opcode 0x00 *\/$/;"	m	struct:amap_pdu_nop_out
+opcode	be_main.h	/^	u8 opcode[6];$/;"	m	struct:amap_pdu_base
+openiscsi_ep	be_mgmt.h	/^	struct iscsi_endpoint *openiscsi_ep;$/;"	m	struct:beiscsi_endpoint	typeref:struct:beiscsi_endpoint::iscsi_endpoint
+over_run	be_main.h	/^	u8 over_run;		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+over_run	be_main.h	/^	u8 over_run;		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_wrb
+pa	be_main.h	/^	struct be_bus_address pa;$/;"	m	struct:async_pdu_handle	typeref:struct:async_pdu_handle::be_bus_address
+pa_base	be_main.h	/^		struct be_bus_address pa_base;$/;"	m	struct:hwi_async_pdu_context::__anon8	typeref:struct:hwi_async_pdu_context::__anon8::be_bus_address
+pa_base	be_main.h	/^		struct be_bus_address pa_base;$/;"	m	struct:hwi_async_pdu_context::__anon9	typeref:struct:hwi_async_pdu_context::__anon9::be_bus_address
+pa_hi	be_cmds.h	/^	u32 pa_hi;$/;"	m	struct:be_sge
+pa_hi	be_mgmt.h	/^	u32 pa_hi;		\/* dword 1 *\/$/;"	m	struct:mcc_sge
+pa_hi	be_mgmt.h	/^	u8 pa_hi[32];		\/* dword 1 *\/$/;"	m	struct:amap_mcc_sge
+pa_lo	be_cmds.h	/^	u32 pa_lo;$/;"	m	struct:be_sge
+pa_lo	be_mgmt.h	/^	u32 pa_lo;		\/* dword 0 *\/$/;"	m	struct:mcc_sge
+pa_lo	be_mgmt.h	/^	u8 pa_lo[32];		\/* dword 0 *\/$/;"	m	struct:amap_mcc_sge
+pad	be_cmds.h	/^	u16	pad;$/;"	m	struct:mgmt_session_info
+pad	be_main.h	/^	u8 pad[26];$/;"	m	struct:amap_beiscsi_offload_params
+pad1	be_main.h	/^	unsigned char pad1[16];$/;"	m	struct:be_cmd_bhs
+pad1	be_main.h	/^	unsigned char pad1[16];$/;"	m	struct:be_nonio_bhs
+pad1	be_main.h	/^	unsigned char pad1[16];$/;"	m	struct:be_status_bhs
+pad2	be_main.h	/^	unsigned char pad2[BE_SENSE_INFO_SIZE -$/;"	m	struct:be_cmd_bhs
+pad2	be_main.h	/^	unsigned char pad2[BE_SENSE_INFO_SIZE -$/;"	m	struct:be_nonio_bhs
+pad_addr_hi	be_main.h	/^	u8 pad_addr_hi[32];	\/* DWORD 8 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+pad_addr_lo	be_main.h	/^	u8 pad_addr_lo[32];	\/* DWORD 9 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+pad_buffer_addr_hi	be_main.h	/^	u8 pad_buffer_addr_hi[32];	\/* DWORD 6 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+pad_buffer_addr_lo	be_main.h	/^	u8 pad_buffer_addr_lo[32];	\/* DWORD 7 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+padding	be_cmds.h	/^	u8	padding[3];$/;"	m	struct:mgmt_auth_method_format
+page_offset	be_cmds.h	/^	u16 page_offset;$/;"	m	struct:be_post_sgl_pages_req
+pages	be_cmds.h	/^	struct phys_addr pages[26];$/;"	m	struct:be_post_sgl_pages_req	typeref:struct:be_post_sgl_pages_req::phys_addr
+pages	be_cmds.h	/^	struct phys_addr pages[4];$/;"	m	struct:be_cmd_req_cq_create	typeref:struct:be_cmd_req_cq_create::phys_addr
+pages	be_cmds.h	/^	struct phys_addr pages[8];$/;"	m	struct:be_cmd_req_eq_create	typeref:struct:be_cmd_req_eq_create::phys_addr
+pages	be_cmds.h	/^	struct phys_addr pages[8];$/;"	m	struct:be_cmd_req_mcc_create	typeref:struct:be_cmd_req_mcc_create::phys_addr
+pages	be_cmds.h	/^	struct phys_addr pages[8];$/;"	m	struct:be_defq_create_req	typeref:struct:be_defq_create_req::phys_addr
+pages	be_cmds.h	/^	struct phys_addr pages[8];$/;"	m	struct:be_wrbq_create_req	typeref:struct:be_wrbq_create_req::phys_addr
+pages	be_main.h	/^	u32 pages;		\/* queue size in pages *\/$/;"	m	struct:be_ring
+params	be_main.h	/^	struct hba_parameters params;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::hba_parameters
+params	be_mgmt.h	/^	struct mgmt_controller_attributes params;$/;"	m	struct:be_mgmt_controller_attributes	typeref:struct:be_mgmt_controller_attributes::mgmt_controller_attributes
+params	be_mgmt.h	/^	struct mgmt_controller_attributes params;$/;"	m	struct:be_mgmt_controller_attributes_resp	typeref:struct:be_mgmt_controller_attributes_resp::mgmt_controller_attributes
+pasync_ctx	be_main.h	/^	struct hwi_async_pdu_context *pasync_ctx;$/;"	m	struct:hwi_context_memory	typeref:struct:hwi_context_memory::hwi_async_pdu_context
+payload	be_cmds.h	/^	} payload;$/;"	m	struct:be_mcc_wrb	typeref:union:be_mcc_wrb::__anon1
+payload	be_mgmt.h	/^	struct amap_mcc_wrb_payload payload;$/;"	m	struct:amap_mcc_wrb	typeref:struct:amap_mcc_wrb::amap_mcc_wrb_payload
+payload	be_mgmt.h	/^	struct mcc_wrb_payload payload;$/;"	m	struct:mcc_wrb	typeref:struct:mcc_wrb::mcc_wrb_payload
+payload_length	be_cmds.h	/^	u32 payload_length;	\/* dword 1 *\/$/;"	m	struct:be_mcc_wrb
+payload_length	be_mgmt.h	/^	u32 payload_length;$/;"	m	struct:mcc_wrb
+payload_length	be_mgmt.h	/^	u8 payload_length[32];$/;"	m	struct:amap_mcc_wrb
+pbe_mcc_context	be_main.h	/^	struct be_mcc_wrb_context *pbe_mcc_context;$/;"	m	struct:hwi_context_memory	typeref:struct:hwi_context_memory::be_mcc_wrb_context
+pbs	be_main.h	/^	u8 pbs;			\/* DWORD 10 *\/$/;"	m	struct:amap_iscsi_wrb
+pbuffer	be_main.h	/^	void *pbuffer;$/;"	m	struct:async_pdu_handle
+pci_bus_number	be_mgmt.h	/^	u8 pci_bus_number;$/;"	m	struct:mgmt_controller_attributes
+pci_device_id	be_mgmt.h	/^	u16 pci_device_id;$/;"	m	struct:mgmt_controller_attributes
+pci_device_number	be_mgmt.h	/^	u8 pci_device_number;$/;"	m	struct:mgmt_controller_attributes
+pci_func_id	be_cmds.h	/^	u8 pci_func_id[8];	\/* dword 1 *\/$/;"	m	struct:amap_be_default_pdu_context
+pci_function	be_main.h	/^		unsigned int pci_function;$/;"	m	struct:beiscsi_hba::__anon6
+pci_function_number	be_mgmt.h	/^	u8 pci_function_number;$/;"	m	struct:mgmt_controller_attributes
+pci_pa	be_main.h	/^	struct be_bus_address pci_pa;	\/* CSR *\/$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::be_bus_address
+pci_sub_system_id	be_mgmt.h	/^	u16 pci_sub_system_id;$/;"	m	struct:mgmt_controller_attributes
+pci_sub_vendor_id	be_mgmt.h	/^	u16 pci_sub_vendor_id;$/;"	m	struct:mgmt_controller_attributes
+pci_va	be_main.h	/^	u8 __iomem *pci_va;	\/* PCI Config *\/$/;"	m	struct:beiscsi_hba
+pci_vendor_id	be_mgmt.h	/^	u16 pci_vendor_id;$/;"	m	struct:mgmt_controller_attributes
+pcicfg	be.h	/^	u8 __iomem *pcicfg;	\/* PCI config space *\/$/;"	m	struct:be_ctrl_info
+pcidev	be_main.h	/^	struct pci_dev *pcidev;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::pci_dev
+pd	be_cmds.h	/^	u8 pd[10];		\/* dword 1 *\/$/;"	m	struct:amap_cq_context
+pd	be_cmds.h	/^	u8 pd[10];		\/* dword 1 *\/$/;"	m	struct:amap_eq_context
+pdev	be.h	/^	struct pci_dev *pdev;$/;"	m	struct:be_ctrl_info	typeref:struct:be_ctrl_info::pci_dev
+pdid	be_cmds.h	/^	u8 pdid[9];$/;"	m	struct:amap_mcc_context
+pdu_base	be_main.h	/^struct pdu_base {$/;"	s
+pdu_data_out	be_main.h	/^struct pdu_data_out {$/;"	s
+pdu_nop_out	be_main.h	/^struct pdu_nop_out {$/;"	s
+permanent	be_cmds.h	/^	u8 permanent;$/;"	m	struct:be_cmd_req_mac_query
+pfrag	be_main.h	/^	struct iscsi_sge *pfrag;$/;"	m	struct:sgl_handle	typeref:struct:sgl_handle::iscsi_sge
+phase	be_cmds.h	/^		u32 phase;$/;"	m	struct:be_cmd_req_modify_eq_delay::__anon4
+phase	be_cmds.h	/^	u32 phase;$/;"	m	struct:eq_delay
+phase	be_cmds.h	/^	u8 phase[2];		\/* dword 2 *\/$/;"	m	struct:amap_eq_context
+phba	be.h	/^	struct beiscsi_hba *phba;$/;"	m	struct:be_eq_obj	typeref:struct:be_eq_obj::beiscsi_hba
+phba	be_main.h	/^	struct beiscsi_hba *phba;$/;"	m	struct:beiscsi_conn	typeref:struct:beiscsi_conn::beiscsi_hba
+phba	be_mgmt.h	/^	struct beiscsi_hba *phba;$/;"	m	struct:beiscsi_endpoint	typeref:struct:beiscsi_endpoint::beiscsi_hba
+phwi_ctrlr	be_main.h	/^	struct hwi_controller *phwi_ctrlr;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::hwi_controller
+phwi_ctxt	be_main.h	/^	struct hwi_context_memory *phwi_ctxt;$/;"	m	struct:hwi_controller	typeref:struct:hwi_controller::hwi_context_memory
+phy_port	be_mgmt.h	/^	u8 phy_port;$/;"	m	struct:mgmt_hba_attributes
+phys_addr	be_cmds.h	/^struct phys_addr {$/;"	s
+phys_port	be_cmds.h	/^	u32 phys_port;$/;"	m	struct:be_fw_cfg
+phys_port	be_main.h	/^		unsigned int phys_port;$/;"	m	struct:beiscsi_hba::__anon6
+physical_port	be_cmds.h	/^	u8 physical_port;$/;"	m	struct:be_async_event_link_state
+pidx	be_cmds.h	/^	u8 pidx[11];		\/* dword 1 *\/$/;"	m	struct:amap_cq_context
+pidx	be_cmds.h	/^	u8 pidx[13];		\/* dword 1 *\/$/;"	m	struct:amap_eq_context
+pidx	be_main.h	/^	u32 pidx;		\/* producer index -- not used by most rings *\/$/;"	m	struct:be_ring
+pio_handle	be_main.h	/^	struct iscsi_task *pio_handle;$/;"	m	struct:wrb_handle	typeref:struct:wrb_handle::iscsi_task
+plast_wrb	be_main.h	/^	struct iscsi_wrb *plast_wrb;$/;"	m	struct:hwi_wrb_context	typeref:struct:hwi_wrb_context::iscsi_wrb
+plogin_sgl_handle	be_main.h	/^	struct sgl_handle *plogin_sgl_handle;$/;"	m	struct:beiscsi_conn	typeref:struct:beiscsi_conn::sgl_handle
+plogin_wrb_handle	be_main.h	/^	struct wrb_handle *plogin_wrb_handle;$/;"	m	struct:beiscsi_conn	typeref:struct:beiscsi_conn::wrb_handle
+pmcc_wrb_base	be_main.h	/^	struct mcc_wrb *pmcc_wrb_base;$/;"	m	struct:hwi_controller	typeref:struct:hwi_controller::mcc_wrb
+port_duplex	be_cmds.h	/^	u8 port_duplex;$/;"	m	struct:be_async_event_link_state
+port_fault	be_cmds.h	/^	u8 port_fault;$/;"	m	struct:be_async_event_link_state
+port_link_status	be_cmds.h	/^	u8 port_link_status;$/;"	m	struct:be_async_event_link_state
+port_number	be_cmds.h	/^	u8 port_number;		\/* dword 0 *\/$/;"	m	struct:be_cmd_req_hdr
+port_speed	be_cmds.h	/^	u8 port_speed;$/;"	m	struct:be_async_event_link_state
+prod_index	be_cmds.h	/^	u8 prod_index[14];$/;"	m	struct:amap_mcc_context
+promiscuous	be_cmds.h	/^	u8 promiscuous;$/;"	m	struct:be_cmd_req_mcast_mac_config
+psgl_handle	be_main.h	/^	struct sgl_handle *psgl_handle;$/;"	m	struct:beiscsi_io_task	typeref:struct:beiscsi_io_task::sgl_handle
+psgl_handle_base	be_main.h	/^	struct sgl_handle *psgl_handle_base;$/;"	m	struct:hwi_controller	typeref:struct:hwi_controller::sgl_handle
+ptr2nextwrb	be_main.h	/^	u8 ptr2nextwrb[8];	\/* DWORD 1 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+ptr2nextwrb	be_main.h	/^	u8 ptr2nextwrb[8];	\/* DWORD 1 *\/$/;"	m	struct:amap_iscsi_wrb
+pwrb	be_main.h	/^	struct iscsi_wrb *pwrb;$/;"	m	struct:wrb_handle	typeref:struct:wrb_handle::iscsi_wrb
+pwrb_handle	be_main.h	/^	struct wrb_handle *pwrb_handle;$/;"	m	struct:beiscsi_io_task	typeref:struct:beiscsi_io_task::wrb_handle
+pwrb_handle_base	be_main.h	/^	struct wrb_handle **pwrb_handle_base;$/;"	m	struct:hwi_wrb_context	typeref:struct:hwi_wrb_context::wrb_handle
+pwrb_handle_basestd	be_main.h	/^	struct wrb_handle **pwrb_handle_basestd;$/;"	m	struct:hwi_wrb_context	typeref:struct:hwi_wrb_context::wrb_handle
+q	be.h	/^	struct be_queue_info q;$/;"	m	struct:be_eq_obj	typeref:struct:be_eq_obj::be_queue_info
+q	be.h	/^	struct be_queue_info q;$/;"	m	struct:be_mcc_obj	typeref:struct:be_mcc_obj::be_queue_info
+qid	be_main.h	/^	u8 qid[10];$/;"	m	struct:amap_cq_db
+queue_get_wrb	be.h	/^static inline void *queue_get_wrb(struct be_queue_info *q, unsigned int wrb_num)$/;"	f
+queue_head_inc	be.h	/^static inline void queue_head_inc(struct be_queue_info *q)$/;"	f
+queue_head_node	be.h	/^static inline void *queue_head_node(struct be_queue_info *q)$/;"	f
+queue_tail_inc	be.h	/^static inline void queue_tail_inc(struct be_queue_info *q)$/;"	f
+queue_tail_node	be.h	/^static inline void *queue_tail_node(struct be_queue_info *q)$/;"	f
+r2t_exp_dtl	be_main.h	/^	u8 r2t_exp_dtl[24];	\/* DWORD 1 *\/$/;"	m	struct:amap_iscsi_wrb
+read_mac_address	be_main.h	/^	unsigned int read_mac_address;$/;"	m	struct:beiscsi_hba
+rearm	be_main.h	/^	u8 rearm[1];$/;"	m	struct:amap_cq_db
+redboot_version_string	be_mgmt.h	/^	u8 redboot_version_string[32];$/;"	m	struct:mgmt_hba_attributes
+ref_handle	be_mgmt.h	/^	unsigned int ref_handle;$/;"	m	struct:invalidate_commands_params_in
+ref_handle	be_mgmt.h	/^	unsigned int ref_handle;$/;"	m	struct:invalidate_commands_params_out
+ref_sgl_icd_idx	be_main.h	/^	u8 ref_sgl_icd_idx[12];	\/* DWORD 15 *\/$/;"	m	struct:amap_iscsi_wrb
+request	be_cmds.h	/^	struct tcp_upload_params_in request;$/;"	m	union:tcp_upload_params	typeref:struct:tcp_upload_params::tcp_upload_params_in
+request	be_mgmt.h	/^	struct invalidate_commands_params_in request;$/;"	m	union:invalidate_commands_params	typeref:struct:invalidate_commands_params::invalidate_commands_params_in
+request	be_mgmt.h	/^	struct iscsi_invalidate_connection_params_in request;$/;"	m	union:iscsi_invalidate_connection_params	typeref:struct:iscsi_invalidate_connection_params::iscsi_invalidate_connection_params_in
+request_length	be_cmds.h	/^	u32 request_length;	\/* dword 2 *\/$/;"	m	struct:be_cmd_req_hdr
+reserved	be_cmds.h	/^	u8 reserved;$/;"	m	struct:ip_address_format
+reserved1	be_main.h	/^	u8 reserved1[16];$/;"	m	struct:amap_pdu_nop_out
+reserved1	be_main.h	/^	u8 reserved1[24];	\/* opcode-specific fields *\/$/;"	m	struct:amap_pdu_base
+reserved4	be_main.h	/^	u8 reserved4[224];$/;"	m	struct:amap_pdu_base
+reserved5	be_main.h	/^	u8 reserved5[128];$/;"	m	struct:amap_pdu_nop_out
+reset_seq	be_cmds.h	/^	u32 reset_seq;$/;"	m	struct:tcp_upload_params_in
+resource_id	be_main.h	/^	u8 resource_id[16];	\/* DWORD 0 *\/$/;"	m	struct:amap_eq_entry
+resp_hdr	be_cmds.h	/^	struct be_cmd_resp_hdr resp_hdr;$/;"	m	struct:be_cmd_resp_eq_create	typeref:struct:be_cmd_resp_eq_create::be_cmd_resp_hdr
+resp_hdr	be_cmds.h	/^	struct be_cmd_resp_hdr resp_hdr;$/;"	m	struct:be_wrbq_create_resp	typeref:struct:be_wrbq_create_resp::be_cmd_resp_hdr
+response	be_cmds.h	/^	struct tcp_upload_params_out response;$/;"	m	union:tcp_upload_params	typeref:struct:tcp_upload_params::tcp_upload_params_out
+response	be_mgmt.h	/^	struct invalidate_commands_params_out response;$/;"	m	union:invalidate_commands_params	typeref:struct:invalidate_commands_params::invalidate_commands_params_out
+response	be_mgmt.h	/^	struct iscsi_invalidate_connection_params_out response;$/;"	m	union:iscsi_invalidate_connection_params	typeref:struct:iscsi_invalidate_connection_params::iscsi_invalidate_connection_params_out
+response_length	be_cmds.h	/^	u32 response_length;	\/* dword 2 *\/$/;"	m	struct:be_cmd_resp_hdr
+ring_base	be_main.h	/^		void *ring_base;$/;"	m	struct:hwi_async_pdu_context::__anon8
+ring_base	be_main.h	/^		void *ring_base;$/;"	m	struct:hwi_async_pdu_context::__anon9
+ring_size	be_cmds.h	/^	u8 ring_size[4];	\/* dword 0 *\/$/;"	m	struct:amap_be_default_pdu_context
+ring_size	be_cmds.h	/^	u8 ring_size[4];$/;"	m	struct:amap_mcc_context
+ring_state	be_cmds.h	/^	u8 ring_state[4];	\/* dword 0 *\/$/;"	m	struct:amap_be_default_pdu_context
+rq_base	be_cmds.h	/^	u32 rq_base;$/;"	m	struct:be_ulp_fw_cfg
+rq_count	be_cmds.h	/^	u32 rq_count;$/;"	m	struct:be_ulp_fw_cfg
+rsvd	be_cmds.h	/^	u32 rsvd;		\/* dword 4 *\/$/;"	m	struct:be_mcc_wrb
+rsvd	be_cmds.h	/^	u32 rsvd[23];$/;"	m	struct:be_cmd_req_get_mac_addr
+rsvd	be_cmds.h	/^	u32 rsvd[23];$/;"	m	struct:be_cmd_resp_get_mac_addr
+rsvd	be_cmds.h	/^	u8 rsvd[6];		\/* dword 2 *\/$/;"	m	struct:amap_sol_cqe_ring
+rsvd0	be_cmds.h	/^	u16	rsvd0;$/;"	m	struct:mgmt_session_login_options
+rsvd0	be_cmds.h	/^	u16 rsvd0;		\/* sword *\/$/;"	m	struct:be_cmd_req_eq_create
+rsvd0	be_cmds.h	/^	u16 rsvd0;		\/* sword *\/$/;"	m	struct:be_cmd_resp_eq_create
+rsvd0	be_cmds.h	/^	u16 rsvd0;$/;"	m	struct:be_cmd_req_cq_create
+rsvd0	be_cmds.h	/^	u16 rsvd0;$/;"	m	struct:be_cmd_req_mcc_create
+rsvd0	be_cmds.h	/^	u16 rsvd0;$/;"	m	struct:be_cmd_resp_cq_create
+rsvd0	be_cmds.h	/^	u16 rsvd0;$/;"	m	struct:be_cmd_resp_mcc_create
+rsvd0	be_cmds.h	/^	u16 rsvd0;$/;"	m	struct:be_defq_create_resp
+rsvd0	be_cmds.h	/^	u16 rsvd0;$/;"	m	struct:be_wrbq_create_resp
+rsvd0	be_cmds.h	/^	u16 rsvd0;$/;"	m	struct:tcp_connect_and_offload_out
+rsvd0	be_cmds.h	/^	u32 rsvd0;		\/* dword 3 *\/$/;"	m	struct:be_cmd_req_hdr
+rsvd0	be_cmds.h	/^	u32 rsvd0;$/;"	m	struct:be_post_sgl_pages_req
+rsvd0	be_cmds.h	/^	u32 rsvd0;$/;"	m	struct:ip_address_format
+rsvd0	be_cmds.h	/^	u8 rsvd0;		\/* dword 0 *\/$/;"	m	struct:amap_cq_context
+rsvd0	be_cmds.h	/^	u8 rsvd0;$/;"	m	struct:be_defq_create_req
+rsvd0	be_cmds.h	/^	u8 rsvd0;$/;"	m	struct:be_wrbq_create_req
+rsvd0	be_cmds.h	/^	u8 rsvd0;$/;"	m	struct:mgmt_conn_login_options
+rsvd0	be_cmds.h	/^	u8 rsvd0[2];$/;"	m	struct:amap_mcc_context
+rsvd0	be_cmds.h	/^	u8 rsvd0[3];		\/* dword 0 *\/$/;"	m	struct:amap_be_default_pdu_context
+rsvd0	be_cmds.h	/^	u8 rsvd0[3];		\/* dword 0 *\/$/;"	m	struct:amap_eq_context
+rsvd0	be_cmds.h	/^	u8 rsvd0[3];$/;"	m	struct:tcp_connect_and_offload_in
+rsvd0	be_cmds.h	/^	u8 rsvd0[7];$/;"	m	struct:be_async_event_link_state
+rsvd0	be_main.h	/^	u8 rsvd0[20];		\/* DWORD 2 *\/$/;"	m	struct:amap_iscsi_wrb
+rsvd0	be_main.h	/^	u8 rsvd0[2];		\/* should be 0 *\/$/;"	m	struct:amap_pdu_data_out
+rsvd0	be_main.h	/^	u8 rsvd0[4];$/;"	m	struct:amap_i_t_dpdu_cqe
+rsvd0	be_main.h	/^	u8 rsvd0[5];		\/* DWORD 1 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rsvd0	be_main.h	/^	u8 rsvd0[5];$/;"	m	struct:amap_cq_db
+rsvd0	be_main.h	/^	u8 rsvd0[9];		\/* DWORD 2 *\/$/;"	m	struct:amap_iscsi_sge
+rsvd0	be_mgmt.h	/^	u8 rsvd0[2];		\/* DWORD 0 *\/$/;"	m	struct:amap_mcc_wrb
+rsvd0	be_mgmt.h	/^	u8 rsvd0[2];$/;"	m	struct:mgmt_hba_attributes
+rsvd0	be_mgmt.h	/^	u8 rsvd0[3];$/;"	m	struct:mgmt_controller_attributes
+rsvd1	be_cmds.h	/^	u32 rsvd1;$/;"	m	struct:be_post_sgl_pages_req
+rsvd1	be_cmds.h	/^	u8 rsvd1;		\/* dword 0 *\/$/;"	m	struct:amap_cq_context
+rsvd1	be_cmds.h	/^	u8 rsvd1;		\/* dword 0 *\/$/;"	m	struct:amap_eq_context
+rsvd1	be_cmds.h	/^	u8 rsvd1[32];$/;"	m	struct:amap_mcc_context
+rsvd1	be_cmds.h	/^	u8 rsvd1[8];		\/* dword 0 *\/$/;"	m	struct:amap_be_default_pdu_context
+rsvd1	be_main.h	/^	u8 rsvd1[15];		\/* DWORD 2 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rsvd1	be_main.h	/^	u8 rsvd1[15];		\/* DWORD 3 *\/$/;"	m	struct:amap_iscsi_sge
+rsvd1	be_main.h	/^	u8 rsvd1[2];$/;"	m	struct:amap_cq_db
+rsvd1	be_main.h	/^	u8 rsvd1[6];		\/* DWORD 10 *\/$/;"	m	struct:amap_iscsi_wrb
+rsvd1	be_main.h	/^	u8 rsvd1[7];$/;"	m	struct:amap_pdu_data_out
+rsvd1	be_mgmt.h	/^	u8 rsvd1[16];		\/* DWORD 0 *\/$/;"	m	struct:amap_mcc_wrb
+rsvd10	be_main.h	/^	u8 rsvd10[32];		\/* DWORD 15 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rsvd2	be_cmds.h	/^	u8 rsvd2;		\/* dword 1 *\/$/;"	m	struct:amap_be_default_pdu_context
+rsvd2	be_cmds.h	/^	u8 rsvd2;		\/* dword 1 *\/$/;"	m	struct:amap_cq_context
+rsvd2	be_cmds.h	/^	u8 rsvd2[32];$/;"	m	struct:amap_mcc_context
+rsvd2	be_cmds.h	/^	u8 rsvd2[3];		\/* dword 1 *\/$/;"	m	struct:amap_eq_context
+rsvd2	be_main.h	/^	u8 rsvd2[16];$/;"	m	struct:amap_pdu_data_out
+rsvd2	be_main.h	/^	u8 rsvd2[2];		\/* DWORD 3 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rsvd2	be_main.h	/^	u8 rsvd2[9];		\/* DWORD 14 *\/$/;"	m	struct:amap_iscsi_wrb
+rsvd2	be_mgmt.h	/^	u32 rsvd2[1];		\/* DWORD 4 *\/$/;"	m	struct:mcc_wrb
+rsvd2	be_mgmt.h	/^	u8 rsvd2[32];		\/* DWORD 4 *\/$/;"	m	struct:amap_mcc_wrb
+rsvd3	be_cmds.h	/^	u8 rsvd3[4];		\/* dword 2 *\/$/;"	m	struct:amap_cq_context
+rsvd3	be_cmds.h	/^	u8 rsvd3[4];		\/* dword 2 *\/$/;"	m	struct:amap_eq_context
+rsvd3	be_cmds.h	/^	u8 rsvd3[5];		\/* dword 2 *\/$/;"	m	struct:amap_be_default_pdu_context
+rsvd3	be_main.h	/^	u8 rsvd3[2];		\/* DWORD 15 *\/$/;"	m	struct:amap_iscsi_wrb
+rsvd3	be_main.h	/^	u8 rsvd3[32];$/;"	m	struct:amap_pdu_data_out
+rsvd3	be_main.h	/^	u8 rsvd3[5];		\/* DWORD 3 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rsvd4	be_cmds.h	/^	u8 rsvd4;		\/* dword 2 *\/$/;"	m	struct:amap_eq_context
+rsvd4	be_cmds.h	/^	u8 rsvd4[20];		\/* dword 2 *\/$/;"	m	struct:amap_cq_context
+rsvd4	be_cmds.h	/^	u8 rsvd4[32];		\/* dword 3 *\/$/;"	m	struct:amap_be_default_pdu_context
+rsvd4	be_main.h	/^	u8 rsvd4[16];		\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rsvd4	be_main.h	/^	u8 rsvd4[32];$/;"	m	struct:amap_pdu_data_out
+rsvd5	be_cmds.h	/^	u8 rsvd5[2];		\/* dword 2 *\/$/;"	m	struct:amap_eq_context
+rsvd5	be_cmds.h	/^	u8 rsvd5[32];		\/* dword 3 *\/$/;"	m	struct:amap_cq_context
+rsvd5	be_main.h	/^	u8 rsvd5[32];		\/* DWORD 10 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rsvd5	be_main.h	/^	u8 rsvd5[32];$/;"	m	struct:amap_pdu_data_out
+rsvd6	be_cmds.h	/^	u8 rsvd6[4];		\/* dword 2 *\/$/;"	m	struct:amap_eq_context
+rsvd6	be_main.h	/^	u8 rsvd6[32];		\/* DWORD 11 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rsvd7	be_cmds.h	/^	u8 rsvd7[32];		\/* dword 3 *\/$/;"	m	struct:amap_eq_context
+rsvd7	be_main.h	/^	u8 rsvd7[32];		\/* DWORD 12 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rsvd8	be_main.h	/^	u8 rsvd8[32];		\/* DWORD 13 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rsvd9	be_main.h	/^	u8 rsvd9[32];		\/* DWORD 14 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+rx_pdid	be_cmds.h	/^	u8 rx_pdid[9];		\/* dword 1 *\/$/;"	m	struct:amap_be_default_pdu_context
+rx_pdid_not_valid	be_cmds.h	/^	u8 rx_pdid_not_valid;	\/* dword 2 *\/$/;"	m	struct:amap_be_default_pdu_context
+rx_pdid_valid	be_cmds.h	/^	u8 rx_pdid_valid;	\/* dword 1 *\/$/;"	m	struct:amap_be_default_pdu_context
+s	be_cmds.h	/^	u8 s;			\/* dword 0 *\/$/;"	m	struct:amap_sol_cqe
+s	be_cmds.h	/^	u8 s;			\/* dword 0 *\/$/;"	m	struct:amap_sol_cqe_ring
+save_cfg	be_mgmt.h	/^	unsigned short save_cfg;$/;"	m	struct:iscsi_invalidate_connection_params_in
+scsi_cmnd	be_main.h	/^	struct scsi_cmnd *scsi_cmnd;$/;"	m	struct:beiscsi_io_task	typeref:struct:beiscsi_io_task::scsi_cmnd
+seeprom_version_hi	be_mgmt.h	/^	u8 seeprom_version_hi;$/;"	m	struct:mgmt_hba_attributes
+seeprom_version_lo	be_mgmt.h	/^	u8 seeprom_version_lo;$/;"	m	struct:mgmt_hba_attributes
+sense_info	be_main.h	/^	unsigned char sense_info[BE_SENSE_INFO_SIZE];$/;"	m	struct:be_status_bhs
+sess	be_mgmt.h	/^	struct beiscsi_sess *sess;$/;"	m	struct:beiscsi_endpoint	typeref:struct:beiscsi_endpoint::beiscsi_sess
+session_flags	be_cmds.h	/^	u32	session_flags;$/;"	m	struct:mgmt_session_info
+session_handle	be_cmds.h	/^	u32	session_handle;$/;"	m	struct:mgmt_session_info
+session_handle	be_cmds.h	/^	u32 session_handle;$/;"	m	struct:be_cmd_req_get_session
+session_handle	be_mgmt.h	/^	unsigned int session_handle;$/;"	m	struct:iscsi_invalidate_connection_params_in
+session_handle	be_mgmt.h	/^	unsigned int session_handle;$/;"	m	struct:iscsi_invalidate_connection_params_out
+session_info	be_cmds.h	/^	struct mgmt_session_info session_info;$/;"	m	struct:be_cmd_resp_get_session	typeref:struct:be_cmd_resp_get_session::mgmt_session_info
+session_state	be_main.h	/^	u8 session_state[3];	\/* DWORD 3 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+sge0_addr_hi	be_main.h	/^	u8 sge0_addr_hi[32];	\/* DWORD 8 *\/$/;"	m	struct:amap_iscsi_wrb
+sge0_addr_lo	be_main.h	/^	u8 sge0_addr_lo[32];	\/* DWORD 9  *\/$/;"	m	struct:amap_iscsi_wrb
+sge0_in_ddr	be_main.h	/^	u8 sge0_in_ddr;		\/* DWORD 11 *\/$/;"	m	struct:amap_iscsi_wrb
+sge0_last	be_main.h	/^	u8 sge0_last;		\/* DWORD 10 *\/$/;"	m	struct:amap_iscsi_wrb
+sge0_len	be_main.h	/^	u8 sge0_len[17];	\/* DWORD 11 *\/$/;"	m	struct:amap_iscsi_wrb
+sge0_offset	be_main.h	/^	u8 sge0_offset[22];	\/* DWORD 10 *\/$/;"	m	struct:amap_iscsi_wrb
+sge1_addr_hi	be_main.h	/^	u8 sge1_addr_hi[32];	\/* DWORD 12 *\/$/;"	m	struct:amap_iscsi_wrb
+sge1_addr_lo	be_main.h	/^	u8 sge1_addr_lo[32];	\/* DWORD 13 *\/$/;"	m	struct:amap_iscsi_wrb
+sge1_in_ddr	be_main.h	/^	u8 sge1_in_ddr;		\/* DWORD 15 *\/$/;"	m	struct:amap_iscsi_wrb
+sge1_last	be_main.h	/^	u8 sge1_last;		\/* DWORD 14 *\/$/;"	m	struct:amap_iscsi_wrb
+sge1_len	be_main.h	/^	u8 sge1_len[17];	\/* DWORD 15 *\/$/;"	m	struct:amap_iscsi_wrb
+sge1_r2t_offset	be_main.h	/^	u8 sge1_r2t_offset[22];	\/* DWORD 14 *\/$/;"	m	struct:amap_iscsi_wrb
+sge_count	be_mgmt.h	/^	u8 sge_count[5];	\/* DWORD 0 *\/$/;"	m	struct:amap_mcc_wrb
+sge_offset	be_main.h	/^	u8 sge_offset[22];	\/* DWORD 2 *\/$/;"	m	struct:amap_iscsi_sge
+sgl	be_cmds.h	/^		struct be_sge sgl[19];	\/* used by non-embedded cmds *\/$/;"	m	union:be_mcc_wrb::__anon1	typeref:struct:be_mcc_wrb::__anon1::be_sge
+sgl	be_mgmt.h	/^		struct amap_mcc_sge sgl[19];$/;"	m	union:amap_mcc_wrb_payload::__anon10	typeref:struct:amap_mcc_wrb_payload::__anon10::amap_mcc_sge
+sgl	be_mgmt.h	/^		struct mcc_sge sgl[19];$/;"	m	union:mcc_wrb_payload::__anon11	typeref:struct:mcc_wrb_payload::__anon11::mcc_sge
+sgl_handle	be_main.h	/^struct sgl_handle {$/;"	s
+sgl_hndl_array	be_main.h	/^	struct sgl_handle **sgl_hndl_array;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::sgl_handle
+sgl_icd_idx	be_main.h	/^	u8 sgl_icd_idx[12];	\/* DWORD 2 *\/$/;"	m	struct:amap_iscsi_wrb
+sgl_index	be_main.h	/^	unsigned int sgl_index;$/;"	m	struct:sgl_handle
+shost	be_main.h	/^	struct Scsi_Host *shost;$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::Scsi_Host
+size	be.h	/^	u32 size;$/;"	m	struct:be_dma_mem
+size	be_cmds.h	/^	u8 size;		\/* dword 0 *\/$/;"	m	struct:amap_eq_context
+size	be_main.h	/^	unsigned int size;		\/* Size required by memory block *\/$/;"	m	struct:mem_array
+size_in_bytes	be_main.h	/^	unsigned int size_in_bytes;	\/* Size required by memory block *\/$/;"	m	struct:be_mem_descriptor
+size_of_struct	be_cmds.h	/^	u16 size_of_struct;$/;"	m	struct:mac_addr
+size_of_structure	be_cmds.h	/^	u16 size_of_structure;$/;"	m	struct:be_cmd_req_get_mac_addr
+size_of_structure	be_cmds.h	/^	u16 size_of_structure;$/;"	m	struct:be_cmd_resp_get_mac_addr
+size_of_structure	be_cmds.h	/^	u16 size_of_structure;$/;"	m	struct:ip_address_format
+sol_cqe	be_cmds.h	/^struct sol_cqe {$/;"	s
+solevent	be_cmds.h	/^	u8 solevent;		\/* dword 0 *\/$/;"	m	struct:amap_cq_context
+solevent	be_cmds.h	/^	u8 solevent;		\/* dword 1 *\/$/;"	m	struct:amap_eq_context
+special	be_mgmt.h	/^	u8 special[8];		\/* DWORD 0 *\/$/;"	m	struct:amap_mcc_wrb
+speed	be_cmds.h	/^	u32 speed;$/;"	m	struct:be_cmd_req_get_mac_addr
+speed	be_cmds.h	/^	u32 speed;$/;"	m	struct:be_cmd_resp_get_mac_addr
+sq_base	be_cmds.h	/^	u32 sq_base;$/;"	m	struct:be_ulp_fw_cfg
+sq_count	be_cmds.h	/^	u32 sq_count;$/;"	m	struct:be_ulp_fw_cfg
+src_ipaddr	be_cmds.h	/^	struct	ip_address_format	src_ipaddr;$/;"	m	struct:mgmt_conn_info	typeref:struct:mgmt_conn_info::ip_address_format
+src_port	be_cmds.h	/^	u16	src_port;$/;"	m	struct:mgmt_conn_info
+stalled	be_cmds.h	/^	u8 stalled;		\/* dword 1 *\/$/;"	m	struct:amap_cq_context
+stalled	be_cmds.h	/^	u8 stalled;		\/* dword 1 *\/$/;"	m	struct:amap_eq_context
+stat_sn	be_main.h	/^	u8 stat_sn[32];		\/* DWORD 5 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+state	be_main.h	/^	unsigned int state;$/;"	m	struct:beiscsi_hba
+status	be_cmds.h	/^	u32	status;$/;"	m	struct:mgmt_session_info
+status	be_cmds.h	/^	u32 status;		\/* dword 0 *\/$/;"	m	struct:be_mcc_compl
+status	be_cmds.h	/^	u32 status;		\/* dword 1 *\/$/;"	m	struct:be_cmd_resp_hdr
+subsystem	be_cmds.h	/^	u8 subsystem;		\/* dword 0 *\/$/;"	m	struct:be_cmd_req_hdr
+supported_modes	be_mgmt.h	/^	u32 supported_modes;$/;"	m	struct:mgmt_hba_attributes
+swap_dws	be.h	/^static inline void swap_dws(void *wrb, int len)$/;"	f
+table	be_mgmt.h	/^	struct invalidate_command_table table[128];$/;"	m	struct:invalidate_commands_params_in	typeref:struct:invalidate_commands_params_in::invalidate_command_table
+tag	be_mgmt.h	/^	u32 tag[2];		\/* DWORD 2 *\/$/;"	m	struct:mcc_wrb
+tag	be_mgmt.h	/^	u8 tag[64];		\/* DWORD 2 *\/$/;"	m	struct:amap_mcc_wrb
+tag0	be_cmds.h	/^	u32 tag0;		\/* dword 1 *\/$/;"	m	struct:be_mcc_compl
+tag0	be_cmds.h	/^	u32 tag0;		\/* dword 2 *\/$/;"	m	struct:be_mcc_wrb
+tag1	be_cmds.h	/^	u32 tag1;		\/* dword 2 *\/$/;"	m	struct:be_mcc_compl
+tag1	be_cmds.h	/^	u32 tag1;		\/* dword 3 *\/$/;"	m	struct:be_mcc_wrb
+tail	be.h	/^	u16 tail, head;$/;"	m	struct:be_queue_info
+target_chap_name	be_cmds.h	/^	u8  target_chap_name[256];$/;"	m	struct:mgmt_chap_format
+target_chap_name_length	be_cmds.h	/^	u16 target_chap_name_length;$/;"	m	struct:mgmt_chap_format
+target_name	be_cmds.h	/^	u8	target_name[224];$/;"	m	struct:mgmt_session_info
+target_secret	be_cmds.h	/^	u8  target_secret[16];$/;"	m	struct:mgmt_chap_format
+target_secret_length	be_cmds.h	/^	u16 target_secret_length;$/;"	m	struct:mgmt_chap_format
+task	be_main.h	/^	struct iscsi_task *task;$/;"	m	struct:beiscsi_conn	typeref:struct:beiscsi_conn::iscsi_task
+task	be_main.h	/^	struct iscsi_task *task;$/;"	m	struct:sgl_handle	typeref:struct:sgl_handle::iscsi_task
+tcp_connect_and_offload_in	be_cmds.h	/^struct tcp_connect_and_offload_in {$/;"	s
+tcp_connect_and_offload_out	be_cmds.h	/^struct tcp_connect_and_offload_out {$/;"	s
+tcp_mss	be_cmds.h	/^	u32 tcp_mss;$/;"	m	struct:mgmt_conn_login_options
+tcp_port	be_cmds.h	/^	u16 tcp_port;$/;"	m	struct:tcp_connect_and_offload_in
+tcp_upload_params	be_cmds.h	/^union tcp_upload_params {$/;"	u
+tcp_upload_params_in	be_cmds.h	/^struct tcp_upload_params_in {$/;"	s
+tcp_upload_params_out	be_cmds.h	/^struct tcp_upload_params_out {$/;"	s
+tcp_window_size	be_cmds.h	/^	u32 tcp_window_size;$/;"	m	struct:mgmt_conn_login_options
+timeout	be_cmds.h	/^	u32 timeout;		\/* dword 1 *\/$/;"	m	struct:be_cmd_req_hdr
+todo_cq	be_main.h	/^	unsigned short todo_cq;$/;"	m	struct:beiscsi_hba
+todo_mcc_cq	be_main.h	/^	unsigned short todo_mcc_cq;$/;"	m	struct:beiscsi_hba
+trailer	be_cmds.h	/^	struct be_async_event_trailer trailer;$/;"	m	struct:be_async_event_link_state	typeref:struct:be_async_event_link_state::be_async_event_trailer
+tsih	be_cmds.h	/^	u16	tsih;$/;"	m	struct:mgmt_session_info
+ttt	be_main.h	/^	u8 ttt[32];		\/* TTT; valid for R2T or 0xffffffff *\/$/;"	m	struct:amap_pdu_data_out
+ttt	be_main.h	/^	u8 ttt[32];		\/* target id for ping or 0xffffffff *\/$/;"	m	struct:amap_pdu_nop_out
+tx_jumbo	be_main.h	/^	u8 tx_jumbo;		\/* DWORD 4 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+tx_wrbindex_drv_msg	be_main.h	/^	u8 tx_wrbindex_drv_msg[8];	\/* DWORD 3 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+type	be_cmds.h	/^	u8 type;$/;"	m	struct:be_cmd_req_mac_query
+type	be_main.h	/^	enum hwh_type_enum type;$/;"	m	struct:wrb_handle	typeref:enum:wrb_handle::hwh_type_enum
+type	be_main.h	/^	u8 type[4];		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+type	be_main.h	/^	u8 type[4];		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_wrb
+type	be_main.h	/^	unsigned int type;$/;"	m	struct:sgl_handle
+u	be_main.h	/^	} u;$/;"	m	struct:be_bus_address	typeref:union:be_bus_address::__anon5
+u	be_mgmt.h	/^	} u;$/;"	m	struct:amap_mcc_wrb_payload	typeref:union:amap_mcc_wrb_payload::__anon10
+u	be_mgmt.h	/^	} u;$/;"	m	struct:mcc_wrb_payload	typeref:union:mcc_wrb_payload::__anon11
+ulp	be_cmds.h	/^	struct be_ulp_fw_cfg ulp[2];$/;"	m	struct:be_fw_cfg	typeref:struct:be_fw_cfg::be_ulp_fw_cfg
+ulp_mode	be_cmds.h	/^	u32 ulp_mode;$/;"	m	struct:be_ulp_fw_cfg
+ulp_num	be_cmds.h	/^	u8 ulp_num;$/;"	m	struct:be_defq_create_req
+ulp_num	be_cmds.h	/^	u8 ulp_num;$/;"	m	struct:be_wrbq_create_req
+undr_run	be_main.h	/^	u8 undr_run;		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+undr_run	be_main.h	/^	u8 undr_run;		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_wrb
+unique_identifier	be_mgmt.h	/^	u64 unique_identifier;$/;"	m	struct:mgmt_controller_attributes
+unused	be_mgmt.h	/^	unsigned short unused;$/;"	m	struct:invalidate_commands_params_in
+unused	be_mgmt.h	/^	unsigned short unused;$/;"	m	struct:iscsi_invalidate_connection_params_in
+unused	be_mgmt.h	/^	unsigned short unused;$/;"	m	struct:iscsi_invalidate_connection_params_out
+upload_type	be_cmds.h	/^	u16 upload_type;$/;"	m	struct:tcp_upload_params_in
+used	be.h	/^	atomic_t used;		\/* Number of valid elements in the queue *\/$/;"	m	struct:be_queue_info
+users_final_status	be_cmds.h	/^	int *users_final_status;$/;"	m	struct:be_mcc_wrb_context
+va	be.h	/^	void *va;$/;"	m	struct:be_dma_mem
+va	be_main.h	/^	void *va;		\/* The virtual address of the ring.  This$/;"	m	struct:be_ring
+va_base	be_main.h	/^		void *va_base;$/;"	m	struct:hwi_async_pdu_context::__anon8
+va_base	be_main.h	/^		void *va_base;$/;"	m	struct:hwi_async_pdu_context::__anon9
+valid	be_cmds.h	/^	u8 valid;		\/* dword 0 *\/$/;"	m	struct:amap_cq_context
+valid	be_cmds.h	/^	u8 valid;		\/* dword 0 *\/$/;"	m	struct:amap_eq_context
+valid	be_cmds.h	/^	u8 valid;		\/* dword 3 *\/$/;"	m	struct:amap_sol_cqe
+valid	be_cmds.h	/^	u8 valid;		\/* dword 3 *\/$/;"	m	struct:amap_sol_cqe_ring
+valid	be_cmds.h	/^	u8 valid;$/;"	m	struct:amap_mcc_context
+valid	be_main.h	/^	u8 valid;		\/* DWORD 0 *\/$/;"	m	struct:amap_eq_entry
+valid	be_main.h	/^	u8 valid;$/;"	m	struct:amap_i_t_dpdu_cqe
+virtual_address	be_main.h	/^	void *virtual_address;		\/* virtual address to the location *\/$/;"	m	struct:mem_array
+wait_queue	be_main.h	/^	} wait_queue;$/;"	m	struct:hwi_async_entry	typeref:struct:hwi_async_entry::__anon7
+work_cqs	be_main.h	/^	struct work_struct work_cqs;	\/* The work being queued *\/$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::work_struct
+wq	be_main.h	/^	struct workqueue_struct *wq;	\/* The actuak work queue *\/$/;"	m	struct:beiscsi_hba	typeref:struct:beiscsi_hba::workqueue_struct
+wq_name	be_main.h	/^	char wq_name[20];$/;"	m	struct:beiscsi_hba
+wrb	be_cmds.h	/^	struct MCC_WRB *wrb;$/;"	m	struct:be_mcc_wrb_context	typeref:struct:be_mcc_wrb_context::MCC_WRB
+wrb	be_cmds.h	/^	struct be_mcc_wrb wrb;$/;"	m	struct:be_mcc_mailbox	typeref:struct:be_mcc_mailbox::be_mcc_wrb
+wrb_context	be_main.h	/^	struct hwi_wrb_context wrb_context[BE2_MAX_SESSIONS * 2];$/;"	m	struct:hwi_controller	typeref:struct:hwi_controller::hwi_wrb_context
+wrb_from_mbox	be_cmds.c	/^struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem)$/;"	f
+wrb_from_mccq	be_cmds.c	/^struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba)$/;"	f
+wrb_handle	be_main.h	/^struct wrb_handle {$/;"	s
+wrb_handle_drvr_list	be_main.h	/^	struct list_head wrb_handle_drvr_list;$/;"	m	struct:hwi_wrb_context	typeref:struct:hwi_wrb_context::list_head
+wrb_handle_list	be_main.h	/^	struct list_head wrb_handle_list;$/;"	m	struct:hwi_wrb_context	typeref:struct:hwi_wrb_context::list_head
+wrb_handles_available	be_main.h	/^	unsigned short wrb_handles_available;$/;"	m	struct:hwi_wrb_context
+wrb_idx	be_main.h	/^	u8 wrb_idx[8];		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_target_context_update_wrb
+wrb_idx	be_main.h	/^	u8 wrb_idx[8];		\/* DWORD 0 *\/$/;"	m	struct:amap_iscsi_wrb
+wrb_index	be_cmds.h	/^	u8 wrb_index[8];	\/* dword 2 *\/$/;"	m	struct:amap_sol_cqe
+wrb_index	be_main.h	/^	unsigned short wrb_index;$/;"	m	struct:wrb_handle
+wrb_mem_index	be_main.h	/^	unsigned int wrb_mem_index;$/;"	m	struct:hwi_controller
+wrbs_per_cxn	be_main.h	/^	unsigned int wrbs_per_cxn;$/;"	m	struct:hba_parameters
+writables	be_main.h	/^		unsigned int writables;$/;"	m	struct:hwi_async_pdu_context::__anon8
+writables	be_main.h	/^		unsigned int writables;$/;"	m	struct:hwi_async_pdu_context::__anon9
+x_bit	be_main.h	/^	u8 x_bit;		\/* reserved, always 0 *\/$/;"	m	struct:amap_pdu_base
+x_bit	be_main.h	/^	u8 x_bit;		\/* reserved; should be 0 *\/$/;"	m	struct:amap_pdu_nop_out
-- 
1.7.1

