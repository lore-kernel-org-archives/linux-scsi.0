Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38CD2C0294
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 20:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788206828; cv=none; b=j55PYZ83jfhhshSf4qCE6+uW6vzfAxd6Lac1YZJeBsCDEN1kD3NU4kQvkI67b1/r4nVRe3P03XlC5v5n/LeFV2elgwtB6LMa47T3IHXgMyLW3WMP6jsMHRqWzg29d8Hh/0FlY5/aOmyCHSFdFFA7QjyLH/N5xYGKBrIsoy0Lp2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788206828; c=relaxed/simple;
	bh=XwjbfG6vPWjXdjEGgNQ3IVugJ8SfhphQzWERyMjvLn8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=prhzfidQDjKfWQmSB/MMHq2NjkTgSjVAND/JDrYcJne9mk4lyZW+ZrUb90D0qXNVAVS5Exuqck3qxaIuBgNXwgm3ZtgpIH5mM5v6xaKHZ7jYtt1+/HFnjxxb96J2qyrXrOY9/lQ2w2IKC6bR+j76iuvmgQBjdaMwxguz4/9irEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GV7zuAiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GV7zuAiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281131F000E9;
	Mon, 31 Aug 2026 20:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788206826;
	bh=MUMgokTpr0lM10auGLc1sHNCG9mg0LhTSy+BTEE+bj0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GV7zuAiAeYx/5HUihv76URNZN6yblRjk6jdGpto/RHSe79rvfI7iOdj7GeV9G9Wn9
	 yzvn614/IaT8QVuUc7QOhQ+DKGx2LUiku+K1jbkIgd+sYS696cZiBHN1GUjh/e6Zhs
	 u6V6KADZHXOofSxOehQ/aF3E6zu6vrr5VhaM1/9FQXtht/uHUPvRUpAE8HilnyE780
	 b5L46av/ei1tpFdF9Y261nA7heq+rl4X9FwfEbjMKRlzxLSXIX3nhjXa9hjTa3wBpc
	 /FvISQPwyf/mzOBU4OLIP9tkac8CvaiisFPByXUJBwWrbcXKssVnZicwpYlJagXfFW
	 TdFa0YR911nfg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: pm8001: Fix SATA FIS offset in struct
 hw_event_resp
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <31963d53810f42970447e78ef46030ab13d2e91f.1788198434.git.bvanassche@acm.org>
References: <31963d53810f42970447e78ef46030ab13d2e91f.1788198434.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 20:07:05 +0000
Message-Id: <20260831200706.281131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds checks for unvalidated `port_id` and `phy_id` extra=
cted from hardware payloads in hardware event handlers, leading to potentia=
l out-of-bounds array accesses.
--

commit 54581172c25d0fbd24fe1a048aa6e9fe28d5e2e9
Author: Bart Van Assche <bvanassche@acm.org>

scsi: pm8001: Fix SATA FIS offset in struct hw_event_resp

This commit fixes a Clang compiler warning about negative pointer
arithmetic by properly defining the SATA FIS offset in the struct
hw_event_resp. It extracts the 28-byte identify frame into a
separate struct and aligns the sata_fis member to its actual
hardware byte offset.

[ ... ]

> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3296,7 +3296,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001=
_ha, void *piomb)

[Severity: High]
This is a pre-existing issue, but does this function lack bounds checking
on the port_id and phy_id extracted from the hardware payload?

Looking earlier in hw_event_sata_phy_up():

    u8 port_id =3D (u8)(lr_status_evt_portid & 0x000000FF);
    u8 phy_id =3D (u8)((phyid_npip_portstate & 0xFF0000) >> 16);
    ...
    struct pm8001_port *port =3D &pm8001_ha->port[port_id];
    struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];

Since port_id and phy_id can be up to 255 based on the bitwise masking,
and the port and phy arrays are statically sized to PM8001_MAX_PHYS (16),
could a malfunctioning or untrusted hardware payload cause out-of-bounds
array accesses here?

A similar pattern also appears to exist in pm80xx_mpi_hw_event() when
handling untrusted event payloads.

>  	phy->sas_phy.oob_mode =3D SATA_OOB_MODE;
>  	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
>  	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
> -	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
> +	memcpy(phy->frame_rcvd, &pPayload->sata_fis,
>  		sizeof(struct dev_to_host_fis));
>  	phy->frame_rcvd_size =3D sizeof(struct dev_to_host_fis);
>  	phy->identify.target_port_protocols =3D SAS_PROTOCOL_SATA;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/31963d53810f4297044=
7e78ef46030ab13d2e91f.1788198434.git.bvanassche@acm.org?part=3D1
