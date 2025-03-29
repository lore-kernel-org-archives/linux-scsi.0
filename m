Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92091ACECB;
	Sat, 29 Mar 2025 09:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743241795; cv=none; b=pcub4uC+CWv6TyN0qCtM2Et1iYA38vWa41ioe7mmPop2jtkBIhwrcH4tzL1kKsOBqivW9fSY3dpxVV+mjDFg+Ik6HQhs4e2RaZupMiEQSYqwLCaxLfkQqA09S+KFdSo6dVkn6PwXwwnSYbnVlGj511yUWFLlwYzRWyz4ko7UzPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743241795; c=relaxed/simple;
	bh=2G2NsAwlFU3vIghi+zrQF9XHVA+fpjd8DdexKeUhLQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fqpKGPGg3RN7FasmE2tGmOJBkk5zGiM0f0R81vjgPh6H4auD99MKInDYIcwXQrv34ExArHX+zDW8c/T4NlYXdChXbQWkF+M3Xi6YI8p6YjJEndtpU+F+h75V6bj9bJ4WRJ1zmouqhn2swCBkC4ug+rtKx55pqESrurGROuplQKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZPswJ1tFDzCsKk;
	Sat, 29 Mar 2025 17:46:08 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 86FEA140146;
	Sat, 29 Mar 2025 17:49:48 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Mar 2025 17:49:47 +0800
Message-ID: <e5ab4e5a-33d0-6102-1c5c-f1f83a752346@huawei.com>
Date: Sat, 29 Mar 2025 17:49:47 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 1/5] scsi: hisi_sas: Add host_tagset_enable module param
 for v3 hw
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, Yihang Li <liyihang9@huawei.com>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>,
	<"linux-ide@"@vger.kernel.org>
References: <20250329073236.2300582-1-liyihang9@huawei.com>
 <20250329073236.2300582-2-liyihang9@huawei.com>
 <f53505e6-9bfa-4553-91cc-497512a6977f@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <f53505e6-9bfa-4553-91cc-497512a6977f@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500012.china.huawei.com (7.202.181.145) To
 kwepemg100017.china.huawei.com (7.202.181.58)

Hi，John

On 2025/3/29 16:50, John Garry wrote:
> On 29/03/2025 07:32, Yihang Li wrote:
> 
> +
> 
>> From: Xingui Yang<yangxingui@huawei.com>
>>
>> After driver exposes all HW queues and application submits IO to multiple
>> queues in parallel, if NCQ and non-NCQ commands are mixed to sata disk,
>> ata_qc_defer() causes non-NCQ commands to be requeued and possibly 
>> repeated
>> forever.
> 
> I don't think that it is a good idea to mask out bugs with module 
> parameters.
> 
> Was this the same libata/libsas issue reported some time ago?

Yeah，related to this issue: 
https://lore.kernel.org/linux-block/eef1e927-c9b2-c61d-7f48-92e65d8b0418@huawei.com/

And, Niklas tried to help fix this problem: 
https://lore.kernel.org/linux-scsi/ZynmfyDA9R-lrW71@ryzen/

Considering that there is no formal solution yet. And our users rarely 
use SATA disks and SAS disks together on a single machine. For this 
reason, they can flexibly turn off the exposure of multiple queues in 
the scenario of using only SATA disks. In addition, it is also 
convenient to conduct performance comparison tests to expose multiple 
hardware queues and single queues.

Thanks,
Xingui
