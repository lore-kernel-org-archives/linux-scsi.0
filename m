From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] rationalize allocation and freeing of struct scsi_device
Date: Mon, 18 Nov 2002 19:44:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118194424.A16780@lst.de>
References: <20021117234901.A9784@lst.de> <20021118102410.A19492@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021118102410.A19492@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Nov 18, 2002 at 10:24:10AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Nov 18, 2002 at 10:24:10AM -0800, Patrick Mansfield wrote:
> On Sun, Nov 17, 2002 at 11:49:01PM +0100, Christoph Hellwig wrote:
> > Currently allocation and freeing of struct scsi_device is a mess.
> > We have two nice functions in scsi_scan.c (scsi_allocate_sdev/
> > scsi_free_sdev) that are the right interfaces to deal with it, so I moved
> > them to scsi and made them non-static.  I've changed all functions
> > allocation freeing them to use it.
> 
> What happened to the scsi_release_sdev that was in your previous version
> of the patch?

That will follow in another patch. 

> That was a nice place to call device_unregister(), and would be the right
> place to remove sysfs scsi_device files.

Right.  But I also want to add such a wrapper for the alloc path, too
before submitting it.

