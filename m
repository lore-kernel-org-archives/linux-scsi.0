Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B2221D5BF
	for <linux-scsi@vger.kernel.org>; Tue,  5 Aug 2025 22:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754433217; cv=none; b=YGPtbccVpRz1DjmPejDOFu/UEmN+4+lSesDJUrFRiFMoE3CD22ijjUtf4wNHN9WsnM7XH0+wHYO8e1W0gICBLwvZ+tLN9bWE0y+TT76JAKEVA9Jg3w+D1gzIFlPUEVkv8KRaE8tqyAH050S1uuNxQMAn/BwP8JeoDwIxyh5mMHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754433217; c=relaxed/simple;
	bh=JW4KnygewTimhUv4wYEPNfjlXaGvELe5rlMyI31YIoI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iQIax+kKdGD0Ah/8yLYvV1HUbi0IX1YgWfQF4ASq5ZhDzygF1Omtax5Y0rDUveJlTbYJcDuTDuLffTWiMzOBl9WfzkJ/DYqjUMTEk6N8f2u8nMhaEUBAgiZN8L0Gd0dFtkBra6BxgsCW9uUHjxc0O3XHWcvyBIFS2Htb3QplQSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2KhcYVvz; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2KhcYVvz"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bxSr81MSlzlgqV1;
	Tue,  5 Aug 2025 22:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1754433206; x=1757025207; bh=Y5y+orP2Eo48EadVuyL+lf8k
	xe8AUK8uNocAtyQ7FHg=; b=2KhcYVvzgbAxvBQEbimvCivnjz9F2bnxZHlUGQnD
	+fp1s7aP6pA2QFSYjPuLHZtyErJvHqYONKdWM2N+QfPIk92VJ5G6Iy3fAsLb875z
	zAg9EHafB3cF/sJ7zR7zcl3MmMX060L0ETIYP97RkOqhhXf8QBHZPIjiBhh3Hk+E
	Y9ckafRcLpZ+4GxfclsEJznIKz6z33WC0KKZYHABpnoiCpcluuZzBOwqRJZVO8YF
	9LHNK8hH7NSrh6AZmsqfHOyaoN5kjfqB/2XBkzW6/9+bieQ/xYf5s7d1LlhkTESL
	mCiTcCN3rhjhW/NU7mSio7fQgVWasad33dzO+I7wDZBIOg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BrMR3KrCtQir; Tue,  5 Aug 2025 22:33:26 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bxSr40ZrPzlgqVj;
	Tue,  5 Aug 2025 22:33:23 +0000 (UTC)
Message-ID: <f62ba915-4f22-464b-97df-6d471b6d6dac@acm.org>
Date: Tue, 5 Aug 2025 15:33:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
From: Bart Van Assche <bvanassche@acm.org>
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
 <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
 <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
 <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
 <d6b35769-e5f7-4174-b581-f6555aec1d4e@oracle.com>
 <959ed10a-27e4-4c63-b9bd-58fefc5c4775@acm.org>
Content-Language: en-US
In-Reply-To: <959ed10a-27e4-4c63-b9bd-58fefc5c4775@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/25 2:25 PM, Bart Van Assche wrote:
> On 4/16/25 12:16 AM, John Garry wrote:
>> I'm not sure how that will look, but my preference is to fully 
>> implement reserved tags support which can be used by all SCSI LLDs.
> 
> I'm working on an implementation of this approach but it will take until
> next month until I will have the time to post a patch series that
> implements this approach.

(replying to my own email from four months ago)

Hi John,

With this approach and with the UFSHCI 4.0 controller model I have on my
desk, I'm hitting a hardware bug in the controller. I see completions
where cqe->command_desc_base_addr is NULL although I triple checked that
this pointer is not NULL in any submission queue entry. Let's postpone
the conversion to allocating reserved requests via the block layer until
I have a setup on which I can test this conversion.

Thanks,

Bart.
