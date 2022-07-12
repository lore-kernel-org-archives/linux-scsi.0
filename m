Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877ABC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 06:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiGLG5n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 02:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiGLG5l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 02:57:41 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2F397485;
        Mon, 11 Jul 2022 23:57:40 -0700 (PDT)
Received: by mail-qk1-f169.google.com with SMTP id x17so5589427qkh.11;
        Mon, 11 Jul 2022 23:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3uLizQBOgw3ria9ktcfW+7uku2VEsdPuYJ1TFmbFXVM=;
        b=FNSQljt+XYfh1kkyz4xwlhhvEPQPAobQ0Tc/J0tpOOGIj/7IdH+myDK454OhWD+J4u
         Me2bvOi6AujlVXvMDDefSLXwnnfHZh0JDusHKcgwFua7asZmTzfYpGvGS/cMppVNb5PC
         ZM7FzSJbPnBcDFhsRi7UCv0X/iDQRDz7SHi/9jJgF88kKW1dBm08oKwCYxE7MXiBTTUt
         ApO2CwzGzPmZU5bNMlIz0OmFDnK62BFOuXd3pYOthwzG5nOAjVzH0FhULWNNLaI9G9xp
         SAgPXFll0S3uhGgLuRuOJ1uxB3zhWUvMlpD5K15EqC9iy7HqvJAl45C96Hu34lCSfzvt
         oV7Q==
X-Gm-Message-State: AJIora8Kgoyl6tNbprB6d6JZOQV37yZthtDBp9XsT8wes/Dq9bwsqJPk
        8BgElEaZCmr2tRN6B2lJ0AJA7EnFg+gD0w==
X-Google-Smtp-Source: AGRyM1seeApahIj0sjy2RmX9T8TnHb0hwKlNeKcBrv+PFgQ5Aiqi5cTFaJjVxtETj+5g/OeSbU0uqQ==
X-Received: by 2002:a37:620f:0:b0:6b5:7487:cc20 with SMTP id w15-20020a37620f000000b006b57487cc20mr9423568qkb.95.1657609059509;
        Mon, 11 Jul 2022 23:57:39 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id x13-20020a05620a258d00b006a8b6848556sm8540228qko.7.2022.07.11.23.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 23:57:39 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id r3so12445678ybr.6;
        Mon, 11 Jul 2022 23:57:39 -0700 (PDT)
X-Received: by 2002:a5b:6c1:0:b0:669:a7c3:4c33 with SMTP id
 r1-20020a5b06c1000000b00669a7c34c33mr20687151ybq.543.1657609058868; Mon, 11
 Jul 2022 23:57:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220709001019.11149-1-schmitzmic@gmail.com> <20220709001019.11149-4-schmitzmic@gmail.com>
 <CAK8P3a0FndsCkCrgXdai8=2oX5yWrMLArDHN5mA90AL4N7pmRw@mail.gmail.com>
 <CAMuHMdXapPSOBzSNTLy_RJV=RLq-6hcf-XFtvfSe-g=PrcAhEw@mail.gmail.com>
 <fb5f0f5d-e144-3f5b-9e46-6e22d8a3ca60@gmail.com> <CAMuHMdVYpQCVhti34y-bNwn-nOFaN7w-xM-SBZbHh+oDwbRndw@mail.gmail.com>
 <a4a3908a-29c5-fe2e-4c58-eed59133d39f@gmail.com> <f565782c-6463-d962-13ce-01c5f0d160e7@gmail.com>
In-Reply-To: <f565782c-6463-d962-13ce-01c5f0d160e7@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 12 Jul 2022 08:57:27 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXMvQ+c=zm8W2AFnSfqxHUGbDEBXNUYBYx1CXH7GTBGpg@mail.gmail.com>
Message-ID: <CAMuHMdXMvQ+c=zm8W2AFnSfqxHUGbDEBXNUYBYx1CXH7GTBGpg@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] scsi - convert mvme146_scsi.c to platform device
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,

On Tue, Jul 12, 2022 at 5:27 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> I just realized the commit message subject for this patch needs
> correcting. Will that mess up your workflow (assuming I retain the
> subject line for the announcement mail)?

Np, I'm used to editing subject lines all the time ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
