From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Oops on scsi_remove_target
Date: Fri, 26 Aug 2005 14:37:58 -0700
Message-ID: <20050826213758.GQ22320@plap.qlogic.org>
References: <430F8637.2060202@xfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:3102 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1030244AbVHZVh6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 17:37:58 -0400
Content-Disposition: inline
In-Reply-To: <430F8637.2060202@xfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Lord <lord@xfs.org>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 26 Aug 2005, Stephen Lord wrote:

> Running 2.6.12 (or one of several descendents of it), someone just let
> loose a new device on our fabric, it is causing one of our hosts no
> end of grief:
> 
> scsi: unknown device type 12
>   Vendor: ADIC      Model: SNC               Rev: 42dF
>   Type:   RAID                               ANSI SCSI revision: 03
> qla2300 0000:18:01.1: Waiting for LIP to complete...
> qla2300 0000:18:01.1: LIP reset occured (f7f7).
> qla2300 0000:18:01.1: LOOP UP detected (2 Gbps).
> qla2300 0000:18:01.1: Topology - (F_Port), Host Loop address 0xffff
> qla2300 0000:18:01.0: scsi(3:16:1): Abort command issued -- 197 2002.
> 
> and a while later:
> 
> Starting udev:  Unable to handle kernel NULL pointer dereference at 
> virtual address 0000004c
>  printing eip:
> *pde = 00000000
> Oops: 0000 [#1]
> SMP
> Modules linked in: sg qla2300 qla2xxx scsi_transport_fc aic7xxx 
> scsi_transport_spi sd_mod scsi_mod
> CPU:    2
> EIP:    0060:[<c0191fe3>]    Not tainted VLI
> EFLAGS: 00010282   (2.6.12-kdb)
> EIP is at sysfs_hash_and_remove+0xc/0xfe
> eax: 00000000   ebx: f7e096b0   ecx: 00000000   edx: f885f6b4
> esi: f7e096a8   edi: f885f6ac   ebp: f7feee68   esp: f7feee4c
> ds: 007b   es: 007b   ss: 0068
> Process events/2 (pid: 12, threadinfo=f7fee000 task=f7fef530)
> Stack: 00000002 00000180 f7e09400 00000000 f7e096b0 f7e096a8 f885f6ac 
> f7feee78
>        c0193aaa 00000000 c02f41fe f7feee9c c0227691 f7e096b0 c02f41fe 
> f885f640
>        f885f6b4 f7e096a8 c1a1fff8 c1a20030 f7feeeac c0227702 f7e096a8 
> f7e09400
> Call Trace:
>  [<c0103ec2>] show_stack+0x9a/0xd0
>  [<c010408d>] show_registers+0x175/0x209
>  [<c01042ac>] die+0xfa/0x19c
>  [<c0115200>] do_page_fault+0x239/0x6ee
>  [<c0103ad7>] error_code+0x4f/0x54
>  [<c0193aaa>] sysfs_remove_link+0x1b/0x1d
>  [<c0227691>] class_device_del+0x8e/0xed
>  [<c0227702>] class_device_unregister+0x12/0x20
>  [<f884d083>] scsi_remove_device+0x4e/0x97 [scsi_mod]
>  [<f884d156>] __scsi_remove_target+0x8a/0xc9 [scsi_mod]
>  [<f884d1b6>] __remove_child+0x21/0x29 [scsi_mod]
>  [<c02255bb>] device_for_each_child+0x32/0x53
>  [<f884d209>] scsi_remove_target+0x4b/0x5a [scsi_mod]
>  [<f883bc54>] fc_timeout_blocked_rport+0x4f/0x55 [scsi_transport_fc]

Hmm, could you try one of the latest 2.6.13-rcs, I believe this was
recently addressed.

--
AV
