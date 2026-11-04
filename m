Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763229;
	b=m2ysKDgGDqkLzd7QJ+GbZNYdjLnDhKqtRBQsGYSHd873vFaPIBAy7piw37X9av/ZDbLL
	 LaKnF7mQanU0YQTvKTZxBRXfdpUgh8qmn/H3DxtO43D72SXn2pv/ERDiCvoA7jgwILGzg
	 r47Dx6RdtPGBxWwMyL96sVqpqTl4N+hG35bxHapFDWhYXRncJsnAGVMFD0LsWTMeOJ3iL
	 oTekuQRviC7i+IRZBk0tLqOIWaBS/fK0X2ZmuDGiLvAN8jfsh2MGkDrNYOgsxhhc2xB7k
	 zPlhoVuOhEYLVnF/RS17v4g2gKm25sCdoJ1pB7Ll71bgJS5nF5KUh6Ak/eyiinlWFgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763229;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=33STVZvE8z48hU/esK4IYZDY8zSS/+5aNbqyxOSocz4=;
	b=a0UdEuq1VQ1y17rnQ4fHhNg1XhQGhv4N2tmG4wA/FaFE+0D8EmhGmyjq/8E9AgIuqFtH
	 wR3we7cmfWnuGridL3PbkrevFXq+uv5zHQg+Jq51vLR0ve3XtcRZk2GU56lzqyrDth5K8
	 BDVgwcCe0Bv6nGiNsnfUC5R9pavDnRokKItTy6HyU1kaFWAvtSkZQI8uXuqCF5vDNofOe
	 YXivJjey/96NcFMDpMEg2Sbquk9H8aws4QyvSz/WslvMfXLcmcUInnx0aUwA+HVIOgMh1
	 5IYUgY0KFUWzNGlcL4Nrtip2xpUdh8N6wNDlTANWDDnEl7gPTAB//6IppxPpk7Kj0sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="WQZs+/du";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA01606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 03:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WQZs+/du
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862D21F000C1;
	Wed,  4 Nov 2026 03:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793763228;
	bh=33STVZvE8z48hU/esK4IYZDY8zSS/+5aNbqyxOSocz4=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=WQZs+/du63akWyusDd6NnxMQYRRkjdkqUeeXTToPgx5MxEwpBgSS3B5MnkoyX8jQ6
	 bHcWMcgve+mywjdKnMPgDlEH36hK6L0JKDMuZRQJVSePjLp3XPrBPtnNrFzBPr7IOa
	 uodr8AlhQw7izJvCImxSTNWOcYWxzCjHiV9YeEZhd4ub6Tc0qEEWpTf2IXP5o3YuWD
	 BKhEBiAmgvPsfnll9O56cHEdn39dvGxlq6a8N7H+myidPqnSmU4o4sGb7bvaBMXBZ0
	 FjEHEs7C6Fyw7l4oRBIELzrf15HPazAAMcyPr0+n1AbZBV5Ld3Br68UL9iPHooBBCP
	 R3Yi6KT3xDvuw==
To: Matt Wang <matt.wang@broadcom.com>
Cc: vishal.bhakta@broadcom.com,  bcm-kernel-feedback-list@broadcom.com,
  linux-scsi@vger.kernel.org
Subject: Re: scsi: vmw_pvscsi: clamp on e->dataLen in pvscsi_complete_request
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20260929231539.630963-1-matt.wang@broadcom.com>
Message-ID: <yq1qzh11d9m.fsf@mail.kernel.org>
References: <20260929231539.630963-1-matt.wang@broadcom.com>
Date: Tue, 03 Nov 2026 22:33:47 -0500
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


Matt,

> When calculating the residual bytes, clamp dataLen to the buffer length
> before the subtraction. This prevents an overflow if the device sends a
> larger value than expected.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
