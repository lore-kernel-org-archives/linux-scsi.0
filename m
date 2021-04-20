Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5049C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 21:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61FD6613EE
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 21:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhDTVK7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 17:10:59 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:43522 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbhDTVK7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 17:10:59 -0400
Received: by mail-pg1-f173.google.com with SMTP id p12so27629389pgj.10
        for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2021 14:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jiSU/kkOvSI9M9FVYeuPh3iWzvduQ+2BiyrvAfBMpQ8=;
        b=h7sTnOQ8JxNGr2hWTPtc5hXRo+p05m9pmDjSWHoTMX6bPULUmgTkviLgNU1C5lRHTL
         qBrdUett40/yiGsGvKEjITVwxbf9KIZwpfehbQGmCOmGljGM6jL0uqi65+o+qwT1z+oh
         XOM+gNq8/COKOdjV8CgPsp7JUlk8sUAf2pfOhTUnVP/exvGp3W8+4gUbGRexo3b55sTp
         Qq/8yeQSLYqx5xyhcERlVM0nhiAzjXwpOBV0pLqm+W5DbT5OzY+OfhgTSKU16sL/FMlF
         JFrodHO1DiO0AKn+4wCGWe5BVSN654EjVlCF9yQ3YR0Dwm49+OBzwBx3t2iQRMvGVbfd
         Df4Q==
X-Gm-Message-State: AOAM531LzVoUHRW24D1JctpC8LMDogmlC2KjcyxWY++5DMmePv7dBtQf
        Pxi/PV4wIAUzA4YGASmT4uC6IujGK9YY4A==
X-Google-Smtp-Source: ABdhPJzCZWxnwLkq9wYdYKamW/VsskOVZUnEjzJoD7yDpqOUiMXk02bf+kAuGeKWAAHcNT8dnW1+zQ==
X-Received: by 2002:a05:6a00:174a:b029:25d:642e:8201 with SMTP id j10-20020a056a00174ab029025d642e8201mr15664449pfc.59.1618953025575;
        Tue, 20 Apr 2021 14:10:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6cb:4566:9005:c2af? ([2601:647:4000:d7:6cb:4566:9005:c2af])
        by smtp.gmail.com with ESMTPSA id d20sm15679675pfn.166.2021.04.20.14.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 14:10:24 -0700 (PDT)
Subject: Re: [PATCH 000/117] Make better use of static type checking
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <7eaf77e8-ca4f-c0db-e94a-5fa3e16e3b51@suse.de>
 <5c194446-e145-9d6d-3bc2-23254f0058b9@acm.org>
 <e230eb1f-172f-c18e-61dd-f9601e30d127@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8533bbb7-1c93-f2ce-2cf2-9f216aecfbae@acm.org>
Date:   Tue, 20 Apr 2021 14:10:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <e230eb1f-172f-c18e-61dd-f9601e30d127@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 10:11 AM, Hannes Reinecke wrote:
> On 4/20/21 6:12 PM, Bart Van Assche wrote:
>> - The parallel SCSI technology is no longer commercially relevant. It
>> may be challenging to motivate people (including yourself) to convert a
>> significant number of parallel SCSI drivers that each have a small user
>> base.
>
> ... true, but then your patchset suffers from the same issue, no?

My patch series should not change the behavior of any SCSI LLD.
Additionally, most changes have been generated with the help of
Coccinelle. I think the risk of such changes is lower than modifying
SCSI LLDs such that the message byte is handled inside the LLD.

Thanks,

Bart.
