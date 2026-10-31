Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793409845;
	b=VAtmuHrqHPM6/1GgnIpJRecfeJODe+AP5EvCAjl9irk6FoB0+886QftLyb5fcoBEbXtf
	 2yYevh73Lx6Kr3fjNdT9db0HVWZd5d5zdbGqUZFz/p8DI26/zmXeH/xBuEA/PXcq84Zfx
	 C7Zt+bWIV4Jn08zCVwuqcdrR+lJRyX9aPbn3WjwmLfRfp51Rs4MDa/YG60720F4ho1Hj7
	 xZ4h8ZndGZOgj6vjMwwpgaGRmv7DDKQbI5/SjIjXYjywabPlFKwoFI9/S4vyYDO8PZ6g/
	 Km7S50Es/HtXdX7GEb60SwGxyBF5Rp1985CC0UlycjKTl+Au437falAZLQeCI4fvTAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793409845;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=r/eSCdeMizNNCvlDhJnnqiITSv5k7zOJDtk3hcAbaKo=;
	b=F/2ILsdmo0FNBlFbfUbKVA2f2ie2DzYqbRQt9W9uRvHESQPYXBNSM97NqcQ6Hnw4J3ym
	 0UCocyeMq42jwWXWRn0MjGzeR/JPMpPcMmIUP6LYIBRQj2w3RG6v2A9GSB+IZQ03rCtGs
	 tF2ROkAC8TeJr47EkUaDzcUCPOtFld+Gtf7b4DNYQTgv5APMn3SfWnVLdW519XwAneMGB
	 g4w7eia78tQM3aPIvSfSnZ6dNAIr+WeSayUSInxfxnwwXKPlc+z+/tTuC0y9UdlK/lD5U
	 YIU+ZjdpS6TWnrxm/aOLCXpiENnmwPMZAyqELNmrxo8GxSjhkBra+hfekuwjSl9h8gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HQDZHkwm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B37F606A31C;
	Sat, 31 Oct 2026 01:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HQDZHkwm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882801F000C1;
	Sat, 31 Oct 2026 01:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793409844;
	bh=r/eSCdeMizNNCvlDhJnnqiITSv5k7zOJDtk3hcAbaKo=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=HQDZHkwmwJvCM+9gLHZgFV1ubwHMPRcvLbwYHm7IZXShrbzWyzzW9hLMpVVe7jHe9
	 sPUI/fDOZs0pK+tHwNtP5MCxm/akWIo630gn7ljWME6Z5eUpzmHzId/IfBZHDxbovJ
	 RTSaCR2voN6JtLcAXBrUwPDmoWspLGQAsYsdu/EWB/qBaAUaCUgTHRua7vwyZn60QM
	 cZ7sCl3WJUycWO9jDsXro7wcujiyej0ZrSbb+OxBvEVjiuCHW72O0MIPhWxD6LBKuF
	 PM3VVVc3RbYyQUvpZlsfkqCmjeuukPXXmXomiseRAEqXmkHAyVZyOJp9B4JNJqzMDn
	 0N91nWJ7+QF9A==
To: <shao.mingyin@zte.com.cn>
Cc: <bostroesser@gmail.com>,  <mkp@kernel.org>,
  <linux-scsi@vger.kernel.org>,  <target-devel@vger.kernel.org>,
  <michael.christie@oracle.com>,  <bvanassche@acm.org>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: target: tcmu: Fix divide-by-zero in
 data_pages_per_blk store
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261026195245337ktSXy9G17VCcXyw760g9s@zte.com.cn>
Message-ID: <yq1bj8a3boi.fsf@mail.kernel.org>
References: <20261026195245337ktSXy9G17VCcXyw760g9s@zte.com.cn>
Date: Fri, 30 Oct 2026 21:24:03 -0400
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


> tcmu_set_data_pages_per_blk() only validates the upper bound of the
> value parsed from data_pages_per_blk=. Zero passes that check and is
> then used as the divisor when computing udev->max_blocks:

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
