Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E603EBF33
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 12:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782476175; cv=none; b=q1TZbnUPOitBaP6aIsnH3SfM0VsnooCwwp3C79FipV+YPvQV6UHXojSwxvIR6QWcNwzPIJulSTmSd+5gbvw1BRaN0y/+a+f6g8pcxMxwHtfUpwQ1bYuecsmPGcP1gUm1v0IWi5T0uoYQ6gBDCHHAw1FzsHnfZDmgmdshNhsRsEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782476175; c=relaxed/simple;
	bh=Ym+XpDL7NN5/zEMaq9X93Rolc7OQyeNuyhwSyrpAupE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=srIOcZM/4vh5ijaqCvs/VwLSfUblu8gZCSbNYaxsQApFX32JXs8Yf1McXh2UIln7eQExBosixkwhQQ7O5tuyyL8wFZ/j5FwdAiKCoVHkesDvZIlF3GHRmFRwkPhGeMwwSHhh8zx7Qs+5tyt+mYySAcjR3Ffi8+JKLVbOCVzRpG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHNEsqDS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHNEsqDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319A51F000E9;
	Fri, 26 Jun 2026 12:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782476174;
	bh=LTpJhYyzlp8HS4Ou48xOQaW319592XtoSWS14HDA9Gg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KHNEsqDSIhXkKQJHdhKgsXCYMggukb2QedfsTi/upqbu6+D5T0KXdO2xXOmLaASTR
	 W6Y8BxGE5ex1SqscyYpCB9WsEHmKefxIYrweb9F7umu/+BalbnsFQvUxuBjzISUSRj
	 g2r6qPo9VIPWViZW7cciLYP/FLF34RJF0TRAQJmCVa/QO+FNLQiaBe7dm0YGhUX5ad
	 eusXCpl+4dV5IexNcRXJpbT1itgBKSmslLtm1gL/DUifJ13hIRKo5F/g1F8AXNcD7W
	 GmJse9aVni97/i1BYXepF2IF3vnieVysFsUPrt2oasK3pyGSxjO7JSdl3v7+U1mBJD
	 bKltMpNlvarkg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 09/10] mpi3mr: Fix SAS PHY cleanup in host addition
 error paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260626114109.43685-10-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
 <20260626114109.43685-10-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 12:16:13 +0000
Message-Id: <20260626121614.319A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unhandled Error Path / NULL Pointer Dereference when adding host P=
HYs.
--

commit 5d2df761c30d63d86fc3554a56dabf8408d62592
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix SAS PHY cleanup in host addition error paths

When adding a SAS host, the driver allocates a PHY array and subsequently
creates individual SAS PHYs. If a later step fails, the error path exits
without cleaning up previously allocated resources, resulting in leaks of
both the PHY array and any registered SAS PHYs.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 1b793d86f7589..0236bbfcff6d9 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
[ ... ]
> @@ -1264,7 +1265,7 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
> =20
>  		if (!(mpi3mr_get_hba_port_by_id(mrioc, port_id)))
>  			if (!mpi3mr_alloc_hba_port(mrioc, port_id))
> -				goto out;
> +				goto out_free_phy;
> =20
>  		mrioc->sas_hba.phy[i].handle =3D mrioc->sas_hba.handle;
>  		mrioc->sas_hba.phy[i].phy_id =3D i;

[Severity: High]
This isn't a bug introduced by this patch, but is it safe to ignore the ret=
urn
value of mpi3mr_add_host_phy() which is called just after this block?

If mpi3mr_add_host_phy() fails (e.g., at sas_phy_add()), it returns -1. At
this point, mr_sas_phy->remote_identify.sas_address is already populated wi=
th
the attached device's SAS address, but mr_sas_phy->phy is left as NULL.

Later, when the attached device triggers a device addition event,
mpi3mr_sas_port_add() successfully matches the failed PHY because the
remote_identify.sas_address is populated:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
		if ((mr_sas_node->phy[i].remote_identify.sas_address !=3D
		    mr_sas_port->remote_identify.sas_address) ||
		    (mr_sas_node->phy[i].hba_port !=3D hba_port))
			continue;
    ...
}

It then unconditionally passes the NULL mr_sas_phy->phy to sas_port_add_phy=
(),
which dereferences it without checking, causing a kernel panic:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
		sas_port_add_phy(port, mr_sas_phy->phy);
    ...
}

Should mpi3mr_sas_host_add() handle the failure of mpi3mr_add_host_phy() and
jump to the new out_free_phy label?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626114109.4368=
5-1-ranjan.kumar@broadcom.com?part=3D9
