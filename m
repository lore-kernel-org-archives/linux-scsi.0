From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2] SCSI: fix queue cleanup race before queue
 initialization is done
Date: Wed, 21 Nov 2018 18:42:51 -0700
Message-ID: <dc374ec8-2ea2-0792-4677-0ae81fa7826e@kernel.dk>
References: <20181114082551.12141-1-ming.lei@redhat.com>
 <63c063ad-7d74-4268-bfd4-2de89908949e@kernel.dk>
 <4e24ace9-c83f-5311-5419-18f4a0fb5148@kernel.dk>
 <20181122010034.GA20814@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181122010034.GA20814@ming.t460p>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, stable <stable@vger.kernel.org>, "jianchao . wang" <jianchao.w.wang@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 11/21/18 6:00 PM, Ming Lei wrote:
> On Wed, Nov 21, 2018 at 02:47:35PM -0700, Jens Axboe wrote:
>> On 11/14/18 8:20 AM, Jens Axboe wrote:
>>> On 11/14/18 1:25 AM, Ming Lei wrote:
>>>> c2856ae2f315d ("blk-mq: quiesce queue before freeing queue") has
>>>> already fixed this race, however the implied synchronize_rcu()
>>>> in blk_mq_quiesce_queue() can slow down LUN probe a lot, so caused
>>>> performance regression.
>>>>
>>>> Then 1311326cf4755c7 ("blk-mq: avoid to synchronize rcu inside blk_cleanup_queue()")
>>>> tried to quiesce queue for avoiding unnecessary synchronize_rcu()
>>>> only when queue initialization is done, because it is usual to see
>>>> lots of inexistent LUNs which need to be probed.
>>>>
>>>> However, turns out it isn't safe to quiesce queue only when queue
>>>> initialization is done. Because when one SCSI command is completed,
>>>> the user of sending command can be waken up immediately, then the
>>>> scsi device may be removed, meantime the run queue in scsi_end_request()
>>>> is still in-progress, so kernel panic can be caused.
>>>>
>>>> In Red Hat QE lab, there are several reports about this kind of kernel
>>>> panic triggered during kernel booting.
>>>>
>>>> This patch tries to address the issue by grabing one queue usage
>>>> counter during freeing one request and the following run queue.
>>>
>>> Thanks applied, this bug was elusive but ever present in recent
>>> testing that we did internally, it's been a huge pain in the butt.
>>> The symptoms were usually a crash in blk_mq_get_driver_tag() with
>>> hctx->tags == NULL, or a crash inside deadline request insert off
>>> requeue.
>>
>> I'm still hitting some weird crashes even with this applied, like
>> this one:
>>
>>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000148      
>>  PGD 0 P4D 0.                                                                   
>>  Oops: 0000 [#1] SMP PTI                                                        
>>  CPU: 37 PID: 763 Comm: kworker/37:1H Not tainted 4.20.0-rc3-00649-ge64d9a554a91-dirty #14
>>  Hardware name: Wiwynn Leopard-Orv2/Leopard-DDR BW, BIOS LBM08   03/03/2017     
>>  Workqueue: kblockd blk_mq_run_work_fn                                          
>>  RIP: 0010:blk_mq_get_driver_tag+0x81/0x120                                     
>>  Code: 24 10 48 89 7c 24 20 74 21 83 fa ff 0f 95 c0 48 8b 4c 24 28 65 48 33 0c 25 28 00 00 00 0f 85 96 00 00 00 48 83 c4 30 5b 5d c3 <48> 8b 87 48 01 00 00 8b 40 04 39 43 20 72 37 f6 87 b0 00 00 00 02
>>  RSP: 0018:ffffc90004aabd30 EFLAGS: 00010246                                    
>>  RAX: 0000000000000003 RBX: ffff888465ea1300 RCX: ffffc90004aabde8              
>>  RDX: 00000000ffffffff RSI: ffffc90004aabde8 RDI: 0000000000000000              
>>  RBP: 0000000000000000 R08: ffff888465ea1348 R09: 0000000000000000              
>>  R10: 0000000000001000 R11: 00000000ffffffff R12: ffff888465ea1300              
>>  R13: 0000000000000000 R14: ffff888465ea1348 R15: ffff888465d10000              
>>  FS:  0000000000000000(0000) GS:ffff88846f9c0000(0000) knlGS:0000000000000000   
>>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                              
>>  CR2: 0000000000000148 CR3: 000000000220a003 CR4: 00000000003606e0              
>>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000              
>>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400              
>>  Call Trace:                                                                    
>>   blk_mq_dispatch_rq_list+0xec/0x480                                            
>>   ? elv_rb_del+0x11/0x30                                                        
>>   blk_mq_do_dispatch_sched+0x6e/0xf0                                            
>>   blk_mq_sched_dispatch_requests+0xfa/0x170                                     
>>   __blk_mq_run_hw_queue+0x5f/0xe0                                               
>>   process_one_work+0x154/0x350                                                  
>>   worker_thread+0x46/0x3c0                                                      
>>   kthread+0xf5/0x130                                                            
>>   ? process_one_work+0x350/0x350                                                
>>   ? kthread_destroy_worker+0x50/0x50                                            
>>   ret_from_fork+0x1f/0x30                                                       
>>  Modules linked in: sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm switchtec irqbypass iTCO_wdt iTCO_vendor_support efivars cdc_ether usbnet mii cdc_acm i2c_i801 lpc_ich mfd_core ipmi_si ipmi_devintf ipmi_msghandler acpi_cpufreq button sch_fq_codel nfsd nfs_acl lockd grace auth_rpcgss oid_registry sunrpc nvme nvme_core fuse sg loop efivarfs autofs4
>>  CR2: 0000000000000148                                                          
>>  ---[ end trace 340a1fb996df1b9b ]---                                           
>>  RIP: 0010:blk_mq_get_driver_tag+0x81/0x120                                     
>>  Code: 24 10 48 89 7c 24 20 74 21 83 fa ff 0f 95 c0 48 8b 4c 24 28 65 48 33 0c 25 28 00 00 00 0f 85 96 00 00 00 48 83 c4 30 5b 5d c3 <48> 8b 87 48 01 00 00 8b 40 04 39 43 20 72 37 f6 87 b0 00 00 00 02
>>
>> which doesn't look that great... Are we sure this patch closed the window
>> completely?
> 
> I mentioned this patch is just one workaround, see my comment before:
> 
> https://marc.info/?l=linux-scsi&m=154224379320094&w=2
> 
>>
>> One thing I'm pondering is we're running the queue async, so the
>> ref get will protect whatever blk_mq_run_hw_queues() does, but
>> what is preventing the queue from going away as soon as we've
>> returned from that call? Meanwhile we still have the work item
>> queued up, and it'll run, and go boom like above.
> 
> blk_sync_queue() supposes to drain the queued work, but it can be
> queued after blk_sync_queue() returns.

It's definitely broken. Big time. And we need to do something about
it NOW.

> Or maybe we can try the following patch?

I'm going to start backing out the sync removal patches instead of
adding items to the hot path...

Ted, I saw your email, I'm looking into it. Sounds like a regression
between 4.18 and 4.19. The sync issue could still be it, as it can
cause memory corruption, and that could lead to other corruption
issues.

-- 
Jens Axboe
