Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AEC3C7DEB;
	Thu,  3 Sep 2026 22:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788473580; cv=none; b=abU00IZXqs2YHfNoA6SPqzxsWR/H6v0DGeKZZbN9cCX/Lbnvlnv2cGUVjBnnYgFYqoS8P98Yyk6IqwOebxprqrpi9JDaTnfY+Os8pe541SLFmWfo29fOR3ibSlfFfp99yt9mOG9XhB4AaSH0+mLbhncbJwdnHHQMNuyZpxHAnbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788473580; c=relaxed/simple;
	bh=QdnVSXQN/uE7XNmn3QO8N6Xt7Xx9/gkLhZ32lfuhIMc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=F+T2mzJqm1P+Y5rBz5zWiHsjPRbhE47wG0kjrw6WqFMfBA0Si//BlLHOD8POKn0wqPs9lTksTcZepiGHPQfDtjtxWvwwPCJ0+O2zJF28V0WcCcDrsg7IDuNZfWa00gToXsoROwdPPQ1Z9qmw7MArAAoxIspP8zvQH59OhPAHXtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJbE3cMi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJbE3cMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101961F000E9;
	Thu,  3 Sep 2026 22:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788473579;
	bh=r4JP7hdJDIoyNzBn71IHHKs1H6EQq5IVkqb5Ov73g6U=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=GJbE3cMiwk2m+HTjQDkXjeKFS1E9AOG2SjJmPZTC26+oeO6fguOgmcx6t05wmLZai
	 NaxyHbQlDgCP80WxyJ9W65Jt/LhlnDfUBGEHDS7W+YiwpVt9cVe77eoHumW43S1OJR
	 dToq0t3VuQllguK2eIVHdcJgALU73wI7aFzKvPcWl3poD4Yq3PLlStZC2CrLXiXoB9
	 QTTVtYv9I3ih4/W5mWvF4X0QgWYNpFBcBSQDZdc65Di4GUvzN4ZbUh0l7ItHnSKqxX
	 Bn+UH+0dODxrLrg/IUaiuzbpf4GNesb0sIV1mKjlga06zFtkfbW79CJ1rCYvqo1ytn
	 7RUUoCcX/ayMg==
Date: Thu, 3 Sep 2026 17:12:58 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Jeffery <djeffery@redhat.com>
Cc: driver-core@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
	Tarun Sahu <tarunsahu@google.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Laurence Oberman <loberman@redhat.com>, kexec@lists.infradead.org,
	Ewan Milne <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Lombardi, Maurizio" <mlombard@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	Jeremy Allison <jallison@ciq.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Pasha Tatashin <tatashin@google.com>
Subject: Re: [PATCH 7/9] PCI: Link a virtual function to its physical function
Message-ID: <20260903221258.GA2263962@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902170734.95504-8-djeffery@redhat.com>

On Wed, Sep 02, 2026 at 01:07:32PM -0400, David Jeffery wrote:
> With a PCI virtual function having the same bus for its parent
> as the physical function it is associated with, there is no
> explicit dependency between the two in the device tree. With
> async shutdown, this can result in the PF being shutdown before the
> VF has an opportunity to shutdown.
> 
> Link the VF as a consumer of the PF to note its dependency and
> ensure clean shutdown ordering.
> 
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/iov.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 9d408fb8ac25..9b74211c6ab4 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -382,14 +382,20 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
>  	}
>  
>  	pci_device_add(virtfn, virtfn->bus);
> +	if (!device_link_add(&virtfn->dev, &dev->dev, DL_FLAG_STATELESS)) {
> +		rc = -ENOMEM;
> +		goto failed1;
> +	}
> +
>  	rc = pci_iov_sysfs_link(dev, virtfn, id);
>  	if (rc)
> -		goto failed1;
> +		goto unlink;
>  
>  	pci_bus_add_device(virtfn);
>  
>  	return 0;
> -
> +unlink:
> +	device_link_remove(&virtfn->dev, &dev->dev);
>  failed1:
>  	pci_stop_and_remove_bus_device(virtfn);
>  	pci_dev_put(dev);
> @@ -421,6 +427,7 @@ void pci_iov_remove_virtfn(struct pci_dev *dev, int id)
>  	if (virtfn->dev.kobj.sd)
>  		sysfs_remove_link(&virtfn->dev.kobj, "physfn");
>  
> +	device_link_remove(&virtfn->dev, &dev->dev);
>  	pci_stop_and_remove_bus_device(virtfn);
>  	virtfn_remove_bus(dev->bus, virtfn->bus);
>  
> -- 
> 2.55.0
> 
