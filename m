Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EF94BD373
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791992011; cv=none; b=B/JJotuqswQEJHZtbOPqFCR8A/+XDnTvTozA3PbP9OOWsQ7vK9lcXq7htX2YbFc68iZLMMpUTHKHOYBKgwsCai8YryaELtDzxndMQlZeJ4ateYxMcNuJMrsf/wLj46SlAri/TGU43QVAYEUDDe7bVP/PKphPsxyAB+9cAUPAnBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791992011; c=relaxed/simple;
	bh=Y0lBOJsuRS5y42TfyYuQQek7IRfgYE4n/AYo/jFFe5M=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XQAbKaJhcs63LOYD7W5XrIiT282fJg0Mj0QheD56xcsIllumYzdCSwDuosCSdWpS4A2eq6xyEHAe2Po/ErtQ9iyXK3aYCWPh/3N1/xqTL5xuQ7BIKzJtyOFXF12SwhzEOApeorCpZEJsYOpEaP8/EINisCY9w4S3T6RkwgwSMV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWPpQdxL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWPpQdxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0871F000C4;
	Wed, 14 Oct 2026 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992009;
	bh=jRCP1kcOlf3bK+QPTpzcXhKU3sAgJDUKljQ0ACaK2Ds=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fWPpQdxLYY0Im0JmF+A8DPT2T6KfQsxy10F7mE7Yr4v+y6JqvIlClkITfpeOyPaSG
	 fGuDCuwlBDrmK3Fdp7fSjXOPdv44cUrBZmPOaUkCZ128YLOGel9oICvXWzuWvf4v0y
	 JKsS5BhSfYHL5NUGnd1chF56rsAtFgEkfGEDEEHqGRBGsnFUT8aw46jGwBpjSOs1By
	 WcN+ZVAadke29D6WRPrYZhYAOoIWIR7ShzE34ARbVQBrnBW6BEyw/8/J0WbfsVmgcY
	 sRowi1/XjX2uU6cDE4mKD6uxuz2y6uD+5O+LCAySd3OnvOsqRF6DNh42jH3Xrv/6Dl
	 QFr2i4iHy0D4Q==
Message-ID: <sashiko-outbox-171473@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/6] scsi: mvumi: reject an out-of-range handshake
 frame length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014151914.3632701-3-yhlee@isslab.korea.ac.kr>
References: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
 <20261014151914.3632701-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 15:33:29 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: mvumi: TOCTOU on DMA payload bypasses checksum and bounds
- [Medium] scsi: mvumi: missing endianness conversion for frame_length
--

commit 31d1a951cd494fae608e39897206b687a75bc558
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: reject an out-of-range handshake frame length

This patch fixes an out-of-bounds read and potential hang in the mvumi
driver by validating the frame_length from the handshake page header. It
ensures the length fits within the handshake buffer before calculating the
checksum, and uses READ_ONCE() to prevent the device from changing the
value mid-validation.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 38a92f8c25f5b..2378b676a7a78 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -1039,9 +1039,15 @@ static int mvumi_hs_process_page(struct mvumi_hba =
*mhba,
>  {
>  	struct mvumi_hs_page1 *hs_page1;
>  	unsigned char page_checksum;
> +	u16 frame_length =3D READ_ONCE(hs_header->frame_length);

[Severity: Medium]
Is an endianness conversion needed here? Hardware devices typically provide
data in little-endian format.

If run on a big-endian architecture, a valid small little-endian length
might be interpreted as a heavily byte-swapped value. This could inevitably
fail the newly added bounds check, preventing driver initialization entirely
on big-endian hosts.

> -	page_checksum =3D mvumi_calculate_checksum(hs_header,
> -						hs_header->frame_length);
> +	if (frame_length > HSP_MAX_SIZE - sizeof(struct mvumi_hs_header)) {
> +		dev_err(&mhba->pdev->dev, "invalid handshake frame length %d\n",
> +			frame_length);
> +		return -1;
> +	}
> +
> +	page_checksum =3D mvumi_calculate_checksum(hs_header, frame_length);
>  	if (page_checksum !=3D hs_header->checksum) {
>  		dev_err(&mhba->pdev->dev, "checksum error\n");
>  		return -1;
>  	}

[Severity: High]
Does validating the checksum over the shared DMA buffer guarantee the
payload's integrity when it is read later?

After validation, mvumi_hs_process_page() and mvumi_handshake() read fields
directly from the shared DMA buffer without using READ_ONCE() or making a
local copy:

mvumi_hs_process_page() {
    ...
    switch (hs_header->page_code) {
    case HS_PAGE_FIRM_CAP:
        hs_page1 =3D (struct mvumi_hs_page1 *) hs_header;
        mhba->max_io =3D hs_page1->max_io_support;
        ...
        mhba->ib_max_size_setting =3D hs_page1->cl_in_max_entry_size;
    ...
}

Could a malicious device concurrently modify these fields immediately after
the checksum is verified, bypassing the integrity check entirely?

This might allow the device to inject values that lead to undefined behavior
or severely corrupt the driver state machine.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014151914.3632=
701-1-yhlee@isslab.korea.ac.kr?part=3D2
