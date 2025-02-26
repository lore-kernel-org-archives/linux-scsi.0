Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64898213E8A;
	Wed, 26 Feb 2025 02:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740535991; cv=none; b=PvrdFa5OQ+iHkS047W19LTxxXN/mmRGYJdOpUYeDfCZLAKy3pfmdG4LLrpGf0J5l/tQYcqH6zpmCx7d9mvMBHLlDCLuSnPNhiazrf5ui5MeERmwwD9noyHyLoYXiNIlUDn75cHmIJDgZ+5qxSaqKU4WpOqsfyijnFQPThozDwqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740535991; c=relaxed/simple;
	bh=wEks5+INRovhnIiK5sKUZebnCdp/Xbkwwg4VSULbSL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=il4vLzOxrwVomTq1icIGZOrQZ8Wwi1IRh6HSzlVquSOyckOPQH8SNZpCyJv4mvzsJTUxRp48dkBsF4VrFsuNbWuA0AS4hTLIP4j+a/omIrEO/RidtpYUd/Cfx/hF1lo4OE8wiy1FMSSj63tODPgH3TmZCvFQ+GOKQS901H8XRwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6X/MhEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6X/MhEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489A0C4CEEA;
	Wed, 26 Feb 2025 02:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740535991;
	bh=wEks5+INRovhnIiK5sKUZebnCdp/Xbkwwg4VSULbSL8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n6X/MhEXQFPuY8yXKYi2fwREMFqiZp5tZgFlCGroPg26PYYABS03nwUksP8hwydHG
	 KkhAhjPwI670JrJjh0yj1VA0FDrp6kb0hjiiyEuUbsgj/NY8VwgJy2pfNDeFb4cGwh
	 bQBZ9W0z4Fli9PK+7eQwgtcvOfxJR+ecR7VWh8rYd8b/VzVR5U33F0BxKoBCdu20ee
	 BlOOOLMC8MHk8Da0yrFngUKDilAfMYtvZaniynhbAfoac9OlweVToFgWYjUK/3lVDT
	 hTKgp6CMp2TFioDHpKgDbHZaFSPUoi7G1RULFQRXM8sFQbD24vDIa6mevZJkhSMh0l
	 8saGv9dUzAlQQ==
Message-ID: <f19060b7-2fde-41d1-b11c-603ac25c5cae@kernel.org>
Date: Wed, 26 Feb 2025 11:13:01 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: hisi: remove incorrect ACPI_PTR annotations
To: Arnd Bergmann <arnd@kernel.org>, Yihang Li <liyihang9@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Garry <john.g.garry@oracle.com>,
 Bart Van Assche <bvanassche@acm.org>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
 Jason Yan <yanaijie@huawei.com>, Igor Pylypiv <ipylypiv@google.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250225163637.4169300-1-arnd@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250225163637.4169300-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/25 1:36 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Building with W=1 shows a warning about sas_v2_acpi_match being unused when
> CONFIG_OF is disabled:
> 
>     drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:3635:36: error: unused variable 'sas_v2_acpi_match' [-Werror,-Wunused-const-variable]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
