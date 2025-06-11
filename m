Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028FA23817D
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 23:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749683687; cv=none; b=qr4fszR8qrCgD9zo8PnKtbwCPVP5TayYeACzFRWcrShjQKydFMpdeGEF6JHyOhPDTqjayDEVWILoiV/Pu9ZSoNrdI4fYwUeVc4hkDsH3svKK8C/0/NYQoSFq0h0MQF0Xuex0CrqD5A2fYhDLFVbSDPAIc5IAiW+V8MwIulaQ2Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749683687; c=relaxed/simple;
	bh=nPmhJuc6Hnsz1Q2I5/8+3SEj89uqZwW8v33HGZhBYnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nbuZicQqPW5FM3rrHC7OaQWvTPKe2Dzi+5IUWfYFD29i1Js5+uu0yFaC7oVbhn40l5RpJFycHVCzR8LUohLWubhc1sYx+/ZoCW8vCfhv8U/WFJkmCBWM89ZqRdZDMPqIYeJAtEK3L0bkjH+5BIc72Sbd2zdWL/QUEAxfmW3uZJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Joab7dBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Joab7dBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C634C4CEE3;
	Wed, 11 Jun 2025 23:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749683686;
	bh=nPmhJuc6Hnsz1Q2I5/8+3SEj89uqZwW8v33HGZhBYnA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Joab7dBVuQ53EUBkN0pDoUExK8mfXPRYrmVwFvpDSew+CUupsoSRcAxSkGjpaeTO1
	 YwQ0xMtthlDjjOViTnOCkv4oDAACSgHAJ9+1+4QGFWdBqmVYPqWJ6rsixp/qxR8cDM
	 0NHuOE9hm7RmHfhdk9frviaRN7d00IGtPL1UlErs3ZKtHK4Ra9RyPd/22ADv/hKs1J
	 A9phrVa4Pr2Yee+vgwhHA8McLrzD8XH5l75s/IOEane+0qEYwlrjMEWjy1xnTW+1kC
	 TQDoQOLK+OQJSY5yJnC4oUNiN0Jol7QhYfoX3y9W1yiBo++anVrw9j6RYU2D5UCx/t
	 X3An1UfUeXQwQ==
Message-ID: <c8cf3ee1-3d65-4241-850c-4539b39f1f5c@kernel.org>
Date: Thu, 12 Jun 2025 08:14:45 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: Remember if a device is an ATA device
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250611093421.2901633-1-dlemoal@kernel.org>
 <aca75eab-45b4-4afd-8319-e2662fd9d9e8@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aca75eab-45b4-4afd-8319-e2662fd9d9e8@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/12/25 00:46, Bart Van Assche wrote:
> On 6/11/25 2:34 AM, Damien Le Moal wrote:
>> scsi_add_lun() tests the device vendor string of SCSI devices to detect
>> if a SCSI device is in fact an ATA device, in order to correctly handle
>> SATL power management. The function scsi_cdl_enable() also requires
>> knowing if a SCSI device is an ATA device to control the state of the
>> device CDL feature but this function does that by testing for the
>> presence of the VPD page 89h (ATA INFORMATION page).
>> sd_read_write_same() also has a similar test.
>>
>> Simplify these different methods by adding the is_ata field to struct
>> scsi_device to remember that a SCSI device is in fact an ATA one based
>> on the device vendor name test. This filed can also allow low level
>> SCSI host adapter drivers to take special actions for ATA devices
>> (e.g. to better handle ATA NCQ errors).
>>
>> With this, simplify scsi_cdl_enable() and sd_read_write_same().
> Hi Damien,
> 
> There is only one "if (is_ata)" check in the SCSI core as far as I can
> see. Can it be avoided that ATA code leaks into the SCSI core by
> introducing a new function pointer, e.g. in struct Scsi_Host, and by
> calling that new function pointer if it has been set from
> scsi_cdl_enable()?

You are off by 2 on the count:

git grep "\->is_ata" drivers/scsi/*

drivers/scsi/scsi.c:    if (sdev->is_ata) {
drivers/scsi/scsi_scan.c:       if (sdev->is_ata) {
drivers/scsi/sd.c:              if (sdev->is_ata)

And no, we cannot avoid trying to detect if we are dealing with an ATA/SAT
device or a real SCSI device in all 3 places where this "if" is done.
2 of these used VPD page dereference under rcu lock before, which is rather
heavy handed. The point of this patch is to simplify that.

> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research
