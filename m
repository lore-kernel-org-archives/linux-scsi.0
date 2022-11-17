Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D806C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 17:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbiKQR5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 12:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbiKQR5a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 12:57:30 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920217FF2C
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 09:57:29 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so2283963pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 09:57:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ux9UBAQGlzNlrcqOHxI/muVqIjfnHbFXJOTI7DucTX0=;
        b=hma2uirNtKL+j1cye8tVdarFBXY9CsWuk+muQAZGVlGPuw6TKmBD33U/XyxKP896wm
         6FajWzfQ+0pgG+mH2QeRm0X71CzlfeSliGCk34C/x/WaWvJsr9SkBSSJ+c1M3amABN2b
         VuWXiULxW1ryTWnbvZWZenZKGU76gCTx6jbhvzyPFAOMrDcQXrrEMIY1Q3mJvR41u+N5
         kDhxNN2DKEvnLR0zQJjacCvOkDF0tzxMVzcJxS1OappglWwOuSZi27x5LBZWf8LckrNs
         iritAzx/lcspnjNHA8XsckX6TO9CFHkTFdYtn7sjQqsGRmJJycryvPIeXJg703rBiPk/
         3MXQ==
X-Gm-Message-State: ANoB5pn9kXF5vbLNNPt9SNXmGscUMbHEC0hgvY2+b7jwZYknL19HPIGT
        0x6sUC5QvRuqKBeabNhMkjE=
X-Google-Smtp-Source: AA0mqf6Yr88tHQluM8rHEKnU3GwQdmdM9+ou995lMTgit9I3zuFFdA4gH5C3E2Hcon2JiahMiqQAEA==
X-Received: by 2002:a17:902:aa49:b0:188:f5de:890b with SMTP id c9-20020a170902aa4900b00188f5de890bmr2115316plr.110.1668707849006;
        Thu, 17 Nov 2022 09:57:29 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:7b21:f8f0:283b:9d21? ([2620:15c:211:201:7b21:f8f0:283b:9d21])
        by smtp.gmail.com with ESMTPSA id c1-20020a17090a674100b0020d45a155d9sm3776799pjm.35.2022.11.17.09.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 09:57:28 -0800 (PST)
Message-ID: <06a82972-75d6-b4cd-978b-29c10e4ca991@acm.org>
Date:   Thu, 17 Nov 2022 09:57:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] scsi: alua: Fix alua_rtpg_queue()
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>
References: <20221115224903.2325529-1-bvanassche@acm.org>
 <0efc9faa6dd519d1d402a08dbedd5cd7ed0de4f5.camel@suse.com>
 <feb72aeb-cd34-4cc0-0520-30e8a808a824@acm.org>
 <2063a6a55bbbccd43ccdde0c687e27e39362286c.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2063a6a55bbbccd43ccdde0c687e27e39362286c.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/22 23:03, Martin Wilck wrote:
> On Wed, 2022-11-16 at 13:22 -0800, Bart Van Assche wrote:
>> On 11/16/22 02:32, Martin Wilck wrote:
>>
>>
>> [...]
>>
>> Although I like the approach of this patch, how about the
>> implementation below?
>> I think the implementation below is a little cleaner but that might
>> be subjective ...
>>
> 
> Fine with me, absolutely, and indeed better than mine. I don't quite
> understand the last hook - sdev->handler_data isn't protected by rcu in
> any way, is it? But that doesn't matter much.

Hi Martin,

I plan to leave out the sdev->handler_data assignment change and to follow
the approach from your patch for the sdev->handler_data pointer (check
whether or not it is NULL) since I'm no longer sure that the change I
proposed is safe.

Thanks,

Bart.

