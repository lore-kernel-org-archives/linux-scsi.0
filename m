Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9D7C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72485610F9
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbhHTD6g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:58:36 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:33636 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbhHTD6g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 23:58:36 -0400
Received: by mail-pf1-f178.google.com with SMTP id w68so7453784pfd.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 20:57:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8M4hx0ALm2TLFkErCSdVv1zxrpP9ePvhx2WRkEuKURY=;
        b=DhCu90trmsEQHMSSz0EjTh0QsdUQFiF8ZUH/+r4Gv3Q1/F8oaISrzWLkvb9AGhl1G0
         O7CXqQvMjnhQdvpJbssyIDoECdnD48cSUsrYEoLwZSAj8x+gbGXYayXSVZxJrLtYbrk1
         05Kekbf0cjLcoRwkdNnO9GmjO0J2h/QArtdj0t0z3JqztDaH4/Z0lF7f3e8iPcAw6rST
         oUSxfPVj4SFTnMYpcsMtIdWSL4/gWhP2NbFFlsAwP89ZJxjIFSvI18jG1ekif2cSbn1y
         bjnz6q13j4J7QPqsxAa/w/lEsFryGpM2Dj2X5adWd23U+8qSZPf9EyTDdlUiTtzXMYwN
         fJFQ==
X-Gm-Message-State: AOAM531d7Jspqfs5ZL+zuCNMbDnkxhPZKOs8GMkP8XUXlwojmNeI+zFF
        ehqibCWJ4o80M7g5GM+4C2k=
X-Google-Smtp-Source: ABdhPJw6pWXAPyOhZi9wGkDh62DJNg2imlFhXUD101jfbyt2UBW6eblrHw7IyFj+6zL4VjVmXYVLMw==
X-Received: by 2002:a63:79c7:: with SMTP id u190mr16551729pgc.355.1629431878976;
        Thu, 19 Aug 2021 20:57:58 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:421c:f2b7:ca22:c5e0? ([2601:647:4000:d7:421c:f2b7:ca22:c5e0])
        by smtp.gmail.com with ESMTPSA id q21sm4555313pjg.55.2021.08.19.20.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 20:57:58 -0700 (PDT)
Subject: Re: [PATCH] scsi: fix scsi_mode_sense()
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20210819073750.132601-1-damien.lemoal@wdc.com>
 <54cc6af0-67c2-5427-9952-230a7fbf4a76@acm.org>
 <DM6PR04MB7081A8741C88E72990BAB2B0E7C19@DM6PR04MB7081.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6ef43642-fc0e-40f8-5fbe-881543367eb4@acm.org>
Date:   Thu, 19 Aug 2021 20:57:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB7081A8741C88E72990BAB2B0E7C19@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/19/21 7:25 PM, Damien Le Moal wrote:
> I would rather keep the argument as an int and add a check for
> "len > UINT16_MAX" to return an error (-EINVAL) rather than having the interface
> automatically cast/truncate len values that are too large. Doing so, buggy
> drivers will get back an error and can be fixed. With the change to uint16_t,
> errors may end up being hidden.
> 
> scsi_mode_select() has such check. And looking at that function, it also has
> problems with the buffer length max possible values as the added length of the
> header is not accounted for. I fixed that too in a different patch (not sent
> yet). Thoughts ?

Changing the argument type into uint16_t would make it possible for the
compiler to warn about integer truncation. The compiler probably would
only warn about truncation if the scsi_mode_sense() len argument is a
constant.

Anyway, I'm also fine with a runtime check for the len argument and
keeping its type.

Bart.
