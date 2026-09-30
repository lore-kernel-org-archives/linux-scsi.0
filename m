Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB49EEC3
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 07:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753287; cv=none; b=dcIwIoyEIlyIjzfv+ueO8d0L/tbyRons6aD3nlHDF/6mnKhe8UZmF/tc/1B/yAZXTBnShDpsY7U1TAVx5aEftmNoxrjP2Q3LKpVapzjNqFUBBW4HOz1Rvwh5W6qcjZWapVqnE2Tv+ExypsPl+AEZAGBA56XfQYJuB6+h7PndmJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753287; c=relaxed/simple;
	bh=ISgmzvabvYuvLTib2LoopgelJARXyor+yD20n4y8jkY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rWXsoiyoQF+6uvvKWMCZCEBzgl1V61zv5atT2SDqa1zHwaDEPxZalswtUTrtcpXv0WhLKqTBN9dk1375IsRvSazs3UMKT2921KPQ0ZF8GXSWmK8AowiHtyhgh1VezSF8rZqdOgFBikUzB+b4v0MBrfP8y79yLvHueBe8MzBLAsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QskCLPhz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QskCLPhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE281F00898;
	Wed, 30 Sep 2026 07:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790753286;
	bh=0MbGo6WqS5DvJ7crHY2gQm/Sd6yRnYRBG3FG4NuxnL0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QskCLPhz5HuHpRrZK/nIf/tMEmEsyUqP6xcPJBZORBo89R5w39/X8vwRBhKT8QXb2
	 fwbZyKvS2u5Ll1DqSK1OTTDOXIhEnJ92nMC+iMDSsv0giQYjPbczcXmw8nxHk2oe8z
	 m3FL3XVT07xai01vp57VTs/urqjoT9j2LzKvOwVHKZm4t0cctCruw9YyFV+uQlYrEY
	 Simg4Ez0E1tue9oTYgReTXS6PRyUAGSZKhrDYgjRlUdDuAaFfjM3JxStedESfCmiNa
	 Bi/jE6vNWTOCFFOZZJbW0XELR4FsnABkwzxvj3SATG7UTFaYvhGMwaCW9kLmMuAC9c
	 S/iiJGYEDZFNQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs: Serve the device init reads from one
 aggregated read
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hyeoncheol Jeong" <hyenc.jeong@samsung.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <1653986196.21790747102619.JavaMail.epsvc@epcpadp1new>
References: <20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p1>
 <CGME20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p2>
 <1653986196.21790747102619.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 07:28:05 +0000
Message-Id: <20260930072805.DBE281F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ufs: unaligned memory access in ufshcd_agg_group() crashes on bad =
device input
--

commit 8bc3a3d567bfb8009dd9c20e3fdb96ed162e1ae5
Author: Hyeoncheol Jeong <hyenc.jeong@samsung.com>

scsi: ufs: Serve the device init reads from one aggregated read

This commit introduces an aggregated read mechanism for UFS 5.0 devices to
fetch attributes, flags, and ID-strings in a single query during device
initialization.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c18b4784a3595..028f0179ee8be 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> +static const u8 *ufshcd_agg_group(const struct ufs_hba *hba, u8 type,
> +				  u16 *group_len)
> +{
> +	const u8 *packet =3D hba->agg_packet;
> +	u16 packet_len =3D hba->agg_packet_len;
> +	u16 group_off =3D 0;
> +
> +	while (packet && group_off + QUERY_AGG_GROUP_HDR_SIZE <=3D packet_len) {
> +		const struct utp_agg_group_header *hdr =3D
> +			(const void *)(packet + group_off);
> +		u16 next_group_off =3D be16_to_cpu(hdr->next_group_offset);

[Severity: High]
Does this code safely handle unaligned memory accesses?

If a malformed or untrusted UFS device returns an odd next_group_offset, the
loop adds this odd offset to the base pointer, and the next iteration will
attempt to read the 16-bit hdr->next_group_offset from an unaligned address.

This will cause a kernel panic on architectures without unaligned access
support. Should get_unaligned_be16() be used here, or should the
utp_agg_group_header struct be marked as __packed?

> +		u16 payload_off =3D group_off + QUERY_AGG_GROUP_HDR_SIZE;
> +
> +		if (next_group_off && (next_group_off < payload_off ||
> +				       next_group_off + QUERY_AGG_GROUP_HDR_SIZE > packet_len))
> +			return NULL;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1860250540.01790752=
381858.JavaMail.epsvc@epcpadp2new?part=3D2
