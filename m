From: santoshprasadnayak@gmail.com
Subject: [PATCH] [SCSI] pm8001: fix endian issue with code optimization.
Date: Sun, 26 Feb 2012 20:14:46 +0530
Message-ID: <4f4a4580.aa3a440a.34c7.2776@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39479 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2BZOpV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Feb 2012 09:45:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang@usish.com
Cc: lindar_liu@usish.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Santosh Nayak <santoshprasadnayak@gmail.com>

=46rom: Santosh Nayak <santoshprasadnayak@gmail.com>

1. Fix endian issue.
2. Fix the following warning :
    " drivers/scsi/pm8001/pm8001_hwi.c:2932:32: warning: comparison
      between =E2=80=98enum sas_device_type=E2=80=99 and =E2=80=98enum =
sas_dev_type=E2=80=99".
3. Few code optimization.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/scsi/pm8001/pm8001_chips.h |    4 +-
 drivers/scsi/pm8001/pm8001_hwi.c   |   89 ++++++++++++++++++----------=
-------
 drivers/scsi/pm8001/pm8001_hwi.h   |    2 +-
 3 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_chips.h b/drivers/scsi/pm8001/p=
m8001_chips.h
index 4efa4d0..9241c78 100644
--- a/drivers/scsi/pm8001/pm8001_chips.h
+++ b/drivers/scsi/pm8001/pm8001_chips.h
@@ -46,9 +46,9 @@ static inline u32 pm8001_read_32(void *virt_addr)
 	return *((u32 *)virt_addr);
 }
=20
-static inline void pm8001_write_32(void *addr, u32 offset, u32 val)
+static inline void pm8001_write_32(void *addr, u32 offset, __le32 val)
 {
-	*((u32 *)(addr + offset)) =3D val;
+	*((__le32 *)(addr + offset)) =3D val;
 }
=20
 static inline u32 pm8001_cr32(struct pm8001_hba_info *pm8001_ha, u32 b=
ar,
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8=
001_hwi.c
index e12c4f6..ce9a524 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1212,7 +1212,7 @@ static int mpi_msg_free_get(struct inbound_queue_=
table *circularQ,
 	consumer_index =3D pm8001_read_32(circularQ->ci_virt);
 	circularQ->consumer_index =3D cpu_to_le32(consumer_index);
 	if (((circularQ->producer_idx + bcCount) % 256) =3D=3D
-		circularQ->consumer_index) {
+		le32_to_cpu(circularQ->consumer_index)) {
 		*messagePtr =3D NULL;
 		return -1;
 	}
@@ -1321,7 +1321,8 @@ static u32 mpi_msg_consume(struct pm8001_hba_info=
 *pm8001_ha,
 	u32 header_tmp;
 	do {
 		/* If there are not-yet-delivered messages ... */
-		if (circularQ->producer_index !=3D circularQ->consumer_idx) {
+		if (le32_to_cpu(circularQ->producer_index)
+			!=3D circularQ->consumer_idx) {
 			/*Get the pointer to the circular queue buffer element*/
 			msgHeader =3D (struct mpi_msg_hdr *)
 				(circularQ->base_virt +
@@ -1329,14 +1330,14 @@ static u32 mpi_msg_consume(struct pm8001_hba_in=
fo *pm8001_ha,
 			/* read header */
 			header_tmp =3D pm8001_read_32(msgHeader);
 			msgHeader_tmp =3D cpu_to_le32(header_tmp);
-			if (0 !=3D (msgHeader_tmp & 0x80000000)) {
+			if (0 !=3D (le32_to_cpu(msgHeader_tmp) & 0x80000000)) {
 				if (OPC_OUB_SKIP_ENTRY !=3D
-					(msgHeader_tmp & 0xfff)) {
+					(le32_to_cpu(msgHeader_tmp) & 0xfff)) {
 					*messagePtr1 =3D
 						((u8 *)msgHeader) +
 						sizeof(struct mpi_msg_hdr);
-					*pBC =3D (u8)((msgHeader_tmp >> 24) &
-						0x1f);
+					*pBC =3D (u8)((le32_to_cpu(msgHeader_tmp)
+						>> 24) & 0x1f);
 					PM8001_IO_DBG(pm8001_ha,
 						pm8001_printk(": CI=3D%d PI=3D%d "
 						"msgHeader=3D%x\n",
@@ -1347,8 +1348,8 @@ static u32 mpi_msg_consume(struct pm8001_hba_info=
 *pm8001_ha,
 				} else {
 					circularQ->consumer_idx =3D
 						(circularQ->consumer_idx +
-						((msgHeader_tmp >> 24) & 0x1f))
-						% 256;
+						((le32_to_cpu(msgHeader_tmp)
+						>> 24) & 0x1f)) % 256;
 					msgHeader_tmp =3D 0;
 					pm8001_write_32(msgHeader, 0, 0);
 					/* update the CI of outbound queue */
@@ -1360,7 +1361,8 @@ static u32 mpi_msg_consume(struct pm8001_hba_info=
 *pm8001_ha,
 			} else {
 				circularQ->consumer_idx =3D
 					(circularQ->consumer_idx +
-					((msgHeader_tmp >> 24) & 0x1f)) % 256;
+					((le32_to_cpu(msgHeader_tmp) >> 24) &
+					0x1f)) % 256;
 				msgHeader_tmp =3D 0;
 				pm8001_write_32(msgHeader, 0, 0);
 				/* update the CI of outbound queue */
@@ -1376,7 +1378,8 @@ static u32 mpi_msg_consume(struct pm8001_hba_info=
 *pm8001_ha,
 			producer_index =3D pm8001_read_32(pi_virt);
 			circularQ->producer_index =3D cpu_to_le32(producer_index);
 		}
-	} while (circularQ->producer_index !=3D circularQ->consumer_idx);
+	} while (le32_to_cpu(circularQ->producer_index) !=3D
+		circularQ->consumer_idx);
 	/* while we don't have any more not-yet-delivered message */
 	/* report empty */
 	return MPI_IO_STATUS_BUSY;
@@ -2857,7 +2860,7 @@ static void pm8001_hw_event_ack_req(struct pm8001=
_hba_info *pm8001_ha,
=20
 	memset((u8 *)&payload, 0, sizeof(payload));
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[Qnum];
-	payload.tag =3D 1;
+	payload.tag =3D cpu_to_le32(1);
 	payload.sea_phyid_portid =3D cpu_to_le32(((SEA & 0xFFFF) << 8) |
 		((phyId & 0x0F) << 4) | (port_id & 0x0F));
 	payload.param0 =3D cpu_to_le32(param0);
@@ -2929,9 +2932,9 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm800=
1_ha, void *piomb)
 	phy->phy_type |=3D PORT_TYPE_SAS;
 	phy->identify.device_type =3D deviceType;
 	phy->phy_attached =3D 1;
-	if (phy->identify.device_type =3D=3D SAS_END_DEV)
+	if (phy->identify.device_type =3D=3D SAS_END_DEVICE)
 		phy->identify.target_port_protocols =3D SAS_PROTOCOL_SSP;
-	else if (phy->identify.device_type !=3D NO_DEVICE)
+	else if (phy->identify.device_type !=3D SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols =3D SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode =3D SAS_OOB_MODE;
 	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
@@ -3075,7 +3078,7 @@ static int mpi_reg_resp(struct pm8001_hba_info *p=
m8001_ha, void *piomb)
 		(struct dev_reg_resp *)(piomb + 4);
=20
 	htag =3D le32_to_cpu(registerRespPayload->tag);
-	ccb =3D &pm8001_ha->ccb_info[registerRespPayload->tag];
+	ccb =3D &pm8001_ha->ccb_info[htag];
 	pm8001_dev =3D ccb->device;
 	status =3D le32_to_cpu(registerRespPayload->status);
 	device_id =3D le32_to_cpu(registerRespPayload->device_id);
@@ -3149,7 +3152,7 @@ mpi_fw_flash_update_resp(struct pm8001_hba_info *=
pm8001_ha, void *piomb)
 	struct fw_control_ex	fw_control_context;
 	struct fw_flash_Update_resp *ppayload =3D
 		(struct fw_flash_Update_resp *)(piomb + 4);
-	u32 tag =3D le32_to_cpu(ppayload->tag);
+	u32 tag =3D ppayload->tag;
 	struct pm8001_ccb_info *ccb =3D &pm8001_ha->ccb_info[tag];
 	status =3D le32_to_cpu(ppayload->status);
 	memcpy(&fw_control_context,
@@ -3238,13 +3241,12 @@ mpi_task_abort_resp(struct pm8001_hba_info *pm8=
001_ha, void *piomb)
=20
 	struct task_abort_resp *pPayload =3D
 		(struct task_abort_resp *)(piomb + 4);
-	ccb =3D &pm8001_ha->ccb_info[pPayload->tag];
-	t =3D ccb->task;
-
=20
 	status =3D le32_to_cpu(pPayload->status);
 	tag =3D le32_to_cpu(pPayload->tag);
 	scp =3D le32_to_cpu(pPayload->scp);
+	ccb =3D &pm8001_ha->ccb_info[tag];
+	t =3D ccb->task;
 	PM8001_IO_DBG(pm8001_ha,
 		pm8001_printk(" status =3D 0x%x\n", status));
 	if (t =3D=3D NULL)
@@ -3270,7 +3272,7 @@ mpi_task_abort_resp(struct pm8001_hba_info *pm800=
1_ha, void *piomb)
 	t->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;
 	t->task_state_flags |=3D SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&t->task_state_lock, flags);
-	pm8001_ccb_task_free(pm8001_ha, t, ccb, pPayload->tag);
+	pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	mb();
 	t->task_done(t);
 	return 0;
@@ -3497,7 +3499,7 @@ static int mpi_hw_event(struct pm8001_hba_info *p=
m8001_ha, void* piomb)
 static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *=
piomb)
 {
 	u32 pHeader =3D (u32)*(u32 *)piomb;
-	u8 opc =3D (u8)((le32_to_cpu(pHeader)) & 0xFFF);
+	u8 opc =3D (u8)(pHeader & 0xFFF);
=20
 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));
=20
@@ -3664,7 +3666,7 @@ static int process_oq(struct pm8001_hba_info *pm8=
001_ha)
 {
 	struct outbound_queue_table *circularQ;
 	void *pMsg1 =3D NULL;
-	u8 bc =3D 0;
+	u8 uninitialized_var(bc);
 	u32 ret =3D MPI_IO_STATUS_FAIL;
=20
 	circularQ =3D &pm8001_ha->outbnd_q_tbl[0];
@@ -3677,11 +3679,10 @@ static int process_oq(struct pm8001_hba_info *p=
m8001_ha)
 			mpi_msg_free_set(pm8001_ha, pMsg1, circularQ, bc);
 		}
 		if (MPI_IO_STATUS_BUSY =3D=3D ret) {
-			u32 producer_idx;
 			/* Update the producer index from SPC */
-			producer_idx =3D pm8001_read_32(circularQ->pi_virt);
-			circularQ->producer_index =3D cpu_to_le32(producer_idx);
-			if (circularQ->producer_index =3D=3D
+			circularQ->producer_index =3D
+				cpu_to_le32(pm8001_read_32(circularQ->pi_virt));
+			if (le32_to_cpu(circularQ->producer_index) =3D=3D
 				circularQ->consumer_idx)
 				/* OQ is empty */
 				break;
@@ -3712,9 +3713,9 @@ pm8001_chip_make_sg(struct scatterlist *scatter, =
int nr, void *prd)
 	}
 }
=20
-static void build_smp_cmd(u32 deviceID, u32 hTag, struct smp_req *psmp=
_cmd)
+static void build_smp_cmd(u32 deviceID, __le32 hTag, struct smp_req *p=
smp_cmd)
 {
-	psmp_cmd->tag =3D cpu_to_le32(hTag);
+	psmp_cmd->tag =3D hTag;
 	psmp_cmd->device_id =3D cpu_to_le32(deviceID);
 	psmp_cmd->len_ip_ir =3D cpu_to_le32(1|(1 << 1));
 }
@@ -3798,7 +3799,7 @@ static int pm8001_chip_ssp_io_req(struct pm8001_h=
ba_info *pm8001_ha,
 	struct ssp_ini_io_start_req ssp_cmd;
 	u32 tag =3D ccb->ccb_tag;
 	int ret;
-	__le64 phys_addr;
+	u64 phys_addr;
 	struct inbound_queue_table *circularQ;
 	u32 opc =3D OPC_INB_SSPINIIOSTART;
 	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
@@ -3819,15 +3820,15 @@ static int pm8001_chip_ssp_io_req(struct pm8001=
_hba_info *pm8001_ha,
 	/* fill in PRD (scatter/gather) table, if any */
 	if (task->num_scatter > 1) {
 		pm8001_chip_make_sg(task->scatter, ccb->n_elem, ccb->buf_prd);
-		phys_addr =3D cpu_to_le64(ccb->ccb_dma_handle +
-				offsetof(struct pm8001_ccb_info, buf_prd[0]));
-		ssp_cmd.addr_low =3D lower_32_bits(phys_addr);
-		ssp_cmd.addr_high =3D upper_32_bits(phys_addr);
+		phys_addr =3D ccb->ccb_dma_handle +
+				offsetof(struct pm8001_ccb_info, buf_prd[0]);
+		ssp_cmd.addr_low =3D cpu_to_le32(lower_32_bits(phys_addr));
+		ssp_cmd.addr_high =3D cpu_to_le32(upper_32_bits(phys_addr));
 		ssp_cmd.esgl =3D cpu_to_le32(1<<31);
 	} else if (task->num_scatter =3D=3D 1) {
-		__le64 dma_addr =3D cpu_to_le64(sg_dma_address(task->scatter));
-		ssp_cmd.addr_low =3D lower_32_bits(dma_addr);
-		ssp_cmd.addr_high =3D upper_32_bits(dma_addr);
+		u64 dma_addr =3D sg_dma_address(task->scatter);
+		ssp_cmd.addr_low =3D cpu_to_le32(lower_32_bits(dma_addr));
+		ssp_cmd.addr_high =3D cpu_to_le32(upper_32_bits(dma_addr));
 		ssp_cmd.len =3D cpu_to_le32(task->total_xfer_len);
 		ssp_cmd.esgl =3D 0;
 	} else if (task->num_scatter =3D=3D 0) {
@@ -3850,7 +3851,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
 	int ret;
 	struct sata_start_req sata_cmd;
 	u32 hdr_tag, ncg_tag =3D 0;
-	__le64 phys_addr;
+	u64 phys_addr;
 	u32 ATAP =3D 0x0;
 	u32 dir;
 	struct inbound_queue_table *circularQ;
@@ -3889,13 +3890,13 @@ static int pm8001_chip_sata_req(struct pm8001_h=
ba_info *pm8001_ha,
 	/* fill in PRD (scatter/gather) table, if any */
 	if (task->num_scatter > 1) {
 		pm8001_chip_make_sg(task->scatter, ccb->n_elem, ccb->buf_prd);
-		phys_addr =3D cpu_to_le64(ccb->ccb_dma_handle +
-				offsetof(struct pm8001_ccb_info, buf_prd[0]));
+		phys_addr =3D ccb->ccb_dma_handle +
+				offsetof(struct pm8001_ccb_info, buf_prd[0]);
 		sata_cmd.addr_low =3D lower_32_bits(phys_addr);
 		sata_cmd.addr_high =3D upper_32_bits(phys_addr);
 		sata_cmd.esgl =3D cpu_to_le32(1 << 31);
 	} else if (task->num_scatter =3D=3D 1) {
-		__le64 dma_addr =3D cpu_to_le64(sg_dma_address(task->scatter));
+		u64 dma_addr =3D sg_dma_address(task->scatter);
 		sata_cmd.addr_low =3D lower_32_bits(dma_addr);
 		sata_cmd.addr_high =3D upper_32_bits(dma_addr);
 		sata_cmd.len =3D cpu_to_le32(task->total_xfer_len);
@@ -4039,7 +4040,7 @@ static int pm8001_chip_dereg_dev_req(struct pm800=
1_hba_info *pm8001_ha,
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	memset(&payload, 0, sizeof(payload));
-	payload.tag =3D 1;
+	payload.tag =3D cpu_to_le32(1);
 	payload.device_id =3D cpu_to_le32(device_id);
 	PM8001_MSG_DBG(pm8001_ha,
 		pm8001_printk("unregister device device_id =3D %d\n", device_id));
@@ -4063,7 +4064,7 @@ static int pm8001_chip_phy_ctl_req(struct pm8001_=
hba_info *pm8001_ha,
 	u32 opc =3D OPC_INB_LOCAL_PHY_CONTROL;
 	memset(&payload, 0, sizeof(payload));
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
-	payload.tag =3D 1;
+	payload.tag =3D cpu_to_le32(1);
 	payload.phyop_phyid =3D
 		cpu_to_le32(((phy_op & 0xff) << 8) | (phyId & 0x0F));
 	ret =3D mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);
@@ -4360,8 +4361,10 @@ pm8001_chip_fw_flash_update_build(struct pm8001_=
hba_info *pm8001_ha,
 	payload.cur_image_offset =3D cpu_to_le32(info->cur_image_offset);
 	payload.total_image_len =3D cpu_to_le32(info->total_image_len);
 	payload.len =3D info->sgl.im_len.len ;
-	payload.sgl_addr_lo =3D lower_32_bits(info->sgl.addr);
-	payload.sgl_addr_hi =3D upper_32_bits(info->sgl.addr);
+	payload.sgl_addr_lo =3D
+		cpu_to_le32(lower_32_bits(le64_to_cpu(info->sgl.addr)));
+	payload.sgl_addr_hi =3D
+		cpu_to_le32(upper_32_bits(le64_to_cpu(info->sgl.addr)));
 	ret =3D mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);
 	return ret;
 }
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8=
001_hwi.h
index 9091320..1a4611e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -625,7 +625,7 @@ struct set_nvm_data_req {
 	__le32	tag;
 	__le32	len_ir_vpdd;
 	__le32	vpd_offset;
-	u32	reserved[8];
+	__le32	reserved[8];
 	__le32	resp_addr_lo;
 	__le32	resp_addr_hi;
 	__le32	resp_len;
--=20
1.7.4.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
