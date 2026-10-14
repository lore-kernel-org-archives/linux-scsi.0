Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDB555C1A2
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791992162; cv=none; b=shsLK3dByDSvIuSIUky5ANKywRB4v8Pr+fZRgwl6Kbq/a6ESc7c/x/9kr/lqu5PR8OB3iZvPuYKR9tMpr4i/O4F7hP421CgIDe/eLT8WdxKB/cZphHeantAzGU0fjbYPMaIW/OPKh8p0VUNybTOLzG4mZfWhaUAKHoUaM8pFhXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791992162; c=relaxed/simple;
	bh=/Jxu6daLHXZvNFZ/jjAtMsPpvWRyzqFt76N7a9s6bZU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=YyXWKxq8GyCXwPaADLYYSBG4QGuU7dljKkW4Z1jMfENAIeI7ppXOkQeD7v2bZoPDxbA/WNtVqhqwJNOEi/adl9Hu7M1VH2CYXcvZNhWIl0xWEOd54Eaxnn+NUft7pi6G3Gs56TCbZjVP94nmXWLJozOzrx8lyOoA7IS1U/BMlaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IGRNzKrx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IGRNzKrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B411F000C4;
	Wed, 14 Oct 2026 15:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992158;
	bh=wtd386+hjC2C1OA8NbTzUiA6PdZJ1w8OF7gYKFtEX6s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IGRNzKrxQbaBxvsSC3F9Nn/fUV13D7TMNbvodgorH3uwyW36a7BqVmx/uBj+oAAw8
	 U0uphSEtrElNu2+cCQWIjFPr8N70P9ixIhZ9NwpiraKKxYZ+vauCZf7XDQkK8ZXoFj
	 d38dfo86T6Am2A4lq8ybObEDenS02cmQ9yGXpsDgeXc3pafH9GLy4WwBmH9ujpIZLw
	 OPYIzBxgbbuSK5zjJ0SAfZf6eIYfS1DtUK7mXaBlUbuCZirEQw0Sm52cEPAi7HYlet
	 3NTPSWD3uMYybO8NgJh/e6FbWr5+UbvNKx0wSplLnnmbPPhW9fMvcdqoGmLurAgJpa
	 WqH1N/3caiTxA==
Message-ID: <sashiko-outbox-171478@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/6] scsi: mvumi: bound the hotplug event bitmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014151914.3632701-4-yhlee@isslab.korea.ac.kr>
References: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
 <20261014151914.3632701-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 15:35:57 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: mvumi: unaligned access, endianness, and truncation in bitma=
p scan
- [High] scsi: mvumi: DMA address truncation in mvumi_delete_internal_cmd
- [Medium] scsi: mvumi: incomplete bounds check causes phantom hotplug even=
ts
--

commit a0f2016a838932df1a44f506a29ddeb029ce97e6
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: bound the hotplug event bitmap

This commit introduces bounds checking for the hotplug event bitmap in
mvumi_proc_msg to prevent scans from exceeding the allocated buffer size.
It also adds a defined macro for the event buffer size to keep the
allocation and bounds check synchronized.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -1652,11 +1652,23 @@ static int mvumi_rescan_bus(void *data)
>  static void mvumi_proc_msg(struct mvumi_hba *mhba,
>  					struct mvumi_hotplug_event *param)
>  {
> -	u16 size =3D param->size;
> +	u16 size =3D READ_ONCE(param->size);

[Severity: High]
Since param->size is supplied by the firmware, does this need an endianness
conversion, such as le16_to_cpu(), to prevent incorrect size bounds on
big-endian systems?

>  	const unsigned long *ar_bitmap;
>  	const unsigned long *re_bitmap;
>  	int index;
> =20
> +	/*
> +	 * The second bitmap starts size bits into the event buffer and
> +	 * find_next_zero_bit() reads it a long at a time, so that is the
> +	 * furthest the two scans reach.
> +	 */
> +	if (sizeof(*param) + (size >> 3) + BITS_TO_LONGS(size) * sizeof(long) >
> +			MVUMI_EVENT_BUF_SIZE) {

[Severity: Medium]
The bounds check allows sizes up to MVUMI_EVENT_BUF_SIZE (512 bytes).
However, looking at the DMA transfer configuration in mvumi_get_event(),
the data_transfer_length is strictly limited to
sizeof(struct mvumi_event_req) which is 388 bytes.

Could this mismatch cause find_next_zero_bit() to scan unwritten,
zero-filled memory between 388 and 512 bytes, treating the zeroes as
device events and incorrectly triggering phantom SCSI hotplug additions?

> +		dev_err(&mhba->pdev->dev,
> +			"invalid hotplug event bitmap size %u\n", size);
> +		return;
> +	}
> +
>  	if (mhba->fw_flag & MVUMI_FW_ATTACH) {
>  		index =3D -1;
>  		ar_bitmap =3D (const unsigned long *) param->bitmap;
>  		re_bitmap =3D (const unsigned long *) &param->bitmap[size >> 3];

[Severity: High]
Does casting param->bitmap, which is at a 4-byte offset in the DMA buffer,
to an unsigned long pointer risk causing an alignment fault on 64-bit
architectures with strict alignment rules?

Additionally, if the firmware provides a size that is not a multiple of 8,
does the bitwise shift size >> 3 truncate the byte offset, causing the
re_bitmap offline scan to incorrectly overlap with the ar_bitmap online
scan?

[ ... ]

> @@ -1708,7 +1720,7 @@ static int mvumi_get_event(struct mvumi_hba *mhba, =
unsigned char msg)
>  	struct mvumi_cmd *cmd;
>  	struct mvumi_msg_frame *frame;
> =20
> -	cmd =3D mvumi_create_internal_cmd(mhba, 512);
> +	cmd =3D mvumi_create_internal_cmd(mhba, MVUMI_EVENT_BUF_SIZE);
>  	if (!cmd)
>  		return -1;

[ ... ]

>  	if (cmd->cmd_status !=3D SAM_STAT_GOOD)
>  		dev_err(&mhba->pdev->dev, "get event failed, status=3D0x%x.\n",
>  							cmd->cmd_status);
>  	else
>  		mvumi_notification(mhba, cmd->frame->cdb[1], cmd->data_buf);
> =20
>  	mvumi_delete_internal_cmd(mhba, cmd);

[Severity: High]
Looking at mvumi_delete_internal_cmd() called here during cleanup:

drivers/scsi/mvumi.c:mvumi_delete_internal_cmd() {
    ...
    phy_addr =3D (dma_addr_t) m_sg->baseaddr_l |
        (dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
    ...
}

Since baseaddr_h is a 32-bit u32, does this double shift evaluate in a
32-bit unsigned int context, causing the upper 32 bits to be zeroed on
64-bit systems before the cast to dma_addr_t?

Could this truncated physical address lead to a DMA unmap memory
corruption or resource leak when reconstructing the original address?

>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014151914.3632=
701-1-yhlee@isslab.korea.ac.kr?part=3D3
