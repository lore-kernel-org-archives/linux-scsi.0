From: Andrew Morton <akpm@digeo.com>
Subject: Re: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Tue, 17 Dec 2002 14:54:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFFAB33.F174D272@digeo.com>
References: <170040000.1040080786@aslan.btc.adaptec.com> <20021217054102.GH13989@redhat.com> <797140000.1040156703@aslan.btc.adaptec.com> <20021217222459.GD28100@redhat.com> <20021217223341.A26529@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id OAA15998
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2002 14:55:42 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> 
> On Tue, Dec 17, 2002 at 05:24:59PM -0500, Doug Ledford wrote:
> > Well, that or I need Jens to clean up the block layer allocation code so
> > that it only allocates one request at block queue init time and from then
> > on does lazy request allocations once the device needs them, similar to
> > what I did with the scsi command blocks.
> 
> What do you think about forward-porting akpm's blk_grow_request_list()
> changes in 2.4?  I could do that easily and it should help to get this
> sorted out properly.
> 

wakes up.

I think (hope) the plan there is to do away with the preallocated
per-queue request lists altogether.  Just allocate the requests
direct from slab at __make_request().

The request slab would have to be backed by a (small) mempool of
course.  get_request_wait() should disappear, and management of
the amount of memory which is under IO is moved up to the VM layer.

This means that we have basically no upper bound on the amount of
memory which can be placed under I/O.  Which used to give the VM
a heart-attack, but it should be OK for writes now.  If not I'll
fix it up.  There could be issues with reads and direct-IO.

The rbtree elevator becomes compulsory with such potentially-large
queues, but that's working fine.
