Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E9823EA83
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781261649; cv=none; b=k9nUXPZAR3JKmdQWVQHYVFypUgLA0knpDvN3XjhKhCadI7lZKetr3k8rCHhrrse/ie71+XBq5xgg87z0c4XUb6a4jjG5Zg1w4fxBXaSO97nHNQrXtQpZ6BCQY30X2eP2qQWBSPOxGc9qpqyDUC2M49GPZ2J2ui3SP8qFjjqNhU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781261649; c=relaxed/simple;
	bh=HiLWXmx+kWeDkvXvEDfjwt06CfEMMdyiJOecNTjaxk0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YlRYcJ3k3Q2uWLJkkqGwCiHc12qnUw4B0h8EG23KhEPDkSszV/nD/NFu2M1nqUZQdAutbMM0jGBvLUUdtxrQPuRJ8nqBj2qJ0spxWg5fDOG5VNxYdlv99KBkduUclMzL/t4bkqj2Mhjex1KMFhBGQ2SPd0vgncWjqwCBCADaEg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTw3xu5E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTw3xu5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B0B1F000E9;
	Fri, 12 Jun 2026 10:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781261648;
	bh=AjjlP2fa4qxtd69liiTSura7TrHQDlRWHi69bAke/iw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TTw3xu5EluueeV8h9pJfWohtQToTVH5JY809RRHPSAAclaZLsBJ8qUpo3x3M7fP/2
	 zTKrPHQc3LB/f2t0Rhhh3s6uCCQUcL/TtpGK0KyKcO2Vb28amBdE7D0+rLqo38FdZ2
	 JF+OnfdPxWEZH8snLHpinL6jv5CI96GjlTS/Q4pV2jsy6fqwPQg0amIEPSHRWN1+zn
	 8+mWAuiBhIQ2FSB6rUWM5+XIuOIWnI5osuyasf95xQFqISorfe02lj90z1kuG6iyES
	 NBa9Hpw2yYRFyjJFLF2koogt1wnBf+OA792wg7Jk8JfvgsIBj6DxmUWL6xWoEnWXqt
	 FN4HSbV1+72+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 31/60] scsi: qla2xxx: Enhance purex_entry handling
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-32-njavali@marvell.com>
References: <20260612095333.1666592-32-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:54:07 +0000
Message-Id: <20260612105408.16B0B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The 9-bit `vp_idx` field extracted from QLA29XX extended IOCBs is =
silently truncated to 8 bits when assigned to a `uint8_t` local variable an=
d other 8-bit struct fields.

Pre-existing issues:
- [Critical] The response queue polling logic overlaps the `signature` fiel=
d with untrusted ELS payload data, allowing a remote attacker to wedge the =
queue or cause a kernel hard lockup.
- [High] Failure to correctly mark the head IOCB signature and over-consump=
tion of IOCBs in `__qla_consume_iocb` leads to ring slot leaks and queue co=
rruption.
--

commit 01f1d63d6b8d4fcc9af6e64914963d0a1cf5920b
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Enhance purex_entry handling for 29xx series

This commit updates the QLogic qla2xxx driver to handle both standard and
extended 29xx series purex_entry structures. It uses a generic pointer to
process command and response data efficiently, branching only where field
encodings like vp_idx and els_frame_payload lengths differ.

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index b05f8e0b705ee..f8bc248e5d18e 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2544,26 +2544,58 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void =
**pkt, struct rsp_que **rsp)
>  	struct fc_port *fcport;
>  	struct qla_els_pt_arg a;
>  	be_id_t beid;
> +	__le16 nport_handle;
> +	__le32 rx_xchg_addr;
> +	__le16 ox_id;
> +	__le16 frame_size, status_flags, trunc_frame_size;
> +	uint8_t s_id[3], d_id[3];
> +	uint8_t vp_idx;
> =20
>  	memset(&a, 0, sizeof(a));
> =20
> +	/*
> +	 * purex_entry_24xx_ext (29xx) overlays purex_entry_24xx for every
> +	 * field touched here -- nport_handle, rx_xchg_addr, ox_id, frame_size,
> +	 * status_flags, trunc_frame_size, s_id[3], d_id[3] -- with only
> +	 * vp_idx differing in width (u8 at offset 6 vs __le16 at offsets 6-7,
> +	 * with reserved2 at offset 7 in the 24xx layout). So all reads but
> +	 * vp_idx go through a single struct purex_entry_24xx * view.
> +	 */
> +	{
> +		struct purex_entry_24xx *p =3D *pkt;
> +
> +		nport_handle =3D p->nport_handle;
> +		rx_xchg_addr =3D p->rx_xchg_addr;
> +		ox_id =3D p->ox_id;
> +		frame_size =3D p->frame_size;
> +		status_flags =3D p->status_flags;
> +		trunc_frame_size =3D p->trunc_frame_size;
> +		memcpy(s_id, p->s_id, sizeof(s_id));
> +		memcpy(d_id, p->d_id, sizeof(d_id));
> +		if (IS_QLA29XX(ha))
> +			vp_idx =3D le16_to_cpu(((struct purex_entry_24xx_ext *)
> +					      *pkt)->vp_idx);

[Severity: High]
Does this code inadvertently truncate the 16-bit vp_idx from QLA29XX extend=
ed
IOCBs to 8 bits?

The local variable vp_idx is declared as uint8_t, and it is later assigned
to a.vp_idx (which is a u8 in struct qla_els_pt_arg) and
purex->pur_info.vp_idx. For NPIV ports with an index of 256 or higher, could
this wrap around and direct ELS responses to the wrong virtual port?

> +		else
> +			vp_idx =3D p->vp_idx;
> +	}
> +

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index f81cf70a0542c..76c66f060b7b4 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -202,6 +202,11 @@ void __qla_consume_iocb(struct scsi_qla_host *vha,
>  	struct rsp_que *rsp_q =3D *rsp;
>  	response_t *new_pkt;
>  	uint16_t entry_count_remaining;
> +	/*
> +	 * entry_count is u8 at offset 1 in both purex_entry_24xx and
> +	 * purex_entry_24xx_ext, so the 24xx view is layout-compatible with
> +	 * either stride.
> +	 */
>  	struct purex_entry_24xx *purex =3D *pkt;
> =20
>  	entry_count_remaining =3D purex->entry_count;

[Severity: High]
This is a pre-existing issue, but does __qla_consume_iocb() consume too many
IOCBs from the ring?

By the time this function is called, the main polling loop in
qla24xx_process_response_queue() has already advanced rsp->ring_ptr past the
head IOCB. Since this loop runs purex->entry_count times, doesn't it
start consuming from the second IOCB and steal one IOCB belonging to the
next hardware packet?

Additionally, does this mean the head IOCB's signature is never marked as
RESPONSE_PROCESSED, potentially causing queue corruption when the ring wraps
around?

[ ... ]

> @@ -914,6 +945,8 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, =
void **pkt,
> =20
>  	if (is_purls)
>  		memcpy(iocb_pkt, &purls->payload[0], no_bytes);
> +	else if (IS_QLA29XX(ha))
> +		memcpy(iocb_pkt, &purex_ext->els_frame_payload[0], no_bytes);
>  	else
>  		memcpy(iocb_pkt, &purex->els_frame_payload[0], no_bytes);
>  	buffer_copy_offset +=3D no_bytes;
> @@ -922,6 +955,8 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, =
void **pkt,
> =20
>  	if (is_purls)
>  		((response_t *)purls)->signature =3D RESPONSE_PROCESSED;
> +	else if (IS_QLA29XX(ha))
> +		((struct response_ext *)purex_ext)->signature =3D RESPONSE_PROCESSED;
>  	else
>  		((response_t *)purex)->signature =3D RESPONSE_PROCESSED;

[Severity: Critical]
This is a pre-existing issue, but does the hardware polling logic here over=
lap
the signature field with untrusted ELS payload data?

In the purex_entry_24xx and purex_entry_24xx_ext structures, the payload
array physically overlaps the signature field at offset 60. Could a remote
FC port craft an unsolicited packet with the RESPONSE_PROCESSED byte sequen=
ce
(e.g., 0xDEADDEAD) at this offset, causing the response queue to be perceiv=
ed
as already processed?

If so, would this lead to an infinite cpu_relax() soft-lockup loop in
qla27xx_copy_multiple_pkt() or otherwise wedge the queue?

>  	wmb();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D31
