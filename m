From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc requests
	and simplify hw handlers
Date: Tue, 07 Jun 2005 15:38:38 -0400
Message-ID: <1118173118.4791.17.camel@mulgrave>
References: <1117847972.23638.62.camel@mina> <20050607180716.GA8172@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:63173 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261982AbVFGUnO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 16:43:14 -0400
In-Reply-To: <20050607180716.GA8172@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2005-06-07 at 20:07 +0200, Jens Axboe wrote:
> I've slowly been doing the same thing in other places in the kernel and
> this bit has been talked about between James and I for at least a year
> or two.

Yes, it's long been a dream of mine to eliminate at least struct
scsi_request and just use block struct request for everything in the
SCSI layer.

The most pleasing aspect of this will be getting rid of the dma mapping
duplications in st and sg.

I'm still not sure we have it entirely correct, though.  Something still
needs to be done about the queue alignment constraints, so bio_copy_...
might need to be part of this API.

Also, Jens, this looks wrong (from ll_rw_blk.c around line 2131):

if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))

The alignment surely wants to be only on the start buffer (otherwise
we'll get spurious copies in variable length commands (like inquiries)?

James


