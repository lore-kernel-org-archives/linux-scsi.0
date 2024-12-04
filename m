Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3296618C03B;
	Wed,  4 Dec 2024 08:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733302052; cv=none; b=QuqvuCa4g1rshPG8AuDhXuKIiYqQVi04oKAmHMvAMJzbG/iImMFcLcitjAp32qyIdOaiM+kXuldlDtDcA5493KXq3t6ff0s2TuDJfw+3Sp6X0k0kpKmwHXCBEKg45DO/G8Wn/U4cPcwI3Pgtn9sc6p1AZhHKqnANXdWSoexhBSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733302052; c=relaxed/simple;
	bh=CAFn4fd2U3fsiB9VE5w54f5xh/VK8ZR7jpJcAOfwqGg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fjlfhkzyhJZ4u8pZQ1x06b+DXrtRGBx9ZEsCmmen06lbezOjV42/ljAuBQPbBkwKQqHcsQeF3R+qLHHioCgBnu+Jm/oYtOgSju8hGxpAcRgcj4cVl6HW6CkFj2+++iEr8YdRILP60XZxez1SKehXuGuAgHqqs7sDRdcRQIKmWvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ISF0cGDM; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ISF0cGDM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1733301999;
	bh=Mx12XwvRAqwi0P5h+aFKem3xs+irSNK8VpS/vMqko+A=;
	h=Date:From:To:Subject:Message-ID:MIME-Version;
	b=ISF0cGDMGKcCVJ37zmyQug4wOI3f78V5dd5WiwAG5APMsq+SbsCwL5HUOWfJRlsTL
	 Ll1z0sM4+sFPC9LklkGGAdvfuYIpqDkSbQtKW1Va/vd3TeGhNMqtb0lj35ZLxsKrnV
	 9nfKETY4bZrm9iRxlBmL2ldWusqG7HesKKB9boYc=
X-QQ-mid: bizesmtpip3t1733301992t6elari
X-QQ-Originating-IP: VkVuchRyXJs5lvlDWvkHZL+dLHV6ZXRiZp8xtk+Ark4=
Received: from john-PC ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 04 Dec 2024 16:46:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14544012370194691012
Date: Wed, 4 Dec 2024 16:45:57 +0800
From: Qiang Ma <maqianga@uniontech.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 axboe@kernel.dk, dwagner@suse.de, hare@suse.de, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Don't wait for completion of in-flight requests
Message-ID: <BA66D0A31F3EBFD9+20241204164557.0296e677@john-PC>
In-Reply-To: <Z08Xf_ZuMFWfP0jd@fedora>
References: <20241126115008.31272-1-maqianga@uniontech.com>
	<Z0XX5ts2yTO7Frl8@fedora>
	<2100C70C0D4CA64E+20241127220437.65ae99dd@john-PC>
	<Z0c4vPLnwicI6T9J@fedora>
	<F991D40F7D096653+20241203211857.0291ab1b@john-PC>
	<Z08Xf_ZuMFWfP0jd@fedora>
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
X-QQ-XMAILINFO: MYfgaE2Hdx7ceHMP0eaXXTJLC6b4lBSXK7GCv2cr6r68zhYutlF6RPRH
	u49B8QLmY/yrrbBTpMA8gzA7iq/1yl8VXm4d48c46LUt34cBVL1PDkU14aJD2rRyNZiBIme
	Te5WYXXkZOjzPcpriB/9C68VnUYbwjazMEvjZii3bf/witpXHJ+KbJSVea0QwTrA9c0lmNm
	a1d+ySF1JF37lZUsJuYXV7hsMtSR/o05oCLzKEnCcbnZ/l6+/JXdnxWbIKmZURx/vbn88jq
	/IIUzrnHyBhiCrQQQzapK4eTD2+NI/O9en44ocoAEpy+QWBnM7CBwjxtMhHuWeyGXqiZOaP
	sv6L9RM9/AgUYaWs4GXMo9yb5ASc9OXcPIlxFeExo8yY9vrnk5/NoJKp3SWSQv5ZMBmqGP0
	+SyG5lx5kC4aEMYa7ZqNwESaD1wl2QB7s0DpqihfBxXQL32T0R0s8Ag3TDtrzri685UeIcW
	6rguRKra19cU3f8gLyB535exIpW09zNf/F+KxWBrnL7ShZVyWkeo1UgPuSkIycHyWYcbjSp
	CTrD+60xihtHi1e+m+mJKRajGrHcRvcqlhif4eRN8PPE4QYCa/gBlVxf+bpV1XLUR9yLg2q
	CGwTjr3abGkhj8cFPevh52ot+6QynlKS57tru9cq1IJU6lQ3K7O9yYc2vxISSbZpqt9WnfV
	nNHq3TTjQv54dcsW+O7nn8p+erNveVoM2kCxXYFEK0jiVXrXvYF6kRE070ZYLemsKXQcMKD
	LdLEAS/7sTAOdGqu3oAaYR4LpRhaFzWOjd3C4NyS/r4SAMG6Nw4u78WiV+fGmmqWL8Af0+F
	xakUvcEnbL+KmAHvcDi71JPtSOvTqXIFmOj7AGve8LoADa3EcyFZUU7wXKKnRSoOFyZlH4J
	dJ5pUFGwMFePeKXWQnisYp36HsDjBAPVGbxF3Rl1jDAWX+rkGPE1wjZYbAO5lNJ/29v+CuK
	AwkNN4FI8jwUkVw==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

On Tue, 3 Dec 2024 22:36:47 +0800
Ming Lei <ming.lei@redhat.com> wrote:

> On Tue, Dec 03, 2024 at 09:21:04PM +0800, Qiang Ma wrote:
> > On Wed, 27 Nov 2024 23:20:28 +0800
> > Ming Lei <ming.lei@redhat.com> wrote:
> >   
> > > On Wed, Nov 27, 2024 at 10:04:37PM +0800, Qiang Ma wrote:  
> > > > On Tue, 26 Nov 2024 22:15:02 +0800
> > > > Ming Lei <ming.lei@redhat.com> wrote:
> > > >     
> > > > > On Tue, Nov 26, 2024 at 07:50:08PM +0800, Qiang Ma wrote:    
> > > > > > Problem:
> > > > > > When the system disk uses the scsi disk bus, The main
> > > > > > qemu command line includes:
> > > > > > ...
> > > > > > -device virtio-scsi-pci,id=scsi0 \
> > > > > > -device scsi-hd,scsi-id=1,drive=drive-virtio-disk
> > > > > > -drive
> > > > > > id=drive-virtio-disk,if=none,file=/home/kvm/test.qcow2 ...
> > > > > > 
> > > > > > The dmesg log is as follows::
> > > > > > 
> > > > > > [   50.304591][ T4382] sd 0:0:0:0: [sda] Synchronizing SCSI
> > > > > > cache [   50.377002][ T4382] kexec_core: Starting new
> > > > > > kernel    
> > > 
> > > Why is one new kernel started? what event triggers kernel_kexec()?
> > > 
> > > machine_shutdown() follows, probably the scsi controller is dead.
> > >   
> > 
> > Yes, triggered by kexec, manually execute the following command:
> > kexec -l /boot/vmlinuz-6.6.0+ --reuse-cmdline
> > --initrd=/boot/initramfs-6.6.0+.img kexec -e
> >   
> > > > > > [   50.669775][  T194] psci: CPU1 killed (polled 0 ms)
> > > > > > [   50.849665][  T194] psci: CPU2 killed (polled 0 ms)
> > > > > > [   51.109625][  T194] psci: CPU3 killed (polled 0 ms)
> > > > > > [   51.319594][  T194] psci: CPU4 killed (polled 0 ms)
> > > > > > [   51.489667][  T194] psci: CPU5 killed (polled 0 ms)
> > > > > > [   51.709582][  T194] psci: CPU6 killed (polled 0 ms)
> > > > > > [   51.949508][   T10] psci: CPU7 killed (polled 0 ms)
> > > > > > [   52.139499][   T10] psci: CPU8 killed (polled 0 ms)
> > > > > > [   52.289426][   T10] psci: CPU9 killed (polled 0 ms)
> > > > > > [   52.439552][   T10] psci: CPU10 killed (polled 0 ms)
> > > > > > [   52.579525][   T10] psci: CPU11 killed (polled 0 ms)
> > > > > > [   52.709501][   T10] psci: CPU12 killed (polled 0 ms)
> > > > > > [   52.819509][  T194] psci: CPU13 killed (polled 0 ms)
> > > > > > [   52.919509][  T194] psci: CPU14 killed (polled 0 ms)
> > > > > > [  243.214009][  T115] INFO: task kworker/0:1:10 blocked for
> > > > > > more than 122 seconds. [  243.214810][  T115]       Not
> > > > > > tainted 6.6.0+ #1 [  243.215517][  T115] "echo 0    
> > > > > > > /proc/sys/kernel/hung_task_timeout_secs" disables this
> > > > > > > message. [  243.216390][  T115] task:kworker/0:1
> > > > > > > state:D stack:0 pid:10    ppid:2      flags:0x00000008    
> > > > > > [  243.217299][  T115] Workqueue: events vmstat_shepherd
> > > > > > [  243.217816][  T115] Call trace:
> > > > > > [  243.218133][  T115]  __switch_to+0x130/0x1e8
> > > > > > [  243.218568][  T115]  __schedule+0x660/0xcf8
> > > > > > [  243.219013][  T115]  schedule+0x58/0xf0
> > > > > > [  243.219402][  T115]  percpu_rwsem_wait+0xb0/0x1d0
> > > > > > [  243.219880][  T115]  __percpu_down_read+0x40/0xe0
> > > > > > [  243.220353][  T115]  cpus_read_lock+0x5c/0x70
> > > > > > [  243.220795][  T115]  vmstat_shepherd+0x40/0x140
> > > > > > [  243.221250][  T115]  process_one_work+0x170/0x3c0
> > > > > > [  243.221726][  T115]  worker_thread+0x234/0x3b8
> > > > > > [  243.222176][  T115]  kthread+0xf0/0x108
> > > > > > [  243.222564][  T115]  ret_from_fork+0x10/0x20
> > > > > > ...
> > > > > > [  243.254080][  T115] INFO: task kworker/0:2:194 blocked
> > > > > > for more than 122 seconds. [  243.254834][  T115]       Not
> > > > > > tainted 6.6.0+ #1 [  243.255529][  T115] "echo 0    
> > > > > > > /proc/sys/kernel/hung_task_timeout_secs" disables this
> > > > > > > message. [  243.256378][  T115] task:kworker/0:2
> > > > > > > state:D stack:0 pid:194   ppid:2      flags:0x00000008    
> > > > > > [  243.257284][  T115] Workqueue: events work_for_cpu_fn
> > > > > > [  243.257793][  T115] Call trace:
> > > > > > [  243.258111][  T115]  __switch_to+0x130/0x1e8
> > > > > > [  243.258541][  T115]  __schedule+0x660/0xcf8
> > > > > > [  243.258971][  T115]  schedule+0x58/0xf0
> > > > > > [  243.259360][  T115]  schedule_timeout+0x280/0x2f0
> > > > > > [  243.259832][  T115]  wait_for_common+0xcc/0x2d8
> > > > > > [  243.260287][  T115]  wait_for_completion+0x20/0x38
> > > > > > [  243.260767][  T115]  cpuhp_kick_ap+0xe8/0x278
> > > > > > [  243.261207][  T115]  cpuhp_kick_ap_work+0x5c/0x188
> > > > > > [  243.261688][  T115]  _cpu_down+0x120/0x378
> > > > > > [  243.262103][  T115]  __cpu_down_maps_locked+0x20/0x38
> > > > > > [  243.262609][  T115]  work_for_cpu_fn+0x24/0x40
> > > > > > [  243.263059][  T115]  process_one_work+0x170/0x3c0
> > > > > > [  243.263533][  T115]  worker_thread+0x234/0x3b8
> > > > > > [  243.263981][  T115]  kthread+0xf0/0x108
> > > > > > [  243.264405][  T115]  ret_from_fork+0x10/0x20
> > > > > > [  243.264846][  T115] INFO: task kworker/15:2:639 blocked
> > > > > > for more than 122 seconds. [  243.265602][  T115]       Not
> > > > > > tainted 6.6.0+ #1 [  243.266296][  T115] "echo 0    
> > > > > > > /proc/sys/kernel/hung_task_timeout_secs" disables this
> > > > > > > message. [  243.267143][  T115] task:kworker/15:2
> > > > > > > state:D stack:0 pid:639   ppid:2      flags:0x00000008    
> > > > > > [  243.268044][  T115] Workqueue: events_freezable_power_
> > > > > > disk_events_workfn [  243.268727][  T115] Call trace:
> > > > > > [  243.269051][  T115]  __switch_to+0x130/0x1e8
> > > > > > [  243.269481][  T115]  __schedule+0x660/0xcf8
> > > > > > [  243.269903][  T115]  schedule+0x58/0xf0
> > > > > > [  243.270293][  T115]  schedule_timeout+0x280/0x2f0
> > > > > > [  243.270763][  T115]  io_schedule_timeout+0x50/0x70
> > > > > > [  243.271245][  T115]
> > > > > > wait_for_common_io.constprop.0+0xb0/0x298
> > > > > > [  243.271830][  T115]  wait_for_completion_io+0x1c/0x30
> > > > > > [  243.272335][  T115]  blk_execute_rq+0x1d8/0x278
> > > > > > [  243.272793][  T115]  scsi_execute_cmd+0x114/0x238
> > > > > > [  243.273267][  T115]  sr_check_events+0xc8/0x310 [sr_mod]
> > > > > > [  243.273808][  T115]  cdrom_check_events+0x2c/0x50 [cdrom]
> > > > > > [  243.274408][  T115]  sr_block_check_events+0x34/0x48
> > > > > > [sr_mod] [  243.274994][  T115]
> > > > > > disk_check_events+0x44/0x1b0 [  243.275468][  T115]
> > > > > > disk_events_workfn+0x20/0x38 [  243.275939][  T115]
> > > > > > process_one_work+0x170/0x3c0 [  243.276410][  T115]
> > > > > > worker_thread+0x234/0x3b8 [  243.276855][  T115]
> > > > > > kthread+0xf0/0x108 [  243.277241][  T115]
> > > > > > ret_from_fork+0x10/0x20      
> > > > > 
> > > > > Question is why this scsi command can't be completed?
> > > > > 
> > > > > When blk_mq_hctx_notify_offline() is called, the CPU isn't
> > > > > shutdown yet, and it still can handle interrupt of this SCSI
> > > > > command.
> > > > > 
> > > > > 
> > > > > Thanks,
> > > > > Ming
> > > > > 
> > > > >     
> > > > Sorry, at the moment I don't know why it can't be finished,
> > > > just provides a solution like loop and dm-rq.
> > > > 
> > > > Currently see the call stack:    
> > > >  => blk_mq_run_hw_queue
> > > >  =>__blk_mq_sched_restart
> > > >  => blk_mq_run_hw_queue
> > > >  => __blk_mq_sched_restart
> > > >  => __blk_mq_free_request
> > > >  => blk_mq_free_request
> > > >  => blk_mq_end_request
> > > >  => blk_flush_complete_seq
> > > >  => flush_end_io
> > > >  => __blk_mq_end_request
> > > >  => scsi_end_request
> > > >  => scsi_io_completion
> > > >  => scsi_finish_command
> > > >  => scsi_complete
> > > >  => blk_mq_complete_request
> > > >  => scsi_done_internal
> > > >  => scsi_done
> > > >  => virtscsi_complete_cmd
> > > >  => virtscsi_req_done
> > > >  => vring_interrupt    
> > > > 
> > > > In finction blk_mq_run_hw_queue():
> > > > __blk_mq_run_dispatch_ops(hctx->queue, false,
> > > > 	need_run = !blk_queue_quiesced(hctx->queue) &&
> > > > 	blk_mq_hctx_has_pending(hctx));
> > > > 	
> > > > 	if (!need_run)
> > > > 		return;
> > > > 
> > > > Come here and return directly.    
> > > 
> > > Does blk_queue_quiesced() return true?
> > >   
> > 
> > blk_queue_quiesced() return false
> > 
> > Sorry, the calltrace above is not the one that is stuck this time.
> > The hang is caused by the wait_for_completion_io(), in
> > blk_execute_rq():
> > 
> > blk_status_t blk_execute_rq(struct request *rq, bool at_head)
> > {
> > 	...
> > 	rq->end_io_data = &wait;
> > 	rq->end_io = blk_end_sync_rq;
> > 	...
> > 	blk_account_io_start(rq);
> > 	blk_mq_insert_request(rq, at_head ? BLK_MQ_INSERT_AT_HEAD :
> > 0); blk_mq_run_hw_queue(hctx, false);
> > 
> > 	if (blk_rq_is_poll(rq)) {
> > 		blk_rq_poll_completion(rq, &wait.done);
> > 	} else {
> > 		...
> > 		wait_for_completion_io(&wait.done);
> > 	}
> > }
> > 
> > In this case, end_io is blk_end_sync_rq, which is not executed.
> > 
> > The process for sending scsi commands is as follows:
> > 
> >      kworker/7:1-134     [007] .....    32.772727: vp_notify
> >      <-virtqueue_notify kworker/7:1-134     [007] .....
> > 32.772729: <stack trace> => vp_notify  
> >  => virtqueue_notify
> >  => virtscsi_add_cmd
> >  => virtscsi_queuecommand
> >  => scsi_dispatch_cmd
> >  => scsi_queue_rq
> >  => blk_mq_dispatch_rq_list
> >  => __blk_mq_sched_dispatch_requests
> >  => blk_mq_sched_dispatch_requests
> >  => blk_mq_run_hw_queue
> >  => blk_execute_rq
> >  => scsi_execute_cmd
> >  => sr_check_events
> >  => cdrom_check_events
> >  => sr_block_check_events
> >  => disk_check_events
> >  => disk_events_workfn
> >  => process_one_work
> >  => worker_thread
> >  => kthread
> >  => ret_from_fork  
> > 
> > In qemu:
> > static void virtio_scsi_handle_cmd_vq(VirtIOSCSI *s, VirtQueue *vq)
> > {
> > 	...
> > 	do {
> >         	if (suppress_notifications) {
> > 			virtio_queue_set_notification(vq, 0);
> > 		}
> > 		...
> > 	} while (ret != -EINVAL && !virtio_queue_empty(vq));
> > 	...
> > 	QTAILQ_FOREACH_SAFE(req, &reqs, next, next) {
> > 		virtio_scsi_handle_cmd_req_submit(s, req);
> > 	}
> > }
> > 
> > virtio_queue_empty() always return true.
> > 
> > As a result, the virtio_scsi_handle_cmd_req_submit() was not
> > executed, and the io command was never submitted.
> > 
> > The reason is that virtio_device_disabled returns true in
> > virtio_queue_split_empty, the code is as follows:
> > 
> > int virtio_queue_empty(VirtQueue *vq)
> > {   
> > 	if (virtio_vdev_has_feature(vq->vdev,
> > VIRTIO_F_RING_PACKED)) { return virtio_queue_packed_empty(vq);
> > 	} else {
> > 		return virtio_queue_split_empty(vq);
> > 	}
> > }
> > 
> > static int virtio_queue_split_empty(VirtQueue *vq)
> > {
> > 	bool empty;
> >             
> > 	if (virtio_device_disabled(vq->vdev)) {
> > 		return 1;
> > 	...
> > }
> > 
> > This function was introduced in the following patch:
> > 
> > commit 9d7bd0826f2d19f88631ad7078662668148f7b5f
> > Author: Michael Roth <mdroth@linux.vnet.ibm.com>
> > Date:   Tue Nov 19 18:50:03 2019 -0600
> > 
> >     virtio-pci: disable vring processing when bus-mastering is
> > disabled  
> 
> OK, then it is obviously one qemu issue, and it can explain why IO
> isn't completed in this case.
> 
> 

However, in fact, the current pci-master state is disabled, it is
shutdown by executing the syscore_shutdown() in kernel_kexec(), and the
call stack is as follows:
kernel_kexec
=> syscore_shutdown
=> ops->shutdown
=> pci_device_shutdown
=> pci_clear_master
=> __pci_set_master

Therefore, qemu determines the pci-master status and disable
virtio-pci when tthe state of the pci-master is disabled.

static void virtio_write_config(PCIDevice *pci_dev, uint32_t address,
                                uint32_t val, int len)
{
	...

	if (!(pci_dev->config[PCI_COMMAND] & PCI_COMMAND_MASTER)) {
		virtio_set_disabled(vdev, true);
		virtio_pci_stop_ioeventfd(proxy);
		virtio_set_status(vdev,
	vdev->status&~VIRTIO_CONFIG_S_DRIVER_OK);
	} else {
		virtio_set_disabled(vdev, false);
	}
	...
}

After opening pci_dbg of initcall_debug and pci.c,
the kernel log is as follows:

[root@localhost ~]# [   41.490716][ T8227] platform
regulatory.0: shutdown [   41.491726][ T8227] sd 0:0:0:0: shutdown
[   41.492471][ T8227] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   41.496945][ T8227] snd_aloop snd_aloop.0: shutdown
[   41.497885][ T8227] platform smccc_trng: shutdown
[   41.498797][ T8227] platform platform-framebuffer.0: shutdown
[   41.499874][ T8227] alarmtimer alarmtimer.0.auto: shutdown
[   41.500905][ T8227] usb usb2-port15: shutdown 
[   41.501713][ T8227] usb usb2-port14: shutdown 
[   41.502527][ T8227] usb usb2-port13: shutdown 
[   41.503367][ T8227] usb usb2-port12: shutdown
[   41.504188][ T8227] usb usb2-port11: shutdown
[   41.505002][ T8227] usb usb2-port10: shutdown
[   41.505816][ T8227] usb usb2-port9: shutdown
[   41.506615][ T8227] usb usb2-port8: shutdown
[   41.507409][ T8227] usb usb2-port7: shutdown
[   41.508205][ T8227] usb usb2-port6: shutdown
[   41.509053][ T8227] usb usb2-port5: shutdown
[   41.509853][ T8227] usb usb2-port4: shutdown
[   41.510652][ T8227] usb usb2-port3: shutdown
[   41.511448][ T8227] usb usb2-port2: shutdown
[   41.512249][ T8227] usb usb2-port1: shutdown
[   41.513053][ T8227] usb usb1-port15: shutdown
[   41.513836][ T8227] usb usb1-port14: shutdown
[   41.514622][ T8227] usb usb1-port13: shutdown
[   41.515408][ T8227] usb usb1-port12: shutdown
[   41.516191][ T8227] usb usb1-port11: shutdown
[   41.516970][ T8227] usb usb1-port10: shutdown
[   41.517754][ T8227] usb usb1-port9: shutdown
[   41.518519][ T8227] usb usb1-port8: shutdown
[   41.519341][ T8227] usb usb1-port7: shutdown
[   41.520102][ T8227] usb usb1-port6: shutdown
[   41.520868][ T8227] usb usb1-port5: shutdown
[   41.521630][ T8227] usb usb1-port4: shutdown
[   41.522396][ T8227] usb usb1-port3: shutdown
[   41.523169][ T8227] usb usb1-port2: shutdown
[   41.523929][ T8227] usb usb1-port1: shutdown
[   41.524698][ T8227] platform Fixed MDIO bus.0: shutdown
[   41.525697][ T8227] kgdboc kgdboc: shutdown
[   41.526451][ T8227] serial8250 serial8250: shutdown
[   41.527335][ T8227] pciehp 0000:00:01.7:pcie004: shutdown
[   41.528295][ T8227] aer 0000:00:01.7:pcie002: shutdown
[   41.529274][ T8227] pcie_pme 0000:00:01.7:pcie001: shutdown
[   41.530278][ T8227] pciehp 0000:00:01.6:pcie004: shutdown
[   41.531243][ T8227] aer 0000:00:01.6:pcie002: shutdown
[   41.532161][ T8227] pcie_pme 0000:00:01.6:pcie001: shutdown
[   41.533164][ T8227] pciehp 0000:00:01.5:pcie004: shutdown
[   41.534132][ T8227] aer 0000:00:01.5:pcie002: shutdown
[   41.535052][ T8227] pcie_pme 0000:00:01.5:pcie001: shutdown
[   41.536051][ T8227] pciehp 0000:00:01.4:pcie004: shutdown
[   41.537011][ T8227] aer 0000:00:01.4:pcie002: shutdown
[   41.537928][ T8227] pcie_pme 0000:00:01.4:pcie001: shutdown
[   41.538971][ T8227] pciehp 0000:00:01.3:pcie004: shutdown
[   41.539939][ T8227] aer 0000:00:01.3:pcie002: shutdown
[   41.540855][ T8227] pcie_pme 0000:00:01.3:pcie001: shutdown
[   41.541847][ T8227] pciehp 0000:00:01.2:pcie004: shutdown
[   41.542823][ T8227] aer 0000:00:01.2:pcie002: shutdown
[   41.543743][ T8227] pcie_pme 0000:00:01.2:pcie001: shutdown
[   41.544742][ T8227] pciehp 0000:00:01.1:pcie004: shutdown
[   41.545705][ T8227] aer 0000:00:01.1:pcie002: shutdown
[   41.546625][ T8227] pcie_pme 0000:00:01.1:pcie001: shutdown
[   41.547616][ T8227] pciehp 0000:00:01.0:pcie004: shutdown
[   41.548579][ T8227] aer 0000:00:01.0:pcie002: shutdown
[   41.549571][ T8227] pcie_pme 0000:00:01.0:pcie001: shutdown
[   41.550645][ T8227] system 00:00: shutdown
[   41.551381][ T8227] platform efivars.0: shutdown
[   41.552208][ T8227] rtc-efi rtc-efi.0: shutdown
[   41.553029][ T8227] platform PNP0C0C:00: shutdown
[   41.553865][ T8227] acpi-ged ACPI0013:00: shutdown
[   41.554829][ T8227] ahci 0000:09:01.0: shutdown
[   41.555911][ T8227] ahci 0000:09:01.0: disabling bus mastering
[   41.557683][ T8227] shpchp 0000:08:00.0: shutdown
[   41.558555][ T8227] shpchp 0000:08:00.0: disabling bus mastering
[   41.560917][ T8227] xhci_hcd 0000:07:00.0: shutdown
[   41.563837][ T8227] virtio-pci 0000:06:00.0: shutdown
[   41.564769][ T8227] virtio-pci 0000:06:00.0: disabling bus mastering
[   41.566490][ T8227] virtio-pci 0000:05:00.0: shutdown
[   41.567436][ T8227] virtio-pci 0000:05:00.0: disabling bus mastering
[   41.569188][ T8227] virtio-pci 0000:04:00.0: shutdown
[   41.570126][ T8227] virtio-pci 0000:04:00.0: disabling bus mastering
[   41.571903][ T8227] virtio-pci 0000:03:00.0: shutdown
[   41.572856][ T8227] virtio-pci 0000:03:00.0: disabling bus mastering
[   41.576969][ T8227] virtio-pci 0000:02:00.0: shutdown
[   41.578341][ T8227] virtio-pci 0000:02:00.0: disabling bus mastering
[   41.902816][ T8227] virtio-pci 0000:01:00.0: shutdown
[   41.905600][ T8227] virtio-pci 0000:01:00.0: disabling bus mastering
[   41.942715][ T8227] pcieport 0000:00:01.7: shutdown
[   41.944723][ T8227] pcieport 0000:00:01.7: disabling bus mastering
[   41.946667][ T8227] pcieport 0000:00:01.6: shutdown
[   41.948481][ T8227] pcieport 0000:00:01.6: disabling bus mastering
[   41.950693][ T8227] pcieport 0000:00:01.5: shutdown
[   41.953068][ T8227] pcieport 0000:00:01.5: disabling bus mastering
[   41.955722][ T8227] pcieport 0000:00:01.4: shutdown
[   41.957888][ T8227] pcieport 0000:00:01.4: disabling bus mastering
[   41.960272][ T8227] pcieport 0000:00:01.3: shutdown
[   41.962422][ T8227] pcieport 0000:00:01.3: disabling bus mastering
[   41.964726][ T8227] pcieport 0000:00:01.2: shutdown
[   41.967348][ T8227] pcieport 0000:00:01.2: disabling bus mastering
[   41.969762][ T8227] pcieport 0000:00:01.1: shutdown
[   41.972004][ T8227] pcieport 0000:00:01.1: disabling bus mastering
[   41.974365][ T8227] pcieport 0000:00:01.0: shutdown
[   41.977924][ T8227] pcieport 0000:00:01.0: disabling bus mastering
[   41.979974][ T8227] pci 0000:00:00.0: shutdown
[   41.980836][ T8227] platform LNRO0005:1f: shutdown
[   41.981739][ T8227] platform LNRO0005:1e: shutdown
[   41.982654][ T8227] platform LNRO0005:1d: shutdown
[   41.983555][ T8227] platform LNRO0005:1c: shutdown
[   41.984454][ T8227] platform LNRO0005:1b: shutdown
[   41.985523][ T8227] platform LNRO0005:1a: shutdown
[   41.986416][ T8227] platform LNRO0005:19: shutdown
[   41.987310][ T8227] platform LNRO0005:18: shutdown
[   41.988205][ T8227] platform LNRO0005:17: shutdown
[   41.989159][ T8227] platform LNRO0005:16: shutdown
[   41.990059][ T8227] platform LNRO0005:15: shutdown
[   41.990956][ T8227] platform LNRO0005:14: shutdown
[   41.991848][ T8227] platform LNRO0005:13: shutdown
[   41.992753][ T8227] platform LNRO0005:12: shutdown
[   41.993638][ T8227] platform LNRO0005:11: shutdown
[   41.994517][ T8227] platform LNRO0005:10: shutdown
[   41.995396][ T8227] platform LNRO0005:0f: shutdown
[   41.996266][ T8227] platform LNRO0005:0e: shutdown
[   41.997135][ T8227] platform LNRO0005:0d: shutdown
[   41.998002][ T8227] platform LNRO0005:0c: shutdown
[   41.998901][ T8227] platform LNRO0005:0b: shutdown
[   41.999766][ T8227] platform LNRO0005:0a: shutdown
[   42.000629][ T8227] platform LNRO0005:09: shutdown
[   42.001490][ T8227] platform LNRO0005:08: shutdown
[   42.002351][ T8227] platform LNRO0005:07: shutdown
[   42.003224][ T8227] platform LNRO0005:06: shutdown
[   42.004087][ T8227] platform LNRO0005:05: shutdown
[   42.004950][ T8227] platform LNRO0005:04: shutdown
[   42.005812][ T8227] platform LNRO0005:03: shutdown
[   42.006675][ T8227] platform LNRO0005:02: shutdown
[   42.007537][ T8227] platform LNRO0005:01: shutdown
[   42.008401][ T8227] platform LNRO0005:00: shutdown
[   42.009320][ T8227] fw_cfg QEMU0002:00: shutdown
[   42.010159][ T8227] sbsa-uart ARMH0011:00: shutdown
[   42.011097][ T8227] reg-dummy reg-dummy: shutdown
[   42.012042][ T8227] kexec_core: Starting new kernel
[   42.252819][   T10] psci: CPU1 killed (polled 0 ms)
[   42.352823][  T304] psci: CPU2 killed (polled 0 ms)
[   42.442807][  T304] psci: CPU3 killed (polled 0 ms)
[   42.532842][  T304] psci: CPU4 killed (polled 0 ms)
[   42.652807][  T304] psci: CPU5 killed (polled 0 ms)
[   42.759163][  T304] psci: CPU6 killed (polled 0 ms)
[   42.839104][  T304] psci: CPU7 killed (polled 0 ms)

> 
> Thanks,
> Ming
> 
> 

