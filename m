Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3299560ABE
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 16:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791996033; cv=none; b=ZgCiCvsFyZpL0Eb+JTKqj9jWgZYAxs3d8ojPyVqyVAyRTOxxF4PEsC8JceABiLz5UkpDy8lYdOXxQoRSq8ApOjWaFYQyYsiggeikwBokUu7t4ZJIy/sZSVpG0WkMVRi5NDKXLQ2ajS2tsTePTGv9rYAvupPftPcMm1bjXbh5ClY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791996033; c=relaxed/simple;
	bh=6fEI6S9/ENBS5WpG8MSRsK0vayV81F8uomfq54VUBII=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Fqt5UjBto2nvExdam9rVbbHsBrg1bUMvRy+MOYE7rua2OcuRdEgs/f3l2fsVhLcWIqcOJZE4di58V1o/PqmYXc5yX4GKVSTY1zd7DilGzB6YgoaCGYTHvzD8GjcD3fF8gZR3tgDiviTYw276nqMeRGi6m4+TGwX0xy+OzdxFk0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+lvnZEo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+lvnZEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D3A1F000C4;
	Wed, 14 Oct 2026 16:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791996032;
	bh=PfDYnA/sDE/AcOPm7Ni1vRnDpLbntZZY0TMtIA7oMXw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U+lvnZEoUUTLXN1LzBOgMkYRQtGmw4JMbxpdnou+9EjWJS5cPEMTKaj5d6Fa29nkL
	 kMqhjUZMTdPXz9YWvnNvOpbw8KTeFm7V2E/hOl7UmZFvYPkWoZk+G07iZJFjuuv5fo
	 0arxZLKZ2lc4xqurPC00jAFYMyBlVSpFqJKLsEMyR8ykL17jzfutSWZcmBvTNNpnC1
	 wTEzU/5MNWE/jPtpSrVWnY7K9fSiEUsu90rPeCdd0nrsUrGh44vFvEVKu+pIK+Y9Kq
	 QkQNHSAQQx5KS9HKrJveYKVKnkmjj4+ncXc10tjte3gJmTgcGzVFmU/XSz/uq57uVo
	 wXpO6puTkPnqA==
Message-ID: <sashiko-outbox-171548@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 4/5] scsi: mvumi: reject handshake sizes that
 overflow the list allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014162413.3649841-5-yhlee@isslab.korea.ac.kr>
References: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
 <20261014162413.3649841-5-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 16:40:31 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mvumi: missing READ_ONCE on DMA fields causes TOCTOU
--

commit 63940e006b3b39c47bbaae8a7b209645d7e0d499
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: reject handshake sizes that overflow the list allocations

mvumi_hs_process_page() takes max_io, the two command entry sizes and the
list depth from the firmware handshake page.  The entry sizes are u8 fields
used as shift counts, and 1 is an int, so a count of 29 or more makes the
<< 2 applied to the shift overflow an int; a count of 32 or more is
undefined outright.
[ ... ]

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 9a3dde53dea97..2871b4c96f1c8 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c

[ ... ]

> @@ -1054,30 +1067,108 @@ static int mvumi_hs_process_page(struct mvumi_hb=
a *mhba,
>  	}
> =20
>  	switch (hs_header->page_code) {
> -	case HS_PAGE_FIRM_CAP:
> +	case HS_PAGE_FIRM_CAP: {
> +		unsigned int new_max_io, new_ib_max_size, new_ob_max_size;
> +		unsigned int new_list_num_io;
> +		unsigned short new_max_target_id, new_capability;
> +		u8 in_sz, out_sz, list_depth;
> +
>  		hs_page1 =3D (struct mvumi_hs_page1 *) hs_header;
> =20
> -		mhba->max_io =3D hs_page1->max_io_support;
> -		mhba->list_num_io =3D hs_page1->cl_inout_list_depth;
> -		mhba->max_transfer_size =3D hs_page1->max_transfer_size;
> -		mhba->max_target_id =3D hs_page1->max_devices_support;
> -		mhba->hba_capability =3D hs_page1->capability;
> -		mhba->ib_max_size_setting =3D hs_page1->cl_in_max_entry_size;
> -		mhba->ib_max_size =3D (1 << hs_page1->cl_in_max_entry_size) << 2;
> +		in_sz =3D READ_ONCE(hs_page1->cl_in_max_entry_size);
> +		out_sz =3D READ_ONCE(hs_page1->cl_out_max_entry_size);
> +		list_depth =3D READ_ONCE(hs_page1->cl_inout_list_depth);
> +
> +		/* Firmware-supplied shift counts: (1U << n) << 2 must fit. */
> +		if (in_sz > 29 || out_sz > 29) {
> +			dev_err(&mhba->pdev->dev,
> +				"invalid handshake entry size\n");
> +			return -1;
> +		}
> +
> +		new_max_io =3D hs_page1->max_io_support;
> +		new_ib_max_size =3D (1U << in_sz) << 2;
> +		new_ob_max_size =3D (1U << out_sz) << 2;
> +		new_max_target_id =3D hs_page1->max_devices_support;
> +		new_capability =3D hs_page1->capability;

[Severity: High]
This patch correctly adds READ_ONCE() for the shift counts, but is it possi=
ble
the remaining DMA-mapped fields are vulnerable to a Time-Of-Check to
Time-Of-Use (TOCTOU) race?

Because `hs_page1` resides in coherent DMA memory, the hardware can modify =
it
concurrently. The compiler is permitted to optimize away local variables li=
ke
`new_max_target_id` and reload them directly from `hs_page1` later in the
function.

> +
> +		/*
> +		 * A target above MVUMI_MAX_TARGET_ID cannot be addressed: its
> +		 * id would land in the LUN byte of device_id and alias another
> +		 * device.  It is also what makes the loop counter in
> +		 * mvumi_flush_cache() wrap before it reaches the bound.
> +		 */
> +		if (new_max_target_id > MVUMI_MAX_TARGET_ID) {
> +			dev_err(&mhba->pdev->dev,
> +				"too many devices reported: %u\n",
> +				new_max_target_id);
> +			return -1;
> +		}
> +
> +		/* An entry has to hold the frame the driver puts in it. */

[ ... ]

> +		/* A host reset does not reallocate, so the sizes have to stay
> +		 * the ones the buffers were allocated with.  Only check that
> +		 * the firmware is not asking for more than they hold.
> +		 */
> +		if (mhba->fw_flag & MVUMI_FW_ALLOC) {
> +			if (new_max_io > mhba->max_io ||
> +			    new_ib_max_size > mhba->ib_max_size ||
> +			    new_ob_max_size > mhba->ob_max_size ||
> +			    new_list_num_io > mhba->list_num_io ||
> +			    new_max_target_id > mhba->max_target_id) {
> +				dev_err(&mhba->pdev->dev,
> +					"handshake sizes grew across reset\n");
> +				return -1;
> +			}
> +			break;
> +		}
> +
> +		mhba->max_io =3D new_max_io;
> +		mhba->list_num_io =3D new_list_num_io;
> +		mhba->max_transfer_size =3D hs_page1->max_transfer_size;
> +		mhba->max_target_id =3D new_max_target_id;
> +		mhba->hba_capability =3D new_capability;

If the compiler rematerializes `new_max_target_id` by doing a read from
`hs_page1->max_devices_support` here during the assignment, could a malicio=
us
or malfunctioning device have changed it after the bounds check?

This would cause `mhba->max_target_id` to exceed 255, leading to the target
aliasing and loop wrap-around vulnerabilities this patch intended to preven=
t in
mvumi_flush_cache().

Should READ_ONCE() also be used when reading `max_io_support`,
`max_devices_support`, and `capability` from `hs_page1`?

> +		mhba->ib_max_size_setting =3D in_sz;
> +		mhba->ib_max_size =3D new_ib_max_size;
> +		mhba->ob_max_size_setting =3D out_sz;
> +		mhba->ob_max_size =3D new_ob_max_size;
> =20
>  		if (mhba->hba_capability & HS_CAPABILITY_SUPPORT_COMPACT_SG)
>  			mhba->eot_flag =3D 22;
>  		else
>  			mhba->eot_flag =3D 27;
> -		if (mhba->hba_capability & HS_CAPABILITY_NEW_PAGE_IO_DEPTH_DEF)
> -			mhba->list_num_io =3D 1 << hs_page1->cl_inout_list_depth;
>  		break;
> +	}
>  	default:
>  		dev_err(&mhba->pdev->dev, "handshake: page code error\n");
>  		return -1;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014162413.3649=
841-1-yhlee@isslab.korea.ac.kr?part=3D4
