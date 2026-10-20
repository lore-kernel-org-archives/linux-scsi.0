Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792537140;
	b=l5H0TX2iDPYKAZt4F+fZpbgL/zdubPrmAy5e6UxB0f/mG6lDzPtr2mUBeuGALzjDcifV
	 lpcVSGoZVtSXehhC+meQsJ52d6rYB8yG++cdw+hY40MaszvBcpC7WnONlsBSPw744sjVL
	 +Zvaqzki8egG5jAxihs54acTm1G0Rgj+ts50HiZ+IjR4VpYBIQvHJlmEZ2zzrz5mMN1Nl
	 IaxDGXlNChejORFWMLFAl6Nh4tYcGwzJAoy7YwObC7roJz6D3uH551u8XYmRSm6Qr8TBr
	 RGBY9ebLG4yYpGlKjIi3D0Z2tQ3QLyfwsAQHCLC4NmZDT5Gp1dD/a2rXX7EzzPGuf8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792537140;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uIWLln2NJhNe4h0QokEDtS4Kj4QoratfH2ZA4cN8OZ4=;
	b=rd/TF/qsP9FnDDjCj3KXvX1GYYTuVbB48axAC3wyUF5vMwBRFFRzxZz8I3L9r5JJ+xHP
	 wmrRosrwACJvKWpxgc0/t+eI9xtUYzMzu58ZU8ujyuwPCxotn1h9GVQmD9lp53L3988Md
	 MSODKGeUh2WXCZSMULeE2LJv0HLELH9/svzRTZDARFNCT1VK8Iqe9Wp0m49Ko9mamAtEl
	 u1f/JOLLXr4lUY14y9E4nsihE5UVyOoKD21m3F/EZVUgYvwtBCXk9iylNVJkscxvKDMrH
	 6LMBYR+kQrxxwEyfKmpJr5H8icYPoQlH7eIdO833ahW5wt2td1EJNc8d+1oyRPxlh6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i7rDakD0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBBF606A319
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 22:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i7rDakD0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AC31F000C9;
	Tue, 20 Oct 2026 22:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792537140;
	bh=uIWLln2NJhNe4h0QokEDtS4Kj4QoratfH2ZA4cN8OZ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i7rDakD0hTtsEQFfnU6YtZK8pGXSqNN9oUR0lz1vUZ2dlCC29hZWbb2KMp/P2DqoG
	 4ilhgNJ3hAoU1nQXgP47DY0JiNIXD1BWPhDMdoBjrVsk9SLjDAjKuRJSllt1cgpcDr
	 PGmCBl5OlYL3mh/5KQxJA457SMosI13uhm/wUOu12G98NPMGuhZPOVeQCypxnBeHI8
	 w2z8HEPwhtIAF/nLLlzpLgVu4CvXwwGssgrxMbfMyhR7TUEJmEQoVuIaczuDwdVdAa
	 gRODlfnKm8WJsBxVDXMpnPf8IEKQGM+N2dmCI4yWN2FA0jGID2yPHkJd++3b2FpA2m
	 o9qG+tFmcILRg==
Message-ID: <sashiko-outbox-179588@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: aic79xx: Fix NULL pointer dereference in device
 reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Luebke" <andrew.luebke@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261020221530.2606178-1-andrew.luebke@gmail.com>
References: <20261020221530.2606178-1-andrew.luebke@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 22:58:59 +0000
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
- [High] scsi: aic79xx: NULL deref in ahd_done() after autosense clears SCB=
_DEVICE_RESET
--

commit 23f3405cc30dbbed5f3a874c429d277d08fab6ac
Author: Andrew Luebke <andrew.luebke@gmail.com>

scsi: aic79xx: Fix NULL pointer dereference in device reset

This commit drops the residual write on the device reset scb in
ahd_linux_dev_reset() and adds null checks for scb->io_ctx to the status,
residual, transfer direction, and freeze wrappers in aic79xx_osm.h.

> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/ai=
c79xx_osm.h
> index c6eb2b97e929c..b47aa6c98581c 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.h
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
[ ... ]
> @@ -584,6 +593,8 @@ void ahd_set_sense_residual(struct scb *scb, u_long r=
esid)
>  static inline
>  u_long ahd_get_residual(struct scb *scb)
>  {
> +	if (!scb->io_ctx)
> +		return 0;
>  	return scsi_get_resid(scb->io_ctx);
>  }
> =20

[Severity: High]
If a reset scb with a null scb->io_ctx reaches ahd_handle_scsi_status()
with check condition or command terminated status (for example, if a
misbehaving target responds with status during non-packetized phases),
could this still trigger a null pointer dereference in ahd_done()?

Just below ahd_get_residual() in drivers/scsi/aic7xxx/aic79xx_osm.h,
ahd_perform_autosense() unconditionally returns 1:

drivers/scsi/aic7xxx/aic79xx_osm.h:ahd_perform_autosense() {
	return (1);
}

When ahd_handle_scb_status() -> ahd_handle_scsi_status() in
drivers/scsi/aic7xxx/aic79xx_core.c handles check condition or command
terminated status, ahd_perform_autosense(scb) returns 1 and
ahd_get_residual(scb) now returns 0, matching ahd_get_transfer_length(scb).
When auto_negotiate is set for the target, ahd_handle_scsi_status() clears
the device reset flag from scb->flags and re-queues the reset scb to issue
autosense:

drivers/scsi/aic7xxx/aic79xx_core.c:ahd_handle_scsi_status() {
	case SAM_STAT_COMMAND_TERMINATED:
	case SAM_STAT_CHECK_CONDITION:
		...
	} else if (ahd_perform_autosense(scb) !=3D 0) {
		...
		if (ahd_get_residual(scb) =3D=3D ahd_get_transfer_length(scb)) {
			ahd_update_neg_request(ahd, &devinfo,
					       tstate, targ_info,
					       AHD_NEG_IF_NON_ASYNC);
		}
		if (tstate->auto_negotiate & devinfo.target_mask) {
			hscb->control |=3D MK_MESSAGE;
			scb->flags &=3D
			    ~(SCB_NEGOTIATE|SCB_ABORT|SCB_DEVICE_RESET);
			scb->flags |=3D SCB_AUTO_NEGOTIATE;
		}
		hscb->cdb_len =3D sizeof(*sc);
		ahd_setup_data_scb(ahd, scb);
		scb->flags |=3D SCB_SENSE;
		ahd_queue_scb(ahd, scb);
}

When that scb later completes via ahd_done() in
drivers/scsi/aic7xxx/aic79xx_osm.c (or is aborted via ahd_abort_scbs() when
the device reset times out), cmd is null and the device reset flag is no
longer set in scb->flags, so ahd_done() skips the early return and
dereferences cmd->sense_buffer:

drivers/scsi/aic7xxx/aic79xx_osm.c:ahd_done() {
	if (cmd) {
		...
	} else if (scb->flags & SCB_DEVICE_RESET) {
		if (ahd->platform_data->eh_done)
			complete(ahd->platform_data->eh_done);
		ahd_free_scb(ahd, scb);
		return;
	}
	ahd_linux_unmap_scb(ahd, scb);
	...
	cmd->sense_buffer[0] =3D 0;
}

Should ahd_perform_autosense() also check for a null scb->io_ctx and return
0?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020221530.2606=
178-1-andrew.luebke@gmail.com?part=3D1
