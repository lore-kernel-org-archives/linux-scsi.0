Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578968;
	b=sw/KPZruRpX/u5xmGTqxHgOBYgWQWRCqtrHthy/MLUbfLHP49a7SEU7SyZiR/86TwoRG
	 9outL6c4IKnKejlytWx0Spe6QNq0u4AIKygO7P6D5XkBtXb9vk9Pn4f3EcRopJ55Uet8d
	 UADoSJzMSvZgti/1haDT7jDNNaAlHNu141QRAFg8ir2V+Du2oPnSbPkJzI3oYf50vcG6N
	 UR7giV+8VIO0N5QfREiauJ2hZ026u8deVK35kv5/jgfJoqviJm+jP8PszzuFzqmrfEirk
	 CWIXt9a+flhR63EY5QlDIPIeyF/z7jG1xYg72I8VSKG3ZduKzhy3NBiQ6RWUaLnYeYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578968;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Rn/W3qmVgAqbdrUSKZsvfOz3jFl9o9L2KjD1Z6+UmoM=;
	b=RlQh3Txz6hKFyltfeUTIvE3TsVS68Sdlh8GrqCjJCd4PX6qjksiO3ujWFVzEp6d6TK+z
	 4F1frUjuHzEEUJznRBeazefgHt6X76/X+7SIxwsfMQdyLxgDTCkMuHUnsR9jG962kwjjx
	 ZNYcELEntTmEsxOqMXOHzjIGD4wY+4l/4htDrg/9S4BgVzzN1xBujudOjaK4eU2H/HLzY
	 30HEvGmNhfqg8imh64QigkKJ+Ql54+QUF2OYctxHZiB+n4BCMZPrlH/J4X9bW/b1FcUg3
	 mGzVbGMfJma6iXtIXTuGdjOctAZQA3jiZhoETLmIrHVL7GuU/RggxgIky+VXCn8yj4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="W4+S2P/o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D45A606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W4+S2P/o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA1E1F000C9;
	Wed, 21 Oct 2026 10:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792578968;
	bh=Rn/W3qmVgAqbdrUSKZsvfOz3jFl9o9L2KjD1Z6+UmoM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W4+S2P/oHh0p5IYcHijA9p+Ow8TzAnM2c5eIx+ipL4l2uaQaZjTZtZ/hcG32BAZxb
	 d7pcFbk54jZb77uWM3yTf1meaiynAVEWzJzH0y708zCqkJXS0SbI2jurx0fV+vi5xl
	 RqUTJ/twRXEg/RZIomlPsvfG32OGPbdLaLZJi1w8HGY/j5UyXg3waxqJ4B25KOPuDm
	 aIOhW0RFm0H62q4JpdKAwI8ky5NaVVf8A30LxhsaOnNBVoHiz5dCnC3ob0WtWfMY9U
	 BtxnH2VIMk9s4GA/PHHuMWbpk5j5XSdpU8lc41IN1SiVUgKStuojoltgUGisBzfohM
	 LUMHfDFd1f5XA==
Message-ID: <sashiko-outbox-180105@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/14] scsi: qla2xxx: Skip vport DPC processing during
 vport deletion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261021102310.3854868-8-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
 <20261021102310.3854868-8-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 10:36:07 +0000
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
- [High] scsi: qla2xxx: wrong vha delete_progress check in qla2x00_do_dpc_a=
ll_vps()
--

commit 4fbe8fb96efa7d2224539e8ec6860bb2e6e4ec2d
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Skip vport DPC processing during vport deletion

This commit attempts to prevent a race between virtual port dpc processing =
in
qla2x00_do_dpc_all_vps() and virtual port deletion by checking the
delete_progress flag before invoking qla2x00_do_dpc_vp(). A later commit in
the series ("scsi: qla2xxx: Fix use-after-free races during vport deletion")
updates this check from vha to vp, and another follow-up commit ("scsi:
qla2xxx: Re-acquire vport_slock and refresh tvp during vport DPC") further
updates the loop.

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 4ad23d206add2..f7a08bc0093a5 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -439,7 +439,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
> =20
>  	spin_lock_irqsave(&ha->vport_slock, flags);
>  	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> -		if (vp->vp_idx) {
> +		if (vp->vp_idx && !vha->flags.delete_progress) {

[Severity: High]
Should this check vp->flags.delete_progress instead of
vha->flags.delete_progress?

In drivers/scsi/qla2xxx/qla_mid.c:qla2x00_do_dpc_all_vps(), vha is always t=
he
base physical host:

	if (vha->vp_idx)
		return;

Each virtual port on ha->vp_list is represented by the loop iterator vp, and
drivers/scsi/qla2xxx/qla_attr.c:qla24xx_vport_delete() only sets
flags.delete_progress on the virtual port being deleted, never on the base
physical host. Checking vha->flags.delete_progress here causes the condition
to remain true for deleting virtual ports, allowing qla2x00_do_dpc_vp(vp) to
continue running concurrently with teardown and potentially causing a
use-after-free or null pointer dereference.

Although the follow-up commit "scsi: qla2xxx: Fix use-after-free races duri=
ng
vport deletion" changes this to check !vp->flags.delete_progress, this comm=
it
is broken on its own and is tagged for stable.

Additionally, even when checking vp->flags.delete_progress, is delete_progr=
ess
set early enough in drivers/scsi/qla2xxx/qla_attr.c:qla24xx_vport_delete() =
to
prevent races with qla2x00_do_dpc_vp()?

In drivers/scsi/qla2xxx/qla_attr.c:qla24xx_vport_delete():

	set_bit(VPORT_DELETE, &vha->dpc_flags);

	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))
		msleep(1000);


	qla24xx_disable_vp(vha);
	qla2x00_wait_for_sess_deletion(vha);

	qla_nvme_delete(vha);
	qla_enode_stop(vha);
	qla_edb_stop(vha);

	vha->flags.delete_progress =3D 1;

	qlt_remove_target(ha, vha);

	fc_remove_host(vha->host);

	scsi_remove_host(vha->host);

	/* Allow timer to run to drain queued items, when removing vp */
	qla24xx_deallocate_vp_id(vha);

Before flags.delete_progress is set, qla24xx_vport_delete() has already
waited for resync, disabled the vport, deleted sessions, and stopped
nvme/enode/edb. Could qla2x00_do_dpc_vp(vp) still enter during that window =
to
start a new loop resync, configure the vport, process purex items, or queue
relogin work, and then continue executing concurrently with
qlt_remove_target(), fc_remove_host(), and scsi_remove_host() before
qla24xx_deallocate_vp_id() waits for vref_count to drain?

Would it be safer to check test_bit(VPORT_DELETE, &vp->dpc_flags) here, mat=
ching
drivers/scsi/qla2xxx/qla_mid.c:qla2x00_alert_all_vps()?

>  			atomic_inc(&vp->vref_count);
>  			spin_unlock_irqrestore(&ha->vport_slock, flags);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021102310.3854=
868-1-njavali@marvell.com?part=3D7
