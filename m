Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68937C001DF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 07:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbjHBHX3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 03:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbjHBHXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 03:23:13 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCC91FEE
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 00:23:11 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-444c42f608aso2088399137.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2023 00:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690960990; x=1691565790;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LjQGGHRrLYlqJ6zgvLtJ9vmKtsKBQZ8R4xmR9XBEN8s=;
        b=UzSi6ZcrhwGtwEb1zHGf3GBVtoN39+XEvgLmIoTJVvZhe3zdoWTtdmYqq1bqhDFejA
         rAvUoV83Y6I8LTOvVuEOoNwr2dJnRtSXoHYdNQu4KPK8Mbpr9MjpXuQsFFi488TJj3tW
         qEPiU1y3KbXOO+k2AubsIPdtSDbomZ8SpaHzKzCS3iIj100vKp8T+tmBTfsbNiJmSUOj
         TApJfuMvu/KfwwTnHytbcSB7QQozPYk3go9YKIgQvpRx/RcMJLyNa0lRacKChmFWcIWp
         mkkHQFVSyWR+Yzr94SPR3KHVGysOus+CtxnXrhLtiX1AiLKVeKAG+TBw3J5qrNbBBJjw
         LBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690960990; x=1691565790;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LjQGGHRrLYlqJ6zgvLtJ9vmKtsKBQZ8R4xmR9XBEN8s=;
        b=KEAheFOHtmHQpg59SzlIbP7i9674iwf4JsqRioLAt8WYWDzKx18+LyTPDqla2PmR8W
         btl3TiDM1mGwki32Z5WlqyOW7l77wc+cwg+WPI7+muFg+a1Zu9G1ov8+FmPSPRgMlqJK
         dIVRX23vGZmUMPkInCYrDqpNFgof3djb0h3JMs+Y1wJPoQNgoKXxJgK5dDxG34jrMbzm
         ks5dl51/MWfWHSViiOFnrWRAncHGA0nM93W97v5B3gPKlQ/pJn22CQEaZPjbYnkWqkcd
         Ks35Wo22bPPT1K+69QmiYgkNG+KrWVofmWuo5wNP3P4NmgwbsJgRM7FLCL/uQuNnGlkh
         pG/w==
X-Gm-Message-State: ABy/qLa/AVg82AxCxeWGmOSF1HfJYmIE9KdxddwobciJK9/UYYoJ+BPe
        oMxAyFqrBmQonMO1xSCQykQjrPPWdKaucltdKTuFFQ==
X-Google-Smtp-Source: APBJJlFXUtjV/6SiiXt6EcNU0Vo+MmFO/Kw7ZAF0LsrV9nngYLTGV2hq39x2hHsRc0n0zWPbfeAmJKr8crPIQPpEWL8=
X-Received: by 2002:a05:6102:316a:b0:444:57aa:571 with SMTP id
 l10-20020a056102316a00b0044457aa0571mr4127175vsm.15.1690960990257; Wed, 02
 Aug 2023 00:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230801232204.1481902-1-bvanassche@acm.org> <1982f003-1c70-4f0b-8d66-d9e7420dbafd@app.fastmail.com>
In-Reply-To: <1982f003-1c70-4f0b-8d66-d9e7420dbafd@app.fastmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Aug 2023 12:52:59 +0530
Message-ID: <CA+G9fYsFqSCG=ZoT9Eo_b_PVPsj6dYxcv7Bi5aeSKReATGGNWw@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: Fix the build for gcc 9 and before
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Can Guo <quic_cang@quicinc.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Aug 2023 at 12:18, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Aug 2, 2023, at 01:21, Bart Van Assche wrote:
> > gcc compilers before version 10 cannot do constant-folding for sub-byte
> > bitfields. This makes the compiler layout tests fail. Hence skip the
> > layout checks for gcc 9 and before.
> >
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Cc: Nathan Chancellor <nathan@kernel.org>
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Would it be a good idea to provide a link to the original report ?
Link: https://lore.kernel.org/linux-scsi/CA+G9fYur8UJoUyTLJFVEJPh-15TJ7kbdD2q8xVz8a3fLjkxxVw@mail.gmail.com/

>
> Looks good to me, I gave it a quick spin with
> all versions from gcc-6 through gcc-10 to make sure this
> works for all of them.
>
> Tested-by: Arnd Bergmann <arnd@arndb.de>

--
Linaro LKFT
https://lkft.linaro.org
