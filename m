Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB1E31B814;
	Fri,  5 Dec 2025 09:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764928356; cv=none; b=NE4wbWhfmXX7R3aHoO5+rom5cvNNGUjwpuF9OhOcbI9Qskb0o5rw5RXLjJM8iWNqEaR2LaoO4zkemTAJOS89S8NsOFBlT+VDGRNuXm/tt0e+9srfbVJpCkvFo1eBkpvnZoA4WdTLR3ji2RpTX9FbCXasib+tFDWiBxxOc9r8EuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764928356; c=relaxed/simple;
	bh=2CnIXu0y7X1T2fuBppSPWj5ZIgd91p5kMReqC8gBw2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=W4E2YtUHKttITqKhSF07g0a43tm11K2aw++JwWL6ihw6x21H6fXopAffzF+Em1iWWkmJZTaVEhx07maRAmziBAzGYLjjLJ4WYv3B8j7dJIv0HCo/oCeVKj26irmz76xP+B/ndwcNs6JGzsH4wPXbOghfE7QEmQk2zhs+p0M68hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Z0IsLmKO; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Z0IsLmKO"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XhVaJARYimL+79pNE0jTyOAgzLUnThmzr6papmMAxmY=;
	b=Z0IsLmKOaR8FqyoYZPMzxplz+4AxJgeZO9mvukAYpxUYVNHA2vBnho2OrRfiDYXIuR05ZM/Yx
	32gFMo9H77srwHO7up98Rh6CdY77pj+5YBr40RHgPpbzVENLvydvzK1nC782uJYIpH1ghjX2bes
	vubUXzrRKs3nr/FBMd1fTho=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dN67Q2jhLzmVX6;
	Fri,  5 Dec 2025 17:50:26 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id E814818001B;
	Fri,  5 Dec 2025 17:52:19 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Dec 2025 17:52:19 +0800
Message-ID: <c92623d5-6a52-4d82-bc2a-da358ee1339c@huawei.com>
Date: Fri, 5 Dec 2025 17:52:17 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Add error handling in the
 sas_register_phys()
To: Chaohai Chen <wdhh6@aliyun.com>, <john.g.garry@oracle.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <dlemoal@kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20251205080252.1020028-1-wdhh6@aliyun.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20251205080252.1020028-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/12/5 16:02, Chaohai Chen 写道:
> If an error is triggered in the loop process, we need to roll back
> the resources that have already been requested.
> 
> Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
> ---
>   drivers/scsi/libsas/sas_phy.c | 21 ++++++++++++++++++---
>   1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
> index 635835c28ecd..455118c7e889 100644
> --- a/drivers/scsi/libsas/sas_phy.c
> +++ b/drivers/scsi/libsas/sas_phy.c
> @@ -116,6 +116,7 @@ static void sas_phye_shutdown(struct work_struct *work)
>   int sas_register_phys(struct sas_ha_struct *sas_ha)
>   {
>   	int i;
> +	int ret = 0;
>   
>   	/* Now register the phys. */
>   	for (i = 0; i < sas_ha->num_phys; i++) {
> @@ -132,8 +133,10 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
>   		phy->frame_rcvd_size = 0;
>   
>   		phy->phy = sas_phy_alloc(&sas_ha->shost->shost_gendev, i);
> -		if (!phy->phy)
> -			return -ENOMEM;
> +		if (!phy->phy) {
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
>   
>   		phy->phy->identify.initiator_port_protocols =
>   			phy->iproto;
> @@ -146,10 +149,22 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
>   		phy->phy->maximum_linkrate = SAS_LINK_RATE_UNKNOWN;
>   		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
>   
> -		sas_phy_add(phy->phy);
> +		ret = sas_phy_add(phy->phy);
> +		if (ret) {
> +			sas_phy_free(phy->phy);
> +			goto fail;
> +		}
>   	}
>   
>   	return 0;
> +fail:
> +	for (i--; i >= 0; i--) {
> +		struct asd_sas_phy *phy = sas_ha->sas_phy[i];
> +
> +		sas_phy_delete(phy->phy);
> +		sas_phy_free(phy);
> +	}
> +	return ret;
>   }
>   
>   const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS] = {

Since you are at it, you should also complete Undo_phys label in 
sas_register_ha().

Thanks,
祝一切顺利
