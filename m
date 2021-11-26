Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9C6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 21:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237037AbhKZV1h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 16:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243757AbhKZVZh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 16:25:37 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1648C061746
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 13:21:45 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id l7so21071531lja.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 13:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=3LgDgmI1KFeqdtNiPTp3gFaVqYYsZqJfj9EoNDk9bTA=;
        b=Xndf0DzjSqm/4emyF93TLGzL2Y4grTI3Ie6l4pDV3cxt4RWlA0/vZ38yXjpytEWp5X
         fu4rtfgwThkT1ZaWTvD9jm6QZtHLrFcmNVXrIYYPxOxB7mV3OfkP8Zz1jJ3vD1TL1HQr
         vpNsORLHBeDp2hiZMCzgddEN52L2g3g73z1yGSAdqRPgZ5xR4TTzPP3NRkLdvBZ3ybqN
         1r9e+VLoNJ3aBPUjBodIpx5gepEU1e/zt0RDevZiCHoiLGvrWCUAd0wahBN5jAmTd9rj
         l7WPSftes5wY1jlCBS5tG1jXe3WUdg/dx6wLd0dwkXtGPrseVOUxpg+a+j5p3mj/MxLd
         JRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=3LgDgmI1KFeqdtNiPTp3gFaVqYYsZqJfj9EoNDk9bTA=;
        b=FzEfD0hxgZPLD2nSu5j0Rxv/DQzlJNrsiSZyyBWOKfRwJoerQdNUqA+7q5Ie4mF/Pr
         1tF8Qe2qRa64AwPXAQbQKbggL9dKqjr0DB0KozQIf9dfvI54ohYUFF8TgyZPJ9vrOXWl
         oJEmDT7VoxMLryoqlW8s3lAMO4Z+pYDLGwq5uD57DiOhDzrYsMQKlYHu/KZL5NT0Tjlh
         c6dy2/VRyILHM/3z1gdpo5Dlt/LsOybllWt1yOJAfl7ZoDoMGSxCbMyCmCv/xv9mZXpo
         ZQaCLG0QjoSb2ZI78cBLQ6z3JP8OSE/c7W7nhYIKtMHdrRjB5iKOaPvMNqNLC8Jkk/Rv
         af4w==
X-Gm-Message-State: AOAM531XuWfczKWQKJ1OuOjSKsqQ+C95GRAO6bIDSWUXTrNq127An6oZ
        gc+adV/ohGFgUoomToXzh69d19srDbT9vfLzYsJdQu3bexs=
X-Google-Smtp-Source: ABdhPJz4ZodUreeVZe1s7et6truSX/wjtPccL9u7oaQ+j5DjEOeH7VmDxNprlOA/rdewNt3HpQ3pY2T3OUZELze5UrI=
X-Received: by 2002:a2e:9718:: with SMTP id r24mr33840349lji.406.1637961704124;
 Fri, 26 Nov 2021 13:21:44 -0800 (PST)
MIME-Version: 1.0
References: <CAGnHSE=uOEiLUS=Sx5xhSVrx-7kvdriC=RZxuRasZaM2cLmDeQ@mail.gmail.com>
In-Reply-To: <CAGnHSE=uOEiLUS=Sx5xhSVrx-7kvdriC=RZxuRasZaM2cLmDeQ@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sat, 27 Nov 2021 05:21:33 +0800
Message-ID: <CAGnHSEmFoAS-ZY6u=ar=O0UU=FPgEuOx5KLcBWkboEVdeFXbGg@mail.gmail.com>
Subject: Re: [Regression][Stable] sd use scsi_mode_sense with invalid param
To:     linux-scsi@vger.kernel.org, damien.lemoal@wdc.com,
        martin.petersen@oracle.com, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ahh, looks like the required change to sd
(c749301ebee82eb5e97dec14b6ab31a4aabe37a6) has been added to upstream
but somehow got missed when 17b49bcbf8351d3dbe57204468ac34f033ed60bc
was pulled into stable...

On Sat, 27 Nov 2021 at 05:11, Tom Yan <tom.ty89@gmail.com> wrote:
>
> Hi,
>
> So with 17b49bcbf8351d3dbe57204468ac34f033ed60bc (upstream),
> scsi_mode_sense now returns -EINVAL if len < 8, yet in sd, the first mode
> sense attempted by sd_read_cache_type() is done with (first_)len being
> 4, which results in the failure of the attempt.
>
> Since the commit is merged into stable, my SATA drive (that has
> volatile write cache) is assumed to be a "write through" drive after I
> upgraded from 5.15.4 to 5.15.5, as libata sets use_10_for_ms to 1.
>
> Since sd does not (get to) determine which mode sense command to use,
> should scsi_mode_sense at least accept a special value 0 (which
> first_len would be set to), which is use to refers to the minimum len
> to use for mode sense 6 and 10 respectively (i.e. 4 or 8)?
>
> Regards,
> Tom
