Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049A5C07E95
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 22:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B9461416
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 22:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhGBWtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 18:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbhGBWth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 18:49:37 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DA3C061764
        for <linux-scsi@vger.kernel.org>; Fri,  2 Jul 2021 15:47:04 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id d25so15375625lji.7
        for <linux-scsi@vger.kernel.org>; Fri, 02 Jul 2021 15:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i96gpHGmTqGyzL1pRnwYPnBFinTz4+ocAC93WptRIao=;
        b=hp1aHE8ygjAGHlmTsQeB3xMJAGF+yLnZeuFihIhiI5Bc0Bb1qlcnAU2lE6/h8MXc4Z
         Z+9940FafwWiyXs2NhVd9WoxXmtmwvH4iCtbYSH9fV5b5cfh27i3NRTYi+e+wUuHVdLV
         vJsVZLg1nx9Z20Qatfa5yOWxl41UD9//VJcXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i96gpHGmTqGyzL1pRnwYPnBFinTz4+ocAC93WptRIao=;
        b=TTkmttsIiYz/OMXUxk2tarTIzv6I2XVtTH3h7fjd+7aZ0xX8G5n8Q1oXqINUnLog9H
         I09Ecxf6pKeobNRaoGouHC3HkZn388fePDm7+832DuERd7xCr97VfZGi9+XDkHt2Qz3v
         zw9busqD9PUBDzTP3xuga3C7GeHOcADfYIFmDwIo9Yi+YgbhqxMrXKE41E0bvdLxYHso
         329HT1zzI7vUg7m1ltWdphevRk8d/GZlNgGy+c/M5A1wdl4v2IBj9LMZ/Qfk687Hjk9I
         /tB0PDXvsoByTT/SaOI7Xtm1d0MBgImOgdAm60ds1C+6SMcjuNOJq2MI3hczoVGGxytV
         zlbw==
X-Gm-Message-State: AOAM532v8fCIeS4HDpriP9VNuki1eMmhTDR5VEhFf9f0/dxZsFV1kO1z
        41aUMUgl8Mi40nwJlfCIejEUYBS87BCm8zPsZvk=
X-Google-Smtp-Source: ABdhPJyOEfGu7uqN07J70o5BRi+F8GaVQn4r1ttA3MgaXYZJSwuHgubIbTCa8CUN2S1YabanZ1fdtQ==
X-Received: by 2002:a05:651c:2042:: with SMTP id t2mr1245075ljo.439.1625266022504;
        Fri, 02 Jul 2021 15:47:02 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id t18sm392762lfk.54.2021.07.02.15.47.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 15:47:02 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id x20so15417845ljc.5
        for <linux-scsi@vger.kernel.org>; Fri, 02 Jul 2021 15:47:01 -0700 (PDT)
X-Received: by 2002:a2e:b553:: with SMTP id a19mr1260817ljn.507.1625266021672;
 Fri, 02 Jul 2021 15:47:01 -0700 (PDT)
MIME-Version: 1.0
References: <e118d4b2fb924156f791564483336e7125276c47.camel@HansenPartnership.com>
In-Reply-To: <e118d4b2fb924156f791564483336e7125276c47.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jul 2021 15:46:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiErhCUj8tGjcZS9mA7Efnv4JO1aMg06GfSqL8nacG4xA@mail.gmail.com>
Message-ID: <CAHk-=wiErhCUj8tGjcZS9mA7Efnv4JO1aMg06GfSqL8nacG4xA@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.13+ merge window
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 2, 2021 at 1:11 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> This series consists of the usual driver updates (ufs, ibmvfc,
> megaraid_sas, lpfc, elx, mpi3mr, qedi, iscsi, storvsc, mpt3sas) with
> elx and mpi3mr being new drivers.  The major core change is a rework to
> drop the status byte handling macros and the old bit shifted
> definitions and the rest of the updates are minor fixes.

Grr. I noticed this too late.

Why do we have that

        default y

for "config FC_APPID".

That makes absolutely zero sense to me. Not only don't we do "default
y" for new features _anyway_, but something like this is certainly
much too specialized to warrant it.

To make matters worse, it actually asks for this stupid thing *TWICE*.
Even if you say no the first time, it will then later on ask about
BLK_CGROUP_FC_APPID, and if you make the mistake to say 'y' on that
second try to push this feature, that will then do a "select FC_APPID"
to turn it on.

So honestly, it feels like

 (a) the "default y" is just completely wrong in all ways

 (b) this "config FC_APPID" shouldn't be a question AT ALL

IOW, it should likely purely be enabled by that 'select' for people
who decide they want BLK_CGROUP_FC_APPID (which properly defaults to
'n').

Pls advise. Or just send me a patch to fix it. Because the current
situation is most definitely not ok.

            Linus
