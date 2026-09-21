Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385283AE195
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 11:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789991044; cv=none; b=jV+Kho6SadqYae59kEiFmo3+9yRoRR9hsPo3LKSAQwQ1qBso3MhmDF5BbeOItQKXcxZbXyXAaZ83lvUHGR3ovhfnUZWPh+IJELRkQ8SJx4ex7P3YhXizGQnsPIBfuCpnS094OFNBPE7AhulcA07DOwP7/txKzHhD9YExBJyJRxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789991044; c=relaxed/simple;
	bh=AKPdGC9JOlNMpYWoBouv2KdkMyutfvsOHEGivjWDj8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k8IwEr176MMgRTVnaIEE7xoTVI00xuMDE8VrtRqbZrj9B8dUjCrcAPuMqqUOSA38VWGrwFXQr35+ZxjApMPAUiTpzPn89PCHIoHIiX19GfFmMycrkSWP9K/Na0YxZspgIrKbrpVJIjd1Og60kIVGtd7YMMo3EQToCVgttPpJK+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bTaZW2Ta; arc=none smtp.client-ip=95.215.58.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bTaZW2Ta"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AKPdGC9JOlNMpYWoBouv2KdkMyutfvsOHEGivjWDj8o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789991040; v=1; x=1790595840;
 b=bTaZW2Tae6U3k5Wv1izBZeqplvUy3prlxZtc+A/zWPU/89+FFqB7w/Ilfk2m2lZJeqh3liZy
 TthEuK7tfPYGhOV5zpHE61zTYdfQQnZSrxZCkh+gws2CXmwKu7LzTLBKaGAZ7ek/TPsqaqy7J84
 P6LUtEjxCC8qvPMBuYR3qAK0=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 94b5999d2a660a3c;
	Mon, 21 Sep 2026 11:43:59 +0000
X-Mizu-Trace-ID: 94b5999d2a660a3c
X-Migadu-Flow: FLOW_OUT
Message-ID: <085fcc2e-112f-4d4c-a07d-9d0962936e44@linux.dev>
Date: Mon, 21 Sep 2026 12:43:55 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Fix use-after-free in
 sas_eh_handle_resets()
To: Wentao Liang <vulab@iscas.ac.cn>, JBottomley@Parallels.com
Cc: James.Bottomley@HansenPartnership.com, djbw@kernel.org,
 john.g.garry@oracle.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, yanaijie@huawei.com,
 stable@vger.kernel.org
References: <20260917143946.2157366-1-vulab@iscas.ac.cn>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260917143946.2157366-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/26 15:39, Wentao Liang wrote:
> sas_eh_handle_resets() drops the reference it took on the domain device
> with sas_put_device() and then accesses dev->state again while holding
> ha->lock. The put may release the last reference, so the clear_bit()
> can touch freed memory.
> 
> Clear the pending flag first and drop the reference last.
> 
> Fixes: 5db45bdc87ce ("[SCSI] libsas: enforce eh strategy handlers only in eh context")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>   drivers/scsi/libsas/sas_scsi_host.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index c83282733ec4..14ca19c93c32 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -680,10 +680,15 @@ static void sas_eh_handle_resets(struct Scsi_Host *shost)
>   		if (test_and_clear_bit(SAS_DEV_RESET, &dev->state))
>   			i->dft->lldd_I_T_nexus_reset(dev);
>   
> -		sas_put_device(dev);
>   		spin_lock_irq(&ha->lock);
>   		clear_bit(SAS_DEV_EH_PENDING, &dev->state);
>   		ha->eh_active--;
> +		spin_unlock_irq(&ha->lock);
> +
> +		/* dev->state is no longer used, this may be the last reference */
> +		sas_put_device(dev);
> +
> +		spin_lock_irq(&ha->lock);
>   	}
>   	spin_unlock_irq(&ha->lock);
>   }


I think that the following is a better change:

----8<-----

--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -695,9 +695,9 @@ static void sas_eh_handle_resets(struct Scsi_Host 
*shost)
                 if (test_and_clear_bit(SAS_DEV_RESET, &dev->state))
                         i->dft->lldd_I_T_nexus_reset(dev);

+               clear_bit(SAS_DEV_EH_PENDING, &dev->state);
                 sas_put_device(dev);
                 spin_lock_irq(&ha->lock);
-               clear_bit(SAS_DEV_EH_PENDING, &dev->state);
                 ha->eh_active--;
         }
         spin_unlock_irq(&ha->lock);


---->8-----
