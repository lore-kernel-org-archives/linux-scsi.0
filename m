Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794193637;
	b=snCSZIQFqfnky/L+YG/YIEeU10igTPZEz7zaU/ut8pA26KDhKsOtn+wr/zcgQY94BnPC
	 OYZwUzPJZt2uOtg4Zkeke+W4PhdkOCeyjOfscwsTpO+nD61PS34cr8FUKlc7jbjTEJ161
	 kI8/pModMxrcVTNt0DOz46Ph52UVrjh4oIuPutOsZ4ABoWlr1id7XV+kmHoen4yENYhsu
	 c0aCZLb4DBTDEUMxcvuRBxFWfVstUdVjDOkTsM1rcn3pFrpMBFdWwhSjqef1cGVo9fldR
	 bhqhgsJM4OkpsSfptZtpacDrDl1wF7BfnE/++MQqFCU4yXquOykHiCCJLkkmnqmZN1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794193637;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=tXMZ6wp8qnNw8G9zXiBRVNXZMZFtUxGC6RrzObvihVU=;
	b=k6uDygM0+eAjoF5XgEdUkNQ6u9TLjDQYeeu8F347XoQ9x82DB3HbmpB799J69Exs3LTM
	 f14zZUJsMjfyJybJ3rjcxOLYvgs3IDkZ8joxCxWtMDLPcWrQGs2pFAIpubg8mA+4EDsCH
	 iDW1+Qw/A8eMJOILT8R1uH5SrCsl1BcVQcm6J35xUa8BCDDly6Gqh83zRfAUkb59aRn7T
	 gG9BJfIDbBZJGlBemUSuoJQuDdilPFu8EPCNb8rEr3k4SEgj7VcKDB/9rbaihWsV13Rvm
	 0Fu5z6v7/62lKMeiZwmWOHY23PmMocf+sSJS/mPzyB42xyGZPl5SKSzECX71y6KAPug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CmVXxU5A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC00606A321;
	Mon,  9 Nov 2026 03:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CmVXxU5A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CC71F008A1;
	Mon,  9 Nov 2026 03:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794193637;
	bh=tXMZ6wp8qnNw8G9zXiBRVNXZMZFtUxGC6RrzObvihVU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=CmVXxU5AdK8vGLK3+OJb025RFcYODm1eBFVAH5vNdDmICr2AvoeSY+cOHfSXAhc65
	 68Ih1XeZseBMSueg1re/bakQCdlspYoOoIs6Ibdxc+Jeg6Trh73cZmz8rVE+0tj74l
	 v4q9vaY3YNCTys4G9sO9iWPl3G7EWfyVqwPDhNL7SvJDZJpXI5XJdEh+ywylzzXqQO
	 Cw5oQyQ7HjwBCS2UC6UmIvrMNHmZC3RLykoaBkUXkR4smO7Vl2xUYScI/1d49nMG3J
	 BLVF+cfNaPgV7/pQ8AhdKO1Sa9YqgY9Cc/GPd89/ifKY67UWEvEX4C3Vtf52odWvL1
	 n9DpBmZN7RvtQ==
To: Jesse Taube <jtaubepe@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,  "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,  Nimal Prabudoss I
 <nprabudo@redhat.com>,  jmeneghi@redhat.com,  Nilesh Javali
 <njavali@marvell.com>,  Manish Rangankar <mrangankar@marvell.com>,
  GR-ETH-Storage-Upstream@marvell.com
Subject: Re: [PATCH] scsi: qedf: Remove unesseary function call
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261029160443.904468-1-jtaubepe@redhat.com>
Message-ID: <yq1qzguwvmq.fsf@mail.kernel.org>
References: <20261029160443.904468-1-jtaubepe@redhat.com>
Date: Sun, 08 Nov 2026 22:07:16 -0500
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


Jesse,

> The result of `skb_transport_header` was unused. Calling this function
> warned when `skb_transport_header_was_set` returned false causing a
> panic on debug kernels.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
