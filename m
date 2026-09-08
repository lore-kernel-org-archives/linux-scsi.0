Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CBB4A2E17;
	Tue,  8 Sep 2026 09:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859092; cv=none; b=ckbDOTcNOxiz9nD8wNTkM/TH35xp/X2V6XkLiqVi7YXnhlO5Tl+L71s8NR0HeM1fKWMLPlsU9Xow7QCawSWhFq3C0pKeJ8c0pKVSWESbKF6l4QX6UksatnFRq+2pemrucgAze1HEJkg7LeSKkmQLXfuGvj2Y7PwEtWmRtV9V9Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859092; c=relaxed/simple;
	bh=9gh5ZOnXWknfpYppFQ6I6Z6KzgkhF8/naffe1JMb0kw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IpY7F/0aOJBcyXjdPVL8YMlTnGY6GwzHtzIS14FJJLG9QNs5P0r/sD11XiwWspERFNSkQNPRDPfcn7D6Ecy+2Peb1pjZiFqbxp4Dc3YqK6r+JlZmTf+jvZQYjyuq9b1cJ6lsYkLYjfABvroG51l2ct6MxUl2Z3EBpxKjT2QnAcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inWt4oP7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inWt4oP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0701F00A3A;
	Tue,  8 Sep 2026 09:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859091;
	bh=tAk7viIHZsnMmX4cELvtALb/L8uHPIZ08G7jMlOEEh4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=inWt4oP7YYHqoYX0K13sjPYvi3E9IIBGg8/T68qcEvE5yIS+pESCf+5kM8ZW7MEB9
	 Q+GOTi/AGu3qAWECT/9+3jbzFiplD3ogcp0RdZd2vwv06BiV9k6I8jRYI4WSe23uqB
	 SM/nmS3olTgUWxxhGujfOpF3xAOKJlcfvTl59NXkYVp9qcG/U4IRaCRISiZh53eddJ
	 bbRFX9z9/ZvG0+8WIyT6mfPyuRNQ7cL0e5IaJDLViWFcQpAOAwqqEs1qU3o0RZWroB
	 VvZo1OzRofGgh2SEPolbgvjclmkZ4xKiFJr/l1hoIweRif63AEQFRUA5WPrZY4hx1b
	 gqCMhcK/idoDQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 04/40] scsi: rename sense field of struct
 scsi_failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260908090308.1085097-5-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:18:10 +0000
Message-Id: <20260908091810.9F0701F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing sentinel element in failure_defs array leads to stack out-=
of-bounds read.
--

commit 36d3480d935664ac35e1691894e4eefff76dfc0f
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: rename sense field of struct scsi_failure
   =20
Rename the sense field of struct scsi_failure to sense_key. This makes
it clear that this field stores the sense key, and also unifies this
structure field names with the names used in struct scsi_sense_hdr.

> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 8694eeadd753e..e321471e8ca22 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
[ ... ]
> @@ -514,18 +514,18 @@ extern void scsi_sanitize_inquiry_string(unsigned c=
har *s, int len);
>   */
>  #define SCMD_FAILURE_STAT_ANY	0xff
>  /*
> - * The following can be set to the scsi_failure sense, asc and ascq fiel=
ds to
> - * match on any sense, ASC, or ASCQ value.
> + * The following can be set to the scsi_failure sense key, asc and ascq =
fields
> + * to match any sense key, ASC, and ASCQ value.
>   */
> -#define SCMD_FAILURE_SENSE_ANY	0xff
> -#define SCMD_FAILURE_ASC_ANY	0xff
> -#define SCMD_FAILURE_ASCQ_ANY	0xff
> +#define SCMD_FAILURE_SENSE_KEY_ANY	0xff
> +#define SCMD_FAILURE_ASC_ANY		0xff
> +#define SCMD_FAILURE_ASCQ_ANY		0xff
>  /* Always retry a matching failure. */
>  #define SCMD_FAILURE_NO_LIMIT	-1
> =20
>  struct scsi_failure {
>  	int result;
> -	u8 sense;
> +	u8 sense_key;
>  	u8 asc;
>  	u8 ascq;
>  	/*

While reviewing the usage of struct scsi_failure, I noticed a related
regression in another file:

drivers/ufs/core/ufshcd.c:ufshcd_execute_start_stop() {
	struct scsi_failure failure_defs[] =3D {
		{
			.allowed =3D 2,
			.result =3D SCMD_FAILURE_RESULT_ANY,
		},
	};
...

[Severity: High]
This is a pre-existing issue, but does this array lack the {} terminator
required by the iteration logic in scsi_check_passthrough()?

A stack out-of-bounds read can occur because the loop expects the array of
scsi_failure elements to be terminated by an empty {} element (where
result =3D=3D 0).

If the stack memory adjacent to the array contains a non-zero value where
result would be, the loop evaluates garbage data.

Could this cause spurious command retries (returning -EAGAIN) or
unpredictable error handling behavior?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D4
