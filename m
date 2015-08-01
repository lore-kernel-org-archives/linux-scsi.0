From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: blk-mq vs kmemleak
Date: Fri, 31 Jul 2015 17:37:02 -0700
Message-ID: <55BC14AE.3090200@sandisk.com>
References: <20150703161137.GA10438@codemonkey.org.uk>
 <5596C080.4050009@sandisk.com>
 <20150707103323.GA13228@e104818-lin.cambridge.arm.com>
 <559BDB49.70209@sandisk.com> <20150708081740.GA3374@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0087.outbound.protection.outlook.com ([157.56.111.87]:49812
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751891AbbHAAhH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 20:37:07 -0400
In-Reply-To: <20150708081740.GA3374@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Dave Jones <davej@codemonkey.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/08/2015 01:17 AM, Christoph Hellwig wrote:
> On Tue, Jul 07, 2015 at 06:59:37AM -0700, Bart Van Assche wrote:
>> Please note that my test was run with CONFIG_SLUB_DEBUG=y which causes a red
>> zone to be allocated before and after each block of allocated memory. Could
>> that explain the kmalloc-96 objects ?
>
> 96 is almost guaranteed to be the sense buffer allocated in
> scsi_init_request and freed in scsi_exit_request.

Hello Catalin and Christoph,

kmemleak still reports large numbers of unreferenced objects for the 
scsi-mq code with the v4.2-rc4 kernel even with the recently posted 
scsi-mq leak fix applied on top of v4.2-rc4. Here is an example of one 
such report:

unreferenced object 0xffff88045e05dc28 (size 96):
   comm "srp_daemon", pid 8461, jiffies 4294973034 (age 742.350s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff814f2ede>] kmemleak_alloc+0x4e/0xb0
     [<ffffffff811b0678>] kmem_cache_alloc_trace+0xc8/0x2d0
     [<ffffffffa006cc37>] scsi_init_request+0x27/0x40 [scsi_mod]
     [<ffffffff81278b91>] blk_mq_init_rq_map+0x1d1/0x260
     [<ffffffff81278cc4>] blk_mq_alloc_tag_set+0xa4/0x1f0
     [<ffffffffa006fb0d>] scsi_mq_setup_tags+0xcd/0xd0 [scsi_mod]
     [<ffffffffa0066464>] scsi_add_host_with_dma+0x74/0x2e0 [scsi_mod]
     [<ffffffffa0478e12>] srp_create_target+0xe12/0x1320 [ib_srp]
     [<ffffffff8138a728>] dev_attr_store+0x18/0x30
     [<ffffffff812371f8>] sysfs_kf_write+0x48/0x60
     [<ffffffff812367f4>] kernfs_fop_write+0x144/0x190
     [<ffffffff811bdaf8>] __vfs_write+0x28/0xe0
     [<ffffffff811be1a9>] vfs_write+0xa9/0x190
     [<ffffffff811bef09>] SyS_write+0x49/0xa0
     [<ffffffff815022f2>] entry_SYSCALL_64_fastpath+0x16/0x7a
     [<ffffffffffffffff>] 0xffffffffffffffff

Thanks,

Bart.
