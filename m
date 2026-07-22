Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDDB3AEF3B;
	Wed, 22 Jul 2026 09:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784711477; cv=none; b=rm44gmocRIZ6wUfro9H4ExVrZpMdWRX0pkx7+vs3IuHkXiiis4Z5lby76v3zp/qGLVtSsOG0xUFxo14KRfMVRkxy5xkaMNxULFN8WWgsUzLAY++lCwHwrpZGKtmTSg9G9RzvFngbmtBDjC55BukbFLRRWfxQbCsHio3+DxI9EKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784711477; c=relaxed/simple;
	bh=cUJ1jiWfulZa0peFWzzZswMOl2QBc+PMPOPbD677JEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jJkCwMBE/uu7ShsOCHE3Pi3/OdbR2tY6CE7YtfWGcFch72FEXJZoreP7qohr2veByrbOlAyWpqdjOjww/tFO8P2diFfVo3ssVASy+7y7MwsJkm77JQaIH+jY+BUpgZ7brIDnfxVN4krkwJWRRz+hfbHQqQAnELD9y18gGl6rloc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=c1J07+bH; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="c1J07+bH"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=p8jN3RkQ6Ocq04knol7ppcsRhdm16AU4RtOPX9Fx1iQ=;
	b=c1J07+bH3riyN9greurpydURSc7w6xz1VDsu3tUt9Q/Rc9AN1Wrt4tt1f7nll8gfGzUv/4yh5
	okkmeoSJYgEhX5Ua3gQ+1mZX6x5ZKRhlqWoD2Sv07BY2gxNMm78a3xsbGIYRlcvnliFnsjRg86I
	hpHzhR+D/tGFZBw3xdSHhrI=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4h4pCY56PSzmVWY;
	Wed, 22 Jul 2026 17:01:45 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 88EDE40578;
	Wed, 22 Jul 2026 17:11:08 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 22 Jul 2026 17:11:07 +0800
Message-ID: <d888a76c-7667-55f2-d047-b37412332ca7@huawei.com>
Date: Wed, 22 Jul 2026 17:11:00 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 2/2] scsi: hisi_sas: add spinup_notify callback to
 handle Active_Wait/Idle_Wait SSP devices
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<dlemoal@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<hare@suse.com>
References: <20260703022833.36847-1-yangxingui@huawei.com>
 <20260703022833.36847-3-yangxingui@huawei.com>
 <c9a91dd7-b158-4416-93bb-9ae1e1acb8a3@oracle.com>
 <55307987-d86b-f28c-7c39-0a6bafe182bb@huawei.com>
 <a2ecff55-aabd-48b4-a702-7e052646f22c@oracle.com>
 <7baf77e4-345b-3419-6562-f0e435227e5a@huawei.com>
 <c5390973-6db4-4191-8330-dea5830da4f0@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <c5390973-6db4-4191-8330-dea5830da4f0@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh100006.china.huawei.com (7.202.181.89) To
 kwepemj100018.china.huawei.com (7.202.194.12)


Hi, John.

On 2026/7/22 16:47, John Garry wrote:
> On 21/07/2026 14:33, yangxingui wrote:
>>>
>>> Yeah, it would be something like that.
>>>
>>> But the method to solve this issue is unclear.
>>>
>>> Back to the original issue: hisi_sas_spinup_notify_work() calls 
>>> sl_notify_ssp, but sl_notify_ssp is called already in 
>>> hisi_sas_phyup_work_common() - so why is it needed to be called again? 
>> In fact, the trigger for this point sometimes fails to take effect.
>>
>>> If it is because hisi_sas_phyup_work_common() is only for direct- 
>>> attached disks, and we need to call sl_notify_ssp for expander 
>>> attached disks?
>>
>> NOTIFY(SPIN UP) is primarily intended for direct-attached HDD wake-up 
>> post-IDENTIFY exchange. Routing it to an Expander may conflict with 
>> SAS topology constraints and could disrupt link-layer arbitration, 
>> indicating that a conditional disable mechanism for cfg_notify_en in 
>> non-direct topologies is advisable.
> 
> This problem which you are trying to solve is only for direct-attached 
> disks, right?

Yeah, I consulted the developer responsible for the Expander firmware, 
the firmware proactively sends a "spin-up" primitive when a sas disk is 
connected and specific conditions are met.

Based on the document below:
https://www.t10.org/ftp/t10/document.02/02-360r1.pdf

"7.1.4 SAS primitives
7.1.4.n SPINUP
...
Initiator devices and expander devices shall transmit SPINUPs while 
attached to target devices (i.e., devices
that report any target protocol support in their IDENTIFY address 
frames). They shall transmit one SPINUP
after power on when the enclosure is ready for initial target device 
spin-up. After the initial SPINUP, they shall
transmit SPINUP periodically.
...

SPINUP shall not be forwarded through expander devices."

Thanks,
Xingui


