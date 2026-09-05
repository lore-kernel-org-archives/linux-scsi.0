Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D913446C7;
	Sat,  5 Sep 2026 03:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579602; cv=none; b=Y3frBmNZm7EQRAyKj+qZTEcyg//aJq3z1NJVQWOSWTpUcZd/jzJBDPw5pIzGmjoOiUYGkNrP0ZKRDofHoi2y4kHM727hVX5lBugL3i2DjeWA8ZFZYgU2tJpU9oCjJaA19TIemUd8pg0u+5CMuZDJoll0D55dw4fEydByFbRkWDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579602; c=relaxed/simple;
	bh=SEXgU/0sGxAzBrmQNRqQw2Vvl23OZ3gTkH1FYH/Dl2Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XWYXD8cuglxRguOfo9rjF8BDtkN5NwYTuSX+Q9ZRwloYVMWuKsvjzZj3mFLgp9zPVM+ZS+Cm5Lob4CA/b0JlWLhb2O/wd17gifSF1k39ocEJb7PilpkMSn3kbD0uvUohaKfaqpdeAOidtxDeL96e1sTkXPpluEJ15VhLQZDKTDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AU3K7CxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AU3K7CxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5471F00A3D;
	Sat,  5 Sep 2026 03:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579600;
	bh=SEXgU/0sGxAzBrmQNRqQw2Vvl23OZ3gTkH1FYH/Dl2Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AU3K7CxYj76X6oQgeqh0aJCkYlbKOBOEIvv12TdwO1On9wii4s2M2DXWHZ6QeHDir
	 KrRqUuKcsWA1NXpXWCGcheSm2jfXpw8SHejWBH66CHkjfqlSOp2vfhVgnUFLMCOdpZ
	 zZFxuWibkvwXK3A52XDtqmyRq3btQL+/ys+hU8LLf1HmictvLR/WLVAdPOMWyV7Y9C
	 XVMU1WiZ/DZEgf8lcxK/Xz1bvpqRiJbADOLr4xmEqia5VCVjPmjNVN4yPQQeeXNwXm
	 aD01boPCiWOPd6HODsJM6oaEoZtqfwcMKZhKiCgYvyJHsg7rKiA1oWWFIbqCFoIeAm
	 oyxrCDFYQqP8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 32/40] scsi: hpsa: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, cassel@kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260905032224.509860-33-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-33-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:39:59 +0000
Message-Id: <20260905033959.EB5471F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D32

