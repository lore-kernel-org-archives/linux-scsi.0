Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B84C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 07:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E31360F43
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 07:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbhITHnK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 03:43:10 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3843 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbhITHnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2021 03:43:09 -0400
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HCbz95cmqz67bFG;
        Mon, 20 Sep 2021 15:39:01 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 20 Sep 2021 09:41:41 +0200
Received: from [10.47.88.85] (10.47.88.85) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 20 Sep
 2021 08:41:40 +0100
Subject: Re: [PATCH RESEND v3 00/13] blk-mq: Reduce static requests memory
 footprint for shared sbitmap
To:     <axboe@kernel.dk>, <ming.lei@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
References: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <e5f92ab5-eddd-eaed-3b3c-29b5bc60f0e6@huawei.com>
Date:   Mon, 20 Sep 2021 08:45:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.85]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/09/2021 16:12, John Garry wrote:
> Currently a full set of static requests are allocated per hw queue per
> tagset when shared sbitmap is used.
> 
> However, only tagset->queue_depth number of requests may be active at
> any given time. As such, only tagset->queue_depth number of static
> requests are required.
> 
> The same goes for using an IO scheduler, which allocates a full set of
> static requests per hw queue per request queue.
> 
> This series changes shared sbitmap support by using a shared tags per
> tagset and request queue. Ming suggested something along those lines in
> v1 review. But we'll keep name "shared sbitmap" name as it is familiar. In
> using a shared tags, the static rqs also become shared, reducing the
> number of sets of static rqs, reducing memory usage.

Hi Ming,

Could you kindly check the remaining few un-reviewed patches in this 
series when you get an opportunity?

Thanks,
John
