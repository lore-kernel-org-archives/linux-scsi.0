Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E70E43A80B;
	Tue,  8 Sep 2026 09:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859493; cv=none; b=TtB6n8bdW0LbEVNxD/c3GJjXBCXeOxCJf2lbZSFZjh1axOObAURhVEIEOLedyVhWGOpDT7BQMBlDneaJF2VyEgT0iJCrXfht2j8zbxO64ZOz0tT8mWb9KUSbiE/UKI0QFUst6mtzJKiKui1ReHuFbMJpkfjD1T30xlWdBg3bMvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859493; c=relaxed/simple;
	bh=0v99s8LYboX38HhZ/GqBuS7nE4ElRQCxF/Il8h2nlKs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z/2ZnANgeZxH6lKUQKjaKWCNYEfnr1efrzPahRaHS0Y7CvXMSE6XdJNByVrkbYON1OQy6Qn91Xl/D7CxysA9CcxrRjepgNgbUK/mAdG060r8fR5l27grOlvD+0mhV/ArNpBBV/bw7slM5+xscFbJCufgwGHeGJ/LRSZ13kuVWyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jefmr+ep; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jefmr+ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86471F00A3D;
	Tue,  8 Sep 2026 09:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859492;
	bh=0v99s8LYboX38HhZ/GqBuS7nE4ElRQCxF/Il8h2nlKs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jefmr+ep7lQ63eTm5CD1aaER4x7zg36fgDQHjxAFT8+Z9s7FtuBRU8GmsZTuYyodD
	 daz6NKG5p3IcnqXK2WIgEc63jO1e5gZZLIkzJGlhliIXUabvt41YWpFvSGqt176YQb
	 H6StbBHc83QhKzdwuyFdnvTeG6gtjzbkKoSdIGI3QF3j/ix8XHgvDOUCGpWHdn0LGL
	 q7xmA0yJqk6n33jwUH+JWCZvdq+ZuKURLymBFXQbVbYN+tXwHYfPZFEWeyKtLmfBgR
	 V6+CGpEgzlrJ26nRoq5j1lCcrllP4643yqb2QtvYSl1QMnGHRW9Ze208HYvzbHSjYH
	 vA9D0QzoXdF9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/40] scsi: core: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, cassel@kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260908090308.1085097-8-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:24:51 +0000
Message-Id: <20260908092451.C86471F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI core code to use the 16-bits sense_code field of
> struct scsi_sense_hdr and struct scsi_failure and replace all hard-coded
> additional sense codes and additional sense code qualifiers with the enum
> values defined in include/scsi/scsi_sense.h. This helps with code clarity
> as the sense codes being processed are easier to test and self-documented.
>=20
> No functional change intended, with the exception of a correction of the
> array any_sense_failure_defs in scsi_lib_test_any_sense() which
> erroenously sets result to SCMD_FAILURE_RESULT_ANY instead of
> SAM_STAT_CHECK_CONDITION and does not sets sense_key to
> SCMD_FAILURE_SENSE_KEY_ANY.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D7

