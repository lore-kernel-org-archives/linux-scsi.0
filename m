Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD8BCA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 09:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA0EB20656
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 09:16:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="WHvD9O6V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfKAJQR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 05:16:17 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39802 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728226AbfKAJQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 05:16:17 -0400
Received: by mail-io1-f68.google.com with SMTP id 18so10194419ion.6
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 02:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2JPk4txylNAtDBUIdyDKHtICDLRC9t4D+l061HMFLwA=;
        b=WHvD9O6VGAQ/uEUqSVbBJ17lCFsw2rWRFf+q3bkq/5+YS5FXeleWIiKFIE3+V90Ki/
         nYbEdjvM/Hkbx3Vnw5sP7EXnFYhPaQI8bjYP0FYGmqK0wwC7c7s+xw6FzFn6p2hnHQsu
         iJfcPpHXllhcPvXD+KEDpcn4Na/kdQcbDlke+J+PpneQciBHzF5LjeahSnGriqAGDzxc
         9FmzK5GOXwcJ7eHpi07Asx5WzP4VYlLrzrJZDDp26Jct9v2maPHGuSSbwWYrAHLf7XDa
         lQcp7Cea3qC+YmJt2CWqJGdvHGabjAV9xOPrsJvCg4+2ruXdY67R4qJUgKlL8WXMfRXT
         m3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2JPk4txylNAtDBUIdyDKHtICDLRC9t4D+l061HMFLwA=;
        b=kbeD0zDAvJYm8LClLc9m+yzWtAyi+fXd6+0d2MbF7D4V6aYL4Q6/wyzQEJgmq6CN+P
         Adiwb8lOMLLGO/1mJyoGjdF1USfzFIdcuyzJd/qXdfATZxPDMGhoZMuoZaZLLWv2tt+f
         o3AO0+pWm2ygYhfPeJacf6deEoqwTTU+MxLs5cpNFFO+6+QhWsjZTrXnViCUjTgYKoFe
         wtbsBmKec5BIEQKGZXyihe5cNI0zZtlAndZQqUA5iTanMZ/WjBEdQTV3TvRTOrGZQ2E5
         2SkFsQnT4nI3QOuXMAvMuClEeUMDqPh+CJak+FOwJRo7fr0Q1oFPCZS1Uk/Rzk+Fz+T+
         F/Xg==
X-Gm-Message-State: APjAAAV5QZyjh2+oBfmyQEkRPLWo9AjL+Lp39ioWrvE56Qf5A+SuFlDr
        0EijH51zEkHjGC2AB4bRwSvYpiDQiU5Ro5P+aiXdSQ==
X-Google-Smtp-Source: APXvYqx6s+EIa/vnOA+baTf5b5kkddnxMOxvdkr7uA7kLoaoOQckhiVViDRU6Kxci7eYgnO5Ux1GOpHv7LSi2Lxcet8=
X-Received: by 2002:a5d:80d5:: with SMTP id h21mr6751739ior.298.1572599774987;
 Fri, 01 Nov 2019 02:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191031051241.6762-1-deepak.ukey@microchip.com> <20191031051241.6762-2-deepak.ukey@microchip.com>
In-Reply-To: <20191031051241.6762-2-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 1 Nov 2019 10:16:04 +0100
Message-ID: <CAMGffEmtc+4Th-ZiC3Gq5MkijO+WU6as9T5My1EH=gtTXfZAoQ@mail.gmail.com>
Subject: Re: [PATCH 01/12] pm80xx : Fix for SATA device discovery.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, auradkar@google.com, ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 31, 2019 at 6:12 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: peter chang <dpf@google.com>
>
> Driver was  missing complete() call in mpi_sata_completion which
> result in SATA abort error handling is timing out. That causes the
> device to be left in the in_recovery state so subsequent commands
> sent to the device fail and the OS removes access to it.
>
> Signed-off-by: peter chang <dpf@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
Thanks for the patch, it looks good.
But the commit message doesn't explain the second part of the change,
I suggest to split it to 2 patches.
Thanks
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 73261902d75d..ee9c187d8caa 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2382,6 +2382,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                         pm8001_printk("task 0x%p done with io_status 0x%x"
>                         " resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                         t, status, ts->resp, ts->stat));
> +               if (t->slow_task)
> +                       complete(&t->slow_task->completion);
>                 pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> @@ -3130,8 +3132,10 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         if (status == 0) {
>                 phy->phy_state = PHY_LINK_DOWN;
>                 if (pm8001_ha->flags == PM8001F_RUN_TIME &&
> -                               phy->enable_completion != NULL)
> +                               phy->enable_completion != NULL) {
>                         complete(phy->enable_completion);
> +                       phy->enable_completion = NULL;
> +               }
>         }
>         return 0;
>
> --
> 2.16.3
>
