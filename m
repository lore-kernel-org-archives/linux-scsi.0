Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C751BF58;
	Thu, 21 Nov 2024 20:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732220934; cv=none; b=HsXU0rkS60/ewa9n47XFv3/tK+tqxR4HYJJ+dVfPCtpi5YQrm+Qie6v8i4CVQdx/P9xa3JOSo41tp8aUmsFmvCS7NcTd1QR1YjRxVF2rgKTdzd+1biW2IHjo2bgcjIrXU4ZedU3rZ3h9V/R6K32pikVey8gKEKtGci1VomSeoQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732220934; c=relaxed/simple;
	bh=aA8GgwXAyAvuaBPYCNtRyjM9WaNoD9Km8KZu7oIKIsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aY9wbaA7HQ+V84Wtj2mlPJ6hr0NRV0It47Umi3HNIhAErplvIaje5HXRSorxgVzkM9l/fs9zT9Dxq0uJgZpV3Dy3xZnhYmSmHGHVD43kW/bU9v7zoGhUucwLTtjNWbabeAtQ1mz5zbbBeETCd37KlR2oyxQfeT5eoCC6DFUFKzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VlBqUFWe; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VlBqUFWe"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XvVF01YMwz6CmQtQ;
	Thu, 21 Nov 2024 20:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732220928; x=1734812929; bh=EDZPObDU33Lo+5i+FY8ihSx9
	2XVxH3LXNxyg2UhqEfc=; b=VlBqUFWe4myw8h8wq902eERrFfocFojJpYNTCFOi
	RjZTkdZI23biiNHRT9lnzqeE1xqq6wi+ZYgImUrZXe3XcUt+yKJTdwRwcNVIvhN9
	36rFa+t4Vf0mr+Cc8h34v9CT3yMlbQcxOmEJaWzn7uY2CXGEKQ159qq4kR3i+8pj
	muK0sNNT//IyBlMDn0cOjfUFs3ZBL7C+hfluFUYL6rHXEX3vFDlUvKzjItqJBv7r
	LLf7sP1uzywrO3d/SQMZ2EreFMh8SnxbInf8kn7t8nZ412buXABD7NbzE5xMDUwY
	Hj4NOiMT27RCeocUP8KW3toLFlkzGg/Uc1m1YmBcaq6AxQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o5sYqHc0LaWz; Thu, 21 Nov 2024 20:28:48 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XvVDv06bjz6CmQtD;
	Thu, 21 Nov 2024 20:28:46 +0000 (UTC)
Message-ID: <2e5e888a-a7d8-4b10-a366-3cefd6685e69@acm.org>
Date: Thu, 21 Nov 2024 12:28:45 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] scsi: ufs: core: Prepare to introduce a new
 clock_gating lock
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Bean Huo <beanhuo@micron.com>
References: <20241118144117.88483-1-avri.altman@wdc.com>
 <20241118144117.88483-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241118144117.88483-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 6:41 AM, Avri Altman wrote:
> Removed hba->clk_gating.active_reqs check from ufshcd_is_ufs_dev_busy
> function to separate clock gating logic from general device busy checks.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   drivers/ufs/core/ufshcd.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e338867bc96c..be5fe2407382 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -258,10 +258,15 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
>   	return UFS_PM_LVL_0;
>   }
>   
> +static bool ufshcd_has_pending_tasks(struct ufs_hba *hba)
> +{
> +	return hba->outstanding_tasks || hba->active_uic_cmd ||
> +	       hba->uic_async_done;
> +}
> +
>   static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
>   {
> -	return (hba->clk_gating.active_reqs || hba->outstanding_reqs || hba->outstanding_tasks ||
> -		hba->active_uic_cmd || hba->uic_async_done);
> +	return hba->outstanding_reqs || ufshcd_has_pending_tasks(hba);
>   }
>   
>   static const struct ufs_dev_quirk ufs_fixups[] = {
> @@ -1943,7 +1948,9 @@ static void ufshcd_gate_work(struct work_struct *work)
>   		goto rel_lock;
>   	}
>   
> -	if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
> +	if (ufshcd_is_ufs_dev_busy(hba) ||
> +	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
> +	    hba->clk_gating.active_reqs)
>   		goto rel_lock;
>   
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
> @@ -1999,8 +2006,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
>   
>   	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
>   	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
> -	    hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
> -	    hba->active_uic_cmd || hba->uic_async_done ||
> +	    ufshcd_has_pending_tasks(hba) || !hba->clk_gating.is_initialized ||
>   	    hba->clk_gating.state == CLKS_OFF)
>   		return;
>   
> @@ -8221,7 +8227,9 @@ static void ufshcd_rtc_work(struct work_struct *work)
>   	hba = container_of(to_delayed_work(work), struct ufs_hba, ufs_rtc_update_work);
>   
>   	 /* Update RTC only when there are no requests in progress and UFSHCI is operational */
> -	if (!ufshcd_is_ufs_dev_busy(hba) && hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL)
> +	if (!ufshcd_is_ufs_dev_busy(hba) &&
> +	    hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL &&
> +	    !hba->clk_gating.active_reqs)
>   		ufshcd_update_rtc(hba);
>   
>   	if (ufshcd_is_ufs_dev_active(hba) && hba->dev_info.rtc_update_period)

Hi Avri,

I see two changes in this patch: introduction of the function
ufshcd_has_pending_tasks() and removal of hba->clk_gating.active_reqs
from ufshcd_is_ufs_dev_busy(). Shouldn't this patch be split into two
patches - one patch per change?

Thanks,

Bart.
