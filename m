Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7623F7484;
	Thu, 27 Jun 2024 01:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719450454; cv=none; b=dd+tI7sDxSlx9qIa007x/crjVGb+4q4Hx1XrO/SkRxwbxvwzAlGhIkdbl31AfQMI5/ypn98TCLZYOmBGmAxTNkPY7YLD5j3lKs5unPXO1NHRKDTKDkFrU/dWXOX1i9Gklq5amiOBE+xu+AgFitCEKdjYXSDd8/d/K9I/lLljZcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719450454; c=relaxed/simple;
	bh=8yTQQhhIyr7blj3BH4MHpSrLEROLzVaTijozH/pQk2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GzEJ3yJxcj3lANhzz93u2iBP5mLJ1F0GFQ52JC9rERWBdoWST4/bRB8unX3nMotnzJwEecDN6YhzXbRZGzQ1T9Y6mzuUrHAppuEsHDcx7puidqhX+xXB9Xdq5WpKam+janoLCTDiToj4y6MBPzS9xSwyIdadZasVORzWylnPHhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKfJLRlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKfJLRlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259C6C116B1;
	Thu, 27 Jun 2024 01:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719450454;
	bh=8yTQQhhIyr7blj3BH4MHpSrLEROLzVaTijozH/pQk2A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SKfJLRlWXhEN9AbtdShRxelCjOTQcgeJNkrB3uAej4QKJDev4e32Zeb6Jxko1f4a4
	 wDkTOXSDZFjjpKD6kw1dZ5TeiarIaL/xgzDFQinw+xQJuVEmYKmItyHt7L+mSdmyKo
	 PpZUavZDQjjYGZNTvFBVrXgBh25mnjzThm4EgvV1WGPr+xSkgAoscy+baefXSZFUSc
	 sxUl5RnOi7Qsb8S+qISnuv1dH9WnvEgCVmareW70KxpNO8sjjfAQm1HurcNqbJulQl
	 hMo1TqnexikYJqKj0JluuMiEliLtoXcz2k7Vz10iiFi8QT6ohEYefaFBFdxncyz4pe
	 kRiA/L12XWDMw==
Message-ID: <b4601197-a273-4f65-8e1a-27a5dfa6d688@kernel.org>
Date: Thu, 27 Jun 2024 10:07:32 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] ata,scsi: Remove useless wrappers
 ata_sas_tport_{add,delete}()
To: Niklas Cassel <cassel@kernel.org>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-19-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240626180031.4050226-19-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 03:00, Niklas Cassel wrote:
> Remove useless wrappers ata_sas_tport_add() and ata_sas_tport_delete().

I am not a big fan of this patch. I would prefer to keep everything in
libata-transport local to libata and have the exports done for what libsas needs
using the wrappers, even if some of them are very trivial...

That also allows keeping the naming consistent with the ata_sas_ prefix for
everything that libsas uses from libata.

John ? Thoughts ?

> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>  drivers/ata/libata-sata.c          | 12 ------------
>  drivers/ata/libata-transport.c     |  2 ++
>  drivers/ata/libata-transport.h     |  3 ---
>  drivers/scsi/libsas/sas_ata.c      |  2 +-
>  drivers/scsi/libsas/sas_discover.c |  2 +-
>  include/linux/libata.h             |  4 ++--
>  6 files changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 9e047bf912b1..e7991595bfe5 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1241,18 +1241,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
>  }
>  EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
>  
> -int ata_sas_tport_add(struct device *parent, struct ata_port *ap)
> -{
> -	return ata_tport_add(parent, ap);
> -}
> -EXPORT_SYMBOL_GPL(ata_sas_tport_add);
> -
> -void ata_sas_tport_delete(struct ata_port *ap)
> -{
> -	ata_tport_delete(ap);
> -}
> -EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
> -
>  /**
>   *	ata_sas_device_configure - Default device_configure routine for libata
>   *				   devices
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
> index 3e49a877500e..d24f201c0ab2 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -265,6 +265,7 @@ void ata_tport_delete(struct ata_port *ap)
>  	transport_destroy_device(dev);
>  	put_device(dev);
>  }
> +EXPORT_SYMBOL_GPL(ata_tport_delete);
>  
>  static const struct device_type ata_port_sas_type = {
>  	.name = ATA_PORT_TYPE_NAME,
> @@ -329,6 +330,7 @@ int ata_tport_add(struct device *parent,
>  	put_device(dev);
>  	return error;
>  }
> +EXPORT_SYMBOL_GPL(ata_tport_add);
>  
>  /**
>   *     ata_port_classify - determine device type based on ATA-spec signature
> diff --git a/drivers/ata/libata-transport.h b/drivers/ata/libata-transport.h
> index 08a57fb9dc61..50cd2cbe8eea 100644
> --- a/drivers/ata/libata-transport.h
> +++ b/drivers/ata/libata-transport.h
> @@ -8,9 +8,6 @@ extern struct scsi_transport_template *ata_scsi_transport_template;
>  int ata_tlink_add(struct ata_link *link);
>  void ata_tlink_delete(struct ata_link *link);
>  
> -int ata_tport_add(struct device *parent, struct ata_port *ap);
> -void ata_tport_delete(struct ata_port *ap);
> -
>  struct scsi_transport_template *ata_attach_transport(void);
>  void ata_release_transport(struct scsi_transport_template *t);
>  
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 4c69fc63c119..1c2400c96ebd 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -608,7 +608,7 @@ int sas_ata_init(struct domain_device *found_dev)
>  	ap->cbl = ATA_CBL_SATA;
>  	ap->scsi_host = shost;
>  
> -	rc = ata_sas_tport_add(ata_host->dev, ap);
> +	rc = ata_tport_add(ata_host->dev, ap);
>  	if (rc)
>  		goto destroy_port;
>  
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 8fb7c41c0962..6e01ddec10c9 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -300,7 +300,7 @@ void sas_free_device(struct kref *kref)
>  		kfree(dev->ex_dev.ex_phy);
>  
>  	if (dev_is_sata(dev) && dev->sata_dev.ap) {
> -		ata_sas_tport_delete(dev->sata_dev.ap);
> +		ata_tport_delete(dev->sata_dev.ap);
>  		kfree(dev->sata_dev.ap);
>  		ata_host_put(dev->sata_dev.ata_host);
>  		dev->sata_dev.ata_host = NULL;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 13fb41d25da6..581e166615fa 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1249,8 +1249,8 @@ extern int ata_slave_link_init(struct ata_port *ap);
>  extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
>  					   struct ata_port_info *, struct Scsi_Host *);
>  extern void ata_port_probe(struct ata_port *ap);
> -extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
> -extern void ata_sas_tport_delete(struct ata_port *ap);
> +extern int ata_tport_add(struct device *parent, struct ata_port *ap);
> +extern void ata_tport_delete(struct ata_port *ap);
>  int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limits *lim,
>  		struct ata_port *ap);
>  extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap);

-- 
Damien Le Moal
Western Digital Research

