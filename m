Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1118641
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jun 2024 06:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718088516; cv=none; b=mMT+JBC1GLukanG2ObDj5bHPPx5KVDGGj9Lx4mqiADUUoMSXLcQAQjyHjRU8R4swxV2ZyY8zHSHguTmkqkWhSQl2aOvD/ReGX05iF92ukgPLJNXVCGtpOjNzhBxQeJOg8kMZNPCjdZjSBDR6hrgBhUXQQyZ7+x6lH7gzCxc44sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718088516; c=relaxed/simple;
	bh=TOSy7/GocUcQnwblfHcM2BZ+QTjwqXF2G0dXp/wwvfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJ+tEm2utD2LQFPM8ORsUqrt2H2ffxJBcOo/fpnWcNyfJtxTtVNX8ZCIYJk4suTp3DyR+nYtZ9Vg/KXla+qjMRTVoI/5nXyo2wLhPjvrfAGTeeWTiuANUfLatR6CbpwfXmc2jH1+DoDe+0FKWxmhS2hYqzpq/iyUPDtoeoQYwAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d51q9Yb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d51q9Yb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66711C2BD10;
	Tue, 11 Jun 2024 06:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718088515;
	bh=TOSy7/GocUcQnwblfHcM2BZ+QTjwqXF2G0dXp/wwvfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d51q9Yb2SHffDG4PqWdd2OxuJZB+Wr7bOPyvQYcVNbN1n2lha9tkWjvEY5FbbCeG+
	 ExcAMiY/KplWlHatrIoBRuKGrDHD6mk00REwe6u8WFnDz2cZ977WBTh1NDKEF2LLHK
	 u2Uz65st+1kwI3Tmbprz/XTYtu7YkjahnhqRYF6Bj6tA0h5kzti5KTyNlQ0/3QFAm8
	 7X6V+gASHfP0FsRvTvnK/N6j3eZEFBYuByfUU0xe4TigzVVhtUmNHcRXUokCnt9E7U
	 8JvGrTbLLEmU5W6saAbJeD1J2Zlq7G+6qv/JDUfK/MQWjcbKSf6AybFYmgpkCkU/GF
	 QScARUnAzF7jw==
Date: Tue, 11 Jun 2024 08:48:31 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v3] scsi: mpi3mr: Fix ATA NCQ priority support
Message-ID: <ZmfzP62ESthd-Uw9@ryzen.lan>
References: <20240610091035.250399-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610091035.250399-1-dlemoal@kernel.org>

On Mon, Jun 10, 2024 at 06:10:35PM +0900, Damien Le Moal wrote:
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
> Reviewed-by: Niklas Cassel <cassel@kernel.org>
> ---

(snip)

> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -416,6 +416,29 @@ unsigned int sas_is_tlr_enabled(struct scsi_device *sdev)
>  }
>  EXPORT_SYMBOL_GPL(sas_is_tlr_enabled);
>  
> +/**
> + * sas_ata_ncq_prio_supported - Check for ATA NCQ command priority support
> + * @sdev: SCSI device
> + *
> + * Check if an ATA device supports NCQ priority using VPD page 89h (ATA
> + * Information). Since this VPD page is implemented only for ATA devices,
> + * this function always returns false for SCSI devices."

The quote char (") at the end of the sentence looks lonely and out of place :)


> + */
> +bool sas_ata_ncq_prio_supported(struct scsi_device *sdev)
> +{
> +	struct scsi_vpd *vpd;
> +	bool ncq_prio_supported = false;
> +
> +	rcu_read_lock();
> +	vpd = rcu_dereference(sdev->vpd_pg89);
> +	if (vpd && vpd->len >= 214)
> +		ncq_prio_supported = (vpd->data[213] >> 4) & 1;
> +	rcu_read_unlock();
> +
> +	return ncq_prio_supported;
> +}
> +EXPORT_SYMBOL_GPL(sas_ata_ncq_prio_supported);
> +
>  /*
>   * SAS Phy attributes
>   */
