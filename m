From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH V4] scsi: ufs: add support for query requests
Date: Thu, 2 May 2013 13:54:30 +0530
Message-ID: <CALMYJDv2wWuLHucARDMMoAE_zqDce6BDUMt6U4hAPT3=DiLMYA@mail.gmail.com>
References: <1367422015-23651-1-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1367422015-23651-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> +
> +/**
> + * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
> + * @hba - UFS hba
> + * @lrb - pointer to local reference block
> + */
> +static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> +{
> +       u32 upiu_flags;
> +       int ret = 0;
> +
> +       switch (lrbp->command_type) {
> +       case UTP_CMD_TYPE_SCSI:
>         case UTP_CMD_TYPE_DEV_MANAGE:
> -               /* For query function implementation */
> +               ufshcd_prepare_req_desc(lrbp, &upiu_flags);
> +               if (lrbp->cmd && lrbp->command_type == UTP_CMD_TYPE_SCSI)

Sorry, probably missed it in the initial review. Here no need to check
for 'lrbp->cmd'.

> +                       ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
> +               else if (lrbp->cmd)

no need to check here also

> +                       ufshcd_prepare_utp_query_req_upiu(hba, lrbp,
> +                                                               upiu_flags);
> +               else {
> +                       dev_err(hba->dev, "%s: Invalid UPIU request\n",
> +                               __func__);
> +                       ret = -EINVAL;
> +               }

remove this else part, this condition will never be true.

>                 break;
>         case UTP_CMD_TYPE_UFS:
>                 /* For UFS native command implementation */
> +               dev_err(hba->dev, "%s: UFS native command are not supported\n",
> +                       __func__);
> +               ret = -ENOTSUPP;
> +               break;
> +       default:
> +               ret = -ENOTSUPP;
> +               dev_err(hba->dev, "%s: unknown command type: 0x%x\n",
> +                               __func__, lrbp->command_type);
>                 break;
>         } /* end of switch */
> +
> +       return ret;
>  }
>


-- 
~Santosh
