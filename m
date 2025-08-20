Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112FE2629F
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 17:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755712422; cv=none; b=Ivy4tNJxHcLGS6pPdzBgoPhaR9JK0ykUsgIOX8eEbI/tMHaTo9ctskzyb8rARhPBVHLak4OvxM6vHm88wO9fGu0bAhG4nuW8Y7BpkXanCsKaPzjqM/HBPXKMzvkviW6yJeci4yNF4qKcRxy/IwZQlzyquEVgN3x+OlwvSizdZWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755712422; c=relaxed/simple;
	bh=rslm4Ed01UwYHA4SPAVx87QAUDp9j7NTOp2Xg8efnxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VG6IKgWO/p+5VzZbfjk0+7mp5qtOetDjufXPrLuVqRF39fX3TGXLbIjJFDjvQaj0l1jcjvNFeUVUngrrO/KX1OFOA+UJqaf5R5yvWgDVzOj22nV3vI0t8veDsRuN2gJwMQeg7l8UQUr61ce+1vbHoK0nZPfcR8atruI3wXAQNHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Zo4hJSAr; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Zo4hJSAr"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c6YwN06tVzm174N;
	Wed, 20 Aug 2025 17:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755712418; x=1758304419; bh=rslm4Ed01UwYHA4SPAVx87QA
	UDp9j7NTOp2Xg8efnxY=; b=Zo4hJSArjlCVEipaqroMaEo2GixEjCrxq0+dF4Pk
	GM1cIoutEP8Uc3E1z8+M9pRukyHTulJVnqv0MbCd8eMzuIemlZFAcbdiDERwxPlk
	951UwwzzFTDYrHH5SOiuOxXPaOBxYp9aYlGQu0V/zeJq+bzywncS3F4IGuIZytrZ
	0MgVWBQk8xU87Jv2DOMNwYS5z+fC2HHroMwybiN5HbgJggeb11eC3jg0uJvtNLbX
	fpb7sU3klyqJTPO+qJzMSqTs7cOcA3lhpxFYY0XvulFtkrKM3xUOxZpHu+R93EPh
	mYc9EF5YegSQCGIok69pGhopYd9tw5+VjnHQPEPbPjh64Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Df13wAHc-TWQ; Wed, 20 Aug 2025 17:53:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c6YwG2skkzm174J;
	Wed, 20 Aug 2025 17:53:33 +0000 (UTC)
Message-ID: <0acda254-32a6-405b-a2d0-eef2401dbd83@acm.org>
Date: Wed, 20 Aug 2025 10:53:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] scsi: core: Do not allocate a budget token for
 reserved commands
To: Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-4-bvanassche@acm.org>
 <f2d65247-ad6b-44ea-a687-808d8c398afc@suse.de>
 <30b475dc-3287-4bcb-99be-f2b6649217a5@oracle.com>
 <004de5e3-ad51-4a49-b7c7-e418587d3ef7@suse.de>
 <3a1f6959-8d74-4bb9-8e4b-31b5105734f9@acm.org>
 <36c7bf20-7dd4-4e19-8bc0-461a9f8a4228@suse.de>
 <58622f7d-a075-40b8-a2ea-190058d2737e@acm.org>
 <66a096d7-8ed1-4a08-a207-533f945f6784@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <66a096d7-8ed1-4a08-a207-533f945f6784@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/25 11:54 PM, Hannes Reinecke wrote:
> On 8/19/25 21:49, Bart Van Assche wrote:
>> On 8/18/25 11:34 PM, Hannes Reinecke wrote:
>>> and if we move TMFs and all non-I/O commands to reserved commands
>>> cmd_per_lun will only be applicable to I/O commands.
 >>
>> Whether or not reserved commands should be used for allocating TMFs
>> depends on the SCSI transport. As an example, the approach mentioned
>> above is not appropriate for the UFS driver. The UFS driver assigns
>> integers in the range 0..31 to TMFs. These integers are passed directly
>> to the UFS host controller. Hence, allocating TMFs as reserved commands
>> from the same tag set as SCSI commands is not appropriate for the UFS
>> host controller driver.
>>
> So TMFs use a separate tagset than normal commands?
> IE can I submit TMF tag '3' when I/O tag '3' is currently
> in flight?

Yes, that's correct. This follows directly from the UFSHCI
specification. In legacy mode (which is easier to explain than MCQ
mode), there is one bitwise doorbell register for regular commands
(UTRLDBR = UTP Transfer Request List DoorBell Register) and another
bitwise doorbell register for task management functions (UTMRLDBR = UTP
Task Management Request List DoorBell Register). A command is submitted
by setting the appropriate bit in the UTRLDBR register. A TMF is
submitted by setting the appropriate bit in the UTMRLDBR register. This
is why the UFS driver allocates two tag sets - one for regular commands
and another for TMFs.

These registers are called REG_UTP_TRANSFER_REQ_DOOR_BELL and
REG_UTP_TASK_REQ_DOOR_BELL in the UFS driver source code.

Thanks,

Bart.
