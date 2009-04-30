From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Fix a regression due to refactoring in interrupt handler code
Date: Wed, 29 Apr 2009 18:00:58 -0700
Message-ID: <453B218D-08A2-4C95-8799-46B9B88A6373@qlogic.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F44B4@azsmsx501.amr.corp.intel.com> <C61D3444.E384%anirban.chakraborty@qlogic.com> <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A63FE0@azsmsx501.amr.corp.intel.com> <C03D50D6-2441-4AE3-9AD2-24037612BF1C@qlogic.com> <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A643F9@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/mixed; boundary="Apple-Mail-9-753053579"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:42615 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbZD3BA7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 21:00:59 -0400
In-Reply-To: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A643F9@azsmsx501.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Styner, Douglas W" <douglas.w.styner@intel.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Driver <Linux-Driver@qlogic.com>, "Ma, Chinang" <chinang.ma@intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "willy@linux.intel.com" <willy@linux.intel.com>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>

--Apple-Mail-9-753053579
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit


On Apr 29, 2009, at 11:04 AM, Styner, Douglas W wrote:

> Anirban Chakraborty <anirban.chakraborty@qlogic.com> writes
>> Is it possible to find out if the zio mode is turned on. If not,  
>> could you > please turn it on and let us know the numbers? You can  
>> turn it on by doing > following:
>> echo "1" > /sys/class/scsi_host/host<>/zio
> We explicit set zio to 1, zio_timer to 200 and qdepth to 48.
>
>> Also, can you let me know the oprofile setup and the tool you used?
> Oprofile collection:
> chrt -p 48 $$
> export PATH=/usr/local/bin:/sbin:$PATH
> opcontrol --init
> opcontrol --vmlinux=/usr/src/linux-`uname -r`/vmlinux
> opcontrol -e=CPU_CLK_UNHALTED:80000
> opcontrol --start-daemon
> sleep 5
> opcontrol --start
> sleep 60
> opcontrol --stop
> opcontrol --save=$1
> opcontrol --deinit
> .
> We used vtune to compare to oprofile.
>

Can you please try the attached patch? Also, what f/w version are you  
running with? What tool are you using to generate the load?
Thanks much,
Anirban



--Apple-Mail-9-753053579
Content-Disposition: attachment; filename="perf.patch"
Content-Type: application/octet-stream; x-unix-mode=0644; name="perf.patch"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 714ee67..52ea0b5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -186,7 +186,6 @@ struct req_que;
  * SCSI Request Block
  */
 typedef struct srb {
-	struct req_que *que;
 	struct fc_port *fcport;
 
 	struct scsi_cmnd *cmd;		/* Linux SCSI command pkt */
@@ -2643,7 +2642,7 @@ typedef struct scsi_qla_host {
 #define VP_ERR_FAB_LOGOUT	4
 #define VP_ERR_ADAP_NORESOURCES	5
 	struct qla_hw_data *hw;
-	int	req_ques[QLA_MAX_HOST_QUES];
+	struct req_que *req;
 } scsi_qla_host_t;
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 528913f..088d595 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -294,8 +294,10 @@ qla81xx_fac_erase_sector(scsi_qla_host_t *, uint32_t, uint32_t);
 extern irqreturn_t qla2100_intr_handler(int, void *);
 extern irqreturn_t qla2300_intr_handler(int, void *);
 extern irqreturn_t qla24xx_intr_handler(int, void *);
-extern void qla2x00_process_response_queue(struct rsp_que *);
-extern void qla24xx_process_response_queue(struct rsp_que *);
+extern void qla2x00_process_response_queue(struct scsi_qla_host *,
+	struct rsp_que *);
+extern void qla24xx_process_response_queue(struct scsi_qla_host *,
+	struct rsp_que *);
 
 extern int qla2x00_request_irqs(struct qla_hw_data *, struct rsp_que *);
 extern void qla2x00_free_irqs(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bd7dd84..c13ad40 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3180,8 +3180,7 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
 	uint32_t wait_time;
-	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req_q_map[vha->req_ques[0]];
+	struct req_que *req = vha->req;
 	struct rsp_que *rsp = req->rsp;
 
 	atomic_set(&vha->loop_state, LOOP_UPDATE);
@@ -4165,7 +4164,7 @@ qla24xx_configure_vhba(scsi_qla_host_t *vha)
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
-	struct req_que *req = ha->req_q_map[vha->req_ques[0]];
+	struct req_que *req = vha->req;
 	struct rsp_que *rsp = req->rsp;
 
 	if (!vha->vp_idx)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index a8abbb9..51f8f49 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -174,7 +174,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 	}
 
 	vha = sp->fcport->vha;
-	req = sp->que;
+	req = vha->req;
 
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
@@ -235,7 +235,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	}
 
 	vha = sp->fcport->vha;
-	req = sp->que;
+	req = vha->req;
 
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
@@ -353,7 +353,6 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Build command packet */
 	req->current_outstanding_cmd = handle;
 	req->outstanding_cmds[handle] = sp;
-	sp->que = req;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
@@ -399,7 +398,7 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
 	if (vha->flags.process_response_queue &&
 	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
-		qla2x00_process_response_queue(rsp);
+		qla2x00_process_response_queue(vha, rsp);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (QLA_SUCCESS);
@@ -656,7 +655,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	}
 
 	vha = sp->fcport->vha;
-	req = sp->que;
+	req = vha->req;
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
@@ -724,19 +723,12 @@ qla24xx_start_scsi(srb_t *sp)
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
-	uint16_t que_id;
 
 	/* Setup device pointers. */
 	ret = 0;
-	que_id = vha->req_ques[0];
 
-	req = ha->req_q_map[que_id];
-	sp->que = req;
-
-	if (req->rsp)
-		rsp = req->rsp;
-	else
-		rsp = ha->rsp_q_map[que_id];
+	req = vha->req;
+	rsp = req->rsp;
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
 
@@ -842,7 +834,7 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
 	if (vha->flags.process_response_queue &&
 		rsp->ring_ptr->signature != RESPONSE_PROCESSED)
-		qla24xx_process_response_queue(rsp);
+		qla24xx_process_response_queue(vha, rsp);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_SUCCESS;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d049818..11283d9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -51,7 +51,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		hccr = RD_REG_WORD(&reg->hccr);
 		if (hccr & HCCR_RISC_PAUSE) {
@@ -96,7 +96,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 			WRT_REG_WORD(&reg->semaphore, 0);
 			RD_REG_WORD(&reg->semaphore);
 		} else {
-			qla2x00_process_response_queue(rsp);
+			qla2x00_process_response_queue(vha, rsp);
 
 			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
 			RD_REG_WORD(&reg->hccr);
@@ -147,7 +147,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
 		if (stat & HSR_RISC_PAUSED) {
@@ -195,7 +195,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 			qla2x00_async_event(vha, rsp, mb);
 			break;
 		case 0x13:
-			qla2x00_process_response_queue(rsp);
+			qla2x00_process_response_queue(vha, rsp);
 			break;
 		case 0x15:
 			mb[0] = MBA_CMPLT_1_16BIT;
@@ -685,9 +685,9 @@ skip_rio:
 		    vha->host_no));
 
 		if (IS_FWI2_CAPABLE(ha))
-			qla24xx_process_response_queue(rsp);
+			qla24xx_process_response_queue(vha, rsp);
 		else
-			qla2x00_process_response_queue(rsp);
+			qla2x00_process_response_queue(vha, rsp);
 		break;
 
 	case MBA_DISCARD_RND_FRAME:
@@ -766,9 +766,7 @@ qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, void *data)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = NULL;
 
-	req = ha->req_q_map[vha->req_ques[0]];
-	if (!req)
-		return;
+	req = vha->req;
 	if (req->max_q_depth <= sdev->queue_depth)
 		return;
 
@@ -872,17 +870,14 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
  * @ha: SCSI driver HA context
  */
 void
-qla2x00_process_response_queue(struct rsp_que *rsp)
+qla2x00_process_response_queue(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
-	struct scsi_qla_host *vha;
 	struct qla_hw_data *ha = rsp->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	sts_entry_t	*pkt;
 	uint16_t        handle_cnt;
 	uint16_t        cnt;
 
-	vha = qla2x00_get_rsp_host(rsp);
-
 	if (!vha->flags.online)
 		return;
 
@@ -1487,12 +1482,9 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
  * @ha: SCSI driver HA context
  */
 void
-qla24xx_process_response_queue(struct rsp_que *rsp)
+qla24xx_process_response_queue(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	struct sts_entry_24xx *pkt;
-	struct scsi_qla_host *vha;
-
-	vha = qla2x00_get_rsp_host(rsp);
 
 	if (!vha->flags.online)
 		return;
@@ -1626,7 +1618,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1664,7 +1656,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			break;
 		case 0x13:
 		case 0x14:
-			qla24xx_process_response_queue(rsp);
+			qla24xx_process_response_queue(vha, rsp);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
@@ -1692,6 +1684,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
+	struct scsi_qla_host *vha;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1701,10 +1694,11 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	}
 	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
+	vha = pci_get_drvdata(ha->pdev);
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	qla24xx_process_response_queue(rsp);
+	qla24xx_process_response_queue(vha, rsp);
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
 	spin_unlock_irq(&ha->hardware_lock);
@@ -1718,6 +1712,7 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
+	struct scsi_qla_host *vha;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1730,7 +1725,8 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	qla24xx_process_response_queue(rsp);
+	vha = qla2x00_get_rsp_host(rsp);
+	qla24xx_process_response_queue(vha, rsp);
 
 	spin_unlock_irq(&ha->hardware_lock);
 
@@ -1760,7 +1756,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock_irq(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1798,7 +1794,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 			break;
 		case 0x13:
 		case 0x14:
-			qla24xx_process_response_queue(rsp);
+			qla24xx_process_response_queue(vha, rsp);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 51716c7..2c2a51b 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -398,9 +398,8 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	qla2x00_start_timer(vha, qla2x00_timer, WATCH_INTERVAL);
 
-	memset(vha->req_ques, 0, sizeof(vha->req_ques));
-	vha->req_ques[0] = ha->req_q_map[0]->id;
-	host->can_queue = ha->req_q_map[0]->length + 128;
+	vha->req = base_vha->req;
+	host->can_queue = base_vha->req->length + 128;
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
 	host->max_cmd_len = MAX_CMDSZ;
@@ -517,7 +516,7 @@ int qla25xx_update_req_que(struct scsi_qla_host *vha, uint8_t que, uint8_t qos)
 int
 qla25xx_delete_queues(struct scsi_qla_host *vha, uint8_t que_no)
 {
-	int cnt, ret = 0;
+	int ret = 0;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
 	struct qla_hw_data *ha = vha->hw;
@@ -545,34 +544,29 @@ qla25xx_delete_queues(struct scsi_qla_host *vha, uint8_t que_no)
 			}
 		}
 	} else {  /* delete all queues of this host */
-		for (cnt = 0; cnt < QLA_MAX_HOST_QUES; cnt++) {
-			/* Delete request queues */
-			req = ha->req_q_map[vha->req_ques[cnt]];
-			if (req && req->id) {
-				rsp = req->rsp;
-				ret = qla25xx_delete_req_que(vha, req);
+		req = vha->req;
+		if (req && req->id) {
+			rsp = req->rsp;
+			ret = qla25xx_delete_req_que(vha, req);
+			if (ret != QLA_SUCCESS) {
+				qla_printk(KERN_WARNING, ha,
+					"Couldn't delete req que %d\n",
+					req->id);
+				return ret;
+			}
+			vha->req = ha->req_q_map[0];
+		/* Delete associated response queue */
+			if (rsp && rsp->id) {
+				ret = qla25xx_delete_rsp_que(vha, rsp);
 				if (ret != QLA_SUCCESS) {
 					qla_printk(KERN_WARNING, ha,
-						"Couldn't delete req que %d\n",
-						vha->req_ques[cnt]);
+					"Couldn't delete rsp que %d\n",
+					rsp->id);
 					return ret;
 				}
-				vha->req_ques[cnt] = ha->req_q_map[0]->id;
-			/* Delete associated response queue */
-				if (rsp && rsp->id) {
-					ret = qla25xx_delete_rsp_que(vha, rsp);
-					if (ret != QLA_SUCCESS) {
-						qla_printk(KERN_WARNING, ha,
-						"Couldn't delete rsp que %d\n",
-						rsp->id);
-						return ret;
-					}
-				}
 			}
 		}
 	}
-	qla_printk(KERN_INFO, ha, "Queues deleted for vport:%d\n",
-		vha->vp_idx);
 	return ret;
 }
 
@@ -759,7 +753,7 @@ qla25xx_create_queues(struct scsi_qla_host *vha, uint8_t qos)
 	ret = qla25xx_create_req_que(ha, options, vha->vp_idx, 0, ret,
 					qos & ~BIT_7);
 	if (ret) {
-		vha->req_ques[0] = ret;
+		vha->req = ha->req_q_map[ret];
 		qla_printk(KERN_INFO, ha, "Request Que:%d created.\n", ret);
 	} else
 		qla_printk(KERN_WARNING, ha, "Request Que create failed\n");
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e4fdcda..e00d7bc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -387,7 +387,6 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 
 	sp->fcport = fcport;
 	sp->cmd = cmd;
-	sp->que = ha->req_q_map[0];
 	sp->flags = 0;
 	CMD_SP(cmd) = (void *)sp;
 	cmd->scsi_done = done;
@@ -612,7 +611,7 @@ qla2x00_wait_for_loop_ready(scsi_qla_host_t *vha)
 void
 qla2x00_abort_fcport_cmds(fc_port_t *fcport)
 {
-	int cnt, que, id;
+	int cnt;
 	unsigned long flags;
 	srb_t *sp;
 	scsi_qla_host_t *vha = fcport->vha;
@@ -620,32 +619,27 @@ qla2x00_abort_fcport_cmds(fc_port_t *fcport)
 	struct req_que *req;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < QLA_MAX_HOST_QUES; que++) {
-		id = vha->req_ques[que];
-		req = ha->req_q_map[id];
-		if (!req)
+	req = vha->req;
+	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+		sp = req->outstanding_cmds[cnt];
+		if (!sp)
+			continue;
+		if (sp->fcport != fcport)
 			continue;
-		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-			sp = req->outstanding_cmds[cnt];
-			if (!sp)
-				continue;
-			if (sp->fcport != fcport)
-				continue;
 
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			if (ha->isp_ops->abort_command(vha, sp, req)) {
-				DEBUG2(qla_printk(KERN_WARNING, ha,
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if (ha->isp_ops->abort_command(vha, sp, req)) {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
 				"Abort failed --  %lx\n",
 				sp->cmd->serial_number));
-			} else {
-				if (qla2x00_eh_wait_on_command(sp->cmd) !=
-					QLA_SUCCESS)
-					DEBUG2(qla_printk(KERN_WARNING, ha,
-					"Abort failed while waiting --  %lx\n",
-					sp->cmd->serial_number));
-			}
-			spin_lock_irqsave(&ha->hardware_lock, flags);
+		} else {
+			if (qla2x00_eh_wait_on_command(sp->cmd) !=
+				QLA_SUCCESS)
+				DEBUG2(qla_printk(KERN_WARNING, ha,
+				"Abort failed while waiting --  %lx\n",
+				sp->cmd->serial_number));
 		}
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
@@ -709,7 +703,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	spt = (srb_t *) CMD_SP(cmd);
 	if (!spt)
 		return SUCCESS;
-	req = spt->que;
+	req = vha->req;
 
 	/* Check active list for command command. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -777,7 +771,7 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 		return status;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	req = sp->que;
+	req = vha->req;
 	for (cnt = 1; status == QLA_SUCCESS &&
 		cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
 		sp = req->outstanding_cmds[cnt];
@@ -1123,7 +1117,7 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
-	struct req_que *req = ha->req_q_map[vha->req_ques[0]];
+	struct req_que *req = vha->req;
 
 	if (sdev->tagged_supported)
 		scsi_activate_tcq(sdev, req->max_q_depth);
@@ -1810,7 +1804,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, base_vha);
 
 	host = base_vha->host;
-	base_vha->req_ques[0] = req->id;
+	base_vha->req = req;
 	host->can_queue = req->length + 128;
 	if (IS_QLA2XXX_MIDTYPE(ha))
 		base_vha->mgmt_svr_loop_id = 10 + base_vha->vp_idx;

--Apple-Mail-9-753053579
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 7bit




--Apple-Mail-9-753053579--
