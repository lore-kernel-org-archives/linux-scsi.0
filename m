Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1CB25B0B3;
	Fri, 24 Jul 2026 06:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873468; cv=none; b=sbJrmMkdfU1BAsFuLoR/ehoddXG0pM/a1FZffs2SRmcN/+NoK2N7R7Vki8K6E0CUoSxk8dPi+KYa4kVGd0Qx0xh1/DPLNBAcla8tXtUsurkN2eemrFh7TI1VvbeFH/tXui8uZ446s3pbHp8KrbNl3OcOVxft86O9jU3vyZr4aR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873468; c=relaxed/simple;
	bh=OL6Tab8YsXsmGWLJ4jH1sUjnYfc6afC6OKSSnzXi0a0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=c2RYrLO/+IOI6w0rIkDiRb6v76xOcQekjmgohlvFT+U3mZ0XR75kxzoxbgGGED2WEkSyAQ2YU0N8rd5vYaOzpbJ/mdU/DK8sSJyB953113QtIKkyiYLYijQBrgIOW56h0nR+buLb6xS17IvgmO9AgU5jh2yUtAe5Tj214RsrYJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eayP+eVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eayP+eVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3661F000E9;
	Fri, 24 Jul 2026 06:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784873466;
	bh=OL6Tab8YsXsmGWLJ4jH1sUjnYfc6afC6OKSSnzXi0a0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eayP+eVCH9gRAoW8r3CWQ/pA77qYaNwIqrY8vTVVnKjTmoSzzrWQ5DaiCZNdf6naK
	 YCB1rMFbSOuiEV3mNJTkPpj4UTi5S6sjhpyhuYIuKSsRUNd0E+YMs8SX+9Fp7Hh0K7
	 yPxVw/l6RSddTF7hZfCehaIqkV0jwvZStSz9Hs3l/ZtXdWoHp8GXv9NREkM43vF1Bg
	 dL5ejGBUhnvCRdUlxWYHq/WKMWBiw4p/7xEzaSwlSSZQt2Nj/wYWGCoJJNnI/fiu/y
	 vOsLdSYnOw+vx1rJeAqDeY6hYqf0HjF/HlsZ0TYE6Qf0Pj9Wt8R9sZ2E9v9//qj9Qk
	 OkFb4Gaj2h8lg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] zfcp: Trace plogi and prli within open port
 response as payload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260724053934.2781087-3-niharp@linux.ibm.com>
References: <20260724053934.2781087-1-niharp@linux.ibm.com>
 <20260724053934.2781087-3-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 06:11:05 +0000
Message-Id: <20260724061106.4E3661F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724053934.2781=
087-1-niharp@linux.ibm.com?part=3D2

