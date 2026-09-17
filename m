Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858F4545D9A
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789652860; cv=none; b=hoqvtoO7CN1yqvPVhguGyveUID0qnA66Bf3ZqUUvkqyY5n+t3zSMGg6n4upks9qo2yGHwIZrAogl/lM8t1paySkfZaXS1ZBr3ao1ZKdt+ygkX0w5NQp7sRlHAi+/EI1EBXZQOTorwswKmoBm4tiXfEavd0tt7kI9r4UFnQqk+/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789652860; c=relaxed/simple;
	bh=CobPfU3xRLRMPlVOuHsj/nqx5bFH7jfPnEnbf+p/+VY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P2T/8VknE4eriQJzomAPbovIkvlIpao032MmeP5jaFVi9qtrtJOYt+OmjA/slpxNyNiRamxCUX30oFFQPpqItUJATDXsZ1G73BR2KnggbX4yY9gj+uLYMKtNpSCiAuWHk+394/ycaBDZLXZzl54TnDwJIUBuIs6hp9p6XM3yr8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGVW58Ql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGVW58Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180741F000FF;
	Thu, 17 Sep 2026 13:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789652852;
	bh=/5Q/An/b1y2iyY6/Awd0thJRsrkDJKLijMDfKbePjcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZGVW58QlwgaoXytaJgkbmQsCeNpZWjlQfDSIz8JuYfZHJQ3WF2svTIbUJ07FkEK0Q
	 xPYbj0pSIlucBz0+c8g5qo5AFI51budgzO6AR8kPAT/Up2smON+70nupfd679H982q
	 2eli5TPmgJHhcu2F4gekCxOMfZeWqFzuFAW7HMPELKlMibAmPgQJvk3HZN6tkgD+We
	 8UkkYlHIJWwtPJ2mxV009QbiK9SPUYQRLxFPkK37NqFMPMvoUip5n8M0T+rh6wliGY
	 9KEhSTydr4WUqwfieBzHsLG3ceHBDmZTCM2ArXusmE0phRKuE95sLDRfBPhNKU1JHD
	 rA8eDREekJM2A==
Date: Thu, 17 Sep 2026 15:47:28 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>
Subject: Re: [PATCH v3 2/6] scsi: scsi_debug: Do not write a partial physical
 block
Message-ID: <aqvvcEUo1u_6BqJS@ryzen>
References: <20260917125445.1376493-8-cassel@kernel.org>
 <20260917125445.1376493-10-cassel@kernel.org>
 <72659c27-3742-4760-8a5f-46d65ccf4012@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72659c27-3742-4760-8a5f-46d65ccf4012@kernel.org>

On Thu, Sep 17, 2026 at 08:11:39PM +0700, Damien Le Moal wrote:
> > @@ -4290,6 +4290,19 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
> >  
> >  	fsp = sip->storep;
> >  
> > +	/*
> > +	 * A data-out buffer that does not hold all of the data that the
> > +	 * command asks for is written up to the last whole physical block
> > +	 * that it does hold, so that a partial physical block is never
> > +	 * written. The bytes that are left over are reported as a residual.
> > +	 */
> > +	if (do_write) {
> > +		u32 avail = (sdb->length - sg_skip) / sdebug_sector_size;
> > +
> > +		if (avail < num)
> > +			num = round_down(avail, 1U << sdebug_physblk_exp);
> 
> Nope, that is not correct. physical sector unaligned writes are OK with regular
> disks. They are not for ZBC, but we should check that in
> check_zbc_access_params() I think.

Patch [4/6] scsi: scsi_debug: Enforce physical block alignment of zonedwrites

does add a check for SWR zones, and for SWR zone only, which errors out if
the write is not aligned to the physical block size.

However, in the case of a short data-out buffer, the request is valid, so I
don't think that check_zbc_access_params() is the right place for the above
check.

But you are right that the check in do_device_access() should be gated on
SWR zones as well...


Something like this:

@@ -4263,6 +4273,8 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
        u64 block;
        enum dma_data_direction dir;
        struct scsi_data_buffer *sdb = &scp->sdb;
+       struct scsi_device *sdp = scp->device;
+       struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
        u8 *fsp;
        int i, total = 0;
 
@@ -4290,6 +4302,23 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 
        fsp = sip->storep;
 
+       /*
+        * For SWR zones, a data-out buffer that does not hold all of the data
+        * that the command asks for is written up to the last whole physical
+        * block that it does hold, so that a partial physical block is never
+        * written. The bytes that are left over are reported as a residual.
+        */
+       if (do_write && sdebug_dev_is_zoned(devip)) {
+               struct sdeb_zone_state *zsp = zbc_zone(devip, lba);
+
+               if (zsp->z_type == ZBC_ZTYPE_SWR) {
+                       u32 avail = (sdb->length - sg_skip) / sdebug_sector_size;
+
+                       if (avail < num)
+                               num = round_down(avail, 1U << sdebug_physblk_exp);
+               }
+       }
+
        block = do_div(lba, sdebug_store_sectors);
 
        /* Only allow 1x atomic write or multiple non-atomic writes at any given time */



Kind regards,
Niklas
