Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A2E4FDA6F
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 16:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663555; cv=none; b=hzseGs8F8+5RJROllqhjoOGtNdia0M/3qh6W9ouH+y/BHuXoNToZBZzZwaNLfYb3LCRqgw39KMhEWGNsmIuS6P7T+j30zpfUMk7gOJo/y1myErV9XgONBSBig7GYEwaKA45aZ6xp9UdOZZJBM0RD63oZYmCrHSy2sBy7P5f/Dto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663555; c=relaxed/simple;
	bh=V5INTN8RuWwRwwnNDHAyBiXr8TPXJ7fn99txaxZ+ahE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MDG+xxrwbvKS3vgxLx7iNfbpQMP42FZtSbvM40QfpmSZC6CFKc/29eNlyaOiKWWNj7nTBqVVVVkfWf6Znejs2kYdnOupE7I0Bndz2ArWX9P5iEpkAB1lnpPpAejwFxZErHTaNtr8yu4u87B6rHULz4ceplSFCHtnl05m0C9Q8NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OAPOHPX+; arc=none smtp.client-ip=91.218.175.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OAPOHPX+"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=V5INTN8RuWwRwwnNDHAyBiXr8TPXJ7fn99txaxZ+ahE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789663550; v=1; x=1790268350;
 b=OAPOHPX+raBVgDiTxlBRJpeAO/c0D2hJhq8U2xcGg7UIu2tyYWfSpYhmemW94eX37lSHPmLE
 At+KwCgGfCW3tEubzxGJ64NRsTTVFEya6nbRLgEBcWCalSY1IJ5PZ+iiHYlpIIiw3YA+NQ5zHiQ
 xrTyJYRSX3PMi3W8LAiqrkk0=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 378d3e8deb789c20;
	Thu, 17 Sep 2026 16:45:50 +0000
X-Mizu-Trace-ID: 378d3e8deb789c20
X-Migadu-Flow: FLOW_OUT
Message-ID: <b0e2de23-7421-4217-bd37-e98e59bef873@linux.dev>
Date: Thu, 17 Sep 2026 17:45:48 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Fix use-after-free in sas_suspend_devices()
To: Wentao Liang <vulab@iscas.ac.cn>, JBottomley@Parallels.com
Cc: James.Bottomley@HansenPartnership.com, djbw@kernel.org,
 jacek.danecki@intel.com, john.g.garry@oracle.com,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, stern@rowland.harvard.edu, yanaijie@huawei.com,
 stable@vger.kernel.org
References: <20260917143800.2157286-1-vulab@iscas.ac.cn>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260917143800.2157286-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/26 15:38, Wentao Liang wrote:
> sas_suspend_devices() walks port->dev_list with list_for_each_entry()
> while sas_notify_lldd_dev_gone() may drop the last reference 

The low-level device driver should not keep (nor put) a reference to the 
domain device.

Notice how sas_put_device() is in sas_internal.h ?

> and free
> the current device, so the next iteration dereferences freed memory.
> 
> Use list_for_each_entry_safe() to keep the next entry around.
> 
> Fixes: 303694eeee5e ("[SCSI] libsas: suspend / resume support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>   drivers/scsi/libsas/sas_discover.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index b07062db50b2..91045966612e 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -231,7 +231,7 @@ static void sas_probe_devices(struct asd_sas_port *port)
>   static void sas_suspend_devices(struct work_struct *work)
>   {
>   	struct asd_sas_phy *phy;
> -	struct domain_device *dev;
> +	struct domain_device *dev, *n;
>   	struct sas_discovery_event *ev = to_sas_discovery_event(work);
>   	struct asd_sas_port *port = ev->port;
>   	struct Scsi_Host *shost = port->ha->shost;
> @@ -245,7 +245,7 @@ static void sas_suspend_devices(struct work_struct *work)
>   	 * suspension, we force the issue here to keep the reference
>   	 * counts aligned
>   	 */
> -	list_for_each_entry(dev, &port->dev_list, dev_list_node)
> +	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node)
>   		sas_notify_lldd_dev_gone(dev);
>   
>   	/* we are suspending, so we know events are disabled and

