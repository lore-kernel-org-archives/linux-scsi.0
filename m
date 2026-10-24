Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792809491;
	b=OmPGOLIxG4hMaB9MP7M2MdYSBBh8QFxP8ODlE4SmIElmzVfgLv1ReoP/dC4tMfwlj/AL
	 ma9p3TtfG+2EUIU7xsG0xAM+p70yiVrFsXxpc6Km365FFbZzBvI3UR2lMoKQks1SJKVlN
	 CIm+p1KKRD/2IytXtoa75+1BesfKGsrkNTGNNiPNhqORLij31KNXqovbPHs/wmttzXogq
	 TLTLpRoJXg/zIGYFMhCxKQCtLMMpbW6/HZUDioD8PZ1tfp02GT/ZHCLsrsEyIttcO35QC
	 dCOotmMuQyCQU96azflGekdBxFhWpXg1I7CLaFGwTWBBzvnBDw0+ExhreXpv1i8r86A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792809491;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=c5id30oTYM0ztO+UBLDYp7pfTP6bBbNriOd2eI37uck=;
	b=N0WC7lMQ/XlY6egmDEOdGStpEyJjSeuQBpJpWZD2uCSGNpvJ/yvNnplR2FuWDhWG7ic1
	 3pWQ7vyKTnwKnDHgD2NqVnoPC8grMBwPKI+b3x0WImAX1/REMmPdMxaAD9DhmN8jRDXpJ
	 QKGD7iNggddR1abi2Dx5JE31K2IC+98aGMkOyNlNbNT4tpNtreKEK8w87ljll0k4Oi2Je
	 wjXzfvZpunP2ufM7i8/Bp9T+RbmNfAFsRfwI8DJJhUGZHwuqcs4YN0tJ6B+MuCx2CfmmX
	 vkHaHuTHcEZiLIsJjRx7eBPcIBsOb3Lln+yE2/dQLbxBt6ejrFyXh4RUZdb0n6C4krw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nsv/OxOc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA07606A31A;
	Sat, 24 Oct 2026 02:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nsv/OxOc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E4C1F01825;
	Sat, 24 Oct 2026 02:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792809490;
	bh=c5id30oTYM0ztO+UBLDYp7pfTP6bBbNriOd2eI37uck=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=nsv/OxOcyXgYoyrHXrDfjMkcUIMX8mK8WF7+B4x/cp8mlxQ2bFG4QTfe3xuoGLpBD
	 85A32USX0hkxgyKkcLwWmcR6GXg0vvBm9kPeFu34GaIFsbtImOPfpyZujSaACNWxKz
	 8LyBXq/zDOX7Y5ykVBSb0x4yX3zZQnZ3ElIqRWAyXx2azOE+RxUNQGGIZwLNAghW3Z
	 0VZWT76xmb45dclO62KEmx2SObA2EmD0aF9S/fZ+tX8Upk2a3QN/+1DZvGaLKhjv9C
	 W6zlrUpmDzBE5ww0n7AGu8WAQ9Xs3WCyGyM6r70XlcYHttLPpbTdK8BDLlgqDFXiEx
	 VeloFXTUHlelg==
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  Alim Akhtar
 <alim.akhtar@samsung.com>,  Bart Van Assche <bvanassche@acm.org>,  Bean
 Huo <beanhuo@micron.com>,  Peter Wang <peter.wang@mediatek.com>,  Brian
 Kao <powenkao@google.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] scsi: ufs: Fix UIC result byte and BSG request
 handling
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261015001855.3450573-1-stanleyjhu@google.com>
Message-ID: <yq1cxszakna.fsf@mail.kernel.org>
References: <20261015001855.3450573-1-stanleyjhu@google.com>
Date: Fri, 23 Oct 2026 22:38:09 -0400
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

> ufs-bsg fixes for issues found by fuzzing /dev/bsg/ufs-bsg* with
> syzkaller on QEMU's emulated UFS host controller and in review of v1,
> plus a fix for peer DME retries.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
