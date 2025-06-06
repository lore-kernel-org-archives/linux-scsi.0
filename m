Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A6F1DB122
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 22:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749248242; cv=none; b=YySGnYZGb+/PF7AURdq1jBqVlwA654WMhE4PevrDdPwzVnv1uFX0r+ZznIpTzkpicPzC7aMImogosUTpYqCBMBaknIvWVW4wwZbR/oik6aNDBNQb14rXGKq0JS9uxT2IC/SlgpgDEYlICQXQVtM3eqJwkIuBZdaclI9x2apejgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749248242; c=relaxed/simple;
	bh=hAfGQ+L9mkhUicwWkZ+Udhq1UmendbTlUlAzzmpPVTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EC8Myg75t2mZArJ0pXeoIXSdne4Oe0y9yYPWxMKORKg7K0a/Y06zVlH3VerrSzO3IFdncYJj6+K0UGJQGTqwFcaUC0J6T6Mq7RWCm04Vuqd+N95laL9GIFZwXBmb1MI26UAgYYaFPA5EIr3Pwyaiuqoaz3baQmbIf9JZEwzaosk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdocNtZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdocNtZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810E9C4CEEB;
	Fri,  6 Jun 2025 22:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749248242;
	bh=hAfGQ+L9mkhUicwWkZ+Udhq1UmendbTlUlAzzmpPVTE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bdocNtZ9MRhNIYB0cFLIpdSlsfaPmYnY2TlkBLnRhNiBhMFBZ6PmJu2Ri8ZpDkiDY
	 uqS+pdubVaVfl6XtHwvBwvXIAHHs/SVD3R4a5Th+zkEWIepMTQHkiYTKQf5fuRFX28
	 jh7ru4QESI+Q9K140c/eciinm1CL9AlbZYMOn98s5VU9aEsRdO3m9oZAwgojWGTLrv
	 unMUzAJN3APQTya18n5GKQkR6hcdhtiF26oE7y12JiZHA9qlpfUI2Le5UpNQM8jLBA
	 8L/rsD3EbWsVaYOH0Tya4k4SX0JBfczkUDXtwyaveh6tXAvoqX0rc3qh4bUiAm0DLo
	 9tM4UpU4AyY+w==
Message-ID: <f8291028-3ff5-4c3b-a67f-dfb481ed6e2f@kernel.org>
Date: Sat, 7 Jun 2025 07:17:20 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Remember if a device is an ATA device
To: Igor Pylypiv <ipylypiv@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250606052844.746754-1-dlemoal@kernel.org>
 <aENd_k2m9RN23VOE@google.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aENd_k2m9RN23VOE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/7/25 06:30, Igor Pylypiv wrote:
> On Fri, Jun 06, 2025 at 02:28:44PM +0900, Damien Le Moal wrote:
>> scsi_add_lun() tests the device vendor string of SCSI devices to detect
>> if a SCSI device is in fact an ATA device, in order to correctly handle
>> SATL power management. The function scsi_cdl_enable() also requires
>> knowing if a SCSI device is an ATA device to control the state of the
>> device CDL feature but this function does that by testing for the
>> presence of the VPD page 89h (ATA INFORMATION page).
>>
>> Simplify these different methods by adding the is_ata field to struct
>> scsi_device to remember that a SCSI device is in fact an ATA one based
>> on the device vendor name test. This filed can also allow low level
>> SCSI host adapter drivers to take special actions for ATA devices
>> (e.g. to better handle ATA NCQ errors).
> 
> It looks like we can also simplify the WRITE SAME disablement logic?
> 
> https://github.com/torvalds/linux/blob/master/drivers/scsi/sd.c#L3466-L3474

Indeed. Will add that in v2.


-- 
Damien Le Moal
Western Digital Research
