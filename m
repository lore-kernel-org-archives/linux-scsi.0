From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Tue, 22 Oct 2002 19:30:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021022233005.GD31295@redhat.com>
References: <James.Bottomley@SteelEye.com> <200210221548.g9MFmJx02529@localhost.localdomain> <20021022114354.A3993@eng2.beaverton.ibm.com> <20021022231714.GA4070@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021022231714.GA4070@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Oct 22, 2002 at 04:17:14PM -0700, Mike Anderson wrote:
> Patrick Mansfield [patmans@us.ibm.com] wrote:
> > On Tue, Oct 22, 2002 at 10:48:19AM -0500, James Bottomley wrote:
> > > 
> > > I tracked down the essential problem: the CD rom finish method expects to have 
> > > allocated command blocks to do a mode sense.  I also fixed a trivial 
> > > initialisation problem (the device pointer in Scsi_CD was being used before it 
> > > was initialised).
> > > 
> > > The attached patch fixes the problem for me.
> > > 
> > > I still can't detach and add a CD-ROM, but the panic is in sr_init, so doesn't 
> > > look to be affected by these changes, but I'll continue debugging.
> > > 
> > > James
> > > 
> > 
> > James -
> > 
> > How do we end up with no command blocks if the slave_attach is
> > calling scsi_build_commandblocks via scsi_adjust_queue_depth?
> 
> It appears after looking at this with Patrick that in drivers where
> slave_attach is is not calling scsi_adjust_queue_depth the
> scsi_build_commandblocks will not be called. In my case ips.c and in
> James case 53c700.c.
> 
> If post calling slave_attach the new_queue_depth is 0 and the device is
> not offline we should ensure there is at least a new_queue_depth of
> 1 which is what your patch does by later on calling
> scsi_build_commandblocks directly.

Actually, prior to the scsi_scan changes, the code always made sure that 
it was at least 1 after the scan.  Maybe that got lost somehow...

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
