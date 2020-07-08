Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE048C433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC8C4206E2
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:17:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="gM7AHVPe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgGHMRp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgGHMRo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:17:44 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B57C08C5DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:17:43 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id y10so50233371eje.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8s3hVkeJXRrqVzLJrXsBVtMK+GJ5/tfUWRczvsro23Y=;
        b=gM7AHVPez1nWNFGhMbSa3qWES9UryMt8FPQr0h0DAlWp3EYs1hqVW6ZrG0JhIOgbQr
         tzkkkbGNP+i6rLWUMq4VCN8aYrYendWmHZJrqDpLGyXxe9qh1CsCebVwFnast3ekz/9I
         SY0tt5l4unvXsXdDUdASuvSoRsGNaxx1ypz/6abUEgwIeMVgeJ9eONiL7oLS7mHsAp7B
         WX3dXJmkPmzn1lEn6g0+WU+4AsFtvaCJNr/CBjSlTx4g+03udR/XQdIJEDZRrb2/G23F
         9SxZUN7ItJ7Gdcscn0bBpPl4dO+uFOM6HO3Aovk6PGL2BoeupAwCOPCdxy6lscd/xYFE
         dB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8s3hVkeJXRrqVzLJrXsBVtMK+GJ5/tfUWRczvsro23Y=;
        b=KoZO1EpU8E1+CEIeDAeJu5FOGgW549DxqiNXv5XAPm01FTGRnOM4eeshhKXMvW8kv1
         gU3x6DYIWwwHaHYdxReI2t5Tx+o0K+l1FQxsM/uQXCkm0yWsfWr2RdgbajIwTo1y+bIt
         mJRB3DLV/4vpLqRsbVXe6FUQWm3y5KzM9m+jUR5I/8FYdLPSScTkWAEQMK90PqbyCjwO
         cZ9PScvfxPzXGi9xktLM9WEs9DCHwAGVX24LSA4PIv2GMIS/lRkqaqFtyRxqhUus5avd
         1BB8Pf2LYV5QFxJrU0cM6FhOtwHmn9RUskiiThxW9XfD/fynB7nykkwQzaBnK2fuGCg5
         GtwQ==
X-Gm-Message-State: AOAM531Chkn9juFoVk13IBAZAyGQyLBWDGyxmWfoL6icHYGkeG+qHKRa
        P8kW8sF5AbzAwhflPHHjcafR0912+au9JgweULizDw==
X-Google-Smtp-Source: ABdhPJwUaRb6MyfaY0ixa5ufAPvXOz8OxJhGWoNFarBGfcV2wZK47yHcG48etxaaxuxyHXDwrKtCaPoAdFDUyKoDaVA=
X-Received: by 2002:a17:906:e294:: with SMTP id gg20mr49897023ejb.521.1594210662221;
 Wed, 08 Jul 2020 05:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200708120221.3386672-1-lee.jones@linaro.org> <20200708120221.3386672-28-lee.jones@linaro.org>
In-Reply-To: <20200708120221.3386672-28-lee.jones@linaro.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 8 Jul 2020 14:17:31 +0200
Message-ID: <CAMGffE=v5sx=RsS9i7kNbgn9BbL6LQz2PO1fG2WkCj9P3cDHXQ@mail.gmail.com>
Subject: Re: [PATCH 27/30] scsi: pm8001: pm8001_init: Demote obvious misuse of
 kerneldoc and update others
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>,
        Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>,
        Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 8, 2020 at 2:03 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> More bitrot issues with function documentation not keeping up with API changes.
>
> Fixes the following W=1 kernel build warning(s):
>
>  drivers/scsi/pm8001/pm8001_init.c:64: warning: cannot understand function prototype: 'const struct pm8001_chip_info pm8001_chips[] = '
>  drivers/scsi/pm8001/pm8001_init.c:86: warning: cannot understand function prototype: 'struct scsi_host_template pm8001_sht = '
>  drivers/scsi/pm8001/pm8001_init.c:115: warning: cannot understand function prototype: 'struct sas_domain_function_template pm8001_transport_ops = '
>  drivers/scsi/pm8001/pm8001_init.c:212: warning: Function parameter or member 'irq' not described in 'pm8001_interrupt_handler_msix'
>  drivers/scsi/pm8001/pm8001_init.c:237: warning: Function parameter or member 'irq' not described in 'pm8001_interrupt_handler_intx'
>  drivers/scsi/pm8001/pm8001_init.c:265: warning: Function parameter or member 'ent' not described in 'pm8001_alloc'
>  drivers/scsi/pm8001/pm8001_init.c:624: warning: Function parameter or member 'pm8001_ha' not described in 'pm8001_init_sas_add'
>  drivers/scsi/pm8001/pm8001_init.c:624: warning: Excess function parameter 'chip_info' description in 'pm8001_init_sas_add'
>  drivers/scsi/pm8001/pm8001_init.c:900: warning: Function parameter or member 'pm8001_ha' not described in 'pm8001_setup_msix'
>  drivers/scsi/pm8001/pm8001_init.c:900: warning: Excess function parameter 'chip_info' description in 'pm8001_setup_msix'
>  drivers/scsi/pm8001/pm8001_init.c:900: warning: Excess function parameter 'irq_handler' description in 'pm8001_setup_msix'
>  drivers/scsi/pm8001/pm8001_init.c:981: warning: Function parameter or member 'pm8001_ha' not described in 'pm8001_request_irq'
>  drivers/scsi/pm8001/pm8001_init.c:981: warning: Excess function parameter 'chip_info' description in 'pm8001_request_irq'
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Cc: Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
> Cc: Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>
> Cc: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Thanks Lee,
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
