Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8C4208D0
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jul 2026 01:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783127599; cv=none; b=K5SC7kXNAc0h9t7pNUSmWxYkKXYt/JGbrUudrwt/yR6IggADLC14+NPxWExmCVc+/U6mpPR7xUZu9Y0bUaMdd0A5rBa/R1rBvNf13ewTwQFjNu2MkYF8oFs+Hu8Na+2cxP2MmUSSkPbA0k3qscsjIJd7lW60KuIv3zKiWyn9f0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783127599; c=relaxed/simple;
	bh=gVlP0EOj99AMYOqAJl+SvToBWL4BpO77O4QXthsqIoY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CaqnwVik2kqu5BVkoOyWN/zb6Rs+oRWeIQyc9I8GWVlHwF7249MW4FmZ5nXO9BBJRyIluhM4Krxa7dhy7TsKSB0IFYTYkVvadtbtrMWwls3zuHqJEg9xZeDO9kcnEhfr6Dr8DW9MOdMRqea5axfp6XP7FbkDFZT2dl44AKWrN9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LAk1Koj9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LAk1Koj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6172B1F000E9;
	Sat,  4 Jul 2026 01:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783127597;
	bh=d/sgVXdAf8ZKEwpHmiSr9ADBBuMNdmlXycxkAM17JSI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LAk1Koj9XD6uKCnFfNA935UGWWVWkhlryz4KgOvPmwu2Th9XaimTY/vfbVcdImAiv
	 6bL2o5kL7kBr57gYpXcJPfEJopXG8UwN6kN2IublX6v8d/LA0QwtRgKYvyUDVnGTVc
	 badvFYoQ2++D7jqdRAb+E0HWH84zTFZ+OnULot7n6CvxtIjctSjT/CyaIGpiJhebkq
	 BjRRQEiDwhVaPkLYvMN2BiLaDCUBx31e/CXRCh3Q54kt1m6P2kfaXCOPyNfMc8hePe
	 D7g00/RN6YEGiUlQ2JWYhfpODY6DK3D7VfYffYF0+VqnTHMDL9TxEe0vbAGHDPcM2c
	 AiWRaSdMdQAzg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: 3w-9xxx: bound firmware error string parsing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260704010512.71912-1-pengpeng@iscas.ac.cn>
References: <20260704010512.71912-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 04 Jul 2026 01:13:16 +0000
Message-Id: <20260704011317.6172B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The identical out-of-bounds read and copy vulnerabilities fixed by=
 this patch in the 3w-9xxx driver also exist in the 3w-sas driver, but were=
 missed. The `twl_aen_queue_event` function calls `strlen(header->err_speci=
fic_desc)` without bounds checking, which can read past the fixed 98-byte f=
irmware array. Furthermore, it uses the resulting unbounded pointer `error_=
str` to calculate the copy length for a `memcpy()` into the 98-byte `event-=
>parameter_data` array, leading to a heap buffer overflow. A similar unboun=
ded `strlen()` is also present in `twl_fill_sense`.
--

commit 18b063874ec862a643c52abdfc2ae2cc3b0824b7
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

scsi: 3w-9xxx: bound firmware error string parsing

This commit bounds firmware error string parsing in the 3w-9xxx driver.
It replaces unbounded strlen() calls with strnlen() and enforces null
termination to prevent potential out-of-bounds reads and writes.

> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 9b93a2440af8f..d6e183517797e 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
[ ... ]
> @@ -404,11 +405,21 @@ static void twa_aen_queue_event(TW_Device_Extension=
 *tw_dev, TW_Command_Apache_H
>  	tw_dev->error_sequence_id++;
> =20
>  	/* Check for embedded error string */
> -	error_str =3D &(header->err_specific_desc[strlen(header->err_specific_d=
esc)+1]);
> -
>  	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] =3D '\=
0';
> -	event->parameter_len =3D strlen(header->err_specific_desc);
> -	memcpy(event->parameter_data, header->err_specific_desc, event->paramet=
er_len + (error_str[0] =3D=3D '\0' ? 0 : (1 + strlen(error_str))));
> +	desc_len =3D strnlen(header->err_specific_desc,
> +			   sizeof(header->err_specific_desc));

[Severity: High]
This is a pre-existing issue, but the identical out-of-bounds read and copy
vulnerabilities fixed here also exist in the 3w-sas driver.

In drivers/scsi/3w-sas.c:twl_aen_queue_event(), the code calls
strlen(header->err_specific_desc) without bounds checking, which can read
past the fixed firmware array if the SCSI controller firmware sends an AEN
lacking a null terminator:

    error_str =3D &(header->err_specific_desc[strlen(header->err_specific_d=
esc)+1]);
    ...
    event->parameter_len =3D strlen(header->err_specific_desc);
    memcpy(event->parameter_data, header->err_specific_desc, event->paramet=
er_len + 1 + strlen(error_str));

This uses the unbounded pointer error_str to calculate the copy length for a
memcpy() into the event->parameter_data array, leading to a heap buffer=20
overflow.

A similar unbounded strlen() is also present in drivers/scsi/3w-sas.c in
twl_fill_sense():

    error_str =3D &(header->err_specific_desc[strlen(header->err_specific_d=
esc) + 1]);

Would it make sense to extend these bounds checking fixes to the 3w-sas
driver as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260704010512.7191=
2-1-pengpeng@iscas.ac.cn?part=3D1
