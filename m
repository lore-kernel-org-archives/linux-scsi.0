Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4330935DA41;
	Wed, 11 Mar 2026 23:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270325; cv=none; b=gNS4ZNYxAqFUMs80Fcnecgudq/Mvz/nXxc0WvC6SfRdhtjf/JTRy1XE8ob2eYVDsx/U0qeEMgh+XQ3diDuSNKx41owlBpDSwDxugEeJ4VTMs7xu2Tt0KWMOCDvywFizwPKo2LZagAJj1/Lp2VirYG8tgFqzt5hYRA9LZ4NoOts4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270325; c=relaxed/simple;
	bh=+Xdaz6TjXDeSBjicHgJcIcgm3xaVP2Q3x9OzMalMLmY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=W+qiMQ4pmH4CXNLLtXBxnLrYm8GWThwJqR9lcpoRD3HPx8BFrC/POglr/O2O6FFG3sRrDCJ4I5Dm6Wbj8mOdhiXjj4ZUPNPedgCa+Z4GaTK3GXCfEnLBtptFYuUqFOQ5LkuPlxxnpzyoqpLdyvredszcg1oGbTZSzXu/Y2TeWUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJkZVarq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJkZVarq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA8DC4CEF7;
	Wed, 11 Mar 2026 23:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773270324;
	bh=+Xdaz6TjXDeSBjicHgJcIcgm3xaVP2Q3x9OzMalMLmY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=ZJkZVarqszqrEo8rmY19514BXG3iosYQMDqVgMdmCS5YJAcJsLyAQg6VhsDnwEjF9
	 wx2npMbohs39Tjr6WBI+GjRVHWm8OWqELfcYICTx1P+PPxV/Or4WxrfGpFa+QNLfrz
	 EkIqePEt++V7d60VTxj91jAuj/HBoLYrkdBazzrakJiWN+i4gra4c0PZ43XE5qksml
	 Nfm3tu1YU9GrQ9gambB/Dxsxs/FLnoBA2vGH85y5CyqG2MnJiRECns41cOaIh8J7hp
	 T4Em9XjomPvcL3MxaNY6V20de2CjLyW6JhGG47/FZgSM2hkLc8TMrTXk4VDw6fe3UI
	 r9vW+DxgAcg3w==
Date: Wed, 11 Mar 2026 18:05:23 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Jeffery <djeffery@redhat.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Tarun Sahu <tarunsahu@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	=?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	Jordan Richards <jordanrichards@google.com>,
	Ewan Milne <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Lombardi, Maurizio" <mlombard@redhat.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 3/5] driver core: async device shutdown infrastructure
Message-ID: <20260311230523.GA1066455@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311171209.9205-3-djeffery@redhat.com>

On Wed, Mar 11, 2026 at 01:12:07PM -0400, David Jeffery wrote:
> Patterned after async suspend, allow devices to mark themselves as wanting
> to perform async shutdown. Devices using async shutdown wait only for their
> dependencies to shutdown before executing their shutdown routine.

I'm not an expert on dependencies.  Is it obvious to everybody else
how these dependencies are expressed?  What would I look at to verify
that, for example, PCI devices are dependencies of the PCI bridges
leading to them?  I suppose it's the same dependencies used for
suspend?

From wait_for_shutdown_dependencies() below, it looks like we'll wait
for each child of dev and then wait for each consumer of dev before
shutting down dev itself.

> Sync shutdown devices are shut down one at a time and will only wait for an
> async shutdown device if the async device is a dependency.

> @@ -132,6 +133,7 @@ struct device_private {
>  #ifdef CONFIG_RUST
>  	struct driver_type driver_type;
>  #endif
> +	struct completion complete;

I thought "complete" might be a little too generic, but I guess async
suspend uses "dev->power.completion" :)

> +static void wait_for_shutdown_dependencies(struct device *dev, bool async)
> +{
> +	struct device_link *link;
> +	int idx;
> +
> +	device_for_each_child(dev, &async, wait_for_device_shutdown);
> +
> +	idx = device_links_read_lock();
> +
> +	dev_for_each_link_to_consumer(link, dev)
> +		if (!device_link_flag_is_sync_state_only(link->flags))
> +			wait_for_device_shutdown(link->consumer, &async);
> +
> +	device_links_read_unlock(idx);
> +}

> @@ -4828,6 +4919,12 @@ void device_shutdown(void)
>  
>  	cpufreq_suspend();
>  
> +	/*
> +	 * Start async device threads where possible to maximize potential
> +	 * paralellism and minimize false dependency on unrelated sync devices

s/paralellism/parallelism/
