Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE664ABBC7
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 08:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789719002; cv=none; b=dLk3YZtqDmJ5v18oB/XgLjcEAGcmDRHzULjRtx7Uwf5TeFhOh+l16DTNCs4nnJVkctrnw5Ofh3iuVwnBj9cBDv4KdfOs54NQtlY1LNI0ynqLzE9IptqYws84NZaHcD0WNywU6xtTJkNVZIrtQbAnzmQxJmuT5oFOjxX2cFzy07Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789719002; c=relaxed/simple;
	bh=awZMeq6bDCiqB5Kn774eAUzZbhjD78bfkjvYh0QAN9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uYUmdGKLw89/57+Gs9F6N81EDf22B8f2AzCiWBumOyBxKDT4Zcx3qsob3DM7o3ZAZV9DV8q3SUdwNI9datwCpN4zYu13IoFDKP+fZMopns0pcc9DsguSTVQi7ysflqHHS9MXaDM071hXS7v7zrCU8IbiNXjb2GoWLlTP/LrdCRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5xb9AXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5xb9AXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577CE1F000FF;
	Fri, 18 Sep 2026 08:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789719000;
	bh=wGxr7bQoeuMoA5CcrJlhhymtT+Y22bYOHg9gJ63cztE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q5xb9AXP2B2VbEGIJUrpnPDrv1ckZRi//XiCG33qaGvtZzVrvyuP7Vhue/vjUhdz0
	 6DzLBq52o06sS4S7GO4MKFUPJk2qUIAXJcXTOXBbuS744wTnpA6cmKie5Ecbn/ofWf
	 d4iwHzeh6w5MwZz5AXewWNSXeF62l6/obOfVX2SeKZIxIYl2WJ6kSTJencjFw9Ejyo
	 jdtA4A7so6Z2IAJPQVMS6QXaVcCi/9Q654eNmanGskVOxaLNe4S0SGzlYO6OFV3k5e
	 nBwGORrQ3abplSljSFUpksMpOrDrIKGvoDS7AkH7l/Up7rtp+y65XJMCpMG/JZr6Pk
	 ootJn0ZHOKy7g==
Date: Fri, 18 Sep 2026 10:09:56 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v4 09/10] scsi: scsi_debug: Map the region written by
 WRITE ATOMIC (16)
Message-ID: <aqzx1AUJExRHuz4S@ryzen>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-21-cassel@kernel.org>
 <9838197a-4c2f-477c-b4bb-648f13922e19@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9838197a-4c2f-477c-b4bb-648f13922e19@linux.dev>

On Fri, Sep 18, 2026 at 08:29:15AM +0100, John Garry wrote:
> On 9/18/26 07:29, Niklas Cassel wrote:
> > When logical block provisioning is enabled, a command that writes user
> > data marks the region that it wrote in the provisioning map, so that
> > GET LBA STATUS reports the region as mapped. resp_write_dt0(),
> > resp_write_scat() and resp_write_same() all call map_region() for that.
> > 
> > resp_atomic_write() does not, so a WRITE ATOMIC (16) leaves the
> > provisioning map untouched, and GET LBA STATUS keeps reporting the
> > region as deallocated after it has been written. map_state(), which
> > GET LBA STATUS uses, is the only reader of the map, so that is the whole
> > of the effect.
> > 
> > Call map_region() the way resp_write_dt0() does, and take the zone
> > metadata write lock across the access as it does when logical block
> > provisioning is enabled. That lock is what serialises the provisioning
> > map against resp_unmap(), which holds it while unmap_region() clears map
> > bits and zeroes the data that they cover. resp_unmap() does nothing
> > unless logical block provisioning is enabled, so the lock is only needed
> > in that case.
> > 
> > Assisted-by: LLM
> > Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> > Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> > Signed-off-by: Niklas Cassel <cassel@kernel.org>
> > ---
> > Tested with:
> > 
> >    modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
> >        atomic_wr=1 lbpu=1
> > 
> > GET LBA STATUS reports a region that has never been written as
> > deallocated, and reports it as mapped after a WRITE ATOMIC (16) of eight
> > blocks. Only an ordinary WRITE did so before this patch.
> > ---
> >   drivers/scsi/scsi_debug.c | 13 +++++++++++++
> >   1 file changed, 13 insertions(+)
> > 
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index cdea21b570c4..5243401701f9 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -6200,6 +6200,8 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
> >   	u8 *cmd = scp->cmnd;
> >   	u16 boundary, len;
> >   	u64 lba, lba_tmp;
> > +	bool meta_data_locked = false;
> > +	bool lbp = scsi_debug_lbp();
> >   	int ret;
> >   	if (!scsi_debug_atomic_write()) {
> > @@ -6244,7 +6246,18 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
> >   		}
> >   	}
> > +	if (lbp) {
> > +		sdeb_meta_write_lock(sip);
> > +		meta_data_locked = true;
> > +	}
> > +
> >   	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
> > +	if (unlikely(lbp))
> > +		map_region(sip, lba, len);> +
> > +	if (meta_data_locked)
> 
> Do we really need meta_data_locked variable? why not:
> 	if (lbp)
> 		sdeb_meta_write_unlock(sip);
> 

Yes, that would work for resp_atomic_write() as it does not support zones.

The code was cargo-culted from resp_write_dt0(), which does support zones.

Will fix in a v5. Will wait until Monday before I respin so that other
people (including Damien) get a chance to review v4.


Kind regards,
Niklas
