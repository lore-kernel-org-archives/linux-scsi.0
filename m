From: James Bottomley <jbottomley@parallels.com>
Subject: Re: hpsa - BUG: using smp_processor_id() in preemptible [00000000
 00000000] code: kworker/u:0/6
Date: Thu, 25 Jul 2013 23:56:08 +0000
Message-ID: <1374796568.1952.43.camel@dabdike>
References: <alpine.LFD.2.03.1307252312310.28787@tycho>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:47408 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab3GYX4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jul 2013 19:56:12 -0400
In-Reply-To: <alpine.LFD.2.03.1307252312310.28787@tycho>
Content-Language: en-US
Content-ID: <1BDBAE4999BCF44085DA750C8ED9B525@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Kacur <jkacur@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "Luis Claudio R. Goncalves" <lclaudio@uudg.org>, Clark Williams <williams@redhat.com>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

[Adding missing cc to linux-scsi]
On Thu, 2013-07-25 at 23:33 +0200, John Kacur wrote:
> Hi
> 
> We're seeing this on a 3.6 kernel with the real-time patch applied, but it 
> looks like it is relevant with the real-time patch in the latest kernel 
> too.
> 
> [   49.688847] hpsa 0000:03:00.0: hpsa0: <0x323a> at IRQ 67 using DAC
> [   49.749928] scsi0 : hpsa
> [   49.784437] BUG: using smp_processor_id() in preemptible [00000000 
> 00000000] code: kworker/u:0/6
> [   49.784465] caller is enqueue_cmd_and_start_io+0x5a/0x100 [hpsa]
> [   49.784468] Pid: 6, comm: kworker/u:0 Not tainted 
> 3.6.11.5-rt37.52.el6rt.x86_64.debug #1
> [   49.784471] Call Trace:
> [   49.784512]  [<ffffffff812abe83>] debug_smp_processor_id+0x123/0x150
> [   49.784520]  [<ffffffffa009043a>] enqueue_cmd_and_start_io+0x5a/0x100 
> [hpsa]
> [   49.784529]  [<ffffffffa00905cb>] 
> hpsa_scsi_do_simple_cmd_core+0xeb/0x110 [hpsa]
> [   49.784537]  [<ffffffff812b09c8>] ? swiotlb_dma_mapping_error+0x18/0x30
> [   49.784544]  [<ffffffff812b09c8>] ? swiotlb_dma_mapping_error+0x18/0x30
> [   49.784553]  [<ffffffffa0090701>] 
> hpsa_scsi_do_simple_cmd_with_retry+0x91/0x280 [hpsa]
> [   49.784562]  [<ffffffffa0093558>] 
> hpsa_scsi_do_report_luns.clone.2+0xd8/0x130 [hpsa]
> [   49.784571]  [<ffffffffa00935ea>] 
> hpsa_gather_lun_info.clone.3+0x3a/0x1a0 [hpsa]
> [   49.784580]  [<ffffffffa00963df>] hpsa_update_scsi_devices+0x11f/0x4f0 
> [hpsa]
> [   49.784592]  [<ffffffff81592019>] ? sub_preempt_count+0xa9/0xe0
> [   49.784601]  [<ffffffffa00968ad>] hpsa_scan_start+0xfd/0x150 [hpsa]
> [   49.784613]  [<ffffffff8158cba8>] ? rt_spin_lock_slowunlock+0x78/0x90
> [   49.784626]  [<ffffffff813b04d7>] do_scsi_scan_host+0x37/0xa0
> [   49.784632]  [<ffffffff813b05da>] do_scan_async+0x1a/0x30
> [   49.784643]  [<ffffffff8107c4ab>] async_run_entry_fn+0x9b/0x1d0
> [   49.784655]  [<ffffffff8106ae92>] process_one_work+0x1f2/0x620
> [   49.784661]  [<ffffffff8106ae20>] ? process_one_work+0x180/0x620
> [   49.784668]  [<ffffffff8106d4fe>] ? worker_thread+0x5e/0x3a0
> [   49.784674]  [<ffffffff8107c410>] ? async_schedule+0x20/0x20
> [   49.784681]  [<ffffffff8106d5d3>] worker_thread+0x133/0x3a0
> [   49.784688]  [<ffffffff8106d4a0>] ? manage_workers+0x190/0x190
> [   49.784696]  [<ffffffff81073236>] kthread+0xa6/0xb0
> [   49.784707]  [<ffffffff815970a4>] kernel_thread_helper+0x4/0x10
> [   49.784715]  [<ffffffff81082a7c>] ? finish_task_switch+0x8c/0x110
> [   49.784721]  [<ffffffff8158e44b>] ? _raw_spin_unlock_irq+0x3b/0x70
> [   49.784727]  [<ffffffff8158e85d>] ? retint_restore_args+0xe/0xe
> [   49.784734]  [<ffffffff81073190>] ? kthreadd+0x1e0/0x1e0
> [   49.784739]  [<ffffffff815970a0>] ? gs_change+0xb/0xb
> 
> -------
> 
> When I look at the code I see this call chain
> enqueue_cmd_and_start_io()->
> 	set_performant_mode()->
> 		smp_processor_id()
> Which if you have debugging enabled calls debug_processor_id() and 
> triggers the warning.
> 
> I'm not very familiar with the hpsa code, so I'm not entirely sure what 
> the purpose of this line is
> 
> c->Header.ReplyQueue = smp_processor_id() % h->nreply_queues;
> 
> Is the purpose to simply try to get a range of ReplyQueue numbers, but 
> somewhat arbitrary? Or is it necessary that the current processor_id 
> is used? If it is the former, and you're not accessing per cpu structures, 
> or pinning a cpu, or anything like that then I would think it is safe to 
> change this to a raw_smp_processor_id() to get rid of a false positive 
> warning.
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 7f4f790..4e19267 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -583,7 +583,7 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
>  		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
>  		if (likely(h->msix_vector))
>  			c->Header.ReplyQueue =
> -				smp_processor_id() % h->nreply_queues;
> +				raw_smp_processor_id() % h->nreply_queues;
>  	}
>  }
>  
> 
> Thanks
> 
> John Kacur


