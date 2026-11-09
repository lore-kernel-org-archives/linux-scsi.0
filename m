Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196552;
	b=ZyqWxEo/39Om8FE9tR2evJWmJiViXErQDDClmNJPnN9MwtltR4PRw3LhhuBcbHnttk+I
	 FWQJxCff4odTdmJGB+oU4rVWp1WNLO7rtH4AzZ5dZ/N4HcRVG89c1hdSTjzCJK2NWKAzM
	 +17FQGE0mvHFPtJeObuCGJBA5TCa8iKpJhNhBojTFaKhE9HOJdNaM7iq1eAd+2sv3xeFt
	 PDULUtq7MgcF9VUT1g5xtsijVVEMswLv7TohT/Q0m1YKzeezkDV1MkwmIu80uYKR7X5t/
	 jDfm0ihKGizix8EbTwQyViwpEA/8PaA7ds1KTlaiGwdichDWRhGhJLBJhpANtP5LNIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ejd605WTFGp3aSTusQoaXr/J+wa+gRW4X9mBYWraq28=;
	b=XW9ZZ9iTqBurDNE0OJBiC9c1YdSv59YgjFWeg2t+HpbhxdxyFJMYorI5hjegMkhDRiDV
	 MqvOosXzZmlZi3h/5tPDUMJGJZ0PJLPkQAZwEIkJsbg9XEsmAA7F2qPSQLNTJskoOjyr1
	 GQIa5soSJZcMtTZFHfwjJKMfbk+h1E4zIgAwAFn2ZtHL7wrLHePHx+9kCZrvmcsbzQB/R
	 fwz2+ik4ji7GwWYSXfH3v9zKz5wIS394pdeA4dePhIEdrLHKY7hWtC0husK8vlHFZjFv6
	 DKRx6fdO4ABIMdPKLY0R637/aLWFaccZLYAUXdtlmrsKWD7MhLeoUIMTuf5uwi2pOtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3tOIT3Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589D1606A32A;
	Mon,  9 Nov 2026 03:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3tOIT3Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAE91F008A1;
	Mon,  9 Nov 2026 03:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196551;
	bh=ejd605WTFGp3aSTusQoaXr/J+wa+gRW4X9mBYWraq28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3tOIT3QPFsLBxHfhfTluWvzOfBSs1dDhdHbOCaXR8Z6pUcHGsYxl04ypMBRDV7FY
	 CzNmx7KOWvHyeETAuol59C6Y8LX1ZQfhHjrq4HDbyNwYibRAIATFeKuig9KelJkBUx
	 cUwCJGkMi5mT5XRMBS9HR3Om/a3WCcT7kblus401DAzgR9E4CCLdRUNt76AkiX0SS3
	 uLOGKhFnTdnl/5WEd/E5QIwd93/0UdblblhsOxkbCJTTpVt2GJvN9nU4FmavRPA5yP
	 Vu7KGNX8yiTz8MeNT5V5zzrp2LgHDJvy7gfj7dEdlmPJxKv62epedun/nZ/rL6nwTG
	 qv1KJbqTqsArg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	John Garry <john.garry@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Keep clock-gating hold on failed W-LUN runtime resume
Date: Sun,  8 Nov 2026 22:55:32 -0500
Message-ID: <179419615219.1941224.17339194202779263652.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029040002.2100002-1-stanleyjhu@google.com>
References: <20261029040002.2100002-1-stanleyjhu@google.com>
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

On Thu, 29 Oct 2026 15:08:30 +0800, Stanley Jhu wrote:

> 1. __ufshcd_wl_suspend() takes one ufshcd_hold() reference and sets
>    hba->clk_gating.is_suspended while the UFS device W-LUN enters
>    RPM_SUSPENDED.
> 2. Since commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
>    suspend callback failures"), a failed runtime resume (for example
>    START STOP UNIT completing with an error) leaves the W-LUN in
>    RPM_SUSPENDED with power.runtime_error == 0, while
>    __ufshcd_wl_resume() already clears hba->clk_gating.is_suspended and
>    calls ufshcd_release().
> 3. The next W-LUN runtime resume runs __ufshcd_wl_resume() again without
>    an intervening suspend and calls ufshcd_release() a second time,
>    dropping a reference it does not own and underflowing
>    hba->clk_gating.active_reqs on UFSHCD_CAP_CLK_GATING hosts.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Keep clock-gating hold on failed W-LUN runtime resume
      https://git.kernel.org/mkp/scsi/c/6da1bc55c060

-- 
Martin K. Petersen
