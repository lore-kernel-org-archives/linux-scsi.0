From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 3/4] cxlflash: Superpipe support
Date: Thu, 06 Aug 2015 15:46:05 -0500
Message-ID: <55C3C78D.7070900@linux.vnet.ibm.com>
References: <1438576417-32974-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:48503 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774AbbHFUqL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2015 16:46:11 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 6 Aug 2015 14:46:11 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 958051FF0049
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2015 14:37:18 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t76KjWHA44630158
	for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2015 13:45:32 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t76Kk7EV020406
	for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2015 14:46:08 -0600
In-Reply-To: <1438576417-32974-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 08/02/2015 11:33 PM, Matthew R. Ochs wrote:
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 9515525..196c651 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -484,6 +484,29 @@ static const char *cxlflash_driver_info(struct Scsi_Host *host)
>  }
> 
>  /**
> + * is_scsi_read_write() - evaluates if a SCSI command is read or write
> + * @scp:	SCSI command to evaluate.
> + *
> + * Return: true or false
> + */
> +static inline bool is_scsi_read_write(struct scsi_cmnd *scp)
> +{
> +	switch (scp->cmnd[0]) {
> +	case READ_6:
> +	case READ_10:
> +	case READ_12:
> +	case READ_16:
> +	case WRITE_6:
> +	case WRITE_10:
> +	case WRITE_12:
> +	case WRITE_16:
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/**
>   * cxlflash_queuecommand() - sends a mid-layer request
>   * @host:	SCSI host associated with device.
>   * @scp:	SCSI command to send.
> @@ -512,6 +535,13 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>  			     get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  			     get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
> 
> +	/* Fail all read/write commands when in operating superpipe mode */
> +	if (scp->device->hostdata && is_scsi_read_write(scp)) {
> +		pr_debug_ratelimited("%s: LUN being used in superpipe mode. "
> +				     "Operation not allowed!\n", __func__);
> +		goto error;
> +	}

Not sure I like this. A couple of concerns:

1. Any process that comes along and issues a read to the device will result in I/O errors getting logged
   by the layers above you. The general expectation is that if reads or writes are failing on a block device,
   then something is wrong and the user should know about it. A user innocently running "fdisk -l", for example,
   to list all disk partitions on the system, would see errors getting logged for every disk configured for
   superpipe mode.
2. How will users know that devices are in superpipe mode? The only indication is the driver specific sysfs attribute
   that no existing tooling will be checking. GUI tools to do disk partitioning and such will see these devices
   and present them to the user with the expectation that something can be done with them.
3. If this is a multipath device, you'll have a dm device sitting on top of this and potentially have multipathd doing health
   checking periodically and these devices will show up in multipath -ll output.

It seems to me like the cleanest option would be, when switching into superpipe mode, for the user code doing
this to unbind the sd driver from the relevant scsi device. This will prevent any reads or writes from being
issued to the LUN from the block layer, since there will no longer be any way to do this. It will also prevent
these devices from showing up in GUIs and menus where we don't want them to.

So, I'd say, kill this snooping of the op code and failing I/O in superpipe mode, and solve this in userspace.


> +
>  	/*
>  	 * If a Task Management Function is active, wait for it to complete
>  	 * before continuing with regular commands.
> @@ -531,7 +561,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>  		goto out;
>  	case EEH_STATE_FAILED:
>  		pr_debug_ratelimited("%s: device has failed!\n", __func__);
> -		goto out;
> +		goto error;
>  	case EEH_STATE_NONE:
>  		break;
>  	}
> @@ -584,6 +614,10 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
> 
>  out:
>  	return rc;
> +error:
> +	scp->result = (DID_NO_CONNECT << 16);
> +	scp->scsi_done(scp);
> +	return 0;
>  }
> 
>  /**

> +
> +/**
> + * read_cap16() - issues a SCSI READ_CAP16 command
> + * @sdev:	SCSI device associated with LUN.
> + * @lli:	LUN destined for capacity request.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
> +{
> +	struct glun_info *gli = lli->parent;
> +	u8 *buf = NULL;
> +	u8 *cmd_buf = NULL;
> +	u8 *scsi_cmd = NULL;
> +	u8 *sense_buf = NULL;
> +	int rc = 0;
> +	int result = 0;
> +	int retry_cnt = 0;
> +	u32 tout = (MC_DISCOVERY_TIMEOUT * HZ);
> +	size_t size;
> +
> +	size = CMD_BUFSIZE + MAX_COMMAND_SIZE + SCSI_SENSE_BUFFERSIZE;
> +retry:
> +	buf = kzalloc(size, GFP_KERNEL);
> +	if (unlikely(!buf)) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	cmd_buf = buf;
> +	scsi_cmd = cmd_buf + CMD_BUFSIZE;
> +	sense_buf = scsi_cmd + MAX_COMMAND_SIZE;
> +
> +	scsi_cmd[0] = SERVICE_ACTION_IN_16;	/* read cap(16) */
> +	scsi_cmd[1] = SAI_READ_CAPACITY_16;	/* service action */
> +	put_unaligned_be32(CMD_BUFSIZE, &scsi_cmd[10]);
> +
> +	pr_debug("%s: %ssending cmd(0x%x)\n", __func__, retry_cnt ? "re" : "",
> +		 scsi_cmd[0]);
> +
> +	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
> +			      CMD_BUFSIZE, sense_buf, tout, 5, 0, NULL);
> +
> +	if (driver_byte(result) == DRIVER_SENSE) {
> +		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
> +		if (result & SAM_STAT_CHECK_CONDITION) {
> +			struct scsi_sense_hdr sshdr;
> +
> +			scsi_normalize_sense(sense_buf, SCSI_SENSE_BUFFERSIZE,
> +					    &sshdr);
> +			switch (sshdr.sense_key) {
> +			case NO_SENSE:
> +			case RECOVERED_ERROR:
> +				/* fall through */
> +			case NOT_READY:
> +				result &= ~SAM_STAT_CHECK_CONDITION;
> +				break;
> +			case UNIT_ATTENTION:
> +				switch (sshdr.asc) {
> +				case 0x29: /* Power on Reset or Device Reset */
> +					/* fall through */
> +				case 0x2A: /* Device capacity changed */
> +				case 0x3F: /* Report LUNs changed */
> +					/* Retry the command once more */
> +					if (retry_cnt++ < 1) {
> +						kfree(buf);
> +						goto retry;
> +					}
> +				}
> +				break;
> +			default:
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (result) {
> +		pr_err("%s: command failed, result=0x%x\n", __func__, result);
> +		rc = -EIO;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Read cap was successful, grab values from the buffer;
> +	 * note that we don't need to worry about unaligned access
> +	 * as the buffer is allocated on an aligned boundary.
> +	 */
> +	spin_lock(&gli->slock);
> +	gli->max_lba = swab64(*((u64 *)&cmd_buf[0]));
> +	gli->blk_len = swab32(*((u32 *)&cmd_buf[8]));

This doesn't look right. How does this work on big endian? I think you want to be using
be64_to_cpu and be32_to_cpu here.

> +	spin_unlock(&gli->slock);
> +
> +out:
> +	kfree(buf);
> +	pr_debug("%s: maxlba=%lld blklen=%d rc=%d\n", __func__,
> +		 gli->max_lba, gli->blk_len, rc);
> +	return rc;
> +}
> +



-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


