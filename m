From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] cxlflash: Base support for IBM CXL Flash Adapter
Date: Thu, 04 Jun 2015 09:38:11 -0500
Message-ID: <557062D3.7080303@linux.vnet.ibm.com>
References: <1433289319-52917-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:47622 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbbFDOiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2015 10:38:18 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 4 Jun 2015 08:38:18 -0600
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 3A1F238C8051
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2015 10:38:16 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t54EcGlT60751928
	for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2015 14:38:16 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t54EcEHQ002022
	for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2015 10:38:15 -0400
In-Reply-To: <1433289319-52917-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 06/02/2015 06:55 PM, Matthew R. Ochs wrote:
> +/**
> + * send_tmf() - sends a Task Management Function (TMF)
> + * @afu:	AFU to checkout from.
> + * @scp:	SCSI command from stack.
> + * @tmfcmd:	TMF command to send.
> + *
> + * Return:
> + *	0 on success
> + *	SCSI_MLQUEUE_HOST_BUSY when host is busy
> + */
> +static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
> +{
> +	struct afu_cmd *cmd;
> +
> +	u32 port_sel = scp->device->channel + 1;
> +	short lflag = 0;
> +	struct Scsi_Host *host = scp->device->host;
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
> +	int rc = 0;
> +
> +	write_lock(&cfg->tmf_lock);

What is this lock protecting? The only thing it seems to be accomplishing is
making sure one thread isn't sending a TMF and another thread is sending
a normal I/O command at the exact same time, yet it looks like you still
allow a TMF to be sent and a normal I/O to be sent immediately after, before
receiving the TMF response.

> +
> +	cmd = cxlflash_cmd_checkout(afu);
> +	if (unlikely(!cmd)) {
> +		pr_err("%s: could not get a free command\n", __func__);
> +		rc = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
> +
> +	cmd->rcb.ctx_id = afu->ctx_hndl;
> +	cmd->rcb.port_sel = port_sel;
> +	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
> +
> +	lflag = SISL_REQ_FLAGS_TMF_CMD;
> +
> +	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
> +				SISL_REQ_FLAGS_SUP_UNDERRUN | lflag);
> +
> +	/* Stash the scp in the reserved field, for reuse during interrupt */
> +	cmd->rcb.scp = scp;
> +
> +	/* Copy the CDB from the cmd passed in */
> +	memcpy(cmd->rcb.cdb, &tmfcmd, sizeof(tmfcmd));
> +
> +	/* Send the command */
> +	rc = cxlflash_send_cmd(afu, cmd);
> +out:
> +	write_unlock(&cfg->tmf_lock);
> +	return rc;
> +
> +}
> +

> +/**
> + * cxlflash_send_cmd() - sends an AFU command
> + * @afu:	AFU associated with the host.
> + * @cmd:	AFU command to send.
> + *
> + * Return:
> + *	0 on success
> + *	-1 on failure
> + */
> +int cxlflash_send_cmd(struct afu *afu, struct afu_cmd *cmd)
> +{
> +	int nretry = 0;
> +	int rc = 0;
> +
> +	/* send_cmd is used by critical users such an AFU sync and to
> +	 * send a task management function (TMF). So we do want to retry
> +	 * a bit before returning an error.
> +	 */
> +	do {
> +		afu->room = readq_be(&afu->host_map->cmd_room);

Looks like you now have an MMIO load as part of sending every command,
including commands coming from queuecommand. Won't that be a performance issue?
Is there any way to avoid this? Could you perhaps decrement afu->room
in this function and only re-read it from the AFU when the counter hits zero?

> +		if (afu->room)
> +			break;
> +		udelay(nretry);
> +	} while (nretry++ < MC_ROOM_RETRY_CNT);
> +
> +	/* Write IOARRIN */
> +	if (afu->room)
> +		writeq_be((u64)&cmd->rcb, &afu->host_map->ioarrin);
> +	else {
> +		pr_err("%s: no cmd_room to send 0x%X\n",
> +		       __func__, cmd->rcb.cdb[0]);
> +		rc = SCSI_MLQUEUE_HOST_BUSY;
> +	}
> +
> +	pr_debug("%s: cmd=%p len=%d ea=%p rc=%d\n", __func__, cmd,
> +		 cmd->rcb.data_len, (void *)cmd->rcb.data_ea, rc);
> +
> +	return rc;
> +}
> +



-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


