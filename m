Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AECD20315
	for <linux-scsi@vger.kernel.org>; Wed, 27 Mar 2024 02:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505623; cv=none; b=qUe2iTasbmIwX3zfEmQrc1pK5aAlQnE4hq2jtCvfH0OA5mWgAXO9xiyD5eKQMF57elc8VCvstBKh1I2m1U3TGPGH/kMkzWMqpo/W7O9DtQYpLLLzxqJp0pyES3v+O3EZ10gv+1h9oOJ7nBP9wf/txvQNGV0skwWx5wPXsMUZ94k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505623; c=relaxed/simple;
	bh=krlxY23uJV+N/E6JbP/ysHvM7EJAvNv93f6gCEk5U0c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gfSfeOd/dlmixOLhhcF1krH0NLn4PgoFOmLsdUQIMCnjoel1hyhc9+5qSdTmvp64upW1XY7BO3yDqQNUbPTYXqPHcN7ncKOHB1O3uWfQyzDwjvFH7NeAU6Uj+vomKKErXLJmHPCCzA88BuKmgU0bQAEDioje2e5poSjc1fBFFYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxiMTI8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxiMTI8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FA5C433F1;
	Wed, 27 Mar 2024 02:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505623;
	bh=krlxY23uJV+N/E6JbP/ysHvM7EJAvNv93f6gCEk5U0c=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=dxiMTI8IsXbMVKVRefem0eRKUrbibbJHXe4AEvEz/Mu89HU02CQLvJpP32wUg05My
	 wgQmxb5fOmiu7Fs3CjOiGQ2VMy6hIAM27+4kVrVm9N6shKq2VSwsniT28tPg9eJFcS
	 QBu+uBB5MsA44cPf6A5jnrcnvusoUnmnNkI5/v2CkN4laaGtNwH+nSD2FRbbtsV+FF
	 8qhyJG0oUSafPg8Wk07UPIg3SQM/HH2ZJgWwnsJWVjm5FVj04DtemAPQh9PBpN3IMM
	 OT0/iGfuQSLLxLTizZUjisnsVUyf0xKWb2z//G0e/ndtqv1SJY5qoGhM03zmY8cy7S
	 b5231XMdnH1Ig==
Message-ID: <763a19c8-83a5-4041-ab1e-3cfac3b470a2@kernel.org>
Date: Wed, 27 Mar 2024 11:13:41 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Fix declaration of ncq priority attributes
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Igor Pylypiv <ipylypiv@google.com>, John Garry <john.garry@huawei.com>
References: <20240327020122.439424-1-dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240327020122.439424-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/24 11:01, Damien Le Moal wrote:
> Commit b4d3ddd2df7 ("scsi: libsas: Define NCQ Priority sysfs attributes
> for SATA devices") introduced support for ATA NCQ priority control for
> ATA devices managed by libsas. This commit introduces the
> ncq_prio_supported and ncq_prio_enable sysfs device attributes to
> discover and control the use of this features, similarly to libata.
> However, libata publicly declares these device attributes and export
> them for use in ATA low level drivers. This leads to a compilation error
> when libsas and libata are built-in due to the double definition:
> 
> ld: drivers/ata/libata-sata.o:/home/Linux/scsi/drivers/ata/libata-sata.c:900:
> multiple definition of `dev_attr_ncq_prio_supported';
> drivers/scsi/libsas/sas_ata.o:/home/Linux/scsi/drivers/scsi/libsas/sas_ata.c:984:
> first defined here
> ld: drivers/ata/libata-sata.o:/home/Linux/scsi/drivers/ata/libata-sata.c:1026:
> multiple definition of `dev_attr_ncq_prio_enable';
> drivers/scsi/libsas/sas_ata.o:/home/Linux/scsi/drivers/scsi/libsas/sas_ata.c:1022:
> first defined here
> 
> Resolve this problem by directly declaring the libsas attributes instead
> of using the DEVICE_ATTR() macro. And for good measure, the device
> attribute variables are also renamed.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Fixes: b4d3ddd2df7 ("scsi: libsas: Define NCQ Priority sysfs attributes for SATA devices")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Forgot to add John to the distribution list...

> ---
>  drivers/scsi/libsas/sas_ata.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index b57c041a5544..4c69fc63c119 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -981,7 +981,8 @@ static ssize_t sas_ncq_prio_supported_show(struct device *device,
>  	return sysfs_emit(buf, "%d\n", supported);
>  }
>  
> -DEVICE_ATTR(ncq_prio_supported, S_IRUGO, sas_ncq_prio_supported_show, NULL);
> +static struct device_attribute dev_attr_sas_ncq_prio_supported =
> +	__ATTR(ncq_prio_supported, S_IRUGO, sas_ncq_prio_supported_show, NULL);
>  
>  static ssize_t sas_ncq_prio_enable_show(struct device *device,
>  					struct device_attribute *attr,
> @@ -1019,12 +1020,13 @@ static ssize_t sas_ncq_prio_enable_store(struct device *device,
>  	return len;
>  }
>  
> -DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
> -	    sas_ncq_prio_enable_show, sas_ncq_prio_enable_store);
> +static struct device_attribute dev_attr_sas_ncq_prio_enable =
> +	__ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
> +	       sas_ncq_prio_enable_show, sas_ncq_prio_enable_store);
>  
>  static struct attribute *sas_ata_sdev_attrs[] = {
> -	&dev_attr_ncq_prio_supported.attr,
> -	&dev_attr_ncq_prio_enable.attr,
> +	&dev_attr_sas_ncq_prio_supported.attr,
> +	&dev_attr_sas_ncq_prio_enable.attr,
>  	NULL
>  };
>  

-- 
Damien Le Moal
Western Digital Research

