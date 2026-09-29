Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1FD2E7366
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 01:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790644994; cv=none; b=dA3u14r1Dlq2DChKb4cNp8iAkWy6gNHA30i/jooIzwBEZhjeh908I2W9pV87UxEcI2oHSiGTnLzsU3Hlqnjj0+B9YPMRwlG6USAQzGa5IznQlxoZ7CL85jwl3hVWimBYD4n0zfezn4ggNO2Q231GP+S6T8S8sD6yC6cCC1cBKus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790644994; c=relaxed/simple;
	bh=Q5Y1cEgDh/7xkPEDPxgSTnwI452e5ZyZhwMGBeZgNlc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=s571YhQH12LZE9PgcIU3kWUZLESxR5fI0m3BLVY1Q+yfnAMamh5DQQKfzLeHJVZXx1QNw2vCgIMMy6jogbiP9ykUTzkQAXOZKDd20OSQpDtaZMHqBBR+Hc7CNk08hv/6MxuPhnpa21BLK748o9L4YnL4i2BWzRL5R665zTIuiVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gH8d3vjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gH8d3vjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600E21F000FF;
	Tue, 29 Sep 2026 01:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790644992;
	bh=dNhljnoMW+BD5pvbRznBh/Coq1MmtoZ+KDyEWF5q75U=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=gH8d3vjdN/0Smfoukj8+3mfqOmE7bfx+IYsejnAwjIP5c5mEJZ7y7HsuWAsK2xFCO
	 1vd0RHFucc/E6tCIDee5FwB/FZFafYSBcyARXbKrB82ZUt/6OXQg9KdwWYyCNKMFso
	 1SaEtlp3vDySs7RGYq1KYQsj6fcnRHURN+x14Cj8DEtQKvbQCeNe9uKn3crGRYD3vI
	 i+nlns7K6Qd+GVmN5MAFd4/PsATqcTkLCsVcgXworXpUnNCAn6X+42/irZaUleL7uu
	 Ufdh0DBiSzk2mMEA3jKs4OTSHcqEaeBCGhR4a45MRyns5lHiSR1On5fsiRVcINqJ/j
	 SJ3fG/tW2xNUg==
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>,  Damien Le Moal
 <dlemoal@kernel.org>,  "James E . J . Bottomley"
 <James.Bottomley@hansenpartnership.com>,  Jorge Ramirez-Ortiz
 <jorge.ramirez@oss.qualcomm.com>,  Bean Huo <beanhuo@micron.com>,
  linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 00/40] Use defined 16-bits ASC/ASCQ combinations
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <18d98009e8d5679e.3137322e31362e3131332e313435.256270.0000sendgmr@google.com>
Message-ID: <yq1jyo4onqe.fsf@mail.kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
	<yq14ifovdyw.fsf@mail.kernel.org>
	<18d98009e8d5679e.3137322e31362e3131332e313435.256270.0000sendgmr@google.com>
Date: Mon, 28 Sep 2026 21:23:11 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Stanley,

> The merge resolution in 670f07403f7c [1] converted the UFS RPMB entry
> added by a8a34238e5e6 ("scsi: ufs: rpmb: Retry power-on UNIT ATTENTION
> on the RPMB WLUN") to:
>
> 	.sense_code = POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED,
>
> The original entry used .ascq = SCMD_FAILURE_ASCQ_ANY. With the
> combined code the ASCQ is now 00h, so scsi_check_passthrough() retries
> 29h/00h only and no longer the other 29h ASCQs, e.g. 29h/01h POWER ON
> OCCURRED. Following the convention used in sd.c, the equivalent would
> be:
>
> 	.sense_code = POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED |
> 		      SCMD_FAILURE_ASCQ_ANY,
>
> Could you fold that into the merge, or would you prefer a separate
> patch?

Sorry about that! So many conflicts this cycle.

Please send a separate patch. Thanks!

-- 
Martin K. Petersen
