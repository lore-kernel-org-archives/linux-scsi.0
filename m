From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.14 RFC PATCH 0/2] dm rq: eliminate historic blk-mq and
 .request_fn queue stacking restrictions
Date: Fri, 14 Jul 2017 10:02:06 -0400
Message-ID: <20170714140206.GA18245@redhat.com>
References: <20170713211217.52361-1-snitzer@redhat.com>
 <20170714071257.GB17046@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170714071257.GB17046@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 14 2017 at  3:12am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Btw, we might want to expedite this to 4.13, a 4.13 now defaults
> to blk-mq for scsi, and this patch would make sure that dm keeps
> on just working with that switch.

Don't think we need to rush anything in response to that change in
SCSI's default.  old .request_fn DM multipath works happily ontop of
blk-mq devices (so long as all paths are blk-mq).

Similarly, blk-mq DM multipath works ontop of all blk-mq devices.

Lastly, old .request_fn DM multipath ontop of old .request_fn paths
works fine.

It is just blk-mq DM multipath ontop of old .request_fn paths that is
disallowed in current upstream code.

But again, I really don't see why we should even want/need to support
that mode... hence my question raised in this RFC.
