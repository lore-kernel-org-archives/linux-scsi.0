From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Mon, 29 Jul 2013 07:46:53 -0400
Message-ID: <20130729114653.GB20951@mtj.dyndns.org>
References: <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
 <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
 <20130726020928.GL29296@kernel.dk>
 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Gordeev <agordeev@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, Jul 26, 2013 at 02:14:36PM -0700, Nicholas A. Bellinger wrote:
> So I don't think (completely) getting rid of ata_port->qcmds[] will be
> possible, and just converting the ata_scsi_queuecmd() path to use the
> extra SHT->cmd_size pre-allocation for *ata_queued_cmd might end up
> being more trouble that it's worth.  Still undecided on that part..
> 
> Tejun, do you have any thoughts + input here..?

libata exception handling which includes probing doesn't go through
SCSI at all.  It all works inside libata proper using ata_queuecmds
and only the result is exposed to SCSI.  Most of those SCSI semantics
need to be emulated anyway, so this makes things a lot easier than
going through SCSI for each command.  As it currently stands, it'd be
a lot of effort to try to embed ata_qc's into higher layer construct.
Given how it's used, I don't think it's a high priority task.

One thing which would probably be worthwhile tho is getting rid of the
bitmap based qc tag allocator in libata.  That one is just borderline
stupid to keep around on any setup which is supposed to be scalable.

Thanks.

-- 
tejun
