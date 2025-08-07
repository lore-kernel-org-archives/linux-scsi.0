Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5172269D16
	for <linux-scsi@vger.kernel.org>; Thu,  7 Aug 2025 15:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754581268; cv=none; b=jBfhM4I4NjM8ZtqEWGa+dzekfg7jLX2V194EFb3onWNJhJxa8QW/GiBYFVH65FPjg2dX9gRK/apLOg1ya1ijuzw+nJRXbmbj9HK0P1pnmYzqXa0EzfdV0BLErM7XFpAPjJg8ZNCqoP3sUPhGXQeIvSNYqDZBBCHZop1dm3T0RCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754581268; c=relaxed/simple;
	bh=AcDnoczkFtLjKVUr+ke5mgdcPDNZrAC+7qRNvG6UCuc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=f4N8HQa7XnQEKIok8lXdJuGyF9Wmb4wgEdjgDvGQh/SewRMVb0whjtddbE9pa9XLSJ6dF0v2QBpo7wpbR/JQUdygWlFAHu1Gx+o1onqaXtU+fJHchTSsY1LI/BCu+1soul2JAodjS4bJ4hTkXPGPozIsISnbTD0UiyYMauVbUQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XPSXQ6tx; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XPSXQ6tx"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4byWbH1rBpzlgqxg;
	Thu,  7 Aug 2025 15:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1754581257; x=1757173258; bh=QB1OidGUydLL0pDjZZwTI4X7
	HFHrJOfwFYRmJezwl0Q=; b=XPSXQ6txmsxK2xa6PJdb7G67gUUdZCAdeqtCAkkR
	mTr+ICqbshMCbQ9cNvDSCwwNGljGFqG2Y7nRfOI4dnpo6UVnCtSiavLDzJt/1bIN
	zFnnHXbaicBB8tUkohEyxrstz+vXphBTDp+83f+lRrX0ngPjQx45rcLVUQmQnhX5
	teKbJbkAb6O+j54+0bq9ULHgkQRWiXYdLOG/mw7HN6GORmig6NQsXyYSLveGEyBm
	7tsy+YKebK0uhlgS04BaGw1ZVNrg/r/6syHIulTND8fqkTFJ4zODt3OuWOF1pCsb
	hJd8p7xIU6fHv0wwOeAM8jVjgNqDwh6xg6bzcHzPmXLYMw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Z88XmQvDx3HM; Thu,  7 Aug 2025 15:40:57 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4byWb66KlNzlgqy6;
	Thu,  7 Aug 2025 15:40:49 +0000 (UTC)
Message-ID: <cf8ca156-18c6-4e25-a490-96662f1fe4b1@acm.org>
Date: Thu, 7 Aug 2025 08:40:48 -0700
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
 <f62ba915-4f22-464b-97df-6d471b6d6dac@acm.org>
Content-Language: en-US
In-Reply-To: <f62ba915-4f22-464b-97df-6d471b6d6dac@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/5/25 3:33 PM, Bart Van Assche wrote:
> On 4/17/25 2:25 PM, Bart Van Assche wrote:
>> On 4/16/25 12:16 AM, John Garry wrote:
>>> I'm not sure how that will look, but my preference is to fully 
>>> implement reserved tags support which can be used by all SCSI LLDs.
>>
>> I'm working on an implementation of this approach but it will take until
>> next month until I will have the time to post a patch series that
>> implements this approach.
> 
> (replying to my own email from four months ago)
> 
> Hi John,
> 
> With this approach and with the UFSHCI 4.0 controller model I have on my
> desk, I'm hitting a hardware bug in the controller. I see completions
> where cqe->command_desc_base_addr is NULL although I triple checked that
> this pointer is not NULL in any submission queue entry. Let's postpone
> the conversion to allocating reserved requests via the block layer until
> I have a setup on which I can test this conversion.

(replying to my own email)

I found an elegant workaround for the hardware bug that I ran into and
will repost the entire patch series after the merge window has closed.

Bart.
