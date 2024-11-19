Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB2315853A;
	Tue, 19 Nov 2024 20:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732047686; cv=none; b=PMvDa0G/KrvtF9qTynDjaHtlWmX83s2o63NKKXT484gKnUsCQymDpm6Ccdin+tWPsAXCtmqQsVw0NK52TzoDGkP6dYN7bi2J9sVLT83eUU1fpVjQKxvUqOZibKvDy2Pt5egRwLkCvzpcO36qZVPWuohXJmFrFOWMyLcOfusUQg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732047686; c=relaxed/simple;
	bh=b+7fb8zN8SGwpCX5cAxruwCkEcC8k7k96sMyyLZ+2TU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N/HOGMGxmPJHTwabVZSvLgN+ixbDn7oMiuX+ygKMio2nGeZsGqQbCfEDgOI2r/RO4xEVavT+fB0gol7uOIWKD5OHhCuiGLm0Sgxz3Fjlpz+tZ5Y2L+aHhYW5CSCi9ZDN7qVhpUE8XLDg4yM40vymXojqidllj5ziW+V1Kk2kq9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Drt2FdYz; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Drt2FdYz"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XtG9B3lCrzlgTWM;
	Tue, 19 Nov 2024 20:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732047675; x=1734639676; bh=ZTDBhM3UJrTh2NsWmlgIX2TW
	Mmn9XJT/woGQyiJy/Ts=; b=Drt2FdYz6CBCJ0zYXtSAC9Xejv/sCxcNFW2KUVPI
	FZTn0VxZ47VSFGn8/5cZ+zSpqF6tF5lTnwP6KfhAUoxHTtSCjMr4gEqwYNeOwPNl
	2p5tNJsLFIxpEDx/VIGHV+VISavR2RTHyYBIcdmqsE/EcfmdDF0Zt+oYX7oyBwPB
	9sDOQy3rTgec5f5uWYdRhCLu4xAksMlv0dMdjtfcuEXi+wQFCqJgpy2zKZLhpuYL
	39VuCKWdL4qMmWy7itG6HvU0kZDM+uXouyIR2eGuxLtwM+FfqbFeoglFKQFlCVq4
	bUD4DAa4pgLspuK8z0ZnaQnq0sviYqjqK1ARC8BwrryqyA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mrBeF1V5DoX0; Tue, 19 Nov 2024 20:21:15 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XtG954r32zlgTWK;
	Tue, 19 Nov 2024 20:21:13 +0000 (UTC)
Message-ID: <e840b66a-79f0-4169-9ab1-c475d9608e4d@acm.org>
Date: Tue, 19 Nov 2024 12:21:12 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 01/26] blk-zoned: Fix a reference count leak
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-2-bvanassche@acm.org>
 <67d3ec9a-8efd-41c6-8c35-1ba5631c2c9a@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <67d3ec9a-8efd-41c6-8c35-1ba5631c2c9a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 6:23 PM, Damien Le Moal wrote:
> On 11/19/24 9:27 AM, Bart Van Assche wrote:
>> Fix a reference count leak in disk_zone_wplug_handle_error()
>>
>> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   block/blk-zoned.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index 70211751df16..3346b8c53605 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -1337,6 +1337,8 @@ static void disk_zone_wplug_handle_error(struct gendisk *disk,
>>   
>>   unlock:
>>   	spin_unlock_irqrestore(&zwplug->lock, flags);
>> +
>> +	disk_put_zone_wplug(zwplug);
> 
> The zone wplug put call is right after the single call site to
> disk_zone_wplug_handle_error(). The reason it is *not* in that function is that
> the reference on the wplug for handling an error is taken when the wplug is
> added to the error list. disk_zone_wplug_handle_error() does not itself take a
> reference on the wplug.
> 
> So how did you come up with this ? What workload/operation did you run to find
> an issue ?

Thanks for the feedback. I can't reproduce the refcount leak without my
other patches. I will check with which other patch this patch has to be
combined. This is the script that triggered the leak:

#!/bin/bash

set -eu

qd=${1:-64}
if modprobe -r scsi_debug; then :; fi
params=(
         delay=0
         dev_size_mb=256
         every_nth=$((2 * qd))
         max_queue=${qd}
         ndelay=100000           # 100 us
         opts=0x8000             # SDEBUG_OPT_HOST_BUSY
         preserves_write_order=1
         sector_size=4096
         zbc=host-managed
         zone_nr_conv=0
         zone_size_mb=4
)
modprobe scsi_debug "${params[@]}"
while true; do
         bdev=$(cd 
/sys/bus/pseudo/drivers/scsi_debug/adapter*/host*/target*/*/block && 
echo *) 2>/dev/null
         if [ -e /dev/"${bdev}" ]; then break; fi
         sleep .1
done
dev=/dev/"${bdev}"
[ -b "${dev}" ]
for rw in write randwrite; do
     params=(
         --direct=1
         --filename="${dev}"
         --iodepth="${qd}"
         --ioengine=io_uring
         --ioscheduler=none
         --gtod_reduce=1
         --hipri=0
         --name="$(basename "${dev}")"
         --runtime=30
         --rw="$rw"
         --time_based=1
         --zonemode=zbd
     )
     fio "${params[@]}"
     rc=$?
     if grep -avH " ref 1 " /sys/kernel/debug/block/sda/zone_wplugs; 
then :; fi
     echo ''
     [ $rc = 0 ] || break
done

