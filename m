Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3711C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jun 2022 18:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237933AbiFUSb0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 14:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiFUSbZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 14:31:25 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA63023BF6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 11:31:24 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id n197so10795773qke.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 11:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0NlM4xJVC+aQrSrJgSgq0lw3fSCtXD7f9PJ3WEW+snY=;
        b=T9DeH1tdcsY6/y90jaWZn9sBSMreY/6fYy5JfAnBkqFhi8U06WJsRV1yPwPdRoZhmb
         t1a4+QBP4IugIjOrKvkbhvnH9bKSZ1y7mmOjw4hKFa/bBGbqZwC4BgHvdvDtBy6qWu/S
         G/nYqb9MGVjH5blyIZbYwbKnXO4jnyjP7Ek07TvvEabDEMRt8BIC6AgfPopzcjS3LkKp
         5KVuRpCLtCHJyyAtI0ngnM82eaeZDfY2P/nzySkK5Nw9/xwitBevsp0m/hT0YMNF2u0r
         utQSWGq8Av6erTGkUfrH5RYPeYpN7WIEvc2U9Ti+awbRtU9X0C2QVHJq9HBH9uOZBIAZ
         nHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0NlM4xJVC+aQrSrJgSgq0lw3fSCtXD7f9PJ3WEW+snY=;
        b=zPPFphR6HXJlfPUK1MnFxnAok076aHiH9ns5xHyfg6iAfinDERVgyLudBPFLBF+6dg
         cFMM18+QXxUDToQ6j0qiGP350wjaHP9UMqWXs85DfS6t+VKCJBgWawqdE2smEIZK0gIM
         yBmyUE9mtrI80OaZrTfmAksAIOjlCKTb63KDDLqASfWM9agukhWYIRHZMVBnTFNOZPAl
         ZWmXlwZ/z0BtPA7pUPauCpDEB3MKf7rX8N7csAWSwofyWF3Ho5zY76Ny6XUf/V3qAUkH
         1SXncCf3Ki28fOU18cE6dcI2q81Quv0TmyosfMLvGBY07Qg9xvE6pNe/QRprv5kdWnwa
         b09g==
X-Gm-Message-State: AJIora86X/09CNqGVi0g+TWsIIhgmju655VItarDkZy9ualbhN/c2ddI
        oPHKdk1rupVNMfjDfxeDHCUsjujKBdseJ7byoq0Ep+i+flkZ+IAg
X-Google-Smtp-Source: AGRyM1s0ZNh6AJMrXbJKR18iOitLzcO1NyUz0Tk/gIvDUtjovASPYxds/P0hzU4wYhaZ7pEJgWzg3R9X4kmRhOCq/HQ=
X-Received: by 2002:a05:620a:9c4:b0:6a6:9c07:c243 with SMTP id
 y4-20020a05620a09c400b006a69c07c243mr21511010qky.783.1655836283892; Tue, 21
 Jun 2022 11:31:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220620202602.2805912-1-changyuanl@google.com> <f21b7a51-ccb0-b8dc-a48e-94a7a0f7e125@acm.org>
In-Reply-To: <f21b7a51-ccb0-b8dc-a48e-94a7a0f7e125@acm.org>
From:   Changyuan Lyu <changyuanl@google.com>
Date:   Tue, 21 Jun 2022 11:30:48 -0700
Message-ID: <CAGzOjsqoZ3CoogdsN23tAMMSoGbqXvhSXSiQiMbCf8gTuxtwDQ@mail.gmail.com>
Subject: Re: [PATCH] trace: events: scsi: Print driver_tag and scheduler_tag
 in SCSI trace
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Rajat Jain <rajatja@google.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/20/2022 20:56, Bart Van Assche <bvanassche@acm.org> wrote:
> Despite the above comments, thanks for the detailed and very
> informative patch description.

Thanks for helping me improve the commit message. I fixed these
issues in v2.

Best,
Changyuan Lyu
