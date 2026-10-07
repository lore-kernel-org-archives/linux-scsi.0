Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5635E480336
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 10:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791369788; cv=none; b=LeucWo+EoP5K0xyryrbmH1s8wSjP+bWdxF9F26+06BFdlgfm+bXOwnh1NFJA6Gu3p8LBXI2SchpZ3bGjp5ssDRjEfbMRGQEChM5DNf5Ae84rXERJ1Epbif2QoIJ5+530tR/avB/LTvgP31LeFiedtksMYu3LXL4F6AqJn61DHfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791369788; c=relaxed/simple;
	bh=leHmwwu/qk8JaQwEKjPV7nCY0AT4BICVm5iUBP3+q/E=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KI9ZNCcvf5733pGQY00bIDLnRzjTfkAsHfuq1KPwRbQOIixYbpPWtZAqKqF7hFfBomgFm4XL2cRZitOnI204lnTNnPDAgBM1BbEP5kQBxGdH9tITyVMa0xFDSroX+g+Xzl3ZcogWQ7Zkd+ME5N197gtzrc2/kYPwN+yIBJOV7uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayc/OO50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayc/OO50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921421F0089B;
	Wed,  7 Oct 2026 10:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791369765;
	bh=x78NUI/I2LsVmxVw+BYZfrrLHR89TOXcX+qyMbyVJ5k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ayc/OO50GlZPK1xSyuSOfbY9Ls0BLlEu+JfjHvm+DSzLdFNMoF6PKDTvwvmoJrAv0
	 T8poPwiObheUIvfOlgSGOkT2A2oyIw2b2XWJqaAJfO07AFKh9kb9m3uS0jsr4g4VIs
	 zzOBvO6Qtlhj0BFCrcpJXvZofEzNZYE7IYNaHm9w6rVqIyZyGT9nyn1/TmWY/zIqVY
	 cDbhVbWLrNs2GWWZOqymHS2h/mUZwdQnvzxDtscroYxdQb6Wln8pziM8fqm3ix/dR+
	 JBvMYTxB6L9srxfRGNrkBAzJerVufoRKjJTEt8FuxP8UC1wT9YAUZ5xs9RxxgaN6jl
	 YeCq3CtDO7D6Q==
Message-ID: <sashiko-outbox-162870@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix fcport handling in session creation
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007102632.11971-1-serhatkumral1@gmail.com>
References: <20261007102632.11971-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 10:42:45 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] scsi: qla2xxx: Unlocked state modifications to live fcport
- [Medium] scsi: qla2xxx: missing d_id update on session swap risks stale N=
_Port ID
--

commit 677908d94136f8ead1918acb926dd5f120568a2d
Author: Serhat Kumral <serhatkumral1@gmail.com>

scsi: qla2xxx: Fix fcport handling in session creation race

This commit addresses a session creation race condition by swapping to
the existing fcport when a second WWPN lookup finds one. It then frees
the newly allocated fcport to avoid a use-after-free in the trailing cleanu=
p.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 3c412c7fb6fe7..1231265365afd 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
[ ... ]
> @@ -5529,7 +5529,9 @@ void qla24xx_create_new_sess(struct scsi_qla_host *=
vha, struct qla_work_evt *e)
>  			    __func__, tfcp->port_name, tfcp->disc_state,
>  			    tfcp->fw_login_state);
> =20
> -			free_fcport =3D 1;
> +			conflict_fcport =3D fcport;
> +			fcport =3D tfcp;

[Severity: Medium]
When swapping to the existing session, is there a missing update for the
N_Port ID?

Unlike the first lookup block in qla24xx_create_new_sess(), the N_Port ID of
the session is not updated here. If pla is NULL (e.g., from GPN_FT or mailb=
ox
events rather than target PLOGI), the d_id is never updated.

Could this cause the subsequent qla2x00_find_fcport_by_nportid() check to
fail or incorrectly identify a conflict, leading to the driver logging into
the stale N_Port ID?

> +
>  		} else {
>  			list_add_tail(&fcport->list, &vha->vp_fcports);
> =20
> @@ -5542,6 +5544,9 @@ void qla24xx_create_new_sess(struct scsi_qla_host *=
vha, struct qla_work_evt *e)
>  	}
>  	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> =20
> +	if (conflict_fcport)
> +		qla2x00_free_fcport(conflict_fcport);
> +
>  	if (fcport) {
>  		fcport->id_changed =3D 1;
>  		fcport->scan_state =3D QLA_FCPORT_FOUND;
>  		fcport->chip_reset =3D vha->hw->base_qpair->chip_reset;
>  		memcpy(fcport->node_name, e->u.new_sess.node_name, WWN_SIZE);

[Severity: Medium]
Does modifying these state fields on the now-live fcport outside of the
sess_lock introduce data races?

Because fcport was swapped to the existing session (tfcp) inside the lock, =
it
points to a live session object. Setting fields like id_changed and scan_st=
ate
after dropping sess_lock may race with other threads accessing this session.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007102632.1197=
1-1-serhatkumral1@gmail.com?part=3D1
