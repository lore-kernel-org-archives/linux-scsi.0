Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C1A37A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 18:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709231520; cv=none; b=pAKCw4VlI8GH66dVSTYymxjPfUcMK/ALPCzX75nrX2ntKbwTp6uaJImYcZrI9VYw8b1tbJO4xy/BY9sSeBGz0AQNkPDHd919O1S5VyXFMZ86H/XN/TDKD1NCn9zSgcQ7Zwc4hnfUFLw4g0cJcNuxWzAABJoealONx0z6OAYZY7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709231520; c=relaxed/simple;
	bh=Qb99DtRFKfAUcogAWzhFDq5wuDlkzuLYy9A7QQkvwOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oHH3E2/gUP9gKxz38Y2aXMaA4V0WGfmYc7GPfLNakH0mkbEfZOZawTTyrb4I1V2HqxPyx32j/AKCLbuHqmuM6r171u1p2zDmAFfIfMFp18BnxyJR/AX5cDP0mUZCRgBPt+9y6YuS3UJ9I9S4Z90sq2hVymJElOg6bS6KhDvuQ8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7W2EouD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7W2EouD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF93C433C7;
	Thu, 29 Feb 2024 18:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709231519;
	bh=Qb99DtRFKfAUcogAWzhFDq5wuDlkzuLYy9A7QQkvwOg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d7W2EouD9KS+0rGubaBInBmOqVdq0CYEMXdJeurtF6iz3BFbqLOAu679c1uI6GFnN
	 AxvGnveSGtHGFuFG0rP3Qai7CLuqydRFnif2iXDz73QybLGKs0MA1eQVRcqW/m4y+W
	 fhzbLL9R0cGCpJL8ECgCxpTeL7rxfQe72atugWigc01mPvacf+o8B/EkUwsd+4HMFJ
	 kLT7SSuZa4NWNv7bKtiC8KpHZ1z6IsJbGyTYFrkpoTzBXFcdp8ht/J7xLvZKNxlr57
	 JVTHpeq1BJUw6FWUmQIW1p1Jut5+VK1FXOnk31i3oWRpMCE3wc/iF+Y22adF1Cp1U7
	 Lgsn98AgVXtRw==
Message-ID: <ecbc260c-1202-4b0f-bcc9-4886c85bf43c@kernel.org>
Date: Thu, 29 Feb 2024 10:31:58 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi/sd_zbc: Use READ(10)/WRITE(10) for zoned UFS devices
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240229172333.2494378-1-bvanassche@acm.org>
 <d28c3a75-0a90-4720-a510-7e6847d76f8b@kernel.org>
 <eec0d0d1-9fe3-457f-8150-e5cbe19a9f23@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <eec0d0d1-9fe3-457f-8150-e5cbe19a9f23@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/02/29 10:05, Bart Van Assche wrote:
> On 2/29/24 09:29, Damien Le Moal wrote:
>> On 2024/02/29 9:23, Bart Van Assche wrote:
>>> +	if (sdev->type == TYPE_ZBC) {
>>> +		/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
>>> +		sdev->use_16_for_rw = 1;
>>> +		sdev->use_16_for_sync = 1;
>>
>> scsi_add_lun() sets use_10_for_rw to "1" so can we clear it to "0" here again
>> like was done in the sd_zbc.c hunk below that you removed ?
> Hi Damien,
> 
> Although it would be easy to make that change, will it cause any
> difference in behavior? sd_setup_read_write_cmnd() checks the value of 
> .use_16_for_rw before it checks the value of .use_10_for_rw. Hence, the
> value of .use_10_for_rw does not matter if .use_16_for_rw is set.

Yes, but I find that a little fragile and given that rw-10 causes problems with
ZBC, I prefer to make it very explicit that the 10B command variants should not
be used.


-- 
Damien Le Moal
Western Digital Research

