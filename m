Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00481225CF;
	Thu, 28 Mar 2024 06:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711608843; cv=none; b=g17ElAKzAtBAiW2pxQBt69bi5SvqPPrEuGRXNbrGkzz7imrgY2bSDQoXJcVIKoZ26++1lWjv5SmxH6k0YlIO8IijVC7r87WlDoyKyoRxKI7iI4BCsIoCDkWKQk49Ti6vFGqSNrekO8NT6oUljpcpNlM8CCk8j/HTTf6nPJcaMzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711608843; c=relaxed/simple;
	bh=QD8flYEO8Q6NBPd8BtzH+Rj81pW2lJaMX765KevEl5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DTvqwJSgQ7Bd/OtvPJJvV2kXzSncq/zP0yTm+CkBVvY5N+w0Owyq0y+0PPSjLxwJaL9jJ77eIXZ7rOy+Kxz628KcOSDMQNRLrtSSrsGW2Zr3Ohtahl1ZLYqV+UQXMJzfjfnwHJLr01grJ4Zd/XugCWyTAwrD3fzHMrzHjyzmv8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6kQ4YCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6kQ4YCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF19C433C7;
	Thu, 28 Mar 2024 06:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711608842;
	bh=QD8flYEO8Q6NBPd8BtzH+Rj81pW2lJaMX765KevEl5g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m6kQ4YCZs/fyfH2pBg7q3ydUlAxyF+3x09RDNHUgYPzgMlJgyCe5MC0OCaXZjy03q
	 fUMyRUUFOpKncSMB2igTgYU6B0HDJ92FsD4DvO4JwII3WpTq7C8FmP9/Ra7+SQFbKb
	 pNWJCpmTZPaZeqyCdjCLGlAlVQAc06guQu5/o0NZTr6EZcJGzJzl+m3Dh8jrQqqys3
	 r96xl2xg+6CGA2/3JTw7oqAalKw99W09g+gwHP5m9ZcjL594knWVBu15NbGw3e7I7r
	 pprxQkZbZMIYKTuEoOgtetKe6hi0yLqWKfXlFeh90wx7loX1/DreGXFK+B/xs0JSF0
	 3ZLMwZzWwdmMg==
Message-ID: <7587193d-f4a3-4a2c-97d9-e5ea8e9fdd0e@kernel.org>
Date: Thu, 28 Mar 2024 15:53:58 +0900
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
References: <20240328043016.GA13701@lst.de>
 <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org>
 <20240328054652.GA16237@lst.de>
 <7d8f3ec4-c416-445f-92db-7d2b60726821@kernel.org>
 <20240328060357.GA16819@lst.de>
 <ca3fe7b0-7e27-4ac9-b669-5263c3cec550@kernel.org>
 <20240328062237.GA17225@lst.de>
 <0d54c569-f586-4b75-a8a3-509e3f3717e2@kernel.org>
 <20240328063816.GA17642@lst.de>
 <b144a7f1-af29-4c0d-96f7-c0f16b2299b8@kernel.org>
 <20240328065256.GB17890@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240328065256.GB17890@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 15:52, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 03:51:09PM +0900, Damien Le Moal wrote:
>> I am all for not micro-optimizing the free path right now.
>> I am not so sure about the mempool being simpler... And I do see some
>> improvements in perf for SMR HDDs with the free list. Could be noise though but
>> it feels a little more solid perf-wise. I have not seen any benefit for faster
>> devices with the free list though...
>>
>> If you prefer the mempool, I can go back to using it though, not a big deal.
> 
> A capped free list + dynamic allocation beyond it is exactly what the
> mempool is, so reimplementing seems a bit silly.

OK. Putting it back then.

-- 
Damien Le Moal
Western Digital Research

