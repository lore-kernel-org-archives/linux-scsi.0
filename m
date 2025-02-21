Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B2E381A3;
	Fri, 21 Feb 2025 02:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740105436; cv=none; b=UFW8TCXwxDQ7FaPawHZbOUYpmVVKhbio1FNUIgdjtn6ba9HykmWJJb1oKlEd5L+70eIIT0u3OobLTOG6enPQB4BnBBDoBAFAIT/pHz+GQoEOFJFdF1kPaAwMSMb1yTXXmhaz91zTjAEwnMX2t8JJagQ7OPz/Y7ufVW4Xq7tkc2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740105436; c=relaxed/simple;
	bh=9hBEf15GI5CInSAZGW3JKnzPz+fnxZVR2nUPv8ge4zA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TG3ArSZkxsgwVIU42X+p+XKH4uSSF8jgc3KqTh+lOa4YQohKEjwzW6QrGWPmo7B0b9OwecoKYP1VC9RRMqhCyqAo9/y/ZQNNN71J6yUQAxQf52JPEjv27s7M6KPe/PoQ8hcZKSLB19Af7ohUy66eIWrDgSNPDpyPeU10/Mp2s4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YzZ214FmTzLr4F;
	Fri, 21 Feb 2025 10:33:45 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id E572A180087;
	Fri, 21 Feb 2025 10:37:09 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 21 Feb 2025 10:37:09 +0800
Message-ID: <f8811c44-0441-434e-8f3a-e8aec3032013@huawei.com>
Date: Fri, 21 Feb 2025 10:36:53 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] scsi: libsas: Move sas_put_device() to libsas.h
To: Xingui Yang <yangxingui@huawei.com>, <john.garry@huawei.com>,
	<liyihang9@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>, <liyangyang20@huawei.com>,
	<f.fangjian@huawei.com>, <xiabing14@h-partners.com>
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-3-yangxingui@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20250220130546.2289555-3-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/2/20 21:05, Xingui Yang 写道:
> As sas_put_device() needs to be called in lldd, it is now moved to libsas.h
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
>   drivers/scsi/libsas/sas_discover.c | 1 +
>   drivers/scsi/libsas/sas_internal.h | 6 ------
>   include/scsi/libsas.h              | 6 ++++++
>   3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 951bdc554a10..43a65d0542ab 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -309,6 +309,7 @@ void sas_free_device(struct kref *kref)
>   
>   	kfree(dev);
>   }
> +EXPORT_SYMBOL_GPL(sas_free_device);
>   
>   static void sas_unregister_common_dev(struct asd_sas_port *port, struct domain_device *dev)
>   {
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 03d6ec1eb970..a1e364deb3ee 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -98,7 +98,6 @@ int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
>   			     u8 *sas_addr, enum sas_device_type *type);
>   int sas_try_ata_reset(struct asd_sas_phy *phy);
>   
> -void sas_free_device(struct kref *kref);
>   void sas_destruct_devices(struct asd_sas_port *port);
>   
>   extern const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS];
> @@ -217,9 +216,4 @@ static inline struct domain_device *sas_alloc_device(void)
>   	return dev;
>   }
>   
> -static inline void sas_put_device(struct domain_device *dev)
> -{
> -	kref_put(&dev->kref, sas_free_device);
> -}
> -
>   #endif /* _SAS_INTERNAL_H_ */
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index ba460b6c0374..f67137f50980 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -425,6 +425,12 @@ static inline void sas_put_local_phy(struct sas_phy *phy)
>   	put_device(&phy->dev);
>   }
>   
> +void sas_free_device(struct kref *kref);
> +static inline void sas_put_device(struct domain_device *dev)
> +{
> +	kref_put(&dev->kref, sas_free_device);
> +}

As we have discussed internally, I still think exporting 
sas_put_device() is not a good idea. I prefer exporting an interface to 
iterate sas_port->dev_list and let the caller operate the domain device.

Thanks,
Jason

> +
>   #ifdef CONFIG_SCSI_SAS_HOST_SMP
>   int try_test_sas_gpio_gp_bit(unsigned int od, u8 *data, u8 index, u8 count);
>   #else
