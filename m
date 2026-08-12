Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42C747DF97
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559254; cv=none; b=QLQhfQw0ahn5yM+QgkmUKnqWtYdPbCruoS6MYmixc2x9mlkm1nB51BWt79p3dCtXjk6yOo5HlrI0C8tbnVKOgg+I9VeajQIBZi1ljODSN0GVJhnaE+cv0kUQdij53ejgX+IJ/pHsOlgKdUPAFG+vqPQkT/BwF2ZgNqzGVA0vMH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559254; c=relaxed/simple;
	bh=Yx9uLfaNi7Qu2/jV7RFGxmwkFHbLI1A1aZnp9NYy4NA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EjbCRgnPv/UACjNv0FRO6LbUirQks9ugU6ygfM8PbEu+zbSGnxqNlgD44xLrD9V/BrRvIddNYeBW1az9fG89f5TmC7vDzl91WKidsSfmIWM/3W86DBrc2D+MvOGNC3KPC10TPDy+ul/xJbwg9cbKawJLKR+9oBW5ka71PJ+4/iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XfDZmvtH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfDZmvtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309881F000E9;
	Wed, 12 Aug 2026 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559253;
	bh=1bipFXlFUlWdjTdr4Ro0mytTv1COQWATZBR+R1as1Fk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XfDZmvtHvtIp11QjAGsWvW+uhbooiml7PJ6Ojrzm8QEq0USmIlggsdyX2NUYNINxL
	 MK3er+UJVnwX8tnC36xondLBmNPcMGOktSp8AAbaasR0ihuudNqKcl2wT9DkDxF9t4
	 umzdU8Oq32GIJWjuR+Lm+7wi3Vqz0tE07GKhArl8tbfSd574U+N9WHUikxwkFSGix6
	 fxQ7Ku07eP5058dK4z9pYe2GYLHtiipSkcHHeNIXcdM9H/nY98IvWBOiCM2VFuweKr
	 GDd10q/Gr3wzScKV/o3fhO2q+jSV7Tm5BwsDjfVzNq3gO5Dz4F8GYcVRIBFtj9MYBv
	 33W0AopD3eTew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/13] nvme-fc: add nvme_fc_set_remoteport_fpin()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-10-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-10-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:27:32 +0000
Message-Id: <20260812182733.309881F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] `nvme_fc_ctrl_connectivity_loss()` clears the `NVME_CTRL_MARGINAL`=
 bit on the wrong structure's flags field, causing state corruption and per=
manent marginal state.
--

--- Patch [9]: [PATCH 09/13] nvme-fc: add nvme_fc_set_remoteport_fpin() ---
commit a1aaa3c652a2b842059c76da3884f9c0dcb9925a
Author: Jesse Taube <jtaubepe@redhat.com>

nvme-fc: add nvme_fc_set_remoteport_fpin()

Add nvme_fc_set_remoteport_fpin() and supporting functions. This
function is called by the SCSI FC transport and driver layer to set or
clear the 'marginal' path status for a specific rport.

> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index d2ca65f70a0c5..4acf23ea8aea2 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -895,6 +895,22 @@ nvme_fc_set_remoteport_devloss(struct nvme_fc_remote=
_port *portptr,
>  }
>  EXPORT_SYMBOL_GPL(nvme_fc_set_remoteport_devloss);
> =20
> +void
> +nvme_fc_set_remoteport_fpin(struct nvme_fc_remote_port *portptr, bool ma=
rginal)
> +{
> +	struct nvme_fc_rport *rport =3D remoteport_to_rport(portptr);
> +	struct nvme_fc_ctrl *ctrl;
> +
> +	spin_lock_irq(&rport->lock);
> +	list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list) {
> +		if (marginal)
> +			set_bit(NVME_CTRL_MARGINAL, &ctrl->ctrl.flags);
> +		else
> +			clear_bit(NVME_CTRL_MARGINAL, &ctrl->ctrl.flags);

[Severity: High]
This code correctly uses &ctrl->ctrl.flags for NVME_CTRL_MARGINAL. However,=
 in
nvme_fc_ctrl_connectivity_loss() introduced in the earlier commit "nvme: add
NVME_CTRL_MARGINAL flag", the marginal state is cleared like this:

drivers/nvme/host/fc.c:nvme_fc_ctrl_connectivity_loss() {
	...
	/* clear 'marginal' flag as controller will be reset */
	clear_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
	...
}

Could clearing NVME_CTRL_MARGINAL on the transport-specific &ctrl->flags
instead of &ctrl->ctrl.flags leave the NVMe controller permanently marked as
marginal across reconnects, preventing the multipath scheduler from fully
utilizing the repaired path?

> +	}
> +	spin_unlock_irq(&rport->lock);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D9
