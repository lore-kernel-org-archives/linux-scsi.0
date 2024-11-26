Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934F78F7D
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2024 14:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732630523; cv=none; b=txupsoue13vC4dv+e1Ry7KmCLlD7P9NvxrUu2b10z4eBMW1nIOax4up64xvOYRldYQGdalBLucrJn2PPdm4o0f9rZ9Wck3ZibsehKAO2rllR3709Dl5rBeihORttYfXlE2860Zy06j0qiA6tc0/3NIONsewQyKSOX8QB4Qmttiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732630523; c=relaxed/simple;
	bh=KGsXrX1qAgWUV2J4o9NOVGsSuKterTunNEPgArxUBuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c5zJnrOylEGiEmJL+YcqEy3qIfATYfiPipd3vjVF7uUgdjLdSCYUduJg5t4QoLIRWoVLi4kjPxJ/DiuOhWZPwkZYUGwzMIP7/C0VUSXL+ltMG9KGagYo1Vyh0OfHG7UYveRGlU3vuGSXuFo0VaApk2Vn6jtpQKQmaTbyl1F+uWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=USfKaUw7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USfKaUw7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732630520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2W4Ssfimb/qOh9l2XaBzKk4OQ1NBpXK08fbyiSEULo=;
	b=USfKaUw7TGOH7Fkk2LtjZQWvo+/lJkbqS1BkDb/kQFRowTH0pjkKN8f3wLv0h+EKygmwLb
	y5KYG5uS1cFqBX/fOY+1/2HR+wzOUYfg6VNXetDFBX12cBe/mH/O2qa9TcbmLBffqM/iPF
	a4oSVjrEc3TjVQyBkNYPxZElwdROwD0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-gyfrhSUnNyuxMJYoMiW5EQ-1; Tue,
 26 Nov 2024 09:15:16 -0500
X-MC-Unique: gyfrhSUnNyuxMJYoMiW5EQ-1
X-Mimecast-MFC-AGG-ID: gyfrhSUnNyuxMJYoMiW5EQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA3E21955E9F;
	Tue, 26 Nov 2024 14:15:13 +0000 (UTC)
Received: from fedora (unknown [10.72.116.45])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF1181956054;
	Tue, 26 Nov 2024 14:15:07 +0000 (UTC)
Date: Tue, 26 Nov 2024 22:15:02 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Qiang Ma <maqianga@uniontech.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	axboe@kernel.dk, dwagner@suse.de, hare@suse.de,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Don't wait for completion of in-flight requests
Message-ID: <Z0XX5ts2yTO7Frl8@fedora>
References: <20241126115008.31272-1-maqianga@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241126115008.31272-1-maqianga@uniontech.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Nov 26, 2024 at 07:50:08PM +0800, Qiang Ma wrote:
> Problem:
> When the system disk uses the scsi disk bus, The main
> qemu command line includes:
> ...
> -device virtio-scsi-pci,id=scsi0 \
> -device scsi-hd,scsi-id=1,drive=drive-virtio-disk
> -drive id=drive-virtio-disk,if=none,file=/home/kvm/test.qcow2
> ...
> 
> The dmesg log is as follows::
> 
> [   50.304591][ T4382] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [   50.377002][ T4382] kexec_core: Starting new kernel
> [   50.669775][  T194] psci: CPU1 killed (polled 0 ms)
> [   50.849665][  T194] psci: CPU2 killed (polled 0 ms)
> [   51.109625][  T194] psci: CPU3 killed (polled 0 ms)
> [   51.319594][  T194] psci: CPU4 killed (polled 0 ms)
> [   51.489667][  T194] psci: CPU5 killed (polled 0 ms)
> [   51.709582][  T194] psci: CPU6 killed (polled 0 ms)
> [   51.949508][   T10] psci: CPU7 killed (polled 0 ms)
> [   52.139499][   T10] psci: CPU8 killed (polled 0 ms)
> [   52.289426][   T10] psci: CPU9 killed (polled 0 ms)
> [   52.439552][   T10] psci: CPU10 killed (polled 0 ms)
> [   52.579525][   T10] psci: CPU11 killed (polled 0 ms)
> [   52.709501][   T10] psci: CPU12 killed (polled 0 ms)
> [   52.819509][  T194] psci: CPU13 killed (polled 0 ms)
> [   52.919509][  T194] psci: CPU14 killed (polled 0 ms)
> [  243.214009][  T115] INFO: task kworker/0:1:10 blocked for more than 122 seconds.
> [  243.214810][  T115]       Not tainted 6.6.0+ #1
> [  243.215517][  T115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  243.216390][  T115] task:kworker/0:1     state:D stack:0     pid:10    ppid:2      flags:0x00000008
> [  243.217299][  T115] Workqueue: events vmstat_shepherd
> [  243.217816][  T115] Call trace:
> [  243.218133][  T115]  __switch_to+0x130/0x1e8
> [  243.218568][  T115]  __schedule+0x660/0xcf8
> [  243.219013][  T115]  schedule+0x58/0xf0
> [  243.219402][  T115]  percpu_rwsem_wait+0xb0/0x1d0
> [  243.219880][  T115]  __percpu_down_read+0x40/0xe0
> [  243.220353][  T115]  cpus_read_lock+0x5c/0x70
> [  243.220795][  T115]  vmstat_shepherd+0x40/0x140
> [  243.221250][  T115]  process_one_work+0x170/0x3c0
> [  243.221726][  T115]  worker_thread+0x234/0x3b8
> [  243.222176][  T115]  kthread+0xf0/0x108
> [  243.222564][  T115]  ret_from_fork+0x10/0x20
> ...
> [  243.254080][  T115] INFO: task kworker/0:2:194 blocked for more than 122 seconds.
> [  243.254834][  T115]       Not tainted 6.6.0+ #1
> [  243.255529][  T115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  243.256378][  T115] task:kworker/0:2     state:D stack:0     pid:194   ppid:2      flags:0x00000008
> [  243.257284][  T115] Workqueue: events work_for_cpu_fn
> [  243.257793][  T115] Call trace:
> [  243.258111][  T115]  __switch_to+0x130/0x1e8
> [  243.258541][  T115]  __schedule+0x660/0xcf8
> [  243.258971][  T115]  schedule+0x58/0xf0
> [  243.259360][  T115]  schedule_timeout+0x280/0x2f0
> [  243.259832][  T115]  wait_for_common+0xcc/0x2d8
> [  243.260287][  T115]  wait_for_completion+0x20/0x38
> [  243.260767][  T115]  cpuhp_kick_ap+0xe8/0x278
> [  243.261207][  T115]  cpuhp_kick_ap_work+0x5c/0x188
> [  243.261688][  T115]  _cpu_down+0x120/0x378
> [  243.262103][  T115]  __cpu_down_maps_locked+0x20/0x38
> [  243.262609][  T115]  work_for_cpu_fn+0x24/0x40
> [  243.263059][  T115]  process_one_work+0x170/0x3c0
> [  243.263533][  T115]  worker_thread+0x234/0x3b8
> [  243.263981][  T115]  kthread+0xf0/0x108
> [  243.264405][  T115]  ret_from_fork+0x10/0x20
> [  243.264846][  T115] INFO: task kworker/15:2:639 blocked for more than 122 seconds.
> [  243.265602][  T115]       Not tainted 6.6.0+ #1
> [  243.266296][  T115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  243.267143][  T115] task:kworker/15:2    state:D stack:0     pid:639   ppid:2      flags:0x00000008
> [  243.268044][  T115] Workqueue: events_freezable_power_ disk_events_workfn
> [  243.268727][  T115] Call trace:
> [  243.269051][  T115]  __switch_to+0x130/0x1e8
> [  243.269481][  T115]  __schedule+0x660/0xcf8
> [  243.269903][  T115]  schedule+0x58/0xf0
> [  243.270293][  T115]  schedule_timeout+0x280/0x2f0
> [  243.270763][  T115]  io_schedule_timeout+0x50/0x70
> [  243.271245][  T115]  wait_for_common_io.constprop.0+0xb0/0x298
> [  243.271830][  T115]  wait_for_completion_io+0x1c/0x30
> [  243.272335][  T115]  blk_execute_rq+0x1d8/0x278
> [  243.272793][  T115]  scsi_execute_cmd+0x114/0x238
> [  243.273267][  T115]  sr_check_events+0xc8/0x310 [sr_mod]
> [  243.273808][  T115]  cdrom_check_events+0x2c/0x50 [cdrom]
> [  243.274408][  T115]  sr_block_check_events+0x34/0x48 [sr_mod]
> [  243.274994][  T115]  disk_check_events+0x44/0x1b0
> [  243.275468][  T115]  disk_events_workfn+0x20/0x38
> [  243.275939][  T115]  process_one_work+0x170/0x3c0
> [  243.276410][  T115]  worker_thread+0x234/0x3b8
> [  243.276855][  T115]  kthread+0xf0/0x108
> [  243.277241][  T115]  ret_from_fork+0x10/0x20

Question is why this scsi command can't be completed?

When blk_mq_hctx_notify_offline() is called, the CPU isn't shutdown yet,
and it still can handle interrupt of this SCSI command.


Thanks,
Ming

