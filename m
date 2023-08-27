Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B9BC83F01
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Aug 2023 14:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjH0OvA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Aug 2023 10:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjH0Oum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Aug 2023 10:50:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36C3139
        for <linux-scsi@vger.kernel.org>; Sun, 27 Aug 2023 07:50:39 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99c1f6f3884so292857866b.0
        for <linux-scsi@vger.kernel.org>; Sun, 27 Aug 2023 07:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693147838; x=1693752638;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Aur7k0McRiFXCUTD2gEOTvsFVl8EBmZX7s+nttC/DQI=;
        b=a6ELKFswxwSyE+EgI3MO3wA1KtAnk3QemRUwTI4gwwiVb2U3zO+TaDHl2ZDmvyC6rz
         24EwpRQv53W37rjYVuQGEMZBG5W06hIg4+ZtjlG2T5kSBHMopuISPklRrm8yTVugda/J
         bC7tXucAGHlA5goiZQTewNRpPsZF24u+8jMbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693147838; x=1693752638;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Aur7k0McRiFXCUTD2gEOTvsFVl8EBmZX7s+nttC/DQI=;
        b=fcVOHywnjJKlydLkxz+QQFcXu9pwvCRT+OP6awphOhdm4wrs3dbAF2hXj8d9xdaCIR
         EHvmgfbhcImNB/z72punOp3VBxaacDQTlsZYW7d58uT3yDwHQBLSrRjDvlupxvEnbcvZ
         dCzDbPavVuL4Pu2Jzu+x752WcGanSQaCmmr/Rpyzsh0P9A6orFt1scMSNbRdXbkU8IzY
         3cKM5impuEtcIqZe7LcnR8FAy/UeGuoQ25yhuuu1VGai0j2GMvrU4FDk9nFQbpq/0/JW
         a/OIKHSCnO9YosVqvS6b6Id/bzhdXhBRxdQJPuW9QsXsGB/Q5Z6g11gYsZ31OIr+wD9r
         Cb3w==
X-Gm-Message-State: AOJu0YyqEhfdoF1T/yYT1TX+WEP+pvvwaMm6hxQnmc4t9HqcGGkma/zi
        q4a3lnST/1noyKEcd1HebdHWzXodJEsopopHvQCSqg==
X-Google-Smtp-Source: AGHT+IHHtrLriUeyUmUEriYZZzw7D5yA6eMWLjvyAga97Wvh6SnYB9K7f/pfPxiQkMYDHS68DYPhlQ==
X-Received: by 2002:a17:907:a04a:b0:99c:4ea0:ed18 with SMTP id gz10-20020a170907a04a00b0099c4ea0ed18mr17013582ejc.8.1693147837874;
        Sun, 27 Aug 2023 07:50:37 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id jj26-20020a170907985a00b0099bd86f9248sm3500950ejc.63.2023.08.27.07.50.37
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Aug 2023 07:50:37 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-52a1132b685so3479640a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 27 Aug 2023 07:50:37 -0700 (PDT)
X-Received: by 2002:a17:906:10dc:b0:9a1:bf00:ae4e with SMTP id
 v28-20020a17090610dc00b009a1bf00ae4emr13151173ejv.54.1693147836857; Sun, 27
 Aug 2023 07:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <4fa74fe53f7a1302b1c4c7c4e17590aa97f9ecc5.camel@HansenPartnership.com>
In-Reply-To: <4fa74fe53f7a1302b1c4c7c4e17590aa97f9ecc5.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 27 Aug 2023 07:50:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi=D=y2z9YQkbMMQpHsCqZaM0x54E78UAbiNBf8FGVRig@mail.gmail.com>
Message-ID: <CAHk-=wi=D=y2z9YQkbMMQpHsCqZaM0x54E78UAbiNBf8FGVRig@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 6.5-rc7
To:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 27 Aug 2023 at 00:01, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

Hmm. For some reason the pr-tracker-bot is not tracking.

So here's a manual, non-robot, "has been merged" message.

Konstantin, is everything ok in robot-land?

                Linus
