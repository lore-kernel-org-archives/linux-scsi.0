Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F19731E84A
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 02:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783651368; cv=none; b=bpMwx7nre24MZbjkyx/i79M2SPaCojDX/vEwsy5lBqcBg/Ae9Z77Fjz3FhtWCagEoOETSqnxi3mRlZsbapCBtp1FOlT0RSFoRCq5fzxLfOFcJ0l4AG+oLzluFL1BbA98xu/XTjadMqNJ69ZIDhIOB+kXEqVPhhad4azz4u/bhZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783651368; c=relaxed/simple;
	bh=JnG1eLiwUACxjfKGSKVSwnCh21QMhClTc0gDtye7tJY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WLM6bBXw7rf3OG8WoXOKjJj29lAk9wBHYtwP26wGb2ksLsrPcHvmDkdiM68vpY0Lj//KWj7Phju3rfm6KO/zE8pdfWYl4mAs3WGEg5NYypS72VbrtiIwmv2lgcx4peV1qHKPm32s7Dv8xuUXRZB70Wa5Yz/NxZJ8oBDp2t/RZX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jsgsfq3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jsgsfq3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4271F000E9;
	Fri, 10 Jul 2026 02:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783651367;
	bh=DyTMGm5Z3gVMYE9BL0CnSFas+qZVU73Cet2rjU/QLRk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jsgsfq3YJ0+/C+gC1IWKFtPVcrl0YGLkhT8JrNPX38loaaOECbKSo558RNOcD+sxV
	 qpqLVOii99qB+szImUZzAIoUWOHzk0x5uICt9rYv2c7B30w4xjV8E43il/xrRfLgMr
	 tAu8fSvr64+xKRPj+LbxcDxxxS2COU9I36fZkssypwLt8dG5ZztZ0ml1DdDq0IqEED
	 cm0bWiQ0jWlT3MLIAdPtCOZb9bKBQD7RM3d6uO4lkOT5Ra1OkFADyJXyzdS9AXvi2U
	 KvS//U8MQULgPva9oHJPmv2wWaXD2ZFYqszaPtF1+hrT3pQJMP1mwPoHocR9CrEjdF
	 voityk/mbaa1Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: lpfc: bound EDC descriptor list by payload
 length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Bommarito" <michael.bommarito@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260710022932.3741311-2-michael.bommarito@gmail.com>
References: <20260710022932.3741311-1-michael.bommarito@gmail.com>
 <20260710022932.3741311-2-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 02:42:46 +0000
Message-Id: <20260710024246.DF4271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] An integer overflow in the FC_TLV_DESC_SZ_FROM_LENGTH macro al=
lows an attacker to bypass bounds checks, resulting in kernel panics or inf=
inite loops.
- [High] Missing bounds check on unknown TLV descriptors in lpfc_els_rcv_ed=
c() and lpfc_cmpl_els_edc() allows KASAN out-of-bounds read.
--

--- Patch [1]: [PATCH 1/2] scsi: lpfc: bound EDC descriptor list by payload=
 length ---
commit 12e45848685e8826e33fd1952148968b98cdc126
Author: Michael Bommarito <michael.bommarito@gmail.com>

    scsi: lpfc: bound EDC descriptor list by payload length
   =20
    drivers/scsi/lpfc/lpfc_els.c:lpfc_els_rcv_edc() trusts the EDC
    descriptor-list length from the received frame without checking that it
    fits in the actual ELS payload. An adjacent Fibre Channel fabric peer or
    device can send an unsolicited EDC frame with a short payload and an
    oversized descriptor-list length. The TLV walk can then read past the
    receive buffer and trip a KASAN slab-out-of-bounds read in the LPFC ELS
    receive path.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 52fc5058976d9..0023524528d93 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
[ ... ]
> @@ -9443,25 +9444,39 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct=
 lpfc_iocbq *cmdiocb,
>  	uint8_t *payload;
>  	uint32_t *ptr, dtag;
>  	const char *dtag_nm;
> -	int desc_cnt =3D 0, bytes_remain;
> +	int desc_cnt =3D 0;
> +	u32 bytes_remain, desc_len, word2 =3D 0;

[Severity: High]
This is a pre-existing issue, but does changing bytes_remain to u32 bypass
the while loop condition if we encounter an unknown TLV descriptor?

If an adjacent peer sends an EDC frame with an unrecognized descriptor tag,
we hit the default case in lpfc_els_rcv_edc() (and lpfc_cmpl_els_edc()),
where we subtract the unvalidated parsed TLV length from bytes_remain:

drivers/scsi/lpfc/lpfc_els.c:lpfc_els_rcv_edc() {
    ...
		default:
			dtag_nm =3D lpfc_get_tlv_dtag_nm(dtag);
			...
		}
		bytes_remain -=3D FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
		tlv =3D fc_tlv_next_desc(tlv);
    ...
}

Since bytes_remain is now u32, subtracting an unvalidated length could
underflow to a large positive value. This would bypass the=20
bytes_remain < FC_TLV_DESC_HDR_SZ check on the next iteration and lead to
an out-of-bounds memory read.

[ ... ]
> @@ -9491,7 +9506,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct l=
pfc_iocbq *cmdiocb,
>  				lpfc_printf_log(phba, KERN_WARNING,
>  					LOG_ELS | LOG_CGN_MGMT | LOG_LDS_EVENT,
>  					"6465 Truncated Link Fault Diagnostic "
> -					"descriptor[%d]: %d vs 0x%zx 0x%zx\n",
> +					"descriptor[%d]: %u vs 0x%zx 0x%zx\n",
>  					desc_cnt, bytes_remain,
>  					FC_TLV_DESC_SZ_FROM_LENGTH(tlv),

[Severity: Critical]
This isn't a bug introduced by this patch, but can FC_TLV_DESC_SZ_FROM_LENG=
TH
overflow and bypass bounds checks entirely?

Looking at the macro definition:

include/uapi/scsi/fc/fc_els.h:
#define FC_TLV_DESC_SZ_FROM_LENGTH(tlv)		\
		(__be32_to_cpu((tlv)->desc_len) + FC_TLV_DESC_HDR_SZ)

It performs an unchecked addition of 8 to an attacker-controlled 32-bit
integer. If an attacker crafts a desc_len near the 32-bit maximum limit
(e.g., 0xFFFFFFF8), the macro could overflow to exactly 0 on 32-bit systems,
or 4GB on 64-bit systems.

In lpfc_els_rcv_fpin(), an overflow to 0 allows this bounds check to pass
incorrectly:

drivers/scsi/lpfc/lpfc_els.c:lpfc_els_rcv_fpin() {
    ...
	while (bytes_remain >=3D FC_TLV_DESC_HDR_SZ &&
	       bytes_remain >=3D FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
    ...
}

Since the evaluated length is 0, neither bytes_remain nor the tlv pointer
would advance, causing an infinite loop. On 64-bit systems, this could lead
to a panic when the large offset is applied to the pointer.

>  					sizeof(struct fc_diag_lnkflt_desc));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710022932.3741=
311-1-michael.bommarito@gmail.com?part=3D1
