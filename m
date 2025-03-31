Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D7F1953A1;
	Mon, 31 Mar 2025 10:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743417000; cv=none; b=XcjJ0YYLMMpxzlVM/YgMqeWulBDjgf817uIVqXGnS7FxmIFqpBCvfXNn5JmXjamllfTlY92w6KrdAOv1wi5e9cXeK9KBxPqRMTbILki62ZEmFzX7VzqfDUN/XPjypLeeu7mQdIjaCOH1IfvbJt5GPKsyhBeEx5kS6Eo8S5RsC4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743417000; c=relaxed/simple;
	bh=ARAKG5Y9y6gbZsJBaTsmRHFtA/qItug5bAy+vkub5Os=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Lwe37FtuwtUYqvlJOloxiOP29NGdOaZnNNyAWSAbsQm64PKlPgYupfWPNymY8ZjgquT+m62YQsfLZq8FeHACkkQxaWhkWpJ4s7KZVlFG2F6Lk5hbNg75CIIPYvVEEPYEcBC6HDzUr3U7+zRTiGkU+5ypaZtoyYvbgXGHD6CcMv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZR6mF1ZH7ztRQM;
	Mon, 31 Mar 2025 18:28:29 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id BF4991400DC;
	Mon, 31 Mar 2025 18:29:54 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 31 Mar 2025 18:29:54 +0800
Subject: Re: [PATCH 1/5] scsi: hisi_sas: Add host_tagset_enable module param
 for v3 hw
To: Niklas Cassel <cassel@kernel.org>, yangxingui <yangxingui@huawei.com>,
	John Garry <john.g.garry@oracle.com>
References: <20250329073236.2300582-1-liyihang9@huawei.com>
 <20250329073236.2300582-2-liyihang9@huawei.com>
 <f53505e6-9bfa-4553-91cc-497512a6977f@oracle.com>
 <e5ab4e5a-33d0-6102-1c5c-f1f83a752346@huawei.com> <Z-pVGyZ1vMBhUfYH@ryzen>
CC: <martin.petersen@oracle.com>, <James.Bottomley@hansenpartnership.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>,
	<dlemoal@kernel.org>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <f26d6a94-5b67-7b5b-a9bd-39c58b662424@huawei.com>
Date: Mon, 31 Mar 2025 18:29:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Z-pVGyZ1vMBhUfYH@ryzen>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)

Hi all,

Thanks for the discussion. I will remove this patch for this series and send a new version later.

Thanks,
Yihang

On 2025/3/31 16:40, Niklas Cassel wrote:
> Hello Xingui,
> 
> On Sat, Mar 29, 2025 at 05:49:47PM +0800, yangxingui wrote:
>> Hi，John
>>
>> On 2025/3/29 16:50, John Garry wrote:
>>> On 29/03/2025 07:32, Yihang Li wrote:
>>>
>>> +
>>>
>>>> From: Xingui Yang<yangxingui@huawei.com>
>>>>
>>>> After driver exposes all HW queues and application submits IO to multiple
>>>> queues in parallel, if NCQ and non-NCQ commands are mixed to sata disk,
>>>> ata_qc_defer() causes non-NCQ commands to be requeued and possibly
>>>> repeated
>>>> forever.
>>>
>>> I don't think that it is a good idea to mask out bugs with module
>>> parameters.
>>>
>>> Was this the same libata/libsas issue reported some time ago?
>>
>> Yeah，related to this issue: https://lore.kernel.org/linux-block/eef1e927-c9b2-c61d-7f48-92e65d8b0418@huawei.com/
>>
>> And, Niklas tried to help fix this problem:
>> https://lore.kernel.org/linux-scsi/ZynmfyDA9R-lrW71@ryzen/
>>
>> Considering that there is no formal solution yet. And our users rarely use
>> SATA disks and SAS disks together on a single machine. For this reason, they
>> can flexibly turn off the exposure of multiple queues in the scenario of
>> using only SATA disks. In addition, it is also convenient to conduct
>> performance comparison tests to expose multiple hardware queues and single
>> queues.
> 
> The solution I sent is not good since it relies on EH.
> 
> One would need to come up with a better solution to fix libsas drivers,
> possibly a workqueue.
> 
> I think Damien is planning to add a workqueue submit path to libata,
> if so, perhaps we could base a better solution on top of that.
> 
> 
> Kind regards,
> Niklas
> 
> .
> 
