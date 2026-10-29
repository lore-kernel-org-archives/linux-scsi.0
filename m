Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793237169;
	b=zx3I62RkdmTJfmbs+2esDSauXF63OT7fsJdwJjLi6+gBrWSNTDsCac7+y9eBsxMCUwlN
	 TfxYCbJlicZQfqaasxoLRW5n1I78AnVFBv9C7A/FivGPGy+Ln8L1ErjKXdQYiROcYax4w
	 wAf+bujvUMf46qZrb1YI8tjBwL1BgqYGBiHogSinmmN/r96oIade6FKPigBIKHbQAhpl1
	 g9HZKdsopMN9G7JplqswpQ6dY7U1Oc9cEpFqVJcLYs8gQvXpeSPgHybMFj391MOkH7tkB
	 szr1Bn84HGpUeX15AYNBREQ3Azspql/ISgn4F1Qp5Eb4geVuwNaEJkhwKlLAvWoIOcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793237169;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=k+n4u/6PJCUbSaVlVUmpXdMwNLpcQ5eqORqq7gI4NKc=;
	b=d4vFuDCI0eM6z1Rv1P7JArDNAGNxyBM90+Paa7Mfha/CGoyYDRs4AuV7zgjStv4/+Aa/
	 sJKxls1PSy5cm/WGF8FQDK0/iPYzOHY8auZpJ8awulKcvwoN/4jKvh+IuKuJxksvz2wU9
	 h312dWhaxYu3AVcQPILDEPWQ4QhNBewLujvc2OkKqEZHqG4DKnFXOaHgqWTPOnC7Bfkm2
	 0pS3ozQJL83WIhnPBCdVl0fvanIMy/i0CyOd3ij75UEr4fSUmf6g9AsatQQ0gT63WC8za
	 JAgq4/q6siqoKyhaLktIZUxGQtAvTith08nC7KbOzUv9pfyLQxQTJpdKbkSg9TFr+LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TFCygdrc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EA6606A31A;
	Thu, 29 Oct 2026 01:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TFCygdrc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47F91F01825;
	Thu, 29 Oct 2026 01:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793237169;
	bh=k+n4u/6PJCUbSaVlVUmpXdMwNLpcQ5eqORqq7gI4NKc=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=TFCygdrcHimu+LvC78Q5LVJO6VK1l5+nabv5hlV0QKd8pZ5O5uf8Q+S+ReVHRLzW0
	 M1gU1aQ7MM5xZj+5DN2+iqKCeuua30Xr/Ib6435R3xgVOKa99v06IX6FNZf5dqcIpj
	 bLsfr0VhMThUHtUf+v9vyPte4cf3VvL4Cfp0Vnpt7xle/uO6+tBYw+XtJRQkUSfnWx
	 8/ZtKvtnXYbJCwebc9i9bovbWk1LqjUm/ncrI2UAByUH8Ap/+QgNdsziXlk7c8+l+a
	 vYxF+G2Y+0aZS1bB6gBySNvYWE9gG7e7mn2Me3tzVTJ8Rcnny3R3ka01RIK5itcCfy
	 dN8rRhHMAKQMA==
To: Giuseppe Piscitelli <ooonea@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <mkp@kernel.org>,  Bart Van Assche <bvanassche@acm.org>,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: Balance the pseudo target reap reference
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261027100859.1031135-1-ooonea@gmail.com>
Message-ID: <yq1wlr147rt.fsf@mail.kernel.org>
References: <20261027100859.1031135-1-ooonea@gmail.com>
Date: Wed, 28 Oct 2026 21:26:07 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Giuseppe,

> With memory allocation profiling enabled, unloading scsi_debug reports
> allocations left at module unload. A stock Linux 7.2.11 VM without
> OpenZFS emitted the following on each of three load/unload cycles:

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
