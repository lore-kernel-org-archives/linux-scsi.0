Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD2FC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 09:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C070206D6
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 09:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfKNJlz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 04:41:55 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2098 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726106AbfKNJlz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Nov 2019 04:41:55 -0500
Received: from lhreml703-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 8836451502569967E717;
        Thu, 14 Nov 2019 09:41:53 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml703-cah.china.huawei.com (10.201.108.44) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 14 Nov 2019 09:41:53 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 14 Nov
 2019 09:41:53 +0000
Subject: Re: [PATCH RFC 3/5] blk-mq: Facilitate a shared tags per tagset
To:     Hannes Reinecke <hare@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "hare@suse.com" <hare@suse.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
 <1573652209-163505-4-git-send-email-john.garry@huawei.com>
 <32880159-86e8-5c48-1532-181fdea0df96@suse.de>
 <2cbf591c-8284-8499-7804-e7078cf274d2@huawei.com>
 <02056612-a958-7b05-3c54-bb2fa69bc493@suse.de>
 <ace95bc5-7b89-9ed3-be89-8139f977984b@huawei.com>
 <42b0bcd9-f147-76eb-dfce-270f77bca818@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <89cd1985-39c7-2965-d25b-2ee2c183d057@huawei.com>
Date:   Thu, 14 Nov 2019 09:41:51 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <42b0bcd9-f147-76eb-dfce-270f77bca818@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/11/2019 18:38, Hannes Reinecke wrote:
>> Hi Hannes,
>>
>>> Oh, my. Indeed, that's correct.
>>
>> The tags could be kept in sync like this:
>>
>> shared_tag = blk_mq_get_tag(shared_tagset);
>> if (shared_tag != -1)
>>      sbitmap_set(hctx->tags, shared_tag);
>>
>> But that's obviously not ideal.
>>
> Actually, I _do_ prefer keeping both in sync.
> We might want to check if the 'normal' tag is set (typically it would 
> not, but then, who knows ...)
> The beauty here is that both 'shared' and 'normal' tag are in sync, so 
> if a driver would be wanting to use the tag as index into a command 
> array it can do so without any surprises.
> 
> Why do you think it's not ideal?

A few points:
- Getting a bit from one tagset and then setting it in another tagset is 
a bit clunky.
- There may be an atomicity of the getting the shared tag bit and 
setting the hctx tag bit - I don't think that there is.
- Consider that sometimes we may want to check if there is space on a hw 
queue - checking the hctx tags is not really proper any longer, as 
typically there would always be space on hctx, but not always the shared 
tags. We did delete blk_mq_can_queue() yesterday, which would be an 
example of that. Need to check if there are others.

Having said all that, the obvious advantage is performance gain, can 
still use request.tag and so maybe less intrusive changes.

I'll have a look at the implementation. The devil is mostly in the detail...

Thanks,
John
