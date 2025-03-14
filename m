Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FAB20298B;
	Fri, 14 Mar 2025 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967739; cv=none; b=ppsHPurhx4wxtEkJpaI4MN7YWcQ94xcNb40Q8N8kghMm7Y3W04qRh1Q7pjKKunBHhQVjd9A91TAWDwSnLk+hGpRMA4FTnIV4TuVZJHZqnYLLfVkDKJ0pUilnBB+l+3Qht52upyTTYCesNx5QqT83m8U/YHS7g4Ep9TU8fCumO4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967739; c=relaxed/simple;
	bh=vMpqShwUmNxr7qtsyBInbNWJOGdwIh/cY4UomPIKZ0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MaOSHiNSqpXcTHjdwJkPX//Qz9O5sNT5mgQ+y2ox2Jkl5ysXmbB6FVB6dvEa4lJ+jGHTnwQPAMIXP6mWCM/x0c1ZA0VZvP0qVyCF/Ruu5SJHqgMWq8ZCGqeGnJTGO0gislKU751Lkbu+s039NsrvpFuJjjFm6A1xCA7+jtIH+Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4mFLQeIn; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4mFLQeIn"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZDpqX4rPczlngSX;
	Fri, 14 Mar 2025 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741967734; x=1744559735; bh=jfzkC8hHMFcfD59yOUVoFbOw
	Q6PIa6w4r/0MtzFLMs4=; b=4mFLQeInhbPjm6UsEbnj4RCg1e7SaB7ouKLKDQBF
	lXWH7rGn/of84QXush+zivcvS27v6vXz3XD2/1di8i2cS9HY+BaoEI/YaDwhq5Co
	JtDjJ2X5mJ39pTiyOsXvbQ3AUZl6mWLrRmgACtZzvec5jI+987Hqdon3IHxisJzO
	aIoRUmPnkSzMqd0jaudU1El/8Fg4De27fzPE+ZX7cWF0++8c9W0c/likFQ6/8s4u
	bkL/YlIoqbb1jyhxbA19AGreS3vg/enzsny7KKr1UHRIjR6aGW3iPwSgvEpz1mW4
	BUfhD8qWVOy2m5BmWEa4KuHHlKUGSBbXUzhwhgswTsqnjg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id J3y96ZrLnjNG; Fri, 14 Mar 2025 15:55:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZDpqN0B9Rzlxdd3;
	Fri, 14 Mar 2025 15:55:26 +0000 (UTC)
Message-ID: <fc08e3a1-da7f-4eb0-a738-cf6b6958316b@acm.org>
Date: Fri, 14 Mar 2025 08:55:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 00/19] scsi: scsi_error: Introduce new error handle
 mechanism
To: Hannes Reinecke <hare@suse.de>, JiangJianJun <jiangjianjun3@huawei.com>,
 jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lixiaokeng@huawei.com,
 hewenliang4@huawei.com, yangkunlin7@huawei.com
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
 <f35b2485-588b-40c4-a2e7-1bb65fb7a9fc@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f35b2485-588b-40c4-a2e7-1bb65fb7a9fc@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/25 2:01 AM, Hannes Reinecke wrote:
> 3. The current EH framework is designed around 'struct scsi_cmnd'.
> Which means that the command _initiating_ the error handling can
> only be returned once the _entire_ error handling (with all
> escalations) is finished. And more often than not, the application
> is waiting on that command to be completed before the next I/O
> is sent. And that really limits the effectiveness of any improved
> error handler; the application ultimatively has to wait for a
> host reset before it can contine.
> 
> But anyway.
> We already have a mechanism for asynchronous command aborts;
> have you checked if you can adapt if for LUN reset, too?
> That would be the easiest solution, I guess ...

Hmm ... does this mean submitting a LUN reset while concurrently new
SCSI commands can be submitted from another thread? I don't think that's
safe.

Additionally, how could a LUN reset help if a SCSI abort doesn't help?
If a SCSI abort doesn't help, it probably means that the host controller
locked up, e.g. due to a firmware bug. How to recover from this without
resetting the host controller?

Thanks,

Bart.
