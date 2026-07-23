Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5051FFC48
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 16:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824319; cv=none; b=tQ1ilY7bmuu/06M8aUM/HuaHOpISMX9zsuCxPLn5Rw9Bo09icTkxAJz6RCWM/RgMuHKHwuQM8R/Gi9zLl3CztiDSs5aBvEv2jPbyjg3wbjfmwDOgN+8/7Tm9jbayBq4FspJ9yZkablQhpljv2lq+FmPGC4keki5RakQAkc0LiNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824319; c=relaxed/simple;
	bh=/md4hGaJGsCwsMvk58MIbOw59Lh375auAytxLEqKQMg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=geUM9xFANgF4HuJD6FJc+TL6VKmQKvcJU0UJvixWsdCgKErSJnriiulDjaz9uLJpX/EvJbtwlUx4Es6K0Ywb4ciopmMxkp5j77XCQsk3CB4MqP18r4vEwKRdU1IGqqxL/PsoRK5dy7fKTu5dKBt6wK9gsXoCPpMIPPsFV4dHtlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652631F000E9;
	Thu, 23 Jul 2026 16:31:57 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 37/56] scsi: qla2xxx: Add size check for extended VP
 report ID entry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-38-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-38-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 16:31:55 +0000
Message-Id: <20260723163157.652631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Extracting `vp_idx` and `vp_status` using C bitfields over a littl=
e-endian `__le16` type causes undefined behavior and data corruption on Big=
-Endian architectures.

Pre-existing issues:
- [High] The vport pointer (`vp`) is accessed after `ha->vport_slock` is re=
leased without holding a reference, leading to a potential Use-After-Free.
- [High] The `fcport` list is traversed locklessly for Format 2 RIDA IOCBs,=
 and the found `fcport` is accessed after dropping `tgt.sess_lock` without =
holding a reference, leading to data races and Use-After-Free.
- [High] Missing `dma_rmb()` read barrier after polling the hardware DMA re=
sponse queue signature.
--

--- Patch [37]: [PATCH v6 37/56] scsi: qla2xxx: Add size check for extended=
 VP report ID entry ---
commit b119ba076c242111b3050f1eff45472d3fdf947f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add size check for extended VP report ID entry

Add reserved_end[64] padding to bring the struct to 128 bytes, matching
the hardware IOCB stride. Change qla24xx_report_id_acquisition() to
accept a void pointer and extract vp_idx and vp_status from the extended
structure on 29xx series adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_f=
w29.h
> index 088a220472a50..a4aa5bacb171a 100644
> --- a/drivers/scsi/qla2xxx/qla_fw29.h
> +++ b/drivers/scsi/qla2xxx/qla_fw29.h

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 128138b4d16a9..085961e04ec2d 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -4175,8 +4175,7 @@ void qla24xx_process_response_queue(struct scsi_qla=
_host *vha,

[Severity: High]
This isn't a bug introduced by this patch, but looking at
qla24xx_process_response_queue(), is a dma_rmb() read barrier needed after
polling the hardware DMA response queue signature?

The driver checks if the signature is valid:

	while (rsp->ring_index !=3D rsp_in &&
		       rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED) {
		pkt =3D (void *)rsp->ring_ptr;
		cur_ring_index =3D rsp->ring_index;

		qla_rsp_ring_advance(rsp);

		if (((response_t *)pkt)->entry_status !=3D 0) {

Without a dma_rmb() barrier after observing the valid signature, can the CPU
speculatively reorder reads and fetch the queue entry payload before the
hardware's DMA write is fully visible?

>  			    qla_sts_cont_data_size(rsp->hw));
>  			break;
>  		case VP_RPT_ID_IOCB_TYPE:
> -			qla24xx_report_id_acquisition(vha,
> -			    (struct vp_rpt_id_entry_24xx *)pkt);
> +			qla24xx_report_id_acquisition(vha, pkt);
>  			break;
>  		case LOGINOUT_PORT_IOCB_TYPE:
>  			qla24xx_logio_entry(vha, rsp->req, pkt);

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 3ebda35dd584f..cec308811d9eb 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4086,15 +4086,18 @@ qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint=
16_t loop_id,
>  }
> =20
>  void
> -qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
> -	struct vp_rpt_id_entry_24xx *rptid_entry)
> +qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
>  {
>  	struct qla_hw_data *ha =3D vha->hw;
> +	struct vp_rpt_id_entry_24xx *rptid_entry =3D pkt;
> +	struct vp_rpt_id_entry_24xx_ext *rptid_entry_ext =3D pkt;
>  	scsi_qla_host_t *vp =3D NULL;
>  	unsigned long   flags;
>  	int found;
>  	port_id_t id;
>  	struct fc_port *fcport;
> +	u16 vp_idx;
> +	u8 vp_status;
> =20
>  	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b6,
>  	    "Entered %s.\n", __func__);
> @@ -4102,6 +4105,14 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
>  	if (rptid_entry->entry_status !=3D 0)
>  		return;
> =20
> +	if (IS_QLA29XX(ha)) {
> +		vp_idx =3D rptid_entry_ext->vp_idx;
> +		vp_status =3D rptid_entry_ext->vp_status;

[Severity: High]
Does this extract the wrong bits on big-endian architectures?

struct vp_rpt_id_entry_24xx_ext defines vp_idx and vp_status as bitfields
over an __le16 type:

	__le16	vp_idx : 9;		/* VP Index 9bits */
	__le16	vp_status : 7;		/* VP Status 7bits */

Since C bitfield layout is implementation- and endian-dependent, the
compiler on big-endian CPUs typically allocates the first bitfield to the
most significant bits.

Since the hardware writes the DMA data in little-endian format, should this
be defined as a single __le16 field and parsed via le16_to_cpu() combined
with bitwise masks to ensure it is endian-safe?

> +	} else {
> +		vp_idx =3D rptid_entry->vp_idx;
> +		vp_status =3D rptid_entry->vp_status;
> +	}
> +
>  	id.b.domain =3D rptid_entry->port_id[2];
>  	id.b.area   =3D rptid_entry->port_id[1];

[ ... ]

> @@ -4241,18 +4251,18 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vh=
a,
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
This is a pre-existing issue, but can this lead to a use-after-free of the
vp pointer?

In qla24xx_report_id_acquisition(), the code iterates over ha->vp_list while
holding ha->vport_slock to find a matching vp. Once found, the lock is
released without taking a reference count (e.g., atomic_inc(&vp->vref_count=
)).

Can vp be concurrently removed from the list and freed by qla24xx_vport_del=
ete(),
resulting in a use-after-free when the unreferenced vp is subsequently pass=
ed
to qla_update_host_map(vp, id)?

[ ... ]

[Severity: High]
This is also a pre-existing issue, but I see fcport accessed outside of its
protective lock in qla24xx_report_id_acquisition().

In the Format 1 path, sess_lock is held during lookup but dropped immediate=
ly:

	fcport =3D qla2x00_find_fcport_by_wwpn(vha,
	    rptid_entry->u.f1.port_name, 1);
	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);

	if (fcport) {
		fcport->plogi_nack_done_deadline =3D jiffies + HZ;

Could a concurrent session deletion free this memory, causing a use-after-f=
ree
when fcport is modified?

Also, in the Format 2 path, the list is traversed locklessly:

	list_for_each_entry(fcport, &vha->vp_fcports, list) {
		fcport->scan_state =3D QLA_FCPORT_SCAN;
		fcport->n2n_flag =3D 0;
	}

	fcport =3D qla2x00_find_fcport_by_wwpn(vha,
	    rptid_entry->u.f2.port_name, 1);

Can this cause list corruption or a crash on stale pointers if other contex=
ts
modify this list under sess_lock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D37
