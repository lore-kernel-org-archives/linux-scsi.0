Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9714F48BD56;
	Thu, 17 Sep 2026 12:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789647723; cv=none; b=lTjAD56yTU12NtAR5wKidOuh6GB0QWzj1aJp9YFnEHYocIjiYqlL7N8vKFiRJ7WWAn+0DbMJkni6S3m6JAVBrVYw40rxQtBwkIjxk8N+0NdOaLjN7m5Bu04OFHWdngganaJ3JDOip/IuhGk05TScCPs+osu5LSCbuGL/k+Pfl9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789647723; c=relaxed/simple;
	bh=hLpiB+Zr3Wowt6GaSTPFTKiva3aPokHyMtteJL9vqls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZSKKildIzlxWseosASL9gFJjWs/utMx6bIu257zJi69Z2Xb4IP4IpaNiJ2diHpAq4nuKlX58hdRPcTmYr3S+FbFdtHgpEqBSfdrhgvjOnx2v1uJTgp10UjJU5W9nhvYFRzhrso56OaBVKkjH6qtzycK7J5yVHrfo/RtoMgHMaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2X040gz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2X040gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA1A1F000FF;
	Thu, 17 Sep 2026 12:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789647713;
	bh=ksCDE8weSJynTp0IPYpbkRfvarE9ZWweigxoOoY6y+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d2X040gz+inturUewT2ZUtyxrLQV5McPiBPwdEgBd83J6H3qFcTX31IKfF+24PxJL
	 TYlAaabpBHQ/L4Z8qBrs2LEKRAhDj6ME3E7bnF+nqs+cacDNjMwC4rl3e/Q9bEp9pd
	 xVLfsjYzZr5I9jsEa10oZkynAb2RvcWN3LbQYlON3SwmA6H7h+KKv5J/AUGRkHKm/i
	 CG5+51dQW4XIhcth3aIjzfJnQO+k7Cm3mu1cfBVO1/1ypFC3HBXOKhTnNtHSrw2JlJ
	 XNIfZ95Sx3KfKlhzpyfsh6+XuAMfpxOjBhfU2jdbrHnr/ELUfjlsRw1XiGbqI9gNhP
	 x+JR4kS5yVjgQ==
Date: Thu, 17 Sep 2026 14:21:50 +0200
From: Niklas Cassel <cassel@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/4] scsi: scsi_debug: Do not advance the write
 pointer of a failed write
Message-ID: <aqvbXpJrgQ60OM-y@ryzen>
References: <20260917110316.1104863-6-cassel@kernel.org>
 <20260917110316.1104863-7-cassel@kernel.org>
 <20260917111738.DFFE91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917111738.DFFE91F00893@smtp.kernel.org>

On Thu, Sep 17, 2026 at 11:17:38AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] scsi: scsi_debug: ZBC specification violation by returning GOOD status without advancing WP
> - [Medium] scsi: scsi_debug: integer overflow in short write check allows incorrect WP advancement
> --
> 
> commit 2b6fea07514157218eac4ea45ff1ba17e05b5125
> Author: Niklas Cassel <cassel@kernel.org>
> 
> scsi: scsi_debug: Do not advance the write pointer of a failed write
> 
> This commit modifies the write pointer advancement logic for ZBC sequential
> write required zones. It ensures the write pointer is only incremented when
> all requested data is successfully written.
> 
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index 6941809dfdb75..3ce2dbdff177c 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -5150,8 +5150,8 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
> >  	if (unlikely(scsi_debug_lbp()))
> >  		map_region(sip, lba, num);
> >  
> > -	/* If ZBC zone then bump its write pointer */
> > -	if (sdebug_dev_is_zoned(devip))
> > +	/* If ZBC zone then bump its write pointer, if all data was written */
> > +	if (sdebug_dev_is_zoned(devip) && ret == num * sdebug_sector_size)
> 
> [Severity: Medium]
> Could the multiplication num * sdebug_sector_size overflow 32-bit arithmetic
> for large num? If the module is loaded with a capacity >= 4GB, an extremely
> large num and an empty data-out buffer might cause do_device_access() to
> safely return 0. If the multiplication overflows and evaluates to 0, this
> check might erroneously pass and incorrectly advance the write pointer.
> 
> [Severity: High]
> If do_device_access() returns a short count due to a small data-out buffer,
> this check prevents advancing the write pointer. However, the function then
> proceeds to return 0 (GOOD status) without calling scsi_set_resid(). Does
> this violate the ZBC specification, which requires that if a write terminates
> with GOOD status, the write pointer must be advanced by the transfer length?
> 
> Could this lead to silent data corruption or UNALIGNED WRITE COMMAND errors
> on subsequent sequential writes?

So it turns out that this driver is missing calls to:
scsi_set_resid() in:

resp_write_dt0(), resp_write_scat(), resp_atomic_write().

Interestingly, the driver does correctly call scsi_set_resid()
for read commands.

Will fix in v3, and will improve the WP advancement code to only
advance the blocks that was actually written (rather than leaving
the WP alone when not all blocks were written).


Kind regards,
Niklas
