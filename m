Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97C1213222;
	Fri, 10 Jan 2025 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736533076; cv=none; b=eVdBhWDaOqJFgfAUqJfCsMTGvybVGFwYGLpnn+afjMk9oTGLqrwWB+7E5xJOjhc0OWFqS29UYCz2etThjBItpv+XGfhLYo58Dip7vwncxWMqQ6MzQlSUd6gxRCR3/WV94W/Op6RwzYKsaYAYQJUy6GdsFbR+odjTkC6l++hk8gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736533076; c=relaxed/simple;
	bh=M4/miNOIFbl9jwExAg2KrDMIy9jYUK3U9gqIYHI+YSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JbDEux6BtpE3LvYmMANJLGibi7n2SRczOlCinrX4WHzL9G6UOxseOqA7Y1H/KlAaQjJW6V+LrtP1yyFbj2PwPMniutOke/L3fACrL9833SVB98jNHVe02ourRs/HdRO04wJ8F8U4mDyfLkOd7xJF7LPyUWzmOw2276gFXRnqX6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=M/jH4cuM; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="M/jH4cuM"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YV8yf6xcdz6CmQtQ;
	Fri, 10 Jan 2025 18:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736533063; x=1739125064; bh=LHr63z/qXB61GZgjN3/nqk/O
	vSZZtv+W4XiU69tj4oU=; b=M/jH4cuM/mNlKz2GRTih1Y6a16+RJa0WzM+ggtJ4
	AIvbhc+tK/r8UoyCbDAJuaLo1952Uh/FP5EyVBb6x/uS6CJd93xHHkSVNSqLfFRE
	HoyB0NRhpiAk6BhCxKHNMrtgQHYqOK0UnKI31BWpc5EXudP1ImizUZiPqxmwfNSE
	XKgYq1/Ak+znCiKMgZqvI7MpdJ5pt4gZlAgZ107VkcLfMLmysweoba/0+EzX/Md6
	CAiL/bPnYJ3IwoNSyyH7mtMePJ7+wJTdxmttlkTR2ohCGCYxbQ/epKinaIJxigTW
	fWch5l4DtGiFxDCKIsRUw72/+MLia5fKXzZNVQ+r/SyYxQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6GmqrkNIM9vi; Fri, 10 Jan 2025 18:17:43 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YV8yZ2cGFz6CmQwT;
	Fri, 10 Jan 2025 18:17:42 +0000 (UTC)
Message-ID: <3a62c833-42e9-4763-a3d8-18b3edf97db0@acm.org>
Date: Fri, 10 Jan 2025 10:17:41 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/26] blk-zoned: Fix a deadlock triggered by
 unaligned writes
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-6-bvanassche@acm.org>
 <6729e88d-5311-4b6e-a3da-0f144aab56c9@kernel.org>
 <8c0c3833-22e4-46ae-8daf-89de989545bf@acm.org>
 <bf6328f2-c660-4431-9ef6-39722dafa9e7@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bf6328f2-c660-4431-9ef6-39722dafa9e7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/9/25 9:07 PM, Damien Le Moal wrote:
> On 1/10/25 04:11, Bart Van Assche wrote:
>> On 11/18/24 6:57 PM, Damien Le Moal wrote:
>>> And we also have the possibility of torn writes (partial writes) with
>>> SAS SMR drives. So I really think that you cannot avoid doing a
>>> report zone to recover errors.
>> (replying to an email of two months ago)
>>
>> Hi Damien,
>>
>> How about keeping the current approach (setting the
>> BLK_ZONE_WPLUG_NEED_WP_UPDATE flag after an I/O error has been observed)
>> if write pipelining is disabled and using the wp_offset_compl approach
>> only if write pipelining is enabled? This approach preserves the
>> existing behavior for SAS SMR drives and allows to restore the write
>> pointer after a write error has been observed for UFS devices. Please
>> note that so far I have only observed write errors for UFS devices if I
>> add write error injection code in the UFS driver.
> 
> If you get write errors, they will be propagated to the user (f2fs in this case
> I suspect) which should do a report zone to verify things. So I do not see why
> this part would need to change.

Hi Damien,

In my email I was referring to write errors that should *not* be
propagated to the user but that should result in a retry by the kernel.
This is e.g. necessary if multiple writes are outstanding simultaneously
and the storage device reports a unit attention condition for any of
these writes except the last write.

Thanks,

Bart.
