Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF45356758;
	Thu, 11 Jun 2026 05:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781155483; cv=none; b=MMy4qknuc3vf2o/AsNuytpujO0+q+8MbB3eKE9W4XimTmlspsqSqQzVcG18CVaZUlFSh3NESJ8C3SIwjSohQT+EzPF/JfecRyZXi34Y68Epf0MUvjZbSGnmKqRJhWAJaS5Q7rj8q1IEsnypBW4SxALM6RF7r+XK5AouDULA/R84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781155483; c=relaxed/simple;
	bh=2HfYUlEVwvi11DexqkZ9u8rB8kDyMXVmY5S5bkIGQHQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D4rcCEKfFvFP5niFEIxkmTQ+z1q5LMvzna/LF+4bX5O+etcXtvlRvLwiS/tbi65LjNNichNhyP4fpLWav/PRt6jhftvPOP2IpoRx1dIYSzdc5x3OlxayoIa8SqRol0W5u6LfqZq602n8f04/RteaRJjGU+3/iapG/P4d/UyFL/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ln2lwGn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ln2lwGn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7161F00893;
	Thu, 11 Jun 2026 05:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781155478;
	bh=Buhkmxb3ZNMrPMUtF32QejzkZs38v+9romIh8ssMWMk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ln2lwGn8ebV0wVeZZc38175s7vjKk61wJ6PsM0anQfDAdcqF4wzs+q3AUa/Z3YEdb
	 jCDteE19K5SqF7r6BhdWxW2b4E2cATzp2hGdZkJIt21MCCBBvsbmasRnW05XbFNtFi
	 +c31oybkunZnbFB++eAR7q5278EpUqNvchUqVkAU51ae6EJ2KJSm3iQmmp32KGELOg
	 /TUhPob0t9IxoS5PatV60dK7RTpQP6x2mP9M9Q7Hj086qahgUBdgfVWRpPV/uXOTVK
	 /DnhE7wnzNaEKwLcP5oEn4y/DIsORv7zW+uo3ikQ5AAxMoi936lYeclRT8a4TzGogJ
	 s1akCT6Z+aIeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] zfcp: Trace plogi and prli within open port
 response as payload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260611050550.796772-4-niharp@linux.ibm.com>
References: <20260611050550.796772-4-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 05:24:37 +0000
Message-Id: <20260611052438.0C7161F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Preexisting out-of-bounds read of kernel memory due to unvalidated=
 `log_start` and `log_length` fields from the FCP adapter response.
--

commit 9e601763da63b3c0c65512bab46a16c131e45614
Author: Steffen Maier <maier@linux.ibm.com>

zfcp: Trace plogi and prli within open port response as payload

This commit updates the zfcp debug trace to include PLOGI and PRLI content
from open port responses back-to-back in the payload trace record. It also
introduces a level argument to zfcp_dbf_pl_write() to control trace
verbosity and avoid flooding the log.

> diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
> index 89b859176b8bd..4217b74baa380 100644
> --- a/drivers/s390/scsi/zfcp_dbf.c
> +++ b/drivers/s390/scsi/zfcp_dbf.c

[ ... ]

> @@ -96,7 +101,27 @@ void zfcp_dbf_hba_fsf_res(char *tag, int level, struc=
t zfcp_fsf_req *req)
> =20
>  	rec->pl_len =3D q_head->log_length;
>  	zfcp_dbf_pl_write(dbf, (char *)q_pref + q_head->log_start,
> -			  rec->pl_len, "fsf_res", req->req_id);
> +			  rec->pl_len, "fsf_res", req->req_id,
> +			  ZFCP_DBF_PAY_LEVEL);

[Severity: High]
This is a pre-existing issue, but I noticed it while looking at this
modified call to zfcp_dbf_pl_write().

Are q_head->log_start and q_head->log_length validated before being used
to compute the source pointer and length here?

Since these fields are retrieved from the FCP adapter's response header,
could a malfunctioning or malicious adapter return arbitrarily large
values? If log_start + log_length exceeds the bounds of the req->qtcb
allocation, could this result in an out-of-bounds read of kernel memory
when copying into the trace buffer?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611050550.7967=
72-1-niharp@linux.ibm.com?part=3D2
