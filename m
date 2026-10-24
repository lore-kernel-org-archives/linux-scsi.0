Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792811906;
	b=16sZ8TxNo65MSRjAD+xRWwrVRs1uzpXFxEQXSmP+VA98Bmk0NPmwnOZArXIKbolZTAOI
	 AbV7pOwn15a7ibtyxhJP03pSo7us+VyAhwrkA4P1uyqWkbmP6aZ07VOgkRIYff7yhCacZ
	 vtJXHX8aj0c2b1GL/I/44BzkPU2t9UZDiRkpr3AVCPUk39ZiF2HEiGIcnbqxaLd52IbIe
	 reNdTR5f5yV7JqN3YJBs4krtEBWzyiOOi2ZpcE/Zf+bf944JVcvYEtkrM3GzfXFnVBDQR
	 7PE7+PAjteb0ezESYqaSy3LJQfW+Vvvm/rA1Wnk2nSe6JnioznP5uVDRsSg1EyiBYaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792811906;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=vqbPa5Xck1oNiM/EhxOJN0ahqtqyHMgmQ2kF9nBYDp8=;
	b=n2aIS6M4AWCLpFPBrfO+8tXmV5WnufMCLVwu2GcllebCyso/MBcwQagLl7ahbo9QpH1w
	 JSjuaD6CIpojqoi3Ul1ScUF4fP8UiC52tMQF92pI52GHaQTrpp8HHXBfaQGITKNnM+f4z
	 jJyaGZWRLP/xEE1ViUZy3/RHml59pzYP2NFnOtxdAA9FGb69lNoPwWLORmC0K1A1DfSNC
	 S565WP4OwELwPPyPtcpaR5k1rrL6U6ICzDqC2fHk2RrqophL08xr6dlLGmpPnh56g8rLS
	 PeNthsybRxX7X3RVxHzrrFKaH+mQxQ9Y/+L5s80u5uHEU6FfpvC1jhON5HWDj+8+3cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bpiHHN0C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A24D606A31A;
	Sat, 24 Oct 2026 03:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bpiHHN0C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1101F01825;
	Sat, 24 Oct 2026 03:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792811906;
	bh=vqbPa5Xck1oNiM/EhxOJN0ahqtqyHMgmQ2kF9nBYDp8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=bpiHHN0CY9b5rRGs7Be+XpHzOTZfzrqvFzE3KdGNRwEjwViwHpHIGXC5B3PRy+Ion
	 HblSdVhfOn+yfj+p++B5c43OEGN0ZISaUaK6vSS4bHNwHEAPIxBorA1WVJCmsDiR+A
	 XVy2kHvOrIptc78QS1hy0Na3mmqQ3wsInsGpGehNYYaZVXl6t73fOMutSfL7FKpKgK
	 YFGRHgAFwAN2uhVGXqFigYskBa2Vd1bX9KVNaq3d0aRluMllCs27GnNKLt4tba/Ah3
	 oTpZ7AhDMHGbfjv8g5WZ8/L1pATqBm6bSXyAZjmtKcTQhc4FR43MeKW9v3mRzdx1hg
	 bXrsR6g/Ppufw==
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  Bart
 Van Assche <bvanassche@acm.org>,  Alim Akhtar <alim.akhtar@samsung.com>,
  Bean Huo <beanhuo@micron.com>,  Peter Wang <peter.wang@mediatek.com>,
  Can Guo <can.guo@oss.qualcomm.com>,  linux-kernel@vger.kernel.org,
  stable@vger.kernel.org
Subject: Re: [PATCH v5 0/6] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completions
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261022034443.3034432-1-stanleyjhu@google.com>
Message-ID: <yq1bj8j7po6.fsf@mail.kernel.org>
References: <20261022034443.3034432-1-stanleyjhu@google.com>
Date: Fri, 23 Oct 2026 23:18:24 -0400
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


Stanley,

> In Single Doorbell (SDB) mode, multiple completion and error handling
> paths can race on the same transfer request when bits in
> hba->outstanding_reqs are not claimed atomically with completing the
> request. A stale bit in hba->outstanding_reqs lets a later poll or
> reset complete the request again and unmap its DMA buffers twice.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
