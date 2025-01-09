Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5288018A93C;
	Thu,  9 Jan 2025 19:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736449916; cv=none; b=esbN9JLSiuG7oWCT3jEIRHyBT4IU3SMM1cPQBMTzuSpSyMc++OLCXXvzEz+eYuUK5fKc14JmT4FLsE0RiCaG/znBukX/h0Rlp6qGj4NYASIAqyqgPDqojhY8Vz3T7qiKse3TKIM/02QgHXxLYQBCBhi7oaRpiVpmxg85u+hP2rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736449916; c=relaxed/simple;
	bh=PUv5QuECKZd605ux8za66qKuTL8CmI4UvNBypR/0ANQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nf7auLxJUJkb3h6lG3RZsqDi3jbvY8LV1d76zQwlW5/G9iy8B5nYUj0PwtiJpHtYizQdGRc3zQ/ngw2ikWdgNGPIh5XxVx9P//Hg1Hm6r+7VseyU2RD2JprqvYcXr6Opwwx5Be4MYD/95TV+lxGkDzax/YhkLRwSavPieg1sVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PboNBrpX; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PboNBrpX"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YTZCY4PGRz6Cnv3g;
	Thu,  9 Jan 2025 19:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736449910; x=1739041911; bh=8yEQXc41uFx7LEv1QdCpk8xK
	Yo1UjhzW1gsgpb2iJ+M=; b=PboNBrpX48ts49BpZbj4FKoCHzM/NWK4YGsQ4an3
	T/81gxUxkjlCDgQDEN1Y39dHoG7XOGycUG1cuDoX8vgBAAERVZJSCgc2wbMi5DsK
	21YVUez0VWYHnH48RUe0TCU+OQTaZRgekZdbzN8AM7clu/u92ko4iEl6L7KAQXxm
	KR6IfIVcMRC8QF/StfMy5c9DETJTwwvSmY9CQD3tNWKs0oLyN671Fhx4sCIiF+0e
	PoZGl7ttylUz1+gy5alEJwvSpfvNJRIF3CMymEdvd9AogM9i6A+0IDrQkfnzxyWh
	YDSJZFD+pE00qEq7b1jWON+ug6q7PHMfwa0UAl9vJLZ9jw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UqjixQfsEBva; Thu,  9 Jan 2025 19:11:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YTZCS0C4dz6Cnv3Q;
	Thu,  9 Jan 2025 19:11:47 +0000 (UTC)
Message-ID: <8c0c3833-22e4-46ae-8daf-89de989545bf@acm.org>
Date: Thu, 9 Jan 2025 11:11:45 -0800
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6729e88d-5311-4b6e-a3da-0f144aab56c9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 6:57 PM, Damien Le Moal wrote:
> And we also have the possibility of torn writes (partial writes) with
> SAS SMR drives. So I really think that you cannot avoid doing a
> report zone to recover errors.
(replying to an email of two months ago)

Hi Damien,

How about keeping the current approach (setting the 
BLK_ZONE_WPLUG_NEED_WP_UPDATE flag after an I/O error has been observed)
if write pipelining is disabled and using the wp_offset_compl approach
only if write pipelining is enabled? This approach preserves the
existing behavior for SAS SMR drives and allows to restore the write
pointer after a write error has been observed for UFS devices. Please
note that so far I have only observed write errors for UFS devices if I
add write error injection code in the UFS driver.

Thanks,

Bart.
