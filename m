From: Laurence Oberman <loberman@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Sat, 6 Aug 2016 10:47:33 -0400 (EDT)
Message-ID: <1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com>
References: <20160801175948.GA6685@redhat.com>
	<eb1af921-d874-1f6a-c5d0-12d3cae04256@sandisk.com>
	<20160804161047.GC6989@redhat.com>
	<4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com>
	<20160804235850.GB13132@redhat.com>
	<1649218.8261013.1470359248073.JavaMail.zimbra@redhat.com>
	<1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com>
	<73e2aeda-140d-72ab-d295-57f35139ae55@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <73e2aeda-140d-72ab-d295-57f35139ae55@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche@sandisk.com>
> To: "Laurence Oberman" <loberman@redhat.com>, "Mike Snitzer" <snitzer@redhat.com>
> Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
> Sent: Friday, August 5, 2016 2:42:49 PM
> Subject: Re: [dm-devel] dm-mq and end_clone_request()
> 
> On 08/05/2016 04:43 AM, Laurence Oberman wrote:
> > Further testing has shown we are still exposed here so more investigation
> > is necessary.
> > The above patch seems to help but I still see sporadic cases of errors
> > escaping up the stack.
> >
> > I expect you will see the same so more work to do here to figure this out.
> 
> Hello Laurence,
> 
> Unfortunately I also still see sporadic I/O errors when testing
> all-paths-down with CONFIG_DM_MQ_DEFAULT=n (I have not yet tried to
> retest with CONFIG_DM_MQ_DEFAULT=y).
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hello Bart,

I am still debugging this, now that I have no_path_retry=queue and not a count :)
I am often hitting the host delete race, have you seen this on your testing during debugging.

I am using your kernel built from your git tree that has  Mikes patches applied.
4.7.0bart

[66813.896159] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[66813.933246] Workqueue: srp_remove srp_remove_work [ib_srp]
[66813.964703]  0000000000000086 00000000d185b9ce ffff88060fa03d20 ffffffff813456df
[66814.007292]  0000000000000000 0000000000000000 ffff88060fa03d60 ffffffff81089fb1
[66814.049336]  0000007da067604b ffff880c01643d80 0000000000017ec0 ffff880c016447dc
[66814.091725] Call Trace:
[66814.104775]  <IRQ>  [<ffffffff813456df>] dump_stack+0x63/0x84
[66814.136507]  [<ffffffff81089fb1>] __warn+0xd1/0xf0
[66814.163118]  [<ffffffff8108a0ed>] warn_slowpath_null+0x1d/0x20
[66814.195409]  [<ffffffff8104fd7e>] native_smp_send_reschedule+0x3e/0x40
[66814.231954]  [<ffffffff810b47db>] try_to_wake_up+0x30b/0x390
[66814.263661]  [<ffffffff810b4912>] default_wake_function+0x12/0x20
[66814.297713]  [<ffffffff810ccb05>] __wake_up_common+0x55/0x90
[66814.330021]  [<ffffffff810ccb53>] __wake_up_locked+0x13/0x20
[66814.361906]  [<ffffffff81261179>] ep_poll_callback+0xb9/0x200
[66814.392784]  [<ffffffff810ccb05>] __wake_up_common+0x55/0x90
[66814.424908]  [<ffffffff810ccc59>] __wake_up+0x39/0x50
[66814.454327]  [<ffffffff810e1f80>] wake_up_klogd_work_func+0x40/0x60
[66814.490152]  [<ffffffff81177b6d>] irq_work_run_list+0x4d/0x70
[66814.523007]  [<ffffffff810710d0>] ? do_flush_tlb_all+0x50/0x50
[66814.556161]  [<ffffffff81177bbc>] irq_work_run+0x2c/0x30
[66814.586677]  [<ffffffff8110ab5f>] flush_smp_call_function_queue+0x8f/0x160
[66814.625667]  [<ffffffff8110b613>] generic_smp_call_function_single_interrupt+0x13/0x60
[66814.669276]  [<ffffffff81050167>] smp_call_function_interrupt+0x27/0x40
[66814.706255]  [<ffffffff816c7e9c>] call_function_interrupt+0x8c/0xa0
[66814.741406]  <EOI>  [<ffffffff8118e733>] ? panic+0x1ef/0x233
[66814.772851]  [<ffffffff8118e72f>] ? panic+0x1eb/0x233
[66814.800207]  [<ffffffff810308f8>] oops_end+0xb8/0xd0
[66814.827454]  [<ffffffff8106977e>] no_context+0x13e/0x3a0
[66814.858368]  [<ffffffff811f3feb>] ? __slab_free+0x9b/0x280
[66814.890365]  [<ffffffff81069ace>] __bad_area_nosemaphore+0xee/0x1d0
[66814.926508]  [<ffffffff81069bc4>] bad_area_nosemaphore+0x14/0x20
[66814.959939]  [<ffffffff8106a269>] __do_page_fault+0x89/0x4a0
[66814.992039]  [<ffffffff811f3feb>] ? __slab_free+0x9b/0x280
[66815.023052]  [<ffffffff8106a6b0>] do_page_fault+0x30/0x80
[66815.053368]  [<ffffffff816c8b88>] page_fault+0x28/0x30
[66815.083196]  [<ffffffff814ae4e9>] ? __scsi_remove_device+0x79/0x160
[66815.117444]  [<ffffffff814ae5c2>] ? __scsi_remove_device+0x152/0x160
[66815.152051]  [<ffffffff814ac790>] scsi_forget_host+0x60/0x70
[66815.183939]  [<ffffffff814a0137>] scsi_remove_host+0x77/0x110
[66815.216152]  [<ffffffffa0677be0>] srp_remove_work+0x90/0x200 [ib_srp]
[66815.253221]  [<ffffffff810a2e72>] process_one_work+0x152/0x400
[66815.286221]  [<ffffffff810a3765>] worker_thread+0x125/0x4b0
[66815.317313]  [<ffffffff810a3640>] ? rescuer_thread+0x380/0x380
[66815.349770]  [<ffffffff810a9298>] kthread+0xd8/0xf0
[66815.376082]  [<ffffffff816c6b3f>] ret_from_fork+0x1f/0x40
[66815.404767]  [<ffffffff810a91c0>] ? kthread_park+0x60/0x60
[66815.436448] ---[ end trace bfaf79198d0976f5 ]---
