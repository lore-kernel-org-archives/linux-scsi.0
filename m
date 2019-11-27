Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBACC432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 13:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6012220722
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 13:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfK0NFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 08:05:44 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2126 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726520AbfK0NFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Nov 2019 08:05:44 -0500
Received: from lhreml703-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id B67AAC758AF59D24523F;
        Wed, 27 Nov 2019 13:05:42 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml703-cah.china.huawei.com (10.201.108.44) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 27 Nov 2019 13:05:42 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 27 Nov
 2019 13:05:42 +0000
Subject: Re: [PATCH 3/8] blk-mq: Use a pointer for sbitmap
To:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Bart van Assche" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-4-hare@suse.de>
 <8f0522ee-2a81-c2ae-d111-3ff89ee6f93e@kernel.dk>
 <62838bca-cd3c-fccf-767c-76d8bea12324@huawei.com>
 <00a6d920-1855-c861-caa3-e845dcbe1fd8@kernel.dk>
 <baffb360-56c0-3da5-9a52-400fb763adbf@huawei.com>
 <9290eb7f-8d0b-8012-f9a4-a49c068def1b@kernel.dk>
 <157f3e58-1d16-cc6b-52aa-15a6e1ac828a@huawei.com>
 <1add0896-4867-12c5-4507-76526c27fb56@kernel.dk>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4a780199-7997-b677-b184-411afdeabba5@huawei.com>
Date:   Wed, 27 Nov 2019 13:05:41 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1add0896-4867-12c5-4507-76526c27fb56@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/11/2019 01:46, Jens Axboe wrote:
>>> Would be interesting to check the generated code for that, ideally we'd
>>> get rid of the extra load for that case, even if it is in the same
>>> cacheline.
>>>
>> I checked the disassembly and we still have the load instead of the add.
>>
>> This is not surprising, as the compiler would not know for certain that
>> we point to a field within the same struct. But at least we still should
>> point to a close memory.
>>
>> Note that the pointer could be dropped, which would remove the load, but
>> then we have many if-elses which could be slower, not to mention that
>> the blk-mq-tag code deals in bitmap pointers anyway.

Hi Jens,

> It might still be worthwhile to do:
> 
> if (tags->ptr == &tags->__default)
> 	foo(&tags->__default);
> 
> to make it clear, as that branch will predict easily. 

Not sure. So this code does produce the same assembly, as we still need 
to do the tags->ptr load for the comparison.

And then if you consider blk_mq_get_tags() as an example, there is no 
other hot value available to indicate whether the shared tags are used 
to decide whether to use  &tags->__default.

I'll consider it more.

If if can be done
> in a nice enough fashion and not sprinkled everywhere, in some fashion.
> 
> Should be testable, though.
> 
> -- Jens Axboe

Thanks,
John
