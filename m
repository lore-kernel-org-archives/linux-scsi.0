Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E2FC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 05:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D91CF61058
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 05:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhG0FUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 01:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbhG0FUf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 01:20:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BB9C061757
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 22:20:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id j2so12831179edp.11
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 22:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SBSA2SN5q6MAcpYXi43NvELEKEyoXpwe1AtkOWTP7yI=;
        b=SYBOMGajk/7A1RMKh+HBgJknTIc0wje3qu1Aq0ZeoYQIri5RrW/eocWa9kyc6i1J+4
         EiDZUO3NLYwEzGNvTvZAR/lmEwAdkquP2BXnCf4rlu6B9Q5yryD5dL8AhyPU7xo9Q3BO
         A8/BltijA+NMsvuzF/5uqbIe2DqvAiMWQz0WCqiVMwkRlhoeOBTEwfHGFDDeHc3H0Q3w
         1IILqNWeRAGfF0LVLWeg/q5m9zzJfE9nJYl8IFundF78Ltwjgwaq6gVLa2D+XD6fgZ4F
         FCuG0lnMClTFxBvOtVyN48Is86FfWR4jj9fkjKa6ngmedhcTiDRHAzz//sbnaaRIWh5X
         UFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SBSA2SN5q6MAcpYXi43NvELEKEyoXpwe1AtkOWTP7yI=;
        b=Zd8Dqs9ayHZXYQN2oMHX/2Emm8LmhYS658HZX1I7BV6rro7qwhkZMc1o1WUfkKGmKQ
         ASjNZxC6P4FnnUGd915J6T4gYBEhd5/pqGh9kduZ5M+opOcn2vMW8ltgwIJY7cYZ4Ibe
         4prSzwN/cctmNXUOZWJTQcXLHJ8g2Q58upgl7o1TtQqJmwmgN4tKFKp34FOV2jRyi9sG
         xLYyD7Rjrd3qmr+6Uhyu7mm3cs9hOfYCpI/r4G+rWh/qQoOEO8fbro2ywSEXdsZowObR
         gSb3chV8JNP11m1tjMqeHZ3Kd10ZlP/5xhILTXW4f1i1h9RgL+BKEsAsjRtp9Tt9ChwU
         1spQ==
X-Gm-Message-State: AOAM530LuaRXYNFSgl8JQG6z8Q03tef19PyGvjuHXQU2ar7WE19Hfz8y
        71uvoNoU3Ib8wk1hYBEDj2BxW3hawagCQB1XEluB1Q==
X-Google-Smtp-Source: ABdhPJzDVF5f7k8vYnfAYihsivNEtBV7vxZKgLDQ6XB4l5ozldI8sijD1J5qwnaggwAJmZaujr3EDjlVAlC1h07oYr4=
X-Received: by 2002:aa7:c042:: with SMTP id k2mr24836427edo.104.1627363234154;
 Mon, 26 Jul 2021 22:20:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210707185945.35559-1-ipylypiv@google.com> <yq1pmv4qwbs.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1pmv4qwbs.fsf@ca-mkp.ca.oracle.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 27 Jul 2021 07:20:23 +0200
Message-ID: <CAMGffEnq40TeYys5kuBmQqx661LFbSTmUit8TBs=bacULp+KjA@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix tmf task completion race condition
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, Yu Zheng <yuuzheng@google.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin

On Tue, Jul 27, 2021 at 5:19 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Jack,
>
> > The tmf timeout timer may trigger at the same time when the response
> > from a controller is being handled. When this happens the sas task may
> > get freed before the response processing is finished.
> >
> > Fix this by calling complete() only when SAS_TASK_STATE_DONE is not set.
> >
> > Similar race condition was fixed in commit b90cd6f2b905
> > ("scsi: libsas: fix a race condition when smp task timeout")
>
> Please review. Thanks!
Sorry for the late reply, done.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
