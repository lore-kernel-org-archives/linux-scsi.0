Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68D3C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 14:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9264460FE7
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 14:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhGaOou (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Jul 2021 10:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhGaOot (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Jul 2021 10:44:49 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D486C0613D3
        for <linux-scsi@vger.kernel.org>; Sat, 31 Jul 2021 07:44:43 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j1so19346734pjv.3
        for <linux-scsi@vger.kernel.org>; Sat, 31 Jul 2021 07:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gapp-nthu-edu-tw.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vUu/An5wB7mKqjDMd75yR8XlG+aIbo0A8ZFdh1+yc+A=;
        b=ezuxOqu25SjG9tz+5Z7akhB9BboGO0rBA2GPIy3MFzQmHk4LMAfvt1weRsu4l2uN3H
         2juUX735KauvYZ0BJ2w3q/KyWSbPNZ1CJYuiHFiq5UM5SsdGy1DkZjz8+xo5S9gk1oM+
         ZgUN90DdLUBFXLy5CrYP40tQS88yzrldEhncsEsYQDKq+H21vUUgJzzUPNM9EwApOmYa
         /8oCP6YnvGx9ZSz2DBJa0uw1Cn9F91vuDfX1l7jvMtJneM0mzJ64DjXL/Z8eI4BG+PR+
         y1V2feBhgU103CMZ5cOSEDXQjeyDdHBcHCxQIkRnwKgIl3JU+FYeZ/wfbT4Soc86pcgZ
         9FZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vUu/An5wB7mKqjDMd75yR8XlG+aIbo0A8ZFdh1+yc+A=;
        b=M3rdWV9KnN/py79g5PQY29YtmYLIYgaoeLE7IgH1g0EEptWY3MT1+AtDEExxPdMMOK
         BRVd1BahcDniYKToAbAVGXX7XpGcuFnjATwEb7C7fHbhDGGID9xnotI7EXtL1OdhDVsp
         Yhv4setFaOhXoJ49br/8O7CNWadg2YXqy4lchaW5B1fvGXr6S/huj/bSLFx9em33I2XL
         QoqQ+EmovI1zx0zXLCUaXg+XAh+B3AJ3+pP9V/67MFg/o+9LxrD1pa/ZmV20ktra/f9v
         xpmtTXbdrMOKkvWl/NpDqEIRwYRjMsNDLfvq35rh6niafgNeVMryAomyxsxx87j54fxX
         6c7w==
X-Gm-Message-State: AOAM532S9/DRbylagh/X9u3bfzPZeaRqbzW2u2WwsWfw+as/+qfxPW/r
        saScBDnKPemc8WzxwcReJEokCTeohpGnTa68f1B1uA==
X-Google-Smtp-Source: ABdhPJyaM9nXDTpolqS541wHVh/30k6cn1ziMrEGHeoLFPS5IsudeDrOScND+LQvAJa+3icVzVbehDcrWugnWXpIg2o=
X-Received: by 2002:a63:5908:: with SMTP id n8mr1762766pgb.202.1627742682542;
 Sat, 31 Jul 2021 07:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210722033439.26550-1-bvanassche@acm.org> <20210722033439.26550-3-bvanassche@acm.org>
In-Reply-To: <20210722033439.26550-3-bvanassche@acm.org>
From:   Stanley Chu <chu.stanley@gapp.nthu.edu.tw>
Date:   Sat, 31 Jul 2021 22:44:31 +0800
Message-ID: <CAOBeenZgzmm-oBhiwJXXBrtBQ=vbTGv8He56c6m6u=zJ5yHXpg@mail.gmail.com>
Subject: Re: [PATCH v3 02/18] scsi: ufs: Reduce power management code duplication
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Yue Hu <huyue2@yulong.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Phillip Potter <phil@philpotter.co.uk>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Keoseong Park <keosung.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> Move the dev_get_drvdata() calls into the ufshcd_{system,runtime}_*()
> functions. Remove ufshcd_runtime_idle() since it is empty. This patch
> does not change any functionality.
>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
