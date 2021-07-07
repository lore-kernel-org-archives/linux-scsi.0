Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD93C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 15:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F2BA61CC1
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 15:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhGGPSb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 11:18:31 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3373 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbhGGPSb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 11:18:31 -0400
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GKjQQ0F8Vz6M4Sh;
        Wed,  7 Jul 2021 23:05:02 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 7 Jul 2021 17:15:49 +0200
Received: from [10.47.24.69] (10.47.24.69) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 7 Jul 2021
 16:15:48 +0100
Subject: Re: SCSI layer RPM deadlock debug suggestion
To:     Hannes Reinecke <hare@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        Xiejianqin <xiejianqin@hisilicon.com>
References: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
 <20210702203142.GA49307@rowland.harvard.edu>
 <ec4a3038-34b0-084f-a1bd-039827465dd1@acm.org>
 <1081c3ed-0762-58c7-8b99-8b3721c710bd@huawei.com>
 <20210705131712.GB116379@rowland.harvard.edu>
 <a5b9109c-cad6-0057-29c9-8974fda3347c@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <47f35811-33c5-9620-45d5-8201e5ec5db3@huawei.com>
Date:   Wed, 7 Jul 2021 16:08:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <a5b9109c-cad6-0057-29c9-8974fda3347c@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.24.69]
X-ClientProxiedBy: lhreml717-chm.china.huawei.com (10.201.108.68) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>>>>> Any suggestion on how to fix this deadlock?
>>>>> This is indeed a tricky question.  It seems like we should allow a
>>>>> runtime resume to succeed if the only reason it failed was that the
>>>>> device has been removed.
>>>>>
>>>>> More generally, perhaps we should always consider that a runtime
>>>>> resume succeeds.  Any remaining problems will be dealt with by the
>>>>> device's driver and subsystem once the device is marked as
>>>>> runtime-active again.
>>>>>
>>>>> Suppose you try changing blk_post_runtime_resume() so that it always
>>>>> calls blk_set_runtime_active() regardless of the value of err.  Does
>>>>> that fix the problem?
>>>>>

Hi Alan,

I tried that suggestion with the following change:


--- a/block/blk-pm.c
+++ b/block/blk-pm.c
@@ -185,9 +185,8 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
   */
void blk_post_runtime_resume(struct request_queue *q, int err)
{
-
+       err = 0;
         if (!q->dev)
                 return;
         if (!err) {


And that looks to solve the deadlock which I was seeing. I'm not sure on 
side-effects elsewhere.

We'll test it a bit more.

Thanks,
John

>>>>> And more importantly, will it cause any other problems...?
>>>> That would cause trouble for the UFS driver and other drivers for which
>>>> runtime resume can fail due to e.g. the link between host and device
>>>> being in a bad state.
>>
>> I don't understand how that could work.  If a device fails to resume
>> from runtime suspend, no matter whether the reason is temporary or
>> permanent, how can the system use it again?
>>
>> And if the system can't use it again, what harm is there in pretending
>> that the runtime resume succeeded?
>>
> 'xactly.
> Especially as we _do_ have error recovery on SCSI, so we should be 
> treating a failure to resume just like any other SCSI error; in the end, 
> we need to equip SCSI EH to deal with these kind of states anyway.
> And we already do, as we're sending 'START STOP UNIT' already to spin up 
> drives which are found to be spun down.
> 
> So I'm all for always returning 'success' from the 'resume' callback and 
> let SCSI EH deal with any eventual fallout.


