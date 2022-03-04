Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81DFC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 09:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbiCDJs6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 04:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239569AbiCDJsp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 04:48:45 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AB44EA3D;
        Fri,  4 Mar 2022 01:47:56 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K930G1dtrz681Y1;
        Fri,  4 Mar 2022 17:46:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Fri, 4 Mar 2022 10:47:53 +0100
Received: from [10.47.95.117] (10.47.95.117) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 4 Mar
 2022 09:47:52 +0000
Message-ID: <43acb2b3-8bb0-48b7-2330-3cfad8ca748c@huawei.com>
Date:   Fri, 4 Mar 2022 09:47:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 4/4] scsi: hisi_sas: Use libsas internal abort support
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Ajish.Koshy@microchip.com>, <linuxarm@huawei.com>,
        <Viswas.G@microchip.com>, <hch@lst.de>, <liuqi115@huawei.com>,
        <chenxiang66@hisilicon.com>
References: <1646309930-138960-1-git-send-email-john.garry@huawei.com>
 <1646309930-138960-5-git-send-email-john.garry@huawei.com>
 <fdded2c0-c382-75b1-9679-e10ba47084d7@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <fdded2c0-c382-75b1-9679-e10ba47084d7@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.95.117]
X-ClientProxiedBy: lhreml734-chm.china.huawei.com (10.201.108.85) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/03/2022 16:42, Damien Le Moal wrote:
>> -	if (DEV_IS_GONE(sas_dev)) {
>> -		if (sas_dev)
>> -			dev_info(dev, "task prep: device %d not ready\n",
>> -				 sas_dev->device_id);
>> -		else
>> -			dev_info(dev, "task prep: device %016llx not ready\n",
>> -				 SAS_ADDR(device->sas_addr));
>> +		if (DEV_IS_GONE(sas_dev)) {
>> +			if (sas_dev)
>> +				dev_info(dev, "task prep: device %d not ready\n",
>> +					 sas_dev->device_id);
>> +			else
>> +				dev_info(dev, "task prep: device %016llx not ready\n",
>> +					 SAS_ADDR(device->sas_addr));
>>   
> This blank line could be removed too, no ?

I think that I might change this code to just use the 2nd print always.

> 
>> -		return -ECOMM;
>> -	}
>> +			return -ECOMM;
>> +		}
>>   
>> -	if (task->uldd_task) {
>> -		struct ata_queued_cmd *qc;
>> +		port = to_hisi_sas_port(sas_port);
>> +		if (!port->port_attached) {
>> +			dev_info(dev, "task prep: %s port%d not attach device\n",
>> +				 dev_is_sata(device) ? "SATA/STP" : "SAS",
>> +				 device->port->id);
>>   
>> -		if (dev_is_sata(device)) {
>> -			qc = task->uldd_task;
>> -			scmd = qc->scsicmd;
>> -		} else {
>> -			scmd = task->uldd_task;
>> +				return -ECOMM;
> One tab too many for the indentation here, no ?

Right, I'll fix it.

Thanks,
John

