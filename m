Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD21239E6C
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 01:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775181317; cv=none; b=i58fqzIFSqBrrlMK4Y5M36cF1wAWGXXeFYOXw6XgnRnFi3RsmgXRS7HtFOghslR9DoQqCLECdmdt2yXXxiRYdYZCcA01FPHJ3hcjnk50lMUx2nsCE/LBu8U1pTD+8oXR5nlbDsMlp/8wIcaS8VRVknsYu62KGX30EWAAWa3M67E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775181317; c=relaxed/simple;
	bh=WceCMgAM9hb0LmVATzakSRIMaK1LNusiIxhocIwwHiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EYr6njv5Nc2StojbvJilxOKDv0lafT44d7EhYzQpU121r80ntUn29JgXVdQHm+7f12UMdvwpT7uuZrYaTxqmpK65qEKu0N+NUEgg5lHp39iIGWdf98R3P2UYxiVNtUCyEcVCT59CyzWDwMkP35pNeae+PkP1iw4Y2h0Mni8ne+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BWKnfdWU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BWKnfdWU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775181315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZrMSG5WhqiegT+A0sFDzBwpum3aJGNMaHDmV5z7yNwo=;
	b=BWKnfdWU6Ajv8TmsT+fAkPMrbD+5SwakVt9sdZpe4MKBuEojL6B5+BNHnpQwyO60pevD9E
	FO4xGJkzPI1wNraTW1aS1Mx9kE7T6oK+HztqvTR86hxuxTWi/ceZVhL/SSJJ72bdsmN9aA
	PnPdcBMfCYGKMS6cxV/xBvgA2VHcLhk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-402-NvGV8eYKMJmendw6hIzqCQ-1; Thu,
 02 Apr 2026 21:55:11 -0400
X-MC-Unique: NvGV8eYKMJmendw6hIzqCQ-1
X-Mimecast-MFC-AGG-ID: NvGV8eYKMJmendw6hIzqCQ_1775181307
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 270C4195608F;
	Fri,  3 Apr 2026 01:55:05 +0000 (UTC)
Received: from [10.22.88.243] (unknown [10.22.88.243])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0EAEF1800361;
	Fri,  3 Apr 2026 01:54:55 +0000 (UTC)
Message-ID: <57ccc69b-2f4b-40ae-b7a5-feb99e34789a@redhat.com>
Date: Thu, 2 Apr 2026 21:54:55 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/13] isolation: Introduce io_queue isolcpus type
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Aaron Tomlin <atomlin@atomlin.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, mst@redhat.com, aacraid@microsemi.com,
 James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 liyihang9@h-partners.com, kashyap.desai@broadcom.com,
 sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
 chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
 sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
 ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, tglx@kernel.org,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org,
 ruanjinjie@huawei.com, yphbchou0911@gmail.com, wagi@kernel.org,
 frederic@kernel.org, chenridong@huawei.com, hare@suse.de, kch@nvidia.com,
 ming.lei@redhat.com, steve@abita.co, sean@ashe.io, chjohnst@gmail.com,
 neelx@suse.com, mproche@gmail.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 MPT-FusionLinux.pdl@broadcom.com
References: <20260330221047.630206-1-atomlin@atomlin.com>
 <20260330221047.630206-10-atomlin@atomlin.com>
 <20260401124947.-d4D5Cr-@linutronix.de>
 <5e6aa61e-0ad0-4027-bba9-cd906ab0d7e8@redhat.com>
 <20260402075810.w0GVbX0Z@linutronix.de>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260402075810.w0GVbX0Z@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 4/2/26 3:58 AM, Sebastian Andrzej Siewior wrote:
> On 2026-04-01 15:05:21 [-0400], Waiman Long wrote:
>>> Could we please clarify whether we want to keep it and this
>>> additionally or if managed_irq could be used instead. This adds another
>>> bit. If networking folks jump in on managed_irqs, would they need to
>>> duplicate this with their net sub flag?
>> Yes, I will very much prefer to reuse an existing HK cpumask like
>> managed_irqs for this purpose, if possible, rather than adding another
>> cpumask that we need to manage. Note that we are in the process of making
>> these housekeeping cpumasks modifiable at run time in the near future.
> Now if you want to change it at run time, it would mean to reconfigure
> the interrupts, device and so on. Not sure if this useful _or_ if it
> would be "easier" to just the tell upper layer (block in case of I/O)
> not to perform any request on this CPU. Then we would have an interrupt
> on that CPU but it wouldn't do anything.
> It would only become a problem if you would have less queues than CPUs
> and you would like to migrate things.

I know that it will not be easy. Anyway, I will let this patch reaching 
a good compromise and get merged first before thinking about that.

Cheers,
Longman

