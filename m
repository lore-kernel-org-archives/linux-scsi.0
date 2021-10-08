Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7299C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 08:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD4A061042
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 08:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhJHIGz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 04:06:55 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3944 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbhJHIGy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 04:06:54 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HQgdX0ChLz67vnQ;
        Fri,  8 Oct 2021 16:02:08 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 8 Oct 2021 10:04:55 +0200
Received: from [10.47.80.141] (10.47.80.141) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 8 Oct 2021
 09:04:54 +0100
Subject: Re: [PATCH v5 00/14] blk-mq: Reduce static requests memory footprint
 for shared sbitmap
To:     Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, Jan Kara <jack@suse.cz>
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
 <ae33dde8-96e8-2978-5f32-c7e0a6136e8e@kernel.dk>
 <81d9e019-b730-221e-a8c0-f72a8422a2ec@huawei.com>
 <e4e92abbe9d52bcba6b8cc6c91c442cc@mail.gmail.com>
 <597c4cbe-ca6c-53e5-1139-be2ca0fbb677@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0da031cb-427b-abd8-368d-d242e8c844c8@huawei.com>
Date:   Fri, 8 Oct 2021 09:07:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <597c4cbe-ca6c-53e5-1139-be2ca0fbb677@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.141]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/10/2021 04:11, Bart Van Assche wrote:

+

> On 10/7/21 13:31, Kashyap Desai wrote:
>> I tested this patchset on 5.15-rc4 (master) -
>> https://github.com/torvalds/linux.git
>>
>> #1 I noticed some performance regression @mq-deadline scheduler which 
>> is not
>> related to this series. I will bisect and get more detail about this 
>> issue
>> separately.
> 
> Please test this patch series on top of Jens' for-next branch 
> (git://git.kernel.dk/linux-block). The mq-deadline performance on Jens' 
> for-next branch should match that of kernel v5.13.

Kashyap did also mention earlier that he say the drop from v5.11 -> v5.12.

The only thing I saw possibly related there was Jan's work in 
https://lore.kernel.org/linux-block/20210111164717.21937-1-jack@suse.cz/
to fix a performance regression witnessed on megaraid sas for slower media.

But I quite doubtful that this is the issue.

Thanks,
John
