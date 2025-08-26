Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D48A92E;
	Tue, 26 Aug 2025 05:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756185055; cv=none; b=apVOLtZo3hxiW5Pje1XpDTRVjHsOdHpzdzZ+poQpnmOd6/UnTJRRQSdF4ykBMylha8QSq1Nv8bOjFCdBCjpPwRcIXxyHUUvsI3eo2zKYdkj0NH0144BBZMwBOznf/aa47029j/vC/n3wrCNECH9Aq9scrbfNkfVaTfxDV04pAqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756185055; c=relaxed/simple;
	bh=v1dtpNDXVbTZUKjNm9xdgQfLoLFeIpUPTXebDaiGii0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LCbfBq34ct2zJiQnKm2Y2mxRSjqBTsnDBMIz+U17lO2LcWhN5b+LWq54XT9bnLLs9KVWMCQJTYAeLuCizmBhcmVhxff2LLU5jLks0uZbvcNd9M+Azvk4Vjv5vrh3Hw//hrB9jTeEcWlzu9xOyZdb3rq2aTwxGhLW/8XhNbrH50w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cd/PEIHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cd/PEIHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10232C4CEF1;
	Tue, 26 Aug 2025 05:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756185055;
	bh=v1dtpNDXVbTZUKjNm9xdgQfLoLFeIpUPTXebDaiGii0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Cd/PEIHrLoC7DNtpPBQdsFx0fxtyarbgz1Qe8OjL/oH7Q/1zPh63y3YUe7kvcmogD
	 MXuKGcm6ntm8yIUrm8TkxuAdHFL8j9asVfeNN7V4Rr8ylhDMn6UpvE+KKsWc6LN5NG
	 soHIJlNt38ro0flhSGK3u5+YhcQNHICoBqj8sJnuD1EiFuELkDgrPWkGSa12MVri08
	 v10Wk9G48rcGk5TvrtJdjQggYqGLvy0CeEhAQM9e7RPAyV78xLvynj6h1EBrjQZdVt
	 mtRfxeG2QFuS06wM33C9vwpT/dwKsGamixToNL2nkrG0nfWWrk5fhuk2Na6Ux0N4S8
	 7ag1O6cPmc87Q==
Message-ID: <6fa29979-7432-4587-814f-ac639868c216@kernel.org>
Date: Tue, 26 Aug 2025 14:10:52 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 1/3] scsi: sd: Fix build warning in
 sd_revalidate_disk()
To: Abinash Singh <abinashsinghlalotra@gmail.com>, bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 stable@vger.kernel.org
References: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
 <20250825183940.13211-2-abinashsinghlalotra@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250825183940.13211-2-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/26/25 03:39, Abinash Singh wrote:
> A build warning was triggered due to excessive stack usage in
> sd_revalidate_disk():
> 
> drivers/scsi/sd.c: In function ‘sd_revalidate_disk.isra’:
> drivers/scsi/sd.c:3824:1: warning: the frame size of 1160 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> This is caused by a large local struct queue_limits (~400B) allocated
> on the stack. Replacing it with a heap allocation using kmalloc()
> significantly reduces frame usage. Kernel stack is limited (~8 KB),
> and allocating large structs on the stack is discouraged.
> As the function already performs heap allocations (e.g. for buffer),
> this change fits well.
> 
> Fixes: 804e498e0496 ("sd: convert to the atomic queue limits API")
> Cc: stable@vger.kernel.org
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
