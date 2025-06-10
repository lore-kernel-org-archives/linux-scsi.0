Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947D4246BC7
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2025 13:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749563479; cv=none; b=F1O1xzuqTElnzys+qSGVoCGEKlX507WU9zVbeIcQGpSuQJot2MuJCWU3mXtg+SWDfskPvzSxGAW05rGeNgr2S3fHjBnKh4wPWbIGhak8LnNzvJaKagNZhz2do8Kq0sI+TYEnagdCfhb9ybCrm5unMA57z8+jV2jH5XrlZ9mKQ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749563479; c=relaxed/simple;
	bh=sGvfl2J2l5Sw7C/rGbbtlebQ772xAlONBhQX0IfDXKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Dy2gzJM3I/X5/csjXK8e8JgJYggEZb2q8Y8WDfZi6HLjJ9LZjbIKt05KrZOvE6lh4We5xUWFb56F42OdiZKCG17UpxsUt7yyoqG9kHbR9xjmEV6Hu7EdapeK23UvTtIDkIsqQqnfLQy9ozb0EFjWIJXrnyp7MRkUFf9KcQS6/9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bGqQj30rLz1W3LZ;
	Tue, 10 Jun 2025 21:29:49 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 885B814034D;
	Tue, 10 Jun 2025 21:33:40 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Jun 2025 21:33:39 +0800
Message-ID: <48639da7-5451-49f7-8a6c-375b67d8060d@huawei.com>
Date: Tue, 10 Jun 2025 21:33:39 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
To: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>, 'John Garry'
	<john.g.garry@oracle.com>, "'james.bottomley@hansenpartnership.com'"
	<James.Bottomley@HansenPartnership.com>, "'Martin K . Petersen'"
	<martin.petersen@oracle.com>
CC: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
References: <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
 <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
 <SJ0PR19MB5415A5F70B0D51BA96CBC76DC4E42@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <b82bee4f-67b7-4355-a152-1f13d4918220@oracle.com>
 <SJ0PR19MB5415CFA77DCC17E0BFAEEF76C4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <eb90005b-1ef7-4bb6-bc62-84af5a03e3e7@oracle.com>
 <SJ0PR19MB54152471D18241A020914B2AC4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <ec087459-ae19-f593-f046-846c041e397d@huawei.com>
 <SJ0PR19MB5415CA74D010E7D35263FFDCC4E32@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH7PR19MB7533B517D647D88C48BE215CC46AA@PH7PR19MB7533.namprd19.prod.outlook.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <PH7PR19MB7533B517D647D88C48BE215CC46AA@PH7PR19MB7533.namprd19.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500002.china.huawei.com (7.185.36.57)


在 2025/6/10 21:05, Li, Eric (Honggang) 写道:
> Jason,
> 
> Sorry for bothering you.
> Is this fix merged into kernel upstream?
> If so, could you please let me know which Linux kernel version includes this fix?
> Thanks.
> 
> Eric LI (Honggang)

I'm afraid it's not merged yet. I don't have a libsas hardware now so 
it's not been tested. Did you test this patch?

Thanks,
Jason

祝一切顺利！
