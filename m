Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E93473C80;
	Fri, 24 Jul 2026 22:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784932239; cv=none; b=Dd6Lt5K/sUukAzrbFbsoTvkPrcZshwwKWgEGoqITeDzR00NYv89IeEdlTBCim9n1yPSTQopTc22hfdkXcq0YsMRKIxZYZoU/iQYFWWMFTJnvROtvgM8WK55Wkt3wA0zSekrbzJU6HfZgXmkT3Ktr7Wu6JYFdksARx/2YQrMT0fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784932239; c=relaxed/simple;
	bh=Gmq7d7Jg9C0o7Jvo2rDo8fBZ5JsOa9IPQMlU3RrGn94=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=aHVY+p7FLIJgOk5W2+/OyFzkJ5k8706AHohV9lw/vJpHfME4e8zYjP07EX6my8KZfACUAeZBwtFD/7LamOsE6IuVsgoDG9VW3Qou5CGpajuJYnkFv92h8fr7TcKimd2CkM9GALU1PW5kvnfzeJCmepVLvxj6aeU3L1aEckHGZNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kg0rN4VN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kg0rN4VN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B40B1F00A3A;
	Fri, 24 Jul 2026 22:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784932236;
	bh=GS14DZQhW66q/6Q+X41QrQ1/gqGz9PBB64fXYqWc4+A=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=Kg0rN4VNZ6bV24H8SvNLXOhE+5jjor+DqTtJly6ByqD6Q0sM0vxfACb688tRlkE1q
	 wjyKLglL9XwupGMR66ysdyTevHPvfSH+frGOISUTH4KavpyI0Lh/jPD+u7McPOXNmr
	 cvRkSvmFUY2KGqROQSWSPngkxP/UbcDEzyMHHCWxHuDvS+ofDdvv6uC3OFDhFoxSsi
	 mjfisqiO3UnipsNxl4hBMB2oOHn4243tNZpYLTGywhA86qUHF6rD9Jm97to+SU1ZwD
	 zP7U+v/AqkntG2svYeCMp6iaxn+Tz4/MeoQWDbi+YyqcX/0VzDERrTXU6cl4ybbR03
	 SnHpJDvqQGwGA==
Date: Fri, 24 Jul 2026 17:30:35 -0500
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
	dri-devel@lists.freedesktop.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v4 9/9] PCI: Fix UAF when probe runs concurrent to dyn ID
 removal
Message-ID: <20260724223035.GA1068309@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723-pci_id_fix-v4-9-3580726844e1@garyguo.net>

On Thu, Jul 23, 2026 at 11:00:48PM +0100, Gary Guo wrote:
> Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
> as remove_id_store() can free the node. Thus, make a copy in
> pci_match_device(). Also, clarify that the id parameter is only valid
> during probe.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/
> Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/pci-driver.c | 28 +++++++++++++++-------------
>  include/linux/pci.h      |  1 +
>  2 files changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index ab3bb756ce89..e16aa59dd7ac 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -180,6 +180,7 @@ static const struct pci_device_id pci_device_id_any = {
>   * pci_match_device - See if a device matches a driver's list of IDs
>   * @drv: the PCI driver to match against
>   * @dev: the PCI device structure to match against
> + * @id_copy: place to store copy of pci_device_id for dynamic ID
>   *
>   * Used by a driver to check whether a PCI device is in its list of
>   * supported devices or in the dynids list, which may have been augmented
> @@ -187,9 +188,9 @@ static const struct pci_device_id pci_device_id_any = {
>   * structure or %NULL if there is no match.
>   */
>  static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
> -						    struct pci_dev *dev)
> +						    struct pci_dev *dev,
> +						    struct pci_device_id *id_copy)
>  {
> -	struct pci_dynid *dynid;
>  	const struct pci_device_id *found_id = NULL;
>  	struct pci_device_id dev_id;
>  	int ret;
> @@ -201,17 +202,16 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>  
>  	dev_id = pci_id_from_device(dev);
>  	/* Look at the dynamic ids first, before the static ones */
> -	spin_lock(&drv->dynids.lock);
> -	list_for_each_entry(dynid, &drv->dynids.list, node) {
> -		if (pci_match_one_id(&dynid->id, &dev_id)) {
> -			found_id = &dynid->id;
> -			break;
> +	scoped_guard(spinlock, &drv->dynids.lock) {
> +		struct pci_dynid *dynid;
> +
> +		list_for_each_entry(dynid, &drv->dynids.list, node) {
> +			if (pci_match_one_id(&dynid->id, &dev_id)) {
> +				*id_copy = dynid->id;
> +				return id_copy;
> +			}
>  		}
>  	}
> -	spin_unlock(&drv->dynids.lock);
> -
> -	if (found_id)
> -		return found_id;
>  
>  	found_id = do_pci_match_id(drv->id_table, &dev_id, ret > 0);
>  	if (found_id)
> @@ -467,12 +467,13 @@ void pci_probe_flush_workqueue(void)
>  static int __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
>  {
>  	const struct pci_device_id *id;
> +	struct pci_device_id id_copy;
>  	int error = 0;
>  
>  	if (drv->probe) {
>  		error = -ENODEV;
>  
> -		id = pci_match_device(drv, pci_dev);
> +		id = pci_match_device(drv, pci_dev, &id_copy);
>  		if (id)
>  			error = pci_call_probe(drv, pci_dev, id);
>  	}
> @@ -1560,12 +1561,13 @@ static int pci_bus_match(struct device *dev, const struct device_driver *drv)
>  	struct pci_dev *pci_dev = to_pci_dev(dev);
>  	struct pci_driver *pci_drv;
>  	const struct pci_device_id *found_id;
> +	struct pci_device_id id_copy;
>  
>  	if (pci_dev_binding_disallowed(pci_dev))
>  		return 0;
>  
>  	pci_drv = (struct pci_driver *)to_pci_driver(drv);
> -	found_id = pci_match_device(pci_drv, pci_dev);
> +	found_id = pci_match_device(pci_drv, pci_dev, &id_copy);
>  	if (found_id)
>  		return 1;
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 64b308b6e61c..92c17c116de6 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -979,6 +979,7 @@ struct module;
>   *		function returns zero when the driver chooses to
>   *		take "ownership" of the device or an error code
>   *		(negative number) otherwise.
> + *		The pci_device_id parameter is only valid during probe.
>   *		The probe function always gets called from process
>   *		context, so it can sleep.
>   * @remove:	The remove() function gets called whenever a device
> 
> -- 
> 2.54.0
> 
