Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256C128F1;
	Thu,  6 Mar 2025 01:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741225471; cv=none; b=Z9gUxguVgWbxp2WMFT5T+2fZal27jsKiBvVLZpjGLJ2bBvOinxoay7YhNTxiqZdTgvWKeIuplh3XPp+3ortpxYq9ZBFLJsYlIL72hQ8b6yX2JsAGNvEBl6ZuvZn/GmB9LnaYt/oBTuFSshckCJT3mIMD39cxo6T33YfROal2nuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741225471; c=relaxed/simple;
	bh=xQ2zZpRbA3gl1OjUxsFggiHGH1qyq3+0l3RZ2SaaDwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=D5Bne0F9bJMHppjc7ZZNSIJfMyCRAkeBQhYck+CV0hf/wWPCE82M+DUzAVcCT/32r3pslbRzC28pF3QWXpCyQYeeAL+9/XmIx9hB2HW7ylkYmUqzj9mx5spDtJ8+7YEMryR0iTLPqwjrg5V9KqnKoGHjfKnHbs0dG4thQ5JzSn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Z7XFS5q9Dz21nyg;
	Thu,  6 Mar 2025 09:41:16 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id CA4D7180042;
	Thu,  6 Mar 2025 09:44:24 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 6 Mar 2025 09:44:23 +0800
Message-ID: <8d769d82-e429-6e25-8bb5-97ef5c2e7a62@huawei.com>
Date: Thu, 6 Mar 2025 09:44:23 +0800
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
 <d4b7ae14-5b60-883a-c4f8-be11fc51a4f7@huawei.com>
 <4f287a32-d24f-47dc-bec5-a4b94895e135@oracle.com>
 <9765d9c7-959f-3611-4093-89f7e941e2ba@huawei.com>
 <4279fe21-6db8-4deb-b5f7-663720637cf0@oracle.com>
 <2a59bb5c-797c-3745-384e-791a74858930@huawei.com>
 <cfef9d7d-adf9-43d8-9244-66f4eda081d2@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <cfef9d7d-adf9-43d8-9244-66f4eda081d2@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh500008.china.huawei.com (7.202.181.139) To
 kwepemg100017.china.huawei.com (7.202.181.58)


Hi, John

On 2025/3/6 0:15, John Garry wrote:
> On 05/03/2025 08:16, yangxingui wrote:
>>>
>>> Sure, something like that - you just need to get libsas to trigger 
>>> the proper hw port id assignment for the device. As for specific 
>>> implementation in the LLDD, that up to you guys.
>>
>> Thank you for your suggestions. The disk was finally restored to 
>> normal, but the error handling took a long time. Since the error 
>> handling would set the host to the recovery state, other disks on the 
>> same host would be blocked for a long time.
> 
> But that because you have IO inflight for the disk which was unplugged?

No, these are all ATA_CMD_ID_ATA commands newly issued by 
ata_eh_revalidate_and_attach() during error handling, and will be 
retried three times. The reason is that after the hw port id is changed, 
we set it to invalid, and these ATA_CMD_ID_ATA cmds will fail to execute.

Thanks,
Xingui

