Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795661171;
	b=uMJUx1XpOeyKTT+uDopYpMRBskDjf0JE+hT+nmBiAXKd49GZSENE+glwuobQy7th3lo9
	 QW4MTLf6dvUN3RKYlgtTgRzzxsnmd/6+wqZISOslSEaACrr4T+lyb/vOi+0Qc/wxbtupX
	 a3Tq1AdfAkr8T1Ys0nPf/SXrdxzpUFH2t8dAnP+je2koMca2cM/oujgtBJcRdRyCSgf7V
	 Y+W0z9Vxx4N1Y4u2rXqEAhPEmfVTPP5m0VqxkC5Awahlr7pransas6GOc8tX7npwgLU/B
	 R8kGkmfKm0UuElJT0lfVG9uZYu/1NgdbcsnxAZt/sz416fxQc13pMpeiJ2TsLe11RxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795661171;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=HadmPbGdwuC9xstk8DEdTWbJDmbpSnd6oCqgM+5muhk=;
	b=DHOMuhtlZQsOlpUGV1E/MjoFukDbCFEzkYAVuMokhYde5MRfHWpU5B0X9FvCAYI8u8CG
	 UM2pSMBAJHTMxtqUCqHNHm7usJWwR7yMxma9WP3e7UzgoW1aI5ZPbO6KUS/OAFkMkdyre
	 7qJuABUCh17w5iYTUTw6KCOUWnQM8FTYceqAf86gvkcUQuEEFD3CK5Gua707CKKayYc1k
	 BlVXizTAiwFKXHmiIcJLCcOEWu02UugwjkQSwupvOUCTwoRwm2d0+87S0CYdDXfqn/uZf
	 /yP5+EeWO8ylYPQAFujigqE7jfHeHzUczjClmKV/G9Hzt6ZjT+R7N68Qqy0NWvvlFSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWT7RJjj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE97606A321;
	Thu, 26 Nov 2026 02:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWT7RJjj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5530D1F000C6;
	Thu, 26 Nov 2026 02:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795661170;
	bh=HadmPbGdwuC9xstk8DEdTWbJDmbpSnd6oCqgM+5muhk=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=LWT7RJjjWMY6TlTAJlYLtaEVkDLGKO+UM4Pjsmd3GdolJfgDEji0jgpERsPc1KG/G
	 XGoSTFriavsgc1ONm4OJyI0Z5U5sVYHy3RXV3aboeKRxPMVmSNDuCFkfVVt83TPiQ1
	 WeF6KGveKvDITJSFtDj3qulhKUwHuEyZJ7HvGQ8DxhvwsANsY04Jbv2utqHQoD8AZK
	 F7NEYFALYAxOtmWzkRLwdSL65R8FkOLNUipC6pv3Ki+PsVr9S593f/WCfUelQjSyfc
	 JqOyQ+geaDv0SrJU7VoT+9mxCjGejB7Tx8rGz4Xvz9bKd3fP9AAg02zgpICAyBMM1/
	 Onh0fxihUUqCg==
To: Po-Wen Kao <powenkao@google.com>
Cc: linux-scsi@vger.kernel.org,  Konstantin Vyshetsky <vkon@google.com>,
  Randall Huang <huangrandall@google.com>,  Alim Akhtar
 <alim.akhtar@samsung.com>,  Bart Van Assche <bvanassche@acm.org>,  Bean
 Huo <beanhuo@micron.com>,  Stanley Jhu <stanleyjhu@google.com>,  "James E
 . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin K .
 Petersen" <mkp@kernel.org>,  Peter Wang <peter.wang@mediatek.com>,  Can
 Guo <can.guo@oss.qualcomm.com>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] scsi: ufs: core: Add debugfs for PA TFS/FEC
 error counters
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261125113435.1426680-1-powenkao@google.com>
Message-ID: <yq1o6bcjonr.fsf@mail.kernel.org>
References: <20261125113435.1426680-1-powenkao@google.com>
Date: Wed, 25 Nov 2026 21:46:09 -0500
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


Po-Wen,

> This series exposes the MIPI UniPro v3.0 PA layer TFS/FEC error
> counters (0x15C3-0x15C7) under debugfs:

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
