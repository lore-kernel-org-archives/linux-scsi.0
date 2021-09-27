Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A94AC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C4D60F70
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhI0JjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 05:39:07 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3878 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbhI0JjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 05:39:06 -0400
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HHyCf6wCdz67VF8;
        Mon, 27 Sep 2021 17:34:54 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 27 Sep 2021 11:37:26 +0200
Received: from [10.47.85.67] (10.47.85.67) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 27 Sep
 2021 10:37:25 +0100
Subject: Re: [PATCH v4 11/13] blk-mq: Refactor and rename
 blk_mq_free_map_and_{requests->rqs}()
To:     Ming Lei <ming.lei@redhat.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hare@suse.de" <hare@suse.de>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-12-git-send-email-john.garry@huawei.com>
 <YU/Va9T+zcRNExUF@T590> <45c0c587-59a2-1761-e175-3920669d0bfb@huawei.com>
 <YVGMvlU5T8zaoEnM@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <cf6452cd-b148-553c-781d-5c888537ac28@huawei.com>
Date:   Mon, 27 Sep 2021 10:40:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YVGMvlU5T8zaoEnM@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.85.67]
X-ClientProxiedBy: lhreml717-chm.china.huawei.com (10.201.108.68) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/09/2021 10:19, Ming Lei wrote:
>> However, apart from this, I can change __blk_mq_free_map_and_rqs() to
>> NULLify set->tags[i], as it is always passed set->tags[i].
>>
>> Do you have a preference?
> I meant there are 5 following uses in your patch:
> 
> +                               blk_mq_free_map_and_rqs(set, set->tags[i], i);
> +                               set->tags[i] = NULL;
> 
> and one new helper(blk_mq_free_set_map_and_rqs(set, i)?) can be added for just
> doing that,

Ah, ok, but in the next patch we replace these blk_mq_free_map_and_rqs() 
calls with __blk_mq_free_map_and_rqs(), and __blk_mq_free_map_and_rqs() 
is always passed set->tags[i], so we do as you request there, i.e. 
NULLify set->tags[i] in __blk_mq_free_map_and_rqs().

Thanks,
John
