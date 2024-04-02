Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB962C80
	for <linux-scsi@vger.kernel.org>; Tue,  2 Apr 2024 01:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712020245; cv=none; b=McktcjcX0Y2gnE4rDE66etIleoDATJZi8f4TklXfV4WvA1EmryVEg+cB17NAa6TF2rMW085mVJONaeu+Prb8Ue0VdkHoz6d0AMViOjE7fqug/ZMccmRuVX8Hs4d57pdxoKAhoII/cUipMVIFf10uOi9sMYhwd1uTWZX4ETk0x5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712020245; c=relaxed/simple;
	bh=V8/St27ArTQL5tqlObHwhQetQTujD8T37bvwLFIYaIU=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=J1OPkYIy9Gn0zWrp1XpTctEwf/wt4bZtYySnGdjSKGx1ghyyUGbAbtfpL4C8/EV6hPIHvj2a/b84iZf2e6ICgbJ3xHWW0o9jVwvAd1aPa5ortSz87KoP4m0wrKhew6zVHJenpshvZkYpz78hD6MhGGydT9QA/15QvCpX6/K/iJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4V7qY53WGFz1wpc2;
	Tue,  2 Apr 2024 09:09:45 +0800 (CST)
Received: from kwepemd200015.china.huawei.com (unknown [7.221.188.21])
	by mail.maildlp.com (Postfix) with ESMTPS id 3FF131A016C;
	Tue,  2 Apr 2024 09:10:37 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemd200015.china.huawei.com (7.221.188.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Tue, 2 Apr 2024 09:10:36 +0800
Subject: Re: [PATCH 1/2] scsi: hisi_sas: Handle the NCQ error returned by D2H
 frame
To: Damien Le Moal <dlemoal@kernel.org>, <jejb@linux.vnet.ibm.com>,
	<martin.petersen@oracle.com>
References: <20240401054914.721093-1-chenxiang66@hisilicon.com>
 <20240401054914.721093-2-chenxiang66@hisilicon.com>
 <415f65a7-ffaf-42a2-a1b5-6182ccc3c3cd@kernel.org>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <dbe0c5b9-d014-a289-612e-32c71b8ac202@hisilicon.com>
Date: Tue, 2 Apr 2024 09:10:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <415f65a7-ffaf-42a2-a1b5-6182ccc3c3cd@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd200015.china.huawei.com (7.221.188.21)

Hi Damien,


在 2024/4/1 星期一 15:10, Damien Le Moal 写道:
> On 4/1/24 14:49, chenxiang wrote:
>> From: Xingui Yang <yangxingui@huawei.com>
>>
>> We find that some disks use D2H frame instead of SDB frame to return NCQ
>> error. Currently, only the I/O corresponding to the D2H frame is processed
>> in this scenario, which does not meet the processing requirements of the
>> NCQ error scenario.
>> So we set dev_status to HISI_SAS_DEV_NCQ_ERR and abort all I/Os of the disk
>> in this scenario.
>>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> index 7d2a33514538..3935fa6bc72b 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> @@ -2244,7 +2244,14 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
>>   	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
>>   		if ((dw0 & CMPLT_HDR_RSPNS_XFRD_MSK) &&
>>   		    (sipc_rx_err_type & RX_FIS_STATUS_ERR_MSK)) {
>> -			ts->stat = SAS_PROTO_RESPONSE;
>> +			if (task->ata_task.use_ncq) {
>> +				struct domain_device *device = task->dev;> +				struct hisi_sas_device *sas_dev =
>> +						device->lldd_dev;
> Missing blank line after the declaration. And why the line split for the above
> declaration ? That fits in 80 chars line...

Will change it in next version.

>
>> +				sas_dev->dev_status = HISI_SAS_DEV_NCQ_ERR;
>> +				slot->abort = 1;
>> +			} else
>> +				ts->stat = SAS_PROTO_RESPONSE;
> Missing the curly brackets here.


Will change it in next version.

>
>>   		} else if (dma_rx_err_type & RX_DATA_LEN_UNDERFLOW_MSK) {
>>   			ts->residual = trans_tx_fail_type;
>>   			ts->stat = SAS_DATA_UNDERRUN;

