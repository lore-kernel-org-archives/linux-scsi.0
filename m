Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980A0377A95
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 14:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814233; cv=none; b=q3cZkhbPd4mAov2qfB3jsWEHXhpbXkY5pnlrVTCuppMA3vizOhs9kmCNg7C022ZlGvplh+5NNXI+vvTjrQ0XVqavItNniRlX8th1Cw/zve9T4AUXK7VET1yyQ3G/Pl85jAwbxXGFyHx44Paf8BqU7ta1+ivXyt8hz4lwDk8q4I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814233; c=relaxed/simple;
	bh=zMvvsco1k45K9VrkXsSxDvZCI3X2d46mbDd1wjjoE8Y=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mAKky9/2lRHOmUU7atOMTe0EvipsxIdPH1GoR3t7HirHEa9JHTtWoAw+fpkJVq/I7S3ip/gdOMAz5QP7SHtD3/Bcg7JqD/2W/ZEV4Q0s/TuPefkL4Av+a/UQJFNwS88Ic5OcMEGRD+qy962sP2+L3dXPJpQR1NOCgbnJjhZ7cK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWTJ5+3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWTJ5+3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B1A1F0089B;
	Mon, 12 Oct 2026 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791814232;
	bh=72Lz3ADKy7wQV6JIRunD82RiO/gUK35RmIQNtQEtxjE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LWTJ5+3OFo631DlgpqzAMMCz4FFxeYJ0+zjFX38RFfyLwywznzr6SHg99q87XgOmI
	 2N63WaUpZabwD+cSiDjLlVXNaba9CFwoVgC+Tm3GjxMdX5orRGoi29wYHT4DMLi/5M
	 q8VlqUjzKSPF25mSDMqEKMHFcbCyV9HSwkJMubbmPoBJ8wVA8KazbZPy27hGVUuLSb
	 kuJpjKiAHwyINHB34OnTERTztuQNrjCagHmaUqFPGnXo0MZIkZSCyD5J2MO277og5v
	 8dAXQlAsOGYdHY4hY31Njf7CK1YQpWGxw2Oc4AvjbZqzjFygYI2FXmVregBUX/naoo
	 oUCqfRh0bN7sg==
Message-ID: <sashiko-outbox-168243@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: tcm_fc: reject overlapping write-data
 frames
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
References: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 14:10:31 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] tcm_fc: missing segment merge causes premature exhaustion of wri=
te_seg array
--

commit 0b59be7f471ca24ee5e88d2fb9a9cd36b483ea6a
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: target: tcm_fc: reject overlapping write-data frames

This patch tracks received write ranges for out-of-order FCP frames to
drop frames that repeat already received data. It introduces an array to
hold disconnected segments, preventing overlapping frames from leaving
unwritten gaps in the data buffer.

Fixes: 3699d92a4d7b ("[SCSI] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FC=
oE target (TCM - target core) support")
Cc: stable@vger.kernel.org

> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_i=
o.c
> index 45329284f52f5..53d7c7268865d 100644
> --- a/drivers/target/tcm_fc/tfc_io.c
> +++ b/drivers/target/tcm_fc/tfc_io.c
[ ... ]
> +static bool ft_add_write_range(struct ft_cmd *cmd, u32 off, u32 len)
> +{
[ ... ]
> +	if (off !=3D cmd->write_contig_end) {
> +		for (i =3D 0; i < cmd->write_nseg; i++) {
> +			if (cmd->write_seg[i].end =3D=3D off) {
> +				cmd->write_seg[i].end =3D end;
> +				return true;
> +			}
> +			if (cmd->write_seg[i].off =3D=3D end) {
> +				cmd->write_seg[i].off =3D off;
> +				return true;
> +			}

[Severity: Medium]
When an out-of-order write frame extends the boundary of an existing tracked
segment, does returning true immediately bypass any logic to check if this
extension makes the segment contiguous with another tracked segment?

If adjacent segments are not coalesced (unless they directly touch
cmd->write_contig_end), could this tracking array artificially waste slots =
on
segments that are now adjacent to each other?

> +		}
> +		if (cmd->write_nseg >=3D FT_WRITE_SEGS)
> +			return false;

[Severity: Medium]
Due to the missing merge logic mentioned above, could the array remain
artificially full of adjacent segments, erroneously triggering this limit
and dropping valid incoming data frames?

If an initiator sends heavily fragmented out-of-order frames, the array
could quickly fill with unmerged adjacent segments. Would subsequent
valid non-adjacent frames then be dropped with a misleading "repeats data"
error, potentially causing FC sequence timeouts, FCP exchange aborts, and
transport layer failures on the initiator?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/506886f3051941899c2=
6b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr?part=3D1
