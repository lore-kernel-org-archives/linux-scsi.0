Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196587;
	b=BdUM8toBLxDLwLX4edsoIvWGy8jq/Zlu7ZIfFexV9TiXslaBBeYMhSYSvdeOcF9xfDuu
	 1TpBvtthEa4ksgMBylt8OqAplJ3naLNTB7fjs7dEs7VmXV6TsFHHj8CnQ8H8lVsVpmZO6
	 tYW6ed1a1+Jsj8fjersOFobGSq0fDAEGbQDattRUgmUabKgiHW3CWBMehI6STxfPwVWG+
	 L9pMPUke5RwJAiuf3qqDVQT0J4joq86PvKDX4LkB20221TM/JT5XtkEvabtPjxGJ/eGgI
	 ww8Mz/Z13nEWEtqoP3ycF3D1tBnBw/G0HISWxJnJI1fBYGJaHF0JXWv9UK/7jvtCIAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LWmYo4KvmGbRcUx3zOWiGbps0fY353/gDC93zDTlUEw=;
	b=I9FmoyGC/fQ2olVCu39Qq1LcPO+8df3E2BuQleUT9Bx1JJ81OaFyvm+mJtKkBue0hnzC
	 f02PxkyCxIJuMnm1PXIDbTOTPgAFP3JWSdyRQWOStGBH56uR+MdBvCnuyoecplqAUJKZU
	 +qdmS88QOcf8WIecwUcvZVZqAUuHV7CE9BQWN/mw93nru2O5GvMsqQMIcqapIR/1pahJg
	 qNQxqc16kCpB6jZGoLhmoWyXkymEoIIbRK7LsBwwmDqRttT029fLVAGAkAS1wCZtY8wOB
	 dWvNf3btYhXcRZAQZTeoPPE2hiY5vMEhwE8fln6qD2cRWOgNr43/bBqtmMEbV+Mj//g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXISmxn8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93117606D804
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 03:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXISmxn8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3931F008A1;
	Mon,  9 Nov 2026 03:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196587;
	bh=LWmYo4KvmGbRcUx3zOWiGbps0fY353/gDC93zDTlUEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXISmxn807LyIpG6joikT2ut/xKed6qReBnskmehZwYlEYeMI8G3K7cYsJdNGv8G8
	 kwLcnsFGMCpDV0L6yJK1Puw9X9rZL3Fak7OuGhHXVP0cfsigEHHV6t2P8TR2LNMw5e
	 Bmm7bLXiAvsqDBeQxTfAgVeU/ewRNP2EPQ1hFnccmCjm+DC5/UCMklrAX0bc+e5Qe2
	 tv910vVrk4FAmdDNaTPUb1GhVIox6MN8pHk06t4kzsPFafkopYi6REY7NM14wJ68qT
	 LRxQ+kH35JfGMhpJ2qUcXrBSN1+CnNHzqyVdaYGs+/R+QjHDOsfPWnuwFCGjpjOmWA
	 7wxSMAMGIx+XA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: vishal.bhakta@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com,
	linux-scsi@vger.kernel.org,
	Matt Wang <matt.wang@broadcom.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>
Subject: Re: scsi: vmw_pvscsi: clamp on e->dataLen in pvscsi_complete_request
Date: Sun,  8 Nov 2026 22:56:16 -0500
Message-ID: <179419636234.1941631.7718947589201019793.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260929231539.630963-1-matt.wang@broadcom.com>
References: <20260929231539.630963-1-matt.wang@broadcom.com>
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

On Wed, 30 Sep 2026 07:15:39 +0800, Matt Wang wrote:

> When calculating the residual bytes, clamp dataLen to the buffer length
> before the subtraction. This prevents an overflow if the device sends a
> larger value than expected.

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: vmw_pvscsi: clamp on e->dataLen in pvscsi_complete_request
      https://git.kernel.org/mkp/scsi/c/a3d959d2778f

-- 
Martin K. Petersen
