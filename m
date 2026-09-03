Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF5D25B08E;
	Thu,  3 Sep 2026 03:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407761; cv=none; b=OuoqFD/Nz8r1QzcWstY5YcpLtFwvTUh/oaSeljxONz3BmYlkYPUbfNjodc5vD1ASEY1bIxjJh1WQUr+fjUh1Af9VDPlk+xHvd5SmFHe3ZBSD7tua2pzYvumlNGX/EECNdhJ8gP1REOkiPQI48kB8JfLW87/T5iUNOwrGU7M8bVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407761; c=relaxed/simple;
	bh=5yvKKse5LrNyZPVFOelQBttYa4GtV05PVVGNzw9vsGE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tB6Ay2WTzEpwq+WX9Hg6Tm179XREia7MY/Vzgej3jm+GHEDSOc7pIepaX+h9QRPOSqidYDD0sh35f5lDvx6eMBxm24WH5DTZo+4FuU2lDxS5kOGcS9tTZW5U7KXT9HXfZLNYWY+hmmmm9ZqYqs7mxwQiX0hvFlhOIxTY/zpwKrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LzX5O18z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzX5O18z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EB11F000E9;
	Thu,  3 Sep 2026 03:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407760;
	bh=5yvKKse5LrNyZPVFOelQBttYa4GtV05PVVGNzw9vsGE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LzX5O18zg3rYA9TMmrUdfxKBrdubkTJAwB72L4QTpWAO35tSeoUk+Zus04NdhW2OC
	 xh2K9bEz18VF18oDp16x863DnSu2fEWDbiJai2MketZK84wcr2xe3ORznnrazTRCJh
	 uDBA7U+/fmTrZJadvj3S8AisTi/Zf0NMLfa63z6EHYTfyNayXF16MvC0A4VabD2kC2
	 Hvo4SWuAGAfKqQqRSKlB1Hp6XdodKjEkULPAbfNqRP8maIzWcXpJhUpbVBxJMUdIPl
	 UWyxTYz24BH0IJ50Sqh+J88P4KMZ3Yr2CvJoQGoH0wnlG25dCeptraDdIeWD6E0kcL
	 +R8I2nkeNsdyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/40] scsi: define all additional sense codes and
 their qualifiers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260903034201.112211-2-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:55:59 +0000
Message-Id: <20260903035559.D3EB11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Introduce the file include/scsi/scsi_sense.h to define all existing
> additional sense codes and their combinations with additional sense code
> qualifiers, according to the most current T10 list available at
> https://www.t10.org/lists/asc-num.txt.
>=20
> Additional sense codes (ASCs) are individually defined as an 8-bit value
> with the ASC_ name prefix. The combination of all ASCs with T10 defined
> possible non-zero code qualifiers are defined as 16-bits values. The
> 16-bits value for ASCs with a zero ASCQ are defined together with the ASC
> 8-code using the ASC() macro.
>=20
> The sense key macro definitions in include/scsi/scsi_proto.h are also
> moved into this new file and scsi_sense.h is included in scsi_proto.h. The
> helper function scsi_sense_code() is defined to facilitate generating a
> 16-bits sense code from 8-bits ASC and ASCQ. The accessors
> scsi_sense_code_asc() and scsi_sense_code_ascq() are defined for the
> reverse operation, that is, to respectively extract an ASC and an ASCQ
> from a 16-bits sense code.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D1

