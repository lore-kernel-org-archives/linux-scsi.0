Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B112641C7;
	Tue, 25 Feb 2025 09:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740476140; cv=none; b=YJu+1jZaw+OsIrENHgZlwk9YWiYZrqgI6p2rJkpBGP8ZZ1DBtJW7PAgi4J3ZjmXMPvWEXBnkMxIrW4+plc2NDT10PRO1j/1HB6ExzRk6G1E7Vd0AHs6rc66BlnWzX3HOoNQUAOW2hhBoDyugm2up07zrPJaGY7TDGL9urfkoRXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740476140; c=relaxed/simple;
	bh=VzmHHAJ4lfXuHw0Z6bdVgeMX5QBu24Qi/C6qVXpxxRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=p1WbUr5A2lzRyR0iwsrNIevdyoK7ppJQURZ3opU8/iiUrh2KvW2Jsvgobmm/PmI79pizpphSbR/rs+MX0hGnaEZJhF0VeenfbeZjjRlw56o1aP1x+TdBss+mjA9jSWP2B0J/AfA3e81P9dpt6oftK4dI43cGgIeDUucvYxFFmXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Z2C6C2pwnz2CpdL;
	Tue, 25 Feb 2025 17:31:31 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id BFCA3140203;
	Tue, 25 Feb 2025 17:35:33 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 25 Feb 2025 17:35:33 +0800
Message-ID: <d4b7ae14-5b60-883a-c4f8-be11fc51a4f7@huawei.com>
Date: Tue, 25 Feb 2025 17:35:22 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <liyihang9@huawei.com>,
	<yanaijie@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>, <liyangyang20@huawei.com>,
	<f.fangjian@huawei.com>, <xiabing14@h-partners.com>
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
 <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
 <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
 <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
 <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
 <d233a108-a46e-47dd-86ad-756c60c8665e@oracle.com>
 <cc9ba6f8-1efb-4910-8952-9ca07c707658@huawei.com>
 <5d34595f-ff57-4679-b263-fa3fea006ce3@oracle.com>
 <25552c7d-858d-ea1e-0987-55f71642a503@huawei.com>
 <420fde94-28ec-4321-943b-5cb84cf14f0e@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <420fde94-28ec-4321-943b-5cb84cf14f0e@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh200004.china.huawei.com (7.202.181.111) To
 kwepemg100017.china.huawei.com (7.202.181.58)

Hi, John

On 2025/2/25 16:19, John Garry wrote:
> On 25/02/2025 01:48, yangxingui wrote:
>>>
>>>
>>> pm8001 sends sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,) 
>>> link reset errors - can you consider doing that in 
>>> hisi_sas_update_port_id() when you find an inconstant port id?
>> Currently during phyup, the hw port id may change, and the 
>> corresponding hisi_sas_port.id and the port id in itct are not updated 
>> synchronously. The problem caused is not a link error, so we don't 
>> need deform port, just update the port id when phyup.
> 
> Sure, but I am just trying to keep this simple. If you deform and reform 
> the port - and so lose and find the disk (which does the itct config) - 
> will that solve the problem?

1、phyup ->form port -> eh -> ata reset -> found hw port change -> 
deform port -> let dev gone -> refound

2、controller reset -> phyup -> finish controller reset -> found hw port 
change -> deform port -> let dev gone -> refound

I also thought about the plan you mentioned in the early days. The above 
will make the process more complicated and retriggering phyup may result 
in a new round of port id changes. Lose and find the disk will cause the 
upper layer IO to report error when controller reset. It seems that it 
is better to make the upper layer unaware of the hw port id change when 
phyup in reset, like ata reset or controller reset. ^_^

Thanks,
Xingui

