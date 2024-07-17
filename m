Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE0B41C64;
	Wed, 17 Jul 2024 10:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721213177; cv=none; b=uwC0HDA5W28Eg8XQUg3W3H36UwUFdb7UJVhz+0SMXpGqeSvaJfVJkAgmKNWACq3qMtDgIpmr55fKsyTw1PRNFyacbqyV5IouqB6zE69lopn0DP4ceC8dgZbqVp+om1UcKppSYJtBb1ms3S6RE+SIr1rs539D970N5T7PD1XHB2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721213177; c=relaxed/simple;
	bh=8nW/0YkeP5wEzj+p/3pW+0dbcf7fT3l2DRseYG9QkiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bO4gR01Q9z7YJBp2VxmW81bJMVcu+xu3OnXszko25Dog6c7WC85vwbx1Z3NatdTwDuvVRkxuY6o+payHEPtRgm5r6KxJ/AUMygxnLbs+cWouFhm2CqhbdnEAkxREFeyrfSf21HdLegQgtWPB8eLZfKtq165TZrj2alLrkDIqLGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gb+8h9GJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gb+8h9GJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB33AC4AF09;
	Wed, 17 Jul 2024 10:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721213176;
	bh=8nW/0YkeP5wEzj+p/3pW+0dbcf7fT3l2DRseYG9QkiE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gb+8h9GJpPciAOjw2qlO63dYwX08ENn1ArIVi6pEC7sFamktcwwYzOXKNQAKYlIjL
	 74PUNtpKa/OYBcs6w3zZPvUW0Ergnpr6x2GyC5jvjzu1DauxyQqPIXNnxuFBkSlQkf
	 3AWe7C/RP51y/3vSDdsWLp0jCBL5YUJQfboWOSoFdBo4Ph1HmZt3ji4t8qh1MFBqNo
	 VgJAxA9TMYPbKVtoqXI6n1zdE6O99uDdVHv0x8h0hDDF84peiIcDdO5NR56yNm5pyM
	 zS080OEgpNsEkZblNC8X0JAsZMTx4XGphDQ/sw3etfYpG1uZzwZo3nI2XMrb+jgSGp
	 XnestQUKqnpig==
Message-ID: <bb277462-579b-4dc3-b63c-bf5768dd1ce4@kernel.org>
Date: Wed, 17 Jul 2024 19:46:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: sd: Do not repeat the starting disk
 message"
To: Johan Hovold <johan@kernel.org>
Cc: Johan Hovold <johan+linaro@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20240716161101.30692-1-johan+linaro@kernel.org>
 <39143ca8-68e4-44eb-8619-0b935aa81603@kernel.org>
 <ZpeIOsEbBIho9P_1@hovoldconsulting.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ZpeIOsEbBIho9P_1@hovoldconsulting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/17/24 18:00, Johan Hovold wrote:
> On Wed, Jul 17, 2024 at 07:48:26AM +0900, Damien Le Moal wrote:
>> On 7/17/24 01:11, Johan Hovold wrote:
>>> This reverts commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4.
>>>
>>> The offending commit tried to suppress a double "Starting disk" message
>>> for some drivers, but instead started spamming the log with bogus
>>> messages every five seconds:
>>>
>>> 	[  311.798956] sd 0:0:0:0: [sda] Starting disk
>>> 	[  316.919103] sd 0:0:0:0: [sda] Starting disk
>>> 	[  322.040775] sd 0:0:0:0: [sda] Starting disk
>>> 	[  327.161140] sd 0:0:0:0: [sda] Starting disk
>>> 	[  332.281352] sd 0:0:0:0: [sda] Starting disk
>>> 	[  337.401878] sd 0:0:0:0: [sda] Starting disk
>>> 	[  342.521527] sd 0:0:0:0: [sda] Starting disk
>>> 	[  345.850401] sd 0:0:0:0: [sda] Starting disk
>>> 	[  350.967132] sd 0:0:0:0: [sda] Starting disk
>>> 	[  356.090454] sd 0:0:0:0: [sda] Starting disk
>>> 	...
>>>
>>> on machines that do not actually stop the disk on runtime suspend (e.g.
>>> the Qualcomm sc8280xp CRD with UFS).
>>
>> This is odd. If the disk is not being being suspended, why does the platform
>> even enable runtime PM for it ? 
> 
> This is clearly intended to be supported as sd_do_start_stop() returns
> false and that prevents sd_start_stop_device() from being called on
> resume (and similarly on suspend which is why there are no matching
> stopping disk messages above):
> 
> 	[   32.822189] sd 0:0:0:0: sd_resume_common - runtime = 1, sd_do_start_stop = 0, manage_runtime_start_stop = 0

Yes, so we can suppress the "Starting disk" message for runtime resume, to match
the runtime suspend not having the message.

> 
>> Are you sure about this ? Or is it simply that
>> the runtime pm timer is set to a very low interval ?
> 
> I haven't tried to determine why runtime pm is used this way, but your
> patch is clearly broken as it prints a message about starting the disk
> even when sd_do_start_stop() returns false.

The patch is not *that* broken, because sd_do_start_stop() returning false mean
only that the disk will *not* be started using a START STOP UNIT command. But
the underlying LLD must start the drive. So the message is not wrong, even
though it is probably best to suppress it for the runtime case.

The point here is that sd_runtime_resume() should NOT be called every 5s unless
there is also a runtime suspend in between the calls. As mentioned, this can
happen if the autosuspend timer is set to a very low timeout to aggressively
suspend the disk after a short idle time. That of course makes absolutely no
sense for HDDs given the spinup time needed, but I guess that is a possiblity
for UFS drives.

> 
>> It almost sound like what we need to do here is suppress this message for the
>> runtime resume case, so something like:
> 
> No, that would only make things worse as I assume you'd have a stopped
> disk message without a matching start message for driver that do end up
> stopping the disk here.

OK. so let's revert this patch and I will rework that message to be displayed
only on device removal, system suspend and system shutdown.

>> However, I would like to make sure that this platform is not calling
>> sd_resume_runtime() for nothing every 5s. If that is the case, then there is a
>> more fundamental problem here and reverting this patch is only hiding that.
> 
> This is with the Qualcomm UFS driver, but it seems it just relies on the
> generic ufshcd_pltfrm_init() implementation.
> 
> Also not sure why anyone would want to see these messages on every
> runtime suspend (for drivers that end up taking this path), but that's a
> separate discussion.

Not really. As mentioned above, it is probably best to suppress the start/stop
messages for runtime suspend. The separate discussion is why sd_runtime_resume
is called that often for this UFS drive: bug or aggressive autosuspend ? Given
that I do not have this hardware, I will let someone else look into that.

-- 
Damien Le Moal
Western Digital Research

