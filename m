From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [patch for playing] 2.5.65 patch to support > 256 disks
Date: Fri, 28 Mar 2003 09:04:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303280904.41797.pbadari@us.ibm.com>
References: <200303211056.04060.pbadari@us.ibm.com> <200303261629.34868.pbadari@us.ibm.com> <20030327091854.GY30908@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030327091854.GY30908@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@digeo.com>, dougg@torque.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi All,

I found 2048-byte slab heavy users. 8MB doesn't seem much they all
add up.

size-2048       before:98 after:4095 diff:3997 size:2060 incr:8233820

The problem is with

	sd.c: sd_attach()
		 alloc_disk(16)

alloc_disk() allocates "hd_struct" structure for 15 minors. 
So it is a 84*15 = 1260 byte allocation. They all come from 
2048-byte slabs. Since I have 4000 simulated disks, it uses up 8MB.

Proposed fixes:

1) Make the allocations come from its own slab, instead of
2048-byte slab. (~40% saving).

2) Instead of allocatinf hd_struct structure for all possible partitions,
why not allocated them dynamically, as we see a partition ? This
way we could (in theory) support more than 16 partitions, if needed.

Are there any issues with doing (2) ? 

Thanks,
Badari
