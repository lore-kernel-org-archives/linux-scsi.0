Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40C5CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 09:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FA972080F
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 09:19:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="TdYxrFzg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbfKAJT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 05:19:57 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40758 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbfKAJT5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 05:19:57 -0400
Received: by mail-io1-f68.google.com with SMTP id p6so10213332iod.7
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 02:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bkky3kUbEXb9jhAH/ZqT85b1zk9OZBnOC+bZjpMsvZQ=;
        b=TdYxrFzgIokcSTIl3J4d7j3CTL+a190ehRQJcSW2Sq/RBVrjTadCLzMBbLjPy9knmd
         I0ScWtFOv6iD0s5h/LeAoCQHkFlVulLPDblcie50T0Z0hSYQ5LucNOk70zahXz/Ywq6I
         qJ4NWFTMKVmNi0VYOMJqu65bSHcFoiEK2zkd540W2Rvf7Gso8UKmRB136AKoxvOoihAY
         3RzkMzFoLeeWoN6qs4P3+pD1UknygMmZb2g2G8wd5VDc9ThSUqathRLDOYs1n9r/Mv0i
         51yzHYNmRo3BiFr/4G/vfFKOEvYLAGC5rC2FiBLeJWG4sZquLwzuaCF2a2ZzFQqaqwP9
         K9KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bkky3kUbEXb9jhAH/ZqT85b1zk9OZBnOC+bZjpMsvZQ=;
        b=LKgASjkym1Xy5vh5f51FhZrXI/eCENvEO+eS0Rqtwwedkz2yibEz/h/X/ZpJs0L9MK
         nmFC7EvXDA+ImX+GJon0Ijhn+V2xvnweMkJZg7RtibCg4IlyP5LnL9IAOOUUje15HlLC
         PtPmBOAt7tF+MtPV+tB2BzJEyTXSqDFzJCbI6FD9FhAt7M672+aaigSDmvv3T31ot8oo
         Lc9/IJr/6cXuRpjCYQ9DqpyIdTZxMdyc+qyfBXHumPnC/Dc38la0Ybei9Ev0pmsQzLFp
         l0dL1MhSOCJveyAsVFJ3ILPiHfQ/5VAW4GFU1xrt7wUQ3is51+i9QKYpOjdyIXBs+9rY
         1zpg==
X-Gm-Message-State: APjAAAXMCNNLbzwptW036aYLq0uku8UW65tMaEdbhwAV6DBYRbGXk2zO
        +2PSnGmIojTOpxLZlHbHAc5e+WR5p80TyyFBHAcKIA==
X-Google-Smtp-Source: APXvYqwhGAqCgpuRHrpMky6nxNkKr1OPBDyLnb3O5EEj5u3EYZ249tuehD9OsJ8YxUHulye8IR2ujuTLDZXkPJIu3xE=
X-Received: by 2002:a6b:3a88:: with SMTP id h130mr9069271ioa.217.1572599996184;
 Fri, 01 Nov 2019 02:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <20191031051241.6762-1-deepak.ukey@microchip.com> <20191031051241.6762-4-deepak.ukey@microchip.com>
In-Reply-To: <20191031051241.6762-4-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 1 Nov 2019 10:19:45 +0100
Message-ID: <CAMGffEk3SEyh6nLUkGLr4xjTRuo0eogmwq77SBake7Sz1TZh4Q@mail.gmail.com>
Subject: Re: [PATCH 03/12] pm80xx : Convert 'long' mdelay to msleep.
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
> From: Vikram Auradkar <auradkar@google.com>
>
> For delays longer than 20ms [um]delay isn't recommended.
> pm80xx_chip_soft_rst starts off with a 500ms delay before it even
> gets around to checking for the results of the reset. As long as
> it's at least 500ms it doesn't matter what the scheduler is doing.
> The delay in the pm8001_exec_internal_task_abort does nothing, and
> theory is this is a delay to avoid a double-free.
>
> Signed-off-by: Vikram Auradkar <auradkar@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
looks good, thanks
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index ee9c187d8caa..1a1adda15db8 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1241,7 +1241,7 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
>                 pm8001_printk("reset register before write : 0x%x\n", regval));
>
>         pm8001_cw32(pm8001_ha, 0, SPC_REG_SOFT_RESET, SPCv_NORMAL_RESET_VALUE);
> -       mdelay(500);
> +       msleep(500);
>
>         regval = pm8001_cr32(pm8001_ha, 0, SPC_REG_SOFT_RESET);
>         PM8001_INIT_DBG(pm8001_ha,
> @@ -2986,7 +2986,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         pm8001_get_attached_sas_addr(phy, phy->sas_phy.attached_sas_addr);
>         spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
>         if (pm8001_ha->flags == PM8001F_RUN_TIME)
> -               mdelay(200);/*delay a moment to wait disk to spinup*/
> +               msleep(200);/*delay a moment to wait disk to spinup*/
>         pm8001_bytes_dmaed(pm8001_ha, phy_id);
>  }
>
> --
> 2.16.3
>
