Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792777088;
	b=G3Edtvi7rv7s+6eW8B/QtYI6GtY01OjqviVJCPtdhC5RC3EKTVi0Gh39KRowXNorHL68
	 a31rc6QSWebSh7xgu5iOJJDIN8m3NHZeNAIUHAtLcyTW4dx9n1RcCEzoppOj6ElqHZqUc
	 ueuHrnLTOIcXR8aAYM/NTPeHMbPBizPt+1MsmftnKbCmQKlLvfmhj6UKkeJOVxqNhhIua
	 t3+ClflscBhnHtQBPmL4qNd2WOyolvs35v38c2q2dRK0CaW0DHiIS5e+q3Zff91lPWC+3
	 jxnt6OHdmXheByi1kcoP55QJf2cO2r9866BH+uqUh690HF1wK2dyuPS2njKiraixNow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792777088;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1Ony8sHX5pbFoUlWXTYqfV+ZO9IUG96NyeOui9a2vqE=;
	b=mrS+4tGjxUWoXX6NKerq4uThKbASJB0bXpfqXwoUOaz15di3XXbvThi2vAoiiwbXPYM1
	 JxfgliTEX53tnnF3oD9KikRL6nJU+Y5T5N8Hng/f8UNMlJ+xKuokH2Uzj+y//MQMsPMWk
	 /nzXmqEGQ7uLa+WRcvBgwCmm+jfKVpEmSAErkOENBS+/C3Ux0Tc6DITI4i0d2p9mtsjX5
	 WYzqgbUdrT0FXKUMIip9Uw8/W6D6PHdqX/zodcOONbgEsJV7NBwl4d5phuxDo05N/z3N/
	 MuPGysES17x5Zfa+bBX+PIYAHF7+1l/+XCqrakXDGKJxAd8ZoV4ebwamQ+ETrTe7+zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4fV3cVi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECFF606A31F
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 17:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4fV3cVi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BB21F01825;
	Fri, 23 Oct 2026 17:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792777087;
	bh=1Ony8sHX5pbFoUlWXTYqfV+ZO9IUG96NyeOui9a2vqE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a4fV3cViL9eMWp/P5wZWVw+yg8tdt7GkEpe1c+qFi39UXfeugbJMavl5QxRMnDozF
	 oy4A0wia54fILZZR7dOr90xyXur1zjms/kZn9VZsinZte+4X6TYuf4lHHoN+5Nv0I8
	 iLU36lLubToxdk4X18NaHmcqAXr8Inb+c/yKCdinvO8im+ace+lGl8F0nuiavFjucS
	 tywKDICpzpXj4MgR+mb3dTr4LVm6vdrde6TqyZIJZk0Xn9vQ852AftX7yjA9Ir4T61
	 kTavoVe6dkbtBUJZWA9eDSIqsJx/ba/xdPiFoqCtQuWkY3d7STwjof0I/yiFCDaBmf
	 G8vaa2NK6ZDUA==
Message-ID: <sashiko-outbox-183005@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: aic79xx: Fix NULL pointer dereference in
 device reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Luebke" <andrew.luebke@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261023170330.269844-1-andrew.luebke@gmail.com>
References: <20261023170330.269844-1-andrew.luebke@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 17:38:07 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: aic79xx: orphaned reset_scb when ahd_perform_autosense() r=
eturns 0
--

commit 1d9ef5977ae546b04b224d841fbb2babca4f0e30
Author: Andrew Luebke <andrew.luebke@gmail.com>

scsi: aic79xx: Fix NULL pointer dereference in device reset

This commit adds NULL checks to the command and SCB accessor wrappers in
aic79xx_osm.h so that device reset SCBs created without an associated
scsi_cmnd do not trigger NULL pointer dereferences. It also changes
ahd_perform_autosense() to return 0 when scb->io_ctx is NULL.

> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/ai=
c79xx_osm.h
> index c6eb2b97e929c..1facfd238f895 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.h
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.h

[ ... ]

> @@ -597,11 +610,12 @@ static inline
>  int ahd_perform_autosense(struct scb *scb)
>  {
>  	/*
> -	 * We always perform autosense in Linux.
> -	 * On other platforms this is set on a
> -	 * per-transaction basis.
> +	 * We always perform autosense in Linux, except for the device
> +	 * reset SCB, which has no command to return sense data to.
>  	 */
> -	return (1);
> +	if (!scb->io_ctx)
> +		return 0;
> +	return 1;
>  }

[Severity: Medium]
Does returning 0 here leave reset_scb uncompleted and orphaned on
ahd->pending_scbs when a target responds to a device reset with
SAM_STAT_CHECK_CONDITION or SAM_STAT_COMMAND_TERMINATED?

In drivers/scsi/aic7xxx/aic79xx_core.c, ahd_handle_scsi_status() is called
from ahd_run_qoutfifo() -> ahd_complete_scb() after the sequencer has
already completed the SCB and popped it from qoutfifo. When
ahd_perform_autosense(scb) returns 0, the SAM_STAT_CHECK_CONDITION /
SAM_STAT_COMMAND_TERMINATED case breaks out of the switch without
requeuing scb or calling ahd_done(ahd, scb):

drivers/scsi/aic7xxx/aic79xx_core.c:ahd_handle_scsi_status() {
	...
	case SAM_STAT_COMMAND_TERMINATED:
	case SAM_STAT_CHECK_CONDITION:
		if ((scb->flags & SCB_SENSE) =3D=3D 0) {
			...
			if (ahd_perform_autosense(scb) =3D=3D 0)
				break;
			...
		}
		ahd_done(ahd, scb);
		break;
	...
}

Because ahd_done() is skipped, reset_scb remains on ahd->pending_scbs even
though it is no longer on the controller. This stalls ahd_linux_dev_reset()
in drivers/scsi/aic7xxx/aic79xx_osm.c for the full 5-second timeout and
causes ahd_reset_cmds_pending() to overcount hardware CMDS_PENDING.

Furthermore, if the reset was triggered via scsi_ioctl_reset() in
drivers/scsi/scsi_error.c with SG_SCSI_RESET_DEVICE |
SG_SCSI_RESET_NO_ESCALATE:

drivers/scsi/scsi_error.c:scsi_ioctl_reset() {
	...
	case SG_SCSI_RESET_DEVICE:
		rtn =3D scsi_try_bus_device_reset(scmd);
		if (rtn =3D=3D SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
			break;
	...
}

error recovery does not escalate to a bus reset and ahd_abort_scbs() never
runs. Doesn't that permanently leak reset_scb and leave dev->active
incremented and dev->openings decremented from ahd_linux_dev_reset(),
which also causes subsequent ahd_suspend() calls to fail with -EBUSY?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023170330.2698=
44-1-andrew.luebke@gmail.com?part=3D1
