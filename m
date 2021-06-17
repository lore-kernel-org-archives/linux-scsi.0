Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7ECEC2B9F4
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 03:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97103613DE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 03:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhFQDrD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 23:47:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4817 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhFQDqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 23:46:04 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G577x1pXYzWkZ1;
        Thu, 17 Jun 2021 11:38:53 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 17
 Jun 2021 11:43:55 +0800
Subject: Re: remove ->revalidate_disk (resend)
To:     Christoph Hellwig <hch@lst.de>
References: <20210308074550.422714-1-hch@lst.de>
 <96011dbd-084f-8a07-3506-fc7717122866@hisilicon.com>
 <20210616135015.GA30671@lst.de>
CC:     Jens Axboe <axboe@kernel.dk>, Tim Waugh <tim@cyberelk.net>,
        <martin.petersen@oracle.com>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <709468de-c8fd-0eeb-a3f9-5eb40650034b@hisilicon.com>
Date:   Thu, 17 Jun 2021 11:43:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20210616135015.GA30671@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,


在 2021/6/16 21:50, Christoph Hellwig 写道:
> On Wed, Jun 16, 2021 at 05:41:54PM +0800, chenxiang (M) wrote:
>> Hi,
>>
>> Before i reported a issue related to revalidate disk
>> (https://www.spinics.net/lists/linux-scsi/msg151610.html), and no one
>> replies, but the issue is still.
>>
>> And i plan to resend it, but i find that revalidate_disk interface is
>> completely removed in this patchset.
>>
>> Do you have any idea about the above issue?
> bdev_disk_changed still calls into sd_revalidate_disk through sd_open.
> How did bdev_disk_changed get called for you previously?  If it was
> through the BLKRRPART ioctl please try latest mainline, which ensures
> that ->open is called for that case.

I use the latest mainline (Linux Euler 5.13.0-rc6-next-20210616), and 
the issue is still.
It is through BLKRRPART ioctl, and the call stack is as follows:

BLKRRPART ->
         block_ioctl ->
                 blkdev_ioctl ->
                         blkdev_common_ioctl ->
                                 blkdev_get_by_dev ->
                                         __blkdev_get ->
                                                 ...
disk->fops->open() ->
                                                         sd_open()
                                                 ...
                                                 dev_disk_changed()
                                                 ...



In function sd_open(), it calls sd_revalidate_disk() when 
sdev->removable or sdkp-> write_prot is true, but for our disk, 
sdev->removable = 0 and
sdkp->write_prot = 0, so sd_revalidate_disk() is not called actually.
For previous code, it will call sd_revalidate_disk() in 
bdev_disk_changed() from here 
(https://elixir.bootlin.com/linux/v5.10-rc1/source/fs/block_dev.c#L1411).

>
> .
>


