From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH] scsi: ufs: fix Command Type issue according to UFS 2.0 spec
Date: Mon, 18 Aug 2014 23:36:33 +0530
Message-ID: <CALMYJDvENUYre-ddYMQXoudVzQ3T8BFT9AiA8JviPL=tvGB66w@mail.gmail.com>
References: <20140801080058.GA13757@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:62391 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaHRSHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Aug 2014 14:07:04 -0400
Received: by mail-ig0-f182.google.com with SMTP id c1so8430534igq.9
        for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2014 11:07:03 -0700 (PDT)
In-Reply-To: <20140801080058.GA13757@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, vinayak holikatti <vinholikatti@gmail.com>

On Fri, Aug 1, 2014 at 1:30 PM, Chuanxiao Dong <chuanxiao.dong@intel.com> wrote:
> UFS 2.0 spec defines that the command type in transfer descriptor
> is always 0x1 instead of different values as shown in UFSHC1.0/1.1.
>
> This patch will distingwish v1.0/v1.1 UFSHC and later UFSHC when
> setting CT
>
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |   27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ba27215..8635d5d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -706,16 +706,19 @@ static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
>  /**
>   * ufshcd_prepare_req_desc_hdr() - Fills the requests header
>   * descriptor according to request
> + * @hba: per adapter instance
>   * @lrbp: pointer to local reference block
>   * @upiu_flags: flags required in the header
>   * @cmd_dir: requests data direction
>   */
> -static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
> -               u32 *upiu_flags, enum dma_data_direction cmd_dir)
> +static void ufshcd_prepare_req_desc_hdr(struct ufs_hba *hba,
> +               struct ufshcd_lrb *lrbp, u32 *upiu_flags,
> +               enum dma_data_direction cmd_dir)
>  {
>         struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
>         u32 data_direction;
>         u32 dword_0;
> +       u8 cmd_type;
>
>         if (cmd_dir == DMA_FROM_DEVICE) {
>                 data_direction = UTP_DEVICE_TO_HOST;
> @@ -728,8 +731,20 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
>                 *upiu_flags = UPIU_CMD_FLAGS_NONE;
>         }
>
> -       dword_0 = data_direction | (lrbp->command_type
> -                               << UPIU_COMMAND_TYPE_OFFSET);
> +       /*
> +        * Per UFSHCI spec v1.0/v1.1, Command Type in UTP transfer
> +        * request descriptor is not the same as v2.0 spec.
> +        * In v2.0 spec, Command Type is always 1, the other values
> +        * are reserved
> +        */
> +       if (hba->ufs_version == UFSHCI_VERSION_10 ||
> +                       hba->ufs_version == UFSHCI_VERSION_11)
> +               cmd_type = lrbp->command_type;
> +       else
> +               cmd_type = UTP_CMD_TYPE_UFS;
> +
> +       dword_0 = data_direction | (cmd_type << UPIU_COMMAND_TYPE_OFFSET);
> +
>         if (lrbp->intr_cmd)
>                 dword_0 |= UTP_REQ_DESC_INT_CMD;
>
> @@ -834,7 +849,7 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>         switch (lrbp->command_type) {
>         case UTP_CMD_TYPE_SCSI:
>                 if (likely(lrbp->cmd)) {
> -                       ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
> +                       ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags,
>                                         lrbp->cmd->sc_data_direction);
>                         ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
>                 } else {
> @@ -842,7 +857,7 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>                 }
>                 break;
>         case UTP_CMD_TYPE_DEV_MANAGE:
> -               ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
> +               ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE);
>                 if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
>                         ufshcd_prepare_utp_query_req_upiu(
>                                         hba, lrbp, upiu_flags);
> --
> 1.7.10.4
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
