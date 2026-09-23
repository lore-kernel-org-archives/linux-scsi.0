Received: from mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D13F457E74
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 07:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790149450; cv=none; b=EuzsP09Z0y41mJRLE2dfs+pX/yhj/Kc+oWw3pc0Qo+J7+EF5CmE0a5N3Ad92rh+I/4ZtdsBY54rgmw5CP8w4BuDL5jAnty6FPb/aHQ/mC5UajPa+e/8igQ/XNWG4IhSYhaF/APCQTIThl2YHuKYj/gldQn/7r5ReAXDfZSDWUz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790149450; c=relaxed/simple;
	bh=X3qdH/IZBuizkgzgXaRkQlEujc28sYO4g1K62pREg7M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YzTYbMPaGS0VXm15+8TVSC90xcqBmqQpKhnf3x5WD1dsTJb8lAdv1h1PUVCNXl4AkCCEyENBTbQGJErWVcS5TwApPFga+7nuFoYvLuQ2Ve2EGa4rJqCKqhLIrWygjEG06d7sx0CM+qSgRA6DOqd3Z0KByJXFAgUEJ7GWZTQDhD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xsAXNG8X; arc=none smtp.client-ip=91.218.175.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xsAXNG8X"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=X3qdH/IZBuizkgzgXaRkQlEujc28sYO4g1K62pREg7M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790149442; v=1; x=1790754242;
 b=xsAXNG8XhoJeClCQTvIqJ8ctW9P6ZamqrMndl7NvCsyFTfKR6jmIpc9VVtaLzchCQvPPkvW6
 VNMxyWtx0HXlAJg+vbVJ2ynj2e2octbUw6RRt+dBDnilh1tPbtzxq4wx2MlKIOel/p+rreobpnM
 8t3zEIWVGOmBEtbM1XcLojAM=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id dc360e6c7fad00f3;
	Wed, 23 Sep 2026 07:44:02 +0000
X-Mizu-Trace-ID: dc360e6c7fad00f3
X-Migadu-Flow: FLOW_OUT
Message-ID: <9d1dc4e5-85e9-4126-8fd9-30e0b5b47dda@linux.dev>
Date: Wed, 23 Sep 2026 08:44:01 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] scsi: scsi_debug: Fix a locking bug in
 resp_write_same()
From: John Garry <john.garry@linux.dev>
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <cover.1790119506.git.bvanassche@acm.org>
 <295c14b6d2d011597284f09f7a3de42a49e08863.1790119506.git.bvanassche@acm.org>
 <41890e94-10da-4b99-af6d-35106b88f026@linux.dev>
Content-Language: en-US
In-Reply-To: <41890e94-10da-4b99-af6d-35106b88f026@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/23/26 08:37, John Garry wrote:
> On 9/23/26 00:26, Bart Van Assche wrote:
>> If fetch_to_dev_buffer() fails in resp_write_same(), the function jumps
>> to 'out' without releasing the data write lock acquired earlier via
>> sdeb_data_write_lock(). Jump to 'unlock' instead so that
>> sdeb_data_write_unlock() is called on the error path. This bug has been
>> discovered by building the scsi_debug driver with Clang and modified
>> lock context annotations. The modified lock context annotations are
>> available in patch "scsi: scsi_debug: Improve lock context annotations".
>>
>> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/scsi_debug.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index 6941809dfdb7..b854102e6caa 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -5402,7 +5402,7 @@ static int resp_write_same(struct scsi_cmnd 
>> *scp, u64 lba, u32 num,
>>       if (-1 == ret) {
>>           ret = DID_ERROR << 16;
>> -        goto out;
>> +        goto unlock;
> 
> at @unlock we lose the error code in ret - is that intentional?
> 

Now I notice that sashiko spotted this too. I will await until issues 
spotted by sashiko elsewhere at attended to before checking further.

>>       } else if (sdebug_verbose && !ndob && (ret < lb_size))
>>           sdev_printk(KERN_INFO, scp->device,
>>                   "%s: %s: lb size=%u, IO sent=%d bytes\n",
>> @@ -5419,6 +5419,7 @@ static int resp_write_same(struct scsi_cmnd 
>> *scp, u64 lba, u32 num,
>>       /* If ZBC zone then bump its write pointer */
>>       if (sdebug_dev_is_zoned(devip))
>>           zbc_inc_wp(devip, lba, num);
>> +unlock:
>>       sdeb_data_write_unlock(sip);
>>       ret = 0;
>>   out:
> 

