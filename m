Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792808988;
	b=QMgyhYSrpuBPG5lPqpaLCd04TWxjDcF8lYvOuSoPYM8aiAMnBIOgRrR8vQLzZmRYvDcJ
	 5eVhmRjS8oM/BwTTjCmK8BN17eHY0DXbLALlOHzQjffmPxDyFlx+piWJpuwv4uSUaReZa
	 QaMPpUBetBG2z3d5ZLdTyaEqhOssUSieNxG7I7iv2vRK3NdfEySaYoI/BiTKkrBJgJXJ8
	 g/GIKcr9ibTUtzYZoIW17SiOamKz59BfWDLsWSs6RKcUxqqZqPEDsKR01/KZt2sAS5mpD
	 psJuMkHz3YMRVAv9tQ9+4aaawEC+Hd/rBnEtS9vL2daIqw52jJTcRPWXdoyzbWjZ4kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792808988;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=BglvdCaKASDGLDgtpeQcM/HF+sqpSGZ9LQxsu7MOuxY=;
	b=y1k+ZCQlKG9Ti2HKp6oLF5UpStHFkb3qMcQFIa0QQMcZwuAkIuurHhUUzhRc7eTLKRsN
	 FJhnbS1Vgk3NPqHcHmrNf84Mx0IcRFOdB4qr7YGumhwzLuZaaXJvtDu/Xr0FMayrR0n0q
	 CUyxCVsZknhp9OXePz65OLoQT2tOB5M1K0v8zkNuBXLBu2h1iGhgX8V8FR8cr9Z+UbTWa
	 yhFKdsu1FklRAGUlmqLeuf597OwBIgbQtvkTygrfLSWpQO8RzciV3ugnA50ELYCUbDMN3
	 eZ7pt7OGdX3OhKWLMtsR5nmH8f63/cd2v5qDmxaKsjpNwgXxI1OdqcP/IRGcLuMQ+EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FUkOdzXj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5253606A32D
	for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 02:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FUkOdzXj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FBD1F031E1;
	Sat, 24 Oct 2026 02:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792808987;
	bh=BglvdCaKASDGLDgtpeQcM/HF+sqpSGZ9LQxsu7MOuxY=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=FUkOdzXjLlt53tTh+CDb96arjX/3fVWzNXld/BQFllBA4cvFWckePvUEJ1uOoyRF2
	 oAHs4DLzS1OIzePpwWJwTTK2Xis8pmPLit81y2dEFtA55Qhk+X8uJ3RjA+VjRm1kSh
	 pVVI4HyBuMy12r1XlhX1SdGQ0pXmU6vUbog/lCP+BubjeXvgrIrjPMqlH+odEM74Ee
	 Ygsm7m2ris7tb0aZEy3uPEoVpkw6G63tKhI8AF9kki2x1s/rSB8N+w3fMmDOHSZ8og
	 1IQpWOn4koK0+rHBEK+lQGlXdBmLOoFiF9HbETqjd7vc3yoUf/cDf+xRF50KPPhH7x
	 AUd5nOow/5mww==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  John Garry <john.garry@linux.dev>,  Hannes
 Reinecke <hare@kernel.org>
Subject: Re: [PATCH] scsi: core: Document the role of scsi_done()
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <6edb00749da7a5ce9b7752d389ad2ed5a38776e4.1792022610.git.bvanassche@acm.org>
Message-ID: <yq1o6cjal0w.fsf@mail.kernel.org>
References: <6edb00749da7a5ce9b7752d389ad2ed5a38776e4.1792022610.git.bvanassche@acm.org>
Date: Fri, 23 Oct 2026 22:29:46 -0400
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


Bart,

> Document the role of scsi_done() and also how it deals with commands
> owned by the SCSI error handler.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
