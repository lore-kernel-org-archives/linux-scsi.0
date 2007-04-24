From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: Kernel crash with AIC94xx
Date: Tue, 24 Apr 2007 08:06:34 -0500
Message-ID: <462E00DA.3040701@linux.vnet.ibm.com>
References: <462DB9DB.3020308@flex.ro>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35714 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161126AbXDXNGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2007 09:06:38 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3OD6Zix007910
	for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2007 09:06:35 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3OD6Z8O524810
	for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2007 09:06:35 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3OD6ZFd025553
	for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2007 09:06:35 -0400
In-Reply-To: <462DB9DB.3020308@flex.ro>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brailateo@gmail.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Copying linux-scsi...

-Brian

Constantin Teodorescu wrote:
> Hello, I hope I can get a little help from you regarding this kind of 
> crash !
> 
> Hardware:
>  - server, TYAN Tempest i5000VS S5372 BIOS v1.0.4
>  - 8 SATA drives Seagate 136 Gb attached on a AIC-9410 controller
>  - one IDE (boot disk and system)
>  - 8 Gb RAM
> 
> Software:
>  - OpenSUSE 10.2 x86_64 (tried also with SLES 10 but didn't succed in 
> compiling adp94xx driver from Adaptec)
> 
> Kernels: i tried with any  of them : linux-2.6.20.1 ,  linux-2.6.20.4 ,  
> linux-2.6.20.7 , linux-2.6.21.rc7
> The last one has the 1.0.3 version of aic94xx driver but the results are 
> the same :-(
> 
> Description:
> - the server is running a very heavy loaded PostgreSQL database with 
> tables spread on those SAS drives, a lot of writes and reads
> - at least 4, 5 times a day I got some warnings in /var/log/messages 
> (sas: Enter sas_scsi_recover_host , trying to find task XXX ---> 
> aic94xx: came back from clear nexus) but the system is still working
> - more rarely (once per day) I got the following bug in 
> /var/log/messages and the system is crashed, SAS drivers are not working 
> anymore, shutdown command is waiting forever, need to hardware reset the 
> system
> 
> 
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff8101c9f5e2c0, task 
> 0xffff81005bfcb080, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff810047f9dd00, task 
> 0xffff81007df80cc0, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff810164d31180, task 
> 0xffff8101247ad500, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81021b8af380, task 
> 0xffff81012e550ac0, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff8101698c3940, task 
> 0xffff8101a3b69b80, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81011e865680, task 
> 0xffff8101a3b69380, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81000ce37340, task 
> 0xffff8101a3b69580, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff810164d31a40, task 
> 0xffff810058a93dc0, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff8100bc25b940, task 
> 0xffff81005bfcbc80, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81000ce37880, task 
> 0xffff81015856bd00, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81022fa2f940, task 
> 0xffff8101d2cf87c0, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff8100bc25b080, task 
> 0xffff81005bfcb880, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81000ce37dc0, task 
> 0xffff8101d186a940, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81009c620640, task 
> 0xffff81010d46a940, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff8100531ae1c0, task 
> 0xffff81012e9bf4c0, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff8100531ae380, task 
> 0xffff8101d186a740, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81011e8654c0, task 
> 0xffff8101247ad100, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81009c620480, task 
> 0xffff81012e5502c0, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81000ce37180, task 
> 0xffff8101d2cf89c0, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81017d5268c0, task 
> 0xffff8101d186a540, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff8101c9f5e800, task 
> 0xffff81015856b900, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81014f8db600, task 
> 0xffff81007df808c0, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81011e865bc0, task 
> 0xffff81012e550cc0, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: command 0xffff81009c620100, task 
> 0xffff8101a3b69980, timed out: EH_NOT_HANDLED
> Apr 24 07:22:20 bnd kernel: sas: Enter sas_scsi_recover_host
> Apr 24 07:22:20 bnd kernel: sas: trying to find task 0xffff81005bfcb080
> Apr 24 07:22:20 bnd kernel: sas: sas_scsi_find_task: aborting task 
> 0xffff81005bfcb080
> Apr 24 07:22:25 bnd kernel: aic94xx: tmf timed out
> Apr 24 07:22:25 bnd kernel: aic94xx: tmf came back
> Apr 24 07:22:25 bnd kernel: aic94xx: task not done, clearing nexus
> Apr 24 07:22:25 bnd kernel: aic94xx: asd_clear_nexus_index: PRE
> Apr 24 07:22:25 bnd kernel: aic94xx: asd_clear_nexus_index: POST
> Apr 24 07:22:25 bnd kernel: aic94xx: asd_clear_nexus_index: clear nexus 
> posted, waiting...
> Apr 24 07:22:30 bnd kernel: aic94xx: asd_clear_nexus_timedout: here
> Apr 24 07:22:35 bnd kernel: aic94xx: came back from clear nexus
> Apr 24 07:22:35 bnd kernel: aic94xx: task not done, clearing nexus
> Apr 24 07:22:35 bnd kernel: aic94xx: asd_clear_nexus_index: PRE
> Apr 24 07:22:35 bnd kernel: aic94xx: asd_clear_nexus_index: POST
> Apr 24 07:22:35 bnd kernel: aic94xx: asd_clear_nexus_index: clear nexus 
> posted, waiting...
> Apr 24 07:22:35 bnd kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
> Apr 24 07:22:35 bnd kernel: aic94xx: asd_clear_nexus_tasklet_complete: 
> opcode: 0x0
> Apr 24 07:22:40 bnd kernel: aic94xx: came back from clear nexus
> Apr 24 07:22:40 bnd kernel: ------------[ cut here ]------------
> Apr 24 07:22:40 bnd kernel: kernel BUG at 
> drivers/scsi/aic94xx/aic94xx_hwi.h:354!
> Apr 24 07:22:40 bnd kernel: invalid opcode: 0000 [1] SMP
> Apr 24 07:22:40 bnd kernel: CPU 0
> Apr 24 07:22:40 bnd kernel: Modules linked in: aic94xx libsas xfs
> Apr 24 07:22:40 bnd kernel: Pid: 3504, comm: scsi_eh_0 Not tainted 
> 2.6.21-rc7_RC7 #1
> Apr 24 07:22:40 bnd kernel: RIP: 0010:[<ffffffff88089f51>]  
> [<ffffffff88089f51>] :aic94xx:asd_abort_task+0x423/0x54a
> Apr 24 07:22:40 bnd kernel: RSP: 0000:ffff81023117fde0  EFLAGS: 00010287
> Apr 24 07:22:40 bnd kernel: RAX: 0000000000000000 RBX: ffff810231618000 
> RCX: ffff81022f66a800
> Apr 24 07:22:40 bnd kernel: RDX: ffffffff88089ebf RSI: ffff81005bfcb080 
> RDI: ffff81005bfcb098
> Apr 24 07:22:40 bnd kernel: RBP: 0000000000000000 R08: ffff81005bfcb080 
> R09: 0000000000000001
> Apr 24 07:22:40 bnd kernel: R10: ffffffff88089ea6 R11: ffff81013ba5bf80 
> R12: ffff81005bfcb080
> Apr 24 07:22:40 bnd kernel: R13: ffff810156e4f580 R14: ffff8101d49fb9c0 
> R15: ffff81022f66a800
> Apr 24 07:22:40 bnd kernel: FS:  0000000000000000(0000) 
> GS:ffffffff80712000(0000) knlGS:0000000000000000
> Apr 24 07:22:40 bnd kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 
> 000000008005003b
> Apr 24 07:22:40 bnd kernel: CR2: 00002b110eff3fe8 CR3: 00000001e75f6000 
> CR4: 00000000000006e0
> Apr 24 07:22:40 bnd kernel: Process scsi_eh_0 (pid: 3504, threadinfo 
> ffff81023117e000, task ffff810232274fe0)
> Apr 24 07:22:40 bnd kernel: Stack:  ffff81023117dac8 00000000c9f5e2c0 
> ffff81023117fe50 ffff81005bfcb080
> Apr 24 07:22:40 bnd kernel:  0000000000000000 ffff8101c9f5e2c0 
> ffff81005bfcb098 ffffffff88073293
> Apr 24 07:22:40 bnd kernel:  ffff810231618010 ffff81023046c000 
> ffff8102316181e0 ffff81023046c000
> Apr 24 07:22:40 bnd kernel: Call Trace:
> Apr 24 07:22:40 bnd kernel:  [<ffffffff88073293>] 
> :libsas:sas_scsi_recover_host+0x1c2/0x83b
> Apr 24 07:22:40 bnd kernel:  [<ffffffff8023f7d6>] 
> keventd_create_kthread+0x0/0x6d
> Apr 24 07:22:40 bnd kernel:  [<ffffffff80403b26>] 
> scsi_error_handler+0x6e/0x2d7
> Apr 24 07:22:40 bnd kernel:  [<ffffffff80403ab8>] 
> scsi_error_handler+0x0/0x2d7
> Apr 24 07:22:40 bnd kernel:  [<ffffffff8023fa46>] kthread+0xd1/0x103
> Apr 24 07:22:40 bnd kernel:  [<ffffffff8020a148>] child_rip+0xa/0x12
> Apr 24 07:22:40 bnd kernel:  [<ffffffff8023f7d6>] 
> keventd_create_kthread+0x0/0x6d
> Apr 24 07:22:40 bnd kernel:  [<ffffffff8023c327>] run_workqueue+0x10/0x179
> Apr 24 07:22:40 bnd kernel:  [<ffffffff8023f975>] kthread+0x0/0x103
> Apr 24 07:22:40 bnd kernel:  [<ffffffff8020a13e>] child_rip+0x0/0x12
> Apr 24 07:22:40 bnd kernel:
> Apr 24 07:22:40 bnd kernel:
> Apr 24 07:22:40 bnd kernel: Code: 0f 0b eb fe 48 8d bb 68 4b 00 00 e8 38 
> df 4a f8 41 8b 95 d0
> Apr 24 07:22:40 bnd kernel: RIP  [<ffffffff88089f51>] 
> :aic94xx:asd_abort_task+0x423/0x54a
> Apr 24 07:22:40 bnd kernel:  RSP <ffff81023117fde0>
> 
> -------------------------------------------------------------------------------------------------------------------------------- 
> 
> I tried to fetch and compile the 
> Adaptec_adp94xx-OpenBuild-B11662.i386.rpm driver from adaptec but got a 
> lot of stupid compile errors.
> Is there anything that I can do in order to make it work ? Would you 
> need more information that could help you understand the problem?
> Please Cc: me at    brailateo@gmail.com
> 
> Big , BIG, BIG thanks in advance !
> Constantin Teodorescu
> ROMANIA
> 
> 


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
