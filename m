Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600012FE074;
	Tue, 28 Jul 2026 05:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785216044; cv=none; b=LX9cdeEfJ8Kj6K0e09MZGySjjfA7Z/FMAIZ6WdSJFBb0ZXidK12Wfu7rtuAcVu1nbXe7jccANJGiLv2hd8R52W4jG68rA/kEGIjtg9KRht//SC/WQLWXhNDFV5xb0rShLQIkBmZWbHyDSgXT0ZhokL1UcFlO7dSIAKcyf8mrHK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785216044; c=relaxed/simple;
	bh=m48MU82HNol7F13W3H8rGI9XBCWpaR2Ue4qgF2zgtK8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FdIaJFPWywUbC15w4QHRjDRNM7RUQR0k8vit9YFFTtdmyyMJ9ubfqEOmzseTpDdrBAG9MccehFxbQlEb8lSjiF0Pexgyw9Xhh2yGjh6zbE3cjru6RTylU6q7y7wgvDpKPIngB1Dt/MEzb0hF09uu0f34Ys0fCDyUs6cYfN+cS60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KP5BfZbD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KP5BfZbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A378D1F00A3E;
	Tue, 28 Jul 2026 05:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216043;
	bh=m48MU82HNol7F13W3H8rGI9XBCWpaR2Ue4qgF2zgtK8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KP5BfZbDFmSuS1M2qnv6+WsfOko5XDHzyFJ9Jj6PCK784ANKPby3+S5Cj8uSyLqrQ
	 ifM81aQW2XtBiAjjOsfyYX0/TEOCWPNXHhybS1vGOLDxkws8ISL//9/7jjZ/z3U2Zr
	 99mZM/Q4oX+CRHBVKGCFVdnNAVZP/1DmTQpsCpV2Di0PhfEFLvmVJ+7ufEuYsv15j6
	 sSwUVpwWonrAWYw5XMMxChtXRQEBdRJnAepu8C5PHAk6mEievEWQg8/8saMpIYlSVT
	 hAm4BLqg0yryO3dvR8b0nu6A3eAxjNbPNKd56DJzswg2jzTgcfW5gyMr/98mNWCToG
	 Af4FUm0aOZ/xw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] zfcp: Trace plogi and prli within open port
 response as payload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260728044857.2532646-3-niharp@linux.ibm.com>
References: <20260728044857.2532646-1-niharp@linux.ibm.com>
 <20260728044857.2532646-3-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 05:20:42 +0000
Message-Id: <20260728052042.A378D1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> From: Steffen Maier <maier@linux.ibm.com>
>=20
> The FCP channel optionally returns the content of PLOGI and PRLI within
> open port response. This information is needed to debug unexpected open
> port responses. Pack both PLOGI and PRLI information back-to-back into a
> PAYload trace record of type "fsf_els" within existing HBA trace record.
>=20
> The length of both parts, and thus also the offset of the second part,
> are added to the corresponding HBA trace record. Be extra careful
> regarding bounds checking.
>=20
> Since auto port scan in multi-initiator zoning environments can cause a
> lot of failed open port responses and trace is enabled by default in the
> HBA trace area, chose a trace level 4 above the default of 3 for the
> corresponding PAYload trace record to contain PLOGI/PRLI data. This way,
> [ ... ]
> Reviewed-by: M Nikhil <nikh1092@linux.ibm.com>
> Reviewed-by: Nihar Panda <niharp@linux.ibm.com>
> Signed-off-by: Steffen Maier <maier@linux.ibm.com>
> Co-developed-by: Chinmaya Kajagar <chinmayk@linux.ibm.com>
> Signed-off-by: Chinmaya Kajagar <chinmayk@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728044857.2532=
646-1-niharp@linux.ibm.com?part=3D2

