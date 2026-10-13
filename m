Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5776552BE5F
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 17:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791913860; cv=none; b=idAnnI2tLnjFVfBevsfbiV18crs1Tu1NvC/rVFh6N8z9MB93YnWSXCAFw6+p4V+dBJsjbyeG37S+nv1Y1qumbKtImVXu09YxLqHnQfEMRT4IQ8nI0d9/4vh4hC79gsk8KYNFDwOkjZeFdlVw/HCkQGRhcf9QLDMwUcOrAUAl7yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791913860; c=relaxed/simple;
	bh=jOKv2iYrXFpVllzIfUGzRbAppcFg2RvraxvOIW63dP8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ak2GPueWr+jRBsh0XDsCPxzYFF0wqQnl0mSokVKACI0l/5C0DpNaVQResPwVXjIRlwMvwkRh9TdkvLXXla1JSQIHRrgrcRFY9as5FLp0mqklaTh8gjKgTAOLB50/XHwtvjl4uQ6HDQpcf/c6VDoJJN6xZz/uLTDZR1c4xAO05Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdNTE1l3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdNTE1l3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D9C1F000FF;
	Tue, 13 Oct 2026 17:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791913857;
	bh=nermlbpyf9Wcy9LbHS+Fib51/leRAHbexP7xNc+HCYU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JdNTE1l3Vpa6Cvogc1FPRQvKZHK26dSOdtUukZEraXlOqxu7XZY7fVFhRtjo2jHy1
	 h3dsMEEsH+dwu7KCOdjCva0kJz2Fu6Cqe1t/+xUvFVlijpX/6dbrW4R1hlOlUk4hzt
	 PrYlx5htXP8cN6JQHHzZmYQBMKHoHEQavpPaCqDqLt/XU7K3hncHHSAPJStcNmTVWp
	 6sBxf85H9iopiNVX1YrYhRGa4v71SnF/rxZ+Z7gDMwvrDk6Jwo3IIooZNimPskIO2/
	 OMqDF1aEoOGvCw/ZdKocaVGKJrBr2Ih0tawbePUjkHDAaVb+hC8otB8y2XKRTE72lo
	 B5VdCU8cUX4iw==
Message-ID: <sashiko-outbox-170275@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: mvumi: reject an out-of-range handshake
 frame length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013173145.3412863-3-yhlee@isslab.korea.ac.kr>
References: <20261013173145.3412863-1-yhlee@isslab.korea.ac.kr>
 <20261013173145.3412863-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 17:50:57 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] scsi: mvumi: Missing READ_ONCE() leads to double-fetch TOCTOU
- [High] scsi: mvumi: integer overflow in mvumi_init_data() allocation size
- [Medium] scsi: mvumi: dead store in handshake abort leads to 30s timeout
- [Medium] scsi: mvumi: missing endian conversion for DMA handshake fields
--

commit 51de9cedc7499343b252f4ceb10b336fff0783a3
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: reject an out-of-range handshake frame length

The patch attempts to fix a vulnerability in mvumi_hs_process_page() where
frame_length from the page header is used without checking it against the
HSP_MAX_SIZE buffer. It adds a bounds check to reject a frame_length that
does not fit the handshake buffer before using it. It reads frame_length on=
ce
into a local variable and uses it for both the bound check and the checksum.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 38a92f8c25f5b..910505ef4f3ee 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -1039,9 +1039,15 @@ static int mvumi_hs_process_page(struct mvumi_hba =
*mhba,
>  {
>  	struct mvumi_hs_page1 *hs_page1;
>  	unsigned char page_checksum;
> +	u16 frame_length =3D hs_header->frame_length;

[Severity: High]
Is a compiler barrier like READ_ONCE() required for this DMA memory read?

Without it, the compiler is free to optimize away the local variable and em=
it
two distinct memory fetches directly from the DMA region (one for the bounds
check, one for mvumi_calculate_checksum()).

If a malicious or misbehaving device changes the memory value between the
bounds check and the checksum calculation, the validation could be bypassed.

Could the re-fetched value of >=3D 256 cause an infinite loop and kernel ha=
ng
inside mvumi_calculate_checksum() because its unsigned char loop counter wi=
ll
indefinitely wrap around?

[Severity: Medium]
Could the unconverted frame_length from DMA memory need to be byte-swapped?

Since the firmware populates the handshake page in little-endian format, it
seems this newly added bounds check uses a byte-swapped raw value. Might th=
is
break initialization entirely on big-endian architectures by triggering a
false positive failure?

This also appears to be an issue when the device capabilities are assigned:

drivers/scsi/mvumi.c:mvumi_hs_process_page() {
    ...
		mhba->max_io =3D hs_page1->max_io_support;
		mhba->list_num_io =3D hs_page1->cl_inout_list_depth;
		mhba->max_transfer_size =3D hs_page1->max_transfer_size;
    ...
}

[Severity: High]
Are other device inputs from the handshake page validated along with
frame_length?

Device inputs are used in bitwise shifts without validation in
mvumi_hs_process_page():

    ...
		mhba->ib_max_size_setting =3D hs_page1->cl_in_max_entry_size;
		mhba->ib_max_size =3D (1 << hs_page1->cl_in_max_entry_size) << 2;

		mhba->ob_max_size_setting =3D hs_page1->cl_out_max_entry_size;
		mhba->ob_max_size =3D (1 << hs_page1->cl_out_max_entry_size) << 2;
    ...

These unvalidated values are later multiplied and summed, which can overflow
the 32-bit tmp_size allocation parameter:

drivers/scsi/mvumi.c:mvumi_init_data() {
    ...
	tmp_size =3D mhba->ib_max_size * mhba->max_io;
	if (mhba->hba_capability & HS_CAPABILITY_SUPPORT_DYN_SRC)
		tmp_size +=3D sizeof(struct mvumi_dyn_list_entry) * mhba->max_io;

	tmp_size +=3D 128 + mhba->ob_max_size * mhba->max_io;
    ...
}

This can cause out-of-bounds pointer usage when memory pointers are advanced
far beyond the under-allocated tmp_size chunk:

drivers/scsi/mvumi.c:mvumi_init_data() {
    ...
	v +=3D mhba->ib_max_size * mhba->max_io;
	p +=3D mhba->ib_max_size * mhba->max_io;
    ...
}

Would this lead to a heap buffer overflow and out-of-bounds DMA access?

> =20
> -	page_checksum =3D mvumi_calculate_checksum(hs_header,
> -						hs_header->frame_length);
> +	if (frame_length > HSP_MAX_SIZE - sizeof(struct mvumi_hs_header)) {
> +		dev_err(&mhba->pdev->dev, "invalid handshake frame length %d\n",
> +			frame_length);
> +		return -1;

[Severity: Medium]
If we return -1 here upon detecting an invalid frame length, won't this
trigger the error-handling path in mvumi_handshake():

drivers/scsi/mvumi.c:mvumi_handshake() {
		if (hs_state =3D=3D HS_S_QUERY_PAGE) {
			if (mvumi_hs_process_page(mhba, hs_header)) {
				HS_SET_STATE(hs_fun, HS_S_ABORT);
				return -1;
			}
        ...
}

Does this modify the local state to signal an abort but return before
propagating this state to the hardware via iowrite32(), resulting in a
dead store?

Since the hardware is never notified of the abort, the driver spins for 30
seconds waiting for a handshake interrupt response that will never arrive.

> +	}
> +
> +	page_checksum =3D mvumi_calculate_checksum(hs_header, frame_length);
>  	if (page_checksum !=3D hs_header->checksum) {
>  		dev_err(&mhba->pdev->dev, "checksum error\n");
>  		return -1;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013173145.3412=
863-1-yhlee@isslab.korea.ac.kr?part=3D2
