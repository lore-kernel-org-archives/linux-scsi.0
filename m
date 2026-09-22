Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE2F49BD93
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790120314; cv=none; b=R0r97nQ6mqTloc3k9Gr1yCR0c5VHMG/vOfJADpmflM0sbFDFV/FJVJqzRhnyuMxTn+rxT+KzFqgZICao5JM9yfIY8D42TP9/85DXX2QxETyYFIbqK06X4lL1ENXJGBhAOOskMrZ0UIi5iCKjyZNqEZBCYy8I2YgWXo3fSq8/t/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790120314; c=relaxed/simple;
	bh=H7JkSzG72bVpx8WpdeO4ZPQeUWtwt6E0nyKZ8d+JrjU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cu6x4Cttf6rG8dmXgkjz9GGTZSLAW/HNzSTFdtdrod5VqHb7CjZxnVB/4TlGRpWVsCFMmNCcRAAg7qpX4OeeesmWMuRZlYz7FkAhGY5aJXla4D5PeoyDtRCSZnUbkbrAnHx4KnCuDMPI4DPVkfnqjPOnR1yZXXSvPhGtKmXVwhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oaOOAeLy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oaOOAeLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B651F000FF;
	Tue, 22 Sep 2026 23:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790120307;
	bh=kALtHNWWMnZa7zDu8h0/AwRxDXDTd5Gew+KeEBlpCEs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oaOOAeLyyTforUYz/TA8agvwpXES7XqUh7VW8jUrWTKwAqBGB2ChEbLFanjC28zcF
	 0ckJe8rrDvN0W29Sh8TfIlBHI8fMAbm9RRrwh1CVzP7ZK4moFnz5VMFjqu+1yplaIP
	 KII1QgzhGtIO8ABqgZT3jy1K1Jz2dCSjJpUjqMAoIb9iMQsJiODgW7tX6SiPb0AdwE
	 vtxQl2eNenaPe1PgJhdffZQM1nYvG5CewBwdvXwOfZRXBLpGhezDVL1F0/zrN8e5Jr
	 /Emg3Tc0r9GqAm+3qXclPUzEZP4CMUtfip7wGSYszcVOjKe5xepCN944jmubO+G2/V
	 T5Ng+GPrEOYpA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/7] scsi: scsi_debug: Split resp_write_same()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <ffc8a3e12ea887344ed6529de190235944f87b45.1790119506.git.bvanassche@acm.org>
References: <cover.1790119506.git.bvanassche@acm.org>
 <ffc8a3e12ea887344ed6529de190235944f87b45.1790119506.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 23:38:26 +0000
Message-Id: <20260922233826.D0B651F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: scsi_debug: error code clobbered in __resp_write_same()
--

commit 696b9f54842f667ad884ebcdfbd0d4e29f77e149
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Split resp_write_same()
   =20
Since the Clang thread-safety analyzer does not support conditional
locking, split the function resp_write_same() such that all locking
statements end up in the same branch of an if-statement.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b854102e6caa1..a44886a4c8539 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
[ ... ]
> @@ -5422,9 +5415,25 @@ static int resp_write_same(struct scsi_cmnd *scp, =
u64 lba, u32 num,
>  unlock:
>  	sdeb_data_write_unlock(sip);
>  	ret =3D 0;
> -out:
> -	if (meta_data_locked)
> +	return ret;

[Severity: High]
If fetch_to_dev_buffer() fails and returns -1, the code earlier in
__resp_write_same() sets ret =3D DID_ERROR << 16 and jumps to the unlock la=
bel:

	if (-1 =3D=3D ret) {
		ret =3D DID_ERROR << 16;
		goto unlock;
	}

Does this code unconditionally overwrite the captured error code and return=
 0,
silently masking the write failure?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790119506.gi=
t.bvanassche@acm.org?part=3D2
