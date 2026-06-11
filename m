Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF093033FC;
	Thu, 11 Jun 2026 05:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781155613; cv=none; b=tkGlFt7P+7cj7tJVr4VULby7/7PI4ibRyhX4MgSszn2Blrrq7pNkFjjWzkqCBT2ID2tIsK1ELfsdzGxQy1ITUBLckhWG8JFVyEgDCYvlO7igl52P1hwiQnSVNKzYPqGqOcsPhgMFwFzyb9vnfTgkLeFmhJ4Fjs8zSR2KMsjYmtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781155613; c=relaxed/simple;
	bh=ekYEWjS9N64LOzaEzqlLT+Hj9id9sJVlAKHXYtt/Rug=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o+uvOS4ExP6m7/otl19z4wcqswNFpLaKzja1tdoacSZDVdX4S/1cxxc7mhweWXFCKHQguIbwIdtH26QrtC1cveu4Fb8//Y49cajAs261n9MxugVJU3gkb6u4Qrl+s9HfT5OcHC6vGYy1FOc3lOkq4qQJquqEKD5YTgdWXmIGvFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DRxQjrWA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRxQjrWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9411F00893;
	Thu, 11 Jun 2026 05:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781155607;
	bh=TobHS9ksDe3FfyUDcXlxzxb+i1S5VgerDw+M5X2BPyA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DRxQjrWA1vSBFElzNAW83mA91tc2HGuF6mWu+WJ3tm1Cmbo8A6nkUkixpUl/iDFCL
	 DO0Qz9VcdO4n2W5BJUFxXghmDkU2GPMU9xRx1RbbrWKVYSPm100pQaxFjVpFJHGgLu
	 YwHLDdTnPFOFAGcW2U/19j9D9C/5bt9SBgwowKQkTAjjSNBl3eQ1kkUxcR6bL53OgZ
	 h8wbVu4wKYe4P0lxgIYkjHyyumG/KPO0IAwF3o0Z3eqi+DYtw89Of2ibu0L3dfvwKI
	 YgAJnpO3z+wOSYNTL82J7k1GNmGY9+VgufMRi6EvqrOyLWYiKvtD8oGQUHadHPEmcH
	 CqRDBAJ5FUYJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] zfcp: Enhance fsf status read buffer tracing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260611050550.796772-3-niharp@linux.ibm.com>
References: <20260611050550.796772-3-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 05:26:46 +0000
Message-Id: <20260611052646.5D9411F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Potential out-of-bounds read and information leak due to an unvali=
dated hardware-provided payload length causing an integer underflow.
--

commit 2a80a7c2006e6e0fd3b5316bfecd4d7662992064
Author: Chinmaya Kajagar <chinmayk@linux.ibm.com>

zfcp: Enhance fsf status read buffer tracing

This commit enhances the status read buffer trace records by appending the
remaining FSF status read buffer fields to the trace structure and extracti=
ng
the 3-byte source ID.

> diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
> index 71f625926ae19..89b859176b8bd 100644
> --- a/drivers/s390/scsi/zfcp_dbf.c
> +++ b/drivers/s390/scsi/zfcp_dbf.c
> @@ -220,6 +220,13 @@ void zfcp_dbf_hba_fsf_uss(char *tag, struct zfcp_fsf=
_req *req)
>  	rec->u.uss.lun =3D srb->fcp_lun;
>  	memcpy(&rec->u.uss.queue_designator, &srb->queue_designator,
>  	       sizeof(rec->u.uss.queue_designator));
> +	rec->u.uss.length =3D srb->length;
> +	rec->u.uss.res1 =3D srb->res1;
> +	rec->u.uss.res2 =3D srb->res2;
> +	rec->u.uss.class =3D srb->class;
> +	rec->u.uss.res3 =3D srb->res3;
> +	rec->u.uss.s_id =3D ntoh24(srb->s_id);
> +	memcpy(&rec->u.uss.res4, &srb->res4, sizeof(rec->u.uss.res4));
> =20
>  	/* status read buffer payload length */
>  	rec->pl_len =3D (!srb->length) ? 0 : srb->length -
>  			offsetof(struct fsf_status_read_buffer, payload);

[Severity: High]
This isn't a bug introduced by this patch, but is there a risk of an integer
underflow here that could cause an out-of-bounds read?

In zfcp_dbf_hba_fsf_uss(), srb->length is an unsigned 32-bit integer read
from the hardware DMA buffer without validation. If the adapter provides a
non-zero length that is smaller than the offset of the payload (which is 64
bytes), the subtraction will underflow.

Because rec->pl_len is a 16-bit integer, the massively underflowed value ge=
ts
truncated. For example, a length of 32 would yield 65504. When this length =
is
passed to zfcp_dbf_pl_write(), it will read that many bytes from
srb->payload.data into the trace.

Since the memory backing srb is allocated as a single 4KB page, could this
copy read tens of thousands of bytes out-of-bounds, potentially leading to a
page fault or exposing adjacent kernel memory in the debugfs traces? It see=
ms
like a similar out-of-bounds read might also happen if srb->length is simply
larger than the 4KB allocated size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611050550.7967=
72-1-niharp@linux.ibm.com?part=3D1
