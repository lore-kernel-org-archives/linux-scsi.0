Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3513D4A6CD3
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 15:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791820407; cv=none; b=Acdpi+jL+pO9oofaE2z4eGXYhoajR6dKrVnH/lamcru1Jy7ACaIi7pRtg95ZvfSBc0tn3HgPrXU8fuqfGMXAfnyvzPSVI9bzo+IWhKpZ7elQyJpTRcb1WeGKqBy+SMdMu9W509PhCqJ0vGxhwxL/rbPonNS99+04ZztV101BK9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791820407; c=relaxed/simple;
	bh=I/vfXuahEbOReKB1B05NNIeQc4GaV9s5LwwRozztXTk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JEeK2xZdjNYU4+JbmdHqa1eovMgCqDpSsNgvKIB1JwrZMNfpTfUVlaAwy4PygY+jCFB0gtn55PFQhLg2c9nfPQwLG8jomIrXO3YtSGkjj8ydmhOjR7ekIF0bY/6CLogXz2UszaA4YZFyWUXwsXvKSVilnNZIx/LCje+ywz5Rits=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Drbv6CtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Drbv6CtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B661F0089B;
	Mon, 12 Oct 2026 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791820405;
	bh=iGe8NtH9dBvJEh0BeALGL4cVQ2cgcr5MKSt8+4+RBQU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Drbv6CtRrKfBhLP+zilaR67Qz0kl6/pKcRbfeoC4nFDWzbmJ1PXkHxsfrrsoTZHla
	 4A4J/jp15wxRzlnYjbw9tv+RLAYhaqiLcJHezpJ9PD3mELlYvvFjyp0YFedR2tBQIJ
	 f6qgDQtRZOwErXqZswfQH2NsBzWDccfcweVt/RVYak9rEvd6LLDRRIRx5e06MHYXUN
	 jTqgSdim3oSZ3XgqrT2poOGKQXO+gNZYPXJDr7/gpE5RMrHBGiGwIZdoyxPtjb+0t6
	 WQ5lHGzq/pF1ayulN4iBvdAY42C/JtzZZqFkPgxhB9WxqE7QV3xv5MN099sS/KL+GK
	 MB5A9ZEX8sVSA==
Message-ID: <sashiko-outbox-168364@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: target: tcm_fc: reject overlapping write-data
 frames
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012153502.2435483-1-yhlee@isslab.korea.ac.kr>
References: <20261012153502.2435483-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 15:53:25 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] tcm_fc: out-of-order writes fail and timeout due to hardcoded FT_W=
RITE_SEGS limit
--

commit 895d9c49c94e103dd30c9a7fa4435fceca1820d6
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: target: tcm_fc: reject overlapping write-data frames

This commit introduces tracking of FCoE write data segments to prevent
overlapping frames from falsely satisfying the command completion length te=
st,
which could otherwise leave trailing buffer contents unchanged. It tracks
disjoint write ranges in a fixed-size array to reject duplicated payload da=
ta.

> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_i=
o.c
> --- a/drivers/target/tcm_fc/tfc_io.c
> +++ b/drivers/target/tcm_fc/tfc_io.c

[ ... ]

> +/* Record a frame's range; refuse one that repeats data already received=
. */
> +static bool ft_add_write_range(struct ft_cmd *cmd, u32 off, u32 len)
> +{
> +	u32 end =3D off + len;
> +	unsigned int i;
> +
> +	if (off < cmd->write_contig_end)
> +		return false;

[ ... ]

> +		if (i =3D=3D cmd->write_nseg) {
> +			if (cmd->write_nseg >=3D FT_WRITE_SEGS)
> +				return false;
> +			cmd->write_seg[i].off =3D off;
> +			cmd->write_seg[i].end =3D end;
> +			cmd->write_nseg++;
> +		}
> +	}
> +
> +	ft_merge_write_ranges(cmd);
> +	return true;
> +}

[Severity: High]
Does this hardcoded limit reject legitimate, highly out-of-order FCoE frame=
s?

If network packet loss or reordering creates 5 or more disjoint data segmen=
ts
before they can be coalesced by ft_merge_write_ranges(), this code hits the
FT_WRITE_SEGS cap and returns false for a valid frame.

Additionally, is it possible for concurrent receive threads to call
ft_add_write_range() for the same exchange simultaneously?

Since the array manipulation and cmd->write_nseg increments are performed
without locks, concurrent frames could cause a data race, potentially
leading to array out-of-bounds corruption into cmd->work.

[ ... ]

>  	if (frame_len + rel_off > se_cmd->data_length)
>  		frame_len =3D se_cmd->data_length - rel_off;
> +	if (!ft_add_write_range(cmd, rel_off, frame_len)) {
> +		pr_err_ratelimited("%s: xid 0x%x: offset %u len %zu repeats data\n",
> +				   __func__, ep->xid, rel_off, frame_len);
> +		goto drop;
> +	}
> =20
>  	/*
>  	 * Setup to use first mem list entry, unless no data.

[Severity: High]
If ft_add_write_range() returns false due to hitting the FT_WRITE_SEGS limi=
t,
does this silently drop the frame without aborting the exchange?

Because FCP write data is unacknowledged per-frame, the initiator will not
be aware that the target dropped the data and will wait for command
completion. The target will hang indefinitely waiting for the dropped bytes.

Will this cause the I/O command to permanently hang until it times out under
non-ideal network conditions?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012153502.2435=
483-1-yhlee@isslab.korea.ac.kr?part=3D1
