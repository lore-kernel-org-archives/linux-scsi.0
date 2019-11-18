Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3962C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE4DC2071B
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Vl5whEQ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKRJl7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 04:41:59 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:40150 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfKRJl7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 04:41:59 -0500
Received: by mail-il1-f194.google.com with SMTP id d83so15359774ilk.7
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 01:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s/xCULP+rH7gn4b9tLGIOpjlH5sBt2aMavVI8pKmtg4=;
        b=Vl5whEQ/5fuz252IGyDczDMN8JXcnwEQN3Jg/XhI7BOykS0YeasyGZgyKsFaM2/kIw
         fRDrBbgO4HQCrVDQ3iWy7r04Fy/HCMsVBXLF20Nk0QS7cVkr8iYVwAwtDhKXEfMSXSCg
         P0b9oAjZEVjjjI6zmCf1GQQoKKllcMF/ut/QBS+0qtkd53WY/JFBkJgRU6tqL92ONrta
         u5wwS6vZViV+Pj/KjkGoBwWChfCL5L/aFQUTK3RtxeTvklr07QjUBbE+Ex9O/EDmjkx4
         SGug4InO0F9eWzI7Ys7/EbiZHADWgVKavgCh4lDb9Y3gjc4ywFaMYlZeradyQyYf/rEu
         LB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/xCULP+rH7gn4b9tLGIOpjlH5sBt2aMavVI8pKmtg4=;
        b=F/w+I6W7j73qxYPXuU5rsJhZEVJzPmr8Yrg+K3PAWI4zHZfOxQOp0c1n1lcOn8Iacj
         VSFfWXgzHhPHlw5n8pe3kO3ntTe/XK8WC+oXyVZ+OIZZHkoVQqjRU0z8egr6+IC0WPUg
         7pLjIkzRBjqaY32D1TBV4tGsbbbaOhIa9OzHX2o3WPviWXuR8Bhh/8ftlkBB9vedXSVG
         OGKGjElTaaY/yTzh+oEHuMAqhA2y8C2ZfA2oGR2AX+B0g3FRUx0x53rIL1yuuJ31IvFc
         qsl1Xn41f/hwXrBN2ZtpGa3TM1LU92jEAFCxctqIh46+/J/7PXDbtn5Zr8RmUhzHMDax
         b0Eg==
X-Gm-Message-State: APjAAAWTmjHpnomQyNIoSrMUp4Wcjlas6HJR/12kU0oed4z1/c3ziKRq
        9QnmAKJB3URMuIW3VO5Tvjk3nvKx1M/vvUu8s2kVWQ==
X-Google-Smtp-Source: APXvYqxcPY5VArAbbjI9PO4LwqreDANiQE7W1dAgM6i7t62mpcboKmFYydhyGg8skDtbPV3eVsaqU19XvZoc+Zr1mRE=
X-Received: by 2002:a92:c152:: with SMTP id b18mr15028816ilh.71.1574070116498;
 Mon, 18 Nov 2019 01:41:56 -0800 (PST)
MIME-Version: 1.0
References: <20191114100910.6153-1-deepak.ukey@microchip.com> <20191114100910.6153-10-deepak.ukey@microchip.com>
In-Reply-To: <20191114100910.6153-10-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 18 Nov 2019 10:41:45 +0100
Message-ID: <CAMGffEnjSZrv+TUrin--EhLq4sJBk09zvq-box0nKdz7pCyr1Q@mail.gmail.com>
Subject: Re: [PATCH V2 09/13] pm80xx : Cleanup command when a reset times out.
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

On Thu, Nov 14, 2019 at 11:08 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
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
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 50 +++++++++++++++++++++++++++++-----------
>  1 file changed, 37 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 4491de8d40fc..b7cbc312843e 100644
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
> +                        * abort the command at the firmware. The assumption
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
