Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792751720;
	b=Tc8FLxOpPZ1RCluxuIDE2srbLyCkvLYJuN97THxcBofE9EZjZVG2D0rv2cNsHcb43USM
	 u4ew/psfcEKoRt0G9osDA7HTL42xOZko9rZdQtkbO0/dHvMblnOmFQzgq1VGanEhNY36t
	 WpW0eK9rwU5mq5kAAufgBezfdXPQHVD2YRKMPyK7evjPP1IkdjPtsDwtpejd/adArKzyf
	 1xDppRUthlaZPwzDYB+1RMb/fd22TZkKRsuWQMXYc7GGEYVhyw934xhbN8Mq+Yk02MiXp
	 6eTnuln3UMT0r3lkyCS6Hdt9awWi3VbM0tj2kGedvQ3UIIOlYRQEF01AZ75kbBjCeFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792751720;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N6qxCqSu2MGcdC5oKwu2bBWVyF9dGU42acaYqndLA8A=;
	b=FllWlSyRHLzn0DAVUKaLa3NiYzXfdil/E8Ys6KvObDYzO0euvj0TX03UUqzOUIQIroXt
	 BYyFtC1B8URixp7HNC+LZOpCe4pJf1/umUGlRajQWWHeCOlB8rz0YcyXSs4MJtJSH8DQh
	 GsCITOrrhbYXPWbWd3o4uHDwAYpKve+zurrOinEVA/OfhPY+r2Lyp8wsKWYVConytfkwJ
	 tOZcGtjlXoEal4WpZ+D3G+m8FtGviXrGZkffXlIfsgo9M+G/Tzm7gZCoFxE2SsRIhu5vp
	 MMbnzHEaR4f9+bk4mlZ38CzszRGHiLtV03qsQj2uw2dZLcaBrxaX54pjYm/i5cP7LYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DI9DWabd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F85606A320
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DI9DWabd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17B21F012D7;
	Fri, 23 Oct 2026 10:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792751720;
	bh=N6qxCqSu2MGcdC5oKwu2bBWVyF9dGU42acaYqndLA8A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DI9DWabdEkPVTNb6jClrYfvQMMJI+u950z2bZ6OPUbZggXzVEuOyQxvn2Cip2vyM2
	 vz0bl2MPnyEz9yaR/tDODKrJFt7ut5CfUSgw9ljgSsr2uO5C1zfshq82TaPIicBPtH
	 xdnq/Fbn7RWS0m9QisLEIH7XR+u0ve5WxZGm7EAveFmoAKndj6v+LzqbOyBX8pxZ62
	 4fqWBNU+pzRWpNKg2inIW3Ig4Ku+Bz8556KNTJEbs2X8L1UlflBh3Fx+qbbndnO0Cp
	 GNwFT1KNQgQjjPjWKWLVma+fSHUFANR9XgDAWLSCQL+a4sd1lg3vQ1jrTv5/AAytA1
	 /s1iBhOhXre7A==
Message-ID: <sashiko-outbox-182694@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/13] scsi: qla2xxx: Wait for session deletion
 before full-login LIP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261023101600.1431179-5-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
 <20261023101600.1431179-5-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 10:35:19 +0000
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
- [Medium] scsi: qla2xxx: qla2x00_loop_reset() stalls 10s and skips FCP-2 s=
ession deletion
--

commit 58a127391fc6a3fa18dd4432ba3a5356192f9875
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Wait for session deletion before full-login LIP

This commit replaces qla2x00_mark_all_devices_lost() with
qla2x00_wait_for_sess_deletion() in qla2x00_loop_reset() so that fcport
session deletions and workqueue items complete before issuing a full-login
LIP mailbox command.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c0efdbff5da71..0e5e672e81ee6 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1752,7 +1752,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
>  	if (ha->flags.enable_lip_full_login && !IS_CNA_CAPABLE(ha)) {
>  		atomic_set(&vha->loop_state, LOOP_DOWN);
>  		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
> -		qla2x00_mark_all_devices_lost(vha);
> +		qla2x00_wait_for_sess_deletion(vha);
>  		ret =3D qla2x00_full_login_lip(vha);

[Severity: Medium]
When a logged-in FCP-2 target (FCF_FCP2_DEVICE) is present and ql2xfc2target
is enabled (which defaults to 1), will calling
qla2x00_wait_for_sess_deletion() from qla2x00_loop_reset() stall for the fu=
ll
10-second timeout and still leave the FCP-2 session undeleted when
qla2x00_full_login_lip() is issued?

qla2x00_loop_reset() is called from qla2xxx_eh_bus_reset() (after
qla2x00_wait_for_hba_online() has waited for ISP abort flags to clear) and
from sysfs qla2x00_issue_lip(). In both paths, qla2x00_reset_active(vha) is
false.

When qla2x00_loop_reset() -> qla2x00_wait_for_sess_deletion() calls
qla2x00_mark_all_devices_lost(), any logged-in FCP-2 target is skipped
because !qla2x00_reset_active(vha) is true:

drivers/scsi/qla2xxx/qla_os.c:qla2x00_mark_all_devices_lost() {
	list_for_each_entry(fcport, &vha->vp_fcports, list) {
		if (ql2xfc2target &&
		    fcport->loop_id !=3D FC_NO_LOOP_ID &&
		    (fcport->flags & FCF_FCP2_DEVICE) &&
		    fcport->port_type =3D=3D FCT_TARGET &&
		    !qla2x00_reset_active(vha)) {
			ql_dbg(ql_dbg_disc, vha, 0x211a,
			       "Delaying session delete for FCP2 flags 0x%x port_type =3D 0x%x p=
ort_id=3D%06x %phC",
			       fcport->flags, fcport->port_type,
			       fcport->d_id.b24, fcport->port_name);
			continue;
		}
		fcport->scan_state =3D 0;
		qlt_schedule_sess_for_deletion(fcport);
	}
}

Because qlt_schedule_sess_for_deletion(fcport) is skipped and
qla2x00_full_login_lip(vha) has not been sent yet, vha->fcport_count remains
non-zero and fcport->deleted remains 0. As a result, test_fcport_count(vha)
never becomes true in qla2x00_wait_for_sess_deletion():

drivers/scsi/qla2xxx/qla_os.c:qla2x00_wait_for_sess_deletion() {
	qla2x00_mark_all_devices_lost(vha);

	for (i =3D 0; i < 10; i++) {
		if (wait_event_timeout(vha->fcport_waitQ,
		    test_fcport_count(vha), HZ) > 0)
			break;
	}

	flush_workqueue(vha->hw->wq);
}

After blocking for all 10 iterations (10 * HZ), qla2x00_full_login_lip(vha)
proceeds with the FCP-2 fcport still in DSC_LOGIN_COMPLETE. If the N2N peer
is an FCP-2 target, RIDA processing in qla24xx_report_id_acquisition() will
then hit the default branch and call qlt_schedule_sess_for_deletion(fcport)
(placing it in DSC_DELETE_PEND) right as N2N_LOGIN_NEEDED is set:

drivers/scsi/qla2xxx/qla_mbx.c:qla24xx_report_id_acquisition() {
				switch (fcport->disc_state) {
				case DSC_DELETED:
					set_bit(RELOGIN_NEEDED,
					    &vha->dpc_flags);
					break;
				case DSC_DELETE_PEND:
					break;
				default:
					qlt_schedule_sess_for_deletion(fcport);
					break;
				}
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023101600.1431=
179-1-njavali@marvell.com?part=3D4
