From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/2] genirq/affinity: try to make sure online CPU is
 assgined to irq vector
Date: Tue, 16 Jan 2018 20:23:24 +0800
Message-ID: <20180116122323.GB26429@ming.t460p>
References: <20180115160345.2611-1-ming.lei@redhat.com>
 <20180115174036.GA20191@infradead.org>
 <20180116013043.GA3213@ming.t460p>
 <alpine.DEB.2.20.1801161223500.1823@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1801161223500.1823@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 16, 2018 at 12:25:19PM +0100, Thomas Gleixner wrote:
> On Tue, 16 Jan 2018, Ming Lei wrote:
> 
> > On Mon, Jan 15, 2018 at 09:40:36AM -0800, Christoph Hellwig wrote:
> > > On Tue, Jan 16, 2018 at 12:03:43AM +0800, Ming Lei wrote:
> > > > Hi,
> > > > 
> > > > These two patches fixes IO hang issue reported by Laurence.
> > > > 
> > > > 84676c1f21 ("genirq/affinity: assign vectors to all possible CPUs")
> > > > may cause one irq vector assigned to all offline CPUs, then this vector
> > > > can't handle irq any more.
> > > 
> > > Well, that very much was the intention of managed interrupts.  Why
> > > does the device raise an interrupt for a queue that has no online
> > > cpu assigned to it?
> > 
> > It is because of irq_create_affinity_masks().
> 
> That still does not answer the question. If the interrupt for a queue is
> assigned to an offline CPU, then the queue should not be used and never
> raise an interrupt. That's how managed interrupts have been designed.

Sorry for not answering it in 1st place, but later I realized that:

	https://marc.info/?l=linux-block&m=151606896601195&w=2

Also wrt. HPSA's queue, looks they are not usual IO queue(such as NVMe's
hw queue) which supposes to be C/S model. And HPSA's queue is more like
a management queue, I guess, since HPSA is still a single queue HBA,
from blk-mq view.

Cc HPSA and SCSI guys.

Thanks,
Ming
