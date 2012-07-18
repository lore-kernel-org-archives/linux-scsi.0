From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [MINI SUMMIT] SCSI core performance
Date: Wed, 18 Jul 2012 15:34:35 -0700
Message-ID: <1342650875.18004.690.camel@haakon2.linux-iscsi.org>
References: <1342579190.18004.597.camel@haakon2.linux-iscsi.org>
	 <1342598402.3022.17.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342598402.3022.17.camel@dabdike.int.hansenpartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: KS-2012-discuss <ksummit-2012-discuss@lists.linux-foundation.org>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <mail@hannes-reinecke.de>, Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-07-18 at 09:00 +0100, James Bottomley wrote:
> On Tue, 2012-07-17 at 19:39 -0700, Nicholas A. Bellinger wrote:
> > Hi KS-PCs,
> > 
> > I'd like to propose a SCSI performance mini-summit to see how interested
> > folks are in helping address the long-term issues that SCSI core is
> > currently facing wrt to multi-lun per host and heavy small block random
> > I/O workloads.
> > 
> > I know this would probably be better suited for LSF (for the record it
> > was proposed this year) but now that we've acknowledge there is a
> > problem with SCSI LLDs vs. raw block drivers vs. other SCSI subsystems,
> > it would be useful to get the storage folks into a single room at some
> > point during KS/LPC to figure out what is actually going on with SCSI
> > core.
> 
> You seem to have a short memory:  The last time it was discussed
> 
> http://marc.info/?t=134155373900003
> 
> It rapidly became apparent there isn't a problem.  Enabling high IOPS in
> the SCSI stack is what I think you mean.
> 

small block random I/O == performance, that is correct.

The host-lock-less stuff is doing better these days for small-ish
multi-lun setups with large block sequential I/O workloads.

Doing ~1 GB/sec per LUN is achievable with multi-lun per host (say up to
6-8 LUNs dependent on your setup) using PCI-e Gen3 hardware.

> > As mentioned in the recent tcm_vhost thread, there are a number of cases
> > where drivers/target/ code can demonstrate this limitation pretty
> > vividly now.
> > 
> > This includes the following scenarios using raw block flash export with
> > target_core_mod + target_core_iblock export and the same small block
> > (4k) mixed random I/O workload with fio:
> > 
> > *) tcm_loop local SCSI LLD performance is an order of magnitude slower 
> >    than the same local raw block flash backend.
> > *) tcm_qla2xxx performs better using MSFT Server hosts than Linux v3.x
> >    based hosts using 2x socket Nehalem hardware w/ PCI-e Gen2 HBAs
> > *) ib_srpt performs better using MSFT Server host than RHEL 6.x .32 
> >    based hosts using 2x socket Romley hardware w/ PCI-e Gen3 HCAs
> > *) Raw block IBLOCK export into KVM guest v3.5-rc w/ virtio-scsi is 
> >    behind in performance vs. raw local block flash.  (cmwq on the host 
> >    is helping here, but still need to with MSFT SCSI mini-port)
> > 
> > Also, with 1M IOPs into a single VM guest now being done by other non
> > Linux based hypervisors, the virtualization bit for high performance KVM
> > SCSI based storage is quickly coming on..
> > 
> > So all of that said, I'd like to at least have a discussion with the key
> > SCSI + block folks who will be present in San Diego on path forward to
> > address these without having to wait until LSF-2013 + hope for a topic
> > slot to materialize then.
> > 
> > Thank you for your consideration,
> 
> Well, your proposal is devoid of an actual proposal.
> 

Huh..?  It's a proposal for a discussion to (hopefully) identify the
main culprit(s) and figure out an incremental way forward.

Due to the fact that 1M IOPs machines aren't quite the norm (yet), the
idea is to get storage folks in the same room who do have access to 1M
IOPs systems + have an interest in making SCSI core go faster for random
small block I/O workloads.

This can be vendors / LLD maintainers who've run into similar
limitations with SCSI core, or folks who have an interest in KVM guest
SCSI performance.

> Enabling high IOPS involves reducing locking overhead and path length
> through the code.  I think most of the low hanging fruit in this area is
> already picked, but if you have an idea, please say.  There might be
> something we can extract from the lockless queue work Jens is doing, but
> we need that to materialise first.
> 

Would really like to hear from Jens here, but I don't know how much time
he is spending on the SCSI layer these days..

I've been more interested recently in working on a fabric that can
demonstrate this bottleneck with raw block flash into KVM guest <->
virtio-scsi, as I think it's a important vehicle for short-term
diagnosis.

> Without a concrete thing to discuss, shooting the breeze on high IOPS in
> the SCSI stack is about as useful as discussing what happened in last
> night's episode of Coronation Street which, when it happens in my house,
> always helps me see how incredibly urgent fixing the leaky tap I've been
> putting off for months actually is.
> 

Sorry, I've never heard of that show.  

> If someone can come up with a proposal ... or even perhaps another path
> trace showing where the reducible overhead and lock problems are we can
> discuss it on the list and we might have a real topic by the time LSF
> rolls around.
> 

So identifying root culprit(s) is still a WIP at this point.

In the next weeks I'll be back spending time back on 1M IOPs machines
with raw block flash + qla2xxx/srpt/vhost + Linux/MSFT SCSI clients, and
should be getting some more data-points by then.

Anyways, if it ends up taking until LSF it ends up at LSF.  I figured
since things are heating up for virtio-scsi that KS might be a good
venue for a discussion like this.

--nab
