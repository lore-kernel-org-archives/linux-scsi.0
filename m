Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C341C2E3AE0
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 17:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753377843; cv=none; b=EbZI7EujCtdD34fyrTYbaTRu+q6AGKGHqqFlNAQo1WdMl87wt6tlbN9Kb5xPSSypzn0oOLVCCgrIPyjaEUQgEeoPMLbyr7nRpcmkoSH4lTIGEaFKUjX/muNNfFbbtshagKrLFIx2WxueZnLxZyHwo/3mBD8yvXYU9yPN4HOo3Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753377843; c=relaxed/simple;
	bh=aSVVcnNrlgN+ov/fODicRL3WGZHa3lXF+7dKvWnnkBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z+tpZzAPGZfQnuvmbrCbBjImTNRywcIuKyeKekswAElUr3ecOy5Zd7YtiTaoBSa+smKTi+Dk18MpoJj75lV3n0stYPVXHA32fjRbpgSvafY6Sfi8qFaewwAA6mFRntOfxIJWR6zp2ez4aXU49wkAgFFz/LE+MfeoBbv/2BOhl7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bGvxw7F0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bGvxw7F0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753377840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w5pXUuJ/6HxcTx1eYXxyiHoliuNG9lqC8fHG836iMw0=;
	b=bGvxw7F0Vh5ThdHHuJ5jNFotSs/MiHQ+Q9viaNl4fW+3yKpaGri9EBrIEhR2KqBsUsJ0AA
	3ghI7VwtMTCJqrrkkR9U3l/5pkDQjdq8ELtwy/m7Bo8Rb2y7w5HIkQ30SAxy9/kUDrsEOw
	ZqC7Y5/zDBt1bMXq06dZdm3dynHxKE0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-YyB0eIyWP6eIVKhyntYWeA-1; Thu,
 24 Jul 2025 13:23:57 -0400
X-MC-Unique: YyB0eIyWP6eIVKhyntYWeA-1
X-Mimecast-MFC-AGG-ID: YyB0eIyWP6eIVKhyntYWeA_1753377836
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F41CA19560B5;
	Thu, 24 Jul 2025 17:23:55 +0000 (UTC)
Received: from [10.22.80.106] (unknown [10.22.80.106])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E589E300018D;
	Thu, 24 Jul 2025 17:23:53 +0000 (UTC)
Message-ID: <de2459a3-ba8a-4f43-bbf9-8a11420bff26@redhat.com>
Date: Thu, 24 Jul 2025 13:23:52 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
To: John Garry <john.g.garry@oracle.com>, jejb@linux.vnet.ibm.com,
 martin.petersen@oracle.com, sagar.biradar@microchip.com
Cc: linux-scsi@vger.kernel.org, hare@suse.com, ming.lei@redhat.com,
 Marco Patalano <mpatalan@redhat.com>
References: <20250715111535.499853-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250715111535.499853-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Sorry it has taken so long to get this patch tested.

The good news is: this patch fixes the offline CPU problem.

Here are the test results:

This is with 6.16.0-rc6:

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   Test
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

fio-3.36-5.el10.x86_64
:: [ 16:06:57 ] :: [   LOG    ] :: INFO: Executing FIO_Test() with on: /home/test1G.img
:: [ 16:06:57 ] :: [  BEGIN   ] :: Running 'fio -filename=/home/test1G.img -iodepth=64 -thread -rw=randwrite -ioengine=libaio -bs=4K -direct=1 -runtime=1200 -time_based -size=1G -group_reporting -name=mytest -numjobs=4 &'
:: [ 16:06:57 ] :: [   PASS   ] :: Command 'fio -filename=/home/test1G.img -iodepth=64 -thread -rw=randwrite -ioengine=libaio -bs=4K -direct=1 -runtime=1200 -time_based -size=1G -group_reporting -name=mytest -numjobs=4 &' (Expected 0, got 0)
:: [ 16:06:57 ] :: [   LOG    ] :: 16 CPUs on this system and we will offline 14
mytest: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
...
fio-3.36
Starting 4 threads
:: [ 16:07:07 ] :: [   LOG    ] :: INFO: Offline/Online CPUs - iteration 1
Offline CPU1
:: [ 16:07:07 ] :: [  BEGIN   ] :: Running 'echo 0 > /sys/devices/system/cpu/cpu1/online'
:: [ 16:07:08 ] :: [   PASS   ] :: Command 'echo 0 > /sys/devices/system/cpu/cpu1/online' (Expected 0, got 0)
Offline CPU2
:: [ 16:07:08 ] :: [  BEGIN   ] :: Running 'echo 0 > /sys/devices/system/cpu/cpu2/online'
:: [ 16:07:08 ] :: [   PASS   ] :: Command 'echo 0 > /sys/devices/system/cpu/cpu2/online' (Expected 0, got 0)
Offline CPU3
:: [ 16:07:08 ] :: [  BEGIN   ] :: Running 'echo 0 > /sys/devices/system/cpu/cpu3/online'
:: [ 16:07:08 ] :: [   PASS   ] :: Command 'echo 0 > /sys/devices/system/cpu/cpu3/online' (Expected 0, got 0)
Offline CPU4
:: [ 16:07:08 ] :: [  BEGIN   ] :: Running 'echo 0 > /sys/devices/system/cpu/cpu4/online'
:: [ 16:07:08 ] :: [   PASS   ] :: Command 'echo 0 > /sys/devices/system/cpu/cpu4/online' (Expected 0, got 0)
Offline CPU5
:: [ 16:07:08 ] :: [  BEGIN   ] :: Running 'echo 0 > /sys/devices/system/cpu/cpu5/online'
:: [ 16:07:08 ] :: [   PASS   ] :: Command 'echo 0 > /sys/devices/system/cpu/cpu5/online' (Expected 0, got 0)
Offline CPU6
:: [ 16:07:08 ] :: [  BEGIN   ] :: Running 'echo 0 > /sys/devices/system/cpu/cpu6/online'
:: [ 16:07:08 ] :: [   PASS   ] :: Command 'echo 0 > /sys/devices/system/cpu/cpu6/online' (Expected 0, got 0)

Almost immediately after offlining the CPUs IO hangs and I see this:

dmesg -Tw
[Wed Jul 23 16:07:08 2025] smpboot: CPU 1 is now offline
[Wed Jul 23 16:07:08 2025] smpboot: CPU 2 is now offline
[Wed Jul 23 16:07:08 2025] smpboot: CPU 3 is now offline
[Wed Jul 23 16:07:08 2025] smpboot: CPU 4 is now offline
[Wed Jul 23 16:07:08 2025] smpboot: CPU 5 is now offline
[Wed Jul 23 16:07:08 2025] smpboot: CPU 6 is now offline
[Wed Jul 23 16:08:10 2025] aacraid: Host adapter abort request.
                            aacraid: Outstanding commands on (1,1,3,0):
[Wed Jul 23 16:08:10 2025] aacraid: Host adapter abort request.
                            aacraid: Outstanding commands on (1,1,3,0):
[Wed Jul 23 16:08:10 2025] aacraid: Host adapter abort request.
                            aacraid: Outstanding commands on (1,1,3,0):
[Wed Jul 23 16:08:10 2025] aacraid: Host adapter abort request.
                            aacraid: Outstanding commands on (1,1,3,0):
[Wed Jul 23 16:08:10 2025] aacraid: Host adapter abort request.
                            aacraid: Outstanding commands on (1,1,3,0):
[Wed Jul 23 16:08:10 2025] aacraid: Host adapter abort request.
                            aacraid: Outstanding commands on (1,1,3,0):
[Wed Jul 23 16:08:10 2025] aacraid: Host adapter abort request.
                            aacraid: Outstanding commands on (1,1,3,0):
[Wed Jul 23 16:08:10 2025] aacraid: Host adapter abort request.
                            aacraid: Outstanding commands on (1,1,3,0):
...
[Wed Jul 23 16:08:11 2025] aacraid: Host adapter abort request.
                            aacraid: Outstanding commands on (1,1,3,0):
[Wed Jul 23 16:08:11 2025] aacraid: Host adapter abort request.
                            aacraid: Outstanding commands on (1,1,3,0):
[Wed Jul 23 16:08:11 2025] aacraid: Host bus reset request. SCSI hang ?
[Wed Jul 23 16:08:11 2025] aacraid 0000:84:00.0: outstanding cmd: midlevel-0
[Wed Jul 23 16:08:11 2025] aacraid 0000:84:00.0: outstanding cmd: lowlevel-0
[Wed Jul 23 16:08:11 2025] aacraid 0000:84:00.0: outstanding cmd: error handler-0
[Wed Jul 23 16:08:11 2025] aacraid 0000:84:00.0: outstanding cmd: firmware-64
[Wed Jul 23 16:08:11 2025] aacraid 0000:84:00.0: outstanding cmd: kernel-0
[Wed Jul 23 16:08:11 2025] aacraid 0000:84:00.0: Controller reset type is 3
[Wed Jul 23 16:08:11 2025] aacraid 0000:84:00.0: Issuing IOP reset
[Wed Jul 23 16:09:28 2025] INFO: task kworker/10:1:162 blocked for more than 121 seconds.
[Wed Jul 23 16:09:28 2025]       Not tainted 6.16.0-rc6 #1
[Wed Jul 23 16:09:28 2025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Wed Jul 23 16:09:28 2025] task:kworker/10:1    state:D stack:0     pid:162   tgid:162   ppid:2      task_flags:0x4208060 flags:0x00004000
[Wed Jul 23 16:09:28 2025] Workqueue: events_freezable_pwr_efficient disk_events_workfn
[Wed Jul 23 16:09:28 2025] Call Trace:
[Wed Jul 23 16:09:28 2025]  <TASK>
[Wed Jul 23 16:09:28 2025]  __schedule+0x2c8/0x730
[Wed Jul 23 16:09:28 2025]  schedule+0x27/0x80
[Wed Jul 23 16:09:28 2025]  io_schedule+0x46/0x70
[Wed Jul 23 16:09:28 2025]  blk_mq_get_tag+0x122/0x290
[Wed Jul 23 16:09:28 2025]  ? __pfx_autoremove_wake_function+0x10/0x10
[Wed Jul 23 16:09:28 2025]  __blk_mq_alloc_requests+0xb5/0x240
[Wed Jul 23 16:09:28 2025]  blk_mq_alloc_request+0x1e8/0x280
[Wed Jul 23 16:09:28 2025]  scsi_execute_cmd+0xbf/0x2a0
[Wed Jul 23 16:09:28 2025]  ? dl_server_stop+0x2f/0x40
[Wed Jul 23 16:09:28 2025]  ? srso_return_thunk+0x5/0x5f
[Wed Jul 23 16:09:28 2025]  scsi_test_unit_ready+0x74/0x100
[Wed Jul 23 16:09:28 2025]  sd_check_events+0xfa/0x1a0 [sd_mod]
[Wed Jul 23 16:09:28 2025]  disk_check_events+0x3a/0x100
[Wed Jul 23 16:09:28 2025]  ? __schedule+0x2d0/0x730
[Wed Jul 23 16:09:28 2025]  process_one_work+0x18b/0x340
[Wed Jul 23 16:09:28 2025]  worker_thread+0x256/0x3a0
[Wed Jul 23 16:09:28 2025]  ? __pfx_worker_thread+0x10/0x10
[Wed Jul 23 16:09:28 2025]  kthread+0xfc/0x240
[Wed Jul 23 16:09:28 2025]  ? __pfx_kthread+0x10/0x10
[Wed Jul 23 16:09:28 2025]  ? __pfx_kthread+0x10/0x10
[Wed Jul 23 16:09:28 2025]  ret_from_fork+0xf0/0x110
[Wed Jul 23 16:09:28 2025]  ? __pfx_kthread+0x10/0x10
[Wed Jul 23 16:09:28 2025]  ret_from_fork_asm+0x1a/0x30
[Wed Jul 23 16:09:28 2025]  </TASK>
[Wed Jul 23 16:09:28 2025] INFO: task main.sh:1849 blocked for more than 121 seconds.
[Wed Jul 23 16:09:28 2025]       Not tainted 6.16.0-rc6 #1
[Wed Jul 23 16:09:28 2025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Wed Jul 23 16:09:28 2025] task:main.sh         state:D stack:0     pid:1849  tgid:1849  ppid:1339   task_flags:0x400040 flags:0x00004002
...
[Wed Jul 23 16:09:32 2025] aacraid 0000:84:00.0: IOP reset succeeded
[Wed Jul 23 16:09:32 2025] aacraid: Comm Interface type2 enabled

The machine is hung at this point and has to be power-cycled to recover.

With your patch, all tests pass:

storageqe-34:linux(aacraid_072225) > git log --oneline -2
6ef5eabf114c (HEAD -> aacraid_072225, johnm/aacraid_072225) scsi: aacraid: Stop using PCI_IRQ_AFFINITY
347e9f5043c8 (tag: v6.16-rc6, branch_v6.16-rc6) Linux 6.16-rc6


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   unknown
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: [ 17:44:30 ] :: [   LOG    ] :: Phases fingerprint:  L5rLAvqh
:: [ 17:44:30 ] :: [   LOG    ] :: Asserts fingerprint: Jdim1mp9
:: [ 17:44:30 ] :: [   LOG    ] :: JOURNAL XML: /var/tmp/beakerlib-h5opPB5/journal.xml
:: [ 17:44:30 ] :: [   LOG    ] :: JOURNAL TXT: /var/tmp/beakerlib-h5opPB5/journal.txt
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   Duration: 1262s
::   Phases: 1 good, 0 bad
::   OVERALL RESULT: PASS (unknown)

:: [ 17:44:02 ] :: [   PASS   ] :: Command 'echo 1 > /sys/devices/system/cpu/cpu11/online' (Expected 0, got 0)
:: [ 17:44:02 ] :: [   PASS   ] :: Command 'echo 1 > /sys/devices/system/cpu/cpu12/online' (Expected 0, got 0)
:: [ 17:44:02 ] :: [   PASS   ] :: Command 'echo 1 > /sys/devices/system/cpu/cpu13/online' (Expected 0, got 0)
:: [ 17:44:02 ] :: [   PASS   ] :: Command 'echo 1 > /sys/devices/system/cpu/cpu14/online' (Expected 0, got 0)
:: [ 17:44:07 ] :: [   PASS   ] :: Command 'sleep 5' (Expected 0, got 0)
:: [ 17:44:07 ] :: [   LOG    ] :: INFO: wait for fio operation to complete
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   Duration: 1239s
::   Assertions: 3001 good, 0 bad
::   RESULT: PASS (Test)


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   unknown
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: [ 17:44:30 ] :: [   LOG    ] :: Phases fingerprint:  L5rLAvqh
:: [ 17:44:30 ] :: [   LOG    ] :: Asserts fingerprint: Jdim1mp9
:: [ 17:44:30 ] :: [   LOG    ] :: JOURNAL XML: /var/tmp/beakerlib-h5opPB5/journal.xml
:: [ 17:44:30 ] :: [   LOG    ] :: JOURNAL TXT: /var/tmp/beakerlib-h5opPB5/journal.txt
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   Duration: 1262s
::   Phases: 1 good, 0 bad
::   OVERALL RESULT: PASS (unknown)


John A. Meneghini
Senior Principal Platform Storage Engineer
RHEL SST - Platform Storage Group
jmeneghi@redhat.com

On 7/15/25 7:15 AM, John Garry wrote:
> When PCI_IRQ_AFFINITY is set for calling pci_alloc_irq_vectors(), it
> means interrupts are spread around the available CPUs. It also means that
> the interrupts become managed, which means that an interrupt is shutdown
> when all the CPUs in the interrupt affinity mask go offline.
> 
> Using managed interrupts in this way means that we should ensure that
> completions should not occur on HW queues where the associated interrupt
> is shutdown. This is typically achieved by ensuring only CPUs which are
> online can generate IO completion traffic to the HW queue which they are
> mapped to (so that they can also serve completion interrupts for that
> HW queue).
> 
> The problem in the driver is that a CPU can generate completions to
> a HW queue whose interrupt may be shutdown, as the CPUs in the HW queue
> interrupt affinity mask may be offline. This can cause IOs to never
> complete and hang the system. The driver maintains its own CPU <-> HW
> queue mapping for submissions, see aac_fib_vector_assign(), but this
> does not reflect the CPU <-> HW queue interrupt affinity mapping.
> 
> Commit 9dc704dcc09e ("scsi: aacraid: Reply queue mapping to CPUs based on
> IRQ affinity") tried to remedy this issue may mapping CPUs properly to
> HW queue interrupts. However this was later reverted in commit c5becf57dd56
> ("Revert "scsi: aacraid: Reply queue mapping to CPUs based on IRQ
> affinity") - it seems that there were other reports of hangs. I guess that
> this was due to some implementation issue in the original commit or
> maybe a HW issue.
> 
> Fix the very original hang by just not using managed interrupts by not
> setting PCI_IRQ_AFFINITY.  In this way, all CPUs will be in each HW
> queue affinity mask, so should not create completion problems if any
> CPUs go offline.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
> build tested only
> 
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index 28cf18955a08..726c8531b7d3 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -481,8 +481,7 @@ void aac_define_int_mode(struct aac_dev *dev)
>   	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
>   		min_msix = 2;
>   		i = pci_alloc_irq_vectors(dev->pdev,
> -					  min_msix, msi_count,
> -					  PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
> +					  min_msix, msi_count, PCI_IRQ_MSIX);
>   		if (i > 0) {
>   			dev->msi_enabled = 1;
>   			msi_count = i;

