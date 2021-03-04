Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49E5C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92E9F64F11
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbhCDJdv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbhCDJd0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:33:26 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC53C061574
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:32:46 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b13so24673633edx.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iaYu5CwLIPx2Ryg9t9835KBMyOcRT26k0alKku0hS0E=;
        b=ILTm+/j+ELenJt/sUbzp6ptivrdr3z2a4IwyI51V7CoiBdx+wH7TQBf2qlE+Vyyy5Y
         Y0H60E/NloAZEUOWHcLfQ3uprajTzIAEL0P9r+KmalYiYqp5ZRG0ekNJxkr+FhNKWNPI
         RqeLNnS95VAVJ7tIKRn7MQ0huhRhOD609VDarNG12/swoW0CKU+uCsrnaGgldIV4J9Fu
         fLbSufgGeN79k5IZBcAwBsjJ4p5Te3w8fBnABUpV7w+2r1JBqrBtb/vRm2+P7yQlNNRB
         Sn4A6f7T6ArAgmlh6CGFCWfQPtB8c5SgwuD0/9pbeS6Rg7ExuYi2W/4KPpXLN2POHAj1
         vgzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iaYu5CwLIPx2Ryg9t9835KBMyOcRT26k0alKku0hS0E=;
        b=DQgrFa07l+znD0H508t5nWwd7KDqt+YTphLrq+6mgm9ROrQcBM5p3/p9NhGEwqS/FH
         ICTvXvObPNlBLp4ZdODXTbbV/t22/PGvXLTt/ldxgAr/nVSyL3/JEs/dKhA/2Le59Lkq
         b1APGdiIBB2ic6HYqQGipIy2EUJpqXbKOufbONxCuKZZUESz7zbNpW9yAvhceTFpJHnw
         OJi6SjmhWj4BtKRxYVSRWJD6dah/31yRq8PT0dTgAhVwEVmWR71qj++rkFoQQrHDwv7u
         BPaXmFwGez1cI4rI0JWiHWY4m20l5r8SuTogqcTM7PWLOJv8t8aOKiDQfiK9NACS8ql9
         m4sA==
X-Gm-Message-State: AOAM532X8kzOGAVC/GILs2Tq+1xKPf+Nqhre0h0KrkFdaAQyMDcCLCyO
        Qfj0xkpR9pvNuUSNeHyvM3q7SFLy8a1b0j6F26iR/A==
X-Google-Smtp-Source: ABdhPJziYCtkrnyE7CjvI5pQT02mUotNYbax4ptvVzoIfTv1HSaBOznqCh9JOvK4akZ7EazSy8ula0ZKfWrLWeoFcW8=
X-Received: by 2002:a50:f38f:: with SMTP id g15mr3292341edm.262.1614850364729;
 Thu, 04 Mar 2021 01:32:44 -0800 (PST)
MIME-Version: 1.0
References: <20210224155802.13292-1-Viswas.G@microchip.com> <20210224155802.13292-6-Viswas.G@microchip.com>
In-Reply-To: <20210224155802.13292-6-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:32:34 +0100
Message-ID: <CAMGffEnRNj6UozDghgbw9MLto7p4DxHAa4qqaT1b0uHYRC+pDg@mail.gmail.com>
Subject: Re: [PATCH 5/7] pm80xx: Completing pending IO after fatal error
To:     Viswas G <Viswas.G@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar.devadi@microchip.com,
        Vishakha Channapattan <vishakhavc@google.com>,
        Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 24, 2021 at 4:48 PM Viswas G <Viswas.G@microchip.com> wrote:
>
> From: Ruksar Devadi <Ruksar.devadi@microchip.com>
>
> When controller runs into fatal error, IOs get stuck with no response,
> handler event is defined to complete the pending IOs
> (SAS task and internal task) and also perform the cleanup for the
> drives.
>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Looks ok to me, thx!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 66 ++++++++++++++++++++++++++++++++++++----
>  drivers/scsi/pm8001/pm8001_hwi.h |  1 +
>  drivers/scsi/pm8001/pm8001_sas.c |  2 +-
>  drivers/scsi/pm8001/pm8001_sas.h |  1 +
>  drivers/scsi/pm8001/pm80xx_hwi.c |  1 +
>  drivers/scsi/pm8001/pm80xx_hwi.h |  1 +
>  6 files changed, 65 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 49bf2f70a470..4e0ce044ac69 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1499,12 +1499,14 @@ void pm8001_work_fn(struct work_struct *work)
>          * was cancelled. This nullification happens when the device
>          * goes away.
>          */
> -       pm8001_dev = pw->data; /* Most stash device structure */
> -       if ((pm8001_dev == NULL)
> -        || ((pw->handler != IO_XFER_ERROR_BREAK)
> -         && (pm8001_dev->dev_type == SAS_PHY_UNUSED))) {
> -               kfree(pw);
> -               return;
> +       if (pw->handler != IO_FATAL_ERROR) {
> +               pm8001_dev = pw->data; /* Most stash device structure */
> +               if ((pm8001_dev == NULL)
> +                || ((pw->handler != IO_XFER_ERROR_BREAK)
> +                        && (pm8001_dev->dev_type == SAS_PHY_UNUSED))) {
> +                       kfree(pw);
> +                       return;
> +               }
>         }
>
>         switch (pw->handler) {
> @@ -1668,6 +1670,58 @@ void pm8001_work_fn(struct work_struct *work)
>                 dev = pm8001_dev->sas_device;
>                 pm8001_I_T_nexus_reset(dev);
>                 break;
> +       case IO_FATAL_ERROR:
> +       {
> +               struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
> +               struct pm8001_ccb_info *ccb;
> +               struct task_status_struct *ts;
> +               struct sas_task *task;
> +               int i;
> +               u32 tag, device_id;
> +
> +               for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
> +                       ccb = &pm8001_ha->ccb_info[i];
> +                       task = ccb->task;
> +                       ts = &task->task_status;
> +                       tag = ccb->ccb_tag;
> +                       /* check if tag is NULL */
> +                       if (!tag) {
> +                               pm8001_dbg(pm8001_ha, FAIL,
> +                                       "tag Null\n");
> +                               continue;
> +                       }
> +                       if (task != NULL) {
> +                               dev = task->dev;
> +                               if (!dev) {
> +                                       pm8001_dbg(pm8001_ha, FAIL,
> +                                               "dev is NULL\n");
> +                                       continue;
> +                               }
> +                               /*complete sas task and update to top layer */
> +                               pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
> +                               ts->resp = SAS_TASK_COMPLETE;
> +                               task->task_done(task);
> +                       } else if (tag != 0xFFFFFFFF) {
> +                               /* complete the internal commands/non-sas task */
> +                               pm8001_dev = ccb->device;
> +                               if (pm8001_dev->dcompletion) {
> +                                       complete(pm8001_dev->dcompletion);
> +                                       pm8001_dev->dcompletion = NULL;
> +                               }
> +                               complete(pm8001_ha->nvmd_completion);
> +                               pm8001_tag_free(pm8001_ha, tag);
> +                       }
> +               }
> +               /* Deregsiter all the device ids  */
> +               for (i = 0; i < PM8001_MAX_DEVICES; i++) {
> +                       pm8001_dev = &pm8001_ha->devices[i];
> +                       device_id = pm8001_dev->device_id;
> +                       if (device_id) {
> +                               PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
> +                               pm8001_free_dev(pm8001_dev);
> +                       }
> +               }
> +       }       break;
>         }
>         kfree(pw);
>  }
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
> index 6d91e2446542..d1f3aa93325b 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.h
> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> @@ -805,6 +805,7 @@ struct set_dev_state_resp {
>  #define IO_ABORT_IN_PROGRESS                           0x40
>  #define IO_ABORT_DELAYED                               0x41
>  #define IO_INVALID_LENGTH                              0x42
> +#define IO_FATAL_ERROR                                 0x51
>
>  /* WARNING: This error code must always be the last number.
>   * If you add error code, modify this code also
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index a98d4496ff8b..edec599ac641 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -590,7 +590,7 @@ struct pm8001_device *pm8001_find_dev(struct pm8001_hba_info *pm8001_ha,
>         return NULL;
>  }
>
> -static void pm8001_free_dev(struct pm8001_device *pm8001_dev)
> +void pm8001_free_dev(struct pm8001_device *pm8001_dev)
>  {
>         u32 id = pm8001_dev->id;
>         memset(pm8001_dev, 0, sizeof(*pm8001_dev));
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 039ed91e9841..36cd37c8c29a 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -727,6 +727,7 @@ ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
>                 struct device_attribute *attr, char *buf);
>  ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
>  int pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha);
> +void pm8001_free_dev(struct pm8001_device *pm8001_dev);
>  /* ctl shared API */
>  extern struct device_attribute *pm8001_host_attrs[];
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 84315560e8e1..1aa3a499c85a 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4126,6 +4126,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
>                         pm8001_dbg(pm8001_ha, FAIL,
>                                    "Firmware Fatal error! Regval:0x%x\n",
>                                    regval);
> +                       pm8001_handle_event(pm8001_ha, NULL, IO_FATAL_ERROR);
>                         print_scratchpad_registers(pm8001_ha);
>                         return ret;
>                 }
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index 2c8e85cfdbc4..c7e5d93bea92 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -1272,6 +1272,7 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
>  #define IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_OPEN_COLLIDE   0x47
>  #define IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_PATHWAY_BLOCKED        0x48
>  #define IO_DS_INVALID                                  0x49
> +#define IO_FATAL_ERROR                                 0x51
>  /* WARNING: the value is not contiguous from here */
>  #define IO_XFER_ERR_LAST_PIO_DATAIN_CRC_ERR    0x52
>  #define IO_XFER_DMA_ACTIVATE_TIMEOUT           0x53
> --
> 2.16.3
>
