Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=BAYES_50,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17877C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 23:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED41561139
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 23:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhDOXV1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 19:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbhDOXV0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 19:21:26 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603FEC061756
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 16:21:02 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id d5so16490620iof.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 16:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hxctX3csfjXBSZzsNsKLVb2KaTjba7NL/rcdzfPsR1Y=;
        b=rVr/Hv17zs6WRlTdESIbpqvo3giu9VYBx5IoJbYrOBW4Y6RUOKdgKsBJVUXEhzi9WZ
         Nc0yCc2+pRRJaR07ftk0rOzJ5KhbJRM9COWCZGnxssxqI+Mm4KcP61/tjKOIxhuXi2nb
         lftwqdQJ3s5Y2gckJ+BX5GmpOaOtZMe0HIKzp8VyXn1fJq9mfwdzo8CBT9WaRHJy3moI
         OREIScnWDIh6b1SJ0po2Mc+JxEqyoplNqwMa12TjPDMhPHBf0/AP1YtKC7Pql1D+u37q
         3OZtNH2Uu4HriwOP2kxTJ/e9B4tj7OKe1Nl8TlxdTBf1oAV8njOdXVN7+d0gCYwz00fh
         oWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hxctX3csfjXBSZzsNsKLVb2KaTjba7NL/rcdzfPsR1Y=;
        b=sG5lXLxuAhNNju9mhtm7GK0LH/BP+sUrHVYdEbQkiCxMJ9PzWauWBFsnM1ayxy/Or2
         u5sq0dL4hxgp15FHsGtJ7f9tg8pGErL/M9BnrX+y6o57oeTULFeijO5JaUIPtZ/PNc+R
         1B0t6b8vTzS0ic6oh/izCFOjnc6YnJSjJHfWdvhBgQkKuw6PQHPD+yXnkTfomMieDnJm
         Ja6MaX4dmZcUurCXdkdXOal3IkogRDjcAMm0dQPMe1Urwdow6bQHUqNvt/C1mRnXeTU4
         xkah0+7WxViHPn32u5B5KRiO4ObI7x+IfzmcJS0/9rd/LB44q1zsqTClCT2U2Ue9dXtD
         Qwcg==
X-Gm-Message-State: AOAM533odmE2SI2MaRk2WJu6MPzU8gcsqJvRZ/tM17LCcG9ONNqXrtQr
        6X38Il3NVk/uOA7XbPjQAhNKX9ZhQIq14/KWdFA=
X-Google-Smtp-Source: ABdhPJzydhiY1povAQmNC8gPy5cEjix2jEHIktzInjObXKP8bdw+Rhxm5SC5WD5ET9xb9EhPqeBI7Hw8ya48p3ZKwWA=
X-Received: by 2002:a05:6638:45:: with SMTP id a5mr1494942jap.64.1618528861461;
 Thu, 15 Apr 2021 16:21:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:55c4:0:0:0:0:0 with HTTP; Thu, 15 Apr 2021 16:21:01
 -0700 (PDT)
From:   Brad Wallwork <bradwworkk@gmail.com>
Date:   Thu, 15 Apr 2021 16:21:01 -0700
Message-ID: <CAGAFM7Q7kzvwva-OvWkeamrTNRRnML7FJvjD23FSDD=u5P3Yrw@mail.gmail.com>
Subject: Good Day
To:     linda@communitycaregivers.org, lingjuan.zhang@xmu.edu.cn,
        linjh66@163.com, link@xmu.edu.cn, linsc@xmu.edu.cn,
        linshaoting@xmu.edu.cn, linsun@zju.edu.cn,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linxf@xmu.edu.cn, liqinxi@xmu.edu.cn, liql@xmu.edu.cn,
        liqq@xmu.edu.cn, liqun@xmu.edu.cn, litang@zju.edu.cn,
        liudl2010@yahoo.com, liuzy809@yahoo.com.cn, lizhenxp@xmu.edu.cn,
        llniu@xmu.edu.cn, longwuye@xmu.edu.cn, lost.distance@yahoo.com,
        lqyang@xmu.edu.cn, lrmjj@126.com, lslong@xmu.edu.cn,
        lswang@xmu.edu.cn, luiginagraziosi@yahoo.it, lujianchen@xmu.edu.cn,
        lutingting@zju.edu.cn, luzhenchen@xmu.edu.cn, lxiao@xmu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,
Brad Wallwork. Can I trust you to be a partner?
Can you handle a lucrative Crude Oil business?
I have a business proposal that involves Crude Oil.
If interested please reply for more details.
bradwworkk@gmail.com
Brad Wallwork.
