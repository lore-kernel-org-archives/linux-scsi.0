Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27A9C5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86877217D7
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="CoH4ESV7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbfKFKjj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 05:39:39 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35133 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfKFKji (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 05:39:38 -0500
Received: by mail-io1-f65.google.com with SMTP id x21so10785365iol.2
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 02:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bNrr8Ib11/V790IuO1UQ7JycvtKE50p6bCpWge+6hbI=;
        b=CoH4ESV74eCcZ7ssMdmaeds0zU5gEBWowNc64oe1VQV2yd2oDPhqbHemFpJW12D3Ye
         i3FoBav483OLmtpEEU+lypgItyhKa+sVyAVkYRvCWnFgeen9r6zg2oQvABEwhKj6Jkgr
         n/S0lJfOEMZyiNZMA+kIeBTkqBWENYgo0vuhnwzBAKiQfR/BXV/+lDeEwLghLpUajzj2
         pF+sZrTnK4HYkcSA37Y9FawfrBbe2iG+Fjl22opByNCdKlynx7CtGRasrfessXffNljk
         tdMsLQ0P6Qa1LDdE+hAjikNFpND/5algPNLy5HBtljJmJqHttoZZcyFdd7xWhaMq98Q0
         1dQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bNrr8Ib11/V790IuO1UQ7JycvtKE50p6bCpWge+6hbI=;
        b=sBRXH6GsxsvE1l+TuSrmJpACzUhk7wFQ33aX7ih0g5OkMoVYjx9A9Rk1MggOhfe8xW
         WT/Ld2X8rJBh9ioHhxIfaMigwtZqrWixmeINgGj3JOJ7LYxnXSdAoS6OJFbHinRF4DHT
         7CwCelJOC9hPP48hdPQpQo2LmLounIhinZgEbOhm+b882Q6WhT8sECu+1MEfCJCnEJ02
         50D23urPaKNEI1EOn7GuUs6VjmhDMcyUTCxhA+HFvtKlEo/3GMTzyTUXeqQaQchh3v6u
         Q1TP4BGkDPBO7Wc7pwpXrs77dDg5+iXtMrSaQ+F/kLacld48y4I8WSS+I7MAOPZlV1IJ
         NhLQ==
X-Gm-Message-State: APjAAAX7VUjTVRZ+Zx5/Pd7TEkzEX6mXsw51c6HlrLlgEUl7KPlaxLhi
        dBX8ocgDlqWTPS/9zFLQHN/HRd5cRl+3g8h4qiyS/Q==
X-Google-Smtp-Source: APXvYqxKZdygWlKjQnmxCU+6mtDkLFcZWbluls6lMy9/T/6UcNRyMkFznvgleWmWJF2nIAChux6PDf5rL1QAAenxyMw=
X-Received: by 2002:a6b:3a88:: with SMTP id h130mr6066438ioa.217.1573036777590;
 Wed, 06 Nov 2019 02:39:37 -0800 (PST)
MIME-Version: 1.0
References: <20191031051241.6762-1-deepak.ukey@microchip.com> <20191031051241.6762-9-deepak.ukey@microchip.com>
In-Reply-To: <20191031051241.6762-9-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 6 Nov 2019 11:39:26 +0100
Message-ID: <CAMGffEmMBTWHVJfdcvZNegDS+yPQFsGhx1L9FbBuN=-QdCRc7A@mail.gmail.com>
Subject: Re: [PATCH 08/12] pm80xx : Cleanup command when a reset times out.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, Vikram Auradkar <auradkar@google.com>,
        ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 31, 2019 at 6:12 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: peter chang <dpf@google.com>
>
> Added the fix so the if driver properly sent the abort it try to remove
> it from the firmware's list of outstanding commands regardless of the
> abort status. This means that the task gets free-ed 'now' rather than
> possibly getting free-ed later when the scsi layer thinks it's leaked
> but still valid.
>
> Signed-off-by: peter chang <dpf@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 50 +++++++++++++++++++++++++++++-----------
>  1 file changed, 37 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 4491de8d40fc..b562916a3d3d 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -1204,8 +1204,8 @@ int pm8001_abort_task(struct sas_task *task)
>         pm8001_dev = dev->lldd_dev;
>         pm8001_ha = pm8001_find_ha_by_dev(dev);
>         phy_id = pm8001_dev->attached_phy;
> -       rc = pm8001_find_tag(task, &tag);
> -       if (rc == 0) {
> +       ret = pm8001_find_tag(task, &tag);
> +       if (ret == 0) {
>                 pm8001_printk("no tag for task:%p\n", task);
>                 return TMF_RESP_FUNC_FAILED;
>         }
> @@ -1243,26 +1243,50 @@ int pm8001_abort_task(struct sas_task *task)
>
>                         /* 2. Send Phy Control Hard Reset */
>                         reinit_completion(&completion);
> +                       phy->port_reset_status = PORT_RESET_TMO;
>                         phy->reset_success = false;
>                         phy->enable_completion = &completion;
>                         phy->reset_completion = &completion_reset;
>                         ret = PM8001_CHIP_DISP->phy_ctl_req(pm8001_ha, phy_id,
>                                 PHY_HARD_RESET);
> -                       if (ret)
> -                               goto out;
> -                       PM8001_MSG_DBG(pm8001_ha,
> -                               pm8001_printk("Waiting for local phy ctl\n"));
> -                       wait_for_completion(&completion);
> -                       if (!phy->reset_success)
> +                       if (ret) {
> +                               phy->enable_completion = NULL;
> +                               phy->reset_completion = NULL;
>                                 goto out;
> +                       }
>
> -                       /* 3. Wait for Port Reset complete / Port reset TMO */
> +                       /* In the case of the reset timeout/fail we still
> +                        * abort the command at the firmware. Yhe assumption
s/Yhe/The
> +                        * here is that the drive is off doing something so
> +                        * that it's not processing requests, and we want to
> +                        * avoid getting a completion for this and either
> +                        * leaking the task in libsas or losing the race and
> +                        * getting a double free.
> +                        */
>                         PM8001_MSG_DBG(pm8001_ha,
> +                               pm8001_printk("Waiting for local phy ctl\n"));
> +                       ret = wait_for_completion_timeout(&completion,
> +                                       PM8001_TASK_TIMEOUT * HZ);
> +                       if (!ret || !phy->reset_success) {
> +                               phy->enable_completion = NULL;
> +                               phy->reset_completion = NULL;
> +                       } else {
> +                               /* 3. Wait for Port Reset complete or
> +                                * Port reset TMO
> +                                */
> +                               PM8001_MSG_DBG(pm8001_ha,
>                                 pm8001_printk("Waiting for Port reset\n"));
> -                       wait_for_completion(&completion_reset);
> -                       if (phy->port_reset_status) {
> -                               pm8001_dev_gone_notify(dev);
> -                               goto out;
> +                               ret = wait_for_completion_timeout(
> +                                       &completion_reset,
> +                                       PM8001_TASK_TIMEOUT * HZ);
> +                               if (!ret)
> +                                       phy->reset_completion = NULL;
> +                               WARN_ON(phy->port_reset_status ==
> +                                               PORT_RESET_TMO);
> +                               if (phy->port_reset_status == PORT_RESET_TMO) {
> +                                       pm8001_dev_gone_notify(dev);
> +                                       goto out;
> +                               }
>                         }
>
>                         /*
> --
> 2.16.3
>
Patch looks fine, please fix the typo above.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
