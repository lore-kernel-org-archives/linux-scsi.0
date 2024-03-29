Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D26A20319;
	Fri, 29 Mar 2024 18:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711738708; cv=none; b=fplBxFpHfxGZIJsi9CPKU8YgaFbk/4DCoK/AFwr4AD6fKF3qiu1LdT6J2plTwsiTSGXvD+O5Vii8BCG2Wbfr/sw7d+NXj2jvQpt/DuvGqw7yH4Ayq93upje1wAswP599L3ZDHrVDCdRLbZi5+EXp5yxpS/ytGNA2r9dNoN8qU0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711738708; c=relaxed/simple;
	bh=5qj+CGEo3kCIwcFnzWLiZGVe4rTmDz0G9iv3+MSmWr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FLrunjtRxwQzVyDzNNwsvFQdEhx+BpPcf9Lz6QdxIT2fScsnSWbGXi0vBElwk7TOjku+gUhNk7iDGcc9myw9pxiFs0A+KK3NGKaDIjv2DobkPzyeEshOFgqvow4zmwZgu79Y3uCxbWn5LMV1X7G5HuQqQqeH73Xz0lVEvvgo8cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aZK3ck9k; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aZK3ck9k"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5qS21xVtzlgTGW;
	Fri, 29 Mar 2024 18:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711738702; x=1714330703; bh=5qj+CGEo3kCIwcFnzWLiZGVe
	4rTmDz0G9iv3+MSmWr4=; b=aZK3ck9k96DkGCo++TkJg93Z9sLPP8i0leIhQMlj
	q4EYZA0FtdpxI+TH505xfcSHMHNoAP6qkZ6nI87CfT15/yEBwWC9q22tBvq+vg9v
	0fZR4Eaj1lIEGMdOD2zPVmWYr7gtA5kABe6laYhUigJltmo/5Efkn+r0J0BMNnge
	3L7KzbTNar4k4a43bcpSBgNmHRwul/6nnfBT/3YBoXy67U8HSmQyydUia9uUIBT8
	yUKyRT+d24yBLXAEST6ya7QBTg8SHEPIiN5fNJsgVPF/tC4dsi6pmUM1KmhBZUQP
	lTJVoF15v4PgmJepBkWgjSDDC1fBaw1Dt7sNJhCPV9lZ9g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XlDOypg29ZJo; Fri, 29 Mar 2024 18:58:22 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5qRw31PXzlgTHp;
	Fri, 29 Mar 2024 18:58:20 +0000 (UTC)
Message-ID: <e02798a5-ce10-4ff1-9fb0-38980b8c5e72@acm.org>
Date: Fri, 29 Mar 2024 11:58:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/30] block: Do not special-case plugging of zone
 write operations
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-31-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-31-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:44 PM, Damien Le Moal wrote:
> With the block layer zone write plugging being automatically done for
> any write operation to a zone of a zoned block device, a regular request
> plugging handled through current->plug can only ever see at most a
> single write request per zone. In such case, any potential reordering
> of the plugged requests will be harmless. We can thus remove the special
> casing for write operations to zones and have these requests plugged as
> well. This allows removing the function blk_mq_plug and instead directly
> using current->plug where needed.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

