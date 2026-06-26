Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79873AEF50;
	Fri, 26 Jun 2026 22:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782511870; cv=none; b=sleeoDHi+QDVC7s16khrrbG2IM6uuuOw2tG48w1FlPn4TZKK+qi0MTxT6Xu/Vo66J290DyfbZYp5RCJ4SfvTb9gKt3qPDGuJWCJkUvW7Igu/Hvg7WRYKIWW7LSZIv074jXZTMuN+qbVUMfab0X1/Yp0lXBBnFN+aww4BWwwwaRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782511870; c=relaxed/simple;
	bh=7M/FugBfskShcz+XtHCrsu3r0ANsIj70ukxI+uLXXks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kE1vVrnutyKfqJ+SdYusVavrZxcnz82/JkuQbhfMDHYvpD/Kkc9hrTslLVpPeyQCcQumsu5BXKun7X826qsCvVf5+zHWDWXQeOUMRrIrOW6SHD7usO3AfbWRCyivEEw88ImWVuIoMV08Ccab3G2BvNbz6rFMM/ZumOFW0jGufHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWkHjZCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWkHjZCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FE31F000E9;
	Fri, 26 Jun 2026 22:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782511869;
	bh=L6FmC3VN1d8NuvhVjp6d49+V8pA1Iapf0CWeIDyTr6s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jWkHjZCocYCauAXjfcwIQo7efn4kBoRbdRtZvggAODys47vLNUoGfpOpIG5A4H01C
	 Lcalsshmgv8+j8Iq9ZWuGBSFcIG1kRayTRK1OboKrpiaCUAoaUl2cpl3ug5m9e6FUk
	 L16SfxWl1m4Epk/PWTD/otGnkqcRw35D8Mm4dY9cr0U9OaDMyzlRiyS+6v3t9hzPdu
	 kXYiyG8Z1Opq9d2QkTHQgaVEYdvz+31ex3lws8sSQV+oWEbNvWFaFx/rpLtq/O/UWf
	 WoPVqXq0/g3AfzBuycltfBoDXWerH+5I6bdxBShYV+E8yG6drkvlqqcR+WU1zbQCp2
	 SVCiqe999tVuw==
Message-ID: <218133be-eca7-44ac-a9f6-81283c55185d@kernel.org>
Date: Sat, 27 Jun 2026 07:11:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Handle expander discovery allocation
 failures
To: Haoxiang Li <haoxiang_li2024@163.com>, john.g.garry@oracle.com,
 yanaijie@huawei.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, cassel@kernel.org, kees@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260623112909.2172701-1-haoxiang_li2024@163.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260623112909.2172701-1-haoxiang_li2024@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/23/26 20:29, Haoxiang Li wrote:
> sas_ex_discover_expander() allocates a domain device and SAS port before
> allocating the expander rphy, but it does not check all allocation and
> registration failures. In particular, sas_expander_alloc() can return
> NULL and the returned rphy is dereferenced unconditionally.
> 
> Add error handling for sas_port_alloc(), sas_port_add(), and
> sas_expander_alloc(), and unwind the resources allocated on each path.
> Use sas_port_free() before a port has been added and sas_port_delete()
> after it has been added.
> 
> Free the child device directly on these early failures because child->rphy
> has not been initialized yet, and sas_put_device() would dereference it.
> 
> Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>

Looks OK. A couple of nits below.

> ---
>  drivers/scsi/libsas/sas_expander.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index f471ab464a78..56c04c4ae818 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -909,9 +909,11 @@ static struct domain_device *sas_ex_discover_expander(
>  		return NULL;
>  
>  	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
> -	/* FIXME: better error handling */
> -	BUG_ON(sas_port_add(phy->port) != 0);
> -
> +	if (!phy->port)
> +		goto out_free_child;

For readability, a blank line would be nice here.

> +	res = sas_port_add(phy->port);
> +	if (res)
> +		goto out_free_port;
>  
>  	switch (phy->attached_dev_type) {
>  	case SAS_EDGE_EXPANDER_DEVICE:
> @@ -926,6 +928,9 @@ static struct domain_device *sas_ex_discover_expander(
>  		rphy = NULL;	/* shut gcc up */
>  		BUG();

can we drop this BUG() too so that instead of crashing we properly error unwind?

>  	}
> +	if (!rphy)
> +		goto out_delete_port;
> +
>  	port = parent->port;
>  	child->rphy = rphy;
>  	get_device(&rphy->dev);
> @@ -963,6 +968,19 @@ static struct domain_device *sas_ex_discover_expander(
>  	}
>  	list_add_tail(&child->siblings, &parent->ex_dev.children);
>  	return child;
> +
> +out_delete_port:
> +	sas_port_delete(phy->port);
> +	phy->port = NULL;
> +	kfree(child);
> +	return NULL;
> +
> +out_free_port:
> +	sas_port_free(phy->port);
> +	phy->port = NULL;
> +out_free_child:
> +	kfree(child);
> +	return NULL;
>  }
>  
>  static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)


-- 
Damien Le Moal
Western Digital Research
