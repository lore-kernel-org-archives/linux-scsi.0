Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A3C379EF0;
	Mon,  7 Sep 2026 03:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750197; cv=none; b=HSBYv91p0y+Gyj8GXeUBXntKdJS2K151Wh0tU78yGeul2vrj6fnR2D4/KgHqBk0NwGp5aaCF8OIkfq1BDF3uYwHbFwiEuIG0ymMDCz5YeTK4uxhUeDIIwx2k1+UFgsuXtQ8+9Y5MO2FRAdU9QVIjSHBmYLnsw62WPVm0RV4M+Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750197; c=relaxed/simple;
	bh=YROVO4xMEt4FTl+tABkyTdogFhZ5gQPc2UovWCvB56g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cXUBEHcTeAJkGpwxiKWN84jznjqDJlSvG3rMkVV6Y5irG5g5ewyCOwjQhkyjXKPpyLiLAspr93AgxIVPdqhPfkIE5MtV8OmkyP7TQtHQSPRp1IURAAqbFnTNhnGismqFt60UmLbPFbikCYlV+DYU9q/aM4cUulLR1eYMCy4kf7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLGLYffS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLGLYffS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA53F1F00A3A;
	Mon,  7 Sep 2026 03:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750196;
	bh=YROVO4xMEt4FTl+tABkyTdogFhZ5gQPc2UovWCvB56g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lLGLYffSXW3dPZgUpYv+KiBBnKr8wheo/4XXGBDvkE35H07NTidE6QblGbmdWLdT7
	 nXwAFerrew5P09TUXn7iV7XWiiJHc3vFePN4ICOX3deobDN9epQXFW6GpRpubJFGzm
	 KuTbuy+FkTu+yEb23cCbpwkrpje9zv8lPB7bo4KgCqCvGHJVCpkNow9Ser+z5UKW5Q
	 Z98jAAhnj5CjNDUFu+44g/DdWomXOVQ8JKp8Da5oeHSiXYSKna48oJX34advMsDSXv
	 rOzfEkEr6egiyk73WnDgiK5x/5wlrG1Fr36SqbBUFY8w+Dqwo32O52KQnkNIPGDrg0
	 4kJNVxKSXnPow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 32/40] scsi: hpsa: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260907024343.1046387-33-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-33-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:03:15 +0000
Message-Id: <20260907030315.EA53F1F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D32

