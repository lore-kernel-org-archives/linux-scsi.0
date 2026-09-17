Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCCF3D413F
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 10:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641748; cv=none; b=ef9XgUC9UJdQKGmnJr2wMVwagB/EqddbaeINBZDEcqRkTuu7uArPDIOFhRyGnY55PxDvHl9fQubD2BCqoZW0WEnboDB3XGJ5q6UFdlrEqpTX3NxQuZvrnjfYaVZp4iCKqTjjER7c3zAPos2hzOxvAxnGbg9NAzUmehuWufNr3+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641748; c=relaxed/simple;
	bh=XK0Tw2LgDynPYnsdV1IRONZ4fY12JEvokKR/op0Y0X4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bb6EgU2+qva00zGgLhEVoWGHu3mfzLajta+VfxWnpYKI8BNxlGQoQufcdGzdWjI6wmKZNPvLp0vG5KwwD3pAvgOnOQiPzquz3lToR1b5hrCGki1EBQeM7Tozg/2bVuh69dOMN8cUwHH0Tzk3/m4nS5XOHQGDJTVJ4OZX2/hochQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ni+PgGFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ni+PgGFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935411F000FF;
	Thu, 17 Sep 2026 10:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789641746;
	bh=+mYZC/dJQ0HeqT+vs6cJ8SrlPv/WSMduVWw80CzhvFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ni+PgGFRW15mj5uSGogGWGYcjDP2TvCbYNx/z2p1mXx49GQHNT+siMXsEK0t75j3m
	 VORp5S7TqZdj7ompzfx9rsrpEWsRbCxlJcipZIb4EwlhvynCTDctSkSC2+e7FRm5Bn
	 2ohEl0lrzHWijvkszYkbii/sczSGf+jEQbSw0PkHsxhnwGrIIJRtEuyMa9KTtTeXny
	 6tGRKYoyETOjkfSFanUFcXjtzPBJBQSIxH3Xbas0i5IP09P2shOwgKH30jaKVMaGI5
	 qv8XQ3vxzkGrwbRscmKX9I+r45PnHQTD6wKcrVdvWmxRiRBP0Dq/qvwo3NUFY/c5Ea
	 1aGAgNiRvbFfQ==
Date: Thu, 17 Sep 2026 12:42:23 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>
Subject: Re: [PATCH 1/2] scsi: scsi_debug: Enforce physical block alignment
 of zoned writes
Message-ID: <aqvEDwt5b2-LsIG6@ryzen>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-5-cassel@kernel.org>
 <b7472e4a-cf81-4e3d-b44a-94b06214ca5f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7472e4a-cf81-4e3d-b44a-94b06214ca5f@kernel.org>

On Thu, Sep 17, 2026 at 04:05:54PM +0700, Damien Le Moal wrote:
> On 2026/09/17 15:45, Niklas Cassel wrote:
> > ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2 Write access pattern
> > requirements for sequential write required zones, states:
> > 
> >   The device server terminates with CHECK CONDITION status, with the
> >   sense key set to ILLEGAL REQUEST, and the additional sense code set
> >   to UNALIGNED WRITE COMMAND a write command, other than an entire
> >   medium write same command, that specifies:
> >     a) the starting LBA in a sequential write required zone set to a
> >        value that is not equal to the write pointer for that sequential
> >        write required zone; or
> >     b) an ending LBA that is not equal to the last logical block within
> >        a physical block (see SBC-5).
> > 
> > That is why sd_zbc_read_zones() sets the zone_write_granularity queue
> > limit to the physical block size of a host-managed device, exposing the
> > constraint to user space.
> > 
> > check_zbc_access_params() implements condition a) but not condition b):
> > it verifies that a write to a sequential write required zone starts at
> > the write pointer of the zone, but never validates the ending LBA. As a
> > consequence, when scsi_debug emulates a host-managed device whose
> > physical block size is larger than its logical block size, for instance
> > with zbc=managed sector_size=512 physblk_exp=3, a write of a single
> > logical block at the write pointer of a sequential zone is accepted and
> > advances the write pointer by one logical block. The write pointer is
> > then no longer a multiple of the zone_write_granularity reported for the
> > device, so nothing can write at it at the granularity that was
> > advertised, and the zone can only be used again after being reset.
> > 
> > Implement condition b) as well, with the same sense data as the write
> > pointer check, as the standard gives both conditions the same sense key
> > and additional sense code. The exclusion of an entire medium write same
> > command needs no special case: such a command spans the whole medium, so
> > it is already terminated with WRITE BOUNDARY VIOLATION by the preceding
> > check.
> > 
> > The check is placed in check_zbc_access_params(), which every command
> > that advances a zone write pointer reaches first: WRITE, WRITE SCATTERED
> > and WRITE SAME. Reads return earlier in the function and are unaffected.
> > 
> > Sequential write preferred zones, which are emulated for host-aware
> > devices with zbc=aware, are left alone: writes to them are not required
> > to be sequential, and Linux does not restrict the write granularity of
> > host-aware devices.
> > 
> > With the default physblk_exp=0, the physical block size equals the
> > logical block size and the new check is a no-op.
> > 
> > Assisted-by: LLM
> > Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> > Signed-off-by: Niklas Cassel <cassel@kernel.org>
> 
> Looks good, but that will be another conflict with linux-next...
> May be rebase the fix on scsi-staging and let's push it to 7.4 instead?

Considering that the fixes are only for a moduled used for debug,
I can do that.

Will rebase on mkp/7.4/scsi-staging


Kind regards,
Niklas
