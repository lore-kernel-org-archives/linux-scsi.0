Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6228801;
	Mon, 19 Aug 2024 04:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724040439; cv=none; b=LfYnC4COGlWtxnBEldQHWrfk5aMH6i+2j5Hhm9tLJTvGVgUGYved7Xj/ZNOo3e8bJ0p4U71N/NHEJmCjoMvAg70RHiaciGicYW7Umyga5FRg7/BvTb35z6T8Wkf612BxRYJTR12GHxQJiD9tmk4oAsJtL9QZJptL1HTtGbhr+4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724040439; c=relaxed/simple;
	bh=YC4pg6rIZ6V7oITQ3r15iFjLXh/SwMR391VwGJ8UtSc=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mstztF0A1T5lLvbqijk2GxfSLShvjgd+dkka0LjzFuLCoI4s9xIsCLxhmV69ragsPr0iZ4kJeUaB1dBk1990C7QhoCDbG7eK8CHD33Lz6bIgJ0SnmItsN/G9igwNI3UzPBIZXm7RUbm5LzYrmKJuqcqHmP7qqcgQWo/c+Zs+XnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WnJvL639szyR0y;
	Mon, 19 Aug 2024 12:06:54 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 00D231800F2;
	Mon, 19 Aug 2024 12:07:15 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Aug 2024 12:07:14 +0800
Subject: Re: [PATCH v4] scsi: sd: retry command SYNC CACHE if format in
 progress
To: Damien Le Moal <dlemoal@kernel.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
References: <20240817015019.3467765-1-liyihang9@huawei.com>
 <10c56cbc-a367-44c3-8b14-b846a3c4e4a0@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<bvanassche@acm.org>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<stable@vger.kernel.org>, <liyihang9@huawei.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <4618fc13-4499-53f1-efea-0487f436b353@huawei.com>
Date: Mon, 19 Aug 2024 12:07:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <10c56cbc-a367-44c3-8b14-b846a3c4e4a0@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf100013.china.huawei.com (7.185.36.179)



On 2024/8/19 7:55, Damien Le Moal wrote:
> On 8/17/24 10:50, Yihang Li wrote:
>> If formatting a suspended disk (such as formatting with different DIF
>> type), the disk will be resuming first, and then the format command will
>> submit to the disk through SG_IO ioctl.
>>
>> When the disk is processing the format command, the system does not submit
>> other commands to the disk. Therefore, the system attempts to suspend the
>> disk again and sends the SYNC CACHE command. However, the SYNC CACHE
> 
> Why would the system try to suspend the disk with a request in flight ? Sounds
> like there is a bug with PM reference counting, no ?

According to my understand and test, the format command request is finished,
so it is not in flight for the kernel. And the command need a few time to processing
in the disk while no other commands are being sent.

> 
>> command will fail because the disk is in the formatting process, which
>> will cause the runtime_status of the disk to error and it is difficult
>> for user to recover it. Error info like:
>>
>> [  669.925325] sd 6:0:6:0: [sdg] Synchronizing SCSI cache
>> [  670.202371] sd 6:0:6:0: [sdg] Synchronize Cache(10) failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
>> [  670.216300] sd 6:0:6:0: [sdg] Sense Key : 0x2 [current]
>> [  670.221860] sd 6:0:6:0: [sdg] ASC=0x4 ASCQ=0x4
>>
>> To solve the issue, retry the command until format command is finished.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Yihang Li <liyihang9@huawei.com>
>> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>> Changes since v3:
>> - Add Cc tag for kernel stable.
>>
>> Changes since v2:
>> - Add Reviewed-by for Bart.
>>
>> Changes since v1:
>> - Updated and added error information to the patch description.
>>
>> ---
>>  drivers/scsi/sd.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index adeaa8ab9951..5cd88a8eea73 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1823,6 +1823,11 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>>  			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
>>  				/* this is no error here */
>>  				return 0;
>> +
>> +			/* retry if format in progress */
>> +			if (sshdr.asc == 0x4 && sshdr.ascq == 0x4)
>> +				return -EBUSY;
>> +
>>  			/*
>>  			 * This drive doesn't support sync and there's not much
>>  			 * we can do because this is called during shutdown
> 
