Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6473A8E3
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 23:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706745200; cv=none; b=jdK47Xk+xI9XwQeHVRem9QTnA1n42H3+3H7yAniKtvwJixZVWHmO9+0XRLs7q0qbJa1B6Y1LhYmEmAdCnv7g/Reieiy5nO9sLQqZL3EMjBgblbP1Qc4FY7cVD9TUUBY0JZtleSNXa+6gpOrqchlCpl981rY1/gjJPdpxRqu0yV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706745200; c=relaxed/simple;
	bh=gS4UWWHPrcDowGZiwBTdtVOYWnJesYSibYgCBC6G6LU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bDExTsoi1opx0KMvzi7CReeRXKgJob7AudeeJHSLe41ztaHL4FsIiq1iukfPtUOdvSIjGLzZHrpwTnEi5wjVMD4j2APUShuTg6lPtRHnepFB5j1BZSkXY779VBciojowO8OWKL9474bzLj96YgtmiFymZc1z7at+MSbaPkMFuvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=opensource.wdc.com; spf=pass smtp.mailfrom=opensource.wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=q2/DJvWb; dkim=pass (2048-bit key) header.d=opensource.wdc.com header.i=@opensource.wdc.com header.b=Slp4VbLY; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=opensource.wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="q2/DJvWb";
	dkim=pass (2048-bit key) header.d=opensource.wdc.com header.i=@opensource.wdc.com header.b="Slp4VbLY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1706745198; x=1738281198;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gS4UWWHPrcDowGZiwBTdtVOYWnJesYSibYgCBC6G6LU=;
  b=q2/DJvWbhBV6Dunwr2Az635Qe2P5kPDX1o3hLXKhDhpuXWfDHBHp1+os
   i4AZhcD49FWPLNf6A7M+2qPqQs3atg+IVwX5qdfTzDu6MRbqDTyuCHTEy
   9VcLDF9T4Yii1jBtNwueGNL30xLd8+LoIqLaDO/ZBfT9qX65lUf+Wpcwn
   TPEM036Py5lMoLypILXy47M6m2E5dyHFshh0dO+KSZZTwrLE6Yhndo6zm
   XhFOlUEBVBwSNFqTR6EwZlFp5a03JSrlaspYzvfVIS9LHHOG3R70ch3rm
   RVR4nzVFYEDnhKSkm+tOtgIMyblT3fVlBSMGo4Ftm4BK5SmKYQwsOSLv5
   w==;
X-CSE-ConnectionGUID: iZ2J5kwAQbKZYTlCKw8eZA==
X-CSE-MsgGUID: vN9pHsqETym4KPDz7GsOZQ==
X-IronPort-AV: E=Sophos;i="6.05,233,1701100800"; 
   d="scan'208";a="8212188"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2024 07:53:15 +0800
IronPort-SDR: Flmhl7nlbNR/KKDNrAe5rKNZJiYspLB3ABERtibBH1I8+xFP8N6IJYwrGWmOnPypOhDX0jc6n+
 g+s8CfoZz3Dw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Jan 2024 14:57:26 -0800
IronPort-SDR: aR5xSHcglek2zXapAkFKYKPNK7rP9KxlU34uJ0wpCZhRMjiSGdfJHcEtxoeSQpQNhprY6cQOwj
 fjkHdPPTIvBQ==
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Jan 2024 15:53:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4TQJkx3gLkz1RtVS
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 15:53:13 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
	reason="pass (just generated, assumed good)"
	header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
	opensource.wdc.com; h=content-transfer-encoding:content-type
	:in-reply-to:organization:from:references:to:content-language
	:subject:user-agent:mime-version:date:message-id; s=dkim; t=
	1706745178; x=1709337179; bh=gS4UWWHPrcDowGZiwBTdtVOYWnJesYSibYg
	CBC6G6LU=; b=Slp4VbLYbJnRFm6tx/5iJq7YCzLgHlHqAThayzfpei4HvM8g0MV
	M2O1/39mHGWTV0gKyZDvJvvfOgXMusbrB7UF3ndcgSeff/KxHpYRW0SymdluP4av
	O77SaXp4ZP2t/So3xIth7E/C2sQoabUIlmRvbH7gT7jjkAYxM/2fxaKFISudz6Bo
	/ulYyoueflFhc0pr8HdcDbWM21QpyAsmCR64NIx0CTldWvrdOYjV/cd9jgKU/OOa
	j0qZ/dzUzp7qov4U1+qZ1YamidsAOOQqrO1JaiVNBjhS0yUnL1lC9bReDzycnNyO
	j8Wmu8QqQ4m7TtqNgUTRa9WaFCwEtHQ4Kxw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id VfUlkpt-r6Yo for <linux-scsi@vger.kernel.org>;
	Wed, 31 Jan 2024 15:52:58 -0800 (PST)
Received: from [10.225.163.2] (unknown [10.225.163.2])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4TQJkb6SnGz1RtVG;
	Wed, 31 Jan 2024 15:52:55 -0800 (PST)
Message-ID: <8cf7697b-b189-4cf9-b0f4-d0cf57b19c9b@opensource.wdc.com>
Date: Thu, 1 Feb 2024 08:52:54 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>,
 Ed Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240118073151.GA21386@lst.de>
 <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
 <20240123091316.GA32130@lst.de>
 <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org>
 <20240124090843.GA28180@lst.de>
 <38676388-4c32-414c-a468-5f82a2e9dda4@acm.org>
 <20240131062254.GA16102@lst.de>
 <d7c1f279-464d-4ecd-8e65-87d2ced984dc@acm.org>
 <Zbq9kVEZZBD4m4ZY@kbusch-mbp.dhcp.thefacebook.com>
 <c2469774-8ebb-4faf-af3b-c9426b8591d4@acm.org>
 <ZbrR7-DcBSS7V9B7@kbusch-mbp.dhcp.thefacebook.com>
 <2fec1355-6570-43bd-ae9e-8e3dfcb6807a@acm.org>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <2fec1355-6570-43bd-ae9e-8e3dfcb6807a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/1/24 08:41, Bart Van Assche wrote:
> On 1/31/24 15:04, Keith Busch wrote:
>> I didn't have anything in mind; just that protocols don't require all
>> commands be fast.
> 
> The default block layer timeout is 30 seconds because typical storage 
> commands complete in much less than 30 seconds.
> 
>> NVMe has wait event commands that might not ever complete.
> 
> Are you perhaps referring to the NVMe Asynchronous Event Request
> command? That command doesn't count because the command ID for that
> command comes from another set than I/O commands. From the NVMe
> driver:
> 
> static inline bool nvme_is_aen_req(u16 qid, __u16 command_id)
> {
> 	return !qid &&
> 		nvme_tag_from_cid(command_id) >= NVME_AQ_BLK_MQ_DEPTH;
> }
> 
>> A copy command requesting multiple terabyes won't be quick for even the
>> fastest hardware (not "hours", but not fast).
> 
> Is there any setup in which such large commands are submitted? Write
> commands that last long may negatively affect read latency. This is a
> good reason not to make the max_sectors value too large.

Even if max_sectors is not very large, if the device has a gigantic write cache
that needs to be flushed first to be able to process an incoming write, then
writes can be slow. I have seen issues in the field with that causing timeouts.
Even a worst case scenario: HDDs doing on-media caching of writes when the
volatile write cache is disabled by the user. Then if the on-media write cache
needs to be freed up for a new write, the HDD will be very very slow handling
writes. There are plenty of scenarios out there where the device can suddenly
become slow, hogging a lot of tags in the process.

>> If hardware stops responding, the tags are locked up for as long as it
>> takes recovery escalation to reclaim them. For nvme, error recovery
>> could take over a minute by default.
> 
> If hardware stops responding, who cares about fairness of tag allocation 
> since this means that request processing halts for all queues associated
> with the controller that locked up?

Considering the above, it would be more about horrible slowdown of all devices
sharing the tagset because for whatever reason one of the device is slow.

Note: this is only my 2 cents input. I have not seen any issue in practice with
shared tagset, but I do not think I ever encountered a system actually using
that feature :)

-- 
Damien Le Moal
Western Digital Research

