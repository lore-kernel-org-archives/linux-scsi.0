Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D1B2D0C89;
	Mon,  7 Sep 2026 02:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749902; cv=none; b=XWBgpnexStwxAKB1sVFvBLoyrVX5Y9JGoT5FD0utIq7p1GMMCRCc5g4sKkOGkv20iRsniakEax458n/+3ap6plB6CwEy31e0He6/DY5xTHXco13/PZrs+y02KHlKpZzj7LtD4e4fnUcPpnNCPl9WcjcCfdzAfAj+rdRtuYiKcpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749902; c=relaxed/simple;
	bh=RnvHyF6/n1+2K52Vea1H9Sv7nmR0oaV9ImOm7CzJScQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lNseGc5gTn5PYJi2rkNwoX3y7SIfv4sNh6lb1IMUD2UXpMLhAtAaBGMdWqDfCOEaC1ZmBxHsYTpAcfEZAiVXiwHBjfdM6EY20TQdsZ9VjEwXEvyTbmoU7wZctfzrJFZtPPvk4yNBDT7m4Tm6s22n2wZBJV6ccFxppU326fqYEXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6Wkjnf5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6Wkjnf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201E21F00A3A;
	Mon,  7 Sep 2026 02:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749900;
	bh=RnvHyF6/n1+2K52Vea1H9Sv7nmR0oaV9ImOm7CzJScQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J6Wkjnf5tFP6jxxH3r3Zdufg1AO6h0B7iblbf5PqnUiDbYPWNAfztY5iJaQXMj26C
	 cwGCrdJhPnOU2n/8Mjo2grcUEGNPOwoiPJHUfgn5Fz2zqnX2CvzIRHlwHWlkyTddWj
	 ZBGpAionnPkZXcpzXb53fv7elyVBBR5bneIwI3j8MOGVLs212aZ9jh+q/XXyn/Nn17
	 0f21dJqO0b7lR6AHD27X3mAJISMuO0yv8CFtldzC71vt/FTiUv0+Ak6amN4RJGOppQ
	 77xfXPOd8kKtINFtKzOLBKFSX01vn0UQ/1ZceIHixlzudsbOhYjJopbIZ0WnSghBYn
	 AceNhGR7gdP3g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 24/40] scsi: qla2xxx: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-scsi@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-25-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-25-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:58:19 +0000
Message-Id: <20260907025820.201E21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the qla2xxx driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
>=20
> While at it, the declaration function qlt_send_resp_ctio(), which is
> modified to take a single 16-bits sense code argument, is changed to a
> static function declaration since that function is used only in the file
> where it is defined.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D24

