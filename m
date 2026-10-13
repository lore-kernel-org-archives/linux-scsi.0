Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B2D3BCD3A
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900927; cv=none; b=tgtLivWPMPQZMIpOa6tHb1eZiY1QCI202ApuTBze1jJXZnal1i2Bs81l9+e5HCPYgLfRH6YIIwWvQkqxMKovx41JMo1jaEKiTcJFuUmxRNtn69vTeUkjYzIQMj9S1EfCawvMadUrLbvqf9KXVbKgE2Un6Wr1tmYatXFfJ3NhDSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900927; c=relaxed/simple;
	bh=rhJ2eWJfkNft9Q5ewOU8pcChn7BAWDkxZkIMkIat22w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IAxWIpdaiUqritm2injOKwiu4iu8nUqPHOAsJD3gqcjd1YAcRbJyODZisFhfCTs9RygdKmh+7Bq95O+oKLJ7g82eDE/qfjC75brmF33Z6cEeioaaYh0cZVfCTmCTTdD0PXGvjmDobI+1wMnXh6rbqNebi8wbg7VcONN+1/avy48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2TglMas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2TglMas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3731F000FF;
	Tue, 13 Oct 2026 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791900925;
	bh=RS17I1ExV+O0ha3FpV+6yfLx5eA4DYtj9BDHCWDo3DA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U2TglMasRVpdEB9FKBuLqGfgjI6UpfccZNa5W4wZ9Kd4WqOQfAVfg6g3S01G3mVbg
	 +zRclSZFWIWU9bxh4Q0hu0fkgjnZinFhTJzgbGFVEdUtePlCXZSfqtuvhLOnVLj0z6
	 wYmpbuTR41D8C5zYMrid3Z0ItoQBc3CZtl/CSU1+/EVSh3EdTCwmKe3PYltqBZRhfe
	 xCCh3hZPBLzuFUZj/XLti0aTv7e0180JHPeHljHXLnKcUxlJpHiOOvUuzPythMVNny
	 5hLkQs2WfRRo3XBJRvcWbOUhsQOfREge4v3yvZapHGAx3/2hK52zitw8Iiash1JxlP
	 uOcKCq9InJN7Q==
Message-ID: <sashiko-outbox-169890@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: aacraid: bound the SRB sense data copy to the
 source buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013140214.3156938-2-yhlee@isslab.korea.ac.kr>
References: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr>
 <20261013140214.3156938-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:15:24 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] scsi: aacraid: silent data corruption due to clobbered scsicmd=
->result
--

commit 41e55cd2865c820cb5e9b169fa01f61a9291992f
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: aacraid: bound the SRB sense data copy to the source buffer

aac_srb_callback() copies the sense data from an adapter SRB reply into
the command's sense buffer, using a length that is only capped at
SCSI_SENSE_BUFFERSIZE (96 bytes). The source, srbreply->sense_data, is
AAC_SENSE_BUFFERSIZE (30 bytes), so an adapter that reports a larger
sense_data_size makes the copy read up to 66 bytes past the sense array.
Cap the copy at the size of the source array, matching the container
sense paths in this driver.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -3418,7 +3418,7 @@ static void aac_srb_callback(void *context, struct =
fib * fibptr)
>  		pr_warn("aac_srb_callback: srb failed, status =3D %d\n",
>  				le32_to_cpu(srbreply->status));
>  		len =3D min_t(u32, le32_to_cpu(srbreply->sense_data_size),
> -			    SCSI_SENSE_BUFFERSIZE);
> +			    sizeof(srbreply->sense_data));
>  		scsicmd->result =3D DID_ERROR << 16 | SAM_STAT_CHECK_CONDITION;
>  		memcpy(scsicmd->sense_buffer,
>  				srbreply->sense_data, len);
>  	}
> =20
>  	/*
>  	 * Next check the srb status
>  	 */
>  	switch ((le32_to_cpu(srbreply->srb_status))&0x3f) {
>  	case SRB_STATUS_ERROR_RECOVERY:
>  	case SRB_STATUS_PENDING:
>  	case SRB_STATUS_SUCCESS:
>  		scsicmd->result =3D DID_OK << 16;

[Severity: Critical]
Does this code unconditionally overwrite the error status set during a FIB
failure?

If the adapter returns a FIB failure (srbreply->status !=3D ST_OK), the blo=
ck
above sets scsicmd->result to DID_ERROR << 16 | SAM_STAT_CHECK_CONDITION.

It then immediately falls through to the switch on srb_status. For values
like SRB_STATUS_PENDING or SRB_STATUS_SUCCESS, the switch assigns
scsicmd->result =3D DID_OK << 16.

Could this clobber the error status and discard the SAM_STAT_CHECK_CONDITION
bit? If srbreply->scsi_status happens to be 0, the command would complete as
DID_OK despite the earlier error.

Can this lead to silent data corruption by causing the OS to ignore the
copied sense buffer and incorrectly assume data was safely written?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013140214.3156=
938-1-yhlee@isslab.korea.ac.kr?part=3D1
