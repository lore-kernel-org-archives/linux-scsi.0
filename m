Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B2F360;
	Thu, 27 Jun 2024 01:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719450939; cv=none; b=PaARlPxI9ouI1f9xWJ38yfIvmkn7bj00gbyTG8RVLKl3JIiygxFcNM+p/2CJBtOtXSa+Z2VxFlldFVL1bmt3qzjH8QguBYQOI8czJmSOP1KLvM4gWmosTEgXj73LKky9jMwmsw4tSLYAjz0co5ouL77OBmsjc38OtTPS3OLTkn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719450939; c=relaxed/simple;
	bh=+Ps0wOnf0QmVH5I8eSHnVy1S/1T1R3pDog1HBNCOyYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OKxVaMUK7l36Lbxnob1mLUh/zpKrzBPk3gg4nYZZwxWXjQTVfEpEsMTI44xzg8+NwnzHAKt52K4rtmZWj/3umtOS3XvyL1z2yoANvr2itgZzcbS46UK5pY4XL6kaCFW7GtsE47+kg1aII0Ef4Avd55F8NrRUBxRSfYr+kXyQSK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VWX0WYPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VWX0WYPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F0AC2BD10;
	Thu, 27 Jun 2024 01:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719450939;
	bh=+Ps0wOnf0QmVH5I8eSHnVy1S/1T1R3pDog1HBNCOyYE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VWX0WYPLBLs0Kzv/bPErfTgyOJhv+5g3E9JCh1OFbjuP65dTKjolGI3zahVmRTNXR
	 e6EuUEhLYAAnBQl4XhqsyOjhEYEPOzdPpYw55Yjby0x5o+WC9PAPU2lZ4ErSwLQ3pa
	 SLxObi2O5CSTLJHqDhHZmDuzJpPJUPubHc+Jmk0wVjzZFE8uQwPHBr7rvE5GYY8vch
	 liuiv1DPASnoN6YPEFRzunDaTHZ0bE4Dkd23pHp2bTkmzbyOKmEL+YmvZW7m0igb0i
	 YvIPZ+r0t9TLxvjgtZTUdZB+rkoCqcQInyoxJ7G4p3PweyBLexrmw3ZTE7de3cf7+s
	 5b/dPsFzeutIA==
Message-ID: <ec3be157-4096-4817-885b-1cb90ca032b2@kernel.org>
Date: Thu, 27 Jun 2024 10:15:37 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] ata,scsi: libata-core: Add ata_port_free()
To: Niklas Cassel <cassel@kernel.org>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-20-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240626180031.4050226-20-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 03:00, Niklas Cassel wrote:
> Add a function, ata_port_free(), that is used to free a ata_port.
> It makes sense to keep the code related to freeing a ata_port in its own
> function, which will also free all the struct members of struct ata_port.
> 
> libsas is currently not freeing all the struct ata_port struct members,
> e.g. ncq_sense_buf for a driver supporting Command Duration Limits (CDL).

This part should be a separate fix patch and sent out this cycle.

> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

> @@ -5518,12 +5530,7 @@ static void ata_host_release(struct kref *kref)
>  	for (i = 0; i < host->n_ports; i++) {
>  		struct ata_port *ap = host->ports[i];
>  
> -		if (ap) {
> -			kfree(ap->pmp_link);
> -			kfree(ap->slave_link);
> -			kfree(ap->ncq_sense_buf);
> -			kfree(ap);
> -		}
> +		ata_port_free(ap);

The variable "ap" can be removed too.

>  		host->ports[i] = NULL;
>  	}
>  	kfree(host);

> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 6e01ddec10c9..951bdc554a10 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
>  
>  	if (dev_is_sata(dev) && dev->sata_dev.ap) {
>  		ata_tport_delete(dev->sata_dev.ap);
> -		kfree(dev->sata_dev.ap);
> +		ata_port_free(dev->sata_dev.ap);

Why not have this inside ata_tport_delete() ?

>  		ata_host_put(dev->sata_dev.ata_host);
>  		dev->sata_dev.ata_host = NULL;
>  		dev->sata_dev.ap = NULL;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 581e166615fa..586f0116d1d7 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1249,6 +1249,7 @@ extern int ata_slave_link_init(struct ata_port *ap);
>  extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
>  					   struct ata_port_info *, struct Scsi_Host *);
>  extern void ata_port_probe(struct ata_port *ap);
> +extern void ata_port_free(struct ata_port *ap);
>  extern int ata_tport_add(struct device *parent, struct ata_port *ap);
>  extern void ata_tport_delete(struct ata_port *ap);
>  int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limits *lim,

-- 
Damien Le Moal
Western Digital Research

