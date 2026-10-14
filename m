Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BD13B6346
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 13:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986224; cv=none; b=GH+bAP6WBoW7jNvW9kP10HmHyVh3Sgc1EDPP25OBp1TvvVqzTKuAIPywT5vxYXpSp1hjmSA4VjcvAVqe4aptsAM4VeifldfOdvWYgsIgBE6ndvIbi6WxDR3Ap4eLXB7yZhSemqZZzV5uauzSseZL74VCpznFuLh7Fd21v/rtg6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986224; c=relaxed/simple;
	bh=vUY4CPouSwCswRPEYrthkj78G2vF8/sQ7y8+QghCQTQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KAu3L7TW93U4+ZKBGQmCI/Ti3qfRiR5bYM4Tl45Aj0mX0QH6c60wSSMpjJm5nlfdGLIhT3EQ63Nxfrjie3vUmliX2ORuoO80dc0mvBz+IYn8qUnmCv2P6eVg1WDhUTQS8q05k9Sl6y8XGjxCMV+8jytTdWH8VQsBMQcmSlsVNt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9wolWTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9wolWTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEDB1F00A2F;
	Wed, 14 Oct 2026 13:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791986219;
	bh=o6b1wYdzCKkPPu/bk1GlGoqCkuqDMwZiSqYJUHfiDjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d9wolWTj2L/BDSRe1ogePKHHpm5XCPLO6PRsc2UL01rhPIyagECEG/SxxAztfci00
	 wqtO1Uw858Z202tJ7AMHCW7lC7UYCZmV8MB6lOT1dK905MsC207ggV+fMmT8rxwrhK
	 iVoWsCoQQwi54eUImNTOgC6tUPYPMojpZz3hAUI11LfYEFBMTKHYbea7zWBZelY0dT
	 9pCb35ZTKaY9l+fKdTQRRLNTxUU592Yy5vpeZUG5xsWSHVoaZcZRwKXqOkpa74/KqR
	 2yJPCZSt8aLmCNOjHd4DQnXwithC20sbEacSfWtRYBwpmpJHMmbPcai9AW9AimWeQV
	 +2FOzJMlkILXg==
Message-ID: <sashiko-outbox-171387@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] scsi: mvumi: reject handshake sizes that overflow
 the list allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014134104.3528958-1-yhlee@isslab.korea.ac.kr>
References: <20261014134104.3528958-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 13:56:58 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: mvumi: infinite loop in mvumi_flush_cache()
- [High] scsi: mvumi: infinite loop and OOB read due to unvalidated frame_l=
ength
--

commit 612d25834778a07ff6eff54f39cff0cf95511595
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

    scsi: mvumi: reject handshake sizes that overflow the list allocations

This commit adds bounds checks for firmware-supplied parameters to prevent
overflows and out-of-bounds accesses. It rejects invalid sizes for the entry
size, list depth, and allocation size, and limits sizes across host resets.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index e70d336b4ab39..4fc0cf819c271 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
[ ... ]
> @@ -1048,30 +1061,80 @@ static int mvumi_hs_process_page(struct mvumi_hba=
 *mhba,
>  	}
> =20
>  	switch (hs_header->page_code) {

[Severity: High]
Does this code allow an infinite loop and out-of-bounds read if the firmware
provides a frame_length >=3D 256?

In mvumi_hs_process_page(), hs_header->frame_length is read directly from t=
he
firmware DMA buffer and passed to mvumi_calculate_checksum() without
validation:

mvumi_hs_process_page() {
        ...
        page_checksum =3D mvumi_calculate_checksum(hs_header,
                                                hs_header->frame_length);
        ...
}

Looking at mvumi_calculate_checksum(), the loop counter i is an 8-bit
unsigned char:

mvumi_calculate_checksum() {
        unsigned char i;
        ...
        for (i =3D 0; i < len; i++) {
                ret ^=3D *ptr;
                ptr++;
        }
}

If frame_length >=3D 256, the condition i < len will always evaluate to true
since i wraps around to 0, causing the kernel to hang and read out of
bounds until a page fault occurs.

> -	case HS_PAGE_FIRM_CAP:
> +	case HS_PAGE_FIRM_CAP: {
> +		unsigned int new_max_io, new_ib_max_size, new_ob_max_size;
> +		unsigned int new_list_num_io;
> +		unsigned short new_max_target_id, new_capability;
> =20
>  		hs_page1 =3D (struct mvumi_hs_page1 *) hs_header;
> =20
[ ... ]
> -		mhba->max_io =3D hs_page1->max_io_support;
> -		mhba->list_num_io =3D hs_page1->cl_inout_list_depth;
> -		mhba->max_transfer_size =3D hs_page1->max_transfer_size;
> -		mhba->max_target_id =3D hs_page1->max_devices_support;
> -		mhba->hba_capability =3D hs_page1->capability;
> -		mhba->ib_max_size_setting =3D hs_page1->cl_in_max_entry_size;
> -		mhba->ib_max_size =3D (1 << hs_page1->cl_in_max_entry_size) << 2;
> +		/* Firmware-supplied shift counts: (1U << n) << 2 must fit. */
> +		if (hs_page1->cl_in_max_entry_size > 29 ||
> +		    hs_page1->cl_out_max_entry_size > 29) {
> +			dev_err(&mhba->pdev->dev,
> +				"invalid handshake entry size\n");
> +			return -1;
> +		}
> =20
> -		mhba->ob_max_size_setting =3D hs_page1->cl_out_max_entry_size;
> -		mhba->ob_max_size =3D (1 << hs_page1->cl_out_max_entry_size) << 2;
> +		new_max_io =3D hs_page1->max_io_support;
> +		new_ib_max_size =3D (1U << hs_page1->cl_in_max_entry_size) << 2;
> +		new_ob_max_size =3D (1U << hs_page1->cl_out_max_entry_size) << 2;
> +		new_max_target_id =3D hs_page1->max_devices_support;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this assignment lead to an infinite loop in mvumi_flush_cache() if
max_devices_support is greater than 255?

The new_max_target_id is derived from max_devices_support (which can be up =
to
65535) and is later assigned to mhba->max_target_id.

However, in mvumi_flush_cache(), the loop counter device_id is declared
as an 8-bit unsigned char:

mvumi_flush_cache() {
        unsigned char device_id;
        ...
        for (device_id =3D 0; device_id < mhba->max_target_id; device_id++)=
 {
                if (!(mhba->target_map[device_id / bitcount] &
                                (1 << (device_id % bitcount))))
                        continue;
        ...
}

If max_devices_support is greater than 255, the condition
device_id < mhba->max_target_id will always be true, locking up the kernel
in an infinite loop.

> +		new_capability =3D hs_page1->capability;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014134104.3528=
958-1-yhlee@isslab.korea.ac.kr?part=3D1
