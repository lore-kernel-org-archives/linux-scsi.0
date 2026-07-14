Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B26E466B7B
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 13:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784034829; cv=none; b=ZOPT1wp3FmnaOJGK8DRZ0zDSXCqgFFbG09X5DLhqtXxVl0nAQ9D15gU47K4ZBY2XdIGLqYeFyXGjQ3kK9IEfoaX83+eFiIj69sogBFGY0kxBUFrAae1ynmLZGGsLZMwt7nNglk//j9pVsH5hs9JK1M3MR2pRSytI5pcpM0jbzYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784034829; c=relaxed/simple;
	bh=4XdXqvfCpllUsTV9C0fEcX27AbJTm6XJUzdqfr3PDJA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UNYzrybTweVdibIhruKjL8eB45wDA8i1wOHcGdsOGwzgkUxWI7ShKTFdhQsrg0s6B2hT3LwpF6bzXEjABD3oemXI5dMU/9gvUcQjkjY+w9ZYXwYM1i6JHAdEUCDwtWYfUwcuaO6RGXIhEjj2IDcdwzXjMdj5QN2U+B6GZH5yAPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghHNYtQV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghHNYtQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE001F000E9;
	Tue, 14 Jul 2026 13:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784034828;
	bh=dm90V5hgHnJ3xqVu7A0gbfTzjxTAJqkbOkumzh+JFR4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ghHNYtQVk/EALqwiDDYQdphMbqbFWLAJYQLgyIei981sbP1Mf0GkINUnHyg+03ZUD
	 jNZdrd9OxlT0GMYNWJy3r6k+6fesT4+67IaLJuyrhfZk5XgIRsEyYG+VEdnc9WxcL1
	 bC2Tkzft+HT17U5CmrzVdX67r12lMuD+dhVNQ6PXEymJBGIR14v5JIm/5eZvknpniK
	 SptPRT1TZrtoxt9wVNFezC7gxWu5lHJ89FviO3RtSYKV5T9uS9nkFlJ0DN1oXydT7U
	 /LLZqoz/CRnHyRK62dERzHN7/uWyANtZiMjk7mZT9aa0/5JVHHBiLeLwJwXpb8zfx9
	 1Wf3BF9nlMvdg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 18/56] scsi: qla2xxx: Enable get_firmware_state for
 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-19-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-19-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 13:13:47 +0000
Message-Id: <20260714131347.EEE001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Kernel stack data is leaked to userspace via the `fw_state` sysfs =
attribute for non-FWI2 host bus adapters.
--

--- Patch [18]: [PATCH v4 18/56] scsi: qla2xxx: Enable get_firmware_state f=
or 29xx ---
commit ef943e04ab0672ac4bb82500a8cba28415fa19ec
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable get_firmware_state for 29xx

Enable get_firmware_state mailbox command for 29xx adapters by adding
IS_QLA29XX() checks alongside existing IS_QLA27XX/IS_QLA28XX checks.
This ensures MBX_12 (MPI state) is properly set up and reported for
29xx adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
[ ... ]
> @@ -2301,7 +2301,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, ui=
nt16_t *states)
>  		states[3] =3D mcp->mb[4];
>  		states[4] =3D mcp->mb[5];
>  		states[5] =3D mcp->mb[6];  /* DPORT status */

[Severity: High]
This is a pre-existing issue, but does this conditional assignment leave
the remaining array elements uninitialized for non-FWI2 adapters?

Looking at qla2x00_fw_state_show() in drivers/scsi/qla2xxx/qla_attr.c,
it appears to allocate an uninitialized array on the kernel stack and
unconditionally prints state[0] through state[5] to sysfs:

	uint16_t state[16];
	...
	return scnprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
	    state[0], state[1], state[2], state[3], state[4], state[5]);

Since qla2x00_get_firmware_state() only populates states[0] when the adapter
is not FWI2 capable, could this leak uninitialized kernel stack memory to
userspace when reading the fw_state sysfs attribute?

> -		if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
> +		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
>  			states[11] =3D mcp->mb[12]; /* MPI state. */
>  	}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D18
