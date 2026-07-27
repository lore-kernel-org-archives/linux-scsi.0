Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9D3353A8A;
	Mon, 27 Jul 2026 10:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785146992; cv=none; b=DFdSAxnNg20pjK5hEGjAwRoePWXCf/Scw5ltDlHkN1MPqrIH7PCPiRKqda+hskm8G4MDo0dc/1kKW0wvJFGxUdz+AgPOrDUBkVJBRIYy6zlb1l2ZzVcfrKzrJYt1YrQwi+BDUCk7eyiRe+1vpULCJ4lIscvVU22Jgn2flRYwnIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785146992; c=relaxed/simple;
	bh=u9vozjv2aR5wEjFIwxW95SSsCpB1+yT6NtyHX0qutmc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SrdlUJQ/9qdafCFvZYyIS/ewn1IBSWy0rfUgePFxc1/O2CVDf0bMjFoOArCEnSlmqpheXTS1tlV3FrdPsyCK+qpfdi1CVqDcCTgjOws/3YdSkGztO4wmWxdJK77JUocUPP0AhfVv5Q7ErIZ1y3cvPX52MbpdsyUrbHwEB9ta3b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gj4u1bXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gj4u1bXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096381F000E9;
	Mon, 27 Jul 2026 10:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785146991;
	bh=XL2/zkiy6+qTuXkHYOtvsPLHCZ+5VBWWQDz8JXRgW3g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gj4u1bXI6ZY4VYA6Qj1Rdhix8t31JfBqzBA4uDIttew533Rscbkzf6rnlxXqTFRfQ
	 lLchgWdN6+XhsTTVM82k7zGOZjvaBx9dizZa4LU8gPF7jgAkjQ9qK/0ZPpp5Bxm6yv
	 XN8w4zfy+CKoj78aosfcINhmV4nDyCur/QCQlY5qLPbSw/pHmhae0vsCTD25L8aUWP
	 D5XYvKxsexTDfCCW4VwuWaS27J+r0QB5Ea9ioORaWQBcCIm1F2dHql2y5McNqlZ3rR
	 LmqPG52/fcz9gL00/luIyGOknoAVT3f+XoH7jLCxedOugYBzzQMiKDEDO9nPDmjqSV
	 256gi0vTKaMfw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/3] soc: qcom: smem: Use 'unsigned int' instead of
 'unsigned'
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konrad Dybcio" <konradybcio@kernel.org>
Cc: devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260727-topic-smem_dramc-v5-1-66188b3e338d@oss.qualcomm.com>
References: <20260727-topic-smem_dramc-v5-0-66188b3e338d@oss.qualcomm.com>
 <20260727-topic-smem_dramc-v5-1-66188b3e338d@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 10:09:49 +0000
Message-Id: <20260727100950.096381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Incomplete conversion from 'unsigned' to 'unsigned int' leaves head=
er and source file inconsistent.
--

--- Patch [1]: [PATCH v5 1/3] soc: qcom: smem: Use 'unsigned int' instead o=
f 'unsigned' ---
commit 936d065428d0ec1f3bef2d47e4d7642e78104f77
Author: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

soc: qcom: smem: Use 'unsigned int' instead of 'unsigned'

This commit converts the SMEM driver to use the 'unsigned int' type instead
of bare 'unsigned'. This is intended to resolve a checkpatch warning about
preferring less ambiguous types.

> diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
> index afb21a778fe7b..43b66120fc644 100644
> --- a/drivers/soc/qcom/smem.c
> +++ b/drivers/soc/qcom/smem.c
[ ... ]
> @@ -503,7 +503,7 @@ static int qcom_smem_alloc_global(struct qcom_smem *s=
mem,
>   *
>   * Return: 0 on success, negative errno on failure.
>   */
> -int qcom_smem_alloc(unsigned host, unsigned item, size_t size)
> +int qcom_smem_alloc(unsigned int host, unsigned int item, size_t size)

[Severity: Low]
Should the function declarations in include/linux/soc/qcom/smem.h also be
updated to match these new definitions?

The public header still declares qcom_smem_alloc(), qcom_smem_get(), and=20
qcom_smem_get_free_space() using bare unsigned types. Updating the header
as well would keep the API consistent and fully resolve the checkpatch
warnings for users of the header.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727-topic-smem=
_dramc-v5-0-66188b3e338d@oss.qualcomm.com?part=3D1
