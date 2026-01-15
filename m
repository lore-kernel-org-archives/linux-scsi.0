Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F2421CC5A;
	Thu, 15 Jan 2026 17:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497881; cv=none; b=K+MaueoJSWVbLp5lRATrLto/6KJMQuAYsvqva8/85CaXrpO9W1P14Qs0aqGGd+RUIjsH1tELbSei6g/v3ulldPXxIxE+ywx7Lqgybqo63GxQt/eVz6djpYySwyHwjtc6rG5PjgjLxLo3wUdI+lotD5iIyTm1RAQUcdYYQgggpKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497881; c=relaxed/simple;
	bh=kA8TtiYYt8fK0wKpjyawQNU2b8oLDjq6/qKRYGeh5uk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RgwXETF1ftZyrGdLMhASK674qPhhY1QVrX/K7CFximJZPOQJHVXLvRRLqMoCKMJwtef0LB8/bRsh7fMlS49h46UY7lXAZPiy4s8nayLIJySXyHfgZGji0NfYG71Z1L0LYbCFVhgFgJaVPwurbGi0mmfOrqYIyrwMzDGR1Axgu/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gK8JoBX+; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gK8JoBX+"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dsVGb2qFJzlgqwC;
	Thu, 15 Jan 2026 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768497877; x=1771089878; bh=jDnusECdqKbA9rbaoSbkLQ7Y
	gd9BkGFdKUj9YuPUREo=; b=gK8JoBX+scOsbxpU6H8KopsdsjnJ4c3rogB7geh1
	Y71kLj5ZVbGYVOUsl+25oSNqz/hEt5p9/sHXsClKI518LclqkAr3m2xinXVY1fsk
	4pA3S3WIPbk7E5r6cZXnvFHVWfHwKKZcNoBT3eXIbh0yItyhk/8CEWaHrsWxpfK6
	qRGgJ/Y4FCs8CXjVHfGUIvSr1HBhlCCYNt2mhDHOjT2xjsSO3r+L6Ox0tRo5cZ+N
	aXjI/Om5n+c8dAGEcEpMHUL0EmNchI5BUOHVqEbd+ac43kUix7jcb7DcLNoupbTn
	Vlex6zo62MyYcYZ1zblo5bIvFv3I4ISZ7UEokLrWLkd9Tw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1WdAK39IiQ5V; Thu, 15 Jan 2026 17:24:37 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e7c:9:1de3:5bc8:3be1:d169] (unknown [104.135.180.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dsVGX4fcTzlgqsP;
	Thu, 15 Jan 2026 17:24:36 +0000 (UTC)
Message-ID: <2c210e30-e7bd-4b70-ad4e-cc7a1bbb5309@acm.org>
Date: Thu, 15 Jan 2026 09:24:34 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: pm8001: Fix data race in sysfs SAS address read
To: Chengfeng Ye <dg573847474@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260115171140.281969-1-cyeaa@connect.ust.hk>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260115171140.281969-1-cyeaa@connect.ust.hk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 9:11 AM, Chengfeng Ye wrote:
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index cbfda8c04e95..e49f11969b3b 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -311,8 +311,15 @@ static ssize_t pm8001_ctl_host_sas_address_show(struct device *cdev,
>   	struct Scsi_Host *shost = class_to_shost(cdev);
>   	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
>   	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> -	return sysfs_emit(buf, "0x%016llx\n",
> -			be64_to_cpu(*(__be64 *)pm8001_ha->sas_addr));
> +	unsigned long flags;
> +	ssize_t ret;
> +
> +	spin_lock_irqsave(&pm8001_ha->lock, flags);
> +	ret = sysfs_emit(buf, "0x%016llx\n",
> +			 be64_to_cpu(*(__be64 *)pm8001_ha->sas_addr));
> +	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +
> +	return ret;
>   }
>   static DEVICE_ATTR(host_sas_address, S_IRUGO,
>   		   pm8001_ctl_host_sas_address_show, NULL);

Why isn't READ_ONCE() sufficient? And why explicit spin_lock_irqsave() 
and spin_unlock_irqrestore() calls instead of using scoped_guard()?

Bart.
