Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1113CEB89
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 23:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716557; cv=none; b=rSzXwJkM2FJuVDB6pKSKInvUYQ2Iuh2VHuzBEDgfWpIzUeVdmITF16WdpVZ9W2yUw+fEAKWJ7uRKZvNgzGrzKmrVyC+FpuGxC2/7nm3O3BujMSLBS5kft3XeP/QT0ZF/BDlGCHrh1SW0vQWaIizjLWQSJfkTeuo60RBCyDyxdE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716557; c=relaxed/simple;
	bh=z59uve8YvjCVToQlMNoOfG6IMTf2JZyY74uvxepW2H8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l/ztTgHaTV/t4HiC/LFSdvepXn5ALJLBrXV0/c+eZ68jRy30gy8QFiraZl75F1qKrVKS2mpuQozMHzX1HAw4t6xuMLuu8QwBjfZKsRLij1soqALlDRx6uRIGZRQWIKYo6i52ZNrbhhUvYW068xb9oZ/pptFJyoPFwYK+AZgvGaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2CjcKf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2CjcKf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF472C19425;
	Wed, 13 May 2026 23:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778716556;
	bh=z59uve8YvjCVToQlMNoOfG6IMTf2JZyY74uvxepW2H8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L2CjcKf4Jf1W//wcyjIOpUuuyKT4B59hB9N7oGd/JsdQl416909j7pLzzKEyvDSV9
	 hCb1cBC36SI0dToO7nxG56Zck3IbiXlsZrkG9XF9yDFp+HhhqCqSh+sIaaI03oh2yj
	 M3xzc0NWrQgr04r4W9JZVvsuUtS5BxpbmzCA5Fm6dsUc7rL4Fzsl54DOZLtU275MaA
	 IpDm0uqx18uHcS+oKfSGjwCKhtqAza8tLcWvSDKkoyIVTrT6uHmhXWI+6MNiksjNVz
	 eJ+TodbXIhH0phmWesd9irFiVxdqrKTHvnAw3qHZwLxq+iVU+WK0j/II6cFB/YyNsD
	 q8g2jpG8H8m8g==
Message-ID: <787e03b1-2765-4f31-ab8b-bfbb8bdc7863@kernel.org>
Date: Thu, 14 May 2026 08:55:46 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Convert inquiry information
To: Guenter Roeck <linux@roeck-us.net>, Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260512194634.58145-1-bvanassche@acm.org>
 <20260512194634.58145-3-bvanassche@acm.org>
 <292bb057-f10e-4af1-b0fe-ca83d4f49d06@kernel.org>
 <8ca0f49a-ae11-452c-987d-d90cce8376dd@acm.org>
 <8f801fd4-6a52-438f-8c99-1cfa28b058df@roeck-us.net>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <8f801fd4-6a52-438f-8c99-1cfa28b058df@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/14 3:40, Guenter Roeck wrote:
> On 5/13/26 10:26, Bart Van Assche wrote:
>> On 5/13/26 1:03 AM, Damien Le Moal wrote:
>>> On 5/13/26 04:46, Bart Van Assche wrote:
>>>> Currently the vendor, model, and revision members of struct scsi_device
>>>> are pointers to fixed-length strings that are not NUL-terminated.
>>>
>>> s/NUL/NULL
>> Really? NUL is the correct spelling according to
>> https://en.wikipedia.org/wiki/ASCII and also according to any other
>> ASCII table I have ever seen.
>>
> 
> Maybe the confusion is NULL pointer (or NULL-terminated array)
> vs. NUL-terminated string ?

Ah, yes, indeed. Please ignore my comment.


-- 
Damien Le Moal
Western Digital Research
