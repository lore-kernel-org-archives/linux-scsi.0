Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14133C07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 12:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF459610C7
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 12:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhGEMK0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 08:10:26 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3364 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhGEMKZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 08:10:25 -0400
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GJPGf3WVFz6H8Th;
        Mon,  5 Jul 2021 19:53:46 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 14:07:47 +0200
Received: from [10.47.92.124] (10.47.92.124) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 5 Jul 2021
 13:07:46 +0100
Subject: Re: SCSI layer RPM deadlock debug suggestion
To:     Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>
CC:     Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        Xiejianqin <xiejianqin@hisilicon.com>
References: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
 <20210702203142.GA49307@rowland.harvard.edu>
 <ec4a3038-34b0-084f-a1bd-039827465dd1@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1081c3ed-0762-58c7-8b99-8b3721c710bd@huawei.com>
Date:   Mon, 5 Jul 2021 13:00:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <ec4a3038-34b0-084f-a1bd-039827465dd1@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.92.124]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/07/2021 00:45, Bart Van Assche wrote:

Hi Alan and Bart,

Thanks for the suggestions.

>>> Removing commit e27829dc92e5 ("scsi: serialize ->rescan against ->remove")
>>> solves this issue for me, but that is there for a reason.
>>>
>>> Any suggestion on how to fix this deadlock?
>> This is indeed a tricky question.  It seems like we should allow a
>> runtime resume to succeed if the only reason it failed was that the
>> device has been removed.
>>
>> More generally, perhaps we should always consider that a runtime
>> resume succeeds.  Any remaining problems will be dealt with by the
>> device's driver and subsystem once the device is marked as
>> runtime-active again.
>>
>> Suppose you try changing blk_post_runtime_resume() so that it always
>> calls blk_set_runtime_active() regardless of the value of err.  Does
>> that fix the problem?
>>
>> And more importantly, will it cause any other problems...?
> That would cause trouble for the UFS driver and other drivers for which
> runtime resume can fail due to e.g. the link between host and device
> being in a bad state.
> 
> How about checking the SCSI device state inside scsi_rescan_device() and
> skipping the rescan if the SCSI device state is SDEV_CANCEL or SDEV_DEL?
> 

I find that the device state is SDEV_RUNNING for me at that point (so it 
cannot work).

> Adding such a check inside __scsi_execute() would break sd_remove() and
> sd_shutdown() since both use __scsi_execute() to submit a SYNCHRONIZE
> CACHE command to the device.

Could we somehow signal from __scsi_remove_device() earlier that the 
request queue is dying or at least in some error state, so that 
blk_queue_enter() in the rescan can fail?

Currently we don't call blk_cleanup_queue() -> blk_set_queue_dying() 
until after the device_del(sdev_gendev) call in __scsi_remove_device().

Thanks,
John
