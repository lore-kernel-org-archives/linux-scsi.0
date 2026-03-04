Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3859C347523;
	Wed,  4 Mar 2026 08:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772613145; cv=none; b=SmSNJ4C7g36B+HyOcJhtGuEkOcH9vyckz6Z/dgI1O9JeevXZA/tpcwK/8SJPOcTBu9qE1o1HLit2WekkIiqXCxOmvL6+2HRWw4uZohdIlcjrmJT9bCgt//+DvvRyMjxD3fyWnGQuDT+boUqJ0S2ZBsxyTmGY+hHfAjI82GkIS5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772613145; c=relaxed/simple;
	bh=Gk/D+QcV/M7xnceU+3xW5RMhszyuQkXGYMrZEK6v2wc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YNHTLch04CwHlUQkl7QwYhT/2Jy3e9Ygm0lX2hWBU8Twqdvg2uWpWRkkiRhi6nSXWYBum+AxBGRa5voD7BGVs7aVTw42xzaqsuCuanose+6+LZ3GylABe61PG+y0WqeTe8I6A+oqr+ub2XeYJ/RuOzFrdSXnAD0gmhk9OdaANZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eflSPy78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eflSPy78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5925C19423;
	Wed,  4 Mar 2026 08:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772613144;
	bh=Gk/D+QcV/M7xnceU+3xW5RMhszyuQkXGYMrZEK6v2wc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eflSPy78wMyKaV2fxZmCTGd5qYyDxkC9BzzQNWa96TWxhTuvlrswkdOg2vIPSZ7Ra
	 mFft4witgKZoKjfq4deKTtkffyc3QYfY4/gp1rFhuhREvJ9D4+/joUfXFYcMys4LHh
	 li9lAKMF7GrXWpB5rBZfvYke+yFBTGbWsOtOvKesnz59q/lDSiAX6SSBr7Ka7vK5eK
	 udOJIcxPVJyNYAhGVgSwxZ9oO4kDg5cKEa6rdvisoZiQhVFKJ8f9QJ8EYLhvxjRvUr
	 Lzt7r7F72jJlGs7qX1oRTrYZggdS/0cYtaMqkdIvuQtJS8IGTaYmEF64D2M4epiMWV
	 6puNTsDBhzAvw==
Message-ID: <6e162686-baa1-46da-aae6-07ec42d25e90@kernel.org>
Date: Wed, 4 Mar 2026 17:32:22 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: Fix async_scan race condition with
 READ_ONCE/WRITE_ONCE
To: Chaohai Chen <wdhh6@aliyun.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, bvanassche@acm.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260304075712.3039960-1-wdhh6@aliyun.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260304075712.3039960-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/4/26 16:57, Chaohai Chen wrote:
> Previously, host_lock was used to prevent bit-set conflicts in async_scan,
> but this approach introduced naked reads in some code paths.
> 
> Convert async_scan from a bitfield to a bool type to eliminate bit-level
> conflicts entirely. Use READ_ONCE() and WRITE_ONCE() to ensure proper
> memory ordering on Alpha and satisfy KCSAN requirements.
> 
> Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
> ---
> 
> v1->v3:
> use READ_ONCE()/WRITE_ONCE() to fix the issue (Christoph Hellwig, Damien Le Moal)
> 
> v1: https://lore.kernel.org/all/20260302121343.1630837-1-wdhh6@aliyun.com/
> 
>  drivers/scsi/scsi_scan.c | 22 ++++++++--------------
>  include/scsi/scsi_host.h |  6 +++---
>  2 files changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 60c06fa4ec32..892be54dacc6 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1298,7 +1298,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>  		goto out_free_result;
>  	}
>  
> -	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
> +	res = scsi_add_lun(sdev, result, &bflags, READ_ONCE(shost->async_scan));
>  	if (res == SCSI_SCAN_LUN_PRESENT) {
>  		if (bflags & BLIST_KEY) {
>  			sdev->lockable = 0;
> @@ -1629,7 +1629,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
>  	scsi_autopm_get_target(starget);
>  
>  	mutex_lock(&shost->scan_mutex);
> -	if (!shost->async_scan)
> +	if (!READ_ONCE(shost->async_scan))
>  		scsi_complete_async_scans();
>  
>  	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
> @@ -1839,7 +1839,7 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
>  		return;
>  
>  	mutex_lock(&shost->scan_mutex);
> -	if (!shost->async_scan)
> +	if (!READ_ONCE(shost->async_scan))
>  		scsi_complete_async_scans();
>  
>  	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
> @@ -1896,7 +1896,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
>  		return -EINVAL;
>  
>  	mutex_lock(&shost->scan_mutex);
> -	if (!shost->async_scan)
> +	if (!READ_ONCE(shost->async_scan))
>  		scsi_complete_async_scans();
>  
>  	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
> @@ -1943,13 +1943,12 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
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
> +	if (READ_ONCE(shost->async_scan)) {
>  		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
>  		goto err;
>  	}
> @@ -1962,9 +1961,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>  		goto err;
>  	init_completion(&data->prev_finished);
>  
> -	spin_lock_irqsave(shost->host_lock, flags);
> -	shost->async_scan = 1;
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	WRITE_ONCE(shost->async_scan, true);
>  	mutex_unlock(&shost->scan_mutex);
>  
>  	spin_lock(&async_scan_lock);
> @@ -1992,7 +1989,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>  static void scsi_finish_async_scan(struct async_scan_data *data)
>  {
>  	struct Scsi_Host *shost;
> -	unsigned long flags;
>  
>  	if (!data)
>  		return;
> @@ -2001,7 +1997,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
>  
>  	mutex_lock(&shost->scan_mutex);
>  
> -	if (!shost->async_scan) {
> +	if (!READ_ONCE(shost->async_scan)) {
>  		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
>  		dump_stack();
>  		mutex_unlock(&shost->scan_mutex);
> @@ -2012,9 +2008,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
>  
>  	scsi_sysfs_add_devices(shost);
>  
> -	spin_lock_irqsave(shost->host_lock, flags);
> -	shost->async_scan = 0;
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	WRITE_ONCE(shost->async_scan, false);
>  
>  	mutex_unlock(&shost->scan_mutex);
>  
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index f6e12565a81d..668ec9a1b33c 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -678,9 +678,6 @@ struct Scsi_Host {
>  	/* Task mgmt function in progress */
>  	unsigned tmf_in_progress:1;
>  
> -	/* Asynchronous scan in progress */
> -	unsigned async_scan:1;
> -
>  	/* Don't resume host in EH */
>  	unsigned eh_noresume:1;
>  
> @@ -699,6 +696,9 @@ struct Scsi_Host {
>  	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
>  	unsigned no_scsi2_lun_in_cdb:1;
>  
> +	/* Asynchronous scan in progress */
> +	bool async_scan;
> +

Please move this before the bit field in the structure to avoid holes.

>  	/*
>  	 * Optional work queue to be utilized by the transport
>  	 */


-- 
Damien Le Moal
Western Digital Research
