Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52358149C7B;
	Mon,  7 Sep 2026 02:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749664; cv=none; b=Qo4Zmjj+LLVyCiEDRTJ0oR1lKo1KID2bu7A0hMMlqJSHWF63qFq0AuMvgBkeCEBLmDsxXLu8QvvMYznYjUigedEKQMt7ng/MtKS4tI8f/OU6Q54CyfTaEUKUSDM/mN+DdjGX7bLTE/rtNzC2dOPvv9SAOX5sbiZCe7Py2DE/L+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749664; c=relaxed/simple;
	bh=6k6FeckI/ansldN0EsZBUMlIMZnkNWEqHpKQRfnGgUY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=es7D4vTGLA2VFtfOIxFrMaeB7leLd6JXi64ip/yiROgGKANE4b8aEvQ7GQg3VHVjjl6adrmhZ/4WKbhqvvs6nGz3b6Hr8UIO0lUJSEYnOxCr+vWiA2obKIG/qHQL09fL6DT3DutIxIpSiekCO7QUgojQQ3oTacW30Rdz7k4fZUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWReDjjx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWReDjjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E281F00A3A;
	Mon,  7 Sep 2026 02:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749662;
	bh=6k6FeckI/ansldN0EsZBUMlIMZnkNWEqHpKQRfnGgUY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OWReDjjxhH+Aih/1KYfEul6tr6kgV9zC/QPw2J7M+hu+mCNAeEa6pESVfjot3AqT/
	 uWe/ibK3to68F9mPyxueCpl6vSPDhebnJMyEjaqX3h1LbBFDMWUIurv2JX3JoOoMay
	 lgU/p1E1RnXn0vKdPDqBOWmVky2GnthOq3HrWSmt+KoAm7WxZQQDpE5ZSpGTJZ2Hwn
	 r+z3zAr8LIcgMQEQARY+yy5lCgY2obWHamKig4OCXCHhi9/keyQD5IhUqEhKFyboFT
	 nCXUdweT/GalJrmuJTcO+2Syzje8o/l0kB8DyPtLKbc8wUU07XeJAXqhIvM1OS6on/
	 8zeqSn/mDLHVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/40] scsi: core: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260907024343.1046387-8-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:54:21 +0000
Message-Id: <20260907025422.52E281F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D7

