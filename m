From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Kernel Panic When Using Multipath-Tools
Date: Thu, 13 Aug 2009 20:06:50 -0700
Message-ID: <1250219210.29449.2.camel@chandra-ubuntu>
References: <D9D8963FC28A1C49BBF5EE152BE97636020713EFE6@CBA0EXBE01.CBA0.centerbeam.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:44968 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbZHNDCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2009 23:02:43 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7E30kFG013388
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2009 21:00:46 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7E32ef9163818
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2009 21:02:40 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7E32dxC002048
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2009 21:02:40 -0600
In-Reply-To: <D9D8963FC28A1C49BBF5EE152BE97636020713EFE6@CBA0EXBE01.CBA0.centerbeam.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Paul Lung (paul.lung@loglogic.com)" <Paul.Lung@loglogic.com>
Cc: "christophe.varoqui@free.fr" <christophe.varoqui@free.fr>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Eddie Williams <Eddie.Williams@steeleye.com>, James Bottomley <jejb@kernel.org>

This looks like the problem repoted by Eddie Williams here:
http://marc.info/?l=dm-devel&m=124656334329954&w=2

and solved by the change here:

http://marc.info/?l=dm-devel&m=124809515303870&w=2

can you try it.

Eddie, what became of that patch ? has it been sent to James ?

chandra
On Thu, 2009-08-13 at 19:09 -0700, Paul Lung (paul.lung@loglogic.com)
wrote:
> Hi All,
> 
> I'm trying to use the multipath tools to enable multipath on an EMC Clariion AX4-5 storage array. The following is the information for my system:
> 
> Multipath-Tools Version:
>     multipath -v       
>     Missing option arguement
>     multipath-tools v0.4.8 (08/02, 2007)
> 
> Linux Kernel Version
>     Linux localhost 2.6.29.4-loglogic #2 SMP Thu Aug 6 19:02:01 PDT 2009 i686 GNU/Linux
> 
> The following kernel config has been turned on:
>     CONFIG_SCSI_DH=y
>     CONFIG_SCSI_DH_RDAC=y
>     CONFIG_SCSI_DH_HP_SW=y
>     CONFIG_SCSI_DH_EMC=y
>     CONFIG_SCSI_DH_ALUA=y
> 
> HBA Model: QLogic QLE2562
> 
> 
> 
> First I tried a dry run using multipath, with the following results:
> 
> Logapp root:~ 0$ multipath -d
> create: 3600050e05f325700345300002c820000 AMCC    ,9690SA-8I  DIS
> [size=1.4T][features=0][hwhandler=0]
> \_ round-robin 0 [prio=1][undef]
>  \_ 0:0:0:0 sda 8:0   [undef][ready]
> create: SATA_SEAGATE_ST35006_9QG953PN ATA     ,SEAGATE ST3500
> [size=466G][features=0][hwhandler=0]
> \_ round-robin 0 [prio=1][undef]
>  \_ 1:0:0:0 sdb 8:16  [undef][ready]
> create: SATA_SEAGATE_ST35006_9QG977GT ATA     ,SEAGATE ST3500
> [size=466G][features=0][hwhandler=0]
> \_ round-robin 0 [prio=1][undef]
>  \_ 2:0:0:0 sdc 8:32  [undef][ready]
> create: 36006016005f021002a26d6d7b84fde11 DGC     ,RAID 5        
> [size=1.4T][features=1 queue_if_no_path][hwhandler=1 emc]
> \_ round-robin 0 [prio=1][undef]
>  \_ 5:0:0:0 sdd 8:48  [undef][ready]
> \_ round-robin 0 [prio=0][undef]
>  \_ 6:0:0:0 sdj 8:144 [undef][ready]
> create: 36006016005f02100545f6b5aa74fde11 DGC     ,RAID 5        
> [size=1.4T][features=1 queue_if_no_path][hwhandler=1 emc]
> \_ round-robin 0 [prio=1][undef]
>  \_ 5:0:0:1 sde 8:64  [undef][ready]
> \_ round-robin 0 [prio=0][undef]
>  \_ 6:0:0:1 sdk 8:160 [undef][ready]
> create: 36006016005f02100b0dfd619b94fde11 DGC     ,RAID 5        
> [size=300G][features=1 queue_if_no_path][hwhandler=1 emc]
> \_ round-robin 0 [prio=1][undef]
>  \_ 5:0:0:2 sdf 8:80  [undef][ready]
> \_ round-robin 0 [prio=0][undef]
>  \_ 6:0:0:2 sdl 8:176 [undef][ready]
> create: 36006016005f0210016bb2544b84fde11 DGC     ,RAID 5        
> [size=300G][features=1 queue_if_no_path][hwhandler=1 emc]
> \_ round-robin 0 [prio=1][undef]
>  \_ 5:0:0:3 sdg 8:96  [undef][ready]
> \_ round-robin 0 [prio=0][undef]
>  \_ 6:0:0:3 sdm 8:192 [undef][ready]
> create: 36006016005f02100e89714f7b74fde11 DGC     ,RAID 5        
> [size=569G][features=1 queue_if_no_path][hwhandler=1 emc]
> \_ round-robin 0 [prio=1][undef]
>  \_ 5:0:0:4 sdh 8:112 [undef][ready]
> \_ round-robin 0 [prio=0][undef]
>  \_ 6:0:0:4 sdn 8:208 [undef][ready]
> create: 36006016005f02100a65b331ab84fde11 DGC     ,RAID 5        
> [size=1.2T][features=1 queue_if_no_path][hwhandler=1 emc]
> \_ round-robin 0 [prio=1][undef]
>  \_ 5:0:0:5 sdi 8:128 [undef][ready]
> \_ round-robin 0 [prio=0][undef]
>  \_ 6:0:0:5 sdo 8:224 [undef][ready]
> 
> 
> 
> Since it seems to recognize everything, I went ahead and created one multipath device:
> 
> Logapp root:~ 0$ multipath /dev/sdl
> create: 36006016005f02100b0dfd619b94fde11 DGC     ,RAID 5        
> [size=300G][features=1 queue_if_no_path][hwhandler=1 emc]
> \_ round-robin 0 [prio=1][undef]
>  \_ 5:0:0:2 sdf 8:80  [undef][ready]
> \_ round-robin 0 [prio=0][undef]
>  \_ 6:0:0:2 sdl 8:176 [undef][ready]
> 
> 
> 
> This created the device /dev/dm-3:
> 
> Logapp root:~ 0$ multipath -l
> 36006016005f02100b0dfd619b94fde11dm-3 DGC     ,RAID 5        
> [size=300G][features=1 queue_if_no_path][hwhandler=1 emc]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 5:0:0:2 sdf 8:80  [active][undef]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 6:0:0:2 sdl 8:176 [active][undef]
> 
> 
> 
> The kernel panic happens when I try to access /dev/dm-3, like using kpartx:
> 
> Logapp root:~ 0$ kpartx /dev/dm-3 
> 
> 
> 
> The kernel panic dumps the following to the console:
> 
> ------------[ cut here ]------------
> kernel BUG at block/cfq-iosched.c:2078!
> invalid opcode: 0000 [#1] SMP 
> last sysfs file: /sys/class/fc_transport/target6:0:0/node_name
> Modules linked in: iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter max6650 hwmon_vid i2c
> _piix4 i2c_dev coretemp bond0 i2c_i801 i2c_core qla2xxx
> 
> Pid: 1205, comm: kmpath_handlerd Not tainted (2.6.29.4-loglogic #2) ST2020_SAN
> EIP: 0060:[<c02caa77>] EFLAGS: 00010046 CPU: 1
> EIP is at cfq_put_request+0x47/0x50
> EAX: 00000000 EBX: f76fc0a0 ECX: c02caa30 EDX: 00000001
> ESI: f66efb1c EDI: f6454578 EBP: f687de9c ESP: f687de94
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kmpath_handlerd (pid: 1205, ti=f687c000 task=f752b540 task.ti=f687c000)
> Stack:
>  f76fc0a0 00282e4f f687dea4 c02bdd83 f687debc c02c036f 00002000 f6454578
>  f76fc0a0 00000292 f687ded0 c02c06cc f6065d04 f6065c04 f76fc0a0 f687df34
>  c03bbf34 00000001 c481d4b4 c4819e00 f687def4 c0124cf8 f752b540 c0522c80
> Call Trace:
>  [<c02bdd83>] ? elv_put_request+0x13/0x20
>  [<c02c036f>] ? __blk_put_request+0x7f/0x90
>  [<c02c06cc>] ? blk_put_request+0x2c/0x50
>  [<c03bbf34>] ? clariion_activate+0x114/0x420
>  [<c0124cf8>] ? dequeue_task_fair+0x28/0x40
>  [<c02ce032>] ? kobject_get+0x12/0x20
>  [<c03ba622>] ? scsi_dh_activate+0x92/0xa0
>  [<c0464593>] ? activate_path+0x43/0x160
>  [<c0464550>] ? activate_path+0x0/0x160
>  [<c013772d>] ? run_workqueue+0xad/0x140
>  [<c013809c>] ? worker_thread+0x5c/0xa0
>  [<c013aee0>] ? autoremove_wake_function+0x0/0x40
>  [<c0138040>] ? worker_thread+0x0/0xa0
>  [<c013abe2>] ? kthread+0x42/0x70
>  [<c013aba0>] ? kthread+0x0/0x70
>  [<c010398b>] ? kernel_thread_helper+0x7/0x1c
> Code: 83 e8 01 89 44 96 2c 8b 43 6c 8b 40 10 e8 c2 8d ff ff 89 f0 c7 43 6c 00 00 00 00 c7 43 70 00 00 00 00 e8 3d ff ff 
> ff 5b 5e 5d c3 <0f> 0b eb fe 90 8d 74 26 00 55 89 e5 83 ec 08 89 1c 24 89 d3 89 
> EIP: [<c02caa77>] cfq_put_request+0x47/0x50 SS:ESP 0068:f687de94
> ---[ end trace 4efc3c49e4977b31 ]---
> 
> 
> 
> Looking at the code, this situation seems to be specifically marked as a kernel bug. Can anyone please shed some light on this? Thank you very much in advance for your time and help.
> 
> Sincerely,
> 
> Paul Lung--
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

