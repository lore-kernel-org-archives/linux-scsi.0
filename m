From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] [SCSI] ufs: calculate read/write xfer len from cdb
Date: Sun, 08 Apr 2012 09:44:07 +0100
Message-ID: <1333874647.2914.12.camel@dabdike>
References: <1333715241-32346-1-git-send-email-santoshsy@gmail.com>
	 <1333715241-32346-2-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36592 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab2DHIoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Apr 2012 04:44:12 -0400
In-Reply-To: <1333715241-32346-2-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, yoshitake.kobayashi@toshiba.co.jp, vinholikatti@gmail.com

On Fri, 2012-04-06 at 17:57 +0530, Santosh Y wrote:
> Currently the Expected data transfer length field in
> command UPIU is being updated with "transfersize" from
> the scsi_cmnd struct. But, if the read/write data
> transfer size exceeds the sector size, the "transfersize"
> will be truncated to the sector size. Thanks to KOBAYASHI
> Yoshitake for pointing it out.

I'm a bit confused by this changelog, but I think it's saying you're
using the cmd->transfersize field for the length of data to transfer?
In which case, that's wrong cmd->transfersize is the minimum transfer
size (usually a sector) ... badly named field, sorry.

Based on the calculation below, the actual length you're looking for is

scsi_cmnd->sdb->length

Which is the total size of the entire transfer in bytes.


> This patch ensures that the correct read/write data transfer
> size is calculated from the "transfer length" available in the
> CDB.
> 
> Reported-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
> Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Signed-off-by: Santosh Y <santoshsy@gmail.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |   37 ++++++++++++++++++++++++++++++++++++-
>  1 files changed, 36 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1878cd8..4f99ab4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -585,6 +585,41 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
>  }
>  
>  /**
> + * ufshcd_get_transfer_len - calculate data transfer size for read/write
> + *			     commands from the CDB
> + * @cmdp: pointer to SCSI command
> + */
> +static inline u32 ufshcd_get_transfer_len(struct scsi_cmnd *cmdp)
> +{
> +	u32 transfer_len;
> +
> +	switch (cmdp->cmnd[0]) {
> +	case READ_6:
> +	case WRITE_6:
> +		transfer_len = cmdp->device->sector_size *
> +			       cmdp->cmnd[4];

Just an efficiency not here, even though the code won't be written this
way, you don't want to multiply by sector_size ... it's always a power
of two, so you do shift or binary log tricks to avoid the expensive
multiply.

James

> +		break;
> +	case READ_10:
> +	case WRITE_10:
> +		transfer_len = cmdp->device->sector_size *
> +			       ((cmdp->cmnd[7] << 8) |
> +				cmdp->cmnd[8]);
> +		break;
> +	case READ_16:
> +	case WRITE_16:
> +		transfer_len = cmdp->device->sector_size *
> +			       ((cmdp->cmnd[10] << 24) |
> +				(cmdp->cmnd[11] << 16) |
> +				(cmdp->cmnd[12] << 8) |
> +				cmdp->cmnd[13]);
> +		break;
> +	default:
> +		transfer_len = cmdp->transfersize;
> +	}
> +	return transfer_len;
> +}
> +
> +/**
>   * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
>   * @lrb - pointer to local reference block
>   */
> @@ -640,7 +675,7 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
>  		ucd_cmd_ptr->header.dword_2 = 0;
>  
>  		ucd_cmd_ptr->exp_data_transfer_len =
> -			cpu_to_be32(lrbp->cmd->transfersize);
> +			cpu_to_be32(ufshcd_get_transfer_len(lrbp->cmd));
>  
>  		memcpy(ucd_cmd_ptr->cdb,
>  		       lrbp->cmd->cmnd,


