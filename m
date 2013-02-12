From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 06/15] pm80xx: Updated common functions common for SPC and
 SPCv/ve
Date: Tue, 12 Feb 2013 04:32:34 -0800
Message-ID: <511A3662.9050705@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60847 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933060Ab3BLMbw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 07:31:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

>From 3fd0f7b1b3d82fc3a55dbfad6e9708ad64f17369 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 4 Feb 2013 17:32:34 +0530
Subject: [PATCH 06/15] pm80xx: Updated common functions common for SPC
and SPCv/ve

Update of function prototype for common function to SPC and SPCv/ve.
Multiple queues implementation for IO.

Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c  |  193
+++++++++++++++++++------------------
 drivers/scsi/pm8001/pm8001_init.c |   20 +++--
 drivers/scsi/pm8001/pm8001_sas.h  |   60 +++++++++++-
 3 files changed, 168 insertions(+), 105 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index 651834c..26f5197 100755
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1158,7 +1158,7 @@ static void pm8001_hw_chip_rst(struct
pm8001_hba_info *pm8001_ha)
  * pm8001_chip_iounmap - which maped when initialized.
  * @pm8001_ha: our hba card information
  */
-static void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
+void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
 {
 	s8 bar, logical = 0;
 	for (bar = 0; bar < 6; bar++) {
@@ -1237,7 +1237,7 @@ pm8001_chip_msix_interrupt_disable(struct
pm8001_hba_info *pm8001_ha,
  * @pm8001_ha: our hba card information
  */
 static void
-pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha)
+pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
 	pm8001_chip_msix_interrupt_enable(pm8001_ha, 0);
@@ -1252,7 +1252,7 @@ pm8001_chip_interrupt_enable(struct
pm8001_hba_info *pm8001_ha)
  * @pm8001_ha: our hba card information
  */
 static void
-pm8001_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
+pm8001_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
 	pm8001_chip_msix_interrupt_disable(pm8001_ha, 0);
@@ -1263,12 +1263,13 @@ pm8001_chip_interrupt_disable(struct
pm8001_hba_info *pm8001_ha)
 }

 /**
- * mpi_msg_free_get- get the free message buffer for transfer inbound
queue.
+ * pm8001_mpi_msg_free_get - get the free message buffer for transfer
+ * inbound queue.
  * @circularQ: the inbound queue  we want to transfer to HBA.
  * @messageSize: the message size of this transfer, normally it is 64 bytes
  * @messagePtr: the pointer to message.
  */
-static int mpi_msg_free_get(struct inbound_queue_table *circularQ,
+int pm8001_mpi_msg_free_get(struct inbound_queue_table *circularQ,
 			    u16 messageSize, void **messagePtr)
 {
 	u32 offset, consumer_index;
@@ -1276,7 +1277,7 @@ static int mpi_msg_free_get(struct
inbound_queue_table *circularQ,
 	u8 bcCount = 1; /* only support single buffer */

 	/* Checks is the requested message size can be allocated in this queue*/
-	if (messageSize > 64) {
+	if (messageSize > IOMB_SIZE_SPCV) {
 		*messagePtr = NULL;
 		return -1;
 	}
@@ -1290,7 +1291,7 @@ static int mpi_msg_free_get(struct
inbound_queue_table *circularQ,
 		return -1;
 	}
 	/* get memory IOMB buffer address */
-	offset = circularQ->producer_idx * 64;
+	offset = circularQ->producer_idx * messageSize;
 	/* increment to next bcCount element */
 	circularQ->producer_idx = (circularQ->producer_idx + bcCount)
 				% PM8001_MPI_QUEUE;
@@ -1302,29 +1303,30 @@ static int mpi_msg_free_get(struct
inbound_queue_table *circularQ,
 }

 /**
- * mpi_build_cmd- build the message queue for transfer, update the PI to FW
- * to tell the fw to get this message from IOMB.
+ * pm8001_mpi_build_cmd- build the message queue for transfer, update
the PI to
+ * FW to tell the fw to get this message from IOMB.
  * @pm8001_ha: our hba card information
  * @circularQ: the inbound queue we want to transfer to HBA.
  * @opCode: the operation code represents commands which LLDD and fw
recognized.
  * @payload: the command payload of each operation command.
  */
-static int mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
+int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 			 struct inbound_queue_table *circularQ,
-			 u32 opCode, void *payload)
+			 u32 opCode, void *payload, u32 responseQueue)
 {
 	u32 Header = 0, hpriority = 0, bc = 1, category = 0x02;
-	u32 responseQueue = 0;
 	void *pMessage;

-	if (mpi_msg_free_get(circularQ, 64, &pMessage) < 0) {
+	if (pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
+		&pMessage) < 0) {
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("No free mpi buffer\n"));
 		return -1;
 	}
 	BUG_ON(!payload);
 	/*Copy to the payload*/
-	memcpy(pMessage, payload, (64 - sizeof(struct mpi_msg_hdr)));
+	memcpy(pMessage, payload, (pm8001_ha->iomb_size -
+				sizeof(struct mpi_msg_hdr)));

 	/*Build the header*/
 	Header = ((1 << 31) | (hpriority << 30) | ((bc & 0x1f) << 24)
@@ -1336,12 +1338,13 @@ static int mpi_build_cmd(struct pm8001_hba_info
*pm8001_ha,
 	pm8001_cw32(pm8001_ha, circularQ->pi_pci_bar,
 		circularQ->pi_offset, circularQ->producer_idx);
 	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("after PI= %d CI= %d\n", circularQ->producer_idx,
-		circularQ->consumer_index));
+		pm8001_printk("INB Q %x OPCODE:%x , UPDATED PI=%d CI=%d\n",
+			responseQueue, opCode, circularQ->producer_idx,
+			circularQ->consumer_index));
 	return 0;
 }

-static u32 mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha, void *pMsg,
+u32 pm8001_mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha, void *pMsg,
 			    struct outbound_queue_table *circularQ, u8 bc)
 {
 	u32 producer_index;
@@ -1350,7 +1353,7 @@ static u32 mpi_msg_free_set(struct pm8001_hba_info
*pm8001_ha, void *pMsg,

 	msgHeader = (struct mpi_msg_hdr *)(pMsg - sizeof(struct mpi_msg_hdr));
 	pOutBoundMsgHeader = (struct mpi_msg_hdr *)(circularQ->base_virt +
-				circularQ->consumer_idx * 64);
+				circularQ->consumer_idx * pm8001_ha->iomb_size);
 	if (pOutBoundMsgHeader != msgHeader) {
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("consumer_idx = %d msgHeader = %p\n",
@@ -1381,13 +1384,14 @@ static u32 mpi_msg_free_set(struct
pm8001_hba_info *pm8001_ha, void *pMsg,
 }

 /**
- * mpi_msg_consume- get the MPI message from  outbound queue message table.
+ * pm8001_mpi_msg_consume- get the MPI message from outbound queue
+ * message table.
  * @pm8001_ha: our hba card information
  * @circularQ: the outbound queue  table.
  * @messagePtr1: the message contents of this outbound message.
  * @pBC: the message size.
  */
-static u32 mpi_msg_consume(struct pm8001_hba_info *pm8001_ha,
+u32 pm8001_mpi_msg_consume(struct pm8001_hba_info *pm8001_ha,
 			   struct outbound_queue_table *circularQ,
 			   void **messagePtr1, u8 *pBC)
 {
@@ -1401,7 +1405,7 @@ static u32 mpi_msg_consume(struct pm8001_hba_info
*pm8001_ha,
 			/*Get the pointer to the circular queue buffer element*/
 			msgHeader = (struct mpi_msg_hdr *)
 				(circularQ->base_virt +
-				circularQ->consumer_idx * 64);
+				circularQ->consumer_idx * pm8001_ha->iomb_size);
 			/* read header */
 			header_tmp = pm8001_read_32(msgHeader);
 			msgHeader_tmp = cpu_to_le32(header_tmp);
@@ -1461,7 +1465,7 @@ static u32 mpi_msg_consume(struct pm8001_hba_info
*pm8001_ha,
 	return MPI_IO_STATUS_BUSY;
 }

-static void pm8001_work_fn(struct work_struct *work)
+void pm8001_work_fn(struct work_struct *work)
 {
 	struct pm8001_work *pw = container_of(work, struct pm8001_work, work);
 	struct pm8001_device *pm8001_dev;
@@ -1659,7 +1663,7 @@ static void pm8001_work_fn(struct work_struct *work)
 	kfree(pw);
 }

-static int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha, void
*data,
+int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha, void *data,
 			       int handler)
 {
 	struct pm8001_work *pw;
@@ -2867,8 +2871,8 @@ mpi_smp_completion(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 	}
 }

-static void
-mpi_set_dev_state_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
+void pm8001_mpi_set_dev_state_resp(struct pm8001_hba_info *pm8001_ha,
+		void *piomb)
 {
 	struct set_dev_state_resp *pPayload =
 		(struct set_dev_state_resp *)(piomb + 4);
@@ -2888,8 +2892,7 @@ mpi_set_dev_state_resp(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 	pm8001_ccb_free(pm8001_ha, tag);
 }

-static void
-mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
+void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void
*piomb)
 {
 	struct get_nvm_data_resp *pPayload =
 		(struct get_nvm_data_resp *)(piomb + 4);
@@ -2908,8 +2911,8 @@ mpi_set_nvmd_resp(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 	pm8001_ccb_free(pm8001_ha, tag);
 }

-static void
-mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
+void
+pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	struct fw_control_ex	*fw_control_context;
 	struct get_nvm_data_resp *pPayload =
@@ -2970,7 +2973,7 @@ mpi_get_nvmd_resp(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 	pm8001_ccb_free(pm8001_ha, tag);
 }

-static int mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void
*piomb)
+int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void
*piomb)
 {
 	struct local_phy_ctl_resp *pPayload =
 		(struct local_phy_ctl_resp *)(piomb + 4);
@@ -2999,7 +3002,7 @@ static int mpi_local_phy_ctl(struct
pm8001_hba_info *pm8001_ha, void *piomb)
  * while receive a broadcast(change) primitive just tell the sas
  * layer to discover the changed domain rather than the whole domain.
  */
-static void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
+void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
 {
 	struct pm8001_phy *phy = &pm8001_ha->phy[i];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
@@ -3033,7 +3036,7 @@ static void pm8001_bytes_dmaed(struct
pm8001_hba_info *pm8001_ha, int i)
 }

 /* Get the link rate speed  */
-static void get_lrate_mode(struct pm8001_phy *phy, u8 link_rate)
+void pm8001_get_lrate_mode(struct pm8001_phy *phy, u8 link_rate)
 {
 	struct sas_phy *sas_phy = phy->sas_phy.phy;

@@ -3070,7 +3073,7 @@ static void get_lrate_mode(struct pm8001_phy *phy,
u8 link_rate)
  * LOCKING: the frame_rcvd_lock needs to be held since this parses the
frame
  * buffer.
  */
-static void pm8001_get_attached_sas_addr(struct pm8001_phy *phy,
+void pm8001_get_attached_sas_addr(struct pm8001_phy *phy,
 	u8 *sas_addr)
 {
 	if (phy->sas_phy.frame_rcvd[0] == 0x34
@@ -3112,7 +3115,7 @@ static void pm8001_hw_event_ack_req(struct
pm8001_hba_info *pm8001_ha,
 		((phyId & 0x0F) << 4) | (port_id & 0x0F));
 	payload.param0 = cpu_to_le32(param0);
 	payload.param1 = cpu_to_le32(param1);
-	mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);
+	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 }

 static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
@@ -3157,19 +3160,19 @@ hw_event_sas_phy_up(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 		pm8001_chip_phy_ctl_req(pm8001_ha, phy_id,
 			PHY_NOTIFY_ENABLE_SPINUP);
 		port->port_attached = 1;
-		get_lrate_mode(phy, link_rate);
+		pm8001_get_lrate_mode(phy, link_rate);
 		break;
 	case SAS_EDGE_EXPANDER_DEVICE:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("expander device.\n"));
 		port->port_attached = 1;
-		get_lrate_mode(phy, link_rate);
+		pm8001_get_lrate_mode(phy, link_rate);
 		break;
 	case SAS_FANOUT_EXPANDER_DEVICE:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("fanout expander device.\n"));
 		port->port_attached = 1;
-		get_lrate_mode(phy, link_rate);
+		pm8001_get_lrate_mode(phy, link_rate);
 		break;
 	default:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3224,7 +3227,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 		" phy id = %d\n", port_id, phy_id));
 	port->port_state =  portstate;
 	port->port_attached = 1;
-	get_lrate_mode(phy, link_rate);
+	pm8001_get_lrate_mode(phy, link_rate);
 	phy->phy_type |= PORT_TYPE_SATA;
 	phy->phy_attached = 1;
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
@@ -3305,7 +3308,7 @@ hw_event_phy_down(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 }

 /**
- * mpi_reg_resp -process register device ID response.
+ * pm8001_mpi_reg_resp -process register device ID response.
  * @pm8001_ha: our hba card information
  * @piomb: IO message buffer
  *
@@ -3314,7 +3317,7 @@ hw_event_phy_down(struct pm8001_hba_info
*pm8001_ha, void *piomb)
  * has assigned, from now,inter-communication with FW is no longer
using the
  * SAS address, use device ID which FW assigned.
  */
-static int mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
+int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	u32 status;
 	u32 device_id;
@@ -3376,7 +3379,7 @@ static int mpi_reg_resp(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 	return 0;
 }

-static int mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
+int pm8001_mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	u32 status;
 	u32 device_id;
@@ -3392,8 +3395,13 @@ static int mpi_dereg_resp(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 	return 0;
 }

-static int
-mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
+/**
+ * fw_flash_update_resp - Response from FW for flash update command.
+ * @pm8001_ha: our hba card information
+ * @piomb: IO message buffer
+ */
+int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
+		void *piomb)
 {
 	u32 status;
 	struct fw_control_ex	fw_control_context;
@@ -3459,8 +3467,7 @@ mpi_fw_flash_update_resp(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 	return 0;
 }

-static int
-mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
+int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void
*piomb)
 {
 	u32 status;
 	int i;
@@ -3476,8 +3483,7 @@ mpi_general_event(struct pm8001_hba_info
*pm8001_ha , void *piomb)
 	return 0;
 }

-static int
-mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
+int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void
*piomb)
 {
 	struct sas_task *t;
 	struct pm8001_ccb_info *ccb;
@@ -3772,17 +3778,17 @@ static void process_one_iomb(struct
pm8001_hba_info *pm8001_ha, void *piomb)
 	case OPC_OUB_LOCAL_PHY_CNTRL:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_LOCAL_PHY_CNTRL\n"));
-		mpi_local_phy_ctl(pm8001_ha, piomb);
+		pm8001_mpi_local_phy_ctl(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEV_REGIST:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_DEV_REGIST\n"));
-		mpi_reg_resp(pm8001_ha, piomb);
+		pm8001_mpi_reg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEREG_DEV:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("unregister the device\n"));
-		mpi_dereg_resp(pm8001_ha, piomb);
+		pm8001_mpi_dereg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEV_HANDLE:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3820,7 +3826,7 @@ static void process_one_iomb(struct
pm8001_hba_info *pm8001_ha, void *piomb)
 	case OPC_OUB_FW_FLASH_UPDATE:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_FW_FLASH_UPDATE\n"));
-		mpi_fw_flash_update_resp(pm8001_ha, piomb);
+		pm8001_mpi_fw_flash_update_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GPIO_RESPONSE:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3833,17 +3839,17 @@ static void process_one_iomb(struct
pm8001_hba_info *pm8001_ha, void *piomb)
 	case OPC_OUB_GENERAL_EVENT:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_GENERAL_EVENT\n"));
-		mpi_general_event(pm8001_ha, piomb);
+		pm8001_mpi_general_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SSP_ABORT_RSP:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_SSP_ABORT_RSP\n"));
-		mpi_task_abort_resp(pm8001_ha, piomb);
+		pm8001_mpi_task_abort_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SATA_ABORT_RSP:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_SATA_ABORT_RSP\n"));
-		mpi_task_abort_resp(pm8001_ha, piomb);
+		pm8001_mpi_task_abort_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SAS_DIAG_MODE_START_END:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3868,17 +3874,17 @@ static void process_one_iomb(struct
pm8001_hba_info *pm8001_ha, void *piomb)
 	case OPC_OUB_SMP_ABORT_RSP:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_SMP_ABORT_RSP\n"));
-		mpi_task_abort_resp(pm8001_ha, piomb);
+		pm8001_mpi_task_abort_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_NVMD_DATA:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_GET_NVMD_DATA\n"));
-		mpi_get_nvmd_resp(pm8001_ha, piomb);
+		pm8001_mpi_get_nvmd_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SET_NVMD_DATA:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_SET_NVMD_DATA\n"));
-		mpi_set_nvmd_resp(pm8001_ha, piomb);
+		pm8001_mpi_set_nvmd_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEVICE_HANDLE_REMOVAL:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3887,7 +3893,7 @@ static void process_one_iomb(struct
pm8001_hba_info *pm8001_ha, void *piomb)
 	case OPC_OUB_SET_DEVICE_STATE:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_SET_DEVICE_STATE\n"));
-		mpi_set_dev_state_resp(pm8001_ha, piomb);
+		pm8001_mpi_set_dev_state_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEVICE_STATE:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3909,7 +3915,7 @@ static void process_one_iomb(struct
pm8001_hba_info *pm8001_ha, void *piomb)
 	}
 }

-static int process_oq(struct pm8001_hba_info *pm8001_ha)
+static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 	struct outbound_queue_table *circularQ;
 	void *pMsg1 = NULL;
@@ -3918,14 +3924,15 @@ static int process_oq(struct pm8001_hba_info
*pm8001_ha)
 	unsigned long flags;

 	spin_lock_irqsave(&pm8001_ha->lock, flags);
-	circularQ = &pm8001_ha->outbnd_q_tbl[0];
+	circularQ = &pm8001_ha->outbnd_q_tbl[vec];
 	do {
-		ret = mpi_msg_consume(pm8001_ha, circularQ, &pMsg1, &bc);
+		ret = pm8001_mpi_msg_consume(pm8001_ha, circularQ, &pMsg1, &bc);
 		if (MPI_IO_STATUS_SUCCESS == ret) {
 			/* process the outbound message */
 			process_one_iomb(pm8001_ha, (void *)(pMsg1 - 4));
 			/* free the message from the outbound circular buffer */
-			mpi_msg_free_set(pm8001_ha, pMsg1, circularQ, bc);
+			pm8001_mpi_msg_free_set(pm8001_ha, pMsg1,
+							circularQ, bc);
 		}
 		if (MPI_IO_STATUS_BUSY == ret) {
 			/* Update the producer index from SPC */
@@ -3948,7 +3955,7 @@ static const u8 data_dir_flags[] = {
 	[PCI_DMA_FROMDEVICE]	= DATA_DIR_IN,/* INBOUND */
 	[PCI_DMA_NONE]		= DATA_DIR_NONE,/* NO TRANSFER */
 };
-static void
+void
 pm8001_chip_make_sg(struct scatterlist *scatter, int nr, void *prd)
 {
 	int i;
@@ -4023,7 +4030,7 @@ static int pm8001_chip_smp_req(struct
pm8001_hba_info *pm8001_ha,
 	smp_cmd.long_smp_req.long_resp_size =
 		cpu_to_le32((u32)sg_dma_len(&task->smp_task.smp_resp)-4);
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag, &smp_cmd);
-	mpi_build_cmd(pm8001_ha, circularQ, opc, (u32 *)&smp_cmd);
+	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, (u32 *)&smp_cmd, 0);
 	return 0;

 err_out_2:
@@ -4087,7 +4094,7 @@ static int pm8001_chip_ssp_io_req(struct
pm8001_hba_info *pm8001_ha,
 		ssp_cmd.len = cpu_to_le32(task->total_xfer_len);
 		ssp_cmd.esgl = 0;
 	}
-	ret = mpi_build_cmd(pm8001_ha, circularQ, opc, &ssp_cmd);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &ssp_cmd, 0);
 	return ret;
 }

@@ -4157,7 +4164,7 @@ static int pm8001_chip_sata_req(struct
pm8001_hba_info *pm8001_ha,
 		sata_cmd.len = cpu_to_le32(task->total_xfer_len);
 		sata_cmd.esgl = 0;
 	}
-	ret = mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
 	return ret;
 }

@@ -4192,7 +4199,7 @@ pm8001_chip_phy_start_req(struct pm8001_hba_info
*pm8001_ha, u8 phy_id)
 	memcpy(payload.sas_identify.sas_addr,
 		pm8001_ha->sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id = phy_id;
-	ret = mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload, 0);
 	return ret;
 }

@@ -4202,7 +4209,7 @@ pm8001_chip_phy_start_req(struct pm8001_hba_info
*pm8001_ha, u8 phy_id)
  * @num: the inbound queue number
  * @phy_id: the phy id which we wanted to start up.
  */
-static int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
+int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	u8 phy_id)
 {
 	struct phy_stop_req payload;
@@ -4214,12 +4221,12 @@ static int pm8001_chip_phy_stop_req(struct
pm8001_hba_info *pm8001_ha,
 	memset(&payload, 0, sizeof(payload));
 	payload.tag = cpu_to_le32(tag);
 	payload.phy_id = cpu_to_le32(phy_id);
-	ret = mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload, 0);
 	return ret;
 }

 /**
- * see comments on mpi_reg_resp.
+ * see comments on pm8001_mpi_reg_resp.
  */
 static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	struct pm8001_device *pm8001_dev, u32 flag)
@@ -4273,14 +4280,14 @@ static int pm8001_chip_reg_dev_req(struct
pm8001_hba_info *pm8001_ha,
 		cpu_to_le32(ITNT | (firstBurstSize * 0x10000));
 	memcpy(payload.sas_addr, pm8001_dev->sas_device->sas_addr,
 		SAS_ADDR_SIZE);
-	rc = mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 	return rc;
 }

 /**
- * see comments on mpi_reg_resp.
+ * see comments on pm8001_mpi_reg_resp.
  */
-static int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha,
+int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	u32 device_id)
 {
 	struct dereg_dev_req payload;
@@ -4294,7 +4301,7 @@ static int pm8001_chip_dereg_dev_req(struct
pm8001_hba_info *pm8001_ha,
 	payload.device_id = cpu_to_le32(device_id);
 	PM8001_MSG_DBG(pm8001_ha,
 		pm8001_printk("unregister device device_id = %d\n", device_id));
-	ret = mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 	return ret;
 }

@@ -4317,7 +4324,7 @@ static int pm8001_chip_phy_ctl_req(struct
pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(1);
 	payload.phyop_phyid =
 		cpu_to_le32(((phy_op & 0xff) << 8) | (phyId & 0x0F));
-	ret = mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 	return ret;
 }

@@ -4341,11 +4348,11 @@ static u32 pm8001_chip_is_our_interupt(struct
pm8001_hba_info *pm8001_ha)
  * @stat: stat.
  */
 static irqreturn_t
-pm8001_chip_isr(struct pm8001_hba_info *pm8001_ha)
+pm8001_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
-	pm8001_chip_interrupt_disable(pm8001_ha);
-	process_oq(pm8001_ha);
-	pm8001_chip_interrupt_enable(pm8001_ha);
+	pm8001_chip_interrupt_disable(pm8001_ha, vec);
+	process_oq(pm8001_ha, vec);
+	pm8001_chip_interrupt_enable(pm8001_ha, vec);
 	return IRQ_HANDLED;
 }

@@ -4367,7 +4374,7 @@ static int send_task_abort(struct pm8001_hba_info
*pm8001_ha, u32 opc,
 		task_abort.device_id = cpu_to_le32(dev_id);
 		task_abort.tag = cpu_to_le32(cmd_tag);
 	}
-	ret = mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort, 0);
 	return ret;
 }

@@ -4376,7 +4383,7 @@ static int send_task_abort(struct pm8001_hba_info
*pm8001_ha, u32 opc,
  * @task: the task we wanted to aborted.
  * @flag: the abort flag.
  */
-static int pm8001_chip_abort_task(struct pm8001_hba_info *pm8001_ha,
+int pm8001_chip_abort_task(struct pm8001_hba_info *pm8001_ha,
 	struct pm8001_device *pm8001_dev, u8 flag, u32 task_tag, u32 cmd_tag)
 {
 	u32 opc, device_id;
@@ -4403,7 +4410,7 @@ static int pm8001_chip_abort_task(struct
pm8001_hba_info *pm8001_ha,
  * @ccb: the ccb information.
  * @tmf: task management function.
  */
-static int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *pm8001_ha,
+int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *pm8001_ha,
 	struct pm8001_ccb_info *ccb, struct pm8001_tmf_task *tmf)
 {
 	struct sas_task *task = ccb->task;
@@ -4421,11 +4428,11 @@ static int pm8001_chip_ssp_tm_req(struct
pm8001_hba_info *pm8001_ha,
 	memcpy(sspTMCmd.lun, task->ssp_task.LUN, 8);
 	sspTMCmd.tag = cpu_to_le32(ccb->ccb_tag);
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
-	ret = mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd, 0);
 	return ret;
 }

-static int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
+int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	void *payload)
 {
 	u32 opc = OPC_INB_GET_NVMD_DATA;
@@ -4501,11 +4508,11 @@ static int pm8001_chip_get_nvmd_req(struct
pm8001_hba_info *pm8001_ha,
 	default:
 		break;
 	}
-	rc = mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req, 0);
 	return rc;
 }

-static int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
+int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	void *payload)
 {
 	u32 opc = OPC_INB_SET_NVMD_DATA;
@@ -4581,7 +4588,7 @@ static int pm8001_chip_set_nvmd_req(struct
pm8001_hba_info *pm8001_ha,
 	default:
 		break;
 	}
-	rc = mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req, 0);
 	return rc;
 }

@@ -4590,7 +4597,7 @@ static int pm8001_chip_set_nvmd_req(struct
pm8001_hba_info *pm8001_ha,
  * @pm8001_ha: our hba card information.
  * @fw_flash_updata_info: firmware flash update param
  */
-static int
+int
 pm8001_chip_fw_flash_update_build(struct pm8001_hba_info *pm8001_ha,
 	void *fw_flash_updata_info, u32 tag)
 {
@@ -4612,11 +4619,11 @@ pm8001_chip_fw_flash_update_build(struct
pm8001_hba_info *pm8001_ha,
 		cpu_to_le32(lower_32_bits(le64_to_cpu(info->sgl.addr)));
 	payload.sgl_addr_hi =
 		cpu_to_le32(upper_32_bits(le64_to_cpu(info->sgl.addr)));
-	ret = mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 	return ret;
 }

-static int
+int
 pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
 	void *payload)
 {
@@ -4672,7 +4679,7 @@ pm8001_chip_fw_flash_update_req(struct
pm8001_hba_info *pm8001_ha,
 	return rc;
 }

-static int
+int
 pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
 	struct pm8001_device *pm8001_dev, u32 state)
 {
@@ -4693,7 +4700,7 @@ pm8001_chip_set_dev_state_req(struct
pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(tag);
 	payload.device_id = cpu_to_le32(pm8001_dev->device_id);
 	payload.nds = cpu_to_le32(state);
-	rc = mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 	return rc;

 }
@@ -4718,7 +4725,7 @@ pm8001_chip_sas_re_initialization(struct
pm8001_hba_info *pm8001_ha)
 	payload.SSAHOLT = cpu_to_le32(0xd << 25);
 	payload.sata_hol_tmo = cpu_to_le32(80);
 	payload.open_reject_cmdretries_data_retries = cpu_to_le32(0xff00ff);
-	rc = mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 	return rc;

 }
diff --git a/drivers/scsi/pm8001/pm8001_init.c
b/drivers/scsi/pm8001/pm8001_init.c
index 9ca1029..e8a983f 100755
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -169,7 +169,7 @@ static void pm8001_tasklet(unsigned long opaque)
 	pm8001_ha = (struct pm8001_hba_info *)opaque;
 	if (unlikely(!pm8001_ha))
 		BUG_ON(1);
-	PM8001_CHIP_DISP->isr(pm8001_ha);
+	PM8001_CHIP_DISP->isr(pm8001_ha, 0);
 }
 #endif

@@ -193,7 +193,7 @@ static irqreturn_t pm8001_interrupt(int irq, void
*opaque)
 #ifdef PM8001_USE_TASKLET
 	tasklet_schedule(&pm8001_ha->tasklet);
 #else
-	ret = PM8001_CHIP_DISP->isr(pm8001_ha);
+	ret = PM8001_CHIP_DISP->isr(pm8001_ha, 0);
 #endif
 	return ret;
 }
@@ -424,6 +424,12 @@ static struct pm8001_hba_info
*pm8001_pci_alloc(struct pci_dev *pdev,
 	pm8001_ha->id = pm8001_id++;
 	pm8001_ha->logging_level = 0x01;
 	sprintf(pm8001_ha->name, "%s%d", DRV_NAME, pm8001_ha->id);
+	/* IOMB size is 128 for 8088/89 controllers */
+	if (pm8001_ha->chip_id != chip_8001)
+		pm8001_ha->iomb_size = IOMB_SIZE_SPCV;
+	else
+		pm8001_ha->iomb_size = IOMB_SIZE_SPC;
+
 #ifdef PM8001_USE_TASKLET
 	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
 		(unsigned long)pm8001_ha);
@@ -726,7 +732,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	if (rc)
 		goto err_out_shost;

-	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha);
+	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
 	pm8001_init_sas_add(pm8001_ha);
 	pm8001_post_sas_ha_init(shost, chip);
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
@@ -762,7 +768,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	sas_remove_host(pm8001_ha->shost);
 	list_del(&pm8001_ha->list);
 	scsi_remove_host(pm8001_ha->shost);
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);

 #ifdef PM8001_USE_MSIX
@@ -806,7 +812,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev,
pm_message_t state)
 		printk(KERN_ERR " PCI PM not supported\n");
 		return -ENODEV;
 	}
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
@@ -867,7 +873,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc)
 		goto err_out_disable;
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
 	rc = pm8001_request_irq(pm8001_ha);
 	if (rc)
 		goto err_out_disable;
@@ -875,7 +881,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
 		    (unsigned long)pm8001_ha);
 	#endif
-	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha);
+	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
 	scsi_unblock_requests(pm8001_ha->shost);
 	return 0;

diff --git a/drivers/scsi/pm8001/pm8001_sas.h
b/drivers/scsi/pm8001/pm8001_sas.h
index bf4963e..3bd350c 100755
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -1,5 +1,5 @@
 /*
- * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver
+ * PMC-Sierra 8001/8081/8088/8089 SAS/SATA based host adapters driver
  *
  * Copyright (c) 2008-2009 USI Co., Ltd.
  * All rights reserved.
@@ -136,11 +136,11 @@ struct pm8001_dispatch {
 	void (*chip_rst)(struct pm8001_hba_info *pm8001_ha);
 	int (*chip_ioremap)(struct pm8001_hba_info *pm8001_ha);
 	void (*chip_iounmap)(struct pm8001_hba_info *pm8001_ha);
-	irqreturn_t (*isr)(struct pm8001_hba_info *pm8001_ha);
+	irqreturn_t (*isr)(struct pm8001_hba_info *pm8001_ha, u8 vec);
 	u32 (*is_our_interupt)(struct pm8001_hba_info *pm8001_ha);
-	int (*isr_process_oq)(struct pm8001_hba_info *pm8001_ha);
-	void (*interrupt_enable)(struct pm8001_hba_info *pm8001_ha);
-	void (*interrupt_disable)(struct pm8001_hba_info *pm8001_ha);
+	int (*isr_process_oq)(struct pm8001_hba_info *pm8001_ha, u8 vec);
+	void (*interrupt_enable)(struct pm8001_hba_info *pm8001_ha, u8 vec);
+	void (*interrupt_disable)(struct pm8001_hba_info *pm8001_ha, u8 vec);
 	void (*make_prd)(struct scatterlist *scatter, int nr, void *prd);
 	int (*smp_req)(struct pm8001_hba_info *pm8001_ha,
 		struct pm8001_ccb_info *ccb);
@@ -565,6 +565,56 @@ int pm8001_mem_alloc(struct pci_dev *pdev, void
**virt_addr,
 	dma_addr_t *pphys_addr, u32 *pphys_addr_hi, u32 *pphys_addr_lo,
 	u32 mem_size, u32 align);

+/********** functions common to spc & spcv - begins ************/
+void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha);
+int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
+			struct inbound_queue_table *circularQ,
+			u32 opCode, void *payload, u32 responseQueue);
+int pm8001_mpi_msg_free_get(struct inbound_queue_table *circularQ,
+				u16 messageSize, void **messagePtr);
+u32 pm8001_mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha, void *pMsg,
+			struct outbound_queue_table *circularQ, u8 bc);
+u32 pm8001_mpi_msg_consume(struct pm8001_hba_info *pm8001_ha,
+			struct outbound_queue_table *circularQ,
+			void **messagePtr1, u8 *pBC);
+int pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
+			struct pm8001_device *pm8001_dev, u32 state);
+int pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
+					void *payload);
+int pm8001_chip_fw_flash_update_build(struct pm8001_hba_info *pm8001_ha,
+					void *fw_flash_updata_info, u32 tag);
+int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha, void
*payload);
+int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha, void
*payload);
+int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *pm8001_ha,
+				struct pm8001_ccb_info *ccb,
+				struct pm8001_tmf_task *tmf);
+int pm8001_chip_abort_task(struct pm8001_hba_info *pm8001_ha,
+				struct pm8001_device *pm8001_dev,
+				u8 flag, u32 task_tag, u32 cmd_tag);
+int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha, u32
device_id);
+void pm8001_chip_make_sg(struct scatterlist *scatter, int nr, void *prd);
+void pm8001_work_fn(struct work_struct *work);
+int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha,
+					void *data, int handler);
+void pm8001_mpi_set_dev_state_resp(struct pm8001_hba_info *pm8001_ha,
+							void *piomb);
+void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha,
+							void *piomb);
+void pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha,
+							void *piomb);
+int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha,
+							void *piomb);
+void pm8001_get_lrate_mode(struct pm8001_phy *phy, u8 link_rate);
+void pm8001_get_attached_sas_addr(struct pm8001_phy *phy, u8 *sas_addr);
+void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i);
+int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
+int pm8001_mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
+int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
+							void *piomb);
+int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void
*piomb);
+int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void
*piomb);
+/*********** functions common to spc & spcv - ends ************/
+
 int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue);

 /* ctl shared API */
-- 
1.7.1

