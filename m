From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block devices: validate block device capacity
Date: Thu, 30 Jan 2014 14:49:23 -0800
Message-ID: <1391122163.2181.103.camel@dabdike.int.hansenpartnership.com>
References: <alpine.LRH.2.02.1401301531040.29912@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1401301531040.29912@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Nick Piggin <npiggin@kernel.dk>, "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-01-30 at 15:40 -0500, Mikulas Patocka wrote:
> When running the LVM2 testsuite on 32-bit kernel, there are unkillable
> processes stuck in the kernel consuming 100% CPU:
> blkid           R running      0  2005   1409 0x00000004
> ce009d00 00000082 ffffffcf c11280ba 00000060 560b5dfd 00003111 00fe41cb
> 00000000 ce009d00 00000000 d51cfeb0 00000000 0000001e 00000002 ffffffff
> 00000002 c10748c1 00000002 c106cca4 00000000 00000000 ffffffff 00000000
> Call Trace:
> [<c11280ba>] ? radix_tree_next_chunk+0xda/0x2c0
> [<c10748c1>] ? release_pages+0x61/0x160
> [<c106cca4>] ? find_get_pages+0x84/0x100
> [<c1251fbe>] ? _cond_resched+0x1e/0x40
> [<c10758cb>] ? truncate_inode_pages_range+0x12b/0x440
> [<c1075cb7>] ? truncate_inode_pages+0x17/0x20
> [<c10cf2ba>] ? __blkdev_put+0x3a/0x140
> [<c10d02db>] ? blkdev_close+0x1b/0x40
> [<c10a60b2>] ? __fput+0x72/0x1c0
> [<c1039461>] ? task_work_run+0x61/0xa0
> [<c1253b6f>] ? work_notifysig+0x24/0x35
> 
> This is caused by the fact that the LVM2 testsuite creates 64TB device.
> The kernel uses "unsigned long" to index pages in files and block devices,
> on 64TB device "unsigned long" overflows (it can address up to 16TB with
> 4k pages), causing the infinite loop.

Why is this?  the whole reason for CONFIG_LBDAF is supposed to be to
allow 64 bit offsets for block devices on 32 bit.  It sounds like
there's somewhere not using sector_t ... or using it wrongly which needs
fixing.

> On 32-bit architectures, we must limit block device size to
> PAGE_SIZE*(2^32-1).

So you're saying CONFIG_LBDAF can never work, why?

James



