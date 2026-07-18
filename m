Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0203713635E;
	Sat, 18 Jul 2026 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784336653; cv=none; b=qTxG4HasKeGMY8ulo0m+akARM4HqPIxdp+L3fpeiu4gG1M2mlMAECWKrcAzGsK4TMJY3kHpRpN0rglrGfTRjhrU2w3EbVj0Ekt5hsJDgkxMUnVomQMWsIRLWdkRfjN1gOlOmA80J3a39NSVTJ5aDpN5ZbN90jSiI7A+CsoFmvD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784336653; c=relaxed/simple;
	bh=J117EmiudlsopFYFJiKnIw3vGxtK20YyRUt8K6h7J2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b2pUjhDNqiH3rUfnd9I9L9g4MH/bcp15CnBIjT1EzD1cN86wbNaS4jkyDYU+HXZxnfM/mZ67oVv3nYSjcBAGSmO8L3X1RUtZC37REmN1TnSUDeB+v5DbawSdSkbiD37YE8tjC785OM2gliw/eORHu+GYnjzDPac74lPQY/ZspaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDZureDC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDZureDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A48E1F000E9;
	Sat, 18 Jul 2026 01:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784336651;
	bh=UlUiCQ6tUwsn1nCPA9vbpMZ88cTeb55U93fiqzJuq9k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KDZureDCPqRegTgi/nfZKXcRoUrUbOuZseztHfvaL5EoJChJeV0d8KwdqXXy4bl/t
	 4vFWQuunhTAokKa1c3BHBhK2O7IpE3u6R6mNhtf46dc0/UxRGFWEdF46i4hEjhV0tA
	 6Hs+lCI/uExh5/xoZlivowyaPZtIOPW/OrB+mwcYVkmmrbLTDbLAVstDTaQblquYYC
	 gAHeBk72gw6RGSkGN1j84CMi/yeIwkCaObFT1S7yy6j3QKynbTgZCVdHolwHCJ8mI4
	 H2Kf8bdULQOqZxcD56+TsGKa1U/f0jNfv08PYAedvTwy9FMvHsWqoMgQqdbEUm2Sfx
	 rq8zsjCGV9PdQ==
Message-ID: <99e6d5af-c680-42bb-8926-213d76ce56fa@kernel.org>
Date: Sat, 18 Jul 2026 10:04:08 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/2] fixup handling of timeouts with deferred QCs
To: Igor Pylypiv <ipylypiv@google.com>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>
References: <20260716083847.926102-1-dlemoal@kernel.org>
 <alpnLgBhz0pb9wDv@google.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <alpnLgBhz0pb9wDv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/26 02:32, Igor Pylypiv wrote:
> On Thu, Jul 16, 2026 at 05:38:45PM +0900, Damien Le Moal wrote:
>> This patch series fixes libata and libsas to correctly handles deferred
>> queued commands in case of a timeout error, to avoid excessive delays in
>> waking up the scsi EH task.
>>
>> Igor,
>>
>> My apologies for the churn, but please retest !
>> Also, I added your Signed-off-by on patch 2 since half of it is yours.
> 
> Thank you, Damien! Test resuls look good.
> 
> I saw you are planning to send v6, I'll wait for it and will retest again.

I am planning to, because Sashiko keeps finding races or uncorevered cases that
can leave deferred QCs stranded and unprocessed. I am still digging into that
because I am not convinced yet that what Sashiko finds is possible or not :)

> 
> Tested-by: Igor Pylypiv <ipylypiv@google.com>

Thanks. Please keep testing!

-- 
Damien Le Moal
Western Digital Research
