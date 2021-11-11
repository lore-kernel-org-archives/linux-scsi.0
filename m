Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EB8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 16:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9EA161179
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 16:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhKKQz5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 11:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhKKQz4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 11:55:56 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCC8C061766
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2021 08:53:07 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id s14so6422310ilv.10
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2021 08:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y6Hyl0f0fIORVneRqBXLhMYWr6NMpLrNiqPUGfktraw=;
        b=SBaD+qdwDg4Fp4gzA5/Co+zXdAT6bbGak5LecLD8vDDnt+bqPD1GHWXsEHga69Zhfa
         GQu0eAuTCVvrovuQDwBDKzav5u36N1fa4zWIpZDhEfT2UcNDhW+GLr9WkErItIrcJ9b7
         3E1vpw8pbIKvyNZXUtYQSBGG0DAv4hi5frlIvRCRUNUb6ls0/bJ04zuldaxBdKS0dXMv
         xytpE7zo/Oe+BQ+zapZo8azMW4r72NRnYiyLfdCpMmFd+7hG+RIV7vdwmDoP5s+q+/he
         9Qi1fD8FHGvNFGXyTIkJ/7G8/Xhli5YskmnmL+udsxQBz/RL40xrPnj+O3DwgDRksEX/
         9xZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y6Hyl0f0fIORVneRqBXLhMYWr6NMpLrNiqPUGfktraw=;
        b=NJuyM3kSmhWkg9tThxDEcb3hNe7z7GLdQ/QsKe/OFlN45uWBLHLLeAV3rD93tuSjKa
         DD01ZHpjLPq1BC3XEjh78jsxw55k3zxKvsr7n/g+oq0MqZVPTu61t0b8ktsXvEaIgbui
         4UKx1h4hS08NsJEZRnj+zQXEai4eIkxUyDrQrEk0tmG6O3qRc0xN0Kq1gGQ95UTQ+WK+
         rJyo1Y/4/HQ0B8T5elsMcrMkwV4HceCuaih2BfczCvd77VU3q1e22qrRsi6Q8D8YM7J9
         zZbzlo96vpAg+DhV7+U1Nj7ETefrw5YvLnldXN0POgXHDZIJVLOUko+MYP/xhRxjdB8r
         M45A==
X-Gm-Message-State: AOAM532F5403dyi67Ia4yKn6qHqZ6A/ukxSH0oKpYVbi1LbjIKfO+rCX
        mRIjh9dEJgXd2GYNEYx2HWdElk/XeFCjhMt1nz8=
X-Google-Smtp-Source: ABdhPJzEgSBHmzdvCHHEbiBILXxlMht/i4w2k0NJSBM+aSJ+k+N/HGFVsDGhqEf4jHah4+7UxaWnm1ZhALTFC4okJ9c=
X-Received: by 2002:a05:6e02:b2c:: with SMTP id e12mr5068968ilu.249.1636649587105;
 Thu, 11 Nov 2021 08:53:07 -0800 (PST)
MIME-Version: 1.0
References: <20211110004440.3389311-1-bvanassche@acm.org> <20211110004440.3389311-3-bvanassche@acm.org>
In-Reply-To: <20211110004440.3389311-3-bvanassche@acm.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Thu, 11 Nov 2021 22:22:31 +0530
Message-ID: <CAGOxZ51A3mpE1d8YjN+vH=pep+VEsH=kSF=ScV++66TFA4SMcg@mail.gmail.com>
Subject: Re: [PATCH 02/11] scsi: ufs: Remove is_rpmb_wlun()
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

On Wed, Nov 10, 2021 at 6:21 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Commit edc0596cc04b ("scsi: ufs: core: Stop clearing UNIT ATTENTIONS")
> removed all callers of is_rpmb_wlun(). Hence also remove the function
> itself.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index dac8fbf221f7..d18685d080d7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2650,11 +2650,6 @@ static inline u16 ufshcd_upiu_wlun_to_scsi_wlun(u8 upiu_wlun_id)
>         return (upiu_wlun_id & ~UFS_UPIU_WLUN_ID) | SCSI_W_LUN_BASE;
>  }
>
> -static inline bool is_rpmb_wlun(struct scsi_device *sdev)
> -{
> -       return sdev->lun == ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN);
> -}
> -
>  static inline bool is_device_wlun(struct scsi_device *sdev)
>  {
>         return sdev->lun ==



-- 
Regards,
Alim
