From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH]qla4xxx:Add support for Async Message PDUs
Date: Tue, 22 Apr 2008 11:20:51 -0500
Message-ID: <480E1063.2060308@cs.wisc.edu>
References: <1208551487.5159.5.camel@d5102avq18960.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54034 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYDVQU7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 12:20:59 -0400
In-Reply-To: <1208551487.5159.5.camel@d5102avq18960.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

David C Somayajulu wrote:
> +int qla4xxx_conn_close_sess_logout(struct scsi_qla_host * ha,
> +	   uint16_t fw_ddb_index, uint16_t connection_id, uint16_t option)
> +{
> +	uint32_t mbox_cmd[MBOX_REG_COUNT];
> +	uint32_t mbox_sts[MBOX_REG_COUNT];
> +
> +	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
> +	memset(&mbox_sts, 0, sizeof(mbox_sts));
> +
> +	mbox_cmd[0] = MBOX_CMD_CONN_CLOSE_SESS_LOGOUT;
> +	mbox_cmd[1] = fw_ddb_index;
> +	mbox_cmd[2] = connection_id;
> +	mbox_cmd[3] = LOGOUT_OPTION_RESET;
> +
> +	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
> +		&mbox_sts[0]) != QLA_SUCCESS) {
> +		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_CONN_CLOSE_SESS_LOGOUT "
> +			      "option %04x failed sts %04X %04X",
> +			      ha->host_no, __func__,
> +			      option, mbox_sts[0], mbox_sts[1]));
> +		if (mbox_sts[0] == 0x4005)
> +			DEBUG2(printk("%s reason %04X\n", __func__,
> +				      mbox_sts[1]));
> +	}
> +	return QLA_SUCCESS;


Does this logout function logout a session and stop it from being logged 
back in, or does it logout the session then the firmware tries to log 
back in?


> +/*
> + * qla4xxx_async_iocbs - processes ASYNC PDU IOCBS, if they are greater in
> + * length than 48 bytes (i.e., more than just the iscsi header). Used for
> + * unsolicited pdus received from target.
> + */
> +static void qla4xxx_async_iocbs(struct scsi_qla_host *ha,
> +		struct async_msg_pdu_iocb *amsg_pdu_iocb)
> +{
> +	struct iscsi_hdr *hdr;
> +	struct async_pdu_iocb *apdu;
> +	uint32_t len;
> +	void *buf_addr;
> +	dma_addr_t buf_addr_dma;
> +	uint32_t offset;
> +	struct passthru0 *pthru0_iocb;
> +	struct scsi_sense_hdr sshdr;
> +	struct ddb_entry *ddb_entry = NULL;
> +	uint8_t using_prealloc = 1;
> +	uint8_t async_event_type;
> +
> +	apdu = (struct async_pdu_iocb *)amsg_pdu_iocb->iocb;
> +	hdr = (struct iscsi_hdr *)apdu->iscsi_pdu_hdr;
> +	len = hdr->hlength + hdr->dlength[2] +
> +		(hdr->dlength[1]<<8) + (hdr->dlength[0]<<16);
> +
> +	offset = sizeof (struct passthru0) + sizeof (struct passthru_status);
> +	if (len <= (PAGE_SIZE - offset)) {
> +		buf_addr_dma = ha->gen_req_rsp_iocb_dma + offset;
> +		buf_addr = (uint8_t *)ha->gen_req_rsp_iocb + offset;
> +	} else {
> +		using_prealloc = 0;
> +		buf_addr = dma_alloc_coherent(&ha->pdev->dev, len,
> +                                        &buf_addr_dma, GFP_KERNEL);
> +		if (!buf_addr) {
> +			dev_info(&ha->pdev->dev,
> +				"%s: dma_alloc_coherent failed\n", __func__);
> +			return;
> +		}
> +	}
> +	/* Create the pass-thru0 iocb */
> +	pthru0_iocb = ha->gen_req_rsp_iocb;
> +	memset(pthru0_iocb, 0, offset);
> +
> +	pthru0_iocb->hdr.entryType = ET_PASSTHRU0;
> +	pthru0_iocb->controlFlags =
> +		cpu_to_le16(PT_FLAG_ISCSI_PDU | PT_FLAG_WAIT_4_RESPONSE);
> +	pthru0_iocb->timeout = cpu_to_le16(PT_DEFAULT_TIMEOUT);
> +	pthru0_iocb->inDataSeg64.base.addrHigh =
> +		cpu_to_le32(MSDW(buf_addr_dma));
> +	pthru0_iocb->inDataSeg64.base.addrLow =
> +		cpu_to_le32(LSDW(buf_addr_dma));
> +	pthru0_iocb->inDataSeg64.count = cpu_to_le32(len);
> +
> +	if (qla4xxx_issue_iocb(ha, sizeof(struct passthru0),
> +		ha->gen_req_rsp_iocb_dma) != QLA_SUCCESS) {
> +		dev_info(&ha->pdev->dev,
> +			"%s: qla4xxx_issue_iocb failed\n", __func__);
> +		goto exit_async_pdu_iocb;
> +	}
> + 
> +	async_event_type = ((struct iscsi_async *)hdr)->async_event;
> +	ddb_entry = ha->fw_ddb_index_map[apdu->target_id];
> +
> +	if (ddb_entry == NULL)
> +		goto exit_async_pdu_iocb;
> +
> +	switch (async_event_type) {
> +	case ISCSI_ASYNC_MSG_SCSI_EVENT:
> +		if (!scsi_normalize_sense((uint8_t *)buf_addr, len, &sshdr)) {
> +			dev_info(&ha->pdev->dev,
> +				"%s: scsi_normalize_sense failed\n", __func__);
> +			break;
> +		}
> +		if (sshdr.asc == 0x3f && sshdr.ascq == 0x0e) {
> +			scsi_scan_target(&ddb_entry->sess->dev, 0,
> +				ddb_entry->sess->target_id, SCAN_WILD_CARD, 0);
>

I do not think you can call scsi_scan_target from your dpc thread. If 
there was a problem that the the dpc thread needed to recover the 
session or host for it would not be able to because the scsi_scan_target 
call would be blocked on the recovery of that host or session.

You need to modify scsi_transport_iscsi.c:session->scan_work related 
code to be able to be called from _iscsi_unblock_session and from some 
new function that just checks the state and scans the session.
