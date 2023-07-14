Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B290CEB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 15:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbjGNPeJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 11:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbjGNPeF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 11:34:05 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D1030FC
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 08:34:04 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-57722942374so19752587b3.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 08:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mobile-mirkwood-net.20221208.gappssmtp.com; s=20221208; t=1689348843; x=1691940843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2LAKb+st0am7KzOlE54nOwHEx22j8pSDF48Z20T+9p8=;
        b=nFZkRS8vMZLCEmK0QVk+u4CgaCkOqDCxQnj74z/EPcbZjc+BJUmntlBrZgqVd9YPd/
         ZQjk2dT3tEBlmYMENxiSdS4pAt6R0A/YsJXdhgvFIcKsJTuBKSjaLM518gp+ghYnFTXx
         GsNcZ/0uCJt71g0+6REhrdmuvtAvCuexKgf0WdUmiaSivgQHhdiMEfmksspm+GDgy7ci
         sLTybpRHVUU+q+B8cLYcfvEV0NbffCoQGI3bG3ECeUiGxZjAOXTSK56Prdy+eKMmiQtS
         p1JeORQUAiB8jBxbz5w6WjNTnqjlLoj64ICJd83RoXSgD9XAVXQPfI1xDSLMeVC5T8hr
         BhRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689348843; x=1691940843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2LAKb+st0am7KzOlE54nOwHEx22j8pSDF48Z20T+9p8=;
        b=DOHt7Dj1Z5rId0Ssox0IO67VAlciW/o9kH456BbsmT7gGVMHmMKVahLOI46XVta9qD
         Ym4Iq4D5xRRlRGwLyWArIzYgsGZPmsoof+7H/VWSJszpJB/DRwgRaNcoY+gLTC1cOVyh
         NNb2mRgV+arKuQNNsX6In2IkmtttpDmnC+yVK3zQNvl1kYrEkoRTRGG0TGthwuKbZpnW
         0F9hZXqEJ4TWa1BJ8Jw9QZzc2DHNplkcvieMz8krXY1upjdzWGVMFjBceHdL73QL11Uq
         rf3LlATa3Ai51VIO6tnGIy5aPKca6ovUsHgUxNZoaSAM+IHIqgDx8hIZmvxPUFY1QCq3
         eqIQ==
X-Gm-Message-State: ABy/qLYuIP2qxIMSR8tkk9icg9EH7LZ+m/hbxqEfLHILM0NXEaSEAtOR
        EWaPuwYLA6AvtnVXFqV96nm0D4FLKSeXW1tBu/qPINcDQmsT+eQs
X-Google-Smtp-Source: APBJJlEVnM96PdRp0EGe+Mddm/IBnp2jB0YNYvaG1E+xTUHZ7GmPf2zg2kCfRJIrhTH4INnonnk2OpVQNT3RAgEHqQ0=
X-Received: by 2002:a81:6c55:0:b0:57a:8ecb:11ad with SMTP id
 h82-20020a816c55000000b0057a8ecb11admr4695103ywc.43.1689348843228; Fri, 14
 Jul 2023 08:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <CALM2zXUDAqAzCQR+sJDwoxxEEnG7cLJ4QazCVscJX-rR49=V2A@mail.gmail.com>
 <fc9f01f1-deb2-cd05-c7ef-1e08ea1d8d60@suse.de> <CALM2zXX9LfshDUaFpKL5KURQy7p8J=5KpSi_foVaC1BfAB9sJg@mail.gmail.com>
 <4a0b76f5-9980-7976-bed1-801a98ecb7d8@suse.de>
In-Reply-To: <4a0b76f5-9980-7976-bed1-801a98ecb7d8@suse.de>
From:   Mike Edwards <medwards@mobile.mirkwood.net>
Date:   Fri, 14 Jul 2023 11:33:52 -0400
Message-ID: <CALM2zXUtZi8Q8NnZ4X0=93Haq7=2VOygb9ayj9iuD76KQEryeQ@mail.gmail.com>
Subject: Re: Mylex AcceleRAID 170 + myrb/myrs causing crash
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'll do some digging on dynamic debug, too, to see if I can figure that out=
.

Thanks again, Hannes - I'll try Leap in the next day or so and let you
know what I have from there.

On Fri, Jul 14, 2023 at 11:18=E2=80=AFAM Hannes Reinecke <hare@suse.de> wro=
te:
>
> On 7/14/23 17:03, Mike Edwards wrote:
> > I can try openSUSE Leap, certainly.
> >
> > However, those debugging statements are going to be hard - the process
> > lockup occurs at initial module load, before init really starts doing
> > much of anything.  I've even tried passing init=3D/bin/bash on the
> > commandline, with no luck - I never made it to a shell before things
> > went south.  For the same reason, there are no logs to speak of, alas
> > - but I can try seeing if I can get a serial console going, as that
> > will let me dump output.
> >
> > I'll verify that the driver in OpenSUSE Leap has the same issue, and
> > will open a bug report when it (almost certainly!) dies the same way.
> >
> You can try with the live system from the ISO image; that will load the
> modules only afterwards, so you should be able to see some messages there=
.
>
> And I think there is even a magic commandline sequence to enable dynamic
> debug...
>
> Cheers,
>
> Hannes
>
