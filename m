Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A623C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 08:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359419AbiFPIXL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 04:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiFPIXK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 04:23:10 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842C821E12;
        Thu, 16 Jun 2022 01:23:09 -0700 (PDT)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LNwCk6HFHz6GCpY;
        Thu, 16 Jun 2022 16:22:58 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 16 Jun 2022 10:23:07 +0200
Received: from [10.126.172.137] (10.126.172.137) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 16 Jun 2022 09:23:05 +0100
Message-ID: <ecfb0694-21b8-55b4-c9b8-5e738f59ce8d@huawei.com>
Date:   Thu, 16 Jun 2022 09:24:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH RFC v2 03/18] scsi: core: Implement reserved command
 handling
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <brking@us.ibm.com>, <hare@suse.de>, <hch@lst.de>
CC:     <linux-block@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <chenxiang66@hisilicon.com>
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
 <1654770559-101375-4-git-send-email-john.garry@huawei.com>
 <b4a0ede5-95a3-4388-e808-7627b5484d01@opensource.wdc.com>
 <9e89360d-3325-92af-0436-b34df748f3e2@acm.org>
 <e36bba7e-d78d-27b4-a0e2-9d921bc82f5d@opensource.wdc.com>
 <3a27b6ff-e495-8f11-6925-1487c9d14fa9@huawei.com>
 <c702f06e-b7da-92be-3c4f-5dd405600235@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <c702f06e-b7da-92be-3c4f-5dd405600235@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.172.137]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/06/2022 03:47, Damien Le Moal wrote:
>>> so going backward several years... That internal tag for ATA does not
>>> need to be reserved since this command is always used when the drive is
>>> idle and no other NCQ commands are on-going.
>>
>> So do you mean that ATA_TAG_INTERNAL qc is used for other commands 
>> apart from internal commands?
> 
> No. It is used only for internal commands. What I meant to say is that 
> currently, internal commands are issued only on device scan, device 
> revalidate and error handling. All of these phases are done with the 
> device under EH with the issuing path stopped and all commands 
> completed, 

If I want to allocate a request for an ATA internal command then could I 
use 1x from the regular tags? I didn't think that this was possible as I 
thought that all tags may be outstanding when EH kicks in. I need to 
double check it.

Even if it were true, not using a reserved tag for ATA internal command 
makes things more tricky as this command requires special handling for 
scsi blk_mq_ops and there is no easy way to identify the command as 
reserved (to know special handling is required).

>so no regular commands can be issued. Only internal ones, non 
> NCQ, using the ATA_TAG_INTERNAL. So strictly speaking, we should not 
> need to reserve that internal tag at all.
> 

Thanks,
John

