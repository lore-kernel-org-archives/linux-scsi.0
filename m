Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34279C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 20:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F006161B04
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 20:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbhKSUoZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhKSUoY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:44:24 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B20BC061574
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 12:41:22 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z5so47637795edd.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 12:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kW7sHYnCDXVSXl0ZtMNxqf1s+pKMyQl4AuTpRTmx0XU=;
        b=bi0plf0WyPpGavgVfV1QtqquuqDxvZiT+Gg/aHjYLY5BLaUOV2UvSKYMgIOXximAXy
         26bRo51hTSr/jTXQ426IiRPXKxg3kgd2RfwZ487TXStcp8WkrBniONM7vfh0PMRMd34o
         ILXihqB3Fo0Ow6FApgF/I94GFarfizNVrWLew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kW7sHYnCDXVSXl0ZtMNxqf1s+pKMyQl4AuTpRTmx0XU=;
        b=Q6W6unCe/II1Jqlni+vns93mGLn2+HYRq6gAF3XKKLjIzl2PXtmTKtazfGJsE5zH6n
         u8bZEbj+CwsM3EbO2RznzqSecpGcSz5CRYqLe5O9ajPiEaNnH9ybqlKZHidfHeQZI2i8
         RwoJjZXssg1miewP17cAYECHKGiazp3MkWNP/wutM5/tIlEeQOvuSmKZZMHvjAI+UE5J
         qwlwBX66qSRekq91VfYFaD4db+UESZeMt19Uzx2TxOfc15vmqtdKVYyJVVNmI6ocX+FB
         7JgK45Sz1JYew0MgVJH0QYw/whZEdeJRHVwAi4FJWaWxVZr3Qi03+0N1gEDmC2T06Pt3
         oeFg==
X-Gm-Message-State: AOAM530iXrOwLZBiTsE1Y1qREXPltH7/zGi77miadhS8/a+D3ZA5RjKC
        4vDBwXOSmzFrsayEuGChHCdMsvWbJ35Xn2pd
X-Google-Smtp-Source: ABdhPJxgU08TbARqDcUmBAQilOmzzpZQR2rMX3egx0s610vSTfGRrwXoOmgvzPBXaGr31j0cI+9qHw==
X-Received: by 2002:a17:906:1558:: with SMTP id c24mr11794760ejd.553.1637354480603;
        Fri, 19 Nov 2021 12:41:20 -0800 (PST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com. [209.85.128.44])
        by smtp.gmail.com with ESMTPSA id hd15sm382173ejc.69.2021.11.19.12.41.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 12:41:20 -0800 (PST)
Received: by mail-wm1-f44.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so8427329wmd.1
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 12:41:19 -0800 (PST)
X-Received: by 2002:a05:600c:1914:: with SMTP id j20mr3304497wmq.26.1637354479681;
 Fri, 19 Nov 2021 12:41:19 -0800 (PST)
MIME-Version: 1.0
References: <0a508ff31bbfa9cd73c24713c54a29ac459e3254.camel@HansenPartnership.com>
 <CAHk-=wjiTXOy3EJ4Eb++umuCgiDufJxrNZ9Z17_NhdORKZGbSA@mail.gmail.com> <af4fd590c7b90e5b3eef13f2fcd0bbb500192d2a.camel@HansenPartnership.com>
In-Reply-To: <af4fd590c7b90e5b3eef13f2fcd0bbb500192d2a.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 19 Nov 2021 12:41:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=whgVp3m-HDiAPDAXAN0nTs+Fx3onnHE1XRg8cxPnmPw9Q@mail.gmail.com>
Message-ID: <CAHk-=whgVp3m-HDiAPDAXAN0nTs+Fx3onnHE1XRg8cxPnmPw9Q@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 5.16-rc1
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 19, 2021 at 12:07 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> I can certainly relate to the need to be clear and unambiguous, but
> this is the thin end of the wedge: you'll be telling me I can't use the
> subjunctive mood next just because Americans don't understand what it
> is ...

Please do strive to keep it to monosyllabic words, with the occasional
grunt for emphasis.

          Linus
