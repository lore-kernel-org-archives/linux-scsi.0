Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21B444C7C
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 22:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739485307; cv=none; b=eDw7HYfBFivYLq4qN6UyJ0C/+qcKMU7X18hjuGNa+7Aav+5z9zTJPFe6WrL9aS6UMWvHwykUDa0+dxYbOTOLamnbX6mbRAhmEzZW+whQfE/7WXGcIx2pUsXlZk4S7q36T1ak7WJt/CrIwlGoaSTisoyd+wsjXug0V2RlAhUO/F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739485307; c=relaxed/simple;
	bh=GmXZM51t0fKyOf4O/2wi1f2vI1HRfCqrZD20NLzBCUI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qWLlTjD/i5HX2RcNOmYntjrroQC/1OXKPY8jvkUlSZ9yiRYuVFOjS87hsl9msUssa+dzluC1NAk+YXOUs3SFQQvBZv5A0dP1LXZrSbc0Z/HVJY3HARYCk5APpVo/nAsMC5y3KH6IkeCB7PpJm3gnEI/XICC3fUfRxDtemhWt+tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NWNQwzUf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NWNQwzUf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739485303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHVqBHgZ3RqRUzl101o7Wln2WJefhjJhKKIFMO7pxDk=;
	b=NWNQwzUfguVFrjKT6GeVK56Z+WLOGBraPhCaqPxwdjm835CaPzLnA8kjDXOIbpmweliUyv
	75lU11Pb+2avpDfNYNJTHchz1w63VfOLOegHu1puXYgambOIBxAVbdyZuYXmGqH1WmLht5
	ha9Fgg/Fz3/KRAXN0O5VhtSvCsBSewg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-249-k8qf04WdNxujMfUZWF78ig-1; Thu,
 13 Feb 2025 17:21:40 -0500
X-MC-Unique: k8qf04WdNxujMfUZWF78ig-1
X-Mimecast-MFC-AGG-ID: k8qf04WdNxujMfUZWF78ig_1739485299
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D977219039C8;
	Thu, 13 Feb 2025 22:21:38 +0000 (UTC)
Received: from [10.22.65.116] (unknown [10.22.65.116])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C859F1955DCE;
	Thu, 13 Feb 2025 22:21:36 +0000 (UTC)
Message-ID: <57bd1652-f20d-4f67-b5f5-97286bf3d6fd@redhat.com>
Date: Thu, 13 Feb 2025 17:21:35 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
From: John Meneghini <jmeneghi@redhat.com>
To: Sagar.Biradar@microchip.com,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, mpatalan@redhat.com,
 Scott.Benesh@microchip.com, Don.Brace@microchip.com,
 Tom.White@microchip.com, Abhinav.Kuchibhotla@microchip.com,
 John Meneghini <jmeneghi@redhat.com>
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
 <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
 <8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
Content-Language: en-US
Organization: RHEL Core Storge Team
In-Reply-To: <8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Sorry, we didn't see a panic with the offline cpu test, we saw a Call Trace.

He's a little more information from our testing.

These are notes from our QA group who tested this patch.

---

With "aac_cpu_offline_feature=0", the system continued to have issues with the offline_cpu test:

Sep 03 14:49:45 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid: Host adapter abort request.
                                                                  aacraid: Outstanding commands on (0,1,3,0):
Sep 03 14:50:12 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid: Host adapter abort request.
                                                                  aacraid: Outstanding commands on (0,1,3,0):
Sep 03 14:50:15 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid: Host adapter abort request.
                                                                  aacraid: Outstanding commands on (0,1,3,0):
Sep 03 14:50:22 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid: Host adapter abort request.
                                                                  aacraid: Outstanding commands on (0,1,3,0):
Sep 03 14:50:22 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid: Host bus reset request. SCSI hang ?
Sep 03 14:50:22 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid 0000:84:00.0: outstanding cmd: midlevel-0
Sep 03 14:50:22 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid 0000:84:00.0: outstanding cmd: lowlevel-0
Sep 03 14:50:22 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid 0000:84:00.0: outstanding cmd: error handler-2
Sep 03 14:50:22 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid 0000:84:00.0: outstanding cmd: firmware-0
Sep 03 14:50:22 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid 0000:84:00.0: outstanding cmd: kernel-0
Sep 03 14:50:23 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid 0000:84:00.0: Controller reset type is 3
Sep 03 14:50:23 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: aacraid 0000:84:00.0: Issuing IOP reset
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: INFO: task kworker/u513:2:478 blocked for more than 122 seconds.
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:       Not tainted 5.14.0-503.5118_1431178045.el9.x86_64 #1
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: task:kworker/u513:2  state:D stack:0     pid:478   tgid:478   ppid:2      flags:0x00004000
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: Workqueue: xfs-cil/dm-0 xlog_cil_push_work [xfs]
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel: Call Trace:
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  <TASK>
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  __schedule+0x229/0x550
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  schedule+0x2e/0xd0
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  xlog_wait_on_iclog+0x16b/0x180 [xfs]
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  ? __pfx_default_wake_function+0x10/0x10
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  xlog_cil_push_work+0x6c6/0x700 [xfs]
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  ? srso_return_thunk+0x5/0x5f
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  process_one_work+0x197/0x380
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  worker_thread+0x2fe/0x410
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  ? __pfx_worker_thread+0x10/0x10
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  kthread+0xe0/0x100
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  ? __pfx_kthread+0x10/0x10
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  ret_from_fork+0x2c/0x50
Sep 03 14:52:03 storageqe-34.fast.eng.rdu2.dc.redhat.com kernel:  </TASK>

Using John's test kernel, I enabled the aac_cpu_offline_feature:

I then rebooted and ran the offline cpu test  - no crashes or hangs were observed.

I generated I/O with FIO and observed the following stats:

# fio -filename=/home/test1G.img -iodepth=64 -thread -rw=randwrite -ioengine=libaio -bs=4K -direct=1 -runtime=300 -time_based -size=1G -group_reporting -name=mytest -numjobs=4

   WRITE: bw=495MiB/s (519MB/s), 495MiB/s-495MiB/s (519MB/s-519MB/s), io=145GiB (156GB), run=300001-300001msec

I then ran FIO again with aacraid aac_cpu_offline_feature=0 - statistics below:

# fio -filename=/home/test1G.img -iodepth=64 -thread -rw=randwrite -ioengine=libaio -bs=4K -direct=1 -runtime=300 -time_based -size=1G -group_reporting -name=mytest -numjobs=4

   WRITE: bw=505MiB/s (529MB/s), 505MiB/s-505MiB/s (529MB/s-529MB/s), io=148GiB (159GB), run=300001-300001msec

/John

On 2/13/25 5:03 PM, John Meneghini wrote:
>> From: Martin K. Petersen
>> Sent: Wednesday, February 12, 2025 6:56 PM
> 
>> [You don't often get email from "martin.petersen@oracle.comjames.bottomley@hansenpartnership.comjmeneghi"@redhat.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> Appears to still be a problem. I'll work with Sagar and see if we can clean this up.
> 
>>> Add a new modparam "aac_cpu_offline_feature" to control CPU offlining. By default, it's disabled (0), but can be enabled during driver load
>>
>>> with:
>>>         insmod ./aacraid.ko aac_cpu_offline_feature=1
>>
>> We are very hesitant when it comes to adding new module parameters. And
>> why wouldn't you want offlining to just work? Is the performance penalty
>> really substantial enough that we have to introduce an explicit "don't
>> be broken" option?
> 
> Yes, this is something that we debated about internally, before asking Sagar to send this patch.
> 
> I agree that it would be much better if we simply fix the driver and make offline_cpu suport work.
> 
> The modparam was added as a compromise, to allow current users and customers who do NOT care about
> cpu_offline support to keep the increased performance they want.  People generally complain any
> time there is a performance regression.
> 
> The current upstream driver is more or less unchanged when the mod param is of off, which is the default.
> So upstream users will see no performance regression... but don't try to offline a cpu or you will see
> a panic. This is the state of the current upstream driver.
> 
>> Thank you for your time to review and giving your valuable opinion.
>> There are two reasons why I chose the modparam way
>> 1) As you rightly guessed - the performance penalty is high when it comes to few RAID level configurations - which is not desired
>> 2) Not a lot of people would use CPU offlining feature as part of their regular usage. This is mostly for admin purposes.
>>
>> These two reasons made me opt for the modparam.
>> We and our folks at RedHat did venture into trying few other options - but this seemed like a nice fit.
> 
> Another option we thought about was making this a kconfig option. We have a patch that replaces the modparam with
> a Kconfig option.
> 
> However, I agree it would be better to just fix the driver, performance impact notwithstanding, and ship it. For
> my part I'd rather have a correctly functioning driver, that's slower, but doesn't panic.
> 
> It's really up to the upstream community.  We need to understand what they want.
> 
> /John
> 
> 

