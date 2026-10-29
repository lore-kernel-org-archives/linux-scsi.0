Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236794;
	b=QzyKw+kWo6+aCik1v0+uxEmgFiWX4dbMCp8mL6bTreaVg2Ied3jZkabNI4pksg0+u1Ty
	 5fyyOZO1Is6+jZZTqllh3JC3dt3AMh2TC1BVrsNGjb3VDTdtKv7qfeptvf9oy51QABy4O
	 M0eyWW4s7UltLURCIx2m0+LkliobB2Ics0IHJpakDaZ6TABiTOzt0iRqYXeKNKoMjTWtQ
	 5byPZYeqDm/XtdO3vlYtHC0/kb+bMsZoHC1zuk4/9k2I2/4tHZakTiIx5Lhc3+VaCaApu
	 dxrvu/OwFEhPkdsICb5Ee65VVVyYUrHNQwWADZhEAMFao+YmrwMAXEpy4AoCuf+RlUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236794;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=+tWCoBT7KFmB5uSAskMHf62LZoAZ8VkTgd9cBZ6QYLE=;
	b=3ZAykR9LF2cEGt+/LyJOuu8gus5jLW5CUw6U1Tw0+PoNvQnylnrVKcPAY3yiZRRggIGk
	 gDrMdeAbqjHkys1TCBUXCdHDsJrVBGn2J7Enoy4c0YwNxxZ0cVIp+tEQiY1NVHt3rphKE
	 roOXg5MlzTlmgfF8iBMj+y/djMw6FP6RNG5Vo4zFdpw1Mci6iFubXbsDdV0gpnKVJcZvB
	 En1tz46vHF+OPeILUNI7II3hut43nIIyOxsXrA9qpdsymT5XagBhon2l904l/DzjaHaDa
	 5TFk13Y1HMpoMOLnfsNo2FBH3J7pFJSqGaDRnK7RZCJUhOJVOLilNT9R07XDry1lJ5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CKyAEvZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9930E606A31A;
	Thu, 29 Oct 2026 01:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CKyAEvZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EF51F01825;
	Thu, 29 Oct 2026 01:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793236794;
	bh=+tWCoBT7KFmB5uSAskMHf62LZoAZ8VkTgd9cBZ6QYLE=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=CKyAEvZBoQEWyCpbNCAeZ/Eh4h8Pff+hKG8jbxegJS/53KXaT8s7XR7Y2N6NyNLeq
	 KJWPxfj2rSm89voYuPiHtwbGkaosm3vwtXHobIZ/Hq/OttjsD5Eyri4X1u4MTZNUd5
	 Wwxa/MCOsjSDxNBKpRdvSHzRKdOI+WCZNNZRCqkcd/5QCfVOrkGVVB8NPnD+ZKfd8f
	 0Ps0GR6mKpR6SQUiKIB1B2xbz6hO4w3E3mz5kHSVCVBm4rMYet+BLXRsG79jW99Oaw
	 xX9A0t4gFJ5AHTGDA/UUEg1ttHv2DjKOorRQXQ3lS9/ylqENx/YZoHhZCPts/vpYjY
	 JmMnX1jUmyeBw==
To: Andrew Luebke <andrew.luebke@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH v3] scsi: aic79xx: Fix NULL pointer dereference in
 device reset
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261026172032.749756-1-andrew.luebke@gmail.com>
Message-ID: <yq18q3h5mmx.fsf@mail.kernel.org>
References: <20261026172032.749756-1-andrew.luebke@gmail.com>
Date: Wed, 28 Oct 2026 21:19:53 -0400
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


Andrew,

> Since commit c67e63800446 ("scsi: aic79xx: Do not reference SCSI
> command when resetting device") the device reset SCB has no SCSI
> command, but ahd_linux_dev_reset() still sets its residual, and
> ahd_abort_scbs(), which completes it, sets its status. Seen on an
> AIC-7902 when a failing disk triggered a device reset, which killed
> the SCSI error handler:

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
