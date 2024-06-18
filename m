Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319E8157A61;
	Tue, 18 Jun 2024 13:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716248; cv=none; b=gpI4s++AYdKGG6Xnmc2NT9T/Dv4RFvzGiiI53APm2W+kIQO5ie287C/P2Fo2P7wCcGgIOYSOQesVxNpdhFGyf6mbFZlsyeqz9PayhfxBYGxRK6BD+3tvFw98Khr5xXZhwIf1zZiiVI4S7m9tpTyNNPQAKmzR9Ap4fw2zGRX4NRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716248; c=relaxed/simple;
	bh=8ydzoB9n6kzJFfDJQQwwCGJCA3eroilH5ETLxVdh2Ek=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TiGX5pzSjxD3Zpede+nK5TEV5FureCw+73Ccgn1aF3bfNr+fEJQFODIwwaHL4GYuGZWxImG2grSnvQw2z7rGGi0S6uf61z4TriLDuAA//chwiXpoQcez1k8Y3Auk49/oKUtT4FzSqBzouhmZoI+RZkySZfzJw4KFxVcFmGHDduo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W3RpS1bSXzxSNN;
	Tue, 18 Jun 2024 21:06:24 +0800 (CST)
Received: from dggpemd100001.china.huawei.com (unknown [7.185.36.94])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A6C218006C;
	Tue, 18 Jun 2024 21:10:35 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 18 Jun 2024 21:10:35 +0800
Message-ID: <d590fde9-69bc-0b9c-c907-0b90838e5f94@huawei.com>
Date: Tue, 18 Jun 2024 21:10:34 +0800
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
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <bfc045d4-746e-4555-9e17-5a0be57ac787@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggpemm500008.china.huawei.com (7.185.36.136) To
 dggpemd100001.china.huawei.com (7.185.36.94)

Hi John,

On 2024/6/18 20:08, John Garry wrote:
> On 18/06/2024 12:45, yangxingui wrote:
>> Hi, John,
>>
>> Thanks for your reply.
>>
>> On 2024/6/18 16:55, John Garry wrote:
>>> On 13/06/2024 13:23, Xingui Yang wrote:
>>>
>>> Sorry for delay in responding and asking further questions.
>> It doesn't matter.
>>>
>>>> We found that it is judged as broadcast flutter when the 
>>>> exp-attached end
>>>> device reconnects after probe failed, as follows:
>>>>
>>>> [78779.654026] sas: broadcast received: 0
>>>> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
>>>> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>>>> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated 
>>>> BROADCAST(CHANGE)
>>>> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
>>>> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 
>>>> 500e004aaaaaaa05 (stp)
>>>> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
>>>> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
>>>> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>>>> ...
>>>> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 
>>>> 0 tries: 1
>>>> [78835.171344] sas: sas_probe_sata: for exp-attached device 
>>>> 500e004aaaaaaa05 returned -19
>>>> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
>>>> [78835.187487] sas: broadcast received: 0
>>>> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
>>>> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>>>> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated 
>>>> BROADCAST(CHANGE)
>>>> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
>>>> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 
>>>> 500e004aaaaaaa05 (stp)
>>>> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
>>>> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
>>>>
>>>> The cause of the problem is that the related ex_phy's 
>>>> attached_sas_addr was
>>>> not cleared after the end device probe failed. In order to solve the 
>>>> above
>>>> problem, a function sas_ex_unregister_end_dev() is defined to clear the
>>>> ex_phy information and unregister the end device after the 
>>>> exp-attached end
>>>> device probe failed.
>>>
>>> Can you just manually clear the ex_phy's attached_sas_addr at the 
>>> appropiate point (along with calling sas_unregister_dev())? It seems 
>>> that we are using heavy-handed approach in calling 
>>> sas_unregister_devs_sas_addr(), which does the clearing and much more.
>>
>> I just tried it and it worked. If we only clear ex_phy's 
>> attached_sas_addr, there is no need to call sas_destruct_ports(). We 
>> are currently using sas_unregister_devs_sas_addr() which will add the 
>> port to sas_port_del_list, so we need to call sas_destruct_ports() 
>> separately to delete the port.
>>
>> Should we also delete the port after the devices probe failed?
> 
> I'm not sure. Please check it.
> 
> sas_fail_probe() would still call sas_unregister_dev(), as required.
> 
> And you said that the sas_fail_probe() probe call would be asynchronous 
> to sas_revalidate_domainin(). I actually expected you to have the new 
> call to sas_destruct_ports() at the top of sas_revalidate_domainin(), 
> like v2, but it is in sas_probe_devices().
> 
> Anyway, please check whether you require this additional call to delete 
> the port.
> 
Sorry, there was something wrong with the previous process description.
the correct is:

1. REVALIDATING DOMAIN
2. new device attached, create port,etc.
4. done REVALIDATING DOMAIN
5. @out, handle parent->port->sas_port_del_list
6. sas_probe_devices()
7. if device probe failed in step 6 and call 
sas_unregister_devs_sas_addr(), then add phy->port->list to 
parent->port->sas_port_del_list // port won't delete

8. next, REVALIDATING DOMAIN
9. new device attached
10. new port create failed, as port already exits.


So, v3 delete port at then end of sas_probe_devices(). And if we don't 
use sas_unregister_devs_sas_addr() follow your suggestion then we don't 
need to call sas_destruct_ports().
Thanks,
Xingui
