From: Jens Axboe <axboe@suse.de>
Subject: aic7xxx kobject crap
Date: Tue, 27 Apr 2004 16:14:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427141401.GF2089@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:15798 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264097AbUD0OOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 10:14:04 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: greg@kroah.com, "Justin T. Gibbs" <gibbs@scsiguy.com>

Hi,

I've given up trying to follow the kobject stuff going on in the driver
model, it's just one big maze of container_of() and foo_get() functions.
Loading the aic7xxx module gives a nice oops:

Oops: 0002 [#1] 
CPU:    0 
EIP:    0060:[<c01da5f6>]    Not tainted 
EFLAGS: 00010292   (2.6.5-5-default)  
EIP is at kobject_add+0x66/0x130 
eax: c034bd20   ebx: e127307c   ecx: e129aed8   edx: e1273098 
esi: e1273080   edi: e1273064   ebp: c034bd28   esp: df273db0 
ds: 007b   es: 007b   ss: 0068 
Process insmod (pid: 378, threadinfo=df272000 task=df274130) 
Stack: e127307c ffffffea e1273064 00000000 c01da749 e127307c c034bcc0
c021f64f  
       e127307c e1264498 e1273040 00000000 e12730d8 c0341db8 c021fad8
c0342484  
       00000010 c1020000 c0342478 c01e378b c0341dc8 00000000 c0341db8
e12614ca  
Call Trace: 
 [<c01da749>] kobject_register+0x19/0x3f 
 [<c021f64f>] bus_add_driver+0x2f/0x80 
 [<c021fad8>] driver_register+0x28/0x30 
 [<c01e378b>] pci_register_driver+0x4b/0x80 
 [<e12614ca>] ahc_linux_pci_init+0xa/0x990 [aic7xxx] 
 [<e10f919c>] ahc_linux_init+0x19c/0x29b [aic7xxx] 
 [<c013cfe0>] free_hot_cold_page+0xd0/0xf0 
 [<c0131ab5>] sys_init_module+0x105/0x15b0 
 [<c01234a0>] __request_region+0x0/0x80 
 [<e10f9000>] ahc_linux_init+0x0/0x29b [aic7xxx] 
 [<c014dd17>] do_shmem_file_read+0x227/0x2e0 
 [<c014de89>] shmem_file_read+0x69/0x80 
 [<c0138560>] file_read_actor+0x0/0xe0 
 [<c014de20>] shmem_file_read+0x0/0x80 
 [<c015538e>] __fput+0x9e/0xf0 
 [<c0107e27>] syscall_call+0x7/0xb 
 
Code: 89 11 8b 43 28 8b 30 8d 4e 48 89 c8 ba ff ff 00 00 0f c1 10  

tracing this, we end up in list_add_tail() in kobject_add() add:

	list_add_tail(&kobj->entry,&kobj->kset->list);

and oops occurs when __list_add() derefs kobj->kset->list.prev since
that is NULL, ie it was never initialized. It looks like kset_init()
sets this up, apparently that was never called for this kset.

-- 
Jens Axboe

