Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689C14D2EFE
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784815792; cv=none; b=lWzPzx0nAtj2pxjjJpCNwkGdJuqOaa8QFezSMPDcqjU5e3qh1MsIVmgHson40FPQlvO/drveICqS5108LtJYPeIdME5pDbr0Q9v8OsRgke1QVyPfI1rzGE34HRmV12z2eQSAJADj2QeS806c88uBwapEsfE2uhaUd9jS0o+EfD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784815792; c=relaxed/simple;
	bh=jsWOX4OFvnPvkG0l2YdssimSQQMdjn1KRTEWj1kFzX4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UaPUWYxFKgqFMpuluw2ZKrYi2CdlyMsZBOVd+8voPjtQj0wxvSGJti8C0cYP+6fqmbMca9ECkFKXPZX12giVZsViMkR3/Jsckobxs+Ef2FTKaZCxrhLRjKra3eygwMOW1fR61HJ7EikLQ7z3ftU6mVm6P0UfBgdaSR5BrTfjcGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oT4pPN5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oT4pPN5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53771F000E9;
	Thu, 23 Jul 2026 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784815788;
	bh=Q89e8Uxpp8LQR3TG5ATVj+kUeSnPU+slIjq80+cuz6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oT4pPN5yjNkT0ELPSrYX+IhqNIrsqil/Ls8jkq60/x93eqBoy1ABIRn/KnH26Hen/
	 K+8gd6kyLcP3UXnYuDDRWV9VAE25fZuIZvdflTTooC+N3DVvxgUh+rQ1/tBzxlxjJq
	 q5efxgwO/ACrSTPSCEMJLOXoIOmCMdvekrDp3/0tmA0TxyO7qoDopWry39TXsCHgJz
	 tquTwtmFjBeUdM2Jj42eHwU9Nef9C0Q/6vTfnAbe9O+vbhueStDSo0wTAKNx7nVgg0
	 KGuXbK6osnjfPzUnsgEZyG4aDCot8lcOvXt/9DYLOqGHBTJ3elvvt9ZNr1BOeCBch4
	 jf/DJSHVM9T+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 28/56] scsi: qla2xxx: Enhance purex_entry handling
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-29-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-29-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 14:09:48 +0000
Message-Id: <20260723140948.B53771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:

New issues:
- [High] The 9-bit virtual port index (`vp_idx`) from 29xx hardware is sile=
ntly truncated to 8 bits.
- [High] Incorrect response IOCB bitfield corruption for 29xx hardware due =
to writing via a legacy 24xx struct view.
- [High] Buffer over-read in continuation IOCB parsing on 29xx hardware tri=
ggers a FORTIFY_SOURCE panic.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but a crafted ELS pa=
yload containing `0xDEADDEAD` at offset 16 will permanently hang the respon=
se queue.
- [High] This problem wasn't introduced by this patch, but `__qla_consume_i=
ocb` consumes an extra, unrelated IOCB and fails to clear the original pack=
et's signature.
- [High] This problem wasn't introduced by this patch, but there is a data =
race between `atomic_inc_return` and non-atomic `memset` on the default PUR=
EX item.
- [High] This problem wasn't introduced by this patch, but there is an infi=
nite polling loop inside interrupt context causing potential hard lockup.
--

--- Patch [28]: [PATCH v6 28/56] scsi: qla2xxx: Enhance purex_entry handlin=
g for 29xx series ---
commit 44ae6bdcc8dd39ac0f056b9473fb3475613ffb9b
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Enhance purex_entry handling for 29xx series

This patch updates purex_entry handling to support the 29xx series by
differentiating between standard 64-byte and 128-byte extended structures.
It reuses overlapping byte views to avoid duplicating read paths.

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2544,26 +2544,55 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void =
**pkt, struct rsp_que **rsp)
[ ... ]
> +	uint8_t vp_idx;
> +	struct purex_entry_24xx *p =3D *pkt;
[ ... ]
> +	if (IS_QLA29XX(ha))
> +		vp_idx =3D le16_to_cpu(((struct purex_entry_24xx_ext *)
> +				      *pkt)->vp_idx);

[Severity: High]
Does assigning the 16-bit packed vp_idx value to a uint8_t local variable
truncate the 9-bit virtual port index for 29xx hardware? This looks like it
might cause responses for NPIV virtual ports with IDs 256 and above to be
misrouted or dropped.

[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -202,6 +202,11 @@ void __qla_consume_iocb(struct scsi_qla_host *vha,
[ ... ]
>  	entry_count_remaining =3D purex->entry_count;
>  	while (entry_count_remaining > 0) {
>  		new_pkt =3D rsp_q->ring_ptr;
>  		*pkt =3D new_pkt;

[Severity: High]
This is a pre-existing issue, but does __qla_consume_iocb skip the first
packet and over-consume the ring buffer?

The loop executes entry_count times starting from the next packet:

    while (entry_count_remaining > 0) {
        new_pkt =3D rsp_q->ring_ptr;
        *pkt =3D new_pkt;

Could this consume and silently drop the next valid IOCB while leaving the
original IOCB signature uncleared?

[ ... ]
> @@ -262,14 +275,24 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host=
 *vha,
[ ... ]
> +	if (IS_QLA29XX(ha)) {
> +		struct purex_entry_24xx_ext *purex_ext =3D *pkt;
> =20
> -	memcpy(buf, &purex->els_frame_payload[0], no_bytes);
> +		memcpy(buf, &purex_ext->els_frame_payload[0], no_bytes);
> +	} else {
> +		memcpy(buf, &purex->els_frame_payload[0], no_bytes);
> +	}

[Severity: High]
Is there a risk of a FORTIFY_SOURCE buffer over-read panic during continuat=
ion
IOCB parsing on 29xx hardware?

In __qla_copy_purex_to_buffer and similar functions, the data pointer is
extracted using the sts_cont_entry_t structure:

    data =3D ((sts_cont_entry_t *)*pkt)->data;
    data_sz =3D qla_sts_cont_data_size(ha);

Since sts_cont_entry_t->data is statically defined as a 60-byte array,
FORTIFY_SOURCE sets __builtin_object_size to 60. On 29xx hardware, data_sz
returns 124 bytes. Could the subsequent memcpy trigger a panic by attempting
to copy up to 124 bytes from a 60-byte object?

[ ... ]
> @@ -867,6 +891,13 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha,=
 void **pkt,
[ ... ]
> +	} else if (IS_QLA29XX(ha)) {
> +		purex_ext =3D *pkt;
> +		total_bytes =3D (le16_to_cpu(purex_ext->frame_size) & 0x0FFF) -
> +			      PURX_ELS_HEADER_SIZE;

[Severity: High]
This is a pre-existing issue, but can the spin loop in
qla27xx_copy_multiple_pkt cause a hard lockup?

If the hardware fails to provide the next packet, the code executes an
unbounded spin loop in interrupt context:

    if (rsp_q->ring_ptr->signature =3D=3D RESPONSE_PROCESSED) {
        ql_dbg(...);
        cpu_relax();
        continue;
    }

Could a hardware fault or maliciously crafted entry_count trap the CPU
forever?

[ ... ]
> @@ -1075,9 +1110,9 @@ qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint=
16_t size)
[ ... ]
>  	} else {
>  		if (atomic_inc_return(&vha->default_item.in_use) =3D=3D 1) {
>  			item =3D &vha->default_item;

[Severity: High]
This is a pre-existing issue, but is there a data race when acquiring the
default PUREX item?

In qla24xx_alloc_purex_item, the code uses atomic_inc_return to acquire the
item:

    if (atomic_inc_return(&vha->default_item.in_use) =3D=3D 1) {

However, in qla24xx_free_purex_item, the memory is cleared with a non-atomic
memset:

    memset(&item->vha->default_item, 0, sizeof(struct purex_item));

Could two threads simultaneously acquire the default_item if the memset
clears the in_use field while another thread is checking it out?

[ ... ]
> @@ -4151,6 +4201,8 @@ void qla24xx_process_response_queue(struct scsi_qla=
_host *vha,
[ ... ]
>  		case PUREX_IOCB_TYPE:
> -			purex_entry =3D (void *)pkt;
> -			switch (purex_entry->els_frame_payload[3]) {
> +			if (IS_QLA29XX(ha)) {
> +				purex_entry_ext =3D (void *)pkt;

[Severity: High]
This is a pre-existing issue, but can the response queue permanently hang if
a crafted ELS payload contains 0xDEADDEAD at offset 16?

In qla24xx_process_response_queue, the signature field is evaluated to
determine if the hardware has written a new IOCB:

    while (rsp->ring_index !=3D rsp_in &&
           rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED) {

Because the signature field overlaps with bytes 16-19 of the
els_frame_payload, could a malicious payload prematurely terminate the poll=
ing
loop and prevent further packets from being processed?

[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -6209,15 +6211,26 @@ void qla24xx_process_purex_rdp(struct scsi_qla_ho=
st *vha,
[ ... ]
> +	if (IS_QLA29XX(ha)) {
> +		vp_idx =3D le16_to_cpu(
> +		    ((struct purex_entry_24xx_ext *)purex)->vp_idx);
> +		purex_sz =3D sizeof(struct purex_entry_24xx_ext);

[Severity: High]
Similarly, does extracting the 16-bit vp_idx and storing it in a uint8_t
local variable truncate the value before assigning it to the response IOCB?

[ ... ]
> @@ -6257,7 +6270,7 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host=
 *vha,
>  	rsp_els->handle =3D 0;
>  	rsp_els->nport_handle =3D purex->nport_handle;
>  	rsp_els->tx_dsd_count =3D cpu_to_le16(1);
> -	rsp_els->vp_index =3D purex->vp_idx;
> +	rsp_els->vp_index =3D vp_idx;
>  	rsp_els->sof_type =3D EST_SOFI3;
>  	rsp_els->rx_xchg_address =3D purex->rx_xchg_addr;

[Severity: High]
Will writing to rsp_els->vp_index and rsp_els->sof_type byte-by-byte corrupt
the packed bitfield on 29xx hardware?

In the 24xx struct view, these are separate bytes, but on 29xx they overlap
with the __le16 vp_idx_sof packed bitfield. Writing EST_SOFI3 to the 8-bit
sof_type could clear the 9th bit of vp_index and set the wrong frame
properties.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D28
