Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92002282F0A;
	Mon, 11 May 2026 07:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778482820; cv=none; b=Ntkk+ePo+NNBLZHhlbqT2BXc7c743mJJCZcj2LHY25MHW8nzNnXwXYbCQr5v8YRebmEcQ1gukaqx2VFj029DwBBO5e93H07H0BNFqzbY9QmTgHEzr+WMWRRcQeBtFPvbYbwOM0wN3UVs8FB4nNaCfS05DgYWOcJuWb9VdkxxyOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778482820; c=relaxed/simple;
	bh=ck9zX7YODbEKyE56vY3RQk5xWutG5W/GEz9wFggpCtw=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ETMqMk8v15xDt7mTeSRIBWxIPqVKYDCoToOXSCrdxNletvLLYqzfKFmUnojQe30lnyWGQ3THMlkO898bYjK6cGH8TTL7I3rx/Hby4Wa0DelOhekUjuodBxRbSCt0BDJAyV4unPDNUBSI5hswpeUerfhB/FTcp+sV1yt3E0l8o7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=oqYeWGZb; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="oqYeWGZb"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eVlL/wANbzmMeRXozK2fi4yy3HE8x8rmCqRz6anZDAI=;
	b=oqYeWGZb/DQvYg4VaHnFVQJt9tY6aghM3uXIvvjDGf/ygy/JQrwdkuzc0BZxR2XmHbgP9xs0l
	LXBqDEpaj5ynfShDtiRvFtIH4bSLYzO6IU1yj++0jch1tAhskHL67ai1wXkiO4H6QOxUEIFn3zy
	dZuk+JRySP7jKGG494QbIPM=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gDVmW6TyNzpT01;
	Mon, 11 May 2026 14:53:15 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id ABCBC4056A;
	Mon, 11 May 2026 15:00:13 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 11 May 2026 15:00:13 +0800
Subject: Re: [PATCH v2] scsi: hisi_sas: Add slave_destroy interface for v3 hw
To: Yihang Li <liyihang9@huawei.com>, <martin.petersen@oracle.com>,
	<James.Bottomley@HansenPartnership.com>
References: <20260425082056.2749910-1-liyihang9@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
From: Yihang Li <liyihang9@h-partners.com>
Message-ID: <f73f8ae6-9b37-b904-bf73-95e14a279751@h-partners.com>
Date: Mon, 11 May 2026 15:00:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260425082056.2749910-1-liyihang9@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemh200005.china.huawei.com (7.202.181.112)

friendly Ping...

On 2026/4/25 16:20, Yihang Li wrote:
> WARNING is triggered when executing link reset of remote PHY
> and rmmod SAS driver simultaneously. Following is the WARNING log:
> 
> WARNING: CPU: 61 PID: 21818 at drivers/base/core.c:1347 __device_links_no_driver+0xb4/0xc0
>  Call trace:
>   __device_links_no_driver+0xb4/0xc0
>   device_links_driver_cleanup+0xb0/0xfc
>   __device_release_driver+0x198/0x23c
>   device_release_driver+0x38/0x50
>   bus_remove_device+0x130/0x140
>   device_del+0x184/0x434
>   __scsi_remove_device+0x118/0x150
>   scsi_remove_target+0x1bc/0x240
>   sas_rphy_remove+0x90/0x94
>   sas_rphy_delete+0x24/0x3c
>   sas_destruct_devices+0x64/0xa0 [libsas]
>   sas_revalidate_domain+0xe4/0x150 [libsas]
>   process_one_work+0x1e0/0x46c
>   worker_thread+0x15c/0x464
>   kthread+0x160/0x170
>   ret_from_fork+0x10/0x20
>  ---[ end trace 71e059eb58f85d4a ]---
> 
> During SAS phy up, link->status is set to DL_STATE_AVAILABLE in
> device_links_driver_bound, then this setting influences
> __device_links_no_driver() before driver rmmod and caused WARNING.
> 
> So we add the slave_destroy interface, to make sure link is removed
> after flush workque.
> 
> Fixes: 16fd4a7c59170 ("scsi: hisi_sas: Add device link between SCSI devices and hisi_hba")
> Signed-off-by: Yihang Li <liyihang9@huawei.com>
> ---
> Changs to v1:
> - Use the latest interface .sdev_destroy
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index fda07b193137..c7430f7c4048 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -2977,7 +2977,7 @@ static int sdev_configure_v3_hw(struct scsi_device *sdev,
>  		return 0;
>  
>  	if (!device_link_add(&sdev->sdev_gendev, dev,
> -			     DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)) {
> +			     DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)) {
>  		if (pm_runtime_enabled(dev)) {
>  			dev_info(dev, "add device link failed, disable runtime PM for the host\n");
>  			pm_runtime_disable(dev);
> @@ -2987,6 +2987,15 @@ static int sdev_configure_v3_hw(struct scsi_device *sdev,
>  	return 0;
>  }
>  
> +static void hisi_sas_sdev_destroy(struct scsi_device *sdev)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(&sdev->sdev_gendev);
> +	struct hisi_hba *hisi_hba = shost_priv(shost);
> +	struct device *dev = hisi_hba->dev;
> +
> +	device_link_remove(&sdev->sdev_gendev, dev);
> +}
> +
>  static struct attribute *host_v3_hw_attrs[] = {
>  	&dev_attr_phy_event_threshold.attr,
>  	&dev_attr_intr_conv_v3_hw.attr,
> @@ -3401,6 +3410,7 @@ static const struct scsi_host_template sht_v3_hw = {
>  	.sg_tablesize		= HISI_SAS_SGE_PAGE_CNT,
>  	.sg_prot_tablesize	= HISI_SAS_SGE_PAGE_CNT,
>  	.sdev_init		= hisi_sas_sdev_init,
> +	.sdev_destroy		= hisi_sas_sdev_destroy,
>  	.shost_groups		= host_v3_hw_groups,
>  	.sdev_groups		= sdev_groups_v3_hw,
>  	.tag_alloc_policy_rr	= true,
> 
