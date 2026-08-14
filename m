Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768AD3AAF78;
	Fri, 14 Aug 2026 01:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671744; cv=none; b=oyieA4OYlKbm4UNNz3lYbcezSWfRqeBTKkcF838obC//VCkclsje1dwriic5ZuIVx70vdMeAb1rQ1EJC1+2mYadGFW0Ge3Bb3cibzAIR9W2DqoaVcS/HJoY3cDkP8jf9HqweKxDH3qGdQMIQlWPG0peIQ2UiHbFGvDw6AiuTi00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671744; c=relaxed/simple;
	bh=QBOe1hJsV3vhsKMmakTtq3wS47Ua7HlK0Z30Mum1XwU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=sQpub5885nOVHk7ewJqyc8wpPYt542cwUPdBS7cnxsR6bSuSLoloVc9F3AlZkkoTTK08gC3b1vj+xUfp8sQq/HnO+rrX/ResmUX+3ALWbi1c51OWPuqaYfF+nKRakM2ehpvR6HqcLt4V3Wdy1tccKJSEyRVJPdCTxaxD2JkUQBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1mhaQRv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1mhaQRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95901F000E9;
	Fri, 14 Aug 2026 01:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786671743;
	bh=kUM2YECYY7pis7LfHLFkM23I5Eqpf96+SMSzqNZignU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=C1mhaQRv7/HcKfM2CLtoMG3Q+9Y0iE2mdrWntgbf8EPgXxOAFKbtt67LkM3SX1oom
	 +Fbtel+X7cPbZWWdUn88Cl21YLDyqN3qUpIBaFGW4DKO5fbXK2oJKc0ZzAgDCYOf07
	 qbrQ14+lS4+B7COeu5YBuJmZsmV1rm66NVCW4IHU5NYTSSCJwbxYonrhwIktK/btRL
	 jBBebVgyIppv5rLCY33JaJMwQ1XDQ5iXs0jgXM42DbhO08gyrZ8Hpwv4OAo7QcQb+t
	 T1YHfIHJtR68Trk93nqaLMqDbDI2mPDXQX6fROn8xTqc2ba5QdxfUM62tr7GtsR7Oq
	 OZkyemYnEPkTw==
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nilesh Javali <njavali@marvell.com>,
  GR-QLogic-Storage-Upstream@marvell.com,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <martin.petersen@oracle.com>,  Hannes Reinecke <hare@kernel.org>,  Manish
 Rangankar <mrangankar@marvell.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix size_t format specifier in
 qla29xx_process_rd_image()
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260811-scsi-qla2xxxx-qla_init-wformat-v1-1-50760021914f@kernel.org>
	(Nathan Chancellor's message of "Tue, 11 Aug 2026 14:39:51 -0700")
Message-ID: <yq1wltttr4c.fsf@mail.kernel.org>
References: <20260811-scsi-qla2xxxx-qla_init-wformat-v1-1-50760021914f@kernel.org>
Date: Thu, 13 Aug 2026 21:42:21 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Nathan,

> After commit c3930ec119cb ("scsi: qla2xxx: Add FC operational firmware
> load for 29xx"), there is a warning due to an incorrect format
> specifier for a 'size_t' variable when building for 32-bit platforms,
> for which 'size_t' is 'unsigned int':

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
