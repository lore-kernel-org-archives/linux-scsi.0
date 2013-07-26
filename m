From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 26 Jul 2013 14:14:36 -0700
Message-ID: <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
References: <20130719003034.GG28005@kernel.dk>
	 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
	 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
	 <1374248000.2266.20.camel@dabdike>
	 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
	 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
	 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
	 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
	 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
	 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
	 <20130726020928.GL29296@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130726020928.GL29296@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Gordeev <agordeev@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-07-25 at 20:09 -0600, Jens Axboe wrote:
> On Thu, Jul 25 2013, Nicholas A. Bellinger wrote:
> > On Thu, 2013-07-25 at 12:16 +0200, Alexander Gordeev wrote:
> > > On Mon, Jul 22, 2013 at 02:10:36PM -0700, Nicholas A. Bellinger wrote:
> > > > Np.  FYI, you'll want to use the latest commit e7827b351 HEAD from
> > > > target-pending/scsi-mq, which now has functioning scsi-generic support.
> > > 
> > > Survives a boot, a kernel build and the build's result :)
> > 
> > Great.  Thanks for the feedback Alexander!
> > 
> > So the next step on my end is to enable -mq for ahci, and verify initial
> > correctness using QEMU/KVM hardware emulation.
> > 
> > Btw, I've been looking at enabling the SHT->cmd_size for struct
> > ata_queued_cmd descriptor pre-allocation, but AFAICT these descriptors
> > are already all pre-allocated by libata and obtained via ata_qc_new() ->
> > __ata_qc_from_tag() during ata_scsi_queuecmd().
> 
> Might still not be a bad idea to do it:
> 
> - Cleans up a driver, getting rid of the need to alloc, maintain, and
>   free those structures.
> 
> - Should be some cache locality benefits to having it all sequential.
> 

Looking at this some more, there are a number of locations outside of
the main blk_mq_ops->queue_rq() -> SHT->queuecommand_mq() dispatch that
use *ata_qc_from_tag() to obtain *ata_queued_cmd, and a few without a
associated struct scsi_cmnd like libata-core.c:ata_exec_internal_sg()
for example..

So I don't think (completely) getting rid of ata_port->qcmds[] will be
possible, and just converting the ata_scsi_queuecmd() path to use the
extra SHT->cmd_size pre-allocation for *ata_queued_cmd might end up
being more trouble that it's worth.  Still undecided on that part..

Tejun, do you have any thoughts + input here..?

--nab
