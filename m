Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555CD3BE17D
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783408779; cv=none; b=jicEnJX8Jc6xVaTPJVXUum2zZ4N2cWpnIUHgkSdi75etiTV+s4I6vus/IDEZ5q5932iiokTj7Ol9W9aMOZn7wyskef7DnFquugNsN7R4b403EFHNQYdWJUB9I5VA8iEIBSZEqRq4UBPLl3E+6u6Aq01gRqOgq17emX3Xq5+QPp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783408779; c=relaxed/simple;
	bh=aI8jmyacnOEzJmVLXRfo7XMV3X3BaNf6ebKI5RKnBaI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EgXBoiaZRTv61ivk6YoRd0vH/xKCXFRb+wRYw12G1B66NF2G32DVgxOf1XIohxrr91WwkqGtwgTfeO27T5o7i0KlGFZy3ne2WCNyxAvXMGg+ND75Q6YMi5w88o3CAIHQKYk5iY0H97tufTaiRjVmaalTDnYqjEVYjXjRmeQKOsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfsVXCEk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfsVXCEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944DC1F000E9;
	Tue,  7 Jul 2026 07:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783408772;
	bh=R0KJRb1iCfLedTZLuNopMdOJitoiIgu0/9YNJHxhNfk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OfsVXCEkWkhBXQjtIz6awhpdsRhhKmIjcejpB8lMRbaHLcFm7qN+AVq7jBOYrecjA
	 unR0wJXuglSC9ZfdgaVFl61iEYSjlaikQZRBp4N+nKK2SKIi8QdPEw6kFn71GHz2UR
	 qN/siqQ6lOVxX57Y1jWhQ1oYsFG6Gp9FSEJl/l4O/pWlQPBJ9Kc7QOTMHPAokfwkqG
	 rHAAUFXQNmQjoawGwfiGfTFZE3aC3K0pmw5WLVoh/YKT25ltbx8mKNDz5crnQhF0mC
	 kvihsTyddeBYSAIQpn59YakdY+p+zPibrUyJgBfBUYwey5POfcN5IbPvA+MJvqxomd
	 bAwzVxNO2sk8A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 69/88] scsi: qla2xxx: Fix soft lockup polling
 continuation IOCB signature
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-70-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-70-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:19:32 +0000
Message-Id: <20260707071932.944DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Incomplete fix for payload aliasing lockup: The head IOCB also=
 carries raw payload at offset 60, which aliases the `signature` field chec=
ked in the outer response queue loop.
- [High] Bypassing the `rsp_q_out` register update when deferring IOCB proc=
essing causes response queue entries to leak, potentially leading to a firm=
ware deadlock.
- [High] Encountering an invalid continuation IOCB in `qla27xx_copy_fpin_pk=
t()` or `qla27xx_copy_multiple_pkt()` causes the driver to permanently dead=
lock the response queue instead of recovering or dropping the frame cleanly.
--

--- Patch [69]: [PATCH v3 69/88] scsi: qla2xxx: Fix soft lockup polling con=
tinuation IOCB signature ---
commit dac7bfdc42a973841c8497f7fb4cafd346a7adea
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature

This commit removes the polling of `rsp_q->ring_ptr->signature` for=20
`RESPONSE_PROCESSED` in `qla27xx_copy_multiple_pkt()` and=20
`qla27xx_copy_fpin_pkt()` to prevent a CPU soft lockup when raw FC frame
payload aliases the signature field. It replaces the wait with a check=20
for available continuation IOCBs before processing.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index c36a2c69c219c..497a0fef742fa 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c

[ ... ]

> @@ -1299,14 +1291,6 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, v=
oid **pkt,
> =20
>  	do {
>  		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
> -			if (rsp_q->ring_ptr->signature =3D=3D RESPONSE_PROCESSED) {
> -				ql_dbg(ql_dbg_async, vha, 0x5084,
> -				       "Ran out of IOCBs, partial data 0x%x\n",
> -				       buffer_copy_offset);
> -				cpu_relax();
> -				continue;
> -			}
> -
>  			*pkt =3D rsp_q->ring_ptr;
>  			data =3D ((sts_cont_entry_t *)*pkt)->data;
>  			data_sz =3D qla_sts_cont_data_size(ha);

[Severity: High]
This isn't a bug introduced by this patch, but does encountering an invalid
continuation IOCB cause the response queue to permanently deadlock?

If the firmware provides an unexpected IOCB type during this loop:

qla27xx_copy_fpin_pkt() {
    ...
    if (((sts_cont_entry_t *)*pkt)->entry_type !=3D STATUS_CONT_TYPE) {
        ql_log(ql_log_warn, vha, 0x507a, "Unexpected IOCB type...\n", ...);
        break;
    }
    ...
}

The loop breaks early and returns NULL without advancing the ring pointer v=
ia
qla_rsp_ring_advance(). The caller, qla24xx_process_response_queue(), then
unconditionally executes:

    ((response_t *)pkt)->signature =3D RESPONSE_PROCESSED;

This overwrites the stranded IOCB. On the next interrupt, the outer loop se=
es
rsp->ring_ptr->signature =3D=3D RESPONSE_PROCESSED on this stranded IOCB and
immediately terminates, never advancing the hardware consumer index.

[ ... ]

> @@ -4271,9 +4255,24 @@ void qla24xx_process_response_queue(struct scsi_ql=
a_host *vha,
>  					       "SCM not active for this port\n");
>  					break;
>  				}
> +				if (qla_chk_cont_iocb_avail(vha, rsp,
> +				    (response_t *)pkt, rsp_in)) {
> +					/*
> +					 * ring_ptr and ring_index were
> +					 * pre-incremented above. Reset them
> +					 * back to current. Wait for next
> +					 * interrupt with all IOCBs to arrive
> +					 * and re-process.
> +					 */
> +					qla_rsp_ring_rewind_to(rsp,
> +					    (response_t *)pkt, cur_ring_index);
> +
> +					ql_dbg(ql_dbg_init, vha, 0x5095,
> +					    "Defer processing FPIN...\n");
> +					return;

[Severity: High]
This is a pre-existing issue, but does this early return skip the hardware
doorbell update?

When deferring IOCB processing, returning directly skips the mandatory
doorbell update at the end of qla24xx_process_response_queue():

    wrt_reg_dword(rsp->rsp_q_out, rsp->ring_index);

If other IOCBs were successfully processed in previous iterations of the
while loop during the same interrupt, the firmware will not be notified
that those slots have been freed. Could this cause the response queue to
fill up and stall?

[Severity: Critical]
This is also a pre-existing issue, but does the same payload aliasing lockup
fixed by this patch still exist for the head IOCB?

The outer loop in qla24xx_process_response_queue() polls the signature fiel=
d:

    while (rsp->ring_index !=3D rsp_in &&
           rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED) {

The head IOCB structures (like purex_entry_24xx) carry raw payloads spanning
offset 60, just like the continuation IOCBs. If an incoming ELS or
pass-through frame has 0xDEADDEAD at offset 16-19 of its payload, the driver
sees signature =3D=3D RESPONSE_PROCESSED and prematurely terminates the loo=
p.

Since the consumer pointer is not advanced past this IOCB, could every
subsequent interrupt immediately break the loop and permanently deadlock the
response queue?

> +				}
>  				pure_item =3D qla27xx_copy_fpin_pkt(vha,
>  							  (void **)&pkt, &rsp);
> -				__update_rsp_in(is_shadow_hba, rsp, rsp_in);
>  				if (!pure_item)
>  					break;
>  				qla24xx_queue_purex_item(vha, pure_item,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D69
