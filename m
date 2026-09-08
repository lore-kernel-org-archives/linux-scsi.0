Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76481D86FF;
	Tue,  8 Sep 2026 00:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788827559; cv=none; b=TCDat14DZ5uZCM67jGrClaE6uDo+Ru5PsWrOY3JnpWyiX1lz+j3UCF0kMxNM1VDTbpmNVZJbNapKsw9EvYHmjrG+qpGOMd+XeM2pNUbPwTPX15n819CeRmapMEt96+P14jZUKHYRS3iGh/gMwguAt7oSJIgKRkTtuTSJqQ1VLyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788827559; c=relaxed/simple;
	bh=h3lAZp3DCeYWg8VnaggBcHdsx+dREnUBjBv7SdQTSV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=J2o2hqepzUkcIEEKp2PYnnn8Ge2/t/mq3uv9z8cndbpaY+WdTKK3ncAfgmo+h5Tp/oKBVgl5WdcXcJu1xHuiSuJEb1x1LPnxqd55NzD2ocgRgc/+lvcNdaEqK/FusDXM4kl+4rC2LCAcHc1SdifBg24hhU9mZAJQp4+0GGuNvn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFK591ZQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFK591ZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D1F1F00A3A;
	Tue,  8 Sep 2026 00:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788827558;
	bh=m5m9yxXD2fBIQmhP1MUXDX2A/Clw0Ck3FOyGQVymdQg=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=ZFK591ZQ7GVB/5yp0xjJ3mgcoYhbAgMrzjjAAtvs+DbT1Ew6upfsG9nZDc6qwmG2U
	 keFy9eEriEj7XovAD0d2tjii2TlavyeCpWFThXIIP6G+lVs9pmnKa6ZBn6R+LCYlCF
	 DEGPm7Fyzj9z79p7WvEM7iKUufJse/4QF7m9heop0HMfnCWppS23CWkDHyvKZ78APN
	 agu7oqV9LOG16QC2qSPpVvg0WY82F1vIyL1cwv3/s8U/mwc97cvYcXsc/uEoIOBjwV
	 qddXkEogodaw6SHxEOpLm4VrgE9t/caPuBn9IQ2beUT0J44H+GMm2kOO2VMXTzrZFU
	 vmDgqGBl6GNjA==
Message-ID: <b9ea00f0-f002-43c8-8783-349d1f3c0b8b@kernel.org>
Date: Tue, 8 Sep 2026 09:32:35 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/40] scsi: use struct scsi_sense_hdr to log sense
 keys and codes
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-7-dlemoal@kernel.org>
 <1a2dbe7c-d220-48e8-adf8-f0fe5afca556@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <1a2dbe7c-d220-48e8-adf8-f0fe5afca556@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/8/26 05:05, Bart Van Assche wrote:
> On 9/6/26 7:43 PM, Damien Le Moal wrote:
>> -void usb_stor_show_sense(const struct us_data *us,
>> -             unsigned char key,
>> -             unsigned char asc,
>> -             unsigned char ascq)
>> +void usb_stor_show_sense(const struct us_data *us, struct scsi_sense_hdr
>> *sshdr)
> 
> The sshdr argument can be declared const, isn't it?

I think it can. Will add that.


-- 
Damien Le Moal
Western Digital Research
