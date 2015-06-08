From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v4] cxlflash: Base support for IBM CXL Flash Adapter
Date: Mon, 08 Jun 2015 12:54:14 -0500
Message-ID: <5575D6C6.5080808@linux.vnet.ibm.com>
References: <1433540782-15276-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:38004 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbbFHRyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2015 13:54:20 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 8 Jun 2015 11:54:19 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id AAA7319D8026
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2015 11:45:18 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t58Hrh1Q35913874
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 10:53:43 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t58HsFJb030847
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 11:54:17 -0600
In-Reply-To: <1433540782-15276-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Looking pretty good. A few more comments.

Thanks,

Brian


On 06/05/2015 04:46 PM, Matthew R. Ochs wrote:
> +/**
> + * cxlflash_queuecommand() - sends a mid-layer request
> + * @host:	SCSI host associated with device.
> + * @scp:	SCSI command to send.
> + *
> + * Return:
> + *	0 on success
> + *	SCSI_MLQUEUE_HOST_BUSY when host is busy
> + */
> +static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
> +{
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
> +	struct afu *afu = cfg->afu;
> +	struct pci_dev *pdev = cfg->dev;
> +	struct afu_cmd *cmd;
> +	u32 port_sel = scp->device->channel + 1;
> +	int nseg, i, ncount;
> +	struct scatterlist *sg;
> +	ulong lock_flags;
> +	short lflag = 0;
> +	int rc = 0;
> +
> +	pr_debug("%s: (scp=%p) %d/%d/%d/%llu cdb=(%08X-%08X-%08X-%08X)\n",
> +		 __func__, scp, host->host_no, scp->device->channel,
> +		 scp->device->id, scp->device->lun,
> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
> +
> +	/* If a Task Management Function is active, wait for it to complete
> +	 * before continuing with regular commands.
> +	 */
> +	spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
> +	if (cfg->tmf_active)
> +		wait_event_interruptible_locked_irq(cfg->tmf_waitq,
> +						    !cfg->tmf_active);
> +	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);

This needs to return SCSI_MLQUEUE_HOST_BUSY instead of sleeping. You can't sleep
in queuecommand.

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
> +	if (scp->sc_data_direction == DMA_TO_DEVICE)
> +		lflag = SISL_REQ_FLAGS_HOST_WRITE;
> +	else
> +		lflag = SISL_REQ_FLAGS_HOST_READ;
> +
> +	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
> +			      SISL_REQ_FLAGS_SUP_UNDERRUN | lflag);
> +
> +	/* Stash the scp in the reserved field, for reuse during interrupt */
> +	cmd->rcb.scp = scp;
> +
> +	nseg = scsi_dma_map(scp);
> +	if (unlikely(nseg < 0)) {
> +		dev_err(&pdev->dev, "%s: Fail DMA map! nseg=%d\n",
> +			__func__, nseg);
> +		rc = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
> +
> +	ncount = scsi_sg_count(scp);
> +	scsi_for_each_sg(scp, sg, ncount, i) {
> +		cmd->rcb.data_len = sg_dma_len(sg);
> +		cmd->rcb.data_ea = sg_dma_address(sg);
> +	}
> +
> +	/* Copy the CDB from the scsi_cmnd passed in */
> +	memcpy(cmd->rcb.cdb, scp->cmnd, sizeof(cmd->rcb.cdb));
> +
> +	/* Send the command */
> +	rc = cxlflash_send_cmd(afu, cmd);
> +	if (unlikely(rc)) {
> +		cxlflash_cmd_checkin(cmd);
> +		scsi_dma_unmap(scp);
> +	}
> +
> +out:
> +	return rc;
> +}
> +
> +/**
> + * cxlflash_eh_device_reset_handler() - reset a single LUN
> + * @scp:	SCSI command to send.
> + *
> + * Return:
> + *	SUCCESS as defined in scsi/scsi.h
> + *	FAILED as defined in scsi/scsi.h
> + */
> +static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
> +{
> +	int rc = SUCCESS;
> +	struct Scsi_Host *host = scp->device->host;
> +	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
> +	struct afu *afu = cfg->afu;
> +	int rcr = 0;
> +
> +	pr_debug("%s: (scp=%p) %d/%d/%d/%llu "
> +		 "cdb=(%08X-%08X-%08X-%08X)\n", __func__, scp,
> +		 host->host_no, scp->device->channel,
> +		 scp->device->id, scp->device->lun,
> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
> +		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
> +
> +	rcr = send_tmf(afu, scp, TMF_LUN_RESET);
> +	if (unlikely(rcr))
> +		rc = FAILED;

Do you need to wait for all commands to the LUN to be returned before returning from
here? You could put a simple loop here, polling until there are no ops outstanding
to this LUN, if needed...


> +
> +	pr_debug("%s: returning rc=%d\n", __func__, rc);
> +	return rc;
> +}
> +

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
> +	u64 room;
> +
> +	/*
> +	 * This routine is used by critical users such an AFU sync and to
> +	 * send a task management function (TMF). Thus we want to retry a
> +	 * bit before returning an error. To avoid the performance penalty
> +	 * of MMIO, we spread the update of 'room' over multiple commands.
> +	 */
> +	if (atomic64_dec_and_test(&afu->room)) {

If you have two threads executing this code concurrently you could have a problem.
If afu->room = 1 and thread 1 decrements it and the return value is 0, we go into this
leg. If a second thread then comes in right after afu->room goes to zero, afu->room
will then get decremented to -1, and you'll send the command, regardless of whether
the AFU has room or not. Either the AFU will have room and afu->room will then
end up being off by one, or it won't have room and you'll send a command when it
does not have room.

I think if you use atomic_dec_if_positive instead, you can get rid of this race condition.
You'd then need to check the return value. If its positive, there is room, if it zero,
you are out of room and you are the thread that will reset afu->room from the AFU. If
it is negative, then you have to either return host busy, or wait for the other thread to
reset afu->room and simply try the atomic_dec_if_positive again in the loop here
instead of reading from the adapter and trying to set it from two threads.

> +		do {
> +			room = readq_be(&afu->host_map->cmd_room);
> +			atomic64_set(&afu->room, room);
> +			if (room)
> +				goto write_ioarrin;
> +			udelay(nretry);
> +		} while (nretry++ < MC_ROOM_RETRY_CNT);
> +
> +		pr_err("%s: no cmd_room to send 0x%X\n",
> +		       __func__, cmd->rcb.cdb[0]);
> +		rc = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
> +
> +write_ioarrin:
> +	writeq_be((u64)&cmd->rcb, &afu->host_map->ioarrin);
> +out:
> +	pr_debug("%s: cmd=%p len=%d ea=%p rc=%d\n", __func__, cmd,
> +		 cmd->rcb.data_len, (void *)cmd->rcb.data_ea, rc);
> +	return rc;
> +}
> +


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


