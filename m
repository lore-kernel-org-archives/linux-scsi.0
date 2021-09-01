Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6189CC432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 07:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B4660F91
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 07:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242842AbhIAIAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 04:00:37 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3711 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242827AbhIAIAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 04:00:36 -0400
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GzxHy6cjKz67ZbW;
        Wed,  1 Sep 2021 15:58:06 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 1 Sep 2021 09:59:37 +0200
Received: from [10.47.95.192] (10.47.95.192) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Wed, 1 Sep 2021
 08:59:37 +0100
Subject: Re: arm scsi drivers
To:     Hannes Reinecke <hare@suse.de>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        "Christoph Hellwig" <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <5a72842f-99db-8787-120b-6d85e7884e2d@huawei.com>
 <9552a506-e53a-3fd3-b38e-3cec81e713a6@huawei.com>
 <20210827150938.GU22278@shell.armlinux.org.uk>
 <087d1fa0-8796-5b97-36fc-379498f53380@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <cbd7991e-0634-83c1-0a6a-c834324ec72d@huawei.com>
Date:   Wed, 1 Sep 2021 09:03:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <087d1fa0-8796-5b97-36fc-379498f53380@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.95.192]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/08/2021 16:23, Hannes Reinecke wrote:
> On 8/27/21 5:09 PM, Russell King (Oracle) wrote:
>> I haven't, sorry.
>>
>> I have run 5.x kernels on the hardware, and do have a set of patches
>> kicking around for the SCSI drivers that do some cleanups. It looks
>> like the fixup is pretty simple from the links you've sent - using
>> scsi_cmd_to_rq() to get the tag.

I'm not sure. The SCSI midlayer does nothing with that tag field, apart 
from set it to the block layer request tag, and it seems that these 
drivers reuse that field for their own tag management. But Hannes is 
confident that we may just use scsi_cmd_to_rq().

>>
>> That said, I think I may only had one SCSI drive that came anywhere
>> close to supported tagged queuing, so I never put much effort into
>> tagged command support. Both acornscsi and fas216 have it disabled
>> for this reason, so it's probably easier just to rip the tag code
>> out of these drivers.
>>
> That's what I figured, too.
> And that's what my patches do, killing the tag support from arm drivers 
> which had them disabled since the dawn of git history.

These are the patches:
https://lore.kernel.org/linux-scsi/20210819084007.79233-1-hare@suse.de/T/#t

Hannes, please consider resending, cc'ing Russell.

Thanks,
John
