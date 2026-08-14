Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A28536EA80;
	Fri, 14 Aug 2026 06:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786689230; cv=none; b=hwPjEHGb7ztrAbSZRr1i8KV1W/f99eWSKpaw8y1R+mbANOHDTQFsP6q4ealFt0in+t78JG89H08cbrzRO62owdPpaQJBgp8RFH+ENdIycLQRGuGwc2PlLTYoD9cDTrb5JTL+kkZOf9c02eoFEfbT8d5mQOZ296GeEh+Oqq7w7EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786689230; c=relaxed/simple;
	bh=JbJUrjQct/bq7GozCgtZcnP+7bSAzDmDxzDZLz17kR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=m2SURfHtyHY1fL2xwxPUKl4HaOtBxa6yB3bKUBFZ5+jk+9rNYoY6fcNE5hV/cKmG4pGvar684odt52n6+Y4+BGXxCRkNNZYUFJ7SBc9aKLn03Zc/wSdF4yswJcddkScijL3kzyX5LrKR3Y3E5FBLixCZ3CRNMO+d2oulvbSOvBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=HFV8zqPf; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="HFV8zqPf"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dVV+kFb9W1cB+utJwZM1TzzkuhvfJj8cIY4QmtPi1Hs=;
	b=HFV8zqPfPElPqip9jR4f4F2czhlrGLGcu3iPx1oNrIlUtSYQ7W9LMZzmmhYKD5hR8mi4jj+5y
	nTuufHabrT+ab2MJYdT/voralQ/SvJ4CJMiMgtjEaDlvWFVocYqY1LiW5vxWesITNu+8KYjGRIV
	9x3dEPpkUj3JxEiTF0KWRdM=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hLscj6MQnz1T4Fq;
	Fri, 14 Aug 2026 14:23:49 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id EDC1C40538;
	Fri, 14 Aug 2026 14:33:42 +0800 (CST)
Received: from [10.174.179.11] (10.174.179.11) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Aug 2026 14:33:42 +0800
Message-ID: <528a4c8f-f061-4879-9547-73eda8db77b0@huawei.com>
Date: Fri, 14 Aug 2026 14:33:41 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
To: Xingui Yang <yangxingui@huawei.com>, <john.g.garry@oracle.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260811040334.4184911-1-yangxingui@huawei.com>
 <20260811040334.4184911-3-yangxingui@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20260811040334.4184911-3-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2026/8/11 12:03, Xingui Yang 写道:
> Introduce sas_dev_is_flutter() and sas_rediscover_ex_phy() to improve
> flutter and device replace detection during rediscovery.
> 
> sas_dev_is_flutter() calls sas_ex_phy_discover() before looking up the
> child device via sas_ex_phy_to_dev(), ensuring the PHY state is always
> updated and avoiding use-after-free since the child device pointer is
> obtained after the sleeping SMP request completes.
> 
> It adds validation for linkrate and sas_addr changes. When the SAS
> address changes, phy->attached_sas_addr is restored to the original
> address before returning false, so sas_unregister_devs_sas_addr() can
> properly match and unregister the old device. The sas_addr check is
> ordered before the linkrate check to avoid skipping the restoration
> when both change simultaneously.
> 
> sas_rediscover_ex_phy() uses the async discovery pattern
> (sas_discover_event) instead of the synchronous sas_discover_new() to
> ensure proper ordering between device unregistration and rediscovery,
> avoiding sysfs_warn_dup() errors.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> Suggested-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/libsas/sas_expander.c | 83 +++++++++++++++++++++++++-----
>   1 file changed, 69 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index a5c5327cd0dd..811c9eb4fef1 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1963,6 +1963,72 @@ static bool dev_type_flutter(enum sas_device_type new, enum sas_device_type old)
>   	return false;
>   }
>   
> +static void sas_rediscover_ex_phy(struct domain_device *dev, int phy_id,
> +				  bool last)
> +{
> +	struct expander_device *ex = &dev->ex_dev;
> +	struct ex_phy *phy = &ex->ex_phy[phy_id];
> +
> +	phy->phy_change_count = -1;
> +	ex->ex_change_count = -1;
> +	sas_unregister_devs_sas_addr(dev, phy_id, last);
> +	sas_discover_event(dev->port, DISCE_REVALIDATE_DOMAIN);
> +}
> +
> +static bool sas_dev_is_flutter(struct domain_device *dev, int phy_id,
> +			       u8 *sas_addr, enum sas_device_type type)
> +{
> +	struct expander_device *ex = &dev->ex_dev;
> +	struct ex_phy *phy = &ex->ex_phy[phy_id];
> +	struct domain_device *child_dev;
> +	char *action = "";
> +	int res;
> +
> +	if (SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr) ||
> +	    !dev_type_flutter(type, phy->attached_dev_type))
> +		return false;
> +
> +	res = sas_ex_phy_discover(dev, phy_id);
> +	if (res)
> +		return false;
> +
> +	child_dev = sas_ex_phy_to_dev(dev, phy_id);
> +	if (!child_dev)
> +		goto out;
> +
> +	if (dev_is_sata(child_dev) &&
> +	    phy->attached_dev_type == SAS_SATA_PENDING) {
> +		action = ", needs recovery";
> +		goto out;
> +	}
> +
> +	if (SAS_ADDR(child_dev->sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
> +		pr_info("ex %016llx phy%02d sas_addr changed from %016llx to %016llx\n",
> +			SAS_ADDR(dev->sas_addr), phy_id,
> +			SAS_ADDR(child_dev->sas_addr),
> +			SAS_ADDR(phy->attached_sas_addr));
> +		/*
> +		 * Device unregistering relies on address matching. Restore
> +		 * attached_sas_addr back to the original address so that the old
> +		 * device can be unregistered later
> +		 */
> +		memcpy(phy->attached_sas_addr, child_dev->sas_addr, SAS_ADDR_SIZE);
> +		return false;
> +	}
> +
> +	if (child_dev->linkrate != phy->linkrate) {
> +		pr_info("ex %016llx phy%02d linkrate changed from %d to %d\n",
> +			SAS_ADDR(dev->sas_addr), phy_id,
> +			child_dev->linkrate, phy->linkrate);
> +		return false;
> +	}
> +
> +out:
> +	pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
> +		 SAS_ADDR(dev->sas_addr), phy_id, action);
> +	return true;
> +}
> +
>   static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
>   			      bool last, int sibling)
>   {
> @@ -2016,27 +2082,16 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
>   		if (res == 0)
>   			sas_set_ex_phy(dev, phy_id, disc_resp);
>   		goto out_free_resp;
> -	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
> -		   dev_type_flutter(type, phy->attached_dev_type)) {
> -		struct domain_device *ata_dev = sas_ex_to_ata(dev, phy_id);
> -		char *action = "";
> -
> -		sas_ex_phy_discover(dev, phy_id);
> +	}
>   
> -		if (ata_dev && phy->attached_dev_type == SAS_SATA_PENDING)
> -			action = ", needs recovery";
> -		pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
> -			 SAS_ADDR(dev->sas_addr), phy_id, action);
> +	if (sas_dev_is_flutter(dev, phy_id, sas_addr, type))
>   		goto out_free_resp;
> -	}
>   
>   	/* we always have to delete the old device when we went here */

Please remove this comment since you are not deleting the old device now.

Thanks,
Jason

>   	pr_info("ex %016llx phy%02d replace %016llx\n",
>   		SAS_ADDR(dev->sas_addr), phy_id,
>   		SAS_ADDR(phy->attached_sas_addr));
> -	sas_unregister_devs_sas_addr(dev, phy_id, last);
> -
> -	res = sas_discover_new(dev, phy_id);
> +	sas_rediscover_ex_phy(dev, phy_id, last);
>   out_free_resp:
>   	kfree(disc_resp);
>   	return res;
