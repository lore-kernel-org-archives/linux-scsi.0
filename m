Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EADA572687;
	Thu, 17 Sep 2026 14:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789653717; cv=none; b=sbnAwu0ubtJI+SWwZFrShrAcTYDR2CMn9NOqYZYlgLsmdg6Q4X9Ne0b2Wem4/B/LkcWKYBarhTGXf9IrPyRX4cAqFb5Bb2MSVubmZ6bjwBgfhZgrVFxEl7dCfqGOhydrPAKqrd1o5qu4DE1lWIYxEjsEkw0EUMTwQjpVAd9uhrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789653717; c=relaxed/simple;
	bh=zFfZjLMgrz+jkb9SxwM7wqYPQWVeaY1DstgCJb3KNQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmFmd/Vj1BrJbC2SHI5pyVMgBGyT4LWPX8hc9QbOD2LeJ0iewbdiVAMnyS03QIL7LnmHuRrFQzfeIXfhgntdqVf0RzHVjIF/mhIrqvtn/Ojjc6xWBc3epxEHDbylIBJIE8GRcsJpuXg+4oT/vrMrRiJUqd50GNEsJ/iLRpw6lpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggUHgwIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggUHgwIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128B11F000FF;
	Thu, 17 Sep 2026 14:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789653715;
	bh=IGwfOWjLKGH3dclZooKwZy6snL3kjdlFmP+nudk6Hg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ggUHgwIeZdodcpVMrYm9FZuXrbAl7LgCFswZPC8tgp31JzAym7z+GqdZhJy3ZGYgq
	 q3EMAQ+COL2Tswll7UBWSAQcVETY8BjFCGwv8jR7yS/qmSz1gMGfvN73ZZiuqEpEZL
	 vUjtucWmCw3ac4T7bqAiJ1EeO+eVLboBLWlop0N8AVYs5nsZeqcMBKaDM55ozdFz+X
	 2xK0jAg/Op+sSUa8TTnvmnCozDipSjCoX02Ixx0n9EHeW7/ZPbPHmIu2Dse+bwiw+h
	 TDHAvRVPUArlDqK/S+qKeMZMOrWCbrcrqSheJJAD5K/hIi9M7wNjLRPMkH1Qvh7KNB
	 I1prNRui37WHw==
Date: Thu, 17 Sep 2026 16:01:52 +0200
From: Niklas Cassel <cassel@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 5/6] scsi: scsi_debug: Map the region written by WRITE
 ATOMIC (16)
Message-ID: <aqvy0OAEDrjagXHj@ryzen>
References: <20260917125445.1376493-8-cassel@kernel.org>
 <20260917125445.1376493-13-cassel@kernel.org>
 <20260917131251.445AC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917131251.445AC1F000FF@smtp.kernel.org>

On Thu, Sep 17, 2026 at 01:12:50PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] scsi_debug: ABBA deadlock between resp_atomic_write() and resp_comp_write()
> - [Medium] scsi_debug: TOCTOU race in resp_atomic_write() via double evaluation
> --
> 
> commit d00845f77d0b11824b6bd723b3a99d9e2026b838
> Author: Niklas Cassel <cassel@kernel.org>
> 
> scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
> 
> When logical block provisioning is enabled, commands that write user data mark
> the region in the provisioning map. WRITE ATOMIC (16) leaves the map untouched,
> so this patch calls map_region() and takes the metadata write lock across the
> access.
> 
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index 64f32d97455d6..33f2df26e5af7 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> [ ... ]
> > @@ -6228,7 +6229,18 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
> >  		}
> >  	}
> >  
> > +	if (scsi_debug_lbp()) {
> > +		sdeb_meta_write_lock(sip);
> > +		meta_data_locked = true;
> > +	}
> > +
> >  	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
> 
> [Severity: High]
> Does this code introduce a lock inversion deadlock with resp_comp_write()?
> 
> Here in resp_atomic_write(), the metadata lock is acquired before calling
> do_device_access(), which acquires the data lock:
> 
> resp_atomic_write()
>   sdeb_meta_write_lock(sip);
>   do_device_access()
>     sdeb_data_lock(sip, true)
>       sdeb_data_write_lock(sip);
> 
> However, in resp_comp_write(), the locks are acquired in the reverse order:
> 
> resp_comp_write()
>   sdeb_data_write_lock(sip);
>   sdeb_meta_write_lock(sip);

Well, this seems to be a pre-existing problem, since resp_write_dt0() takes
the locks in the same order as resp_atomic_write().

It looks like resp_comp_write() is the only one who takes the locks in opposite
order, so the fix is probably to swap the order in resp_comp_write().


> 
> Could concurrent execution of write atomic (16) and compare and write
> commands to the same target cause the scsi processing kworkers to deadlock?
> 
> > +	if (unlikely(scsi_debug_lbp()))
> > +		map_region(sip, lba, len);
> 
> [Severity: Medium]
> Could this result in a race condition due to evaluating scsi_debug_lbp() twice?
> 
> If an administrator modifies /sys/bus/pseudo/drivers/scsi_debug/fake_rw while
> a write atomic (16) command is executing, the first evaluation could return
> false, bypassing the lock acquisition. If the second evaluation then returns
> true, map_region() would be executed without the metadata lock being held.
> 
> Could this be fixed by caching the result of the first evaluation,
> or checking meta_data_locked instead?

Sure, but this is also a pre-existing problem, since resp_write_dt0() looks
exactly the same.

But sure, can introduce a local variable in all functions that call
scsi_debug_lbp(), so that it is never evaluated twice.


Kind regards,
Niklas
