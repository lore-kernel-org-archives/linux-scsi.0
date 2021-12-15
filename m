Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF43C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 07:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240616AbhLOH4V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 02:56:21 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28320 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240611AbhLOH4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 02:56:20 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JDSH43GTzzbcxG;
        Wed, 15 Dec 2021 15:56:00 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Wed, 15
 Dec 2021 15:56:18 +0800
Subject: Re: [PATCH 00/15] Add runtime PM support for libsas
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <71fd6690-8fc3-896a-ddab-9a46fb79e929@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <ba7b63a4-16f9-8b2d-e2d7-8f6fdbbe965e@hisilicon.com>
Date:   Wed, 15 Dec 2021 15:56:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <71fd6690-8fc3-896a-ddab-9a46fb79e929@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,


在 2021/12/14 19:52, John Garry 写道:
> On 17/11/2021 02:44, chenxiang wrote:
>> From: Xiang Chen<chenxiang66@hisilicon.com>
>>
>
> Please consider this rewrite:
>
> Currently the HiSilicon SAS controller v3 hw driver supports runtime 
> PM. However a number of corner-case bugs have been reported for this 
> feature. These include:
> a. If a directly-attached disk is removed when the host is suspended a 
> system hang may occur during resume. libsas drains events after 
> resuming the host. Draining the events causes a deadlock as we need to 
> ensure that the host is resumed for some libsas events processing, 
> however the resume process will not complete until all events are 
> processed.
> b. If a disk is attached to an expander when the host is suspended 
> then this new disk will not be detected when active again.
> c. The host controller may not resume from suspension when sending SMP 
> IOs.
> d. If a phy comes up when resuming the host controller then we may get 
> a deadlock from processing of events DISCE_DISCOVER_DOMAIN and 
> PORTE_BYTES_DMAED.
> e. Similar to d., the work of PORTE_BROADCAST_RCVD and 
> PORTE_BYTES_DMAED may deadlock.
>
> This series addresses those issues, briefly described as follows:
> a. As far as we can see, this drain is unneeded, so conditionally remove.
> b. Just insert broadcast events to revalidate the topology.
> c. and e. When processing any events from the LLD, make libsas keep 
> the host active until finished processing all work related to that 
> original event.
> d. Defer phyup event processing in case described.

Thanks for your detailed comments.
I will improve those commit message according to your suggestions.

>
>
>> Right now hisi_sas driver has already supported runtime PM, and it works
>> well on base functions. But for some exception situations, there are 
>> some
>> issues related to libsas layer:
>> - Remove a directly attached disk when sas host is suspended, a hang 
>> will
>> occur in the resume process, patch 1~2 solve the issue;
>> - Insert a new disk (for expander) during suspended, and the disk is not
>> revalidated when resuming sas host, patch 4~7 solve the issue;
>> - SMP IOs from libsas may be sending when sas host is suspended, so 
>> resume
>> sas host when sending SMP IOs in patch 9;
>> - New phyup may occur during the process of resuming controller, then 
>> work
>> of DISCE_DISCOVER_DOMAIN of a new phy and work PORTE_BYTES_DMAED of 
>> suspended
>> phy are blocked by each other, so defer works of new phys during suspend
>> in patch 10~12;
>> - Work PORTE_BROADCAST_RCVD and PORTE_BYTES_DMAED are in the same
>> workqueue, but it is possible that they are blocked by each other,
>> so keep sas host active until finished some work in patch 14.
>>
>> And patch 3 which is related to scsi/block PM is from Alan Stern
>> (https://lore.kernel.org/linux-scsi/20210714161027.GC380727@rowland.harvard.edu/) 
>>
>
>
> .
>


