Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652E3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 07:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbhLOH5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 02:57:35 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15741 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbhLOH5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 02:57:34 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JDSFP1hcWzZdhk;
        Wed, 15 Dec 2021 15:54:33 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Wed, 15
 Dec 2021 15:57:32 +0800
Subject: Re: [PATCH 13/15] scsi: hisi_sas: Keep controller active between ISR
 of phyup and the event being processed
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-14-git-send-email-chenxiang66@hisilicon.com>
 <eda21591-d691-f892-8ca5-0f5b3d49f496@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <30e132fb-f072-bf85-e7a9-d6f935e477ee@hisilicon.com>
Date:   Wed, 15 Dec 2021 15:57:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <eda21591-d691-f892-8ca5-0f5b3d49f496@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2021/12/13 18:44, John Garry 写道:
> On 17/11/2021 02:45, chenxiang wrote:
>> From: Xiang Chen<chenxiang66@hisilicon.com>
>>
>> It is possible that controller may be suspended between ISR of phyup
>> and the event being processed, then it can't ensure controller is
>> active when processing the phyup event which will cause issues.
>> To avoid the issue, add pm_runtime_get_noresume() in ISR of phyup
>> and pm_runtime_put_sync() in the work handler exit of a new event
>> HISI_PHYE_PHY_UP_PM which is called in v3 hw as runtime PM is
>> only supported for v3 hw.
>
> Please consider this rewrite:
>
> It is possible that the controller may become suspended between 
> processing a phyup interrupt and the event being processed by libsas. 
> As such, we can't ensure that the controller is active when processing 
> the phyup event - this may cause the phyup event to be lost or other 
> issues.
> To avoid any possible issues, add pm_runtime_get_noresume() in the 
> phyup interrupt handler and pm_runtime_put_sync() in the work handler 
> exit to ensure that we stay always active. Since we only want 
> pm_runtime_get_noresume() called for v3 hw, signal this will a new 
> event, HISI_PHYE_PHY_UP_PM.

Ok, i will rewrite it in next version.

>
> Thanks,
> John
>
> .
>


