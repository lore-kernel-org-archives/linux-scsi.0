Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273DE186601
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 18:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724436327; cv=none; b=UXvM8+2c/A47Zzeh6+ESGK11k4K/LLpgaRP5WavPQneWCv4pKedQiJHuqll20iq0LvpBD15V0f592Ske/x/OIbhFi9ljuvnG4EG/hqwUUyBn1B41ovsXzGv5Y14pI1szg53NCaRVUW7nMo+Sc76J0OFI5Q/PZ0I3o0p5Usc4s3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724436327; c=relaxed/simple;
	bh=P7Y/fjP9jB6QY9FkTMQgUUQd+OhdylYoLMn5YFx9iSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UsdpJUYAe2WntO/SK9Ms0m1ov/tlq6eA7KcxU0qalmWMMu0zidIXyzAzbvfIMBJQJ5F0TCoKXXLoMDK8HjnuMoSaBTGULbr0mWGEjO9sr+pSGvJIv2nX3WsI3CK65vgbSo5tKYmxaUqu5z6h75Xah+VeAK3yqDxGMlJ9bA3aFeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LTfNXoch; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LTfNXoch"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wr7Jv1nnmzlgVnK;
	Fri, 23 Aug 2024 18:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724436315; x=1727028316; bh=rv+mD/UWPWJwaV3O2A1qZNaH
	hvyD39wt4JqMf1Q0Mhs=; b=LTfNXochqLveNl7a1xrKK84idMR2MCz5swb5dS6A
	el2tvkQEY8tyU27cvoHGBjt4LyXz0hsq0oRXXT3Swu8NQTVZvpmQLddl3NctaATS
	0Soe5u1FQ79WI4NFoDQFCqbkS3fViM6trJvbHAomyfgJ+n/C1RS7F2yFtt+qkb1K
	aLAql1GyCzRAQTIjGGVTEakFSLbrJc8rPwrWkhrOIekvkzidIzpWQL2F8xgsU99b
	eZXthHBtGhS26IOjYnZJplGQrYjFs+8JAFBd0wq9L7g4F5P5DlfwYstR8isQfPOf
	sIekMxth36W26xo80z9H8nOpAR8ZrRY6g1tv31N7fVJS0Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vNU1w46prY6s; Fri, 23 Aug 2024 18:05:15 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wr7Jn707kzlgVnF;
	Fri, 23 Aug 2024 18:05:13 +0000 (UTC)
Message-ID: <4b7d6a81-a0ac-4f1e-9744-6fc1ed4c6c43@acm.org>
Date: Fri, 23 Aug 2024 11:05:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Eric Biggers <ebiggers@google.com>,
 Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
 <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
 <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
 <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
 <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
 <20240823120104.siy54o6qja75lpwh@thinkpad>
 <5b3057e7-0d0f-4601-bf96-5d2111af2362@acm.org>
 <20240823145817.e24ka7mmbkn5purd@thinkpad>
 <c5699d57-cd51-4bff-95f4-372a00b2a3dd@acm.org>
 <20240823164822.fdkfswpyhlwnfgfl@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240823164822.fdkfswpyhlwnfgfl@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 9:48 AM, Manivannan Sadhasivam wrote:
> On Fri, Aug 23, 2024 at 09:07:18AM -0700, Bart Van Assche wrote:
>> On 8/23/24 7:58 AM, Manivannan Sadhasivam wrote:
>>> Then why can't you send the change at that time?
>>
>> We use the Android GKI kernel and any patches must be sent upstream
>> first before these can be considered for inclusion in the GKI kernel.
> 
> But that's the same requirement for other SoC vendors as well. Anyway, these
> don't justify the fact that the core code should be modified to workaround a
> controller defect. Please use quirks as like other vendors.

Let me repeat what I mentioned earlier:
* Introducing a new quirk without introducing a user for that quirk is
   not acceptable because that would involve introducing code that is
   dead code from the point of view of the upstream kernel.
* The UFS driver core is already complicated. If we don't need a new
   quirk we shouldn't introduce a new quirk.

Bart.
