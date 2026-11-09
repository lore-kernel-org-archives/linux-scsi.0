Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794193367;
	b=Dv9O3cNOIs52otImXWyRX0Y80EYLDkDNv1ddAdcRexfqmkh1up2Xdy8w+rx2Ot45ErBW
	 GP+8ApaZ9AxBajh9U/3Wq59yKG/29Ka0DZ7+YwfhpRfXt2QySivFZSh3dCAVcvbYAcbuh
	 kRiQm/JIcl9ZpgNHX/WWEgaQ5W6bnK7sw+VvFJaNTu5+Pr+z4s/f+ZFxs3SL0j2dIffDC
	 /boSGt+8nfySu2xVPfi/XcFq6t1GAzCXopgKCP1L97ekwaQ+DcxnSnvm+Qi5qIkjBAz9u
	 Bt4+PrSwQY1439Ua8Oge8J60cQyS2l4vc4lS/veCg3urXOZLyxDq496fEvLOJO+OEHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794193367;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=Ulsi9oCTW0gPXOojIMabVzJJWYRbOooaVADLzBvQT58=;
	b=wIY0yycZWvxH22H3LkG7GhN6uzT/7rovZvvjEb/KYFB/hQ511OYK42Y2PNIwkGLhKWGg
	 UyeYZrqt4j0I5pLHYoIk1adBOWmrBwzZmwn6yjfLtVcdmOHE4JjaezzAFdGF1euveNer2
	 HlQizS8bhE8x8EnI+TjlF5ZvqBYJzB/RihDQL8U49grrGrRl3+RSCLqS4bhhpdpyoY+vM
	 CUefo95VexlWSCu2zzii032Hd+S/eQzSPBnIDn3W53ExcXBNRjKJatyaM9Z9LCmtickOf
	 JxjuXCiwTrV622HpovhSdw2YUsd9oZRcJW4kBt7P8EuTUErgBeOiz6aq8EKmOIPh/wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MZSP+XuM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD80606A31C
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 03:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MZSP+XuM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC851F008A1;
	Mon,  9 Nov 2026 03:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794193367;
	bh=Ulsi9oCTW0gPXOojIMabVzJJWYRbOooaVADLzBvQT58=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=MZSP+XuMzCNs9YnHLt+zouo/unHxY3LsskqKHL0JkmoBqXKcBxrCiUjROssEMGBlu
	 GaanoST5l3JnkuWJ18jlvRsOk6xTf9oOI42unSsCynwgzBG+ovQCU2PO+NciXb3RLU
	 jf8GcLYDLoz0n6/cGJvoIwGrTy2sAayBbGaa1BFWf3BOJOoXIM0H8FjkxlPvXQ5MRE
	 9Ug3RoO8ymBcMKYmS+Z5T/BDGrKfEAd25Yf7axmW9YEfqdsj3Rd2R6FriBi2cFSMXP
	 TMMdWciNubtdhj/gZ3TSAQaC/UyvYpfzAQ41VbaJAwyS5iLFFm9EhXk2YoGqN8XDAZ
	 Owinwm6KmZC8g==
To: Brian Bunker <brian@purestorage.com>
Cc: linux-scsi@vger.kernel.org,  "Martin K . Petersen" <mkp@kernel.org>,
  "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
  Hannes Reinecke <hare@kernel.org>,  Bart Van Assche <bvanassche@acm.org>,
  Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH v3 0/3] scsi: Bind sd to LUs in the ALUA unavailable state
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261029002531.82824-1-brian@purestorage.com>
Message-ID: <yq1wlqmwvug.fsf@mail.kernel.org>
References: <20261029002531.82824-1-brian@purestorage.com>
Date: Sun, 08 Nov 2026 22:02:45 -0500
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


Brian,

> A LU that is in the ALUA unavailable state on a target port reports
> peripheral qualifier 001b in its INQUIRY data. scsi_bus_match() only
> matches devices with peripheral qualifier 000b, so if a host scans
> such a path, no upper-level driver is ever bound to it. When the
> target port later becomes available, nothing binds sd and the path
> stays unusable until the device is deleted and rescanned. A host that
> was already running when the path became unavailable keeps sd bound,
> so the result depends on when the host scanned.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
