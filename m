Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40428C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 18:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 180DE24679
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 18:26:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="njedkY2J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLSS0T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 13:26:19 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:38833 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfLSS0T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 13:26:19 -0500
Received: by mail-vs1-f68.google.com with SMTP id v12so4374596vsv.5;
        Thu, 19 Dec 2019 10:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rFab9TFuVyy0B0hidssVyx0Ip53fX/LaEkCJxLNWYBA=;
        b=njedkY2JO/DXhybGjAgtuJQ3ELQtSyBbr4LtklvedJ40JfEyQUuq/88wWz760rpihi
         +QPs+7JUh2ExfDnz5RJ3yVQD2clbnAeeCYgLgYcuhXKFx/trbXWgVvIHtzuyiEmHwh8U
         umfPvRs60aCXka/6STVBQOfMateoMZaMcaQtstMCwwVW4Qyja8DM8evmAdjcWrmW/WlP
         W1o0SpPgU/y0ughI3pA5oqlSyOSguwQzm/lfh9fgPHYF6ItaxFmzBhBvMX3OCu3Ka2kh
         dDp42dc9BynBuc2KdnyZo+QZ8KUWSZpBqcdXmcy9G/UA52saC7UhjAhmdqSzAG1DVI8c
         SVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rFab9TFuVyy0B0hidssVyx0Ip53fX/LaEkCJxLNWYBA=;
        b=LhQ3EWdp3eqGjaWae8O394wIcS+Ip6r6AaIm0DxOfye0j9+DflJHoDkDFsjIOiFKMo
         mQ97JxPMQ+gODEllC8+qRtjgkqMypU1OzD2dy50E5/0474Y6gDcCJmi7PEQimv1UYxMz
         h9cHh8BrcuO8x0HRXbzObVKhHCKy7Oq1778ursxgvzrmZsLSqwI9TU1NqklhPHCUmGI0
         ZWJWrK3wbOZJg+5KSpDelm3ItWTmvo0TK7tx3dMWoOHnZaZ/fJazsNqJ4vB8oNzWTg1F
         BEn4NNUnJkgVd53ukb3n77qk2ayRteJpjdHkMNUBOaGNwCDOMrOi2axHUiK99K6pdSCG
         ySFg==
X-Gm-Message-State: APjAAAX6hyckeg96UhsW654zRQxlBt+Z8usAKmPhLLn1065Q9BceEZnT
        E00GI5ArFUsp/UHEiaQowbwExA9SJpw0SfFochhxNVS/OUg=
X-Google-Smtp-Source: APXvYqyLPE/PUdXmbPKj8EMXclPSXyJgYJpxajEIC9HQ1RfZo8Iy2l7Mc313mPx7rnQ5LEzufff/eY7Ua8VC1PyZ+ag=
X-Received: by 2002:a67:fb14:: with SMTP id d20mr5904491vsr.136.1576779977603;
 Thu, 19 Dec 2019 10:26:17 -0800 (PST)
MIME-Version: 1.0
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com> <1576224695-22657-4-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1576224695-22657-4-git-send-email-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Thu, 19 Dec 2019 23:55:41 +0530
Message-ID: <CAGOxZ50orn8JYxvCv4S6ziMdnB6+BG0DSdkand=x9Vw3H-Dejw@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] scsi: ufs-mediatek: configure customized
 auto-hibern8 timer
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 13, 2019 at 3:04 PM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> Configure customized auto-hibern8 timer in MediaTek Chipsets.
>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 690483c78212..71e2e0e4ea11 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -7,6 +7,7 @@
>   */
>
>  #include <linux/arm-smccc.h>
> +#include <linux/bitfield.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
>  #include <linux/phy/phy.h>
> @@ -300,6 +301,13 @@ static int ufs_mtk_post_link(struct ufs_hba *hba)
>         /* enable unipro clock gating feature */
>         ufs_mtk_cfg_unipro_cg(hba, true);
>
> +       /* configure auto-hibern8 timer to 10ms */
> +       if (ufshcd_is_auto_hibern8_supported(hba)) {
> +               ufshcd_auto_hibern8_update(hba,
> +                       FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, 10) |
> +                       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3));
> +       }
> +
>         return 0;
>  }
>
> --
> 2.18.0



-- 
Regards,
Alim
