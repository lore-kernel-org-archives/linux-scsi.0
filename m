Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B04E1547FF;
	Tue, 19 Nov 2024 21:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732050415; cv=none; b=Ls1LLJV9qA3SdRzlezaf327VG0w0DPcBzW8U9MpxN0ehH42b4DAMUcLEAwF1O4ujtWfrqsLQ+Bwtzq+XVbfT2zeDV3p4SV3iKt1quceTplDKLWeFaxLjTWTwTieZ0LtUvq7rtPM3DroSB+No0Zg8tJp7K1VnKWyLsOVn4LD18xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732050415; c=relaxed/simple;
	bh=rZ8mQYpeyh+NzPF1kETafz9ayxs4kYWLwN0DGH6SwnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qYjWCXLjsuzsfFguaDqs2SCq84Un6AoCtlZ6buwovq00qe2jGpGrqNL6G9E+op4Oror+VPhCgJGjVxPzD+eZkrFHrJAav3lqEGMebAHqhMjSahOWPaG1GpH0Hg/ssdtN3mk0VNbKBhpzlRZqBWUY9e16iJm0jUQZ/O7f0reKW7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ef8ZGFws; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ef8ZGFws"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XtH9n3TJQzlgTWM;
	Tue, 19 Nov 2024 21:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732050410; x=1734642411; bh=PuhcN48vLDFqlOcfu3/PeCyM
	CW1l5NwRmiw+0aBAS3Y=; b=Ef8ZGFwsDVeBzR3aQfRE3Azz3T0I/YGWgCDeXyu6
	d1rZFfMC/CiLjqfLZIW9B9CQNYIV2p29coWXAAHe8G4BVemS89RlAcL5FBxVaigB
	H3IgJRhejGwJXDsXmMoUYKlvu+4wdc9jn+Is2dzJzVXqS0gDqFy6Uyd/C+C7R95M
	Z9mOk7RJJ4bbzLqjMUczJqbt+DmT6Z3e/tYdoYz2Sfupp3kwZzbw1F+OFi2GImcS
	jrHw/hSCb2bJgLfJV44VaENJ/G6Qr1RIEQ6j/8RGhqtXTBEMIqQyqObSOTFlFl5m
	q4itqmK8vPyPrgoCh7cVWUi4MqAwj3215Ww3JGBNF1HRnA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id K6BFodbbPyiz; Tue, 19 Nov 2024 21:06:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XtH9h4J03zlgTWK;
	Tue, 19 Nov 2024 21:06:47 +0000 (UTC)
Message-ID: <93f44f84-e992-4c21-8705-31ccffc57d71@acm.org>
Date: Tue, 19 Nov 2024 13:06:47 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 06/26] blk-zoned: Fix requeuing of zoned writes
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-7-bvanassche@acm.org>
 <286101f8-c01f-4b10-bb94-adb8928e50e6@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <286101f8-c01f-4b10-bb94-adb8928e50e6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 7:00 PM, Damien Le Moal wrote:
> On 11/19/24 9:27 AM, Bart Van Assche wrote:
>> Make sure that unaligned writes are sent to the block driver. This
>> allows the block driver to limit the number of retries of unaligned
>> writes. Remove disk_zone_wplug_abort_unaligned() because it only examines
>> the bio plug list. Pending writes can occur either on the bio plug list
>> or on the request queue requeue list.
> 
> There can be only one write in flight, so at most one write in the requeue
> list... And if that write was requeued, it means that it was not even started
> so is not failed yet. So not sure what this is all about.
> 
> Am I missing something ?

Patch 20/26 in this series enables support for multiple in-flight zoned
writes per zone.

Thanks,

Bart.

