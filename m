Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA13FC54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 15:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4A46206D7
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 15:21:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvuUUSeA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgDXPV4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 11:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726707AbgDXPVz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 11:21:55 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150FBC09B045
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 08:21:55 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w3so3852329plz.5
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 08:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kO8sCLdNuTQo4aB6ChhPB/ZDAvngFKRdYxYpbEBAaVE=;
        b=hvuUUSeAkttHLjLqYSi7zhyOd6zwI784kxYgQKnzE+RK7XNOlXzjL8F/0ifo9kK5tZ
         nQO48+zAQcLRx+rEDry7Q6Km0glkAIZGHoRUkjqqDd8PPl0gEwrlzL+s6IVacbwvFIfV
         o/DvhQd/8QoELQ/6QEjbrSkE84ZbTzEU/WVrPKOnBOndmNDzRq70KcmjfVpMaMoZeoFC
         ev5cHRamYXBiCDgBagv+hrIBP1nhQiVAaTEg3W8YSFOYVTPOSETncs70GQkr0szR8j6O
         66qeftVlCiMWdU2yyHboDr8Tu8W64b3L1wMlPqYOQoV+vZWFrM1trFK0J+yDfwqxnIXs
         1SVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kO8sCLdNuTQo4aB6ChhPB/ZDAvngFKRdYxYpbEBAaVE=;
        b=KcGzconFLcILcriT8wln6VhRTOnlbgAg79rs1kx49+vn07cCZOcT+gnWPxgiMBfqU1
         HUJt8LueXV1gYU0+NGiHKy0+eAT7VZkvCG17xjreKqUC7dPEJeohhJre7iuLW5Ri4k3b
         FiQXrrOVf9dGKtHEt/Y9oYUqT7IzCwp5JoXZ16socT8EkX8DF0MmZhDpYoC/tyg4z7S5
         w7C9ZYgi1Avi2cwKdqAol5pVhyjTWDe9PTSCXwd6Lfaz/xmIHLb+fEPFAXtea+6kec+n
         Td77q78tm7MGCqh1KVloel4LaxVwi80eRQZKOqoKMPTN5Gx0hDtP+qgjaH70av5bjCLF
         XLqQ==
X-Gm-Message-State: AGi0PubxjKj9JXMOxPMy0DDYnBUvFcP0YIiQ1JyrNwuQez5FOgK3VKNG
        VwX8guMpln2WNXJo2+5Dg5g=
X-Google-Smtp-Source: APiQypITEiXzGhFc0Cg4vGQ/TrKgTt5bfA+9j3WmXsKVvxf+Eecpdc/WSTEQPGPIve/o+YFdzjFYNg==
X-Received: by 2002:a17:90a:f2c6:: with SMTP id gt6mr6928794pjb.61.1587741714459;
        Fri, 24 Apr 2020 08:21:54 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u8sm5255398pgl.19.2020.04.24.08.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 08:21:53 -0700 (PDT)
Subject: Re: [PATCH v3 04/31] elx: libefc_sli: queue create/destroy/parse
 routines
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-5-jsmart2021@gmail.com>
 <20200415100445.qdmx34sekrsyjo7r@carbon>
 <a1837942-f6d8-a8bf-d6a6-c2d10ceb5e7e@gmail.com>
 <20200424072930.f3snaykeuycz3aly@beryllium.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <71c3842a-15d7-129b-2f8d-c650acdc311f@gmail.com>
Date:   Fri, 24 Apr 2020 08:21:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424072930.f3snaykeuycz3aly@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/2020 12:29 AM, Daniel Wagner wrote:
>>> Shouldn't this be q->n_posted++ ? Or is it garanteed n_posted is 0?
>>
>> yes - we post 1 at a time.
> 
> Sorry to ask again, but I worried that sli_mq_write() is called while there is
> work pending. Maybe it could at least documented with something like
> WARN_ON_ONCE(n_posted != 0)

Yes - I'm having us re-look at the q->n_posted field. n_posted is to be 
used as an accumulator for when consuming or posting multiple elements 
from/to a queue. As RQ and MQ are not doing multiples, it makes no sense 
to set the field to one. So the DB writes will just explicitly set the 
DB value and ignore the field. The only code then setting n_posted will 
be the code that actually uses it as an accumulator.  This should 
address your concerns.  We'll also look at whether the queue structure 
is actually defined well - meaning perhaps it should contain common 
definitions (used by all queues) and a union of per-queue-type structs - 
so it's very clear what things a queue-type accesses. Not sure what will 
look the cleanest in the end, but that's the thinking.

-- james


