Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCBDC4727F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 663A122211
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="CygWg92z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgIYGNY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 02:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbgIYGNY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2020 02:13:24 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340D9C0613CE
        for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2020 23:13:24 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gx22so2036936ejb.5
        for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2020 23:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=53X+coXl7kKDVnVNpNiO9aqzNp3GazC3Z9ubEeWoDxI=;
        b=CygWg92z3VzNe+nDaLxTQP1MS8fMF6AqNquqXl1GJpVkioRddVqbLZe/jfYSr0OoIK
         vGe0Q48olMNwigTiUd0P5QBy8OB6X/by19Az+1h7HFYjkqHU59t3Buk+cXyOv2Rw9h5b
         l2X1AGI3H9CDOyGniB/0t/U+glWcS7NFj2QHet1xg7P9USPimAOMfsxTfEcahUMNe10r
         UZ0uUzRRL9U811xW7BYa6FSpURHMsg3zB4IGaOjDhF4bU8QrUhcRYlU/8I6xOV1P/gKs
         rJQXE6VwVYPXfY+Zo98pQ8UPTznHQ87QzepdeFUx+ilTXeuBYhwLPtNlrO+6I6crTa4h
         13CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=53X+coXl7kKDVnVNpNiO9aqzNp3GazC3Z9ubEeWoDxI=;
        b=Hzv1XSCarWx7RM91ZgycLO6GS2KlZPqL3ybkR9BjZv5y7eiitE7ratbCS/YrzZ8ZYS
         zu2pCOwpJVuHKilWrhRVe79hV0WepG7ULp9lJUzijAnh7RgpK0eKAwnDZ2DJKs42JKN/
         jcUtwZ4lInqrS9VwcwBeuj+79LOpvVTY7O3wrGjCxBBatLHiPWy6I2yd0HEQA0C4XBD/
         1xpi9ZB+lEXgfm8POGQoXyvdnuRubir2eRTjixpADX8Wo6pkB9qzxs8J8rKAFD0Lqc84
         HGak8bZambMaAg5xXxVT3MrTF08NS/O9Hyl6XcgrRHQmCk4UIOO9SKRdFIljLr2fb0v/
         80Jg==
X-Gm-Message-State: AOAM533mmvGyOTCXuuYWQo+bRk3UbbshAOfSM0XuqQy09GT5XbM777wQ
        40zI7YkpXdsvCMw2G4nDY9FOcWPa6Nw9KWJLOpcX/UacofNQkBJk
X-Google-Smtp-Source: ABdhPJwyOycQBVCuwazf/WQVL+FL0RsZZa2WCufey/q+cM8hqB5NZ/uMSOTrWkLbVDKEcblgONvcUVPhhcGhoiVqh4g=
X-Received: by 2002:a17:906:8c1:: with SMTP id o1mr1213889eje.478.1601014402804;
 Thu, 24 Sep 2020 23:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200925061605.31628-1-Viswas.G@microchip.com.com>
In-Reply-To: <20200925061605.31628-1-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 25 Sep 2020 08:13:11 +0200
Message-ID: <CAMGffEmyy7-kKL35qY5Ei1BW=L8cXb2qegb8x9=1xgO2-PD7Vw@mail.gmail.com>
Subject: Re: [PATCH 0/4] pm80xx updates
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Viswas,
On Fri, Sep 25, 2020 at 8:06 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: Viswas G <Viswas.G@microchip.com>
>
> This patch set includes some enhancements in pm80xx driver.
Thanks for the patches. the first and 3rd one, seems to be performance
improvement,
can you share your performance number?


>
> Viswas G (4):
>   pm80xx : Increase number of supported queues.
>   pm80xx : Remove DMA memory allocation for ccb and device structures.
>   pm80xx : Increase the number of outstanding IO supported to 1024.
>   pm80xx : Driver version update
Thanks
>
>  drivers/scsi/pm8001/pm8001_ctl.c  |   6 +-
>  drivers/scsi/pm8001/pm8001_defs.h |  27 +++--
>  drivers/scsi/pm8001/pm8001_hwi.c  |  38 +++----
>  drivers/scsi/pm8001/pm8001_init.c | 220 ++++++++++++++++++++++++++------------
>  drivers/scsi/pm8001/pm8001_sas.h  |  15 ++-
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 109 ++++++++++---------
>  6 files changed, 253 insertions(+), 162 deletions(-)
>
> --
> 2.16.3
>
