From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] scsi_allocate_request() reference
Date: Mon, 21 Mar 2005 17:57:52 +0100
Message-ID: <20050321165751.GJ25452@suse.de>
References: <20050321132604.GA25452@suse.de> <1111417798.5504.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:29103 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261302AbVCUQ54 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 11:57:56 -0500
Content-Disposition: inline
In-Reply-To: <1111417798.5504.8.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Mar 21 2005, James Bottomley wrote:
> On Mon, 2005-03-21 at 14:26 +0100, Jens Axboe wrote:
> > scsi_allocate_request() doesn't hold a reference to the device that it
> > points to, that is not good. This patch fixes that up.
> 
> Actually, I don't think this is correct.  The reference is taken when
> the command is attached to a request in the scsi_request_fn function
> after first checking that the entity is in a condition to have this
> happen.

Where does this happen, specifically? I can verify that this patch
solves at least one of the oopses I am seeing with hotplug. IMHO, the
reference should be taken when you reference the device (ie ->sr_device
is assigned in scsi_allocate_request()).

> The problem is that the device could have been torn down (surprise
> ejection etc) when some of the routines that call scsi_allocate_request
> run.  What's the actual problem this is trying to solve?

Same problem, SCSI blowing up with a hotplug device. Try with your
pendrive, you should have no problem oopsing the kernel. As mentioned
earlier in this thread, there are unsolvable reference counting problems
between sdev and the request_queue right now.

-- 
Jens Axboe

