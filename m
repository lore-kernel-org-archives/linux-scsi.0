Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE921FF7C3
	for <linux-scsi@vger.kernel.org>; Wed, 27 Nov 2024 15:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732720849; cv=none; b=ctQOmTxZ3nXIT6SfB/2H295z3/5HHcjtzGWmMzG1LarwargBxnjO0GDRHcPKx+MpRpytFyDTHuqYIMWawCh8Hk7fSqGYMPxQye5ws9SYVrH01XThUjcuQk2Z7cSK/q9Z3Hd8959C8egZpmZ/Hm8OUn3FBUAnyVoWco7vRNXyZ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732720849; c=relaxed/simple;
	bh=/3Wsd0r1atmN8QgendSG2mAiHmuXScUakR9O7v+XZZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJN45DrIBVzBoRQI9+3dqS4U114FpuubS3ECJUT1Gig21oVxolNUHmLLZIw+T/KupTr7AO2e5rcuV1RzG80p2o4nim0HaaRKBc7AEfw6mi8wItC9QXeXLiBI9CnQK3/QpBirKFIcveNR4DxqZ05q1K6ITskV1dPJQeqEmEIo5oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fgjqd4DN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fgjqd4DN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732720847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2m3sM+geAVqtO9zJQ0mLUooy55Xp73Cx8PifdCc8B0s=;
	b=Fgjqd4DN2aKOuctsRJhwLxq1ItF7Pg5AgJMOXrojlJaE7oiSSlW1rFiqrFOMPFqd2siPAv
	2rkOQpJrpwdxFEeqTjotnA/e+u1QdMO2wLH7l/4x0MqWyEhS2r8I6P+s+HS3yzLTxULOrl
	dGNLSa2U0vl11ZE97QM1m0BvJc0Sz30=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-vbvfy8jRNE639mBPqSDwow-1; Wed,
 27 Nov 2024 10:20:41 -0500
X-MC-Unique: vbvfy8jRNE639mBPqSDwow-1
X-Mimecast-MFC-AGG-ID: vbvfy8jRNE639mBPqSDwow
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFD3D1936133;
	Wed, 27 Nov 2024 15:20:39 +0000 (UTC)
Received: from fedora (unknown [10.72.116.17])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 14770300019E;
	Wed, 27 Nov 2024 15:20:33 +0000 (UTC)
Date: Wed, 27 Nov 2024 23:20:28 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Qiang Ma <maqianga@uniontech.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	axboe@kernel.dk, dwagner@suse.de, hare@suse.de,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Don't wait for completion of in-flight requests
Message-ID: <Z0c4vPLnwicI6T9J@fedora>
References: <20241126115008.31272-1-maqianga@uniontech.com>
 <Z0XX5ts2yTO7Frl8@fedora>
 <2100C70C0D4CA64E+20241127220437.65ae99dd@john-PC>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2100C70C0D4CA64E+20241127220437.65ae99dd@john-PC>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Nov 27, 2024 at 10:04:37PM +0800, Qiang Ma wrote:
> On Tue, 26 Nov 2024 22:15:02 +0800
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Tue, Nov 26, 2024 at 07:50:08PM +0800, Qiang Ma wrote:
> > > Problem:
> > > When the system disk uses the scsi disk bus, The main
> > > qemu command line includes:
> > > ...
> > > -device virtio-scsi-pci,id=scsi0 \
> > > -device scsi-hd,scsi-id=1,drive=drive-virtio-disk
> > > -drive id=drive-virtio-disk,if=none,file=/home/kvm/test.qcow2
> > > ...
> > > 
> > > The dmesg log is as follows::
> > > 
> > > [   50.304591][ T4382] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > > [   50.377002][ T4382] kexec_core: Starting new kernel

Why is one new kernel started? what event triggers kernel_kexec()?

machine_shutdown() follows, probably the scsi controller is dead.

> > > [   50.669775][  T194] psci: CPU1 killed (polled 0 ms)
> > > [   50.849665][  T194] psci: CPU2 killed (polled 0 ms)
> > > [   51.109625][  T194] psci: CPU3 killed (polled 0 ms)
> > > [   51.319594][  T194] psci: CPU4 killed (polled 0 ms)
> > > [   51.489667][  T194] psci: CPU5 killed (polled 0 ms)
> > > [   51.709582][  T194] psci: CPU6 killed (polled 0 ms)
> > > [   51.949508][   T10] psci: CPU7 killed (polled 0 ms)
> > > [   52.139499][   T10] psci: CPU8 killed (polled 0 ms)
> > > [   52.289426][   T10] psci: CPU9 killed (polled 0 ms)
> > > [   52.439552][   T10] psci: CPU10 killed (polled 0 ms)
> > > [   52.579525][   T10] psci: CPU11 killed (polled 0 ms)
> > > [   52.709501][   T10] psci: CPU12 killed (polled 0 ms)
> > > [   52.819509][  T194] psci: CPU13 killed (polled 0 ms)
> > > [   52.919509][  T194] psci: CPU14 killed (polled 0 ms)
> > > [  243.214009][  T115] INFO: task kworker/0:1:10 blocked for more
> > > than 122 seconds. [  243.214810][  T115]       Not tainted 6.6.0+ #1
> > > [  243.215517][  T115] "echo 0
> > > > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > [  243.216390][  T115] task:kworker/0:1     state:D stack:0
> > > > pid:10    ppid:2      flags:0x00000008
> > > [  243.217299][  T115] Workqueue: events vmstat_shepherd
> > > [  243.217816][  T115] Call trace:
> > > [  243.218133][  T115]  __switch_to+0x130/0x1e8
> > > [  243.218568][  T115]  __schedule+0x660/0xcf8
> > > [  243.219013][  T115]  schedule+0x58/0xf0
> > > [  243.219402][  T115]  percpu_rwsem_wait+0xb0/0x1d0
> > > [  243.219880][  T115]  __percpu_down_read+0x40/0xe0
> > > [  243.220353][  T115]  cpus_read_lock+0x5c/0x70
> > > [  243.220795][  T115]  vmstat_shepherd+0x40/0x140
> > > [  243.221250][  T115]  process_one_work+0x170/0x3c0
> > > [  243.221726][  T115]  worker_thread+0x234/0x3b8
> > > [  243.222176][  T115]  kthread+0xf0/0x108
> > > [  243.222564][  T115]  ret_from_fork+0x10/0x20
> > > ...
> > > [  243.254080][  T115] INFO: task kworker/0:2:194 blocked for more
> > > than 122 seconds. [  243.254834][  T115]       Not tainted 6.6.0+ #1
> > > [  243.255529][  T115] "echo 0
> > > > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > [  243.256378][  T115] task:kworker/0:2     state:D stack:0
> > > > pid:194   ppid:2      flags:0x00000008
> > > [  243.257284][  T115] Workqueue: events work_for_cpu_fn
> > > [  243.257793][  T115] Call trace:
> > > [  243.258111][  T115]  __switch_to+0x130/0x1e8
> > > [  243.258541][  T115]  __schedule+0x660/0xcf8
> > > [  243.258971][  T115]  schedule+0x58/0xf0
> > > [  243.259360][  T115]  schedule_timeout+0x280/0x2f0
> > > [  243.259832][  T115]  wait_for_common+0xcc/0x2d8
> > > [  243.260287][  T115]  wait_for_completion+0x20/0x38
> > > [  243.260767][  T115]  cpuhp_kick_ap+0xe8/0x278
> > > [  243.261207][  T115]  cpuhp_kick_ap_work+0x5c/0x188
> > > [  243.261688][  T115]  _cpu_down+0x120/0x378
> > > [  243.262103][  T115]  __cpu_down_maps_locked+0x20/0x38
> > > [  243.262609][  T115]  work_for_cpu_fn+0x24/0x40
> > > [  243.263059][  T115]  process_one_work+0x170/0x3c0
> > > [  243.263533][  T115]  worker_thread+0x234/0x3b8
> > > [  243.263981][  T115]  kthread+0xf0/0x108
> > > [  243.264405][  T115]  ret_from_fork+0x10/0x20
> > > [  243.264846][  T115] INFO: task kworker/15:2:639 blocked for more
> > > than 122 seconds. [  243.265602][  T115]       Not tainted 6.6.0+ #1
> > > [  243.266296][  T115] "echo 0
> > > > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > [  243.267143][  T115] task:kworker/15:2    state:D stack:0
> > > > pid:639   ppid:2      flags:0x00000008
> > > [  243.268044][  T115] Workqueue: events_freezable_power_
> > > disk_events_workfn [  243.268727][  T115] Call trace:
> > > [  243.269051][  T115]  __switch_to+0x130/0x1e8
> > > [  243.269481][  T115]  __schedule+0x660/0xcf8
> > > [  243.269903][  T115]  schedule+0x58/0xf0
> > > [  243.270293][  T115]  schedule_timeout+0x280/0x2f0
> > > [  243.270763][  T115]  io_schedule_timeout+0x50/0x70
> > > [  243.271245][  T115]  wait_for_common_io.constprop.0+0xb0/0x298
> > > [  243.271830][  T115]  wait_for_completion_io+0x1c/0x30
> > > [  243.272335][  T115]  blk_execute_rq+0x1d8/0x278
> > > [  243.272793][  T115]  scsi_execute_cmd+0x114/0x238
> > > [  243.273267][  T115]  sr_check_events+0xc8/0x310 [sr_mod]
> > > [  243.273808][  T115]  cdrom_check_events+0x2c/0x50 [cdrom]
> > > [  243.274408][  T115]  sr_block_check_events+0x34/0x48 [sr_mod]
> > > [  243.274994][  T115]  disk_check_events+0x44/0x1b0
> > > [  243.275468][  T115]  disk_events_workfn+0x20/0x38
> > > [  243.275939][  T115]  process_one_work+0x170/0x3c0
> > > [  243.276410][  T115]  worker_thread+0x234/0x3b8
> > > [  243.276855][  T115]  kthread+0xf0/0x108
> > > [  243.277241][  T115]  ret_from_fork+0x10/0x20  
> > 
> > Question is why this scsi command can't be completed?
> > 
> > When blk_mq_hctx_notify_offline() is called, the CPU isn't shutdown
> > yet, and it still can handle interrupt of this SCSI command.
> > 
> > 
> > Thanks,
> > Ming
> > 
> > 
> Sorry, at the moment I don't know why it can't be finished,
> just provides a solution like loop and dm-rq.
> 
> Currently see the call stack:
>  => blk_mq_run_hw_queue
>  =>__blk_mq_sched_restart
>  => blk_mq_run_hw_queue
>  => __blk_mq_sched_restart
>  => __blk_mq_free_request
>  => blk_mq_free_request
>  => blk_mq_end_request
>  => blk_flush_complete_seq
>  => flush_end_io
>  => __blk_mq_end_request
>  => scsi_end_request
>  => scsi_io_completion
>  => scsi_finish_command
>  => scsi_complete
>  => blk_mq_complete_request
>  => scsi_done_internal
>  => scsi_done
>  => virtscsi_complete_cmd
>  => virtscsi_req_done
>  => vring_interrupt
> 
> In finction blk_mq_run_hw_queue():
> __blk_mq_run_dispatch_ops(hctx->queue, false,
> 	need_run = !blk_queue_quiesced(hctx->queue) &&
> 	blk_mq_hctx_has_pending(hctx));
> 	
> 	if (!need_run)
> 		return;
> 
> Come here and return directly.

Does blk_queue_quiesced() return true?

Thanks,
Ming

