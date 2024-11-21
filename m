Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E42B57C93;
	Thu, 21 Nov 2024 18:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732212026; cv=none; b=rusDq8quHP+hjKrhhBf5IEf3Z8uBiiZgRWP2HPiCIbvLeIR3Bd0U3p6DtPGO2G84It32+tC91Pc4bh/imvr09In2GWg9qQ2DTS7NpXDWd3JC05aAqAa0stgbkV4GPPzR9uNGyfblZKOxUTsH4WTspEpy5Fl93P060NdwyasxN8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732212026; c=relaxed/simple;
	bh=cuu4lQv6lTc2r66HcLz0Mn3hWTfN3ayWUwMZ/ibap10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RnL+dAGmxQ6Ud39dROu6CGiUx3reHq+++Z9dHT+/U+Q1puRYih9eGqABkb7ATHGCXmzGGSyiKXjil08i9SL7YiJH2QhiD2LOBV9c1iwnLmB5+llcACWQO+JGhaNZpwPA09O+G+eafb0wgD+X+IK/S64Znv7HlxKRpRdf545JZrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aUc3cjLy; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aUc3cjLy"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XvQxZ4jb0zlgTWP;
	Thu, 21 Nov 2024 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732212014; x=1734804015; bh=cuu4lQv6lTc2r66HcLz0Mn3h
	WTfN3ayWUwMZ/ibap10=; b=aUc3cjLypR5zQKvwJY0pCh3DWOyJt0ZGz1wgK5wc
	vvF/6XkC/t1l3GF8hGc0NE82RbjNJv0TblRV/ln4TUy6Te35wnqsRzCjdbcwX8Tt
	1BaFh60LUJiIHaqfmFcEmUK78JQUnfk3dy/MEpJI3Yk8YIPEQ4LODFVj4JZ24XXk
	n+HsL0FtP5j8PIfH8HqozgkOjT5CS5S/NqBlBFL/O6D7J78N75o/ICcO87FK9ALm
	9dq5nEgdmtyKgTjtvLYCwnQkr4foYJO0HehgmwLKwI/cEqiGbLefYWyluO1Z1oyk
	goizGHJH+uyFCW10IibQipTNj+3XhNE3i7cNJBDPdVWuWA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id srRY9R4UBMIg; Thu, 21 Nov 2024 18:00:14 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XvQxR6k4KzlgTWG;
	Thu, 21 Nov 2024 18:00:11 +0000 (UTC)
Message-ID: <9f26b8a8-f6b5-4329-a899-a2cd1bc51851@acm.org>
Date: Thu, 21 Nov 2024 10:00:10 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/26] Improve write performance for zoned UFS devices
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <95ab028e-6cf7-474e-aa33-37ab3bccd078@kernel.org>
 <de43ae13-240a-4653-b8ac-f36c433d9ffb@acm.org>
 <d594be95-2cbf-4f9c-8508-d7adcedb148b@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d594be95-2cbf-4f9c-8508-d7adcedb148b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 7:20 PM, Damien Le Moal wrote:
> I am only trying to see if there is not a simpler approach than what you did.
> The less changes, the better, right ?

Hi Damien,

I agree with you that we should select the simplest approach that yields
the desired performance.

Regarding the proposed approach, forcing unplugging a zone write plug
from the driver once a command is passed to the driver and the driver
did not reject it, is this approach compatible with SCSI devices that
may report a unit attention? If two zoned writes for the same zone are
submitted in order to a SCSI device and the SCSI device responds with a
unit attention condition to the first write then the second write will
fail with an "unaligned write" error. This will have to be handled by
pausing zoned write submission and by resubmitting zoned writes after
all pending zoned writes for the given zone have completed. In other
words, if higher queue depths are supported per zone, we cannot avoid
increasing the complexity of the code in block/blk-zoned.c. If we cannot
avoid increasing the complexity of that code, I think we can as well
select the approach that yields the highest performance and the fewest
changes in the block layer code for regular reads and writes.

Thanks,

Bart.


