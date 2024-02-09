Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79076522A;
	Fri,  9 Feb 2024 03:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707451142; cv=none; b=Vn5sKCDHbGpHzd5o8YfFcASCT+7PmuukYV30HFN+hfpFDDAi+8fX208DchkzOMJIjsf8HHWvEPn3gN62zyYEe+i5WBBrit5ivsTFWnLhNATgxp9RWv4Vuz/h49mW5EBAgWInSUMLYWE0TuENwIPqmiHrUnTftfHbCEt1gyutGgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707451142; c=relaxed/simple;
	bh=H82I7rllxtsLHj8eJjE5t6SEi7ZJWl0T5JXmanbkDa0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qJaRzCm1zRmTpwqJjP1XnjnE/kaW98NbwT39IzSxPrbMQ4eg4D806YpYKie1KloDXot3Oq6QFM27rU3EYGZZ3RZWbuxWznNKKflBNjiaxIb0ec8p5lt2ME+8JudSOeGoDEV4hAf+f0zoMfeDpJPJxVtS8SKxzkljKhz0EqddzPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7RVIj7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7RVIj7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE4DC433C7;
	Fri,  9 Feb 2024 03:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707451142;
	bh=H82I7rllxtsLHj8eJjE5t6SEi7ZJWl0T5JXmanbkDa0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I7RVIj7sT6EzCX4AlE+al/0aWuwBnLueQ51FW/q9DLA26d8vQloXoiYoymUIef8Ek
	 UYaU3RasWczpQ137lxyx5rC6DaDoKR2hsFmPzUilyutQ8hbYxwb/djni11dDNhyNE1
	 kegfx2eigl5cRrY/ZiPUyUpkhaCvhlwpUFivR8FWoe2Ay2WpZFQ6eC2Bu6u/ceN5SI
	 HHgxTFOnniQhTGLJ9f+y1J6svmVfIQQkDsPyp0DLARSfFrApUQFog8sEyqwNBvo5GE
	 FFbyFGEsWBT8QSm12D9cpAV3gAqJ4Q/Rqr90vTeNG0+kjugz622z5WBp4PJzv/cFg5
	 PCYYxuHVsln2Q==
Message-ID: <75240a9d-1862-4d09-9721-fd5463c5d4e5@kernel.org>
Date: Fri, 9 Feb 2024 12:58:59 +0900
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
 <a324beda-7651-4881-aea9-99a339e2b9eb@kernel.org>
 <2e246189-a450-4061-b94c-73637859d073@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <2e246189-a450-4061-b94c-73637859d073@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/7/24 06:20, Bart Van Assche wrote:
> On 2/5/24 15:55, Damien Le Moal wrote:
>> The array of struct blk_zone_wplug for the disk is sized for the total number of
>> zones of the drive. The reason for that is that we want to retain the wp_offset
>> value for all zones, even if they are not being written. Otherwise, everytime we
>> start writing a zone, we would need to do a report zones to be able to emulate
>> zone append operations if the drive requested that.
> 
> We do not need to track wp_offset for empty zones nor for full zones. The data
> structure with plug information would become a lot smaller if it only tracks
> information for zones that are neither empty nor full. If a zone append is
> submitted to a zone and no information is being tracked for that zone, we can
> initialize wp_offset to zero. That may not match the actual write pointer if
> the zone is full but that shouldn't be an issue since write appends submitted
> to a zone that is full fail anyway.

We still need to keep in memory the write pointer offset of zones that are not
being actively written to but have been previously partially written. So I do
not see how excluding empty and full zones from that tracking simplifies
anything at all. And the union of wp offset+zone capacity with a pointer to the
active zone plug structure is not *that* complicated to handle...

-- 
Damien Le Moal
Western Digital Research

