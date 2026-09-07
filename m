Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3398F1DDA18;
	Mon,  7 Sep 2026 03:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750879; cv=none; b=KscmDNDwizx6a9opN/pfBe3W8pkRZO3lK4snvIfqxT/ojjgOVHMm9AMFPcR0s/mK76u9m2iu2jhkdPUH636ff9c+ZqQBq5c6wYla49a6fxWc0KeNKSQnWtHCzqoF/ZMyAsSLx7Y1JmlCjASb8+CS92FagTNV6kj3wVqRcyI4X4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750879; c=relaxed/simple;
	bh=xTgWqwoar8iJJNLsib9gzuJp062gvkqKRkZBZ44WpBc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oxzFd6hZLkcY9djGiC8RZdtuOMs3uUQEr3/8wu812gTG2MpmYZF5PsHAwsWBQ9tumGURsrvbQfgwoImCEwhbHmXQl1czP7KWO14A9FPKHCMtsB64UTete9AJw5oz56Qo+IyTT6Rrvj9XjNgtKl5JvUfP9bQ8wsvMnRb/Ulk6JJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKEMmIxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKEMmIxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FC41F00A3A;
	Mon,  7 Sep 2026 03:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750878;
	bh=e8HGIAJK85+r0upFMbQQ4i+Xh/5x1F1p59G3AJOdrdA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iKEMmIxlZLbEkGb2+hAI+MfkUg5FjgRTKWRcu7JpgX+1al/yKZ5RnnZGsyHXdBxtu
	 PJvERSsMQilyTsmAlsi66jsf9I1hAO/WCoWog+ZypoQ6fG3RpA542+etEkK6zV0Whz
	 pBjkWIc3SzNAXvTigdEY+NOlZlZmtwSXiRGbwY5H5hlrvhbX88hhfptDYdh+wxitmx
	 ezOpwpbeaSIe0HNjbM1egJvQ5C5SN7eFjpN6hUiguFLsu7g1Szt49ahG2zrGDkU9DF
	 U5b1jEaDDMiJVDHE8Yz1fdvWL9ve/FTjevWS8EDFqh3B9/D8gJfn2aETweT6V9r98x
	 2u1wEXLABPYCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/40] scsi: define all additional sense codes and
 their qualifiers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260907024343.1046387-2-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:14:37 +0000
Message-Id: <20260907031437.87FC41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The newly introduced `scsi_sense_code` enum injects hundreds of gen=
eric, un-prefixed identifiers into the global namespace.
--

commit 483fa6eeda05c51714847f3283212cc3d768cf57
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: define all additional sense codes and their qualifiers

Introduce include/scsi/scsi_sense.h to define all existing additional
sense codes and their combinations with additional sense code qualifiers.
The sense key macro definitions in include/scsi/scsi_proto.h are also
moved into this new file, and scsi_sense.h is included in scsi_proto.h.

> diff --git a/include/scsi/scsi_sense.h b/include/scsi/scsi_sense.h
> new file mode 100644
> index 0000000000000..e668ac1c2302c
> --- /dev/null
> +++ b/include/scsi/scsi_sense.h
[ ... ]
> +enum scsi_sense_code {
> +	ASC(NO_ADDITIONAL_SENSE_INFORMATION,			0x00),
> +	FILEMARK_DETECTED					=3D 0x0001,
[ ... ]
> +	ASC(WARNING,						0x0B),

[Severity: Low]
Does defining scsi_sense_code this way inject generic, un-prefixed
identifiers like WARNING and WRITE_ERROR into the global namespace?

Could this cause symbol collisions since scsi_sense.h is widely included
through scsi_proto.h?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D1
