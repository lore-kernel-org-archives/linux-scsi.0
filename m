Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9370E48665E
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 08:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790585537; cv=none; b=hlWoDzHXiFBzdoqckMLoYvDLNT5ySHl4hbLGIx4ZqXbl2/tAXRg8EnHvCX0jKZnWF+1xTN8bg9NpNXToe9f8UqaNeJs3fIyoy/8Zt4PXEWhQzFIasdMyoMpt7Gee3xFNJm6qT1qanc1LcgX3Vm6de5WRU1iPthsc30z27hVPfZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790585537; c=relaxed/simple;
	bh=4PSajfsQQKe3Vpi3dWcKVVNKFGRdlMRqvlycjNk5fmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tlcwaLP47l26eM9nSr1oBUHXLJ7x+NEUV3hT59tTPlWztutdNZfDJgdtBldMKVLgLuDE/Q413ZFReFHi3V5C59TAbm9HO86GzQhhwcWpaPsJD1/xXB1fNXx6knbAKFRe+X/HvjarihyHfjQWfDP3+kRaMIJfZFz5RloMOx4V8dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fRVgYGIp; arc=none smtp.client-ip=91.218.175.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fRVgYGIp"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4PSajfsQQKe3Vpi3dWcKVVNKFGRdlMRqvlycjNk5fmY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790585533; v=1; x=1791190333;
 b=fRVgYGIpVDYNCxmFmmMM6Oj1y+suOV2yi+Xg0JWjIcRFgl6WDM/lVvZZjXtXFUL9wCMCgb/J
 xzKSITHsg0x9Aj2qH5/KwXtUKeMFAaoZOeOD6rHwo1j3JnKYT7YzY9Zf2J0/ncOqp36GXHiDfGv
 JJIeJye0t7vPCu9Wn9k5wP7w=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 2fee077ae45f3eec;
	Mon, 28 Sep 2026 08:52:13 +0000
X-Mizu-Trace-ID: 2fee077ae45f3eec
X-Migadu-Flow: FLOW_OUT
Message-ID: <962b3eed-9721-4f7d-b6e6-bc942ba48820@linux.dev>
Date: Mon, 28 Sep 2026 09:52:12 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/11] scsi: scsi_debug: Refuse a short WRITE ATOMIC
 (16) before writing it
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
 <20260925071726.140915-22-cassel@kernel.org>
 <3fc3aab6-9eca-4d3e-81ea-92ee56de2af5@linux.dev> <argI11P7AhIlfKXa@ryzen>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <argI11P7AhIlfKXa@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/26/26 19:03, Niklas Cassel wrote:
> Hello John,
> 
> On Fri, Sep 25, 2026 at 10:30:11AM +0100, John Garry wrote:
>>> ---
>>> Tested with:
>>>
>>>     modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
>>>         atomic_wr=1 lbpu=1
>>>
>>> issuing a WRITE ATOMIC (16) of eight blocks through SG_IO with a buffer
>>> of four blocks of 0xaa. It fails with DID_ERROR before and after this
>>> patch, but before it the first four blocks read back as 0xaa afterwards,
>>> and after it all eight read back as they were. A WRITE ATOMIC (16) with
>>> a full buffer writes all eight blocks, as before.
>>>
>>
>> What is the command which you use?
> 
> SG_IO, with a CDB for eight blocks and a buffer of four:
> sg_raw -s 2048 -i aa4 /dev/sdX 9c 00 00 00 00 00 00 00 00 40 00 00 00 08 00 00
> 
> 
>>
>> I am just wondering if this check should go into sd_setup_atomic_cmnd() or
>> somewhere else higher up. I mean, this check is not really specific to
>> scsi_debug, right?
> 
> sd can't produce a short atomic write: sd_setup_read_write_cmnd() derives
> nr_blocks from blk_rq_sectors(), and the data buffer is the same request,
> so the transfer length and the buffer always match.
> 
> A mismatch is only possible through SG_IO, where the caller supplies both.
> 
> SBC-6 4.28.2 puts the requirement on the device server: a failed atomic
> write must leave the LBAs unaltered. scsi_debug is the device server here,
> so I think this is the right place for it.
> 
OK, I think that the important information is "4.28.2 requires one that 
cannot complete to leave the LBAs that it specifies unaltered", so maybe 
add a small comment for that.

Reviewed-by: John Garry <john.garry@linux.dev>
