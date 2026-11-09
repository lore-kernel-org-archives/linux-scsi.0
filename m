Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196551;
	b=xxSesolTFAlaQ+/Z636fA/yCS4lK2V45wFQvqCGNXcsh8sNE6VJwcyc2HdYJLAlInWZe
	 vrwBJRgWOY55nVtuu+MhyM6jYzYeuuFOW9r6Ar4JUeEHARe4cF2DhsoHt6dYoS1B3hep1
	 1vDotAFoxDsmw/D9RfoqRYCXE221S6QiUlNabsmOI0yxE72m4aKB95mKPJRT8O5K2D2ls
	 9CYoWjI1xK1LthGBobNIElp3RFVFdkgRIYyHMPI4d9Y5YsBxmFAvAiWrfSuvoifcvFX/J
	 PGi+MaD5F7wZpHJsPlkPaIXaWKRJjqVOn0E96ud5xVgbdSeZnVVTw09R2/57dZp6a6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=yl0cWu9LSM4Hk1hkiEXe0iDaWO1AMImJZAKH5kG2YLk=;
	b=VBZp0BeCkd2Q5HGQGh3avjb+Ijm2Dbtg59TK2Lxz8O0ZstNE2Udp/YUXJcF/kBG0cO+f
	 cbYbJHiKTf93nuQJXQnO9jUB0WK0AxbeIOtHhqVHQlPhhn4BpTfFUMeU2FHGdZ7FdHzwy
	 CHe8lLFq191zRLa1Fk/R/twBNnlb8fVasP7xosfPqTpVKE3lvbIODgf3CfFJ7A2FY7+Ns
	 unlKsAYqqNz5PJ3hl+rHPQfo2AP/gTIHVBkqq8H94AeAVpxkSEj/DeO1zg5gOCFgZKL2v
	 nchScOOtl7Ewb05PrTEhiECpsYIgFgFUiUmuR7oxXx3KBSaBWXXGT11kfQgRCYiE/TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NvG8DIbf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B802A606EE99
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 03:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NvG8DIbf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96781F008A3;
	Mon,  9 Nov 2026 03:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196550;
	bh=yl0cWu9LSM4Hk1hkiEXe0iDaWO1AMImJZAKH5kG2YLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvG8DIbfnBPyzmILgsdKqCT7Gp/waww2aP4aFnUenQChZKmhqqri7fKo/djgrEPKb
	 OeAFZeuP5t5Z2Z4bd+bORzxIRzWqHIuN3BBIi82EWzhVTQI5SdHzo3IsccsQEZbYYi
	 CVAMl8cZV6LASWkQQN2y+b1pHC6PhzLT+UrXVbhXxDDj7dvGrpqb65SO9x1evvYCqa
	 cnrKGlOWNAPSZq18imP+lTz8lwlvVU3E75GWMVyGfUY85wWai38Ayq0T56P46o6C3K
	 dSIR6Cmt/U3iw0gR6g1YQZGcYOC+b0B3AtewDaGN+OYcrk70GBCI9FvXOzIvzpDiWI
	 jmneZSCOd+PGg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Shawn Lin <shawn.lin@rock-chips.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-rockchip@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: rockchip: Improve RX noise immunity
Date: Sun,  8 Nov 2026 22:55:31 -0500
Message-ID: <179419615225.1941224.6496447799725433464.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029151030.1.I61cd43e660b146e49d4380a754e936270e5fb6a1@changeid>
References: <20261029151030.1.I61cd43e660b146e49d4380a754e936270e5fb6a1@changeid>
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

On Thu, 29 Oct 2026 15:24:55 +0800, Shawn Lin wrote:

> Program VND_RX_SAVE_DET_CTRL for each RX lane to raise the receiver's
> tolerance against short transients on the incoming signal, as recommended
> by the Rockchip PHY team.

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: ufs: rockchip: Improve RX noise immunity
      https://git.kernel.org/mkp/scsi/c/c84374cf4d2c

-- 
Martin K. Petersen
