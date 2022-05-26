Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1514FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 26 May 2022 02:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344051AbiEZCSB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 22:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiEZCR6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 22:17:58 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDA5BC6C8
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 19:17:57 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id f21so400891ejh.11
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 19:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lV5zgCXHyqPoniN4egpc4ez8v2ywGktu+KT77l1Uk9w=;
        b=TWlmfSYO1gOTBu4bXnhrBzM1Rv9dK1/PZds8v/pKilDbkkFP21w0PVI58t7co3BHlF
         ShnTmtragg2Cx23Y2qLdT72mfuoDSuBYjJrJsDUEU7Vtde2CX1jBU9X4X3cgHbRlV4YI
         MLTPfTDlN5hV/rhUvSb/M5+0OjO3oa3jnaLnU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lV5zgCXHyqPoniN4egpc4ez8v2ywGktu+KT77l1Uk9w=;
        b=KRYKh2rhSBZOYAP07/tGOz4jvMLbQaCdVUAKLPtL6YVd130sngS6dli2MI81Xr0UTX
         +FzIOPl+1I99lvLT3VkeuIVy/z/jTJl/uXkH3zQe4INS7WbvTo4y1gsgijlmjEJ8pqTy
         Af71gOF+HUSj3JlQxHn9ljHXC1GPJgPmvaNjA8N3Y4vNXnh5xumbIPqLS8fQpTfp71Ws
         7XyakRwEO1ihmV4r36U+2X/xtRapOG7i6ZpLq4UreAN/QyKXBfmN7cTNB6asFMiTp+zr
         D12w719ulpAJNSqoosQdv7ZUhvUAs2/CG/fuH8ASRe+c+C38FW8xVHPLLcufL3pLLoPA
         0EjA==
X-Gm-Message-State: AOAM530U4NKcb8MJHaxGwc/DDoB1S6AAK81mMEhLOyCQB6MOpgRDr67l
        4RV0FSwB8Yq8uvHD2xy8mVMDJZ2LKcM0gvaKomM=
X-Google-Smtp-Source: ABdhPJyJX+YoHsujzWt2QOPHIC20Sfd23t4GEihyY7g7Nbi2J1fadwVTW6El7BVx+bbMAs1qfnP5LQ==
X-Received: by 2002:a17:907:2d90:b0:6fe:cf3c:ac97 with SMTP id gt16-20020a1709072d9000b006fecf3cac97mr18165933ejc.742.1653531475734;
        Wed, 25 May 2022 19:17:55 -0700 (PDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com. [209.85.128.44])
        by smtp.gmail.com with ESMTPSA id m4-20020a509984000000b0042ac2b71078sm134523edb.55.2022.05.25.19.17.55
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 19:17:55 -0700 (PDT)
Received: by mail-wm1-f44.google.com with SMTP id i82-20020a1c3b55000000b003974edd7c56so1781360wma.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 19:17:55 -0700 (PDT)
X-Received: by 2002:a05:600c:3d18:b0:397:6531:b585 with SMTP id
 bh24-20020a05600c3d1800b003976531b585mr104467wmb.38.1653531474740; Wed, 25
 May 2022 19:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <bd25414c73fae85529568c6f5b88bfdad6df7b97.camel@HansenPartnership.com>
In-Reply-To: <bd25414c73fae85529568c6f5b88bfdad6df7b97.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 25 May 2022 19:17:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh5SyuAox3QXvmJLwV4VgN_EK4oaAkh5-73FVf36ZdHog@mail.gmail.com>
Message-ID: <CAHk-=wh5SyuAox3QXvmJLwV4VgN_EK4oaAkh5-73FVf36ZdHog@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.18+ merge window
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 24, 2022 at 7:38 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Max Gurtovoy (3):
>       scsi: target: iscsi: Rename iscsi_session to iscsit_session
>       scsi: target: iscsi: Rename iscsi_conn to iscsit_conn
>       scsi: target: iscsi: Rename iscsi_cmd to iscsit_cmd

People, there really isn't some incredible drought of letters in the
world. It's ok to write out "target" instead of just "t".

Done is done, and renaming things further is probably not worth it,
but when the commit talks about "more readable code" I really don't
know if "struct iscsit_session" and friends is conducive to "more
readable". It looks more like line noise.

Yeah, it's less typing, and maybe "struct iscsi_target_session" would
have been too long. But still, I had to do a double-take when looking
at the diff, and aside from it being line noise, having a structure
name that differs by just one character in the middle between target
and initiator feels like mistake.

Anyway, pulled despite what feels like an oddity.

                Linus
