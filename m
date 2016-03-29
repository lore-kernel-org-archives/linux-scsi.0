From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [RESEND] [PATCH v11 2/6] added UFS 2.0 capabilities
Date: Tue, 29 Mar 2016 12:08:15 +0100
Message-ID: <56FA621F.7050104@synopsys.com>
References: <cover.1457111366.git.jpinto@synopsys.com>
 <fcc0aa6a294a02dcab590d56f7f43bcb2f9f18db.1457111366.git.jpinto@synopsys.com>
 <5B8DA87D05A7694D9FA63FD143655C1B541CD26F@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:42867 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbcC2LIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2016 07:08:22 -0400
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B541CD26F@hasmsx108.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>, Joao Pinto <Joao.Pinto@synopsys.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "CARLOS.PALMINHA@synopsys.com" <CARLOS.PALMINHA@synopsys.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "robh@kernel.org" <robh@kernel.org>

Hi Thomas,

On 3/29/2016 11:41 AM, Winkler, Tomas wrote:
> 
> Adding UFS 2.0 support to the UFS core driver.
> 
> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
> Changes v8->v11:
> - Nothing changed (just to keep up with patch set version).
> Changes v7->v8:
> - Added "jedec, ufs-2.0" to the ufschd-platform compatibility strings Changes v0->v7:
> - Nothing changed (just to keep up with patch set version).
> 
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  4 +--
>  drivers/scsi/ufs/ufshcd.c                          | 29 +++++++++++++++++++---
>  drivers/scsi/ufs/ufshci.h                          |  1 +
>  3 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> index 03c0e98..8d9a9d2 100644
> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -4,8 +4,8 @@ UFSHC nodes are defined to describe on-chip UFS host controllers.
>  Each UFS controller instance should have its own node.
>  
>  Required properties:
> -- compatible		: must contain "jedec,ufs-1.1", may also list one or more
> -					  of the following:
> +- compatible		: must contain "jedec,ufs-1.1" or "jedec,ufs-2.0", may
> +			  also list one or more of the following:
>  					  "qcom,msm8994-ufshc"
>  					  "qcom,msm8996-ufshc"
>  					  "qcom,ufshc"
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index 85cd256..2b5f2bf 100644
> 
> I think this should go in separate patch

In my opinion it only makes sense to add 2.0 to the device-tree binding if the
driver actually supports it, that was why I added to the same patch, but of
course it can be separated if more people agree with the approach.

> 
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1223,6 +1223,7 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  			ret = -EINVAL;
>  		}
>  		break;
> +	case UTP_CMD_TYPE_UFS_STORAGE:
>  	case UTP_CMD_TYPE_DEV_MANAGE:
>  		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
>  		if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY) @@ -1287,6 +1288,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  	struct ufshcd_lrb *lrbp;
>  	struct ufs_hba *hba;
>  	unsigned long flags;
> +	u32 upiu_flags;
>  	int tag;
>  	int err = 0;
>  
> @@ -1343,10 +1345,23 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  	lrbp->task_tag = tag;
>  	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
>  	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
> -	lrbp->command_type = UTP_CMD_TYPE_SCSI;
> +
> +	if (hba->ufs_version == UFSHCI_VERSION_20)
> +		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
> +	else
> +		lrbp->command_type = UTP_CMD_TYPE_SCSI;
> This translation can be pushed to prepare_req_desc_hdr and you end up with  ~oneliner fix 

I think your suggestion is good! We have to check the 2.0 version in 2 places
and with your approach we would only check it in prepare_req_desc_hdr() once.
I will do that update!

> 
>  
>  	/* form UPIU before issuing the command */
> -	ufshcd_compose_upiu(hba, lrbp);
> +	if (hba->ufs_version == UFSHCI_VERSION_20) {
> +		if (likely(lrbp->cmd)) {
> How this can be possible NULL, the code above will crash or I'm missing something ? 
> +			ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
> +					lrbp->cmd->sc_data_direction);
> +			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
> What is different her from the code in ufshcd_compose_upiu ?
> +		} else
> +			err = -EINVAL;
> +	} else
> +		ufshcd_compose_upiu(hba, lrbp);

If you check ufshcd_compose_upiu() you will see that it contains 2 scopes:
cmd_upiu and query_req_upiu. Before 2.0 this single function approach that had
both scopes worked well, but now with 2.0 we must use the same command_type
(UTP_CMD_TYPE_UFS_STORAGE) which causes incompatibility. This was why I put the
same code from cmd_upiu in the outside.

Of course we can break ufshcd_compose_upiu() in 2: ufshcd_compose_cmd_upiu() and
ufshcd_compose_query_upiu(). What do you think?

> +
>  	err = ufshcd_map_sg(lrbp);
>  	if (err) {
>  		lrbp->cmd = NULL;
> @@ -1371,7 +1386,12 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
>  	lrbp->sense_buffer = NULL;
>  	lrbp->task_tag = tag;
>  	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
> -	lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
> +
> +	if (hba->ufs_version == UFSHCI_VERSION_20)
> +		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
> +	else
> +		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
> +
> This translation can be pushed to prepare_req_desc_hdr and you end up with ~ oneliner fix
> 
>  	lrbp->intr_cmd = true; /* No interrupt aggregation */
>  	hba->dev_cmd.type = cmd_type;
>  
> @@ -3187,7 +3207,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>  			/* Do not touch lrbp after scsi done */
>  			cmd->scsi_done(cmd);
>  			__ufshcd_release(hba);
> -		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
> +		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
> +			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
>  			if (hba->dev_cmd.complete)
>  				complete(hba->dev_cmd.complete);
>  		}
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h index 0ae0967..8dba0e7 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -273,6 +273,7 @@ enum {
>  	UTP_CMD_TYPE_SCSI		= 0x0,
>  	UTP_CMD_TYPE_UFS		= 0x1,
>  	UTP_CMD_TYPE_DEV_MANAGE		= 0x2,
> +	UTP_CMD_TYPE_UFS_STORAGE	= 0x11,
>  };
>  
>  enum {
> --
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Thanks,
Joao


