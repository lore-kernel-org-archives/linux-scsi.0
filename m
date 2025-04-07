Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0585221729;
	Mon,  7 Apr 2025 20:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744059225; cv=none; b=X3VecWdtjRICpZPs1IKqzRk8qfFzt3aEAQRIjyTDcO6NVO7MHrlFbpIYTaO0ALeDF4rEdzlnVyxWRHWe+gYaWlFP2viSmf/17RxvxPWPFd41blbsZLmW+x2dsvHfCLSBw47kC6bLPBN/5d/czuY48kAafwOA/WdSN7qtjhCbwwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744059225; c=relaxed/simple;
	bh=ONyrYfJdstF09oesH8qf4tZareb3hyXSOEj90mpSUt0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LLVpHVHhygWZ8oVjTKg3/rQ15687gFvSTSdOjqfqezWTm0Up/VEFhX7KjB4MUrTAn7cvgBiK0F7IXY32uJP1KMoyc2YqUmebqoj8EbZ83Ur/PXM++jKeg47SeFX7XiwZSsAeeNCiNSu2QPthRNON9AQFEePW8j/37SjptDD1P5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=azMaEq7i; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="azMaEq7i"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744059210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/9NxyHKb0L4iiKZ01cs/8rSz9fvN+ya3tGixgSTi3Y=;
	b=azMaEq7icYQRXd6FGqsEZPS2hzwa0KuSEQGVq38nc2ef6PzSq5qy3ULGCb2jv1EqxFa0bN
	Z4DbI0QCrUzF7O0+wPPkgCADYf7qITM0T0w0UCzMsldkzFRGSE0npNCoW2AUR5icfYx1mT
	s+gbLpKeJT8OEJcZS/jGZmt11ULSqiw=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.2\))
Subject: Re: [PATCH] scsi: elx: sli4: Replace deprecated strncpy() with
 strscpy()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <202504071330.90FC6D8@keescook>
Date: Mon, 7 Apr 2025 22:53:17 +0200
Cc: James Smart <james.smart@broadcom.com>,
 Ram Vegesna <ram.vegesna@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-hardening@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <60521C02-BD56-4BAD-AB32-561F7A1AAA6A@linux.dev>
References: <20250226185531.1092-2-thorsten.blum@linux.dev>
 <202504071126.37117C5D@keescook>
 <67E5FE26-F258-4690-A466-236A7E7484E8@linux.dev>
 <202504071330.90FC6D8@keescook>
To: Kees Cook <kees@kernel.org>
X-Migadu-Flow: FLOW_OUT

On 7. Apr 2025, at 22:30, Kees Cook wrote:
> On Mon, Apr 07, 2025 at 09:01:53PM +0200, Thorsten Blum wrote:
>> On 7. Apr 2025, at 20:28, Kees Cook wrote:
>>> On Wed, Feb 26, 2025 at 07:55:26PM +0100, Thorsten Blum wrote:
>>>> strncpy() is deprecated for NUL-terminated destination buffers; use
>>>> strscpy() instead.
>>>> 
>>>> Compile-tested only.
>>>> 
>>>> Link: https://github.com/KSPP/linux/issues/90
>>>> Cc: linux-hardening@vger.kernel.org
>>>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>>>> ---
>>> 
>>> Standard question for these kinds of conversions: Why is it safe that
>>> this is not NUL padded? I haven't found where this buffer is being
>>> zeroed out, but it probably is (given the "- 1" on the length), but
>>> without run-time testing, this needs much more careful analysis.
>> 
>> I think this was submitted before I started to explain this better.
>> 
>> 'wr_obj' is the zeroed out 'buf' returned from sli_config_cmd_init().
> 
> I don't see how dma->virt and buf are associated?

Since dma is NULL, sli_config_cmd_init() returns config->payload.embed
early (it doesn't get to return dma->virt) and before we have

    memset(buf, 0, SLI4_BMBX_SIZE);
    config = buf;

and SLI4_BMBX_SIZE is 256 which matches the size of sli4_cmd_sli_config.

It's not very obvious tbh.

