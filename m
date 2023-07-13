Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E51C001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 19:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjGMTZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 15:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjGMTZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 15:25:10 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6282119
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 12:25:09 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-cb4de3bd997so1044256276.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 12:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mobile-mirkwood-net.20221208.gappssmtp.com; s=20221208; t=1689276308; x=1691868308;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+jpBKHIsnu6tGXVw8bPXz3C1VnKdtPaV/KaA+Asrevk=;
        b=p7ochAz/t8L/TAOCrmuNztpujIkuOe94Au64l/U6TOr3eTz9ts8xpuOqMd05Y/R6q8
         3hTj2Cqx2kzaTVAy+RGsx9IDwgPBtBZ3Ru+iHODgAVpKFNC1sKzpi7CHmlyVOakf43Nc
         nIcDG6fUbQr4lc6bY8CynQxXEMZHBJX1apTwLXv6Cz0oT6pxuh+FlV/HLQFNY0wvJDfW
         2kNMpodUk31n7OYOlELKCOHWPJgOm1NANAZyfMs3c0WPTGdV7J6G1nkTIaCQt31lasc7
         pCojFx8A6Sj7thsswir1CHWZ/puY5KIIcuFNwxwsamd+4TKGZfoTibNR6eodaD+okmyb
         JjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689276308; x=1691868308;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+jpBKHIsnu6tGXVw8bPXz3C1VnKdtPaV/KaA+Asrevk=;
        b=hxEEFQgP3ok3MlWM68J27qOKOykqlNI6JUzxm+fMm+Nbe55ElYCqDi96OkG6PZgMRx
         i2F+3GvjqyC1xZub43vdfM0CGoddAfhvmd2AqU1N6Amu9XLqHG4cviQbDWsYxu9UJKVZ
         n7xe7N86idQRQ3B6CR0L5tlWRW7sIrTQ1x8n9nTQbDqlmsJ7C0Zc67aN+eZgFUmU/Gg+
         1E7Bg7QQWpyQAZ/25SClLqO4FGz+XXj+h+jKHtpPsMwYFxPwTUWIK+GkP9TyRdX34IDV
         9RmymOZlNvpcxAwb3uasOshNc38y+Tzmw+g/XkqgejMpz1pn01GA3kTQYJr0LUygLkk0
         DRWA==
X-Gm-Message-State: ABy/qLZ1qWr2JJp1gt3+myDo8Jd0IP3YZ1fWRTxnW34+7HctF6VFK/os
        ke4OockZEZb/0rYCVYPfxqrJ/s5zhIfAQcAy/H4tYUhRhkr/JbYo
X-Google-Smtp-Source: APBJJlFwYX1uYWiNBztXAVQEtKeM3YHgUQH1LB2PeDQs2HI5FCpeyLTBd8pbjXJNTccHAmQE9E5cBupNCbkRFN448jA=
X-Received: by 2002:a0d:eb0d:0:b0:56c:f0c7:7d72 with SMTP id
 u13-20020a0deb0d000000b0056cf0c77d72mr634806ywe.4.1689276308594; Thu, 13 Jul
 2023 12:25:08 -0700 (PDT)
MIME-Version: 1.0
References: <CALM2zXUDAqAzCQR+sJDwoxxEEnG7cLJ4QazCVscJX-rR49=V2A@mail.gmail.com>
In-Reply-To: <CALM2zXUDAqAzCQR+sJDwoxxEEnG7cLJ4QazCVscJX-rR49=V2A@mail.gmail.com>
From:   Mike Edwards <medwards@mobile.mirkwood.net>
Date:   Thu, 13 Jul 2023 15:24:57 -0400
Message-ID: <CALM2zXV0JD=3WkEu-sTEFGjExQjMa_1TL2wRyDCVX=Ta2GL=-A@mail.gmail.com>
Subject: Re: Mylex AcceleRAID 170 + myrb/myrs causing crash
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Re-sending this as text/plain due to vger spam rules.

On Thu, Jul 13, 2023 at 3:21=E2=80=AFPM Mike Edwards
<medwards@mobile.mirkwood.net> wrote:
>
> I spun up an old machine (with an even older Mylex AcceleRAID card, the 1=
70 w/ a bios dated Jan 21, 2000 - yikes!) recently.  While this machine was=
 running an old 4.7 kernel and booted fine, attempting to update it to a mo=
dern release of Debian with a 6.1 kernel caused the kernel to hang while bo=
oting, with a number of stuck tasks warnings, starting with udev-worker and=
 including kworker kernel processes.
>
> During troubleshooting, I was able to identify the myrb/myrs drivers whic=
h replaced the old DAC960 driver (removed in commit 6956b956934f10c19eca2a1=
d44f50a3bee860531) as the culprit.  The last kernel to successfully boot on=
 here is 4.19.x, while anything newer exhibits the same stuck processes - a=
nd indeed, blacklisting the myrb and myrs drivers allows 6.1 to boot on thi=
s machine.
>
> I know this card is functional, as I do have two drives attached to it, a=
nd both it and the drives work fine in 4.19 and older kernels, so the issue=
 seems to be with the newer myrb/myrs drivers.  Is there a chance of fixing=
 the current drivers, or, at worst, reintroducing the old deprecated DAC960=
 driver back into the kernel?  I'm not absolutely tied to using that driver=
, other than 'it just works' for this card.
