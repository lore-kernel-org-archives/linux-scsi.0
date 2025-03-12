Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AB6A31
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 01:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741744386; cv=none; b=KuWtvZUvVtEr+LJrHunM9TEqKSfgVeybptNHyd1EJJcUYcIM3onLeEPiy6m8XunjK6CCD0tbnz08WVYwVIq/T+xa4kP+BVcxXeLZjbsm9+4whtSERKDZCGS6r7SPSJfqhmHAbvW2B05Ch92Xwd0zbaJg1aARcpSchc4NT945gf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741744386; c=relaxed/simple;
	bh=12StXZzU1eAl/cGjE3VN2+DhX0ZTZ0+D6NC1wqZ+Yi0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZPRAVors8xi9TfJEo4QjYh5OIFx9KaROqBYC0OBcDB21Mm8gWM59+jpQ/XjoEdGtE5KWNkMPwci7v51QBVAi03YlIL+S1i8AHhhE3+M5eaiipbrEZB7X0KRu4AfgNEofS3AH1X4A1Upt/K7JF9O3nLLaVWkN/oGr489ceAZCrTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dwJnbbSz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dwJnbbSz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741744383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3PJVswqNQxm0fqJkjuC1Wxal4xGuyI9ZgyDnuqmrFY=;
	b=dwJnbbSznF1laVLLf4Hy5T5EjCuKc/5BsaVkgyGmQkseU6wPq42/nxRvyFx2TuUi/SRVMO
	aEM+Lc+USsg8B8wKgrLXqPLVJrvzKUA12Vj4/3zKTkHb9Py3z7aO92VgsG855RWi+n/dF0
	HKDQvhWmxeuTyBMhIM2Op3yZWYzJhfQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-483-_CwMXNOvPzyzwNuGqMV6hw-1; Tue,
 11 Mar 2025 21:52:58 -0400
X-MC-Unique: _CwMXNOvPzyzwNuGqMV6hw-1
X-Mimecast-MFC-AGG-ID: _CwMXNOvPzyzwNuGqMV6hw_1741744376
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09C1A18007E1;
	Wed, 12 Mar 2025 01:52:56 +0000 (UTC)
Received: from [10.22.65.26] (unknown [10.22.65.26])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5DF2C1944F12;
	Wed, 12 Mar 2025 01:52:52 +0000 (UTC)
Message-ID: <c3f77605-3061-461f-8406-8eb0493c71cd@redhat.com>
Date: Tue, 11 Mar 2025 21:52:51 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: John Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
To: Hannes Reinecke <hare@suse.de>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 pheidologeton@protonmail.com, kernel@roadkil.net, maokaman@gmail.com
Cc: Sagar.Biradar@microchip.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, thenzl@redhat.com, mpatalan@redhat.com,
 Scott.Benesh@microchip.com, Don.Brace@microchip.com,
 Tom.White@microchip.com, Abhinav.Kuchibhotla@microchip.com
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
 <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
 <8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
 <yq1eczsjaaz.fsf@ca-mkp.ca.oracle.com>
 <2eca14e0-3978-440f-a4a4-32c9c61baad4@redhat.com>
 <84a87c16-0738-460d-b83f-55f8181d536e@suse.de>
Content-Language: en-US
Organization: RHEL Core Storge Team
In-Reply-To: <84a87c16-0738-460d-b83f-55f8181d536e@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


On 3/10/25 12:44 PM, Hannes Reinecke wrote:
> On 2/24/25 22:15, John Meneghini wrote:
>> On 2/20/25 9:38 PM, Martin K. Petersen wrote:
>>> If go-faster stripes are desired in specific configurations, then make
>>> the performance mode an opt-in. Based on your benchmarks, however, I'm
>>> not entirely convinced it's worth it...
>>
>> I agree.  So how about if we can just take out the aac_cpu_offline_feature modparam...?
>>
>> Alternatively we can replace the modparam with a kConfig option. The default setting for the new Kconfig 
>> option will be offline_cpu_support_on and performance_mode_off. That way we can ship a default kernel configuration that
>> provides a working aacraid driver which safely supports off-lining
>> CPUS. If people are really unhappy with the performance, and they
>> don't care about offline cpu support, they can re-config their kernel.
>>
>> Personally I prefer option 1, but we the thoughts of the upstream users.
>>
>> I've added the original authors of Bugzilla 217599[1] to the cc list to
>> get their attention and review.
>>
> Do we have an idea what these 'specific use-cases' are?

Yes. The use case is offline CPU support.  We have customers who are using the aacraid driver to support their main
storage. They have hundreds of system deployed like this and they started using the offline CPU function and found
the problem in Bugzilla 217599. The customer is currently using this patch (minus the modparam) and it solves there
problem.

> And how much performance impact we have?

This was discussed earlier in this thread.

With aac_cpu_offline_feature=1 fio statistics show:

# fio -filename=/home/test1G.img -iodepth=64 -thread -rw=randwrite -ioengine=libaio -bs=4K -direct=1 -runtime=300 -time_based -size=1G -group_reporting -name=mytest -numjobs=4

   WRITE: bw=495MiB/s (519MB/s), 495MiB/s-495MiB/s (519MB/s-519MB/s), io=145GiB (156GB), run=300001-300001msec

With aac_cpu_offline_feature=0 fio statistics show:

# fio -filename=/home/test1G.img -iodepth=64 -thread -rw=randwrite -ioengine=libaio -bs=4K -direct=1 -runtime=300 -time_based -size=1G -group_reporting -name=mytest -numjobs=4

   WRITE: bw=505MiB/s (529MB/s), 505MiB/s-505MiB/s (529MB/s-529MB/s), io=148GiB (159GB), run=300001-300001msec

Of course this is with a very primitive test.  As always your performance results will vary based upon workload, system size, etc..

Our customer reported the following results with this patch when aac_cpu_offline_feature=1.  This was with their specific workload.

The test configuration is: 3x Disk Raid 5:

Chunk/Stripe Size:
Stripe-unit size : 256 KB
Full Stripe Size : 512 KB

Description	Unpatched	Patched
Random reads	103K		114K
clat avg	2500		2100

Description	Unpatched	Patched
Random writes	17.7		18K
clat avg	14400		13300

fio was used to perform 4k random io with 16 jobs and iodepth of 16 which mimics the
customer's working environment/application io.

> I could imagine a single-threaded workload driving just one blk-mq queue would benefit from spreading out onto several interrupts.

Yes, I think the performance results with this patch can vary greatly.
  
> But then, this would be true for most of the multiqueue drivers; and indeed quite some drivers 
> (eg megaraid_sas & mpt3sas 'smp_affinity_enable') have the very same module option.
OK, fine... but until that option is availble... I think we need to do something with this driver.

> Wouldn't it be an idea to check if we can make this a generic / blk-mq
> queue option instead of having each driver to implement the same functionality on it's own?

> Topic for LSF?

I'd be happy to talk about this at LSF.
  
> Cheers,
> 
> Hannes

