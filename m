From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc requests and simplify hw handlers
Date: Tue, 7 Jun 2005 20:07:18 +0200
Message-ID: <20050607180716.GA8172@suse.de>
References: <1117847972.23638.62.camel@mina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:28294 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261878AbVFGSGV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2005 14:06:21 -0400
Content-Disposition: inline
In-Reply-To: <1117847972.23638.62.camel@mina>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jun 03 2005, Mike Christie wrote:
> The following patches should enable the use of scatter lists for all
> REQ_BLOCK_PC requests and cleanup some code duplication or dangerous
> memory allocations in the dm-multipath hw handlers and
> block/scsi_ioctl.c.
> 
> REQ_BLOCK_PC scatter list usage only required converting the old
> sg_scsi_ioctl code to do bio backed requests since the current block
> layer SG_IO code will always use requests with bios. But while
> converting the old ioctl and removing some dangerous (GFP_KERNEL in
> failover path) memory allocations from a dm-multipath hw_handler (and
> while updating the LSI one) I was able to seperate some common code into
> two new functions: blk_rq_map_kern() and bio_map_kern. These functions
> are similar to their blk/bio*user cousins where they allocate requests
> and bios and setup the data pointers except they work on kernel buffers.

Wonderful stuff, much needed for a long time.

> The goal is next convert the scsi 'special' requests to use these
> functions, so scsi will be able to use block layer functions for scatter
> lists setup for all requests. And then hopefully one day we will not
> need those stinking "if (sc->use_sg)" paths all over our scsi drivers.

I've slowly been doing the same thing in other places in the kernel and
this bit has been talked about between James and I for at least a year
or two.

-- 
Jens Axboe

