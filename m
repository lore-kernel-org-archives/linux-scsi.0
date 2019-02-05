From: Keith Busch <keith.busch@intel.com>
Subject: Re: Question on handling managed IRQs when hotplugging CPUs
Date: Tue, 5 Feb 2019 08:11:15 -0700
Message-ID: <20190205151115.GC28023@localhost.localdomain>
References: <20190129172059.GC17132@localhost.localdomain>
 <3fe63dab-0791-f476-69c4-9866b70e8520@huawei.com>
 <alpine.DEB.2.21.1901301338170.5537@nanos.tec.linutronix.de>
 <86d5028d-44ab-3696-f7fe-828d7655faa9@huawei.com>
 <745609be-b215-dd2d-c31f-0bd84572f49f@suse.de>
 <alpine.DEB.2.21.1902012255550.8200@nanos.tec.linutronix.de>
 <d93ff049-e96d-36ce-7e58-ec97cbb27ed0@suse.de>
 <42d149c5-0380-c357-8811-81015159ac04@huawei.com>
 <20190205145244.GB28023@localhost.localdomain>
 <d4a04c13-b7db-84df-b1d3-90022905c084@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d4a04c13-b7db-84df-b1d3-90022905c084@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, Marc Zyngier <marc.zyngier@arm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Linuxarm <linuxarm@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 05, 2019 at 03:09:28PM +0000, John Garry wrote:
> On 05/02/2019 14:52, Keith Busch wrote:
> > On Tue, Feb 05, 2019 at 05:24:11AM -0800, John Garry wrote:
> > > On 04/02/2019 07:12, Hannes Reinecke wrote:
> > > 
> > > Hi Hannes,
> > > 
> > > > 
> > > > So, as the user then has to wait for the system to declars 'ready for
> > > > CPU remove', why can't we just disable the SQ and wait for all I/O to
> > > > complete?
> > > > We can make it more fine-grained by just waiting on all outstanding I/O
> > > > on that SQ to complete, but waiting for all I/O should be good as an
> > > > initial try.
> > > > With that we wouldn't need to fiddle with driver internals, and could
> > > > make it pretty generic.
> > > 
> > > I don't fully understand this idea - specifically, at which layer would
> > > we be waiting for all the IO to complete?
> > 
> > Whichever layer dispatched the IO to a CPU specific context should
> > be the one to wait for its completion. That should be blk-mq for most
> > block drivers.
> 
> For SCSI devices, unfortunately not all IO sent to the HW originates from
> blk-mq or any other single entity.

Then they'll need to register their own CPU notifiers and handle the
ones they dispatched.
