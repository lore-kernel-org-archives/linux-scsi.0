From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Thu, 20 Mar 2003 20:39:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030320203912.A18471@beaverton.ibm.com>
References: <20030319182755.A9535@beaverton.ibm.com> <3E7A1EF5.3050501@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E7A1EF5.3050501@splentec.com>; from luben@splentec.com on Thu, Mar 20, 2003 at 03:05:09PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, Mar 20, 2003 at 03:05:09PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > This patch (against 2.5 bk on march 18) fixes a few problems with the
> > linux scsi "starved" algorithm.
> 
> Patch is fine by me.  Comments inlined:
> 
> > It uses a list_head per scsi_host to store a list of scsi request queues
> > that were "starved" (they were not able to send IO because of per host
> > limitations).
> 
> Then this should probably be your comment for the list variable, inlined:

Okay, the comments are not clear, and don't match the code, I'll remove
them rather than try to get something terse and meaningful.

> > +	__blk_run_queue(q);
> > +
> >  	spin_unlock_irqrestore(q->queue_lock, flags);
> >  }
> 
> Why don't you *first* hit the ``q'' queue and unlock it and then, i.e. afterwards,
> go over starved_list.
> 
> Or you can do it the other way around, i.e. assume prioritization, which I strongly
> advise *against* -- the _caller_ may have handled prioritization already.

I'm trying to give priority to scsi_devices that have not been able to
send IO. If we call __blk_run_queue(q) first, one busy scsi_device could
starve all other scsi_devices on an adapter.

I don't see how the caller can have a priority (across scsi_devices), as
there is no priorizitation across different request queues. The blk layer
should already have prioritized/sorted the request (per request queue).

-- Patrick Mansfield
