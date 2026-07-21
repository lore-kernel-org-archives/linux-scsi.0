Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE45736DA1D;
	Tue, 21 Jul 2026 22:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673259; cv=none; b=Zl0XgaKFSFH/c9satdNBlUvGIWc+P4bnVcBsuGmT3Aohh33n+7Ep6bc6skQQ4KGOMUjmCf48d/kcb2QGVj76wfegoU9mgWLOAaBdrI82HMR6RAAt67FZJEeWT5lXv13QfVy6m43PWCIW2p7mp4lFJ/VAQKLdUxFLw3LjKeSOhPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673259; c=relaxed/simple;
	bh=RL1+0W1/B+tR2MDPhC+qlvNj68/fW3XHVt2y04aHbpI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=GVawOxlw1LQVA4H2BaZy0GxeEQdiZC4tkVXN4SXiZFXerTgp4GOTRfgLmgmMq2MMC2kX3PKnksngltflL9yokOhtBn3uTrwdZbP5D1fwMI7T2SqPgQ/bPHe4Vv13BrFoOqMjYeONlrggiTzRIe2e25ITJSDdb4k0AziMu7rnpoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKMuPxBL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKMuPxBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B4C1F00A3A;
	Tue, 21 Jul 2026 22:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784673257;
	bh=lAjZyOjKZNuaCJGmQ2f5ZGdqL19zt46PrmfNWeD1Muc=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=AKMuPxBLw8TK507+1jlj9vLGif/Rw9+wWS+JV7uDCkhQM4qjOg9XhVcSEpmTSIrfH
	 tsd1YVbtCtsu61NyAFhMBdf44pVj5sDpKAVpjAHCCo2nLBsz5sbKQTFhS6nXDYzRRb
	 ujGppqGQcFBHWYAmEFRs1GTUjuABOW9VDUvlPuSiPKFgdktXc8pPtYb7lzAYjYmmHG
	 KKnSKCARsQnHHC2t29PuAoR3ucGPbtLP8sFYm7x48PKygEUi0syUUXvkte0shdgLam
	 JtuLCjBABLE1+HQxw26xoHb1m4KqGR0P1r0dxxuhV0WS1wgkiMpN1dr4wVje2iJyX9
	 s9Kx446/MwNwQ==
Date: Tue, 21 Jul 2026 17:34:16 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Gary Guo <gary@garyguo.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Zhenzhong Duan <zhenzhong.duan@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	GOTO Masanori <gotom@debian.or.jp>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vaibhav Gupta <vaibhavgupta40@gmail.com>,
	Jens Taprogge <jens.taprogge@taprogge.org>,
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	industrypack-devel@lists.sourceforge.net, netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v3 8/9] pci: fix dyn_id add TOCTOU
Message-ID: <20260721223416.GA682871@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706-pci_id_fix-v3-8-2d48fc025acc@garyguo.net>

On Mon, Jul 06, 2026 at 03:11:20PM +0100, Gary Guo wrote:
> Currently there is a TOCTOU issue in new_id_store as the dyn ID insertion
> in pci_add_dynid and the pci_match_device are in separate critical
> sections.
> 
> Fix this by moving the existing ID check to inside pci_add_dynid and only
> check against the static ID table outside the critical section.
> 
> Fixes: 3853f9123c18 ("PCI: Avoid duplicate IDs in driver dynamic IDs list")
> Signed-off-by: Gary Guo <gary@garyguo.net>
> ---
>  drivers/pci/pci-driver.c | 139 ++++++++++++++++++++++++-----------------------
>  1 file changed, 71 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 0507cb801310..2e80ae150ff4 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -29,6 +29,47 @@ struct pci_dynid {
>  	struct pci_device_id id;
>  };
>  
> +/**
> + * do_pci_add_dynid - add a new PCI device ID to this driver and re-probe devices

Wrap comments and code to fit in 80 columns like the rest of the file.

> + * @drv: target pci driver
> + * @id: ID to be added
> + * @check_dup: whether to check if matching ID is already present
> + *
> + * Adds a new dynamic pci device ID to this driver and causes the
> + * driver to probe for all devices again.  @drv must have been
> + * registered prior to calling this function.

s/Adds/Add/
s/pci/PCI/

Wrap to fill 78 columns or so.

> + *
> + * CONTEXT:
> + * Does GFP_KERNEL allocation.
> + *
> + * RETURNS:

s/RETURNS:/Return:/ to match others you're touching

> + * 0 on success, -errno on failure.
> + */
> +static int do_pci_add_dynid(struct pci_driver *drv, const struct pci_device_id *id, bool check_dup)
> +{
> +	struct pci_dynid *dynid, *existing_dynid;
> +
> +	dynid = kzalloc_obj(*dynid);
> +	if (!dynid)
> +		return -ENOMEM;
> +
> +	dynid->id = *id;
> +
> +	scoped_guard(spinlock, &drv->dynids.lock) {
> +		if (check_dup) {
> +			list_for_each_entry(existing_dynid, &drv->dynids.list, node) {
> +				if (pci_match_one_id(&existing_dynid->id, id)) {
> +					kfree(dynid);
> +					return -EEXIST;
> +				}
> +			}
> +		}
> +		list_add_tail(&dynid->node, &drv->dynids.list);
> +	}
> +
> +	return driver_attach(&drv->driver);
> +}
> +
>  /**
>   * pci_add_dynid - add a new PCI device ID to this driver and re-probe devices
>   * @drv: target pci driver
> @@ -56,25 +97,17 @@ int pci_add_dynid(struct pci_driver *drv,
>  		  unsigned int class, unsigned int class_mask,
>  		  unsigned long driver_data)
>  {
> -	struct pci_dynid *dynid;
> +	struct pci_device_id id = {
> +		.vendor = vendor,
> +		.device = device,
> +		.subvendor = subvendor,
> +		.subdevice = subdevice,
> +		.class = class,
> +		.class_mask = class_mask,
> +		.driver_data = driver_data,
> +	};
>  
> -	dynid = kzalloc_obj(*dynid);
> -	if (!dynid)
> -		return -ENOMEM;
> -
> -	dynid->id.vendor = vendor;
> -	dynid->id.device = device;
> -	dynid->id.subvendor = subvendor;
> -	dynid->id.subdevice = subdevice;
> -	dynid->id.class = class;
> -	dynid->id.class_mask = class_mask;
> -	dynid->id.driver_data = driver_data;
> -
> -	spin_lock(&drv->dynids.lock);
> -	list_add_tail(&dynid->node, &drv->dynids.list);
> -	spin_unlock(&drv->dynids.lock);
> -
> -	return driver_attach(&drv->driver);
> +	return do_pci_add_dynid(drv, &id, false);
>  }
>  EXPORT_SYMBOL_GPL(pci_add_dynid);
>  
> @@ -94,16 +127,19 @@ static void pci_free_dynids(struct pci_driver *drv)
>   * do_pci_match_id - See if a PCI ID matches a given pci_id table
>   * @ids: array of PCI device ID structures to search in
>   * @dev_id: the actual PCI device ID structure to match against.
> + * @include_override_only: also match against device ID entries marked as override only.
>   *
>   * Returns the matching pci_device_id structure or
>   * %NULL if there is no match.
>   */
>  static const struct pci_device_id *do_pci_match_id(const struct pci_device_id *ids,
> -						   const struct pci_device_id *dev_id)
> +						   const struct pci_device_id *dev_id,
> +						   bool include_override_only)
>  {
>  	if (ids) {
>  		while (ids->vendor || ids->subvendor || ids->class_mask) {
> -			if (pci_match_one_id(ids, dev_id))
> +			if ((!ids->override_only || include_override_only) &&
> +			    pci_match_one_id(ids, dev_id))
>  				return ids;
>  			ids++;
>  		}
> @@ -128,7 +164,7 @@ const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
>  {
>  	struct pci_device_id dev_id = pci_id_from_device(dev);
>  
> -	return do_pci_match_id(ids, &dev_id);
> +	return do_pci_match_id(ids, &dev_id, true);
>  }
>  EXPORT_SYMBOL(pci_match_id);
>  
> @@ -153,7 +189,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>  						    struct pci_dev *dev)
>  {
>  	struct pci_dynid *dynid;
> -	const struct pci_device_id *found_id = NULL, *ids;
> +	const struct pci_device_id *found_id = NULL;
>  	struct pci_device_id dev_id;
>  	int ret;
>  
> @@ -176,20 +212,9 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>  	if (found_id)
>  		return found_id;
>  
> -	for (ids = drv->id_table; (found_id = do_pci_match_id(ids, &dev_id));
> -	     ids = found_id + 1) {
> -		/*
> -		 * The match table is split based on driver_override.
> -		 * In case override_only was set, enforce driver_override
> -		 * matching.
> -		 */
> -		if (found_id->override_only) {
> -			if (ret > 0)
> -				return found_id;
> -		} else {
> -			return found_id;
> -		}
> -	}
> +	found_id = do_pci_match_id(drv->id_table, &dev_id, ret > 0);
> +	if (found_id)
> +		return found_id;
>  
>  	/* driver_override will always match, send a dummy id */
>  	if (ret > 0)
> @@ -197,11 +222,6 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>  	return NULL;
>  }
>  
> -static void _pci_free_device(struct device *dev)
> -{
> -	kfree(to_pci_dev(dev));
> -}
> -
>  /**
>   * new_id_store - sysfs frontend to pci_add_dynid()
>   * @driver: target device driver
> @@ -215,38 +235,22 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
>  {
>  	struct pci_driver *pdrv = to_pci_driver(driver);
>  	const struct pci_device_id *ids = pdrv->id_table;
> -	u32 vendor, device, subvendor = PCI_ANY_ID,
> -		subdevice = PCI_ANY_ID, class = 0, class_mask = 0;
> -	unsigned long driver_data = 0;
> +	struct pci_device_id id = {
> +		.subvendor = PCI_ANY_ID,
> +		.subdevice = PCI_ANY_ID
> +	};
>  	int fields;
>  	int retval = 0;
>  
>  	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
> -			&vendor, &device, &subvendor, &subdevice,
> -			&class, &class_mask, &driver_data);
> +			&id.vendor, &id.device, &id.subvendor, &id.subdevice,
> +			&id.class, &id.class_mask, &id.driver_data);
>  	if (fields < 2)
>  		return -EINVAL;
>  
>  	if (fields != 7) {
> -		struct pci_dev *pdev = kzalloc_obj(*pdev);
> -		if (!pdev)
> -			return -ENOMEM;
> -
> -		pdev->vendor = vendor;
> -		pdev->device = device;
> -		pdev->subsystem_vendor = subvendor;
> -		pdev->subsystem_device = subdevice;
> -		pdev->class = class;
> -		pdev->dev.release = _pci_free_device;
> -
> -		device_initialize(&pdev->dev);
> -		if (pci_match_device(pdrv, pdev))
> -			retval = -EEXIST;
> -
> -		put_device(&pdev->dev);
> -
> -		if (retval)
> -			return retval;
> +		if (do_pci_match_id(pdrv->id_table, &id, false))
> +			return -EEXIST;
>  	}
>  
>  	/* Only accept driver_data values that match an existing id_table
> @@ -254,7 +258,7 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
>  	if (ids) {
>  		retval = -EINVAL;
>  		while (ids->vendor || ids->subvendor || ids->class_mask) {
> -			if (driver_data == ids->driver_data) {
> +			if (id.driver_data == ids->driver_data) {
>  				retval = 0;
>  				break;
>  			}
> @@ -264,8 +268,7 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
>  			return retval;
>  	}
>  
> -	retval = pci_add_dynid(pdrv, vendor, device, subvendor, subdevice,
> -			       class, class_mask, driver_data);
> +	retval = do_pci_add_dynid(pdrv, &id, fields != 7);
>  	if (retval)
>  		return retval;
>  	return count;
> 
> -- 
> 2.54.0
> 
