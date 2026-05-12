Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3DA362137;
	Tue, 12 May 2026 10:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778580132; cv=none; b=D5+ehLF1R894U72fRfJGjO9gn12y8n+EgxL0dr1cObfKfSGoivru1Xp8AtpGihdFhPSY9N3BKB3KShPnSOoFs6L/rY6zFDQ/TuLg7iKu8pPnoDb+v6c1vAT2eL/4BTvZ+MIA0XjCfUqViDv3C7OBvJbPqrIgNZFV6VY9ptYMa6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778580132; c=relaxed/simple;
	bh=asGBpettRxHgk9ZG9YyLvuCgwTR3DtLKHkJeHTVpf3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXTYwve6vijl3xVTvjS2eXa+roQj358fSwytL3QlnjJDqKyQb9wpGL4Rt6GZppuF+VobVIK9LvI52brNkUrmbJTmMmFtGZ8v/LXabkXFVhcjoVylwpdOGbzqOX95FoLTju37j5XlPgABAg4b+wNNc9ruCbElVl4dGg7MGemStYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAPJTtI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAPJTtI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C20DC2BCFC;
	Tue, 12 May 2026 10:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778580132;
	bh=asGBpettRxHgk9ZG9YyLvuCgwTR3DtLKHkJeHTVpf3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TAPJTtI+/V1dADNWCrOeiT3VFDemu20Rs6VR/OysJGp19ZBmF8UFJI9g+Iboydalv
	 FipQYy9Pt4sqvcXeU4PcWA1VP7mGnSAaFuSB38TsIdDzGaGmq84VTsb/SuFhMfn8Gl
	 EcMTo0xGiW6lesYb2j/I7QWkqq4x4SukfMJasEV7W5jRTVkFrnbyId23v607IG9pnG
	 9fBrR65hA9ere453/E0iIT2+L3/cNi53wYcoY6puUUFCVC9siUrx7uCXvwLvkbBL66
	 Jmn5g3w2VDKadZVbMizPLM9mjHLEARxqxIdlA8m1XytdI+Mx6UADTlYGkD+uYqMgVS
	 4/J1AECE7V7gg==
Date: Tue, 12 May 2026 12:02:07 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 1/7] ata: libata-scsi: add atapi_max_lun module
 parameter
Message-ID: <agL6n9aXd84YPgFA@ryzen>
References: <20260506234548.1974603-1-philpem@philpem.me.uk>
 <20260506234548.1974603-2-philpem@philpem.me.uk>
 <7f7126d4-0c8d-4f88-9ece-5bbfac2b47c7@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f7126d4-0c8d-4f88-9ece-5bbfac2b47c7@kernel.org>

On Tue, May 12, 2026 at 10:46:39AM +0900, Damien Le Moal wrote:
> On 5/7/26 08:45, Phil Pemberton wrote:
> > Until now libata has hard-coded shost->max_lun = 1 for every ATA host,
> > so the SCSI layer never scans past LUN 0.  This blocks support for
> > the small handful of multi-LUN ATAPI devices (Panasonic LF-1195C and
> > COMPAQ PD-1 PD/CD combos export CD on LUN 0 and PD on LUN 1; old
> > Nakamichi MJ-x.y CD changers expose one LUN per disc slot, up to 7).
> > 
> > Introduce a libata module parameter, atapi_max_lun, that controls the
> > upper bound of the per-host SCSI LUN scan.  Default is 1, preserving
> > current behaviour exactly: out-of-the-box only LUN 0 is scanned.
> > Range is clamped to 1..ATAPI_MAX_LUN (8, the SCSI-2 ceiling).
> > 
> > Subsequent patches gate actual LUN>0 probing on BLIST_FORCELUN, so a
> > device must both be on the SCSI device list (or carry the appropriate
> > quirk) and run on a host whose atapi_max_lun has been raised before
> > any extra LUNs are scanned.
> > 
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> 
> Looks good, but this does not apply to libata tree for-7.2 / for-next branch.
> What is this based on ? Please rebase and resend as I would like to run some tests.

Tip:
When using "git format-patch" you can specify --base <SHA1> and
then the base SHA1 will be added at the end of the cover-letter.


Kind regards,
Niklas
