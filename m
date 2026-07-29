Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE9E3AFCE5
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785337798; cv=none; b=ijCkxFp7wvaoUY0UCGnulLKdJNRaH1/qdLi4YczjidWDsQSB3gvZyFct5BnCZTX6cthc4gh1oFtub3vLrWmN21WqC5K1I1cFSOWGZOm88FA03OtJGpY9uff8jS3NPQISX+mCTPcZav0OGbA0sq/1mw6HFS79xhrjdSnLY4lofC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785337798; c=relaxed/simple;
	bh=9LgMT+DHBH4XIQ3UAssn/tNui9lejH3BMZfjYFecitg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Viyq4CHw1Hs9J5HJ/3QIbW4ZOB1pFSJpcCTJ/OmRLFTw88oA5WAsggdcIQDye9lNvVzz+FfClXQHJLBYX3euBZI0mjkxB4m6m5VZKFOM5seJjimhvMAYhdUML9CuG26Rs0OkvGCKv5OAlz0CqoMJq/kOfppR9PUcrJ51E3S8O60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqoNC+5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqoNC+5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6602A1F000E9;
	Wed, 29 Jul 2026 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337796;
	bh=JSlLOJ/NyE9EPe/XjDSuHqwngbCFbcLtctvlzE682r8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LqoNC+5Dt4qM5IckR6FtjS9Z/2Sa5piU/FnlV/Jv+f5vTUWXfuOGFlNT/6rYFsRal
	 TmqoC3daYcIqzdhE2aWXgAucCWUt0IbIU3VpJ3743gLisuP11pLiC392PXlsh/UT5n
	 PaoMVuJyz01AqrQuEHTbvkDYQ/oMIMcpM5baAhCrV2+usoI4YNrDYequens7hV0jbz
	 u9VFjC5pqZJT/HMdQfBlmVTsUmO1eKRRYcZIskj2XMPt2HNbVTxfE10PoOtM6dcQhM
	 tJIEdf19Yy8PmkAeXQkIyyt8uAlVruYF5c4pQOmoSz4AbO3951BKFfdclxrDkaFpDc
	 9kC4weFO1sPlg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] scsi: lpfc: Replace strlcat() with scnprintf() in
 lpfc_vport_symbolic_node_name()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Bridges" <icb@fastmail.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729144617.1388646-3-icb@fastmail.org>
References: <20260729144617.1388646-1-icb@fastmail.org>
 <20260729144617.1388646-3-icb@fastmail.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 15:09:55 +0000
Message-Id: <20260729150956.6602A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pre-existing out-of-bounds read and stack buffer overflow in `lpfc=
_decode_firmware_rev` due to partial array initialization and missing null-=
termination.
--

--- Patch [2]: [PATCH 2/5] scsi: lpfc: Replace strlcat() with scnprintf() i=
n lpfc_vport_symbolic_node_name() ---
commit ccac320efc7231c941f0ae4e81fa116ae23ad75e
Author: Ian Bridges <icb@fastmail.org>

scsi: lpfc: Replace strlcat() with scnprintf() in lpfc_vport_symbolic_node_=
name()

This commit replaces strlcat() API uses with a single scnprintf() in
lpfc_vport_symbolic_node_name(). The replacement formats all fragments
directly into the destination buffer, avoiding intermediate truncation.

Link: https://github.com/KSPP/linux/issues/370 [1]

> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index c7853e7fe0719..0734ab3be3e30 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -1823,34 +1823,15 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *=
vport, char *symbol,
>  	size_t size)
>  {
>  	char fwrev[FW_REV_STR_SIZE] =3D {0};
> -	char tmp[MAXHOSTNAMELEN] =3D {0};
> -
> -	memset(symbol, 0, size);
> -
> -	scnprintf(tmp, sizeof(tmp), "Emulex %s", vport->phba->ModelName);
> -	if (strlcat(symbol, tmp, size) >=3D size)
> -		goto buffer_done;
> =20
>  	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);

[Severity: High]
This is a pre-existing issue, but can lpfc_decode_firmware_rev() cause a
stack buffer overflow when called from other paths with flag =3D 1?

Looking at lpfc_decode_firmware_rev() in drivers/scsi/lpfc/lpfc_ct.c, the
stack array str is only partially initialized:

drivers/scsi/lpfc/lpfc_ct.c:lpfc_decode_firmware_rev() {
        uint32_t *ptr, str[4];
        ...
                for (i =3D 0; i < 3; i++)
                        str[i] =3D be32_to_cpu(*ptr++);

                if (c =3D=3D 0) {
                        if (flag)
                                sprintf(fwrevision, "%d.%d%d (%s)",
                                        b1, b2, b3, (char *)str);
                        else
...
}

Only 3 elements (12 bytes) of the 4-element str array are initialized.

If the firmware name does not contain any spaces to be converted to null
bytes in the first 12 bytes, won't sprintf() read past str[2] into
uninitialized stack memory?

Since this reads until a null byte is encountered, couldn't this overflow
the caller's fwrevision destination buffer?

This appears reachable when triggered via sysfs where untrusted device
firmware might provide maliciously crafted data.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729144617.1388=
646-1-icb@fastmail.org?part=3D2
