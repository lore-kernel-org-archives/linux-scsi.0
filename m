Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C27285CB7;
	Mon,  7 Jul 2025 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751922725; cv=none; b=r3nVGPHzMkTe8UwZp5JaaRastPu6cDMn5jrPtR26wmqQba/Mwco4W94iF4oL2YClZDfinIvuUJzzjeF+ElhZrQ4Gw+DkAYdp25s+u/3/d2EdLJDyIaMCc8W1ZgIQvHAZ3Tfja5MpqC1CfhVPxc+mJmbcWbit9jsgPJiuDidCJZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751922725; c=relaxed/simple;
	bh=r5I8t8Pp1vaoSeXwDh5f86XWK7k+0Uq9uft1zZnyglc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UTCXuOZE+3cMzpi7ZaF8hc6qJL4GSnj+9uZ9ZClxqkBLi6yfX6m1L0ghheqxj3Pv3xV8UlttyT7C7s4ldwvrU5qFppFUPeIf6qIsXaynX+iYqCUjoh1W5HQ4iTDkOfdeLZO2UA6if7Og1nU0jVHLpDIWpJ1KACFPf1ySilsexZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=d1b/HOfk; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="d1b/HOfk"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bbcPZ5ycmzlfnBk;
	Mon,  7 Jul 2025 21:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751922721; x=1754514722; bh=r5I8t8Pp1vaoSeXwDh5f86XW
	K7k+0Uq9uft1zZnyglc=; b=d1b/HOfkAwacuJcGjU96tXF/uAOl6W4/ci5AqqnE
	03F/rGVGbKvue1hylax80gXVWA6LQDRPSSnOGqWV69bTFEj6jHWoPNoZy18GpUwl
	J/Giw09WuPHAEHk+Rf3ii5CoJenQ1617ltnZF0aEgDgu2nDPgKGvpMAYQ5viujkN
	/ZHgjAG9DTc/23yhqxfwGlC8VfoIK7bteo7TldUfFOdRGtQmuXY1pap0QPKM0tce
	AdlzdkObmiEnaKKi1KqRP1Tizb2oH9eVEciUyXsH1Hegq+d/HKfgrPMfhIncm719
	06qzkBy6khGnzcyfF3811cYwmKHflbwsbJ4tasZq96OcPw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id d-e6BEXTF-HD; Mon,  7 Jul 2025 21:12:01 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bbcPR6q9XzlstRT;
	Mon,  7 Jul 2025 21:11:55 +0000 (UTC)
Message-ID: <6d13fd24-6579-45da-8c81-fd2930680b6c@acm.org>
Date: Mon, 7 Jul 2025 14:11:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 01/11] block: Support block drivers that preserve the
 order of write requests
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
 Nitesh Shetty <nj.shetty@samsung.com>, Ming Lei <ming.lei@redhat.com>
References: <20250630223003.2642594-1-bvanassche@acm.org>
 <20250630223003.2642594-2-bvanassche@acm.org>
 <0f9f5900-b7d0-4df2-8c05-fc147c991534@kernel.org>
 <a7b5b394-ed7d-4f57-96ba-ff14375b2e7b@acm.org>
 <a97a31b0-bb6c-4c7a-8d51-d2f723a2b650@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a97a31b0-bb6c-4c7a-8d51-d2f723a2b650@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/25 5:09 PM, Damien Le Moal wrote:
> I did suggest that you simply should plug all BIOs, always, and have them
> submitted by the BIO work for a zone by scheduling that work on a single CPU,
> always the same CPU. Doing so, you can distribute writes to different zones to
> different CPUs. And if the submitter process is not bouncing all over the place
> (being rescheduled constantly on different CPUs), there will be no overhead
> because you can simply run the BIO work on the current CPU.

I will look into making this change.

Thanks,

Bart.


