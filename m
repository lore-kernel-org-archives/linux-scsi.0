From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: scsi/qla2xxx: BUG_ON(blk_queued_rq(req) is triggered in
 blk_finish_request
Date: Tue, 5 Jun 2018 09:11:18 +0800
Message-ID: <27031631-a93f-e053-da84-3a11f78b3e62@oracle.com>
References: <66FCA66D-62D6-4B3F-A41D-BF50082E7572@cavium.com>
 <104bc709-fd06-0465-2eaa-44154f9df437@oracle.com>
 <6edc16d5-da2c-9c94-9352-36ab70649c68@oracle.com>
 <2E3BD00B-A5FD-46AB-B085-5399EC02FC2A@cavium.com>
 <49bb2808-bd63-bb89-1c61-6cb1d53178d9@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <49bb2808-bd63-bb89-1c61-6cb1d53178d9@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Junxiao Bi <junxiao.bi@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hi Himanshu

Would you please give some comment here?

Thanks
Jianchao

On 05/30/2018 11:28 AM, jianchao.wang wrote:
> Hi Himanshu
> 
> Thanks for your kindly response.
> 
> On 05/30/2018 01:44 AM, Madhani, Himanshu wrote:
>> Thanks for the information. I was out for couple days. Still working through my emails. 
>>
>> Without core dump shared with us, things become hard to debug. We'll take a look at this data. 
>>
>> Also, if you have any reproducer test case, Can you share that with us so that we can try to trigger It internally and see if we have better luck debugging that.
> 
> This issue occurred in customer's environment twice till now, there is no reproduce steps.
> 
> If you have time, would you please look at our analysis to see whether it is reasonable ?
> The kernel is not newest, but there should be the same issue in mainline with scsi + block legacy
> The key point here is:
> when the aborted command returns in irq context, it will invoke scsi_done, then blk_complete_request.
> however, the scsi recovery context could clear the ATOM_COMPLETE and requeue the request before irq
> context get it.
> 
> Thanks
> Jianchao
> 
>>
>> ﻿On 5/28/18, 6:11 PM, "jianchao.wang" <jianchao.w.wang@oracle.com> wrote:
>>
>>     Hi Himanshu
>>     
>>     do you need any other information ?
>>     
>>     Thanks
>>     Jianchao
>>     
>>     On 05/25/2018 02:48 PM, jianchao.wang wrote:
>>     > Hi Himanshu
>>     > 
>>     > I'm afraid I cannot provide you the vmcore file, it is from our customer.
>>     > If any information needed in the vmcore, I could provide with you.
>>     > 
>>     > In this scene, there are two contexts:
>>     > 1. the irq context, scsi_done() from qla2x00_sp_compl()
>>     > 2. the kworker context, scmd_eh_abort_handler which invokes the
>>     > qla2xxx_eh_abort()
>>     > 
>>     > Let's see the irq context.
>>     > scsi_done() will invoke the blk_complete_request().
>>     > In common case, the REQ_ATOM_COMPLETE　should have been set by
>>     > blk_rq_check_expired() when the request was confirmed timeout. So
>>     > __blk_complete_request() will not be invoked.
>>     > 
>>     > On the other hand, in the kworker context, scmd_eh_abort_handler() will do some
>>     > other things on this aborted request.
>>     > 
>>     > rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
>>     > if (rtn == SUCCESS) {
>>     >     set_host_byte(scmd, DID_TIME_OUT)
>>     >     if (scsi_host_eh_past_deadline(sdev->host)) {
>>     >         >>>>
>>     >     } else if (!scsi_noretry_cmd(scmd) &&
>>     >         (++scmd->retries <= scmd->allowed)) {
>>     >         scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY)
>>     >     }>>>>
>>     >>>>>
>>     > }
>>     > The host type of the result will set to DID_TIME_OUT. scsi_noretry_cmd() will
>>     > return false and scsi_queue_insert() will be invoked, finally the
>>     > blk_requeue_request().
>>     > 
>>     > blk_requeue_request() will clear the REQ_ATOM_COMPLETE and queue the request on
>>     > request_queue->queue_head.
>>     > 
>>     > There could be a race between these two contexts:
>>     > what if the blk_clear_rq_complete() in kworker context is invoked before the
>>     > blk_mark_rq_complete() in irq context ?
>>     > 
>>     > BLK_SOFTIRQ will be raised by __blk_complete_request() in irq context. Then the
>>     > scsi_softirq_done() will be invoked. At the moment, the request has been
>>     > requeued by kworker context and scsi_cmnd->result is set 0. On the cpu of the
>>     > irq context, the blk_finish_request() will be invoked finally, and panic comes
>>     > up due to  BUG_ON(blk_queued_rq(req)
>>     > 
>>     > Here is the dmesg log.
>>     > [4937745.180213] qla2xxx [0000:92:00.1]-801c:4: Abort command issued nexus=4:5:5 --  1 2002.
>>     > [4937745.180655] qla2xxx [0000:92:00.1]-801c:4: Abort command issued nexus=4:4:73 --  0 2002.
>>     > [4937745.181059] qla2xxx [0000:92:00.1]-801c:4: Abort command issued nexus=4:5:5 --  1 2002.
>>     > [4937745.181514] qla2xxx [0000:92:00.1]-801c:4: Abort command issued nexus=4:4:73 --  0 2002.
>>     > [4937745.181636] ------------[ cut here ]------------
>>     > [4937745.181900] kernel BUG at block/blk-core.c:2601!
>>     > [4937745.182095] qla2xxx [0000:92:00.1]-801c:4: Abort command issued nexus=4:5:5 --  1 2002.
>>     > [4937745.182338] qla2xxx [0000:92:00.1]-801c:4: Abort command issued nexus=4:4:73 --  1 2002.
>>     > [4937745.183046] qla2xxx [0000:92:00.1]-801c:4: Abort command issued nexus=4:5:5 --  1 2002.
>>     > [4937745.183213] qla2xxx [0000:92:00.1]-801c:4: Abort command issued nexus=4:4:73 --  1 2002.
>>     > [4937745.183844] qla2xxx [0000:92:00.1]-801c:4: Abort command issued nexus=4:5:5 --  1 2002.
>>     > [4937745.184038] qla2xxx [0000:92:00.1]-801c:4: Abort command issued nexus=4:4:73 --  1 2002.
>>     > [4937745.184919] invalid opcode: 0000 [#1] SMP
>>     > [4937745.185173] Modules linked in: ...
>>     > [4937745.188237] CPU: 18 PID: 0 Comm: swapper/18 Not tainted 4.1.12-61.1.9.el6uek.x86_64 #2
>>     > [4937745.188691] Hardware name: Oracle Corporation SUN BLADE X4-2B  /BD,ASSY,PCB,X4-2B     , BIOS 28010200 01/16/2014
>>     > [4937745.189157] task: ffff880227fa9c00 ti: ffff880227fc0000 task.ti: ffff880227fc0000
>>     > [4937745.189607] RIP: e030:[<ffffffff812ed130>]  [<ffffffff812ed130>] blk_finish_request+0xd0/0xe0
>>     > [4937745.190104] RSP: e02b:ffff88022d483d78  EFLAGS: 00010083
>>     > [4937745.190339] RAX: 0000000000000280 RBX: ffff8801c4508730 RCX: 0000000000000280
>>     > [4937745.190791] RDX: 0000000000008b5a RSI: 0000000000000000 RDI: ffff8801c4508730
>>     > [4937745.191246] RBP: ffff88022d483d88 R08: 0000000000000000 R09: 0000000000004000
>>     > [4937745.191694] R10: 000000000000000b R11: 0000000000007ffe R12: 0000000000000000
>>     > [4937745.192153] R13: ffff88022374d000 R14: ffff880184cb88c0 R15: ffff8800536ccc90
>>     > [4937745.197930] FS:  0000000000000000(0000) GS:ffff88022d480000(0000) knlGS:ffff88022d480000
>>     > [4937745.198389] CS:  e033 DS: 002b ES: 002b CR0: 0000000080050033
>>     > [4937745.198627] CR2: 00000000016e1f18 CR3: 000000010caed000 CR4: 0000000000042660
>>     > [4937745.199080] Stack:
>>     > [4937745.199309]  ffff8801c4508730 0000000000000000 ffff88022d483dd8 ffffffff814ac82f
>>     > [4937745.199790]  ffff88022d483da8 0000000000000280 ffff88022d483dd8 ffff880184cb88c0
>>     > [4937745.200290]  ffff8801c4508730 0000000000000000 0000000000000000 0000000000000000
>>     > [4937745.200745] Call Trace:
>>     > [4937745.200968]  <IRQ>
>>     > [4937745.200986]  [<ffffffff814ac82f>] scsi_end_request+0x11f/0x1e0
>>     > [4937745.201422]  [<ffffffff814accfc>] scsi_io_completion+0xac/0x500
>>     > [4937745.201651]  [<ffffffff814a3bb0>] scsi_finish_command+0xf0/0x150
>>     > [4937745.201875]  [<ffffffff814ad2ba>] scsi_softirq_done+0x14a/0x160
>>     > [4937745.202103]  [<ffffffff812f3c66>] blk_done_softirq+0x86/0xa0
>>     > [4937745.202333]  [<ffffffff8108879a>] __do_softirq+0x10a/0x350
>>     > [4937745.202558]  [<ffffffff81088b55>] irq_exit+0x125/0x130
>>     > [4937745.202787]  [<ffffffff813e5a89>] xen_evtchn_do_upcall+0x39/0x50
>>     > [4937745.203020]  [<ffffffff816cce5e>] xen_do_hypervisor_callback+0x1e/0x40
>>     > [4937745.203247]  <EOI>
>>     > [4937745.203263]  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
>>     > [4937745.203703]  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
>>     > [4937745.203930]  [<ffffffff8100baf0>] ? xen_safe_halt+0x10/0x20
>>     > [4937745.204160]  [<ffffffff81022abe>] ? default_idle+0x1e/0x100
>>     > [4937745.204387]  [<ffffffff8102210f>] ? arch_cpu_idle+0xf/0x20
>>     > [4937745.204614]  [<ffffffff810c8f25>] ? cpuidle_idle_call+0x135/0x1e0
>>     > [4937745.204841]  [<ffffffff810c91c5>] ? cpu_idle_loop+0x1f5/0x220
>>     > [4937745.205070]  [<ffffffff810c920b>] ? cpu_startup_entry+0x1b/0x70
>>     > [4937745.205294]  [<ffffffff810c924f>] ? cpu_startup_entry+0x5f/0x70
>>     > [4937745.205524]  [<ffffffff81013a5a>] ? cpu_bringup_and_idle+0x2a/0x40
>>     > [4937745.205749] Code: 89 de e8 a4 14 00 00 e9 6b ff ff ff 83 7b 48 01 0f 85
>>     > 78 ff ff ff 48 8b 7b 30 48 81 c7 98 01 00 00 e8 75 6b ea ff e9 63 ff ff ff
>>     > <0f> 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48
>>     > [4937745.206811] RIP  [<ffffffff812ed130>] blk_finish_request+0xd0/0xe0
>>     > [4937745.207046]  RSP <ffff88022d483d78>
>>     > [4937745.207687] ---[ end trace 0b43a57bdab9464f ]---
>>     > [4937745.207693] ------------[ cut here ]------------
>>     > 
>>     > On 05/25/2018 02:30 PM, Madhani, Himanshu wrote:
>>     >> Hi Jianchao, 
>>     >>
>>     >> Do you have any debug logs collected for us to look at this in details. 
>>     >>
>>     >> Can you provide me crash/vmlinux/modules for details analysis. 
>>     >>
>>     >> Thanks,
>>     >> himanshu
>>     >>
>>     >> On 5/24/18, 6:49 AM, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com> wrote:
>>     >>
>>     >>     
>>     >>     > On May 24, 2018, at 2:09 AM, jianchao.wang <jianchao.w.wang@oracle.com> wrote:
>>     >>     > 
>>     >>     > Hi Himanshu
>>     >>     > 
>>     >>     > Thanks god get response from your side finally :)
>>     >>     > I get qla2xxx-upstream@qlogic.com from the maintainer information of driver/scsi/qla2xxx
>>     >>     > Looks like it should be modified.
>>     >>     > 
>>     >>     Sorry for delay. I do try to respond quickly to any emails received on that ID as well. 
>>     >>     
>>     >>     We’ll keep it for now and I’ll look into updating it, if needed. 
>>     >>     
>>     >>     > Thanks
>>     >>     > Jianchao
>>     >>     > 
>>     >>     > On 05/24/2018 12:21 PM, Madhani, Himanshu wrote:
>>     >>     >> Hi, 
>>     >>     >> 
>>     >>     >> Yes. We'll look at this issue. 
>>     >>     >> 
>>     >>     >> Thanks,
>>     >>     >> Himanshu  
>>     >>     >> 
>>     >>     >>> -----Original Message-----
>>     >>     >>> From: jianchao.wang [mailto:jianchao.w.wang@oracle.com]
>>     >>     >>> Sent: Wednesday, May 23, 2018 6:51 PM
>>     >>     >>> To: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>; Madhani,
>>     >>     >>> Himanshu <Himanshu.Madhani@cavium.com>; jthumshirn@suse.de
>>     >>     >>> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
>>     >>     >>> jejb@linux.vnet.ibm.com; Martin K. Petersen <martin.petersen@oracle.com>;
>>     >>     >>> Junxiao Bi <junxiao.bi@oracle.com>
>>     >>     >>> Subject: Re: BUG: scsi/qla2xxx: BUG_ON(blk_queued_rq(req) is triggered in
>>     >>     >>> blk_finish_request
>>     >>     >>> 
>>     >>     >>> Would anyone please take a look at this ?
>>     >>     >>> 
>>     >>     >>> Thanks in advance
>>     >>     >>> Jianchao
>>     >>     >>> 
>>     >>     >>> On 05/23/2018 11:55 AM, jianchao.wang wrote:
>>     >>     >>>> 
>>     >>     >>>> 
>>     >>     >>>> Hi all
>>     >>     >>>> 
>>     >>     >>>> Our customer met a panic triggered by BUG_ON in blk_finish_request.
>>     >>     >>>>> From the dmesg log, the BUG_ON was triggered after command abort
>>     >>     >>> occurred many times.
>>     >>     >>>> There is a race condition in the following scenario.
>>     >>     >>>> 
>>     >>     >>>> cpu A                                   cpu B
>>     >>     >>>> kworker                                 interrupt
>>     >>     >>>> 
>>     >>     >>>> scmd_eh_abort_handler()
>>     >>     >>>>  -> scsi_try_to_abort_cmd()
>>     >>     >>>>    -> qla2xxx_eh_abort()
>>     >>     >>>>      -> qla2x00_eh_wait_on_command()   qla2x00_status_entry()
>>     >>     >>>>                                          -> qla2x00_sp_compl()
>>     >>     >>>>                                            -> qla2x00_sp_free_dma()
>>     >>     >>>>  -> scsi_queue_insert()
>>     >>     >>>>    -> __scsi_queue_insert()
>>     >>     >>>>      -> blk_requeue_request()
>>     >>     >>>>        -> blk_clear_rq_complete()
>>     >>     >>>>                                            -> scsi_done
>>     >>     >>>>                                              -> blk_complete_request
>>     >>     >>>>                                                -> blk_mark_rq_complete
>>     >>     >>>>          -> elv_requeue_request()              -> __blk_complete_request()
>>     >>     >>>>            -> __elv_add_request()
>>     >>     >>>>            // req will be queued here
>>     >>     >>>>                                                    BLK_SOFTIRQ
>>     >>     >>>>                                                    scsi_softirq_done()
>>     >>     >>>>                                                      -> scsi_finish_command()
>>     >>     >>>>                                                        -> scsi_io_completion()
>>     >>     >>>>                                                          -> scsi_end_request()
>>     >>     >>>>                                                            -> blk_finish_request()  //
>>     >>     >>> BUG_ON(blk_queued_rq(req)) !!!
>>     >>     >>>> 
>>     >>     >>>> The issue will not be triggered most of time, because the request is marked as
>>     >>     >>> complete by timeout path.
>>     >>     >>>> So the scsi_done from qla2x00_sp_compl does nothing.
>>     >>     >>>> But as the scenario above, if the complete state has been cleaned by
>>     >>     >>> blk_requeue_request, we will get
>>     >>     >>>> the request both requeued and completed, and then
>>     >>     >>> BUG_ON(blk_queued_rq(req)) in blk_finish_request comes up.
>>     >>     >>>> 
>>     >>     >>>> Is there any solution for this in qla2xxx driver side ?
>>     >>     >>>> 
>>     >>     >>>> Thanks
>>     >>     >>>> Jianchao
>>     >>     >>>> 
>>     >>     >>>> 
>>     >>     
>>     >>     Thanks,
>>     >>     - Himanshu
>>     >>     
>>     >>     
>>     >>
>>     > 
>>     
>>
