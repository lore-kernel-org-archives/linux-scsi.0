Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4468624EA85
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 05:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749794146; cv=none; b=KGp+OtBw7Gt+TQVFNrmlk9AzhiFSAzkzTbjbDxHD5MSF/hKvARdXKCqQdjF8pHgAB1ulls/e3nB0fwQJ8UR48a4/bt4oQk315nn0Du2YbTQ+GRZDtom63tJtCgLAmhhu5Xs7YxVlR5LBp5tEEanDAgx4u8sukBNA68bwr4w6xMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749794146; c=relaxed/simple;
	bh=id2Qawk6HEDioTtq7MZUslREVBdlxPdr2aKzkIxeBk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F+Kz/M8seVzBiwjUeUxl/Wf2pcO/tiOuWhj0dsE19NN7Ej3SRJ5EJFgIDGmGH8HMrbASBUzh66q5Y/moVovhT+JRJv9wJNTQiLUYt8mb2dLzNFQcGgw35qP1mmu2kZv8ksWso0Z3uA2soHpl+shlO8/2q+fTCXhbl+86On5JWZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a3qUAn7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a3qUAn7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF2CC4CEE3;
	Fri, 13 Jun 2025 05:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749794144;
	bh=id2Qawk6HEDioTtq7MZUslREVBdlxPdr2aKzkIxeBk4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=a3qUAn7Pbyn3UnH7ecjHo3soG0ygSMAlbxhMD5LaWSc6BZ764T+BUT4NkarPyv62a
	 2J/4qeubsYL0u/BQtydgj/UavtS8o0zPIbw4AyXRXWzcdITyUolAoqTS0PCuVd9TGT
	 4Gkc5eaAiir4XVrMEdzqM63EKadZJKGYk/SjmdoJ/LVsom2mGKLJwJdmd8YmkDl0ws
	 Qs3RQQTzJhPcvsJxT55kyPHlgUpPQYfcUG7DoBD4fTwmnpo14Q+110LYvyYwgiST6m
	 I8C3ABpyTtTzWeBAVe2zL+NOXmVTeB2IY52WRlVzOq2a/z2AqwQXB63oULSRdP2MRw
	 kKv6bMkXrI8Hw==
Message-ID: <bdeb7235-3295-4cd9-b892-60515b76c366@kernel.org>
Date: Fri, 13 Jun 2025 14:55:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] scsi: sd: Prevent logical_to_bytes() from
 returning overflowed values
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250612060211.1970933-1-dlemoal@kernel.org>
 <20250612060211.1970933-2-dlemoal@kernel.org>
 <9cabd627-b22b-4ef3-87b0-cb5a9a97aea8@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <9cabd627-b22b-4ef3-87b0-cb5a9a97aea8@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/13/25 00:53, Bart Van Assche wrote:
> On 6/11/25 11:02 PM, Damien Le Moal wrote:
>> Make sure that logical_to_bytes() does not return an overflowed value
>> by changing its return type from unsigned int (32-bits) to size_t
>> (64-bits).
> 
> size_t is only 64 bits on 64-bit systems. Shouldn't size_t be changed
> into u64? See also https://en.wikipedia.org/wiki/64-bit_computing.
> 
>> -static inline unsigned int logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
>> +static inline size_t logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
>>   {
>>   	return blocks * sdev->sector_size;
>>   }
> 
> Since 'blocks' represents an LBA instead of a byte offset divided by
> 512, please consider changing "sector_t blocks" into
> "u64 logical_blocks". Independent of this patch, "sector_size" probably
> should be renamed into "logical_block_size" since the word "sector" is
> only used in references to "physical sector" in the SBC specification.

Well, one could argue that struct scsi_device is SPC territory, not SBC, and
that "sector_size" or block size has no business being in struct scsi_device.
But changing that would not make access to that value easy when all we have is a
scsi command :)

> 
> Otherwise this patch looks good to me.
> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research
