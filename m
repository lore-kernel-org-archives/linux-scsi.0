Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A5B35CB95;
	Mon, 19 Jan 2026 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832897; cv=none; b=OnXIie2a6T6cICwIs3gv35QANiMWneYov9m1D7N/6V8dF2Enh3Zj4uGuRo0ei783eG3Gh/t/XqRQFslqZBdyNymebpcXs6frwxaPsYEyUFYzw4FVhtEAZvmK31cosr1KIx//a1vjvSWnrCPdJMwL15V5VMtPpoXsrK7pgyY/Teg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832897; c=relaxed/simple;
	bh=wiHdtjR9m8/MFCHvlIEAkvQxZwFjE9o7xL9entXT0I4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WRV3IaMs/XcQMYh4KwmwcAGZvw3euKu3z86iAWcc2FenpbEHoWsWN4MdrDz7Bxb0xxpTCOlKgjUrNO2SxS9I/FWHK8zcuSM1cOfBR3Oy+AeFfsgcd61x/UD/7Vwihnl+SHcIfgFB7Nu8WkSZ/41ficRTBasly3j/2AO3xJ2bWLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3+I+bBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3+I+bBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006D6C116C6;
	Mon, 19 Jan 2026 14:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768832897;
	bh=wiHdtjR9m8/MFCHvlIEAkvQxZwFjE9o7xL9entXT0I4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T3+I+bBpTWXGgZMRQSZ/fUGcblN/oocb6eG7kIOYExo6uxrUHlPsQiGw12R7C7Jyy
	 8G2Xm3jBfYgltlPOwgNjtrq/6qbK/fV6PlKOmTK3x6dN3PtTbZZBdmoLuZ4TsRHKxF
	 yTbToIHj+i2biSA/k6uOpHapC36s1BR6nT9PKHAoTXaaFrQtHuRZoz275e2YwCuzzY
	 iQw01mFaInBF3RZeam1rq2p3OdjiusMbzbJY01IppqGa+l6crd2AvC/wyFWK8GS9ev
	 DZmZJDfvzfraNQVsYsbU5zGoCa01C7PpzV3YXL6M3ahK/EZxgYElzha5DXpsYAZ0yK
	 l8eDEPdrOhzdQ==
Date: Mon, 19 Jan 2026 22:28:13 +0800
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg KH <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Don't free dev_name() manually
Message-ID: <aW4_fbfNUMTDTAN1@tzungbi-laptop>
References: <20260117193221.152540-1-tzungbi@kernel.org>
 <de7b19fe19ccb117cad8cd32d9c51796ee81b752.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de7b19fe19ccb117cad8cd32d9c51796ee81b752.camel@HansenPartnership.com>

On Sun, Jan 18, 2026 at 09:45:26AM -0500, James Bottomley wrote:
> On Sun, 2026-01-18 at 03:32 +0800, Tzung-Bi Shih wrote:
> > > scsi_host_alloc() is designed to hold initial reference count of
> > > `&shost->shost_gendev` and `&shost->shost_dev`.  In the error
> > > handling paths [1], only drop a reference count to `&shost-
> > > >shost_gendev` is sufficient as scsi_host_dev_release() will be
> > > called and the reference count of `&shost->shost_dev` should be
> > > dropped at that time.
> > > 
> > > Drivers shouldn't need to free the device name and hold a reference
> > > count to its parent device as the driver core automatically handles
> > > that.  Remove them.
> > > 
> > > [1] Either at "fail" label in scsi_host_alloc() or in SCSI drivers
> > > that
> > >     a subsequent scsi_add_host{,_with_dma}() fails.
> 
> This commit description seems to bear almost no relation to what's
> going on in the commit ... please describe why you're doing what you're
> doing (like eliminating the class based device get and the parent get
> and, apparently, trying to flatten the device tree in the host).

An attempt to fix in v2[2].

[2] https://lore.kernel.org/all/20260119142306.33676-1-tzungbi@kernel.org/T/#u.

> 
> > > 
> > > Fixes: b49493f99690 ("Fix a memory leak in
> > > scsi_host_dev_release()")
> > > Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
> > > ---
> > >  drivers/scsi/hosts.c | 16 +++++-----------
> > >  1 file changed, 5 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > > index 1b3fbd328277..b88d553cdde6 100644
> > > --- a/drivers/scsi/hosts.c
> > > +++ b/drivers/scsi/hosts.c
> > > @@ -55,7 +55,6 @@ static DEFINE_IDA(host_index_ida);
> > >  
> > >  static void scsi_host_cls_release(struct device *dev)
> > >  {
> > > - put_device(&class_to_shost(dev)->shost_gendev);
> > >  }
> 
> An empty release function can simply become a NULL pointer.  I assume
> the reason this one doesn't is because the device core will complain if
> a device has no release function ... in which case a comment why we
> don't need one should be here.

Fixed in v2.

> But there's a reason for the warning: a bigger problem with this is the
> parenting goes
> 
> shost_dev -> shost_gendev -> underlying device
> 
> And shost_dev is visible in the sysfs tree so it could possibly by held
> in place by user space.  If that happens, since you've now removed the
> reference it took on shost_gendev, what stops shost_gendev (and the
> rest of the host) being freed?
> 
> > >  
> > >  static struct class shost_class = {
> > > @@ -279,11 +278,9 @@ int scsi_add_host_with_dma(struct Scsi_Host
> > > *shost, struct device *dev,
> > >   goto out_disable_runtime_pm;
> > >  
> > >   scsi_host_set_state(shost, SHOST_RUNNING);
> > > - get_device(shost->shost_gendev.parent);
> 
> We need a reference to the parent to prevent surprise removal ... where
> else is the reference held?

It looks to me the same question as above.  IIUC, device_add() holds a
reference count to its parent[3].  Drivers don't need to do it explicitly.

[3] https://elixir.bootlin.com/linux/v6.18/source/drivers/base/core.c#L3612

> 
> > >  
> > >   device_enable_async_suspend(&shost->shost_dev);
> > >  
> > > - get_device(&shost->shost_gendev);
> 
> I assume this is matched to the class dev_release which is gone?  If
> so, say in the commit message.

Fixed in v2.
