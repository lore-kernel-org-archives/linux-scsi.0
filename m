From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH -next] ufs: fix source address of the read descriptor
Date: Thu, 29 Aug 2013 23:11:32 +0530
Message-ID: <CALMYJDsHEf2+ebZog__2Z3Cht4aoqpdtdqrwbCao7OW2EWL9_Q@mail.gmail.com>
References: <1377702030-12901-1-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:62503 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab3H2RmG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2013 13:42:06 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so302170bkb.41
        for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 10:42:02 -0700 (PDT)
In-Reply-To: <1377702030-12901-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <mita@fixstars.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, James Bottomley <JBottomley@parallels.com>

On Wed, Aug 28, 2013 at 8:30 PM, Akinobu Mita <mita@fixstars.com> wrote:
> When the query request with read descriptor opcode is completed, the
> descriptor is copied from response UPIU to the buffer that the caller
> has specified.  Unfortunately the source address of the descriptor is
> broken due to the unnecessary address-of operator.
>
> Signed-off-by: Akinobu Mita <mita@fixstars.com>
> Cc: Dolev Raviv <draviv@codeaurora.org>
> Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: Santosh Y <santoshsy@gmail.com>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a0f5ac2..7a319c6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -454,8 +454,7 @@ void ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>
>         /* Get the descriptor */
>         if (lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
> -               u8 *descp = (u8 *)&lrbp->ucd_rsp_ptr +
> -                               GENERAL_UPIU_REQUEST_SIZE;
> +               u8 *descp = (u8 *)lrbp->ucd_rsp_ptr + GENERAL_UPIU_REQUEST_SIZE;
>                 u16 len;
>
>                 /* data segment length */
> --
> 1.8.3.1
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
