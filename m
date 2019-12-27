Return-Path: <SRS0=4AUr=2R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A115C2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 01:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E40F020838
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 01:34:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hKSl9LsH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfL0BeX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 20:34:23 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:34052 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0BeX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 20:34:23 -0500
Received: by mail-vs1-f65.google.com with SMTP id g15so16143336vsf.1;
        Thu, 26 Dec 2019 17:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c2NZUOXB+u4N/6ynLgzIx+P3HGegc5/3CrzlQhhVkNg=;
        b=hKSl9LsHyLf6H23TKYquoRCv47amnB07IAyIWTFA9xS6edi3vbQWpcM2zU6pybyxEU
         dp+PpHmvMbMNCW2aOsz66YpRfNTAfNegZlNr5HVVZVFv5Fq6z27Z0chyKa1+aLB4q/2r
         GdVY2xhVnBRRh50DSgotuxalNVk9415GL1lhux1GUGgRHsF4hPxu1dBrDVVxx03+RUE/
         9+VGwm8yjt4qA1RSySKH+kcNmD8gq06d0ilNk9gUCN04JqE2a/r+wpP5olPyJtN21g52
         fa21lrcwK375iWKayzpmyVMMYtdIPJnP8I+HHhfhfE41ujSu7UOUhpd5lhOa3F9vlxQu
         8RIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c2NZUOXB+u4N/6ynLgzIx+P3HGegc5/3CrzlQhhVkNg=;
        b=piiK0e2OOjIHO8AVcV4t3GmgIguTvmhYgsAHEsNwbUc9dwTKsVlgIAHkQDrsRFY6uK
         hUBoyco6M8E3m++sLycZNfpH2KrmUfU+YxCB0HQoedxlPKvg2pTjXhbuggo2NLsZDhpP
         ZlSVfC1Sw8GiNOkMsqT9cH+w7rSMuBANBlD92l4ZNAet5eeU/ZEcnxppg69TpNDz8L6j
         tlCHGh/jKr6wc/KLPny3flOuUFqdlCcMK7l0zkaMBI+bPM59Mybg3t1z4b3IIxT4JPSu
         5ADbE+O08XdwkXmU5k+F6BaGYy00Dwg8oo+XGtjJWkptke0GwZaeSDWK6/sJJ4pqvCV/
         we8A==
X-Gm-Message-State: APjAAAVBb2u8rtrZxLeRhSlzRpEHO91UIbg10wUrVtFV0sx0UbIhd3N+
        7Ed1d87HLuhRqi7OTsgaVif/rzb1SbtcsuQBNdk=
X-Google-Smtp-Source: APXvYqyVeOGbvgWGe1iD9awj8wB/SgMSBPry9zyGE8kBSWztrseHrfYrKTMNOXiqV0LTSPsEceV4deRha4vbzTbFBjY=
X-Received: by 2002:a05:6102:3102:: with SMTP id e2mr27328735vsh.179.1577410461880;
 Thu, 26 Dec 2019 17:34:21 -0800 (PST)
MIME-Version: 1.0
References: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Fri, 27 Dec 2019 07:03:45 +0530
Message-ID: <CAGOxZ53wWCcJJpcO3BRDuOKS=gsNmYd=EjU3YEo+8z68iT+EiQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] scsi: ufs: use existed well-defined functions
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley

On Tue, Dec 24, 2019 at 6:31 PM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> Hi,
>
> This patchset fixes two small place to use existed well-defined functions to replace legacy statements.
>
> Stanley Chu (2):
>   scsi: ufs: unify scsi_block_requests usage
>   scsi: ufs: use ufshcd_vops_dbg_register_dump for vendor specific
>     dumps
>
>  drivers/scsi/ufs/ufshcd.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> --
For this series,
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

> 1.7.9.5



-- 
Regards,
Alim
