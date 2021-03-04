Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39BAC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6232A64F2D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbhCDJyj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbhCDJya (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:54:30 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67709C061756
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:53:50 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id c10so21645011ejx.9
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ugRBwM9gJLad1zr51OTw4cYfsieSlu5IQWtZrKEHGZo=;
        b=P4UXZElxC7FR8hbUmh5nKKoxPmEbLhw+1vymP1zTF0Ze1+snWE0ZtnF3b9TjLyNl8C
         /6F8yAE+M1IRu7dEf4qRleL9rNDTRzXxdnFLoU5fqDdg7dqo7ae79iXU7Jx848dyot1J
         U1S61dd85jn9V/OLUhGuClroVGxXcCXj6kvpmONcuvqGcFVBjhLXNxeHbyheLTzttOEA
         hd3/C2k58j/09ePRirZyvT6HDJsdK8f1hmDfK8k61PvGJPuw/jvrKGWlv8yttPs8xAM8
         pAWe0I6SWXLbRfbU2sARTVKFATnDIQ12yp0CiMmL7ejm17Z60NDfO1n0a+uIIF+R8HYr
         10Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ugRBwM9gJLad1zr51OTw4cYfsieSlu5IQWtZrKEHGZo=;
        b=PnLhIFUSBWKLNjPeyfbMbIUwuSnu/g0zuXrKx+emAYBBdLZ7LYyBmjKLCaBQ0ACgVL
         ISk/UoIqjwWMlyFxsboX2POkEtXjJTgGuD2qrbajJM6RN7Nno35+n0IJUcbkw+fPh/ae
         IIZkXW3TwWwRKz3QveqvDxwdyB8Yd/ruao5QRwJHn4R7Y+KEn8YhaynCXmiNL1LfftjY
         2tORyt/ofpXsPMLGMbC80NibisfH6lSztdW1N3i6KUoraz2GDddXpTLEurMXZ5uoMePH
         4K6pvG3Rm1DnXyPI0DR4uprpKpnEldR4eLDo+CUxvsXaYzo/Vt5MfkwDlZ0cTvlIAg25
         a+Nw==
X-Gm-Message-State: AOAM531j5C9b/j2uCuMn0ItSdTBdqYi4ZVfUbYT4na3SxLZ2f/8M0nyn
        aLYoQqRddVK2+M43lww6tFuSidh+2xwXIW+p2X9LWQ==
X-Google-Smtp-Source: ABdhPJzwN+5nAIY776KqrS7O2Kj9hbFeOWWOvbjcDhO+EKShcukA95wTe/rNp6QzE9cy8o+SBy2zuQ8VVXZ9RsszEzw=
X-Received: by 2002:a17:906:d18e:: with SMTP id c14mr3199851ejz.62.1614851629202;
 Thu, 04 Mar 2021 01:53:49 -0800 (PST)
MIME-Version: 1.0
References: <20210303144631.3175331-1-lee.jones@linaro.org> <20210303144631.3175331-23-lee.jones@linaro.org>
In-Reply-To: <20210303144631.3175331-23-lee.jones@linaro.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:53:38 +0100
Message-ID: <CAMGffEm8aK-D0pn-ED9pAuaE2X-eY3E2sTHQGg1-socM=RGz9g@mail.gmail.com>
Subject: Re: [PATCH 22/30] scsi: pm8001: pm80xx_hwi: Fix a bunch of doc-rotted
 function headers
To:     Lee Jones <lee.jones@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 3, 2021 at 3:47 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> Fixes the following W=1 kernel build warning(s):
>
>  drivers/scsi/pm8001/pm80xx_hwi.c:1427: warning: expecting prototype for pm8001_chip_init(). Prototype was for pm80xx_chip_init() instead
>  drivers/scsi/pm8001/pm80xx_hwi.c:1584: warning: expecting prototype for pm8001_chip_soft_rst(). Prototype was for pm80xx_chip_soft_rst() instead
>  drivers/scsi/pm8001/pm80xx_hwi.c:1711: warning: expecting prototype for pm8001_chip_interrupt_enable(). Prototype was for pm80xx_chip_intx_interrupt_enable() instead
>  drivers/scsi/pm8001/pm80xx_hwi.c:1722: warning: expecting prototype for pm8001_chip_intx_interrupt_disable(). Prototype was for pm80xx_chip_intx_interrupt_disable() instead
>  drivers/scsi/pm8001/pm80xx_hwi.c:1733: warning: expecting prototype for pm8001_chip_interrupt_enable(). Prototype was for pm80xx_chip_interrupt_enable() instead
>  drivers/scsi/pm8001/pm80xx_hwi.c:1752: warning: expecting prototype for pm8001_chip_interrupt_disable(). Prototype was for pm80xx_chip_interrupt_disable() instead
>  drivers/scsi/pm8001/pm80xx_hwi.c:4192: warning: expecting prototype for pm8001_chip_smp_req(). Prototype was for pm80xx_chip_smp_req() instead
>  drivers/scsi/pm8001/pm80xx_hwi.c:4775: warning: expecting prototype for pm8001_chip_phy_stop_req(). Prototype was for pm80xx_chip_phy_stop_req() instead
>  drivers/scsi/pm8001/pm80xx_hwi.c:4907: warning: expecting prototype for pm8001_chip_isr(). Prototype was for pm80xx_chip_isr() instead
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 84315560e8e1a..74ed072209f47 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1420,7 +1420,7 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
>  }
>
>  /**
> - * pm8001_chip_init - the main init function that initialize whole PM8001 chip.
> + * pm80xx_chip_init - the main init function that initialize whole PM8001 chip.
>   * @pm8001_ha: our hba card information
>   */
>  static int pm80xx_chip_init(struct pm8001_hba_info *pm8001_ha)
> @@ -1574,7 +1574,7 @@ pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha)
>  }
>
>  /**
> - * pm8001_chip_soft_rst - soft reset the PM8001 chip, so that the clear all
> + * pm80xx_chip_soft_rst - soft reset the PM8001 chip, so that the clear all
>   * the FW register status to the originated status.
>   * @pm8001_ha: our hba card information
>   */
> @@ -1703,7 +1703,7 @@ static void pm80xx_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
>  }
>
>  /**
> - * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
> + * pm80xx_chip_intx_interrupt_enable - enable PM8001 chip interrupt
>   * @pm8001_ha: our hba card information
>   */
>  static void
> @@ -1714,7 +1714,7 @@ pm80xx_chip_intx_interrupt_enable(struct pm8001_hba_info *pm8001_ha)
>  }
>
>  /**
> - * pm8001_chip_intx_interrupt_disable- disable PM8001 chip interrupt
> + * pm80xx_chip_intx_interrupt_disable - disable PM8001 chip interrupt
>   * @pm8001_ha: our hba card information
>   */
>  static void
> @@ -1724,7 +1724,7 @@ pm80xx_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
>  }
>
>  /**
> - * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
> + * pm80xx_chip_interrupt_enable - enable PM8001 chip interrupt
>   * @pm8001_ha: our hba card information
>   * @vec: interrupt number to enable
>   */
> @@ -1743,7 +1743,7 @@ pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  }
>
>  /**
> - * pm8001_chip_interrupt_disable- disable PM8001 chip interrupt
> + * pm80xx_chip_interrupt_disable - disable PM8001 chip interrupt
>   * @pm8001_ha: our hba card information
>   * @vec: interrupt number to disable
>   */
> @@ -4183,7 +4183,7 @@ static void build_smp_cmd(u32 deviceID, __le32 hTag,
>  }
>
>  /**
> - * pm8001_chip_smp_req - send a SMP task to FW
> + * pm80xx_chip_smp_req - send a SMP task to FW
>   * @pm8001_ha: our hba card information.
>   * @ccb: the ccb information this request used.
>   */
> @@ -4766,7 +4766,7 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
>  }
>
>  /**
> - * pm8001_chip_phy_stop_req - start phy via PHY_STOP COMMAND
> + * pm80xx_chip_phy_stop_req - start phy via PHY_STOP COMMAND
>   * @pm8001_ha: our hba card information.
>   * @phy_id: the phy id which we wanted to start up.
>   */
> @@ -4898,7 +4898,7 @@ static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
>  }
>
>  /**
> - * pm8001_chip_isr - PM8001 isr handler.
> + * pm80xx_chip_isr - PM8001 isr handler.
>   * @pm8001_ha: our hba card information.
>   * @vec: irq number.
>   */
> --
> 2.27.0
>
