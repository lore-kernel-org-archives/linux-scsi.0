Return-Path: <SRS0=4AUr=2R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA56C2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 01:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AF0920838
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 01:22:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H1aO2q84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfL0BWA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 20:22:00 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:42927 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0BWA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 20:22:00 -0500
Received: by mail-vs1-f67.google.com with SMTP id b79so16104439vsd.9
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 17:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IZtccVTKLhaYaVWE03Uv8al8UwSM7fqu+791La2mZ8o=;
        b=H1aO2q84mmzUYJuwHmuTMfxoByYNJjnnJ+pXaiQSWA8EICeFoFkxRiBvD7W0VAy8jY
         4h3WGlb3HhGC5Ve8IFb0zLvhINBc1j8IlXKGmgh6IAZiKaN87f4TVqBs9XBy5HKfKq/o
         bFmlNE7lx+XrUXhlg+Adjwx3+xX9qemz1zox2XjsP7TMnll93pE1wIRdYetsM2LXSjC5
         P4RsWtczyYJOJiObRfC9bv3zRl8c3xcnDtHnMXXNOB6l9W+HSWHoQm2YRqgLRYqIKV4s
         9EEVDJ1ErfnZHbEcrpftr2CpG7dFbARLphejZQJefGVM+3AJ29zowGRfiAeyBhKduR55
         t9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IZtccVTKLhaYaVWE03Uv8al8UwSM7fqu+791La2mZ8o=;
        b=KanYHhAEuo6ClF1PrkRPeh2bw4H0UzH9q/7caGjTX/iDf+xswLqwDJNNJ2un58AaVC
         7AEdmInol5ONHoiVlko3gNprWN09ImgqzzyLz8BEJe0/f1M9gGs3YcSt0Q15yz7XzAN0
         cDeKPgkoQoBhMJdWb9lU5SxRcb1klp7LQ4md9kaR6bf6UMTO7xQiUL9njC7+d79T3J87
         U25CA8Y0PfOvrGm+o1uQUjo2cMFuUmdgspKlHxw1tMW501A6ZtOPkkIkO5h0q/3LqJax
         Pr8WJXBEeandl2ojYE/weZw9DhV0QPe9J2bSBEsRAVzZHG+MMRK1yKe1B0AcdOONOvUM
         TlXA==
X-Gm-Message-State: APjAAAXY9VnfKZf7LBZPzrSie9Zy07hNok7ySDzM8dFYju97pFM6v48L
        NjRdgGPeXT/Wm9wwM38hqfI/QRURSw7308AwqoArVUWYh7Q=
X-Google-Smtp-Source: APXvYqyD8OJXVf4/tXSmcQO16+vlX+bLkj5G2sNHg4NFotH5BDfri832porT2rbathmq/z+1ArpdNoozZHNODrr5QEU=
X-Received: by 2002:a67:fb14:: with SMTP id d20mr26357413vsr.136.1577409719329;
 Thu, 26 Dec 2019 17:21:59 -0800 (PST)
MIME-Version: 1.0
References: <20191224220248.30138-1-bvanassche@acm.org> <20191224220248.30138-5-bvanassche@acm.org>
In-Reply-To: <20191224220248.30138-5-bvanassche@acm.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Fri, 27 Dec 2019 06:51:23 +0530
Message-ID: <CAGOxZ534GtixwYrt2_oWJCKBP6Oj+NztFt3=7D_xWe0Ref9vHg@mail.gmail.com>
Subject: Re: [PATCH 4/6] ufs: Fix a race condition in the tracing code
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

On Wed, Dec 25, 2019 at 3:34 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Starting execution of a command before tracing a command may cause the
> completion handler to free data while it is being traced. Fix this race
> by tracing a command before it is submitted.
>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 80b028ba39e9..4d9bb1932b39 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1875,12 +1875,12 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
>  {
>         hba->lrb[task_tag].issue_time_stamp = ktime_get();
>         hba->lrb[task_tag].compl_time_stamp = ktime_set(0, 0);
> +       ufshcd_add_command_trace(hba, task_tag, "send");
>         ufshcd_clk_scaling_start_busy(hba);
>         __set_bit(task_tag, &hba->outstanding_reqs);
>         ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>         /* Make sure that doorbell is committed immediately */
>         wmb();
> -       ufshcd_add_command_trace(hba, task_tag, "send");
>  }
>
>  /**



-- 
Regards,
Alim
