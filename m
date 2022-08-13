Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29F1C19F2D
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Aug 2022 20:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239932AbiHMUsI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Aug 2022 16:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239878AbiHMUsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Aug 2022 16:48:08 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DD5B7ED
        for <linux-scsi@vger.kernel.org>; Sat, 13 Aug 2022 13:48:06 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b16so5135545edd.4
        for <linux-scsi@vger.kernel.org>; Sat, 13 Aug 2022 13:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8+24X1voRXl29E4Men41L011ucEXlLL6AMGFCSV5598=;
        b=Dooj+Rt0Wkp9Ypz84bBRTewTk2pQT9Tu5y7qW759b9Mtrc3SZ43E8XcW9aDFFOK5sZ
         sF4ncAxPj/SMoklJ1LEW21Su6HnBf+T0tr0XRCgnIXeHdVcRorK+6j+8vKktCEjAGyPw
         TPAteKxOIBm4xNNwhUeBUFLI4vPswYFE376ME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8+24X1voRXl29E4Men41L011ucEXlLL6AMGFCSV5598=;
        b=M9rlt/zTOsVUIcDHFofvRddtJO0GT01S7n1JJ1vuXjaLomGqHcISVjF9X+OI2j3AW5
         bBEv0dGbxIgucdiGlsyUIDASfAVaBf5xrCDhR4Y2NKXPVRFj65aAjqoQ4jtbijHoWx2/
         9gFtyumNAr8C0XdIZvnK3hfMX378flv7AaeIHbFfJXVbDqWEP56Td3FBy/P1N+/nrmW4
         IvQ2+I0OS4Z5YDJZ9sz4sYAO4H7la+AKuq1Y4q6IrOpLtPRHcAtvPHnzmQkvvVjKetd1
         HpHLQ1gQrUWkY7ZisjZcRlyXCc9ZmbfO35cs4x0JT3nkQVIx/OWJ7DJWjj8/oGaLRrAe
         IdNQ==
X-Gm-Message-State: ACgBeo3NfFc146FcsTQcNnGuApycDgy04RSShyWYdZ9EhYlg60jdYRRS
        e2+iTaIB2VOnr6Io2UMph3ZmZJes0pslJhLU
X-Google-Smtp-Source: AA6agR7qeIjFG799ZMpr2fzbSebk4GgJHRtyZgvBJQIC2c+BTC9YP4McrM9o5jCM8sDX3g/EOcmKkQ==
X-Received: by 2002:a05:6402:f17:b0:43e:4700:f63e with SMTP id i23-20020a0564020f1700b0043e4700f63emr8636658eda.190.1660423684456;
        Sat, 13 Aug 2022 13:48:04 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090676c300b00722e4bab163sm2255507ejn.200.2022.08.13.13.48.03
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Aug 2022 13:48:04 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id b4so1575823wrn.4
        for <linux-scsi@vger.kernel.org>; Sat, 13 Aug 2022 13:48:03 -0700 (PDT)
X-Received: by 2002:a05:6000:1888:b0:222:ca41:dc26 with SMTP id
 a8-20020a056000188800b00222ca41dc26mr4746439wri.442.1660423683645; Sat, 13
 Aug 2022 13:48:03 -0700 (PDT)
MIME-Version: 1.0
References: <62ef6e3d028a5182f4485d6201a126bbf4ca659c.camel@HansenPartnership.com>
In-Reply-To: <62ef6e3d028a5182f4485d6201a126bbf4ca659c.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 13 Aug 2022 13:47:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgeVWg=3sae6u__x2dhMzxw2-nyTTkxbQZfkDrueXGvTg@mail.gmail.com>
Message-ID: <CAHk-=wgeVWg=3sae6u__x2dhMzxw2-nyTTkxbQZfkDrueXGvTg@mail.gmail.com>
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.19+ merge window
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 13, 2022 at 5:55 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> [my key just expired so you'll need to do the dane update thing I
> showed you]

Oh, I don't care about expired keys at all. As long as you keep using
the *same* key, I'm happy, and gpg saying "Note: This key has
expired!" is something I'll happily ignore.

None of the technical rules of pgp keys make any sense at all. The
"sufficient trust" computations are completely pointless garbage with
the whole "marginal" vs "complete trust". It's all just crazy talk.

The expiry times likewise. I will completely ignore those.

I will check the signatures of a key as I import them. Because anybody
who thinks that "trust" is about automation is probably not human, or
so far on the spectrum that they don't understand humans.

              Linus
