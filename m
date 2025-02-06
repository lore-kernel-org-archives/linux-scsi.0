Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12474239594;
	Thu,  6 Feb 2025 18:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865335; cv=none; b=FE6QH//f6kOoddg7idxSICSqSKog3gworPNmhk3FsScMom+z/vHcvPq9nV2Kv/00jFfHsQEfNCqwsX0LjSBYloCoJQxaMCzg2XlRfYjkV0s/iMBy5Q3Y3cqyudnyjhchSs2KpNE+hHhq/l1UFODqMquxIFGl8fxfGPwhHhv8an0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865335; c=relaxed/simple;
	bh=5q2sLIrAySLnTpuDxDuv9lXzXAZXKbv7PneLrwOFSvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SSgjrudxiW6OD39mVoph/10UGmsCWUPWbrg9CPwUpmDyJaPw3eBJ5ec6Z7skmS+l5o9EMns8H3BKMNM+ADmeLg/Dq3YaOwnNcnSviKmNbsmUsisVxQRc/cjxVXqzObp6a7GFStZs14o3854o40ktRwmlXKIGaKvYcggLEA3b00U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xrL1x7UU; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xrL1x7UU"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YplTp25jSz6CmQyd;
	Thu,  6 Feb 2025 18:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738865323; x=1741457324; bh=fjStii4iwtrr16pdBH0zg69Y
	e6+XIHaaaHUuap4UAVA=; b=xrL1x7UUO1HVb3hATvxP2cNaL/vQIipiBfvLtL+j
	eyMGi/qGhrNtT6G0qz++SLntrLnsLSTPXmWm6oAfEzPNWAS8/CUCJfirL87TwxKZ
	gR2JVDYaqg/ZZX3kZiOdLzxDhfIaTwNIs5sc3MX4n1feuk7GOq6MWBXdsJ9AD7Yh
	Kd09o+vCZpC8Nues63jaU6xF/FhLYIBJVxCg6bCr/295XuZ9cBUiTBwXiD3PP72y
	NA3sKgRJS+8GqXFTQ4THI+sRBFcq98iXMWVoI258J6+LRDo/6gtRiiptBllZlI9a
	7c3gG2PpJDrGF+SyMNjm2kYdmbQHN4p4D1w3Stw3pQMq2A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hBpBdxGxpiXN; Thu,  6 Feb 2025 18:08:43 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YplTk519hz6CmQyc;
	Thu,  6 Feb 2025 18:08:42 +0000 (UTC)
Message-ID: <b3f8a233-7172-41d8-a39b-49e6014a2aff@acm.org>
Date: Thu, 6 Feb 2025 10:08:41 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: critical health condition
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20250204143124.1252912-1-avri.altman@wdc.com>
 <9ebbd6d9-149f-43cb-b188-bd3a6125654f@acm.org>
 <DM6PR04MB6575FACB152A64BDA4B4F5E8FCF72@DM6PR04MB6575.namprd04.prod.outlook.com>
 <DM6PR04MB65757320A1761FE473BFC5CCFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
 <b962df63-42c4-4bc9-9815-9871be1ce2d5@acm.org>
 <DM6PR04MB657573C4DE11B13E58B1B5ADFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657573C4DE11B13E58B1B5ADFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/25 9:47 AM, Avri Altman wrote:
>> On 2/6/25 12:54 AM, Avri Altman wrote:
>>> After some further internal discussions: The set conditions are vendor
>>> specific; The device may set it as many times it wants depending on
>>> its criticality. The spec does not define that nor what the host
>>> should do. So there is this concern that some vendors will report
>>> multiple times, while other wont. Hence, reading critical_health = 1
>>> might be misleading. What do you think?
 >
> Still not sure if you want this to be a counter?

Since the event can be reported multiple times, a counter sounds better
to me than a boolean.
>> How about emitting a uevent if a critical health condition has been reported by a
>> UFS device? See also sdev_evt_send().
> Thanks for pointing this out.
> A ufs event in enum scsi_device_event seems misplaced - looks like it was invented for unit attention codes.
> How about calling kobject_uevent() or  kobject_uevent_env() directly from the driver?

Please note that emitting a uevent is not the only possible approach for
informing user space code. Emitting a uevent is recommended if the code
that processes an event can be implemented as a shell script. Could it
be more likely that critical health events will be processed by C or C++
code rather than a shell script? If so, how about making the sysfs
attribute that reports the number of critical health events pollable? In
C and C++ code, polling a sysfs attribute requires less code than
listening for uevents.

Thanks,

Bart.

