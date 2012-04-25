From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 42969] New: Softlockup during boot during init_sd
Date: Wed, 25 Apr 2012 16:05:30 +0100
Message-ID: <1335366330.3081.6.camel@dabdike.lan>
References: <bug-42969-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58689 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087Ab2DYPFf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 11:05:35 -0400
In-Reply-To: <bug-42969-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 2012-03-21 at 06:46 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=42969
> 
>            Summary: Softlockup during boot during init_sd
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 3.3-rc5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: eric.sesterhenn@lsexperts.de
>         Regression: Yes
> 
> 
> Created an attachment (id=72662)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=72662)
> Bisect Log
> 
> Hi,
> 
> when switching from kernels 2.6 to 3 we run into a softlockup during sd_init.
> 
> The last working kernel we used was Debian Backports 2.6.39-
> bpo.2-amd64. The newest kernel we tested which failed is vanilla 3.3-rc5.
> 
> The problem roughly happens in three out of four boots.
> 
> 
> [   60.219724] BUG: soft lockup - CPU#0 stuck for 23s! [modprobe:257]          
>                                                        [   60.219726] Modules
> linked in: sd_mod(+) crc_t10dif uhci_hcd(+) lpfc 
> scsi_transport_fc scsi_tgt ehci_hcd usbcore igb scsi_mod usb_common dca        
>                                                                     [  
> 60.219736] CPU 0                                                               
>                [   60.219737] Modules linked in: sd_mod(+) crc_t10dif
> uhci_hcd(+) lpfc 
> scsi_transport_fc scsi_tgt ehci_hcd usbcore igb scsi_mod usb_common dca        
>                                                                     [  
> 60.219743]                                                                     
> [   60.219746] Pid: 257, comm: modprobe Not tainted 3.2.0-1-amd64 #1 HITACHI    
> BladeSymphony F51   /7TPBVa                             
> [   60.219750] RIP: 0010:[<ffffffff810703c0>]  [<ffffffff810703c0>] 
> smp_call_function_many+0x1c7/0x1de                                   
> [   60.219759] RSP: 0018:ffff880630939d48  EFLAGS: 00000202                     
> [   60.219761] RAX: 0000000000000200 RBX: 0000000000000010 RCX: 
> 0000000000000000                                                         
> [   60.219763] RDX: 0000000000000010 RSI: 0000000000000200 RDI: 
> 0000000000000286                                                         
> [   60.219766] RBP: 000000000000000f R08: 0000000000000200 R09: 
> ffffffff8168cac0                                                         
> [   60.219768] R10: 00000000000163a8 R11: 00000000000163a8 R12: 
> ffffffffffffff95                                                         
> [   60.219770] R13: 0000000000000286 R14: 0000000000000200 R15: 
> 0000000000000010                                                         
> [   60.219773] FS:  00007f29dea69700(0000) GS:ffff88033fc00000(0000) 
> knlGS:0000000000000000                                              
> [   60.219776] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033               
>                                                 [   60.219778] CR2:
> ffffe8fcffc00000 CR3: 00000006308cb000 CR4: 
> 00000000000006f0                                                         
> [   60.219780] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> 0000000000000000                                                         
> [   60.219782] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
> 0000000000000400                                                         
> [   60.219785] Process modprobe (pid: 257, threadinfo ffff880630938000, task 
> ffff88063170caa0)                                           
> [   60.219787] Stack:                                                          
>                [   60.219788]  0000000000000246 01ffffff810eaa96
> 0000000000000088 
> ffffffff810e9109                                                      
> [   60.219794]  ffff88032cdc8f00 000000000000fef0 00000000ffffffff 
> 000000000000000f                                                      
> [   60.219798]  000000000000003c ffffffff810703f2 00000000000163a8 
> ffffffff81070409                                                      
> [   60.219802] Call Trace:                                                     
>                     [   60.219809]  [<ffffffff810e9109>] ?
> kmem_cache_size+0x4/0x4                                                        
> [   60.219813]  [<ffffffff810703f2>] ? smp_call_function+0x1b/0x20             
>                                        [   60.219816]  [<ffffffff81070409>] ?
> on_each_cpu+0x12/0x35                                                          
> [   60.219820]  [<ffffffff810eb078>] ? do_tune_cpucache+0xef/0x3d6             
>                                        [   60.219823]  [<ffffffff810eb530>] ?
> enable_cpucache+0x78/0x9d                                                      
> [   60.219827]  [<ffffffff810eba3a>] ? kmem_cache_create+0x3fb/0x476           
>                                        [   60.219834]  [<ffffffffa018609c>] ?
> init_sd+0x9c/0x1000 [sd_mod]                                                    
> [   60.219837]  [<ffffffffa0186000>] ? 0xffffffffa0185fff                      
>                                        [   60.219840]  [<ffffffffa0186000>] ?
> 0xffffffffa0185fff                                                             
> [   60.219844]  [<ffffffff81002085>] ? do_one_initcall+0x75/0x12c              
>                                        [   60.219847]  [<ffffffffa0186000>] ?
> 0xffffffffa0185fff                                                             
> [   60.219851]  [<ffffffff81074efd>] ? sys_init_module+0x10c/0x25b             
>                                        [   60.219856]  [<ffffffff813457d2>] ?
> system_call_fastpath+0x16/0x1b                                                 
> [   60.219858] Code: 48 89 5a 08 48 89 c6 89 6b 28 48 89 1d 1a 3e 59 00 e8 a9 
> 04 2d 00 0f ae f0 4c 89 ef ff 15 11 3e 5a 00 80 7c 24 0f 00 75 04 eb 08 <f3> 
> 90 f6 43 20 01 75 f8 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41                     
> [   60.219880] Call Trace:                                                     
>                     [   60.219884]  [<ffffffff810e9109>] ?
> kmem_cache_size+0x4/0x4                                                        
> [   60.219887]  [<ffffffff810703f2>] ? smp_call_function+0x1b/0x20             
>                                        [   60.219890]  [<ffffffff81070409>] ?
> on_each_cpu+0x12/0x35                                                          
> [   60.219894]  [<ffffffff810eb078>] ? do_tune_cpucache+0xef/0x3d6             
>                                        [   60.219897]  [<ffffffff810eb530>] ?
> enable_cpucache+0x78/0x9d                                                      
> [   60.219901]  [<ffffffff810eba3a>] ? kmem_cache_create+0x3fb/0x476           
>                                        [   60.219906]  [<ffffffffa018609c>] ?
> init_sd+0x9c/0x1000 [sd_mod]                                                    
> [   60.219909]  [<ffffffffa0186000>] ? 0xffffffffa0185fff                      
>                                        [   60.219911]  [<ffffffffa0186000>] ?
> 0xffffffffa0185fff                                                             
> [   60.219914]  [<ffffffff81002085>] ? do_one_initcall+0x75/0x12c              
>                                        [   60.219917]  [<ffffffffa0186000>] ?
> 0xffffffffa0185fff                                                             
> [   60.219920]  [<ffffffff81074efd>] ? sys_init_module+0x10c/0x25b             
>                                        [   60.219924]  [<ffffffff813457d2>] ?
> system_call_fastpath+0x16/0x1b           
> 
> 
> A collegue tried a bisect, but the offending commit seemed USB related and
> reverting did not fix the problem for us.

This doesn't look sd related to me.  The failure seems to be because
smp_call_function got stuck.  That implies either one of the IPIs got
lost or one of the CPUs is spinning with interrupts off.

I've cc'd linux-kernel in case anyone there knows what might be causing
this.

James



