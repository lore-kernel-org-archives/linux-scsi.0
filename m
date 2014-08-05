From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/15] block copy: initial XCOPY offload support
Date: Tue, 5 Aug 2014 18:45:47 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1408051844070.23986@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1407151534180.14632@file01.intranet.prod.int.rdu2.redhat.com> <20140804140925.GA24261@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaHEWq0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2014 18:46:26 -0400
In-Reply-To: <20140804140925.GA24261@amd.pavel.ucw.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org



On Mon, 4 Aug 2014, Pavel Machek wrote:

> On Tue 2014-07-15 15:34:47, Mikulas Patocka wrote:
> > This is Martin Petersen's xcopy patch
> > (https://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/commit/?h=xcopy&id=0bdeed274e16b3038a851552188512071974eea8)
> > with some bug fixes, ported to the current kernel.
> > 
> > This patch makes it possible to use the SCSI XCOPY command.
> > 
> > We create a bio that has REQ_COPY flag in bi_rw and a bi_copy structure
> > that defines the source device. The target device is defined in the
> > bi_bdev and bi_iter.bi_sector.
> > 
> > There is a new BLKCOPY ioctl that makes it possible to use XCOPY from
> > userspace. The ioctl argument is a pointer to an array of four uint64_t
> > values.
> 
> But it is there only for block devices, right?
> 
> Is there plan to enable tools such as /bin/cp to use XCOPY?
> 
> 									Pavel

It is interesting idea, but it would be far from simple. You could make 
sendfile (or maybe splice) use XCOPY, but it needs to interact with page 
cache.

Mikulas
