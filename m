Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7DFC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE7B23AFE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgLHWro (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 17:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbgLHWro (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 17:47:44 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1769AC0613D6
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 14:47:04 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 4so100490plk.5
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 14:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NhoPWANOuKk74WKFMhZT6qq1p5q2Lo8ht3SDLB7i7r8=;
        b=vqG3vMEW30YVZkZ3EhpYrXQJPqrDz8uFRuNK8rsW5VbhyJNrLLjnQlQj752zlXRn6b
         sf7uM8ikLy+9cdeE86GdCCf+vA6H3d2qzpFEvcVhvNBmRj3wC3VPSMIKRltjB+UWokxm
         uKRgWZzRMB7GDbpDCcYuzsftrmdVLz1nxj24TAETvpHNx96kbNYlMEfXVLSIcWFOk2Lj
         mXacmgDd92ys9D/4TPewM9gfblhCL9lZoVU+rVsU6JLpZJ5GIjnw8a97vYkJmmghUoWW
         R4cOryf2iWw0fV2+efNufuUtQUY8k9k9DPoGBTWJ+g11HwB3jW1Nhk84wYrW6WaEAQzH
         XqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NhoPWANOuKk74WKFMhZT6qq1p5q2Lo8ht3SDLB7i7r8=;
        b=H+MOVITpve6r930HrmbZTfJdIQ10CBrY9l/GOGlJRiwjKeIV37HUFyTMvxCZAor7gq
         nS48A8rHiifql8Da3vfvGa1rPF+p093QWXLCBNzcUQpZsuHz7KxnuSGWy/jrrU93rZ0s
         0ytGuqN5AT1lsMvzTYkVYi8txRVzLtMvx9aEuCqWWy76lYn0rwqHunZ6bjWuHqx3cR2G
         cMho9YcRyCOytoMrUuFUe3FvowjkK5la29dQTrikhXzbXOKLhCzfwA6NvfEhk061W3MO
         zYQTO/0sBcCdcRbSN0RXiB1eXEiNYmeCAA4iYgIKEb/HGECON+oBAi+YMELVf2xcz+Zq
         Ewyw==
X-Gm-Message-State: AOAM5314LcyO66sQ73dKgGYPWcV8DW3z5Wj+gd1bDm+5KIS1HjM4c8ia
        C82i2t4tLplLMt8n+yHi47CHOQ==
X-Google-Smtp-Source: ABdhPJyTNwc9ppFYE5Krbe4DW1eOX3XMoDFJAurWfPSZUtamJFI1LgNhldLKQx43nqRXajRYEe4NeA==
X-Received: by 2002:a17:902:a9c1:b029:da:8227:65f7 with SMTP id b1-20020a170902a9c1b02900da822765f7mr221417plr.49.1607467623485;
        Tue, 08 Dec 2020 14:47:03 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b4sm192701pju.33.2020.12.08.14.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:47:02 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: problem booting 5.10
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
 <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
 <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com>
 <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
 <alpine.DEB.2.22.394.2012082339470.16458@hadrien>
Message-ID: <ca63ada5-76a6-dae9-e759-838386831f83@kernel.dk>
Date:   Tue, 8 Dec 2020 15:47:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.22.394.2012082339470.16458@hadrien>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 8, 2020 at 3:42 PM Julia Lawall <julia.lawall@inria.fr> wrote:
> On Tue, 8 Dec 2020, Linus Torvalds wrote:
>
> > On Tue, Dec 8, 2020 at 1:14 PM John Garry <john.garry@huawei.com> wrote:
> > >
> > > JFYI, About "scsi: megaraid_sas: Added support for shared host tagset
> > > for cpuhotplug", we did have an issue reported here already from Qian
> > > about a boot hang:
> >
> > Hmm. That does sound like it might be it.
> >
> > At this point, the patches from Ming Lei seem to be a riskier approach
> > than perhaps just reverting the megaraid_sas change?
> >
> > It looks like those patches are queued up for 5.11, and we could
> > re-apply the megaraid_sas change then?
> >
> > Jens, comments?
> >
> > And Julia - if it's that thing, then a
> >
> >     git revert 103fbf8e4020
> >
> > would be the thing to test.
>
> This solves the problem.  Starting from 5.10-rc7 and doing this
> revert, I get a kernel that boots.

Thanks for testing! Linus, do you just want to revert this, or do you
want me to queue it up?

-- 
Jens Axboe

