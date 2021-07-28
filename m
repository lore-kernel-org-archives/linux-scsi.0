Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90111C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 21:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78FC260FE7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 21:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhG1VzY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:55:24 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:37528 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbhG1VzY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 17:55:24 -0400
Received: by mail-pj1-f49.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso12322181pjq.2;
        Wed, 28 Jul 2021 14:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KkaDpFBrorB/7+KcoYo9mjb47DIH688fsoaa3C+MbmI=;
        b=SaUDZQhbzZDEexflbyun7MDMI0L/T1nJk4FgCVZEcUpvHszt/9d4HR1Jy710dVpWby
         kMsQCkKEZ9Kj7Q//4HuzhXSROaFEkWxB6xY00PsN5RRjrYRxFS5lZCWOkRJRLCrWI1BU
         uAfv5cwkH2biNaM2huYix69En7yKfLYgP7Y631JXVJY2tMwFSKHCpKh3VOfMeT1hs5It
         Gjfu7x8DDl4nvCDGbW8vO2xOmkx5Tdb1dGKz2T6PYq6no4R30oX28VYl9wgMqBA7gi3W
         jKL2fDMuMOKA2/v6CvOEkEwhKWW7Zv+kXtoh4P4azzP95yMUQMgUqeFuBEaMn08LtQjK
         mF0g==
X-Gm-Message-State: AOAM530gj7htp6ZCA+K9OFKRnnhoLdyt1/Bh72s8hrEIeDkArKqKF28j
        pWPXyE9tToHJOMojPShD/Ci4ZpUhXE1OApHx
X-Google-Smtp-Source: ABdhPJzxZaMJqQ5j1kW97caD3zwk6yq5e6Zs69mm7+kaTJHr5jgqBc3ipBWEkRI+pTEIrK/F1SiNQg==
X-Received: by 2002:a17:90a:b313:: with SMTP id d19mr1707062pjr.84.1627509321414;
        Wed, 28 Jul 2021 14:55:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:3328:5f8d:f6e2:85ea])
        by smtp.gmail.com with ESMTPSA id a13sm913556pgt.58.2021.07.28.14.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 14:55:20 -0700 (PDT)
Subject: Re: [PATH v2] scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach
To:     yebin <yebin10@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210113063103.2698953-1-yebin10@huawei.com>
 <a1113b04-e320-a12b-5a59-ec7479d5eec1@acm.org> <61016887.9000200@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1a86eadf-41fe-256e-2656-b9a13f73d88f@acm.org>
Date:   Wed, 28 Jul 2021 14:55:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <61016887.9000200@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/28/21 7:24 AM, yebin wrote:
> On 2021/7/23 12:04, Bart Van Assche wrote:
>> On 1/12/21 10:31 PM, Ye Bin wrote:
>>>       sdev->handler_data = NULL;
>>> +    synchronize_rcu();
>>>       kfree(h);
>> What is the purpose of the new synchronize_rcu() call?
> Thanks for your reply.
> Yes, I add new synchronize_rcu() call is to wait until *h is no longer 
> in use. If free
> "h" right now , mybe lead to UAF.
>> If its purpose is
>> to wait until *h is no longer in use, please use kfree_rcu() instead.
> struct rdac_dh_data {
>          struct list_head        node;
>          .....
> }
> As rdac_dh_data.node type is "struct list_head", but  kfree_rcu the 
> first parameter type is
> "struct rcu_head". So we can only use synchronize_rcu() at here.

Ah, that's right. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
