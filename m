Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CE718E043;
	Fri,  9 Aug 2024 08:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723192121; cv=none; b=smCIfozxjyvDUUtKVToBE4H7pzdmYuka8wr7YnCyKYb6uwRsjPGU/O8h5M8PzlEA2ogntbQnZYCc+g0GMCYS2dWYNtvSNrFGniv/aMGJwCnY4925E830cB3Faaj/C9vY/eVubZOEyfJwX2JhA9J6tBpMf9V6amnM+CVyrFkb9Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723192121; c=relaxed/simple;
	bh=/l0yUZUpC/nMUugQZnOrV9FPr+m9pokntN5G6vFoWtU=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Yfo5koqlRJvutMqSBn7h4LD1KT6F6p1kI3cy4cL2ASu0rNQMvU8aCjJbx+PP3FEXJA9gtqgWyA4LWSMKbY9D3OOK7IPa+xJArt4FX7LBfRU0rl7d5eS/nuSqhjvYYP/oul07iUJElNKixIX/PG2G2googAsQdMrM6RqIOEMDUdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WgH7Z6LhTzfb7b;
	Fri,  9 Aug 2024 16:26:34 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id A8650140121;
	Fri,  9 Aug 2024 16:28:29 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Aug 2024 16:28:29 +0800
Subject: Re: [PATCH] scsi: sd: Have scsi-ml retry START_STOP errors
To: Bart Van Assche <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
References: <20240808034619.768289-1-liyihang9@huawei.com>
 <17c0a914-9bd7-43ef-b739-d2105ec46567@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<prime.zeng@huawei.com>, <linuxarm@huawei.com>, <liyihang9@huawei.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <35f5f7d3-3cbf-b45a-8a3b-eb1a3f34ddec@huawei.com>
Date: Fri, 9 Aug 2024 16:28:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <17c0a914-9bd7-43ef-b739-d2105ec46567@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)



On 2024/8/9 1:20, Bart Van Assche wrote:
> On 8/7/24 8:46 PM, Yihang Li wrote:
>> When sending START_STOP commands to resume scsi_device, it may be
>> interrupted by exception operations such as host reset or PCI FLR. Once
>> the command of START_STOP is failed, the runtime_status of scsi device
>> will be error and it is difficult for user to recover it.
> 
> How is the PCI FLR sent to the device? Shouldn't PCI FLRs only be
> triggered by the SCSI LLD from inside an error handler callback? How can
> a PCI FLR be triggered while a START STOP UNIT command is being
> processed? Why can PCI FLRs only be triggered while a START STOP UNIT
> command is being processed and not while any other command is being
> processed?

The PCI FLR mentioned in my description is not sent to the SCSI device,
but to the SCSI host.

When the START STOP UNIT command is submitted to the SCSI device,
the command is sent to the SCSI device through the SCSI host.
If the user triggers the PCI FLR through the sysfs interface or
the host is reset due to an error, the START STOP UNIT command
(other commands are the same) is interrupted. So I think the command
needs to be retried.

> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 5cd88a8eea73..29f30407d713 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -4088,9 +4088,20 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>>   {
>>       unsigned char cmd[6] = { START_STOP };    /* START_VALID */
>>       struct scsi_sense_hdr sshdr;
>> +    struct scsi_failure failure_defs[] = {
>> +        {
>> +            .allowed = 3,
>> +            .result = SCMD_FAILURE_RESULT_ANY,
>> +        },
>> +        {}
>> +    };
>> +    struct scsi_failures failures = {
>> +        .failure_definitions = failure_defs,
>> +    };
>>       const struct scsi_exec_args exec_args = {
>>           .sshdr = &sshdr,
>>           .req_flags = BLK_MQ_REQ_PM,
>> +        .failures = &failures,
>>       };
>>       struct scsi_device *sdp = sdkp->device;
>>       int res;
> 
> The above change makes the START STOP UNIT command to be retried
> unconditionally. A START STOP UNIT command should not be retried
> unconditionally.
> 
> Please take a look at the following patch series (posted yesterday):
> https://lore.kernel.org/linux-scsi/20240807203215.2439244-1-bvanassche@acm.org/

I will reconsider the retry of the START STOP UNIT command, and try this patch series as well.

Thanks,

Yihang.
