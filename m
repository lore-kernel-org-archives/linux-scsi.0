Received: from NOTESERV1.attotech.com (sw.attotech.com [208.69.85.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCA81B0437;
	Thu, 24 Apr 2025 15:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=208.69.85.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508816; cv=none; b=kQL7a8/yHAWp5McZVtURhjdmsjWSEGO3qN4iAlWQuvwyi7+8SCj/RMbyiLrYqc9TZtNPa8hApc0QDJGJKVZWY7TtW7hSSUkltyKgzYtCDJ4/+FMhrZoM4WJ+Qmkn0yY6xn7lHHf8VDJdq/C1/fp1z7XQR4bC5ixpS5jZCEu8CLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508816; c=relaxed/simple;
	bh=Xfc8GKtKubTRv/XopZVJMagIqooOj7Vc/rTv+DHGaME=;
	h=Message-ID:Date:Subject:To:Cc:From:In-Reply-To:Content-Type:
	 MIME-Version:References; b=s5lg5FEgDHujFAN5Eqf3e+B4FNn9Opl2RtTKKVtO8aFA2tyZOjgwpyfZOXSCBzclYYFwKdinSM5+X1t1zGqkK2s5oueeSj/FU1TvWyH7N+9OfglOb49Ur9hOj6kLWONKCnIXRuXCtkj1lkHTtromQsQJFbs11FLVAMuhgB0kWrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=atto.com; spf=pass smtp.mailfrom=atto.com; arc=none smtp.client-ip=208.69.85.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=atto.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atto.com
Received: from [10.20.0.14] ([10.20.0.14])
          by NOTESERV1.attotech.com (HCL Domino Release 12.0.2FP3 HF86)
          with ESMTP id 2025042411332402-909 ;
          Thu, 24 Apr 2025 11:33:24 -0400 
Message-ID: <05faf356-0bc7-4fdf-8a74-f738365fad20@atto.com>
Date: Thu, 24 Apr 2025 11:33:23 -0400
Subject: Re: [PATCH] scsi: sd_zbc: Limit the report zones buffer size to
 UIO_MAXIOV
To: Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: bgrove@atto.com, James.Bottomley@hansenpartnership.com,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, Steve Siwinski <stevensiwinski@gmail.com>
From: "Siwinski, Steve" <ssiwinski@atto.com>
In-Reply-To: <8454a55d-bfcc-441a-837e-157123e881fe@kernel.org>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
References: <20250411203600.84477-1-ssiwinski@atto.com>
 <Z_yinytV0e_BbNrF@infradead.org>
 <OFA5AB0241.ED5C089D-ON85258C70.0068BDE0-85258C70.00721A7A@atto.com>
 <8454a55d-bfcc-441a-837e-157123e881fe@kernel.org>
X-MIMETrack: Itemize by SMTP Server on NOTESERV1/SERV/ATTO(Release 12.0.2FP3 HF86|December
 17, 2024) at 04/24/2025 11:33:24 AM
X-TNEFEvaluated: 1
X-Disclaimed: 41067

On 4/18/2025 5:29 PM, Damien Le Moal wrote:
> On 4/19/25 05:46, SSiwinski@atto.com wrote:
>>
>> "Christoph Hellwig" <hch@infradead.org> wrote on 04/14/2025 01:52:31 AM:
>>
>>> On Fri, Apr 11, 2025 at 04:36:00PM -0400, Steve Siwinski wrote:
>>>> The report zones buffer size is currently limited by the HBA's
>>>> maximum segment count to ensure the buffer can be mapped. However,
>>>> the user-space SG_IO interface further limits the number of iovec
>>>> entries to UIO_MAXIOV when allocating a bio.
>>>
>>> Why does the userspace SG_IO interface matter here?
>>> sd_zbc_alloc_report_buffer is only used for the in-kernel
>>> ->report_zones call.
>>
>> I was referring to the userspace SG_IO limitation (UIO_MAXIOV) in
>> bio_kmalloc(), which gets called when the report zones command is
>> executed and the buffer mapped in bio_map_kern().
>>
>> Perhaps my wording here was poor and this is really a limitation of bio?
> 
> sd_zbc_alloc_report_buffer() is called only from sd_zbc_report_zones() which is
> the disk ->report_zones() operations, which is NOT called for passthrough
> commands. So modifying sd_zbc_alloc_report_buffer() will not help in any way
> solving your issue with an SG_IO passthrough report zones command issued by the
> user.
> 
> For reference, libzbc uses ioctl(SG_GET_SG_TABLESIZE) * sysconf(_SC_PAGESIZE) as
> the max buffer size and allocates page aligned buffers to avoid these SG_IO
> buffer mapping limitations.
> 

My issue is not with passthough report zones.

The report zones command is failing on driver load and causing the drive 
to fail to appear as a block device. If queue_max_segments is set to a 
value over 1024, then nr_vecs in bio_alloc() will be greater than 
UIO_MAXIOV and bio_alloc() will return NULL.

This causes the error.
```
sd 8:0:0:0: [sdb] REPORT ZONES start lba 0 failed
sd 8:0:0:0: [sdb] REPORT ZONES: Result: hostbyte=0xff driverbyte=DRIVER_OK
sdb: failed to revalidate zones
```

You can reproduce this by setting the max_sgl_entries parameter to 2k or 
greater in the mpt3sas driver. Other drivers can also reproduce this 
behavior.


This electronic transmission and any attachments hereto are intended only for the use of the individual or entity to which it is addressed and may contain confidential information belonging to ATTO Technology, Inc. If you have reason to believe that you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution or the taking of any action in reliance on the contents of this electronic transmission is strictly prohibited. If you have reason to believe that you have received this transmission in error, please notify ATTO immediately by return e-mail and delete and destroy this communication.   
