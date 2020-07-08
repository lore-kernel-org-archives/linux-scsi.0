Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFBDC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 11:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8000204EC
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 11:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgGHLdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 07:33:10 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2440 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728742AbgGHLdK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jul 2020 07:33:10 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id E091CFBE4E751B066A8A;
        Wed,  8 Jul 2020 12:33:08 +0100 (IST)
Received: from [127.0.0.1] (10.210.171.111) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Wed, 8 Jul 2020
 12:33:07 +0100
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.com>,
        <hch@lst.de>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-11-git-send-email-john.garry@huawei.com>
 <d55972999b9370f947c20537e41b49bf@mail.gmail.com>
 <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
 <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <5cac073f-d930-3074-49a8-515dcd0d80d6@huawei.com>
Date:   Wed, 8 Jul 2020 12:31:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.111]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/07/2020 20:19, Kashyap Desai wrote:
>>> My understanding is
>>> - This RFC + patch set from above link is required for it. I could not
>>> see above series is committed.
>> It is committed and part of 5.8-rc1
>>
>> The latest rc should have some scheduler fixes also.
>>
>> I also note that there has been much churn on blk-mq tag code lately, and
>> something may be broken, so I plan to verify latest rc myself soon.
> Thanks. I will try merging 5.8-rc1 and RFC and see how CPU hot plug works.
> 

JFYI, I tested 5.8-rc4 for scheduler=none and =mq-deadline (no fully 
tested), and it looks ok

john

