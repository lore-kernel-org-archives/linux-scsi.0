From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Tue, 22 Oct 2002 11:43:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021022114354.A3993@eng2.beaverton.ibm.com>
References: <James.Bottomley@SteelEye.com> <200210221548.g9MFmJx02529@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200210221548.g9MFmJx02529@localhost.localdomain>; from James.Bottomley@steeleye.com on Tue, Oct 22, 2002 at 10:48:19AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Oct 22, 2002 at 10:48:19AM -0500, James Bottomley wrote:
> 
> I tracked down the essential problem: the CD rom finish method expects to have 
> allocated command blocks to do a mode sense.  I also fixed a trivial 
> initialisation problem (the device pointer in Scsi_CD was being used before it 
> was initialised).
> 
> The attached patch fixes the problem for me.
> 
> I still can't detach and add a CD-ROM, but the panic is in sr_init, so doesn't 
> look to be affected by these changes, but I'll continue debugging.
> 
> James
> 

James -

How do we end up with no command blocks if the slave_attach is
calling scsi_build_commandblocks via scsi_adjust_queue_depth?

-- Patrick Mansfield
