Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04EFC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 07:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7717661100
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 07:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhHSHdC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 03:33:02 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3670 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhHSHdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 03:33:01 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GqxK65Qvsz6FGMl;
        Thu, 19 Aug 2021 15:31:22 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 19 Aug 2021 09:32:22 +0200
Received: from [10.47.81.140] (10.47.81.140) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 19 Aug
 2021 08:32:21 +0100
Subject: Re: [PATCH v2 06/11] blk-mq: Pass driver tags to
 blk_mq_clear_rq_mapping()
To:     Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-7-git-send-email-john.garry@huawei.com>
 <YRyGb/Ay3lvUZs/V@T590> <23448833-593c-139f-6051-9b8e7d3deade@huawei.com>
 <YR2oO8hhtDx1Wd+P@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <c957c544-4040-e462-47f6-3514ab3da617@huawei.com>
Date:   Thu, 19 Aug 2021 08:32:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YR2oO8hhtDx1Wd+P@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.140]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/08/2021 01:39, Ming Lei wrote:
>> That's intentional, as we have from later patch:
>>
>> void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>> unsigned int hctx_idx)
>> {
>> 	struct blk_mq_tags *drv_tags;
>> 	struct page *page;
>>
>> +	if (blk_mq_is_sbitmap_shared(set->flags))
>> +		drv_tags = set->shared_sbitmap_tags;
>> +	else
>> 		drv_tags = set->tags[hctx_idx];
>>
>> 	...
>>
>> 	blk_mq_clear_rq_mapping(drv_tags, tags);
>>
>> }
>>
>> And it's just nice to not re-indent later.
> But this way is weird, and I don't think checkpatch.pl is happy with
> it.

There is the idea to try to not remove/change code earlier in a series - 
I am taking it to an extreme! I can stop.

On another related topic, how about this change also:

---8<---
void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
			     struct blk_mq_tags *tags)
  {

+	/* There is no need to clear a driver tags own mapping */
+	if (drv_tags == tags)
+		return;
--->8---

Thanks,
John
