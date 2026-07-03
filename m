Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F05341AD6
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 22:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783117979; cv=none; b=FF0YxRmhVuI+YIJKwt74rWeO9jwEacUgjoKY7Y/XKTsPfNHP/RFkGBCaJtCzhmV1k6CAGAMaE3VrUzhmQ4oYIQJJxFPQGNiRnDTXjno4DLRhm7BVr5zMODm0yMXgqkszcR+5xTuV0cmkvFwln+Hn46mgpiORb+co7UDJkbCGMPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783117979; c=relaxed/simple;
	bh=Htz5SKfqtgUVd9qMSDTOxnc7fiOCpQxFmm7K87Usawc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V8OJAeZOeiFkMopN7aj/aL2gHKHo3ldOJacKRthGzGUHL6LKV0HDos19CBlyfQal0FCCzY+V47gW/BXFtR6RBW8E7+aKI3ttSWvk1RNPHcwc/EiDXhBQWX965cm37At7z5g4Bvn7BrAksZGFKbGBwkr9lfijOM7OXXsxdhh+WKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGAclgn+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGAclgn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8499C1F000E9;
	Fri,  3 Jul 2026 22:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783117977;
	bh=CUnwRQVyLW6hcC4NvA7mYuHSmL1RuW4fFvFF3c6a50g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WGAclgn+hbQqSTNaQZhuYlSDgZeFi+Oy+li4OTH0v206sq0Ob8Dn77IsNtGAh0TKk
	 H4ZBeKc3innuI4x7DDt9j5kee1Ws+qirZtG18jzHSyqm9h4zuFCHRHkVJeh6GnRcuX
	 MQ2bhVMkR9ivyc7C6kXx2Ejrg49mcyXgeuQVcH12XlYY+/TgoRAm+hJkMAdY8Dt9Xq
	 8uppmmojnAM4cXE9XA3a1Zc89inygezF2o4n5LrNPbwuZ5mP9v0L1sSdRjzNdRiAxv
	 edubkavtiNZ/KyDPCGSXakVVq7lDGzDyyOS9QuO+9xo5Y5PYjAjzx4M+8DJwIzcPIl
	 TmytP6GJ1Oorw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: csiostor: Use str_plural() in
 csio_mem_intr_handler()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Thorsten Blum" <thorsten.blum@linux.dev>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703221731.180534-3-thorsten.blum@linux.dev>
References: <20260703221731.180534-3-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 22:32:57 +0000
Message-Id: <20260703223257.8499C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The patch introduces a build failure by including a non-existent he=
ader `<linux/string_choices.h>` and calling an undefined function `str_plur=
al()`.
--

commit cdb7701e8f1bfc8ec07f47cf6dd02c5a65955713
Author: Thorsten Blum <thorsten.blum@linux.dev>

scsi: csiostor: Use str_plural() in csio_mem_intr_handler()

This patch simplifies the pluralization logic in csio_mem_intr_handler()
by replacing a manual ternary operator with the str_plural() helper.
It also adds the string_choices.h header to support this function.

> diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio=
_hw.c
> --- a/drivers/scsi/csiostor/csio_hw.c
> +++ b/drivers/scsi/csiostor/csio_hw.c
> @@ -38,6 +38,7 @@
>  #include <linux/stddef.h>
>  #include <linux/delay.h>
>  #include <linux/string.h>
> +#include <linux/string_choices.h>

[Severity: Low]
Does this header exist in the current tree? It appears that including
linux/string_choices.h might cause a build failure if the header is not
present in this kernel version.

[ ... ]

> @@ -3026,7 +3027,7 @@ static void csio_mem_intr_handler(struct csio_hw *h=
w, int idx)
> =20
>  		csio_wr_reg32(hw, ECC_CECNT_V(ECC_CECNT_M), cnt_addr);
>  		csio_warn(hw, "%u %s correctable ECC data error%s\n",
> -			    cnt, name[idx], cnt > 1 ? "s" : "");
> +			  cnt, name[idx], str_plural(cnt));

[Severity: Low]
Is str_plural() defined in this kernel version? If the helper function
is missing, this will result in an undeclared function error during
compilation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703221731.1805=
34-3-thorsten.blum@linux.dev?part=3D1
