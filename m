Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D7735202E
	for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 19:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791747036; cv=none; b=V4N6fTKdZAgaXayYZi+py6rvOt/BwAytRn8OeK2kq1E98bGzNkwaIWSXFWMh655gBrXDuLUmMhjp4DMknK2P55+ZNaLqUXUYGQfAPabMxQYoxpsba9hHprxXEqAhXJC7NhGPUfAg02tQPG34yRvduS0SAmRnrX6OkTLE63Ik/lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791747036; c=relaxed/simple;
	bh=kmmE5OHODGODkWn+DMq2XxhIyUmYnZhqvqzAIaYpuYw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=qU4th7s5gfpFGfh6R4+lK2pe45lnTAhmdojzjzzuVgk3SYUBPVp0Bu+yw5Hka/4cqx9/XINMEjSzUuTUEQ5VZ6BAsjtmd2jb4Oys8ATaY8EC0GiP0o57GIYn3OO1fvq0H3yykkf2MIsbEZbwuhOcIB96nlPmZYHvXJucWiZoU9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxESK+8S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxESK+8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED5B1F0089B;
	Sun, 11 Oct 2026 19:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791747031;
	bh=5Bla+97PupORhZlH4zYlUAw34Bxq5Lw+XyhimPlg59k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KxESK+8S/m2CqD3c8GxkvwvgCJUaBTe4qPLM5NBsfdEC9AR384Ugj1zWXgnt0g9pP
	 YpLN9Z+W674Tgr3V+D2jEpXbG/ryXFPoOJu++zeAO5BdBMk459zBJJK5u3UZrmzSgn
	 AXUPi1WQKd1syuy+V8bM/DCWWUTyWuy35Sg28VgRjN453qzK8DT5OF+30PBk0lOl9w
	 MlGj1viUyeAlML2+jy/Il9JA6MtmopNFB1Yl4IUOZSYBuYmAxxDalyJWLPCFvJSHKl
	 FZ/CNAfYLUYfevDmvpar68jIpj2V3VQvtQbrbHJKlPWozZ4vr3XGi/GsLnbHDcyiV+
	 b3Je8we8y0VDQ==
Message-ID: <sashiko-outbox-167409@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: aic94xx: Free the IRQ before killing the
 completion tasklet
Reply-To: sashiko-reviews@lists.linux.dev
To: "Myeonghun Pak" <mhun512@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261011151621.b9b17c998453-1-mhun512@gmail.com>
References: <20261011151621.b9b17c998453-1-mhun512@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 19:30:31 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: aic94xx: memory leak of sas_phys and sas_ports arrays on p=
robe error
--

commit 06cb328e08d3b300d95f57379c0e6e1c9182cebb
Author: Myeonghun Pak <mhun512@gmail.com>

scsi: aic94xx: Free the IRQ before killing the completion tasklet

This commit changes the teardown order in the aic94xx driver by moving
free_irq() ahead of tasklet_kill(). This ensures that the last possible
producer is joined before killing the completion tasklet in the device
removal and probe error paths.

> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/a=
ic94xx_init.c
> --- a/drivers/scsi/aic94xx/aic94xx_init.c
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -810,6 +810,7 @@ static int asd_pci_probe(struct pci_dev *dev, const s=
truct pci_device_id *id)
>  Err_escbs:
>  	asd_disable_ints(asd_ha);
>  	free_irq(dev->irq, asd_ha);
> +	tasklet_kill(&asd_ha->seq.dl_tasklet);
>  Err_irq:

[Severity: Medium]
Does this error handling path leak the sas_phys and sas_ports arrays?

If sas_register_ha() fails in asd_register_sas_ha(), those arrays are
dynamically allocated but do not appear to be freed before returning an
error:

drivers/scsi/aic94xx/aic94xx_init.c:asd_register_sas_ha() {
        struct asd_sas_phy   **sas_phys =3D
                kzalloc_objs(*sas_phys, ASD_MAX_PHYS);
        struct asd_sas_port  **sas_ports =3D
                kzalloc_objs(*sas_ports, ASD_MAX_PHYS);
        ...
        return sas_register_ha(&asd_ha->sas_ha);
}

The asd_pci_probe() function propagates this failure by jumping to
Err_reg_sas, which falls through this code block to eventually free asd_ha.
Could we be missing a kfree() for asd_ha->sas_ha.sas_phy and
asd_ha->sas_ha.sas_port before freeing the main structure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011151621.b9b1=
7c998453-1-mhun512@gmail.com?part=3D1
