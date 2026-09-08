Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AEA4E8E07;
	Tue,  8 Sep 2026 09:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859118; cv=none; b=ZMwrcVEMca+SffQ/pVs/nCUqLcbktet1pvuVy4JNM/N24BMh6SHI1kYM6xpwddiH4+LJxL2EMF63xhcl4bU4degjqJOjpg2w4rYGS6a/Ew9VqyvvYX5SwCxyvRW+11VjeCjOulEqibrpIrB1dXz3RmbZuue9hOmVrEGN9vF/uyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859118; c=relaxed/simple;
	bh=G22KocaG9/yoA2iWQsV9CFOoZ9ErV4bzNjepLJN+AxA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qe0Rfr81hxIUaOcufML0N3UUwV0e9fsXLJowSuTuqE0XHyr4r8RLvcY2nZ0AYKIWFCowpsjcnXzxgr9vxEc1b9nVZxx5rvK5FOkAHPlz6LAL0zTHvNRSAKWTEOb8j3wdPToWkmxkLrg9dHAb8zoNBJoUqBTPYTitVx/pjUcKCoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czKkDwBi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czKkDwBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA271F00A3A;
	Tue,  8 Sep 2026 09:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859117;
	bh=oiQ0HJII6M8cueu7O94ijegmFV9E7VNDSvtMpw3a5ko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=czKkDwBiLPFGi7rS0KHwfXmiswyKFADWovKLX+t/Soq3Zt8Aj/Hhd5PpzYJRr++Ja
	 /0IdtO60Z1vNSYFKJJBj5vnvUBUkBbST916wToSgiBP19fICLumKpiB+W24532IH+O
	 Iv+Iif5FRbS+pOmM+yqDDWZRmjLZUWOFhKcWD5JrOlj9UWyJVuBGaK9/e1W/2rXphC
	 9n4fsckN8shOWYOKES0+E2H0Q8TiCW3YKDOsp9xgCFdeSoBzfqXYb5D5pcmMVuCmfA
	 jrv/MMal6Xbz1z08J7OLbiBFG3AtAJJoZkeiXfzy21dm/zFLms5oG+yGvLHppytLZt
	 q6/1tzDUHNa+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/40] scsi: prepare for using 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-6-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:18:36 +0000
Message-Id: <20260908091837.1CA271F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> In preparation for handling sense codes and their qualifiers as a single
> 16-bits sense code field, with the values  defined as macros in
> include/scsi/scsi_sense.h, modify the definition of the structures
> scsi_failure and scsi_sense_hdr to introduce a 16-bits sense_code field
> as a union with the existing 8-bits asc and ascq fields.
>=20
> This temporary modification allows accessing either the asc and ascq
> fields individually, or their combination as the 16-bits sense_code field.
>=20
> The helper functions scsi_sense_asc(), scsi_sense_ascq() are defined to
> allow accessing the 8-bits ASC and ASCQ values from the sense_code filed
> of struct scsi_sense_hdr. The helper functions scsi_failure_asc() and
> scsi_failure_ascq() provide the same for the sense code field of struct
> scsi_failure.
>=20
> The helper functions scsi_set_sense_buffer() and scsi_set_sense() are also
> added to wrap calls to scsi_build_sense_buffer() and scsi_build_sense()
> using a 16-bits sense code aregument instead of the 8-bits ASC and ASCQ
> arguments.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D5

