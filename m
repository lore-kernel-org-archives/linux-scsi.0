Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9562C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 16:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87FD8611C2
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 16:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbhEQQwC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 12:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239779AbhEQQvo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 12:51:44 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F74C0753BE;
        Mon, 17 May 2021 09:40:01 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id b19-20020a05600c06d3b029014258a636e8so3978273wmn.2;
        Mon, 17 May 2021 09:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mJg/+7GYl1kUJvfa8nmmRMcNriQOvuN6MAq6Cn+ONao=;
        b=QljiQ+uaASZtSxfuEI8hK1tI3a4Y6o+6ZIacfUmOJb0k0fVi7Sqo0U56LxQQ9n0D7H
         OxzEbcNqyB3z1vQNEnR5Zrv17/IW60UCKTt0DkFBfAkpNKRBn3/qqDDNQHQ+gKicApoK
         IEUakbF//Mlmww+fZRhyglLfSqybZ2w6kt78ttIvat3UjfCgjAdZre8u2bdxxvh7b7Oh
         0OORdS0W6PfJcfoRcPXrwXLnXkv26W4BkQolDkROWbWxKCd0pVsI/yPSXNZS74FXWI36
         09YJ3c55dOmix4700cyb4PhvAdUTQWISqO7u6Nx5VlJSOoo6z2UJd6lpY5WpnMFD8J+Y
         H+Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mJg/+7GYl1kUJvfa8nmmRMcNriQOvuN6MAq6Cn+ONao=;
        b=Vo/pu0TVdinu+MW74Hmdb8aVTxfTJqaooxLF6M0yQZo88ZHS25J5/eD57NFFSd2/rd
         NP/l/KtvGGC0hOfZFmrRMpAPwHYZWffmDykvCBMt9sB9UOXiXdtJ5jFY7xJry/YqIftu
         1JwygOvgcK+QPEYVzh4IVo90zHgF1AYax71BwAkO95n9NerP2/73Z9xllJj+LWx2T07P
         jZP9W38ky0yICwOZph7sc4/GAA1KgrfosMO89xJJHMNmtmxQikc2sk0N3Pdygrq5Kbbe
         JAe2DrqqlNZUAXmkmXgHPEtZ03gwtegzXlblcI5QOYHlvIRiEvxD9dAjuuIyFBvhZ0oX
         6HcQ==
X-Gm-Message-State: AOAM530xjsRTLNFhkoKpEM0+A9pkqR+BpYrMOicE5xcdT33aq7aO1CKv
        oNwLsEV2W60ulwn8iolnfantfY1Ub0hwktZJ3qPRLC0vRWg=
X-Google-Smtp-Source: ABdhPJztcjSsj0J/JNFDHQf/JgaBAZUnQRFLtkWcpXIR+qh9ia6xfQrYTY+eZZzHSaCUmybr7ASuRfMEoFGty1cPlx0=
X-Received: by 2002:a1c:a442:: with SMTP id n63mr510553wme.25.1621269600181;
 Mon, 17 May 2021 09:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 17 May 2021 22:09:32 +0530
Message-ID: <CA+1E3rJO-HzZu5q+8ac1wxsnkGeST1epE8Ro00RNBAF340Dgeg@mail.gmail.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> * What we will discuss in the proposed session ?
> -----------------------------------------------------------------------
>
> I'd like to propose a session to go over this topic to understand :-
>
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?
>
> * Required Participants :-
> -----------------------------------------------------------------------
>
> I'd like to invite file system, block layer, and device drivers
> developers to:-
>
> 1. Share their opinion on the topic.
> 2. Share their experience and any other issues with [4].
> 3. Uncover additional details that are missing from this proposal.
>
I'd like to participate in discussion.
Hopefully we can get consensus on some elements (or discover new
issues) before Dec.
An async-interface (via io_uring) would be good to be discussed while
we are at it.


-- 
Kanchan
