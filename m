From: Jens Axboe <axboe@suse.de>
Subject: Re: Fw: PROBLEM: Linux V. 2.6.3 panics with "Buffers at physical address >16Mb used for aha1542" at boot time
Date: Mon, 23 Feb 2004 20:04:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040223190422.GL32010@suse.de>
References: <20040218171212.0eb6618a.akpm@osdl.org> <1077243517.2164.61.camel@mulgrave> <1077265837.1297.9.camel@felicia> <20040220083808.GA11822@suse.de> <1077300620.1937.11.camel@mulgrave> <20040223164811.GK32010@suse.de> <1077557656.1759.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:6058 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262002AbUBWTEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 14:04:37 -0500
Content-Disposition: inline
In-Reply-To: <1077557656.1759.58.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Dr. Ernst Molitor" <molitor@uni-bonn.de>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Feb 23 2004, James Bottomley wrote:
> On Mon, 2004-02-23 at 10:48, Jens Axboe wrote:
> > Something half-assed like this should work as an immediate fix...
> 
> But I don't see how this bounces the buffer?  Without a bio, this simply
> passes req->data (which is cgc->buffer) into cmd->request_buffer in
> scsi_init_io(); but the problem was that this buffer is outside the
> dma_mask.

Duh you are right, I completely forgot about that. Well that really
settles the fact that it must be bio backed, and that use_sg should just
die in the same iteration.

It was a step in the wrong direction regardless, I'd love to kill ->data
eventually.

Anyways, I have another way to solve this without shaking
scsi_wait_req() up too much. The way I see it, you cannot implement what
you want there, you simply don't have access to everything you need to
make it possible. The best way is to add a few helpers to map to a (bio
backed) request and have sr/sd/st call these to set things up. I'll give
that a go.

-- 
Jens Axboe

