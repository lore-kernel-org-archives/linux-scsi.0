Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196587;
	b=XanYehUtzz6Twyt6SXko4KkUQg2gvSxv4zrDZg3F2epGCscAh28GD6ocmmzekflnS44n
	 wslP/wR96HpTkcoBFjk61RU/8yIHn5X5nHPTDSIZ8FLYUf6A3q9dSqqhApIcItg9NoO2f
	 cUsG3r+YORs4iz4EubvpPlyKq6GpCZfxqHaLJUGeEkoVkTCTmGKXzO3ojDWdj797jnp6h
	 Tmxq29bhQe4m0NfuC0T0XsnJW3GwnC/IwR2VS0CbYWfrddHM+Y7tFn2uf9Nov4cddF4lB
	 wJQ4lzFaD2YTXo/r1WbhJd56QrOKxbHYmPyuTSYi3Zs8tGfXq6hKWfPXcYoD9gc207A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=eqVJPjpZzjsIoM0mVoqHEnHCkj7mgHKG3aK15te/8r8=;
	b=2OMKjkj7i/7Odjxnv6wJn7Zvmnh99IGx29BrPZOdL+CpRs25N7M9ZYgRuydgvZtg7pOg
	 iJdINwXeWHNia78QLMKJB13bIPg/FN7Q64G4B0o7sUwNkWs02U6Vl+NrY7ZCuO7Q8B27W
	 NKe1QX7O760bxmomx7hfonxMP5wcK07v5CIT2cMshmJRdQ78SyOy4xP5d0UWZYRGl5H3d
	 SQCHj0+WD6+7oqK+YK7Pky6VKOEHnTwMJTrn5yoin9SF3THBq7SMOQkWbXpilvIRYIYSx
	 9DoYX+Rqhvh8yugZoUFvyfqLTK3afKIAfNlwPdu0mFQufs6j98um3XJHERPHOB1OPUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="TLY/GReU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF634606D801
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 03:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TLY/GReU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31CC1F0089F;
	Mon,  9 Nov 2026 03:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196586;
	bh=eqVJPjpZzjsIoM0mVoqHEnHCkj7mgHKG3aK15te/8r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLY/GReUrwK0af8Bl+nFN3HdC1I1Eikv742KG+WzkF3jBvtERnPGlDnCHAgUE62rY
	 jrcOn0iYwBSXTT+Q8gnuwk5Edqm3JPqYvV7KxGEUvQi9AC6oLQQZNuJcdpG88b4myW
	 yJuav+jPEepnuPVYHxbEvtWNKKutYLrVcaP9MOd6DV+hr8LSXTj+s4ZCPpMGLOUfck
	 YrY+8l0NxzOPtbh7rCThdigJzbf+3QszIev2Qinp/2QwrZD7EIHx9LyZAeOnsTDUS2
	 W6sNX5ypoCaiJAqHcXZav/4zZMYMWzscRNO9dEx18Zaq6k78ZTVaVXw3ywF8AeJPhn
	 OjQ58z5n2dpWA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: vishal.bhakta@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com,
	linux-scsi@vger.kernel.org,
	Matt Wang <matt.wang@broadcom.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>
Subject: Re: scsi: vmw_pvscsi: add boundary check for cmd_map access.
Date: Sun,  8 Nov 2026 22:56:15 -0500
Message-ID: <179419636233.1941631.5827898891941440425.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260929231459.630938-1-matt.wang@broadcom.com>
References: <20260929231459.630938-1-matt.wang@broadcom.com>
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

On Wed, 30 Sep 2026 07:14:59 +0800, Matt Wang wrote:

> The context value provided by the device in a completion is used to
> index into cmd_map to find the command that was completed. To prevent
> out of bounds access or completion of an inactive context, check that
> the context value is in-bounds and that it maps to an active context.

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: vmw_pvscsi: add boundary check for cmd_map access.
      https://git.kernel.org/mkp/scsi/c/6e862335a8d3

-- 
Martin K. Petersen
