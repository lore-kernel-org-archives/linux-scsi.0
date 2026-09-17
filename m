Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1086349AA23;
	Thu, 17 Sep 2026 09:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636163; cv=none; b=pB18032xZ2HINEDXJQTrQ96otiazwDFbbKTIv+sBdO0hUr+0LGU4F+4V4AAz0l7RKEHAd+9jyYeGc/N1jiDx++m+F4y/4dWv9Mb9Pr+JWacTwxogQWFtxIfabXIHNK1JAfDsGbGmsnx5+vgtAcq7leIvFXAYn7twq2QIjIh7hmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636163; c=relaxed/simple;
	bh=p1F7NJhrkocgz+GjECC8uOX3z466+i5y30cIZVAsNhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0UNQxhuSL0P+88pgpjqqyi3FPf6h51UdvhFel+kNPnfgw8l7RFhhVJokN4KuLwIgJ4zlL9onqVRXeSL7LGuZ6nzAbVtKY4EhJkug8xPhwkGogtJC9VA6dUMwRq5zZfkF6sTB5cV12KPdiO5F7tBEvFtqn1BmqhjUkqafve0GnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyLywAXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyLywAXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3C01F000FF;
	Thu, 17 Sep 2026 09:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636161;
	bh=iG7HGe3ZgUs1IPrK51nxzoViBklze3HkGpQvds9gOEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iyLywAXLzzorVJUDv78FptcN1KUExadljXZf3Eqb+EZKamrxqVlLJCiSMd7YpG5kD
	 bz9atrc8aHWNxNRU6CtmFTFn0LlT7xPb1bfhVo81LotAZ3CdLQd+RMqOhhLBEExZpP
	 ABzVxBBpxq5A6BANmwhCVj8uPY7ScYipmyGBzwLC6xLbSskfL96gJMoOk9cf0Di5CP
	 e9l0dICpPl9q+BQQE1gEgt4We/2jVhC1PaluQoFObK1LSFjVES7D+70Eg11U6Txoam
	 Wbz7fGtxWNSbLaThJ4hZpYREW8UPFjmnnj5dBt5drokpqogv+jV0UUhcUNcCAYMdN7
	 CZx9JWxLadP2A==
Date: Thu, 17 Sep 2026 11:09:18 +0200
From: Niklas Cassel <cassel@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
Message-ID: <aquuPkwDEK6Ppnte@ryzen>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
 <20260917090021.7C6E81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917090021.7C6E81F000FF@smtp.kernel.org>

On Thu, Sep 17, 2026 at 09:00:21AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] scsi: scsi_debug: zone write pointer incremented on failed ATOMIC WRITE
> --
> 
> commit 9183d5d7f092b92218c3638f33edc6839086d9f3
> Author: Niklas Cassel <cassel@kernel.org>
> 
> scsi: scsi_debug: Validate zone access for WRITE ATOMIC (16)
> 
> WRITE ATOMIC (16) is a write command, so on a zoned device it is subject to
> the access requirements of the zone that it addresses, and it advances the
> write pointer of a sequential write required zone. This patch validates the
> access and advances the write pointer holding the zone metadata write lock
> across both operations.
> 
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index 5a95b7cd7a44c..d52b1f762afb5 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -6209,7 +6209,24 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
> [ ... ]
> >  	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
> > +
> > +	/* If ZBC zone then bump its write pointer */
> > +	if (sdebug_dev_is_zoned(devip)) {
> > +		zbc_inc_wp(devip, lba, len);
> 
> [Severity: Medium]
> Does this code advance the write pointer even if do_device_access() fails?
> 
> If a command like WRITE ATOMIC (16) is submitted with an invalid DMA
> direction (e.g., DMA_FROM_DEVICE via SG_IO) or a truncated scatter-gather
> list, do_device_access() can return -1 or a short length.
> 
> Because the write pointer in resp_atomic_write() is incremented before
> checking the return value of do_device_access(), the mock device's internal
> zone state could become out-of-sync with the simulated physical medium.
> This could cause subsequent valid writes to be incorrectly rejected with
> UNALIGNED WRITE COMMAND.

That is how resp_write_dt0() and all other write functions is scsi_debug is
implemented.

That said, I agree that it looks suboptimal...

I can write prep-patch that cleans up all the write functions to only
advance the WP when do_device_access() succeeds.


Kind regards,
Niklas
