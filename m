Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63173C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 13:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350431AbiBKNIr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 08:08:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbiBKNIq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 08:08:46 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFC7F57
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 05:08:45 -0800 (PST)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JwDSD49lwz67nFV;
        Fri, 11 Feb 2022 21:07:56 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 14:08:42 +0100
Received: from [10.47.87.89] (10.47.87.89) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 11 Feb
 2022 13:08:41 +0000
Message-ID: <f4130aa7-fc02-f71a-7216-9a9f922278bf@huawei.com>
Date:   Fri, 11 Feb 2022 13:08:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 00/20] libsas and pm8001 fixes
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <b3efd3cf-e36b-9594-06b8-9772bb525e00@huawei.com>
 <ea6b25db-d4da-bab5-8bf2-ec5024c95f89@opensource.wdc.com>
 <af3b0aff-3e43-5a1f-0d98-f68b9100090e@huawei.com>
 <db9c1fb7-bc0b-5742-c856-4b739bdfec39@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <db9c1fb7-bc0b-5742-c856-4b739bdfec39@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.89]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/02/2022 12:37, Damien Le Moal wrote:

Hi Damien,

>> Sometimes I get TMF timeouts, which is a bad situation. I guess it's a
>> subtle driver bug, but where ....?
> What is the command failing ? Always the same ? Can you try adding scsi
> trace to see the commands ?

This is the same issue I have had since day #1.

Generally mount/unmount or even fdisk -l fails after booting into 
miniramfs. I wouldn't ever try to boot a distro.

> 
> If you are "lucky", it is always the same type of command like for the
> NCQ NON DATA in my case.

I'm just trying SAS disks to start with - so it's an SCSI READ command. 
SATA/STP support is generally never as robust for SAS HBAs (HW and LLD 
bugs are common - as this series is evidence) so I start on something 
more basic - however SATA/STP also has this issue.

The command is sent successfully but just never completes. Then 
sometimes the TMFs for error handling timeout and sometimes succeed. I 
don't have much to do on....

> Though on mount, I would only expect a lot of
> read commands and not much else.

Yes, and it is commonly the first SCSI read command which times out. It 
reliably breaks quite early. So I can think we can rule out issues like 
memory barriers/timing.

  There may be some writes and a flush
> too, so there will be "data" commands and "non data" commands. It may be
> an issue with non-data commands too ?
> 

Not sure on that. I guess it isn't.

Thanks,
John
