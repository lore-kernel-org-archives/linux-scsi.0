Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58FD40F723
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786633325; cv=none; b=a/O4TUAqMzYHjnIOuMP8WWprxajtGA3i4shJbqt/kMinEhg6H0LckNUaSply3mkvs9QkLl52jWKPQq3h2yKIzjVvvcDqPmt31im49GMVsI116QPr9ItWbP8Hz9AOqgU5TwT84j3ZXSd51A0UOX9DHbFZMKsO/fs7za9/jVXHdKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786633325; c=relaxed/simple;
	bh=bYPaB8yx54JMS2lMUTUx4NrGUJf3pfvlOpk17FqeYhU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B9IftucLn6Cqp5KrIoKzQKHfctzLZzGorDkfGxLlfOG4I5IxolmleIEHlBu7pd12zTwgpxVqE5QaSahkRvf+6Fou4WquC0Nvo3zd7MMIZd5ht+ucM79bevnNS/HvkaoEMzAoNhi94doYhCbfBtdou4g0Q6zPMI/+4B4H7XIJSAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Te2rCuqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Te2rCuqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9ED1F000E9;
	Thu, 13 Aug 2026 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786633324;
	bh=8nZ7Q0ORWGkjSgfQtJh5npG1DQUGKG5NPz82PHooFjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Te2rCuqC3sGlD94rTQviVe0FXTyK3+XDmjqLyPs4/V+nenUrZM5Wt9LffpNEB3qbt
	 giYE+a/dSf8nykgSP6tvXpYP3YPjqQLsZLdV7V67ZqkwrNM1eNL0TxwAU/PDxe6v/D
	 0oo3k6Qy5FHux1K8NdvOonkupmo4b+XUF+k2X0Sna8O5bs1K4GuPfNuwVA6CVSaF8o
	 O/KNkg1V58cljEfqaSwUfrKbxRH1SLe0VlLuvGBG/S+qiLbdZjd9lZIDXITP3w0RNM
	 RY3fMVaBCTHOgZ/tthIbPRhH4gOJ0mqE/AX//NMIPfVqAoxKb9skE7csLzxK/r/x9B
	 oSLJrKevp1syQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ipr: fix out-of-bounds read in
 __ipr_format_res_path()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haotian Zhang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260813144614.5081-1-vulab@iscas.ac.cn>
References: <20260813144614.5081-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 15:02:03 +0000
Message-Id: <20260813150204.6A9ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds check on hardware-supplied errors_logged causes out=
-of-bounds array reads.
--

--- Patch [1]: [PATCH] scsi: ipr: fix out-of-bounds read in __ipr_format_re=
s_path() ---
commit bc3f2f125a3eaeb0638d8a5ff264fd2cd1c9634a
Author: Haotian Zhang <vulab@iscas.ac.cn>

scsi: ipr: fix out-of-bounds read in __ipr_format_res_path()

The loop in __ipr_format_res_path() reads res_path[i] before checking
i against IPR_RES_PATH_BYTES. This commit moves the index check before=20
the element access so the loop stops at the array boundary.

> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index d207e5e81afe0..26e967783d952 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -1217,7 +1217,7 @@ static char *__ipr_format_res_path(u8 *res_path, ch=
ar *buffer, int len)
> =20
>  	*p =3D '\0';
>  	p +=3D scnprintf(p, buffer + len - p, "%02X", res_path[0]);
> -	for (i =3D 1; res_path[i] !=3D 0xff && i < IPR_RES_PATH_BYTES; i++)
> +	for (i =3D 1; i < IPR_RES_PATH_BYTES && res_path[i] !=3D 0xff; i++)

[Severity: High]
This is a pre-existing issue, but since you are fixing bounds checking in
this file, could there be similar out-of-bounds array reads in
ipr_log_config_error(), ipr_log_enhanced_config_error(), and
ipr_log_sis64_config_error()?

In all three functions, the hardware-supplied error->errors_logged is read
and used unconditionally as a loop bound over the error->dev array:

drivers/scsi/ipr.c:ipr_log_config_error() {
	...
	errors_logged =3D be32_to_cpu(error->errors_logged);
	...
	for (i =3D 0; i < errors_logged; i++, dev_entry++) {
	...
}

If a malfunctioning or malicious PCIe device supplies an arbitrarily large
value for errors_logged via DMA, couldn't this loop read out of bounds past
the 3-element error->dev array and potentially cause a kernel panic or leak
kernel memory to the system log?

Should errors_logged be bounded against ARRAY_SIZE(error->dev) in these
functions?

>  		p +=3D scnprintf(p, buffer + len - p, "-%02X", res_path[i]);
> =20
>  	return buffer;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813144614.5081=
-1-vulab@iscas.ac.cn?part=3D1
