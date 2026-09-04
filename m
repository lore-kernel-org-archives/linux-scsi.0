Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF82391505;
	Fri,  4 Sep 2026 02:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788488851; cv=none; b=E/xsVOTjv9nt3UjGkvg43MsgvQEnllp+KaA/ru1InI1uiBeKZApgmSFLHdTL0B3S2oJIobO7kDf/OefW5hnJbgvOFdkAc2lx4CxLGrQa5vygPYKcexqY0ZnvVWXBAVku56nSFJQ70YkYHjryHJeCxUXEq747ORDRQm+u8uo4CBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788488851; c=relaxed/simple;
	bh=aLneTk2KvQf+dOAUtG7MaAhnBJekqBC4Iy5WRpNZf2k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pXezOFgfR/jRun/OvjFLgwJvGbGp/JYuAhDhOuHdWsf0y9COEbBGGOkq1I5d5fDTINajNo8OAEk8JTs1e4rYpbZYKpQA+ajisUNO7KIQxobUpyFaRfnxZeEBl0vCf8g0SEKvqYcp3Jy0/5v5YNwF/LycISykcwbjKKR5MNpo4PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o0x4VX7h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o0x4VX7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2091F000E9;
	Fri,  4 Sep 2026 02:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788488850;
	bh=aLneTk2KvQf+dOAUtG7MaAhnBJekqBC4Iy5WRpNZf2k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=o0x4VX7hNVd21XSzQdBJp3k7zUQH0ipYdL7Lk4n8xM53VzU7LfLL5TZQ2XFkBZVI4
	 2PXzLzPE45qm+FREwJ1Efh6xGpm/1DMgFl1TnhxIjxdnUm8LZ91VdvdzGO2+BpaNIJ
	 TynBYFJonsmYrHS3KDdsuEjvo48RLZbYBOsW8dOCpr4qaHtL/yhhPx6hA5YHfAqYUN
	 Vm+ZOS4TmVyuLJ0DTuoSfFRe1z2jfwHiBgfyPyhmeDakEnh0l5NQC+Vp0cwz5zOWrL
	 GTd/MD5ir1sTAXwd5liouEvKmopZGf1rM0cweAXsQgXOGtGvjGmtopLBgU4FqJagR4
	 yDPd7MGH7oxcw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 32/40] scsi: hpsa: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260904002644.157668-33-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-33-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:27:29 +0000
Message-Id: <20260904022729.BA2091F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D32

