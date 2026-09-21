Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C51348F03A
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 11:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789990673; cv=none; b=CzOVm5rsYW7Osnmocv3mfNgNLrKEeXMSZgKBwkOY3ELK3yBmLO/vqRc4MXjAvUIqdY13ItnHEa3hFcTIuZUsRG260VKPdn0OnjnTzuToa0yseC8ztxC289OYPcFWbuJ0G03dxsTWOMTW9QmxcUXkWaSDvrPInZp5eVNzEGvlkJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789990673; c=relaxed/simple;
	bh=m7hNfSxPSwIpaL1L70GhCZJmufgA10s73TeAeGiuvaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N7HIPw56j//JI4ctozo+JtNi54q7k0PuVhFu+8dhgLqrqAv/3/Wkdfv7qtujz3YlhH2FRIUaukZfrqdYmNu5VxiZUOnkeBT1F5Ftkr3bEbaFPnhIet4mv7n0arG38TofEzSrhuHlsA+ka93pgPXSzv75IzKBYwlQ/ok8DPdfEiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KcJZCQP+; arc=none smtp.client-ip=95.215.58.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KcJZCQP+"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=m7hNfSxPSwIpaL1L70GhCZJmufgA10s73TeAeGiuvaI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789990667; v=1; x=1790595467;
 b=KcJZCQP+p7Hqgr4lQ2FO79sxCsHXtnDNE1eb8EHto7rvl8iGbXdO2T/YxyXipeTHeIQyk80N
 RTtl3D5GMhzM1+yq244IQTBqw8auaOYq9LEIaGzATkuUgUUIzmdQTQg/PsaBlwZSvLkXXrsIW8Z
 rLrZF6/SVw4rv7qZkUjDg8OY=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 17c102dc8b568dc9;
	Mon, 21 Sep 2026 11:37:47 +0000
X-Mizu-Trace-ID: 17c102dc8b568dc9
X-Migadu-Flow: FLOW_OUT
Message-ID: <9a72eeb3-ca32-4241-9e21-74cf894a9bf1@linux.dev>
Date: Mon, 21 Sep 2026 12:37:42 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: libsas: Fix SMP IO deadlock during HA resume
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
 jejb@linux.ibm.com, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260918070307.381207-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260918070307.381207-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/18/26 08:03, Xingui Yang wrote:
> When the controller resumes, sas_resume_ha() -> sas_drain_work()
> processes the DISCE_RESUME work, which restores the ATA ports through
> the libata error handler (ata_sas_port_resume() requests ATA_EH_RESET)
> and waits for it in sas_ata_flush_pm_eh(). For an expander-attached
> ATA device the hard reset in that recovery is an SMP PHY CONTROL
> command sent to the expander:
> 
>    ata_eh_recover() -> ata_eh_reset() -> sas_ata_hard_reset()
>      -> lldd_I_T_nexus_reset() -> sas_phy_reset()
>        -> sas_smp_phy_control() -> smp_execute_task_sg()

This seems like an obvious issue. How come it was not found earlier? It 
is apparently fixing a patch which is 5 years old.

> 
> For a runtime resume ha->dev is still RPM_RESUMING while the callback
> runs, so the pm_runtime_get_sync() in smp_execute_task_sg() blocks
> waiting for the resume to complete, but the resume is blocked in
> sas_drain_work() waiting for that very SMP IO — a deadlock.
> 
> Use pm_runtime_get_noresume() to take the reference while
> SAS_HA_RESUMING is set, and pm_runtime_put() to drop it. The hardware
> is already initialized by the LLDD before sas_resume_ha() runs.
> SAS_HA_RESUMING is also set during a system sleep resume, where the
> usage counter is still held from the sleep prepare and the put is
> harmless.
> 
> Outside of the resume window, convert the pm_runtime_get_sync() call
> to pm_runtime_resume_and_get() and check the result, so that an SMP IO
> is not submitted to a host whose runtime resume failed (the return
> value was previously ignored).
> 
> Only hisi_sas enables runtime PM among libsas LLDDs, so other drivers
> (pm8001, isci, aic94xx, mvsas) are unaffected.
> 
> Fixes: 0da7ca4c4fd9 ("scsi: libsas: Resume host while sending SMP I/Os")
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
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
>   drivers/scsi/libsas/sas_expander.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 811c9eb4fef1..5a8cdd3682fe 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -61,8 +61,22 @@ static int smp_execute_task_sg(struct domain_device *dev,
>   	struct sas_internal *i =
>   		to_sas_internal(dev->port->ha->shost->transportt);
>   	struct sas_ha_struct *ha = dev->port->ha;
> -
> -	pm_runtime_get_sync(ha->dev);
> +	bool ha_resuming = test_bit(SAS_HA_RESUMING, &ha->state);
> +
> +	/*
> +	 * While the host is resuming, ha->dev may be RPM_RESUMING and
> +	 * the resume blocked in sas_drain_work() waiting for this very
> +	 * SMP IO, so waiting for the host to resume here would deadlock.
> +	 * Hold the reference without resuming, the hardware is already
> +	 * initialized by the LLDD before sas_resume_ha() runs.
> +	 */
> +	if (ha_resuming) {
> +		pm_runtime_get_noresume(ha->dev);
> +	} else {
> +		res = pm_runtime_resume_and_get(ha->dev);
> +		if (res)
> +			return res;
> +	}
>   	mutex_lock(&dev->ex_dev.cmd_mutex);
>   	for (retry = 0; retry < 3; retry++) {
>   		if (test_bit(SAS_DEV_GONE, &dev->state)) {
> @@ -135,7 +149,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
>   		}
>   	}
>   	mutex_unlock(&dev->ex_dev.cmd_mutex);
> -	pm_runtime_put_sync(ha->dev);
> +	pm_runtime_put(ha->dev);
>   
>   	BUG_ON(retry == 3 && task != NULL);
>   	sas_free_task(task);

