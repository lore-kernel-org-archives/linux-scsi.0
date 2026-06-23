Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4888374197
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 08:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782203987; cv=none; b=GYM338dagJKFWNVwNmzn+0XbqvjmwGnJioIjs3lGu6fb0KCk2abe8PW5pa1o0FpKukrZpdqWl/kXbLcCTcVyyrg4TJVoOCXbbMO1tIHxWcGJ5Wr4Vi/nBbYcc7VM91pt6wdpnVzBEtzgM7B6iz2uaG3w9x/k1WkEZI1SOt7PiDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782203987; c=relaxed/simple;
	bh=4FrDpInQmAnInHzAhjlsxKrja+aWYaE4ossiwlzZ/1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tCa1M+Jy3siXtGgwRUlRquGfncrmGeHy9pDzBUj5CFKql12o1Rb33eRVMbnwDaISOdc/VEKgy1OejJHIjdGeityRDRlsCgSbos1uMs8190S6EomwQ1+4kpaYIgGeSkpjQAuW8M0svzt+e3S65MaS1djn/KD2Gss/ROO3ima/BiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pQl2vjUN; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pQl2vjUN"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HdqwTGQibWQCEuGCb/g2CUvt050Qxl5kgv8qRnDYk7w=;
	b=pQl2vjUNtQpEmCCkOtiiq68XLSb5JRc1cO00DYAj5PyTiRL4x8mCc0UOQHpt8ZyNCVWrW0TF2
	b3GufOLdFlZQQ4Xj+TeyUNiBqGu6mLLrQxd8q/OMj8Eh9bBsxO0q4Z9P+cGDdMDC89eFVI6bkQT
	Crng+NryTGRJd+Hkzx5UrBg=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gkyv01V24zmVWh;
	Tue, 23 Jun 2026 16:30:36 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 1BDB7402AB;
	Tue, 23 Jun 2026 16:39:41 +0800 (CST)
Received: from [10.174.179.11] (10.174.179.11) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 23 Jun 2026 16:39:40 +0800
Message-ID: <3ba86e62-9a11-4d15-bf19-b7205624bd1c@huawei.com>
Date: Tue, 23 Jun 2026 16:39:39 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
To: <sashiko-reviews@lists.linux.dev>, Xingui Yang <yangxingui@huawei.com>
CC: <linux-scsi@vger.kernel.org>
References: <20260623024304.714582-1-yangxingui@huawei.com>
 <20260623024304.714582-3-yangxingui@huawei.com>
 <20260623025715.569241F000E9@smtp.kernel.org>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20260623025715.569241F000E9@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2026/6/23 10:57, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [Medium] `sas_dev_is_flutter()` improperly bypasses PHY discovery when `child_dev` is NULL, failing to update the libsas routing table and PHY state.
> 
> Pre-existing issues:
> - [High] Attempting to prevent UAF by acquiring a reference via `kref_get(&child_dev->kref)` results in a TOCTOU race because `sas_find_dev_by_rphy()` returns a raw pointer without holding a reference.
> --
> 
> commit 4a9be29a10948d7f2b0efa1425b3ea27e6c08b1f
> Author: Xingui Yang <yangxingui@huawei.com>
> 
> scsi: libsas: Add linkrate and sas_addr change detection in rediscover
> 
> This commit introduces sas_dev_is_flutter() and sas_rediscover_ex_phy()
> to improve flutter and device replace detection during rediscovery.
> It holds a kref on the child device during SMP discovery and uses async
> discovery to avoid ordering issues.
> 
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index cb9d3b7482225..63d033e789855 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
> [ ... ]
>> @@ -1966,6 +1966,78 @@ static bool dev_type_flutter(enum sas_device_type new, enum sas_device_type old)
> [ ... ]
>> +static bool sas_dev_is_flutter(struct domain_device *dev, int phy_id,
>> +			       u8 *sas_addr, enum sas_device_type type)
>> +{
>> +	struct expander_device *ex = &dev->ex_dev;
>> +	struct ex_phy *phy = &ex->ex_phy[phy_id];
>> +	struct domain_device *child_dev = NULL;
>> +	char *action = "";
>> +	int res;
>> +
>> +	if (SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr) ||
>> +	    !dev_type_flutter(type, phy->attached_dev_type))
>> +		return false;
>> +
>> +	child_dev = sas_ex_to_dev(dev, phy_id);
>> +	if (!child_dev)
>> +		goto out;
> 
> [Severity: Medium]
> In the original code, sas_ex_phy_discover() was called unconditionally.
> Will this new early return bypass the SMP request that updates the PHY state
> (via sas_set_ex_phy()) when the child device is not instantiated or has been
> removed?
> 
>> +
>> +	kref_get(&child_dev->kref);
> 
> [Severity: High]
> This is a pre-existing issue, but could attempting to prevent a use-after-free
> by acquiring a reference here result in a time-of-check to time-of-use
> (TOCTOU) race?
> 
> Looking at sas_find_dev_by_rphy() (called by sas_ex_to_dev()), it acquires
> port->dev_list_lock, finds the device, and drops the lock before returning
> the raw pointer:
> 
> drivers/scsi/libsas/sas_scsi_host.c:sas_find_dev_by_rphy() {
>      ...
>      found_dev = dev;
>      spin_unlock(&port->dev_list_lock);
>      goto found;
>      ...
> }
> 
> If a concurrent link-loss or device removal event runs, can it acquire the
> lock, remove the device, and drop its last reference before we call
> kref_get(&child_dev->kref) here, leading to a use-after-free?

Actually all libsas events are processed sequentially in sas_ha->disco_q 
workqueue. So this will not happen.

Thanks,
Jason

> 
>> +	res = sas_ex_phy_discover(dev, phy_id);
>> +	if (res)
>> +		goto out_put;
> 
