From: Andrew Morton <akpm@digeo.com>
Subject: Re: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Tue, 17 Dec 2002 17:22:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFFCDC0.C456BBDB@digeo.com>
References: <170040000.1040080786@aslan.btc.adaptec.com> <20021217054102.GH13989@redhat.com> <797140000.1040156703@aslan.btc.adaptec.com> <20021217222459.GD28100@redhat.com> <20021217223341.A26529@infradead.org> <3DFFAB33.F174D272@digeo.com> <20021218010050.GF28100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id RAA21226
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2002 17:22:09 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

Doug Ledford wrote:
> 
> On Tue, Dec 17, 2002 at 02:54:43PM -0800, Andrew Morton wrote:
> >
> > wakes up.
> >
> > I think (hope) the plan there is to do away with the preallocated
> > per-queue request lists altogether.  Just allocate the requests
> > direct from slab at __make_request().
> 
> So, what is the overhead of using the slab allocator on each command?  If
> you prealloc a reasonable queue, allocation from that queue is O(1).
> Would we suffer no/little/large penalty using slab instead?
> 
> /me hasn't gone looking in the slab allocator and has no idea how well it
> actually works at being a cache...

It's wickedly quick.  There won't be a problem there...

> Second issue I have is that overly large request queues have never seemed
> to help performance in my experience.  At a certain point the overhead of
> the queue and merging so many requests, etc. becomes greater than the gain
> of the increased depth and starts to slow things back down.  So, my
> question to you, is why would we *want* to be able to have huge queues?
> 

Generally, huge queues don't appear to buy us much.  And in principle
they shouldn't, because we should be ordering write better at the VFS layer.

In practice, I expect there will be certain workloads at which the VFS
is known to behave very suboptimally in which the huge queues will
make a large difference.  Mainly the "seek all around a huge file writing
stuff" workload.

The other "in principle" thing here is that the VM/VFS should _not_
be dependent on request exhaustion for its own throttling, because
that will fail if there are a large number of disks, or if the
machine has a teeny amount of memory.

So I expect that in practice we would be unlikely to go beyond
128 requests per direction per queue.  But it should be an
option, and it should work well.
