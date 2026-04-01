Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491A833F8C3
	for <linux-scsi@vger.kernel.org>; Wed,  1 Apr 2026 19:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775070346; cv=none; b=kNqoDD+DecPtUYJ4ReJ2bgd8WQgqDF3KLim+AhnZ/0zmyRJMYYOEJrR4LsxbeFUfRks1B2SXgKNvReVL5MV3SiorupWATwl4gOpASvcl/YAajqf5enpA3OYDFv+ilfOVM+JMqT5luTNjt4h128EKZvzIlmNtRZHZURIDgwHiPMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775070346; c=relaxed/simple;
	bh=wW8PJiB2WunGtowCjXzATpDa3T2NiSBGzCktX2oKtNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f0FIbsNhepAFW2urqAzUsmyAaTsf+lDq9C6vvmsNbU9xrARblfpzgpWt9KDNHWnFWjR+/rZw7i1kllgjNPKy5sqDShBRCwpYK0i4m3UHkKjLZ33C1aeAWYX/e5RI4oaAAW1rMMKiSgI4R5lVU6xaAVPzIyJFrtsqDA12tVvWPPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chhC9Ol5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chhC9Ol5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775070344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3sAJ1FdjGwRu+DMqvGIwhQdYQkK9kW2zWLcKVGLOXc=;
	b=chhC9Ol504m9LLSg19g9pQQva5ICkHzw8ifGFbdHAuSseFpTv+BzJruv1UYy8+GQOder+e
	N2OEz46VGqbn9S3c+gspvKDKUteLoajZ+ZJuuI6x5+u0pbs9Y9taU+u64kYrMvNcqvG9EA
	rU1aV+eH91SKax9/zyGoGwu1QQBMrrI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-gdXDJV8FOZaZNkUCfQRb2A-1; Wed,
 01 Apr 2026 15:05:41 -0400
X-MC-Unique: gdXDJV8FOZaZNkUCfQRb2A-1
X-Mimecast-MFC-AGG-ID: gdXDJV8FOZaZNkUCfQRb2A_1775070333
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FF8D1955D4D;
	Wed,  1 Apr 2026 19:05:31 +0000 (UTC)
Received: from [10.22.81.104] (unknown [10.22.81.104])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B2C8F180035F;
	Wed,  1 Apr 2026 19:05:22 +0000 (UTC)
Message-ID: <5e6aa61e-0ad0-4027-bba9-cd906ab0d7e8@redhat.com>
Date: Wed, 1 Apr 2026 15:05:21 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/13] isolation: Introduce io_queue isolcpus type
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Aaron Tomlin <atomlin@atomlin.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
 mst@redhat.com, aacraid@microsemi.com,
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
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260401124947.-d4D5Cr-@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 4/1/26 8:49 AM, Sebastian Andrzej Siewior wrote:
> On 2026-03-30 18:10:43 [-0400], Aaron Tomlin wrote:
>> From: Daniel Wagner <wagi@kernel.org>
>>
>> Multiqueue drivers spread I/O queues across all CPUs for optimal
>> performance. However, these drivers are not aware of CPU isolation
>> requirements and will distribute queues without considering the isolcpus
>> configuration.
>>
>> Introduce a new isolcpus mask that allows users to define which CPUs
>> should have I/O queues assigned. This is similar to managed_irq, but
>> intended for drivers that do not use the managed IRQ infrastructure
> I set down and documented the behaviour of managed_irq at
> 	https://lore.kernel.org/all/20260401110232.ET5RxZfl@linutronix.de/
>
> Could we please clarify whether we want to keep it and this
> additionally or if managed_irq could be used instead. This adds another
> bit. If networking folks jump in on managed_irqs, would they need to
> duplicate this with their net sub flag?

Yes, I will very much prefer to reuse an existing HK cpumask like 
managed_irqs for this purpose, if possible, rather than adding another 
cpumask that we need to manage. Note that we are in the process of 
making these housekeeping cpumasks modifiable at run time in the near 
future.

Cheers,
Longman

