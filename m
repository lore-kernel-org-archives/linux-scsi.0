Return-Path: <SRS0=4AUr=2R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A400C2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 01:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E090A20740
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 01:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QeWErhlC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfL0BON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 20:14:13 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:41692 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0BON (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 20:14:13 -0500
Received: by mail-vk1-f194.google.com with SMTP id p191so6476455vkf.8
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 17:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4u1YvYC9AKTNpid3YPWvxr5yfjnPXCcrGkesGGihI7c=;
        b=QeWErhlCbmGi8VZ8My84RaaQDbY5kLLEadaim7XOSpJn0U2DfgEs+U2+dyYs8JmkFK
         wLP7IF23ouKsyRjSsKnx02SSqz+FOzlXEuMjpH9dsH/yJGCmhK+x9Og9RltvYY0o6Ptm
         8syUdrMLCruWXf7M9y+4rENKyNdItHErIzZ/tka1LBoof6NyMJKcTL7YS9+5dfZNAB1d
         rgmlfoVpVxY8+NPDx8W4btcv4ATpMTXE6pk3/fWPIo0wd98QhaNhNAQeEVTPt0dU1dbz
         qtaFBAWvvanTz+gFUgbSBpoIjnuK0UwTgvhgaRT3t4Se/ZQ+CGV6Mar3pBLPLM563aZ+
         pk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4u1YvYC9AKTNpid3YPWvxr5yfjnPXCcrGkesGGihI7c=;
        b=tFRBpasuIOzPPgFxy1Cqae295w+SqnzouT8j3eqMStlfmOa96iD9ko62BNlQ7XVZvB
         hnnDiFvrTsd3lJfRwX8dyZIg44olklybjwvz5FLlr/46rxtJVzRDMddnl/LA8SQrrdPC
         Q+5Bud6s4YlOJF53lB3NxyjljgRieipfTLLRchvjL9OJZfs4HybIWF9zmMRxSLVLmH8M
         QGZNKouw8+giN9zvCChb6asiaxTQsxEtB9fbrptL6uY/aMA4Y32ppTCTp4xBBaFkCFO0
         z4nSsrdSIs4vPkfeXHhiCDVOTHQ8fWewPxim1xnQmBaopf66EIotJC5tLxwCmd6gguZu
         oyYg==
X-Gm-Message-State: APjAAAURCFEh5xJYIcQeWgpKdAtNGLnes6x0Uci7brIhikaqKwRQHueg
        b6a3ayC1VFeusLubP68wxBkFLDUk3FYGckvlLx0=
X-Google-Smtp-Source: APXvYqzmqhJQ+sgskdc68bmSmn8lYeJqXssgFjtbuu7P0ch8OSteJ5M2WtUfVgOb+J+muYUZzTDBgViHGS0yM+IFka0=
X-Received: by 2002:a1f:252:: with SMTP id 79mr29109217vkc.96.1577409252382;
 Thu, 26 Dec 2019 17:14:12 -0800 (PST)
MIME-Version: 1.0
References: <20191224220248.30138-1-bvanassche@acm.org> <20191224220248.30138-2-bvanassche@acm.org>
In-Reply-To: <20191224220248.30138-2-bvanassche@acm.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Fri, 27 Dec 2019 06:43:36 +0530
Message-ID: <CAGOxZ53Ymxj-Z4s7pBn8h3cx2rjWDLA5NQAbki_kiRXaBn=rOg@mail.gmail.com>
Subject: Re: [PATCH 1/6] ufs: Fix indentation in ufshcd_query_attr_retry()
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

On Wed, Dec 25, 2019 at 3:33 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Remove a space that occurs after a tab.
>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
Reviewed-by: Alim Akhar <alim.akhtar@samsung.com>
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d6d0f83c9044..48f2f94d51bc 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2869,7 +2869,7 @@ static int ufshcd_query_attr_retry(struct ufs_hba *hba,
>         int ret = 0;
>         u32 retries;
>
> -        for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
> +       for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
>                 ret = ufshcd_query_attr(hba, opcode, idn, index,
>                                                 selector, attr_val);
>                 if (ret)



-- 
Regards,
Alim
