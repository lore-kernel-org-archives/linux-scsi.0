Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E9E1EF080;
	Tue,  3 Dec 2024 13:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733232128; cv=none; b=vFUrfW7aQgeRkLaTqo5t/LQdujwH8JZm7eoIMIrsdck/6FJIVqh5uzcSlc2MURNsG1XC3yBlPNsGXOVb+cPgFNiBtI9YeG54K1K4fHmHwhw9KbpdbPTA1FF4+js/PBjiFLaK0kjEOambfdGzqBwt97nwriKSK7zFPd10rmbgaZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733232128; c=relaxed/simple;
	bh=XM2Qs5TVTvF5KLbCiIfxoBDNY+HnAHHBk0Uu1C29jes=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SmdE0u18FsLwKbeiPgKig/oJA/Y/WEy5ocYkAqwSUzIYscqEfyLQHdXeiCc81S3xUUUW1H8hkV3R9vDB+/lwkkTKb2jNKUOhXtfZiXIEaM1AiT7yy0POnU8krh5eGNz6oaKuosgu7+VCNYD6d3BesAktHtri0Mc2BvkV4z7Wqoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=i6QV27cx; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="i6QV27cx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1733232074;
	bh=OZDtcsYK/4OHIGXsF+xDQ8aQrKNgOb4/eEDszbzsfXA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version;
	b=i6QV27cx/oy8KBr0lyxai90nAyml9Fo+rnCEGNjLbJQXLcriN6wBY1+MaxjMtLmAB
	 9YHMy1TKq9NFivjigXwGbggTbvebkJOXX+Tw/U3E4UVcfiaV8bKlakJE3hRya61Axm
	 fsLTiBlkTqgzr1XP38niV5j8/NhAXskfAeBJxSQk=
X-QQ-mid: bizesmtpip2t1733232066tz0rzuq
X-QQ-Originating-IP: YMnLzejeA0yt3dDOaMmJSPjvXwQGD45FbwaGTeqPPL4=
Received: from john-PC ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 03 Dec 2024 21:21:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10701980929126009326
Date: Tue, 3 Dec 2024 21:21:04 +0800
From: Qiang Ma <maqianga@uniontech.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 axboe@kernel.dk, dwagner@suse.de, hare@suse.de, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Don't wait for completion of in-flight requests
Message-ID: <F991D40F7D096653+20241203211857.0291ab1b@john-PC>
In-Reply-To: <Z0c4vPLnwicI6T9J@fedora>
References: <20241126115008.31272-1-maqianga@uniontech.com>
	<Z0XX5ts2yTO7Frl8@fedora>
	<2100C70C0D4CA64E+20241127220437.65ae99dd@john-PC>
	<Z0c4vPLnwicI6T9J@fedora>
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
X-QQ-XMAILINFO: NtjtdWiRcLBFRGxgk/qOWC04lgPf/8Z2VE3vJcW04103Nox5BxKZrCZ2
	G/sio4IURh+bGac+wlV7Vxb0EMcKhLyttgfUnclGmt1J9SXDCXnGi9M34eGcnZDgyafBUTI
	1zZ63UN3+XL15Bf/xjHq4MVboviU+XmeNzrVqGUP7mKRsHyUm6nBPqiiyvywpdUSJ7Mkc9p
	qVGNbaJWQQzr7jG5iocPh3w3rIh+bFOfboarNbEaGxBluXiMSxWnGqCIjnm1PdNiWrn3lm3
	BhrP57joivnAQQQFX+SFj9EtsSm70AP0jzw0PNDlc/mfePoThgEaXUknQzSWRONV6Ibheyb
	ad9k/ybaAJavxraZGQw6+6CE0+sZLKTx2wrjSOngKDSr0rVQp66trzTsreruoGb0PPw//Ll
	LFsDBhwJ3BeDc0Zri0+5HlIwW+JOrScPj9nFJqji6QEuxvjjaTFgY/dAZjaBeM1YCwWC8BI
	KwU0PBvhpAnxyIyq4p+fVgJCJNwH89uGS41sMQjpfnpDoWZNZySntvUXLlSGCijAPkoi87B
	+tGMPJJ6DWRK9m5PNz+EaWLVcamsktBiJo9b8gUsTl3n4H/wIMR7XI2E/TY11cJyFv7jC+H
	Z0HmIDNUPDjM+ooHmt/INqKomp7fJnLldjopQ0wjlzCcPifBTn6FXtNvfhl13pcLhWxKjbK
	ImoR9L6vt8oYPCfyAnGcAl9aNTSdxNhBcDKU3au8bBZDcyGXNgMnWFXhPsf3JDn8+bfoVnQ
	aiMG3tBbWdH+Z2S2e9HH6K/ywKCOvdc6pZtzOqRSyANtTIpWdCd+8klGvj78QcwFpdSd+v0
	v4NR3NzX/0MN4h5dr+64MBq/gPUA7TYPU2fbtR3lKUs9DsM6uwL51zQq38pg0aHVJlkqyCD
	JAdcJMZ3xAR4gpECsP8Ew9XdhAuDCcRAtjrPTU01cdIB4TTGkaEids5/oIIWVmzum627n77
	dB/s=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

On Wed, 27 Nov 2024 23:20:28 +0800
Ming Lei <ming.lei@redhat.com> wrote:

> On Wed, Nov 27, 2024 at 10:04:37PM +0800, Qiang Ma wrote:
> > On Tue, 26 Nov 2024 22:15:02 +0800
> > Ming Lei <ming.lei@redhat.com> wrote:
> >   
> > > On Tue, Nov 26, 2024 at 07:50:08PM +0800, Qiang Ma wrote:  
> > > > Problem:
> > > > When the system disk uses the scsi disk bus, The main
> > > > qemu command line includes:
> > > > ...
> > > > -device virtio-scsi-pci,id=scsi0 \
> > > > -device scsi-hd,scsi-id=1,drive=drive-virtio-disk
> > > > -drive id=drive-virtio-disk,if=none,file=/home/kvm/test.qcow2
> > > > ...
> > > > 
> > > > The dmesg log is as follows::
> > > > 
> > > > [   50.304591][ T4382] sd 0:0:0:0: [sda] Synchronizing SCSI
> > > > cache [   50.377002][ T4382] kexec_core: Starting new kernel  
> 
> Why is one new kernel started? what event triggers kernel_kexec()?
> 
> machine_shutdown() follows, probably the scsi controller is dead.
> 

Yes, triggered by kexec, manually execute the following command:
kexec -l /boot/vmlinuz-6.6.0+ --reuse-cmdline
--initrd=/boot/initramfs-6.6.0+.img kexec -e

> > > > [   50.669775][  T194] psci: CPU1 killed (polled 0 ms)
> > > > [   50.849665][  T194] psci: CPU2 killed (polled 0 ms)
> > > > [   51.109625][  T194] psci: CPU3 killed (polled 0 ms)
> > > > [   51.319594][  T194] psci: CPU4 killed (polled 0 ms)
> > > > [   51.489667][  T194] psci: CPU5 killed (polled 0 ms)
> > > > [   51.709582][  T194] psci: CPU6 killed (polled 0 ms)
> > > > [   51.949508][   T10] psci: CPU7 killed (polled 0 ms)
> > > > [   52.139499][   T10] psci: CPU8 killed (polled 0 ms)
> > > > [   52.289426][   T10] psci: CPU9 killed (polled 0 ms)
> > > > [   52.439552][   T10] psci: CPU10 killed (polled 0 ms)
> > > > [   52.579525][   T10] psci: CPU11 killed (polled 0 ms)
> > > > [   52.709501][   T10] psci: CPU12 killed (polled 0 ms)
> > > > [   52.819509][  T194] psci: CPU13 killed (polled 0 ms)
> > > > [   52.919509][  T194] psci: CPU14 killed (polled 0 ms)
> > > > [  243.214009][  T115] INFO: task kworker/0:1:10 blocked for
> > > > more than 122 seconds. [  243.214810][  T115]       Not tainted
> > > > 6.6.0+ #1 [  243.215517][  T115] "echo 0  
> > > > > /proc/sys/kernel/hung_task_timeout_secs" disables this
> > > > > message. [  243.216390][  T115] task:kworker/0:1     state:D
> > > > > stack:0 pid:10    ppid:2      flags:0x00000008  
> > > > [  243.217299][  T115] Workqueue: events vmstat_shepherd
> > > > [  243.217816][  T115] Call trace:
> > > > [  243.218133][  T115]  __switch_to+0x130/0x1e8
> > > > [  243.218568][  T115]  __schedule+0x660/0xcf8
> > > > [  243.219013][  T115]  schedule+0x58/0xf0
> > > > [  243.219402][  T115]  percpu_rwsem_wait+0xb0/0x1d0
> > > > [  243.219880][  T115]  __percpu_down_read+0x40/0xe0
> > > > [  243.220353][  T115]  cpus_read_lock+0x5c/0x70
> > > > [  243.220795][  T115]  vmstat_shepherd+0x40/0x140
> > > > [  243.221250][  T115]  process_one_work+0x170/0x3c0
> > > > [  243.221726][  T115]  worker_thread+0x234/0x3b8
> > > > [  243.222176][  T115]  kthread+0xf0/0x108
> > > > [  243.222564][  T115]  ret_from_fork+0x10/0x20
> > > > ...
> > > > [  243.254080][  T115] INFO: task kworker/0:2:194 blocked for
> > > > more than 122 seconds. [  243.254834][  T115]       Not tainted
> > > > 6.6.0+ #1 [  243.255529][  T115] "echo 0  
> > > > > /proc/sys/kernel/hung_task_timeout_secs" disables this
> > > > > message. [  243.256378][  T115] task:kworker/0:2     state:D
> > > > > stack:0 pid:194   ppid:2      flags:0x00000008  
> > > > [  243.257284][  T115] Workqueue: events work_for_cpu_fn
> > > > [  243.257793][  T115] Call trace:
> > > > [  243.258111][  T115]  __switch_to+0x130/0x1e8
> > > > [  243.258541][  T115]  __schedule+0x660/0xcf8
> > > > [  243.258971][  T115]  schedule+0x58/0xf0
> > > > [  243.259360][  T115]  schedule_timeout+0x280/0x2f0
> > > > [  243.259832][  T115]  wait_for_common+0xcc/0x2d8
> > > > [  243.260287][  T115]  wait_for_completion+0x20/0x38
> > > > [  243.260767][  T115]  cpuhp_kick_ap+0xe8/0x278
> > > > [  243.261207][  T115]  cpuhp_kick_ap_work+0x5c/0x188
> > > > [  243.261688][  T115]  _cpu_down+0x120/0x378
> > > > [  243.262103][  T115]  __cpu_down_maps_locked+0x20/0x38
> > > > [  243.262609][  T115]  work_for_cpu_fn+0x24/0x40
> > > > [  243.263059][  T115]  process_one_work+0x170/0x3c0
> > > > [  243.263533][  T115]  worker_thread+0x234/0x3b8
> > > > [  243.263981][  T115]  kthread+0xf0/0x108
> > > > [  243.264405][  T115]  ret_from_fork+0x10/0x20
> > > > [  243.264846][  T115] INFO: task kworker/15:2:639 blocked for
> > > > more than 122 seconds. [  243.265602][  T115]       Not tainted
> > > > 6.6.0+ #1 [  243.266296][  T115] "echo 0  
> > > > > /proc/sys/kernel/hung_task_timeout_secs" disables this
> > > > > message. [  243.267143][  T115] task:kworker/15:2    state:D
> > > > > stack:0 pid:639   ppid:2      flags:0x00000008  
> > > > [  243.268044][  T115] Workqueue: events_freezable_power_
> > > > disk_events_workfn [  243.268727][  T115] Call trace:
> > > > [  243.269051][  T115]  __switch_to+0x130/0x1e8
> > > > [  243.269481][  T115]  __schedule+0x660/0xcf8
> > > > [  243.269903][  T115]  schedule+0x58/0xf0
> > > > [  243.270293][  T115]  schedule_timeout+0x280/0x2f0
> > > > [  243.270763][  T115]  io_schedule_timeout+0x50/0x70
> > > > [  243.271245][  T115]
> > > > wait_for_common_io.constprop.0+0xb0/0x298
> > > > [  243.271830][  T115]  wait_for_completion_io+0x1c/0x30
> > > > [  243.272335][  T115]  blk_execute_rq+0x1d8/0x278
> > > > [  243.272793][  T115]  scsi_execute_cmd+0x114/0x238
> > > > [  243.273267][  T115]  sr_check_events+0xc8/0x310 [sr_mod]
> > > > [  243.273808][  T115]  cdrom_check_events+0x2c/0x50 [cdrom]
> > > > [  243.274408][  T115]  sr_block_check_events+0x34/0x48
> > > > [sr_mod] [  243.274994][  T115]  disk_check_events+0x44/0x1b0
> > > > [  243.275468][  T115]  disk_events_workfn+0x20/0x38
> > > > [  243.275939][  T115]  process_one_work+0x170/0x3c0
> > > > [  243.276410][  T115]  worker_thread+0x234/0x3b8
> > > > [  243.276855][  T115]  kthread+0xf0/0x108
> > > > [  243.277241][  T115]  ret_from_fork+0x10/0x20    
> > > 
> > > Question is why this scsi command can't be completed?
> > > 
> > > When blk_mq_hctx_notify_offline() is called, the CPU isn't
> > > shutdown yet, and it still can handle interrupt of this SCSI
> > > command.
> > > 
> > > 
> > > Thanks,
> > > Ming
> > > 
> > >   
> > Sorry, at the moment I don't know why it can't be finished,
> > just provides a solution like loop and dm-rq.
> > 
> > Currently see the call stack:  
> >  => blk_mq_run_hw_queue
> >  =>__blk_mq_sched_restart
> >  => blk_mq_run_hw_queue
> >  => __blk_mq_sched_restart
> >  => __blk_mq_free_request
> >  => blk_mq_free_request
> >  => blk_mq_end_request
> >  => blk_flush_complete_seq
> >  => flush_end_io
> >  => __blk_mq_end_request
> >  => scsi_end_request
> >  => scsi_io_completion
> >  => scsi_finish_command
> >  => scsi_complete
> >  => blk_mq_complete_request
> >  => scsi_done_internal
> >  => scsi_done
> >  => virtscsi_complete_cmd
> >  => virtscsi_req_done
> >  => vring_interrupt  
> > 
> > In finction blk_mq_run_hw_queue():
> > __blk_mq_run_dispatch_ops(hctx->queue, false,
> > 	need_run = !blk_queue_quiesced(hctx->queue) &&
> > 	blk_mq_hctx_has_pending(hctx));
> > 	
> > 	if (!need_run)
> > 		return;
> > 
> > Come here and return directly.  
> 
> Does blk_queue_quiesced() return true?
> 

blk_queue_quiesced() return false

Sorry, the calltrace above is not the one that is stuck this time.
The hang is caused by the wait_for_completion_io(), in blk_execute_rq():

blk_status_t blk_execute_rq(struct request *rq, bool at_head)
{
	...
	rq->end_io_data = &wait;
	rq->end_io = blk_end_sync_rq;
	...
	blk_account_io_start(rq);
	blk_mq_insert_request(rq, at_head ? BLK_MQ_INSERT_AT_HEAD : 0);
	blk_mq_run_hw_queue(hctx, false);

	if (blk_rq_is_poll(rq)) {
		blk_rq_poll_completion(rq, &wait.done);
	} else {
		...
		wait_for_completion_io(&wait.done);
	}
}

In this case, end_io is blk_end_sync_rq, which is not executed.

The process for sending scsi commands is as follows:

     kworker/7:1-134     [007] .....    32.772727: vp_notify
     <-virtqueue_notify kworker/7:1-134     [007] .....    32.772729:
     <stack trace> => vp_notify
 => virtqueue_notify
 => virtscsi_add_cmd
 => virtscsi_queuecommand
 => scsi_dispatch_cmd
 => scsi_queue_rq
 => blk_mq_dispatch_rq_list
 => __blk_mq_sched_dispatch_requests
 => blk_mq_sched_dispatch_requests
 => blk_mq_run_hw_queue
 => blk_execute_rq
 => scsi_execute_cmd
 => sr_check_events
 => cdrom_check_events
 => sr_block_check_events
 => disk_check_events
 => disk_events_workfn
 => process_one_work
 => worker_thread
 => kthread
 => ret_from_fork

In qemu:
static void virtio_scsi_handle_cmd_vq(VirtIOSCSI *s, VirtQueue *vq)
{
	...
	do {
        	if (suppress_notifications) {
			virtio_queue_set_notification(vq, 0);
		}
		...
	} while (ret != -EINVAL && !virtio_queue_empty(vq));
	...
	QTAILQ_FOREACH_SAFE(req, &reqs, next, next) {
		virtio_scsi_handle_cmd_req_submit(s, req);
	}
}

virtio_queue_empty() always return true.

As a result, the virtio_scsi_handle_cmd_req_submit() was not
executed, and the io command was never submitted.

The reason is that virtio_device_disabled returns true in
virtio_queue_split_empty, the code is as follows:

int virtio_queue_empty(VirtQueue *vq)
{   
	if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
		return virtio_queue_packed_empty(vq);
	} else {
		return virtio_queue_split_empty(vq);
	}
}

static int virtio_queue_split_empty(VirtQueue *vq)
{
	bool empty;
            
	if (virtio_device_disabled(vq->vdev)) {
		return 1;
	...
}

This function was introduced in the following patch:

commit 9d7bd0826f2d19f88631ad7078662668148f7b5f
Author: Michael Roth <mdroth@linux.vnet.ibm.com>
Date:   Tue Nov 19 18:50:03 2019 -0600

    virtio-pci: disable vring processing when bus-mastering is disabled
    
    Currently the SLOF firmware for pseries guests will
    disable/re-enable a PCI device multiple times via IO/MEM/MASTER
    bits of PCI_COMMAND register after the initial probe/feature
    negotiation, as it tends to work with a single device at a time at
    various stages like probing and running block/network bootloaders
    without doing a full reset in-between.
    
    In QEMU, when PCI_COMMAND_MASTER is disabled we disable the
    corresponding IOMMU memory region, so DMA accesses (including to
    vring fields like idx/flags) will no longer undergo the necessary
    translation. Normally we wouldn't expect this to happen since it
    would be misbehavior on the driver side to continue driving DMA
    requests. 
    However, in the case of pseries, with iommu_platform=on, we trigger
    the following sequence when tearing down the virtio-blk dataplane
    ioeventfd in response to the guest unsetting PCI_COMMAND_MASTER:
    
      #2  0x0000555555922651 in virtqueue_map_desc
    (vdev=vdev@entry=0x555556dbcfb0,
    p_num_sg=p_num_sg@entry=0x7fffe657e1a8,
    addr=addr@entry=0x7fffe657e240, iov=iov@entry=0x7fffe6580240,
    max_num_sg=max_num_sg@entry=1024, is_write=is_write@entry=false,
    pa=0, sz=0) at /home/mdroth/w/qemu.git/hw/virtio/virtio.c:757 #3
    0x0000555555922a89 in virtqueue_pop (vq=vq@entry=0x555556dc8660,
    sz=sz@entry=184) at /home/mdroth/w/qemu.git/hw/virtio/virtio.c:950
    #4  0x00005555558d3eca in virtio_blk_get_request
    (vq=0x555556dc8660, s=0x555556dbcfb0)
    at /home/mdroth/w/qemu.git/hw/block/virtio-blk.c:255 #5
    0x00005555558d3eca in virtio_blk_handle_vq (s=0x555556dbcfb0,
    vq=0x555556dc8660)
    at /home/mdroth/w/qemu.git/hw/block/virtio-blk.c:776 #6
    0x000055555591dd66 in virtio_queue_notify_aio_vq
    (vq=vq@entry=0x555556dc8660)
    at /home/mdroth/w/qemu.git/hw/virtio/virtio.c:1550 #7
    0x000055555591ecef in virtio_queue_notify_aio_vq
    (vq=0x555556dc8660)
    at /home/mdroth/w/qemu.git/hw/virtio/virtio.c:1546 #8
    0x000055555591ecef in virtio_queue_host_notifier_aio_poll
    (opaque=0x555556dc86c8)
    at /home/mdroth/w/qemu.git/hw/virtio/virtio.c:2527 #9
    0x0000555555d02164 in run_poll_handlers_once
    (ctx=ctx@entry=0x55555688bfc0,
    timeout=timeout@entry=0x7fffe65844a8)
    at /home/mdroth/w/qemu.git/util/aio-posix.c:520 #10
    0x0000555555d02d1b in try_poll_mode (timeout=0x7fffe65844a8,
    ctx=0x55555688bfc0) at /home/mdroth/w/qemu.git/util/aio-posix.c:607
    #11 0x0000555555d02d1b in aio_poll (ctx=ctx@entry=0x55555688bfc0,
    blocking=blocking@entry=true)
    at /home/mdroth/w/qemu.git/util/aio-posix.c:639 #12
    0x0000555555d0004d in aio_wait_bh_oneshot (ctx=0x55555688bfc0,
    cb=cb@entry=0x5555558d5130 <virtio_blk_data_plane_stop_bh>,
    opaque=opaque@entry=0x555556de86f0)
    at /home/mdroth/w/qemu.git/util/aio-wait.c:71 #13
    0x00005555558d59bf in virtio_blk_data_plane_stop (vdev=<optimized
    out>)
    at /home/mdroth/w/qemu.git/hw/block/dataplane/virtio-blk.c:288 #14
    0x0000555555b906a1 in virtio_bus_stop_ioeventfd
    (bus=bus@entry=0x555556dbcf38)
    at /home/mdroth/w/qemu.git/hw/virtio/virtio-bus.c:245 #15
    0x0000555555b90dbb in virtio_bus_stop_ioeventfd
    (bus=bus@entry=0x555556dbcf38)
    at /home/mdroth/w/qemu.git/hw/virtio/virtio-bus.c:237 #16
    0x0000555555b92a8e in virtio_pci_stop_ioeventfd
    (proxy=0x555556db4e40)
    at /home/mdroth/w/qemu.git/hw/virtio/virtio-pci.c:292 #17
    0x0000555555b92a8e in virtio_write_config (pci_dev=0x555556db4e40,
    address=<optimized out>, val=1048832, len=<optimized out>)
    at /home/mdroth/w/qemu.git/hw/virtio/virtio-pci.c:613 I.e. the
    calling code is only scheduling a one-shot BH for
    virtio_blk_data_plane_stop_bh, but somehow we end up trying to
    process an additional virtqueue entry before we get there. This is
    likely due to the following check in
    virtio_queue_host_notifier_aio_poll: static bool
    virtio_queue_host_notifier_aio_poll(void *opaque) { EventNotifier
    *n = opaque; VirtQueue *vq = container_of(n, VirtQueue,
    host_notifier); bool progress; if (!vq->vring.desc ||
    virtio_queue_empty(vq)) { return false; } progress =
    virtio_queue_notify_aio_vq(vq); namely the call to
    virtio_queue_empty(). In this case, since no new requests have
    actually been issued, shadow_avail_idx == last_avail_idx, so we
    actually try to access the vring via vring_avail_idx() to get the
    latest non-shadowed idx: int virtio_queue_empty(VirtQueue *vq)
    { bool empty; ... if (vq->shadow_avail_idx != vq->last_avail_idx)
    { return 0; } rcu_read_lock(); empty = vring_avail_idx(vq) ==
    vq->last_avail_idx; rcu_read_unlock(); return empty;
    
    but since the IOMMU region has been disabled we get a bogus value (0
    usually), which causes virtio_queue_empty() to falsely report that
    there are entries to be processed, which causes errors such as:
    
      "virtio: zero sized buffers are not allowed"
    
    or
    
      "virtio-blk missing headers"
    
    and puts the device in an error state.
    
    This patch works around the issue by introducing
    virtio_set_disabled(), which sets a 'disabled' flag to bypass
    checks like virtio_queue_empty() when bus-mastering is disabled.
    Since we'd check this flag at all the same sites as vdev->broken,
    we replace those checks with an inline function which checks for
    either vdev->broken or vdev->disabled. 
    The 'disabled' flag is only migrated when set, which should be
    fairly rare, but to maintain migration compatibility we disable
    it's use for older machine types. Users requiring the use of the
    flag in conjunction with older machine types can set it explicitly
    as a virtio-device option.
    
    NOTES:
    
     - This leaves some other oddities in play, like the fact that
       DRIVER_OK also gets unset in response to bus-mastering being
       disabled, but not restored (however the device seems to continue
       working)
     - Similarly, we disable the host notifier via
       virtio_bus_stop_ioeventfd(), which seems to move the handling out
       of virtio-blk dataplane and back into the main IO thread, and it
       ends up staying there till a reset (but otherwise continues
    working normally)
    
    Cc: David Gibson <david@gibson.dropbear.id.au>,
    Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
    Cc: "Michael S. Tsirkin" <mst@redhat.com>
    Signed-off-by: Michael Roth <mdroth@linux.vnet.ibm.com>
    Message-Id: <20191120005003.27035-1-mdroth@linux.vnet.ibm.com>
    Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


> Thanks,
> Ming
> 
> 

