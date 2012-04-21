From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] [SCSI] ufs: Process SCSI command for UFS device
Date: Sat, 21 Apr 2012 14:59:09 +0400
Message-ID: <1335005949.3081.6.camel@dabdike.lan>
References: <1334999359-3181-1-git-send-email-santoshsy@gmail.com>
	 <1334999359-3181-3-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48297 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628Ab2DUK7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Apr 2012 06:59:14 -0400
In-Reply-To: <1334999359-3181-3-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com

On Sat, 2012-04-21 at 14:39 +0530, Santosh Y wrote:
> UFS Spec specifies that the SCSI CDB fields, that are not
> supported by UFS should be set to zero. It also mentions
> that some of the CDB fields should be set to default
> values before issuing the command to a UFS device.
> Ex: Mode Select - Page Format bit should be set to 1.
> 
> If the fields are not set to values mentioned in UFS spec,
> strict CDB checking UFS device may complete the commands
> with a check condition.

Altering CDB field values in the driver is a bad idea.  If you tamper
with commands in the driver unexpected things will be returned to
userspace.  The general principle is that the mid layer tries to be as
correct and conservative as possible, but we don't forbid users from
sending out of spec commands because sometimes that's required.

Are you actually trying to fix a bug, or is this just theoretical?  If
the former, the way to fix it is to get the mid layer to be more
conservative about what it does (or possibly add a quirk flag).  If the
latter, then I think you need to wait until you see a problem first
(unless you can infer a problem from what the mid-layer will do).

James


> Signed-off-by: Santosh Y <santoshsy@gmail.com>
> Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |  100 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 100 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 662d00f..ef416b1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -583,6 +583,104 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
>  }
>  
>  /**
> + * ufshcd_process_scsi_cdb - Process SCSI command for UFS device
> + * @cdb: Pointer to SCSI cdb
> + * @cdb_len: SCSI cdb length
> + */
> +static inline void
> +ufshcd_process_scsi_cdb(unsigned char *cdb, unsigned short cdb_len)
> +{
> +	switch (cdb[0]) {
> +	case READ_10:
> +	case READ_16:
> +	case WRITE_10:
> +	case WRITE_16:
> +
> +		/* set RDPROTECT/WRPROTECT bits to 0 */
> +		cdb[1] &= 0x1F;
> +		break;
> +	case START_STOP:
> +
> +		/* set Power Condition Modifier to 0 */
> +		cdb[3] &= 0xF0;
> +		break;
> +	case MODE_SELECT_10:
> +
> +		/* set Page Format(PF) bit to 1 */
> +		cdb[1] |= 0x10;
> +		break;
> +	case MODE_SENSE_10:
> +
> +		/*
> +		 * set Long LBA Accepted(LLBAA) bit to 0 and
> +		 * Disable Block Descriptors(DBD) bit to 1
> +		 */
> +		cdb[1] = 0x08;
> +		break;
> +
> +	case READ_CAPACITY:
> +
> +		/* set Partial Medium Indicator(PMI) bit to 0 */
> +		cdb[8] &= ~1;
> +
> +		/* set Logical Block Address(LBA) to 0 */
> +		cdb[2] = 0;
> +		cdb[3] = 0;
> +		break;
> +
> +	case SERVICE_ACTION_IN:
> +		if ((cdb[1] & 0x1F) == SAI_READ_CAPACITY_16) {
> +
> +			/* set PMI bit to 0 */
> +			cdb[14] &= ~1;
> +
> +			/* set Logical Block Address(LBA) to 0 */
> +			cdb[2] = 0;
> +			cdb[3] = 0;
> +			cdb[4] = 0;
> +			cdb[5] = 0;
> +			cdb[6] = 0;
> +			cdb[7] = 0;
> +			cdb[8] = 0;
> +			cdb[9] = 0;
> +		}
> +		break;
> +	case VERIFY:
> +
> +		/* set VRPROTECT, Disable Page Out(DPO), BYTCHK bits to 0 */
> +		cdb[1] &= 0x0C;
> +
> +		/* set Group Number to 0 */
> +		cdb[6] &= 0xF0;
> +		break;
> +
> +	case REQUEST_SENSE:
> +
> +		/* set Descriptor Format(DESC) bit to 0 */
> +		cdb[1] = 0;
> +
> +		/* device server will transfer upto 18 bytes of data */
> +		if (cdb[4] > MAX_SENSE_SIZE)
> +			cdb[4] = MAX_SENSE_SIZE;
> +		break;
> +
> +	case SECURITY_PROTOCOL_IN:
> +	case SECURITY_PROTOCOL_OUT:
> +
> +		/*
> +		 * set INC_512 to 0, to specify Allocation/Transfer Length
> +		 * represent the number of bytes to be transferred
> +		 */
> +		cdb[4] &= 0x7F;
> +		break;
> +	}
> +
> +	/* set control field to 0 */
> +	if (cdb_len <= MAX_CDB_SIZE)
> +		cdb[cdb_len - 1] = 0;
> +}
> +
> +/**
>   * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
>   * @lrb - pointer to local reference block
>   */
> @@ -645,6 +743,8 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
>  		       (min_t(unsigned short,
>  			      lrbp->cmd->cmd_len,
>  			      MAX_CDB_SIZE)));
> +
> +		ufshcd_process_scsi_cdb(ucd_cmd_ptr->cdb, lrbp->cmd->cmd_len);
>  		break;
>  	case UTP_CMD_TYPE_DEV_MANAGE:
>  		/* For query function implementation */


