Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87023EDE42;
	Tue,  8 Sep 2026 09:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861550; cv=none; b=bFioZc7OxAEmk/6NSUny3jUD+oui06lstCtQs6ORABwCY4/wh9FkHv241eALxLK7QMhC6KJn1yodQ5PVaSkAdo1nMOiTFxvOunn+BHlq5WoZO/yp75MEfGWcrE6KtvjqK61CLmiHoLi6RyBl4K2r+NoNoOxcvLdFrJiEiSqeAH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861550; c=relaxed/simple;
	bh=OuhgeNhRs6+FqwUDium+XZm/bFgvfVdEHlXUjxxvzzc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hxwfXM90oJnN6Sra75DlJxXLQzHvqqygN+C7+3jDm1WXFZgmmR4/gXUSGT5lFmU0bQqpOjZAeMS4JiDG/JwnL997LH5gBN10aZraYMPZz8ZoZOjza4ocX71OBlUq0hBKp1hein/HaIp7nO8QjhGd5LYQYriul6/PpMbGVXyMFRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLQra0BH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLQra0BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80BC1F00A3A;
	Tue,  8 Sep 2026 09:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788861548;
	bh=7V+8y7H2wWBJF6JFA4qiCIQs+9Nk25EEK0zOmC3fGi4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eLQra0BHFtNZoFfFtC6ycmGNcLjHagCUKhaya88m/mynHB2UTV7cvodoPVtzjKnGq
	 rKEN0b+aGQcLk/Jtgjh4c4cYUuDkZpJumsp0W0IKnQLiaJlrz2lkx96g0lQNLZIg2P
	 H3Cm/K9NC4bUc2dQyft++IovOkpPRM0tuXTJt8qqm6F98W9GmohdV7s5yMEv5oYlAt
	 v3ZbpdRL30SHgf1SyXZRIe3tTEvli3/ORuAr/BixUVNhHJblLOSncbVPbmbtfIoce8
	 R3TavHW1K3DKsWNs575QJc+nmbBYWzvMXQqr15Yx8IQw1OCaUQ0YHCW6JouCwe5Jie
	 IlTATHiGbfhKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 22/40] scsi: myrX: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-23-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:59:07 +0000
Message-Id: <20260908095907.E80BC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The REQUEST_SENSE command intercepts the CDB but returns without c=
alling scsi_done(), causing the command to hang.
--

commit b860b6810bf948611bc8eabd52fcae5e876d0483
Author: Damien Le Moal <dlemoal@kernel.org>
scsi: myrX: use 16-bits defined sense codes

Refactor the Mylex RAID controller driver to use scsi_set_sense() and the
16-bits sense_code field of struct scsi_sense_hdr and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h.

> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 3678b66310ed0..95df6e5345f7a 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c

[ ... ]

> @@ -1493,8 +1495,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(s=
truct Scsi_Host *shost,
>  		return 0;

[Severity: High]
This is a pre-existing issue, but does this missing scsi_done() cause the
REQUEST_SENSE command to hang indefinitely?

Looking at myrb_ldev_queuecommand(), the REQUEST_SENSE command is intercept=
ed
and returns without calling scsi_done():

	case REQUEST_SENSE:
		myrb_request_sense(cb, scmd);
		scmd->result =3D (DID_OK << 16);
		return 0;

Because this command is never completed, could it hang indefinitely and
eventually trigger the SCSI midlayer error handler?

Since userspace applications with access to the SCSI generic device
can send arbitrary SCSI commands via the SG_IO ioctl, could this be reached
from userspace and trigger a local denial of service by forcing SCSI error
recovery?

>  	case SEND_DIAGNOSTIC:
>  		if (scmd->cmnd[1] !=3D 0x04) {
> -			/* Illegal request, invalid field in CDB */
> -			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
> +			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
> +				       INVALID_FIELD_IN_CDB);
>  		} else {
>  			/* Assume good status */
>  			scmd->result =3D (DID_OK << 16);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D22
