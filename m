From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 3 May 2009 08:48:47 -0600
Message-ID: <20090503144847.GR8822@parisc-linux.org>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>
Sender: linux-ide-owner@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

On Sun, May 03, 2009 at 02:07:32PM +0100, Hugh Dickins wrote:
> I notice OCZ hope to have updated Vertex firmware mid-May,
> such that their TRIM support matches up with (y)ours.

Excellent.

> You have GFP_KERNEL allocations in your discard_fn()s.  I believe that
> allocations down at that level will need to be GFP_NOIO - the bio mempool
> might be empty by this point, you don't want memory allocation to get into
> submitting even more I/O to satisfy your discard_fn().  Does it need its
> own mempool of reserve pages?  My guess is that you can get away without
> that, since a failed discard, though regrettable, loses no data.

You make a good point.  There's definitely still work to be done around
error handling.  OTOH, we could always do what IDE does ...

static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
{
        ide_drive_t *drive = q->queuedata;
        struct ide_cmd *cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);

        /* FIXME: map struct ide_taskfile on rq->cmd[] */
        BUG_ON(cmd == NULL);



-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
