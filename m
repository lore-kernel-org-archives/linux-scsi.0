Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795661341;
	b=o6hV83k2n6NZ/WxzRL+hzrAVZ8Q72qo+IvWpO+hOFycVFo9hycGMS9O2wOadMa82WDcE
	 XscmmKXsE8z6vNKEVmADaNROfkTQ8J2yXz14tWdatis/+qR5q0cE2XTfbUilRrPLpCZyn
	 E9Ni58l/ixbqhbCXF8Pv4hfknRGCWyNY+wmRIiVS/5ZbzMmKrMFcVtX9SO9HbK/97TWvc
	 f4DeXkBsJL5Pe/KwKsJKCPiKnfMFSQ7L+PdNA2YNDGEVgpF3w7VRPMGBJYRFgGO+TRtv1
	 0pLR8ROc3iF0H+Zx+SDodYBtzmS+zceIHph7SZj0QiESM0cHvmCu8ehqfHobupWtD7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795661341;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=+Ba94K1J0+ldR1shzY2hFpeSi+738mOCdRdjKxYDuL0=;
	b=EAHNAQ92QFJahoS6exv2UBIoiojh6PYhhO9wQtA2VMaV016lfcKjq3F2weGiUC865gwQ
	 VtNoFjfFyxtAeVXEc1khe7VZN8SG77MgPLorvurp2aRAM1ayzmzjYUKTALak7gv6FZQb2
	 APT0AHiC1VxDkDeh0p3u6UcVxQDjKM3Y7Mun6Ql9yjK8vN94aOv/RI6zKUGV92my80daE
	 AwqkuvogITm3Rk2pM07d2HZ5n1sLnd8XmmuemjuB4hmyQu2lyAvKGvQqh59kBAkldbSWe
	 ATYpFK6+x4libVRKOXC4g2oWN0te1yUReOEa7k7T/3Jg302FehzuvDv8tv1RnpLwGPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZIhwKiDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE56606A31E;
	Thu, 26 Nov 2026 02:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZIhwKiDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3DD1F000C0;
	Thu, 26 Nov 2026 02:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795661340;
	bh=+Ba94K1J0+ldR1shzY2hFpeSi+738mOCdRdjKxYDuL0=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=ZIhwKiDCGIOU+tn/dwLSp9MzukekwRcckQRabyrFBwW1s8FKMQDaRi3jUoH1PBCpT
	 OKflu/NLQNoC3wr8ljTy6EEADwlpQSLrJtZYpKqK1AOqLlALEdzoUTwW+/ME83ASWQ
	 Exc+Gs2AZxJQAhxLL0TqVu7BGPRZl2TGp2/t3uPeM+uFx3AtpSq8nNCHw4ZuvULZAo
	 t96P+dWA9euA+RC0A95VBN3vRNajaxFm1xIQU9D7LisqC3v/XTCozM+6K7v0S+RSWd
	 3gf1Kpd1R6+V6CK1zVr+k6yVNykgqDB11mgV1mpp6DirdM37nUMovgxgkDUgLEKCNH
	 WkFGWkbrf7GUw==
To: Geert Uytterhoeven <geert@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
  "Martin K . Petersen" <mkp@kernel.org>,  Kars de Jong
 <jongk@linux-m68k.org>,  linux-scsi@vger.kernel.org,
  linux-parisc@vger.kernel.org,  linux-alpha@vger.kernel.org,  Geert
 Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] scsi: 53c700: Fix hostdata[] size on 64-bit
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <0df0fae8a75e46f2f1613d398c1e137211d924a0.1795423196.git.geert@linux-m68k.org>
Message-ID: <yq1ik1kjoj1.fsf@mail.kernel.org>
References: <0df0fae8a75e46f2f1613d398c1e137211d924a0.1795423196.git.geert@linux-m68k.org>
Date: Wed, 25 Nov 2026 21:48:59 -0500
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


Geert,

> NCR_700_detect() allocates four bytes for a single-entry hostdata
> array, to store the NCR_700_Host_Parameters pointer. However, hostdata
> is an array of unsigned longs, thus storing a pointer or unsigned long
> causes a buffer overflow on 64-bit platforms.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
