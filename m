Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E5BC001B0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jul 2023 17:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjGCRZg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjGCRZf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2023 13:25:35 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A0EE59
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jul 2023 10:25:34 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4fb960b7c9dso7289064e87.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Jul 2023 10:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688405133; x=1690997133;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n4kUBRQrdx2CGWwKrDgL92ebtE5Gyg+bfTU+CSzkAt8=;
        b=fPvby7RWNhhWJ3wBolEnbdAotZ3JLJT78FZIvayG8/GVnG0STYphwavS30ktr3Nq5b
         UYgTdsN4ho/jKZRazJDccpfXyWDR1o+lN9Qr5VEXT2Sol4VnDFHo6UtoXzKIlSF3ulIx
         O5dl7aEo2+1fyBcIhvjngW+iZ2J6shc1hiBv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688405133; x=1690997133;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n4kUBRQrdx2CGWwKrDgL92ebtE5Gyg+bfTU+CSzkAt8=;
        b=D9z9uOgoDTqiV9LE0b7RdnO/J9PXN+u4aRd/g5RvizCKxddX8B6dbseZt7t6K9nkKI
         LU6Jqp14uFCUbh0hbQlFbXRLVKbFTYHxN+E7jla2wnpCN5pKGd4E7mjDnLlhbo7LMPTu
         XwUXdF5eY+aq16WTspL1Acl7ZDOrkUxr93x2I58+WxeQZwMV4aj2Aa6Xr9TYPYrvUUfN
         kLAwQt5XAzc57yD3R6sZoe4BnhXv6ab7oC5J0GKY1e5/sBpne8sHpGMef4ByzMX7rnAa
         IY1ekLszxHqrkSrp4Z7fou4yc2Mv0cB3dGHSq+WGNdnFqv3wuqJPb0H2CFFA3lYVYRik
         pUUg==
X-Gm-Message-State: ABy/qLYp3ZK2fNG/obv8+3HGvdEj+rzAlBZwgjk2QuEPvE727hWjQ3sK
        SGN3Hyssodo0gB5e8JKxAyt6sDwDeG76tzWjavc55jUp
X-Google-Smtp-Source: APBJJlHWQ3XbrkSCIQ4UZppg//0pKrGxlEroGFQfDvER2Nj+v5o8Kr+BPwol5+13c9pjbT9yvnyQNQ==
X-Received: by 2002:a19:4f10:0:b0:4f8:5dd2:21f5 with SMTP id d16-20020a194f10000000b004f85dd221f5mr6831886lfb.67.1688405132635;
        Mon, 03 Jul 2023 10:25:32 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id x13-20020ac2488d000000b004edc72be17csm2811378lfc.2.2023.07.03.10.25.32
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jul 2023 10:25:32 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2b69f958ef3so75552081fa.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Jul 2023 10:25:32 -0700 (PDT)
X-Received: by 2002:a2e:8955:0:b0:2b6:9b2e:e352 with SMTP id
 b21-20020a2e8955000000b002b69b2ee352mr7461069ljk.9.1688405131758; Mon, 03 Jul
 2023 10:25:31 -0700 (PDT)
MIME-Version: 1.0
References: <23bd2eafa9b9a23e4a8a96fc0180bba9e77e42ca.camel@HansenPartnership.com>
 <CAHk-=wjgnB11KzroXS+Gi1TQO19uf0FvkMBn=V7mcQ8q78ucnQ@mail.gmail.com> <69eeacda-d59c-bec8-d115-4bf7c97d7690@oracle.com>
In-Reply-To: <69eeacda-d59c-bec8-d115-4bf7c97d7690@oracle.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Jul 2023 10:25:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=whkqWU+OVkU5YM=X0rdF4wvcMynReCo+0fyD8ErMb51Sg@mail.gmail.com>
Message-ID: <CAHk-=whkqWU+OVkU5YM=X0rdF4wvcMynReCo+0fyD8ErMb51Sg@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 6.4+ merge window
To:     Mike Christie <michael.christie@oracle.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 3 Jul 2023 at 10:09, Mike Christie <michael.christie@oracle.com> wrote:
>
> Maybe name it persistent_reservation.c, or if people think that's too
> long does persistent_resv.c make sense since we use the "resv"
> abbreviation for reservation in nvme and the block layer.

Yeah, as a non-storage person, I really would prefer more informative names.

Maybe I'll never end up looking at that file again, and my one-time
conflict resolution reaction is really just that, but I do think that
we can afford the extra disk space.

Do people really end up typing that file name so much that the extra
keystrokes would matter (and if so - do you really not use
tab-completion? Is it just me that tab-completes pretty much every
filename I type?)

I did do a simple

    git ls-files | grep '/[a-z][a-z]\.[ch]$'

to see how common this kind of two-letter thing is, and  we do have a
ton of them (the test directory has single-letter "a.c" kind of files
too, but for testing that's fine).

Some of those two-letter things look fine: things like "mm", "fs",
"rw", "rx", "tx", and "io" are I think common enough in kernel
contexts that there is practically no real long-form version of them

And others seem to perhaps make sense within the context of individual
device drivers (ie there seem to be two-letter board revisions).

And then we have the ones that make me just go "Whaa". Like that
"pr.c". If I hadn't looked at it, I would have expected "pr" to be
shorthand for some kind of printing function (eg our "pr_warn()" etc
helpers).

Clearly it's not the only one.

           Linus
