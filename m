From: Andrew Morton <akpm@digeo.com>
Subject: Re: Possible explanation for SCSI benchmark problems in 2.5
Date: Sun, 29 Sep 2002 13:53:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D976864.65C82D7B@digeo.com>
References: <200209292048.g8TKmN424799@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id NAA13207
	for <linux-scsi@vger.kernel.org>; Sun, 29 Sep 2002 13:53:59 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

James Bottomley wrote:
> 
> Hi All,
> 
> While looking at other code (OK, how to get the MCA drivers not to use bounce
> buffers...)  I discovered that the way scsi_scan.c calls
> scsi_initialize_merge_fn() guarantees (on an x86) that the
> blk_queue_bounce_limit is always called with BLK_BOUNCE_HIGH.  This will
> probably hurt benchmarks on machines with 1Gb or more of memory.
> 
> The problem is that scsi_initialize_merge_fn() checks sdev->type, but this is
> always -1 in scsi_alloc_sdev, and thus it never uses the pci dma mask for disk
> devices.
> 
> The attached patch moves the initialisation to after sdev->type has the
> correct value.
> 

argh, sorry.  I've had such a patch in my tree for ages, and
I do all testing with it in place.

But high-IO is bust for IDE as well at present, so at least
we're being fair ;)
