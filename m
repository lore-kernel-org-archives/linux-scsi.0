Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10957FBBF;
	Wed, 19 Jun 2024 09:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718789097; cv=none; b=eXdF0/Dm8G2HgjBnxz8jcjCtlCUy5O3Z+tvANiJZ+7vvWh3ktyVfRi1TnKvVkdjkknWEO0wNe+5zVTWjoMw45eCj9Puff7OR47dIxeImoTkJX6VCREpWRWx9OV1JBlafW95aSsA9d5mrbdVaoU3rBSsswBDCkw865u8l/ExOG1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718789097; c=relaxed/simple;
	bh=hN6kdnLBTquDXR9KrmJk7yIsGzVwE9lDcA2ZQdIL3wI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=n+0kB3zeIUbZjWAWyAS+7j3llXhwajop4i56xoZEPYoExbQQJUqTW5BeEDOxj+1kY3oNx+/wHNI1UnU2mxFo07TdqRBBbiI9nEKUuL2URTeFZ9A0UsXLKIhPeH8GrWDaADPCW2ZAuMyouPds5HI1HjxxXnPGCOahKupO9+R7y6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4W3yNw3MCqznWSR;
	Wed, 19 Jun 2024 17:04:32 +0800 (CST)
Received: from dggpemd100001.china.huawei.com (unknown [7.185.36.94])
	by mail.maildlp.com (Postfix) with ESMTPS id CE6A518007A;
	Wed, 19 Jun 2024 17:09:26 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 19 Jun 2024 17:09:26 +0800
Message-ID: <df7b4ee6-0d75-9ed5-f147-3c180be6d4a5@huawei.com>
Date: Wed, 19 Jun 2024 17:09:26 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<damien.lemoal@opensource.wdc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
	<chenxiang66@hisilicon.com>, <kangfenglong@huawei.com>
References: <20240619032815.3499-1-yangxingui@huawei.com>
 <45175ca4-d0da-42ca-97b9-f3891bf13c53@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <45175ca4-d0da-42ca-97b9-f3891bf13c53@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggpemm500007.china.huawei.com (7.185.36.183) To
 dggpemd100001.china.huawei.com (7.185.36.94)

Hi John,

On 2024/6/19 15:50, John Garry wrote:
> On 19/06/2024 04:28, Xingui Yang wrote:
>> The expander phy will be treated as broadcast flutter in the next
>> revalidation after the exp-attached end device probe failed, as follows:
>>
>> [78779.654026] sas: broadcast received: 0
>> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
>> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated 
>> BROADCAST(CHANGE)
>> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
>> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 
>> 500e004aaaaaaa05 (stp)
>> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
>> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
>> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>> ...
>> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
>> tries: 1
>> [78835.171344] sas: sas_probe_sata: for exp-attached device 
>> 500e004aaaaaaa05 returned -19
>> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
>> [78835.187487] sas: broadcast received: 0
>> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
>> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated 
>> BROADCAST(CHANGE)
>> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
>> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 
>> 500e004aaaaaaa05 (stp)
>> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
>> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
>>
>> The cause of the problem is that the related ex_phy's 
>> attached_sas_addr was
>> not cleared after the end device probe failed, so reset it.
>>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> 
> Apart from a couple of comments, below:
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
>> ---
>> Changes since v3:
>> - Just manually clear the ex_phy's attached_sas_addr instead of calling
>>    sas_unregister_devs_sas_addr() and deleting the port.
>> - Update commit information.
>>
>> Changes since v2:
>> - Add a helper for calling sas_destruct_devices() and 
>> sas_destruct_ports(),
>>    and put the new call at the end of sas_probe_devices() based on John's
>>    suggestion.
>>
>> Changes since v1:
>> - Simplify the process of getting ex_phy id based on Jason's suggestion.
>> - Update commit information.
>> ---
>>   drivers/scsi/libsas/sas_internal.h | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/scsi/libsas/sas_internal.h 
>> b/drivers/scsi/libsas/sas_internal.h
>> index 85948963fb97..7c0931ccea23 100644
>> --- a/drivers/scsi/libsas/sas_internal.h
>> +++ b/drivers/scsi/libsas/sas_internal.h
>> @@ -145,6 +145,20 @@ static inline void sas_fail_probe(struct 
>> domain_device *dev, const char *func, i
>>           func, dev->parent ? "exp-attached" :
>>           "direct-attached",
>>           SAS_ADDR(dev->sas_addr), err);
>> +
>> +    /* if the device probe failed, the expander phy attached address
> 
> please use standard comment format, i.e. /* goes on a line on its own
OK.
> 
>> +     * need to be reset so that the phy will not be treated as flutter
> 
> /s/need to be reset/needs to be reset/OK.
> 
>> +     * in the next revalidation
>> +     */
>> +    if (dev->parent && !dev_is_expander(dev->dev_type)) {
>> +        struct domain_device *parent = dev->parent;
>> +        struct expander_device *ex_dev = &parent->ex_dev;
>> +        struct sas_phy *phy = dev->phy;
>> +        struct ex_phy *ex_phy = &ex_dev->ex_phy[phy->number];
> 
> this could all be put on fewer lines, or even 1, like:
OK. I'll update a new version.
> 
> struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy->number];
> 
> you could even add a helper, like:
> 
> static inline struct ex_phy *sas_expander_ex_phy(struct domain_device
>   *parent, int phy_id)
>   {
>   struct expander_device *ex_dev = &parent->ex_dev;
> 
>   return &ex_dev->ex_phy[phy_id];
>   }
> 
> However, I am not sure how helpful it will be, since we often require a 
> struct expander_device pointer when we would be using that helper.
> 
Thanks,
Xingui


