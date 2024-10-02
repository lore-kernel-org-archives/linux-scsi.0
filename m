Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC97215F7D
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 20:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727900598; cv=none; b=qg6+6hdjxGn7uSpyH5IbuPxPdr+jppKIxLCPWmYe6loJoPjVlwqFf+oAEglWtlEpHuN9q8aZK6ABKkq0J03zwQEcg/7Rq3/sZ+xpBxneANOuLNWxT78tMHqfN5snwcEXtlCTFoEwGXl3l2LBj1aCGYtAqYJZXhWJTs9HGMUXjkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727900598; c=relaxed/simple;
	bh=90LPflDD0fTVLaOgMOhKclOmQmbJf8IpmhXQnNhrIJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ir+Ldla4c7mktcR4qvibBeRtgzzLABIzI+2Ys0PlghUhwnU6G3kzDr96/0GTCJVKf9kK7cf4PcbQUQYDujfMPbXNdwo+BJkAvOsYw8p2caRj63zmYqS7au1RfTjHuYrVlFKJA9XaIFIovTbQHJiBz22nyOU6oq/57YezaZlPF7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=P1xmTZUV; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="P1xmTZUV"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJmTV2vkLzlgMW9;
	Wed,  2 Oct 2024 20:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727900588; x=1730492589; bh=evHlMaA5vdM3lXU/ux7+SjFT
	yNIeF46Kver6AiHsFtg=; b=P1xmTZUVO6+U3YEMMAAMVP63raeS6vMPrhdfh6KZ
	mWNyCaQGLss0G0mLBVi6g7Dyu1SBaeRRtNFHWsS+tkSWs2mAA9EV8/T39tU1G/mw
	othoKA9HtBvg2jfQiEpOLmf73rnW57SHpCIlh+eE8J9hSmwjqOgcfcaF/kkkOEq+
	XyYrDDAb8pGpdUTqOuWU7vdtgZjkDW8zOobRwIioBcotOjNqpfqGsilwImirvUdW
	dfh3BrcnsX9mxGifua500FIvKAHeJEJyJyX7NlGVhysVyo2EKCltUBp6X7UZm+Kw
	QftBFcGytEmqOyAoAnMdCSCnwwIfBP4UbFtQ/U505QuaLA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TNyiyqS3fTCG; Wed,  2 Oct 2024 20:23:08 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJmTS2BZyzlgMVy;
	Wed,  2 Oct 2024 20:23:08 +0000 (UTC)
Message-ID: <376dfcb4-a25d-457d-acdd-4af77290b05b@acm.org>
Date: Wed, 2 Oct 2024 13:23:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: Rename .slave_alloc() and .slave_destroy()
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20240930201937.2020129-1-bvanassche@acm.org>
 <20240930201937.2020129-2-bvanassche@acm.org>
 <5b3e96da-9fe9-4eb5-ad0e-0377622df5c2@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5b3e96da-9fe9-4eb5-ad0e-0377622df5c2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 5:10 PM, Damien Le Moal wrote:
> On 10/1/24 05:18, Bart Van Assche wrote:
>> diff --git a/include/linux/libata.h b/include/linux/libata.h
>> index 9b4a6ff03235..e04184b6d79b 100644
>> --- a/include/linux/libata.h
>> +++ b/include/linux/libata.h
>> @@ -1201,10 +1201,10 @@ extern int ata_std_bios_param(struct scsi_device *sdev,
>>   			      struct block_device *bdev,
>>   			      sector_t capacity, int geom[]);
>>   extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
>> -extern int ata_scsi_slave_alloc(struct scsi_device *sdev);
>> +extern int ata_scsi_device_alloc(struct scsi_device *sdev);
> 
> While at it, drop the extern.
> 
>>   int ata_scsi_device_configure(struct scsi_device *sdev,
>>   		struct queue_limits *lim);
>> -extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
>> +extern void ata_scsi_device_destroy(struct scsi_device *sdev);
> 
> Here too.

Hi Damien,

Can I declare removing superfluous "extern" keywords as out-of-scope for
this patch series? There are plenty of superfluous "extern" keywords in
many Linux .h files. Removing the superfluous "extern" keyword for the
functions renamed by this patch series only probably won't make much of
a difference.

Thanks,

Bart.

