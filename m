From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Wed, 23 Oct 2002 18:36:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021023183641.A20779@eng2.beaverton.ibm.com>
References: <dledford@redhat.com> <200210231416.g9NEGoI01976@localhost.localdomain> <20021023171335.B17312@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021023171335.B17312@lst.de>; from hch@lst.de on Wed, Oct 23, 2002 at 05:13:35PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Wed, Oct 23, 2002 at 05:13:35PM +0200, Christoph Hellwig wrote:
> On Wed, Oct 23, 2002 at 09:16:49AM -0500, James Bottomley wrote:
> > It looks like what we want to have happen is:
> > 
> > 1) init first
> >
> > 
> > 2) detect is currently superfluous (there will probably be a future time when 
> > we need a separate detect for lazy attachment---devices don't attach and 
> > consume resources until the operator so instructs)
> > 4) call build commandblocks to get a single working command
> > 5) attach
> > 6) if anything attached do the slave attach or cmd_per_lun adjustment.  If 
> > not, release the command blocks.
> 
> Completly agreed with that.

We should also call blk_cleanup_queue along with scsi_release_commandblocks,
and then call scsi_initialize_queue when we call scsi_build_commandblocks
in scsi_register_device (or wherever we have the corresponding
scsi_build_commandblocks call).

The request queue memory usage is probably a lot higher than what is used
for one Scsi_Cmnd.

-- Patrick Mansfield
