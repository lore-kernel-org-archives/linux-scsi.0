Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C8325F7A9;
	Fri, 30 Jan 2026 03:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769742125; cv=none; b=SYqT6dDhhGuFUx2aY/4JE3VXnWaTq4V+W9kgiRCHlndOJWdcGCUjMrpwdNJuGRmUsR2ZTpXckohMnW/ylesN7ffPZ051phsy9nQrDk6kqFwj3qwnQlbLqbCdrk7/sdSFIYHTjG/M7pogyaroOI/6mEl4ink8lQRgOmYHoaUdSbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769742125; c=relaxed/simple;
	bh=A4YfM+zfTczKpjl2dplTXZI2lD+xPV+s59uqx5+/34U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UHUrgubFz13K2AcsHcLmDSWFgTM33Me0nmq43Y0vTkLUqTyBA8h0NEDV5H1jPBPpN9tpONtitmKXWsKbSysjf5jUQJ6I+VPSDOm6wEUp6N0SN03cIIJe3hURtc86jfgQ8NBdeJfSs0xFl0uYGuRo0o/8zgCTJhCIWaRPrt6ZJes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t01RtS46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t01RtS46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CDBC4CEF7;
	Fri, 30 Jan 2026 03:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769742124;
	bh=A4YfM+zfTczKpjl2dplTXZI2lD+xPV+s59uqx5+/34U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t01RtS46jKqjVbdyZqyp71MUzAy//b4nDcKc0FLiiIoLsWJeatAWdWQRa2jwCLhKR
	 EDrQpGb2+oqR1DVp/1wHH+6ytlw4LggYMmKtNaIBroDyUGVRvCUOXpwivPqPepTXa2
	 Ui4q222fKZ7aMbTEBJ4G2O+r43xlBs00OI4nOX4TS0QOAHWDfcz1qwXovwxva+74R4
	 Q9q559OO2XiehLvO4vzoy5DATCQmPt4YuKl325tkJl6z8zsSV1AUJ5c4nFaUTcFTMO
	 Fq7oQP+ErehiKegpEtazE5gMorAH7hI/+PX1kYVxBYmYVCRKZqaUc5c5HcA0ia4nxW
	 QARKURjNToaWQ==
Message-ID: <aa5ca682-ea38-49f6-81a1-6b154f00239d@kernel.org>
Date: Fri, 30 Jan 2026 12:02:01 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Fix dev_list race conditions with proper
 locking
To: Chaohai Chen <wdhh6@aliyun.com>, john.g.garry@oracle.com,
 yanaijie@huawei.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, johannes.thumshirn@wdc.com, mingo@kernel.org,
 cassel@kernel.org, tglx@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260129093859.1418749-1-wdhh6@aliyun.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260129093859.1418749-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/29/26 18:38, Chaohai Chen wrote:
> Multiple functions in libsas were accessing port->dev_list without
> proper locking, leading to potential race conditions that could cause:
> - Use-after-free when devices are removed during list traversal
> - List corruption from concurrent modifications
> - System crashes from accessing freed memory

There si a lot going on in this patch with reference counting changes that are
not very clear. Ideally, this patch should be split to address reference
counting and exclusive access to the list with a spinlock.

More comments below.

> 
> This patch adds proper dev_list_lock protection to the following functions:
> 
> 1. sas_ex_level_discovery(): Added locking around list traversal with
>    safe iteration and reference counting for devices. The lock is
>    released before calling functions that may sleep
>    (sas_ex_discover_devices).
> 
> 2. sas_dev_present_in_domain(): Added locking for read-only list access
>    to prevent reading inconsistent list state.
> 
> 3. sas_suspend_devices(): Added locking around list traversal to prevent
>    concurrent modifications during device suspension.
> 
> 4. sas_unregister_domain_devices(): Added proper locking with reference
>    counting. The lock is released before calling sas_unregister_dev()
>    which may sleep, but device references are held to prevent premature
>    removal.
> 
> 5. sas_port_event_worker(): Added locking around list traversal with
>    reference counting for devices accessed outside the lock.
> 
> All modifications follow the pattern of:
> - Hold dev_list_lock during list traversal
> - Use list_for_each_entry_safe where list may be modified
> - Take device reference (kref_get) before releasing lock
> - Release lock before calling functions that may sleep
> - Release device reference (sas_put_device) after use
> 
> Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
> ---
>  drivers/scsi/libsas/sas_discover.c | 14 +++++++++++++
>  drivers/scsi/libsas/sas_expander.c | 32 +++++++++++++++++++++++-------
>  drivers/scsi/libsas/sas_port.c     | 10 ++++++++++
>  3 files changed, 49 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index b07062db50b2..3c18fdfde8c2 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -245,8 +245,10 @@ static void sas_suspend_devices(struct work_struct *work)
>  	 * suspension, we force the issue here to keep the reference
>  	 * counts aligned
>  	 */
> +	spin_lock_irq(&port->dev_list_lock);
>  	list_for_each_entry(dev, &port->dev_list, dev_list_node)
>  		sas_notify_lldd_dev_gone(dev);
> +	spin_unlock_irq(&port->dev_list_lock);
>  
>  	/* we are suspending, so we know events are disabled and
>  	 * phy_list is not being mutated
> @@ -410,11 +412,23 @@ void sas_unregister_domain_devices(struct asd_sas_port *port, bool gone)
>  {
>  	struct domain_device *dev, *n;
>  
> +	/* Lock while iterating to prevent concurrent modifications.

Please use the correct kernel style: multi-line comments start with a "/*" line
with no text.

> +	 * We need to unlock before calling sas_unregister_dev() as it
> +	 * may sleep, but we hold a reference to prevent device removal.

And why is that necessary ?

> +	 */
> +	spin_lock_irq(&port->dev_list_lock);
>  	list_for_each_entry_safe_reverse(dev, n, &port->dev_list, dev_list_node) {
>  		if (gone)
>  			set_bit(SAS_DEV_GONE, &dev->state);
> +		kref_get(&dev->kref);
> +		spin_unlock_irq(&port->dev_list_lock);
> +
>  		sas_unregister_dev(port, dev);
> +		sas_put_device(dev);
> +
> +		spin_lock_irq(&port->dev_list_lock);
>  	}
> +	spin_unlock_irq(&port->dev_list_lock);
>  
>  	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
>  		sas_unregister_dev(port, dev);
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index d953225f6cc2..c82c9b3d5103 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -643,14 +643,21 @@ static int sas_dev_present_in_domain(struct asd_sas_port *port,
>  					    u8 *sas_addr)
>  {
>  	struct domain_device *dev;
> +	int found = 0;

Use a bool please. That menas changing the function to return a bool as well.

>  
>  	if (SAS_ADDR(port->sas_addr) == SAS_ADDR(sas_addr))
>  		return 1;
> +
> +	spin_lock_irq(&port->dev_list_lock);
>  	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
> -		if (SAS_ADDR(dev->sas_addr) == SAS_ADDR(sas_addr))
> -			return 1;
> +		if (SAS_ADDR(dev->sas_addr) == SAS_ADDR(sas_addr)) {
> +			found = 1;
> +			break;
> +		}
>  	}
> -	return 0;
> +	spin_unlock_irq(&port->dev_list_lock);
> +
> +	return found;
>  }
>  
>  #define RPEL_REQ_SIZE	16
> @@ -1579,20 +1586,31 @@ static int sas_discover_expander(struct domain_device *dev)
>  static int sas_ex_level_discovery(struct asd_sas_port *port, const int level)
>  {
>  	int res = 0;
> -	struct domain_device *dev;
> +	struct domain_device *dev, *n;
>  
> -	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
> +	spin_lock_irq(&port->dev_list_lock);
> +	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node) {
>  		if (dev_is_expander(dev->dev_type)) {
>  			struct sas_expander_device *ex =
>  				rphy_to_expander_device(dev->rphy);
>  
> -			if (level == ex->level)
> +			if (level == ex->level) {
> +				kref_get(&dev->kref);
> +				spin_unlock_irq(&port->dev_list_lock);
>  				res = sas_ex_discover_devices(dev, -1);
> -			else if (level > 0)
> +				sas_put_device(dev);
> +				spin_lock_irq(&port->dev_list_lock);

This was locked already before the loop. So you will deadlock here... no ?

> +			} else if (level > 0) {
> +				kref_get(&port->port_dev->kref);
> +				spin_unlock_irq(&port->dev_list_lock);
>  				res = sas_ex_discover_devices(port->port_dev, -1);
> +				sas_put_device(port->port_dev);
> +				spin_lock_irq(&port->dev_list_lock);
> +			}
>  
>  		}
>  	}
> +	spin_unlock_irq(&port->dev_list_lock);
>  
>  	return res;
>  }
> diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
> index de7556070048..491c9f7104c6 100644
> --- a/drivers/scsi/libsas/sas_port.c
> +++ b/drivers/scsi/libsas/sas_port.c
> @@ -44,13 +44,19 @@ static void sas_resume_port(struct asd_sas_phy *phy)
>  	 * 1/ presume every device came back
>  	 * 2/ force the next revalidation to check all expander phys
>  	 */
> +	spin_lock_irq(&port->dev_list_lock);
>  	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node) {
>  		int i, rc;
>  
> +		kref_get(&dev->kref);
> +		spin_unlock_irq(&port->dev_list_lock);
> +
>  		rc = sas_notify_lldd_dev_found(dev);
>  		if (rc) {
>  			sas_unregister_dev(port, dev);
>  			sas_destruct_devices(port);
> +			sas_put_device(dev);

Same here. Why is the extra reference count needed ?

> +			spin_lock_irq(&port->dev_list_lock);
>  			continue;
>  		}
>  
> @@ -62,7 +68,11 @@ static void sas_resume_port(struct asd_sas_phy *phy)
>  				phy->phy_change_count = -1;
>  			}
>  		}
> +
> +		sas_put_device(dev);
> +		spin_lock_irq(&port->dev_list_lock);
>  	}
> +	spin_unlock_irq(&port->dev_list_lock);
>  
>  	sas_discover_event(port, DISCE_RESUME);
>  }


-- 
Damien Le Moal
Western Digital Research
