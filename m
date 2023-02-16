Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B824CC636CC
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Feb 2023 13:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBPNSP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Feb 2023 08:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjBPNSN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2023 08:18:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C236B57769
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2023 05:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676553423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MdGJFHZv/2Zv+Ysvuyq4SlJgM+0STJ7hRrwb8iOEyeY=;
        b=V/I6U1RbFQWTGEfQRDMNYBtc/aAu8CsqG4zOghaZby3UBNNb4iq4y487ABZXQEi4HYtzBA
        kSBlzxKhT2koc597YwkAeBr4o7xFkK+QndBTD2a09ZotZ8Gxo/mih4Pc1izQ4ZHuv4Srg3
        GBKMxkXfJPdBGMyr8U23DDTkkkw0VlY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-433-IgFubq8xPiaaPzyFzs46ZA-1; Thu, 16 Feb 2023 08:17:02 -0500
X-MC-Unique: IgFubq8xPiaaPzyFzs46ZA-1
Received: by mail-pg1-f197.google.com with SMTP id o63-20020a634142000000b004fc2619ca10so86950pga.8
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2023 05:17:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MdGJFHZv/2Zv+Ysvuyq4SlJgM+0STJ7hRrwb8iOEyeY=;
        b=ZRSflUYsihUXcNipBEq5NDs4asvFvCI5tPSsL/B5R0FUdRWES0ULPzkGxq512iFlrM
         cAfLr4x8bU3Fbgd52dWJdysg5myCMjPqgz7TDf9ATGvSfGUk2zLIpqxdz1MlrYfBLGqM
         9KReYH7YFvbIjqQ2E8oCnNSnLLIKt7H+zZaagW6yl27pOehPlcNONfTw/292Q/C0Cx6B
         JkdHfTNDSa9UNyYiuCXdceAqfT98KWF0Rp0lEf4GELcFvA9pBbjtrivf0rbwdKjXOnZ8
         ih2C7XEuxfmThAVldefzLa+BN+5ULHGvTnnR3Q1V4VbyhTDvBogTjRkHLVLLmGBpZgP1
         O3hg==
X-Gm-Message-State: AO0yUKWS5CtMgW7ExX6iKUtT/ISRH/UqAHxUW7SYvEgKB+jpSkhPHELy
        w8lLnIg1HPnqoYVwVxFmRJC1ZmTYcMsAdy+CVpZY1MyCKK2R3IEfy4mObs1TA/0Ajs/cFSpXIVU
        S6tQeyy1Z6rSdNsmhyJmu4yH+/5Qqy3hxWJVdFw==
X-Received: by 2002:a17:90b:17d2:b0:231:1364:4103 with SMTP id me18-20020a17090b17d200b0023113644103mr526606pjb.145.1676553421449;
        Thu, 16 Feb 2023 05:17:01 -0800 (PST)
X-Google-Smtp-Source: AK7set8OW6dHAP0HJaL/mr5kVLmWOT0BI1KzJZKOvZNe90BHNqSv+r18CcHwXHwbOm0nzZ0urvOJTWjxQt6N+tVCw/4=
X-Received: by 2002:a17:90b:17d2:b0:231:1364:4103 with SMTP id
 me18-20020a17090b17d200b0023113644103mr526602pjb.145.1676553421197; Thu, 16
 Feb 2023 05:17:01 -0800 (PST)
MIME-Version: 1.0
References: <CAHj4cs-jef8f4zxJQxjKirAWyZkTREycFdNPvQaGbgS-1r_Lcg@mail.gmail.com>
 <f4079ecb-f483-34f9-0074-b77a9bd36cb6@acm.org>
In-Reply-To: <f4079ecb-f483-34f9-0074-b77a9bd36cb6@acm.org>
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Thu, 16 Feb 2023 21:16:49 +0800
Message-ID: <CAHj4cs8WpKQbL-Yb3pRJk_n2B-QaTMmaCtBTcQGQYNnCWkan8g@mail.gmail.com>
Subject: Re: [bug report] WARNING at fs/proc/generic.c:376 proc_register+0x131/0x1c0
 observed with blktests scsi
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart
The original reproduced commit doesn't exists now, seems it was
changed due to the linux-block/for-next rebase.
I also tried the blktests scsi/ with the latest linux-block/for-next,
6.2.0-rc6 and 6.2.0-rc7 today, but with no luck to reproduce the issue
now

Thanks
Yi
On Wed, Feb 15, 2023 at 2:43 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 2/5/23 23:30, Yi Zhang wrote:
> > blktests scsi/ failed on the latest linux-block/for-next, pls help
> > check it, thanks.
>
> Please help with testing and/or reviewing the candidate fix that I
> posted
> (https://lore.kernel.org/linux-scsi/20230210205200.36973-1-bvanassche@acm.org/).
>
> Thanks,
>
> Bart.
>


-- 
Best Regards,
  Yi Zhang

