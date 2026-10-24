Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792811044;
	b=ih3D1ih3xs+Om7K+g3nDG5rz9tYHAJS7h1clJS7beDfn5O1K0+IuqKxNZ9osdy0irSsj
	 0d+aBf2qoHofDRibhIyWm+HuaO/nq/O/nwKChLJdHyk1IFUSxUuh/r1mDMHH7b3gSYfWE
	 fu2b3eY3gjAkiJN/5YZ+TTWLxT4Vq7GuIlnmeG79S7ru1jG+iwE/L/OfBKAgtlflDjv6N
	 XTbcTH+xO0+FwxPvz5Q5qneDTiMRCUQDwhfnhC2Q2tAUewTTcVUjCTf3ZqGTcYCKiFPKv
	 QQVMkRakMMySilD5iOUshHfer8M6T6JsEHBtLbxV58EGRsOu273YbDF7bcOGwwFpT8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792811044;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=TmK84cuyXL/OTFiUXGEgEikpxQYq9UtzXSvMycfVZmM=;
	b=WxgEI8pzGoBAqjZqyQ/Zf0CLdZNejmoZxmTzrJt8Q+vLjbLWl2p5Kg0pFTgQh8vIm2MQ
	 V7ZbBf5L/QDCrfxJF7gftSk9PZ/FLSIKB2bPv+R2TCesXZiDDw/ZrITE02jRltu94x0UV
	 Qjmi59hTl6NT3hSyvEV/st1XLIaYbxfHN0gx6T234fLWXefJ4QqNQQ70jFgq5b17UCEw3
	 RTdNrmY5fB6tHl40PcofjrQmj7QUlHvk4KlI5ddfI01FrYzwJESeZUsbrErR6+7x8PdB0
	 +VgphYC5sshUBtbNU/UL0pC4OnIBD2C7IpAnvbRMLb3yGPpSE7j2GrBP21W7Zt+oVcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XDqQoyeh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92306606A32D;
	Sat, 24 Oct 2026 03:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XDqQoyeh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C681F031E3;
	Sat, 24 Oct 2026 03:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792811044;
	bh=TmK84cuyXL/OTFiUXGEgEikpxQYq9UtzXSvMycfVZmM=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=XDqQoyehhrXZSf5g3ZZgNDggw9S+puk3uA6GsYPiB5IoHkmv6HgRsyWxniUmEKdJP
	 9KObSK5CtOndf6FpQ1QB1uZvcHcCW/SoQRrnQO1y5YDrg+qvAem+3rLvJQVIoneYP4
	 VlRN0cq7iI89iOLnDv/3inMdLEsods1OG7jny0pjwntvYELdjy83TRY961L+6tt1CB
	 a0R+u9Xlymv14iCeJDUnqNdJ0RFbGROE79BisauiKiPiFy0mJqCR2WTLyQHRC4utg9
	 eLOww3VxV07nB4DfC6+qE+4BaIkXtXwjMRN+kyBMfygZc7MWggcjN//3Mqzj01+RZ7
	 ZTXSisgpKw7VA==
To: Wang Yingjie <x-professor@outlook.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,  Jens Axboe <axboe@kernel.dk>,
  Bart Van Assche <bvanassche@acm.org>,  FUJITA Tomonori
 <fujita.tomonori@lab.ntt.co.jp>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>,  "linux-block@vger.kernel.org"
 <linux-block@vger.kernel.org>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] scsi: handle out-of-range SG_SET_TIMEOUT values
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261022025508.294713-1-x-professor@outlook.com>
Message-ID: <yq133tv94ve.fsf@mail.kernel.org>
References: <eb20226b-cfae-4b10-b42c-1b12c2d17687@acm.org>
	<20261022025508.294713-1-x-professor@outlook.com>
Date: Fri, 23 Oct 2026 23:04:02 -0400
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


> SG_SET_TIMEOUT accepts a signed int in USER_HZ units. The sg character
> device rejects negative values and limits positive values so the
> converted timeout fits its destination field. The block SCSI and BSG
> paths instead pass the value to clock_t_to_jiffies(), which accepts an
> unsigned long, and store the result in an unsigned int.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
