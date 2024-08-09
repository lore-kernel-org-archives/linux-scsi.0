Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBB215ECC3;
	Fri,  9 Aug 2024 19:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230903; cv=none; b=sbw/of+xseElN1dNrymgkBrqf1c/yZZKVfwHk5xdJbUiCkpJkWdAGQ6XlCGm2Khep6w9CyjBXwoElC3bPOlmoEYubr6JgAMQ5osrh54KV3WXvt0ZVqnTtNx7SlySPeMn6SmonbEficIeURD7Ges5n6eBq30Ac31QrmHJyjUocuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230903; c=relaxed/simple;
	bh=DibLUEnTsdSBZPfJSqD2frndtrOkbATuQ+3Wb8lPRZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ftLOdoq8FPXyqZltwmINcRgRggYoBWA5zoQW9HxFuLGlbkAEJMi8yTs/5ZX5FqiMqybJGHNdsg7l21X0uGPuS+jDXaNN+uZvbicIv42bCURXGQzIo1IivPewKiswuvK2W0voot4S55O1dOef1bAVO/szB0ZQmBwsRhlsr0pTm1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KLQjzp7A; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KLQjzp7A"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WgYWn44Lxz6ClY8x;
	Fri,  9 Aug 2024 19:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723230898; x=1725822899; bh=C3Y7RyE6Umt352oYn9af7CF/
	QQU4tkrbbVojV42x/og=; b=KLQjzp7A+axw0CZAm/PhGhXC1O+NKGGnC4r8R5D2
	SspmMv2NjmHKq3fGUcl+PaTA4ncys2YJnhI7mEXKc04wUqY4tL7AP0fISY6zeGyq
	3wpi/jo+QnyCe28wzQrgfYzgQ3pXad1mkyJGw0A+q3L5WuZIbV7zSL9jug6zg+CY
	7Rv9mPCg/YkSzga7yU0VAagBYo7lOkibtEtShKP1KmsH1dJryW354ee6YP2vkAPD
	C9jnQf1qfIv9bLI+c+9V8gXB7g529SnG0fgUqb7p4NGV+Huv8UBpSErzyMi3w5j9
	xHs3VzOSmKLADWaY0aXqs1ITmp4FD/uun6tvHG3DLz7bjw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5e5aGB_-gQWs; Fri,  9 Aug 2024 19:14:58 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WgYWh1VqSz6ClY8s;
	Fri,  9 Aug 2024 19:14:55 +0000 (UTC)
Message-ID: <7e6669da-d723-4eb4-8849-77e4deed5ffa@acm.org>
Date: Fri, 9 Aug 2024 12:14:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: retry command SYNC CACHE if format in progress
To: Yihang Li <liyihang9@huawei.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 prime.zeng@huawei.com, linuxarm@huawei.com
References: <20240808021719.4167352-1-liyihang9@huawei.com>
 <1cd0b145-431a-4d9f-979f-04d4063eeda8@acm.org>
 <e6b05d46-7acd-8364-2826-c14e342f8e2d@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e6b05d46-7acd-8364-2826-c14e342f8e2d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/8/24 8:44 PM, Yihang Li wrote:
> On 2024/8/9 3:09, Bart Van Assche wrote:
>> On 8/7/24 7:17 PM, Yihang Li wrote:
>>> If formatting a suspended disk (such as formatting with different DIF
>>> type), the SYNC CACHE command will fail because the disk is in the
>>> formatting process, which will cause the runtime_status of the disk to
>>> error and it is difficult for user to recover it.
>>>
>>> To solve the issue, retry the command until format command is finished.
>>
>> How is the format command submitted to the SCSI disk? Is that command
>> perhaps submitted as a SCSI pass-through command (SG_IO ioctl)?
>>
> 
> When formatting a suspended disk, the disk will be resuming first,
> and then the format command will submit to the disk through SG_IO ioctl.
> 
> When the disk is processing the formatting command, the system does not
> submit other commands to the disk. Therefore, the system attempts to suspend
> the disk again and sends the SYNC CACHE command. However, the SYNC CACHE
> command fails because the disk is being formatted.
> 
> Error info like:
> 
> [  669.925325] sd 6:0:6:0: [sdg] Synchronizing SCSI cache
> [  670.202371] sd 6:0:6:0: [sdg] Synchronize Cache(10) failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
> [  670.216300] sd 6:0:6:0: [sdg] Sense Key : 0x2 [current]
> [  670.221860] sd 6:0:6:0: [sdg] ASC=0x4 ASCQ=0x4

Please consider integrating this information in the patch description.

>> Should the sd driver perhaps be unbound while the format command is in
>> progress?
>>
> 
> I do not have any suggestions for this yet. I don't know how to unbound driver
> when executing the format command and bound driver after the command is executed.
> 
> If you have any suggestions, please let me know.

It seems like the PCI core supports binding and unbinding through sysfs
but the SCSI core not. So it's probably easier to add support for
ASC/ASCQ 04h / 04h rather than to add bind/unbind support to the SCSI
core.

Thanks,

Bart.
