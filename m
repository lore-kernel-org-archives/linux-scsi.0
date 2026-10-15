Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB373DFC6D
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031926; cv=none; b=WzvphovT0yLbJFRJnOLDITogg81O1j9+CeQoDG+6hEEGLE/C5tNoyyDIKZC0SKOy4aFC9zFjw04Pv3nFFRtxZ+pGzXwAP2Iz/eAaJUROfTxp3Gvvn8qoSpAncb+x0gD3HN91Wf+yA/Ilc22vqe9LpNVXRn8Uupb20G9SeCcsONU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031926; c=relaxed/simple;
	bh=pveojx68NPcbZTl8AmUPgqPlU/XLzJPdyvg2qS1s0hs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=N1iztUeV545aCQ+XMqgTnFGaiGa7O921pAHJDX4qWRQNlEpnkZ59tyoaBg/DJd7bdoccDTtf8O/gE97ROSl6NvOMneARKpck0g6R/0/zTsBUNURxuy3j5V8nLXgRZXw2EdMtSnhTcz/8P+yPrjzOg9Kd5vEVgFiK/vuWB49WHL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DuZdyETm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DuZdyETm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3EB1F000C4;
	Thu, 15 Oct 2026 02:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792031917;
	bh=zTI7/v3zHAqmgLlgyviLX9EEPQ0KBlo1adTLCl429gc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DuZdyETm4QIbTsMwfizMjWrA85tyAVV/lg3VAIAH1jOAE9cLNj70gmOaT4vvTO2yH
	 +Abvko6VFOPzc47nBUyPXISNULznkvsFLHmpNmtwZzOGYImaJKhi/d3+icCe7PTJTE
	 vJlhF1/AyG0FA6bJP3kD3YA8EpXW1hAdgidnFOVh2XIlXp6ZaKLIHkXPtXwNqcOfGG
	 wSLLG7IdUWkPQVds1uYM2owVgzHL1MDSsQMTlWFS0Fcli4ni39I6aOIl9WAlPxgALi
	 oKG40nLNIHD0Sp3AX0YrPQSVx93i2Xu8l7b8tjCdSnur5yawWaylngOTLvCucVFCun
	 esvS6Ir8Be2Ag==
Message-ID: <sashiko-outbox-172162@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 7/8] scsi: mvumi: fix the DMA address rebuilt in
 mvumi_delete_internal_cmd()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015022728.3936714-8-yhlee@isslab.korea.ac.kr>
References: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
 <20261015022728.3936714-8-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 02:38:36 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: mvumi: missing endianness conversion for DMA address SGL fie=
lds
- [High] scsi: mvumi: memory corruption due to trusting DMA memory for allo=
cator parameters
--

commit ef0a8e1f55942bcd0c7bbd2536d73b0f59532840
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: fix the DMA address rebuilt in mvumi_delete_internal_cmd()

This commit fixes a bug in mvumi_delete_internal_cmd() where a 32-bit shift
on baseaddr_h resulted in truncation of the upper 32 bits of a DMA address.
The fix uses a 64-bit cast before shifting to ensure the address is properly
reconstructed for dma_free_coherent().

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 2410d2aa147d9..bd1a8c1d54aeb 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -295,8 +295,8 @@ static void mvumi_delete_internal_cmd(struct mvumi_hb=
a *mhba,
>  			m_sg =3D (struct mvumi_sgl *) &cmd->frame->payload[0];
>  			sgd_getsz(mhba, m_sg, size);

[Severity: High]
Does reading the size natively here cause issues on big-endian architecture=
s?
The SGL buffer size is natively read back from a little-endian field in
device DMA memory without using le32_to_cpu().

> =20
> -			phy_addr =3D (dma_addr_t) m_sg->baseaddr_l |
> -				(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
> +			phy_addr =3D (dma_addr_t)(((u64)m_sg->baseaddr_h << 32) |
> +						m_sg->baseaddr_l);

[Severity: High]
Is it safe to construct this DMA address without endianness conversion?

These SGL fields are populated using cpu_to_le32() but are read back native=
ly.
On big-endian architectures, reading little-endian SGL fields natively yiel=
ds
corrupted values, which could cause dma_free_coherent() to unmap the wrong
address or trigger a panic.

[Severity: High]
Can a compromised PCIe device modify these fields concurrently?

cmd->frame is allocated in bidirectionally mapped DMA-coherent memory,
so an untrusted device could modify sg_counts, size, baseaddr_h, and basead=
dr_l
after they have been initialized or concurrently during cleanup.

Since the driver uses these values directly as parameters for
dma_free_coherent() below, this introduces a DMA double fetch / TOCTOU
vulnerability that could allow arbitrary unmapping of memory.

> =20
>  			dma_free_coherent(&mhba->pdev->dev, size, cmd->data_buf,
>  								phy_addr);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015022728.3936=
714-1-yhlee@isslab.korea.ac.kr?part=3D7
