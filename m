Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00164B1D1C
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 10:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727126; cv=none; b=ZRAxcSdCba3YXLfIu3sme574RyEzRtIvhdLqozZywx+qascg7v3ezZNmq96rKCAdYv00kV/7FlUFWSiaNy3NIVlBEagxU+Hs1KrT5hbATUAA34z0prYj+P4/QPg7CfiHwlkxlgKwDji58sPBW85lLZ9exOa8mYxoE2vx83PKTo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727126; c=relaxed/simple;
	bh=SMBW1jowDItIUfRQjcyaOwTTuXLFDwAQLqszf+kipiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anprIMK1dbWnIczojRjhwzictvyvXN8nkcJolDpxr+vQValhd+S5ebPobQwrxtAqs1W8AmLX8NcUseeP9rLMEnhTbTsnzue4nU1cDkGefUTl66+FgxO+KYEORkBanLGj/IsbFXgsQRT3u5NOkJtua2rnknjMo0uaPQioBfU1eEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2IPEzwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2IPEzwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259A31F000FF;
	Fri, 18 Sep 2026 10:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727124;
	bh=EvAMJnU6aQGtL6+wKmfBubz+sLqG55hHcszVOv7wINo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B2IPEzwIsoRizLaQV1FBPmNSDB05xUjYWz2klwfJYKqtOjXQZWXg80kpTm6uliAZM
	 vDIXvoUC8WG86dBnbpt0tERxYb0zF0vVxogJiXqYO7m8KqVgHl631AS3sJAjuKbXYC
	 IL8aWgHIeqqleSZUghU/rbzggofXdDvv+PgyoPqsme/nx79QJY5mJs9cx9zukt6hHN
	 1lLbAE7Da9eoG9XCO94HUlmuEi343It506bByQjdVuG+l6SJbub/rPm4IOGA1oF3Xx
	 SH8veGjVtKsq9v0erwFf7aFzbMDFw8KH5z/enMEs7E43s4aLZTwkN9ADTvHQvec3mG
	 Er7/ZI9R8E3wg==
Date: Fri, 18 Sep 2026 12:25:20 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>
Subject: Re: [PATCH v4 07/10] scsi: scsi_debug: Do not write a partial
 physical block to a zoned device
Message-ID: <aq0RkLjApqzC96mP@ryzen>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-19-cassel@kernel.org>
 <cbae6ecb-21da-4fac-8a44-ba9072009159@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbae6ecb-21da-4fac-8a44-ba9072009159@kernel.org>

On Fri, Sep 18, 2026 at 04:31:23PM +0700, Damien Le Moal wrote:
> On 2026/09/18 13:29, Niklas Cassel wrote:
> > do_device_access() copies one logical block at a time and stops at the
> > first short copy, so when the data-out buffer is smaller than the
> > transfer length of the command it can write part of a physical block.
> > An initiator can arrange that with SG_IO.
> > 
> > A write that does not end on a physical block boundary is perfectly
> > acceptable to a device that is not zoned, and to a conventional zone,
> > where the device reads, modifies and writes the physical block that the
> > write falls in. ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2, does require
> > a write to a sequential write required zone to end on a physical block
> > boundary, though, so a partly written physical block is not a state that
> > such a zone can be left in.
> > 
> > Stop at the last whole physical block that the buffer holds, for a
> > sequential write required zone only. The bytes that are left over are
> > not written, and are reported to the initiator as part of the residual.
> > 
> > With the default physblk_exp=0 the physical block size equals the
> > logical block size and this changes nothing. Nothing changes either when
> > the buffer holds all of the data that the command asks for, so a command
> > that transfers fewer logical blocks than a physical block is unaffected
> > wherever it is legal.
> > 
> > Assisted-by: LLM
> > Signed-off-by: Niklas Cassel <cassel@kernel.org>
> 
> A bit shift would be nicer than a division... But nevertheless, looks good.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Sure, will apply the following change for this patch:

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5ae1241e4d8b..bbd675ca47f2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4313,7 +4313,8 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
                struct sdeb_zone_state *zsp = zbc_zone(devip, lba);

                if (zsp->z_type == ZBC_ZTYPE_SWR) {
-                       u32 avail = (sdb->length - sg_skip) / sdebug_sector_size;
+                       u32 avail = (sdb->length - sg_skip)
+                               >> ilog2(sdebug_sector_size);

                        if (avail < num)
                                num = round_down(avail, 1U << sdebug_physblk_exp);


And the following change for patch "scsi: scsi_debug: Advance the write
pointer over the data written":

@@ -5184,7 +5185,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
        /* If ZBC zone then bump its write pointer over the data written */
        if (sdebug_dev_is_zoned(devip) && ret > 0)
-               zbc_inc_wp(devip, lba, ret / sdebug_sector_size);
+               zbc_inc_wp(devip, lba, ret >> ilog2(sdebug_sector_size));
        if (meta_data_locked)
                sdeb_meta_write_unlock(sip);
 
@@ -5350,7 +5351,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
                ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
                /* If ZBC zone then bump its write pointer over the data written */
                if (sdebug_dev_is_zoned(devip) && ret > 0)
-                       zbc_inc_wp(devip, lba, ret / sdebug_sector_size);
+                       zbc_inc_wp(devip, lba,
+                                  ret >> ilog2(sdebug_sector_size));
                if (unlikely(scsi_debug_lbp()))
                        map_region(sip, lba, num);
                if (unlikely(-1 == ret)) {


when respinning.


Kind regards,
Niklas
