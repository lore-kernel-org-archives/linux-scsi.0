Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD9C49E5F4
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 07:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792049947; cv=none; b=KujMF+DGDZCEMoPVubhOJe1jYbBZ5xR6Zj9pApc3mdFWt54oX7TE2uyGCxMKuKoUPs4Fi5mR/yqg36KhxTdza/Fpe8x6soCOlRekH1o0EEJ2K6D1u9f6JIUqNddDMawInwM908tZ5hBUSDj0qI3wr2ZKkE7GYTWAXD4xnmPf7oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792049947; c=relaxed/simple;
	bh=FBVzdOuWZGjqgQxFt7ApB4Cnw6SiKgjs+4Uvfwx4eo8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jwLTy9/dssik5CaGCdkuQZTpSkSOjEluxPhVOXeezTa5IdpYemHX19BuijVbaTe7ypgHe29BEVcXmeRrQePP6va/+L8Z2kyMNqfTxsUkg3ytMImxPSw/TTgiMRY2DqitjhhPylink18qjF9f82wLow4rguq4m4FREz3v4giQm+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUppileI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUppileI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286261F000C7;
	Thu, 15 Oct 2026 07:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792049944;
	bh=wY3kBCHxIEV6cq+U0P4O1v++JstVQbzAu0pnnWyjx1s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HUppileIGoFqyU2DgOtD6lJV65kuzZy60e8GC6ZcAYODZuDlcwC2t5bzhLuxt4QbG
	 xNROI7bcHusnknccliB2oKb9oWUtqgHl/dzsY/wCZtcG6RpnvAmaiVOvpBiQh0vRZc
	 KaodNGY+BhR4rvIe2KKhSGuhwSnwmj+y6+FmhJT3Y2Iu75xKSxQcGjx0w1YQ4Fqeij
	 5WjkskRhgjwUxDjz9gOZbS8RBG5ZaBbpWSUF4M8Ykxksi3oJfmK0GOdISnsGoh5KyT
	 RikIbraPi78HaFXoK6ShhEAVpiQvWGnXPWrxyG5dGMekyBorGVz+vaWJsLP1jKFZCr
	 7KOoYIZ5iEoSQ==
Message-ID: <sashiko-outbox-172427@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] scsi: aic94xx: validate the EDB index in
 asd_get_response_tasklet()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015072612.4144043-3-yhlee@isslab.korea.ac.kr>
References: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
 <20261015072612.4144043-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 07:39:03 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: aic94xx: dropped task response leads to false-positive SUC=
CESS
--

commit 01f64db51b53d15913fd46e2c3fef1fd65e921d6
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: aic94xx: validate the EDB index in asd_get_response_tasklet()

This commit validates the empty data buffer index in
asd_get_response_tasklet() to prevent out-of-bounds array access. If the
sequencer returns an invalid edb_id, the driver now prints a debug message
and returns early.

> diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/a=
ic94xx_task.c
> index b26a468ddc981..35cf61f541d1b 100644
> --- a/drivers/scsi/aic94xx/aic94xx_task.c
> +++ b/drivers/scsi/aic94xx/aic94xx_task.c
> @@ -169,6 +169,12 @@ static void asd_get_response_tasklet(struct asd_ascb=
 *ascb,
>  		return;
>  	}
> =20
> +	if (edb_id < 0 || edb_id >=3D ASD_EDBS_PER_SCB) {
> +		ASD_DPRINTK("edb_id is %d! resp_sb->flags is 0x%x\n",
> +			    edb_id, resp_sb->flags);
> +		return;
> +	}
        ^^^^^^^

[Severity: Medium]
Does returning early here leave the task status as SAS_PROTO_RESPONSE?

If this return is taken, ts->stat is not updated to an error status. For SSP
tasks, sas_end_task() in libsas maps SAS_PROTO_RESPONSE to DID_OK and
SAS_SAM_STAT_GOOD. For ATA tasks, libsas parses the task's uninitialized
response buffer, resulting in no error mask.

Could this lead to a false-positive task success, masking hardware errors or
causing silent data corruption if data was not actually transferred?

> +
>  	ts->buf_valid_size =3D 0;
>  	edb =3D asd_ha->seq.edb_arr[edb_id + escb->edb_index];
>  	r =3D edb->vaddr;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015072612.4144=
043-1-yhlee@isslab.korea.ac.kr?part=3D2
