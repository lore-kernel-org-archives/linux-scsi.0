Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C7823A99F
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 18:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790445788; cv=none; b=lI/8qmb/vMnKPLblYLOW0uPtxSrViXBIFcwlKXPsaU+dNaLE4AG316rs8C4daCncKKgXJjd09/ecN+5iAmYoPzwMqwoeeCDiARfrz7g7SQjT9ngqwdGn83Q0NHNz8yoiQwtgfEhB4VOldPQ0L9J3x2QgyQYHxzVWLMz2uGTffxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790445788; c=relaxed/simple;
	bh=PleGiJsiVojBzWe0vTGyghogv1SzUvyglPyTbjW4nqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pvMWu8KiuIOTlRVxYfXi4xFocU8+1AYaJjVyzxEydJwK+qjmw36Ljhd2VRWeCHjx76GU5+WuLcZRGE1QJPMGN3UGPsl90D5s73I2AS8cdmAd3peu0BcAZBzG8zMbK3pvDsTMUbfs+XgzfKrp2i+5tG0Z/T5cGQfJckHqz5PrxlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5QAuYbG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5QAuYbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813041F000FF;
	Sat, 26 Sep 2026 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790445786;
	bh=djbgl0N/7SYxF5EavywWRvr/CN96IU4ujqacJIwI7MA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g5QAuYbGzyspS2GvFkDUEeh6UgYRpQMPgtbTT3AKIsAdEC2hCf490L7yfqLCYZCMa
	 1IGgPERk122BA3goA0QMbbXBVeWF9TqwkfJq2nqZXrOh+t4vORORKZp1E1tyVwXvvy
	 nSMfiVuYcb3IYRlbl+1SmoZyPEF7QUVihsDrDBbTvWEmqJL7NeWzMaMtQca+vgvpvl
	 TXvBvaQkMsn4030J/kz3PjEaf3eAxqxc0SzbbeM0xnPNoxqzTEp1otqwfCGH7KfuCy
	 ocUEVewHIO2yT5W3iJ82pKf2jm9hF72LmtlVMH8FadDSYQYGDyxDQ6M8Cq2qFGezkm
	 8GXQFOXhccHVw==
Date: Sat, 26 Sep 2026 20:03:03 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v7 09/11] scsi: scsi_debug: Refuse a short WRITE ATOMIC
 (16) before writing it
Message-ID: <argI11P7AhIlfKXa@ryzen>
References: <20260925071726.140915-13-cassel@kernel.org>
 <20260925071726.140915-22-cassel@kernel.org>
 <3fc3aab6-9eca-4d3e-81ea-92ee56de2af5@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fc3aab6-9eca-4d3e-81ea-92ee56de2af5@linux.dev>

Hello John,

On Fri, Sep 25, 2026 at 10:30:11AM +0100, John Garry wrote:
> > ---
> > Tested with:
> >
> >    modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
> >        atomic_wr=1 lbpu=1
> >
> > issuing a WRITE ATOMIC (16) of eight blocks through SG_IO with a buffer
> > of four blocks of 0xaa. It fails with DID_ERROR before and after this
> > patch, but before it the first four blocks read back as 0xaa afterwards,
> > and after it all eight read back as they were. A WRITE ATOMIC (16) with
> > a full buffer writes all eight blocks, as before.
> >
>
> What is the command which you use?

SG_IO, with a CDB for eight blocks and a buffer of four:
sg_raw -s 2048 -i aa4 /dev/sdX 9c 00 00 00 00 00 00 00 00 40 00 00 00 08 00 00


>
> I am just wondering if this check should go into sd_setup_atomic_cmnd() or
> somewhere else higher up. I mean, this check is not really specific to
> scsi_debug, right?

sd can't produce a short atomic write: sd_setup_read_write_cmnd() derives
nr_blocks from blk_rq_sectors(), and the data buffer is the same request,
so the transfer length and the buffer always match.

A mismatch is only possible through SG_IO, where the caller supplies both.

SBC-6 4.28.2 puts the requirement on the device server: a failed atomic
write must leave the LBAs unaltered. scsi_debug is the device server here,
so I think this is the right place for it.


Kind regards,
Niklas
