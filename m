Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664099;
	b=33hxHbzqTr9NMzjY1j7GkhyAFFKhAH6cVWVKCF0W1Or7sBLGOts6HvmDgyeD59rcydL+
	 PS6MuM/8h8434bvtVf/IKefnNZONeILrNq/yTYhcpanfoE0AyoG6bGGXYHZECyPWH6Ncf
	 VUJ0D/B9MiYNwBS+RxLkIGgSy+PISzym6NtAR3vxwp7/zCp1bAyFMzqa8Ug0boI4JcEwD
	 rdzfLRW2RIkEhe/DPN3eSBsmLWNiQRq0/1VPF4IZ6rNn/091KLF7iXqVp7u0/MkMM9Hid
	 giePQGJG1dMoDuIAHH8cFLjuK9pYchaOImPqGJcBsOYIJcZSQZ2F9K2KbcabPLhoUDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=7b5Y3CQvtGHz1i3oTx4UCSTiJ4cHifax/NgRjeHgRpw=;
	b=ql+oy94VN63EHCNmXxo9pUz/bjjTyQxLhSP9vi4DwWZ7SpOdt1yZJOtLyPY6q+uNIbnJ
	 VW28/W+HQ2+Rroh39H36v3wc7+jWM6zZPTGrf3B6Jgck40oOw81owIoJJC2bYUNqt4Iia
	 xMBwsKvDkSLVNrvMxbJe6h/hxyyPfe86oWrVq2QrpdHfGL+Ep8kVFOjBHgxAc+ttuSBjL
	 arITK+4aKrBgZMvNl3EcGk5HtHJp2t7oym0bN8mMB+9VdnE8MJP3CC0cMvS2o0iz/59hd
	 eiGYKpazSQ6fKeO/sjV8aCimFZfxkAn5fl8/onritYly8GlE7ke2gfmaXyC3QB4CCwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WguUNT0h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F82F606A31E
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 03:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WguUNT0h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7321F000C4;
	Thu, 26 Nov 2026 03:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664098;
	bh=7b5Y3CQvtGHz1i3oTx4UCSTiJ4cHifax/NgRjeHgRpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WguUNT0h4RVHxqROrLCP37IEbPzH14iIiDAggxPaXqR5WLgj7lBdMmg5QsGU6I+tx
	 lFgfUcmjIlTupySM+UdD0k5J7ROf1luPvzdTReG8HYq81sYMBih2AJOEqhqQ6+wHsu
	 Ft8f9Za6IFx6HkXTdy6jLE9DWTstL+BxZxsT2peEEilTCdsxFBFtx87uPW8vHLStOT
	 k8VBKTPuqktjrBG6HUTu0qeOkjTBL9w4he2+lY9sRh6zhTqWjarWKmUSAmlTlJg04L
	 YTcglWa9eGCeWNchfAm3WPzd27WNuHrePwX5aXA+Jmne3c7T7GkPb5qAeDGHu+6Obd
	 BVBDMMSAtVxxg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	HOYOUNG SEO <hy50.seo@samsung.com>,
	John Garry <john.garry@linux.dev>,
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Subject: Re: [PATCH] ufs: core: Remove the DMA addresses from struct ufshcd_lrb
Date: Wed, 25 Nov 2026 22:34:45 -0500
Message-ID: <179566062776.467514.3455347121039745230.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <cc98d54dcd4a98fead25db50c5c6aec2dd65d595.1795135853.git.bvanassche@acm.org>
References: <cc98d54dcd4a98fead25db50c5c6aec2dd65d595.1795135853.git.bvanassche@acm.org>
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

On Thu, 19 Nov 2026 16:50:57 -0800, Bart Van Assche wrote:

> The offsets stored in struct utp_transfer_req_desc are in double words
> on hosts without UFSHCD_QUIRK_PRDT_BYTE_GRAN. Using these offsets as
> byte offsets to compute ucd_rsp_dma_addr and ucd_prdt_dma_addr results
> in incorrect DMA addresses. These addresses are only used by
> ufshcd_print_tr() for error logging.
> 
> Instead of fixing how these addresses are computed, remove the
> utrd_dma_addr, ucd_req_dma_addr, ucd_rsp_dma_addr and ucd_prdt_dma_addr
> members from struct ufshcd_lrb and do not report DMA addresses anymore
> in ufshcd_print_tr(). The contents of the transfer request descriptor,
> the request UPIU, the response UPIU and the PRDT are still dumped by
> that function. Remove the local variable cmd_desc_element_addr from
> ufshcd_init_lrb() since it is no longer used.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] ufs: core: Remove the DMA addresses from struct ufshcd_lrb
      https://git.kernel.org/mkp/scsi/c/ebdcb02c8a2d

-- 
Martin K. Petersen
