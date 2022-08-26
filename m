Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CDFECAAA3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 17:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344317AbiHZRbq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 13:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244134AbiHZRbp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 13:31:45 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8370EDB06E
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 10:31:44 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m1so2930635edb.7
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 10:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Jme7uqqc6twTvBXYEnP6kaEZrCfdEsgOykmCLtXGQqQ=;
        b=cqn8OYgAgusLNPHbU9fDfjR9OHGrc1htGybhgrf3u8IJEBJOaU0/ceKFUnwpb/zB+E
         U0qrKqpxtNaJ2Ul3dpqZ9YHxZJvsHGbZZQANsomq+14hiAHBqLQ3DvSOElgzwdxSTuAM
         MPjiakXtex91wUcdaPqdsTaRK2qgDh6M5XOOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Jme7uqqc6twTvBXYEnP6kaEZrCfdEsgOykmCLtXGQqQ=;
        b=1G5c4IOAi7PaZeSlLn9XFrxMMil0A+o7+I9XVGCChrt/P4EH58yjBraZU9GDsmF5Na
         U7qgtIIdSS3Fe870DtYie128YqfPs5FvzaOzE+6y6n2bSpwovUaCS5DcjCb61uq9qTXE
         FnrxiYsiejAS0wvCvpN8SeCFie6Od6a+JUUvYguEoJjMZgmGSDnaVwgBkwrz+1aixKKs
         AxRQq5mJEqU98kshsgh7PHtrWGP51bzdcTrPBW8mSYUhIr5Cr33Owp54w31yLt5Wk+cd
         KuC/d7OqDx6dZUneOFLoruckR3VpiJU2elhlMhRsYZMPzfWBUjqVdKB9uDngLaoOVVfv
         Vi2g==
X-Gm-Message-State: ACgBeo2fgvjOrlpdUaA4bsjSKNFJxs5ER7669xRYLmq+Xrvf2D3KtzVg
        PLcp0Y3ogNDfu+tWcgO9GKdfkcl9fC+kJO9a3oY=
X-Google-Smtp-Source: AA6agR6fw0oansj3z+7CTuKy12cp7QOo0r27wI1hO1q36K+Q4ZC3Dj4y+JqXBubmvvDDOb1aYNKN4g==
X-Received: by 2002:a05:6402:369a:b0:43d:75c5:f16c with SMTP id ej26-20020a056402369a00b0043d75c5f16cmr7369906edb.57.1661535102514;
        Fri, 26 Aug 2022 10:31:42 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id gw20-20020a170906f15400b0073cc17cdb92sm1122954ejb.106.2022.08.26.10.31.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 10:31:41 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id i67-20020a1c3b46000000b003a7b6ae4eb2so11368wma.4
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 10:31:41 -0700 (PDT)
X-Received: by 2002:a05:600c:657:b0:3a5:e4e6:ee24 with SMTP id
 p23-20020a05600c065700b003a5e4e6ee24mr407390wmm.68.1661535101292; Fri, 26 Aug
 2022 10:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <042650172f59fca9836fe523ce14a07daccc4f2d.camel@HansenPartnership.com>
In-Reply-To: <042650172f59fca9836fe523ce14a07daccc4f2d.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 26 Aug 2022 10:31:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjcvDA+TtFGiFS1faAX9-sVK_jkMGC+0FX01U+hw9tgkA@mail.gmail.com>
Message-ID: <CAHk-=wjcvDA+TtFGiFS1faAX9-sVK_jkMGC+0FX01U+hw9tgkA@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 6.0-rc2
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 26, 2022 at 12:39 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> With full diff below.

Nothing there.

I assume you noticed that the full diff was unnecessarily big, but
left the notice..

               Linus
