Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD65FC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 15:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F173611BD
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 15:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346171AbhESPs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 11:48:28 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:41929 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhESPs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 11:48:28 -0400
Received: by mail-pf1-f175.google.com with SMTP id s19so7927662pfe.8
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 08:47:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4gEZiKQftCOg1HI3Tpq7Nhcoru/iYMV7u3iMCRVZ/Ik=;
        b=DklryJomH+m2v+7PwTTe0T/2S5uS07vnneuprhZVV9DCGlNxpT/DEUN0QTq2cWcGKi
         U5wdMq6nIRfw2UmpqumyhYJHSrGD/m36Z4+C+QpXX0pzdHxVjOb5WsJfJuS1HsDuSfqg
         GdU/Mq9plvA8uZOYSHYZKVuLoGKKrSluAvNkM+aFdDaepSaZFPeGsfJwPOsy3tgvo4ra
         ZdgIMQd26bblZnSB23DoYZLDkYB1f2mKnMIg0S7UA0kO9MXk67AdJSg7fxlP2IcpBTUP
         8SCz7VtU+EJssFe1IpKLPfFkMfvAc8mHaXhb0wknObAB/YchlAOHYzBwyaWL23WRKSRH
         BKEw==
X-Gm-Message-State: AOAM533PSUCa5Q/J1fyvxOSVwKs4vvr+DmmTj55rh+uENvZOMBLGI4n3
        POKdoV5yLBQfnrZu5mvLHeE=
X-Google-Smtp-Source: ABdhPJzjTfSylojB2K34Esgzc0LuFLVnJbTnwJN1L5QxS0S4p3PXoOmHqqbXxYJDPoYPHt7zm/BOIQ==
X-Received: by 2002:aa7:8a1a:0:b029:2d4:a24:8967 with SMTP id m26-20020aa78a1a0000b02902d40a248967mr11545630pfa.11.1621439227560;
        Wed, 19 May 2021 08:47:07 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:db5a:2bf3:3617:be1c? ([2601:647:4000:d7:db5a:2bf3:3617:be1c])
        by smtp.gmail.com with ESMTPSA id 187sm14563498pff.139.2021.05.19.08.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 08:47:06 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] Introduce enums for the SAM, message, host and
 driver status codes
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210518175006.21308-1-bvanassche@acm.org>
 <20210518175006.21308-3-bvanassche@acm.org>
 <71783cd3-b008-f5c9-b5a0-8c4279b2d017@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8088a19d-975d-50f4-b1ab-759d3bc099a3@acm.org>
Date:   Wed, 19 May 2021 08:47:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <71783cd3-b008-f5c9-b5a0-8c4279b2d017@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/19/21 4:23 AM, John Garry wrote:
> Do we have an example of where the compiler would catch an incorrect
> usage / mismatch?

If I remember correctly some time ago Hannes fixed multiple LLDs that
assigned incorrect values to scsi_cmd->result. I'd like to modify the
type of struct scsi_cmnd.result such that the compiler can verify
whether the proper enum type is assigned to each SCSI result subcomponent.

Bart.
