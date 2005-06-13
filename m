From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [Fwd] further testing w/ multipath ... and bugs
Date: Mon, 13 Jun 2005 14:30:53 +0200
Message-ID: <20050613123053.GB28625@averon.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:45541 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S261542AbVFMMaI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 08:30:08 -0400
Received: from debian (lns-vlq-40-rei-82-252-4-52.adsl.proxad.net [82.252.4.52])
	by postfix4-1.free.fr (Postfix) with ESMTP id 8D265317EE1
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 14:30:00 +0200 (CEST)
Received: from cvaroqui by debian with local (Exim 4.50)
	id 1Dho5d-0007iP-3a
	for linux-scsi@vger.kernel.org; Mon, 13 Jun 2005 14:30:53 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I should have posted this here in the first place.
Seems related to the recent fc_remote_ports and qlogic work.

Regards,
cvaroqui

----- Forwarded message from Christophe Varoqui <christophe.varoqui@free.fr> -----

List-Id: device-mapper development <dm-devel.redhat.com>

Here is an additional one :

When at the end of the previous scenario, with a dd in D-state, I "dmsetup remove_all" ... it effectively accept to remove the maps. Exec'ing multipath again gives :

 [<c027506c>] end_that_request_last+0xcc/0x100                                  
 [<c02b19ed>] scsi_end_request+0x9d/0xe0                                    
 [<c02b1d45>] scsi_io_completion+0x155/0x500                                  
 [<c0327643>] ip_rcv+0x3a3/0x560                                            
 [<c012c1de>] del_timer+0x5e/0x70                                               
 [<c02cdce4>] sd_rw_intr+0x164/0x320                                         
 [<c0149531>] mempool_free+0x81/0xa0                                          
 [<c02c60cd>] qla2x00_process_response_queue+0x14d/0x1d0                    
 [<c02ac946>] scsi_finish_command+0x96/0xe0                                   
 [<c033f2e3>] tcp_write_timer+0x73/0xe0                                      
 [<c02ac836>] scsi_softirq+0xa6/0xe0                                        
 [<c01285b2>] __do_softirq+0x82/0x100                                      
 [<c0128665>] do_softirq+0x35/0x40                                         
 [<c010675b>] do_IRQ+0x3b/0x70                                                
 [<c0104c1e>] common_interrupt+0x1a/0x20                           
 [<c0102030>] default_idle+0x0/0x30                                
 [<c0102053>] default_idle+0x23/0x30                               
 [<c0102104>] cpu_idle+0x64/0x80                                   
 [<c0462965>] start_kernel+0x185/0x1d0                             
 [<c0462370>] unknown_bootoption+0x0/0x1e0                         
Code: 90 80 3e 00 7e f9 fa eb e8 89 d8 8b 74 24 0c 8b 5c 24 08 83 c4 10 c3 c7 04
 24 c4 6a 38 c0 8b 44 24 10 89 44 24 04 e8 6d 30 db ff <0f> 0b 95 00 c2 62 38 c0
 eb bc 8d 76 00 53 83 ec 08 89 c3 fa 81                     
 <0>Kernel panic - not syncing: Fatal exception in interrupt       

Regards,
cvaroqui

On Mon, Jun 13, 2005 at 10:11:54AM +0200, Christophe Varoqui wrote:
> Hello,
> 
> I'm testing Mike Christie's START_STOP hwhandler and discovered a bunch of new, interesting, phenomenons :
> 
> A little context first :
> o kernel 2.6.12-rc6 + qlogic discovery patch
> o qla2342 (dual 2GB)
> o EVA5000, Solaris-tagged connections
> 
> Here is a map created by multipath, fresh from boot :
> 
> eva1_lun2 (3600508b400014ba7000120000cf00000)
> [size=50 GB][features="1 queue_if_no_path"][hwhandler="1 hp_sw"]
> \_ round-robin 0 [active][best]
>   \_ 0:0:0:2 sdb  8:16    [ready ][active]
>   \_ 1:0:0:2 sdf  8:80    [ready ][active]
> \_ round-robin 0 [enabled]
>   \_ 0:0:1:2 sdd  8:48    [faulty][active]
>   \_ 1:0:1:2 sdh  8:112   [faulty][active]
> 
> Start a background stream read with dd on that map.
> 
> Do a port disable on the FC switch port connected to HBA 0
> Consistently at this moment I get the following in the logs :
> 
> qla2300 0000:05:0d.0: LOOP DOWN detected.
> Debug: sleeping function called from invalid context at include/linux/rwsem.h:43
> in_atomic():1, irqs_disabled():1
>  [<c0120a74>] __might_sleep+0xa4/0xc0
>  [<c026a466>] device_for_each_child+0x26/0x80
>  [<c02b3180>] target_block+0x0/0x30
>  [<c02bbdae>] fc_remote_port_block+0x2e/0x60
>  [<c02bdbf5>] qla2x00_mark_all_devices_lost+0x55/0x60
>  [<c02c597e>] qla2x00_async_event+0x83e/0xd60
>  [<c011dd2b>] find_busiest_group+0xbb/0x310
>  [<c02cdce4>] sd_rw_intr+0x164/0x320
>  [<c02c4e37>] qla2300_intr_handler+0x77/0x240
>  [<c0144882>] handle_IRQ_event+0x32/0x70
>  [<c0144997>] __do_IRQ+0xd7/0x140
>  [<c0106756>] do_IRQ+0x36/0x70
>  [<c0104c1e>] common_interrupt+0x1a/0x20
>  [<c0102030>] default_idle+0x0/0x30
>  [<c0102053>] default_idle+0x23/0x30
>  [<c0102104>] cpu_idle+0x64/0x80
> 
> If I wait long enough, I then get the following :
> 
>  rport-0:0-0: blocked FC remote port time out: removing target
>  rport-0:0-1: blocked FC remote port time out: removing target
> 
> ... which is rather new to me.
> 
> As a side effect, all sd associated are removed, uevents are sent signaling the disks have gone. This triggers checker removal on multipathd side in the current implementation.
> 
> Then, upon port reenable, sd are registred again with different minor than before. uevent adds get sent, multipath reconfigures the maps and ...
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> f8b0d29f
> *pde = 08e4d001
> Oops: 0000 [#1]
> SMP
> Modules linked in: dm_round_robin dm_hp_sw dm_multipath md5 ipv6 parport_pc lp parport autofs4 i2c_dev i2c_core sunrpc video button battery ac ohci_hcd tg3 floppy dm_mod qla6312
> CPU:    2
> EIP:    0060:[<f8b0d29f>]    Not tainted VLI
> EFLAGS: 00010086   (2.6.12-rc6)
> EIP is at rr_select_path+0xf/0x60 [dm_round_robin]
> eax: f6a989cc   ebx: 00000000   ecx: f6a978c0   edx: f7f1e77c
> esi: f7f1e77c   edi: 00000000   ebp: 00000001   esp: f65d1f00
> ds: 007b   es: 007b   ss: 0068
> Process kmpathd/2 (pid: 4564, threadinfo=f65d0000 task=f6708aa0)
> Stack: f6a989c0 f7f1e740 f8ae3bc2 f7f1e740 f7f1e740 f8ae3c90 f7f1e740 f7f1e740
>        00000000 f7f1e74c f8ae3f9c 00000286 00000000 f7f1e754 f7f1e740 f7f34100
>        f7f1e790 00000282 c01339a2 00000000 000f42b4 f6cdfe5c f7f34128 f7f34110
> Call Trace:
>  [<f8ae3bc2>] __choose_path_in_pg+0x12/0x40 [dm_multipath]
>  [<f8ae3c90>] __choose_pgpath+0xa0/0xb0 [dm_multipath]
>  [<f8ae3f9c>] process_queued_ios+0x7c/0xf0 [dm_multipath]
>  [<c01339a2>] worker_thread+0x1c2/0x250
>  [<f8ae3f20>] process_queued_ios+0x0/0xf0 [dm_multipath]
>  [<c011eaa0>] default_wake_function+0x0/0x10
>  [<c011eaa0>] default_wake_function+0x0/0x10
>  [<c01337e0>] worker_thread+0x0/0x250
>  [<c0137c65>] kthread+0xa5/0xf0
>  [<c0137bc0>] kthread+0x0/0xf0
>  [<c0102445>] kernel_thread_helper+0x5/0x10
> Code: 42 04 89 10 89 58 04 89 03 31 c0 5b c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 83 ec 08 89 74 24 04 89 d6 89 1c 24 8b 58 04 <8b> 03 39 d8 74 30 89 c1 8b 50 04 8b 00 85 c9 89 50 04 89 02 8b
> 
> Here dd is now stuck in D-state.
> 
> I Will post more as I continue my hammering.
> 
> Regards,
> cvaroqui
> 
----- End forwarded message -----
