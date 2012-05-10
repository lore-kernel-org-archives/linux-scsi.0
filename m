From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/6] fcoe: Don't hold rtnl_mutex in fcoe_update_src_mac
Date: Thu, 10 May 2012 08:53:15 +0100
Message-ID: <1336636395.5323.7.camel@dabdike>
References: <20120420191620.4634.94869.stgit@localhost6.localdomain6>
	 <20120420191643.4634.91026.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52898 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401Ab2EJIfy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2012 04:35:54 -0400
In-Reply-To: <20120420191643.4634.91026.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

On Fri, 2012-04-20 at 12:16 -0700, Robert Love wrote:
> The rtnl_mutex was held to protect calls to dev_uc_add
> and dev_uc_del. Holding rtnl is not required as those
> functions make use of the netif_addr_lock* API to
> protect the MAC changing.
> 
> This change fixes the following regression by removing
> the rtnl usage when fcoe_update_src_mac is called.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=42918
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&fip->ctlr_mutex){+.+...}:
>        [<c1091f70>] lock_acquire+0x80/0x1b0
>        [<c147655d>] mutex_lock_nested+0x6d/0x340
>        [<f8970c32>] fcoe_ctlr_link_up+0x22/0x180 [libfcoe]
>        [<f894620e>] fcoe_create+0x47e/0x6e0 [fcoe]
>        [<f8973dd3>] fcoe_transport_create+0x143/0x250 [libfcoe]
>        [<c10527e0>] param_attr_store+0x30/0x60
>        [<c1052696>] module_attr_store+0x26/0x40
>        [<c11a201e>] sysfs_write_file+0xae/0x100
>        [<c11449df>] vfs_write+0x8f/0x160
>        [<c1144cbd>] sys_write+0x3d/0x70
>        [<c147a0c4>] syscall_call+0x7/0xb
> 
> -> #0 (rtnl_mutex){+.+.+.}:
>        [<c109164b>] __lock_acquire+0x140b/0x1720
>        [<c1091f70>] lock_acquire+0x80/0x1b0
>        [<c147655d>] mutex_lock_nested+0x6d/0x340
>        [<c13a10c4>] rtnl_lock+0x14/0x20
>        [<f89445ac>] fcoe_update_src_mac+0x2c/0xb0 [fcoe]
>        [<f8971712>] fcoe_ctlr_timer_work+0x712/0xb60 [libfcoe]
>        [<c104fb69>] process_one_work+0x179/0x5d0
>        [<c10502f1>] worker_thread+0x121/0x2d0
>        [<c10550ed>] kthread+0x7d/0x90
>        [<c1481a82>] kernel_thread_helper+0x6/0x10
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&fip->ctlr_mutex);
>                                lock(rtnl_mutex);
>                                lock(&fip->ctlr_mutex);
>   lock(rtnl_mutex);
> 
>  *** DEADLOCK ***
> 
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> Nacked-by: Robert Love <robert.w.love@intel.com>

Nacked-by?  I'm assuming, since you signed off above, that you're
actually happy with the patch, and I just removed this line as some
accidental addition.

James


