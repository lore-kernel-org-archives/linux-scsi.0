Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6520D30BBBF;
	Fri, 16 Jan 2026 10:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768560618; cv=none; b=LgD5xp7PSptQK1M3tKy2RMvH/TOiLSkGLoIVKk/qlHIULCD/n5AYM/+ffN37YaoTIXuYQ5UhINIaOZhkxG6ztShmhKrIfKm/yXgZ1ItShMZWjh6uKs3bisut/c4lv7DJOjzvKetldAZ5Vzu3LBQwqLYTn8GrHeobtUB3YJ+WvBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768560618; c=relaxed/simple;
	bh=twU4m5YcK2UnrcpZN3wZfibzK8tVZafQcR1pYqBSjDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYMoh/eJmKCGxELzPY6YCSsBcvTjPe+9gRzgZUbAUXkJyo/CYjL/JIDX6oDKxkBv1hLvsWxTMzZnWt7ZN3UY7ztOXb/fMYM89IAsJE1B2Jvl2gRSlPvlkeF2wAhQqrxue9MjyGeKEIwX3nFrPEhTHdmOmYpHGcAuwBN53xUT4zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLJISYPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLJISYPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACF0C116C6;
	Fri, 16 Jan 2026 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768560617;
	bh=twU4m5YcK2UnrcpZN3wZfibzK8tVZafQcR1pYqBSjDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wLJISYPYV2bT+73D17fp5ZbvOph4ujl0Co8s0P2bKlnS89cRnMlQVNmv7nzUuopJN
	 5FvkP6NLbxEXawNW4tPbn+DZrdyPOLrHJivpEiO4HJojzkDd0xcw3sNDMd9iE0m1Gf
	 r8ZwPEN6U3FXPGNErJNNc1R6Jgb877I4fGOiH9e0=
Date: Fri, 16 Jan 2026 11:50:15 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Correct wrong kfree() usage for `kobj->name`
Message-ID: <2026011658-fervor-possibly-4af2@gregkh>
References: <20260116081359.353256-1-tzungbi@kernel.org>
 <2026011614-exile-raisin-0ec4@gregkh>
 <aWoGw8PEKj_5mncV@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWoGw8PEKj_5mncV@google.com>

On Fri, Jan 16, 2026 at 09:37:07AM +0000, Tzung-Bi Shih wrote:
> On Fri, Jan 16, 2026 at 10:00:11AM +0100, Greg KH wrote:
> > On Fri, Jan 16, 2026 at 08:13:59AM +0000, Tzung-Bi Shih wrote:
> > > `kobj->name` should be freed by kfree_const()[1][2].  Correct it.
> > > 
> > > [1] https://elixir.bootlin.com/linux/v6.18/source/lib/kasprintf.c#L41
> > > [2] https://elixir.bootlin.com/linux/v6.18/source/lib/kobject.c#L695
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: b49493f99690 ("Fix a memory leak in scsi_host_dev_release()")
> > > Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
> > > ---
> > >  drivers/scsi/hosts.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > > index e047747d4ecf..50ec782cf9f4 100644
> > > --- a/drivers/scsi/hosts.c
> > > +++ b/drivers/scsi/hosts.c
> > > @@ -373,7 +373,7 @@ static void scsi_host_dev_release(struct device *dev)
> > >  		 * name as well as the proc dir structure are leaked.
> > >  		 */
> > >  		scsi_proc_hostdir_rm(shost->hostt);
> > > -		kfree(dev_name(&shost->shost_dev));
> > > +		kfree_const(dev_name(&shost->shost_dev));
> > 
> > Shouldn't the struct device name be freed by the driver core for this
> > device when it goes out of scope?  Why is it being manually freed here
> > at all?
> 
> Ah, correct.  I think the following patch is what it really needs:
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 1b3fbd328277..e3362f445f93 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -373,7 +373,6 @@ static void scsi_host_dev_release(struct device *dev)
>  		 * name as well as the proc dir structure are leaked.
>  		 */
>  		scsi_proc_hostdir_rm(shost->hostt);
> -		kfree(dev_name(&shost->shost_dev));
>  	}
> 
>  	kfree(shost->shost_data);
> @@ -548,11 +547,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
>  		goto fail;
>  	return shost;
>   fail:
> -	/*
> -	 * Host state is still SHOST_CREATED and that is enough to release
> -	 * ->shost_gendev. scsi_host_dev_release() will free
> -	 * dev_name(&shost->shost_dev).
> -	 */
> +	put_device(&shost->shost_dev);
>  	put_device(&shost->shost_gendev);
> 
>  	return NULL;

Can you test this to verify that the leak you were seeing is actually
now handled?

thanks,

greg k-h
