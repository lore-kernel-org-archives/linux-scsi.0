Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A970938758C;
	Wed, 24 Jun 2026 06:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782281786; cv=none; b=LVCSQpu7kUxQemL3CeGEKbTaVo1+6Ry6a24iSfcACvTYQ5WKKQxjgNEJHTbFGMX+EoPHfi3cTYR4MKl/U88JqSjGfAk/rpjgv2STBgU34il6cUB3buLH1FGay5Xu81KhGjyQQf4MuJuohxg3rdXDIsOqANxETPZ2ynVPikNHpiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782281786; c=relaxed/simple;
	bh=Kq7n1uU6ClewfVtkd3KpMdBEpJ5NSHWeMzzOEugKiAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BX9Rx9Ir8dmO/EHxuI6L+pjrfeQ01AloaO/q536cTNGH9cZgmf6Z8SdN7c+bB94v9b3Mj2feBTWnL8ZmkolmFxs/JYzaen4Y6LmZ+5LNIj41BVMEb12cATirLB9xfsjoR4DD+3e6pdUOQOThRMw3y2vJH1zB/hvBqWIUe5U5XKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=B2D/qeJv; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="B2D/qeJv"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=i1xz4oi81nGVcwCGhMKtUNgT/5HrDZ1sVyDegpaRBlk=;
	b=B2D/qeJvMHnxNW9j5Al2+1X7TfpY/Ut1CIkPU9NhZRYZAfE8W0vDvzNqN5aDibhfPL0v0/xKD
	0HNKMWpcWxvRwBbSrV6qNw2ATV74zQt5yf4YGYP5sGWlLi1rS2n9tJzezMxDPrMDzonaT8GJeU/
	iydFvskM8hZOxY0Tmk+Wbm8=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4glWg23ltCzLlYS;
	Wed, 24 Jun 2026 14:07:10 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id BD8F64056E;
	Wed, 24 Jun 2026 14:16:15 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 24 Jun 2026 14:16:15 +0800
Message-ID: <f4c98a27-b9ae-e838-7320-9d307bacd23d@huawei.com>
Date: Wed, 24 Jun 2026 14:16:14 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v8 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
Content-Language: en-CA
To: Jason Yan <yanaijie@huawei.com>, <john.g.garry@oracle.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260623024304.714582-1-yangxingui@huawei.com>
 <20260623024304.714582-3-yangxingui@huawei.com>
 <fabfd6ed-ccfa-4a2e-ad91-3598751615ca@huawei.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <fabfd6ed-ccfa-4a2e-ad91-3598751615ca@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500010.china.huawei.com (7.202.181.141) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Hi Jason,

Thanks for the review.

On 2026/6/23 16:52, Jason Yan wrote:
> 在 2026/6/23 10:43, Xingui Yang 写道:
>> Introduce sas_dev_is_flutter() and sas_rediscover_ex_phy() to improve
>> flutter and device replace detection during rediscovery.
>>
>> sas_dev_is_flutter() adds validation for linkrate and sas_addr changes.
>> When the SAS address changes, it restores phy->attached_sas_addr back to
>> the original address before returning false, ensuring
>> sas_unregister_devs_sas_addr() can properly match and unregister the old
>> device via sas_phy_match_dev_addr().
>>
>> The sas_addr check is ordered before the linkrate check to ensure the
>> address restoration is not skipped when both change simultaneously.
>>
>> Hold a kref on child_dev across the sas_ex_phy_discover() call to
>> prevent use-after-free, since sas_ex_phy_discover() sends an SMP
>> request which can sleep, during which the device could be freed by
>> a concurrent removal path.
>>
>> sas_rediscover_ex_phy() uses the async discovery pattern
>> (sas_discover_event) instead of the synchronous sas_discover_new() to
>> ensure proper ordering between device unregistration and rediscovery,
>> avoiding sysfs_warn_dup() errors.
>>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 89 +++++++++++++++++++++++++-----
>>   1 file changed, 75 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>> b/drivers/scsi/libsas/sas_expander.c
>> index cb9d3b748222..63d033e78985 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -1966,6 +1966,78 @@ static bool dev_type_flutter(enum 
>> sas_device_type new, enum sas_device_type old)
>>       return false;
>>   }
>> +static void sas_rediscover_ex_phy(struct domain_device *dev, int phy_id,
>> +                  bool last)
>> +{
>> +    struct expander_device *ex = &dev->ex_dev;
>> +    struct ex_phy *phy = &ex->ex_phy[phy_id];
>> +
>> +    phy->phy_change_count = -1;
>> +    ex->ex_change_count = -1;
>> +    sas_unregister_devs_sas_addr(dev, phy_id, last);
>> +    sas_discover_event(dev->port, DISCE_REVALIDATE_DOMAIN);
>> +}
>> +
>> +static bool sas_dev_is_flutter(struct domain_device *dev, int phy_id,
>> +                   u8 *sas_addr, enum sas_device_type type)
>> +{
>> +    struct expander_device *ex = &dev->ex_dev;
>> +    struct ex_phy *phy = &ex->ex_phy[phy_id];
>> +    struct domain_device *child_dev = NULL;
>> +    char *action = "";
>> +    int res;
>> +
>> +    if (SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr) ||
>> +        !dev_type_flutter(type, phy->attached_dev_type))
>> +        return false;
>> +
>> +    child_dev = sas_ex_to_dev(dev, phy_id);
>> +    if (!child_dev)
>> +        goto out;
>> +
>> +    kref_get(&child_dev->kref);
> 
> This is not necessary so I think you can remove it as domain device will 
> never release here sine we are in the discover workqueue process.
> It's ture that sas_find_dev_by_rphy() is not perfect. It shall get a 
> reference after lock ->dev_list_lock. But this will affect many existing 
> users. We can do that in another patchset.

Agreed. In v9 I have removed the kref_get/sas_put_device pattern
entirely. Instead, sas_ex_phy_discover() is now called before
sas_ex_to_dev(), so the child device pointer is obtained after the
sleeping SMP request completes. This eliminates the UAF concern
without needing a kref, since we are serialized by disco_mutex in
the discover workqueue.

The sas_find_dev_by_rphy() reference counting improvement is noted
as a separate patchset as you suggested.

Thanks,
Xingui
