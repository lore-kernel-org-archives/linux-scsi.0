Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F31C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 13:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4239610FD
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 13:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhKCNm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 09:42:59 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:33491 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhKCNm6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 09:42:58 -0400
Received: by mail-pl1-f176.google.com with SMTP id s24so2583795plp.0
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 06:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Eksb9O6DGc8Ofj16zmoxAXHAKiVWyqvVeR3AfLvGIz4=;
        b=sRZfqGMzQ4hlv/p2jx0Qmvd6fxJXlM6TaKfhnoDHWP2f9Ipkkp6jIqCh3hlFFNoOKQ
         jHi8mV5WaN4uyNYdtrVQQvIwXLcT8py9dzXuYOpp0KwNB5+hriw+FFJ44tIKRw1Gg183
         c4f5IcQQ9WCq46K4RvGGfyWX/v+EkATtqxI2GNuSSafN25R4kKXdMXnWPP55Hkf0H+hd
         4Lqm4LkVxZc1k5/BXxvFZUmsou7elyReozD6DZpSt9nvxPxEK9gpI+GIK03vZhvLS+x/
         b+EfN8jBBnTS8XLz1ToWU77yj0W/k2WvsikvBRMJlekyGUCwQbQac1jGQ9joI8fWXjtf
         5p9g==
X-Gm-Message-State: AOAM530t8RxfuGwTDPmJORCtY8iJQIHjuMEiW20L1Ow47Fx4PYez/HfG
        prUrSusRCF4aqTb6Tp4Gq0Q=
X-Google-Smtp-Source: ABdhPJzLWOTtgE3CjHXqkVhkK3ZBHnh/b0tUipOriiIqsRsaDTulfO84Oa/FbjP2eA/jOfMAURdwVQ==
X-Received: by 2002:a17:90a:d3d6:: with SMTP id d22mr14679493pjw.242.1635946822068;
        Wed, 03 Nov 2021 06:40:22 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:7139:8ee0:6bbd:757c? ([2601:647:4000:d7:7139:8ee0:6bbd:757c])
        by smtp.gmail.com with ESMTPSA id y25sm2782422pfa.70.2021.11.03.06.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 06:40:21 -0700 (PDT)
Message-ID: <d25a32ff-251c-dcca-57ad-5e95c094317d@acm.org>
Date:   Wed, 3 Nov 2021 06:40:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
 <82dffddc-15e8-dc1a-abda-e84e7e441d87@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <82dffddc-15e8-dc1a-abda-e84e7e441d87@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/21 23:56, Adrian Hunter wrote:
> On 03/11/2021 02:05, Bart Van Assche wrote:
>> The following deadlock has been observed on a test setup:
>> * All tags allocated.
>> * The SCSI error handler calls ufshcd_eh_host_reset_handler()
>> * ufshcd_eh_host_reset_handler() queues work that calls ufshcd_err_handler()
>> * ufshcd_err_handler() locks up as follows:
>>
>> Workqueue: ufs_eh_wq_0 ufshcd_err_handler.cfi_jt
>> Call trace:
>>   __switch_to+0x298/0x5d8
>>   __schedule+0x6cc/0xa94
>>   schedule+0x12c/0x298
>>   blk_mq_get_tag+0x210/0x480
>>   __blk_mq_alloc_request+0x1c8/0x284
>>   blk_get_request+0x74/0x134
>>   ufshcd_exec_dev_cmd+0x68/0x640
>>   ufshcd_verify_dev_init+0x68/0x35c
>>   ufshcd_probe_hba+0x12c/0x1cb8
>>   ufshcd_host_reset_and_restore+0x88/0x254
>>   ufshcd_reset_and_restore+0xd0/0x354
>>   ufshcd_err_handler+0x408/0xc58
>>   process_one_work+0x24c/0x66c
>>   worker_thread+0x3e8/0xa4c
>>   kthread+0x150/0x1b4
>>   ret_from_fork+0x10/0x30
>>
>> Fix this lockup by making ufshcd_exec_dev_cmd() allocate a reserved
>> request.
> 
> It is worth noting that the error handler itself could always find
> a free slot, either by waiting for one, or by taking the reset
> path which clears all slots.

I do not agree. As mentioned in the patch description, this patch is a 
fix for a scenario in which ufshcd_eh_host_reset_handler() waits until 
ufshcd_err_handler() finishes. ufshcd_err_handler() does not finish 
since there are no tags and no tags will be freed since that is the 
responsibility of ufshcd_eh_host_reset_handler() but it is blocked ...

> For UFS-specific patch sets please always cc me on all patches
> in a series including the cover letter.

I will do that.

Thanks,

Bart.
