Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA4EC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 12:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240643AbiBWM5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 07:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240665AbiBWM5G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 07:57:06 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AEEA7;
        Wed, 23 Feb 2022 04:56:36 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K3bcM1PPFz67k3x;
        Wed, 23 Feb 2022 20:55:31 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 23 Feb 2022 13:56:33 +0100
Received: from [10.47.92.123] (10.47.92.123) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 23 Feb
 2022 12:56:33 +0000
Message-ID: <75ccb490-3c77-b7d9-815a-8bf1698f0848@huawei.com>
Date:   Wed, 23 Feb 2022 12:56:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 3/8] scsi: don't memset the entire scsi_cmnd in
 scsi_init_command
To:     Christoph Hellwig <hch@lst.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-4-hch@lst.de>
 <f5c2f7e0-6b14-222f-ba16-696b29517296@huawei.com>
 <20220223123940.GA4205@lst.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220223123940.GA4205@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.92.123]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/02/2022 12:39, Christoph Hellwig wrote:
> On Wed, Feb 23, 2022 at 12:21:10PM +0000, John Garry wrote:
>> I am just wondering did you consider using struct_group() for safety?
>>
>> I don't think the scsi_cmnd members have special ordering apart from
>> co-locating related members.
>>
>> Here's how it could look (on top of yours):
> 
> Besides being ugly as hell I don't see the benefit.  Quite contrary,
> a lot of these fields are properly initialized later and we can drop
> the zeroing as well, but I'd rather do that separately and with a proper
> audit.
> 
> .

ok, fine - so the init may be removed later.

For the record, advantages now could include:
- prob more efficient
- somewhat safer coding practice
- more condense C code

But, for sure, it's not so pretty to have this sub-struct.

Anyway, I don't feel too strongly about it and it was just a suggestion.

Thanks,
John
