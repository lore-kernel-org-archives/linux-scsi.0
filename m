Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E454AEC8742
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Sep 2023 17:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbjIGR2E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243905AbjIGR1q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2023 13:27:46 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECFD1FF2;
        Thu,  7 Sep 2023 10:27:21 -0700 (PDT)
Received: from kwepemm600012.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RhJc51twBzGptg;
        Thu,  7 Sep 2023 20:35:17 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm600012.china.huawei.com (7.193.23.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 7 Sep 2023 20:38:57 +0800
Message-ID: <e3a691e4-3fbc-98ba-28f0-627364d8b4d7@huawei.com>
Date:   Thu, 7 Sep 2023 20:38:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH v2 00/18] scsi: scsi_error: Introduce new error handle
 mechanism
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Hannes Reinecke <hare@suse.de>, <linux-kernel@vger.kernel.org>,
        <louhongxiang@huawei.com>, <lixiaokeng@huawei.com>
References: <20230901094127.2010873-1-haowenchao2@huawei.com>
 <b8350de1-6ac8-4d5f-aaa7-7b03e2f7aa93@oracle.com>
 <7ec75e40-671b-e080-9e7b-2afd5edb25db@huawei.com>
 <d0566ed5-34df-412a-82ff-29d56d499abb@oracle.com>
From:   Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <d0566ed5-34df-412a-82ff-29d56d499abb@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600012.china.huawei.com (7.193.23.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/9/6 23:56, Mike Christie wrote:
> On 9/6/23 6:15 AM, haowenchao (C) wrote:
>>>
>>> If the driver supports performing multiple TMFs/resets in parallel then why
>>> not always enable it?
>>>
>>
>> Not all hardware/drivers support performing multiple TMFs/resets in parallel,
>> so I think it is necessary to call scsi_device_setup_eh/scsi_device_clear_eh
>> in specific drivers.
> 
> Ah shoot sorry. I edited my email before I sent it and dropped part of it.
> 
> For the scsi_device_setup_eh/scsi_device_clear_eh comment I just meant it could
> be a scsi_host_template field. scsi-ml would then see it and do the
> scsi_device_setup_eh/scsi_device_clear_eh calls for the driver. The drivers
> then don't have to deal with doing slave callouts and handling errors.
> 
> Also for the error handling case I think we want to still proceed if
> scsi_device_setup_eh fails. Just use the old EH in that case.

It looks better to add setup_eh/clear_eh in scsi_host_template, I would update in
next version.
