Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5B034574B
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 06:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784184216; cv=none; b=cnsUmDbKbU1lioQfuXW4P06jX3ZS+vrkyhDXn27tHx7w6TgxWlKYaL+7OhmwR5rQs2UbzWfsrIqNnkbJ9ruqiuQX9Oy6EmMe+oHmYj9UcGhiul9tDPpjhvdjoofhvqCd6mZhpWEKxyQGvbSOU3et5u1iAZtJKRpmT4WPz6fL/GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784184216; c=relaxed/simple;
	bh=nBWBfJOS1l3h5yJl7BpBmNei8YzZOQD8jn9OC2qTeDQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Iz9QB7wvZA9O1KpEQ1uBRUDN3vzb3yF4PExEwe3PhZBPqQXdaz/QJ/i2L2Vxt2pejDw5f+m4N7zOAM39oLUru+6MGPcX1QLC7u2unFfveIzOw75DCAfJfgT8Ng/Bl6L3xC2IBW+9NuG1FC0IP61ge0EAgCO9lWDiNlxDH0zd7tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFyhBDC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFyhBDC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6071F000E9;
	Thu, 16 Jul 2026 06:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784184215;
	bh=VOl0gHVqBcnvPEyjNuSateeRi0FpoBgByAJ7ahVas3M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HFyhBDC+lDtiJKKYImDLhFLzRV0ODDJ7M22bEu22m63axK2CIcq8yJpoQ8UtAtzTe
	 /tHdvHfdfQAQc4SHpmV4ZEIh/Fkt5wPlsChZGf4mfXCisTaq6HCW39GyT+pCjN7IPs
	 qf4rkv+5tdikC2a/mS0dG0sv1e1jrwzSr/u+Tx3/8HO5ZMM/8DfAASbTKEeFg3rRLk
	 ezqZuBZBQdQ1PDR/x6nB6AR8+OT//VV44VkrrsHTV4H6mrcel4V2z0F8at1edj7a33
	 zTzab0OmIjb8u9IsD45QiY31fp+s9cChB8byRNdU+B5pSwEAGYfj6Fxz7SmKTtgV0H
	 pBLbex3fnO1hA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] scsi: ufs: Fix NULL dereferences after tag lookup
Reply-To: sashiko-reviews@lists.linux.dev
To: liqiang <liqiang01@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <a761788934d27cef7cbd099674923fd1c7c00f48.1784182493.git.liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <a761788934d27cef7cbd099674923fd1c7c00f48.1784182493.git.liqiang01@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 16 Jul 2026 06:43:34 +0000
Message-Id: <20260716064334.DA6071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] If a malicious or malfunctioning UFS device sends a completion que=
ue entry for a task tag that is not currently in-flight, `ufshcd_compl_one_=
cqe` will process it and release resources, leading to a double DMA unmap a=
nd power management underflow.
--

--- Patch [2]: [PATCH 2/5] scsi: ufs: Fix NULL dereferences after tag looku=
p ---
commit 070044fcdb23bd62a58cf9f22d642b3928421c36
Author: Li Qiang <liqiang01@kylinos.cn>

scsi: ufs: Fix NULL dereferences after tag lookup

This commit fixes a potential NULL pointer dereference in the MCQ cleanup
and completion paths by moving the private-command and request lookups
after the cmd NULL check. It also avoids dereferencing a NULL cqe when
reporting an invalid tag.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3541da5b6f4de..f2a5fa624e749 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5857,13 +5857,14 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, in=
t task_tag,
>  			  struct cq_entry *cqe)
>  {
>  	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, task_tag);
> -	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
> +	struct ufshcd_lrb *lrbp;
>  	enum utp_ocs ocs;
> =20
> -	if (WARN_ONCE(!cmd, "cqe->command_desc_base_addr =3D %#llx\n",
> -		      le64_to_cpu(cqe->command_desc_base_addr)))
> +	if (WARN_ONCE(!cmd, "invalid completion tag %d, cqe->command_desc_base_=
addr =3D %#llx\n",
> +		      task_tag, cqe ? le64_to_cpu(cqe->command_desc_base_addr) : 0ULL))
>  		return;
> =20
> +	lrbp =3D scsi_cmd_priv(cmd);

[Severity: High]
This is a pre-existing issue, but can spurious completions from the device
cause double DMA unmaps and power management refcount underflows here?

Because ufshcd_tag_to_cmd() returns the memory allocated for the tag in the
block layer tagset (which is non-NULL even for inactive requests), the !cmd
check passes even if the tag isn't currently in-flight.

Later in ufshcd_compl_one_cqe(), ufshcd_release_scsi_cmd(hba, cmd) is called
unconditionally, bypassing the block layer's active request protections. If
a malicious or malfunctioning device sends a CQE for an inactive tag, it lo=
oks
like it could trigger a double DMA unmap and permanently break clock gating
by underflowing the PM refcounts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1784182493.gi=
t.liqiang01@kylinos.cn?part=3D2
