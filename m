Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F9CC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DE7D23B1F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgLHV0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgLHV0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:26:23 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31C3C0613D6
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 13:25:42 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id m19so360493lfb.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 13:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hAt6SR54pfO6r6IYwitLEIY1X0vGqJNiQs3ra1/Xs4I=;
        b=N3XcvG71up8pI7MNyZXvuWhjPZGymShTsiqNrSDaH/wJvGTfFOt9MdyHVSy8SHtQMJ
         YW8SfVvGRX1xIZGT3xTYidoIUPeU7QmbggBvhbB7/SXWeWhH+pNDSkZRtRYIvYMLTUl+
         U+b/c6y5qX3l+nOVC3pae7YGo3zpp3RBxZJws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hAt6SR54pfO6r6IYwitLEIY1X0vGqJNiQs3ra1/Xs4I=;
        b=G9PlQal7MbsqO9Ey/+0RuLsJw9jJqhRks1kFWbI8Z6dLCsAwqrmdNqtlaJ69UCbK+x
         OiL7Qks/Q+lQw0McrPLONRTA/kTgSPm4FpuiYhyW2ApOh2cM/Dcdhu+/0CYX0OqA0AJj
         E6P+jmdUlJ8HxAsVoUMNxVKf3EQp7fGjLmw+rnK1mMb2LtBUiwtB3IHbOvQJACowaGF0
         juUq6bjSxV+NQjurbe+xV98TX+g/QVKU7StnEy3myXj44QhnJVqSHvwX8i4t3h3+YJ5t
         wNpGv6gZlnJUbopNBlgQ9uj7kvgn4W1f2uZze1Jeq9DsFAv8cKhTDnC8e+rrtCbbsHzC
         be9g==
X-Gm-Message-State: AOAM530eVGc5R+qtxmTUzQIa6nB3YyUzbrhhkNTOB07JEBUZaCh12JN4
        qWPkBSV/HMd+9Dpmx7AXaJWf10muj5wVOQ==
X-Google-Smtp-Source: ABdhPJyp4keuN8B6H+8gnSEioenoyYhqKcoVP/FXqjw7Yw31gpR0iLOzXEeAP1XET5m1KVUMOmstRA==
X-Received: by 2002:a19:5050:: with SMTP id z16mr2480565lfj.48.1607462739762;
        Tue, 08 Dec 2020 13:25:39 -0800 (PST)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id u7sm1800lfu.244.2020.12.08.13.25.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:25:38 -0800 (PST)
Received: by mail-lj1-f170.google.com with SMTP id x23so15085077lji.7
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 13:25:38 -0800 (PST)
X-Received: by 2002:a2e:9d89:: with SMTP id c9mr1137779ljj.220.1607462738309;
 Tue, 08 Dec 2020 13:25:38 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
 <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com> <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com> <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 8 Dec 2020 13:25:21 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi=Xs6K7-Yj83yoGr=z5fTw+=MUHrLpFJZ0FOeHA2fjuA@mail.gmail.com>
Message-ID: <CAHk-=wi=Xs6K7-Yj83yoGr=z5fTw+=MUHrLpFJZ0FOeHA2fjuA@mail.gmail.com>
Subject: Re: problem booting 5.10
To:     John Garry <john.garry@huawei.com>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[ Just re-sending with Jens added back - he's been on a couple of the
emails, but wean't on this one. Sorry for the duplication ]

On Tue, Dec 8, 2020 at 1:23 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Dec 8, 2020 at 1:14 PM John Garry <john.garry@huawei.com> wrote:
> >
> > JFYI, About "scsi: megaraid_sas: Added support for shared host tagset
> > for cpuhotplug", we did have an issue reported here already from Qian
> > about a boot hang:
>
> Hmm. That does sound like it might be it.
>
> At this point, the patches from Ming Lei seem to be a riskier approach
> than perhaps just reverting the megaraid_sas change?
>
> It looks like those patches are queued up for 5.11, and we could
> re-apply the megaraid_sas change then?
>
> Jens, comments?
>
> And Julia - if it's that thing, then a
>
>     git revert 103fbf8e4020
>
> would be the thing to test.
>
>            Linus
