Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239407;
	b=X87e5P6UNubhyYvPybxOButi8zVEYP6+p2LVCzJUd6Z9pDIjbIzljnpSfHxQWBIU6Btn
	 Ke34OdgZnrZ70Ed38IDaoASb5DneH50D01x3O8KCmF5ETrwNIvh6bT5t86HrwZKNyyCQc
	 Fd79AkbXyFH6/ktqWegOr6FXNOqmwQxoTiQyMV5D1NEPRRuYgiRWQdSr7pw63SRaOrT0/
	 H8LhQbMrUIDSfcl16xKQ4nI7EEynYqKtL1MpG0so+/rrI9pseedKblYA1/Z2Y/qZFgmXG
	 IMMmnns6BWP5qtPV4LzB48fDJHvw7bF4pJIgE9v5dqc69DyAv28CVqmH6pj8lSgA5ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=sZu3YnsQV4zj3DDdVLHtNwlJOE7o6Jb9sVyyBNtx4OA=;
	b=zAhNtLOhh75iTJlZNsnaYCZSViachVd52S3/9qAXmgVipDx/yd9f2RyN7jfcUyMVP0AZ
	 qkP18opmMRNWZUKEO8GWwORKYQJsnuGnfKiDEu3/1yr/XV9xigDTh2wNyvELnEeA1sBNd
	 meYUjWCEEXYLCHzU7nLaOfBjFwXPVyhMbo4O7q7OAfBELsOM0CW1UYQAprL7RG2+m/AcW
	 2O+6cIzQMxBhyjaJDbN8k8FRUwCIS1JOcQ/IDxK9PG8Q8H6pMOSqRzd6DMX6WozOLNtqX
	 QtAw3JauRE0E2NUxbbv+HngvdbHrfM7h0whNPVoX1BxlzICNY35269SKm+0PWOdMv0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L07oQZ9h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0772D60A3827;
	Thu, 29 Oct 2026 02:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L07oQZ9h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFE11F031EB;
	Thu, 29 Oct 2026 02:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239406;
	bh=sZu3YnsQV4zj3DDdVLHtNwlJOE7o6Jb9sVyyBNtx4OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L07oQZ9hxFVJOGuTfZcaiBiVBD0EjoiT+9puB4e1M1U3VpO/rrIaJjQZaSwKpVb29
	 DdyDlsNW1CMuzGtexsgN+OOm9cipp9Jhdoc8nOmUv03iBu6qIJ4AzorKXCeaB4PZHd
	 S9v9EpmMObqiCF5VWi8ByodFqIHhR7AxwQ690zzPdh5J+qoNJtOKb7srsWVv3GQuUG
	 MzurzokC9UdanB7khQb2mfOBdr1oHIJRJreGrQeIqI8Na5sduWgeKThih4wcHOcM/e
	 /lPHTTjsgmEFdo0AIOZlpQo0MhD9Ncy8UWe+/x/vUdaRKW1fcyhIJKTvvabAtc4lpB
	 wj1N9alE13aWg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Wang Yingjie <x-professor@outlook.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: handle out-of-range SG_SET_TIMEOUT values
Date: Wed, 28 Oct 2026 22:03:00 -0400
Message-ID: <179323465391.491807.13936959270361712429.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022025508.294713-1-x-professor@outlook.com>
References: <20261022025508.294713-1-x-professor@outlook.com>
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

On Thu, 22 Oct 2026 02:55:11 +0000, Wang Yingjie wrote:

> SG_SET_TIMEOUT accepts a signed int in USER_HZ units. The sg character
> device rejects negative values and limits positive values so the converted
> timeout fits its destination field. The block SCSI and BSG paths instead
> pass the value to clock_t_to_jiffies(), which accepts an unsigned long,
> and store the result in an unsigned int.
> 
> Negative values are converted into large unsigned timeouts. On 64-bit
> systems, large positive values can also exceed UINT_MAX after conversion
> and are truncated on assignment. With HZ=1000 and USER_HZ=100, for
> example, 429496730 clock ticks become 4294967300 jiffies and are stored
> as 4 jiffies. On 32-bit systems, an overflowing conversion becomes
> ULONG_MAX, which is an unsafe relative interval for the block timer
> comparisons.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: handle out-of-range SG_SET_TIMEOUT values
      https://git.kernel.org/mkp/scsi/c/9a6cb1da4f3b

-- 
Martin K. Petersen
