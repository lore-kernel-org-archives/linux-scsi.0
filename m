From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: 05 Feb 2003 09:22:18 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044458540.1807.19.camel@mulgrave>
References: <20030204162326.A30755@lst.de>
	<20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de>
	<20030204091955.A24785@beaverton.ibm.com>
	<1044383605.2014.23.camel@mulgrave> <20030204202935.A325@lst.de>
	<1044399797.3484.15.camel@mulgrave>
	<20030204172505.A28812@beaverton.ibm.com>
	<1044410039.3485.61.camel@mulgrave>
	<20030204211516.A30419@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA07217
	for <linux-scsi@vger.kernel.org>; Wed, 5 Feb 2003 07:22:24 -0800
In-Reply-To: <20030204211516.A30419@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-02-04 at 23:15, Patrick Mansfield wrote:
> OK that sounds great, except we should not plug the queue since we
> have outstanding IO.

Yes, that's true.  The guaranteed returning I/O will restart it.

> > And the slave_{alloc,configure,destroy} needs fixing too.
> 
> What is broken?

This one, I'm not sure.  The patch just drew my attention to the
breakage.  The way I understand the API:

slave_alloc tells the LLD we're going to issue probes to the device
slave_configure tells the LLD we've probed it and we're now going to
configure and use it
slave_destroy tells the LLD we're no longer interested.

The patch removes the slave_configure call from scsi_slave_attach()
which is called by the upper level drivers.  However, it looks like
scsi_add_lun always calls it.

The correct thing, I think, is not to call slave_configure until we're
sure an ULD is attaching (there's no point getting the LLD to allocate
resources to a command queue until we have an attachment).

James


