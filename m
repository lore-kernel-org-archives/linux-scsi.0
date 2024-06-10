Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D462CCB7
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 07:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718006160; cv=none; b=HgxJ+ECQTN7FLOLXMwwuUw7sE+izmPJRxNZ/fb/7nzF5TWP5fVZIdbM+3lPxQaEvJUp77eMlZ1cLezumPOCRqDMmwDR0VVVrQ5opmJyGW1m2VIYy8Z7wMnJsb8SFRgUm/rkuTSHNFv0qfIIrLQZPb11cejXbVCSI6wqLTatckAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718006160; c=relaxed/simple;
	bh=tM1P1S08wwHGybp3OS+FxCNppQisLOqF1M/njCAsJ4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p24vrbNlQdiu7ge8P2OQSf6GH/Ecm1UaVGDKF7vYF6RcKnjaiSlXbCrUqon9QZ1wk2SVhMDEbzla6WNmstDqH0/Fa3oS2ktdNJL9/ogJAOtTfSy/YMhVqVJ0iW+dB/CDlE15u0rxM9rN6b/xb1MutZ3IEHseKJ102dcDRZEsknQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evG+rv5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evG+rv5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60198C2BBFC;
	Mon, 10 Jun 2024 07:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718006159;
	bh=tM1P1S08wwHGybp3OS+FxCNppQisLOqF1M/njCAsJ4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=evG+rv5JmPTFszlA8OyiIdSYI36MLsUBDnXEowQuOzDfbNJtQhWL1YrDOOTB34Tj+
	 a5qkZ3rDzKiMz1p+0uFbNYgWECCtMA7jU7a6vekQet3+8/oqr8fWtoiqs2MRn54RLL
	 U36zL4FEW9yMZ7E+1K1iwtVQrleIdGzUNtFcCurA3W69VEo/Mo+gVX1raWWcaUxI6d
	 EEMuqQQJGxqrIvJ/dZsNizlwvBxiJXDDs1Px96ng4vBOMZwycBJXF40C8rM/LEQdu9
	 iSAHBNsaqPABR5ASr3FL5UZ7G/Tq8r/JMdKIEIwV/nmcTuJVvxTld2Hh4zrwTGMM3p
	 TF163h2QLDMOw==
Date: Mon, 10 Jun 2024 09:55:55 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v2] scsi: mpi3mr: Fix ATA NCQ priority support
Message-ID: <Zmaxi6LJXIFiNXxd@ryzen.lan>
References: <20240607012404.111448-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607012404.111448-1-dlemoal@kernel.org>

On Fri, Jun 07, 2024 at 10:24:04AM +0900, Damien Le Moal wrote:
> The function mpi3mr_qcmd() of the mpi3mr driver is able to indicate to
> the HBA if a read or write command directed at an ATA device should be
> translated to an NCQ read/write command with the high prioiryt bit set
> when the request uses the RT priority class and the user has enabled NCQ
> priority through sysfs.
> 
> However, unlike the mpt3sas driver, the mpi3mr driver does not define
> the sas_ncq_prio_supported and sas_ncq_prio_enable sysfs attributes, so
> the ncq_prio_enable field of struct mpi3mr_sdev_priv_data is never
> actually set and NCQ Priority cannot ever be used.
> 
> Fix this by defining these missing atributes to allow a user to check if
> an ATA device supports NCQ priority and to enable/disable the use of NCQ
> priority. To do this, lift the function scsih_ncq_prio_supp() out of the
> mpt3sas driver and make it the generic scsi sas transport function
> sas_ata_ncq_prio_supported(). Nothing in that function is hardware
> specific, so this function can be used in both the mpt3sas driver and
> the mpi3mr driver.
> 
> Reported-by: Scott McCoy <scott.mccoy@wdc.com>
> Fixes: 023ab2a9b4ed ("scsi: mpi3mr: Add support for queue command processing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
> 
> Changes from v1:
>  - Moved scsih_ncq_prio_supp() to be a function in scsi_transport_sas.c
>    and renamed that function to sas_ata_ncq_prio_supported().
> 
>  drivers/scsi/mpi3mr/mpi3mr_app.c     | 62 ++++++++++++++++++++++++++++
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 --
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  4 +-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 23 -----------
>  drivers/scsi/scsi_transport_sas.c    | 22 ++++++++++
>  include/scsi/scsi_transport_sas.h    |  2 +
>  6 files changed, 88 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> index 1638109a68a0..cd261b48eb46 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2163,10 +2163,72 @@ persistent_id_show(struct device *dev, struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RO(persistent_id);
>  
> +/**
> + * sas_ncq_prio_supported_show - Indicate if device supports NCQ priority
> + * @dev: pointer to embedded device
> + * @attr: sas_ncq_prio_supported attribute descriptor
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' sdev attribute, only works with SATA devices
> + */
> +static ssize_t
> +sas_ncq_prio_supported_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +
> +	return sysfs_emit(buf, "%d\n", sas_ata_ncq_prio_supported(sdev));
> +}
> +static DEVICE_ATTR_RO(sas_ncq_prio_supported);
> +
> +/**
> + * sas_ncq_prio_enable_show - send prioritized io commands to device
> + * @dev: pointer to embedded device
> + * @attr: sas_ncq_prio_enable attribute descriptor
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read/write' sdev attribute, only works with SATA devices
> + */
> +static ssize_t
> +sas_ncq_prio_enable_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data =  sdev->hostdata;
> +
> +	if (!sdev_priv_data)
> +		return 0;
> +
> +	return sysfs_emit(buf, "%d\n", sdev_priv_data->ncq_prio_enable);
> +}
> +
> +static ssize_t
> +sas_ncq_prio_enable_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data =  sdev->hostdata;
> +	bool ncq_prio_enable = 0;
> +
> +	if (kstrtobool(buf, &ncq_prio_enable))
> +		return -EINVAL;
> +
> +	if (!sas_ata_ncq_prio_supported(sdev))
> +		return -EINVAL;
> +
> +	sdev_priv_data->ncq_prio_enable = ncq_prio_enable;
> +
> +	return strlen(buf);
> +}
> +static DEVICE_ATTR_RW(sas_ncq_prio_enable);
> +
>  static struct attribute *mpi3mr_dev_attrs[] = {
>  	&dev_attr_sas_address.attr,
>  	&dev_attr_device_handle.attr,
>  	&dev_attr_persistent_id.attr,
> +	&dev_attr_sas_ncq_prio_supported.attr,
> +	&dev_attr_sas_ncq_prio_enable.attr,
>  	NULL,
>  };
>  
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index bf100a4ebfc3..fe1e96fda284 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -2048,9 +2048,6 @@ void
>  mpt3sas_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
>  	struct _raid_device *raid_device, Mpi25SCSIIORequest_t *mpi_request);
>  
> -/* NCQ Prio Handling Check */
> -bool scsih_ncq_prio_supp(struct scsi_device *sdev);
> -
>  void mpt3sas_setup_debugfs(struct MPT3SAS_ADAPTER *ioc);
>  void mpt3sas_destroy_debugfs(struct MPT3SAS_ADAPTER *ioc);
>  void mpt3sas_init_debugfs(void);
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index 1c9fd26195b8..87784c96249a 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -4088,7 +4088,7 @@ sas_ncq_prio_supported_show(struct device *dev,
>  {
>  	struct scsi_device *sdev = to_scsi_device(dev);
>  
> -	return sysfs_emit(buf, "%d\n", scsih_ncq_prio_supp(sdev));
> +	return sysfs_emit(buf, "%d\n", sas_ata_ncq_prio_supported(sdev));
>  }
>  static DEVICE_ATTR_RO(sas_ncq_prio_supported);
>  
> @@ -4123,7 +4123,7 @@ sas_ncq_prio_enable_store(struct device *dev,
>  	if (kstrtobool(buf, &ncq_prio_enable))
>  		return -EINVAL;
>  
> -	if (!scsih_ncq_prio_supp(sdev))
> +	if (!sas_ata_ncq_prio_supported(sdev))
>  		return -EINVAL;
>  
>  	sas_device_priv_data->ncq_prio_enable = ncq_prio_enable;
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 89ef43a5ef86..3a1ed6a4f370 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -12571,29 +12571,6 @@ scsih_pci_mmio_enabled(struct pci_dev *pdev)
>  	return PCI_ERS_RESULT_RECOVERED;
>  }
>  
> -/**
> - * scsih_ncq_prio_supp - Check for NCQ command priority support
> - * @sdev: scsi device struct
> - *
> - * This is called when a user indicates they would like to enable
> - * ncq command priorities. This works only on SATA devices.
> - */
> -bool scsih_ncq_prio_supp(struct scsi_device *sdev)
> -{
> -	struct scsi_vpd *vpd;
> -	bool ncq_prio_supp = false;
> -
> -	rcu_read_lock();
> -	vpd = rcu_dereference(sdev->vpd_pg89);
> -	if (!vpd || vpd->len < 214)
> -		goto out;
> -
> -	ncq_prio_supp = (vpd->data[213] >> 4) & 1;
> -out:
> -	rcu_read_unlock();
> -
> -	return ncq_prio_supp;
> -}
>  /*
>   * The pci device ids are defined in mpi/mpi2_cnfg.h.
>   */
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 424a89513814..17a72fcab210 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -416,6 +416,28 @@ unsigned int sas_is_tlr_enabled(struct scsi_device *sdev)
>  }
>  EXPORT_SYMBOL_GPL(sas_is_tlr_enabled);
>  
> +/**
> + * sas_ata_ncq_prio_supported - Check for NCQ command priority support
> + * @sdev: SCSI device
> + *
> + * Check if an ATA device supports NCQ priority. For non-ATA devices,
> + * this always return false.

Nit:
"this will always return false"
or
"this always returns false"
or perhaps even better:
"the vpd page 89 is not implemented, so this function will return false"


With the nit fixed:
Reviewed-by: Niklas Cassel <cassel@kernel.org>
