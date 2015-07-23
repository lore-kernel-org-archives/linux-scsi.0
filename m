From: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>
Subject: RE: [PATCH V5 05/11] [SCSI] aacraid: Tune response path if
 IsFastPath bit set
Date: Thu, 23 Jul 2015 18:41:20 +0000
Message-ID: <E34C6B6293F0214497D0C55B92526C05EAFF86B3@BBYEXM02.pmc-sierra.internal>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1437583757-5449-6-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <55B0FCB2.7040501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:48582 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbbGWSlV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jul 2015 14:41:21 -0400
In-Reply-To: <55B0FCB2.7040501@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

Hi Tomas,

We will make the changes and submit.

Thanks,

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Thursday, July 23, 2015 7:40 AM
To: Rajinikanth Pandurangan; jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Mahesh Rajashekhara; Achim Leubner; Murthy Bhat
Subject: Re: [PATCH V5 05/11] [SCSI] aacraid: Tune response path if IsFastPath bit set

On 22.7.2015 18:49, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
>         If 'IsFastPath' bit is set, then response path assumes no error
>         and skips error check.
> 
> Changes from V2:
> None
> 
> Reviewed By:
>  Tomas Henzl <thenzl@redhat.com>,
The same here - I haven't noticed this before, but in V2 I haven't reviewed this patch, I have asked you for a change which hasn't been followed.
Please remove my 'Reviewed by' tag.
-tm

>  Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>,  Johannes 
> Thumshirn <jthumshirn@suse.de>
> 
> Signed-off-by: Rajinikanth Pandurangan 
> <rajinikanth.pandurangan@pmcs.com>
> ---
>  drivers/scsi/aacraid/aachba.c | 259 
> ++++++++++++++++++++++--------------------
>  1 file changed, 137 insertions(+), 122 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c 
> b/drivers/scsi/aacraid/aachba.c index fe59b00..864e9f6 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -2977,11 +2977,16 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
>  		return;
>  
>  	BUG_ON(fibptr == NULL);
> -
>  	dev = fibptr->dev;
>  
> -	srbreply = (struct aac_srb_reply *) fib_data(fibptr);
> +	scsi_dma_unmap(scsicmd);
>  
> +	/* expose physical device if expose_physicald flag is on */
> +	if (scsicmd->cmnd[0] == INQUIRY && !(scsicmd->cmnd[1] & 0x01)
> +	  && expose_physicals > 0)
> +		aac_expose_phy_device(scsicmd);
> +
> +	srbreply = (struct aac_srb_reply *) fib_data(fibptr);
>  	scsicmd->sense_buffer[0] = '\0';  /* Initialize sense valid flag to 
> false */
>  
>  	if (fibptr->flags & FIB_CONTEXT_FLAG_FASTRESP) { @@ -2994,147 
> +2999,157 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
>  		 */
>  		scsi_set_resid(scsicmd, scsi_bufflen(scsicmd)
>  				   - le32_to_cpu(srbreply->data_xfer_length));
> -	}
> -
> -	scsi_dma_unmap(scsicmd);
> -
> -	/* expose physical device if expose_physicald flag is on */
> -	if (scsicmd->cmnd[0] == INQUIRY && !(scsicmd->cmnd[1] & 0x01)
> -	  && expose_physicals > 0)
> -		aac_expose_phy_device(scsicmd);
> +		/*
> +		 * First check the fib status
> +		 */
>  
> -	/*
> -	 * First check the fib status
> -	 */
> +		if (le32_to_cpu(srbreply->status) != ST_OK) {
> +			int len;
>  
> -	if (le32_to_cpu(srbreply->status) != ST_OK){
> -		int len;
> -		printk(KERN_WARNING "aac_srb_callback: srb failed, status = %d\n", le32_to_cpu(srbreply->status));
> -		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
> -			    SCSI_SENSE_BUFFERSIZE);
> -		scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
> -		memcpy(scsicmd->sense_buffer, srbreply->sense_data, len);
> -	}
> +			printk(KERN_WARNING "aac_srb_callback: srb failed, status = %d\n", le32_to_cpu(srbreply->status));
> +			len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
> +				    SCSI_SENSE_BUFFERSIZE);
> +			scsicmd->result = DID_ERROR << 16
> +						| COMMAND_COMPLETE << 8
> +						| SAM_STAT_CHECK_CONDITION;
> +			memcpy(scsicmd->sense_buffer,
> +					srbreply->sense_data, len);
> +		}
>  
> -	/*
> -	 * Next check the srb status
> -	 */
> -	switch( (le32_to_cpu(srbreply->srb_status))&0x3f){
> -	case SRB_STATUS_ERROR_RECOVERY:
> -	case SRB_STATUS_PENDING:
> -	case SRB_STATUS_SUCCESS:
> -		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
> -		break;
> -	case SRB_STATUS_DATA_OVERRUN:
> -		switch(scsicmd->cmnd[0]){
> -		case  READ_6:
> -		case  WRITE_6:
> -		case  READ_10:
> -		case  WRITE_10:
> -		case  READ_12:
> -		case  WRITE_12:
> -		case  READ_16:
> -		case  WRITE_16:
> -			if (le32_to_cpu(srbreply->data_xfer_length) < scsicmd->underflow) {
> -				printk(KERN_WARNING"aacraid: SCSI CMD underflow\n");
> -			} else {
> -				printk(KERN_WARNING"aacraid: SCSI CMD Data Overrun\n");
> +		/*
> +		 * Next check the srb status
> +		 */
> +		switch ((le32_to_cpu(srbreply->srb_status))&0x3f) {
> +		case SRB_STATUS_ERROR_RECOVERY:
> +		case SRB_STATUS_PENDING:
> +		case SRB_STATUS_SUCCESS:
> +			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
> +			break;
> +		case SRB_STATUS_DATA_OVERRUN:
> +			switch (scsicmd->cmnd[0]) {
> +			case  READ_6:
> +			case  WRITE_6:
> +			case  READ_10:
> +			case  WRITE_10:
> +			case  READ_12:
> +			case  WRITE_12:
> +			case  READ_16:
> +			case  WRITE_16:
> +				if (le32_to_cpu(srbreply->data_xfer_length)
> +							< scsicmd->underflow)
> +					printk(KERN_WARNING"aacraid: SCSI CMD underflow\n");
> +				else
> +					printk(KERN_WARNING"aacraid: SCSI CMD Data Overrun\n");
> +				scsicmd->result = DID_ERROR << 16
> +							| COMMAND_COMPLETE << 8;
> +				break;
> +			case INQUIRY: {
> +				scsicmd->result = DID_OK << 16
> +							| COMMAND_COMPLETE << 8;
> +				break;
> +			}
> +			default:
> +				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
> +				break;
>  			}
> -			scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
>  			break;
> -		case INQUIRY: {
> -			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
> +		case SRB_STATUS_ABORTED:
> +			scsicmd->result = DID_ABORT << 16 | ABORT << 8;
>  			break;
> -		}
> -		default:
> -			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
> +		case SRB_STATUS_ABORT_FAILED:
> +			/*
> +			 * Not sure about this one - but assuming the
> +			 * hba was trying to abort for some reason
> +			 */
> +			scsicmd->result = DID_ERROR << 16 | ABORT << 8;
> +			break;
> +		case SRB_STATUS_PARITY_ERROR:
> +			scsicmd->result = DID_PARITY << 16
> +						| MSG_PARITY_ERROR << 8;
> +			break;
> +		case SRB_STATUS_NO_DEVICE:
> +		case SRB_STATUS_INVALID_PATH_ID:
> +		case SRB_STATUS_INVALID_TARGET_ID:
> +		case SRB_STATUS_INVALID_LUN:
> +		case SRB_STATUS_SELECTION_TIMEOUT:
> +			scsicmd->result = DID_NO_CONNECT << 16
> +						| COMMAND_COMPLETE << 8;
>  			break;
> -		}
> -		break;
> -	case SRB_STATUS_ABORTED:
> -		scsicmd->result = DID_ABORT << 16 | ABORT << 8;
> -		break;
> -	case SRB_STATUS_ABORT_FAILED:
> -		// Not sure about this one - but assuming the hba was trying to abort for some reason
> -		scsicmd->result = DID_ERROR << 16 | ABORT << 8;
> -		break;
> -	case SRB_STATUS_PARITY_ERROR:
> -		scsicmd->result = DID_PARITY << 16 | MSG_PARITY_ERROR << 8;
> -		break;
> -	case SRB_STATUS_NO_DEVICE:
> -	case SRB_STATUS_INVALID_PATH_ID:
> -	case SRB_STATUS_INVALID_TARGET_ID:
> -	case SRB_STATUS_INVALID_LUN:
> -	case SRB_STATUS_SELECTION_TIMEOUT:
> -		scsicmd->result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
> -		break;
>  
> -	case SRB_STATUS_COMMAND_TIMEOUT:
> -	case SRB_STATUS_TIMEOUT:
> -		scsicmd->result = DID_TIME_OUT << 16 | COMMAND_COMPLETE << 8;
> -		break;
> +		case SRB_STATUS_COMMAND_TIMEOUT:
> +		case SRB_STATUS_TIMEOUT:
> +			scsicmd->result = DID_TIME_OUT << 16
> +						| COMMAND_COMPLETE << 8;
> +			break;
>  
> -	case SRB_STATUS_BUSY:
> -		scsicmd->result = DID_BUS_BUSY << 16 | COMMAND_COMPLETE << 8;
> -		break;
> +		case SRB_STATUS_BUSY:
> +			scsicmd->result = DID_BUS_BUSY << 16
> +						| COMMAND_COMPLETE << 8;
> +			break;
>  
> -	case SRB_STATUS_BUS_RESET:
> -		scsicmd->result = DID_RESET << 16 | COMMAND_COMPLETE << 8;
> -		break;
> +		case SRB_STATUS_BUS_RESET:
> +			scsicmd->result = DID_RESET << 16
> +						| COMMAND_COMPLETE << 8;
> +			break;
>  
> -	case SRB_STATUS_MESSAGE_REJECTED:
> -		scsicmd->result = DID_ERROR << 16 | MESSAGE_REJECT << 8;
> -		break;
> -	case SRB_STATUS_REQUEST_FLUSHED:
> -	case SRB_STATUS_ERROR:
> -	case SRB_STATUS_INVALID_REQUEST:
> -	case SRB_STATUS_REQUEST_SENSE_FAILED:
> -	case SRB_STATUS_NO_HBA:
> -	case SRB_STATUS_UNEXPECTED_BUS_FREE:
> -	case SRB_STATUS_PHASE_SEQUENCE_FAILURE:
> -	case SRB_STATUS_BAD_SRB_BLOCK_LENGTH:
> -	case SRB_STATUS_DELAYED_RETRY:
> -	case SRB_STATUS_BAD_FUNCTION:
> -	case SRB_STATUS_NOT_STARTED:
> -	case SRB_STATUS_NOT_IN_USE:
> -	case SRB_STATUS_FORCE_ABORT:
> -	case SRB_STATUS_DOMAIN_VALIDATION_FAIL:
> -	default:
> +		case SRB_STATUS_MESSAGE_REJECTED:
> +			scsicmd->result = DID_ERROR << 16
> +						| MESSAGE_REJECT << 8;
> +			break;
> +		case SRB_STATUS_REQUEST_FLUSHED:
> +		case SRB_STATUS_ERROR:
> +		case SRB_STATUS_INVALID_REQUEST:
> +		case SRB_STATUS_REQUEST_SENSE_FAILED:
> +		case SRB_STATUS_NO_HBA:
> +		case SRB_STATUS_UNEXPECTED_BUS_FREE:
> +		case SRB_STATUS_PHASE_SEQUENCE_FAILURE:
> +		case SRB_STATUS_BAD_SRB_BLOCK_LENGTH:
> +		case SRB_STATUS_DELAYED_RETRY:
> +		case SRB_STATUS_BAD_FUNCTION:
> +		case SRB_STATUS_NOT_STARTED:
> +		case SRB_STATUS_NOT_IN_USE:
> +		case SRB_STATUS_FORCE_ABORT:
> +		case SRB_STATUS_DOMAIN_VALIDATION_FAIL:
> +		default:
>  #ifdef AAC_DETAILED_STATUS_INFO
> -		printk("aacraid: SRB ERROR(%u) %s scsi cmd 0x%x - scsi status 0x%x\n",
> -			le32_to_cpu(srbreply->srb_status) & 0x3F,
> -			aac_get_status_string(
> -				le32_to_cpu(srbreply->srb_status) & 0x3F),
> -			scsicmd->cmnd[0],
> -			le32_to_cpu(srbreply->scsi_status));
> +			printk(KERN_INFO "aacraid: SRB ERROR(%u) %s scsi cmd 0x%x - scsi status 0x%x\n",
> +				le32_to_cpu(srbreply->srb_status) & 0x3F,
> +				aac_get_status_string(
> +					le32_to_cpu(srbreply->srb_status) & 0x3F),
> +				scsicmd->cmnd[0],
> +				le32_to_cpu(srbreply->scsi_status));
>  #endif
> -		if ((scsicmd->cmnd[0] == ATA_12)
> -		  || (scsicmd->cmnd[0] == ATA_16)) {
> -			if (scsicmd->cmnd[2] & (0x01 << 5)) {
> -				scsicmd->result = DID_OK << 16
> -						| COMMAND_COMPLETE << 8;
> +			if ((scsicmd->cmnd[0] == ATA_12)
> +				|| (scsicmd->cmnd[0] == ATA_16)) {
> +					if (scsicmd->cmnd[2] & (0x01 << 5)) {
> +						scsicmd->result = DID_OK << 16
> +							| COMMAND_COMPLETE << 8;
>  				break;
> +				} else {
> +					scsicmd->result = DID_ERROR << 16
> +						| COMMAND_COMPLETE << 8;
> +					break;
> +				}
>  			} else {
>  				scsicmd->result = DID_ERROR << 16
> -						| COMMAND_COMPLETE << 8;
> +					| COMMAND_COMPLETE << 8;
>  				break;
>  			}
> -		} else {
> -			scsicmd->result = DID_ERROR << 16
> -					| COMMAND_COMPLETE << 8;
> -			break;
>  		}
> -	}
> -	if (le32_to_cpu(srbreply->scsi_status) == SAM_STAT_CHECK_CONDITION) {
> -		int len;
> -		scsicmd->result |= SAM_STAT_CHECK_CONDITION;
> -		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
> -			    SCSI_SENSE_BUFFERSIZE);
> +		if (le32_to_cpu(srbreply->scsi_status)
> +				== SAM_STAT_CHECK_CONDITION) {
> +			int len;
> +
> +			scsicmd->result |= SAM_STAT_CHECK_CONDITION;
> +			len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
> +				    SCSI_SENSE_BUFFERSIZE);
>  #ifdef AAC_DETAILED_STATUS_INFO
> -		printk(KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n",
> -					le32_to_cpu(srbreply->status), len);
> +			printk(KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n",
> +						le32_to_cpu(srbreply->status), len);
>  #endif
> -		memcpy(scsicmd->sense_buffer, srbreply->sense_data, len);
> +			memcpy(scsicmd->sense_buffer,
> +					srbreply->sense_data, len);
> +		}
>  	}
>  	/*
>  	 * OR in the scsi status (already shifted up a bit)
> 

