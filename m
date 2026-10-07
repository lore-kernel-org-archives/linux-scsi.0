Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418B5492E5D;
	Wed,  7 Oct 2026 14:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791383503; cv=none; b=jJxyncRET8FwZ8EGwKqsN19JSEg+MT4AzfXvZT/L42oYX19vMUoSLCa2HZkj+B+Kacf6ClITC3qPNi4vojDN1QxKPnK1pf6m1MVtqSCpqCctIEIKqz6FAPEzR6mYeaZ9K5We0Wgj3Cr7Y4WrrSXBS12lMN5V5iZX2EIrHt+bHu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791383503; c=relaxed/simple;
	bh=BS9M//oQZOQJced0Q6bIEbQyo5kBMEyRMzQ0Sx1ac1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bh8P5EZo5dNM1LKmbixma/23LCwWEum0xYqbRgVCGDGXo8eNBs5kGiPMYfBUBBhofDuDxE/KWa/pdLRiJAAKnSzWhNumyaBa9d4VbKPnvlvVnC6BCTHTyI/U1cxtlb6Dkkzg3ZffIPaKxgjNaBdqLsIGho3NXVjpS5NtiGGM05g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ax6dbSpY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ax6dbSpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EE91F0089B;
	Wed,  7 Oct 2026 14:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791383499;
	bh=3coKYYmHCujO5E+dsek64SjGAecOQubds/IWYX/LEV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ax6dbSpYIgF309W8djwZk38JRV6uzH4fmtkWdazDc6Qr2tYTzk3CXqQwOTIMU/iWd
	 jR23AeYzskyZA+5qCspSelAhNZH8fTvlpBL5j11WD/Oi8y0relTmC5h7y4LDUan0qI
	 XZQtFpxqVCIdpinwh4KlDjtaygZedq2OC8/ziftZhHO4YrjvNlVdJODC2yDo+lzFpu
	 oOTQPgcRnfmci0ILY2kkGdzSiD1CLmId/9DexK367Qr6CnXtcN/4NTvwM5N9hY5Xtl
	 6EsHPKB3JGZJbEsv4w/88ytjqYJigqET7ga/85fDGlk9/5KsLDcZGle5fz4PHt3aVg
	 ehM2m7cvheUzg==
Message-ID: <777cbd7d-0ea6-4263-9dfa-92f3422d5330@kernel.org>
Date: Wed, 7 Oct 2026 16:31:36 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] block: fail reads to offline zones early
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
 <20261007082344.1049179-2-dlemoal@kernel.org> <20261007132905.GA31906@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261007132905.GA31906@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/07 15:29, Christoph Hellwig wrote:
> On Wed, Oct 07, 2026 at 05:23:38PM +0900, Damien Le Moal wrote:
>> Any BIO targeting an offline zone of a zoned block device will fail,
>> including read commands. So there is no point in issuing read BIOs.
>> Fail these read operations early if we ever see one.
> 
> Sashiko things this can race with zone updates.  Which is real, at least
> sorta.  Maybe we should just do this in the drivers instead where we
> are under freeze protection?  A bit uglier due to duplication, but not
> really any more complicated.  And drivers right now would basically
> just be sd and zloop anyway.

Yep, I will drop this patch and add a zloop and sd patch.

-- 
Damien Le Moal
Western Digital Research
