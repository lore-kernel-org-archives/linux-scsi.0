From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [patch v3 2/3] block: hold queue if flush is running for
 non-queueable flush drive
Date: Mon, 9 May 2011 21:50:46 +0800
Message-ID: <20110509135046.GB29753@sli10-conroe.sh.intel.com>
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
 <20110505020417.817084678@sli10-conroe.sh.intel.com>
 <20110505083853.GC30950@htj.dyndns.org>
 <20110509130316.GB5975@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110509130316.GB5975@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "jaxboe@fusionio.com" <jaxboe@fusionio.com>, "hch@infradead.org" <hch@infradead.org>, "jgarzik@pobox.com" <jgarzik@pobox.com>, "djwong@us.ibm.com" <djwong@us.ibm.com>, "sshtylyov@mvista.com" <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ricwheeler@gmail.com" <ricwheeler@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 09, 2011 at 09:03:16PM +0800, Vivek Goyal wrote:
> On Thu, May 05, 2011 at 10:38:53AM +0200, Tejun Heo wrote:
> 
> [..]
> > Similarly, I'd like to suggest something like the following.
> > 
> > 		/*
> > 		 * Hold dispatching of regular requests if non-queueable
> > 		 * flush is in progress; otherwise, the low level driver
> > 		 * would keep dispatching IO requests just to requeue them
> > 		 * until the flush finishes, which not only adds
> > 		 * dispatching / requeueing overhead but may also
> > 		 * significantly affect throughput when multiple flushes
> > 		 * are issued back-to-back.  Please consider the following
> > 		 * scenario.
> > 		 *
> > 		 * - flush1 is dispatched with write1 in the elevator.
> > 		 *
> > 		 * - Driver dispatches write1 and requeues it.
> > 		 *
> > 		 * - flush2 is issued and appended to dispatch queue after
> > 		 *   the requeued write1.  As write1 has been requeued
> > 		 *   flush2 can't be put in front of it.
> > 		 *
> > 		 * - When flush1 finishes, the driver has to process write1
> > 		 *   before flush2 even though there's no fundamental
> > 		 *   reason flush2 can't be processed first and, when two
> > 		 *   flushes are issued back-to-back without intervening
> > 		 *   writes, the second one essentially becomes noop.
> > 		 *
> > 		 * This phenomena becomes quite visible under heavy
> > 		 * concurrent fsync workload and holding the queue while
> > 		 * flush is in progress leads to significant throughput
> > 		 * gain.
> > 		 */
> 
> Tejun,
> 
> I am assuming that these back-to-back flushes are independent of each
> other otherwise write request will anyway get between two flushes.
Hi,
yes, the flushes are independent.
 
> If that's the case, then should we solve the problem by improving flush
> merge logic a bit better. (Say idle a bit before issuing a flush only
> if request queue is not empty).
I tried some ways to improve flush merge logic. The problem I observed is something like:
say we have 10 flushes, originally we dispatch 4 flush, write, 6 flush. doing more merge
we have 6 flush, write, 4 flush. the flush request number sent to drive isn't reduced.
Another reason I didn't see improvement with better back-to-back merge might be drive
already optimizes two adjacent flushes case well.

Thanks,
Shaohua
