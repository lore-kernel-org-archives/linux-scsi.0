Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889B5C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 09:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240879AbiFMJiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 05:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240304AbiFMJiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 05:38:23 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701A91114F;
        Mon, 13 Jun 2022 02:38:22 -0700 (PDT)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LM5wK2zCHz688LD;
        Mon, 13 Jun 2022 17:33:21 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 13 Jun 2022 11:38:20 +0200
Received: from [10.195.33.253] (10.195.33.253) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 13 Jun 2022 10:38:19 +0100
Message-ID: <fa907f45-258b-d63f-85a6-10ea8cf44bb8@huawei.com>
Date:   Mon, 13 Jun 2022 10:41:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH RFC v2 06/18] libata-scsi: Add ata_scsi_queue_internal()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <brking@us.ibm.com>, <hare@suse.de>,
        <hch@lst.de>
CC:     <linux-block@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <chenxiang66@hisilicon.com>
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
 <1654770559-101375-7-git-send-email-john.garry@huawei.com>
 <5b4d17c2-9ee6-7d44-e4cd-6402b0a61c01@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <5b4d17c2-9ee6-7d44-e4cd-6402b0a61c01@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.195.33.253]
X-ClientProxiedBy: lhreml746-chm.china.huawei.com (10.201.108.196) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/06/2022 08:12, Damien Le Moal wrote:
>> -	if (dev->class == ATA_DEV_ATA || dev->class == ATA_DEV_ZAC) {
>> +	if (scsi_is_reserved_cmd(scmd)) {
>> +		return ata_scsi_queue_internal(scmd, dev);
>> +	} else if (dev->class == ATA_DEV_ATA || dev->class == ATA_DEV_ZAC) {
> No need for the else here.
> 

Ah, yes

Thanks,
John
