Received: from mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C03B48FF71
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 10:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790764857; cv=none; b=aY78xoWeyWQNW2jVxlZVRjG3nLMW+YFbkYPVtwS+0cTte7hwVvRCBvYqvtNRJ4UL0dKScI07JMUsQgG5CVcFtC/CYLEqme2r2084P27yl30MFoNQIB4VPcdQdTRNUOpSPOg0aKRazTTDf3Ld/z7UOJf4kqBbWf4hEyHskHll0bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790764857; c=relaxed/simple;
	bh=ws7MHPb/4Kh4CouikZp1btmelMOEgVbMdOCyZd50Fok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=twubi3K2qD57NT667WoXiUeFRq0pGd8t+t0gShv9yiDh1kvh1Ra7WAk/1tAlyaI6JfJ7bVfVstW6bWM0qVH8S4NUGMcS5krbHkkxYXEptVHXzBHpkkB7LFNMd3R2DoJa6PzEi1w3n+VhcOSzTWCLcM9ZymonC45a5nNw1FtXm6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TQZIipb9; arc=none smtp.client-ip=91.218.175.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TQZIipb9"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ws7MHPb/4Kh4CouikZp1btmelMOEgVbMdOCyZd50Fok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790764843; v=1; x=1791369643;
 b=TQZIipb9EhieN17NcRKPY7KuUozWA3Etk2wTMM+btI7ttk78CHs3QLUKjuM3JbcvCdyCAIv0
 CiYU5tcuHJoInEM6kk3uXQzp0TnGqqDp+P0OKD4ib++RH6c1ef8dP62zCXJ70SwIDt13/X0j88W
 fhCdVyXnxMIjDyjiX2l+v+hY=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 9d2ce5c8554342d0;
	Wed, 30 Sep 2026 10:40:32 +0000
X-Mizu-Trace-ID: 9d2ce5c8554342d0
X-Migadu-Flow: FLOW_OUT
Message-ID: <820657c2-1cbd-47d8-92f2-477531692135@linux.dev>
Date: Wed, 30 Sep 2026 11:40:27 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: libsas: Fix SMP IO deadlock during HA resume
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
 jejb@linux.ibm.com, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260928040234.992912-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260928040234.992912-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/26 05:02, Xingui Yang wrote:
> smp_execute_task_sg() calls pm_runtime_get_sync() on the host before
> issuing an SMP command. When that command is itself issued from the
> HA resume path, the get_sync() deadlocks: it waits for the ongoing
> resume (the device is RPM_RESUMING), while the resume is blocked in
> sas_drain_work() waiting for that same SMP IO to complete.
> 
> The deadlock needs an expander-attached SATA disk. 

What do you mean by "deadlock needs an expander-attached SATA disk?

> During
> sas_resume_ha() -> sas_drain_work(), DISCE_RESUME ->
> sas_resume_sata() -> ata_sas_port_resume() requests ATA_EH_RESET,
> and the hard reset for such a disk is done via SMP PHY CONTROL
> (sas_ata_hard_reset() -> sas_phy_reset() -> sas_smp_phy_control() ->
> smp_execute_task_sg()). Direct-attached SATA resets through
> lldd_control_phy() and SSP devices use TMFs, so neither hits this.
> 
> Replace the get_sync()/put_sync() pair with
> pm_runtime_get_noresume()/pm_runtime_put(). smp_execute_task_sg()
> only needs to hold off autosuspend while the SMP is in flight, and it
> must not try to resume the host: a sync resume issued from the HA
> resume path itself is what deadlocks, and by the time sas_resume_ha()
> runs, hw_init has already reinitialized the hardware, so the device
> is accessible without one.
> 
> The usage reference is still required. 

Do you mean that usage reference from pm_runtime_get_noresume() is still 
required?

> Discovery work normally runs
> inside an event worker's PM reference, taken at
> sas_notify_port_event() notify time and held until the handler has
> flushed the disco queue. sas_rediscover_ex_phy() however requeues
> DISCE_REVALIDATE_DOMAIN from within the revalidation worker itself,
> and flush_workqueue() does not wait for work items queued during
> execution, so that chained revalidation runs with no outer PM
> reference - without the get_noresume(), its SMP could race
> autosuspend.
> 
> For the BSG path, sas_smp_handler() is the only caller which may
> find the host autosuspended: expander SMP requests do not go through
> any SCSI device request queue, so nothing else in that path holds
> the host awake. Resume it there with pm_runtime_resume_and_get()
> and check the result.
> 
> Fixes: 3dbbbf656b850 ("scsi: libsas: Fix HA resume deadlock and hisi_sas disk-wake race")
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>

Question: do you have a (non-hisi_sas) SAS HBA card whose driver uses 
libsas? pm8001 would be such an example. It would be nice to verify that 
all these and other non-rpm libsas changes does cause regression there.

> ---
> Changes since v3:
> - Move the host resume to sas_smp_handler(), the only caller which may
>    find the host autosuspended, as suggested by John Garry
> - Replace get_sync()/put_sync() with get_noresume()/put() in
>    smp_execute_task_sg(): a blocking resume issued from the HA resume
>    path itself is what deadlocks
> - Drop the racy SAS_HA_RESUMING check
> 
> Changes since v2:
> - Drop the reference with pm_runtime_put() instead of
>    pm_runtime_put_noidle().
> 
> Changes since v1:
> - Use pm_runtime_get_noresume()/put_noidle() during HA resume instead
>    of skipping the PM reference entirely, so an in-flight SMP IO always
>    keeps autosuspend away.
> - Convert pm_runtime_get_sync() to pm_runtime_resume_and_get() and
>    check the result (pre-existing issue flagged by sashiko).
> 
>   drivers/scsi/libsas/sas_expander.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 811c9eb4fef1..26c2099c28b9 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -62,7 +62,11 @@ static int smp_execute_task_sg(struct domain_device *dev,
>   		to_sas_internal(dev->port->ha->shost->transportt);
>   	struct sas_ha_struct *ha = dev->port->ha;
>   
> -	pm_runtime_get_sync(ha->dev);
> +	/*
> +	 * Non-blocking: a sync resume here would deadlock against
> +	 * sas_drain_work() during HA resume.
> +	 */
> +	pm_runtime_get_noresume(ha->dev);
>   	mutex_lock(&dev->ex_dev.cmd_mutex);
>   	for (retry = 0; retry < 3; retry++) {
>   		if (test_bit(SAS_DEV_GONE, &dev->state)) {
> @@ -135,7 +139,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
>   		}
>   	}
>   	mutex_unlock(&dev->ex_dev.cmd_mutex);
> -	pm_runtime_put_sync(ha->dev);
> +	pm_runtime_put(ha->dev);
>   
>   	BUG_ON(retry == 3 && task != NULL);
>   	sas_free_task(task);
> @@ -2222,6 +2226,11 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
>   		goto out;
>   	}
>   
> +	/* The host may have autosuspended, resume it here. */
> +	ret = pm_runtime_resume_and_get(dev->port->ha->dev);
> +	if (ret)
> +		goto out;
> +
>   	ret = smp_execute_task_sg(dev, job->request_payload.sg_list,
>   			job->reply_payload.sg_list);
>   	if (ret >= 0) {
> @@ -2229,6 +2238,7 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
>   		rcvlen = job->reply_payload.payload_len - ret;
>   		ret = 0;
>   	}
> +	pm_runtime_put(dev->port->ha->dev);
>   
>   out:
>   	bsg_job_done(job, ret, rcvlen);

