Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A323932EE
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 18:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790447361; cv=none; b=Gd7YXh2mMGf1Dmi68qhOfGjJu3C7Y/JHPPgt2l8BKJfyTWpnG8nazW4VYqovsVeungdSn92Ub6gA7+AFUPxDgsJHwWQFLc0EXlCR5oZZmwMTedzCv33ye1H8EuIQf1126kmM1RsOnTGQDmDErgMTPcSmNNfa67/p+vWaRvYNAYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790447361; c=relaxed/simple;
	bh=1cUdgyY27Sf98/poy2Bmd1O4IqlJXjmMzbUg/Uq82/E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xc7pLpR0f9lLW8b3NhRNB8Sb1VuuA39gvh/nw1buoDsTIJ2II1KEIsH1o0J2ruox1LSXP7TrudzXWCMpS9wWGqXzMNEK4gF/XdwapBFs8pPPB0GwE9dMJT+KDT5a3bzhyOwt00MVVeE/3JAoVje0Q6isVDXZ4PIIaiXJeJmXmdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3aPAR50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3aPAR50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FDF1F000FF;
	Sat, 26 Sep 2026 18:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790447360;
	bh=CpMpdiFULrkLNzn/dXL4hrjFYHrcfVX+Zb23Ol0NrOM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C3aPAR50yY+ZU98pir/uOrIj+MeqTZFTY21E2NmoH0ej73J7POYPm4EpiYzw7pXLq
	 H2aGHGPj5LZDeaGdx7+bHJG1yM7i+9wGstyW+8Y3z2KzRQx61q7wo5tqj1smQCUy3+
	 1UocSx3a4+neoO2N2ffBiQQzIFpFTcc9QV4/5C7rKZN1QvMiogOskoP/9Uu5f+HlNj
	 1uTe55XNqN7mqk15f8LHNfU6924+x2Oci0HXOzto6J+NQ3hljPcPVXyXw4yVvynPGf
	 MYx3NEOT7+XhxhOOudOhcTSRcxg4od7rHmy1fzWXWE7SiLTvPorHWRdSkcshagsk/i
	 AB+3CnfQw4oSA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 05/11] scsi: scsi_debug: Report the residual of a
 write
Reply-To: sashiko-reviews@lists.linux.dev
To: "Niklas Cassel" <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260926181702.508975-18-cassel@kernel.org>
References: <20260926181702.508975-13-cassel@kernel.org>
 <20260926181702.508975-18-cassel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 18:29:19 +0000
Message-Id: <20260926182920.46FDF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: scsi_debug: residual reporting bypassed on error paths in =
resp_write_scat
--

commit 3c508959885d7806b55921f3734fa6ad6ca1e100
Author: Niklas Cassel <cassel@kernel.org>

scsi: scsi_debug: Report the residual of a write

This commit adds residual reporting for writes in the scsi_debug driver. It
ensures that commands whose data buffer is larger than their transfer length
report the unconsumed portion as a residual, making writes behave consisten=
tly
with reads.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b64ae3ad300d8..9220758bb8017 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c

[ ... ]

> @@ -5350,6 +5357,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>  		sg_off +=3D num_by;
>  		cum_lb +=3D num;
>  	}
> +	/*
> +	 * sg_off counts what the command asked for, which can exceed the
> +	 * buffer: lbdof is not validated against it, and a range is counted
> +	 * in full even if do_device_access() copied less.
> +	 */
> +	if (scsi_bufflen(scp) > sg_off)
> +		scsi_set_resid(scp, scsi_bufflen(scp) - sg_off);
>  	ret =3D 0;
>  err_out_unlock:
>  	sdeb_meta_write_unlock(sip);

[Severity: Medium]
Does placing the err_out_unlock label after the residual reporting logic
cause error exits to bypass it?

If a write scattered command processes the first LBA range successfully but
fails on a subsequent range (for example, if the second range exceeds
device capacity and check_device_access_params() fails), the code in
resp_write_scat() jumps directly to err_out_unlock:

		ret =3D check_device_access_params(scp, lba, num, true);
		if (ret)
			goto err_out_unlock;

This bypasses the new residual reporting logic at the end of the function,
leaving the residual incorrectly at 0 instead of reflecting the unwritten
data. Should the residual also be updated before returning from these error
paths?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926181702.5089=
75-13-cassel@kernel.org?part=3D5
