Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC5F1C20;
	Wed, 19 Jun 2024 01:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718758900; cv=none; b=lnNPUeqadVwMEUXLuY5qHo0NAWZz6+2eNXYXJSlItji0GiEDrTsgZIl5h1zLrbtj8stzSL6xf5yv4AuAbDgRsxjqo71i0ywqYuMiSc5BU4bgGpEFz9GjyWsEE+n5dZAq2H5rbzyW/NLwAVTCz10eGuihOM3CYecJ2kVXCEj7xM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718758900; c=relaxed/simple;
	bh=HfrUQHKUfdTyX4Y7zj/TBDvU7xjtOZyPCFW72wYPSrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TvH0Zv+XxeQ32hFT4rFvOlYUy6EgipZH4ehJDR1qMhQlY0uMeXCfLpbaBlRzcDy1Mo+Jg5oWhKVHWN5Qo6c+57ouM5BrXYe5ulHTcKEvl1C4E/zSNFoXJucsk52BK34ecEJ2Z1ekS8khrXmxFujysHQdiCxTbDiMFJBe/4z7IvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4W3lZl4w9jz1SCDV;
	Wed, 19 Jun 2024 08:57:19 +0800 (CST)
Received: from dggpemd100001.china.huawei.com (unknown [7.185.36.94])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C84B18007A;
	Wed, 19 Jun 2024 09:01:34 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 19 Jun 2024 09:01:33 +0800
Message-ID: <2f408257-c516-8de1-4b3a-db77b0aa816f@huawei.com>
Date: Wed, 19 Jun 2024 09:01:33 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<damien.lemoal@opensource.wdc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
	<chenxiang66@hisilicon.com>, <kangfenglong@huawei.com>
References: <20240613122355.7797-1-yangxingui@huawei.com>
 <437c99f4-a67d-48d9-98ee-58cbbc3d19f4@oracle.com>
 <815fcddf-85cc-126e-4be1-618b5ba8f823@huawei.com>
 <bfc045d4-746e-4555-9e17-5a0be57ac787@oracle.com>
 <d590fde9-69bc-0b9c-c907-0b90838e5f94@huawei.com>
 <c4ad0886-6148-4714-b91e-3f669d438dcf@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <c4ad0886-6148-4714-b91e-3f669d438dcf@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggpemm500020.china.huawei.com (7.185.36.49) To
 dggpemd100001.china.huawei.com (7.185.36.94)

Hi, John

On 2024/6/18 23:21, John Garry wrote:
> On 18/06/2024 14:10, yangxingui wrote:
>>>>>
>>>>>> We found that it is judged as broadcast flutter when the 
>>>>>> exp-attached end
>>>>>> device reconnects after probe failed, as follows:
>>>>>>
>>>>>> [78779.654026] sas: broadcast received: 0
>>>>>> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
>>>>>> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has 
>>>>>> changed
>>>>>> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated 
>>>>>> BROADCAST(CHANGE)
>>>>>> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
>>>>>> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 
>>>>>> 500e004aaaaaaa05 (stp)
>>>>>> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
>>>>>> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, 
>>>>>> res 0x0
>>>>>> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>>>>>> ...
>>>>>> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 
>>>>>> failed: 0 tries: 1
>>>>>> [78835.171344] sas: sas_probe_sata: for exp-attached device 
>>>>>> 500e004aaaaaaa05 returned -19
>>>>>> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
>>>>>> [78835.187487] sas: broadcast received: 0
>>>>>> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
>>>>>> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has 
>>>>>> changed
>>>>>> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated 
>>>>>> BROADCAST(CHANGE)
>>>>>> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
>>>>>> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 
>>>>>> 500e004aaaaaaa05 (stp)
>>>>>> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
>>>>>> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, 
>>>>>> res 0x0
>>>>>>
>>>>>> The cause of the problem is that the related ex_phy's 
>>>>>> attached_sas_addr was
>>>>>> not cleared after the end device probe failed. In order to solve 
>>>>>> the above
>>>>>> problem, a function sas_ex_unregister_end_dev() is defined to 
>>>>>> clear the
>>>>>> ex_phy information and unregister the end device after the 
>>>>>> exp-attached end
>>>>>> device probe failed.
>>>>>
>>>>> Can you just manually clear the ex_phy's attached_sas_addr at the 
>>>>> appropiate point (along with calling sas_unregister_dev())? It 
>>>>> seems that we are using heavy-handed approach in calling 
>>>>> sas_unregister_devs_sas_addr(), which does the clearing and much more.
>>>>
>>>> I just tried it and it worked. If we only clear ex_phy's 
>>>> attached_sas_addr, there is no need to call sas_destruct_ports(). We 
>>>> are currently using sas_unregister_devs_sas_addr() which will add 
>>>> the port to sas_port_del_list, so we need to call 
>>>> sas_destruct_ports() separately to delete the port.
>>>>
>>>> Should we also delete the port after the devices probe failed?
>>>
>>> I'm not sure. Please check it.
>>>
>>> sas_fail_probe() would still call sas_unregister_dev(), as required.
>>>
>>> And you said that the sas_fail_probe() probe call would be 
>>> asynchronous to sas_revalidate_domainin(). I actually expected you to 
>>> have the new call to sas_destruct_ports() at the top of 
>>> sas_revalidate_domainin(), like v2, but it is in sas_probe_devices().
>>>
>>> Anyway, please check whether you require this additional call to 
>>> delete the port.
>>>
>> Sorry, there was something wrong with the previous process description.
>> the correct is:
>>
>> 1. REVALIDATING DOMAIN
>> 2. new device attached, create port,etc.
>> 4. done REVALIDATING DOMAIN
>> 5. @out, handle parent->port->sas_port_del_list
>> 6. sas_probe_devices()
>> 7. if device probe failed in step 6 and call 
>> sas_unregister_devs_sas_addr(), then add phy->port->list to 
>> parent->port->sas_port_del_list // port won't delete
>>
>> 8. next, REVALIDATING DOMAIN
>> 9. new device attached
>> 10. new port create failed, as port already exits.
>>
>>
>> So, v3 delete port at then end of sas_probe_devices(). And if we don't 
>> use sas_unregister_devs_sas_addr() follow your suggestion then we 
>> don't need to call sas_destruct_ports().
> 
> I am finding it hard to follow you now.
I'm sorry for that. ^-^
> 
> Can you show the complete change which you think that we now require to 
> fix this issue?
> 
Okay, I'll update a new version.

Thanks,
Xingui
