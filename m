From: Badari Pulavarty <badari@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Wed, 30 Oct 2002 09:39:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210301739.g9UHdDU12308@eng2.beaverton.ibm.com>
References: <20021027215433.GA30429@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021027215433.GA30429@suse.de> from "Jens Axboe" at Oct 27, 2002 09:54:33 PM PST
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Badari Pulavarty <pbadari@us.ibm.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Doug Ledford <dledford@redhat.com>

Hi,

I still get panics while doing filesystem IO on -mm kernels (with
qlogic fc). I get following msgs before getting the panic:

Incorrect number of segments after building list
counted 3, received 2
req nr_sec 256, cur_nr_sec 8

So I debugged why this is happening. Here is the bottom line:

bio->bi_phys_segments calculated by blk_recount_segments()
is not matching the number of sg elements used by blk_rq_map_sg().

I am doing 128K IO. In the following debug output, my pages in the 
IO except for the first one are contiguous. Since q->max_segment_size = 64K,
it is using 3 sg elememnts - which is correct. 

But blk_recount_segments() is not incrementing bio->bi_phys_segments 
due to the BIOVEC_VIRT_MERGEABLE() check. It always fails and
it creats a new segment all the time. (which does not increment
bi_phys_segments).

What does BIOVEC_VIRT_MERGEABLE() supposed to do ? I am guessing
it is supposed to restrict IO crossing 4GB boundary. Is it correct ?


- Badari

Here is the debug output:

blk_recount_segments():
=======================

counted 3, received 2
req nr_sec 256, cur_nr_sec 8
>>>>> made a new seg:1 (c2f76718, 4096, 0)
Loop: brvprv:c2f76718 bvec:c2f77780 offset:0 len:4096
>>>>> made a new seg:2 (c2f77780, 4096, 0)
Loop: brvprv:c2f77780 bvec:c2f777a8 offset:0 len:4096
Loop: brvprv:c2f777a8 bvec:c2f777d0 offset:0 len:4096
Loop: brvprv:c2f777d0 bvec:c2f777f8 offset:0 len:4096
Loop: brvprv:c2f777f8 bvec:c2f77820 offset:0 len:4096
Loop: brvprv:c2f77820 bvec:c2f77848 offset:0 len:4096
Loop: brvprv:c2f77848 bvec:c2f77870 offset:0 len:4096
Loop: brvprv:c2f77870 bvec:c2f77898 offset:0 len:4096
Loop: brvprv:c2f77898 bvec:c2f778c0 offset:0 len:4096
Loop: brvprv:c2f778c0 bvec:c2f778e8 offset:0 len:4096
Loop: brvprv:c2f778e8 bvec:c2f77910 offset:0 len:4096
Loop: brvprv:c2f77910 bvec:c2f77938 offset:0 len:4096
Loop: brvprv:c2f77938 bvec:c2f77960 offset:0 len:4096
Loop: brvprv:c2f77960 bvec:c2f77988 offset:0 len:4096
Loop: brvprv:c2f77988 bvec:c2f779b0 offset:0 len:4096
Loop: brvprv:c2f779b0 bvec:c2f779d8 offset:0 len:4096
>>>>> made a new seg:3 (c2f77a00, 4096, 0)
Loop: brvprv:c2f77a00 bvec:c2f77a28 offset:0 len:4096
Loop: brvprv:c2f77a28 bvec:c2f77a50 offset:0 len:4096
Loop: brvprv:c2f77a50 bvec:c2f77a78 offset:0 len:4096
Loop: brvprv:c2f77a78 bvec:c2f77aa0 offset:0 len:4096
Loop: brvprv:c2f77aa0 bvec:c2f77ac8 offset:0 len:4096
Loop: brvprv:c2f77ac8 bvec:c2f77af0 offset:0 len:4096
Loop: brvprv:c2f77af0 bvec:c2f77b18 offset:0 len:4096
Loop: brvprv:c2f77b18 bvec:c2f77b40 offset:0 len:4096
Loop: brvprv:c2f77b40 bvec:c2f77b68 offset:0 len:4096
Loop: brvprv:c2f77b68 bvec:c2f77b90 offset:0 len:4096
Loop: brvprv:c2f77b90 bvec:c2f77bb8 offset:0 len:4096
Loop: brvprv:c2f77bb8 bvec:c2f77be0 offset:0 len:4096
Loop: brvprv:c2f77be0 bvec:c2f77c08 offset:0 len:4096
Loop: brvprv:c2f77c08 bvec:c2f77c30 offset:0 len:4096
>>>>> returning segs:3


blk_recount_segments():
======================
===>>>>> made a new seg phys:1 hw:1 
=== Loop: brvprv:c2f76718 bvec:c2f77780 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:2 
=== Loop: brvprv:c2f77780 bvec:c2f777a8 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:3 
=== Loop: brvprv:c2f777a8 bvec:c2f777d0 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:4 
=== Loop: brvprv:c2f777d0 bvec:c2f777f8 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:5 
=== Loop: brvprv:c2f777f8 bvec:c2f77820 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:6 
=== Loop: brvprv:c2f77820 bvec:c2f77848 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:7 
=== Loop: brvprv:c2f77848 bvec:c2f77870 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:8 
=== Loop: brvprv:c2f77870 bvec:c2f77898 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:9 
=== Loop: brvprv:c2f77898 bvec:c2f778c0 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:10 
=== Loop: brvprv:c2f778c0 bvec:c2f778e8 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:11 
=== Loop: brvprv:c2f778e8 bvec:c2f77910 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:12 
=== Loop: brvprv:c2f77910 bvec:c2f77938 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:13 
=== Loop: brvprv:c2f77938 bvec:c2f77960 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:14 
=== Loop: brvprv:c2f77960 bvec:c2f77988 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:15 
=== Loop: brvprv:c2f77988 bvec:c2f779b0 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:16 
=== Loop: brvprv:c2f779b0 bvec:c2f779d8 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:17 
=== Loop: brvprv:c2f779d8 bvec:c2f77a00 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:18 
=== Loop: brvprv:c2f77a00 bvec:c2f77a28 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:19 
=== Loop: brvprv:c2f77a28 bvec:c2f77a50 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:20 
=== Loop: brvprv:c2f77a50 bvec:c2f77a78 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:21 
=== Loop: brvprv:c2f77a78 bvec:c2f77aa0 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:22 
=== Loop: brvprv:c2f77aa0 bvec:c2f77ac8 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:23 
=== Loop: brvprv:c2f77ac8 bvec:c2f77af0 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:24 
=== Loop: brvprv:c2f77af0 bvec:c2f77b18 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:25 
=== Loop: brvprv:c2f77b18 bvec:c2f77b40 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:26 
=== Loop: brvprv:c2f77b40 bvec:c2f77b68 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:27 
=== Loop: brvprv:c2f77b68 bvec:c2f77b90 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:28 
=== Loop: brvprv:c2f77b90 bvec:c2f77bb8 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:29 
=== Loop: brvprv:c2f77bb8 bvec:c2f77be0 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:30 
=== Loop: brvprv:c2f77be0 bvec:c2f77c08 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:31 
=== Loop: brvprv:c2f77c08 bvec:c2f77c30 offset:0 len:4096
===>>>>> Going to make a new seg BIOVEC_VIRT_MERGEABLE failed
===>>>>> made a new seg phys:2 hw:32 
blk_recount_segments  phys: 2 hw:32
