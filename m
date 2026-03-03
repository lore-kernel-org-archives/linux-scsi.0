Received: from out30-74.freemail.mail.aliyun.com (out30-74.freemail.mail.aliyun.com [115.124.30.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32360382398;
	Tue,  3 Mar 2026 09:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772529658; cv=none; b=cYBV3cr6lO1phF4ZWHTTrk9l88DKSiAC4nkjdEB8sZyTSUuxLInSnZyRdslAhnMavObNzmxlxOnN7QOE0S9wWgAq9xISOroPwtAucdNW2KLCmfvyhaBo7DQXNx5iH75dUFKz1kMbFHmVW/w3oFRJtrU7/xHJL2jnA1TfanHY0qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772529658; c=relaxed/simple;
	bh=5hB4yGWIroRcDs2BunxwAQA55QRPhn1m8voSWEv9f2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H4SIttbmMiO59iKWtPnW3LaxTOPQfiUZXVk/EBu4YYuf4feuNnt2K6B8nRScahxGR/Zt2TW93+eopLkbE+OCMkqCaVgE4ZwKZnygDpX/H2lJDil4BA+CJ9hVflni50Z50CmJ2gARbtYLdzVYxTUL53dx4pomyKMpLzSrVOo4bHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=luM4/+RS; arc=none smtp.client-ip=115.124.30.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="luM4/+RS"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1772529655; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=8ZDMSrA48o8VhabuQoBI/jNgHq/gf4Pf15b6rfqKZiM=;
	b=luM4/+RSFnM+rKge9LM29uoYj/tqpTBuOLRUmAR6GXRd8NcpzpLhFxYh+acBHoGJGPU4Yxx7NRnRfQ869GhAX7QCp7kWusn+Y646sfOZJuEllxCAm8L5x23Jg6QphSsSuOSuhgGz484AvEzEYNP9qUJI4AYCkeGQtyya0byeLq4=
Received: from VM-209-93-tencentos(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0X-9LGk0_1772529649 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 17:20:54 +0800
Date: Tue, 3 Mar 2026 17:20:49 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Fix missing lock when read async_scan in
 Scsi_Host
Message-ID: <aaan8Vlw7HQMZdA7@VM-209-93-tencentos>
References: <20260302121343.1630837-1-wdhh6@aliyun.com>
 <8dbc772a-e0dd-44d2-8e1f-1e54df42d72b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dbc772a-e0dd-44d2-8e1f-1e54df42d72b@kernel.org>

On Tue, Mar 03, 2026 at 05:45:13PM +0900, Damien Le Moal wrote:
> On 3/2/26 21:13, Chaohai Chen wrote:
> > When setting the async_scan flag in host, the host lock was locked,
> > but it is not locked during reading. Encapsulate the corresponding
> > API to fix this issue.
> > 
> > Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
> > ---
> >  drivers/scsi/scsi_scan.c | 60 +++++++++++++++++++++++++++++-----------
> >  1 file changed, 44 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 60c06fa4ec32..8b63130ef2e5 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -122,6 +122,42 @@ struct async_scan_data {
> >  	struct completion prev_finished;
> >  };
> >  
> > +static bool scsi_test_async_scan(struct Scsi_Host *shost)
> > +{
> > +	bool async;
> > +	unsigned long flags;
> > +
> > +	lockdep_assert_not_held(shost->host_lock);
> > +
> > +	spin_lock_irqsave(shost->host_lock, flags);
> > +	async = shost->async_scan;
> > +	spin_unlock_irqrestore(shost->host_lock, flags);
> > +
> > +	return async;
> > +}
> 
> Use an atomic ?
> 
The structure member async_stcan is defined in a bit field manner, 
and using atomic may change the structure definition, making it too complex
