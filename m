Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B04229B01;
	Mon, 10 Mar 2025 13:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612163; cv=none; b=N/YSm94v+9Tad7Esusc0PK4+psBYz0qvfu4wuotWq9CN3euWbcOqNso1rFx2vykkfwJVr0/+wp/ju/f2+TqaR4JmGsdsBiZuQhKf8AxEKCMeeyTh1cKzzUFMwbcW4nc41PxDlunZLX0VYlImU+5JXCAzc9Xb+KMQ3Mb9qRxUh5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612163; c=relaxed/simple;
	bh=tlca46uB4gXZyiSoLwdM6jMebWtzZXX1UAB5ei9AbZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Pjs2QVhYpTuk1vuWVHFEtpzWO4Ah7NfQaMMFG6ys3oEoCU58RkJWqQ7nt2L73/S0t3fA3xV2Se/g4eapL9T03cYkF93xVzrKA2jhlu9FmGMsV4VLLiN90cSmiQw3DwiQYRPFEDM110rnHi8bs+/998o2EyO7mmC+RB7rUTgYmnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZBHDV6Kwsz2RTL8;
	Mon, 10 Mar 2025 21:04:58 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 078BC1401F0;
	Mon, 10 Mar 2025 21:09:18 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 10 Mar 2025 21:09:17 +0800
Message-ID: <d0a6b502-328b-2f83-3cdf-55c1effd80c1@huawei.com>
Date: Mon, 10 Mar 2025 21:09:16 +0800
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
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh200008.china.huawei.com (7.202.181.115) To
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
> 
We found that we need to perform lose and find for all devices on the 
port including the local phy and the remote phy. This process still 
requires traversing the phy information corresponding to all devices to 
reset and it is also necessary to consider that there is a race between 
device removal and the current process.  it looks similar to solution of 
update port id directly. And there will be the problem mentioned above. 
e.g, during error handling, the recovery state will last for more than 
15 seconds, affecting the performance of other disks on the same host.


Thanks,
Xingui


