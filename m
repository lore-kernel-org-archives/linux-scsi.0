Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0DC1A6814;
	Thu,  6 Aug 2026 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786033839; cv=none; b=Xot+f/3N/IYraCvsipJ+1o72q1idUscGPFfN7xgs4WVVqWvsoASva/CONEgi6281V9pTyE0Yxv4cFcCVtQ7v0acY/xlXz/jMGE4qaPHNSQZCYkg/otKR8h2mWPzz1RTzuBlr7Sf0N2NwXqARNT8XIXT4CgwEOCjm5I01N1YqC44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786033839; c=relaxed/simple;
	bh=APATeCcIeGDguQSdzxOjS3PWeB2DXRBJvUcZuBpk4es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C245RwwYL+F+fe2Vadm4xptqX3Eh5yOEX95COGmVNhk1FSwRzrH/g3VTiyrEQiRo7KJurX2FVwUodbwgADyfICbjOyAYPfbU5XjekaaItvOwD01U+tQBIpeIKS2cS2YglBOTlrsMU8XcNfBSH8kV+y9IL0Q5B1zOnwn6AXmpE4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQk45cNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQk45cNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E651C1F000E9;
	Thu,  6 Aug 2026 16:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786033838;
	bh=5N643OcZ6TKjcgSUXv0mk+FEk5LRIN0olw3gyMmc8Ow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nQk45cNzbKYZ+bNorwbh3f0Q7tR7Z3+HV5CIQ3MQDGfI4LAP2RUlFD9jGgIkkBFLS
	 syPZ+NKhtOd/jVqIjQQJ1rOeMRrF/vSeOrIll1V3sPCoxuVLnx4NNbJGd4dFy63Tth
	 oUx2iStVPA1S/NEyxFaI1HviKL8aEqLkiA1depBAp9Oly8jFut1bHTFcKKtcCkCqLX
	 LtK8ElpNlzi0pJDm87Uuwi4ioI61DjdflBnBZJJtP+/VTp9hjw8aDu5DPUdmaaHxKX
	 o6TGURv5D+v37GYyRvMMEMkuB1BHsjJZ2aTblxb4O7NtJL5q2whlGBt3cE8FbckVLf
	 dHcFy1qHNUdYw==
Message-ID: <9bd395e3-5df4-4e13-886f-b1afeeb5d4a2@kernel.org>
Date: Thu, 6 Aug 2026 09:30:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Drop Scsi_Host.default_lock
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org,
 linux-s390@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-usb@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260806113958.3127942-1-john.g.garry@oracle.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260806113958.3127942-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/08/06 4:39, John Garry wrote:
> From: John Garry <john.garry@linux.dev>
> 
> Back in the 2.6.xx days, it was possible to for low-level drivers to set

s/to for/for

> the shost lock pointer. That is why there is a default lock and a pointer
> to the shost lock.
> 
> However, support for this has long been removed, so drop
> Scsi_Host.default_lock and make Scsi_Host.host_lock as the actual lock.
> 
> Getting the address of embedded host_lock structure just requires adding
> a fixed offset value to the shost pointer. However, getting the value of
> the host_lock pointer requires loading from a fixed offset to the shost
> pointer. The latter should be very slightly slower, which is relevant as
> this lock is used a lot throughout the core code and drivers.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
For the ata bits,

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
