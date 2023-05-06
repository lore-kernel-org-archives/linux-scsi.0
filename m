Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E32C77B7C
	for <linux-scsi@archiver.kernel.org>; Sat,  6 May 2023 02:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjEFCLH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 May 2023 22:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEFCLG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2023 22:11:06 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE9A59C3;
        Fri,  5 May 2023 19:11:05 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QCrXK3msXzZfqM;
        Sat,  6 May 2023 10:06:57 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 6 May 2023 10:11:02 +0800
Subject: Re: [PATCH v2] ata: libata-scsi: Fix get identity data failed
To:     yangxingui <yangxingui@huawei.com>,
        John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <damien.lemoal@opensource.wdc.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
        <kangfenglong@huawei.com>
References: <20230505025712.19438-1-yangxingui@huawei.com>
 <291f1d97-9195-45ac-8e12-058f5c797277@kernel.org>
 <b13c9445-39c5-f207-d5d0-d6c86eee54ae@oracle.com>
 <1b703656-e966-63f8-19dd-33e4e9914676@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <4364409d-e63c-f87f-0484-f170e92d44c5@huawei.com>
Date:   Sat, 6 May 2023 10:11:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1b703656-e966-63f8-19dd-33e4e9914676@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/5/5 17:14, yangxingui wrote:
> 
> 
> On 2023/5/5 16:25, John Garry wrote:
>> On 05/05/2023 09:17, Damien Le Moal wrote:
>>>> --- a/drivers/ata/libata-scsi.c
>>>> +++ b/drivers/ata/libata-scsi.c
>>>> @@ -26,6 +26,7 @@
>>>>   #include <scsi/scsi_device.h>
>>>>   #include <scsi/scsi_tcq.h>
>>>>   #include <scsi/scsi_transport.h>
>>>> +#include <scsi/libsas.h>
>>
>> hmmm... is it really acceptable that libata is referencing libsas? I 
>> didn't think that it would be. libsas uses libata, not the other way 
>> around.
> Yeah, I didn't expect that either. Is there any other way? If so, is 
> patch v1 OK?

Hi Xingui,

Libsas should follow the standard way of libata to manage the ata 
structures. Not the opposite way. So what you should do is to find a way 
for libsas to behave as a normal ata driver. It's not good to make 
libata aware of libsas or referencing libsas.

If you have detailed questions you can ask me internally(which will be 
faster) or publicly through the maillist(which may have some delay).

Thanks,
Jason
