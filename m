Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D1036D9EB;
	Fri,  4 Sep 2026 01:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485961; cv=none; b=D6Bt/6OhBJQ3YXUQ0arz8fNYQBkocEZsGS9rZ4guJ6xuxKHLXLEH9+KAcqwcLHu5hYTuDkADXqjVxTX20n4Jd5kAt7c0ZkuNOydQDpnI7VyMC98zfASTPnsXdd6sn4rzRbvk2VCvWlRlg3396Eyq1hs5V/iwTzGdLsUX5t6kCw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485961; c=relaxed/simple;
	bh=Qt+HycAHGmNy1+RVPzF1t/B2Nql+4PvprzH5eHrLq+o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ac+0g+hCUCa+dIXywg8tw2lmsLQeNwlW8hp7caaWvrSaB8k0JM6BMTr6Pis7RJ/wUZBOVLNngOBqJtxmn6Bh6iepL/shj2IMoHnuOtgyk8Vt+Q1ihKvuQ7BGJS20JygNN8d/d6faH38f9OoSuvh+9n7ZgtzeJp7TtMXtSrS4+Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G/L4JoOK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/L4JoOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671C01F000E9;
	Fri,  4 Sep 2026 01:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485959;
	bh=Qt+HycAHGmNy1+RVPzF1t/B2Nql+4PvprzH5eHrLq+o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G/L4JoOKRv2waYl93rm8+lcIyQtNacI9TWy2VaC70tgx+GadbHYE82us67mX7tIlu
	 oF3ztax9qCC+vOM/VD7fK73Z0Blq13RctWppKlouh89L9F7WpsPUn02X+z16KE9Csb
	 YJlonefol4qegAuuOcH5WuIZcC0VDvKOcjefPkB9O/W3oJmrOxUy8GQb7VpwIFvtSX
	 AMgqi2RdItAEkgXP1/e7pJW5cdMdEgN/lm1ZVfcfMuGFWPzOdQbMwwgth6P+9NBQAz
	 XQ157q7VSlnpWuofMaCXHsABjL7axCphRwi0KZUeyXp2k8T4avbph2veRH42UiYlwi
	 xAMIoTu62XM1w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 20/40] scsi: leapraid: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260904002644.157668-21-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:39:18 +0000
Message-Id: <20260904013919.671C01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the leapraid driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> With this change, the locally defined macros for ASC and ASCQ values are
> deleted.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D20

