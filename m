Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5D2483BD5
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782817; cv=none; b=HuorsmltGJv/1jXSlNQJtI5l8JTHu1WB5S3gSstXkPPtskmzC3+1NWoCFVCfTgQXLMMuwkPNYaHt95DsOuopYpF9HbJr+RRk60QiV6Nv4NumoSdatwz2V7O66cikYKLa6mxgLk29jM//tZ8gWl2OByeSov5wZ0okY/1kdBtCTqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782817; c=relaxed/simple;
	bh=eouoanbRbUdceuGhWjgRaCPuvUqxMYOlNAo2dEfU+kg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rJrKNeNiyVc28w6fHZgZwGHkG8gqHU7tGe2O38w+aPToWK94/q4qMI02uoV7ZgLiqhf7QJpOIPx3Y2qUVOfj0nxr33liPJjK1FVfTdZakhgmqkp7NLkQMee5xoaCnuiyQ9e5dhMFoybPqQhnj/pMKWGvA5fTEUaXLAlimdecBt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TZIO+cfh; arc=none smtp.client-ip=91.218.175.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TZIO+cfh"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eouoanbRbUdceuGhWjgRaCPuvUqxMYOlNAo2dEfU+kg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788782813; v=1; x=1789387613;
 b=TZIO+cfhYG7/uslcZ1lMlOHOvpRuHsg8CWAbi+nhRV58mvJe+/UcQ1xzhKX6KkoAi30AlZt6
 FbdC7E1AWB72qaAttAdy32xJBUSYGss9Kw23m2x4TtNpahUrTVRdN9vd2vdAyv2SmuSkl6K8p3R
 KoBy8ZC90VnR7cTmBwLJ+Niw=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 4028d51d5cc5b359;
	Mon, 07 Sep 2026 12:06:53 +0000
X-Mizu-Trace-ID: 4028d51d5cc5b359
X-Migadu-Flow: FLOW_OUT
Message-ID: <beef6759-9594-4a38-bb20-f1796e617aeb@linux.dev>
Date: Mon, 7 Sep 2026 13:06:50 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 11/27] scsi-multipath: introduce basic SCSI device
 support
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-12-john.g.garry@oracle.com>
 <20260907113341.395EA1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260907113341.395EA1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 12:33, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] scsi_mpath_unique_lun_id ignores string truncation of the unique LUN ID, risking incorrect multipath grouping.
> --
> 
> commit 1346e25fe4922ff0f78a31848664daccf7121f0f
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: introduce basic SCSI device support
> 
> For a scsi_device to support multipath, introduce structure
> scsi_mpath_device to hold multipath-specific details. A module param
> is introduced to enable multipath. SCSI multipath will only be
> available when supported and unique ID is available in VPD page 83.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> new file mode 100644
>> index 0000000000000..5559e2e8d64a8
>> --- /dev/null
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> +static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
>> +	int ret;
>> +
>> +	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
>> +				SCSI_MPATH_DEVICE_ID_LEN);
>> +	if (ret < 0)
>> +		return ret;
>> +	else if (ret == 0)
>> +		return -EINVAL;
>> +
>> +	return 0;
> 
> [Severity: Medium]
> Can the LUN ID be silently truncated here without returning an error?

Yeah, I think we we can add a check for ret >= SCSI_MPATH_DEVICE_ID_LEN

> 
> Similar to snprintf, scsi_vpd_lun_id returns the number of bytes that would
> have been written. If a device provides a pathological T10 Vendor ID that
> causes the expanded string to exceed SCSI_MPATH_DEVICE_ID_LEN (256 bytes),
> the string in the buffer is truncated but the returned length will be
> greater than or equal to SCSI_MPATH_DEVICE_ID_LEN.
> 
> Because any positive value of ret results in returning 0, a truncated ID
> will be treated as a success. If the unique identifier portion of the ID is
> pushed past the 255th byte, multiple distinct LUNs might share the exact same
> 255-character prefix and be incorrectly grouped together by
> scsi_mpath_find_head.
> 
>> +}
> 

