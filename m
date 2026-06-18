Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120053B27C1
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781789207; cv=none; b=HxkcW75bibaMVoEPlR9yOr4LFGURpiYP7yfoZKOvGyhMX0VocBzlEAN6PLA8TKC6ydwPn9k71U2cqOB64uCOtjrhojLAkZ/cAyMeIblnEbJiFPCE59RuxVvQS9ZmiqDBn4coDSRBnvKzoFvFJJYTAHkM1zU3QxnPGEs40xyH3vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781789207; c=relaxed/simple;
	bh=yoFBo2F8aC1WNYGsXOQ820qCA4MKv6JguU9jVu01AZ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DdpvFFlIwxQ+q62KQufYau/k9zO4R76GpSPwA2FrxtGIRDGypdkOQiBBApUkWqziIdUTJr2JbQx3l2m0e92haBKGZt0kRINoL4gzL5LgEmBWM41DiIOqixZUKX7Sxr2sdmi/R+Iqa9c0Lp29NmfMVHGwPLSyiM0f1TUqH45BmXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+iuRfx1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+iuRfx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0CE1F00ACF;
	Thu, 18 Jun 2026 13:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781789205;
	bh=AWv8AHGYN+rCXlh5SVw9LG+3bnH7MwR9bFckv2Qzh7g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A+iuRfx1GYdwKtLNnWn8IPCwCOFQ9qhTt8nZteB2LkEIZch67J2d/Bsecgq/6EfUb
	 G1AtbnqKJ3ZLV/A8lAmTQ/afv3HEfeOCp2MLtvqqlKCDdP+Y6Bl4VcNUGJKpG8YtHy
	 riA1v5udVZS5M1XneZ46XRgSA6cJUlLQH5XfGX6WWp8WuEmu6m2glhKVBm7PcvRHcV
	 iKWhgzpV4kD8rzaI46Mt634tZvVTlYnKh+Df0VBmUEPizXiZgAbQ/zYDDCX2hsUGbu
	 DcD8MT5PWq+YjvP1pcCtGkZhVvRPN0aaClkanyn+CUzGIt5f1iMHM/DOx0LP92tbtW
	 33MuC/drECWTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: scsi_dh_alua: Use common code in alua_rtpg()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Markus Elfring" <Markus.Elfring@web.de>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <366c376e-ef8a-490d-a580-570f2f51ec81@web.de>
References: <366c376e-ef8a-490d-a580-570f2f51ec81@web.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Jun 2026 13:26:45 +0000
Message-Id: <20260618132645.9F0CE1F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A race condition in `alua_rtpg` can cause ALUA port group state up=
dates to be permanently dropped.
--

commit a4fc4f8579d1bb0ef6314519e4902a1bf335fb2b
Author: Markus Elfring <elfring@users.sourceforge.net>
Subject: scsi: scsi_dh_alua: Use common code in alua_rtpg()

This commit introduces a goto label to consolidate the memory freeing
and return logic in alua_rtpg(). It replaces multiple redundant kfree()
calls throughout the error handling paths of the function.

> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/de=
vice_handler/scsi_dh_alua.c
> index 80ab0ff921d43..0161507010643 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c

[ ... ]

> @@ -632,15 +632,14 @@ static int alua_rtpg(struct scsi_device *sdev, stru=
ct alua_port_group *pg)
>  			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
>  				    ALUA_DH_NAME);
>  			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> -			kfree(buff);
> -			return err;
> +			goto free_buff;
>  		}
>  		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
>  			    ALUA_DH_NAME);
>  		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> -		kfree(buff);
>  		pg->expiry =3D 0;
> -		return SCSI_DH_IO;
> +		err =3D SCSI_DH_IO;
> +		goto free_buff;
>  	}
> =20
>  	len =3D get_unaligned_be32(&buff[0]) + 4;

[Severity: High]
This is a pre-existing issue, but was not introduced by the patch under
review. While we are consolidating the return paths in alua_rtpg(), does
this function still have a race condition when applying the new access
state?

Looking at the loop that processes the descriptors further down in
alua_rtpg():

    if (spin_trylock_irqsave(&tmp_pg->lock, flags)) {
        if ((tmp_pg =3D=3D pg) ||
            !(tmp_pg->flags & ALUA_PG_RUNNING)) {
            struct alua_dh_data *h;

            tmp_pg->state =3D desc[0] & 0x0f;

If this trylock fails because the lock is held by a function that doesn't
set the ALUA_PG_RUN_RTPG flag (like alua_bus_detach() or
alua_set_params()), the new ALUA access state is silently discarded without
queuing a retry.

Could this cause the port group's access state to become permanently stale
(e.g., stuck in SCSI_ACCESS_STATE_STANDBY despite the hardware
transitioning to an active state), ultimately failing all I/O to
non-optimal paths and causing data unavailability?

> @@ -770,6 +769,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct=
 alua_port_group *pg)
>  		break;
>  	}
>  	spin_unlock_irqrestore(&pg->lock, flags);
> +free_buff:
>  	kfree(buff);
>  	return err;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/366c376e-ef8a-490d-=
a580-570f2f51ec81@web.de?part=3D1
