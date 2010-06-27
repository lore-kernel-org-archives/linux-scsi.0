From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Sun, 27 Jun 2010 10:16:40 -0400
Message-ID: <20100627141638.GD3970@redhat.com>
References: <20100627185927K.fujita.tomonori@lab.ntt.co.jp>
 <20100627193253P.fujita.tomonori@lab.ntt.co.jp>
 <20100627110712.GA14511@lst.de>
 <20100627212952D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab0F0ORH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2010 10:17:07 -0400
Content-Disposition: inline
In-Reply-To: <20100627212952D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@lst.de, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Sun, Jun 27 2010 at  8:32am -0400,
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Sun, 27 Jun 2010 13:07:12 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > > How about this?
> > 
> > As I tried to explain before this utterly confuses the I/O completion
> > path.  With the patch applied even a simple mkfs.xfs that issues discard
> > just hangs.
> 
> Wired. I just tried mkfs.xfs against scsi_debug with my block patches
> (I saw one discard command). Seemed that it worked fine.

My leak fixes have been tested extensively against all permuations of
devices with discards (ATA trim, SCSI UNMAP, SCSI WRTIE SAME w/ unmap=1).

I think we need to get Christoph's discard payload transformation
complete by fixing the leaks _without_ trying to rework how discard
commands are tagged, etc.  E.g. fix what Jens already has staged in
linux-2.6-block's 'for-next' and 'for-2.6.36'.

With that sorted out we can then look at longer term changes to cleanup
discard request processing.

Regards,
Mike
