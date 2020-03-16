Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7434C1975A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7BF3206B1
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:47:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="VDHdJvKX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbgCPIrk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:47:40 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45050 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730118AbgCPIrj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 04:47:39 -0400
Received: by mail-io1-f67.google.com with SMTP id v3so6111853iot.11
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2020 01:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ARonZXKLjp2V54hx5ziMSfMjZgoOgYH+dO/2y2CdcH0=;
        b=VDHdJvKXHUE3Na8ZqfbUfK1MpL+heW8KO5UEW2RCPyS+qpgkGbtoD3+T+lgtPaPJMY
         DkDS4G18FSUS5Yy69rQ/rHp0KefxkQ/XcN5CH/1jxVaWdmdgDxRULTGP1WOVatNAXGXx
         TIXEvV2a0QQT6JTNC8ZhyYuzIpyZoKpZrDXyZTaln3jk1FFtJFY6dMqs696u63XFeiRk
         g2uc0j5zpY4zvlrwLKmId/+ttDk3WJaCEuiPq4a1bVpvRV/lcIOdStfTUnAxVtHU1rsn
         0/ThTQuummo9P7T49Vf+MZOIxVr46y5Mmw0KTkuyMrPYNN+lXHpTE+IG79MVJeLhqDCr
         +IaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ARonZXKLjp2V54hx5ziMSfMjZgoOgYH+dO/2y2CdcH0=;
        b=ga542B6+VuRES3hgVFm/iRcr0csAPQKyW6DF/C8OpANvM7jqUB/yZSCHVoIaDkAIY+
         e3gmsPZNvblULo1kV2Jx9w644lRHCW/Vot124juTZbB/x4cazC8Q815wJd5tFQqrTml+
         0oR1gxeH998HYkphv+6DQVrZfl3oBOGfjWbRp+4JbBrkRLIbcZwS3WQELfu+d8blE5hc
         xzWsVXxWObKg+En6S0JfBtxXT2d12Zwk1PgEqp5sjYmN54mBr487uO5ZPx0z5bvaOkCX
         2UnGZmZ6oRjo56B3eKTItrHb9wXP6dBMJvDjtEUnEClWlQ9eJTgUXVluI9Rlx3Kv0XII
         Azkg==
X-Gm-Message-State: ANhLgQ2+KIrdyGLSwIJT6IrbNvePwCPVUxKbG9RIO3A/cyAJrGpEqVX9
        Pn1ibWbQCBbu99yB5URJweX30tbmVfsH45mfY+K0lQ==
X-Google-Smtp-Source: ADFU+vsW840ZtZtDn/7feeLANLq0XN3fX6nvkl4hV1t+Nn6m+shYonUA4XfV3vG+ZO5+rGOTSth5dwoxw8JB+Ho86VY=
X-Received: by 2002:a05:6638:39a:: with SMTP id y26mr24706124jap.13.1584348457003;
 Mon, 16 Mar 2020 01:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200316074906.9119-1-deepak.ukey@microchip.com> <20200316074906.9119-2-deepak.ukey@microchip.com>
In-Reply-To: <20200316074906.9119-2-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 16 Mar 2020 09:47:27 +0100
Message-ID: <CAMGffEkQCyW_rqiteM0nn4dgjk5YkM59QMgVS9yHk1F4XET3yA@mail.gmail.com>
Subject: Re: [PATCH V3 1/6] pm80xx : Increase request sg length.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 16, 2020 at 8:39 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Peter Chang <dpf@google.com>
>
> Increasing the per-request size maximum (max_sectors_kb) runs into
> the per-device dma scatter gather list limit (max_segments) for
> users of the io vector system calls (eg, readv and writev). This is
> because the kernel combines io vectors into dma segments when
> possible, but it doesn't work for our user because the vectors in the
> buffer cache get scrambled.
> This change bumps the advertised max scatter gather length to 528 to
> cover 2M w/ x86's 4k pages and some extra for the user checksum.
> It trims the size of some of the tables we don't care about and
> exposes all of the command slots upstream to the scsi layer.
> Also reduced the PM8001_MAX_CCB to 256 as pm8001 driver has memory
> limit depend on machine capability. If we increase the sg length,
> we need to trade-off it by decreasing PM8001_MAX_CCB.
> PM8001_MAX_CCB = 256 does not have any influence on normal use
>
> Signed-off-by: Peter Chang <dpf@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Reported-by: kbuild test robot <lkp@intel.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks!
> ---
>  drivers/scsi/pm8001/pm8001_defs.h | 5 +++--
>  drivers/scsi/pm8001/pm8001_init.c | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
> index 48e0624ecc68..1c7f15fd69ce 100644
> --- a/drivers/scsi/pm8001/pm8001_defs.h
> +++ b/drivers/scsi/pm8001/pm8001_defs.h
> @@ -75,7 +75,7 @@ enum port_type {
>  };
>
>  /* driver compile-time configuration */
> -#define        PM8001_MAX_CCB           512    /* max ccbs supported */
> +#define        PM8001_MAX_CCB           256    /* max ccbs supported */
>  #define PM8001_MPI_QUEUE         1024   /* maximum mpi queue entries */
>  #define        PM8001_MAX_INB_NUM       1
>  #define        PM8001_MAX_OUTB_NUM      1
> @@ -99,7 +99,8 @@ enum port_type {
>  #define OB                     (CI + PM8001_MAX_SPCV_INB_NUM)
>  #define PI                     (OB + PM8001_MAX_SPCV_OUTB_NUM)
>  #define USI_MAX_MEMCNT         (PI + PM8001_MAX_SPCV_OUTB_NUM)
> -#define PM8001_MAX_DMA_SG      SG_ALL
> +#define        CONFIG_SCSI_PM8001_MAX_DMA_SG   528
> +#define PM8001_MAX_DMA_SG      CONFIG_SCSI_PM8001_MAX_DMA_SG
>  enum memory_region_num {
>         AAP1 = 0x0, /* application acceleration processor */
>         IOP,        /* IO processor */
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index ff618ad80ebd..3f1e755c52c6 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -95,7 +95,7 @@ static struct scsi_host_template pm8001_sht = {
>         .bios_param             = sas_bios_param,
>         .can_queue              = 1,
>         .this_id                = -1,
> -       .sg_tablesize           = SG_ALL,
> +       .sg_tablesize           = PM8001_MAX_DMA_SG,
>         .max_sectors            = SCSI_DEFAULT_MAX_SECTORS,
>         .eh_device_reset_handler = sas_eh_device_reset_handler,
>         .eh_target_reset_handler = sas_eh_target_reset_handler,
> --
> 2.16.3
>
