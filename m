Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AF9357A37;
	Fri, 16 Jan 2026 09:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768556230; cv=none; b=UJpOjiNEtv8WDCafLeNS95QAd39DZqgxgJJlEBRgEsAu2xCUfogXfdC7NcUY1g99kB5RxhXcUJ097WRa2BL/nzOuI0rpP+l9EMSseyMYygJaKs1pGUUYK86bo+L9LYyFE0xK739yPrmuyL9zJYKW5WG35jtueJ0mAkh3YJpKJXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768556230; c=relaxed/simple;
	bh=zUduGCxVwQP0KumLu36joq1fjzu91IDcm5g6mdZhwPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvvqO8V45gYgTtusiXm6RPt7KxLu/x8Vx+kMr+Kpv0FxNhF9vv4NmBLjzRolkXsIMQ5NVpjUUJIt60TqifmDkMsKjlvIS0/eI5ENfZDwtyqJ0RkJIhfxaV/mhqVfqhk1dQhFGsWm5FklYTRGPtd1oajCymwKFqb3MgAVQvL24CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKADkw/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKADkw/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36944C19425;
	Fri, 16 Jan 2026 09:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768556230;
	bh=zUduGCxVwQP0KumLu36joq1fjzu91IDcm5g6mdZhwPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKADkw/fp7j5p1fU3GRILCaD8FF9JHFv5LSBAij5d5qjSLMJF2AhhfoHJjKV3OxnP
	 xNdDNV+oVKRSbqWwIeBFShGh81ji0fluSF8J46jJG2UrGD2YawH0KbYIBMlmMvKn+X
	 +GPG60M5d2Qtic48dbkRBIKDnZRRy2VTgykd6OS9PfrBBY2Nhhahe3m647tna7cU06
	 e6Ayp8LACiKaHPzQjQyzdMjz9mg9N7yj7Rg7ozyK9GPsA0rrPEy8KeAayRANHSAfZX
	 lZLHQ+ClBRC+6fxcXuOnI1/QmXPo3t5WNQGPpanG1v7DN8p2YY2ukQTL8cJygBl6FV
	 jHnc7faId4ZWA==
Date: Fri, 16 Jan 2026 09:37:07 +0000
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Correct wrong kfree() usage for `kobj->name`
Message-ID: <aWoGw8PEKj_5mncV@google.com>
References: <20260116081359.353256-1-tzungbi@kernel.org>
 <2026011614-exile-raisin-0ec4@gregkh>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026011614-exile-raisin-0ec4@gregkh>

On Fri, Jan 16, 2026 at 10:00:11AM +0100, Greg KH wrote:
> On Fri, Jan 16, 2026 at 08:13:59AM +0000, Tzung-Bi Shih wrote:
> > `kobj->name` should be freed by kfree_const()[1][2].  Correct it.
> > 
> > [1] https://elixir.bootlin.com/linux/v6.18/source/lib/kasprintf.c#L41
> > [2] https://elixir.bootlin.com/linux/v6.18/source/lib/kobject.c#L695
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: b49493f99690 ("Fix a memory leak in scsi_host_dev_release()")
> > Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
> > ---
> >  drivers/scsi/hosts.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index e047747d4ecf..50ec782cf9f4 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -373,7 +373,7 @@ static void scsi_host_dev_release(struct device *dev)
> >  		 * name as well as the proc dir structure are leaked.
> >  		 */
> >  		scsi_proc_hostdir_rm(shost->hostt);
> > -		kfree(dev_name(&shost->shost_dev));
> > +		kfree_const(dev_name(&shost->shost_dev));
> 
> Shouldn't the struct device name be freed by the driver core for this
> device when it goes out of scope?  Why is it being manually freed here
> at all?

Ah, correct.  I think the following patch is what it really needs:

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1b3fbd328277..e3362f445f93 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -373,7 +373,6 @@ static void scsi_host_dev_release(struct device *dev)
 		 * name as well as the proc dir structure are leaked.
 		 */
 		scsi_proc_hostdir_rm(shost->hostt);
-		kfree(dev_name(&shost->shost_dev));
 	}

 	kfree(shost->shost_data);
@@ -548,11 +547,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 		goto fail;
 	return shost;
  fail:
-	/*
-	 * Host state is still SHOST_CREATED and that is enough to release
-	 * ->shost_gendev. scsi_host_dev_release() will free
-	 * dev_name(&shost->shost_dev).
-	 */
+	put_device(&shost->shost_dev);
 	put_device(&shost->shost_gendev);

 	return NULL;
