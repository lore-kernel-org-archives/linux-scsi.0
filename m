From: Jens Axboe <axboe@suse.de>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Mon, 27 Jun 2005 16:27:44 +0200
Message-ID: <20050627142742.GH11633@suse.de>
References: <20050626153941.456543d6.akpm@osdl.org> <1119829031.5038.15.camel@mulgrave> <20050627075255.GK19550@suse.de> <1119882148.5175.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:49622 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261729AbVF0O0h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 10:26:37 -0400
Content-Disposition: inline
In-Reply-To: <1119882148.5175.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, aradford@amcc.com, Nick Orlov <bugfixer@list.ru>

On Mon, Jun 27 2005, James Bottomley wrote:
> On Mon, 2005-06-27 at 09:52 +0200, Jens Axboe wrote:
> > This wont work at all, I'm afraid. You cannot atomically kmap() the
> > buffer for queueing, and unmap it from interrupt context. The type
> > probably isn't correct, and you are not guaranteed to be on the same
> > CPU when doing the unmap. Thus you end up with corrupted maps and
> > preemption counts.
> 
> Actually, it's a lot simpler than that.  We're generating the data for
> the command, so all we do is send an equivalent command to the array (if
> any) and then in the irq routine, kmap_atomic the buffer, copy the array
> data into the buffer in the right order for the command then kunmap the
> buffer again.  This should work fine, I think.

Yup, that would be ok, if that is what you did I misread where the
mapping took place! But you still can't use KM_USER0 in irq context.

-- 
Jens Axboe

