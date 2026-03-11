Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A312B175A73;
	Wed, 11 Mar 2026 21:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773265050; cv=none; b=AvZCtez7Noi58kyFJHpyI2DqIwjDQ1YtMLqr7LLFpCgxMtNfo9b+nsKt/9k7kYYZy0L9Inpv05r+b55NVPDQp6Sffg8espNmLgYrnIfGIWzQ0oVqXJx2iaeYINgqr7a503sb6RKFw2uN8mhnQeNxpiSwPRMBrUzG6uc4SCWtYH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773265050; c=relaxed/simple;
	bh=ORQzYJ3u6URHD61tJ2SgGSNAbElHdRC0qUDT7hNEH6w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=f8MrGTJBz/Kalsl417RY/+Fp6GrxxljUpp/7+JNM2R9nCdQm1zvrrzdyK2mPJkgPN2ICApvAoFUVgS2Wv2xCLJz/7vXYo6LbTEtYTF2eVm0Btb7vYGv9lYhzE4EBvO3gTVFQvfzH2m30g1xmDFlEKamiPAfcuJ4hcSycKjgQHuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nx21Hlgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nx21Hlgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2F5C4CEF7;
	Wed, 11 Mar 2026 21:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773265050;
	bh=ORQzYJ3u6URHD61tJ2SgGSNAbElHdRC0qUDT7hNEH6w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=Nx21HlgqQ6VZ+y2Us6LdjW0RQ1hUYuC/0bmVaTeszZWdDsxJXElSuZzXoBCgyp6lH
	 jkh4i3oqF5ejljyM9fxUvcxj9oxeg8UU+1E9TR7bIWP49btl8XpKIauCxvHL8Hqi31
	 ihrwzBSdj6MiSGNo13Ur5xHwp/QSl6B+gwVfZ5QBbfohbZZv3sFgFfxJGRmNIeIGGw
	 pQYDAxGrh5txU1Yy3u1G5RL6av0A6kpJpSIiqUd14kk4wKEG3r7qUzhsGwa7ilKUfy
	 CzEYKpkz2z7TfiJ5j33hP9tOJezEAhDjDne7ZorrYnrSH502PK93L9wcFogEh54tlq
	 roZ0rovRgelGA==
Date: Wed, 11 Mar 2026 16:37:28 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
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
	Laurence Oberman <loberman@redhat.com>,
	Marco Elver <elver@google.com>
Subject: Re: [PATCH 2/5] driver core: separate function to shutdown one device
Message-ID: <20260311213728.GA1024689@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <932d4e59-395f-4022-a2de-874fdea778ac@acm.org>

On Wed, Mar 11, 2026 at 11:00:11AM -0700, Bart Van Assche wrote:
> On 3/11/26 10:12 AM, David Jeffery wrote:
> > +static void shutdown_one_device(struct device *dev)
> > +{
> > +	/* hold lock to avoid race with probe/release */
> > +	if (dev->parent && dev->bus && dev->bus->need_parent_lock)
> > +		device_lock(dev->parent);
> > +	device_lock(dev);
> > +
> > +	/* Don't allow any more runtime suspends */
> > +	pm_runtime_get_noresume(dev);
> > +	pm_runtime_barrier(dev);
> > +
> > +	if (dev->class && dev->class->shutdown_pre) {
> > +		if (initcall_debug)
> > +			dev_info(dev, "shutdown_pre\n");
> > +		dev->class->shutdown_pre(dev);
> > +	}
> > +	if (dev->bus && dev->bus->shutdown) {
> > +		if (initcall_debug)
> > +			dev_info(dev, "shutdown\n");
> > +		dev->bus->shutdown(dev);
> > +	} else if (dev->driver && dev->driver->shutdown) {
> > +		if (initcall_debug)
> > +			dev_info(dev, "shutdown\n");
> > +		dev->driver->shutdown(dev);
> > +	}
> > +
> > +	device_unlock(dev);
> > +	if (dev->parent && dev->bus && dev->bus->need_parent_lock)
> > +		device_unlock(dev->parent);
> > +
> > +	put_device(dev->parent);
> > +	put_device(dev);
> > +}
> 
> Please keep the following code in the caller:
> 
> 	if (dev->parent && dev->bus && dev->bus->need_parent_lock)
> 		device_lock(dev->parent);
> 
> 	if (dev->parent && dev->bus && dev->bus->need_parent_lock)
> 		device_unlock(dev->parent);
> 
> 	put_device(dev->parent);
> 	put_device(dev);

Can you elaborate on this a little bit?  I can see that doing this in
the caller is simpler in some ways, although there are two callers
that would need this.  Maybe it's just the lock anti-pattern below?

> Additionally, please make sure that the caller is made compatible with
> lock context analysis (see also
> https://lore.kernel.org/all/20250206181711.1902989-1-elver@google.com/).
> All that is required to make this code compatible with lock context
> analysis is to organize it as follows:
> 
> 	if (dev->parent && dev->bus && dev->bus->need_parent_lock) {
> 		device_lock(dev->parent);
> 		shutdown_one_device(dev);
> 		device_unlock(dev->parent);
> 	} else {
> 		shutdown_one_device(dev);
> 	}

I guess avoiding the "conditional acquisition and later conditional
release" pattern mentioned at [1] is what makes this compatible with
lock context analysis?

I guess this is another way of expressing the "no conditionally held
locks" rule [2], which is more concise and fits better in my pea
brain.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/dev-tools/context-analysis.rst?id=v7.0-rc1#n42
[2] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#no-conditionally-held-locks
