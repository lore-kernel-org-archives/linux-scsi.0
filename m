Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC2BC4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53CCF23AFD
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbgLHW5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 17:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728147AbgLHW51 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 17:57:27 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08933C061793
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 14:56:47 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id l11so758123lfg.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 14:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dp63dIdRcJ+RLwNco+dq+wSG9tRy12b3KCEuVvbzzL8=;
        b=LhNqYMYEDwYKbHkLZ330pI728saYOj9rxKzqq4j1aGuQmsKxAeEGqoVNujajZbkkmQ
         CRMFF7OWR2loXvYd7gVB2TcOB9g60xRH/EEhVLhSbBWqeao2CwGTCFuIpvf1aeYyl94K
         PmZNAPNRCemrWOyyf+xxHNkCZjddQnjYUHrLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dp63dIdRcJ+RLwNco+dq+wSG9tRy12b3KCEuVvbzzL8=;
        b=almcH2up6RgJCPHKrO59w2OIeu9ydkR3cJJl5dmNClwIWGWxYHgJlsKKjZ++DLieOb
         1EWe+8Vn1+DgyEh/UQpcDpII/NS54DSx7td4NE8RZ8bjwMJphJ6blFfcIq9ojrMT975d
         Ey5wazlaVww0IS+BYl/KafliKzVyJUg2vfQ5Kl3zw5T1iIH5RPfhX9AgBOqseXzcAYLR
         o66K2WsMnnK6lJjs1HriZ/0hzPW8eLxQl5o+3W6J8EaCiAVc0lCWgBXuy3EbR+rsNiCp
         8A2IvD8v2zjljkeL/lug0/CpMcxz1rC31ZdXllk52KQ6/R3LEY6CgfvTELvsRUFooZkJ
         0DBA==
X-Gm-Message-State: AOAM5315FuWSGqSL+Kxpx4fr5VSeCsrtICda6IFKaVlJnL8ojP+IG78N
        EBtHAelW7Ra3/L/QcwROdUc3PLbkLCN0Mw==
X-Google-Smtp-Source: ABdhPJwg3Xh/Xknp7xHKs2XbFdJkm/Q/v4xZ/PjRqm0kV4EZiayWEH/F22eiknnMo/3yWYIGNFJgkA==
X-Received: by 2002:a19:88c3:: with SMTP id k186mr1098395lfd.276.1607468203944;
        Tue, 08 Dec 2020 14:56:43 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id e20sm4129ljn.8.2020.12.08.14.56.43
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:56:43 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id 23so637713lfg.10
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 14:56:43 -0800 (PST)
X-Received: by 2002:ac2:4831:: with SMTP id 17mr11506247lft.487.1607468200941;
 Tue, 08 Dec 2020 14:56:40 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
 <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com> <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com> <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
 <alpine.DEB.2.22.394.2012082339470.16458@hadrien> <ca63ada5-76a6-dae9-e759-838386831f83@kernel.dk>
 <yq1mtynud0n.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1mtynud0n.fsf@ca-mkp.ca.oracle.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 8 Dec 2020 14:56:24 -0800
X-Gmail-Original-Message-ID: <CAHk-=whCChtPRmGZqZM8XeCAFhfRzX8ts4RFKeXgGUyuNtWGMQ@mail.gmail.com>
Message-ID: <CAHk-=whCChtPRmGZqZM8XeCAFhfRzX8ts4RFKeXgGUyuNtWGMQ@mail.gmail.com>
Subject: Re: problem booting 5.10
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Julia Lawall <julia.lawall@inria.fr>,
        John Garry <john.garry@huawei.com>,
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

On Tue, Dec 8, 2020 at 2:54 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Oh, I just realized the megaraid patch went in through block.

I'll take this as an "ack" for the revert, though ;)

          Linus
