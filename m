Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7601E21767A;
	Fri, 19 Dec 2025 17:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766165722; cv=none; b=DhYAiMC9CEX0OfReq0eGu0Ja8lBltquwRTFI87BIakzXz9vWN2sb5n2EWMp+z/o2JP3AWT4zapbT7Rqg/0/N8SM42p/KTs4VN8zvvelubsGhhqX8IggkO9UL2zKh3p/7Uz7bLfUzhYgDCrFH9Dw7sojrSvI4dke/1gxVy3a9ksg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766165722; c=relaxed/simple;
	bh=/UM1x9gOOEfFuA2M3GO2QtAGlimQ9fJx3lIfkmsUh6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GzjKRFFMwyWLQDzX9x+gCX+Yl7QW2Ncj03UQ76dYB/v+Vm2xhOSw0eEROXVhiGx29ON2yCWRm+umV9xBLOLKxT8KQMF/Mx7XZu655MarRpyOCLwR+0MATr4lnkpdANnvOKY5q0LWb2x8hfv8x2R31SEGuJipMmmHvdBJDDRcuAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=33yMuV2e; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="33yMuV2e"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dXvnN0Knpzlw8Yd;
	Fri, 19 Dec 2025 17:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766165718; x=1768757719; bh=Ed2pB4/DgHi2VX769DnyeGvx
	zCzvF9nTLPvZD+WqVp0=; b=33yMuV2ea1/x9ToTPu7YufGkqrV4byBGNiMInSf4
	lD5HvKYJJxyh1NagcBJLtY6qDJe4egBDl+JjiYKnAZPLy0Qcj1yOYtSQaXlnpnhQ
	xxAf08nDqjfVxiik0taHT3xl3258L556z7nvIRzj6va0Z5Ny/tQhXmy5sIP4WkY9
	lpAE3m0wTlSJ11pgtwHrSxPudN0eykDkFSi/A+pigUXNjbRR1/YjfPeoBvboXXBM
	VYmHIm0l8MWzOh2p4CiE7e0eXe+OC/59ky/iI6jcw5/CQnXMRuoyxyUlHgVSNrAF
	dGC1DsleoPAe/uISsIBSlRs/x/wGBw1tfTvAyc1aY3VUNA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bOWTkcfrI2ef; Fri, 19 Dec 2025 17:35:18 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dXvnH4QTlzlvwpy;
	Fri, 19 Dec 2025 17:35:14 +0000 (UTC)
Message-ID: <dba8da69-1f14-48a5-a540-01e8659b7d3a@acm.org>
Date: Fri, 19 Dec 2025 09:35:13 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] scsi: core: Improve IOPS in case of host-wide tags
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
 Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251216223052.350366-1-bvanassche@acm.org>
 <20251216223052.350366-7-bvanassche@acm.org>
 <ac537693-ec0c-4c50-8ee9-a02975f0e18c@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ac537693-ec0c-4c50-8ee9-a02975f0e18c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/16/25 7:24 PM, Damien Le Moal wrote:
> On 12/17/25 07:30, Bart Van Assche wrote:
>> The SCSI core uses the budget map to restrict the number of commands
>> that are in flight per logical unit. That limit check can be left out if
>> host->cmd_per_lun >= host->can_queue and if the host tag set is shared
>> across all hardware queues or if there is only one hardware queue  Since
> 
> Missing a period at the end of the sentence (before Since). But more
> importantly, this does not explain why the above is true, and frankly, I do not
> see it...
Hi Damien,

The purpose of the SCSI device budget map is to prevent that the queue
depth limit for that SCSI device is exceeded. If there is only a single
hardware queue or there is a host-wide tag set and host->cmd_per_lun is
identical to host->can_queue, it is not possible that the queue depth
for a single SCSI device is exceeded and hence the SCSI device budget
map is not needed.

Please help with reviewing the ATA patch in this series.

Thanks,

Bart.
