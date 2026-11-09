Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794188745;
	b=vOaIEu9UVa2Ocr4+a7oPmVzbTtzGYFxqy4FMFnat4w1E4hKZjId6RjoxGuPmSHI98Pvt
	 FbJu5a+iGnRsqC/VKAjjGikAaCzbXS9Dat93pD+6UxSY1UXYG7grIWbVI/C5cLmWffb1O
	 yYzmgQ3cPQcjbPWB4wQ8GOspucCf1BBMLafOwV70RdheTMwXmFuExjyDISvfpzpcwXPI0
	 BrdcFEpbvLoHSMv9sKwZRQTbLtdtnTsv3WEncorzRicOd9YIh8tz/LSO9PEb7nMEihouH
	 xjaoYWNMtXU9IFtXQ1yCRfvzIyID5sX+pYW68haL84h7jvVzWH7XdlySD1c9XfkYpIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794188745;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=/3oD/voQY7oS/fisfpwP1Btaj9r2Y4l36G9k37HEMU4=;
	b=SkE/nzQOl8+hJTEySHzTtcQOE4lklVV7ymyNWQFHW+1tYUJsOZyAZcCVAbzq2x11kil2
	 d0CjRjB05ARDO1oAO5zvRhnnnuE5EKdFcs4fYrYHKcq3nR1r1XdQig78/KyXDuQpVV8Nz
	 joBv/3i2yLp+GHDx6FkDen4UjAxx+FPRW2sZ/TG0DW6uqYj2Knd2sV6ywRPNAL5dXgT3R
	 Rh2qYBRJRXDK+0RDOZ9x7dFtIKUeuKe3GKZ+koIb6WeJlz70USj2iOIGd/PiacKkBOZAp
	 P79rXoerQfsrYjmbclmlwQmNsErOSHUMFfOXseoXrWMu+aI6e5TCewqaBTuEDuSzMJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FH7sRyIv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF557606A33B;
	Mon,  9 Nov 2026 01:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FH7sRyIv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E061F0089F;
	Mon,  9 Nov 2026 01:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794188744;
	bh=/3oD/voQY7oS/fisfpwP1Btaj9r2Y4l36G9k37HEMU4=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=FH7sRyIvpjx3JsXUgvWYE4gqeJ3AQ7JFmkcf4r+kYqw23Gf0/13klBq9VI/OhCf7i
	 R/LOYzms07ykyp7ohMoPjfOqvBSCq6AbeBiATDFR2iQOzlUHN0RH43RhaO0hIAL+1q
	 GHTfcHJvgSqC+CEVHOhNg1OG7XCfF+9hRMgmlAu/vK3NcrZ6Q7kn5YHXOzjZodEpAK
	 RmITNuInWLs8476Tr69fpyD1F9QlrYwgDNZasFEIEqbay6kIiBB2ZuDyZOlJ9aZGYT
	 zsUsbBKdXu1az5lxl392LN9EOeIYXCkN867jT00I0jzJkcFRIBQ/I9tFZQlR4DU8LJ
	 BuIlxNmh2N2bw==
To: Laurence Oberman <loberman@redhat.com>
Cc: Martin Petersen <martin.petersen@oracle.com>,  Maurizio Lombardi
 <mlombard@redhat.com>,  target-devel@vger.kernel.org,
  michael.christie@oracle.com,  linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <0e12bf8de941ab70a7eb2136fb794cf1dc4bfd8d.camel@redhat.com>
Message-ID: <yq1eccuye0n.fsf@mail.kernel.org>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
	<d7a1701ddc2e7c976ad8ff9ec071d9bfdc86a7e2.camel@redhat.com>
	<20261028140221.GB32229@yadro.com>
	<f4cbbca9e8b743da07902e97b09e49ac7e1cc5fb.camel@redhat.com>
	<7e08a1f08defd24b42722ce0ad52326ff59236cd.camel@redhat.com>
	<0e12bf8de941ab70a7eb2136fb794cf1dc4bfd8d.camel@redhat.com>
Date: Sun, 08 Nov 2026 20:45:43 -0500
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


Laurence,

> Gentle ping on this one, I really needing Dmitry's series to be taken.
> A large customer is waiting so we can include this in RHEL. I did lots
> of testing and due diligence on this issue.

It's been sitting in fixes for a few days.

-- 
Martin K. Petersen
