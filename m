Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33716274FD0;
	Wed, 16 Sep 2026 02:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789524186; cv=none; b=UbpzGEGJtTJo5t/4vDyj7pyoGHo41nYounL2wn1uuquvEYxR2XMh2r5bakhqbWGUVMxQuC2ZaHw0hFGIX1WMXYKUgDjQHsbanWLuUuHVRu3APIi094ooaBo6lypQoJg/2RZZRLbZVOszYOhsTyJlnE9DBbUqb+4tqcxJ6G54OUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789524186; c=relaxed/simple;
	bh=V016nywrHk7syBiyvLKCyLssOGPXtMTQ6NJRasWqgSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WCY3r1IHH+RaQBJ45MrchLKQOJHQqsp766PNkNwauyehr+zEZV0mHunHz3HPo/iPxGGgHP4cQ/GvNwFhOG1z6jEyAAxPjS+fNe/fh/vSo1zdm8ESCoI5WTGAixyxOI0UU+mqWxrAtM6O6Qjpm21HRCCZ5AWePBs9Od32DiGZbmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cv25d224; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cv25d224"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52BB1F000FF;
	Wed, 16 Sep 2026 02:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789524177;
	bh=4YA3Yt3U1vmZa0R3oGDZw9VKqNNiagcekSwAqaYhk3Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cv25d224qdYcWV6V5wxMB+rakJ+Pdcfi3t6iaiHJV+UQUXu/lrjOh3nvtXuc2K8bM
	 e8rzWP0fjHzEItYc+K7c0p5YYAhYUIqP5tATvRhP6t8Ob9yWdUHDiCGlBhhgNdryxW
	 k9S2+3/kAdKSAb3WWnE2yyzJcTR0JmrxFUC0Cm/H4KwEwc61PE1FaoSx65a8TnQdFM
	 5HP80d+syPlXn092PJh6nAToz2SnKFw3hdR4wNkxSz6KdRs+924/qlg9VfReJ/gMPy
	 mD3UBqNs2r4MjDgdx25ln7YcJtraeSHHgfWUf7sUqXlKchjHyAJA8wvPkY4ueQGf0W
	 RoxdxIwtIsu1g==
Message-ID: <9771af84-afef-46eb-a848-058e60bcefce@kernel.org>
Date: Wed, 16 Sep 2026 09:02:53 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: leapraid: avoid -Wformat-security warning
To: Arnd Bergmann <arnd@kernel.org>, Dongdong Hao
 <doubled@leap-io-kernel.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Hannes Reinecke <hare@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260915202134.3534708-1-arnd@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260915202134.3534708-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/16 3:20, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When extra warnings are enabled, the alloc_ordered_workqueue() function
> cannot be called with a variable name for the format string:
> 
> drivers/scsi/leapraid/leapraid_os.c: In function 'leapraid_probe':
> drivers/scsi/leapraid/leapraid_os.c:2062:58: error: format not a string literal and no format arguments [-Werror=format-security]
>  2062 |                 alloc_ordered_workqueue(adapter->fw_evt_s.fw_evt_name, 0);
>       |                                         ~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
> 
> As the string is only assembled before the call and not used anywhere
> else, just fold the earlier snprintf() into the alloc_ordered_workqueue()
> call.
> 
> Fixes: 5597088c9e79 ("scsi: leapraid: Add new SCSI driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
