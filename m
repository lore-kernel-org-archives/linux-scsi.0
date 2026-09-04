Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF49023C503;
	Fri,  4 Sep 2026 00:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788483206; cv=none; b=md2FwdVtNMjPFvXURnP0jvyNCXLz3KNxKB6lNiHALn4pHMn2NN0jKJw1hiSvPl6q17xQqLjTz9T9663W7OJlMhHDzdEUEw5AnD8sW7z3808YzuTsI9tKheEFio0YbSawDp/XlpKQZGeEVXk21c5ZsoyoFpO0Z3uP/v5EhfTG9HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788483206; c=relaxed/simple;
	bh=89SrA+ufLk0ZgeYMcwRS/JjHjHpq+1SoJY+ag9pJ2kA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SXLbM70N3ZrloGtx9leohHPDSC7M+YXfPFYSCzrUfmSJfnNrMIFiXbpDKQxrYjOBg27fjhmQvDVy2izxk0xjZT0KeRPaiQwh/aoBNo0fjgzqpoeoLuS9k7UD7Wd+LuhWE/DM5QS0UHaBCdmu/5HzvVgATV5+HCKLpbi6YimGxiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DxXvLVu4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxXvLVu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5863E1F000E9;
	Fri,  4 Sep 2026 00:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788483204;
	bh=89SrA+ufLk0ZgeYMcwRS/JjHjHpq+1SoJY+ag9pJ2kA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DxXvLVu42yCeIvrZA4RjM69lU7lL5HxAF8AXi6+Em4R5X9UOUSSdJwctGQ9UTl8HK
	 qH3hfdJteZ0uhtnQapayIGSfnovaWJju4ngLwshr1XyAokzenUrbnUo9tWDUDA/21L
	 4ngQ50i+GvhKkZEHHdJJBkbyRAAHl+kNuDExh480zwXlWTZxI2YBFhR+NN2NzDmJPj
	 7K8xgUxF3K/UTYu4Skb7DMjl1bHBgBFFFxSo/u0gSqGhWOizKAM6rr51ZYFmnZDv+O
	 6Qguf2Cdov8F3HWkZthBdzbDeX0nzAEzVE5sbFAj0P2YUKfXEcqauhJ+onA9Bxlffp
	 c9BgfdyE4YHvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/40] scsi: core: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260904002644.157668-8-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 00:53:23 +0000
Message-Id: <20260904005324.5863E1F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D7

