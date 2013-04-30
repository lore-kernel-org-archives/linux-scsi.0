From: merez@codeaurora.org
Subject: Re: [PATCH V6 Resend2 2/2] [SCSI] ufs: Correct the expected data
 transfersize
Date: Tue, 30 Apr 2013 13:39:34 -0700
Message-ID: <2b37ba8d8fb30c725313c73c8d8db6cd.squirrel@www.codeaurora.org>
References: <1361882086-2548-1-git-send-email-vinholikatti@gmail.com>
    <1361882086-2548-2-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54986 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933362Ab3D3Uje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Apr 2013 16:39:34 -0400
In-Reply-To: <1361882086-2548-2-git-send-email-vinholikatti@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org, merez@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>

Hi James,

Can this patch be poushed to 3.9+ merge window?

Thnaks,
Maya
> This patch corrects the expected data transfer size of the
> command UPIU. The current implementation of cmd->transfersize
> is wrong as it probably equal to sector size. With this
> implementation the transfer size is updated correctly
>
> Reported-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> Tested-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 60fd40c..c32a478 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -478,7 +478,7 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb
> *lrbp)
>  		ucd_cmd_ptr->header.dword_2 = 0;
>
>  		ucd_cmd_ptr->exp_data_transfer_len =
> -			cpu_to_be32(lrbp->cmd->transfersize);
> +			cpu_to_be32(lrbp->cmd->sdb.length);
>
>  		memcpy(ucd_cmd_ptr->cdb,
>  		       lrbp->cmd->cmnd,
> --
> 1.7.5.4
>
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

