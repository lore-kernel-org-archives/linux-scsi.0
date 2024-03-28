Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F6F2B9A8;
	Thu, 28 Mar 2024 06:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711608185; cv=none; b=BnMqi/J20i7v2z62Lkbw+xpTeJFlDYnapiM303sXTWv42fymmREQKrzXQcD/BH7GxMiVdTmQCSfjFOnhx0g99RDHt8da/3OYmZTCFvsUomZWmDhWcdeq7eaICZijgLnPN863qSLlUkm/GaxU/FEqtXbdfQnQe3UDUukQv1Z6O9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711608185; c=relaxed/simple;
	bh=yPA8SyoA2brBq0mJQaKnU2hLNt90w9F+QYsLCClR88I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bcF9FrAJWVlFkdm8QvL2XatyE5G3GyT/8EmIooEHiboKE07WCyWwwQK7+Uy3jMkQNa0Gohcj4Bm3oiYXEqMJiTItrsMkcFIl5js9/czl/1ymtHOArKbAFtsX/M1uv6y5PBe1HazDhJmabV7itX5WymAwNxletBMleaLq3YSOQYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SifEzXyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SifEzXyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF78C433C7;
	Thu, 28 Mar 2024 06:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711608185;
	bh=yPA8SyoA2brBq0mJQaKnU2hLNt90w9F+QYsLCClR88I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SifEzXyPGr5YdYZ3yVsUb//eWSbH+aFjM2uMorHd8+Lrl2aeWObv/9DKQMvi75cBZ
	 IE1TnNlBR/j1UkiN1fO7Uird09tSFH2hJQnvtIuOuTuauxWvW0rFNVJ8TvYfI9zlsy
	 AOsxtoMdR676g5muFbVzaoRzwqAWsj8/9r24AO8iTXXABzfpdyOc6JMz2D8N5VDgeq
	 8OITcYYUq8Zh5LhDTdXWik7i8rdTdMzFWHoYAGc6NSJ8RRigefQEkK6jVQbFPAk4ab
	 akxD1n5tVGfy7hgFm90eBjENusNtn7sIRZ2zI2ZuYbN1drKug39o/C36cl5aDtJHdo
	 qKfDNmjJJn6fw==
Message-ID: <6035bad8-b157-4705-8ec1-80cc003fa646@kernel.org>
Date: Thu, 28 Mar 2024 15:43:02 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/30] block: Do not special-case plugging of zone
 write operations
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-31-dlemoal@kernel.org> <20240328045430.GN14113@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240328045430.GN14113@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 13:54, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 09:44:09AM +0900, Damien Le Moal wrote:
>> With the block layer zone write plugging being automatically done for
>> any write operation to a zone of a zoned block device, a regular request
>> plugging handled through current->plug can only ever see at most a
>> single write request per zone. In such case, any potential reordering
>> of the plugged requests will be harmless. We can thus remove the special
>> casing for write operations to zones and have these requests plugged as
>> well. This allows removing the function blk_mq_plug and instead directly
>> using current->plug where needed.
> 
> This looks good in general:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But IIRC we recently had a report that plus reorder I/Os, which would
> be grave for the extent layout if we haven't fixed that yet, so we
> should probably look into it first.

That is indeed not great, but irrelevant for zone writes as the regular BIO plug
is after the zone write plugging. So the regular BIO plug can only see at most
one write request per zone. Even if that order changes, that will not result in
unaligned write errors like before. But the reordering may still be bad for
performance though, especially on HDD, so yes, we should definitely look into this.

-- 
Damien Le Moal
Western Digital Research

