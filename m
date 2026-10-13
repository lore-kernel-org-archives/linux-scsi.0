Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BE251D52D
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908919; cv=none; b=PMkAB3TzerpdWI+Q9kHTEwEf2bJzJmSZd/W1H0KYwTzel6hsrfbXwWRUYeYFk/6tmHIZtNP4T0asZTULaZbGdema9UDyhC7+N07BirM+xqAQdIjjGgfJO6wmrHP5FCqWAwPTTnA4Xc+uHnMTzL2G4TBmzlvIOv5alT9u9fsmK1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908919; c=relaxed/simple;
	bh=jnqOyDoXFdtnuADsTcJ5muEr2wVw63X4TLG3mtGhHyg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QhMs7BDJyKOPU2S8R9CuSWoKZmr0u0aTGzIyqx0CY33d/MnKqF9tDPf8EDdg8BYZI6uLvVe0/XK5q7/KA08+uktrs+Mjd/7MKaSsiQrjbHTyJs2u0aihkaz4Ga0nbzzBoNUJ5XpQG/FQBR7aNFB3rJolsOj27yMZQOhyubYtdDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b26OMEgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b26OMEgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAD11F000FF;
	Tue, 13 Oct 2026 16:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791908918;
	bh=h7Fopv9JBZwIuRkBip4t1+yFP9WqVTDX8QKgYHT0VF0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b26OMEgdTTp+jhKyNUa4ALePesCX3d+BGD+tUS6kW3Vdn4L2IH2x4q7scnNlWsY7O
	 jLZw/rGw8eeOU84OhoWYds2fID8KNP1rzKyJpQMNKIfqPyW3brtGhGBFgEsquBL8ov
	 S/MfnzII0uNmYMOLpkvx7whw6/zxxq1pcG3pGknuguQIA7jA00A7nxHqvWTRgfdJJm
	 TOr4ytA9WbAF8q3ZjStf/TwcN4/xdtfHR2u9b3UX200DsZhCJ8kgTLUNihSycrykik
	 NcHoRd4qnhOLyEnY4fGJ5gdA+SCpf0C3OOMnW5K5XHw9onOFclZxm2X37v71xfauLo
	 /oXya7qmijSew==
Message-ID: <sashiko-outbox-170111@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: mvumi: reject an out-of-range handshake frame
 length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013161620.3210533-3-yhlee@isslab.korea.ac.kr>
References: <20261013161620.3210533-1-yhlee@isslab.korea.ac.kr>
 <20261013161620.3210533-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 16:28:37 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: mvumi: double fetch of frame_length from DMA memory bypasses=
 check
- [Medium] scsi: mvumi: handshake abort fails to notify hardware, causing 3=
0s hang
- [Medium] scsi: mvumi: missing endianness conversion for frame_length
--

commit dafccf0ec918c5690e69772bbc05185a6c69bf98
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: reject an out-of-range handshake frame length

This patch adds a bounds check to mvumi_hs_process_page() to reject an
out-of-range handshake frame_length. This prevents an infinite loop and out=
 of
bounds read that occurs if the firmware fills in a value of 256 or more.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 38a92f8c25f5b..e85400291a141 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -1040,6 +1040,13 @@ static int mvumi_hs_process_page(struct mvumi_hba =
*mhba,
>  	struct mvumi_hs_page1 *hs_page1;
>  	unsigned char page_checksum;
> =20
> +	if (hs_header->frame_length >
> +	    HSP_MAX_SIZE - sizeof(struct mvumi_hs_header)) {

[Severity: Medium]
Does hs_header->frame_length need an endianness conversion here?

If the device writes this data into DMA memory as little-endian, reading it=
 as
a plain u16 without le16_to_cpu() could cause a valid small length to be
interpreted as a massive value on big-endian architectures.

Could this cause the initialization probe to fail on big-endian systems?

> +		dev_err(&mhba->pdev->dev, "invalid handshake frame length %d\n",
> +			hs_header->frame_length);
> +		return -1;

[Severity: Medium]
Does returning an error here cause the driver to hang?

When mvumi_hs_process_page() returns an error, the caller mvumi_handshake()
sets its state to HS_S_ABORT and returns -1 immediately:

drivers/scsi/mvumi.c:mvumi_handshake() {
    ...
    if (mvumi_hs_process_page(mhba, hs_header)) {
        HS_SET_STATE(hs_fun, HS_S_ABORT);
        return -1;
    }
    ...
}

By returning immediately, it skips the iowrite32 calls at the end of the bl=
ock
that notify the hardware of the state change.

Furthermore, its caller mvumi_handshake_event() completely ignores the -1
return value:

drivers/scsi/mvumi.c:mvumi_handshake_event() {
    ...
    mvumi_handshake(mhba);
    do {
        isr_status =3D mhba->instancet->read_fw_status_reg(mhba);
    ...
}

Will this cause the driver to fall through into the 30-second polling loop
waiting for an interrupt that will never arrive?

> +	}
> +
>  	page_checksum =3D mvumi_calculate_checksum(hs_header,
>  						hs_header->frame_length);

[Severity: High]
Does this introduce a double fetch regression?

The bounds check above evaluates hs_header->frame_length, but then the leng=
th
is read a second time from shared DMA memory to pass into
mvumi_calculate_checksum().

If the device firmware is untrusted, could it race the CPU and modify
frame_length in memory to a value larger than 255 after the bounds check
passes but before this second fetch?

This would pass an out-of-bounds length into the checksum loop, causing the
unsigned char loop counter to wrap around infinitely and re-triggering the
exact hang this patch intended to fix.

>  	if (page_checksum !=3D hs_header->checksum) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013161620.3210=
533-1-yhlee@isslab.korea.ac.kr?part=3D2
