Received: from bramsgout01.huawei.com (bramsgout01.huawei.com [119.8.89.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1327D2F616B;
	Fri, 11 Sep 2026 01:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.89.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789089517; cv=none; b=FcGbNXfQ0LDL3euc4wyUcGPWi2vmvTaG+d9zhrC/t4l0GefUcRxjFyDY8Vs5HOcBMEvW5IXJ71J+8qMMIUjf1ja/sgN08vKLIh9O8A9aJMOpBle9Ak8gcx//+2HX7ljlH0hlFCQBhfLQDP0NtP7apbDv09areasrUxAnbhdYhCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789089517; c=relaxed/simple;
	bh=eQIauYMRa6TjIK0rYZQYCQSuFJBb2g7nTWO536zFGpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tt+aT2/YyzTYKzEkSyiQ14WStaFoxu7KTG0oW1Cl0DSqoHbJQbSgiS0lWbCDUg4aeywmJigj3PpCOL53zYx2D5kJCyBr1y7U5hBSqz2k4icJXMQmot1XSbfVcplJ8kgImrhBxdPi650NjB8YUC2bNdSIgPyskNtwVAc7HdTJWIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=SsH0WuFi; arc=none smtp.client-ip=119.8.89.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="SsH0WuFi"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=d9oLsbBdX5Yj6u7M4OyHosIbampjoiJ4QXjlTq/p25o=;
	b=SsH0WuFiMXnAG0m293RZ13Vl+LlToM8BH32ETgnDdUwyvcf1ExtmYpazNs/4rXhZPVTxN/ToN
	Hx7wauJhF0eHgy1LjD0FnE4fk5knyhlCfjWIyoKLmXRXCwFAyTIszslxD25X19WwHBSccdc/rPV
	zURzcXPu9EXWkzzgts6e0Kg=
Received: from mail.maildlp.com (unknown [172.18.210.132])
	by bramsgout01.huawei.com (SkyGuard) with ESMTPS id 4hgwws0JZ8z3NPNP;
	Fri, 11 Sep 2026 08:51:57 +0800 (CST)
Received: from kwepemp500001.china.huawei.com (unknown [7.202.195.40])
	by mail.maildlp.com (Postfix) with ESMTPS id C461E4058E;
	Fri, 11 Sep 2026 09:00:44 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500001.china.huawei.com (7.202.195.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 09:00:44 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 09:00:43 +0800
Message-ID: <a97c6cfb-8476-1030-a07a-fea1c004ecbe@huawei.com>
Date: Fri, 11 Sep 2026 09:00:43 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] scsi: libsas: Fix SMP IO deadlock during HA resume
Content-Language: en-CA
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <john.garry@linux.dev>, <mkp@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260826032845.1632348-1-yangxingui@huawei.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20260826032845.1632348-1-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemj500017.china.huawei.com (7.202.194.47) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Hi John & Jason,

Kindly ping for review...

On 2026/8/26 11:28, Xingui Yang wrote:
> During sas_resume_ha() -> sas_drain_work(), ATA EH will trigger SMP IOs via
> sas_phy_reset() -> sas_smp_phy_control() for expander-attached ATA devices.
> Since ha->dev is RPM_RESUMING at that point, pm_runtime_get_sync() blocks
> waiting for the resume to finish, but the resume is blocked in
> sas_drain_work() waiting for the SMP IO — a deadlock.
> 
> Skip the PM get/put when SAS_HA_RESUMING is set. The hardware is already
> initialized by the LLDD resume callback before sas_resume_ha() runs, so no
> explicit resume is needed.
> 
> Only hisi_sas enables runtime PM among libsas LLDDs, so other drivers
> (pm8001, isci, aic94xx, mvsas) are unaffected.
> 
> Fixes: 0da7ca4c4fd9 ("scsi: libsas: Resume host while sending SMP I/Os")
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
>   drivers/scsi/libsas/sas_expander.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 811c9eb4fef1..77ae2ae7b2c4 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -61,8 +61,17 @@ static int smp_execute_task_sg(struct domain_device *dev,
>   	struct sas_internal *i =
>   		to_sas_internal(dev->port->ha->shost->transportt);
>   	struct sas_ha_struct *ha = dev->port->ha;
> -
> -	pm_runtime_get_sync(ha->dev);
> +	bool skip_pm = test_bit(SAS_HA_RESUMING, &ha->state);
> +
> +	/*
> +	 * Skip PM get/put during HA resume to avoid deadlock: the host is
> +	 * RPM_RESUMING and the drain waits for this SMP IO to finish, but
> +	 * pm_runtime_get_sync() would block on RPM_RESUMING. Safe because
> +	 * hardware is already initialized by the LLDD before call
> +	 * sas_resume_ha().
> +	 */
> +	if (!skip_pm)
> +		pm_runtime_get_sync(ha->dev);
>   	mutex_lock(&dev->ex_dev.cmd_mutex);
>   	for (retry = 0; retry < 3; retry++) {
>   		if (test_bit(SAS_DEV_GONE, &dev->state)) {
> @@ -135,7 +144,8 @@ static int smp_execute_task_sg(struct domain_device *dev,
>   		}
>   	}
>   	mutex_unlock(&dev->ex_dev.cmd_mutex);
> -	pm_runtime_put_sync(ha->dev);
> +	if (!skip_pm)
> +		pm_runtime_put_sync(ha->dev);
>   
>   	BUG_ON(retry == 3 && task != NULL);
>   	sas_free_task(task);
> 
