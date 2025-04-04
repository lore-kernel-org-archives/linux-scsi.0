Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9227E1F867F
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2025 16:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743784461; cv=none; b=k7EoypXt45m4SwRDueYb20z5gMsIj0EXEntp3TeQn7gvl87SyUQsYOoA/VPu3f09CSs+SX6HE0sJ1LC/sz4UMBKE/BwegXhb3gTGHJ7MeO2b6D0JqkObsG/QCE3wrpsCBuiqTGhjAtdXEJG/yuqKY2mi8QGZh57xF1ULeD+KMvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743784461; c=relaxed/simple;
	bh=tzwyn1vLwso6P+d4UVcl2WJxBev0KuNohfHqvasilZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kU6WSfwRlCO+xp5UCY6YVX4sn5zYbjKIBDTMMq7qm6yJn+ntHpEIsdIuNnwWl5xPGlR4m7T23eIjKPQUrhmVERxYhHoOtoESG+HQyXbPMexvSD0DJwQYDqZ072iOv5UiLp2wisG1lFiq7es2CfAuVVFrpYubWSDRRamfoaxyt4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZHVoLcqe; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZHVoLcqe"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTkhT3Cv6zm1Hbm;
	Fri,  4 Apr 2025 16:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743784456; x=1746376457; bh=X8E3zq3NSDCaR8GboXJ/QmZj
	HnJpzCpKUYtB8ndhXTM=; b=ZHVoLcqeEvh0pjptT+LOGQH8YKJbMCeYFYKlDUy5
	NEMb4xxtEpzm6FtT1HFdQFc83XKTiPme6K2UmOrcBGcqRXcihA3X0vyi+LkarVHP
	6JkrY7b6W2bm5L9M70pgN3O5Lz0RbqT75YMjsrTtlk81/AdT50BLu8jBuIo7xvXf
	elA3d/Ey1cGWM5PqJ6mkEbpFOfQrB2PkxPu5Wz+GF3j4wEWy5fcwDXXfv23lcugD
	gMLR5OxvCevkzS31ImB3A1uWOa4UmiGOhwNA8VQu73hxSkFz+pwAr2lnh7JgRsaN
	ZNrqewf5Yr9NffShvg0DLUuTJZtrgtA3gB/M2wNl9pVjbQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id p_GIFb308Gvz; Fri,  4 Apr 2025 16:34:16 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTkhN3DgBzlxd6N;
	Fri,  4 Apr 2025 16:34:11 +0000 (UTC)
Message-ID: <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
Date: Fri, 4 Apr 2025 09:34:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/25 3:49 AM, John Garry wrote:
> On 03/04/2025 22:17, Bart Van Assche wrote:
>> From: Hannes Reinecke<hare@suse.de>
>>
>> Quite some drivers are using management commands internally. These 
>> commands
>> typically use the same tag pool as regular SCSI commands. Tags for these
>> management commands are set aside before allocating the block-mq tag 
>> bitmap
>> for regular SCSI commands. The block layer already supports this via the
>> reserved tag mechanism. Add a new field 'nr_reserved_cmds' to the SCSI 
>> host
>> template to instruct the block layer to set aside a tag space for these
>> management commands by using reserved tags. Exclude reserved commands 
>> from
>> .can_queue because .can_queue is visible in sysfs.
>>
>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>> [ bvanassche: modified patch description ]
>> Cc: John Garry<john.g.garry@oracle.com>
>> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
> 
> How is this related to the rest of the series?
> 
> To allocate a reserved-tag request we need to use BLK_MQ_REQ_RESERVED, 
> right? I don't see that used...

Hi John,

Calling blk_mq_alloc_request(..., BLK_MQ_REQ_RESERVED) is not the only 
way to allocated a reserved tag. Another possibility is to let the
driver manage reserved tags. The UFS driver only needs a single reserved
tag and already serializes use of that tag. See also the following
change in patch 21/24:

-	hba->reserved_slot = hba->nutrs - 1;
+	hba->reserved_slot = 0;

Use of hba->reserved_slot is serialized by calling ufshcd_dev_man_lock()
and ufshcd_dev_man_unlock(). More code is serialized by these calls than
only the region in which hba->reserved_slot is used so I don't think
that the UFS driver code would become shorter by using block layer
functions for allocating / freeing reserved tags.

Thanks,

Bart.
