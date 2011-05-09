From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch v3 2/3] block: hold queue if flush is running for
 non-queueable flush drive
Date: Mon, 9 May 2011 09:58:51 -0400
Message-ID: <20110509135851.GD5975@redhat.com>
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
 <20110505020417.817084678@sli10-conroe.sh.intel.com>
 <20110505083853.GC30950@htj.dyndns.org>
 <20110509130316.GB5975@redhat.com>
 <20110509135046.GB29753@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1EIN70 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 May 2011 09:59:26 -0400
Content-Disposition: inline
In-Reply-To: <20110509135046.GB29753@sli10-conroe.sh.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "jaxboe@fusionio.com" <jaxboe@fusionio.com>, "hch@infradead.org" <hch@infradead.org>, "jgarzik@pobox.com" <jgarzik@pobox.com>, "djwong@us.ibm.com" <djwong@us.ibm.com>, "sshtylyov@mvista.com" <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ricwheeler@gmail.com" <ricwheeler@gmail.com>

On Mon, May 09, 2011 at 09:50:46PM +0800, Shaohua Li wrote:
> On Mon, May 09, 2011 at 09:03:16PM +0800, Vivek Goyal wrote:
> > On Thu, May 05, 2011 at 10:38:53AM +0200, Tejun Heo wrote:
> > 
> > [..]
> > > Similarly, I'd like to suggest something like the following.
> > > 
> > > 		/*
> > > 		 * Hold dispatching of regular requests if non-queueable
> > > 		 * flush is in progress; otherwise, the low level driver
> > > 		 * would keep dispatching IO requests just to requeue them
> > > 		 * until the flush finishes, which not only adds
> > > 		 * dispatching / requeueing overhead but may also
> > > 		 * significantly affect throughput when multiple flushes
> > > 		 * are issued back-to-back.  Please consider the following
> > > 		 * scenario.
> > > 		 *
> > > 		 * - flush1 is dispatched with write1 in the elevator.
> > > 		 *
> > > 		 * - Driver dispatches write1 and requeues it.
> > > 		 *
> > > 		 * - flush2 is issued and appended to dispatch queue after
> > > 		 *   the requeued write1.  As write1 has been requeued
> > > 		 *   flush2 can't be put in front of it.
> > > 		 *
> > > 		 * - When flush1 finishes, the driver has to process write1
> > > 		 *   before flush2 even though there's no fundamental
> > > 		 *   reason flush2 can't be processed first and, when two
> > > 		 *   flushes are issued back-to-back without intervening
> > > 		 *   writes, the second one essentially becomes noop.
> > > 		 *
> > > 		 * This phenomena becomes quite visible under heavy
> > > 		 * concurrent fsync workload and holding the queue while
> > > 		 * flush is in progress leads to significant throughput
> > > 		 * gain.
> > > 		 */
> > 
> > Tejun,
> > 
> > I am assuming that these back-to-back flushes are independent of each
> > other otherwise write request will anyway get between two flushes.
> Hi,
> yes, the flushes are independent.
>  
> > If that's the case, then should we solve the problem by improving flush
> > merge logic a bit better. (Say idle a bit before issuing a flush only
> > if request queue is not empty).
> I tried some ways to improve flush merge logic. The problem I observed is something like:
> say we have 10 flushes, originally we dispatch 4 flush, write, 6 flush. doing more merge
> we have 6 flush, write, 4 flush. the flush request number sent to drive isn't reduced.

If we try to get rid of WRITE completely between these 10 flushes then we
run the risk of starving other READS/WRITES as long as flushes are going on.

> Another reason I didn't see improvement with better back-to-back merge might be drive
> already optimizes two adjacent flushes case well.

I did not understand this one. With improved back to back merge logic 
we have already optimized the flush case. So for 10 flush and one write
we seem to be issuing following (as per your mail).

1 flush (6 flush merged)--> WRITE --> 1flush (4 flush merged).

So where is the opprotinutiy for drive (non flush queuing drive) to optimize
flush here?

IOW, if flush merging is already working well, do we really want to move
in a direction where we can potentially starve other READ/WRITE happening
in an attempt to improve throughput for a sepecific workload.

Thanks
Vivek
