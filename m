From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: Fri, 31 Jan 2003 18:46:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030131184626.A22325@beaverton.ibm.com>
References: <20030129104731.A2811@beaverton.ibm.com> <3E382E2C.4030201@splentec.com> <20030129121117.A3389@beaverton.ibm.com> <20030130225738.1874c2e0.akpm@digeo.com> <1044020591.2002.16.camel@mulgrave> <20030131124412.086f2d1c.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030131124412.086f2d1c.akpm@digeo.com>; from akpm@digeo.com on Fri, Jan 31, 2003 at 12:44:12PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, luben@splentec.com, linux-scsi@vger.kernel.org

On Fri, Jan 31, 2003 at 12:44:12PM -0800, Andrew Morton wrote:
> James Bottomley <James.Bottomley@steeleye.com> wrote:
> >
> > On Fri, 2003-01-31 at 01:57, Andrew Morton wrote:
> > > Please do not reinvent the mm/mempool.c functionality.
> > > 
> > > 'twould be better to just use it ;)
> > 
> > Unfortunately, in this instance, mempool is a slight overkill.  The
> > problem is that we need to guarantee that a command (or set of commands)
> > be available to a given device regardless of what's going on in the rest
> > of the system.  Thus we might need a mempool for each active device,
> > rather than a mempool for all devices and a mechanism for giving fine
> > grained control to the pool depth per device.
> 
> A lot depends on the context of the allocation.  Can the caller sleep?

No (generally) - we are in our request function, and are called via soft
irq and from anywhere that blk_run_queues is called. Calls outside of the
request function can sleep (but they are not used for regular IO).

> Is the caller using GFP_ATOMIC/__GFP_HIGH?

Yes normally GFP_ATOMIC

> (What file-n-line should I be looking at, anyway?)

If you have bk, bk://linux-scsi.bkbits.net/scsi-combined-2.5, file is
drivers/scsi/scsi_lib.c - the calls to scsi_getset_command. That tree also
has other scsi changes, as well as changes related to the new allocation
scheme.

In 2.5.59 this was a call to scsi_allocate_device. The current 2.5
allocation alogrithm used by scsi_allocate_device is poor. In the new
code, scsi_allocate_device is replaced by a call to scsi_getset_command.

scsi_getset_command effectively calls kmem_cache_alloc(some_cache,
flags).

My complaint that started the thread is that (generally) we don't have
fairness across devices (scsi_device) on kmem_cache_alloc failure - a
failure can put us in a timeout/poll like mode, but anyone with an IO
already in flight can allocate (from kmem_cache_alloc or a single
scsi_cmnd saved per host adapter) and issue another IO before the device
that had a kmem_cache_alloc failure.

So, a swap disk could potentially be starved from issuing IO during low
memory conditions. 

But, there is the extra scsi_cmnd per host adapter (not per device), and
it is always refilled (if empty) when a scsi_cmnd completes for that
adapter, this combined with filling of the cache via continued IO use
might prevent most (and hopefully all) such failures.

-- Patrick Mansfield
