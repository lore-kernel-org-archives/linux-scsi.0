Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C493C13E3F6
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 23:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717715501; cv=none; b=tYpDnIgT6TQptpsEUR105urI43RuLJV0lPS0Kse6rhQpGrh9bjaDwkuzUfm8TdHBMlfjNbp8tcfsRAlxIQ1QnEUpstAxgxbC8HPx4IYiwyuKznKrTQjNUDQYp/UTW3hRh62Mr0lKWBy4EHSVHw75EaxFM+6HFTDHtGbwSDCshmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717715501; c=relaxed/simple;
	bh=KFOV/3tJWvDscFhl4Sc1aGBsKP7xYktVV4V3BeOqm9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O2LVp3tqRt3RDRLjWH+EYyT203/YL3W80g+MiS4UXwxmNDAcGqUhLOS/GCv7rvNTKkGA4cvdMOvk+V6nXYFepSyo20/6zVawgxsUxcU60fJstOMCNq/+0w05nVt7uPjsh7fAUMha4B+/ixhvLsch0iPlHIZOkNzmVaRkPWbsj60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0sd2l7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0sd2l7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA38C2BD10;
	Thu,  6 Jun 2024 23:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717715501;
	bh=KFOV/3tJWvDscFhl4Sc1aGBsKP7xYktVV4V3BeOqm9o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p0sd2l7PYn5QcwjULxUDukYnyW7TEbNQF6ya9UfOxZ3hl5nUV3xeB+pDe1KlOvGkH
	 sIEyLwrSAFq8ryDbx10qJgES5sne6gfob6WZ1xz0dIjdnpn4FE395ftwhLEew26yeN
	 RaDrQWxIsQaM2eWaOGGvfh7gUkQoqVGhlpbtJArDSi2oF3RJfEr520j9dcvWb50Z5g
	 F8pO1+41X84Xpm05YaFs5Axr0/LvpV0FAWZIZYCSXzg8id74gZS/ZSQ1Hw3OByfudE
	 toHIzTKDumezTKuH59kfw0COH2HR+vONHRR75aa97/Pelcya7G3EupsmcUr5nkDJbd
	 WIFwDq2+EI1dw==
Message-ID: <4c93ddba-2bdb-44ea-95df-a42a1aec2a7c@kernel.org>
Date: Fri, 7 Jun 2024 08:11:39 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Disabe CDL by default
To: Niklas Cassel <cassel@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20240606054606.55624-1-dlemoal@kernel.org>
 <ZmG4XfHEbfhje2Zp@ryzen.lan>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ZmG4XfHEbfhje2Zp@ryzen.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 22:23, Niklas Cassel wrote:
> Hello Damien,
> 
> s/Disabe/Disable/
> in $subject

Good catch. Will fix that.

> 
> On Thu, Jun 06, 2024 at 02:46:06PM +0900, Damien Le Moal wrote:
>> For scsi devices supporting the Command Duration Limits feature set, the
>> user can enable/disable this feature use through the sysfs device
>> attribute cdl_enable. This attribute modification triggers a call to
>> scsi_cdl_enable() to enable and disable the feature for ATA devices and
>> set the scsi device cdl_enable to the user provided bool value.
>>
>> However, for ATA devices, a drive may spin-up with the CDL feature
>> either enabled or disabled by default, depending on the drive. But the
>> scsi device cdl_enable field is always initialized to false (CDL
>> disabled), regardless of the actual device CDL feature state.
>>
>> Add a call to scsi_cdl_enable() in scsi_cdl_check() to make sure that
>> the device-side state of the CDL feature always matches the scsi device
>> cdl_enable field state, thus avoiding inconsistencies for devices that
>> have CDL enabled when first scanned. This implies that CDL will always
>> be disabled, as it should be, when the system first scans the devices.
>>
>> Reported-by: Scott McCoy <scott.mccoy@wdc.com>
>> Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>  drivers/scsi/scsi.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 3e0c0381277a..9e9576066e8d 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -666,6 +666,13 @@ void scsi_cdl_check(struct scsi_device *sdev)
>>  		sdev->use_10_for_rw = 0;
>>  
>>  		sdev->cdl_supported = 1;
>> +
>> +		/*
>> +		 * If the device supports CDL, make sure that the current drive
>> +		 * feature status is consistent with the user controlled
>> +		 * cdl_enable state.
>> +		 */
>> +		scsi_cdl_enable(sdev, sdev->cdl_enable);
>>  	} else {
>>  		sdev->cdl_supported = 0;
>>  	}
> 
> Perhaps I'm missing something here, but since this is only a problem for
> ATA devices, where the device might have CDL enabled on the device,
> but disabled in sysfs, why isn't this code disabling it:
> https://github.com/torvalds/linux/blob/v6.10-rc2/drivers/ata/libata-core.c#L2551-L2572

The inconsistency happen with ATA devices connected to a SAS HBA. This patch is
for such setup only. libata (and libsas) managed ATA CDL devices are fine thanks
to the code you pointed out.

> 
> The whole point of that code is to keep the device in sync with the
> device/sysfs value.
> 
> Can't we modify ata_dev_config_cdl() such that we can avoid doing basically
> the same sync (only needed for ATA devices) in two different functions?

No need, that is all fine. Again, this patch is for SAS HBA connected ATA
devices only. I will update the commit message to make this clear.

> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

