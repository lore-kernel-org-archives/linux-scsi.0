Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E458234887E
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784305771; cv=none; b=DmM/u6AC5t301zievhxaFOOfx4l6jp5HRN4QLlHFrgdr18cHtuNUOZ83Qk8bjynikU/mzPuYAWKKpphHU5lx6KnGTP7JoqTVEP1asOkI1MSbEwuo2uML5a6SxLqPe8Kpl+mn2Sy+4FMR7gAodgKS876QWmq0sknFt1gzhlbpknY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784305771; c=relaxed/simple;
	bh=0CpiOxsbivItxBQj5QLSzwWxg4SCsn6YmuPqP7YTcjw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kJ4ObFBnqTEpBmcz8ANorYTFSDSwG5t+Xboo5reRHqa6ni1/hmei//v6p0uQCw5dyWLR9F7ocHqUfxZwk7o2Rdw2kran72sQ9HFri7BTxvtSKoB3FI6OQfXWia6Zz8eZmAKkAw1JBaSWcG5omVNwMNCu+V4Eq06qj0uOYZWqnQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PS+A0FT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PS+A0FT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819A21F000E9;
	Fri, 17 Jul 2026 16:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784305769;
	bh=ExtJLL+Py8VVutiyjFcWreIoBVBHTaL44ip3wu9zoiE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PS+A0FT49t1SQeVgWHke6WPd6O1co6ySCw1S3aqQ3ZAogDQMIwuO+yKcJT9uvZsXr
	 1+r0mA4RU2/w/LHEhRjbqevRLqk6398AbkJ5XueqGsa9nm2aOlSf5BgXNubLiy7T++
	 U1RAC8kKDsFRUuAky809kC/05pflmEpcOUkcHpGvhKj88BB+yLYAUVHOAvbflrA77K
	 NTQ9U/8y6di7CmonXMmZIvDPzD+H8v5X+s7yFABTwbyqACrGDcC9L4lPh4LcBDHVUB
	 ah01MqNv495X6AjaXmZ+0sfNjJ/4P45v/CCfJww0jb+0gTt7POEhhmf6Cmns1xGNny
	 ODDsD5TUkopbw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 37/56] scsi: qla2xxx: Add size check for extended VP
 report ID entry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-38-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-38-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:29:29 +0000
Message-Id: <20260717162929.819A21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] The patch series introduces C bitfields (`__le16 vp_idx : 9`, `__l=
e16 vp_status : 7`) in a hardware descriptor structure and directly extract=
s them, which breaks on Big-Endian architectures.

Pre-existing issues:
- [High] The `bbcr` field is accessed and masked without being converted to=
 CPU byte order, erroneously disabling buffer-to-buffer credits on big-endi=
an architectures.
- [High] The virtual port (`vp`) pointer is accessed and modified after `ha=
->vport_slock` is dropped, without acquiring a reference count.
- [High] DMA pool memory is freed immediately upon mailbox command timeout =
without guaranteeing firmware quiescence, leading to DMA corruption.
- [High] `qla_update_host_map` is called locklessly, violating its requirem=
ent for `ha->vport_slock`.
- [High] Unprotected traversal of `vha->vp_fcports` and lockless modificati=
ons to `fcport` state.
--

--- Patch [37]: [PATCH v5 37/56] scsi: qla2xxx: Add size check for extended=
 VP report ID entry ---
commit aa254942b9f9f6093a5fcd8b950678e07b111a9c
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add size check for extended VP report ID entry

Add reserved_end[64] padding to bring the struct to 128 bytes, matching
the hardware IOCB stride. Change qla24xx_report_id_acquisition() to
accept a void pointer and extract vp_idx and vp_status from the extended
structure on 29xx series adapters, maintaining data integrity for the
larger IOCB format.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 3ebda35dd584f..cec308811d9eb 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
[ ... ]
> @@ -4102,6 +4105,14 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
>  	if (rptid_entry->entry_status !=3D 0)
>  		return;
> =20
> +	if (IS_QLA29XX(ha)) {
> +		vp_idx =3D rptid_entry_ext->vp_idx;
> +		vp_status =3D rptid_entry_ext->vp_status;
> +	} else {
> +		vp_idx =3D rptid_entry->vp_idx;
> +		vp_status =3D rptid_entry->vp_status;
> +	}
> +

[Severity: High]
Are we sure these bitfields are safe on big-endian architectures?

Memory layout of C bitfields is implementation-defined, and on big-endian
platforms, GCC typically allocates bitfields starting from the most
significant bit. Reading the 16-bit little-endian IOCB value from the
hardware will yield mixed bits for vp_idx and vp_status, which might cause
the driver to configure the wrong virtual port or fail entirely.

[ ... ]
> @@ -4223,8 +4233,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
>  		/* buffer to buffer credit flag */
>  		vha->flags.bbcr_enable =3D (rptid_entry->u.f1.bbcr & 0xf) !=3D 0;
> =20

[Severity: High]
This is a pre-existing issue, but does evaluating
(rptid_entry->u.f1.bbcr & 0xf) !=3D 0 without applying le16_to_cpu()
incorrectly check the least significant bits of the host's integer
representation?

On big-endian machines, this checks bits 8-11 of the little-endian value
instead of bits 0-3, which might improperly disable the buffer-to-buffer
credit feature.

> -		if (rptid_entry->vp_idx =3D=3D 0) {
> -			if (rptid_entry->vp_status =3D=3D VP_STAT_COMPL) {
> +		if (vp_idx =3D=3D 0) {
> +			if (vp_status =3D=3D VP_STAT_COMPL) {
>  				/* FA-WWN is only for physical port */
>  				if (qla_ini_mode_enabled(vha) &&
>  				    ha->flags.fawwpn_enabled &&
>  				    (rptid_entry->u.f1.flags &
>  				     BIT_6)) {
>  					memcpy(vha->port_name,
>  					    rptid_entry->u.f1.port_name,
>  					    WWN_SIZE);
>  				}
> =20
>  				qla_update_host_map(vha, id);

[Severity: High]
This is a pre-existing issue, but is it safe to call qla_update_host_map()
here without holding ha->vport_slock?

qla_update_host_map() modifies the B-tree ha->host_map, which doesn't appear
to be thread-safe. Other parts of the codebase hold the lock before updating
it. Could this result in a data race that corrupts the B-tree?

>  			}
> =20
>  			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
>  			set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
>  		} else {
> -			if (rptid_entry->vp_status !=3D VP_STAT_COMPL &&
> -				rptid_entry->vp_status !=3D VP_STAT_ID_CHG) {
> +			if (vp_status !=3D VP_STAT_COMPL &&
> +				vp_status !=3D VP_STAT_ID_CHG) {
>  				ql_dbg(ql_dbg_mbx, vha, 0x10ba,
>  				    "Could not acquire ID for VP[%d].\n",
> -				    rptid_entry->vp_idx);
> +				    vp_idx);
>  				return;
>  			}
> =20
>  			found =3D 0;
>  			spin_lock_irqsave(&ha->vport_slock, flags);
>  			list_for_each_entry(vp, &ha->vp_list, list) {
> -				if (rptid_entry->vp_idx =3D=3D vp->vp_idx) {
> +				if (vp_idx =3D=3D vp->vp_idx) {
>  					found =3D 1;
>  					break;
>  				}
>  			}

[Severity: High]
This is a pre-existing issue, but is the virtual port pointer protected
against concurrent deletion after the lock is dropped?

After dropping ha->vport_slock at the end of this loop, the code does not
increment vp->vref_count via atomic_inc(). If the virtual port is
concurrently removed and freed, could the subsequent use of vp (e.g. in
qla_update_host_map(vp, id)) lead to a use-after-free?

[Severity: High]
This is a pre-existing issue, but is it safe to traverse vha->vp_fcports
and modify fcport states in this file without holding
vha->hw->tgt.sess_lock?

In format =3D=3D 2 processing later in qla24xx_report_id_acquisition(), the
code traverses the list locklessly:

    list_for_each_entry(fcport, &vha->vp_fcports, list) {
        fcport->scan_state =3D QLA_FCPORT_SCAN;
        fcport->n2n_flag =3D 0;
    }

In format =3D=3D 1 processing, the lock is acquired for the lookup but drop=
ped
before modifying fields like fcport->plogi_nack_done_deadline. Since no
reference count is taken on the pointer, could this risk a use-after-free
if a concurrent deletion occurs?

[Severity: High]
This is a pre-existing issue, but in timeout paths like
qla24xx_login_fabric(), is it safe to immediately free DMA pool memory
without guaranteeing firmware quiescence?

When a mailbox command times out, a DMA buffer from ha->s_dma_pool is freed
immediately via dma_pool_free():

    dma_pool_free(ha->s_dma_pool, lg_buf, lg_dma);

Since scheduling an ISP abort does not synchronously halt the hardware, cou=
ld
the active firmware complete the delayed IOCB and write its response to the
freed DMA physical address, causing silent DMA memory corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D37
