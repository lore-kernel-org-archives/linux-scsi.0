Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005E5A92F;
	Sat, 10 Aug 2024 01:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723254426; cv=none; b=VbDfIZRweQu7nl1lRt7GK63P3g2zDUjLeKAhFGIL2/5gCmYf0VPEq/Igi1Pqs7j7LfjAA2eSVqxGWi3bFxAEHoHdRfUxLLX3zVw2miDeoie9lQomvksyMTA7QhLFj9I8KUEr3Dy01nR7eZqT9GzxETsZZWx545k0d2opvqS4ggg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723254426; c=relaxed/simple;
	bh=cgLvwEz1GMIOEyU6IGjZn2n7hbxnJKa1LNVI31BIvyI=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dD+TyfvJAXv0f27Ic4e1X1YmaAQdnzcQ01NoiswFY0YrFyCHNOknNgS60DpKZiQLafn1laApLI50snsAx0kaG7ODk/fnIs5qXl9Ek+0RJ1F82wdLP5w1j2TP84Sast/JanqNH2QuXWWBcl1SWI+qs0foaQikXTBHFyWqLRRjXS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Wgk6t3NxWz20l6m;
	Sat, 10 Aug 2024 09:42:30 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id A013B1A0188;
	Sat, 10 Aug 2024 09:46:59 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 10 Aug 2024 09:46:59 +0800
Subject: Re: [PATCH] scsi: sd: retry command SYNC CACHE if format in progress
To: Bart Van Assche <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
References: <20240808021719.4167352-1-liyihang9@huawei.com>
 <1cd0b145-431a-4d9f-979f-04d4063eeda8@acm.org>
 <e6b05d46-7acd-8364-2826-c14e342f8e2d@huawei.com>
 <7e6669da-d723-4eb4-8849-77e4deed5ffa@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<prime.zeng@huawei.com>, <linuxarm@huawei.com>, <liyihang9@huawei.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <d3ad4bab-e54e-5ad4-9b8c-ac6dea2a4c05@huawei.com>
Date: Sat, 10 Aug 2024 09:46:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <7e6669da-d723-4eb4-8849-77e4deed5ffa@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf100013.china.huawei.com (7.185.36.179)



On 2024/8/10 3:14, Bart Van Assche wrote:
> On 8/8/24 8:44 PM, Yihang Li wrote:
>> On 2024/8/9 3:09, Bart Van Assche wrote:
>>> On 8/7/24 7:17 PM, Yihang Li wrote:
>>>> If formatting a suspended disk (such as formatting with different DIF
>>>> type), the SYNC CACHE command will fail because the disk is in the
>>>> formatting process, which will cause the runtime_status of the disk to
>>>> error and it is difficult for user to recover it.
>>>>
>>>> To solve the issue, retry the command until format command is finished.
>>>
>>> How is the format command submitted to the SCSI disk? Is that command
>>> perhaps submitted as a SCSI pass-through command (SG_IO ioctl)?
>>>
>>
>> When formatting a suspended disk, the disk will be resuming first,
>> and then the format command will submit to the disk through SG_IO ioctl.
>>
>> When the disk is processing the formatting command, the system does not
>> submit other commands to the disk. Therefore, the system attempts to suspend
>> the disk again and sends the SYNC CACHE command. However, the SYNC CACHE
>> command fails because the disk is being formatted.
>>
>> Error info like:
>>
>> [  669.925325] sd 6:0:6:0: [sdg] Synchronizing SCSI cache
>> [  670.202371] sd 6:0:6:0: [sdg] Synchronize Cache(10) failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
>> [  670.216300] sd 6:0:6:0: [sdg] Sense Key : 0x2 [current]
>> [  670.221860] sd 6:0:6:0: [sdg] ASC=0x4 ASCQ=0x4
> 
> Please consider integrating this information in the patch description.

Ok, I will send a new version later.

> 
>>> Should the sd driver perhaps be unbound while the format command is in
>>> progress?
>>>
>>
>> I do not have any suggestions for this yet. I don't know how to unbound driver
>> when executing the format command and bound driver after the command is executed.
>>
>> If you have any suggestions, please let me know.
> 
> It seems like the PCI core supports binding and unbinding through sysfs
> but the SCSI core not. So it's probably easier to add support for
> ASC/ASCQ 04h / 04h rather than to add bind/unbind support to the SCSI
> core.

Thanks,

Yihang.
