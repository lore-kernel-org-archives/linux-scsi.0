Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA1C17BBF;
	Mon, 28 Jul 2025 23:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753744533; cv=none; b=dOkJmQv4Yt7KwM8YPdJP9B1VLO1g2zQJst2giBF17oYmnnI4uA1if8A+yIZVPhp0X5GSg3alg7pRR4x/YuWmwqMErso3yhwlr6WASVzO6j1NXB4jDe7P4/3w6WVUNhWMEbTp4uwDHyF6gZ8PuBmrYovvQpCHpdMmP56HNycgyPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753744533; c=relaxed/simple;
	bh=Dcv0ckOfiKhRbeqcMEMeTGdMeh0Kj2RQGBbpto32XEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jiy1fXSCoUd5jTI7bvoikuROSCfJJZb9DxCi1ypdZmhsRD+3fEG5L3hnT9R8sp7MdxA34BsjmTjCGHaqx1Ln0g1X5x377AhJDf3yLIFno2W+2aD4VD9qbREUu2GQS0RVJDEKsvSz0NQNg6rwC0EjkbK1GIFD2Eh/0O/xAVuuUdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0dDEMGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0dDEMGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8A2C4CEE7;
	Mon, 28 Jul 2025 23:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753744532;
	bh=Dcv0ckOfiKhRbeqcMEMeTGdMeh0Kj2RQGBbpto32XEk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J0dDEMGsoL6lrrvb8hm0rOPOWdBTm/YbyqD1JlsoRKDDJV3GdwHlJNUEcgoZQellR
	 /QCRZcwvlvwMMwykO5PYaaPIEMddLmNl35mtl7Wn91JQQABZiqNjnHDwytLigxgBiC
	 k3e+RKWGv6RIAbXUEKzfy6+bb4pzw3MQDlkNcaK2ZhUsYSx8iYjxTLaGCuyeEjOcsx
	 Wl/Oc86DmcI7xhrAiu4IDwKldJgH1XAXaTsMIndhOW+xOCOOXqPN+8aOzwCMaJEtSj
	 MOmHQ1sjb7kzwImTgMcJLZSBhPzEI5S4v32mry75L7XS7uB9AcLfbEhn7y9396w5TV
	 MoTk7QZMOKAxQ==
Message-ID: <9f8d9590-eb2c-4985-82e2-73744980313a@kernel.org>
Date: Tue, 29 Jul 2025 08:15:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: sd: fix sd shutdown to issue START STOP UNIT
 command appropriately
To: Bart Van Assche <bvanassche@acm.org>,
 Salomon Dushimirimana <salomondush@google.com>
Cc: James.Bottomley@hansenpartnership.com, ipylypiv@google.com,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, vishakhavc@google.com
References: <20250724212137.105270-1-salomondush@google.com>
 <20250724214520.112927-1-salomondush@google.com>
 <325a7f60-955c-4e3d-bd16-e5377462fa33@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <325a7f60-955c-4e3d-bd16-e5377462fa33@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/29/25 00:47, Bart Van Assche wrote:
> On 7/24/25 2:45 PM, Salomon Dushimirimana wrote:
>> Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
>> manage_system_start_stop") enabled libata EH to manage device power mode
>> trasitions for system suspend/resume and removed the flag from
>> ata_scsi_dev_config. However, since the sd_shutdown() function still
>> relies on the manage_system_start_stop flag, a spin-down command is not
>> issued to the disk with command "echo 1 > /sys/block/sdb/device/delete"
>>
>> sd_shutdown() can be called for both system/runtime start stop
>> operations, so utilize the manage_run_time_start_stop flag set in the
>> ata_scsi_dev_config and issue a spin-down command during disk removal
>> when the system is running. This is in addition to when the system is
>> powering off and manage_shutdown flag is set. The
>> manage_system_start_stop flag will still be used for drivers that still
>> set the flag.
>>
>> Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
>> Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
>> ---
>> Changes in v3:
>> - Removed unnecessary tag
>>
>>   drivers/scsi/sd.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index eeaa6af294b81..282000c761f8e 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -4173,7 +4173,9 @@ static void sd_shutdown(struct device *dev)
>>   	if ((system_state != SYSTEM_RESTART &&
>>   	     sdkp->device->manage_system_start_stop) ||
>>   	    (system_state == SYSTEM_POWER_OFF &&
>> -	     sdkp->device->manage_shutdown)) {
>> +	     sdkp->device->manage_shutdown) ||
>> +	    (system_state == SYSTEM_RUNNING &&
>> +	     sdkp->device->manage_runtime_start_stop)) {
>>   		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>>   		sd_start_stop_device(sdkp, 0);
>>   	}
> 
> Runtime power management is not related at all to deleting a LUN through
> sysfs. This patch makes it impossible to understand the sd_shutdown()
> implementation without studying the ATA subsystem and its history.
> Additionally, this patch makes the documentation of
> .manage_runtime_start_stop incorrect.
> 
> There are only two drivers that set .manage_runtime_start_stop: libata
> and the unmaintained sbp2 driver. Has it been considered to test
> sdkp->device->is_ata instead of sdkp->device->manage_runtime_start_stop?

I would rather prefer to not spread the use of device->is_ata further than it
already is. We are not even supposed to be needing that one in the first place,
but SAT is not a perfect specification.

But nevertheless, feel free to send cleanup patches to make this code prettier :)


-- 
Damien Le Moal
Western Digital Research
