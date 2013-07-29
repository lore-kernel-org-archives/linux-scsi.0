From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Mon, 29 Jul 2013 07:50:11 -0400
Message-ID: <20130729115011.GC20951@mtj.dyndns.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374885793.7397.1537.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Gordeev <agordeev@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Yo,

On Fri, Jul 26, 2013 at 05:43:13PM -0700, Nicholas A. Bellinger wrote:
> Considering there can be more than a single ata_device hanging off each
> ata_port, the '*sdev = ap->link.device[0].sdev' in __ata_qc_from_tag()
> is definitely bogus, but I'm not sure how else to correlate
> blk-mq/scsi-mq per device descriptors to existing code expecting
> ata_port->qcmd[] descriptors to be shared across multiple devices..
> 
> Tejun..?

I have no idea.  Let's please just do simpler conversion and worry
about embedding qc's into scsi_cmnds later.  libata isn't a normal
SCSI driver and has a rather its own thick midlayer doing the
impedance matching inbetween && I really don't think there is too much
benefit to be reaped from embedding qc's into scsi_cmnds.

Thanks.

-- 
tejun
