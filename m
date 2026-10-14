Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA00175A5
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 01:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791941616; cv=none; b=TnqIzDoQsYe4zi4rRTh9ND/JrLOqZ0BdfchO4G3bJqhOr414V/TQPo4h32lw6pypYPvomcTXR8nr9zCZucSjUzwePjmMMtN8p0EdsGzerCKKAL2mlNeeUBD3qFmq8mmFipJrQIccRiHIuCm9hy6TKiYIPQztpZ6EgXLYCJau8zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791941616; c=relaxed/simple;
	bh=Pt8TgWo7TjDAlzFeXryz1EUdS6bIMASqPBBsA05wigo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ABvCwGmfbKxcyheIScTnmtrWS2KjtwFkJT6HCYEQvOOCJIWX8FEPgx5p+W3o9VxEkCBOPqtlPz0oOuxjOEpAbVTUcM45cW4+j7GM8etVFiq3paomNI0nagyfPzce6mrlwAfBIl7hHvXzTccFvTIqZVEyylJ0+Vg9UAWEmblqero=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCzAIUVz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCzAIUVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55181F000FF;
	Wed, 14 Oct 2026 01:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791941614;
	bh=/uiIiWnll154hmG0/buYkBi2vGWOrBd8zy+rGHezBd4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VCzAIUVz7AQNe+WL+RO94gzEKfDBwm9wnsNAX58HFiK9eINaq5lE68YHVrGCaNMdq
	 8xsjS1Nln/Vzn5Cn1ZRrzPAuvofbnMKY1MFFdh21M/KixUSJoQzel6mOX1qLLZ93QI
	 Tr9De4j/kwwPImaPQn+3LhIPz6Oxo3/BT5aXSyInQNY+oI/rTiDCOTnqPfF2sSd+Cz
	 iwxfSSppl9AfhbtICM5ShsA2VaPRem90nvEA4R9q4CyvtfFj5bwT+oEjKS+NdnoUJf
	 IDHMrZBquTFBy08UV40mnH/ATZwwGB2/RP6oaa+nfQrlE/OpWA+JyxZyur2FNaUV+5
	 eO0o7i8EyzekQ==
Message-ID: <sashiko-outbox-170674@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: mvumi: reject handshake sizes that overflow
 the list allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014011808.3479480-1-yhlee@isslab.korea.ac.kr>
References: <20261014011808.3479480-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 01:33:33 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: mvumi: endianness bug and OOB read via find_first_bit on 32-=
bit int
- [High] mvumi: firmware sizes overwrite allocated limits during host reset
--

commit ce35d6361a0f2c7a476f1fd961e2fc0f05fccc6b
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: reject handshake sizes that overflow the list allocations

This patch rejects entry sizes above 29 and list depths of 32 or more from =
the
firmware to prevent shift overflows and out-of-bounds array access. It also
calculates the total allocation size in a 64-bit variable, failing if it ex=
ceeds
UINT_MAX, to prevent 32-bit truncation before memory allocation.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index e70d336b4ab39..e9ba072220331 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -912,10 +912,23 @@ static int mvumi_init_data(struct mvumi_hba *mhba)
>  	unsigned int tmp_size, offset, i;
>  	void *virmem, *v;
>  	dma_addr_t p;
> +	u64 total;
> =20
>  	if (mhba->fw_flag & MVUMI_FW_ALLOC)
>  		return 0;
> =20
> +	/* These are firmware-supplied and size the allocations below. */
> +	total =3D (u64)mhba->ib_max_size * mhba->max_io +
> +		(u64)mhba->ob_max_size * mhba->max_io +
> +		sizeof(struct mvumi_dyn_list_entry) * (u64)mhba->max_io +
> +		160;
> +	if (total > UINT_MAX) {

[Severity: High]
Does this bypass the new bounds checks during a host reset?

During a host reset (mvumi_host_reset() -> mvumi_wait_for_outstanding() ->
mvumi_start()), a new firmware handshake is initiated. In
mvumi_hs_process_page(), structural limits like mhba->max_io and
mhba->ib_max_size are unconditionally overwritten with new firmware values.

When mvumi_init_data() is subsequently called, MVUMI_FW_ALLOC is already
set, causing an early return. This completely bypasses the new
total > UINT_MAX validation and does not reallocate buffers.

If the firmware supplies larger sizes during a reset, the driver will use
the larger bounds to index into the previously allocated, smaller buffers,
resulting in an out-of-bounds memory access.

While reviewing the changes to mhba->list_num_io, I noticed a related issue
in mvumi_hs_build_page():

drivers/scsi/mvumi.c:mvumi_hs_build_page() {
    ...
		if (mhba->hba_capability
			& HS_CAPABILITY_NEW_PAGE_IO_DEPTH_DEF) {
			hs_page4->ob_depth =3D find_first_bit((unsigned long *)
							    &mhba->list_num_io,
							    BITS_PER_LONG);
			hs_page4->ib_depth =3D find_first_bit((unsigned long *)
							    &mhba->list_num_io,
							    BITS_PER_LONG);
    ...
}

[Severity: High]
Does this code cause an out-of-bounds read and endianness bug on 64-bit sys=
tems?

Passing a pointer to a 32-bit unsigned int (mhba->list_num_io) cast to
unsigned long * to find_first_bit() reads 8 bytes on 64-bit architectures.

On big-endian systems, this will incorrectly scan the adjacent 32-bit member
(ib_max_size) instead of list_num_io, writing incorrect ob_depth and ib_dep=
th
capabilities to the firmware.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014011808.3479=
480-1-yhlee@isslab.korea.ac.kr?part=3D1
