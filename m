Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CBA28D831;
	Thu,  3 Sep 2026 03:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407824; cv=none; b=l8s49Js1Qu3mxgdrqeUro90MxRedItCu7spLYyWReIQ2Jx564mIlz4koWvBHN+VBWPgog5JpwmJK6kouQqczpOfNJnuVFKhVLOVaMK8YWI0MB3C6FKBqZ8ZnoEqF2kCd25IzZSdmJFVQzH7XzRpu4yfxsmzul+fAPlODHa9gkws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407824; c=relaxed/simple;
	bh=iVX007pEwDU4LuV55yrM4T2wjprgLFqz4DwDw5QvzuM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l15qlA9G5zX/3/gRsQAU2+ywx86ERZYOm/zRyS4wmDQmQ5uX0gbwGwn0Vmtgb3Xpt/0dESFbtbKXovSjMSqLAoaKOLW+8KjpHz6CefFclaaCSPpIFbWvfUoBEfqly+h+drOx4QsubbafSis/KOZhZwsU0890SGuFD88kU47Hdiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbLMtoM+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbLMtoM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F291F000E9;
	Thu,  3 Sep 2026 03:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407823;
	bh=iVX007pEwDU4LuV55yrM4T2wjprgLFqz4DwDw5QvzuM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WbLMtoM+jHC9rNKQ6wSSI65pPPWpnSFs5dQJc0poPxJn0bGzZthfdoeUmmmmbf1QJ
	 gCSHrQD2R6wAd69TPtnoHCr393B6V8d4KZHQtfKMWl51vPthOc4Uo/sNlNHzEjkdew
	 eEAhjaZKCsxi9+4to5UimiaqFPFLjgzWWDFZ6/dfNvRhQtE1vakZDYu5p4OgdYBBdY
	 RRBOTgaRDU21Smj3ZWgB+U4qNQ78GjYdqxXzU8yC3/X55uHiJpxP59nwTcBv+PuU/2
	 z9amQJTTIIeOywzOIylyu6XeiZ87KUZb9E08Zns0NsG2on87GpjS8jX4OlcCHnsgGB
	 QTwta678985aw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 32/40] scsi: hpsa: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260903034201.112211-33-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-33-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:57:02 +0000
Message-Id: <20260903035702.A2F291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the hpsa driver to replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> The function decode_sense_data() is also modified to take a pointer to a
> 16-bits sense_code variable in place of the two pointers to the additional
> sense code and its code qualifier. The local definitions of ASCs and ASCQs
> are deleted too.
>=20
> No functional change intended, but the function hpsa_volume_offline() was
> checking only the addditional sense code qualifier with checking the
> additional sense code. This change assumes that the intended additional
> sense code to check is ASC_LU_NOT_READY.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D32

