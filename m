Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CBD13FD8A
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 09:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717666283; cv=none; b=OvwOvcV/qfcr2fwtgtCrF8p6durk7cHQz9oIXkMMfj++qgqHlRgCyIXeCB991JeFqYWXOTNWvWWJikw5Cx7ezjoW5kfxhG/7uifEsKZ62ghB1kj6rCCoAqeiF+v5aWnpBcNYlI/Z26yOxaK1sUQBBaHWX8RqgPMzD0qFFWNQ7h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717666283; c=relaxed/simple;
	bh=W7r8KdFrhP7mEzSZRrGfmoVUnxE74HNPyd9VnYEvwvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YjpP89IZEP8qN57ADGI0rUtXe+askSZqBAoRKpphuBhZ7KZLr7xnvmHTjlRxSGpriPpcdZDCPqcNtduJtg8+v5KjGeF0iHCbzaaLPq8p8cydQyNNajQ4hdW8EzlDfLoye4ORV/pMR4I1N1SLwL/nOh7oYrP0eeIxFFbpZKnrYTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EBB3jeI8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EBB3jeI8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1kuoks9zLbjLaFUk1cEoVg0OuBWGpj4Rk4bsiDCnds0=; b=EBB3jeI8LgJ5zv/5iTxoGdZYGl
	OB0uwG/jWCEcw2UIep2IZH4Qz9S5td/SKGcLxsP/FLh6PIpYK3ZyG+UxMrDeufN4rgfR9/zCqqmxE
	sWGhvTz5SyhJjr4MEQn5ubAyneWgl4b61v8EM/9uFaKtGUdJzfY7ZRvC1L/U4sszkQ144bsyPWtz7
	3oEbo2oTsZCF0ADFsQ2e7etWw7Q9JyjiLEL+PbMGGYmN5iXI2plp+0IFhRp4rXHR6b/VCXT+qEBVJ
	QBZ/FQKbLYTEsfKmRDoqYn4abGFy5OvPOvP1fd+j87A99G9a0FYoT9+yBiBMNYh+BoIVp0kWUkz/1
	F1ZgBUTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sF9Sq-00000009CNU-3Dm4;
	Thu, 06 Jun 2024 09:31:20 +0000
Date: Thu, 6 Jun 2024 02:31:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH] scsi: mpi3mr: Fix SATA NCQ priority support
Message-ID: <ZmGB6I1OQ5TZOHAn@infradead.org>
References: <20240606054749.55708-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606054749.55708-1-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 06, 2024 at 02:47:49PM +0900, Damien Le Moal wrote:
> The function mpi3mr_qcmd() of the mpi3mr driver is able to indicate to
> the HBA if a read or write command directed at a SATA device should be
> executed using NCQ high priority, if the request uses the RT priority
> class and the user has enabled NCQ priority through sysfs.
> 
> However, unlike the mpt3sas driver, the mpi3mr driver does not define
> the sas_ncq_prio_supported and sas_ncq_prio_enable sysfs attributes, so
> the ncq_prio_enable field of struct mpi3mr_sdev_priv_data is never
> actually set and NCQ Priority cannot ever be used.
> 
> Fix this by defining these missing atributes to allow a user to check if
> a device supports NCQ priority and to enable/disable the use of NCQ
> priority. To do this, lift the function scsih_ncq_prio_supp() out of the
> mpt3sas driver and make it the generic scsi device function
> scsi_ncq_prio_supported(). Nothing in that function is hardware
> specific, so this function can be used for both the mpt3sas driver and
> the mpi3mr driver.

Shouldn't this move into the SAS transport class instead then?

> +/**
> + * scsi_ncq_prio_supported - Check for NCQ command priority support
> + * @sdev: SCSI device
> + *
> + * Check if a (SATA) device supports NCQ priority. For non-SATA devices,
> + * this always return false.
> + */
> +bool scsi_ncq_prio_supported(struct scsi_device *sdev)
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
> +EXPORT_SYMBOL_GPL(scsi_ncq_prio_supported);

This also feels kinda out of place in the core SCSI code and more in
scope for the SAS transport class, even if the other code can't
move there for whatever reason.

