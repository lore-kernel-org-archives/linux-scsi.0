Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9595C8F6E
	for <linux-scsi@vger.kernel.org>; Mon,  1 Apr 2024 07:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711955298; cv=none; b=CzNH0zTB+ru408FBGH5pu1mCpQn1drTE98pKPTJFJ7obPIXfWwYd0RH3RpWVNitn4uFy4Az2LKn8AemGXSW4jolMDQQIIcvaM4mGCZ5AMe28+cMrxwffF37xGq4aN6SdGE/L4+0J4HSkIymeezZBPxeTKN4fU4XaEMbFM9u1gYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711955298; c=relaxed/simple;
	bh=GUOmv+Y0WjHvNCS+PlzAw3YfnpaPNR2c84gdnY8xRqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BgdJIze40KUWraaXys8H7ogAhF8Eyc2Qf3nAwYCCx9RZ9BWe5Mby132TMnizRHeLc27T1Vd7VCwMJubA0l02rX+6vsfrCWtn8VOJVaKOvGOrGRNa6wWREFe2ULXiyt8QtdJQtYawOGPi2FzkPc9pU7F+QNDEZWcRHMFfMNhPNQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYeZ6iDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYeZ6iDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB85C433F1;
	Mon,  1 Apr 2024 07:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711955298;
	bh=GUOmv+Y0WjHvNCS+PlzAw3YfnpaPNR2c84gdnY8xRqU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dYeZ6iDsVL2MAHqOXr2Oc36CEpe9FkGaTN8+PdAEpNLPNuBOH3r+TpqMBCFVhCQKl
	 peyTJHzCADtKLC1auvi8v+xoHUSdtruamVdcoWBGhoaq1kQhfSVhoI6sVyHbA3SMbv
	 v90HyVCge7wfb4DTzax65Z+lox0d8oZUSVfX78N3uhKTOuvNqHklUZoYvKkC3/LpH7
	 pg9Twr7examE+Nid8tOCKdnMqQRFp/MLISi/ZgMF0YIV4Nfrmb4HWoqMeyX8LnF1Mc
	 v3lW/Yd7lfIC4RyWXiTmuub0MgS8ShEmznaIA86OLRZ+fJViwyRATkLpzPgngaINVy
	 FhHLkQmhwFomw==
Message-ID: <98d9748f-a723-4b35-9ff6-1e425fe5d5b2@kernel.org>
Date: Mon, 1 Apr 2024 16:08:16 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: hisi_sas: Modify the deadline for
 ata_wait_after_reset()
To: chenxiang <chenxiang66@hisilicon.com>, jejb@linux.vnet.ibm.com,
 martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org
References: <20240401054914.721093-1-chenxiang66@hisilicon.com>
 <20240401054914.721093-3-chenxiang66@hisilicon.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240401054914.721093-3-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/24 14:49, chenxiang wrote:
> From: Yihang Li <liyihang9@huawei.com>
> 
> We found that the second parameter of function ata_wait_after_reset() is
> incorrectly used. We call smp_ata_check_ready_type() to poll the device
> type until the 30s timeout, so the correct deadline should be (jiffies +
> 30000).
> 
> Fixes: 3c2673a09cf1 ("scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset")
> Signed-off-by: xiabing <xiabing12@h-partners.com>
> Signed-off-by: Yihang Li <liyihang9@huawei.com>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 097dfe4b620d..7245600aedb2 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -1796,8 +1796,10 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
>  
>  	if (dev_is_sata(device)) {
>  		struct ata_link *link = &device->sata_dev.ap->link;
> +		unsigned long deadline = ata_deadline(jiffies,
> +				HISI_SAS_WAIT_PHYUP_TIMEOUT / HZ * 1000);

At the very least, you should use jiffies_to_msecs() here. But I do not see the
point though given that ata_deadline will do "jiffies + msecs_to_jiffies()".

So may be calling:

	rc = ata_wait_after_reset(link, jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT,
				  smp_ata_check_ready_type);

May be simpler and more readable.

>  
> -		rc = ata_wait_after_reset(link, HISI_SAS_WAIT_PHYUP_TIMEOUT,
> +		rc = ata_wait_after_reset(link, deadline,
>  					  smp_ata_check_ready_type);
>  	} else {
>  		msleep(2000);

-- 
Damien Le Moal
Western Digital Research

