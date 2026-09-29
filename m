Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698C652940C
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 13:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790688856; cv=none; b=tSv/3qVWEgas/QN3Y2vZbcnFPfiOZS38KTiRqoEHGwmzjV1O/l4QLuaA4Zp57qrFHEF7HP8VTopndDDw/33Zj1sgsZ3nq0gaj+gJPacAmmR1gmalh3eqlvHm/GCH5Fv6myr/fxm0qLMTNtQDNo9RQurSFyz3MiFViNqkHz4+n5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790688856; c=relaxed/simple;
	bh=w1zXQxJ2YiGrYCqJkflaO7T52o2vpUEDWp0cK7W4q24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L+uih1d6qv+la9VaPXyzgfiJY8wO/sJ2no+w2O2BvZnJHHNkBlcRhmW80worc4TMvXUhIysRFZFjZq3sofi7bvqfJ8YNqfQEsQUGMosxUnvFRt9X9VusYFiHWb+WFCQh82wpL/ZpKNiWPA3x7bvr8+INo7517A9VTIbW1qeNp20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOHhT22m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOHhT22m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9061F000FF;
	Tue, 29 Sep 2026 13:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790688855;
	bh=+tZnFrMGnV5ZCMpOobIwWogXj8EN7BS4Yxrl2EjhKzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SOHhT22mI287pxoRo/D6Uf5RRMETqzB8bwx5embZ4PiLegPn61iZHFok4thL2CHrx
	 9Bk0tgu9afSQbSOgXdYC1DqUeF7c1rwTSi4Ps8aXA4wLB8E5N/fOZPQAsbN5qrSilA
	 1HsSZ479119AenNONIWbSndg8OEjUkQIkaIA88AO+hf0ayYhH5nZh44zHX4skCIYfd
	 xko15TfhPPxT1joKSLxXgd+0CRaOHexRNUrx+uocSQ75lM3cP51d2h6m2qqqq5CV4v
	 A560JLixsFA5nKL2idkxw95rcW2f3CcuNaRd3EhZxAFlvdXeK7RQAsp0i7o08Zut/E
	 t1Aq1zw7mnCMw==
Message-ID: <ae7739a1-ae74-4c84-9a49-6afd3107e6f9@kernel.org>
Date: Tue, 29 Sep 2026 15:34:11 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 03/13] scsi: scsi_debug: Refuse a negative physblk_exp
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260929082456.857423-15-cassel@kernel.org>
 <20260929082456.857423-18-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260929082456.857423-18-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/29 10:25, Niklas Cassel wrote:
> sdebug_init() refuses a physblk_exp above 15, but the parameter is a
> signed int, so a negative value is accepted. The driver then shifts by
> it when it builds the Block Limits VPD page, which is undefined
> behaviour, and READ CAPACITY (16) reports an exponent of 15 for -1.
> 
> Refuse a negative value as well, and print it as a signed value.
> 
> Assisted-by: LLM
> Fixes: ea61fca58c13 ("scsi_debug: Add support for physical block exponent and alignment")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Another way of fixing this would be to declare sdebug_physblk_exp as unsigned
int. But this works too.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
