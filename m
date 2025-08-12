Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25C92D0636;
	Tue, 12 Aug 2025 23:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755043053; cv=none; b=UkJV4HcxuGrjdUBAJRZTn5eRXpkMgXU3a+4y0BjtFi0eeIcSaoX8rr+pnd4FMy1x1hybciEfsZKhUf++0P2UI52gWE7Ccdhdw1QFuelnPj/xc65wTDQhC/oMf5bkrjOtGdehZGxFaIe4Xyhhp0xQCsH6AAHmZANC0MTt8fSZZoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755043053; c=relaxed/simple;
	bh=GGJfHCS1Y79aXwZEvamO03h73lyHIOOftgkTQcMTVyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jYatJLl+7vc9bt+Cq4vnbnNE/D18u7zXJhHid78I8YHBeU/lXQUqu4WZXM3tb8Qb2crTY/4j1CMngnDz4YzC5tL6smLs4RXPVMkQZYelcGJDjDG5+31hQvfVYwgc+34Cl2ekg3RA6sudzCiEUjOb0wOqJuX1iZYUA++FMSDTgxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Fw1+WWFr; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Fw1+WWFr"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c1pMt52TrzlgqyY;
	Tue, 12 Aug 2025 23:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755043049; x=1757635050; bh=KvXXGnQ5MoPMBp5T9DHr4a9c
	jIUnuCTQFIAzi8COOVA=; b=Fw1+WWFrdwd7v8GvGNpZDfFL5rByCVSw6K1GG9rL
	MXmaMdrl4WVoh6Vj2PwCa8+pueif264Q11WIIwYTDgGh7S0GHxoOB0ZbGDgaUA9c
	xnNqZft2Ra+1xw0lGu2tXjTABJ6IE0YT+iw1Lph9tfk/aXHxZzdALfNmf5Ciorqy
	tcyStF3UirfcoZlhlskOSY1KwQZ28UAwye5G/ANGCJ76veK75pqodiwEvKO/AATQ
	6n3bfWWRfZyzt2kPhcct1REqpIdlS5pH1b6cgtCwwtKGDlDWA8TsEGt17qXcZk+e
	swkrkwyABt52sMJVli/G5NHuA0H3MYv+0TE18ixm8EaG6g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3NLawijAN5EK; Tue, 12 Aug 2025 23:57:29 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c1pMn2YRhzlv4Tt;
	Tue, 12 Aug 2025 23:57:24 +0000 (UTC)
Message-ID: <6b56a20a-3ff6-40c3-b165-2f3e4dfda45a@acm.org>
Date: Tue, 12 Aug 2025 16:57:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 01/16] block: Support block devices that preserve the
 order of write requests
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250811200851.626402-1-bvanassche@acm.org>
 <20250811200851.626402-2-bvanassche@acm.org>
 <7570f60f-932b-4b76-a87d-8f3f0760c44f@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7570f60f-932b-4b76-a87d-8f3f0760c44f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/11/25 7:12 PM, Damien Le Moal wrote:
> On 8/12/25 5:08 AM, Bart Van Assche wrote:
>> Some storage controllers preserve the request order per hardware queue.
>> Some but not all device mapper drivers preserve the bio order. Introduce
>> the feature flag BLK_FEAT_ORDERED_HWQ to allow block drivers and stacked
>> drivers to indicate that the order of write commands is preserved per
>> hardware queue and hence that serialization of writes per zone is not
>> required if all pending writes are submitted to the same hardware queue.
>> Add a sysfs attribute for controlling write pipelining support.
> 
> Why ? Why would you want to disable write pipelining since it give better
> performance ?
> 
> The commit message also does not describe BLK_FEAT_PIPELINE_ZWR, but I think
> this enable/disable flag is not needed.

Hi Damien,

Having a control in sysfs for enabling and disabling write pipelining is
very convenient when measuring the performance impact of write
pipelining. Adding such a control in each block driver would be
cumbersome because it would require to add the following sequence in
every block driver:
* Freeze the request queue.
* Call queue_limits_start_update().
* Toggle the BLK_FEAT_ORDERED_HWQ flag.
* Call queue_limits_commit_update_frozen().
* Unfreeze the request queue.

Do you agree that this the "pipeline_zoned_writes" sysfs attribute is
useful? If not, I will drop the newly introduced sysfs attribute and 
also the BLK_FEAT_PIPELINE_ZWR flag.

Thanks,

Bart.
