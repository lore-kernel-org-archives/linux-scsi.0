Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4D8C25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 16:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjJZQ3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 12:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjJZQ3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 12:29:07 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480DF183;
        Thu, 26 Oct 2023 09:29:06 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1caa7597af9so8624105ad.1;
        Thu, 26 Oct 2023 09:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698337746; x=1698942546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lly9OjyG1WuwJev02hSJMW7JdqQD0L2vXqMu6PleNA0=;
        b=PhRxdCn6HmGQSpOWusHoJcq8KlJz5QYiAqunPPBje3Hz1SC4NPl56ch/vGiTgelY8X
         KldYz/YULbMv8Z0qRmO5Y5+Eb0/iXQjXKCv40QdAP5V+GLJLp7iJgc+xYi7uCYVPacYy
         QwrzwtHKvY036CrWf6BvGqmZicvVvkg+XavSAZV+fcWUXh7tGU2D2k9XYxciyQBFe2vi
         lO6nyfZORiql02eEW8acEaE3aXtL/W/yL9r48UENl04X/eKRdMac7AIHS/arCgxow70o
         gui4oIYIpriZJoF2+WqAxwwCJX8s11gIAHjWnrU7Nlyg4LHifrydmRspcpAgEBOA9DEi
         lRpQ==
X-Gm-Message-State: AOJu0YyHzhjoj3daJa/tWG0sSo6tbwi0R/mdEy/9mJ7rfqL6admLC/sX
        KL2jtkMU0Otlb8Sh+00tmJs=
X-Google-Smtp-Source: AGHT+IHVqWMDZ3Mm9hErO84KSp5efXY6apySMlcwBTmyLWa5ZpGeEpGqSZyL6vojKBaM2ftWF626NQ==
X-Received: by 2002:a17:902:c153:b0:1c9:fb8e:2c33 with SMTP id 19-20020a170902c15300b001c9fb8e2c33mr3712plj.7.1698337745550;
        Thu, 26 Oct 2023 09:29:05 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:4dcf:e974:e319:6ce8? ([2620:15c:211:201:4dcf:e974:e319:6ce8])
        by smtp.gmail.com with ESMTPSA id h17-20020a170902f7d100b001c0bf60ba5csm11299874plw.272.2023.10.26.09.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Oct 2023 09:29:04 -0700 (PDT)
Message-ID: <1e53e562-bec2-4261-a704-88d2a64111d3@acm.org>
Date:   Thu, 26 Oct 2023 09:29:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] Support disabling fair tag sharing
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
References: <20231023203643.3209592-1-bvanassche@acm.org>
 <ZTcr3AHr9l4sHRO2@fedora> <5d37f5ed-130a-4e75-b9a7-f77aeb4c7c89@acm.org>
 <ZThwdPaeAFmhp58L@fedora> <faf6f9e4-e1fe-4934-8fdf-84383f51e740@acm.org>
 <ZTmm0kNdN2Eka6V6@fedora>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZTmm0kNdN2Eka6V6@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/23 16:37, Ming Lei wrote:
> You are talking about multi-lun case, and your change does affect 
> multi-lun code path, but your test result doesn't cover multi-lun, is
> it enough?
I think that the results I shared are sufficient because these show the
worst possible performance impact of fair tag sharing. If there are two
active logical units and much more I/O is sent to one logical unit than
to the other, then the aggregate performance will be very close to what
I shared in a previous email.

> At least your patch shouldn't cause performance regression on
> multi-lun IO workloads, right?
If blk_mq_get_tag() can't allocate a tag, and if multiple threads are
waiting for a tag, the thread that called blk_mq_get_tag() first is
granted the first tag that is released. I think this guarantees fairness
if all requests have a similar latency. There will be some unfairness if
there are significant differences in latency per logical unit, e.g.
because all requests sent to one logical unit are small and because all
requests sent to another logical unit are large. Whether or not this
matters depends on the use case.

Thanks,

Bart.


