Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664112;
	b=G9YjqgJcQ8tC+VHTpyoCu+aTptChvam4jT1VdUmJlgebyxbZ7K7YTcBdi7pc0DRjS2Mb
	 JlyKfN7+oNplP6BgrwyfGfutbMOO9HTKU3yXqd8leFRgdClommMQ6ytF60rPx17BILkXS
	 jrkIXcXaw5X1PkHOiaZ3oucRy8Fa604v12ZbiTVWl39SFsp4mvpzjJIG1/DQN0wznbzX2
	 LRGszBK6WPiwvzU4znHyFyr3PmJs7xb3DUm/S0h4MpPR5SjoxYhHqqO5wmx+vN0Nbh9h5
	 RdU/DOcLEoPiL0yqwmEocNuWorBo87aDP2p8V3hFmCFF3qPc7Xxu8hnfFs9onJVVaHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=7adnO86G/LNaSmCpkn+/1fkJbg8WifdSBTt7x2+IFWw=;
	b=FWvHF8MyBMdDqb6mxZhwldFHHo0Qx2BNyPgY5W6Xow1PVQplgbk3vOLxhlZM77cemmyg
	 pLhIvCiconsmFYvVEK1/AzKO36pMDFqgk+6hX3wNzoHJW1bBctEzZGn4SAWpK3nRJYlwh
	 bexaQ5G9y7tFcIB37SdGK3bPhf+acAuZ10U5HBRtR82kQV82uEaerywzMAahNDkuYKRet
	 TF59V3RIO6S/mdCs44mOEcoxzI0LnMTHGGHwWd3CdK2yHOXy2hdRQ/Gp2o4RBXQtxB8aT
	 HQXGPUAIjt9sYv+ZV4iGBXWqK23Forbx7bO/Qe+zhrun0hhjpVn0dtnybtZZyfSnssg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeX3aSNG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473CE606A333;
	Thu, 26 Nov 2026 03:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeX3aSNG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD411F000CA;
	Thu, 26 Nov 2026 03:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664111;
	bh=7adnO86G/LNaSmCpkn+/1fkJbg8WifdSBTt7x2+IFWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CeX3aSNGKF2bVaRzGwuuAU9AJAFXzNpm+dy/oogaNls6AXNTayhV2MJv0AGRNlSKv
	 Wa3UBXBvEV+5dwf3Vyvw/58co01yZ/9zg/02XQ07PHtZfmJHr34OVtX2Nw+jOuigps
	 d56zCM5Wfl0VgTf7SquxOyK1uGcFR5QCtGuJlNe06anWqj3rJD58KtY/m5zz93r9QT
	 FyMrpwCT4jmf1jM5JENtyFB93aySwZIGckhCcT4kcPam7EZ+Y8MHnvT3Mwx5L8yCMd
	 n390lXojmQlnn2Se3kbVI4Ih+8avX0a2NIaKgmSEoXpDGTaYEecd929t1bcxNCT79t
	 t5Fxs0dRmBK2w==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Tal Zussman <tz2294@columbia.edu>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] scsi: scsi_debug: fix zone reset with virtual_gb and DIX
Date: Wed, 25 Nov 2026 22:34:53 -0500
Message-ID: <179566062800.467514.18281232090391526941.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261116-scsi-debug-zone-reset-v2-0-83c8a9841f4c@columbia.edu>
References: <20261116-scsi-debug-zone-reset-v2-0-83c8a9841f4c@columbia.edu>
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

On Mon, 16 Nov 2026 16:06:52 -0500, Tal Zussman wrote:

> Resetting a written zone on scsi_debug zeroes the zone's blocks in the
> store, but does so with a raw offset that doesn't wrap around the store
> like writes do, and without resetting the blocks' protection
> information. With virtual_gb set, resetting a zone that starts past the
> end of the store oopses. With DIX enabled, a reset zone can't be read
> back. The first patch makes the reset wrap around the end of the store
> like writes do. The second resets the protection information of the
> zeroed blocks.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/2] scsi: scsi_debug: wrap around the store when zeroing a reset zone
      https://git.kernel.org/mkp/scsi/c/78f28a31d7d6
[2/2] scsi: scsi_debug: reset protection information on zone reset
      https://git.kernel.org/mkp/scsi/c/021fae688d1e

-- 
Martin K. Petersen
