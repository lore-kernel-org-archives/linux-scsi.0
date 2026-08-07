Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E80D3A3E7A;
	Fri,  7 Aug 2026 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117026; cv=none; b=l47fQbB0Y1IHrv6r9JrYXHMAem6Erls2S/l5HIzJXm0dAIXTn0u7tPXJrQU+f//5KTjOkYD9kVaY1FnmazCsnPTb2oUkrQTYCv53ye6x3gBdX1NoQwo9cpQJxWMspUMhVuE9p9smD1XgXaHWrKUiOQinGM7McTvcc4AMfLgJ9jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117026; c=relaxed/simple;
	bh=S6JuEmQUf12G5ngteZsAufLsDHpk40ICp5zGF5st+ko=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=Yb/fhunBpSn6OPOYJWHKLCIaCx9B9NwvYGcwiqbgWDPIo78YKrZln8/g4LcyQg/Jje0ulYpN8J1sbHwt/5KGeseWjpeqHTekt0Q/OgatqjvL6s6O2nf6KCkQK1U2AGcFQSNTC5WverJumc/kVRn2wWKKfSBxp5Il9/l7e1Qbzw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=feimK17c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="feimK17c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81D41F00A3A;
	Fri,  7 Aug 2026 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786117025;
	bh=Er3hjE5BWHxsgKUqgopr5rjqRH3g4/3LW36d4wK9zaw=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=feimK17cJF/RRBhdUcSCLM0BPcvzHJKX+jdP9a88RunoOpzbhK0t5T3NrUPIbA9Y+
	 WdxT3xwghsvcHx8dihWHTiygxRvTbbgW67wcdgLs3LUcWt8roX3flvZHCtPqr0eeam
	 A2pSdKJZRTBZA0dRyaXKDJGKnS6aNd9Gf+qV1jHl4P/5ZURjtqn4HMKTFx0DKUH8EV
	 zmK5znBnwqd+vcRTOWRlInyBRnEHLZdsCBUN/0Y0agwyzJRs2ELYh9Qm12lSlaSWa6
	 LVrTo0lEDl+70kz/jtr8VsmMu1JQIHFvPkOj6tKpe92REJmndBKlZK96hOpV/UmorU
	 pZRyWERY41tjA==
To: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Cc: "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,  "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>,  "bvanassche@acm.org" <bvanassche@acm.org>,
  "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,  ALIM AKHTAR
 <alim.akhtar@samsung.com>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,  Jinyoung Choi <j-young.choi@samsung.com>,
  Dukhyun Kwon <d_hyun.kwon@samsung.com>,  Jeuk Kim
 <jeuk20.kim@samsung.com>,  Keoseong Park <keosung.park@samsung.com>,
  Jaemyung Lee <jaemyung.lee@samsung.com>,  Jieon Seol
 <jieon.seol@samsung.com>,  Gyusun Lee <gyusun.lee@samsung.com>,  Yunjae Jo
 <yunjae00.jo@samsung.com>
Subject: Re: [PATCH v4 0/2] scsi: ufs: Add support for the aggregated read
 query opcode
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
	(Hyeoncheol Jeong's message of "Tue, 28 Jul 2026 18:22:08 +0900")
Message-ID: <yq1mruy2b9k.fsf@mail.kernel.org>
References: <CGME20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
	<20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
Date: Fri, 07 Aug 2026 11:37:03 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Hyeoncheol,

> UFS 5.0 / JEDEC 220H introduces the AGGREGATED READ query opcode
> (0x9), which retrieves an aggregated data packet bundling multiple
> Descriptors, Attributes and Flags in a single QUERY RESPONSE UPIU.
> Such a packet can be far larger than a single descriptor, so the
> reserved (device management) tag gets a dedicated UCD with an enlarged
> response area.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
