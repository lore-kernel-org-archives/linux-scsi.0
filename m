Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0505BA92E;
	Tue, 26 Aug 2025 05:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756185006; cv=none; b=S4JwoOoUPLJxHy4b72NLGS5KHQCgEwbUnW8QmlI6tDw5+cJdKaSydYUPiBb7RkrcAzqars+4wJ2RDRgGkB2KAsLnCYRlIb8Nc4ZHbppjYrU265C+945iAmdyJ3E24kTEPDgPGOxu8ZelEUHRPILw/KA2td7g6Ybvt5oZxPD56yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756185006; c=relaxed/simple;
	bh=0GDYshJH2dENjEzqGPH6OZl85xajSPfIw+5++sTXWEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qr6B66en5yYDBKhffkKZ5lTouswGf9kVbffDJfBXGuvEnMHxv+RJWsH7CXfBxKKwEsCm+bYSZ+wrwKyw3kxacUxebRTYEjYAEaWmooCuN/5ELA7V1xK8V7O5IMf3RS1TSLqYfJKGSHcYRzIwemy45f/O75Aub9bWuKEyCZYrSNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVnVrWRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVnVrWRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E94C4CEF1;
	Tue, 26 Aug 2025 05:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756185005;
	bh=0GDYshJH2dENjEzqGPH6OZl85xajSPfIw+5++sTXWEE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cVnVrWRbIDx57K8+gYXDjHqI7i2hZE/s3wJSrJagOrIXb3cBoXLwestuK3EsdvShm
	 ge0B/yrxa7CvUH3xt7b9+B2e5J82Z3/hY3PJzbtOmT+LGgq1q00jS6STz7tzkRHadN
	 gq17ddWp3X9pMWeDPGM+ZbvgeqsvICTE/6/2wTCr90BaB34XKpnTQBYm17puFsbrKR
	 66DtaGkfFOMs3zJGEExsoMlPrZj32h/0+xyCikf9Ocgpp+jvuNx4BO5Tpwp4O1rNpH
	 YRxo4lkXIQ4WKA0dnPmOZwSykYEt/yhpmYQMCw1GRP41NZ4nF8yv75bDcLfixVbwU+
	 mpE92sFkiIFHg==
Message-ID: <a618bb76-af82-4b47-a68c-8fc83cad97cb@kernel.org>
Date: Tue, 26 Aug 2025 14:10:03 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/3] scsi: sd: make sd_revalidate_disk() return void
To: Abinash Singh <abinashsinghlalotra@gmail.com>, bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
 <20250825183940.13211-4-abinashsinghlalotra@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250825183940.13211-4-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/26/25 03:39, Abinash Singh wrote:
> The sd_revalidate_disk() function currently returns 0 for
> both success and memory allocation failure.Since none of its
> callers use the return value, this return code is both unnecessary
> and potentially misleading.
> 
> Change the return type of sd_revalidate_disk() from int to void
> and remove all return value handling. This makes the function
> semantics clearer and avoids confusion about unused return codes.
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>

[...]

>  	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
>  	if (!lim)
> -		goto out;
> +		return;
>  
>  	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
>  	if (!buffer)
> @@ -3823,7 +3823,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	kfree(buffer);
>  	kfree(lim);
>  

Nit: please delete the blank line above too.

> -	return err;
>  }
>  
>  /**


-- 
Damien Le Moal
Western Digital Research
