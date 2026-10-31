Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410824;
	b=Ay0NHpklt72CUnuFTfKKxrb+0/tq0RqL5jw2f8F1tZhL6zsvGXy233l5FPf/bwhXsbnX
	 Ccadni3OT7bcrUrJHQbkMEm1OriCFv3WR8tC3OgnXaR7NbKI37h+X6mGrPzryzvikRKLl
	 L7YUnpV1BN1uipKe132GxBoMq0lb4pftMse+qJUElM9myW1AupvrVxDGouOMePxw77V8n
	 M9jigWDtR0PocwzQoOu4gY7PWDv+3OQ6axqEJrSCCTM2wDyj+oI/qMD1SA0bM7BPpeqNW
	 PCNDtjXsPtFGJStW3lqrVEw8czGkVQuiyK1q4IvbJho0ipo7Q6mvxSWjYkiuXZBhNEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=bU5shHp7LlIscgQhG0sOxp1r7GidigzvXa1rktcJqqs=;
	b=DdirjWVCZEA970plgsT1osK91o6eREkzAoEcSFPx/ZXPxjY3vso29O+FwOrMoeeR3o3C
	 DqJU1gXzYEhX62irWFdCxsczgd9+46ZtADqohD5A+zbnISY8dOam2H4sNikvZVNKXXpfS
	 MlwtZ72g6bEHisWzd+wzsK032VXK6cTBqWTuYWEGlQP0/p+G3mYwyAsodZ22asg0zWRBP
	 0uaXriYCZ9hKHbiX98cBP6fl9hwjcP/aCjrVTT6TYmBBSGPpV3fOsOZoQzPEfvrjUcSjG
	 d43mg9/fBNj4ykPciwHSw1PyIeemR/m4eC2ag88VcTGOhGUP79Cesl3SCskjaAsTK3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lwn8Qr8v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EDD606A329;
	Sat, 31 Oct 2026 01:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lwn8Qr8v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB051F0093A;
	Sat, 31 Oct 2026 01:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410824;
	bh=bU5shHp7LlIscgQhG0sOxp1r7GidigzvXa1rktcJqqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lwn8Qr8vJUjW56V5E+05NtABvG+UFds/NH4zwi5f6QcBpOJOvzqDnVx7VLypS7hUO
	 ToxF99MHdzq4ULFKCkZ3e1C7SV/s9eOASB4R1tSvA0YG33h9iXh6ifi0u3R4NnL/o0
	 6rfXeY9OOsCtsIUE+xH+2plRIGBV+mzaUjxwfkaLUmeyyLnfZMDtrz8m7d7dEnXItZ
	 C+eEzZ6j/Ir264nl68meRCQbRY4seuv6hN32wz5bCyPi2QfzSlE+Q/2oJOdW9ndo3X
	 TizDkdCjKwOXsEL66WI4kBltfhN5ulXNa0P+Vf/N6afp4vg76WWnwIcXpw9be9JCw0
	 P8sudbWyX83CQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Imre Kaloz <kaloz@kernel.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts
Date: Fri, 30 Oct 2026 21:40:09 -0400
Message-ID: <179340755626.952351.12723652064711976932.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013094253.2956-1-kaloz@kernel.org>
References: <20261013094253.2956-1-kaloz@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 11:42:53 +0200, Imre Kaloz wrote:

> The REQUEST SENSE length was taken from sg->len after the
> AHC_DMA_LAST_SEG flag was or-ed in and the value converted to
> little-endian, so the 8-bit field is 0x80 on big-endian hosts and the
> target is asked for 128 bytes into a 32-byte buffer. Use the buffer
> size, as aic79xx does. On an SGI O2 with a Fujitsu MAX3147NC, the sense
> data of its CHECK CONDITIONs during probe was lost.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts
      https://git.kernel.org/mkp/scsi/c/9a2690eb4bbe

-- 
Martin K. Petersen
