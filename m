From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] always handle REQ_BLOCK_PC requests in common code
Date: Sat, 7 Jan 2006 15:13:25 +0100
Message-ID: <20060107141325.GA9477@lst.de>
References: <20060106173407.GA23658@lst.de> <43BF5F23.2040804@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:12426 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1030456AbWAGONi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jan 2006 09:13:38 -0500
Content-Disposition: inline
In-Reply-To: <43BF5F23.2040804@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Sat, Jan 07, 2006 at 04:26:43PM +1000, Douglas Gilbert wrote:
> Christoph Hellwig wrote:
> > LLDDs should never see REQ_BLOCK_PC requests, we can handle them just
> > fine in the core code.  There is a small behaviour change in that some
> > check in sr's rw_intr are bypassed, but I consider the old behaviour
> > a bug.
> > 
> > Mike found this cleanup ooportunity and provdided early patches, so all
> > the credit goes to him, even if I redid the patches from scratch beause
> > that was easier than forward-porting the old patches.
> 
> The point of the hacks in the sd driver was to make
> sure SG_IO ioctl commands issued via a sd device node
> would not get caught up in the sd driver's error
> processing (e.g. retries on MEDIUM ERRORs). Is there
> a clean path back for such errors to the SG_IO ioctl
> and hence the user space?

Yeah.  scsi_io_completion deals specially with REQ_BLOCK_PC requests,
so we don't do these retries on MEDIUM ERRORs.  sg even before my patch
directly handed off these requests to scsi_io_completion, and didn't do
any own handling of errors for them.  There's zero change in behaviour
for sd and st.  Only sr did some error processesing previously which
was wrong.

