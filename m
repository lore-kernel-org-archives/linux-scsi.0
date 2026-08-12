Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367F7394785
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559178; cv=none; b=EYmiDimnputn6/TgMgburCvGudHE6niX4FRGBYAjuejUoMMJy48G//jZTWu6l+JEJE+GmB4kkPzBOs7wLw41ve0Jasv5+DhVrYE6HjKypfnCQPDf/qHeV60DpyFTjMA+M1h8IeIkIM5cJOGBDlLJ4vMV9maHaepZrNCQ5GpYcho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559178; c=relaxed/simple;
	bh=zfreUv6X3S4YBGNI4FUZLVYZFCFJRPWa9NnjjngkA/U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EhQkU2Jw5dRR71ZIqaD1KiysgZuB6y1mmiIgv7bcxrNFHXC40G0o76e83LktAyfiJirjbaUwEk9f4dnyKmVc0NoK/PVmnvZ1YCaKjRb8ot9jKS04UOwvDEpkRGpzT7qKfTlDymwjme8UYV4qJEV7e+WlKQQX0WP+FpdWld7GMJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/9V1wfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/9V1wfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20A51F000E9;
	Wed, 12 Aug 2026 18:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559176;
	bh=u7idewhhhpOH8UfefRP4ftoE7whuYnAJUbPSBwWJOzc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U/9V1wfDb1x9p4rp++vLU0ctDlmDpqgnZyUlNc8tk64J4uIWN28ZkdKQpEneOF207
	 2tPzAp+JuqnCujKueCv7365Xj/5JE/U/1Qkk4IkHHNBoo4OHMP9Hb9K0gP9lzfFyLK
	 QAOozy9AElZSScQdVw6NvK0Y23owCOJ7bGRj5rpq5lAN6+/eC/O48Pu1B02SF8Oj3G
	 oGhJYvlz1LxD2ZMMgKSjo8+BrAJOk1H9pieesC56g6+IvfWRNKiCj0zXB6O0PKV0+y
	 JUF8BBP+BmwjxaiNF/DB/xbBcCVCeZjkO0jwMQtpnmvv7IWs11b92ThmXBvJwhQeKN
	 2dTvbVbQJXbeg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/13] fc_els: use 'union fc_tlv_desc'
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-2-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-2-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:26:16 +0000
Message-Id: <20260812182616.C20A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:

New issues:
- [High] ABI and Wire Protocol Breakage: `union fc_tlv_desc` introduces 8-b=
yte alignment, inserting 4-byte padding before `desc[]` in ELS response str=
uctures.
- [High] Build Failure: Flexible array members nested inside a union and de=
clared as an array violate the C standard.
- [High] UAPI Source Breakage: Redefining `struct fc_tlv_desc` as `union fc=
_tlv_desc` breaks userspace compilation.
- [High] Undefined Behavior: Casting unaligned network offsets to a union r=
equiring 8-byte alignment crashes strict-alignment architectures.

Pre-existing issues:
- [High] Undefined Behavior: Overlapping memory regions in `memcpy` during =
descriptor shifting.
- [High] Race Condition / Use-After-Free: `fc_find_rport_by_wwpn()` returns=
 an rport pointer without acquiring a reference.
- [High] Out-of-Bounds Read: Signed integer underflow in `bytes_remain` log=
ic bypasses length validation.
- [High] Out-of-Bounds Read: Missing minimum payload length validation prio=
r to parsing specific descriptors.
--

--- Patch [1]: [PATCH 01/13] fc_els: use 'union fc_tlv_desc' ---
commit 96c48d7bf5ab3d34f4f3bb76d985ca1b29c2c877
Author: Hannes Reinecke <hare@kernel.org>
Subject: fc_els: use 'union fc_tlv_desc'

This commit introduces union fc_tlv_desc to provide a common structure for
all FC ELS TLV structures, helping to avoid type casts when managing these
descriptors.

> diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
> --- a/include/uapi/scsi/fc/fc_els.h
> +++ b/include/uapi/scsi/fc/fc_els.h
> @@ -259,12 +259,12 @@ enum fc_ls_tlv_dtag {
[ ... ]
> +union fc_tlv_desc {
> +	struct fc_tlv_desc_hdr hdr;
> +	struct fc_els_lsri_desc lsri;
> +	struct fc_fn_li_desc li;
> +	struct fc_fn_deli_desc deli;
> +	struct fc_fn_peer_congn_desc peer_congn;
> +	struct fc_fn_congn_desc congn;
> +	struct fc_df_desc_fpin_reg fpin_reg;
> +	struct fc_diag_lnkflt_desc lnkflt;
> +	struct fc_diag_cg_sig_desc cg_sig;
> +};

[Severity: High]
Does changing struct fc_tlv_desc into a union break UAPI source
compatibility? Userspace applications that were previously compiling with
struct fc_tlv_desc will now fail to compile against these headers.

[ ... ]
> +static inline union fc_tlv_desc *fc_tlv_next_desc(union fc_tlv_desc *des=
c)
> +{
> +	return (union fc_tlv_desc *)((__u8 *)desc + FC_TLV_DESC_SZ_FROM_LENGTH(=
desc));
> +}

[Severity: High]
Can this cast lead to unaligned access panics on strict-alignment
architectures? The pointer math calculates an offset that is only guaranteed
to be 4-byte aligned, but it is then cast to union fc_tlv_desc. Because this
union contains 64-bit fields, the compiler expects 8-byte alignment, which
might trigger undefined behavior when dereferenced later in paths like
lpfc_els_rcv_edc().

[ ... ]
>  struct fc_els_fpin {
>  	__u8		fpin_cmd;	/* command (0x16) */
>  	__u8		fpin_zero[3];	/* specified as zero - part of cmd */
>  	__be32		desc_len;	/* Length of Descriptor List (in bytes).
>  					 * Size of ELS excluding fpin_cmd,
>  					 * fpin_zero and desc_len fields.
>  					 */
> -	struct fc_tlv_desc	fpin_desc[];	/* Descriptor list */
> +	union fc_tlv_desc	fpin_desc[];	/* Descriptor list */
>  };

[Severity: High]
Will this build successfully on standard C compilers? The C standard forbids
unions containing flexible array members from being elements of an array.
Nesting flexible array members inside the union fc_tlv_desc and then
declaring an array of that union might trigger a build constraint violation.

[ ... ]
>  struct fc_els_rdf_resp {
>  	struct fc_els_ls_acc	acc_hdr;
>  	__be32			desc_list_len;	/* Length of response (in
>  						 * bytes). Excludes acc_hdr
>  						 * and desc_list_len fields.
>  						 */
>  	struct fc_els_lsri_desc	lsri;
> -	struct fc_tlv_desc	desc[];	/* Supported Descriptor list */
> +	union fc_tlv_desc	desc[];	/* Supported Descriptor list */
>  };

[Severity: High]
Does this structure layout change break the wire protocol? By introducing
union fc_tlv_desc containing 64-bit members, the union adopts an 8-byte
alignment requirement. Because fc_els_lsri_desc ends at a 4-byte aligned
boundary, the compiler will silently insert 4 bytes of padding before the
desc array. This could corrupt the network payload offsets in ELS responses.
This same padding issue applies to the modified fc_els_edc_resp structure.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
[ ... ]
> @@ -9482,7 +9478,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct l=
pfc_iocbq *cmdiocb,
>  			goto out;
>  		}
> =20
> -		dtag =3D be32_to_cpu(tlv->desc_tag);
> +		dtag =3D be32_to_cpu(tlv->hdr.desc_tag);

[Severity: High]
This isn't a bug introduced by this patch, but does the bytes_remain loop
logic properly handle underflows? If a malicious or malformed payload causes
bytes_remain to become negative, it might bypass the length check in the wh=
ile
loop because the negative value could be implicitly cast to size_t when
compared against FC_TLV_DESC_HDR_SZ, resulting in out-of-bounds kernel memo=
ry
reads.

[ ... ]
> @@ -10374,22 +10367,22 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, voi=
d *p, u32 fpin_length)
>  	/* process each descriptor separately */
>  	while (bytes_remain >=3D FC_TLV_DESC_HDR_SZ &&
>  	       bytes_remain >=3D FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
> -		dtag =3D be32_to_cpu(tlv->desc_tag);
> +		dtag =3D be32_to_cpu(tlv->hdr.desc_tag);
>  		switch (dtag) {
>  		case ELS_DTAG_LNK_INTEGRITY:
> -			lpfc_els_rcv_fpin_li(phba, tlv);
> +			lpfc_els_rcv_fpin_li(phba, &tlv->li);

[Severity: High]
This is a pre-existing issue, but does this parsing code ensure the TLV
payload is large enough before casting and accessing the specific structure?
The loop validates the TLV header length, but immediately dispatches to
parsing routines like lpfc_els_rcv_fpin_li which map the payload to larger
structures. This missing minimum payload length validation might lead to
reading out of bounds during structural extraction.

[ ... ]
>  		/* Sanity check descriptor length. The desc_len value does not
>  		 * include space for the desc_tag and the desc_len fields.
>  		 */
> -		len -=3D (cnt + sizeof(struct fc_tlv_desc));
> +		len -=3D (cnt + sizeof(struct fc_tlv_desc_hdr));
>  		if (len < 0) {

[Severity: High]
This is a pre-existing issue, but could the memcpy further down in this
routine cause undefined behavior?

If desc_cnt is true, the code calls:
    memcpy(first_tlv, current_tlv, (cnt + sizeof(struct fc_els_fpin)));

The source and destination memory regions for the descriptors overlap here
since they are being shifted in-place within the same buffer. This should
probably use memmove instead.

> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transpo=
rt_fc.c
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -776,12 +776,11 @@ fc_fpin_pname_stats_update(struct Scsi_Host *shost,
>   *
>   */
>  static void
> -fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
> +fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_fn_li_desc *l=
i_desc)
>  {
>  	struct fc_rport *rport =3D NULL;
>  	struct fc_rport *attach_rport =3D NULL;
>  	struct fc_host_attrs *fc_host =3D shost_to_fc_host(shost);
> -	struct fc_fn_li_desc *li_desc =3D (struct fc_fn_li_desc *)tlv;
>  	u16 event_type =3D be16_to_cpu(li_desc->event_type);
> =20
>  	rport =3D fc_find_rport_by_wwpn(shost,
>  				      be64_to_cpu(li_desc->attached_wwpn));
>  	if (rport &&

[Severity: High]
This isn't a bug introduced by this patch, but does fc_find_rport_by_wwpn()
safely manage the returned pointer?=20

It appears to return an rport pointer without acquiring a reference. Since =
it
drops the host_lock before returning:

    if (rport->port_name =3D=3D wwpn) {
        spin_unlock_irqrestore(shost->host_lock, flags);
        return rport;
    }

Concurrent destruction pathways could potentially free the structure while
it is being used here in fc_fpin_li_stats_update(), leading to a
use-after-free condition.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D1
