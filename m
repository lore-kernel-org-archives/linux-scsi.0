Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792810325;
	b=lPUBceauvBRwoo46GB4iTboTl0WMW0H+JL7OWKlpuN/64Os+qplJo/Fj9mrIxwo5N0ed
	 1xh2Gq8on+/UwLz3TJ8RopyKbknV4LyLhyLMFutAWy5O4ErEdCp3Y2zMYG7QajwuGpsQm
	 /k+jRzfUzYVe6TXgq9ZTNeXoUt8vn2c8/SN4NHVk3ch1N+YqoRsOJ3IUVuokKhMH9DaIb
	 YLwPqhR6iEEmHEwfYA4Uu+0kgQnQ8fPZz2PW81OTGPSCyZbkO8nATRjkFXMeDNT8BHXhK
	 p76sDfQZzskW3+Fe0L0aFhr3RneB5wepGxEz0oi9yW9yItLrcMyKdSCiz2+tji8eaFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792810325;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=aLNSqsBGXiY7rxJSvoWY1/IsOqJJCuwYrC3lByH3Dgo=;
	b=aWEJTDGnXOel7exNyHd2v5uqk9nElvH6zKTOOwlyULRZnhA0XQAMEm0RDw97tAP7RIEu
	 NL/3T83QcjYYlLcO/v67BSKEagUq9jfvJK2Qp8yQxZXPGhMPV/AxCw7sEX7SzKIybh5MG
	 amA9di8+I/T/YU1ewDqPTfvt9HRmAq4H24AZmdW3yAarlEgYRdyRaPBty4if+6g4ulBwD
	 gFKSVyIhvYjakR1q4rj9WwhlYwlhQ1ydeEez0TIwsnJD5qic17CHwJscGkKh0A4YXhpZq
	 6R1sQQWLZ10lzwOxU4cDF1QVVRN6chOPJfC9sQA9Yrdo5VzJj3touhrNYHta9pG/5TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PmEjkiaa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDC4606A31A;
	Sat, 24 Oct 2026 02:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PmEjkiaa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9331D1F01825;
	Sat, 24 Oct 2026 02:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792810324;
	bh=aLNSqsBGXiY7rxJSvoWY1/IsOqJJCuwYrC3lByH3Dgo=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=PmEjkiaa9p1QnjFlZbeEJb6jPzMuOOnbjleeIyINt3dB5y0lltq/gQfcKVIKRKHKw
	 m2+UKX0c0p191dSWs3O74+ddHSu3h07LAkIXkuL9BAndiA0NBSaJhNUvBKB36BCLdX
	 S+WFmPuR1x1CSUWhzgywLMYwq3Id2A9lEAfBxcvNt6x8EU4vQglyifIJiCEqD+f1Ez
	 5bGPZCF/te3ZtRxwTfwRTVisFhW+7JOuMoBVeLITkYpzIOGmrM1f96jgsaMKnyVZMa
	 ddLZbF63U8Akuqz/AE/ACf0POLseTcZbVDuIlREQwLnMGmh8xNF083XTXF2AJKxUrS
	 rwZ0nD56WGo/Q==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  John Garry <john.garry@linux.dev>,
  Christoph Hellwig <hch@lst.de>,  Lianqin Hu <hulianqin@vivo.com>,
  stable@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: Mark the disk dead if runtime resume fails in
 sd_remove()
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <2c0c76d70f0fe197932836b9bcf8496095135d1b.1792446921.git.bvanassche@acm.org>
Message-ID: <yq1jyn795fi.fsf@mail.kernel.org>
References: <2c0c76d70f0fe197932836b9bcf8496095135d1b.1792446921.git.bvanassche@acm.org>
Date: Fri, 23 Oct 2026 22:52:03 -0400
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

> If a SCSI disk is unplugged while runtime suspended, its request queue
> is still in the pm-only state when sd_remove() is called. The runtime
> resume attempted by scsi_autopm_get_device() fails because the parent
> device, e.g. a USB device in the USB_STATE_NOTATTACHED state, cannot be
> resumed.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
