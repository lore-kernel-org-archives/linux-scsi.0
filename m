From: Jens Axboe <axboe@suse.de>
Subject: Re: Unaligned scatter-gather buffers and usb-storage
Date: Wed, 19 Nov 2003 09:47:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119084729.GA1106@suse.de>
References: <20031110095914.B22518@beaverton.ibm.com> <Pine.LNX.4.44L0.0311181001030.735-100000@ida.rowland.org> <20031118143720.A6411@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:49574 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261957AbTKSIrh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 03:47:37 -0500
Content-Disposition: inline
In-Reply-To: <20031118143720.A6411@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Tue, Nov 18 2003, Patrick Mansfield wrote:
> On Tue, Nov 18, 2003 at 10:20:17AM -0500, Alan Stern wrote:
> 
> > Alignment to a 512-byte boundary would suffice and page alignment would be
> > more than enough.  The cleanest way to fix the problem would be to have st
> > and sg refuse to do direct I/O when the user's buffer isn't page aligned.  
> > That's probably too draconian (but it would allow us to give the user
> > process an appropriate error code right away).
> 
> The above restriction sounds reasonable to me, but I do not have
> experience in this area. I thought that the raw and direct block
> interfaces already had such restrictions.
> 
> Jens or Doug G can you comment on this?
> 
> You could add a scsi_host fields or bits specifying alignment
> restrictions, and enforce them as needed in upper level drivers.

The queue already has such a restriction embedded, see bio_map_user()
and queue_dma_alignment().

-- 
Jens Axboe

