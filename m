Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B14B2D8762;
	Sun, 27 Sep 2026 07:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790492485; cv=none; b=AwKGkkcv+/2B2TVXW8mkec0byYiklhdkEc2YKDWBRwT/sX/3k4E9XYhGs5uxqnTsYE+yKyZRDtAbf4sKQ+tS7cs89RGibgepykjYTZfeGc58d8yUfD+nRx+cDwoGkBk/aObt1t3AYrkrfH3WB0gvlG71a6+6BgDTV9pkQkcqMHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790492485; c=relaxed/simple;
	bh=tMaA0mK3oeTw4HsFLgyNUn2AZZekYkO3RS8bu8Ks6jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVey2DxlklF5cyr8vETJ9Q+CjVyssrC4jTOkBrNvDpM9Bal5N4LdKAkMxKOdCpWTk+X7fGTH7t063Q1gUVOSCqxtvPrFArxBI3xD4thzz4aFxIHlO1Y/nO8l0sk8YuncXKdT3If2i0ct6Xc7rroDbgXzPpoab3NlmazSCR+HZ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ceMWUVoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ceMWUVoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829321F00893;
	Sun, 27 Sep 2026 07:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790492484;
	bh=Y/XX+mcoPaRwDHBEMu0QDp28TlaYYuPL8tqFhltODTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ceMWUVoP6MOQKU6B4czru+Po4yH98/3Z6uinv8mtHRPyMPoirGhLxk0Ze+5dWPWCN
	 XlekCt/Ac5siA/dnqyn1oNdTacT8ldYeOd1NoCA3ozyAsbXAtD/RGB92io9VL6U6Od
	 CqsBqZa0bScFDjINPcZDgSY+eRCY7eOlqEM8rZDjuWJFYyx6Mm/djel6Xw4NqvFOMQ
	 3Ab2s4zlRc2LbZrv9dtoWgxO8KSv5BrZDA0Og2WqA+50cNm3IXCO/6ERLRE0rNOI10
	 XvWuAdRgu1OO9MVQnjbKDXEVS+gxxdK+siC6SY738Wy4ybYWZ6+tJBB/yhFllOLZTv
	 DjMWMD2nUjmQA==
Date: Sun, 27 Sep 2026 09:01:20 +0200
From: Niklas Cassel <cassel@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v9 05/11] scsi: scsi_debug: Report the residual of a write
Message-ID: <ari_QAG23rIE6Ur0@ryzen>
References: <20260927052650.567035-13-cassel@kernel.org>
 <20260927052650.567035-18-cassel@kernel.org>
 <20260927054039.E7B7D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927054039.E7B7D1F000FF@smtp.kernel.org>

On Sun, Sep 27, 2026 at 05:40:39AM +0000, sashiko-bot@kernel.org wrote:
> [Severity: Medium]
> Will this calculation produce an incorrect residual if the command includes
> a very large LBA range?
> 
> In resp_write_scat(), the variables num_by, num, and lb_size are all 32-bit
> integers, and num_by is calculated as:
> 
>     num_by = num * lb_size;
> 
> If num is sufficiently large (e.g., > 8.38M blocks), does this 32-bit
> multiplication overflow and wrap around to a small value?

num_by and sg_off have been u32 since commit 481b5e5c7949 ("scsi: scsi_debug:
add resp_write_scat function").

sg_off (which can already overflow in mainline) is already passed to
do_device_access(), so this is not a new problem...

But sure... I can introduce a prep patch which changes both to u64.


Kind regards,
Niklas
