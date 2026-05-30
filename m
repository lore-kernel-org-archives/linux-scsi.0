Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80435E54B;
	Sat, 30 May 2026 02:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780106660; cv=none; b=nypZtq++vS84UerwjlLQuRUIsZLS2lfW4lS05rhEfoAnCP1Ws8iKA3m9cDtnbfWyc+Mm1zLp59+TB9TKo+sed++uownQppSD/b0BQ0s3pK0Wn+7Dw/rQ0N7KLXnEyvjKz1MM4o3QO/K77i2uZ96sZggUqjPJJhCUeu7XC85r9wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780106660; c=relaxed/simple;
	bh=IR1pqcNmcD62WpiPx0pBquW4VNxP4QUbuiWk3j2jwmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MhKXWkc4g2D17FHGudKVQNso+hHHFDyo6gPIbYnzhuEuu7u/30X9FXATmKP4ytV6ZJjmdR8ojIacINyDPgfulIiYm03Lj3P/sywN7dz4zqYPznPzlpvGTHNbPTRUo8CZPDD+7K8VO7/fa7ftNgdJ2jl7DHHhv7SP8Lt9LD07QFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=RktZMrMJ; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="RktZMrMJ"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=x8Fn+UJO8CmXhC6vpI2yWME1XHTappqaB0gVfk/7TmQ=;
	b=RktZMrMJMq2n6BZGnbLpSZIK97bOkL5IZngNaS7duh8H/gD7OSyY5EZXvz+4ae7+J89pjQXcb
	ihzPEfUsJ3o7OIOM/1xt7b6SNxPgrQYWdK4DxEaxbPc16hzYz0low/tXTmf6JJMuiFy9mhksOUO
	ZcFPIeZO8wArV59eZLQXeTk=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gS3H938nbzLlYX;
	Sat, 30 May 2026 09:56:21 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 577F740571;
	Sat, 30 May 2026 10:04:08 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Sat, 30 May 2026 10:04:07 +0800
Message-ID: <b5190317-b481-6556-99d1-0242dc59f49e@huawei.com>
Date: Sat, 30 May 2026 10:04:06 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260526015418.2022398-1-yangxingui@huawei.com>
 <20260526015418.2022398-3-yangxingui@huawei.com>
 <cd70e2a4-91e1-4237-bdd0-7568b2dbdc9f@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <cd70e2a4-91e1-4237-bdd0-7568b2dbdc9f@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500001.china.huawei.com (7.202.181.130) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/5/29 22:09, John Garry wrote:
>> +static void sas_rediscover_phy(struct domain_device *dev, int phy_id,
> 
> most of the expander phy symbols have _ex_phy ending

Ok, I will update in the next version.

> 
>> +                   bool last)
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
>> +static bool sas_is_flutter(struct domain_device *dev, int phy_id,
> 
> sas_dev_is_flutter may be a better name

Ok.

> 
>> +               u8 *sas_addr, enum sas_device_type type)
>> +{
>> +    struct expander_device *ex = &dev->ex_dev;
>> +    struct ex_phy *phy = &ex->ex_phy[phy_id];
>> +    struct domain_device *child_dev;
>> +    char *action = "";
>> +
>> +    if (SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr) ||
>> +        !dev_type_flutter(type, phy->attached_dev_type))
>> +        return false;
>> +
>> +    child_dev = sas_ex_to_dev(dev, phy_id);
>> +
>> +    sas_ex_phy_discover(dev, phy_id);
> 
> why not check the return code for error?

Hmm, I've considered this part as well. This section of code was 
directly extracted from the original code without any processing. I'll 
handle it in the next version as follow:

      res = sas_ex_phy_discover(dev, phy_id);
      if (res)
            return false;

If discover fails, we treat it as needing rediscovery rather than
ignoring the error.

> 
>> +
>> +    if (child_dev && dev_is_sata(child_dev) &&
>> +        phy->attached_dev_type == SAS_SATA_PENDING) {
>> +        action = ", needs recovery";
>> +    } else if (child_dev && child_dev->linkrate != phy->linkrate) {
>> +        pr_info("ex %016llx phy%02d linkrate changed from %d to %d\n",
>> +            SAS_ADDR(dev->sas_addr), phy_id,
>> +            child_dev->linkrate, phy->linkrate);
>> +        return false;
>> +    } else if (child_dev &&
> 
> Can you factor out the child_dev checks for all if/else legs?

Good idea, I will update in the next version.

> 
>> +           SAS_ADDR(child_dev->sas_addr) != 
>> SAS_ADDR(phy->attached_sas_addr)) {
>> +        pr_info("ex %016llx phy%02d sas_addr changed from %016llx to 
>> %016llx\n",
>> +            SAS_ADDR(dev->sas_addr), phy_id,
>> +            SAS_ADDR(child_dev->sas_addr),
>> +            SAS_ADDR(phy->attached_sas_addr));
>> +        return false;
>> +    }
>> +
>> +    pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
>> +         SAS_ADDR(dev->sas_addr), phy_id, action);
>> +    return true;
>> +}
>> +
>>   static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
>>                     bool last, int sibling)
>>   {
>> @@ -2015,27 +2065,16 @@ static int sas_rediscover_dev(struct 
>> domain_device *dev, int phy_id,
>>           if (res == 0)
>>               sas_set_ex_phy(dev, phy_id, disc_resp);
>>           goto out_free_resp;
>> -    } else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
>> -           dev_type_flutter(type, phy->attached_dev_type)) {
>> -        struct domain_device *ata_dev = sas_ex_to_ata(dev, phy_id);
>> -        char *action = "";
>> -
>> -        sas_ex_phy_discover(dev, phy_id);
>> +    }
>> -        if (ata_dev && phy->attached_dev_type == SAS_SATA_PENDING)
>> -            action = ", needs recovery";
>> -        pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
>> -             SAS_ADDR(dev->sas_addr), phy_id, action);
>> +    if (sas_is_flutter(dev, phy_id, sas_addr, type))
>>           goto out_free_resp;
>> -    }
>>       /* we always have to delete the old device when we went here */
>>       pr_info("ex %016llx phy%02d replace %016llx\n",
>>           SAS_ADDR(dev->sas_addr), phy_id,
>>           SAS_ADDR(phy->attached_sas_addr));
>> -    sas_unregister_devs_sas_addr(dev, phy_id, last);
>> -
>> -    res = sas_discover_new(dev, phy_id);
>> +    sas_rediscover_phy(dev, phy_id, last);
>>   out_free_resp:
>>       kfree(disc_resp);
>>       return res;
> 
> Can res still hold non-zero value from earlier?

Yes, I've considered this part as well, but it's always 
SMP_RESP_FUNC_ACC (0) when reaching the replace
branch. The code path to reach replace requires:

1. sas_get_phy_discover() returns SMP_RESP_FUNC_ACC (0)
2. SAS_ADDR(sas_addr) != 0 (otherwise goto out_free_resp)
3. res != -ECOMM (otherwise goto out_free_resp)
4. Not a flutter condition (otherwise goto out_free_resp)

So res is guaranteed to be 0 at the replace branch. I kept it unchanged
without explicitly setting res = 0.


Thanks.
Xingui

