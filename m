From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 1/7] scsi: ufs: amend the ocs handling with fatal error
Date: Mon, 29 Jul 2013 23:33:09 +0530
Message-ID: <CALMYJDtbfxMAhXCL24jakA4y4m=uHbg9NsT=2FP+BSfwFB9fZA@mail.gmail.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <1374280885-11526-2-git-send-email-mita@fixstars.com> <001c01ce8a06$5bcbc1c0$13634540$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:53033 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab3G2SDb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 14:03:31 -0400
Received: by mail-bk0-f49.google.com with SMTP id r7so1704547bkg.36
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 11:03:30 -0700 (PDT)
In-Reply-To: <001c01ce8a06$5bcbc1c0$13634540$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Fri, Jul 26, 2013 at 7:15 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> Fatal error in OCS(overall command status) field indicates
> error conditions which is not covered by UFSHCI.
> It means that host cannot define the result of command status
> and therefore host may need to check transfer response UPIU's
> response and status field.
> It was actually found that 'CHECK CONDITION' is stored in status
> field of UPIU where OCS is 'FATAL ERROR'.

It seems specific to the host controller you are checking with.
It doesn't seem right to interpret the scsi status -- even though the
handling isn't mentioned in the spec for FATAL ERROR.

>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b743bd6..4cf3a2d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1199,7 +1199,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>
>         switch (ocs) {
>         case OCS_SUCCESS:
> -
> +       case OCS_FATAL_ERROR:
>                 /* check if the returned transfer response is valid */
>                 result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
>                 if (result) {
> @@ -1229,7 +1229,6 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>         case OCS_MISMATCH_DATA_BUF_SIZE:
>         case OCS_MISMATCH_RESP_UPIU_SIZE:
>         case OCS_PEER_COMM_FAILURE:
> -       case OCS_FATAL_ERROR:
>         default:
>                 result |= DID_ERROR << 16;
>                 dev_err(hba->dev,
> --
> 1.7.0.4
>
>



-- 
~Santosh
