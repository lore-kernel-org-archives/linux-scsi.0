Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3024EFFBE
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 15:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659780; cv=none; b=mBWE3WV5l/HZsj+mZ82AljMb6J+A/nuiDgrITZnNxnl8BPTUTri85Nz+aiQtpdhrjQuZfg4OKEKn++rUoXH44n8AS8VXd0dDO2gjdENLy11e7+6KQ+n0CRov/PRn+P7FQBKVyKgpIiDCQ7qNKKlW62YFQZQJhL5LiT2cJ9Hs8Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659780; c=relaxed/simple;
	bh=mQmcTpQcG0Q7E2+jMULxcFDpOPPok6A4PSBssLI4KOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ncc2rW+KwDdwEWnqP3Wk+djZEtWfVmdRBpl76ndDcOhaMPEdYOD7ymwPqXizlWgphllVX4UE01w3UAH+8I9UDk4GjY/Dt2z9Au3GqQMOIJPrF5MV71Bi0NNyykBkGgcwGht/A5JlyYSJsjzOaCV+xsmpcVO24Pzw3KZkoKaEamo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HcVSKyDK; arc=none smtp.client-ip=91.218.175.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HcVSKyDK"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mQmcTpQcG0Q7E2+jMULxcFDpOPPok6A4PSBssLI4KOc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789659763; v=1; x=1790264563;
 b=HcVSKyDKZPJclhwvN9laFUF6Bi5MaQJshQ7WJIwxocKuwM4dONZfQnY/sw1Izufg4LwryMfK
 e88p/DEEMrL3ZWjRoN14rJGia96O2rE6rN9JmK+AgPT5cJz8BIXj94N4zO1qKJzOAFmmbxE1rFO
 bs54Hfypfk6Sb9TAXJYQqeW8=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id bc1485c9f542bf9f;
	Thu, 17 Sep 2026 15:42:33 +0000
X-Mizu-Trace-ID: bc1485c9f542bf9f
X-Migadu-Flow: FLOW_OUT
Message-ID: <35ad0b9c-06bb-4ccd-8e58-fde4d859b85e@linux.dev>
Date: Thu, 17 Sep 2026 16:42:28 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
 <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev> <aqu5Q_6EvfY7iRmk@ryzen>
 <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev> <aqvCeq9IsbjSJIEx@ryzen>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <aqvCeq9IsbjSJIEx@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/26 11:35, Niklas Cassel wrote:
> On Thu, Sep 17, 2026 at 11:26:45AM +0100, John Garry wrote:
>> On 9/17/26 10:56, Niklas Cassel wrote:
>>> On Thu, Sep 17, 2026 at 10:38:30AM +0100, John Garry wrote:
>>>> On 9/17/26 09:45, Niklas Cassel wrote:
>>>>
>>>> So far we have not considered atomic writes for zoned devices
>>>> - do devices which support both technologies exist? Or is
>>>> this just hypothetical?
>>> If the specs allow it, someone might build it.
>>
>> Sure, but do they (allow it)? atomic writes have specific
>> alignment and granularity rules - how does that play with
>> zoned devices?
>>
>> I would need to check the specs more on this..
> 
> I haven't been able to find anything that disallows it.
> 
> Trying to parse the specs with the help of LLM:
> 
> ""
> WRITE ATOMIC (16) is a write command as far as ZBC is concerned, so on a
> zoned device it is subject to the access requirements of the zone that it
> addresses, and it advances the write pointer of a sequential write
> required zone.
> Neither standard says so directly, but the definitions leave no room for
> anything else. SBC-6 r02 defines an atomic write operation as a "process
> by which a device server performs a write operation that is either
> completed in its entirety or has no effects on stored logical block
> data" (3.1.9), and an atomic write command as a "command that performs
> one or more atomic write operations" (3.1.8). ZBC-3 r06 in turn defines
> a write operation as a "write operation as described in SBC-5 with the
> additional requirements described in this standard" (3.1.62), and a
> write command as a "command that requests write operations" (3.1.61).
> WRITE ATOMIC (16) therefore falls under 4.5.3.3.2 Write access pattern
> requirements for sequential write required zones, exactly as WRITE (16)
> does.
> ""
> 
> Right now, I don't see why WRITE ATOMIC should not be allowed on a ZBC
> drive.
> 
> 
So what happens when the write pointer is not aligned with Atomic 
alignment? Are atomic writes just not permitted in that scenario?
