Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13F048B386
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784040345; cv=none; b=I7cNjrld8GYd4jfAFrUJAaMkojJdApqsw0S5Fh8A8Qvmh7d6qOZbU7DUWKyS/I8xHfi1rduNRqaX2qqDhmHPL30ddIawarpAfwkOGJ137JVH/8lkAilPt/DIHKPs/Mowty2SNIG6FklOWcGr3aslPOsRylMxyxGhKIEdnI1dkYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784040345; c=relaxed/simple;
	bh=g8+FdO5HZZZFmj2dKMQ7ZkrTuGgdt/j3xIv+blShv+8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HFPp56KjHIUkvgWOzBZKP0J/csbVqr6LxpjQulnpaMYkodtsZWrRsEms7RnNMCduVqnEFJktKY1VMriRH63o0VqHFPfvWXlGi3HDiQpTIKSUwKNq0GrF+GZeB6wPezc15b4diVlOHUMOmCBBUYw7Su3EFHCcpyhsAb1STzW2sXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWccVwuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWccVwuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709391F00A3A;
	Tue, 14 Jul 2026 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784040334;
	bh=PFioTFMNI9ILoZUKuN82nJxHNrVsDL/cN7kHlPpsJpo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bWccVwuDOcMCof7dOXQX/KrYMve6213+EK+y1B6aEHMLdyxvJ6o9EzRR3ytoId9UK
	 dmbgWdvo2ysUoRuqJQ2igFDHjhV8u/atubhbiAhQwb59v1+NxXjWajM45z0iNdd6ta
	 ZrbtcYjjABpqcQeHA0CGNirD71wc6E2+z3K04Wl/xJPHliVkqLKSYcC8QrCk/pcmtH
	 7CZCekfPp1N9RqtBInF8vQdgWqYmqaaU7/HcNYOjMqng3xYe4Sc24UVAEcJBcYAKsU
	 2HSAU0KYULOIgSzgwSRtNo13XbI6TP5XtmcCdSHtyEGEnKgSIdxjfNNvKtpSKFSh+l
	 Ox8ftkpu6t0lg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 28/56] scsi: qla2xxx: Enhance purex_entry handling
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-29-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-29-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 14:45:33 +0000
Message-Id: <20260714144534.709391F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Critical] Incomplete fix for FORTIFY_SOURCE buffer limits in continuatio=
n IOCBs on QLA29xx adapters, leading to guaranteed kernel panics on multi-I=
OCB frames.
- [Medium] Silent truncation of the 16-bit Virtual Port (VP) index to 8 bit=
s, breaking >255 VP support on 29xx adapters.

Pre-existing issues:
- [Critical] `__qla_consume_iocb` incorrectly loops `entry_count` times wit=
hout accounting for the already-consumed head IOCB, skipping the head signa=
ture and discarding unrelated IOCBs.
--

--- Patch [28]: [PATCH v4 28/56] scsi: qla2xxx: Enhance purex_entry handlin=
g for 29xx series ---
commit 91252616a5e800941a18bc247ce6eecf4c680a85
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enhance purex_entry handling for 29xx series

This updates function signatures and internal logic across multiple files
to accept a generic pointer for packet data. It differentiates between
standard purex_entry_24xx and extended purex_entry_24xx_ext structures
based on the IS_QLA29XX() macro to support 64-byte and 128-byte IOCBs.

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index b05f8e0b705ee..ade1d81785736 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2544,26 +2544,55 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void =
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
> +	struct purex_entry_24xx *p =3D *pkt;
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
> +	nport_handle =3D p->nport_handle;
> +	rx_xchg_addr =3D p->rx_xchg_addr;
> +	ox_id =3D p->ox_id;
> +	frame_size =3D p->frame_size;
> +	status_flags =3D p->status_flags;
> +	trunc_frame_size =3D p->trunc_frame_size;
> +	memcpy(s_id, p->s_id, sizeof(s_id));
> +	memcpy(d_id, p->d_id, sizeof(d_id));
> +	if (IS_QLA29XX(ha))
> +		vp_idx =3D le16_to_cpu(((struct purex_entry_24xx_ext *)
> +				      *pkt)->vp_idx);
> +	else
> +		vp_idx =3D p->vp_idx;

[Severity: Medium]
Can this silently truncate the virtual port index on 29xx adapters?

The 29xx extended structure defines a 16-bit vp_idx to support 9 bits of
virtual port index data. However, the value is being stored in the new
uint8_t vp_idx local variable in both qla24xx_auth_els() and
qla24xx_process_purex_rdp(). Does this break support for setups with more
than 255 NPIV vports by silently discarding the upper bits?

Additionally, when qla24xx_process_purex_rdp() populates the response
IOCB later on, writing the 8-bit vp_idx and sof_type into rsp_els
overwrites offsets 14 and 15 individually. Could this corrupt the 9th bit
of the __le16 vp_idx_sof union expected by the 29xx firmware?

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index c38771e4202c0..c4e2e62f924ff 100644
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
> @@ -230,6 +235,14 @@ void __qla_consume_iocb(struct scsi_qla_host *vha,
>  		new_pkt =3D rsp_q->ring_ptr;
>  		*pkt =3D new_pkt;

[Severity: Critical]
This is a pre-existing issue, but does this loop correctly handle the head
IOCB?

In __qla_consume_iocb(), the while loop processes entry_count_remaining
items by advancing the ring pointer and marking new_pkt as
RESPONSE_PROCESSED. Because qla24xx_process_response_queue() has already
advanced the ring pointer over the head IOCB before calling this function,
this loop appears to leave the head IOCB's signature unmarked.

Consequently, it looks like it will consume and discard unrelated subsequent
IOCBs by looping entry_count times from the already-advanced position. Could
this lead to response ring corruption or a permanent queue stall when the
ring wraps around and hits the unmarked head IOCB?

[ ... ]

> @@ -262,14 +275,24 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host=
 *vha,
>  	}
> =20
>  	pending_bytes =3D total_bytes =3D tpad;
> -	no_bytes =3D (pending_bytes > sizeof(purex->els_frame_payload))  ?
> -	    sizeof(purex->els_frame_payload) : pending_bytes;
> +	no_bytes =3D (pending_bytes > payload_size) ?
> +		payload_size : pending_bytes;
> +	if (IS_QLA29XX(ha)) {
> +		struct purex_entry_24xx_ext *purex_ext =3D *pkt;
> =20
> -	memcpy(buf, &purex->els_frame_payload[0], no_bytes);
> +		memcpy(buf, &purex_ext->els_frame_payload[0], no_bytes);
> +	} else {
> +		memcpy(buf, &purex->els_frame_payload[0], no_bytes);
> +	}
>  	buffer_copy_offset +=3D no_bytes;
>  	pending_bytes -=3D no_bytes;
>  	--entry_count_remaining;

[Severity: Critical]
Will the continuation IOCB extraction loops trigger a fortify source panic
on 29xx adapters?

Further down in __qla_copy_purex_to_buffer() (and similarly in the loops
for qla27xx_copy_multiple_pkt(), qla27xx_copy_fpin_pkt(), and
qla2x00_status_cont_entry()), the code casts the packet to sts_cont_entry_t,
which defines data as a 60-byte array:

    data =3D ((sts_cont_entry_t *)*pkt)->data;
    data_sz =3D qla_sts_cont_data_size(ha);
    ...
    memcpy((buf + buffer_copy_offset), data, no_bytes);

However, on 29xx adapters, data_sz can be up to 124 bytes. When memcpy()
attempts to copy up to 124 bytes from a struct member declared as a 60-byte
array, won't this trigger a __read_overflow2_field panic when processing
multi-IOCB PUREX, PURLS, or FPIN frames?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D28
