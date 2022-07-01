Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8728CCA479
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 08:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbiGAIqi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 04:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234741AbiGAIqg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 04:46:36 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CF573596;
        Fri,  1 Jul 2022 01:46:34 -0700 (PDT)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LZ7zB3G1wz67VqM;
        Fri,  1 Jul 2022 16:44:06 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Fri, 1 Jul 2022 10:46:32 +0200
Received: from [10.126.173.51] (10.126.173.51) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 1 Jul 2022 09:46:31 +0100
Message-ID: <42505bbc-7319-f266-f282-e76ba505725e@huawei.com>
Date:   Fri, 1 Jul 2022 09:46:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v5 4/5] scsi: scsi_transport_sas: Cap shost max_sectors
 according to DMA optimal limit
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <joro@8bytes.org>, <will@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hch@lst.de>,
        <m.szyprowski@samsung.com>, <robin.murphy@arm.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <iommu@lists.linux.dev>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1656590892-42307-1-git-send-email-john.garry@huawei.com>
 <1656590892-42307-5-git-send-email-john.garry@huawei.com>
 <2e6475e5-4899-1e3a-1418-918b9510ec6d@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <2e6475e5-4899-1e3a-1418-918b9510ec6d@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.173.51]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/07/2022 00:49, Damien Le Moal wrote:
>>   
>> +	if (dma_dev) {
>> +		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
>> +				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
>> +	}

Hi Damien,

 > Hmm... shost->max_sectors becomes the max_hw_sectors limit for the block
 > dev. So using dma_max_mapping_size(dma_dev) for that limit makes sense.
 > Shouldn't dma_opt_mapping_size(dma_dev) be used to limit only the default
 > "soft" limit (queue max_sectors limit) instead of the hard limit ?
 >

Sure, it would sensible to use dma_opt_mapping_size() to limit the 
default queue max sectors limit, while dma_max_mapping_size() limits the 
host max sectors. But I didn't see in practice how limiting the shost 
max sectors to dma_opt_mapping_size() makes a difference:

- block queue max_hw_sectors_kb file is read-only, so we cannot change 
the queue max sectors from there

- And no SAS driver actually tries to modify upwards from the default.
I do note that USB storage driver as an example of a scsi driver which 
does (modify from shost max sectors): see scsiglue.c::slave_configure()

Finally there is no common method to limit the default request queue max 
sectors for those SAS drivers - I would need to add this limit in each 
of their slave_configure callbacks, and I didn't think that its worth it.

Thanks,
John

