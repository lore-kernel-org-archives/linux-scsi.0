Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805584C81;
	Tue, 13 Aug 2024 01:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723511655; cv=none; b=dS6D9h9gbW3dUlCR7wZTyWHFm4aDDGHc4QenMS4h6EY2qaxTj22yBvfXr24XYI0IE0PTqiZno/Ukih8fZ57C32v+GdeZeUeB78pUI9gfylndjFfZM7OSV+ukOzlXyN3bRVKWFqOFijDXd+bCQUq2Sv+IbFPGRt69SFRLlfsJFXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723511655; c=relaxed/simple;
	bh=QRJK1qrmLtmgWTXPkRp19MsZgzlSH8bpmDM3MgE5Krk=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=n3rgE+lkpdmnc6ENQWtfyzsmQ+1DvMYjMTEGfV7uX8V4/zlHLosul1b02MR9zLmGXUc7OKTyxUkUDZbFS92RtnkH1+ZwGjVZUMZTgux4/41sirE2UqZPvfwyHXlZW2xg1lrXeMQAX+xR8snPZj+3yR7aosXRsw7gQSAGvN0btwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WjYJX6h6fzfbNW;
	Tue, 13 Aug 2024 09:12:12 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 7AA48180102;
	Tue, 13 Aug 2024 09:14:09 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 13 Aug 2024 09:14:09 +0800
Subject: Re: [PATCH v2] scsi: sd: retry command SYNC CACHE if format in
 progress
To: Bart Van Assche <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
References: <20240810015912.856223-1-liyihang9@huawei.com>
 <be2a8462-38fb-4e74-905d-12bc9f678082@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <liyihang9@huawei.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <439a83c1-4a61-0ef3-b77e-917c6ae2d653@huawei.com>
Date: Tue, 13 Aug 2024 09:14:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <be2a8462-38fb-4e74-905d-12bc9f678082@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf100013.china.huawei.com (7.185.36.179)



On 2024/8/13 5:24, Bart Van Assche wrote:
> On 8/9/24 6:59 PM, Yihang Li wrote:
>> If formatting a suspended disk (such as formatting with different DIF
>> type), the disk will be resuming first, and then the format command will
>> submit to the disk through SG_IO ioctl.
>>
>> When the disk is processing the format command, the system does not submit
>> other commands to the disk. Therefore, the system attempts to suspend the
>> disk again and sends the SYNC CACHE command. However, the SYNC CACHE
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
>> Signed-off-by: Yihang Li <liyihang9@huawei.com>
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 
> If you want this patch to land in older kernels a "Cc: stable" tag will
> have to be added.
> 
ok, I will add this tag in patch v3.

Thanks,

Yihang.
