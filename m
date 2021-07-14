Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570FCC07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 17:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A4FF613C5
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 17:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239759AbhGNRn5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 13:43:57 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3414 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhGNRn5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 13:43:57 -0400
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GQ4JL245yz6L82C;
        Thu, 15 Jul 2021 01:29:54 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 19:41:03 +0200
Received: from [10.47.83.59] (10.47.83.59) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 18:41:02 +0100
Subject: Re: SCSI layer RPM deadlock debug suggestion
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        Xiejianqin <xiejianqin@hisilicon.com>
References: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
 <20210702203142.GA49307@rowland.harvard.edu>
 <ec4a3038-34b0-084f-a1bd-039827465dd1@acm.org>
 <1081c3ed-0762-58c7-8b99-8b3721c710bd@huawei.com>
 <20210705131712.GB116379@rowland.harvard.edu>
 <a5b9109c-cad6-0057-29c9-8974fda3347c@suse.de>
 <47f35811-33c5-9620-45d5-8201e5ec5db3@huawei.com>
 <20210714161027.GC380727@rowland.harvard.edu>
 <dc75007c-4a07-d1a9-6b86-2f6d2dc59271@huawei.com>
 <20210714171016.GE380727@rowland.harvard.edu>
From:   John Garry <john.garry@huawei.com>
Message-ID: <71293d49-9cdf-3fce-5824-8e8f390ee91a@huawei.com>
Date:   Wed, 14 Jul 2021 18:41:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210714171016.GE380727@rowland.harvard.edu>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.59]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2021 18:10, Alan Stern wrote:
>> Hi Alan,
>>
>> Sorry for not getting back to you sooner. Testing so far with the originally
>> proposed change [0] has not raised any issues and has solved the deadlock.
>>
>> But we have a list of other problems to deal with in the RPM area related to
>> the LLDD/libsas, so were waiting to address all of them (or at least have a
>> plan) before progressing this change.
>>
>> One such issue is that when we issue the link-reset which causes the device
>> to be lost in the test, the disk is not found again. The customer may not be
>> happy with this, so we're investigating solutions.
>>
>> As for your change itself, I had something similar sitting on our dev
>> branch:
>>
>> [0]https://github.com/hisilicon/kernel-dev/commit/3696ca85c1e00257c96e40154d28b936742430c4
>>
>> For me, I'm happy to hold off on any change, but if you think it's serious
>> enough to progress your patch, below, now, then I think that should be ok.
> No, I don't think it's all that serious.  The scenario is probably
> pretty rare in real life, outside of a few odd circumstances like yours.
> I'm happy to wait until you're comfortable with a full set of changes.

Fine, and I'll ask for your change to be tested also, even though 
effectively it looks identical to what was tested already.

Thanks,
john
