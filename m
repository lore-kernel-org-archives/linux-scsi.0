Received: from mta1.migadu.com (out-145.mta1.migadu.com [95.215.58.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784C246983C
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782908; cv=none; b=eEWmRYAxr4KY6QtQfUeqF2oq83SsHLLGEDAYNavYNptnV5pJm4Uyo4eAwhc3Pw2gf8gXMRqO28SqoayLpIPydWz3eKWdfO4hrXnlRIt3xTDGG/vIysHb1dIj1zi0bZ3KG/gjfo8GKtghcpqGoNNyq3ma6eAQbSz2uNVRUpPCBs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782908; c=relaxed/simple;
	bh=0Z2ZGxZKqnTwRetas2V5IK8TR9SG8S9E/yoFBRl3MJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I/Kh2HBUvzzfF1lnwt/lnxvVXiVnWvI2PdwVajay2C3KmFYbl0F4Gcv/dSa89cFn5Djos2lTAa+Ct/sEqENDLUaiiWjHO2aI/DdHfpxSriCrQQ1HUMxeEsXN/Dn9KUT1SDQyrDxVB6EItGwGoctYsy4KJbBRFYwjjGwTFIIybAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rllsHWcY; arc=none smtp.client-ip=95.215.58.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rllsHWcY"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0Z2ZGxZKqnTwRetas2V5IK8TR9SG8S9E/yoFBRl3MJE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788782904; v=1; x=1789387704;
 b=rllsHWcY6iMfmWZqTafAeR6Lp39mZ//V1S8bZ6sGHmRF8Km9O3tcftloiOE4JiPQRGSH4kRf
 oOarKn0UKOl0IAWz7s9vBLnW52J2JH2rXkRYEGD3Kc3/yujopO6Irn03uUd7bwk93C6HzkPJcyk
 D4MBxLEn42uQtlHuZ6DybNog=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id cab069c3bdd34d9b;
	Mon, 07 Sep 2026 12:08:24 +0000
X-Mizu-Trace-ID: cab069c3bdd34d9b
X-Migadu-Flow: FLOW_OUT
Message-ID: <07862c5c-94ed-4e41-9271-2245192c72ae@linux.dev>
Date: Mon, 7 Sep 2026 13:08:23 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 15/27] scsi-multipath: clone each bio
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-16-john.g.garry@oracle.com>
 <20260907114530.211B01F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260907114530.211B01F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 12:45, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] Failure to copy the updated `bi_sector` from the clone back to the master bio breaks `REQ_OP_ZONE_APPEND` completions.
> --
> 
> commit 7a2bc90e62297f99675ed0e03f2410ced58b148e
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: clone each bio
> 
> This commit updates SCSI failover handling by cloning each original bio
> before submission. Since SCSI has no guarantee that submitted bios are
> entirely completed or not at all, this ensures the original bio can be
> safely resubmitted upon failure.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 7164bc61e65e1..68fe50f62158c 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> @@ -237,7 +238,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +static void scsi_mpath_clone_end_io(struct bio *clone)
>> +{
>> +	struct bio *master_bio = clone->bi_private;
>> +
>> +	master_bio->bi_status = clone->bi_status;
>> +	bio_put(clone);
>> +	bio_endio(master_bio);
>> +}
> 
> [Severity: Critical]
> Does this completion function need to propagate the appended sector location
> for REQ_OP_ZONE_APPEND bios?

We're not supporting zoned devices yet

> 
> When a filesystem issues a REQ_OP_ZONE_APPEND bio to a zoned multipath
> device, the lower layers choose where exactly within the zone the data is
> written and update clone->bi_iter.bi_sector upon completion.
> 
> Since scsi_mpath_clone_end_io() only copies clone->bi_status and omits
> copying the updated clone->bi_iter.bi_sector back to
> master_bio->bi_iter.bi_sector before calling bio_endio(master_bio), will
> this cause filesystems like btrfs or f2fs to record incorrect data locations
> resulting in data corruption?

This can be updated later

> 

