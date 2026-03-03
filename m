Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0E0277017;
	Tue,  3 Mar 2026 08:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772527516; cv=none; b=tH7s5jerx+EYH/gcwCG5LccVQiIt3Lj1WI+cGRA3s+s1V0sRfTzIiMfv3gAdgRAFMJW4v83YMqMnd3eaQOKZPHowZx1Euf5DiW+aWHqhumt3jwkWyFzNijGHU0Jy2hMX0ECAa9jm/ugdfiaXynvs38bA3yL5LuIutAd1Nm9/Ho4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772527516; c=relaxed/simple;
	bh=3oNKpRNtiggh9skom3/Pbg1C/UB/IlYcwj9sWhysJLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BjidGKJOMjXNen9p/RcIl49GcFrL3BWCNA9sOn6tdy71T7g6e7UgxJBk99txrpkdZlDXTiKMMsWFHtotWu9LjwOD3IyVbIBfvDFPP5Dnz23JuKik7PGJp2p1YEgWCx9fUYVYi7angKdrTb1VfxswMp83hOrTi2isPSqRk4hmgbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVhRcHKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVhRcHKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3962EC19425;
	Tue,  3 Mar 2026 08:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772527516;
	bh=3oNKpRNtiggh9skom3/Pbg1C/UB/IlYcwj9sWhysJLI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cVhRcHKy/pRpgX/zKaG/QDWnushSxl4NLpPiNelv/QDBkCTDyRUPewW0oTK2H7qeN
	 Kco5sFQsYN8Zo5mP9+vTU3qlh16b94dtB9eM3bsbL1u3MBR+rAf837mITPnElQVavl
	 u9+lz2xqL6iVUTnQvwNDS+nSHSWqWRqfgeYO/jqPev+0aPlPkpICC39+LuCu21UmqK
	 vXNJf+peya7h2pyyq9+KovXTWtcGn2tkTKQzXXlaNpQpKTZv4fjKO4y8KPH8xdbC2O
	 RpXzk6YJytlThddLFadqtH4MQzGmFhpdlkKFHM6Dn0ToQjH+bEvr6PNDdyq5lxN0Th
	 36gKaJNcFN1XQ==
Message-ID: <8dbc772a-e0dd-44d2-8e1f-1e54df42d72b@kernel.org>
Date: Tue, 3 Mar 2026 17:45:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix missing lock when read async_scan in
 Scsi_Host
To: Chaohai Chen <wdhh6@aliyun.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260302121343.1630837-1-wdhh6@aliyun.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260302121343.1630837-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/2/26 21:13, Chaohai Chen wrote:
> When setting the async_scan flag in host, the host lock was locked,
> but it is not locked during reading. Encapsulate the corresponding
> API to fix this issue.
> 
> Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
> ---
>  drivers/scsi/scsi_scan.c | 60 +++++++++++++++++++++++++++++-----------
>  1 file changed, 44 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 60c06fa4ec32..8b63130ef2e5 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -122,6 +122,42 @@ struct async_scan_data {
>  	struct completion prev_finished;
>  };
>  
> +static bool scsi_test_async_scan(struct Scsi_Host *shost)
> +{
> +	bool async;
> +	unsigned long flags;
> +
> +	lockdep_assert_not_held(shost->host_lock);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	async = shost->async_scan;
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	return async;
> +}

Use an atomic ?

> +
> +static void scsi_set_async_scan(struct Scsi_Host *shost)
> +{
> +	unsigned long flags;
> +
> +	lockdep_assert_not_held(shost->host_lock);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	shost->async_scan = 1;
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +}
> +
> +static void scsi_clear_async_scan(struct Scsi_Host *shost)
> +{
> +	unsigned long flags;
> +
> +	lockdep_assert_not_held(shost->host_lock);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	shost->async_scan = 0;
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +}
> +
>  /*
>   * scsi_enable_async_suspend - Enable async suspend and resume
>   */
> @@ -1298,7 +1334,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>  		goto out_free_result;
>  	}
>  
> -	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
> +	res = scsi_add_lun(sdev, result, &bflags, scsi_test_async_scan(shost));
>  	if (res == SCSI_SCAN_LUN_PRESENT) {
>  		if (bflags & BLIST_KEY) {
>  			sdev->lockable = 0;
> @@ -1629,7 +1665,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
>  	scsi_autopm_get_target(starget);
>  
>  	mutex_lock(&shost->scan_mutex);
> -	if (!shost->async_scan)
> +	if (!scsi_test_async_scan(shost))
>  		scsi_complete_async_scans();
>  
>  	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
> @@ -1839,7 +1875,7 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
>  		return;
>  
>  	mutex_lock(&shost->scan_mutex);
> -	if (!shost->async_scan)
> +	if (!scsi_test_async_scan(shost))
>  		scsi_complete_async_scans();
>  
>  	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
> @@ -1896,7 +1932,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
>  		return -EINVAL;
>  
>  	mutex_lock(&shost->scan_mutex);
> -	if (!shost->async_scan)
> +	if (!scsi_test_async_scan(shost))
>  		scsi_complete_async_scans();
>  
>  	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
> @@ -1943,13 +1979,12 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
>  static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>  {
>  	struct async_scan_data *data = NULL;
> -	unsigned long flags;
>  
>  	if (strncmp(scsi_scan_type, "sync", 4) == 0)
>  		return NULL;
>  
>  	mutex_lock(&shost->scan_mutex);
> -	if (shost->async_scan) {
> +	if (scsi_test_async_scan(shost)) {
>  		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
>  		goto err;
>  	}
> @@ -1961,10 +1996,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>  	if (!data->shost)
>  		goto err;
>  	init_completion(&data->prev_finished);
> -
> -	spin_lock_irqsave(shost->host_lock, flags);
> -	shost->async_scan = 1;
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	scsi_set_async_scan(shost);
>  	mutex_unlock(&shost->scan_mutex);
>  
>  	spin_lock(&async_scan_lock);
> @@ -1992,7 +2024,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>  static void scsi_finish_async_scan(struct async_scan_data *data)
>  {
>  	struct Scsi_Host *shost;
> -	unsigned long flags;
>  
>  	if (!data)
>  		return;
> @@ -2001,7 +2032,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
>  
>  	mutex_lock(&shost->scan_mutex);
>  
> -	if (!shost->async_scan) {
> +	if (!scsi_test_async_scan(shost)) {
>  		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
>  		dump_stack();
>  		mutex_unlock(&shost->scan_mutex);
> @@ -2011,10 +2042,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
>  	wait_for_completion(&data->prev_finished);
>  
>  	scsi_sysfs_add_devices(shost);
> -
> -	spin_lock_irqsave(shost->host_lock, flags);
> -	shost->async_scan = 0;
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	scsi_clear_async_scan(shost);
>  
>  	mutex_unlock(&shost->scan_mutex);
>  


-- 
Damien Le Moal
Western Digital Research
