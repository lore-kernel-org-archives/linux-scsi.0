From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v5] cxlflash: Base support for IBM CXL Flash Adapter
Date: Mon, 08 Jun 2015 17:56:47 -0500
Message-ID: <55761DAF.9030203@linux.vnet.ibm.com>
References: <1433802653-7476-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:42036 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbbFHW4x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2015 18:56:53 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 8 Jun 2015 18:56:52 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 89B12C90041
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2015 18:47:57 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t58MuoKa61538468
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 22:56:50 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t58Mun8A005150
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 18:56:50 -0400
In-Reply-To: <1433802653-7476-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 06/08/2015 05:30 PM, Matthew R. Ochs wrote:
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
> +	long newval;
> +
> +	/*
> +	 * This routine is used by critical users such an AFU sync and to
> +	 * send a task management function (TMF). Thus we want to retry a
> +	 * bit before returning an error. To avoid the performance penalty
> +	 * of MMIO, we spread the update of 'room' over multiple commands.
> +	 */
> +retry:
> +	newval = atomic64_dec_if_positive(&afu->room);
> +	if (!newval) {
> +		do {
> +			room = readq_be(&afu->host_map->cmd_room);
> +			atomic64_set(&afu->room, room);
> +			if (room)
> +				goto write_ioarrin;
> +		} while (nretry++ < MC_ROOM_RETRY_CNT);

It looks like you removed the udelay here. Was that intentional? 

> +
> +		pr_err("%s: no cmd_room to send 0x%X\n",
> +		       __func__, cmd->rcb.cdb[0]);
> +		rc = SCSI_MLQUEUE_HOST_BUSY;

If you actually get here, how do you get out of this state? Since now afu->room is
zero and anyone that comes through here will go to the else if leg.

> +		goto out;
> +	} else if (unlikely(newval < 0)) {
> +		/* This should be rare. i.e. Only if two threads race and
> +		 * decrement before the MMIO read is done. In this case
> +		 * just benefit from the other thread having updated
> +		 * afu->room.
> +		 */
> +		if (nretry++ < MC_ROOM_RETRY_CNT)

I'm guessing you'd want the udelay here as well.

> +			goto retry;
> +		else {
> +			rc = SCSI_MLQUEUE_HOST_BUSY;
> +			goto out;
> +		}
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


