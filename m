From: Joe Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] [scsi]: Add offline state checking while dispatch a scsi cmd
Date: Fri, 9 Mar 2007 09:40:40 +0800
Message-ID: <20070309014040.GA6632@joejin-pc.cn.oracle.com>
References: <20070308092207.GA17141@joejin-pc.cn.oracle.com> <1173369759.3683.1.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:57483 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992872AbXCIBmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Mar 2007 20:42:37 -0500
Content-Disposition: inline
In-Reply-To: <1173369759.3683.1.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Joe Jin <joe.jin@oracle.com>, akpm@osdl.org, dgilbert@interlog.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, haobo.zhou@oracle.com

> What's the error you're trying to fix?  scsi_dispatch_cmd() is only
> called from scsi_request_fn() which already has an equivalent of this
> check in it just prior to calling dispatch.

Yeah, I have saw the cheking at scsi_request_fn(), recently we got a crash
info as following at rhel4 2.6.9-42.0.2.ELsmp,

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
megaraid: aborting-150766876 cmd=2a <c=2 t=0 l=0>
megaraid abort: 150766876:15[255:128], fw owner
...
egaraid: aborting-150767541 cmd=2a <c=2 t=0 l=0>
megaraid abort: 150767541[255:128], driver owner
megaraid: resetting the host...
megaraid: 150766876:129[65535:65535], reset from pending list
megaraid: 1 outstanding commands. Max wait 180 sec
megaraid mbox: Wait for 1 commands to complete:180
...
megaraid mbox: Wait for 1 commands to complete:0
megaraid mbox: critical hardware error!
megaraid: resetting the host...
megaraid: hw error, cannot reset
megaraid: resetting the host...
megaraid: hw error, cannot reset
scsi: Device offlined - not ready after error recovery: host 0 channel 2 id 0 lun 0
SCSI error : <0 2 0 0> return code = 0x6000000
end_request: I/O error, dev sda, sector 24117409
Buffer I/O error on device sda5, logical block 327797
...
EXT3-fs error (device sda8) in start_transaction: Journal has aborted
scsi0 (0:0): rejecting I/O to offline device
printk: 85 messages suppressed.
Buffer I/O error on device sda5, logical block 327691
lost page write due to I/O error on sda5
scsi0 (0:0): rejecting I/O to offline device
...
EXT3-fs error (device sda8) in start_transaction: Journal has aborted

Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
<ffffffffa0031e66>{:megaraid_mbox:megaraid_queue_command+2634}
PML4 21a25d067 PGD 2170ac067 PMD 0 
Oops: 0002 [1] SMP 
CPU 0 
Modules linked in: hangcheck_timer mptctl mptbase ipmi_devintf ipmi_si ipmi_msghandler dell_rbu netconsole netdump autofs4 i2c_dev i2c_core ocfs2(U) debugfs(U) nfs lockd nfs_acl ocfs2_dlmfs(U) ocfs2_dlm(U) ocfs2_nodemanager(U) configfs(U) sunrpc ds yenta_socket pcmcia_core ide_dump scsi_dump diskdump zlib_deflate dm_mirror dm_multipath dm_mod emcphr(U) emcpmpap(U) emcpmpaa(U) emcpmpc(U) emcpmp(U) emcp(U) emcplib(U) button battery ac joydev uhci_hcd ehci_hcd hw_random tg3 e1000 bond0(U) floppy sg ext3 jbd lpfc scsi_transport_fc megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 13238, comm: emagent Tainted: P      2.6.9-42.0.2.ELsmp
RIP: 0010:[<ffffffffa0031e66>] <ffffffffa0031e66>{:megaraid_mbox:megaraid_queue_command+2634}
RSP: 0018:000001019b5a9b48  EFLAGS: 00010002
RAX: 0000000220b8e000 RBX: 00000102ffd1b048 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000010431124bf0
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000010133ce5b80
R10: 00000102ffd3e5a0 R11: 0000000000000060 R12: 0000010133ce5b80
R13: 00000102ffd3e480 R14: 00000100bfb4c8b8 R15: 00000101ffcf4000
FS:  0000000000000000(0000) GS:ffffffff804e5180(005b) knlGS:00000000f47ffbb0
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000101000 CR4: 00000000000006e0
Process emagent (pid: 13238, threadinfo 000001019b5a8000, task 000001003e5a8030)
Stack: 0000000000000000 0000000000000046 0000000000000046 00000102ffd3e480 
       00000101fff73980 ffffffff8015cb38 00000100bfb4d4aa 00000100bfb4d4a2 
       00000100bfb4c8b8 0000010100000080 
Call Trace:<ffffffff8015cb38>{mempool_alloc+129} <ffffffffa0002874>{:scsi_mod:scsi_done+0} 
       <ffffffff8013fc00>{__mod_timer+113} <ffffffffa0002adf>{:scsi_mod:scsi_dispatch_cmd+595} 
       <ffffffffa0007a72>{:scsi_mod:scsi_request_fn+990} <ffffffff8024e385>{generic_unplug_device+24} 
       <ffffffff8017a6d3>{__wait_on_buffer+120} <ffffffff8017a55e>{bh_wake_function+0} 
       <ffffffff8017a55e>{bh_wake_function+0} <ffffffffa00877fe>{:ext3:ext3_bread+96} 
       <ffffffffa008935c>{:ext3:htree_dirblock_to_tree+50} 
       <ffffffffa008952c>{:ext3:ext3_htree_fill_tree+295} 
       <ffffffff8018b232>{filldir64+122} <ffffffff8018b1b8>{filldir64+0} 
       <ffffffffa0083ace>{:ext3:ext3_readdir+371} <ffffffff8018f019>{dput+56} 
       <ffffffff8018b1b8>{filldir64+0} <ffffffff8018599c>{path_release+12} 
       <ffffffff8019e335>{compat_sys_statfs+105} <ffffffff8018b1b8>{filldir64+0} 
       <ffffffff8018aef7>{vfs_readdir+155} <ffffffff8018b2e8>{sys_getdents64+118} 
       <ffffffff80125bbb>{sysenter_do_call+27} 

Code: 48 89 04 11 41 8b 44 24 18 49 83 c4 20 49 8b 56 20 89 44 11 
RIP <ffffffffa0031e66>{:megaraid_mbox:megaraid_queue_command+2634} RSP <000001019b5a9b48>
CR2: 0000000000000000
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

full crash info have update to http://patch.linux-security.cn/crashinfo/megaraid_crashinfo.log

>From crashinfo, befor kernel panic, device have setting state to OFFLINE, but
at that time, scsi cmd still will send to device.

any advice?

-Joe
