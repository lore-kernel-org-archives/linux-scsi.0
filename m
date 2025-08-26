Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1C528D8ED;
	Tue, 26 Aug 2025 08:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756198072; cv=none; b=McwDZDp8Q6yDKEvtnVfjPBjSGqJuB+U8DusAXwSRVS2mmGn6mSjYTK++3kBU/8EdEYoL6e7jp9/4bJ/UYB/Rpdr7QcleRuq/iRZq2E0C5UfeyxHKvuChNjyq2EPZvABCFOyLCvzs9c5Bsygc5I3pjgKNpvCXJjsR+5KjtG+78Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756198072; c=relaxed/simple;
	bh=Gwo0aKyr9J8G5DjEjiGm/JVgVdLbWa/sI/d4yxPg5O4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gIVHnqxmdgY5mKw0PjB4ajFfyHrVEhncxGj3d7lyuH/Tm9BiaszdKYX8bbmeq5yUNLs1kpaJQ/cINBo59hB0cR2hDvMg0tVVixnjEuJIW7em2WYuwQXg7eMPT9eEs1JpF+QjzSwYVei+6JgpOXFwFRN+FuU5ujQGdDR7t1NLQnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cB1RR6NN6z13NVY;
	Tue, 26 Aug 2025 16:44:03 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id D3D67180087;
	Tue, 26 Aug 2025 16:47:44 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 Aug 2025 16:47:43 +0800
Message-ID: <41077713-8119-4898-8307-731a0d8f346e@huawei.com>
Date: Tue, 26 Aug 2025 16:47:43 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Switch to use tasklet over threaded
 irq handling
To: Yihang Li <liyihang9@h-partners.com>, Bart Van Assche
	<bvanassche@acm.org>, <martin.petersen@oracle.com>,
	<James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
 <f02e9bb8-3477-4fa7-8b20-72bd518407ed@acm.org>
 <2f2e5534-a368-547d-dedf-78f8ca2fc999@h-partners.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <2f2e5534-a368-547d-dedf-78f8ca2fc999@h-partners.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/8/25 9:42, Yihang Li 写道:
> Hi Bart,
> 
> On 2025/8/22 23:17, Bart Van Assche wrote:
>> On 8/22/25 12:59 AM, Yihang Li wrote:
>>> We found that when the CPU handling the interrupt thread is occupied by
>>> other high-priority processes, the interrupt thread will not be scheduled.
>>> So there is a change to switch the driver to use tasklet over threaded
>>> interrupt handling.
>> Tasklets have severe disadvantages and hence their removal has been
>> proposed several times. See e.g. https://lwn.net/Articles/960041/.
>> There must be a better solution than switching to tasklets.
>>
> 
> Thanks you for your reply. I will consider some other solution.
> Additionally, do you have any good suggestions?

It seems the official replacement of tasklets is WQ_BH. However there 
are very few users now. I'm not sure if the stability and performance 
can meet our requirements.

> 
>> Bart.
>> .
>>
> 
