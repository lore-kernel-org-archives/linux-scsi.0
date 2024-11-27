Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C977A9463;
	Wed, 27 Nov 2024 13:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732715669; cv=none; b=BKIYh/yQDGOVf/WpI6jttQAY13gRdrnIPevkN5Ewl7zdaaYoLnHA4nzbWjgpTDuDgZ3v3HVIxF79rMKs6ciGoT4sPOMnN/5z6THNBJkPTn7Yyo5lMWXj4tYTDIWGzwZ3oUOZhYiaMbhsngKUdhfkEKIlOdKP4bE6HN9sBLsiJDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732715669; c=relaxed/simple;
	bh=Aqw4szN02PG8dHOxpyuuU4c0ytj2/nLiRBeIS61po1A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ISkS3MpiRxCHYch0aMSDZGGyfMDWIUN6VYpY2u6BUwDQvMEnCFHnTq7VNWmQt0pY1cQ92l6aMuRNk7ttdiRGW/RekMwMyKCz0w4ssgdcqzLeHodauKJvTZNq0dMhcEhFakxS9S6kcSfQdcIDjAYWHZ3U3LEuXDo5mTJY5G8D9ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=j8TLGYKq; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="j8TLGYKq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1732715619;
	bh=hhWzNR/51JZI1UYeGWf5oAGKUhNQnvHe6OwnE3nLtxo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version;
	b=j8TLGYKqGwyLInbcJqujcXtrGVQeYWCss+yBDKdeF+gf3xtJpQ5Qxuc2iE9LjFfnE
	 m8A4F82AETKsT5rm8OBHa54RGIZM0JFMyPYToVc9FoqXwmcNYeZWy0YXyX37I+VKYX
	 AE7sAQPYKPWv9D0mvzeetMCm37pogyyzNC9ozBk8=
X-QQ-mid: bizesmtpip2t1732715615tfe6msh
X-QQ-Originating-IP: 5//ZsfN8GJuQpPxWAmHlF7FZkgXH2FNP1pNhxmgpZXE=
Received: from john-PC ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 Nov 2024 21:53:33 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13632265027764339069
Date: Wed, 27 Nov 2024 21:53:30 +0800
From: Qiang Ma <maqianga@uniontech.com>
To: John Garry <john.g.garry@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 axboe@kernel.dk, dwagner@suse.de, ming.lei@redhat.com, hare@suse.de,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Don't wait for completion of in-flight requests
Message-ID: <3472C3D5E7A545A1+20241127215330.493f9690@john-PC>
In-Reply-To: <7c95b86b-68a0-41f8-a09c-3cb4b06fe61a@oracle.com>
References: <20241126115008.31272-1-maqianga@uniontech.com>
	<7c95b86b-68a0-41f8-a09c-3cb4b06fe61a@oracle.com>
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
X-QQ-XMAILINFO: MV3QjUGSBBpe2dB3AGQuv1cl+fqjah7MmWcpVuyfdnaamrrvCgqz5bJR
	CQq36ExtkTOvtjItC1b8TkeMVW7NZ10jBkOcML6C/iH2dp7/up+/aXoLy6iLLtWbvCXv2DT
	I91PkKrJSdMZMW0bg6LK/KwwOR4enor3Qh62UuT8TJS+eBmKn1ayILyahLLqh90dj/I5kY6
	V7GAFPBfgzutprk6sQeW9tCtpaFsT+8UaHwk/gKnTfbMbFnr7ps3xyCjI6jVJG1HzuPESWR
	hTfyPA/3OvQPHtyUAQAM/YErgdYJwKUHZvCLWUNRBsYHT3H7+Szt3pwnn2o96dqQtR8GluT
	9Msrn7csQvB+i6YfQE71jSoED0FTQehv5dlBypFDauKqDO5gCbOxfTW9OkfuYcX5bT+c4KF
	myKW7sJh5Hbf0qs4+fv30VEMwAeYk+u/fU7QX9fTw8wFTT/Wn7zzS/4vhXCQNc3upb6THvC
	N//mEuP2a0e7nzwJuNgORkmWi3GzjYsu7+piUVRXPLk1zoDyge78c38ude0RLtD+xc+JenX
	dF5oqUvQzFzGYZ0O3vPCZrS1TSiOvJXlbdfIGCL6knRfKlCggg+pGuHK04QyiN4R8ZbWh1n
	zCku3U+WGfvZ0lkBOBiMvjdtfqRhxFgEe/MPI2oDFQpRodlFUOPdW5R54ZqetlQV61OJA3y
	wORiiLKLTmCeSFIqdbrh+bskPxFMyQj32mtwbViVthscEZZg+EyafzFQ6epSNkdRt7tR6e/
	5z/Oi53hT8Z5ZcHkLOl95ukRoy4vxmUALsJnwqD6Ak9BocMvYi7pZ7OI2L3ie+O0+yQ28C+
	5C+O044Lqlhx/OtK3RpEcf7XMDt9YZaRm9UrnAPPTZsq7NBOJMsP1OMg86SM44ZQBvgOLOZ
	L0dAJoVevSaDq/0i6/c5oojetKB6Gch4c2fNpJb1CqQSOYypSDiaVZ1OZIfFAtI9hOkInPi
	n+6Q=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

On Tue, 26 Nov 2024 12:21:24 +0000
John Garry <john.g.garry@oracle.com> wrote:

> On 26/11/2024 11:50, Qiang Ma wrote:
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
> > 
> > ftrace finds that it enters an endless loop, code as follows:
> > 
> > if (percpu_ref_tryget(&hctx->queue->q_usage_counter)) {
> > 	while (blk_mq_hctx_has_requests(hctx))
> > 		msleep(5);
> > 	percpu_ref_put(&hctx->queue->q_usage_counter);
> > }
> > 
> > Solution:
> > Refer to the loop and dm-rq in patch commit bf0beec0607d
> > ("blk-mq: drain I/O when all CPUs in a hctx are offline"),
> > add a BLK_MQ_F_STACKING and set it for scsi, so we don't need
> > to wait for completion of in-flight requests  to avoid a potential
> > hung task.
> > 
> > Fixes: bf0beec0607d ("blk-mq: drain I/O when all CPUs in a hctx are
> > offline")
> > 
> > Signed-off-by: Qiang Ma <maqianga@uniontech.com>
> > ---
> >   drivers/scsi/scsi_lib.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index adee6f60c966..0a2d5d9327fc 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -2065,7 +2065,7 @@ int scsi_mq_setup_tags(struct Scsi_Host
> > *shost) tag_set->queue_depth = shost->can_queue;
> >   	tag_set->cmd_size = cmd_size;
> >   	tag_set->numa_node = dev_to_node(shost->dma_dev);
> > -	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
> > +	tag_set->flags = BLK_MQ_F_SHOULD_MERGE |
> > BLK_MQ_F_STACKING;  
> 
> This should not be set for all SCSI hosts. Some SCSI hosts rely on 
> bf0beec0607d.
> 
> 
What are the side effects of setting this up for some scsi hosts?

> >   	tag_set->flags |=
> >   		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
> >   	if (shost->queuecommand_may_block)  
> 
> 

