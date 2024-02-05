Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CC250244;
	Mon,  5 Feb 2024 23:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707177341; cv=none; b=lB0l06Ykru+wq23szNyN8X/D/m861fylPrRFPNNZ+PFKdUdnzcnoi8cPu+U4O2PF71QGcroLCAPn4niBTR6XyvQNLP83HnGvoAAg97LjhuJ1Kd7fOY78XQTZ4hBIkbTQOqGzWVknL/o6KmWG1MLHMXnsbmPSHJyfGjPtAnOI8rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707177341; c=relaxed/simple;
	bh=iVyuOEs6E9xsZkuZotl8oHTiPtaPa+nZmTTnG+SCDO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IGku3dDrQgeIsxvtH3dt9k2QAnWyqGe8AMFgLE/a91XiGkhrN0WK3XOHT+zWI4XMbtTejhJSEbNNBvHouDxBwZgNc2Btvyzjlki3PoBHUJ1V/74YxruqIr+PaFQSoHP5chk+SfvjEdFSiIrVsrjH2xKkby/yrEEaW6Jym57bzNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QaZSK6za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QaZSK6za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD0AC433F1;
	Mon,  5 Feb 2024 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707177341;
	bh=iVyuOEs6E9xsZkuZotl8oHTiPtaPa+nZmTTnG+SCDO4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QaZSK6zabWZcbIreqyBNRCyY4FVk3OTEd8ms6551DLHichy59tBuKC1+iufG3myyH
	 O5NBbNBBuTTsoKHoFo8Wh2ioA7c2tQ701MScCXtcYQVRWqWbREgAq9nSJnJlEf3KF/
	 r+SYyHoLDeWXSc9pKtFZ4ZrVvnukCTGMT+iBgvPc9g0aRRmzrFUKscyKun4Noti9Oi
	 iOYJmnqFfwSSs4PWFj/HlVUTJexnHQ/iTJSt4bMaxoPS9XQZ3Gk1WIzQTa+zwt3E8M
	 QNcT/YdOewU5zm9vRwb0BU4OQBOQv5z+2C417rkU7s2Q4NVg07MK7UihCJJ3TDOLVf
	 Xt7SF3hXJOUqw==
Message-ID: <a324beda-7651-4881-aea9-99a339e2b9eb@kernel.org>
Date: Tue, 6 Feb 2024 08:55:38 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] block: Reduce zone write plugging memory usage
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-26-dlemoal@kernel.org>
 <09d99780-8311-4ea9-8f48-cf84043d23f6@suse.de>
 <f3a2f8b8-32d2-4e42-ba78-1f668d69033f@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <f3a2f8b8-32d2-4e42-ba78-1f668d69033f@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 02:51, Bart Van Assche wrote:
> On 2/4/24 04:42, Hannes Reinecke wrote:
>> On 2/2/24 15:31, Damien Le Moal wrote:
>>> With this mechanism, the amount of memory used per block device for zone
>>> write plugs is roughly reduced by a factor of 4. E.g. for a 28 TB SMR
>>> hard disk, memory usage is reduce to about 1.6 MB.
>>>
>> Hmm. Wouldn't it sufficient to tie the number of available plugs to the
>> number of open zones? Of course that doesn't help for drives not reporting that, but otherwise?
> 
> I have the same question. I think the number of zoned opened by filesystems
> like BTRFS and F2FS is much smaller than the total number of zoned supported
> by zoned drives.

I am not sure what Hannes meant, nor what you mean either.
The array of struct blk_zone_wplug for the disk is sized for the total number of
zones of the drive. The reason for that is that we want to retain the wp_offset
value for all zones, even if they are not being written. Otherwise, everytime we
start writing a zone, we would need to do a report zones to be able to emulate
zone append operations if the drive requested that.

Once the user/FS starts writing to a zone, we allocate a struct
blk_zone_active_wplug (64 B) from a mempool that is sized according to the drive
maximum number of active zones or maximum number of open zones. The mempool
ensure minimal overhead for that allocation, far less than what a report zone
command would cost us in lost time (we are talking about 1ms at least on SMR
drives). Also, with SMR, report zones cause a cache flush, so this command can
be very slow and we *really* want to avoid it in the hot path.

So yes, it is somewhat a large amount of memory (16 B per zone), but even with a
super large 28 TB SMR drive, that is still a reasonnable 1.6 MB. But I am of
course open to suggestions to optimize this further.

> 
> Thanks,
> 
> Bart.
> 
> 

-- 
Damien Le Moal
Western Digital Research

