Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D174FC8EE;
	Tue,  8 Sep 2026 09:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860353; cv=none; b=EbJEVizskp8r80biMGtF/8NwwjF7+tVGC8bZlzKfaAvPmFEm5Vc/BV3cKSPNoge6JfHXHwuaHLhML/Tx8BYsC/IV0X9g0cPGyeyIH8KAX6VV8M5g6fK+oBZSz/Jty1l4lL2RW5tESZZXY5G3ezvXkt/gFvO3ijRGGc65n61h08g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860353; c=relaxed/simple;
	bh=S8clsrPc+ER9FfmU+FjsP9a66CoXHe0bkW4QfBeQmWA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eJDv9OzVsKdov/4X5QateNpaIJi1tq6N49bp8jD857OtFh8GOVOyBMN00vgf9Nu6fdJ8nx/JGIkhj30YxsT500AE14MkKGA973dczfKAFqyg4VN5yB63MDIkbWQY8XKcFF+C+p8BtJkR3M+3wvH8PG/YA6j+lgXdXy+crjumacU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osoeWKT/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osoeWKT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AB51F00A3E;
	Tue,  8 Sep 2026 09:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788860351;
	bh=S8clsrPc+ER9FfmU+FjsP9a66CoXHe0bkW4QfBeQmWA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=osoeWKT/Tu2jEZI81u8plqgv1ALsPj9HATWzqB3IY88EGUz3AuAyh6aWBLrqc/0G2
	 G1u2chbeoaqv6qfe/V5Y7NHvE7SIrqZr0ZMcK6J1wF+UhcyH6po+vXUGgsGGa1K28y
	 XvNx/+B2RaS/o5bkhiIfbu56SG4lFXuD6upW1cshoIP9uwobFvH9RA75DsPssmkpkm
	 UDz/X6O0l9zhkl18GcF9zcWlM3Ta+sq2TvPG0S4Q8cfFKlFJ+uuuA7XRunvu3ze0GD
	 Ck+If+gfxqctnqB/8MI5/ukl+bCL+334EPEkyTt46Qadjxn4/O4IQoGzStR8uEcPWB
	 54TVoa6qCUCeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 01/40] scsi: define all additional sense codes and
 their qualifiers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-2-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:39:10 +0000
Message-Id: <20260908093911.54AB51F00A3E@smtp.kernel.org>
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
> possible code qualifiers are defined as 16-bits values without any name
> prefix. The 16-bits value for ASCs with a zero ASCQ are defined together
> with the ASC 8-code using the ASC() macro. For names that may potentially
> create conflicts with other subsystems (e.g. WARNING or WRITE_ERROR), the
> SSC_ prefix is added to the sense code name.
>=20
> The sense key macro definitions in include/scsi/scsi_proto.h are also
> moved into this new file and scsi_sense.h is included in scsi_proto.h.
> The helper function scsi_sense_code() is defined to facilitate generating
> a 16-bits sense code from 8-bits ASC and ASCQ. The accessors
> scsi_sense_code_asc() and scsi_sense_code_ascq() are defined for the
> reverse operations, that is, to respectively extract an ASC and an ASCQ
> from a 16-bits sense code.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D1

