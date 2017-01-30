From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 16/24] aacraid: Add task management functionality
Date: Mon, 30 Jan 2017 12:19:47 +0100
Message-ID: <20170130111947.GL3603@linux-x5ow.site>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-17-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51961 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751053AbdA3LUY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 06:20:24 -0500
Content-Disposition: inline
In-Reply-To: <20170127192853.10082-17-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On Fri, Jan 27, 2017 at 11:28:45AM -0800, Raghava Aditya Renukunta wrote:
> Added support to send out task management commands.
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> 
> ---

[...]

> @@ -3365,7 +3462,151 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
>  
>  /**
>   *
> - * aac_send_scb_fib
> + * aac_hba_callback
> + * @context: the context set in the fib - here it is scsi cmd
> + * @fibptr: pointer to the fib
> + *
> + * Handles the completion of a native HBA scsi command
> + *
> + */
> +void aac_hba_callback(void *context, struct fib *fibptr)
> +{
> +	struct aac_dev *dev;
> +	struct scsi_cmnd *scsicmd;
> +
> +	scsicmd = (struct scsi_cmnd *) context;
> +
> +	if (!aac_valid_context(scsicmd, fibptr))
> +		return;
> +
> +	WARN_ON(fibptr == NULL);
> +	dev = fibptr->dev;
> +
> +	if (!(fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF))
> +		scsi_dma_unmap(scsicmd);
> +
> +	if (fibptr->flags & FIB_CONTEXT_FLAG_FASTRESP) {
> +		/* fast response */
> +		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
> +	} else {
> +		struct aac_hba_resp *err =
> +			&((struct aac_native_hba *)fibptr->hw_fib_va)->resp.err;
> +
> +		// BUG_ON(err->iu_type != HBA_IU_TYPE_RESP);

Please zap that C++ comment and see if you can tidy up the remaining code a
bit (e.g a new function for the else block, switch statement iterating over
err->serivce_response, etc...)

> +		if (err->service_response == HBA_RESP_SVCRES_TASK_COMPLETE) {
> +			scsicmd->result = err->status;
> +			/* set residual count */
> +			scsi_set_resid(scsicmd,
> +				le32_to_cpu(err->residual_count));
> +
> +			switch (err->status) {
> +			case SAM_STAT_GOOD:
> +				scsicmd->result |= DID_OK << 16 |
> +					COMMAND_COMPLETE << 8;
> +				break;
> +			case SAM_STAT_CHECK_CONDITION:
> +			{
> +				int len;
> +
> +				len = min_t(u8, err->sense_response_data_len,
> +					SCSI_SENSE_BUFFERSIZE);
> +				if (len)
> +					memcpy(scsicmd->sense_buffer,
> +						err->sense_response_buf, len);
> +				scsicmd->result |= DID_OK << 16 |
> +					COMMAND_COMPLETE << 8;
> +				break;
> +			}
> +			case SAM_STAT_BUSY:
> +				scsicmd->result |= DID_BUS_BUSY << 16 |
> +					COMMAND_COMPLETE << 8;
> +				break;
> +			case SAM_STAT_TASK_ABORTED:
> +				scsicmd->result |= DID_ABORT << 16 |
> +					ABORT << 8;
> +				break;
> +			case SAM_STAT_RESERVATION_CONFLICT:
> +			case SAM_STAT_TASK_SET_FULL:
> +			default:
> +				scsicmd->result |= DID_ERROR << 16 |
> +					COMMAND_COMPLETE << 8;
> +				break;
> +			}
> +		} else if (err->service_response == HBA_RESP_SVCRES_FAILURE) {
> +			switch (err->status) {
> +			case HBA_RESP_STAT_HBAMODE_DISABLED:
> +			{
> +				u32 bus, cid;
> +
> +				bus = aac_logical_to_phys(
> +						scmd_channel(scsicmd));
> +				cid = scmd_id(scsicmd);
> +				if (dev->hba_map[bus][cid].devtype ==
> +					AAC_DEVTYPE_NATIVE_RAW) {
> +					dev->hba_map[bus][cid].devtype =
> +						AAC_DEVTYPE_ARC_RAW;
> +					dev->hba_map[bus][cid].rmw_nexus =
> +						0xffffffff;
> +				}
> +				scsicmd->result = DID_NO_CONNECT << 16 |
> +					COMMAND_COMPLETE << 8;
> +				break;
> +			}
> +			case HBA_RESP_STAT_IO_ERROR:
> +			case HBA_RESP_STAT_NO_PATH_TO_DEVICE:
> +				scsicmd->result = DID_OK << 16 |
> +					COMMAND_COMPLETE << 8 | SAM_STAT_BUSY;
> +				break;
> +			case HBA_RESP_STAT_IO_ABORTED:
> +				scsicmd->result = DID_ABORT << 16 |
> +					ABORT << 8;
> +				break;
> +			case HBA_RESP_STAT_INVALID_DEVICE:
> +				scsicmd->result = DID_NO_CONNECT << 16 |
> +					COMMAND_COMPLETE << 8;
> +				break;
> +			case HBA_RESP_STAT_UNDERRUN:
> +				/* UNDERRUN is OK */
> +				scsicmd->result = DID_OK << 16 |
> +					COMMAND_COMPLETE << 8;
> +				break;
> +			case HBA_RESP_STAT_OVERRUN:
> +			default:
> +				scsicmd->result = DID_ERROR << 16 |
> +					COMMAND_COMPLETE << 8;
> +				break;
> +			}
> +		} else if (err->service_response ==
> +			HBA_RESP_SVCRES_TMF_REJECTED) {
> +			scsicmd->result =
> +				DID_ERROR << 16 | MESSAGE_REJECT << 8;
> +		} else if (err->service_response ==
> +			HBA_RESP_SVCRES_TMF_LUN_INVALID) {
> +			scsicmd->result =
> +				DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
> +		} else if ((err->service_response ==
> +			HBA_RESP_SVCRES_TMF_COMPLETE) ||
> +			(err->service_response ==
> +			HBA_RESP_SVCRES_TMF_SUCCEEDED)) {
> +			scsicmd->result =
> +				DID_OK << 16 | COMMAND_COMPLETE << 8;
> +		} else {
> +			scsicmd->result =
> +				DID_ERROR << 16 | COMMAND_COMPLETE << 8;
> +		}
> +	}
> +
> +	aac_fib_complete(fibptr);
> +
> +	if (fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF)
> +		scsicmd->SCp.sent_command = 1;
> +	else
> +		scsicmd->scsi_done(scsicmd);
> +}

[...]

> @@ -3408,6 +3649,54 @@ static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
>  	return -1;
>  }
>  
> +/**
> + *
> + * aac_send_hba_fib
> + * @scsicmd: the scsi command block
> + *
> + * This routine will form a FIB and fill in the aac_hba_cmd_req from the
> + * scsicmd passed in.
> + */
> +static int aac_send_hba_fib(struct scsi_cmnd *scsicmd)
> +{
> +	struct fib *cmd_fibcontext;
> +	struct aac_dev *dev;
> +	int status;
> +
> +	dev = (struct aac_dev *)scsicmd->device->host->hostdata;

dev = shost_priv(scsicmd->device->host);

[...]

> @@ -3660,6 +3949,73 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
>  	return 0;
>  }
>  
> +static long aac_build_sghba(struct scsi_cmnd *scsicmd,
> +			struct aac_hba_cmd_req *hbacmd,
> +			int sg_max,
> +			u64 sg_address)
> +{
> +	unsigned long byte_count = 0;
> +	int nseg;
> +
> +	nseg = scsi_dma_map(scsicmd);
> +	if (nseg < 0)
> +		return nseg;

if (nseg <= 0)
	return nseg;

> +	if (nseg) {
> +		struct scatterlist *sg;
> +		int i;
> +		u32 cur_size;
> +		struct aac_hba_sgl *sge;
> +
> +		if (nseg > HBA_MAX_SG_EMBEDDED)
> +			sge = &hbacmd->sge[2];
> +		else
> +			sge = &hbacmd->sge[0];
> +
> +		scsi_for_each_sg(scsicmd, sg, nseg, i) {
> +			int count = sg_dma_len(sg);
> +			u64 addr = sg_dma_address(sg);
> +
> +			WARN_ON(i >= sg_max);
> +			sge->addr_hi = cpu_to_le32((u32)(addr>>32));
> +			sge->addr_lo = cpu_to_le32((u32)(addr & 0xffffffff));
> +			cur_size = cpu_to_le32(count);
> +			sge->len = cur_size;
> +			sge->flags = 0;
> +			byte_count += count;
> +			sge++;
> +		}
> +
> +		sge--;
> +		/* hba wants the size to be exact */
> +		if (byte_count > scsi_bufflen(scsicmd)) {
> +			u32 temp = le32_to_cpu(sge->len) -
> +				(byte_count - scsi_bufflen(scsicmd));
> +			sge->len = cpu_to_le32(temp);
> +			byte_count = scsi_bufflen(scsicmd);
> +		}
> +
> +		if (nseg <= HBA_MAX_SG_EMBEDDED) {
> +			hbacmd->emb_data_desc_count = cpu_to_le32(nseg);
> +			sge->flags = cpu_to_le32(0x40000000);
> +		} else {
> +			/* not embedded */
> +			hbacmd->sge[0].flags = cpu_to_le32(0x80000000);
> +			hbacmd->emb_data_desc_count = (u8)cpu_to_le32(1);
> +			hbacmd->sge[0].addr_hi =
> +				(u32)cpu_to_le32(sg_address >> 32);
> +			hbacmd->sge[0].addr_lo =
> +				cpu_to_le32((u32)(sg_address & 0xffffffff));
> +		}
> +
> +		/* Check for command underflow */
> +		if (scsicmd->underflow && (byte_count < scsicmd->underflow)) {
> +			pr_warn("aacraid: cmd len %08lX cmd underflow %08X\n",
> +					byte_count, scsicmd->underflow);
> +		}
> +	}
> +	return byte_count;
> +}
> +
>  #ifdef AAC_DETAILED_STATUS_INFO
>  
>  struct aac_srb_status_info {
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
