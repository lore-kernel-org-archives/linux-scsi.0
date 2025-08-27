Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE37925BEE7;
	Wed, 27 Aug 2025 02:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756260904; cv=none; b=ul+tznfhuUiVwyMpiZMD9f8wrBFbIU/+m8iRPEOv1zx0myC8pbBkLmRIPK4un9dBZG5El0qLbMSPI2p7ML/XNLYLo9CDG2uvSxY7tl88y7SMqglt4d03Aht+RlDFJTvP+kWvpOLvjFnjfPZOOH4MVAY5qjhgkp393boHNuZSpRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756260904; c=relaxed/simple;
	bh=FlxkxCmqZG6UN0Js21iWVeMu1t3W5dSBaknWCf2D5es=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=txB9o+kXU+o29KbjSYfiEYkEXGtYAK7e2fKjjAVBs8dPZM34nyRsIimNreYO7kbTXlsJzVIQa5yiZ3t/87YonCPFUdb8I7Fg6QwMhBlU6bot1UtFjSKVo9FpzQcWmB0SeB6Sd8Jxb31HuxkSUFBgOhrDbXfXwJTUedmfpJFUKVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cBSfj5vY4zPqTy;
	Wed, 27 Aug 2025 10:10:21 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id 03F0F180485;
	Wed, 27 Aug 2025 10:14:58 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 Aug 2025 10:14:57 +0800
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Switch to use tasklet over threaded
 irq handling
To: Jason Yan <yanaijie@huawei.com>, Bart Van Assche <bvanassche@acm.org>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
 <f02e9bb8-3477-4fa7-8b20-72bd518407ed@acm.org>
 <2f2e5534-a368-547d-dedf-78f8ca2fc999@h-partners.com>
 <41077713-8119-4898-8307-731a0d8f346e@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>,
	Yihang Li <liyihang9@h-partners.com>
From: Yihang Li <liyihang9@h-partners.com>
Message-ID: <58f31c71-1d70-e763-45b4-66b4778ba028@h-partners.com>
Date: Wed, 27 Aug 2025 10:14:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <41077713-8119-4898-8307-731a0d8f346e@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemh200005.china.huawei.com (7.202.181.112)

Hi, Jason

On 2025/8/26 16:47, Jason Yan wrote:
> 在 2025/8/25 9:42, Yihang Li 写道:
>> Hi Bart,
>>
>> On 2025/8/22 23:17, Bart Van Assche wrote:
>>> On 8/22/25 12:59 AM, Yihang Li wrote:
>>>> We found that when the CPU handling the interrupt thread is occupied by
>>>> other high-priority processes, the interrupt thread will not be scheduled.
>>>> So there is a change to switch the driver to use tasklet over threaded
>>>> interrupt handling.
>>> Tasklets have severe disadvantages and hence their removal has been
>>> proposed several times. See e.g. https://lwn.net/Articles/960041/.
>>> There must be a better solution than switching to tasklets.
>>>
>>
>> Thanks you for your reply. I will consider some other solution.
>> Additionally, do you have any good suggestions?
> 
> It seems the official replacement of tasklets is WQ_BH. However there are very few users now. I'm not sure if the stability and performance can meet our requirements.
> 

Yes, so I will first attempt to modify it using WQ_BH,
and after thorough testing and verification,
I will report the solution to everyone.

Thanks,

Yihang.
