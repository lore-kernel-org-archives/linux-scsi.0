Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8EF136358;
	Thu, 27 Nov 2025 07:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764228125; cv=none; b=W290fk7HlvyQleiUe592f5qBJ+l+z0gzkDhD6CJalps5ea4B7kjIXfiZL+xy204M4+4sbXKftVaa1GUrt20/naVvZ9AIqPKrLVX44dAP/CU/HUwNl+1fHmZ6pRsalD7QfEaj28OtgsBnOgtkUMAmKePGYHP69yZzFXVrc3D786I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764228125; c=relaxed/simple;
	bh=1MUdi9zNgzjb5r442NgP1pK7YpipZBe1VVvy/+gfWHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BGKC7npDPp/Du8w8fiIJgDVm+VbndYEvnpx/U5IQc8y/Oo47EBAq2Pm8/8JFOACMqrthl5U5ckznKE4LKLA+gTAdpuHyrpO3OwTnJwym6NwFDZFLWiobolzdfayt5Dr5jnuAHs/Dj+jkIuAYbEn2xZlRZYMQMyIG7bYx/OvrLrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=b/iliIG2; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="b/iliIG2"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MGDDaaY90/tRMb+TKTq7JegsZuVfQL0ENBqbKUPaqys=;
	b=b/iliIG2D3wyQgIqx3fDqiVQrNe6YMono7wZg7kfjnPQ4AeaAq004SNCwEDdJ7YlvXj0YEpNU
	g93sGhjg4pB/Z1+hbTper688MoE2J/LmHH1EI4HXn0bAjKsyEtxOAUgiMX5WR0+hmnsCSuQ2iOP
	KbiMIcGnzO9CsX5I5tFbVYw=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dH79j5rhmzLlSX;
	Thu, 27 Nov 2025 15:20:09 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 031ED140296;
	Thu, 27 Nov 2025 15:21:58 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 27 Nov 2025 15:21:57 +0800
Message-ID: <19929526-cc46-4337-b6e2-5305002565a4@huawei.com>
Date: Thu, 27 Nov 2025 15:21:43 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: libsas: Fix exp-attached device scan after
 probe failure scanned in again after probe failed"
To: Xingui Yang <yangxingui@huawei.com>, <john.g.garry@oracle.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20251021073438.3441934-1-yangxingui@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20251021073438.3441934-1-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/10/21 15:34, Xingui Yang 写道:
> This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.
> 
> As the disk may fall into an abnormal loop of probe when it fails to probe
> due to physical reasons and cannot be repaired.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
>   drivers/scsi/libsas/sas_internal.h | 14 --------------
>   1 file changed, 14 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 03d6ec1eb970..85948963fb97 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -145,20 +145,6 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
>   		func, dev->parent ? "exp-attached" :
>   		"direct-attached",
>   		SAS_ADDR(dev->sas_addr), err);
> -
> -	/*
> -	 * If the device probe failed, the expander phy attached address
> -	 * needs to be reset so that the phy will not be treated as flutter
> -	 * in the next revalidation
> -	 */
> -	if (dev->parent && !dev_is_expander(dev->dev_type)) {
> -		struct sas_phy *phy = dev->phy;
> -		struct domain_device *parent = dev->parent;
> -		struct ex_phy *ex_phy = &parent->ex_dev.ex_phy[phy->number];
> -
> -		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
> -	}

You need to track probe failed times, and if probe failed more than 3 
times, stop trying to probe this phy.

Jaosn
祝一切顺利

> -
>   	sas_unregister_dev(dev->port, dev);
>   }
>   
