Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C630C1F1518
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 17:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755279048; cv=none; b=n6MSdD7UktJohuKVGphBmp9WL9TSvguKCPiHZC0h/T9SHvLmWx5pzJ1UZ09s88Ya1zLpCE4EBMeAuDjS0JaUuLPl6E6d0L94rjSHorYezUfUNiGBjHPUibkoNeUUi7Kik1kGjQO1pZDJs4RwO259ao+6L4pUxLfnt0PlJoXoqg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755279048; c=relaxed/simple;
	bh=q+oEdlSTPlcG6zBGJ/zzdpkB3dihEAAcHq0wvuWtbI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VjlNdI+YsIeTBNxY1nnOTj2G5v0bCRPnwBxIeXrn+pc6SrYq9p+CHYrZxuWUCZbpD5xNFzXaDFQt4vd3giylO0z9fYW7dXl1iwZVii4pPAkPqeb+tVqMMxOqKW/jlZocb1PSvCFaFGQ8ULqRLCkYxThc3hxJMFFEyCph0KJio5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yekW0Knv; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yekW0Knv"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c3Tf8240yzm174W;
	Fri, 15 Aug 2025 17:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755279038; x=1757871039; bh=epxtctQqThlqjejGqty3LmjJ
	95zavbs/+6xMwZsY1GY=; b=yekW0KnvSAi0rSgV9rGt4m3b3zNZTRfKHRj1RxZ8
	XjG4R+r3F9OOlUTqzrdi5/qPCc8USLFu+HsSTnkWDGrrAQZWLRIpXrzjmW/zRGiO
	UK8mkLgUdD/zsqyphbIi8eVyp0ZgW1mMGxGLuT/FkyJyvDiGiZYqwS8pd5YnAF41
	Eb+odDgvHbx8U41p1UsM/I95rEuxifsDDb0nqAkRXBybOOthbHiTd4z2jSYTA+dG
	ynUPgPAQhF1pYcFBKz4Olv7vZBWhcEtI5twyc59ckMOf6xICzjLjqtIp0lSnHcFK
	XyFQ5/VXb8Xf1EyEPgox++x/vhgzPJd27CUmw1VwI7Fcqg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NYvbtm55TF7r; Fri, 15 Aug 2025 17:30:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c3Tf36B7tzm174R;
	Fri, 15 Aug 2025 17:30:34 +0000 (UTC)
Message-ID: <5a5c975e-9514-4adf-9888-4149e6d201a0@acm.org>
Date: Fri, 15 Aug 2025 10:30:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/30] Optimize the hot path in the UFS driver
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.com
References: <20250811173634.514041-1-bvanassche@acm.org>
 <d5cd0109-915f-4fe7-b6c2-34681b4b1763@oracle.com>
 <d4151040-ab1a-4b3c-b5f9-577e907b43fc@acm.org>
 <ff0705fe-0bac-408e-a073-a833525dabf8@oracle.com>
 <e651aa7e-aad2-4e4e-afff-3e89a61f13f9@acm.org>
 <71a41bd0-1243-4fb3-ae83-c2cfae229296@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <71a41bd0-1243-4fb3-ae83-c2cfae229296@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 12:50 AM, John Garry wrote:
> Maybe so. But it is still less than ideal how the TMF tags are managed 
> in the UFS driver, specifically having a stub in ufshcd_tmf_ops. Have 
> you considered modelling on how the NVMe driver manages the admin queue?

The PCIe NVMe driver has different tag sets for the admin queue and I/O
queues. Additionally, it allocates separate request queues for admin
commands and for I/O commands, just like the UFS driver. Can you be more
specific about why you are referring to the NVMe driver?

Regarding the stub in ufshcd_tmf_ops: moving the code for queueing a TMF
into ufshcd_queue_tmf() and switching to blk_execute_rq() for submitting
TMFs shouldn't be that hard. However, I consider that change as
out-of-scope for this patch series.

>>> - I like that you are using blk_execute_rq(), but why do we need the
>>> pseudo sdev (and not the ufs sdev)? The idea of the psuedo sdev was 
>>> originally for sending reserved commands for the host.
>>
>> In the UFS driver several reserved commands are sent before
>> ufshcd_scsi_add_wlus() and scsi_scan_host() are called. 
>
> If you must send "host" reserved commands (which are not for a specific 
> SCSI target), then it would be ok.
> 
> But do you need to send any "reserved" commands to a specific SCSI 
> target (which are not TMFs)?

In this patch series, reserved commands are used for communicating with
the UFS device. It doesn't matter which struct scsi_device instance is
used for sending reserved commands since UFS host controllers only
support a single UFS device.

>>> - IIRC, I was advised to have a check in the scsi core dispatch 
>>> command patch to check for a reserved command, and have a separate 
>>> handler for that, i.e. don't use sht->queuecommand for reserved 
>>> commands. I can try to find the exact discussion if you like.
>>
>> It would be appreciated if a link to that conversation could be shared.
> 
> I looked, but I could not find it. It may have been a private 
> conversation while at my old employer (so now lost).
> 
> Anyway, here is a reference implementation:
> https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send-email- 
> john.garry@huawei.com/

The description of that patch says what the patch does but not why the
.reserved_queuecommand() function pointer is introduced. Integrating
that patch into this UFS kernel driver series wouldn't simplify any code
but would lead to some code duplication. Hence, I will leave it to
someone else to integrate that patch in the upstream kernel.

Thanks,

Bart.

