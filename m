From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch v3 2/3] block: hold queue if flush is running for
 non-queueable flush drive
Date: Mon, 9 May 2011 16:37:02 +0200
Message-ID: <20110509143702.GK1661@htj.dyndns.org>
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
 <20110505020417.817084678@sli10-conroe.sh.intel.com>
 <20110505083853.GC30950@htj.dyndns.org>
 <20110509130316.GB5975@redhat.com>
 <20110509135046.GB29753@sli10-conroe.sh.intel.com>
 <20110509135851.GD5975@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61391 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab1EIOhI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2011 10:37:08 -0400
Content-Disposition: inline
In-Reply-To: <20110509135851.GD5975@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "jaxboe@fusionio.com" <jaxboe@fusionio.com>, "hch@infradead.org" <hch@infradead.org>, "jgarzik@pobox.com" <jgarzik@pobox.com>, "djwong@us.ibm.com" <djwong@us.ibm.com>, "sshtylyov@mvista.com" <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ricwheeler@gmail.com" <ricwheeler@gmail.com>

Hello, Vivek, Shaohua.

On Mon, May 09, 2011 at 09:58:51AM -0400, Vivek Goyal wrote:
> > > I am assuming that these back-to-back flushes are independent of each
> > > other otherwise write request will anyway get between two flushes.

Yeap.

> > > If that's the case, then should we solve the problem by improving flush
> > > merge logic a bit better. (Say idle a bit before issuing a flush only
> > > if request queue is not empty).

Maybe, I don't know.  Maybe we can implement some sort of adaptive
delay logic which detects parallel stream of flush requests and try to
insert artificial delays between flush issues to maximize throughput.
With such workload, such optimization probably wouldn't hurt latency
that much either.

However, such heuristics tend to be fairly finicky and result in
unexpected behavior when workload isn't of the expected pattern and
that's why I stuck with mostly mechanical mechanism we currently have
for the initial implementation, but please feel free to play with it.
It would be awesome if such logic can be implemented with something
mechanical which doesn't involve a lot of magic tunables, timers and
pattern detection logics.

> If we try to get rid of WRITE completely between these 10 flushes
> then we run the risk of starving other READS/WRITES as long as
> flushes are going on.

Back-to-back flushes are very cheap.  It just costs command
issue/completion roundtrip latency and if that's a problem we can
optimize that out too, so I don't think stream of back-to-back empty
flushes can be a problem.  For flushes with data, nothing prevents
other IOs from issued while flush writes are being sequenced.  It will
look like,

 FLUSH -> FLUSH and other data -> FLUSH -> FLUSH -> FLUSH and other data...

Before this patch, it was

 FLUSH -> FLUSH and other data -> FLUSH -> other data -> FLUSH -> FLUSH and other data...

The change isn't gonna cause starvation.

> I did not understand this one. With improved back to back merge logic 
> we have already optimized the flush case. So for 10 flush and one write
> we seem to be issuing following (as per your mail).
> 
> 1 flush (6 flush merged)--> WRITE --> 1flush (4 flush merged).
> 
> So where is the opprotinutiy for drive (non flush queuing drive) to optimize
> flush here?

I suspect the workload doesn't really swamp the device with fsync's
and there frequently are brief holes without any pending flush.  In
such cases, flush sequencer will start sequencing immediately and the
following flushes would lose a chance to be merged and the intervening
write causes the performance hit.  It would be interesting to
investigate this deeper tho.

> IOW, if flush merging is already working well, do we really want to move
> in a direction where we can potentially starve other READ/WRITE happening
> in an attempt to improve throughput for a sepecific workload.

I don't think it's gonna starve anything and actually like it as it
effectively implements another side of mechnical merging.  Before the
patch, it only tried to merge requests which already shared a FLUSH.
ie. It delayed post-FLUSH until all writes which shared pre-FLUSH
finished.  This change doesn't introduce any latency on idle queue
while allowing effective merging of flushes which immediately follows
the first one, and there's no knobs to adjust - timings are regulated
by how fast the device can handle flushes and IOs.

So, whether we add further merge strategy or not, I think this one can
serve nicely as one of the base logics and would really like to see
how it affects higher end devices.

Please note that really highend devices with battery backed buffer
wouldn't care about all of this anyway.  I think we would mostly be
looking at SCSI hard drives or cheap arrays where I don't think
issuing other IOs together with flush would bring a lot of benefits.
So, I'd like to enable the logic by default unless it actively hurts
those devices.

Thank you.

-- 
tejun
