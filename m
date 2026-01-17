Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D94F243956;
	Sat, 17 Jan 2026 19:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768679323; cv=none; b=J4q7A+iOTPRPxn/EykrO6IBAV15JGRrYmjrJ3j+DTKiLmqnYs/CBPTQie/8MP9CnQQrB/9X58ZbGZH8eGjSedhF3kfMgEKy5h8SBetGrSMIAYAqx4o3awWd7PCGi+Nt8kdtTa4RRrEa3l8+wQlIlMfw2vcfbTdhDY/Qy335isZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768679323; c=relaxed/simple;
	bh=/C/tBm2xi0H4+4EGIjq5H8w+8b7Ugn1WXndTijHdt+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmEFQ23vas8lb/vYb7t1mphQX8BNMZADAZ2g2DbouwOTYp/jjY4eJiVapGdXQBtuAMSyG/+jlv3Qv4DTsdL4pygAcYcrDU0pZjEt0GOJVaFwqqG5EFxYPiQn2aU/1/WIX90hIvMgZrUQor63qVH6tvyB2BmA+Yk31DfPUzz+YJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AVywj7BY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVywj7BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB582C4CEF7;
	Sat, 17 Jan 2026 19:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768679323;
	bh=/C/tBm2xi0H4+4EGIjq5H8w+8b7Ugn1WXndTijHdt+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AVywj7BYfi3XpQB9ewRMlQHR6EoquyThPql6ayPHJKU1S0B9tOlTn+7yktLzJvcVt
	 nMaG4VtxGVW30s/fk0Bo8OfMymu6MUGU9HjuZhgBxOHI94Q0olQGOEa1IW4Nt35gGt
	 Es11NrvJoQrA1WDpZZMLgnQiYpxpEGWthMHvPVN7WWAQy6yOPeP+5BKvPn4f2VHiVs
	 kkDskXWghzQcIMUAa2ZCHVd/a+i2eeZoWP7iIaBnpJM9TNJD9mcO5RtQjZ6XOo5nvK
	 WvbsyealisWqqNcBOfR5zwpr9XHDrQgOO4+rQhUh5tionzAInvoWYNgLv1LsU3QUz5
	 2krkj1+ttd0Cw==
Date: Sun, 18 Jan 2026 03:48:38 +0800
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Correct wrong kfree() usage for `kobj->name`
Message-ID: <aWvnloUA2smmmi9v@tzungbi-laptop>
References: <20260116081359.353256-1-tzungbi@kernel.org>
 <2026011614-exile-raisin-0ec4@gregkh>
 <aWoGw8PEKj_5mncV@google.com>
 <2026011658-fervor-possibly-4af2@gregkh>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026011658-fervor-possibly-4af2@gregkh>

On Fri, Jan 16, 2026 at 11:50:15AM +0100, Greg KH wrote:
> On Fri, Jan 16, 2026 at 09:37:07AM +0000, Tzung-Bi Shih wrote:
> > On Fri, Jan 16, 2026 at 10:00:11AM +0100, Greg KH wrote:
> > > On Fri, Jan 16, 2026 at 08:13:59AM +0000, Tzung-Bi Shih wrote:
> > > > `kobj->name` should be freed by kfree_const()[1][2].  Correct it.
> > > > 
> > > > [1] https://elixir.bootlin.com/linux/v6.18/source/lib/kasprintf.c#L41
> > > > [2] https://elixir.bootlin.com/linux/v6.18/source/lib/kobject.c#L695
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: b49493f99690 ("Fix a memory leak in scsi_host_dev_release()")
> > > > Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
> > > > ---
> > > >  drivers/scsi/hosts.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > > > index e047747d4ecf..50ec782cf9f4 100644
> > > > --- a/drivers/scsi/hosts.c
> > > > +++ b/drivers/scsi/hosts.c
> > > > @@ -373,7 +373,7 @@ static void scsi_host_dev_release(struct device *dev)
> > > >  		 * name as well as the proc dir structure are leaked.
> > > >  		 */
> > > >  		scsi_proc_hostdir_rm(shost->hostt);
> > > > -		kfree(dev_name(&shost->shost_dev));
> > > > +		kfree_const(dev_name(&shost->shost_dev));
> > > 
> > > Shouldn't the struct device name be freed by the driver core for this
> > > device when it goes out of scope?  Why is it being manually freed here
> > > at all?
> > 
> > Ah, correct.  I think the following patch is what it really needs:
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 1b3fbd328277..e3362f445f93 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -373,7 +373,6 @@ static void scsi_host_dev_release(struct device *dev)
> >  		 * name as well as the proc dir structure are leaked.
> >  		 */
> >  		scsi_proc_hostdir_rm(shost->hostt);
> > -		kfree(dev_name(&shost->shost_dev));
> >  	}
> > 
> >  	kfree(shost->shost_data);
> > @@ -548,11 +547,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
> >  		goto fail;
> >  	return shost;
> >   fail:
> > -	/*
> > -	 * Host state is still SHOST_CREATED and that is enough to release
> > -	 * ->shost_gendev. scsi_host_dev_release() will free
> > -	 * dev_name(&shost->shost_dev).
> > -	 */
> > +	put_device(&shost->shost_dev);
> >  	put_device(&shost->shost_gendev);
> > 
> >  	return NULL;

The patch doesn't work well.  It can cause an underflow on the reference
count of `&shost->shost_gendev`.  [3] is a more appropriate fix.

> Can you test this to verify that the leak you were seeing is actually
> now handled?

To clarify, the patch wasn't motivated by the leak.  But I can reproduce
the leak by reverting b49493f99690, manual fault injection, rebinding the
driver, and kmemleak.  [3] is tested by the scenario.

[3] https://lore.kernel.org/all/20260117193221.152540-1-tzungbi@kernel.org/
