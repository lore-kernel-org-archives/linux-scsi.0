From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] [scsi]: Add offline state checking while dispatch a
	scsi cmd
Date: Sun, 11 Mar 2007 10:21:23 -0500
Message-ID: <1173626483.3420.3.camel@mulgrave.il.steeleye.com>
References: <20070308092207.GA17141@joejin-pc.cn.oracle.com>
	 <1173369759.3683.1.camel@mulgrave.il.steeleye.com>
	 <20070309014040.GA6632@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53375 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933749AbXCKPVk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Mar 2007 11:21:40 -0400
In-Reply-To: <20070309014040.GA6632@joejin-pc.cn.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Jin <joe.jin@oracle.com>
Cc: akpm@osdl.org, dgilbert@interlog.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, haobo.zhou@oracle.com

On Fri, 2007-03-09 at 09:40 +0800, Joe Jin wrote:
> > What's the error you're trying to fix?  scsi_dispatch_cmd() is only
> > called from scsi_request_fn() which already has an equivalent of this
> > check in it just prior to calling dispatch.
> 
> Yeah, I have saw the cheking at scsi_request_fn(), recently we got a crash
> info as following at rhel4 2.6.9-42.0.2.ELsmp,

This kernel is way to old to debug ...

However: 
> scsi0 (0:0): rejecting I/O to offline device
> ...
> EXT3-fs error (device sda8) in start_transaction: Journal has aborted
> 
> Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
> <ffffffffa0031e66>{:megaraid_mbox:megaraid_queue_command+2634}

This is a bug actually in the megaraid.

> PML4 21a25d067 PGD 2170ac067 PMD 0 
> Oops: 0002 [1] SMP 
> CPU 0 
> Modules linked in: hangcheck_timer mptctl mptbase ipmi_devintf ipmi_si ipmi_msghandler dell_rbu netconsole netdump autofs4 i2c_dev i2c_core ocfs2(U) debugfs(U) nfs lockd nfs_acl ocfs2_dlmfs(U) ocfs2_dlm(U) ocfs2_nodemanager(U) configfs(U) sunrpc ds yenta_socket pcmcia_core ide_dump scsi_dump diskdump zlib_deflate dm_mirror dm_multipath dm_mod emcphr(U) emcpmpap(U) emcpmpaa(U) emcpmpc(U) emcpmp(U) emcp(U) emcplib(U) button battery ac joydev uhci_hcd ehci_hcd hw_random tg3 e1000 bond0(U) floppy sg ext3 jbd lpfc scsi_transport_fc megaraid_mbox megaraid_mm sd_mod scsi_mod
> Pid: 13238, comm: emagent Tainted: P      2.6.9-42.0.2.ELsmp
> RIP: 0010:[<ffffffffa0031e66>] <ffffffffa0031e66>{:megaraid_mbox:megaraid_queue_command+2634}
> RSP: 0018:000001019b5a9b48  EFLAGS: 00010002
> RAX: 0000000220b8e000 RBX: 00000102ffd1b048 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000010431124bf0
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000010133ce5b80
> R10: 00000102ffd3e5a0 R11: 0000000000000060 R12: 0000010133ce5b80
> R13: 00000102ffd3e480 R14: 00000100bfb4c8b8 R15: 00000101ffcf4000
> FS:  0000000000000000(0000) GS:ffffffff804e5180(005b) knlGS:00000000f47ffbb0
> CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000101000 CR4: 00000000000006e0
> Process emagent (pid: 13238, threadinfo 000001019b5a8000, task 000001003e5a8030)
> Stack: 0000000000000000 0000000000000046 0000000000000046 00000102ffd3e480 
>        00000101fff73980 ffffffff8015cb38 00000100bfb4d4aa 00000100bfb4d4a2 
>        00000100bfb4c8b8 0000010100000080 
> Call Trace:<ffffffff8015cb38>{mempool_alloc+129} <ffffffffa0002874>{:scsi_mod:scsi_done+0} 
>        <ffffffff8013fc00>{__mod_timer+113} <ffffffffa0002adf>{:scsi_mod:scsi_dispatch_cmd+595} 
>        <ffffffffa0007a72>{:scsi_mod:scsi_request_fn+990} <ffffffff8024e385>{generic_unplug_device+24} 
>        <ffffffff8017a6d3>{__wait_on_buffer+120} <ffffffff8017a55e>{bh_wake_function+0} 
>        <ffffffff8017a55e>{bh_wake_function+0} <ffffffffa00877fe>{:ext3:ext3_bread+96} 
>        <ffffffffa008935c>{:ext3:htree_dirblock_to_tree+50} 
>        <ffffffffa008952c>{:ext3:ext3_htree_fill_tree+295} 
>        <ffffffff8018b232>{filldir64+122} <ffffffff8018b1b8>{filldir64+0} 
>        <ffffffffa0083ace>{:ext3:ext3_readdir+371} <ffffffff8018f019>{dput+56} 
>        <ffffffff8018b1b8>{filldir64+0} <ffffffff8018599c>{path_release+12} 
>        <ffffffff8019e335>{compat_sys_statfs+105} <ffffffff8018b1b8>{filldir64+0} 
>        <ffffffff8018aef7>{vfs_readdir+155} <ffffffff8018b2e8>{sys_getdents64+118} 
>        <ffffffff80125bbb>{sysenter_do_call+27} 

And this is a direct command submission path:  it already passed both
online check gates in this path *after* the device was offlined, so
adding a third won't fix this.  Firstly, I'm assuming you have only a
single disk, so the I/O was definitely bound for sda?  Secondly, can you
reproduce with a modern (2.6.20) kernel.  Your trace strongly suggests
that the device came back online for some reason and then the megaraid
driver died.

James


