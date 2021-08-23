Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3591C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 08:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5CDC61248
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 08:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbhHWIwc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 04:52:32 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3678 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbhHWIwa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 04:52:30 -0400
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GtQtc0Jvbz67nHL;
        Mon, 23 Aug 2021 16:50:32 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 23 Aug 2021 10:51:43 +0200
Received: from [10.47.87.96] (10.47.87.96) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 23 Aug
 2021 09:51:43 +0100
Subject: Re: [PATCH v2 10/11] blk-mq: Use shared tags for shared sbitmap
 support
To:     Ming Lei <ming.lei@redhat.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "hare@suse.de" <hare@suse.de>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-11-git-send-email-john.garry@huawei.com>
 <YRzB+aCVVSP+OmE4@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <a46c6365-7423-cab0-896b-621af85b3f99@huawei.com>
Date:   Mon, 23 Aug 2021 09:55:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YRzB+aCVVSP+OmE4@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.96]
X-ClientProxiedBy: lhreml719-chm.china.huawei.com (10.201.108.70) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/08/2021 09:16, Ming Lei wrote:
>> ret = blk_mq_alloc_rqs(set, tags, 0, set->queue_depth);
>> +	if (ret) {
>> +		blk_mq_exit_sched_shared_sbitmap(queue);
>> +		return ret;
> There are two such patterns for allocate rq map and request pool
> together, please put them into one helper(such as blk_mq_alloc_map_and_rqs)
> which can return the allocated tags and handle failure inline. Also we may
> convert current users into this helper.
> 
>>   	}

Hi Ming,

Do you have a preference for the API:

int blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set, struct 
blk_mq_tags **tags, unsigned int hctx_idx, unsigned int depth);

void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
  struct blk_mq_tags **tags, unsigned int hctx_idx);


or

struct blk_mq_tags *blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
unsigned int hctx_idx, unsigned int depth);

void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
  struct blk_mq_tags *tags, unsigned int hctx_idx);


The advantage of the first is that we don't need the pattern:
blk_mq_free_map_and_requests(tags)
tags = NULL;

But then passing struct blk_mq_tags ** is a bit overly complicated.

Thanks,
John
