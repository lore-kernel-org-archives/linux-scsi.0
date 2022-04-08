Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3345C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 08:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiDHIJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiDHIJR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 04:09:17 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F7A2D1F7
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 01:07:14 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qh7so15642665ejb.11
        for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2022 01:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fKNNV7Gulkc/9emvTc5Wp3n8WKlh6VaPXReQDTL2a5I=;
        b=DLtWuoreAFqE2VEWahqrmH4qr2oQEQ9miCsHoHDfVQ36Blb9MWVmEZjyGa66IWEsVf
         fglJ+HTpBW45BKENf/EddXqchBLMfpGBWnsiz1GGK9Bbk3iokuRyT+ADLW5yWmtX5y6O
         asYZCh2hN1+Zj1STIUBwERvdfXzXL50zLENhgiFTNKMH7HdUZbNHk/epTz+AYOnO+C0D
         fl1a81BRzIedjB+t2zA6YzjJ0iYW/mToAzmhsXgKZN9r4cs/tAzw72AHcyL9rEhwH5Dl
         2LmYhxx45atWZMvC5s7NbgYk+eRr2dSqNAvfvTQHfD22sCN5kXaFZ16Q7tMjt9waHAtL
         E9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fKNNV7Gulkc/9emvTc5Wp3n8WKlh6VaPXReQDTL2a5I=;
        b=Pz6ineUrtlA0nt1w06i2s+WJpNTpQEWM5NKqhw87XWZbwxnBIms0/ST9Rlyg+a2SGB
         270hg5LurXZg0qnxuaP25qEeedRny4QDCPOssV82BPCe09477vpij0JBlOYKRfZuTQXE
         6LC+fs8IwE4Y8e2gY7gRO1PZWQT++kH99Io2/YneahhZHpBSDq3e6tNRT5hVOWCFKJIJ
         dr4CvZHV62CCednm0bUyHpmAAnkvoI8fUaGgIjj2xi1QTL8xP1glRnbPb8kAucLHwshk
         i/OpbGcsl5Evi98vBlBTSzCqbRTF3oL6Kok4ohGb8kYSLRkINWPnth1k9x7RjHFLSM6C
         6VSA==
X-Gm-Message-State: AOAM532wsqsH+LqK84YO/aD4ZQhmKA4HJ2w+LdQ5qrk0NoKvELLNQZzg
        kS2d8Jq+xAVkCcExpK2+zNhSKpNI+qSqANd1uKruTA==
X-Google-Smtp-Source: ABdhPJwB7pwc87O4089CU/hhyL2cuYw2FvHsQkdd2MltypNBmjcn8GrWvF1k50fvbn1adBjDNbutriZXR/S6FEhzYgs=
X-Received: by 2002:a17:907:3da9:b0:6db:f3f:33c2 with SMTP id
 he41-20020a1709073da900b006db0f3f33c2mr16825610ejc.735.1649405233090; Fri, 08
 Apr 2022 01:07:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220408080538.278707-1-Ajish.Koshy@microchip.com> <20220408080538.278707-3-Ajish.Koshy@microchip.com>
In-Reply-To: <20220408080538.278707-3-Ajish.Koshy@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 8 Apr 2022 10:07:02 +0200
Message-ID: <CAMGffEkRuCGucynaY98tRpYEnkPMMoP=BsNoXbWOSAch0OOmKg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] scsi: pm80xx: enable upper inbound, outbound queues
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        damien.lemoal@opensource.wdc.com, john.garry@huawei.com,
        Jinpu Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 8, 2022 at 10:05 AM Ajish Koshy <Ajish.Koshy@microchip.com> wrote:
>
> Executing driver on servers with more than 32 CPUs were faced with command
> timeouts. This is because we were not geting completions for commands
> submitted on IQ32 - IQ63.
>
> Set E64Q bit to enable upper inbound and outbound queues 32 to 63 in the
> MPI main configuration table.
>
> Added 500ms delay after successful MPI initialization as mentioned in
> controller datasheet.
>
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index cdb31679f419..71b6cc4b9420 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -766,6 +766,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity       = 0x01;
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt          = 0x01;
>
> +       /* Enable higher IQs and OQs, 32 to 63, bit 16 */
> +       if (pm8001_ha->max_q_num > 32)
> +               pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt |=
> +                                                       1 << 16;
>         /* Disable end to end CRC checking */
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
>
> @@ -1027,6 +1031,8 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
>         if (0x0000 != gst_len_mpistate)
>                 return -EBUSY;
>
> +       msleep(500);
> +
>         return 0;
>  }
>
> --
> 2.31.1
>
