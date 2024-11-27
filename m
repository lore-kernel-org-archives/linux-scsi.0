Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54FF1FE44E;
	Wed, 27 Nov 2024 14:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.82.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732716367; cv=none; b=k86T95c1btjBrmChXkg3aIMQJGNlGGKlOoTKpx+dAgJSOnYoalDOcDNdYvFBd1P/vyKe2AhaZOFG0ExKEdusypO/s3Gs2x+n+kgADTN5y8UHaH4C/HmSgcP/XFf80W+QVQMzTsm4DZdcuA7HhVqqIt5zkSeBu4kKx+r9yv/vDmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732716367; c=relaxed/simple;
	bh=hl7pSD6Va2jGqRKBmvbTdZ0ciQe7LWwiApySQUTIuvo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kHl0I85QKh6sX3qyxWJTKKY5c+JSZpgmhlgpaXJoU6a/jEk21SCHLkd0kVC/6JyN3jg+rUAc8SJfJ+zclOoKT2zAft0+axpvd/1DxYDw3T9lfxCLFleZVt91DJyYPrCrqIxc3Zb1o7ThV4rD/dz15SVq5dizSEqqeOGB8CfpKyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Cw7SGPTs; arc=none smtp.client-ip=15.184.82.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Cw7SGPTs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1732716303;
	bh=lpUbe2iEsrUtD+K5F9y6D/Hf9UaLdV/dPn5S7BDZQhg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version;
	b=Cw7SGPTsUlgHMOjE5hqeswDJUjGNiypvJ0beooRjY6NzvRoIoSynJNq5UUTxeJh07
	 QXPqHPQ4R0kZ1Dm7CmEPN8au2PN+H5gEV2tg2wpLEQ5m+0zRgNlNCJQbT3IT2e85do
	 4lWzSyLOPc9jX6pOVRrowJCzX4SyqBMIAlm5SvW8=
X-QQ-mid: bizesmtpip2t1732716296tq0sm4o
X-QQ-Originating-IP: 6G/NEyDYBKCNIRtbsqGJy8MY0E1haWqHzGi0uC6UhiU=
Received: from john-PC ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 Nov 2024 22:04:55 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11257385633280249915
Date: Wed, 27 Nov 2024 22:04:37 +0800
From: Qiang Ma <maqianga@uniontech.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 axboe@kernel.dk, dwagner@suse.de, hare@suse.de, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Don't wait for completion of in-flight requests
Message-ID: <2100C70C0D4CA64E+20241127220437.65ae99dd@john-PC>
In-Reply-To: <Z0XX5ts2yTO7Frl8@fedora>
References: <20241126115008.31272-1-maqianga@uniontech.com>
	<Z0XX5ts2yTO7Frl8@fedora>
Organization: UOS
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: Mvv6JxatWTxOSRmhP7JMgzgavZD0f53HUEeJB2hcQvrlBqsxhpK6+9dF
	ZFcz4rHRZWIFcF1bVXH+B5JYfzO1U/TDT00TwNpyxwgTKE0czWY8elDpqopmDilDv+HfELp
	JLIjyvxyGjZAvh2s3sJ5khuSEGnfyHbnEIKPIl7SF5awfGoGJI6px3HlIzgqimF181cpb8P
	EGS5YsoYHn1vQF3OhAF5iFWJBUDVRQqUBSGcCgiKz9xnOlKvnPiOYiX1YRMOTf8U486LVup
	2Nd4xfWfwPsXfeljXPGTcF84rA1ESgywNncYp2j7bsRN21TxKTaNVYkD4szraOxiSHHh0JQ
	cXVRGMlmb2V59n3od55wXyzAeVCyFvhpPd9w0HdaRehw5W4tiI8Fu6fCcaFUmPKWWqC6vTr
	/mYM/G3tWebIOwaw+3YN792QrYsahHGKbcO3pIBKsgiPtnzeaUAh77+0A0mNuPujzf57PpQ
	pVwkgR0/vU/luwNsZhJjKT18X2WdJNLccOk4Me0thjYYNbdDC8Xs/V5srV9EyS7S7fzBz+a
	zgfKO6spNuDjgVGo5ukU9j2lkneP0cW57UWEJR5Z7UX5Z14LswtVg3zoP03LE7XfxhuXqqB
	yV+8falDei8GrN54GcikPv4hqeAYckxMq8uudsZIIsp9Tv50CLSgBr0/UxIOV2c5k1e0bBN
	f/aWZX/ziN/ytIHj0ixynt/RqDUXQpuMw9xmTN6v20jWH9hQDxzE8ppki5DBDtMQg4x+vEY
	mb1tNRgNPU0YqOlavPndtdy55dpTta6Yi0M6fZCrthkGKKUUEltaZ8w6xVRA+moOYHjZtgp
	MOHIeW6gQMNLSpscwbSPftXJcdQz+XX866CQ9mPX0OvtCmfEChaOUkp0Iy4DjlU4GrAlVOx
	Hp7dGi6TFkLIkH7IaWcYAw/2pd9V3yh4Bi6bWuyG50skF8alP3UUw6Lkj1e/sCzDRRxJ+/W
	iE25ST0P69ftc10AGED3J2vbY82gPNyHy/n1Nq5EA6IjmdZOtHu8MTh/1+J2Wf0I5KdNKDq
	+UVe+XaYpJmSRihKgc
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

On Tue, 26 Nov 2024 22:15:02 +0800
Ming Lei <ming.lei@redhat.com> wrote:

> On Tue, Nov 26, 2024 at 07:50:08PM +0800, Qiang Ma wrote:
> > Problem:
> > When the system disk uses the scsi disk bus, The main
> > qemu command line includes:
> > ...
> > -device virtio-scsi-pci,id=scsi0 \
> > -device scsi-hd,scsi-id=1,drive=drive-virtio-disk
> > -drive id=drive-virtio-disk,if=none,file=/home/kvm/test.qcow2
> > ...
> > 
> > The dmesg log is as follows::
> > 
> > [   50.304591][ T4382] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > [   50.377002][ T4382] kexec_core: Starting new kernel
> > [   50.669775][  T194] psci: CPU1 killed (polled 0 ms)
> > [   50.849665][  T194] psci: CPU2 killed (polled 0 ms)
> > [   51.109625][  T194] psci: CPU3 killed (polled 0 ms)
> > [   51.319594][  T194] psci: CPU4 killed (polled 0 ms)
> > [   51.489667][  T194] psci: CPU5 killed (polled 0 ms)
> > [   51.709582][  T194] psci: CPU6 killed (polled 0 ms)
> > [   51.949508][   T10] psci: CPU7 killed (polled 0 ms)
> > [   52.139499][   T10] psci: CPU8 killed (polled 0 ms)
> > [   52.289426][   T10] psci: CPU9 killed (polled 0 ms)
> > [   52.439552][   T10] psci: CPU10 killed (polled 0 ms)
> > [   52.579525][   T10] psci: CPU11 killed (polled 0 ms)
> > [   52.709501][   T10] psci: CPU12 killed (polled 0 ms)
> > [   52.819509][  T194] psci: CPU13 killed (polled 0 ms)
> > [   52.919509][  T194] psci: CPU14 killed (polled 0 ms)
> > [  243.214009][  T115] INFO: task kworker/0:1:10 blocked for more
> > than 122 seconds. [  243.214810][  T115]       Not tainted 6.6.0+ #1
> > [  243.215517][  T115] "echo 0
> > > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > [  243.216390][  T115] task:kworker/0:1     state:D stack:0
> > > pid:10    ppid:2      flags:0x00000008
> > [  243.217299][  T115] Workqueue: events vmstat_shepherd
> > [  243.217816][  T115] Call trace:
> > [  243.218133][  T115]  __switch_to+0x130/0x1e8
> > [  243.218568][  T115]  __schedule+0x660/0xcf8
> > [  243.219013][  T115]  schedule+0x58/0xf0
> > [  243.219402][  T115]  percpu_rwsem_wait+0xb0/0x1d0
> > [  243.219880][  T115]  __percpu_down_read+0x40/0xe0
> > [  243.220353][  T115]  cpus_read_lock+0x5c/0x70
> > [  243.220795][  T115]  vmstat_shepherd+0x40/0x140
> > [  243.221250][  T115]  process_one_work+0x170/0x3c0
> > [  243.221726][  T115]  worker_thread+0x234/0x3b8
> > [  243.222176][  T115]  kthread+0xf0/0x108
> > [  243.222564][  T115]  ret_from_fork+0x10/0x20
> > ...
> > [  243.254080][  T115] INFO: task kworker/0:2:194 blocked for more
> > than 122 seconds. [  243.254834][  T115]       Not tainted 6.6.0+ #1
> > [  243.255529][  T115] "echo 0
> > > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > [  243.256378][  T115] task:kworker/0:2     state:D stack:0
> > > pid:194   ppid:2      flags:0x00000008
> > [  243.257284][  T115] Workqueue: events work_for_cpu_fn
> > [  243.257793][  T115] Call trace:
> > [  243.258111][  T115]  __switch_to+0x130/0x1e8
> > [  243.258541][  T115]  __schedule+0x660/0xcf8
> > [  243.258971][  T115]  schedule+0x58/0xf0
> > [  243.259360][  T115]  schedule_timeout+0x280/0x2f0
> > [  243.259832][  T115]  wait_for_common+0xcc/0x2d8
> > [  243.260287][  T115]  wait_for_completion+0x20/0x38
> > [  243.260767][  T115]  cpuhp_kick_ap+0xe8/0x278
> > [  243.261207][  T115]  cpuhp_kick_ap_work+0x5c/0x188
> > [  243.261688][  T115]  _cpu_down+0x120/0x378
> > [  243.262103][  T115]  __cpu_down_maps_locked+0x20/0x38
> > [  243.262609][  T115]  work_for_cpu_fn+0x24/0x40
> > [  243.263059][  T115]  process_one_work+0x170/0x3c0
> > [  243.263533][  T115]  worker_thread+0x234/0x3b8
> > [  243.263981][  T115]  kthread+0xf0/0x108
> > [  243.264405][  T115]  ret_from_fork+0x10/0x20
> > [  243.264846][  T115] INFO: task kworker/15:2:639 blocked for more
> > than 122 seconds. [  243.265602][  T115]       Not tainted 6.6.0+ #1
> > [  243.266296][  T115] "echo 0
> > > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > [  243.267143][  T115] task:kworker/15:2    state:D stack:0
> > > pid:639   ppid:2      flags:0x00000008
> > [  243.268044][  T115] Workqueue: events_freezable_power_
> > disk_events_workfn [  243.268727][  T115] Call trace:
> > [  243.269051][  T115]  __switch_to+0x130/0x1e8
> > [  243.269481][  T115]  __schedule+0x660/0xcf8
> > [  243.269903][  T115]  schedule+0x58/0xf0
> > [  243.270293][  T115]  schedule_timeout+0x280/0x2f0
> > [  243.270763][  T115]  io_schedule_timeout+0x50/0x70
> > [  243.271245][  T115]  wait_for_common_io.constprop.0+0xb0/0x298
> > [  243.271830][  T115]  wait_for_completion_io+0x1c/0x30
> > [  243.272335][  T115]  blk_execute_rq+0x1d8/0x278
> > [  243.272793][  T115]  scsi_execute_cmd+0x114/0x238
> > [  243.273267][  T115]  sr_check_events+0xc8/0x310 [sr_mod]
> > [  243.273808][  T115]  cdrom_check_events+0x2c/0x50 [cdrom]
> > [  243.274408][  T115]  sr_block_check_events+0x34/0x48 [sr_mod]
> > [  243.274994][  T115]  disk_check_events+0x44/0x1b0
> > [  243.275468][  T115]  disk_events_workfn+0x20/0x38
> > [  243.275939][  T115]  process_one_work+0x170/0x3c0
> > [  243.276410][  T115]  worker_thread+0x234/0x3b8
> > [  243.276855][  T115]  kthread+0xf0/0x108
> > [  243.277241][  T115]  ret_from_fork+0x10/0x20  
> 
> Question is why this scsi command can't be completed?
> 
> When blk_mq_hctx_notify_offline() is called, the CPU isn't shutdown
> yet, and it still can handle interrupt of this SCSI command.
> 
> 
> Thanks,
> Ming
> 
> 
Sorry, at the moment I don't know why it can't be finished,
just provides a solution like loop and dm-rq.

Currently see the call stack:
 => blk_mq_run_hw_queue
 =>__blk_mq_sched_restart
 => blk_mq_run_hw_queue
 => __blk_mq_sched_restart
 => __blk_mq_free_request
 => blk_mq_free_request
 => blk_mq_end_request
 => blk_flush_complete_seq
 => flush_end_io
 => __blk_mq_end_request
 => scsi_end_request
 => scsi_io_completion
 => scsi_finish_command
 => scsi_complete
 => blk_mq_complete_request
 => scsi_done_internal
 => scsi_done
 => virtscsi_complete_cmd
 => virtscsi_req_done
 => vring_interrupt

In finction blk_mq_run_hw_queue():
__blk_mq_run_dispatch_ops(hctx->queue, false,
	need_run = !blk_queue_quiesced(hctx->queue) &&
	blk_mq_hctx_has_pending(hctx));
	
	if (!need_run)
		return;

Come here and return directly.
