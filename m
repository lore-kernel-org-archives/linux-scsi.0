Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D719ACCA47D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 09:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239960AbiFMJl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 05:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbiFMJlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 05:41:25 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAE11658F;
        Mon, 13 Jun 2022 02:41:23 -0700 (PDT)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LM5zp5M84z68BVP;
        Mon, 13 Jun 2022 17:36:22 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 13 Jun 2022 11:41:21 +0200
Received: from [10.195.33.253] (10.195.33.253) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 13 Jun 2022 10:41:21 +0100
Message-ID: <7dbd2f49-89b9-16f2-dbd5-e6c8978ebf22@huawei.com>
Date:   Mon, 13 Jun 2022 10:44:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH RFC v2 07/18] libata-scsi: Add ata_internal_queuecommand()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <brking@us.ibm.com>, <hare@suse.de>,
        <hch@lst.de>
CC:     <linux-block@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <chenxiang66@hisilicon.com>
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
 <1654770559-101375-8-git-send-email-john.garry@huawei.com>
 <da6a77ff-0dde-b0b4-4d6c-047eab48d595@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <da6a77ff-0dde-b0b4-4d6c-047eab48d595@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.195.33.253]
X-ClientProxiedBy: lhreml746-chm.china.huawei.com (10.201.108.196) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/06/2022 08:16, Damien Le Moal wrote:
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index baac35dd17ca..b2702ab0183b 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -1114,6 +1114,20 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>>   	return 0;
>>   }
>>   
>> +int ata_internal_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
> ata_scsi_internal_queuecommand()

ok

> 
> But given that this is used for the .reserved_queuecommand() method, I
> would call it ata_scsi_reserved_queuecommand().

I did mention somewhere that I continued to use the term "internal" as 
that is what libata already uses, but I can change it.

> 
>> +{
>> +	struct ata_port *ap;
>> +	int res;
>> +
>> +	ap = ata_shost_to_port(shost);
> You can move this to ap declaration.
> 
> 	struct ata_port *ap = ata_shost_to_port(shost);

ok

> 
>> +	spin_lock_irq(ap->lock);
> spin_lock_irqsave() ?

Right

> 
>> +	res = ata_sas_queuecmd(scmd, ap);
>> +	spin_unlock_irq(ap->lock);
>> +
>> +	return res;

Thanks,
John
