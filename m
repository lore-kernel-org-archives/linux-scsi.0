Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795663571;
	b=ibqbgXSiE6uFmvLoXTaehXNOFiKGuMwZtc5TZCMdQNBdha55Ys/BlY4llizrTSx9V9Nz
	 UtxYSK/d26jnTyfPpf+e5Pr93NGYk0gMOw2Xk21tgxnGsZ2yl2YERI7QxtLQIsuhtRtc4
	 zh4pZ+oelo6Vhq16mye+nm95OCIdwjRK2zMy51aS05m8RxnIYNZf9vqx8rrLlMhG+BTtI
	 zJb956k0/NOo4RllGTGyEh24Rh/kNsyE+73DMS40CC7JCJPiTc/uGSnOOM8o0aHSOEwiE
	 zBtnH+E9wgwAN3r2ORAi9fglks8MEzfP8Z9+C8NiiIpIPlqF4ioiAtj4QN8gx2sChNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795663571;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=ofJy08aWX1//YrHoygi/IkjCsi3MA9HBCDQXykemzuY=;
	b=buUu0+P1E+5hwzieL2v/wrcexImNiG5tTHK5pidjbgusZpvwy9CQUrg7p9fqlJjG4v74
	 YzpbPkEC1zcLaZvfvJGnmM0JRi5Vekt3yA/7QWbSzUumLJpwEC3tSjlre3/q8jIi8Gq0h
	 Q96LAOzJbP23dSbhOiUHLEmPSHRTroutS50WvgViVvMxfonOFRfPPpdXbt0rcxqz2e/D4
	 CuVGEHInsIuaMauiZmJ0jMOMeh7f4nD8aKojmnwiOzhINRwpqb61i87OItx0VmnDxyiav
	 YTIquhDQbpXaZquZJH164EQy21Sh/SFmmOENN7UHIqDBdSAN9zT8x1lcUSic6T9bibg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GLrXlgFG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0833B606A31E;
	Thu, 26 Nov 2026 03:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GLrXlgFG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C245D1F000C6;
	Thu, 26 Nov 2026 03:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795663570;
	bh=ofJy08aWX1//YrHoygi/IkjCsi3MA9HBCDQXykemzuY=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=GLrXlgFGpqdk1+lX+eHjW0IqPI+8at1Y3kYciPFt7X3TYN1IQrBZmph+i0hntghM2
	 17OUOXX6kmRgRRDZpRl1+eiBb4owmtjaT1eK4Wh+PrVleJ8L7rVoDjf0t8boKetB16
	 7SMw38QDMKyJntDxIBBb0QmxIiSA4zt1N/eD7oPy6Auc/bWOel4MQy9Bc4cHzh31ys
	 fXSWW5BIC7JWW9yKvmS3UenSF/LGQqU0bZtPMjGmQ9L7WSZ/7zwRlOZ+CeLrFZ6cso
	 FULKOF45mlbt5u9lP4QN8/AUp4er9E3WlUWU+6frOUPlc9Z/swBANxVQ3ncK/UDFi4
	 dCn7AEL/WSutw==
To: Ziheng Wei <zihengw03@163.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
  "Martin K . Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  linux-m68k@lists.linux-m68k.org,  linux-kernel@vger.kernel.org,
  stable@vger.kernel.org
Subject: Re: [PATCH] scsi: 53c700: fix invalid frees in m68k driver remove
 paths
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261122160447.519889-1-zihengw03@163.com>
Message-ID: <yq17bi0jmt4.fsf@mail.kernel.org>
References: <20261122160447.519889-1-zihengw03@163.com>
Date: Wed, 25 Nov 2026 22:26:08 -0500
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


Ziheng,

> NCR_700_detect() stores the allocated host parameters in
> host->hostdata[0]. The m68k remove paths instead use shost_priv(host),
> which returns the address of the pointer slot and causes an interior
> free.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
