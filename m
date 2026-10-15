Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624F63D75C4
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030954; cv=none; b=QIsAgOj9lXc+gpV5l4dvzDLH466/DJdNeznae58tIXlnShWJPnXhdZtAfWGPDnChxTyeF9D3RVZYVei+KR51tACX3v+ykbLGMcJlafV9/BBB3jWvv0ktr6+HTu1Ni3ai54EIAA1JZ3aVsx6/BuJTsE1eT4XcxBCotNY+Yw0xvv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030954; c=relaxed/simple;
	bh=i1PR1h7AkYWS+PUpAynitq1FLb6KlHzUPMNmPlcrAbE=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=FeC1TQndPLpdbXgBB1GV8Tu7SD78nCOKUZQmQdvZnlu+OlrqCe+aHZR84/Ctxci426Nis5SquYav7NtI2B+EHdtZTq/4HseUMt3dz74jmTK551Lzl/Wo0xOQhjPxwc/GYq/tfDkQWJ/ZjyScDjn5DV2+mlmnxD9r3ll1gwvsubE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMIurUxe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMIurUxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AB21F000C4;
	Thu, 15 Oct 2026 02:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792030952;
	bh=L5mzNQaZHMlwci5YbvmO/ngi/jRypPlIc8iBkcx15XI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=LMIurUxez8a46B/a5eLQK8i6FfMZ07bUtqXiocjUEzYFvmsg1wrnY6oE0/PNvy8F+
	 RI6pHkWAS76JF+Ome4oOzmG81647qeZYAnEdh4yBOEXds45jKbuaxN5/cpusLORloG
	 GTzeZodYX5f6KVaDV09vuJxieptAI53ckRaxXpdrjI7Un0Yi8pCeCiGrx/PxgRlYq2
	 xAJPK74h1kg/6gBSd62W831lfrcbqz0r2gkeMECiH7KA9CvmB8lxRHHvIBWzWOTA65
	 BluIeMVFNJystMjrTPrd3Nkpe2iXEibDt9HCj4zdkX4DeGTAvjMPD7fCxg34HMszba
	 FU74isDz4bv6A==
Message-ID: <sashiko-outbox-172142@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: validate data_out size before SMP
 link-reset check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Weibin Liu" <liuwb@xiaopeng.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261015-mpt3sas-dataout-sz-v1-1-0781d24bb7ad@xiaopeng.com>
References: <20261015-mpt3sas-dataout-sz-v1-1-0781d24bb7ad@xiaopeng.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 02:22:32 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mpt3sas: UAPI regression breaking short SMP requests
--

commit c6e5c105f2c358ce97748e66aceca72796ee77b8
Author: Weibin Liu <liuwb@xiaopeng.com>

scsi: mpt3sas: validate data_out size before SMP link-reset check

This commit prevents an out-of-bounds read in _ctl_do_mpt_command() by
validating the size of the data_out buffer before checking for SMP link
reset requests on non-IMMEDIATE SMP PASSTHROUGH commands.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
> index 8bb947004885b..ae9b2be51ce0f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -968,7 +968,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, stru=
ct mpt3_ioctl_command karg,
>  		    MPI2_SMP_PT_REQ_PT_FLAGS_IMMEDIATE)
>  			data =3D (u8 *)&smp_request->SGL;
>  		else {
> -			if (unlikely(data_out =3D=3D NULL)) {
> +			if (unlikely(!data_out || data_out_sz < 11)) {

[Severity: High]
Does this cause a regression for valid short SMP requests?

By enforcing data_out_sz >=3D 11 and returning -EINVAL on shorter payloads,
this change appears to prevent user-space applications (such as smp_utils
or lsiutil) from sending standard short SMP commands (like
SMP_REPORT_GENERAL, which has an 8-byte payload) via the MPT3COMMAND ioctl
using a non-immediate payload buffer.

Before this patch, short commands were successfully sent to the hardware,
even though the driver incorrectly read data[10] out of bounds.

Could this be resolved by instead checking the payload size only when
evaluating the link reset detection logic later in the function?

For example:
	if (data_out_sz >=3D 11 && data[1] =3D=3D 0x91 && (data[10] =3D=3D 1 || ..=
.))

>  				pr_err("failure at %s:%d/%s()!\n",
>  				    __FILE__, __LINE__, __func__);
>  				mpt3sas_base_free_smid(ioc, smid);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-mpt3sas-da=
taout-sz-v1-1-0781d24bb7ad@xiaopeng.com?part=3D1
