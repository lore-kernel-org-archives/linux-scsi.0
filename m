Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CC42580FF;
	Thu, 16 Oct 2025 20:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760647823; cv=none; b=qH/aBWy+qm6y3d6hTIq1JlQbn3cT9w4Sry8K6BwTVxlCPEFfVs+t6nsbZ9xMECYnpCOZ5W/KljCvxifVcOpdWtl1lnLwt4D/TYOus3YW8aHcTIu5/Jnelg6047rHHNE2pO6X8AZGOM/GInmbNDiuQVnP1w8V0N65qnzogBATfLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760647823; c=relaxed/simple;
	bh=q0LriYbVBMKSKKnUMEM4X7PxLruGGt8QKzX3/m18MFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ClzmKMKNX5Rlv61QWOWz/YH2rr2ifyR4VgQ4rq0N/G/YiZf7Jv8zPq5VT6HYVwo7SqPrz2P/QasqQ/qWT5NE+ljF5pSY0jqQK2XF/H/5rNjY9NEZ1/kx6gUqSexdpjQpTyLaNGd5ljqJrohFGFIiF3KxG1k7SOycvyMVGs7PkuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Hh0Aosb3; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Hh0Aosb3"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cng7w3xB0zm0yVW;
	Thu, 16 Oct 2025 20:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760647819; x=1763239820; bh=q0LriYbVBMKSKKnUMEM4X7Px
	LruGGt8QKzX3/m18MFY=; b=Hh0Aosb3JDOmEwwb/GXvdgxjMPlgl5tnZA4oPTRa
	Vy/PFwhqq9muppQLQsD0RdIEAnTqzaMrhRwa8hpcUTRiIJqqPkae6iLS87qP13SU
	cEDwsUY28t9MS+OeN2SCDl1rLfISVpX/qu6EoYzV3RCSD/yPWVQnmKZL5f9flk7m
	ni9FTgo98qZXmbyP1FS1ikXCQCG0d5csoAu67XwEeWHpLk41SlbkXvzUQ1D99iZq
	WnBZ5Mc9PTQYo7fSZeGQKYzzuhh9ReANNtQzqs06V8b+H9QeL8gjzesC1LFhGEOj
	4fPcECXogpWy9xekLqq/C9MZYUxZBqmR2xP7T/wbNsklAw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WERkQ4Ikx9sV; Thu, 16 Oct 2025 20:50:19 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cng7q6sVdzm0ytS;
	Thu, 16 Oct 2025 20:50:15 +0000 (UTC)
Message-ID: <a1850fbc-a699-4e73-9fb7-48d4734c6dd3@acm.org>
Date: Thu, 16 Oct 2025 13:50:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v25 07/20] block/mq-deadline: Enable zoned write
 pipelining
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org>
 <20251014215428.3686084-8-bvanassche@acm.org>
 <08ce89bb-756a-4ce8-9980-ddea8baab1d1@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <08ce89bb-756a-4ce8-9980-ddea8baab1d1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/25 12:31 AM, Damien Le Moal wrote:
> it seems to me that what you are trying to do can be generic in the
> block layer and leave mq-deadline untouched.
Hi Damien,

After having given this some further thought, I think that write
pipelining can be enabled if an I/O scheduler is active by serializing
blk_mq_run_dispatch_ops() calls, e.g. with a mutex. For mq-deadline and
BFQ a single mutex per request queue should be used. For Kyber one mutex
per hwq should be sufficient. With this approach it may be necessary to
use different hardware queues for reads and writes to prevent that read
performance is affected negatively. Inserting different types of
requests into different hardware queues is already supported - see e.g.
blk_mq_map_queue(). Please let me know if you want me to look further
into this approach.

Thanks,

Bart.
