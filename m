Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE848287C;
	Wed, 22 May 2024 12:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716380612; cv=none; b=rPuQYA3v+OTb6xypA81jgooJGiYfACcxDBbNTety5Ee91xBpFL9OBZ+AvG4siAg9nCE8hjim3zjlGtpzukxGHMuFaYsXVu8MaCvJQ40FXbdMv7sMz0mt6ZPjiQuP5ZK4QRPu5L4WnaM8AszgKdE3ty2F45dANsJGS21MLO852CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716380612; c=relaxed/simple;
	bh=FjqCLCPKNxX5x8NRyIF9DPo+K51w7Xt7vSUtZB+xj68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9mUZjBAFqmOTCowzD9uQ4W6qgeaRhkJhtA4xs0VJVeCuEWEJSR4tFiwmj8WSlpJ/OVaoWme75bTt/Nye20hNIkUOz6nUUD2E0QmxBT0/WiFSrQgtff450jArGPMaBr63ob17nSKXxq9/DBnStEY+HUhPQVdPW3eZNz2ZfJJczA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8k7kLlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8k7kLlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C7FC2BD11;
	Wed, 22 May 2024 12:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716380611;
	bh=FjqCLCPKNxX5x8NRyIF9DPo+K51w7Xt7vSUtZB+xj68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N8k7kLlj1hYg741ysC4LYoD/zhAf5kFI9bAdIU3Pns090H6ENIR6lyzfmKrqZ/QaJ
	 U4mlikxDjUJUeERh0s1cS35dAwHZtUaSR4lPg8IlcyWUI7DevZ0OwDkZ9qZbwDFZMX
	 eSfq2tm/tsBL4ueyyeCTVKmjpIkQVnIv1419eFBM=
Date: Wed, 22 May 2024 14:23:28 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Xingui Yang <yangxingui@huawei.com>
Cc: rafael@kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxarm@huawei.com,
	prime.zeng@hisilicon.com, liyihang9@huawei.com,
	kangfenglong@huawei.com
Subject: Re: [PATCH] driver core: Add log when devtmpfs create node failed
Message-ID: <2024052221-pulverize-worrisome-37fb@gregkh>
References: <20240522114346.42951-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522114346.42951-1-yangxingui@huawei.com>

On Wed, May 22, 2024 at 11:43:46AM +0000, Xingui Yang wrote:
> Currently, no exception information is output when devtmpfs create node
> failed, so add log info for it.

Why?  Who is going to do something with this?

> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
>  drivers/base/core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 5f4e03336e68..32a41e0472b2 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -3691,7 +3691,10 @@ int device_add(struct device *dev)
>  		if (error)
>  			goto SysEntryError;
>  
> -		devtmpfs_create_node(dev);
> +		error = devtmpfs_create_node(dev);
> +		if (error)
> +			pr_info("devtmpfs create node for %s failed: %d\n",
> +				dev_name(dev), error);

Why is an error message pr_info()?

And again, why is this needed?  If this needs to be checked, why are you
now checking it but ignoring the error?

What would this help with?

thanks,

greg k-h
