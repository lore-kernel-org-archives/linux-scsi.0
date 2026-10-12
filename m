Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4466948C3F2;
	Mon, 12 Oct 2026 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791817173; cv=none; b=uS2J8tAsyYv35pidwEUTJdV/wa7uttYMJL4vJH5IafI0jT602VmwFcmzoDEAj953JLZJ1Oirb/sLQU+k6e/lo0ApwWdB/s5lKOHmzPW/te+4rbmpFVrJGnu5SE2TuWH///jeLQa6LOW9zX0M7vAoT53D8SW8MVBk3b+qEvCU1YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791817173; c=relaxed/simple;
	bh=mAXTGSONz2rJvCx1XStNFEm2ROV3Ll3i4cpM3ltIm74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bHWtjDuvh/WJowkhPmE6+yIilabRZOyxTy991UqjOkkItlZZG6hgpVOja+5W1jFWKIy5sjey+B0KYabQv3wUWSBmi7Ka7P4BwKIN9qe15rShUE//abzDusnw1hKJFQucAZIeSB+zAc/T5IUTzjEgZv5FAM7ky6O0AoUsPysCwgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCo6t8XJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCo6t8XJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B871F0089B;
	Mon, 12 Oct 2026 14:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791817172;
	bh=jMdiwXW2JOQOgGJ7nBKJGOgVz4q4YkdsWA5uhBXOkYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mCo6t8XJEVvyBuL4FUDkACiVZGQv5eu9hmkeL2ZJ6xyyqdyC0PJmKP7YNXX2V+UlG
	 RhcNvaP7A5zfdJFBqADguprqgnnxtZB+3W3OQmZm0rPOPDnFvWpBZSmv75/2WNhttf
	 t4RYhIDQRPF7E5lIMBg3TExU6UzefSBybKg9P7L3xo8G7SmE4YfY3BIZGnuHqDfZEc
	 8kLVgYYvwZeN+88JgxlB2id54X79fBbDnIbtHrqyoFuv55rHhOqsEfsS3k4yfbJ7eF
	 AtcGeP5eKVwmwJrc0QTeC6a7Sk1mxLWbHnQFxzrPJc2uQ4TcPEg64HnVa/TKQr4iiM
	 1vyp6uOHuTfBw==
Message-ID: <7fbd590f-03d2-4963-8d73-851fa0eb08fb@kernel.org>
Date: Mon, 12 Oct 2026 16:59:29 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/9] block: add storage element management ioctls
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
 <20261012130121.1902634-5-dlemoal@kernel.org> <20261012143146.GB8609@lst.de>
 <46272028-d50a-40fa-806b-186f1f9575c2@kernel.org>
 <20261012145740.GB11255@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261012145740.GB11255@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/12 16:57, Christoph Hellwig wrote:
> On Mon, Oct 12, 2026 at 04:56:18PM +0200, Damien Le Moal wrote:
>>>
>>> Sashiko is obviously confused here about partitions that aren't supported
>>> on zoned devices.  The conventional zones argument isn't entirely
>>> stupid, but also not a great one.  Maybe we should add a check to just
>>> reject the ioctls if conventional zones are present, as that would make
>>> a mess of the depop anyway?
>>
>> Not sure sure it makes sense. 3 things can happen:
>> 1) The conv zone goes offline on remove
>> 2) The conv zone goes read-only on remove
>> 3) The conv zone content is totally unknown on restore since that is a
>> destructive op.
>>
>> So the "data loss" comment makes sense only in the case (2). All other cases
>> lose the data anyway. As we make it clear that the user is responsible for sync
>> & no io before issuing a remove ioctl, I am not sure if we really need to do
>> anything special here. And we cannot really do anything special since we do not
>> know which zones are going to be affected. So either we do nothing and let the
>> user deal with potentially cached data not physically accessible anymore (not
>> great), or like here invalidate everything.
> 
> Maybe add a comment?

Will do.

-- 
Damien Le Moal
Western Digital Research
