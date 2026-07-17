Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A887337F72C
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 18:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784312963; cv=none; b=usGXxXoYhrmCNrfm7qg95gaHdkQxzUkHSVQY5YACQK4CXtCe2ZNMPLDbT3OyHDgh+EQ0nQIUT/Z0jn2OXuvB7ddJ0jfZ59902zP6fBy4P7LWQ8HxJIQPUxFOhzP8w5dHMamag5YIYbBHO1ViUF8LStMD3zgdWg7rH1sSPcYu32k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784312963; c=relaxed/simple;
	bh=9d+03km1AS2HkR18QvMmHCq+F62gi/5SJBDDXcc4+r0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BS3VTL5SB57+ABvUFGrEHrbDlwaSDeUjOqM63i9ZqMWUfF+LfYcXWz3b8BqFm+naVuliBamvU/pxcadH7z4xGq/gNsRPfzafcKfshd0UaLo7BmpsB7CUJLIqLekSIhmoDTRfHedDsDsZpHN1hSqj3Qypt7rjrrh0TB1uOlsCofU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZET9Rid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZET9Rid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052331F000E9;
	Fri, 17 Jul 2026 18:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312961;
	bh=pOP/Fb5TqkqNwHPSXKoN0ftjxfml/pjYYqDHxWRnQcg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cZET9Rid2J+pAXjA06WPenChMRq9H6rkPJ48WqnMUTI1HIbJRD78GUyYGP1uGsvXO
	 RicgamguAFvLgtMwTNHIbguPVEDvfSb3z/26OrfgnbwDZkYNRrfmXrftOiMqHjYcRM
	 SYfmQ/heQvgkbcQlayhjlx3jO9bDuNmCdW6+OUKz28hFD6566dZzqSAHfgaW+yTdyI
	 ntnecwAUvLXVMCyKMuW1K+yRywGtnMJHIsSoBFcwCy9WydMPpXS87IfmDTUqHDj+1f
	 v8f2aY8GrkxjdQChfkyRJSi3v/EuoeXYPU4Vh5SrM5DeBer07dckNP73ixE0hFonB/
	 HUTgu4h/O/paQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 28/56] scsi: qla2xxx: Enhance purex_entry handling
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-29-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-29-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 18:29:20 +0000
Message-Id: <20260717182921.052331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] The `vp_idx` is truncated to 8 bits, and the 24xx struct layout is=
 incorrectly used to populate the 29xx response IOCB, corrupting vport inde=
xing and SOF type.
- [High] `memcpy` from `sts_cont_entry_t->data` triggers a `FORTIFY_SOURCE`=
 panic on 29xx hardware because it copies up to 124 bytes from an array wit=
h a statically defined size of 60 bytes.
- [High] Mismatched DMA free size for `rsp_els` on QLA29XX adapters.

Pre-existing issues:
- [High] `__qla_consume_iocb` skips marking the head slot as processed and =
prematurely marks unrelated future slots, leading to dropped hardware respo=
nses.
- [High] `qla24xx_alloc_purex_item` has a data race on `default_item.in_use=
` with `qla24xx_free_purex_item`.
--

--- Patch [28]: [PATCH v5 28/56] scsi: qla2xxx: Enhance purex_entry handlin=
g for 29xx series ---
commit 778e5ac5d8bcf791b8a97a7b9c1906d28083e550
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enhance purex_entry handling for 29xx series

This commit updates function signatures and internal logic across qla_edif.=
c,
qla_isr.c, and qla_os.c to differentiate between standard and extended purex
structures based on IS_QLA29XX(). It ensures proper initialization and
processing of command and response data for 64-byte and 128-byte PUREX IOCBs
across ELS paths.

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index b05f8e0b705ee..ade1d81785736 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
[ ... ]
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

[Severity: High]
Does this code truncate the 9-bit virtual port index?

Since vp_idx is defined as a uint8_t, assigning the 16-bit vp_idx from
the 29xx extended structure drops the MSB, which might corrupt the
vport index routing.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 5aa45b8f49290..75ce09933afc1 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
[ ... ]
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
This is a pre-existing issue, but does the loop in __qla_consume_iocb()
corrupt the ring tracking by skipping the head slot?

If the caller, such as qla24xx_process_response_queue(), advances the ring
pointer before calling this function, the loop will grab the next slot:

void __qla_consume_iocb(...)
{
    ...
    while (entry_count_remaining > 0) {
        new_pkt =3D rsp_q->ring_ptr;
        *pkt =3D new_pkt;
        qla_rsp_ring_advance(rsp_q);
        new_pkt->signature =3D RESPONSE_PROCESSED;
        ...
    }
}

This marks the newly advanced pointer as processed and leaks the original
head slot, which can lead to hardware hangs or dropped responses.

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

[Severity: High]
Can the subsequent continuation loop in __qla_copy_purex_to_buffer()
overread the sts_cont_entry_t buffer on 29xx hardware?

Further down in this function (and similarly in qla27xx_copy_multiple_pkt
and qla2x00_status_cont_entry), the code copies data from the continuation
entry:

    data =3D ((sts_cont_entry_t *)*pkt)->data;
    data_sz =3D qla_sts_cont_data_size(ha);
    ...
    memcpy((buf + buffer_copy_offset), data, no_bytes);

On 29xx hardware, qla_sts_cont_data_size(ha) returns 124. However, the data
array in sts_cont_entry_t is statically defined as 60 bytes. Copying up to
124 bytes from a 60-byte array triggers a FORTIFY_SOURCE panic.

[ ... ]
> @@ -1126,14 +1161,20 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, st=
ruct purex_item *pkt,
>  static struct purex_item
>  *qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
>  {
> +	struct qla_hw_data *ha =3D vha->hw;
>  	struct purex_item *item;
> +	u16 copy_sz;
> =20
> -	item =3D qla24xx_alloc_purex_item(vha,
> -					QLA_DEFAULT_PAYLOAD_SIZE);
> +	if (IS_QLA29XX(ha))
> +		copy_sz =3D sizeof(struct purex_entry_24xx_ext);
> +	else
> +		copy_sz =3D QLA_DEFAULT_PAYLOAD_SIZE;
> +
> +	item =3D qla24xx_alloc_purex_item(vha, copy_sz);

[Severity: High]
This is a pre-existing issue, but does allocating the fallback purex item
race with freeing it?

In qla24xx_alloc_purex_item(), the fallback item is claimed via:

    if (atomic_inc_return(&vha->default_item.in_use) =3D=3D 1) {
        item =3D &vha->default_item;

However, qla24xx_free_purex_item() resets it using a non-atomic memset:

    if (item =3D=3D &item->vha->default_item)
        memset(&item->vha->default_item, 0, sizeof(struct purex_item));

If another CPU calls atomic_inc_return() concurrently with the memset, the
atomic increment could be lost, allowing multiple CPUs to claim the
default item at the same time and corrupting memory.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 0b7c4ee73ebfd..c327d053f8eee 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
[ ... ]
> @@ -6209,15 +6211,26 @@ void qla24xx_process_purex_rdp(struct scsi_qla_ho=
st *vha,
>  	uint8_t *sfp =3D NULL;
>  	uint16_t sfp_flags =3D 0;
>  	uint rsp_payload_length =3D sizeof(*rsp_payload);
> +	uint8_t vp_idx;
> +	size_t purex_sz;
>  	int rval;
> =20
>  	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0180,
>  	    "%s: Enter\n", __func__);
> =20
> +	if (IS_QLA29XX(ha)) {
> +		vp_idx =3D le16_to_cpu(
> +		    ((struct purex_entry_24xx_ext *)purex)->vp_idx);
> +		purex_sz =3D sizeof(struct purex_entry_24xx_ext);
> +	} else {

[Severity: High]
Does this code truncate the 9-bit virtual port index, similar to the logic
in qla24xx_auth_els()?

The vp_idx is defined as a uint8_t, which causes the 16-bit vp_idx from
the extended structure to lose its MSB.

> @@ -6257,7 +6270,7 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host=
 *vha,
>  	rsp_els->handle =3D 0;
>  	rsp_els->nport_handle =3D purex->nport_handle;
>  	rsp_els->tx_dsd_count =3D cpu_to_le16(1);
> -	rsp_els->vp_index =3D purex->vp_idx;
> +	rsp_els->vp_index =3D vp_idx;
>  	rsp_els->sof_type =3D EST_SOFI3;

[Severity: High]
Does freeing rsp_els result in a size mismatch on 29xx hardware, and does
this corrupt the bitfield on 29xx?

This function dynamically allocates rsp_els_pkt using rsp_els_sz, which
is 128 bytes on 29xx hardware, and then casts it to the 64-byte
struct els_entry_24xx:

    if (IS_QLA29XX(ha))
        rsp_els_sz =3D sizeof(struct els_entry_24xx_ext);
    ...
    rsp_els_pkt =3D dma_alloc_coherent(..., rsp_els_sz, ...);
    rsp_els =3D rsp_els_pkt;

In the cleanup paths, the memory is freed using sizeof(*rsp_els), which
evaluates statically to 64 bytes:

    dma_free_coherent(&ha->pdev->dev, sizeof(*rsp_els), rsp_els, rsp_els_dm=
a);

This passes a 64-byte size to free a 128-byte DMA allocation.

Additionally, writing the 8-bit EST_SOFI3 to the legacy sof_type offset on
the 29xx extended layout misaligns with the __le16 bitfield on
little-endian systems, incorrectly setting sof_type to 1 instead of 2.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D28
