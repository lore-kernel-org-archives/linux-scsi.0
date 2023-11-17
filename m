Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6348DC5AD4C
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Nov 2023 09:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbjKQJFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Nov 2023 04:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjKQJFW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Nov 2023 04:05:22 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355D9D4F;
        Fri, 17 Nov 2023 01:05:19 -0800 (PST)
Received: from dggpemd100001.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SWrZf3lZyzvQqg;
        Fri, 17 Nov 2023 17:04:58 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.23; Fri, 17 Nov 2023 17:05:16 +0800
Message-ID: <9fa0cf22-38fd-9390-8f3d-f70e283da302@huawei.com>
Date:   Fri, 17 Nov 2023 17:05:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] scsi: libsas: Fix set zero-address when device-type !=
 NO_DEVICE
Content-Language: en-CA
To:     John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <damien.lemoal@opensource.wdc.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
        <kangfenglong@huawei.com>, <chenxiang66@hisilicon.com>
References: <20231116035241.13730-1-yangxingui@huawei.com>
 <dea5cabb-7d9a-44b0-85e4-878c13233f6a@oracle.com>
 <9cc196d7-0c4f-ef09-53b8-362d5eb599a6@huawei.com>
 <a84f7c4e-5da1-4357-9001-c379734e500d@oracle.com>
From:   yangxingui <yangxingui@huawei.com>
In-Reply-To: <a84f7c4e-5da1-4357-9001-c379734e500d@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.120.108]
X-ClientProxiedBy: dggpemm100005.china.huawei.com (7.185.36.231) To
 dggpemd100001.china.huawei.com (7.185.36.94)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,

On 2023/11/17 0:54, John Garry wrote:
> On 16/11/2023 13:45, yangxingui wrote:
>>> I think that patch title can be improved, but I would need to know 
>>> more about the problem before suggesting an improvement.
>> How about "Fix port add phy failed" ?
>>>
>>>> Firstly, when ex_phy is added to the parent port, ex_phy->port is 
>>>> not set.
>>>
>>> That seems correct, but why mention this now?
>>>
>>>> As a result, sas_port_delete_phy() won't be called in
>>>> sas_unregister_devs_sas_addr(), and although ex_phy's sas_address is 
>>>> zero,
>>>> it is not deleted from the parent port's phy_list.
>>>
>>> I am not sure why you mention this now either. You seem to be 
>>> describing how the problem occurs without actually mentioning what 
>>> the problem is.
>>> ohn
>>>>
>>>> Secondly, phy->attached_sas_addr will be set to a zero-address when
>>>> phy->linkrate < SAS_LINK_RATE_1_5_GBPS and device-type != NO_DEVICE 
>>>> during
>>>> device registration, such as stp. It will create a new port and all 
>>>> other
>>>> ex_phys whose addresses are zero will be added to the new port in
>>>> sas_ex_get_linkrate(), and it may trigger BUG() as follows:
>>>
>>> I think that it would be better to first mention this crash, i.e. the 
>>> problem, how you recreate it, and then describe how and why it 
>>> happens, and then tell us how you will fix it
>> How about follows:
>>
>> The following processes trigger a BUG(). A new port port-7:7:0 that 
>> created by a new zero-address sata device tries to add phy-7:7:19 had 
>> the same zero-address, but phy-7:7:19 is already part of another port.
> 
> I would like to know how to recreate, which gives a lot more context and 
> helps me understand what the problem is.
I have update a new version based on your suggestion.

Thanks,
Xingui
.
