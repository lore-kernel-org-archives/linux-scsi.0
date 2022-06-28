Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F9BCCA47E
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 07:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343627AbiF1Hyb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 03:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242547AbiF1Hya (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 03:54:30 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A4A13FA7;
        Tue, 28 Jun 2022 00:54:28 -0700 (PDT)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXH0R6bZ3z6GDF1;
        Tue, 28 Jun 2022 15:53:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 09:54:26 +0200
Received: from [10.126.174.22] (10.126.174.22) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 08:54:25 +0100
Message-ID: <6619638c-52e8-cb67-c56c-9c9d38c18161@huawei.com>
Date:   Tue, 28 Jun 2022 08:54:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v4 5/5] libata-scsi: Cap ata_device->max_sectors according
 to shost->max_sectors
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <joro@8bytes.org>, <will@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hch@lst.de>,
        <m.szyprowski@samsung.com>, <robin.murphy@arm.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <iommu@lists.linux.dev>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1656343521-62897-1-git-send-email-john.garry@huawei.com>
 <1656343521-62897-6-git-send-email-john.garry@huawei.com>
 <b69c6112-98b7-3890-9d11-bb321a7c877a@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <b69c6112-98b7-3890-9d11-bb321a7c877a@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.174.22]
X-ClientProxiedBy: lhreml726-chm.china.huawei.com (10.201.108.77) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/06/2022 00:24, Damien Le Moal wrote:
> On 6/28/22 00:25, John Garry wrote:
>> ATA devices (struct ata_device) have a max_sectors field which is
>> configured internally in libata. This is then used to (re)configure the
>> associated sdev request queue max_sectors value from how it is earlier set
>> in __scsi_init_queue(). In __scsi_init_queue() the max_sectors value is set
>> according to shost limits, which includes host DMA mapping limits.
>>
>> Cap the ata_device max_sectors according to shost->max_sectors to respect
>> this shost limit.
>>
>> Signed-off-by: John Garry<john.garry@huawei.com>
>> Acked-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>
> Nit: please change the patch title to "ata: libata-scsi: Cap ..."
> 

ok, but it's going to be an even longer title :)

BTW, this patch has no real dependency on the rest of the series, so 
could be taken separately if you prefer.

Thanks,
John
