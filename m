From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Thu, 25 Jul 2013 20:09:28 -0600
Message-ID: <20130726020928.GL29296@kernel.dk>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Alexander Gordeev <agordeev@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 25 2013, Nicholas A. Bellinger wrote:
> On Thu, 2013-07-25 at 12:16 +0200, Alexander Gordeev wrote:
> > On Mon, Jul 22, 2013 at 02:10:36PM -0700, Nicholas A. Bellinger wrote:
> > > Np.  FYI, you'll want to use the latest commit e7827b351 HEAD from
> > > target-pending/scsi-mq, which now has functioning scsi-generic support.
> > 
> > Survives a boot, a kernel build and the build's result :)
> 
> Great.  Thanks for the feedback Alexander!
> 
> So the next step on my end is to enable -mq for ahci, and verify initial
> correctness using QEMU/KVM hardware emulation.
> 
> Btw, I've been looking at enabling the SHT->cmd_size for struct
> ata_queued_cmd descriptor pre-allocation, but AFAICT these descriptors
> are already all pre-allocated by libata and obtained via ata_qc_new() ->
> __ata_qc_from_tag() during ata_scsi_queuecmd().

Might still not be a bad idea to do it:

- Cleans up a driver, getting rid of the need to alloc, maintain, and
  free those structures.

- Should be some cache locality benefits to having it all sequential.

> So that said, with the struct request + struct scsi_cmnd pre-allocations
> already provided by blk-mq -> scsi-mq code, all memory allocations
> should have already been eliminated from I/O fast path.

Nice!

-- 
Jens Axboe

