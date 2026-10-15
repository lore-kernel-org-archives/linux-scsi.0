Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FF72571B8
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792032100; cv=none; b=ioLdIqVAxLg7Xm7LSbuwh7RnUsjqoJ9OFElTnZU8vGs/Jipj3rDg8qZNToAi+BjjVYaCIkdKDxl6qtovM7LiwPAWepspnzxsiGJSNSQf155hjfplGdEUeK+ibA2v/a77yZ1yqZng6XRxakFkPkBluP+Qf2j2IVmui6XavtkdBOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792032100; c=relaxed/simple;
	bh=U/NMqm8skQ29+UQW8oJSpbCJEAMeendWncHSK9zbuNA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=guep3vYeqaRFraGGy3o6XfZLezWTlQRX2y/80CQPLcz1BCLRps+H3ljXCa+45ZG8NrSj1ToR8PVxAMdcOn96Iu9BE9OaZ3Reud7Yp3jomjZG5LhROy859B59JmfusULiPIjmNMcdSaUwn8psJ8uvHqqszuqxRS5FxC4A3szn+lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2GCk7mj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2GCk7mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F0A1F000C4;
	Thu, 15 Oct 2026 02:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792032098;
	bh=Llf4pfkF0Be3ru4uEUz/KCAQG95Rpsmv0P4sd2H80d0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E2GCk7mj4VQBOnI3Qjtrt8yJLJoUkljV0THtQsR3I/EGZOIeNbtjG8XEVtG3OlDJG
	 YmPmztl8vuGvvVFgRkx3pcB+rJTmos1klAuM0zf/W4WfCvkDfra6R5EXvyagiZzjGU
	 zY23SbbQ7Q+49jxxXr6Hvw6VPMjf14AWGrOgR35/nyRBnSyVj6BmK+UMUb5t5A8klH
	 b6VMzGBGTcC2L4sLbkub4ehJyvZ10BeCRICbjzbrgvNOl0AW9DTBaeKwKfZ3vKSY5P
	 XDl1Xz9/LR8SFH+dOmQy+b4vAZvuSVkJ329+D+teHOTx6ZJc5ZtmuYCrl+SpfLuVa2
	 oZ7tYSFFhgh2w==
Message-ID: <sashiko-outbox-172169@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/8] scsi: mvumi: reject an out-of-range handshake
 frame length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015022728.3936714-3-yhlee@isslab.korea.ac.kr>
References: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
 <20261015022728.3936714-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 02:41:38 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: mvumi: missing endianness conversion for frame_length
--

commit 86284f2a4fc8c1a95cd41e7f1687f3c482b376ac
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: reject an out-of-range handshake frame length

This patch adds bounds checking to the frame_length obtained from the firmw=
are
handshake page to prevent out-of-bounds reads and hangs during checksum
calculations. It also uses READ_ONCE() to ensure the DMA value is fetched o=
nly
once.

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
> =20
> -	page_checksum =3D mvumi_calculate_checksum(hs_header,
> -						hs_header->frame_length);
> +	if (frame_length > HSP_MAX_SIZE - sizeof(struct mvumi_hs_header)) {

[Severity: Medium]
Is an endianness conversion required here before the bounds check?

hs_header->frame_length is populated by the PCI device, which typically uses
little-endian byte order. On big-endian architectures, reading it directly =
into
a u16 without le16_to_cpu() results in a byte-swapped value.

This swapped value will cause the bounds check against HSP_MAX_SIZE to
spuriously fail the handshake and abort the device probe. While the driver =
may
lack complete endian conversions overall, does this new check introduce an
immediate probe failure on big-endian platforms?

> +		dev_err(&mhba->pdev->dev, "invalid handshake frame length %d\n",
> +			frame_length);
> +		return -1;
> +	}
> +
> +	page_checksum =3D mvumi_calculate_checksum(hs_header, frame_length);
>  	if (page_checksum !=3D hs_header->checksum) {
>  		dev_err(&mhba->pdev->dev, "checksum error\n");
>  		return -1;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015022728.3936=
714-1-yhlee@isslab.korea.ac.kr?part=3D2
