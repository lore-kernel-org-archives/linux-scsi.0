Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196542;
	b=WQJ3AO0Lnvi4acOKVp3P3t/RIM2LUxmqNQEBHGd7oQO7CaXQPSttxVajJDBYeFz3RIHL
	 6w2e810hoYnrLqWDLCiZ2ajwyGjn21/E1cZCzrOGUF3w7Mlj3X1db3H8/V/hP/J+x1Gyp
	 WWmdM7X/7BDlchPPUDS94Xfzac+1mEfT75eYpZ9jdnATxnxncqz3fftfjQFHzOg98aqcP
	 hV5OlFKiy5udAsUjQJ7yrbdxNblYSLxqrq9U6XIFPsGjpGze8wt/yAS60NvtNYc3w90vz
	 tUHNh3TMamEVhM7yuWW2w2NR3NutmKGIp6UzrzETOukqLJIoctg04D0/lixF8KMjaOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=qL1PHWR+UFgKZbvNDIunq2Agijkm94RmUs2cUI64v70=;
	b=TPXPKNsXwAS7xs5kfKbudlXAo6+mHUQSj6IdcYev2maOsNHRhsex9TEb62T8daCEqjue
	 Gzdja9ouuhI7uMrr4kt5hOx0c5CJSrJRL+1h5ymRlAYl7Lnh+gIgMNMoby1Oa02zm5jzV
	 K9aQcfVB+GEpAX9C5lDieCU7TW8k9uDot8CbhtgFoKJ+kgU+vRyNFLiWnUaJirS0jZFzC
	 XcStp0p1lfRwO6CNLRvG0CTYDcdAefWgIIm4oZKmuwtF5BR20w5ZBvtws/XrwJ+udy16B
	 Smzi4Z21yOfjKMHLxYv4Ya1sL+pWYscjNYfMWI6eC3ZGuGeoTaCnAKqjix9vmh/ey8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7+AmU61;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BA0606D807;
	Mon,  9 Nov 2026 03:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7+AmU61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CE61F008A1;
	Mon,  9 Nov 2026 03:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196542;
	bh=qL1PHWR+UFgKZbvNDIunq2Agijkm94RmUs2cUI64v70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7+AmU61OAbBPX4FvtbiLu467QqZUR0IR4tfPhJHxyFXobxL1YFmg5qFnJGGP1lCU
	 NDj9yiAOWB9xMFNq649EPaH1lXZIc47Dd7VN+rHAfnqwv/bTAjKj8eS2IdmfsKTsH1
	 U6UADOm8lctG/2CQFt9HaFCSTq8+5HikfaCfH2t2D5CHHUqjJRNVbT3bdq9knEC+Kr
	 K9h8OVmGiKIxRFcznvWeI825YOB3ckYWnvEV/U8D/rjrNxhcGLB60sI+ZEQZHb4ImJ
	 AjHbE09YNG6B/r1Z6c/l3amDU1OlaT1OogZTaUMcRsU6yx7/A/TkxpMVcHorbwJ0TL
	 xn4dsDon0HCgA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Ciro Iriarte <ciro.iriarte+software@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: core: Parse APTPL res_type and res_scope as hex
Date: Sun,  8 Nov 2026 22:55:23 -0500
Message-ID: <179419615241.1941224.11662554715359026347.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <ea903e6c-09b5-4a11-80e8-6e1387f39ef5@gmail.com>
References: <ea903e6c-09b5-4a11-80e8-6e1387f39ef5@gmail.com>
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

On Sat, 31 Oct 2026 22:21:39 -0300, Ciro Iriarte wrote:

> core_scsi3_update_aptpl_buf() saves the reservation holder's type and
> scope to the APTPL metadata file as zero-padded hex ("res_type=%02x",
> "res_scope=%02x"), but target_pr_res_aptpl_metadata_store() reads them
> back with "%d" tokens and match_int(), which parse with base 0. A
> leading zero selects octal, so match_token() parses only the "0" of
> "res_type=08", the trailing "8" makes the token not match, and the field
> is ignored as unknown. An Exclusive Access - All Registrants holder
> (type 0x8) is left with type 0 and the write fails with -EINVAL and
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: target: core: Parse APTPL res_type and res_scope as hex
      https://git.kernel.org/mkp/scsi/c/08f08a6d49ef

-- 
Martin K. Petersen
