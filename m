Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332C5C33CB1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 14:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03A802072B
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 14:39:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pmjnazB7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgASOjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 09:39:13 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:42283 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASOjN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 09:39:13 -0500
Received: by mail-ua1-f68.google.com with SMTP id u17so10614112uap.9
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2020 06:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j8keUpOCp3VWJ4TU0kbq3GzP9kgMSYkjFPyvwNMsufM=;
        b=pmjnazB7VaFTaGbsc65Tj7VBBA3qJfGyoAYN1qyO+z4xVzynINVD9D9E7lCWM6VYIV
         MnQYgDPK3xo3BxWnkzcvv4+jCZ2bD5zciMRx6glyofHhwHVooRkojE+8fJ8ZB1kBCC2B
         8bvCqBYQL8gMXpjQgVoLb+yRIfcRgoRdmyg4YwXwubfHliDEwYxTeytky6CYVlaj+Jor
         wDCMkSu9zgxYJxgtLUROxsDldtbC63K6CrPZMVgn0LmsS1XmaX4lX5qnsZxELfZKiDRv
         C2lTPLXtKGTkBraHI++I+uoag0YZbhg2kAjP8fZ13SUctTvFjj9fpoFlgX2B4dzkiHWb
         xEZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j8keUpOCp3VWJ4TU0kbq3GzP9kgMSYkjFPyvwNMsufM=;
        b=HycT7Fy/AwErbrhRvOVR3hBM+f0hH/bUV/ShHkrnu7hdReFWOM1UA/ZiQIhRySL3//
         JSXaD6f79F6cYFGGtBY8G8J2EG8MtQ13FlmfL0taSN2JGjM3RuXrRrPkYMemvrrXHHcW
         gFsoDc+g0rPYV5TJAMHLeNyquw7jZ/mcfaZgqyd7ej7XvWkcz/XVXRCxGvWVX9KcHo8c
         2pfPlWHqf21o1t6wVnGcPenZ91Q3aNdUlv6xNxH+c58rqrr4n8VgdYKVIFKGN2GDQGke
         AJT5GhvMFg/JWkgb5l+KXJPrF/JNODlJACoi/FDlNG5SPzI/Fvl0p9DwhB+iBSHo72Cr
         BVIw==
X-Gm-Message-State: APjAAAVvfqBkNiYQnrrwqIAqBnS5+bl885K+miMOsjCCrF162NCOKurp
        3ifdvdcw8oVqOkgZCZRNJjBtupxVtpAcB1By7Tc=
X-Google-Smtp-Source: APXvYqxvT7hLLTJztdehlDyNPdGu6Z5QZfCuwd7LzdY2QgezWsDYtyDMGxQeurPhaVW+hE7bTzvQTX6ogyddl8GUmkg=
X-Received: by 2002:ab0:30c2:: with SMTP id c2mr29569059uam.8.1579444752075;
 Sun, 19 Jan 2020 06:39:12 -0800 (PST)
MIME-Version: 1.0
References: <20200107192531.73802-1-bvanassche@acm.org> <20200107192531.73802-3-bvanassche@acm.org>
In-Reply-To: <20200107192531.73802-3-bvanassche@acm.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 20:08:35 +0530
Message-ID: <CAGOxZ531tcv7aVzTWXH0k0=vKy9LbL=h7sSXnwXem+kr5_MbUw@mail.gmail.com>
Subject: Re: [PATCH 2/4] ufs: Introduce ufshcd_init_lrb()
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

On Wed, Jan 8, 2020 at 12:57 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> This patch does not change any functionality but makes the next patch in
> this series easier to read.
>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1b97f2dc0b63..6f55d72e7fdd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2364,6 +2364,27 @@ static inline u16 ufshcd_upiu_wlun_to_scsi_wlun(u8 upiu_wlun_id)
>         return (upiu_wlun_id & ~UFS_UPIU_WLUN_ID) | SCSI_W_LUN_BASE;
>  }
>
> +static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
> +{
> +       struct utp_transfer_cmd_desc *cmd_descp = hba->ucdl_base_addr;
> +       struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
> +       dma_addr_t cmd_desc_element_addr = hba->ucdl_dma_addr +
> +               i * sizeof(struct utp_transfer_cmd_desc);
> +       u16 response_offset = offsetof(struct utp_transfer_cmd_desc,
> +                                      response_upiu);
> +       u16 prdt_offset = offsetof(struct utp_transfer_cmd_desc, prd_table);
> +
> +       lrb->utr_descriptor_ptr = utrdlp + i;
> +       lrb->utrd_dma_addr = hba->utrdl_dma_addr +
> +               i * sizeof(struct utp_transfer_req_desc);
> +       lrb->ucd_req_ptr = (struct utp_upiu_req *)(cmd_descp + i);
> +       lrb->ucd_req_dma_addr = cmd_desc_element_addr;
> +       lrb->ucd_rsp_ptr = (struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
> +       lrb->ucd_rsp_dma_addr = cmd_desc_element_addr + response_offset;
> +       lrb->ucd_prdt_ptr = (struct ufshcd_sg_entry *)cmd_descp[i].prd_table;
> +       lrb->ucd_prdt_dma_addr = cmd_desc_element_addr + prdt_offset;
> +}
> +
>  /**
>   * ufshcd_queuecommand - main entry point for SCSI requests
>   * @host: SCSI host pointer
> @@ -3385,7 +3406,6 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
>   */
>  static void ufshcd_host_memory_configure(struct ufs_hba *hba)
>  {
> -       struct utp_transfer_cmd_desc *cmd_descp;
>         struct utp_transfer_req_desc *utrdlp;
>         dma_addr_t cmd_desc_dma_addr;
>         dma_addr_t cmd_desc_element_addr;
> @@ -3395,7 +3415,6 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
>         int i;
>
>         utrdlp = hba->utrdl_base_addr;
> -       cmd_descp = hba->ucdl_base_addr;
>
>         response_offset =
>                 offsetof(struct utp_transfer_cmd_desc, response_upiu);
> @@ -3431,20 +3450,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
>                                 cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
>                 }
>
> -               hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
> -               hba->lrb[i].utrd_dma_addr = hba->utrdl_dma_addr +
> -                               (i * sizeof(struct utp_transfer_req_desc));
> -               hba->lrb[i].ucd_req_ptr =
> -                       (struct utp_upiu_req *)(cmd_descp + i);
> -               hba->lrb[i].ucd_req_dma_addr = cmd_desc_element_addr;
> -               hba->lrb[i].ucd_rsp_ptr =
> -                       (struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
> -               hba->lrb[i].ucd_rsp_dma_addr = cmd_desc_element_addr +
> -                               response_offset;
> -               hba->lrb[i].ucd_prdt_ptr =
> -                       (struct ufshcd_sg_entry *)cmd_descp[i].prd_table;
> -               hba->lrb[i].ucd_prdt_dma_addr = cmd_desc_element_addr +
> -                               prdt_offset;
> +               ufshcd_init_lrb(hba, &hba->lrb[i], i);
>         }
>  }
>


-- 
Regards,
Alim
