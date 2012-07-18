From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [MINI SUMMIT] SCSI core performance
Date: Wed, 18 Jul 2012 09:00:02 +0100
Message-ID: <1342598402.3022.17.camel@dabdike.int.hansenpartnership.com>
References: <1342579190.18004.597.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42161 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab2GRIAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2012 04:00:10 -0400
In-Reply-To: <1342579190.18004.597.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: KS-2012-discuss <ksummit-2012-discuss@lists.linux-foundation.org>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <mail@hannes-reinecke.de>, Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On Tue, 2012-07-17 at 19:39 -0700, Nicholas A. Bellinger wrote:
> Hi KS-PCs,
> 
> I'd like to propose a SCSI performance mini-summit to see how interested
> folks are in helping address the long-term issues that SCSI core is
> currently facing wrt to multi-lun per host and heavy small block random
> I/O workloads.
> 
> I know this would probably be better suited for LSF (for the record it
> was proposed this year) but now that we've acknowledge there is a
> problem with SCSI LLDs vs. raw block drivers vs. other SCSI subsystems,
> it would be useful to get the storage folks into a single room at some
> point during KS/LPC to figure out what is actually going on with SCSI
> core.

You seem to have a short memory:  The last time it was discussed

http://marc.info/?t=134155373900003

It rapidly became apparent there isn't a problem.  Enabling high IOPS in
the SCSI stack is what I think you mean.

> As mentioned in the recent tcm_vhost thread, there are a number of cases
> where drivers/target/ code can demonstrate this limitation pretty
> vividly now.
> 
> This includes the following scenarios using raw block flash export with
> target_core_mod + target_core_iblock export and the same small block
> (4k) mixed random I/O workload with fio:
> 
> *) tcm_loop local SCSI LLD performance is an order of magnitude slower 
>    than the same local raw block flash backend.
> *) tcm_qla2xxx performs better using MSFT Server hosts than Linux v3.x
>    based hosts using 2x socket Nehalem hardware w/ PCI-e Gen2 HBAs
> *) ib_srpt performs better using MSFT Server host than RHEL 6.x .32 
>    based hosts using 2x socket Romley hardware w/ PCI-e Gen3 HCAs
> *) Raw block IBLOCK export into KVM guest v3.5-rc w/ virtio-scsi is 
>    behind in performance vs. raw local block flash.  (cmwq on the host 
>    is helping here, but still need to with MSFT SCSI mini-port)
> 
> Also, with 1M IOPs into a single VM guest now being done by other non
> Linux based hypervisors, the virtualization bit for high performance KVM
> SCSI based storage is quickly coming on..
> 
> So all of that said, I'd like to at least have a discussion with the key
> SCSI + block folks who will be present in San Diego on path forward to
> address these without having to wait until LSF-2013 + hope for a topic
> slot to materialize then.
> 
> Thank you for your consideration,

Well, your proposal is devoid of an actual proposal.

Enabling high IOPS involves reducing locking overhead and path length
through the code.  I think most of the low hanging fruit in this area is
already picked, but if you have an idea, please say.  There might be
something we can extract from the lockless queue work Jens is doing, but
we need that to materialise first.

Without a concrete thing to discuss, shooting the breeze on high IOPS in
the SCSI stack is about as useful as discussing what happened in last
night's episode of Coronation Street which, when it happens in my house,
always helps me see how incredibly urgent fixing the leaky tap I've been
putting off for months actually is.

If someone can come up with a proposal ... or even perhaps another path
trace showing where the reducible overhead and lock problems are we can
discuss it on the list and we might have a real topic by the time LSF
rolls around.

James


