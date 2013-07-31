From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Wed, 31 Jul 2013 06:23:03 -0400
Message-ID: <20130731102303.GC2810@htj.dyndns.org>
References: <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
 <20130726020928.GL29296@kernel.dk>
 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
 <1374885793.7397.1537.camel@haakon3.risingtidesystems.com>
 <20130729111827.GA14283@dhcp-26-207.brq.redhat.com>
 <1375125571.5171.16.camel@haakon3.risingtidesystems.com>
 <CAO1A-8AW-aQJ0hjX38U_q8Ovcpb58fP9Skfyi59xihXTQHECNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAO1A-8AW-aQJ0hjX38U_q8Ovcpb58fP9Skfyi59xihXTQHECNQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Marc C <marc.ceeeee@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Tue, Jul 30, 2013 at 09:16:02PM -0700, Marc C wrote:
> >> One thing which would probably be worthwhile tho is getting rid of the
> >> bitmap based qc tag allocator in libata.  That one is just borderline
> >> stupid to keep around on any setup which is supposed to be scalable.
> > Your border might be wider than mine :-). Yes, the bitmap should
> > definitely go.
>
> A naive implementation is obviously less-than-efficient. However, what
> other problems exist with the libata QC tag allocator? I highly doubt
> SATA will change to beyond 32 queue tags, primarily because it would
> be a pain to change SDB FIS (it's likely to break the dozens of AHCI
> controller implementations out there). Further, it seems like the
> industry stopped caring about SATA and is pushing NVMe for future
> offerings.
> 
> In any event, most modern systems should have instructions to count
> leading zeroes and modify bits atomically.

It's inefficient not because scanning is expensive but because it
makes all CPUs in the system to hit on the exact same cacheline over
and over and over again.

Thanks.

-- 
tejun
