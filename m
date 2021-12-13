Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE61C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 12:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhLMMYW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 07:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhLMMYW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Dec 2021 07:24:22 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E322CC061574
        for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2021 04:24:21 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id iq11so11749218pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2021 04:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ekrnPRHrLftlhoBTlCEJVwtbo//rAs/3u/OFtBV1tEQ=;
        b=en0Pmq0rlrpk08BUiqUWxOgy2ofSZ7roz66DQXnBS9ttJ+uj+fLfLXNbetl0OxgqZl
         JRDPjwVsYq9CGwfs3GfAmIMvy+ZuqXMlnBR/vrr7YH6ZUabGBF/mxggAW1bioxflC0hl
         Sg3f6xLR1HRNqm6v9UnprCJFgewZ5MVtrXj+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ekrnPRHrLftlhoBTlCEJVwtbo//rAs/3u/OFtBV1tEQ=;
        b=GrfiTCzuUbrTja3LSlr7dL6AHSIVs7N9mr5qM+fB6r75daLIb2rUSRqzvlNS4b4LYW
         3RREbxE74uh5tmpQ14YR5WzqKBO+l/TQxzq7fnKy5+/QRTqvbLKxUiHa2ufrqdzZpcgx
         s4hyZ3osNmVIfjJiH4IwEI9aZMLgFG5SCnE+YdEsJYnmNUGS+8VMWK7puQfNTCXaPdhr
         /F+7/2B15hND+z6E1V/X2KME2QjcWtutzuBvxIpz/h0owTctHwNouCVVxxBYxY6LSgUD
         o/XhlUaOouD6NuM0JqLwAeQbjIaFyqaAAsIhdh9ovBvBvOtbJwPsAGCHuY4zesKYkHcn
         d4ig==
X-Gm-Message-State: AOAM530J6C/W6RuQJtR8+LhvZrRFkGqfFXZezS4EStUMpFt/NBUs41nX
        KY61jBnNVolczfXKVlHBUkFK6STf6axDqSeL7UEeWw==
X-Google-Smtp-Source: ABdhPJx1rArQEFg+RdfAXzmSe+VaAiCYbcSVvj05yVHi07KM7/4A79XDB51/nnqrBkYUoaUDmV/VERcuKckhJx0de3Q=
X-Received: by 2002:a17:90b:2290:: with SMTP id kx16mr43922503pjb.193.1639398261073;
 Mon, 13 Dec 2021 04:24:21 -0800 (PST)
MIME-Version: 1.0
References: <20210921184600.64427-1-kashyap.desai@broadcom.com>
 <20210921184600.64427-3-kashyap.desai@broadcom.com> <yq1h7dw6qsx.fsf@ca-mkp.ca.oracle.com>
 <9e544200d3c6e879ed1f655f0f1ab0db@mail.gmail.com> <yq1fssn16rp.fsf@ca-mkp.ca.oracle.com>
 <41d922ea207d661046d4febca5872aae@mail.gmail.com>
In-Reply-To: <41d922ea207d661046d4febca5872aae@mail.gmail.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Mon, 13 Dec 2021 17:53:54 +0530
Message-ID: <CAL2rwxrjm-kd3H1f0d3CakQNULgdbhwo2s=Cd1X4d3u+OnGYVA@mail.gmail.com>
Subject: Re: [mpi3mr] RE: [PATCH 2/7] miscdevice: adding support for MPI3MR_MINOR(243)
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steve Hagan <steve.hagan@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

We are working on adding bsg interface support in mpi3mr driver. In
bsg, we can use SG_IO command type for synchronous ioctls,
but I don't see the infrastructure for asynchronous commands. I
searched a bit around it and noticed that "poll" interface was
supported
earlier but removed through this patch-
https://www.spinics.net/lists/kernel/msg2853766.html

We have a requirement wherein the userland application/daemon
waits/listens for asynchronous driver/firmware events.
With driver IOCTLs, we were using the "fasync" interface for this. How
can we achieve the same with bsg interface ?

Thanks,
Sumit

On Fri, Oct 29, 2021 at 12:04 AM Kashyap Desai
<kashyap.desai@broadcom.com> wrote:
>
> >
> >
> > Kashyap,
> >
> > > Immediately dropping ioctl support will create lots of issues for
> > > Development/Test (within a org + OEM testing).  How about accepting
> > > updated ioctl patch-set after reviewed-by tag (which will not use
> > > static MAJOR number) for time being ?
> >
> > If we were to introduce an ioctl interface for mpi3mr we would never be
> able
> > to deprecate it without breaking existing applications.
>
> Martin -
>
> Understood that best case scenario is not to have IOCTL interface code at
> all in kernel tree (for new drivers), but we need this interface to be
> there for couple of
> months.
> As of now, There is only in-house application development happened on
> <mpi3mr> since product is under development and OEM has access to the h/w
> for pre-GA testing.
> We are also planning to document such interface change for those who wants
> to develop their own application in future.  Most of the application which
> need interopt check of ioctl vs bsg will be Broadcom in-house and we are
> planning to take care the same.
>
> How about providing unlocked_ioctl under module parameter  ?  By default
> parameter will be OFF (this will avoid interopt issue as you mentioned)
> and at least user who really have dependency on Test vehicle for time
> being can enable it.
> Once <bsg> interface is available, we will remove whole IOCTL code from
> tree.
>
>
> Kashyap
> >
> > While I appreciate that it is inconvenient to have to update your
> tooling, this is
> > the only chance we have to get the interface right.
> >
> > --
> > Martin K. Petersen    Oracle Linux Engineering
