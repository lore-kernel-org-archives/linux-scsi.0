Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D73C5223;
	Thu, 28 Mar 2024 06:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711607598; cv=none; b=UQgphOzaCEHbN6W0ZjNvxKXfD80OfaQrdydOJuFgfzBICkQjcSWYH73REMT/gcahDPcKsLSUvBSD1EERTVmn7pGBSRc1/Pup4NWj4S2aaqZqRkBogCmLrKqFsILoqdC0v1Mz8twVuLhDhG0Ok1XTyo6w6uri+Jvr7Ob5Dqofd2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711607598; c=relaxed/simple;
	bh=pnn1rBwl7okz5KQPjjIbUYL83lIbFWVfob8arJ3eTdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OKCmJLjFyrGRs5LSeH+BZ585OtaaTQf5BMzaOvVTXEF5vmH8aph5faRB1JUXAsQKmBScACuOEhP1hnJYmzLzZu/vS7ZBpUEng5JOYq4XN3S0snXhzcNQCkO8vkGPiXPkCOo9a1wBOTJaSUOkicHlGraWG8ewaMsvX/8L09EZnCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DEOpjtjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DEOpjtjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450C5C433F1;
	Thu, 28 Mar 2024 06:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711607597;
	bh=pnn1rBwl7okz5KQPjjIbUYL83lIbFWVfob8arJ3eTdc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DEOpjtjoDphsjzqdfmc+oW2z5RKEb/O3BRxBr+5ZaPPENY5oyeQdFzZM4kznRPHly
	 NG+N+UvvDvfLwggfdcHnalD2qpotFzOqdXGXXQz0hkPjuc08RHBs/j6Rxd9UQW6oAF
	 hKlu+ho4Zssg+R2jls0h3rulj4p/NkKKu1ej/n9O/rfI/ZlEECWGyIXlzv2d3MsC7y
	 jJiGqZeOXzH+kRUlg6xtyyDw46kgezKugWLBDWDqS5ESBAwLG6r85hR18XiXHUtuXl
	 UN6h+8WRofRiDFWJjrB+7C6ioGaLyWE/UJ6a0/zVzRjp640N5ktClLgXY+pkDNj8rU
	 AoWGvpq7X2C5g==
Message-ID: <0d54c569-f586-4b75-a8a3-509e3f3717e2@kernel.org>
Date: Thu, 28 Mar 2024 15:33:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-10-dlemoal@kernel.org> <20240328043016.GA13701@lst.de>
 <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org>
 <20240328054652.GA16237@lst.de>
 <7d8f3ec4-c416-445f-92db-7d2b60726821@kernel.org>
 <20240328060357.GA16819@lst.de>
 <ca3fe7b0-7e27-4ac9-b669-5263c3cec550@kernel.org>
 <20240328062237.GA17225@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240328062237.GA17225@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 15:22, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 03:18:46PM +0900, Damien Le Moal wrote:
>>> Yes, bt it can use kfree_rcu which doesn't need the rcu_head in the
>>> zwplug.
>>
>> Unfortunately, it does. kfree_rcu() is a 2 argument macro: address and rcu head
>> to use... The only thing we could drop from the plug struct is the gendisk pointer.
> 
> It used to have a one argument version.  Oh, that recently got renamed
> to kfree_rcu_mightsleep.  Which seems like a somewhat odd name, but
> it's still there and what i meant.

Ha. OK. I did not see that one. But that means that the plug kfree() can then
block the caller. Given that the last ref drop may happen from BIO completion
context (when the last write to a zone making the zone full complete), I do not
think we can use this function...

-- 
Damien Le Moal
Western Digital Research

