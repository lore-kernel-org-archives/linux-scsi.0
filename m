From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SMP pass through interface via bsg
Date: Mon, 02 Apr 2007 11:02:01 -0500
Message-ID: <1175529721.3680.18.camel@mulgrave.il.steeleye.com>
References: <20070402110125U.fujita.tomonori@lab.ntt.co.jp>
	 <1175486263.27675.11.camel@mulgrave.il.steeleye.com>
	 <20070402214325Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59385 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933094AbXDBQCk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 12:02:40 -0400
In-Reply-To: <20070402214325Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@infradead.org, dougg@torque.net, James.Smart@Emulex.Com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Mon, 2007-04-02 at 21:43 +0900, FUJITA Tomonori wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> > If you post the code, others who also have the hardware can try it
> > too ...
> 
> I've attached a patch against Jens' bsg tree and uploaed a patch
> against the sgv4-tools tree:
> 
> http://zaal.org/bsg/smp-test.diff
> 
> The sgv4-tools tree is at:
> 
> http://git.kernel.org/?p=linux/kernel/git/tomo/sgv4-tools.git;a=summary
> 
> 
> If everything works:
> 
> gazania:/sys/class/bsg# ls
> end_device-0:0  end_device-0:1  expander-0:0  sas_host0  sda  sdb
> 
> gazania:/home/fujita/sgv4-tools# ./smp_test /sys/class/bsg/expander-0\:0
> 
> 
> smp_test works like Doug's smp_rep_manufacturer.
> 
> Note that `smp_test /sys/class/bsg/expander-0\:0/` doesn't work.

Well, I get a lot further than Doug with aic94xx, but it still doesn't
quite work.  This is the console output:

sas_non_host_smp_fn 193
sas_smp_fn 172: 8 0804d000 4
BUG: sleeping function called from invalid context at mm/slab.c:3032
in_atomic():0, irqs_disabled():1
no locks held by smp_test/3102.
irq event stamp: 1234
hardirqs last  enabled at (1233): [<c01370b5>] debug_check_no_locks_freed+0xa5/0x1c0
hardirqs last disabled at (1234): [<c02d906f>] _spin_lock_irq+0xf/0x40
softirqs last  enabled at (0): [<c011878d>] copy_process+0x2dd/0x11c0
softirqs last disabled at (0): [<00000000>] 0x0
 [<c0103b0a>] show_trace_log_lvl+0x1a/0x30
 [<c0104182>] show_trace+0x12/0x20
 [<c0104236>] dump_stack+0x16/0x20
 [<c0113829>] __might_sleep+0xb9/0xd0
 [<c0164448>] __kmalloc_track_caller+0xd8/0x110
 [<c0150799>] __kzalloc+0x19/0x50
 [<f88f3a6f>] sas_smp_request+0x3f/0x130 [libsas]
 [<f88d474f>] sas_smp_fn+0x8f/0xd0 [scsi_transport_sas]
 [<f88d53e0>] sas_non_host_smp_fn+0x60/0x70 [scsi_transport_sas]
 [<c01b48b1>] elv_insert+0x91/0x160
 [<c01b49dd>] __elv_add_request+0x5d/0xb0
 [<c01b7b82>] blk_execute_rq_nowait+0x52/0xa0
 [<c01b7c65>] blk_execute_rq+0x95/0xe0
 [<c01bd053>] bsg_ioctl+0x133/0x1b0
 [<c017308b>] do_ioctl+0x6b/0x80
 [<c01730f7>] vfs_ioctl+0x57/0x2a0
 [<c0173379>] sys_ioctl+0x39/0x60
 [<c0102b08>] syscall_call+0x7/0xb
 =======================
sas: smp_execute_task: task to dev 500605b000001450 response: 0x0 status 0x82
sas: smp_execute_task: task to dev 500605b000001450 response: 0x0 status 0x82
sas: smp_execute_task: task to dev 500605b000001450 response: 0x0 status 0x82

The first huge dump is just complaining about a kzalloc GFP_KERNEL with irqs off in sas_smp_request.

I'll debug why the execute_task is failing when I get more time today.

James


