Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4041B3D0C4;
	Wed, 20 Mar 2024 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.252.227.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710934961; cv=none; b=E40nyjKxwH7sBl+ppCKfj0E2Gl8jgtlcSmFzESa/TNgu6cUa6wsLZsMYDdu3grcSJ7l2w7qOtiphi6R8mlKsCn+wDemm1kEwE2kCMuwWJ3injdiuMuPX7pYU+JaNS1PQDJM84sWyTvSWGvh57ym+zmz2fpO2NX78Y6+QewN+ukI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710934961; c=relaxed/simple;
	bh=yaob604HyJScDanRGDxcxMtmS0HhbA8ouHRMm7gKnG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SI4lSV3wK87CPY/Ux9SrnQMtwkAWf8bhrhiPS5BRFQI1FpIe7bjcQ8xWOw79FMOMMkF2GX6qU4F9wJqGVg9M20jfkKq41km0Bs2YybGKd0BNCFawPhT0f8H4NbdU/6zt0s2KT+15QA2/CT2781D4843H1rzxzrDCw1CmWe3qqHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de; spf=pass smtp.mailfrom=wetzel-home.de; dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b=xkquxyXH; arc=none smtp.client-ip=5.252.227.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="xkquxyXH"
Message-ID: <e346780f-0490-4e71-9388-acd53c700c03@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
	s=wetzel-home; t=1710934955;
	bh=yaob604HyJScDanRGDxcxMtmS0HhbA8ouHRMm7gKnG4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=xkquxyXHRswlPiQnAW66+1nwx49MzBrWDCO+Zb5u5DU+XEr8FN/XVmcXZ/nTXxzDn
	 q7LohVG4/aX5OalrIqjuVVW6qPoRr85bGJrOv0oLVNUTcPc8022Y5rraeHJ45EFT+j
	 eqayr3ovEPp5NY0/aEM0KBAKC75mLs5w+VesTXK0=
Date: Wed, 20 Mar 2024 12:42:35 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sg: Avoid sg device teardown race
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
References: <20240318175021.22739-1-Alexander@wetzel-home.de>
 <20240320110809.12901-1-Alexander@wetzel-home.de>
 <2024032031-duller-surgical-c543@gregkh>
Content-Language: en-US, de-DE
From: Alexander Wetzel <alexander@wetzel-home.de>
In-Reply-To: <2024032031-duller-surgical-c543@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.03.24 12:16, Greg KH wrote:
> On Wed, Mar 20, 2024 at 12:08:09PM +0100, Alexander Wetzel wrote:
>> sg_remove_sfp_usercontext() must not use sg_device_destroy() after
>> calling scsi_device_put().
>>
>> sg_device_destroy() is accessing the parent scsi device request_queue.
>> Which will already be set to NULL when the preceding call to
>> scsi_device_put() removed the last reference to the parent scsi device.
>>
>> The resulting NULL pointer exception will then crash the kernel.
>>
>> Link: https://lore.kernel.org/r/20240305150509.23896-1-Alexander@wetzel-home.de
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
>> ---
>> Changes compared to V1:
>> Reworked the commit message
> 
> What commit id does this fix?

It's a combination of patches. I think
db59133e9279 ("scsi: sg: fix blktrace debugfs entries leakage") was the 
one which finally broke it.

The in the hindsight wrong sequence was introduced via:
c6517b7942fa ("[SCSI] sg: fix races during device removal")
and cc833acbee9d ("sg: O_EXCL and other lock handling")

Alexander
