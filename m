From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Mon, 29 Jul 2013 12:11:06 -0700
Message-ID: <1375125066.5171.10.camel@haakon3.risingtidesystems.com>
References: <1374248000.2266.20.camel@dabdike>
	 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
	 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
	 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
	 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
	 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
	 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
	 <20130726020928.GL29296@kernel.dk>
	 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
	 <1374885793.7397.1537.camel@haakon3.risingtidesystems.com>
	 <20130729115011.GC20951@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130729115011.GC20951@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Gordeev <agordeev@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-07-29 at 07:50 -0400, Tejun Heo wrote:
> Yo,
> 
> On Fri, Jul 26, 2013 at 05:43:13PM -0700, Nicholas A. Bellinger wrote:
> > Considering there can be more than a single ata_device hanging off each
> > ata_port, the '*sdev = ap->link.device[0].sdev' in __ata_qc_from_tag()
> > is definitely bogus, but I'm not sure how else to correlate
> > blk-mq/scsi-mq per device descriptors to existing code expecting
> > ata_port->qcmd[] descriptors to be shared across multiple devices..
> > 
> > Tejun..?
> 
> I have no idea.  Let's please just do simpler conversion and worry
> about embedding qc's into scsi_cmnds later.  libata isn't a normal
> SCSI driver and has a rather its own thick midlayer doing the
> impedance matching inbetween && I really don't think there is too much
> benefit to be reaped from embedding qc's into scsi_cmnds.
> 

That is essentially the same conclusion that I came to, but wanted to at
least give you a chance to comment here.  ;)

So that said, I'll include a simple conversion for libata into the
scsi-mq WIP branch, and folks who are interested in more detailed
conversions can pursue them as separate items.

--nab 

