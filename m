Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C5938D6B8
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264624; cv=none; b=i/1WFh06mHZ/PCWlx0Lnzx0Dm+ecoPJjZs4k6seoZ8JArSxeIdzE6i/V9K7K9yzLOHG7FJ5PVVTe6ug0XgFJeznlAvJge/tc0YFxwMdyrjBvl6DutEDogEsbQq2J+cX/4AhViBOVEWFU9VOHrxtidzl30IzwS7ESJhfeB0H2uKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264624; c=relaxed/simple;
	bh=fNxyY1I96pjbIxk4HcwZ9c92n715+N4fsBhCvp3vsU8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Fr7hkgUYn/5D+dDUIZOPhn37QknV6Z0eCvY1Bu949m45F2rMIPRbDVscEhCzzb6u24L4JQnvgKOmE+lUsTLFcyYuGfJmPrZxSTHtH73qnF8v6orUKa3Nu0d3o4WHoNHHwQOWjr6hxSPtWOeQjINHcYbL0LK1dX6cDZsnv1eihfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WugloaDS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WugloaDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEEB1F000E9;
	Fri, 12 Jun 2026 11:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781264623;
	bh=qYL1UvnXyWhQacFHelPkVe8S2w+s558RzkJNZL2TRzA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WugloaDSQAdZS8MojgcrXJ1QVcoNZLrZd9fNnfVTGvSt4pKKzy0wlpM5el+61FEAJ
	 7cjPH1mSXy8Vj4UBON9hJeOqMb8Yy2JWixgPCnp9Mv/MxpgKzxIxpnEDz0/53ZqLMb
	 sRgic0nMlAoGDUG8cTHoThcp4n/X3LFvfjYdZdkje+UXRVz0bvsHPsTCFua2yxpNnk
	 OpfxNAtqecAtQXzQG46pHxGqG6EsfZaq2sfaTQytWUOwpzeXqJTKb/qvLaOvVkaih2
	 wWDOP2QmPvp/Fqj5iIKdXYFwEVTPVbp2bNwGDfpEj4zj8YMLo359eml148PCsioW93
	 +7avFKgeT77PA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 51/60] scsi: qla2xxx: edif: Fix NULL pointer deref in
 RX SA delete check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-52-njavali@marvell.com>
References: <20260612095333.1666592-52-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:43:42 +0000
Message-Id: <20260612114343.5AEEB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch adds a NULL check for `cmd` to prevent a crash when a la=
te firmware status completion arrives for an already returned command, but =
it fails to account for handle re-use by non-SCSI commands (e.g., BSG or EL=
S commands), which will bypass the check and still cause an out-of-bounds r=
ead or crash due to union aliasing.
--

commit 8ccf27493c42b83e13fc3d263bc951bcaddb4472
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check

This commit fixes a NULL pointer dereference in
qla_chk_edif_rx_sa_delete_pending() by adding an early return if the command
pointer is NULL. This prevents a crash when firmware posts a late status
completion for a command that has already been returned or aborted.

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index f8bc248e5d18e..c8889ea199d33 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -3543,6 +3543,9 @@ void qla_chk_edif_rx_sa_delete_pending(scsi_qla_hos=
t_t *vha,
>  	uint32_t handle;
>  	uint16_t sa_index;
> =20
> +	if (!cmd)
> +		return;
> +

[Severity: High]
This isn't a bug introduced by this patch, but does this function safely
handle non-SCSI commands?

In qla2x00_status_entry(), if the firmware sends an unexpected STATUS_TYPE
IOCB for a non-SCSI handle (such as a BSG or ELS command), this function is
called without verifying if sp->type is SRB_SCSI_CMD.

Because GET_CMD_SP(sp) expands to sp->u.scmd.cmd, accessing this union field
for a non-SCSI command could yield a non-NULL garbage pointer. This would
bypass the new check and potentially cause an out-of-bounds read or crash
when dereferencing cmd->sc_data_direction immediately after.

Could this be protected by validating sp->type =3D=3D SRB_SCSI_CMD before t=
rying
to evaluate the SCSI command pointer?

>  	handle =3D (uint32_t)LSW(sts24->handle);
> =20
>  	/* find out if this status iosb is for a scsi read */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D51
