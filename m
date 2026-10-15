Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1F61AAE28
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 05:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792040609; cv=none; b=XOLUBN24c0zj8WBLD54Ma7FkoARPN6zPBdwV+KkQM7utNSRxNv0npkY0DKOz5d5BDAcUT3AjM6AuSDFyvOZa/hQ2IcZz+xH9xB/NcsxnS+wQMYsJklXUbeWg6P3rs2gBseIYRs19vwxCP+9BumJ0RAxfUzKfAhpMo/YfUiwVqiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792040609; c=relaxed/simple;
	bh=n9/0zZTmIuR/APxUqLP1beG8X3XmRWPPw3ZRs1DbZ0Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=duxcwVBkrp+leFO5A6otwxL6aJy3hpVVQ3awi7tWUWUEyXljusUTDekR0laR6Nw3ArEGh87CPg4t4lqwGbf3gALDCDufSL/05AGs2l7dBos496gSR9vwCl7956S0XWlvOZX/x4X8zHU/CskUUYjXgrDsYYHSOoM1PGhOh6LmVSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5bGX0VD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5bGX0VD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1794C1F000C4;
	Thu, 15 Oct 2026 05:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792040608;
	bh=Kqr8KhrZxuaDqJUd8R2juUdGsl/K+2szwxmqxNx3YYs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d5bGX0VDSMRPF7GZu/X4FV/mWm+368EMXn6jXvQwfIfygaGrxtvgtF32HA//eNAVU
	 XsoHZk3cVowwjuX/zQzHBOWeubHXSZX7vEHWpq6BAfk+xPGAmJx+Drj1tOHsIJaCFc
	 TmsTtk4FA1FGYHY1vkCof/UkpS+FIMmz+T7VmVwNcYg1BH01ZAbugKSGmiy3Ip8S2x
	 Uj6ZI+Yb3MT9UEhoX5bj2KglAYeaAr13Ot5UAdN2qv5UQolFwra6kSvkQUwX6uf8fc
	 FtiKiuOIma3wL3xWsDRTAKzfwTLIcEJyx7Y91fv245jYL3cWzhQpRvhkzB5pr/YTXt
	 FQsh4es8fpbmA==
Message-ID: <sashiko-outbox-172292@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 7/9] scsi: mvumi: free the internal command buffer by
 what was allocated
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015045213.3975845-8-yhlee@isslab.korea.ac.kr>
References: <20261015045213.3975845-1-yhlee@isslab.korea.ac.kr>
 <20261015045213.3975845-8-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 05:03:27 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mvumi: DMA Use-After-Free on internal command timeout
--

commit a045f4b7ba7499dba25350d8e9d333f7c9956722
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: free the internal command buffer by what was allocated
   =20
This patch stores the DMA buffer address and length directly in the
mvumi_cmd struct instead of reconstructing it from the command frame.
This avoids an issue where a 32-bit shift in mvumi_delete_internal_cmd()
caused the upper 32 bits of the DMA address to be truncated.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 2410d2aa147d9..133e53bc2cb37 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
[ ... ]
> @@ -286,21 +288,10 @@ static struct mvumi_cmd *mvumi_create_internal_cmd(=
struct mvumi_hba *mhba,
>  static void mvumi_delete_internal_cmd(struct mvumi_hba *mhba,
>  						struct mvumi_cmd *cmd)
>  {
> -	struct mvumi_sgl *m_sg;
> -	unsigned int size;
> -	dma_addr_t phy_addr;
> -
>  	if (cmd && cmd->frame) {
> -		if (cmd->frame->sg_counts) {
> -			m_sg =3D (struct mvumi_sgl *) &cmd->frame->payload[0];
> -			sgd_getsz(mhba, m_sg, size);
> -
> -			phy_addr =3D (dma_addr_t) m_sg->baseaddr_l |
> -				(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
> -
> -			dma_free_coherent(&mhba->pdev->dev, size, cmd->data_buf,
> -								phy_addr);
> -		}
> +		if (cmd->data_buf)
> +			dma_free_coherent(&mhba->pdev->dev, cmd->data_buf_size,
> +					  cmd->data_buf, cmd->data_buf_phys);

[Severity: High]
If an internal command times out in mvumi_issue_blocked_cmd(), the function
returns without explicitly aborting the hardware operation or resetting the
controller.

The callers of mvumi_issue_blocked_cmd() (such as mvumi_inquiry(),
mvumi_flush_cache(), or mvumi_scan_events()) then immediately invoke
mvumi_delete_internal_cmd(), which unconditionally frees the DMA-mapped
command frame and data buffer back to the system.

Since the hardware is unaware that the software has abandoned the command,
can a delayed completion cause the hardware to write to the freed physical
memory, resulting in a DMA use-after-free and memory corruption?

>  		dma_free_coherent(&mhba->pdev->dev, mhba->ib_max_size,
>  				cmd->frame, cmd->frame_phys);
>  		kfree(cmd);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015045213.3975=
845-1-yhlee@isslab.korea.ac.kr?part=3D7
