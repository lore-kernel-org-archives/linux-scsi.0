Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C31352030
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 05:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782884874; cv=none; b=PwIhytBJ5u9Du6fYkItdZpsPmPXl+9AF3ha1FQWVWwWSCmRYiWCEMBXQRkeOQpFG/wblmKXWnc45rDwtZpQB+HJiUjIAMJkwR95s6c3pRbT8fF8QpAQslim9/nUUuQaK9SwEsQf4Yo7BBGG8yjGIJcaeCwKZS3S/YLDz/VTH7S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782884874; c=relaxed/simple;
	bh=K6n7e4rE92TsF0lkqwznQmgS+E25XwAYT7QlcPCqQec=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AToD9DbsEh/tT2erjd8zwbGBVoY3qZ7iAR8NvAfL7WqUHJUHJlVeduLIC8BHbTjNZexZ5HOgthwdgXMAmTY+8k974p8lTaSwJnIMQw2mscFr5a87PNpjLN/iLci7KYJKZxnBuDVBEybhJgZ1LZqeqDxl66JSM1T9XmWCRryRu0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NY7r+mhy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NY7r+mhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10861F000E9;
	Wed,  1 Jul 2026 05:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782884873;
	bh=A5gOpBdOGsuJrRI4gVzVdWq99daw5TmXHCksX02r7Do=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NY7r+mhy1RsfNJHMkGrgR4hlo+gu6CDkfrSa46FaSjNfXfBwdJPN+IeRZlYd1EWIY
	 8EuuaZ4hJ85o/hwfy8DWR7aHT1n5OMoKqqJUUZp7Tib3aRAfvmM+C4YfiwbUQVx1T1
	 6zylQiXtSRbERCryrFmEGHdVDSOXY+Dv5sHTdXVIVonQx9df+1pHf1X7CqGdH3ykU2
	 gbgKx7MEplS9rHuvkJlZugg+1WKxKKml4sHi40/1ZBcVonkDaZjCe4dy24ZL704T+F
	 ksrSI6f0ppFYWxBXxvmsLVa5a1Mrb1gRs08QUnHTaiceSDcWyxnS9AVeA6QQiz3UZl
	 EuPfklyqzOACg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: hpsa: clamp physical LUN count in fallback report
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260701053626.44118-1-pengpeng@iscas.ac.cn>
References: <20260701053626.44118-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 05:47:52 +0000
Message-Id: <20260701054752.D10861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The fallback path fails to zero out the remaining fields of the 24=
-byte extended LUN entry, leaving them populated with garbage data from a p=
rior failed DMA transfer.
--

commit 2d3d5c4cd564b5d4730f076194c9998a95c658a9
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

scsi: hpsa: clamp physical LUN count in fallback report

When REPORT PHYS EXTENDED is not supported, the driver falls back to REPORT=
 LUNS
and converts entries. This commit clamps the converted count to array bound=
s and
updates the output LUNListLength accordingly.

> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index a1b116cd4723d..a7115efdde7fe 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3797,6 +3797,10 @@ static inline int hpsa_scsi_do_report_phys_luns(st=
ruct ctlr_info *h,
>  		/* Copy ReportLUNdata header */
>  		memcpy(buf, lbuf, 8);
>  		nphys =3D be32_to_cpu(*((__be32 *)lbuf->LUNListLength)) / 8;
> +		nphys =3D min_t(u32, nphys, ARRAY_SIZE(lbuf->LUN));
> +		nphys =3D min_t(u32, nphys, ARRAY_SIZE(buf->LUN));
> +		put_unaligned_be32(nphys * sizeof(buf->LUN[0]),
> +				   buf->LUNListLength);
>  		for (i =3D 0; i < nphys; i++)
>  			memcpy(buf->LUN[i].lunid, lbuf->LUN[i], 8);

[Severity: High]
This is a pre-existing issue, but does this fallback path fail to clear the
remaining fields of the 24-byte extended LUN entry?

When the initial hpsa_scsi_do_report_luns() call fails with -EOPNOTSUPP, it
may have successfully completed a DMA transfer that populated buf with stan=
dard
8-byte LUN data.

This loop only overwrites the 8-byte lunid of the 24-byte extended LUN entr=
y,
leaving the trailing 16 bytes populated with data from the prior failed DMA
transfer.=20

Could this cause hardware property corruption? Data structures like wwid,
device_type, device_flags, and ioaccel_handle might be populated with bytes
from adjacent LUN IDs, potentially causing the driver to misidentify devices
or use invalid IOAccel handles leading to IO failures or crashes.

>  	}
>  	kfree(lbuf);
>  	return rc;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701053626.4411=
8-1-pengpeng@iscas.ac.cn?part=3D1
