Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC68F54EEAE
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991907; cv=none; b=oTb8LsmZLO9H2b9imVJrxOtNRT+05Km4yyTaPjpl1I6WNi8Kt8mGYgkXVXapdqpHsk4qyVGQKr7cyWwuP3tQOY+Y0VFgf6RX5CMs0uNsw8FJTFmVh8VYAnQw6HwiVrynFo89KsidZKSu/KI+QVP9yIEXIA77iP1VIMohhKgbax4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991907; c=relaxed/simple;
	bh=eVZfDdz+PxbaYJQQcTAWuy9CWwbkIXm1f3s4n33GK7E=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QldBMPA82jnG+i5795//5M8vmlODPvxsi4O0PVnhqvT37YvM5ubxgN1om2Y455h6NbC/1i6dV6yekf/EhpaxYe5gBFJV9iwNxm2sxujwFOoNjCal47RTGs/FMBrk7NoZie8UZ/rn16XnXt3yx3Ti+CrAqCI3WNkJD6HQJLyiex0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pdr3ihh5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pdr3ihh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487621F000C4;
	Wed, 14 Oct 2026 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791991906;
	bh=ezDL9RBCWMmBvMAoKGogHVn3zofXTdUvtmdbuEpY0L0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pdr3ihh5XF4qfHSS+MP8J8uun1DERzfRZ0IsOAmbWYneuuiYk5AGq0EYXD5nZD805
	 zlCiCJotASAnngjmHed20MBr+zFHfj+77HjQ6qUz2XEnsMAnwg59SAKCNnhHQ4zSA2
	 wfijA8/fDHm/206amkDujxJjyQWKA//tgU9FRG4gKHB4t5H7jfRM7b/u5eojwrisNO
	 12kNIh9+dunJDSU3T1HE0R6owr+6rAlT7VXqmA2pnFuvQu4UM1W0jZYbd3tz+q9uF0
	 abCGTjy/a6VGj8dR/Oa9Vn/e/HLAC+TxAsJ24xF6dx5eQLbbOW6LLknFcx5N24dKjl
	 m1gtzbVCgXsUg==
Message-ID: <sashiko-outbox-171470@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/6] scsi: mvumi: reject handshake sizes that
 overflow the list allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014151914.3632701-5-yhlee@isslab.korea.ac.kr>
References: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
 <20261014151914.3632701-5-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 15:31:45 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mvumi: ring queue desync when firmware limits shrink across =
reset
--

commit af2767dc7ac6cb07639493635b81a3c6bd8a53fb
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: reject handshake sizes that overflow the list allocations

This commit adds bounds checking for handshake page sizes to prevent
integer overflows and out-of-bounds writes during allocations. It also
validates that firmware limits do not grow across a host reset.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 9e342db4b8383..e63b3ba7eaabd 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
[ ... ]
> @@ -1054,30 +1067,80 @@ static int mvumi_hs_process_page(struct mvumi_hba=
 *mhba,
>  	}
> =20
>  	switch (hs_header->page_code) {
> -	case HS_PAGE_FIRM_CAP:
> +	case HS_PAGE_FIRM_CAP: {
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

[Severity: High]
Does this break statement skip updating the driver's internal limits when t=
he
firmware capacities shrink across a reset?

If a soft reset occurs and the firmware reports smaller capabilities for
list_num_io or max_io, this path is taken because the new values are not
larger than the old ones. However, by breaking out early, the driver misses
updating its internal state to match the smaller firmware limits.

Can this lead to desynchronization of the driver-firmware circular command
rings and overflow of firmware queues?

> +		}
> +
> +		mhba->max_io =3D new_max_io;
> +		mhba->list_num_io =3D new_list_num_io;
> +		mhba->max_transfer_size =3D hs_page1->max_transfer_size;
> +		mhba->max_target_id =3D new_max_target_id;
> +		mhba->hba_capability =3D new_capability;
> +		mhba->ib_max_size_setting =3D hs_page1->cl_in_max_entry_size;
> +		mhba->ib_max_size =3D new_ib_max_size;
> +		mhba->ob_max_size_setting =3D hs_page1->cl_out_max_entry_size;
> +		mhba->ob_max_size =3D new_ob_max_size;
> +
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014151914.3632=
701-1-yhlee@isslab.korea.ac.kr?part=3D4
