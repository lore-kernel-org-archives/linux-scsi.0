Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3EC136E23;
	Fri, 31 May 2024 08:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717145631; cv=none; b=Z/SUYBzO9VxdtMLLpoEejPRDGJymTf/ZNW4FSjuYF0tgd70ysfpnDex5sPBkzpC/WK5KbpH+Kj11rO77STQXDzY+uFT5rpx7paEQu2WgDN09tvLJ9LOTc9AkBvawJeISQmmqxZ3G8ciDiARyEO65yE0ZWtIZDKX9Hs7/1PNAEG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717145631; c=relaxed/simple;
	bh=GX83tVnVrrE7CbGvDzxEtC/0sBHxwKgPFSeDxJFmwi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Td/7gsLMbQ2u5DPa2UQ8uSkIjeh6/hg8V/kTX34D5tTO/xA9MEPqf47v3S+iZo0K8rrzYLrunEfcP59HTUDPKYIz1IX+OUlw0XHF6fCsMXFKDuvwqGTECOsQDHtALVwivw0DDMuBaaW+VbM+4e07pb55cyJy3UUlQ/b8qUgucCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4VrH1h05sZz1xs93;
	Fri, 31 May 2024 16:52:24 +0800 (CST)
Received: from dggpemd100001.china.huawei.com (unknown [7.185.36.94])
	by mail.maildlp.com (Postfix) with ESMTPS id EA5701A016C;
	Fri, 31 May 2024 16:53:41 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 31 May 2024 16:53:41 +0800
Message-ID: <d4b6ed9b-8beb-025b-fc60-078a3fd7e471@huawei.com>
Date: Fri, 31 May 2024 16:53:41 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<damien.lemoal@opensource.wdc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
	<chenxiang66@hisilicon.com>, <kangfenglong@huawei.com>
References: <20240424080807.8469-1-yangxingui@huawei.com>
 <824c34aa-7c4c-4edd-b41c-f9b5ff5aff03@oracle.com>
 <12ea14e9-5821-b2b5-16c1-ac48985927d7@huawei.com>
 <a8b18cea-cc04-47d0-8ff0-b02dd087dc73@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <a8b18cea-cc04-47d0-8ff0-b02dd087dc73@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggpemm100003.china.huawei.com (7.185.36.68) To
 dggpemd100001.china.huawei.com (7.185.36.94)


Hi John,
On 2024/5/28 18:11, John Garry wrote:
> On 25/05/2024 04:08, yangxingui wrote:
>>> Why do these new additions not cover the same job which those calls 
>>> to the same functions @out covers?
>> For asynchronous probes like sata, the failure occurs after @out. 
>> After adding the device to port_delete_list, the port is not deleted 
>> immediately. This may cause the device to fail to create a new port 
>> because the previous port has not been deleted when the device 
>> attached again. as follow:
>>
>> 1. REVALIDATING DOMAIN
>> 2. new device attached
>> 3. ata_sas_async_probe
>> 4. done REVALIDATING DOMAIN
>> 5. @out, handle parent->port->sas_port_del_list
>> 6. sata probe failed
>> 7. add phy->port->list to parent->port->sas_port_del_list // port 
>> won't delete now
>>
>> 8、REVALIDATING DOMAIN
>> 9、new device attached
>> 10、new port create failed, as port already exits.
>>
> ok, so next please consider these items:
> 
> - add a helper for calling sas_destruct_devices() and sas_destruct_ports().
> 
> - add a comment on why we have this new extra call to 
> sas_destruct_devices() and sas_destruct_ports()
> 
> - can we put the new call to sas_destruct_devices() and 
> sas_destruct_ports() after 7, above? i.e. the
> sas_probe_devices() call? It would look a bit neater.

Yes, this is much simpler. I will test it more according to your suggestion.

Thanks,
Xingui
