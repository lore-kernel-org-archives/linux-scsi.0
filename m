From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Tue, 17 Dec 2002 17:03:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021218010344.GA12812@holomorphy.com>
References: <170040000.1040080786@aslan.btc.adaptec.com> <20021217054102.GH13989@redhat.com> <797140000.1040156703@aslan.btc.adaptec.com> <20021217222459.GD28100@redhat.com> <20021217223341.A26529@infradead.org> <3DFFAB33.F174D272@digeo.com> <20021218010050.GF28100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021218010050.GF28100@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>, Christoph Hellwig <hch@infradead.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

On Tue, Dec 17, 2002 at 02:54:43PM -0800, Andrew Morton wrote:
>> I think (hope) the plan there is to do away with the preallocated
>> per-queue request lists altogether.  Just allocate the requests
>> direct from slab at __make_request().

On Tue, Dec 17, 2002 at 08:00:50PM -0500, Doug Ledford wrote:
> So, what is the overhead of using the slab allocator on each command?  If 
> you prealloc a reasonable queue, allocation from that queue is O(1).  
> Would we suffer no/little/large penalty using slab instead?
> /me hasn't gone looking in the slab allocator and has no idea how well it 
> actually works at being a cache...
> Second issue I have is that overly large request queues have never seemed 
> to help performance in my experience.  At a certain point the overhead of 
> the queue and merging so many requests, etc. becomes greater than the gain 
> of the increased depth and starts to slow things back down.  So, my 
> question to you, is why would we *want* to be able to have huge queues?

It helps here. When there's a lot of RAM, getting a decent fraction
of memory in-flight by and large overloads the queues. Also, blocking
explicitly breaks the asynchronous semantics expected by the apps.


Bill
